import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/api/chat_session_related/chat_controller.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';
import 'package:shoebill_template_server/src/services/daytona_claude_streaming.dart';

typedef SessionUUID = String;
typedef TimesRefreshed = int;
const int kMaxSessionRefreshes = 30;

final Map<SessionUUID, IChatController> _activeSessions = {};
final Map<SessionUUID, Timer> _sessionCleanupTimers = {};
final Map<SessionUUID, int> _sessionRefresh = {};

class ChatSessionEndpoint extends Endpoint {
  final Uuid uuidClass = Uuid();

  void refreshSession(SessionUUID sessionUuid) {
    final currentRefreshes = _sessionRefresh[sessionUuid] ?? 0;
    if (currentRefreshes >= kMaxSessionRefreshes) {
      _activeSessions.remove(sessionUuid);
      _sessionCleanupTimers[sessionUuid]?.cancel();
      _sessionCleanupTimers.remove(sessionUuid);
      _sessionRefresh.remove(sessionUuid);
      return;
    }
    _sessionRefresh[sessionUuid] = currentRefreshes + 1;
    _sessionCleanupTimers[sessionUuid]?.cancel();
    _sessionCleanupTimers[sessionUuid] = Timer(
      Duration(minutes: 30),
      () {
        _activeSessions.remove(sessionUuid);
        _sessionRefresh.remove(sessionUuid);
        _sessionCleanupTimers.remove(sessionUuid);
      },
    );
  }

  Future<SessionUUID> startChat() async {
    final uuid = uuidClass.v7();
    _activeSessions[uuid] = ChatControllerImpl(
      codding: DaytonaClaudeCodeService(
        daytonaApiKey: '',
        anthropicApiKey: '',
      ),
    );
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

    final IChatController? currentSession = _activeSessions[sessionUUID];

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
    refreshSession(sessionUUID);

    yield* currentSession.sendMessage(
      message: message,
    );
  }
}
