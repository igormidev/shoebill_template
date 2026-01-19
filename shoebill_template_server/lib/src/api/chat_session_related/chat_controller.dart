// ignore_for_file: avoid_print

import 'dart:async';
import 'package:shoebill_template_server/server.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';
import 'package:shoebill_template_server/src/services/daytona_claude_streaming.dart';
import 'package:shoebill_template_server/src/services/pdf_controller.dart';

abstract class IChatController {
  const IChatController();
  bool get isAlreadyProcessingMessage;
  Stream<ChatMessage> sendMessage({
    required String message,
  });
}

class ChatControllerImpl implements IChatController {
  ChatControllerImpl({required this.codding});

  final PdfController pdfController = getIt<PdfController>();
  final DaytonaClaudeCodeService codding;

  @override
  Stream<ChatMessage> sendMessage({
    required String message,
  }) async* {
    isAlreadyProcessingMessage = true;
    final StreamController<ChatMessage> controller =
        StreamController<ChatMessage>();
    yield* controller.stream;

    void onThinking(String thinking) {
      if (isLocal) print('🧠 Thinking: $thinking');
      controller.add(
        ChatMessage(
          role: ChatActor.ai,
          content: thinking,
          style: ChatUIStyle.thinkingChunk,
        ),
      );
    }

    void onToolUse(String toolName, Map<String, dynamic> input) {
      if (isLocal) {
        print('🔧 Using tool: $toolName');
        if (toolName == 'Write') {
          print('   Writing to: ${input['file_path']}');
        }
      }

      controller.add(
        ChatMessage(
          role: ChatActor.ai,
          style: ChatUIStyle.thinkingChunk,
          content: '\nUsing tool: $toolName\n',
        ),
      );
    }

    void onText(String text) {
      if (isLocal) print('💬 $text');
      controller.add(
        ChatMessage(
          role: ChatActor.ai,
          content: text,
          style: ChatUIStyle.normal,
        ),
      );
    }

    final result = await codding.generatePythonScript(
      message,

      // 🧠 Real-time thinking from Claude
      onThinking: onThinking,

      // 🔧 Tool usage (Write, Bash, Read, etc.)
      onToolUse: onToolUse,

      // 💬 Text output
      onText: onText,
    );

    switch (result) {
      case ClaudeCodeSuccess():
        controller.add(
          ChatMessage(
            role: ChatActor.ai,
            style: ChatUIStyle.success,
            content: result.logs,
          ),
        );
        controller.add(
          ChatMessage(
            role: ChatActor.system,
            style: ChatUIStyle.normal,
            content: '''The code generation completed successfully.

I will now test the script that generates the PDF in a sandbox environment to ensure it works.''',
          ),
        );
      case ClaudeCodeSandboxError():
        controller.add(
          ChatMessage(
            role: ChatActor.ai,
            style: ChatUIStyle.error,
            content: result.message,
          ),
        );
        controller.add(
          ChatMessage(
            role: ChatActor.system,
            style: ChatUIStyle.success,
            content:
                '''Seems like a error of status code ${result.statusCode} happened when trying to run the script in a sandbox environment.

Please contact support.''',
          ),
        );
      case ClaudeCodeExecutionError():
        // TODO: Handle this case.
        throw UnimplementedError();
      case ClaudeCodeFileNotFoundError():
        // TODO: Handle this case.
        throw UnimplementedError();
      case ClaudeCodeTimeoutError():
        // TODO: Handle this case.
        throw UnimplementedError();
      case ClaudeCodeNetworkError():
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    await controller.close();
    isAlreadyProcessingMessage = false;
  }

  @override
  bool isAlreadyProcessingMessage = false;
}
