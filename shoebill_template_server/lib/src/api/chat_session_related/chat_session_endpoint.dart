import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/api/chat_session_related/chat_controller.dart';
import 'package:shoebill_template_server/src/api/pdf_related/entities/schema_property_extensions.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/core/utils/consts.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';
import 'package:shoebill_template_server/src/services/ai_services.dart';
import 'package:shoebill_template_server/src/services/daytona_claude_code_service.dart';
import 'package:shoebill_template_server/src/services/pdf_controller.dart';
import 'package:shoebill_template_server/src/services/template_reviewer_service.dart';

typedef SessionUUID = String;

/// Encapsulates all mutable state associated with a single chat session.
class SessionData {
  /// The chat controller handling AI interactions for this session.
  IChatController controller;

  /// Current template state (NewTemplateState or DeployReadyTemplateState).
  TemplateCurrentState templateState;

  /// For existing templates: the scaffold UUID that the version belongs to.
  UuidValue? scaffoldId;

  /// For existing templates: the version ID being edited (for UI-only updates).
  int? existingVersionId;

  /// Whether this session is for a brand new template (true) or editing an existing one (false).
  bool isNewTemplate;

  /// Tracks whether the schema was modified during the session.
  /// When true, deploying creates a new ShoebillTemplateVersion instead of updating in place.
  bool schemaChanged;

  /// Stores the Daytona Claude Code session ID for resume capability.
  /// This allows stopping/deleting the sandbox to save costs, then resuming later.
  String? daytonaSessionId;

  /// Timer that auto-cleans up this session after inactivity.
  Timer? cleanupTimer;

  /// How many times this session has been refreshed (bounded by kMaxSessionRefreshes).
  int refreshCount;

  SessionData({
    required this.controller,
    required this.templateState,
    this.scaffoldId,
    this.existingVersionId,
    required this.isNewTemplate,
    this.schemaChanged = false,
    this.daytonaSessionId,
    this.cleanupTimer,
    this.refreshCount = 0,
  });
}

/// All active chat sessions, keyed by session UUID.
final Map<SessionUUID, SessionData> _sessions = {};

class ChatSessionEndpoint extends Endpoint {
  final Uuid _uuidGenerator = Uuid();

  IPdfController get _pdfController => GetIt.instance<IPdfController>();

  ChatControllerImpl get newChat => ChatControllerImpl(
    daytonaService: DaytonaClaudeCodeService(
      daytonaApiKey: const String.fromEnvironment('DAYTONA_API_KEY'),
      anthropicApiKey: const String.fromEnvironment('ANTHROPIC_API_KEY'),
    ),
    reviewerService: TemplateReviewerService(
      openAiService: GetIt.instance<IOpenAiService>(),
    ),
  );

  /// Refreshes the session timer and increments the refresh counter.
  /// If the max refreshes are exceeded, the session is cleaned up entirely.
  void refreshSession(SessionUUID sessionUuid) {
    final sessionData = _sessions[sessionUuid];
    if (sessionData == null) return;

    if (sessionData.refreshCount >= kMaxSessionRefreshes) {
      _cleanupSession(sessionUuid);
      return;
    }
    sessionData.refreshCount += 1;
    sessionData.cleanupTimer?.cancel();
    sessionData.cleanupTimer = Timer(
      kSessionInactivityTimeout,
      () => _cleanupSession(sessionUuid),
    );
  }

  /// Removes all in-memory data associated with a session.
  void _cleanupSession(SessionUUID sessionUuid) {
    final sessionData = _sessions.remove(sessionUuid);
    sessionData?.cleanupTimer?.cancel();
  }

  // ===========================================================================
  // START CHAT: NEW TEMPLATE
  // ===========================================================================

