// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:shoebill_template_server/server.dart';
import 'package:shoebill_template_server/src/api/pdf_related/entities/schema_property_extensions.dart';
import 'package:shoebill_template_server/src/core/utils/consts.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';
import 'package:shoebill_template_server/src/services/daytona_claude_code_service.dart';
import 'package:shoebill_template_server/src/services/template_reviewer_service.dart';

// ============================================================================
// CHAT CONTROLLER INTERFACE
// ============================================================================

/// Interface for the chat controller that handles message processing.
abstract class IChatController {
  const IChatController();

  /// Whether the controller is currently processing a message.
  bool get isAlreadyProcessingMessage;

  /// The Claude session ID from the last Daytona interaction.
  /// Used for resuming conversations in new sandboxes.
  String? get claudeSessionId;

  /// The current HTML content after the last successful generation.
  String? get currentHtmlContent;

  /// The current CSS content after the last successful generation.
  String? get currentCssContent;

  /// Sends a message and returns a stream of response items.
  ///
  /// The stream yields [SendMessageStreamResponseItem] which can be either:
  /// - [ChatMessageResponse]: A chat message (thinking, status, success, error)
  /// - [TemplateStateResponse]: The current template state after generation
  Stream<SendMessageStreamResponseItem> sendMessage({
    required String message,
    required TemplateCurrentState templateState,
    NewSchemaChangePayload? schemaChangePayload,
  });
}

// ============================================================================
// CHAT CONTROLLER IMPLEMENTATION
// ============================================================================

/// Implements the chat controller with Daytona Claude Code integration
/// and Template Reviewer AI validation loop.
///
/// ## Flow:
/// 1. User sends message
/// 2. Determine scenario (create/edit/schema change)
/// 3. Build prompt and call Daytona service, streaming thinking/tool use
/// 4. Get HTML/CSS result
/// 5. Run basic syntax validation (via reviewer)
/// 6. Call TemplateReviewerService for AI-powered review
/// 7. If approved: yield success + template state
/// 8. If rejected and attempts < max: feed feedback to Daytona, retry
/// 9. If rejected and attempts >= max: yield error
class ChatControllerImpl implements IChatController {
  ChatControllerImpl({
    required DaytonaClaudeCodeService daytonaService,
    required TemplateReviewerService reviewerService,
  })  : _daytonaService = daytonaService,
        _reviewerService = reviewerService;

  final DaytonaClaudeCodeService _daytonaService;
  final TemplateReviewerService _reviewerService;

  @override
  bool isAlreadyProcessingMessage = false;

  @override
  String? claudeSessionId;

  @override
  String? currentHtmlContent;

  @override
  String? currentCssContent;

  @override
  Stream<SendMessageStreamResponseItem> sendMessage({
    required String message,
    required TemplateCurrentState templateState,
    NewSchemaChangePayload? schemaChangePayload,
  }) async* {
    isAlreadyProcessingMessage = true;

    try {
      // Determine the scenario based on template state and schema change payload
      final scenario = _buildScenario(
        message: message,
        templateState: templateState,
        schemaChangePayload: schemaChangePayload,
      );

      final reviewScenario = _determineReviewScenario(
        templateState: templateState,
        schemaChangePayload: schemaChangePayload,
      );

      // Get schema and previous state for the reviewer
      final schema = _extractSchemaDefinition(
        templateState,
        schemaChangePayload,
      );
      final previousHtml = currentHtmlContent;
      final previousCss = currentCssContent;
      final previousSchema = _extractPreviousSchema(templateState);

      // Enter the generation + review loop
      yield* _generateAndReviewLoop(
        scenario: scenario,
        reviewScenario: reviewScenario,
        userPrompt: message,
        schema: schema,
        previousHtml: previousHtml,
        previousCss: previousCss,
        previousSchema: previousSchema,
        templateState: templateState,
        schemaChangePayload: schemaChangePayload,
      );
    } catch (e) {
      yield ChatMessageResponse(
        message: ChatMessage(
          role: ChatActor.system,
          style: ChatUIStyle.error,
          content: 'An unexpected error occurred: $e',
        ),
      );
    } finally {
      isAlreadyProcessingMessage = false;
    }
  }

