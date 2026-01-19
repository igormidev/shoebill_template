/// Daytona + Claude Code Integration with Streaming Support
///
/// This library provides real-time streaming of Claude Code's thinking process
/// while generating Python scripts inside a secure Daytona sandbox.
///
/// ## Features:
/// - Real-time streaming of Claude's thinking via `--output-format stream-json`
/// - PTY (Pseudo Terminal) support via WebSocket for live output
/// - Sealed classes for exhaustive error handling
///
/// ## Dependencies (add to pubspec.yaml):
/// ```yaml
/// dependencies:
///   http: ^1.2.0
///   web_socket_channel: ^2.4.0
/// ```
///
/// ## Example with streaming:
/// ```dart
/// final service = DaytonaClaudeCodeService(
///   daytonaApiKey: 'your-daytona-api-key',
///   anthropicApiKey: 'your-anthropic-api-key',
/// );
///
/// final result = await service.generatePythonScript(
///   'Create a CSV parser with validation',
///   onThinking: (thinking) => print('🧠 $thinking'),
///   onToolUse: (tool, input) => print('🔧 Using $tool'),
///   onText: (text) => print('💬 $text'),
/// );
/// ```
library;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

// ============================================================================
// SEALED RESULT CLASSES
// ============================================================================

/// Base sealed class for Claude Code generation results.
sealed class ClaudeCodeResult {
  const ClaudeCodeResult();
}

/// Success result with the generated Python script.
final class ClaudeCodeSuccess extends ClaudeCodeResult {
  /// The generated Python script as plain text.
  final String pythonScript;

  /// Complete execution logs.
  final String logs;

  /// Parsed thinking blocks from the execution.
  final List<String> thinkingBlocks;

  const ClaudeCodeSuccess({
    required this.pythonScript,
    required this.logs,
    this.thinkingBlocks = const [],
  });
}

/// Error during sandbox creation.
final class ClaudeCodeSandboxError extends ClaudeCodeResult {
  final String message;
  final int? statusCode;

  const ClaudeCodeSandboxError(this.message, [this.statusCode]);
}

/// Error during Claude Code execution.
final class ClaudeCodeExecutionError extends ClaudeCodeResult {
  final String message;
  final String? stderr;
  final int? exitCode;

  const ClaudeCodeExecutionError(this.message, {this.stderr, this.exitCode});
}

/// Generated file not found.
final class ClaudeCodeFileNotFoundError extends ClaudeCodeResult {
  final String message;
  final List<String> searchedPaths;

  const ClaudeCodeFileNotFoundError(this.message, this.searchedPaths);
}

/// Operation timed out.
final class ClaudeCodeTimeoutError extends ClaudeCodeResult {
  final Duration timeout;
  final String phase;

  const ClaudeCodeTimeoutError(this.timeout, this.phase);
}

/// Network or connection error.
final class ClaudeCodeNetworkError extends ClaudeCodeResult {
  final String message;
  final Object? originalError;

  const ClaudeCodeNetworkError(this.message, [this.originalError]);
}

// ============================================================================
// STREAM EVENT TYPES
// ============================================================================

/// Represents a parsed event from Claude Code's stream-json output.
sealed class ClaudeStreamEvent {
  const ClaudeStreamEvent();
}

/// Claude is thinking (extended thinking / chain of thought).
final class ThinkingEvent extends ClaudeStreamEvent {
  final String thinking;
  const ThinkingEvent(this.thinking);
}

/// Claude is using a tool (Write, Read, Bash, etc.).
final class ToolUseEvent extends ClaudeStreamEvent {
  final String toolName;
  final Map<String, dynamic> input;
  const ToolUseEvent(this.toolName, this.input);
}

/// Claude generated text output.
final class TextEvent extends ClaudeStreamEvent {
  final String text;
  const TextEvent(this.text);
}

/// Tool execution result.
final class ToolResultEvent extends ClaudeStreamEvent {
  final String toolName;
  final String result;
  const ToolResultEvent(this.toolName, this.result);
}

/// Final result from Claude Code.
final class ResultEvent extends ClaudeStreamEvent {
  final bool success;
  final String? error;
  const ResultEvent(this.success, [this.error]);
}

// ============================================================================
// CALLBACK TYPES
// ============================================================================

/// Callback for Claude's thinking process (chain of thought / extended thinking).
typedef OnThinkingCallback = void Function(String thinking);

/// Callback for tool usage events.
typedef OnToolUseCallback =
    void Function(String toolName, Map<String, dynamic> input);

/// Callback for text output.
typedef OnTextCallback = void Function(String text);

