import 'package:shoebill_template_server/src/generated/protocol.dart';

abstract class IRemoteAiCodingSession {
  abstract bool isAlreadyProcessingMessage;
  abstract String? lastWorkingScript;

  Stream<ChatMessage> sendMessage({
    required String message,
  });
}

class DaytonaCodingSession implements IRemoteAiCodingSession {
  @override
  bool isAlreadyProcessingMessage = true;

  @override
  String? lastWorkingScript;

  @override
  Stream<ChatMessage> sendMessage({
    required String message,
  }) {
    throw UnimplementedError();
  }
}
