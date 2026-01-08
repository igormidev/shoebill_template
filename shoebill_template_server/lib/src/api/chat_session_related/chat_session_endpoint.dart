import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/api/chat_session_related/remote_ai_coding_session.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';

typedef SessionUUID = String;

final Map<SessionUUID, IRemoteAiCodingSession> _activeSessions = {};

class ChatSessionEndpoint extends Endpoint {
  final Uuid uuidClass = Uuid();

  Future<SessionUUID> startChat() async {
    final uuid = uuidClass.v7();
    _activeSessions[uuid] = DaytonaCodingSession();
    return uuid;
  }

  Stream<ChatMessage> sendMessage(
    Session session, {
    required SessionUUID sessionUUID,
    required String message,
  }) async* {
    yield ChatMessage(
      role: ChatActor.user,
      content: message,
      style: ChatUIStyle.normal,
    );

    final IRemoteAiCodingSession? currentSession = _activeSessions[sessionUUID];

    if (currentSession == null) {
      yield ChatMessage(
        role: ChatActor.system,
        content: "No session finded...",
        style: ChatUIStyle.error,
      );
      return;
    }

    if (currentSession.isAlreadyProcessingMessage) {
      yield ChatMessage(
        role: ChatActor.system,
        content: "Still processing previous message",
        style: ChatUIStyle.error,
      );
      return;
    }

    yield* currentSession.sendMessage(
      message: message,
    );
  }
}
