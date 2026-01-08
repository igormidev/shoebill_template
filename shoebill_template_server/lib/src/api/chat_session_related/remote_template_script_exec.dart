import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Result of a PDF run.
class PdfRunResult {
  final Uint8List pdfBytes;
  final String rawStdout;
  final String rawStderr;

  PdfRunResult({
    required this.pdfBytes,
    required this.rawStdout,
    required this.rawStderr,
  });
}

/// Contract for “run Python -> get PDF bytes”.
abstract class PdfSandboxRunner {
  /// Stream of logs (build logs + runtime logs).
  Stream<String> get logs;

  /// Runs user-provided Python code in an isolated sandbox and returns PDF bytes.
  ///
  /// Convention:
  /// - Your pythonScript can either:
  ///   (A) set a global variable `PDF_BYTES` (bytes), OR
  ///   (B) write a file named `output.pdf` in the current directory.
  ///
  /// You can access the provided input map via `INPUT` dict in the Python code.
  Future<PdfRunResult> renderPdf({
    required String pythonScript,
    Map<String, dynamic> input,
    List<String> pipPackages,
    String pythonVersion,
    Duration timeout,
  });

  Future<void> close();
}

class DaytonaPdfSandboxRunner implements PdfSandboxRunner {
  DaytonaPdfSandboxRunner({
    String pythonExecutable = 'python3',
    Map<String, String>? extraEnv,
  }) : _pythonExecutable = pythonExecutable,
       _extraEnv = extraEnv ?? const {};

  final String _pythonExecutable;
  final Map<String, String> _extraEnv;

  final _logController = StreamController<String>.broadcast();

  @override
  Stream<String> get logs => _logController.stream;

  @override
  Future<PdfRunResult> renderPdf({
    required String pythonScript,
    Map<String, dynamic> input = const {},
    List<String> pipPackages = const ['reportlab'],
    String pythonVersion = '3.12',
    Duration timeout = const Duration(minutes: 3),
  }) async {
    final payload = <String, dynamic>{
      'python_b64': base64Encode(utf8.encode(pythonScript)),
      'input_json_b64': base64Encode(utf8.encode(jsonEncode(input))),
      'pip_packages': pipPackages,
      'python_version': pythonVersion,
    };

    final proc = await Process.start(
      _pythonExecutable,
      ['-u', '-c', _pythonHelper],
      environment: {
        ...Platform.environment,
        ..._extraEnv,
      },
      runInShell: false,
    );

    // Collect + stream stderr (Daytona snapshot build logs go here).
    final stderrLines = <String>[];
    final stderrSub = proc.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
          stderrLines.add(line);
          _logController.add(line);
        });

    // Collect stdout (this includes the PDF base64 markers).
    final stdoutBuffer = StringBuffer();
    final stdoutSub = proc.stdout
        .transform(utf8.decoder)
        .listen((chunk) => stdoutBuffer.write(chunk));

    // Write request payload to helper stdin.
    proc.stdin.writeln(jsonEncode(payload));
    await proc.stdin.flush();
    await proc.stdin.close();

    int exitCode;
    try {
      exitCode = await proc.exitCode.timeout(timeout);
    } on TimeoutException {
      proc.kill(ProcessSignal.sigkill);
      await stderrSub.cancel();
      await stdoutSub.cancel();
      throw DaytonaPdfRunnerException(
        'Timeout waiting for Python helper.',
        rawStderr: stderrLines.join('\n'),
        rawStdout: stdoutBuffer.toString(),
      );
    }

    await stderrSub.cancel();
    await stdoutSub.cancel();

    final rawStdout = stdoutBuffer.toString();
    final rawStderr = stderrLines.join('\n');

    if (exitCode != 0) {
      throw DaytonaPdfRunnerException(
        'Python helper failed with exitCode=$exitCode.',
        rawStderr: rawStderr,
        rawStdout: rawStdout,
      );
    }

    final pdfB64 = _extractBetween(
      rawStdout,
      '===PDF_B64_BEGIN===',
      '===PDF_B64_END===',
    );
    if (pdfB64 == null || pdfB64.trim().isEmpty) {
      throw DaytonaPdfRunnerException(
        'No PDF markers found in output.',
        rawStderr: rawStderr,
        rawStdout: rawStdout,
      );
    }

    final pdfBytes = base64Decode(pdfB64.trim());
    return PdfRunResult(
      pdfBytes: pdfBytes,
      rawStdout: rawStdout,
      rawStderr: rawStderr,
    );
  }

  @override
  Future<void> close() async {
    await _logController.close();
  }

  String? _extractBetween(String text, String start, String end) {
    final startIdx = text.indexOf(start);
    if (startIdx < 0) return null;
    final from = startIdx + start.length;
    final endIdx = text.indexOf(end, from);
    if (endIdx < 0) return null;
    return text.substring(from, endIdx);
  }
}

class DaytonaPdfRunnerException implements Exception {
  final String message;
  final String rawStdout;
  final String rawStderr;

  DaytonaPdfRunnerException(
    this.message, {
    required this.rawStdout,
    required this.rawStderr,
  });

  @override
  String toString() =>
      '$message\n--- stderr ---\n$rawStderr\n--- stdout ---\n$rawStdout';
}

/// Python helper (runs locally) -> uses Daytona Python SDK -> runs code in sandbox -> prints PDF base64.
const String _pythonHelper = r'''
import sys, json, base64, traceback

from daytona import Daytona, CreateSandboxFromImageParams, Image

def eprint(*a, **k):
    print(*a, file=sys.stderr, **k)

payload_raw = sys.stdin.read().strip()
payload = json.loads(payload_raw or "{}")

script_b64 = payload["python_b64"]
input_b64 = payload.get("input_json_b64", "")
pip_packages = payload.get("pip_packages") or ["reportlab"]
python_version = payload.get("python_version") or "3.12"

# Build an image that has your PDF dependency installed.
# (Declarative builder example in docs uses Image.debian_slim(...).pip_install([...]).workdir(...))
image = (
    Image.debian_slim(python_version)
    .pip_install(pip_packages)
    .workdir("/home/daytona")
)

daytona = Daytona()
sandbox = None

try:
    # Create sandbox from image and stream snapshot build logs to stderr
    sandbox = daytona.create(
        CreateSandboxFromImageParams(image=image),
        timeout=0,
        on_snapshot_create_logs=lambda chunk: eprint(chunk, end="")
    )

    # Run the user code safely via code_run.
    # Convention:
    # - user code can set PDF_BYTES OR write output.pdf
    code = f"""
import base64, json

INPUT = json.loads(base64.b64decode('{input_b64}').decode('utf-8')) if '{input_b64}' else {{}}
USER_CODE = base64.b64decode('{script_b64}').decode('utf-8')

g = globals()
exec(USER_CODE, g)

_pdf = g.get('PDF_BYTES', None)
if _pdf is None:
    with open('output.pdf', 'rb') as f:
        _pdf = f.read()

print('===PDF_B64_BEGIN===')
print(base64.b64encode(_pdf).decode('ascii'))
print('===PDF_B64_END===')
"""

    resp = sandbox.process.code_run(code)

    # Print sandbox stdout to our stdout (Dart will parse markers).
    sys.stdout.write(getattr(resp, "result", "") or "")

    exit_code = getattr(resp, "exit_code", 0) or 0
    if exit_code != 0:
        sys.exit(exit_code)

except Exception:
    traceback.print_exc(file=sys.stderr)
    sys.exit(1)
finally:
    if sandbox is not None:
        try:
            sandbox.delete()
        except Exception:
            pass
''';