  // ==========================================================================
  // GENERATION + REVIEW LOOP
  // ==========================================================================

  /// Main loop that generates template with Daytona and validates with reviewer.
  /// Retries up to [kMaxDaytonaRetryAttempts] times if the reviewer rejects.
  Stream<SendMessageStreamResponseItem> _generateAndReviewLoop({
    required TemplateScenario scenario,
    required ReviewScenario reviewScenario,
    required String userPrompt,
    required SchemaDefinition schema,
    required String? previousHtml,
    required String? previousCss,
    required SchemaDefinition? previousSchema,
    required TemplateCurrentState templateState,
    required NewSchemaChangePayload? schemaChangePayload,
  }) async* {
    TemplateScenario currentScenario = scenario;
    int attempt = 0;

    while (attempt < kMaxDaytonaRetryAttempts) {
      attempt++;

      if (attempt > 1) {
        yield ChatMessageResponse(
          message: ChatMessage(
            role: ChatActor.system,
            style: ChatUIStyle.normal,
            content:
                'Retry attempt $attempt of $kMaxDaytonaRetryAttempts...',
          ),
        );
      }

      // --- Step 1: Call Daytona Claude Code with streaming ---
      // We use a StreamController to bridge the callback-based Daytona API
      // with our async generator. The Daytona service provides real-time
      // callbacks for thinking/tool use, which we forward as stream events.
      final daytonaStreamController =
          StreamController<SendMessageStreamResponseItem>();
      final daytonaResultCompleter = Completer<DaytonaClaudeCodeResult>();

      unawaited(
        _daytonaService
            .generateTemplate(
          scenario: currentScenario,
          previousSessionId: claudeSessionId,
          onThinking: (thinking) {
            if (isLocal) print('Thinking: $thinking');
            if (!daytonaStreamController.isClosed) {
              daytonaStreamController.add(
                ChatMessageResponse(
                  message: ChatMessage(
                    role: ChatActor.ai,
                    content: thinking,
                    style: ChatUIStyle.thinkingChunk,
                  ),
                ),
              );
            }
          },
          onToolUse: (toolName, input) {
            if (isLocal) {
              print('Using tool: $toolName');
              if (toolName == 'Write') {
                print('   Writing to: ${input['file_path']}');
              }
            }
            if (!daytonaStreamController.isClosed) {
              daytonaStreamController.add(
                ChatMessageResponse(
                  message: ChatMessage(
                    role: ChatActor.ai,
                    style: ChatUIStyle.thinkingChunk,
                    content: 'Using tool: $toolName',
                  ),
                ),
              );
            }
          },
          onText: (text) {
            if (isLocal) print('Text: $text');
            if (!daytonaStreamController.isClosed) {
              daytonaStreamController.add(
                ChatMessageResponse(
                  message: ChatMessage(
                    role: ChatActor.ai,
                    content: text,
                    style: ChatUIStyle.normal,
                  ),
                ),
              );
            }
          },
        )
            .then((result) {
          daytonaResultCompleter.complete(result);
          if (!daytonaStreamController.isClosed) {
            daytonaStreamController.close();
          }
        }).catchError((Object error) {
          daytonaResultCompleter.completeError(error);
          if (!daytonaStreamController.isClosed) {
            daytonaStreamController.close();
          }
        }),
      );

      // Yield all streaming events from Daytona (thinking, tool use, text)
      yield* daytonaStreamController.stream;

      // Get the final Daytona result
      final DaytonaClaudeCodeResult daytonaResult;
      try {
        daytonaResult = await daytonaResultCompleter.future;
      } catch (e) {
        yield ChatMessageResponse(
          message: ChatMessage(
            role: ChatActor.ai,
            style: ChatUIStyle.error,
            content: 'Daytona execution failed: $e',
          ),
        );
        return;
      }

      // If Daytona returned an error, handle it
      if (daytonaResult is! DaytonaSuccess) {
        yield* _handleDaytonaError(daytonaResult);
        return;
      }

      // Save session ID and current HTML/CSS
      claudeSessionId = daytonaResult.claudeSessionId;
      currentHtmlContent = daytonaResult.htmlContent;
      currentCssContent = daytonaResult.cssContent;

      // --- Step 2: Yield success from Daytona ---
      yield ChatMessageResponse(
        message: ChatMessage(
          role: ChatActor.ai,
          style: ChatUIStyle.success,
          content: daytonaResult.summaryText.isNotEmpty
              ? daytonaResult.summaryText
              : 'Template generation completed.',
        ),
      );

      // --- Step 3: Announce verification ---
      yield ChatMessageResponse(
        message: ChatMessage(
          role: ChatActor.system,
          style: ChatUIStyle.normal,
          content:
              'The AI has completed its modifications. '
              'Now verifying the template for errors and completeness...',
        ),
      );

      // --- Step 4: Run reviewer with streaming ---
      ReviewResult? reviewResult;

      await for (final event in _reviewerService.reviewTemplateStream(
        htmlContent: daytonaResult.htmlContent,
        cssContent: daytonaResult.cssContent,
        userPrompt: userPrompt,
        schema: schema,
        scenario: reviewScenario,
        previousHtml: previousHtml,
        previousCss: previousCss,
        previousSchema: previousSchema,
      )) {
        switch (event) {
          case ReviewThinkingEvent(:final thinkingChunk):
            yield ChatMessageResponse(
              message: ChatMessage(
                role: ChatActor.system,
                content: thinkingChunk.thinkingText,
                style: ChatUIStyle.thinkingChunk,
              ),
            );
          case ReviewStatusEvent(:final message):
            yield ChatMessageResponse(
              message: ChatMessage(
                role: ChatActor.system,
                content: message,
                style: ChatUIStyle.normal,
              ),
            );
          case ReviewCompleteEvent(:final result):
            reviewResult = result;
        }
      }

      // If reviewer stream completed without a result, treat as error
      if (reviewResult == null) {
        yield ChatMessageResponse(
          message: ChatMessage(
            role: ChatActor.system,
            style: ChatUIStyle.error,
            content:
                'Template verification completed without producing a result. '
                'The template has been saved but may contain issues.',
          ),
        );
        yield _buildTemplateStateResponse(
          templateState: templateState,
          htmlContent: daytonaResult.htmlContent,
          cssContent: daytonaResult.cssContent,
          schemaChangePayload: schemaChangePayload,
        );
        return;
      }

      // --- Step 5: Handle review result ---
      switch (reviewResult) {
        case ReviewApproved(:final feedbackForUser):
          yield ChatMessageResponse(
            message: ChatMessage(
              role: ChatActor.system,
              style: ChatUIStyle.success,
              content: feedbackForUser,
            ),
          );
          yield _buildTemplateStateResponse(
            templateState: templateState,
            htmlContent: daytonaResult.htmlContent,
            cssContent: daytonaResult.cssContent,
            schemaChangePayload: schemaChangePayload,
          );
          return;

        case ReviewRejected(
          :final feedbackForClaude,
          :final feedbackForUser,
          :final issues,
        ):
          if (attempt >= kMaxDaytonaRetryAttempts) {
            yield ChatMessageResponse(
              message: ChatMessage(
                role: ChatActor.system,
                style: ChatUIStyle.error,
                content:
                    'The template could not be fully validated after '
                    '$kMaxDaytonaRetryAttempts attempts. '
                    'Issues found: ${issues.join("; ")}. '
                    'Please try rephrasing your request or simplifying '
                    'the template requirements.',
              ),
            );
            return;
          }

          // Inform user about what is being fixed
          yield ChatMessageResponse(
            message: ChatMessage(
              role: ChatActor.system,
              style: ChatUIStyle.normal,
              content: feedbackForUser,
            ),
          );

          // Build a new scenario with reviewer feedback for retry
          currentScenario = _buildRetryScenario(
            originalScenario: currentScenario,
            feedbackForClaude: feedbackForClaude,
            currentHtml: daytonaResult.htmlContent,
            currentCss: daytonaResult.cssContent,
          );

        case ReviewError(:final errorMessage):
          yield ChatMessageResponse(
            message: ChatMessage(
              role: ChatActor.system,
              style: ChatUIStyle.error,
              content:
                  'Template verification encountered an error: $errorMessage. '
                  'The template has been saved but may contain issues.',
            ),
          );
          yield _buildTemplateStateResponse(
            templateState: templateState,
            htmlContent: daytonaResult.htmlContent,
            cssContent: daytonaResult.cssContent,
            schemaChangePayload: schemaChangePayload,
          );
          return;
      }
    }
  }