  /// Creates a new session entry, registers it in the [_sessions] map, and
  /// starts the inactivity timer. Returns the generated session UUID.
  SessionUUID _initSession({
    required TemplateCurrentState templateState,
    required bool isNewTemplate,
    UuidValue? scaffoldId,
    int? existingVersionId,
  }) {
    if (!isNewTemplate && (scaffoldId == null || existingVersionId == null)) {
      throw ArgumentError(
        'scaffoldId and existingVersionId are required when isNewTemplate is false',
      );
    }

    final uuid = _uuidGenerator.v7();
    _sessions[uuid] = SessionData(
      controller: newChat,
      templateState: templateState,
      isNewTemplate: isNewTemplate,
      scaffoldId: scaffoldId,
      existingVersionId: existingVersionId,
    );
    refreshSession(uuid);
    return uuid;
  }

  /// Starts a new chat session for creating a brand new template.
  ///
  /// The [newTemplateState] provides the initial schema, payload example,
  /// reference language, and PDF content metadata (name/description).
  /// No HTML/CSS exists yet - the AI will generate it during the chat.
  Future<SessionUUID> startChatFromNewTemplate(
    Session session, {
    required NewTemplateState newTemplateState,
  }) async {
    return _initSession(
      templateState: newTemplateState,
      isNewTemplate: true,
    );
  }

  // ===========================================================================
  // START CHAT: EXISTING TEMPLATE
  // ===========================================================================

  /// Starts a new chat session for editing an existing template version.
  ///
  /// Loads the full entity hierarchy (version -> scaffold, schema, input HTML/CSS)
  /// and the baseline implementation for the reference language.
  /// Creates a [DeployReadyTemplateState] with the current HTML/CSS content.
  ///
  /// [templateVersionId] is the integer ID of the [ShoebillTemplateVersion] to edit.
  Future<SessionUUID> startChatFromExistingTemplate(
    Session session, {
    required int templateVersionId,
  }) async {
    // Load the version with its scaffold, schema, and input (HTML/CSS)
    final version = await ShoebillTemplateVersion.db.findById(
      session,
      templateVersionId,
      include: ShoebillTemplateVersion.include(
        scaffold: ShoebillTemplateScaffold.include(
          referencePdfContent: PdfContent.include(),
        ),
        schema: SchemaDefinition.include(),
        input: ShoebillTemplateVersionInput.include(),
      ),
    );

    if (version == null) {
      throw ShoebillException(
        title: 'Template version not found',
        description:
            'No ShoebillTemplateVersion found for ID: $templateVersionId',
      );
    }

    final scaffold = version.scaffold;
    if (scaffold == null) {
      throw ShoebillException(
        title: 'Scaffold not found',
        description:
            'No ShoebillTemplateScaffold associated with version: $templateVersionId',
      );
    }

    final pdfContent = scaffold.referencePdfContent;
    if (pdfContent == null) {
      throw ShoebillException(
        title: 'PDF content not found',
        description:
            'No PdfContent (name/description) found for scaffold of version: $templateVersionId',
      );
    }

    final schema = version.schema;
    if (schema == null) {
      throw ShoebillException(
        title: 'Schema not found',
        description:
            'No SchemaDefinition found for version: $templateVersionId',
      );
    }

    final input = version.input;
    if (input == null) {
      throw ShoebillException(
        title: 'Version input not found',
        description:
            'No ShoebillTemplateVersionInput (HTML/CSS) found for version: $templateVersionId',
      );
    }

    // Find the baseline for this version to get the reference language and payload
    final baseline = await ShoebillTemplateBaseline.db.findFirstRow(
      session,
      where: (b) => b.versionId.equals(version.id!),
    );

    if (baseline == null) {
      throw ShoebillException(
        title: 'Baseline not found',
        description:
            'No ShoebillTemplateBaseline found for version: $templateVersionId',
      );
    }

    // Find the reference implementation (in the baseline's reference language)
    final referenceImplementation =
        await ShoebillTemplateBaselineImplementation.db.findFirstRow(
      session,
      where: (impl) =>
          impl.baselineId.equals(baseline.id) &
          impl.language.equals(baseline.referenceLanguage),
    );

    if (referenceImplementation == null) {
      throw ShoebillException(
        title: 'Reference implementation not found',
        description:
            'No baseline implementation found for the reference language '
            '(${baseline.referenceLanguage.name}) of version: $templateVersionId',
      );
    }

    final templateState = DeployReadyTemplateState(
      pdfContent: pdfContent,
      schemaDefinition: schema,
      referenceLanguage: baseline.referenceLanguage,
      htmlContent: input.htmlContent,
      cssContent: input.cssContent,
      referenceStringifiedPayloadJson:
          referenceImplementation.stringifiedPayload,
    );

    return _initSession(
      templateState: templateState,
      isNewTemplate: false,
      scaffoldId: scaffold.id,
      existingVersionId: version.id,
    );
  }

