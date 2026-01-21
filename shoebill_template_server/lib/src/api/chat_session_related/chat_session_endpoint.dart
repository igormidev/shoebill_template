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
      _isNewTemplate.remove(sessionUuid);
      _sessionTemplateInfo.remove(sessionUuid);
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
        _isNewTemplate.remove(sessionUuid);
        _sessionTemplateInfo.remove(sessionUuid);
        _sessionCleanupTimers.remove(sessionUuid);
      },
    );
  }

  Future<UuidValue> deploySession(
    Session session, {
    required SessionUUID sessionUUID,
  }) async {
    final templateState = _sessionTemplateInfo[sessionUUID];

    if (templateState == null) {
      throw ShoebillException(
        title: 'Session not found',
        description: 'No template session found for UUID: $sessionUUID',
      );
    }

    if (templateState is! DeployReadyTemplateState) {
      throw ShoebillException(
        title: 'Template not ready',
        description:
            'The template is not ready for deployment. Ensure the Python generator script has been created.',
      );
    }

    final isNew = _isNewTemplate[sessionUUID] ?? true;

    if (isNew) {
      return _deployNewTemplate(session, templateState: templateState);
    } else {
      return _updateExistingTemplate(session, templateState: templateState);
    }
  }

  Future<UuidValue> _deployNewTemplate(
    Session session, {
    required DeployReadyTemplateState templateState,
  }) async {
    var schemaDefinition = templateState.schemaDefinition;
    var pdfContent = templateState.pdfContent;

    return session.db.transaction((tx) async {
      // Insert SchemaDefinition if it doesn't have an ID
      if (schemaDefinition.id == null) {
        schemaDefinition = await SchemaDefinition.db.insertRow(
          session,
          schemaDefinition,
          transaction: tx,
        );
      }

      // Insert PdfContent if it doesn't have an ID
      if (pdfContent.id == null) {
        pdfContent = await PdfContent.db.insertRow(
          session,
          pdfContent,
          transaction: tx,
        );
      }

      // Create the PdfDeclaration
      final pdfDeclaration = await PdfDeclaration.db.insertRow(
        session,
        PdfDeclaration(
          schemaId: schemaDefinition.id!,
          referencePdfContentId: pdfContent.id!,
          referencePdfContent: pdfContent,
          schema: schemaDefinition,
          pythonGeneratorScript: templateState.pythonGeneratorScript,
          referenceLanguage: templateState.referenceLanguage,
        ),
        transaction: tx,
      );

      // Create the PdfImplementationPayload
      final implementation = await PdfImplementationPayload.db.insertRow(
        session,
        PdfImplementationPayload(
          stringifiedJson: templateState.referenceStringifiedPayloadJson,
          pdfDeclarationId: pdfDeclaration.id,
          language: templateState.referenceLanguage,
        ),
        transaction: tx,
      );

      // Attach the implementation to the declaration
      await PdfDeclaration.db.attachRow.pdfImplementationsPayloads(
        session,
        pdfDeclaration,
        implementation,
        transaction: tx,
      );

      return pdfDeclaration.id;
    });
  }

  Future<UuidValue> _updateExistingTemplate(
    Session session, {
    required DeployReadyTemplateState templateState,
  }) async {
    // For existing templates, pdfContent should have an ID
    final pdfContentId = templateState.pdfContent.id;
    if (pdfContentId == null) {
      throw ShoebillException(
        title: 'Invalid template state',
        description: 'Existing template state is missing PDF content ID.',
      );
    }

    // Find the existing PdfDeclaration by pdfContent
    final existingDeclaration = await PdfDeclaration.db.findFirstRow(
      session,
      where: (t) => t.referencePdfContentId.equals(pdfContentId),
    );

    if (existingDeclaration == null) {
      throw ShoebillException(
        title: 'Declaration not found',
        description:
            'No existing PDF declaration found for the given template.',
      );
    }

    return session.db.transaction((tx) async {
      // Update the python generator script
      await PdfDeclaration.db.updateRow(
        session,
        existingDeclaration.copyWith(
          pythonGeneratorScript: templateState.pythonGeneratorScript,
        ),
        columns: (t) => [t.pythonGeneratorScript],
        transaction: tx,
      );

      // Update or create the implementation payload for the reference language
      final existingImplementation = await PdfImplementationPayload.db
          .findFirstRow(
            session,
            where: (t) =>
                t.pdfDeclarationId.equals(existingDeclaration.id) &
                t.language.equals(templateState.referenceLanguage),
            transaction: tx,
          );

      if (existingImplementation != null) {
        // Update existing implementation
        await PdfImplementationPayload.db.updateRow(
          session,
          existingImplementation.copyWith(
            stringifiedJson: templateState.referenceStringifiedPayloadJson,
          ),
          columns: (t) => [t.stringifiedJson],
          transaction: tx,
        );
      } else {
        // Create new implementation for this language
        final newImplementation = await PdfImplementationPayload.db.insertRow(
          session,
          PdfImplementationPayload(
            stringifiedJson: templateState.referenceStringifiedPayloadJson,
            pdfDeclarationId: existingDeclaration.id,
            language: templateState.referenceLanguage,
          ),
          transaction: tx,
        );

        await PdfDeclaration.db.attachRow.pdfImplementationsPayloads(
          session,
          existingDeclaration,
          newImplementation,
          transaction: tx,
        );
      }

      return existingDeclaration.id;
    });
  }

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

    await for (final msg in currentSession.sendMessage(
      message: message,
    )) {
      yield msg;
      switch (msg) {}
    }
  }
}
