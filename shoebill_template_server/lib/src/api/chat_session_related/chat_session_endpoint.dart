import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/api/chat_session_related/chat_controller.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';
import 'package:shoebill_template_server/src/services/daytona_claude_streaming.dart';

typedef SessionUUID = String;
typedef TimesRefreshed = int;
const int kMaxSessionRefreshes = 30;

final Map<SessionUUID, IChatController> _activeSessions = {};
final Map<SessionUUID, TemplateCurrentState> _sessionTemplateInfo = {};
final Map<SessionUUID, bool> _isNewTemplate = {};
final Map<SessionUUID, Timer> _sessionCleanupTimers = {};
final Map<SessionUUID, int> _sessionRefresh = {};

class ChatSessionEndpoint extends Endpoint {
  final Uuid uuidClass = Uuid();

  ChatControllerImpl get newChat => ChatControllerImpl(
    codding: DaytonaClaudeCodeService(
      daytonaApiKey: '',
      anthropicApiKey: '',
    ),
  );

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

  Future<void> deploySession(
    Session session, {
    required SessionUUID sessionUUID,
  }) async {}

  Future<SessionUUID> startChatFromNewTemplate(
    Session session, {
    required NewTemplateState newTemplateState,
  }) async {
    final uuid = uuidClass.v7();
    _sessionTemplateInfo[uuid] = newTemplateState;
    _isNewTemplate[uuid] = true;
    _activeSessions[uuid] = newChat;
    refreshSession(uuid);
    return uuid;
  }

  Future<SessionUUID> startChatFromExistingTemplate(
    Session session, {
    required UuidValue pdfDeclarationUuid,
  }) async {
    final pdfDeclaration = await PdfDeclaration.db.findById(
      session,
      pdfDeclarationUuid,
      include: PdfDeclaration.include(
        schema: SchemaDefinition.include(),
        referencePdfContent: PdfContent.include(),
      ),
    );

    if (pdfDeclaration == null) {
      throw ShoebillException(
        title: 'Template not found',
        description: 'The specified PDF template does not exist.',
      );
    }

    if (pdfDeclaration.schema == null ||
        pdfDeclaration.referencePdfContent == null) {
      throw ShoebillException(
        title: 'Incomplete template',
        description: 'The template is missing required schema or content data.',
      );
    }

    final PdfImplementationPayload? pdfImplementation =
        await PdfImplementationPayload.db.findFirstRow(
          session,
          where: (pI) =>
              pI.pdfDeclarationId.equals(pdfDeclaration.id) &
              pI.language.equals(pdfDeclaration.referenceLanguage),
        );

    if (pdfImplementation == null) {
      throw ShoebillException(
        title: 'Implementation not found',
        description:
            'No PDF implementation found for the template in the reference language.',
      );
    }

    final templateEssential = DeployReadyTemplateState(
      pdfContent: pdfDeclaration.referencePdfContent!,
      schemaDefinition: pdfDeclaration.schema!,
      pythonGeneratorScript: pdfDeclaration.pythonGeneratorScript,
      referenceLanguage: pdfDeclaration.referenceLanguage,
      referenceStringifiedPayloadJson: pdfImplementation.stringifiedJson,
    );

    final uuid = uuidClass.v7();
    _sessionTemplateInfo[uuid] = templateEssential;
    _isNewTemplate[uuid] = false;
    _activeSessions[uuid] = newChat;
    refreshSession(uuid);
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