  // ===========================================================================
  // SEND MESSAGE
  // ===========================================================================

  /// Sends a message in the chat session, optionally applying a schema change.
  ///
  /// Returns a stream of [SendMessageStreamResponseItem] which can be either:
  /// - [ChatMessageResponse]: wraps a [ChatMessage] (thinking, text, errors, etc.)
  /// - [TemplateStateResponse]: provides the updated [TemplateCurrentState] after processing
  ///
  /// If [schemaChange] is provided:
  /// - Validates the new example payload against the new schema
  /// - Marks the session as having a schema change (affects deploy behavior)
  /// - Updates the session template info with new schema and payload
  Future<Stream<SendMessageStreamResponseItem>> sendMessage(
    Session session, {
    required SessionUUID sessionUUID,
    required String message,
    NewSchemaChangePayload? schemaChange,
  }) async {
    final controller = StreamController<SendMessageStreamResponseItem>();

    // Yield the user's message first
    controller.add(
      ChatMessageResponse(
        message: ChatMessage(
          role: ChatActor.user,
          content: message,
          style: ChatUIStyle.normal,
        ),
      ),
    );

    final sessionData = _sessions[sessionUUID];

    if (sessionData == null) {
      controller.add(
        ChatMessageResponse(
          message: ChatMessage(
            role: ChatActor.system,
            content: 'No active session found for the provided UUID.',
            style: ChatUIStyle.error,
          ),
        ),
      );
      await controller.close();
      return controller.stream;
    }

    if (sessionData.controller.isAlreadyProcessingMessage) {
      controller.add(
        ChatMessageResponse(
          message: ChatMessage(
            role: ChatActor.system,
            content: 'Still processing the previous message. Please wait.',
            style: ChatUIStyle.error,
          ),
        ),
      );
      await controller.close();
      return controller.stream;
    }

    // Handle schema change if provided
    if (schemaChange != null) {
      final validationError = _applySchemaChange(
        sessionUUID: sessionUUID,
        schemaChange: schemaChange,
      );
      if (validationError != null) {
        controller.add(
          ChatMessageResponse(
            message: ChatMessage(
              role: ChatActor.system,
              content: validationError,
              style: ChatUIStyle.error,
            ),
          ),
        );
        await controller.close();
        return controller.stream;
      }

      // Notify the user that schema change was applied
      controller.add(
        ChatMessageResponse(
          message: ChatMessage(
            role: ChatActor.system,
            content:
                'Schema change applied successfully. The AI will now adapt the template to the new schema.',
            style: ChatUIStyle.normal,
          ),
        ),
      );
    }

    refreshSession(sessionUUID);

    // Stream messages from the chat controller
    unawaited(_processMessages(
      controller: controller,
      currentSession: sessionData.controller,
      sessionUUID: sessionUUID,
      message: message,
      templateState: sessionData.templateState,
      schemaChange: schemaChange,
    ));

    return controller.stream;
  }