/// Callback for raw stream events (for advanced usage).
typedef OnRawEventCallback = void Function(ClaudeStreamEvent event);

/// Callback for raw PTY output (terminal bytes).
typedef OnRawOutputCallback = void Function(String rawOutput);

// ============================================================================
// MAIN SERVICE CLASS
// ============================================================================

/// Service for generating Python scripts with Claude Code in a Daytona sandbox,
/// with support for real-time streaming of Claude's thinking process.
///
/// ## Streaming Claude's Thinking
///
/// Claude Code supports `--output-format stream-json` which outputs JSON Lines
/// (JSONL) in real-time, including thinking blocks, tool usage, and results.
///
/// ```dart
/// final result = await service.generatePythonScript(
///   'Create a web scraper',
///   onThinking: (thinking) {
///     // Real-time thinking from Claude
///     print('🧠 Thinking: $thinking');
///   },
///   onToolUse: (tool, input) {
///     // Claude is using a tool (Write, Bash, etc.)
///     print('🔧 Tool: $tool');
///   },
///   onText: (text) {
///     // Text output from Claude
///     print('💬 $text');
///   },
/// );
/// ```
///
/// ## How it works
///
/// 1. Creates a Daytona sandbox with PTY (Pseudo Terminal) support
/// 2. Installs Claude Code CLI
/// 3. Runs Claude Code with `--output-format stream-json --verbose`
/// 4. Streams PTY output via WebSocket in real-time
/// 5. Parses JSONL events and invokes callbacks
/// 6. Retrieves the generated Python file
/// 7. Cleans up the sandbox
class DaytonaClaudeCodeService {
  final String daytonaApiKey;
  final String anthropicApiKey;
  final String apiUrl;
  final String target;
  final Duration executionTimeout;
  final http.Client _httpClient;