  // ==========================================================================
  // DAYTONA ERROR HANDLING
  // ==========================================================================

  /// Handles Daytona error results by yielding appropriate error messages.
  Stream<SendMessageStreamResponseItem> _handleDaytonaError(
    DaytonaClaudeCodeResult result,
  ) async* {
    final errorMessage = switch (result) {
      DaytonaSandboxError(:final message, :final statusCode) =>
        'Sandbox error${statusCode != null ? ' (HTTP $statusCode)' : ''}: '
            '$message',
      DaytonaExecutionError(:final message, :final stderr) =>
        'Execution error: $message'
            '${stderr != null ? '\nDetails: $stderr' : ''}',
      DaytonaFileNotFoundError(:final message) =>
        'Generated files not found: $message',
      DaytonaTimeoutError(:final phase) =>
        'Operation timed out during: $phase',
      DaytonaNetworkError(:final message) => 'Network error: $message',
      DaytonaFileUploadError(:final message, :final fileName) =>
        'Failed to upload file "$fileName": $message',
      DaytonaSuccess() => '', // Unreachable
    };

    yield ChatMessageResponse(
      message: ChatMessage(
        role: ChatActor.ai,
        style: ChatUIStyle.error,
        content: errorMessage,
      ),
    );

    yield ChatMessageResponse(
      message: ChatMessage(
        role: ChatActor.system,
        style: ChatUIStyle.error,
        content:
            'The template generation failed. Please try again or contact '
            'support if the issue persists.',
      ),
    );
  }