  /// Processes messages from the chat controller and streams them as responses.
  /// The chat controller yields [SendMessageStreamResponseItem] (which includes
  /// both [ChatMessageResponse] and [TemplateStateResponse]) directly.
  Future<void> _processMessages({
    required StreamController<SendMessageStreamResponseItem> controller,
    required IChatController currentSession,
    required SessionUUID sessionUUID,
    required String message,
    required TemplateCurrentState templateState,
    NewSchemaChangePayload? schemaChange,
  }) async {
    try {
      await for (final msg in currentSession.sendMessage(
        message: message,
        templateState: templateState,
        schemaChangePayload: schemaChange,
      )) {
        controller.add(msg);

        // If the controller yielded a TemplateStateResponse, update session state
        if (msg is TemplateStateResponse) {
          _sessions[sessionUUID]?.templateState = msg.currentState;
        }
      }
    } catch (e) {
      controller.add(
        ChatMessageResponse(
          message: ChatMessage(
            role: ChatActor.system,
            content: 'An unexpected error occurred: $e',
            style: ChatUIStyle.error,
          ),
        ),
      );
    } finally {
      await controller.close();
    }
  }

  /// Validates and applies a schema change to the session.
  /// Returns an error message string if validation fails, or null on success.
  String? _applySchemaChange({
    required SessionUUID sessionUUID,
    required NewSchemaChangePayload schemaChange,
  }) {
    final newSchema = schemaChange.newSchemaDefinition;
    final newPayloadString = schemaChange.newExamplePayloadStringified;

    // Validate the new example payload is valid JSON
    final Map<String, dynamic>? parsedPayload = tryDecode(newPayloadString);
    if (parsedPayload == null) {
      return 'The new example payload is not valid JSON. '
          'Please provide a valid JSON object.';
    }

    // Validate the payload conforms to the new schema
    final validationError =
        newSchema.validateJsonFollowsSchemaStructure(parsedPayload);
    if (validationError != null) {
      return 'The new example payload does not conform to the new schema: '
          '$validationError';
    }

    // Mark session as having a schema change
    final sessionData = _sessions[sessionUUID];
    if (sessionData == null) return null;

    sessionData.schemaChanged = true;

    // Update the session template info with new schema and payload
    sessionData.templateState = _reconstructTemplateState(
      currentState: sessionData.templateState,
      schemaDefinition: newSchema,
      referenceStringifiedPayloadJson: newPayloadString,
    );

    return null; // Success
  }

  // ===========================================================================
  // DEPLOY SESSION
  // ===========================================================================

  /// Deploys the session, persisting the template to the database.
  ///
  /// The behavior depends on whether this is a new template or existing one,
  /// and whether the schema was changed during the session:
  ///
  /// - **New template**: Creates a new [ShoebillTemplateScaffold] with a first version.
  /// - **Existing template, no schema change**: Updates the HTML/CSS in place
  ///   on the current [ShoebillTemplateVersion]. Old baselines continue to work.
  /// - **Existing template, schema changed**: Creates a new [ShoebillTemplateVersion]
  ///   under the same scaffold. The old version remains intact for backward compatibility.
  ///
  /// Returns the UUID of the scaffold (for new templates) or the scaffold UUID
  /// (for existing templates). The caller can use this to navigate back to the
  /// template dashboard.
  Future<UuidValue> deploySession(
    Session session, {
    required SessionUUID sessionUUID,
  }) async {
    final sessionData = _sessions[sessionUUID];

    if (sessionData == null) {
      throw ShoebillException(
        title: 'Session not found',
        description: 'No template session found for UUID: $sessionUUID',
      );
    }

    final templateState = sessionData.templateState;

    if (templateState is! DeployReadyTemplateState) {
      throw ShoebillException(
        title: 'Template not ready',
        description:
            'The template is not ready for deployment. '
            'Ensure the HTML and CSS have been generated by the AI.',
      );
    }

    final isNew = sessionData.isNewTemplate;
    final schemaChanged = sessionData.schemaChanged;

    final UuidValue resultId;

    if (isNew) {
      resultId = await _deployNewTemplate(session, templateState: templateState);
    } else if (schemaChanged) {
      resultId = await _deployWithSchemaChange(
        session,
        templateState: templateState,
        sessionData: sessionData,
      );
    } else {
      resultId = await _updateExistingTemplateVersion(
        session,
        templateState: templateState,
        sessionData: sessionData,
      );
    }

    // Clean up session data after successful deploy
    _cleanupSession(sessionUUID);

    return resultId;
  }