  DaytonaClaudeCodeService({
    required this.daytonaApiKey,
    required this.anthropicApiKey,
    this.apiUrl = 'https://app.daytona.io/api',
    this.target = 'us',
    this.executionTimeout = const Duration(minutes: 30),
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  /// Generates a Python script with real-time streaming of Claude's thinking.
  ///
  /// [prompt] - Natural language description of the script to generate.
  /// [outputFileName] - Name for the generated file (default: 'generated_script.py').
  /// [onThinking] - Callback for Claude's thinking/reasoning process.
  /// [onToolUse] - Callback when Claude uses a tool (Write, Read, Bash, etc.).
  /// [onText] - Callback for text output from Claude.
  /// [onRawEvent] - Callback for all parsed stream events (advanced).
  /// [onRawOutput] - Callback for raw PTY output (advanced).
  ///
  /// Returns [ClaudeCodeResult] sealed class with the result or error.
  Future<ClaudeCodeResult> generatePythonScript(
    String prompt, {
    String outputFileName = 'generated_script.py',
    OnThinkingCallback? onThinking,
    OnToolUseCallback? onToolUse,
    OnTextCallback? onText,
    OnRawEventCallback? onRawEvent,
    OnRawOutputCallback? onRawOutput,
  }) async {
    String? sandboxId;
    final logs = StringBuffer();
    final thinkingBlocks = <String>[];

    try {
      // Step 1: Create sandbox
      final createResult = await _createSandbox();
      if (createResult.error != null) {
        return ClaudeCodeSandboxError(
          createResult.error!,
          createResult.statusCode,
        );
      }
      sandboxId = createResult.sandboxId!;

      // Step 2: Wait for sandbox to be ready
      final isReady = await _waitForSandboxReady(sandboxId);
      if (!isReady) {
        return const ClaudeCodeSandboxError('Sandbox failed to start');
      }

      // Step 3: Install Claude Code via regular exec (not PTY)
      final installResult = await _executeCommand(
        sandboxId,
        'npm install -g @anthropic-ai/claude-code',
      );
      if (installResult.exitCode != 0) {
        return ClaudeCodeExecutionError(
          'Failed to install Claude Code',
          stderr: installResult.stderr,
          exitCode: installResult.exitCode,
        );
      }

      // Step 4: Run Claude Code with streaming via PTY
      final claudePrompt = _buildPrompt(prompt, outputFileName);
      final ptyResult = await _runClaudeCodeWithPty(
        sandboxId,
        claudePrompt,
        onData: (data) {
          logs.write(data);
          onRawOutput?.call(data);

          // Parse JSONL stream
          _parseStreamJsonLine(
            data,
            onThinking: (thinking) {
              thinkingBlocks.add(thinking);
              onThinking?.call(thinking);
            },
            onToolUse: onToolUse,
            onText: onText,
            onRawEvent: onRawEvent,
          );
        },
      );

      if (!ptyResult.success) {
        return ClaudeCodeExecutionError(
          'Claude Code execution failed',
          stderr: ptyResult.error,
          exitCode: ptyResult.exitCode,
        );
      }

      // Step 5: Retrieve the generated file
      final searchPaths = [
        outputFileName,
        '/home/daytona/$outputFileName',
        '/workspace/$outputFileName',
        './$outputFileName',
      ];

      for (final path in searchPaths) {
        final content = await _downloadFile(sandboxId, path);
        if (content != null && content.trim().isNotEmpty) {
          return ClaudeCodeSuccess(
            pythonScript: content,
            logs: logs.toString(),
            thinkingBlocks: thinkingBlocks,
          );
        }
      }

      // Try finding any .py file
      final findResult = await _executeCommand(
        sandboxId,
        'find . -name "*.py" -type f 2>/dev/null | head -5',
      );
      if (findResult.exitCode == 0 && findResult.stdout?.isNotEmpty == true) {
        for (final file
            in findResult.stdout!
                .split('\n')
                .where((f) => f.trim().isNotEmpty)) {
          final content = await _downloadFile(sandboxId, file.trim());
          if (content != null && content.trim().isNotEmpty) {
            return ClaudeCodeSuccess(
              pythonScript: content,
              logs: logs.toString(),
              thinkingBlocks: thinkingBlocks,
            );
          }
        }
      }

      return ClaudeCodeFileNotFoundError(
        'Generated Python script not found',
        searchPaths,
      );
    } on TimeoutException catch (e) {
      return ClaudeCodeTimeoutError(executionTimeout, e.message ?? 'unknown');
    } on http.ClientException catch (e) {
      return ClaudeCodeNetworkError('HTTP error: ${e.message}', e);
    } catch (e) {
      return ClaudeCodeNetworkError('Unexpected error: $e', e);
    } finally {
      if (sandboxId != null) {
        await _deleteSandbox(sandboxId);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // PTY Streaming Implementation
  // ---------------------------------------------------------------------------

  Future<_PtyResult> _runClaudeCodeWithPty(
    String sandboxId,
    String prompt, {
    required void Function(String data) onData,
  }) async {
    try {
      // Create PTY session
      final createPtyResponse = await _httpClient.post(
        Uri.parse('$apiUrl/sandboxes/$sandboxId/process/pty'),
        headers: _headers,
        body: jsonEncode({
          'id': 'claude-code-${DateTime.now().millisecondsSinceEpoch}',
          'cols': 120,
          'rows': 40,
        }),
      );

      if (createPtyResponse.statusCode != 200 &&
          createPtyResponse.statusCode != 201) {
        // Fallback to non-PTY execution
        return _runClaudeCodeFallback(sandboxId, prompt, onData);
      }

      final ptyData =
          jsonDecode(createPtyResponse.body) as Map<String, dynamic>;
      final sessionId = ptyData['id'] as String?;
      final wsUrl = ptyData['wsUrl'] as String?;

      if (sessionId == null || wsUrl == null) {
        return _runClaudeCodeFallback(sandboxId, prompt, onData);
      }

      // Connect to PTY via WebSocket
      final channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
        protocols: ['Authorization', 'Bearer $daytonaApiKey'],
      );

      final completer = Completer<_PtyResult>();
      final outputBuffer = StringBuffer();
      var exitCode = 0;

      // Listen to WebSocket stream
      channel.stream.listen(
        (dynamic data) {
          String text;
          if (data is List<int>) {
            text = utf8.decode(data, allowMalformed: true);
          } else {
            text = data.toString();
          }
          outputBuffer.write(text);
          onData(text);
        },
        onError: (error) {
          if (!completer.isCompleted) {
            completer.complete(
              _PtyResult(
                success: false,
                error: error.toString(),
                exitCode: -1,
              ),
            );
          }
        },
        onDone: () {
          if (!completer.isCompleted) {
            completer.complete(
              _PtyResult(
                success: true,
                output: outputBuffer.toString(),
                exitCode: exitCode,
              ),
            );
          }
        },
      );

      // Wait for connection
      await Future.delayed(const Duration(milliseconds: 500));

      // Build and send the Claude Code command
      final escapedPrompt = prompt
          .replaceAll('\\', '\\\\')
          .replaceAll("'", "'\\''")
          .replaceAll('\$', '\\\$');

      final command =
          '''
export ANTHROPIC_API_KEY=$anthropicApiKey
claude --dangerously-skip-permissions -p '$escapedPrompt' --output-format stream-json --verbose
exit
''';

      channel.sink.add(utf8.encode(command));

      // Wait for completion with timeout
      final result = await completer.future.timeout(
        executionTimeout,
        onTimeout: () {
          channel.sink.close();
          return _PtyResult(
            success: false,
            error: 'Execution timed out',
            exitCode: -1,
          );
        },
      );

      await channel.sink.close();
      return result;
    } catch (e) {
      // Fallback if PTY fails
      return _runClaudeCodeFallback(sandboxId, prompt, onData);
    }
  }

  Future<_PtyResult> _runClaudeCodeFallback(
    String sandboxId,
    String prompt,
    void Function(String data) onData,
  ) async {
    final escapedPrompt = prompt
        .replaceAll('\\', '\\\\')
        .replaceAll("'", "'\\''")
        .replaceAll('\$', '\\\$');

    final command =
        "ANTHROPIC_API_KEY=$anthropicApiKey claude --dangerously-skip-permissions -p '$escapedPrompt' --output-format stream-json --verbose";

    final result = await _executeCommand(sandboxId, command);

    // Emit the output through callback
    if (result.stdout != null) {
      onData(result.stdout!);
    }
    if (result.stderr != null) {
      onData(result.stderr!);
    }

    return _PtyResult(
      success: result.exitCode == 0,
      output: result.stdout,
      error: result.stderr,
      exitCode: result.exitCode,
    );
  }

  // ---------------------------------------------------------------------------
  // Stream JSON Parser
  // ---------------------------------------------------------------------------

  /// Line buffer for parsing JSONL (handles partial lines)
  final _lineBuffer = StringBuffer();

  void _parseStreamJsonLine(
    String data, {
    OnThinkingCallback? onThinking,
    OnToolUseCallback? onToolUse,
    OnTextCallback? onText,
    OnRawEventCallback? onRawEvent,
  }) {
    _lineBuffer.write(data);
    final content = _lineBuffer.toString();
    final lines = content.split('\n');

    // Keep the last potentially incomplete line in buffer
    _lineBuffer.clear();
    if (!content.endsWith('\n') && lines.isNotEmpty) {
      _lineBuffer.write(lines.removeLast());
    }

    for (final line in lines) {
      if (line.trim().isEmpty) continue;

      try {
        final json = jsonDecode(line) as Map<String, dynamic>;
        final event = _parseJsonEvent(json);

        if (event != null) {
          onRawEvent?.call(event);

          switch (event) {
            case ThinkingEvent(:final thinking):
              onThinking?.call(thinking);
            case ToolUseEvent(:final toolName, :final input):
              onToolUse?.call(toolName, input);
            case TextEvent(:final text):
              onText?.call(text);
            case ToolResultEvent():
            case ResultEvent():
              // These are handled internally
              break;
          }
        }
      } catch (_) {
        // Not valid JSON, might be regular terminal output
        // Try to extract any visible text
        if (line.trim().isNotEmpty && !line.startsWith('{')) {
          onText?.call(line);
        }
      }
    }
  }

  ClaudeStreamEvent? _parseJsonEvent(Map<String, dynamic> json) {
    final type = json['type'] as String?;

    switch (type) {
      case 'assistant':
        // Check for thinking in content blocks
        final message = json['message'] as Map<String, dynamic>?;
        final content = message?['content'] as List?;
        if (content != null) {
          for (final block in content) {
            if (block is Map<String, dynamic>) {
              final blockType = block['type'] as String?;
              if (blockType == 'thinking') {
                final thinking = block['thinking'] as String?;
                if (thinking != null) {
                  return ThinkingEvent(thinking);
                }
              } else if (blockType == 'text') {
                final text = block['text'] as String?;
                if (text != null) {
                  return TextEvent(text);
                }
              } else if (blockType == 'tool_use') {
                final name = block['name'] as String? ?? 'unknown';
                final input = block['input'] as Map<String, dynamic>? ?? {};
                return ToolUseEvent(name, input);
              }
            }
          }
        }
        return null;

      case 'content_block_delta':
        final delta = json['delta'] as Map<String, dynamic>?;
        final deltaType = delta?['type'] as String?;
        if (deltaType == 'thinking_delta') {
          final thinking = delta?['thinking'] as String?;
          if (thinking != null) {
            return ThinkingEvent(thinking);
          }
        } else if (deltaType == 'text_delta') {
          final text = delta?['text'] as String?;
          if (text != null) {
            return TextEvent(text);
          }
        }
        return null;

      case 'tool_use':
        final name = json['name'] as String? ?? 'unknown';
        final input = json['input'] as Map<String, dynamic>? ?? {};
        return ToolUseEvent(name, input);

      case 'tool_result':
        final name = json['tool_name'] as String? ?? 'unknown';
        final result = json['result']?.toString() ?? '';
        return ToolResultEvent(name, result);

      case 'result':
        final success = json['is_error'] != true;
        final error = json['error'] as String?;
        return ResultEvent(success, error);

      default:
        return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Sandbox Management (same as before)
  // ---------------------------------------------------------------------------

  Future<_SandboxCreateResult> _createSandbox() async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse('$apiUrl/sandboxes'),
            headers: _headers,
            body: jsonEncode({
              'image': 'daytonaio/ai-starter:latest',
              'envVars': {'ANTHROPIC_API_KEY': anthropicApiKey},
              'autoStopInterval': 30,
              'autoArchiveInterval': 60,
              'autoDeleteInterval': 120,
              'target': target,
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _SandboxCreateResult(sandboxId: data['id'] as String);
      }
      return _SandboxCreateResult(
        error: 'HTTP ${response.statusCode}: ${response.body}',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return _SandboxCreateResult(error: e.toString());
    }
  }

  Future<bool> _waitForSandboxReady(String sandboxId) async {
    for (var i = 0; i < 60; i++) {
      try {
        final response = await _httpClient.get(
          Uri.parse('$apiUrl/sandboxes/$sandboxId'),
          headers: _headers,
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final state = data['state'] as String?;
          if (state == 'running' || state == 'started') return true;
          if (state == 'error' || state == 'failed') return false;
        }
      } catch (_) {}
      await Future.delayed(const Duration(seconds: 2));
    }
    return false;
  }

  Future<void> _deleteSandbox(String sandboxId) async {
    try {
      await _httpClient
          .delete(
            Uri.parse('$apiUrl/sandboxes/$sandboxId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));
    } catch (_) {}
  }

  Future<_CommandResult> _executeCommand(
    String sandboxId,
    String command,
  ) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse('$apiUrl/sandboxes/$sandboxId/process/exec'),
            headers: _headers,
            body: jsonEncode({'command': command, 'timeout': 600}),
          )
          .timeout(const Duration(minutes: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _CommandResult(
          exitCode: data['exitCode'] as int? ?? -1,
          stdout: data['stdout'] as String?,
          stderr: data['stderr'] as String?,
        );
      }
      return _CommandResult(
        exitCode: -1,
        stderr: 'HTTP ${response.statusCode}',
      );
    } catch (e) {
      return _CommandResult(exitCode: -1, stderr: e.toString());
    }
  }

  Future<String?> _downloadFile(String sandboxId, String path) async {
    try {
      final uri = Uri.parse(
        '$apiUrl/sandboxes/$sandboxId/files/download',
      ).replace(queryParameters: {'path': path});
      final response = await _httpClient
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) return response.body;
    } catch (_) {}
    return null;
  }

  String _buildPrompt(String userPrompt, String outputFile) =>
      '''
Create a production-ready Python script and save it as "$outputFile".

Requirements:
$userPrompt

Instructions:
- Complete, working Python script
- Proper error handling with try/except
- Clear docstrings and comments  
- All necessary imports at the top
- main() function with if __name__ == "__main__" guard
- PEP 8 compliant

Save the file as "$outputFile" in the current directory, then verify with: ls -la $outputFile

It is mandatory that the script runs without errors. So you should execute it.
If there is any import errors, since you have access to the internet, you can install packages needed in order to make the script run.
Also - is is ULTRA MANDATORY that you mantain all script in only 1 single file - DO NOT CREATE MULTIPLE FILES TO SPLIT THE LOGIC, mantain it in a single file.
''';

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $daytonaApiKey',
    'Content-Type': 'application/json',
  };

  void dispose() => _httpClient.close();
}

// ---------------------------------------------------------------------------
// Internal Types
// ---------------------------------------------------------------------------

class _SandboxCreateResult {
  final String? sandboxId;
  final String? error;
  final int? statusCode;
  _SandboxCreateResult({this.sandboxId, this.error, this.statusCode});
}

class _CommandResult {
  final int exitCode;
  final String? stdout;
  final String? stderr;
  _CommandResult({required this.exitCode, this.stdout, this.stderr});
}

class _PtyResult {
  final bool success;
  final String? output;
  final String? error;
  final int exitCode;
  _PtyResult({
    required this.success,
    this.output,
    this.error,
    this.exitCode = 0,
  });
}

class TimeoutException implements Exception {
  final String? message;
  final Duration? duration;
  TimeoutException(this.message, [this.duration]);
  @override
  String toString() => 'TimeoutException: $message';
}