  // ==========================================================================
  // SCENARIO BUILDING
  // ==========================================================================

  /// Determines the Daytona template scenario based on the current state.
  ///
  /// Three scenarios are supported:
  /// 1. **Create New**: No existing HTML/CSS, first-time generation
  /// 2. **Edit Existing**: Has current HTML/CSS, user wants UI changes
  /// 3. **Schema Change**: Schema changed, template must adapt to new fields
  TemplateScenario _buildScenario({
    required String message,
    required TemplateCurrentState templateState,
    NewSchemaChangePayload? schemaChangePayload,
  }) {
    final schemaJson = _getSchemaJsonString(
      templateState,
      schemaChangePayload,
    );
    final payloadJson = _getPayloadJsonString(
      templateState,
      schemaChangePayload,
    );

    // Schema change scenario: new schema provided + existing HTML/CSS
    if (schemaChangePayload != null &&
        currentHtmlContent != null &&
        currentCssContent != null) {
      final currentSchemaJson = _getSchemaJsonStringFromDefinition(
        _extractPreviousSchema(templateState) ??
            _extractSchemaDefinition(templateState, null),
      );
      return TemplateScenario.changeSchema(
        userPrompt: message,
        currentSchemaJson: currentSchemaJson,
        newSchemaJson: schemaJson,
        newExamplePayloadJson: payloadJson,
        currentHtmlContent: currentHtmlContent!,
        currentCssContent: currentCssContent!,
      );
    }

    // Edit existing scenario: controller already has HTML/CSS from previous msg
    if (currentHtmlContent != null && currentCssContent != null) {
      return TemplateScenario.editExisting(
        userPrompt: message,
        schemaJson: schemaJson,
        examplePayloadJson: payloadJson,
        currentHtmlContent: currentHtmlContent!,
        currentCssContent: currentCssContent!,
      );
    }

    // Edit existing scenario: template loaded from DB with HTML/CSS
    if (templateState is DeployReadyTemplateState) {
      currentHtmlContent = templateState.htmlContent;
      currentCssContent = templateState.cssContent;
      return TemplateScenario.editExisting(
        userPrompt: message,
        schemaJson: schemaJson,
        examplePayloadJson: payloadJson,
        currentHtmlContent: templateState.htmlContent,
        currentCssContent: templateState.cssContent,
      );
    }

    // Create new scenario: no existing HTML/CSS anywhere
    return TemplateScenario.createNew(
      userPrompt: message,
      schemaJson: schemaJson,
      examplePayloadJson: payloadJson,
    );
  }