  /// Creates a brand new template scaffold with the full entity hierarchy.
  /// Returns the scaffold UUID.
  Future<UuidValue> _deployNewTemplate(
    Session session, {
    required DeployReadyTemplateState templateState,
  }) async {
    final scaffold = await _pdfController.createNewTemplateScaffold(
      session: session,
      pdfContent: templateState.pdfContent,
      schemaDefinition: templateState.schemaDefinition,
      language: templateState.referenceLanguage,
      stringifiedPayload: templateState.referenceStringifiedPayloadJson,
      htmlContent: templateState.htmlContent,
      cssContent: templateState.cssContent,
    );

    return scaffold.id;
  }

  /// Creates a new version under the existing scaffold when the schema changed.
  /// The old version remains intact for backward compatibility.
  /// Returns the scaffold UUID (unchanged, but the newest version is now different).
  Future<UuidValue> _deployWithSchemaChange(
    Session session, {
    required DeployReadyTemplateState templateState,
    required SessionData sessionData,
  }) async {
    final scaffoldId = sessionData.scaffoldId;
    if (scaffoldId == null) {
      throw ShoebillException(
        title: 'Scaffold ID missing',
        description:
            'Cannot create a new version: scaffold ID not found. '
            'This indicates the session was not properly initialized from an existing template.',
      );
    }

    // Create a new SchemaDefinition (without ID) for the new version
    final newSchema = SchemaDefinition(
      properties: templateState.schemaDefinition.properties,
    );

    await _pdfController.createNewTemplateVersion(
      session: session,
      scaffoldId: scaffoldId,
      schemaDefinition: newSchema,
      htmlContent: templateState.htmlContent,
      cssContent: templateState.cssContent,
    );

    return scaffoldId;
  }

  /// Updates the HTML/CSS of the existing version in place (UI-only change).
  /// The schema has not changed, so all existing baselines continue to work.
  /// Returns the scaffold UUID.
  Future<UuidValue> _updateExistingTemplateVersion(
    Session session, {
    required DeployReadyTemplateState templateState,
    required SessionData sessionData,
  }) async {
    final versionId = sessionData.existingVersionId;
    if (versionId == null) {
      throw ShoebillException(
        title: 'Version ID missing',
        description:
            'Cannot update version: version ID not found. '
            'This indicates the session was not properly initialized from an existing template.',
      );
    }

    final scaffoldId = sessionData.scaffoldId;
    if (scaffoldId == null) {
      throw ShoebillException(
        title: 'Scaffold ID missing',
        description:
            'Cannot update version: scaffold ID not found.',
      );
    }

    await _pdfController.updateTemplateVersion(
      session: session,
      versionId: versionId,
      htmlContent: templateState.htmlContent,
      cssContent: templateState.cssContent,
    );

    return scaffoldId;
  }

  // ===========================================================================
  // UTILITY: TEMPLATE STATE RECONSTRUCTION HELPER
  // ===========================================================================

  /// Reconstructs a [TemplateCurrentState] from the current state, optionally
  /// overriding schema, payload, HTML, and CSS fields.
  ///
  /// If [currentState] is a [NewTemplateState] and both [htmlContent] and
  /// [cssContent] are provided, promotes it to a [DeployReadyTemplateState].
  TemplateCurrentState _reconstructTemplateState({
    required TemplateCurrentState currentState,
    SchemaDefinition? schemaDefinition,
    String? referenceStringifiedPayloadJson,
    String? htmlContent,
    String? cssContent,
  }) {
    if (currentState is DeployReadyTemplateState) {
      return DeployReadyTemplateState(
        pdfContent: currentState.pdfContent,
        schemaDefinition: schemaDefinition ?? currentState.schemaDefinition,
        referenceLanguage: currentState.referenceLanguage,
        htmlContent: htmlContent ?? currentState.htmlContent,
        cssContent: cssContent ?? currentState.cssContent,
        referenceStringifiedPayloadJson: referenceStringifiedPayloadJson ??
            currentState.referenceStringifiedPayloadJson,
      );
    } else if (currentState is NewTemplateState) {
      // If HTML/CSS are provided, promote to DeployReadyTemplateState
      if (htmlContent != null && cssContent != null) {
        return DeployReadyTemplateState(
          pdfContent: currentState.pdfContent,
          schemaDefinition: schemaDefinition ?? currentState.schemaDefinition,
          referenceLanguage: currentState.referenceLanguage,
          htmlContent: htmlContent,
          cssContent: cssContent,
          referenceStringifiedPayloadJson: referenceStringifiedPayloadJson ??
              currentState.referenceStringifiedPayloadJson,
        );
      }
      return NewTemplateState(
        pdfContent: currentState.pdfContent,
        schemaDefinition: schemaDefinition ?? currentState.schemaDefinition,
        referenceLanguage: currentState.referenceLanguage,
        referenceStringifiedPayloadJson: referenceStringifiedPayloadJson ??
            currentState.referenceStringifiedPayloadJson,
      );
    }
    return currentState;
  }

  // ===========================================================================
  // UTILITY: UPDATE TEMPLATE STATE FROM AI OUTPUT
  // ===========================================================================

  /// Updates the session's template state with new HTML/CSS content produced by the AI.
  /// This is called after the Daytona Claude Code instance finishes generating/modifying
  /// the template files.
  ///
  /// Transitions a [NewTemplateState] to [DeployReadyTemplateState] if HTML/CSS
  /// are now available.
  void updateSessionTemplateWithAiOutput({
    required SessionUUID sessionUUID,
    required String htmlContent,
    required String cssContent,
  }) {
    final sessionData = _sessions[sessionUUID];
    if (sessionData == null) return;

    sessionData.templateState = _reconstructTemplateState(
      currentState: sessionData.templateState,
      htmlContent: htmlContent,
      cssContent: cssContent,
    );
  }

  // ===========================================================================
  // DAYTONA SESSION ID MANAGEMENT
  // ===========================================================================

  /// Stores the Daytona Claude Code session ID for a given chat session.
  /// This allows resuming the Claude conversation after the sandbox is stopped.
  void setDaytonaSessionId({
    required SessionUUID sessionUUID,
    required String daytonaSessionId,
  }) {
    _sessions[sessionUUID]?.daytonaSessionId = daytonaSessionId;
  }

  /// Retrieves the stored Daytona Claude Code session ID for resuming.
  /// Returns null if no session ID has been stored yet.
  String? getDaytonaSessionId(SessionUUID sessionUUID) {
    return _sessions[sessionUUID]?.daytonaSessionId;
  }

  // ===========================================================================
  // SESSION STATE ACCESSORS (for use by ChatController or other services)
  // ===========================================================================

  /// Returns the current template state for a session, or null if not found.
  TemplateCurrentState? getSessionTemplateState(SessionUUID sessionUUID) {
    return _sessions[sessionUUID]?.templateState;
  }

  /// Returns whether the schema has been changed during this session.
  bool hasSchemaChanged(SessionUUID sessionUUID) {
    return _sessions[sessionUUID]?.schemaChanged ?? false;
  }

  /// Returns whether this session is for a new template.
  bool isNewTemplateSession(SessionUUID sessionUUID) {
    return _sessions[sessionUUID]?.isNewTemplate ?? true;
  }
}