  /// Determines the review scenario type for the template reviewer.
  ReviewScenario _determineReviewScenario({
    required TemplateCurrentState templateState,
    NewSchemaChangePayload? schemaChangePayload,
  }) {
    if (schemaChangePayload != null) {
      return ReviewScenario.schemaChange;
    }
    if (currentHtmlContent != null ||
        templateState is DeployReadyTemplateState) {
      return ReviewScenario.editingExisting;
    }
    return ReviewScenario.creatingNew;
  }

  /// Builds a retry scenario that includes reviewer feedback for Claude Code.
  ///
  /// When the reviewer rejects a template, we construct a new "edit existing"
  /// scenario with the feedback embedded in the prompt so Claude Code knows
  /// exactly what to fix.
  TemplateScenario _buildRetryScenario({
    required TemplateScenario originalScenario,
    required String feedbackForClaude,
    required String currentHtml,
    required String currentCss,
  }) {
    final retryPrompt = '''
The previous attempt had issues that need to be fixed. Here is the reviewer's feedback:

$feedbackForClaude

Please fix all the issues mentioned above in the existing HTML/CSS template.
Do NOT start from scratch - modify the existing files to address the specific issues.
''';

    // Extract schema info from the original scenario
    final schemaJson = switch (originalScenario) {
      CreateNewTemplateScenario(:final schemaJson) => schemaJson,
      EditExistingTemplateScenario(:final schemaJson) => schemaJson,
      ChangeSchemaTemplateScenario(:final newSchemaJson) => newSchemaJson,
    };

    final payloadJson = switch (originalScenario) {
      CreateNewTemplateScenario(:final examplePayloadJson) =>
        examplePayloadJson,
      EditExistingTemplateScenario(:final examplePayloadJson) =>
        examplePayloadJson,
      ChangeSchemaTemplateScenario(:final newExamplePayloadJson) =>
        newExamplePayloadJson,
    };

    return TemplateScenario.editExisting(
      userPrompt: retryPrompt,
      schemaJson: schemaJson,
      examplePayloadJson: payloadJson,
      currentHtmlContent: currentHtml,
      currentCssContent: currentCss,
    );
  }

  // ==========================================================================
  // TEMPLATE STATE RESPONSE BUILDING
  // ==========================================================================

  /// Builds the [TemplateStateResponse] with the updated template state.
  ///
  /// Converts the current [TemplateCurrentState] (which may be [NewTemplateState]
  /// or [DeployReadyTemplateState]) into a [DeployReadyTemplateState] with the
  /// latest HTML/CSS content from Daytona.
  TemplateStateResponse _buildTemplateStateResponse({
    required TemplateCurrentState templateState,
    required String htmlContent,
    required String cssContent,
    NewSchemaChangePayload? schemaChangePayload,
  }) {
    // Both NewTemplateState and DeployReadyTemplateState share the same fields
    // needed to construct a DeployReadyTemplateState, so we extract them
    // uniformly regardless of the concrete type.
    final effectiveSchema = schemaChangePayload?.newSchemaDefinition ??
        _extractSchemaDefinition(templateState, null);
    final effectivePayload =
        schemaChangePayload?.newExamplePayloadStringified ??
            _getPayloadJsonString(templateState, null);
    final referenceLanguage = switch (templateState) {
      NewTemplateState(:final referenceLanguage) => referenceLanguage,
      DeployReadyTemplateState(:final referenceLanguage) => referenceLanguage,
    };
    final pdfContent = switch (templateState) {
      NewTemplateState(:final pdfContent) => pdfContent,
      DeployReadyTemplateState(:final pdfContent) => pdfContent,
    };

    final deployState = DeployReadyTemplateState(
      pdfContent: pdfContent,
      schemaDefinition: effectiveSchema,
      referenceLanguage: referenceLanguage,
      htmlContent: htmlContent,
      cssContent: cssContent,
      referenceStringifiedPayloadJson: effectivePayload,
    );

    return TemplateStateResponse(currentState: deployState);
  }

  // ==========================================================================
  // UTILITY METHODS
  // ==========================================================================

  /// Extracts the target schema definition from the template state or
  /// schema change payload.
  SchemaDefinition _extractSchemaDefinition(
    TemplateCurrentState templateState,
    NewSchemaChangePayload? schemaChangePayload,
  ) {
    if (schemaChangePayload != null) {
      return schemaChangePayload.newSchemaDefinition;
    }
    return switch (templateState) {
      NewTemplateState(:final schemaDefinition) => schemaDefinition,
      DeployReadyTemplateState(:final schemaDefinition) => schemaDefinition,
    };
  }

  /// Extracts the previous/current schema definition (before any change).
  SchemaDefinition? _extractPreviousSchema(
    TemplateCurrentState templateState,
  ) {
    return switch (templateState) {
      NewTemplateState(:final schemaDefinition) => schemaDefinition,
      DeployReadyTemplateState(:final schemaDefinition) => schemaDefinition,
    };
  }

  /// Gets the schema as a JSON string for Daytona prompts.
  String _getSchemaJsonString(
    TemplateCurrentState templateState,
    NewSchemaChangePayload? schemaChangePayload,
  ) {
    final schema = _extractSchemaDefinition(
      templateState,
      schemaChangePayload,
    );
    return _getSchemaJsonStringFromDefinition(schema);
  }

  /// Converts a [SchemaDefinition] to a formatted JSON string.
  String _getSchemaJsonStringFromDefinition(SchemaDefinition schema) {
    final schemaMap = <String, dynamic>{};
    for (final entry in schema.properties.entries) {
      schemaMap[entry.key] = entry.value.toSchemaJson();
    }
    return const JsonEncoder.withIndent('  ').convert(schemaMap);
  }

  /// Gets the example payload JSON string for Daytona prompts.
  String _getPayloadJsonString(
    TemplateCurrentState templateState,
    NewSchemaChangePayload? schemaChangePayload,
  ) {
    if (schemaChangePayload != null) {
      return schemaChangePayload.newExamplePayloadStringified;
    }
    return switch (templateState) {
      NewTemplateState(:final referenceStringifiedPayloadJson) =>
        referenceStringifiedPayloadJson,
      DeployReadyTemplateState(:final referenceStringifiedPayloadJson) =>
        referenceStringifiedPayloadJson,
    };
  }
}
