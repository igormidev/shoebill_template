/// Daytona + Claude Code Integration Service for Jinja2 Template Generation
///
/// This service manages Claude Code instances running in Daytona sandboxes
/// to generate Jinja2 HTML/CSS templates. It supports:
///
/// - Creating new templates from scratch
/// - Editing existing templates (HTML/CSS changes)
/// - Handling schema changes (creating new versions)
/// - Session persistence via Claude session IDs
/// - Real-time streaming of Claude's thinking process
/// - Cost optimization through immediate sandbox cleanup
///
/// ## Configuration Required:
/// - `DAYTONA_API_KEY`: API key from Daytona dashboard (https://app.daytona.io)
/// - `ANTHROPIC_API_KEY`: Anthropic API key for Claude Code
///
/// ## Example Usage:
/// ```dart
/// final service = DaytonaClaudeCodeService(
///   daytonaApiKey: Platform.environment['DAYTONA_API_KEY']!,
///   anthropicApiKey: Platform.environment['ANTHROPIC_API_KEY']!,
/// );
///
/// // Create a new template
/// final result = await service.generateTemplate(
///   scenario: TemplateScenario.createNew(
///     userPrompt: 'Create an invoice template with header and footer',
///     schemaJson: '{"type": "object", ...}',
///     examplePayloadJson: '{"invoice_number": "INV-001", ...}',
///   ),
///   onThinking: (chunk) => print('Thinking: $chunk'),
///   onText: (text) => print('Text: $text'),
///   onToolUse: (tool, input) => print('Tool: $tool'),
/// );
///
/// switch (result) {
///   case DaytonaSuccess():
///     print('HTML: ${result.htmlContent}');
///     print('CSS: ${result.cssContent}');
///     print('Session ID: ${result.claudeSessionId}');
///     break;
///   case DaytonaSandboxError():
///     print('Sandbox error: ${result.message}');
///     break;
///   // ... handle other error cases
/// }
/// ```
library;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shoebill_template_server/src/core/utils/consts.dart';

// ============================================================================
// CONSTANTS
// ============================================================================

/// The Claude model identifier used for Daytona Claude Code instances.
/// Haiku 4.5 provides 90% of Sonnet 4.5's capability at 3x cost savings.
const String kDaytonaClaudeModel = 'claude-haiku-4-5-20251001';

/// Default Daytona API base URL.
const String kDaytonaApiBaseUrl = 'https://app.daytona.io/api';

/// Default target region for sandbox creation.
const String kDaytonaDefaultTarget = 'us';

/// Maximum time to wait for sandbox to be ready.
const Duration kSandboxReadyTimeout = Duration(seconds: 120);

/// Maximum time for Claude Code execution.
const Duration kClaudeExecutionTimeout = Duration(minutes: 15);

/// Polling interval when waiting for sandbox readiness.
const Duration kSandboxPollInterval = Duration(seconds: 2);

/// Maximum number of sandbox readiness poll attempts.
const int kMaxSandboxPollAttempts = 60;

/// The working directory inside the Daytona sandbox.
const String kSandboxWorkDir = '/home/daytona/workspace';

/// Sandbox image for AI workloads.
const String kSandboxImage = 'daytonaio/ai-starter:latest';

/// Auto-stop interval in minutes (minimize cost).
const int kAutoStopIntervalMinutes = 5;

/// Auto-archive interval in minutes.
const int kAutoArchiveIntervalMinutes = 15;

/// Auto-delete interval in minutes.
const int kAutoDeleteIntervalMinutes = 30;

// ============================================================================
// FILE NAME CONSTANTS (used for upload and reference in prompts)
// ============================================================================

const String kFileNameHtml = 'template.html';
const String kFileNameCss = 'template.css';
const String kFileNamePayloadExample = 'example_payload.json';
const String kFileNameCurrentSchema = 'current_schema.json';
const String kFileNameNewTargetSchema = 'new_target_schema.json';
const String kFileNameUserPrompt = 'user_specification_prompt.md';

// ============================================================================
// PROMPT TEMPLATE CONSTANTS (shared across scenarios)
// ============================================================================

/// Common instructions appended to all prompts regarding Jinja2, multi-language,
/// and research requirements.
const String kCommonPromptInstructions = '''
## MANDATORY RESEARCH REQUIREMENT (DO NOT SKIP)

Before writing ANY code, you MUST:
1. Research the LATEST Jinja2 documentation to understand current template syntax, filters, and best practices.
2. Research the LATEST Daytona documentation to understand the sandbox environment you are working in.
3. Do NOT rely on training data alone - always verify against the latest docs.

## Jinja2 Template Requirements

You are creating a Jinja2-compatible HTML template with a corresponding CSS file.
The HTML file uses Jinja2 syntax ({{ variable }}, {% for %}, {% if %}, etc.).

### Multi-Language Support (CRITICAL)

ALL hardcoded strings in the template MUST support multiple languages using Jinja2 conditionals.
The template receives a `language` parameter that determines which language to display.

Supported languages: english, simplifiedMandarinChinese, traditionalChinese, spanish, french, brazilianPortuguese, portugalPortuguese, russian, ukrainian, polish, indonesian, malay, german, dutch, japanese, swahili, turkish, vietnamese, korean, italian, filipino, romanian, swedish, czech

Example of multi-language hardcoded string:
```html
{% if language == "english" %}Invoice{% elif language == "spanish" %}Factura{% elif language == "french" %}Facture{% elif language == "japanese" %}請求書{% elif language == "simplifiedMandarinChinese" %}发票{% elif language == "german" %}Rechnung{% else %}Invoice{% endif %}
```

You MUST translate hardcoded strings for ALL supported languages listed above.
Do NOT leave any string untranslated - provide translations for every language.

### Font Requirement

Use "Noto Sans CJK" as the default font family. This font supports Latin, CJK (Chinese, Japanese, Korean), and many other scripts.
Include it in the CSS:
```css
body {
  font-family: 'Noto Sans CJK SC', 'Noto Sans', sans-serif;
}
```

### Template Variables

The template receives variables from a JSON payload that matches the provided schema.
Access nested objects using dot notation: {{ data.customer.name }}
Access arrays with for loops: {% for item in data.items %}...{% endfor %}

### Output Requirements

1. Save the HTML template as "@$kFileNameHtml" in the current directory
2. Save the CSS as "@$kFileNameCss" in the current directory
3. The HTML must include a <link> to the CSS file or embed styles
4. The template must be valid Jinja2 syntax
5. Use proper HTML5 structure with <!DOCTYPE html>
6. Design for A4 paper size (210mm x 297mm) for PDF generation
7. Include print-friendly CSS (@media print)
8. Do NOT use any external JavaScript
9. All images should use {{ variable }} from the schema, never hardcoded URLs
''';

/// Instructions for the final summary message from Claude Code.
const String kFinalSummaryInstruction = '''

## Final Step

After completing the template, provide a brief summary of:
1. What was created/modified
2. Key design decisions made
3. Any assumptions about the data structure
4. Which languages were included in the translations

IMPORTANT: Verify the files exist by running: ls -la $kFileNameHtml $kFileNameCss
''';

// ============================================================================
// SEALED RESULT CLASSES
// ============================================================================

/// Base sealed class for Daytona Claude Code generation results.
sealed class DaytonaClaudeCodeResult {
  const DaytonaClaudeCodeResult();
}

/// Successful generation with HTML, CSS, and session metadata.
final class DaytonaSuccess extends DaytonaClaudeCodeResult {
  /// The generated HTML template content (Jinja2 syntax).
  final String htmlContent;

  /// The generated CSS content.
  final String cssContent;

  /// Claude session ID for resuming the conversation later.
  final String? claudeSessionId;

  /// Summary text from Claude about what was done.
  final String summaryText;

  /// All thinking blocks captured during execution.
  final List<String> thinkingBlocks;

  const DaytonaSuccess({
    required this.htmlContent,
    required this.cssContent,
    this.claudeSessionId,
    required this.summaryText,
    this.thinkingBlocks = const [],
  });
}

/// Error during sandbox creation or management.
final class DaytonaSandboxError extends DaytonaClaudeCodeResult {
  final String message;
  final int? statusCode;

  const DaytonaSandboxError(this.message, [this.statusCode]);
}

/// Error during Claude Code execution inside the sandbox.
final class DaytonaExecutionError extends DaytonaClaudeCodeResult {
  final String message;
  final String? stderr;
  final int? exitCode;

  const DaytonaExecutionError(this.message, {this.stderr, this.exitCode});
}

/// Generated HTML/CSS files not found after execution.
final class DaytonaFileNotFoundError extends DaytonaClaudeCodeResult {
  final String message;
  final List<String> searchedPaths;

  const DaytonaFileNotFoundError(this.message, this.searchedPaths);
}

/// Operation timed out.
final class DaytonaTimeoutError extends DaytonaClaudeCodeResult {
  final Duration timeout;
  final String phase;

  const DaytonaTimeoutError(this.timeout, this.phase);
}

/// Network or connection error.
final class DaytonaNetworkError extends DaytonaClaudeCodeResult {
  final String message;
  final Object? originalError;

  const DaytonaNetworkError(this.message, [this.originalError]);
}

/// File upload to sandbox failed.
final class DaytonaFileUploadError extends DaytonaClaudeCodeResult {
  final String message;
  final String fileName;

  const DaytonaFileUploadError(this.message, this.fileName);
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

/// Final result from Claude Code execution.
final class ResultEvent extends ClaudeStreamEvent {
  final bool success;
  final String? sessionId;
  final String? error;
  const ResultEvent(this.success, {this.sessionId, this.error});
}

// ============================================================================
// CALLBACK TYPES
// ============================================================================

/// Callback for Claude's thinking process (chain of thought / extended thinking).
typedef OnThinkingCallback = void Function(String thinking);

/// Callback for tool usage events.
typedef OnToolUseCallback = void Function(
  String toolName,
  Map<String, dynamic> input,
);

/// Callback for text output.
typedef OnTextCallback = void Function(String text);

/// Callback for raw stream events (for advanced usage).
typedef OnRawEventCallback = void Function(ClaudeStreamEvent event);

// ============================================================================
// TEMPLATE SCENARIO (what kind of generation we're doing)
// ============================================================================

/// Defines the scenario for template generation.
sealed class TemplateScenario {
  const TemplateScenario();

  /// Creating a brand new template (no existing HTML/CSS).
  const factory TemplateScenario.createNew({
    required String userPrompt,
    required String schemaJson,
    required String examplePayloadJson,
  }) = CreateNewTemplateScenario;

  /// Editing an existing template (has current HTML/CSS).
  const factory TemplateScenario.editExisting({
    required String userPrompt,
    required String schemaJson,
    required String examplePayloadJson,
    required String currentHtmlContent,
    required String currentCssContent,
  }) = EditExistingTemplateScenario;

  /// Changing the schema of an existing template.
  const factory TemplateScenario.changeSchema({
    required String userPrompt,
    required String currentSchemaJson,
    required String newSchemaJson,
    required String newExamplePayloadJson,
    required String currentHtmlContent,
    required String currentCssContent,
  }) = ChangeSchemaTemplateScenario;
}

/// Scenario: Creating a brand new template from scratch.
final class CreateNewTemplateScenario extends TemplateScenario {
  final String userPrompt;
  final String schemaJson;
  final String examplePayloadJson;

  const CreateNewTemplateScenario({
    required this.userPrompt,
    required this.schemaJson,
    required this.examplePayloadJson,
  });
}

/// Scenario: Editing an existing template's UI/layout.
final class EditExistingTemplateScenario extends TemplateScenario {
  final String userPrompt;
  final String schemaJson;
  final String examplePayloadJson;
  final String currentHtmlContent;
  final String currentCssContent;

  const EditExistingTemplateScenario({
    required this.userPrompt,
    required this.schemaJson,
    required this.examplePayloadJson,
    required this.currentHtmlContent,
    required this.currentCssContent,
  });
}

/// Scenario: Changing the data schema of an existing template.
final class ChangeSchemaTemplateScenario extends TemplateScenario {
  final String userPrompt;
  final String currentSchemaJson;
  final String newSchemaJson;
  final String newExamplePayloadJson;
  final String currentHtmlContent;
  final String currentCssContent;

  const ChangeSchemaTemplateScenario({
    required this.userPrompt,
    required this.currentSchemaJson,
    required this.newSchemaJson,
    required this.newExamplePayloadJson,
    required this.currentHtmlContent,
    required this.currentCssContent,
  });
}

// ============================================================================
// MAIN SERVICE CLASS
// ============================================================================

/// Service for generating Jinja2 HTML/CSS templates using Claude Code
/// running inside Daytona sandboxes.
///
/// ## Cost Optimization
///
/// Sandboxes are deleted immediately after results are retrieved.
/// Claude session IDs are persisted so conversations can be resumed
/// in new sandboxes without losing context.
///
/// ## Session Persistence Pattern
///
/// 1. Create sandbox -> Upload files -> Run Claude Code
/// 2. Capture Claude session ID from stream-json output
/// 3. Download generated HTML/CSS files
/// 4. Delete sandbox immediately (stop spending)
/// 5. Store session ID for later resumption
/// 6. On next message: Create new sandbox -> Resume with session ID
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
    this.apiUrl = kDaytonaApiBaseUrl,
    this.target = kDaytonaDefaultTarget,
    this.executionTimeout = kClaudeExecutionTimeout,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  // --------------------------------------------------------------------------
  // PUBLIC API
  // --------------------------------------------------------------------------

  /// Generates or modifies a Jinja2 template based on the given scenario.
  ///
  /// [scenario] - Defines what type of generation to perform.
  /// [previousSessionId] - Optional Claude session ID to resume from.
  /// [onThinking] - Callback for Claude's thinking/reasoning process.
  /// [onToolUse] - Callback when Claude uses a tool.
  /// [onText] - Callback for text output from Claude.
  /// [onRawEvent] - Callback for all parsed stream events.
  ///
  /// Returns [DaytonaClaudeCodeResult] sealed class with result or error.
  Future<DaytonaClaudeCodeResult> generateTemplate({
    required TemplateScenario scenario,
    String? previousSessionId,
    OnThinkingCallback? onThinking,
    OnToolUseCallback? onToolUse,
    OnTextCallback? onText,
    OnRawEventCallback? onRawEvent,
  }) async {
    String? sandboxId;
    final thinkingBlocks = <String>[];
    final textBuffer = StringBuffer();
    String? capturedSessionId;

    try {
      // Step 1: Create sandbox
      final createResult = await _createSandbox();
      if (createResult.error != null) {
        return DaytonaSandboxError(
          createResult.error!,
          createResult.statusCode,
        );
      }
      sandboxId = createResult.sandboxId!;

      // Step 2: Wait for sandbox to be ready
      final isReady = await _waitForSandboxReady(sandboxId);
      if (!isReady) {
        return const DaytonaSandboxError(
          'Sandbox failed to reach ready state within timeout',
        );
      }

      // Step 3: Upload files to sandbox based on scenario
      final uploadError = await _uploadFilesForScenario(sandboxId, scenario);
      if (uploadError != null) {
        return uploadError;
      }

      // Step 4: Install Claude Code CLI
      final installResult = await _executeCommand(
        sandboxId,
        'npm install -g @anthropic-ai/claude-code',
      );
      if (installResult.exitCode != 0) {
        return DaytonaExecutionError(
          'Failed to install Claude Code CLI',
          stderr: installResult.stderr,
          exitCode: installResult.exitCode,
        );
      }

      // Step 5: Build the prompt based on scenario
      final prompt = _buildPromptForScenario(scenario);

      // Step 6: Run Claude Code with streaming
      final claudeResult = await _runClaudeCode(
        sandboxId,
        prompt: prompt,
        previousSessionId: previousSessionId,
        onData: (data) {
          _parseStreamJsonLine(
            data,
            onThinking: (thinking) {
              thinkingBlocks.add(thinking);
              onThinking?.call(thinking);
            },
            onToolUse: onToolUse,
            onText: (text) {
              textBuffer.write(text);
              onText?.call(text);
            },
            onSessionId: (id) {
              capturedSessionId = id;
            },
            onRawEvent: onRawEvent,
          );
        },
      );

      if (!claudeResult.success) {
        return DaytonaExecutionError(
          'Claude Code execution failed',
          stderr: claudeResult.error,
          exitCode: claudeResult.exitCode,
        );
      }

      // Step 7: Retrieve generated HTML and CSS files
      final htmlContent = await _downloadFileFromSandbox(
        sandboxId,
        kFileNameHtml,
      );
      final cssContent = await _downloadFileFromSandbox(
        sandboxId,
        kFileNameCss,
      );

      if (htmlContent == null || htmlContent.trim().isEmpty) {
        // Try alternative paths
        final altHtml = await _findAndDownloadFile(sandboxId, '*.html');
        if (altHtml == null) {
          return const DaytonaFileNotFoundError(
            'Generated HTML template not found in sandbox',
            [kFileNameHtml, '$kSandboxWorkDir/$kFileNameHtml'],
          );
        }
        final altCss = await _findAndDownloadFile(sandboxId, '*.css');
        return DaytonaSuccess(
          htmlContent: altHtml,
          cssContent: altCss ?? '',
          claudeSessionId: capturedSessionId,
          summaryText: textBuffer.toString(),
          thinkingBlocks: thinkingBlocks,
        );
      }

      return DaytonaSuccess(
        htmlContent: htmlContent,
        cssContent: cssContent ?? '',
        claudeSessionId: capturedSessionId,
        summaryText: textBuffer.toString(),
        thinkingBlocks: thinkingBlocks,
      );
    } on TimeoutException catch (e) {
      return DaytonaTimeoutError(
        executionTimeout,
        e.message ?? 'execution',
      );
    } on http.ClientException catch (e) {
      return DaytonaNetworkError('HTTP client error: ${e.message}', e);
    } catch (e) {
      return DaytonaNetworkError('Unexpected error: $e', e);
    } finally {
      // COST OPTIMIZATION: Always delete sandbox after getting results
      if (sandboxId != null) {
        await _deleteSandbox(sandboxId);
      }
    }
  }

  /// Disposes of the HTTP client. Call when the service is no longer needed.
  void dispose() => _httpClient.close();

  // --------------------------------------------------------------------------
  // FILE UPLOAD
  // --------------------------------------------------------------------------

  /// Uploads files to the sandbox based on the template scenario.
  Future<DaytonaClaudeCodeResult?> _uploadFilesForScenario(
    String sandboxId,
    TemplateScenario scenario,
  ) async {
    switch (scenario) {
      case CreateNewTemplateScenario():
        return _uploadFilesForCreate(sandboxId, scenario);
      case EditExistingTemplateScenario():
        return _uploadFilesForEdit(sandboxId, scenario);
      case ChangeSchemaTemplateScenario():
        return _uploadFilesForSchemaChange(sandboxId, scenario);
    }
  }

  /// Upload files for creating a new template.
  Future<DaytonaClaudeCodeResult?> _uploadFilesForCreate(
    String sandboxId,
    CreateNewTemplateScenario scenario,
  ) async {
    final filesToUpload = <String, String>{
      kFileNamePayloadExample: scenario.examplePayloadJson,
      kFileNameCurrentSchema: scenario.schemaJson,
      kFileNameUserPrompt: scenario.userPrompt,
    };
    return _uploadFiles(sandboxId, filesToUpload);
  }

  /// Upload files for editing an existing template.
  Future<DaytonaClaudeCodeResult?> _uploadFilesForEdit(
    String sandboxId,
    EditExistingTemplateScenario scenario,
  ) async {
    final filesToUpload = <String, String>{
      kFileNameHtml: scenario.currentHtmlContent,
      kFileNameCss: scenario.currentCssContent,
      kFileNamePayloadExample: scenario.examplePayloadJson,
      kFileNameCurrentSchema: scenario.schemaJson,
      kFileNameUserPrompt: scenario.userPrompt,
    };
    return _uploadFiles(sandboxId, filesToUpload);
  }

  /// Upload files for a schema change scenario.
  Future<DaytonaClaudeCodeResult?> _uploadFilesForSchemaChange(
    String sandboxId,
    ChangeSchemaTemplateScenario scenario,
  ) async {
    final filesToUpload = <String, String>{
      kFileNameHtml: scenario.currentHtmlContent,
      kFileNameCss: scenario.currentCssContent,
      kFileNamePayloadExample: scenario.newExamplePayloadJson,
      kFileNameCurrentSchema: scenario.currentSchemaJson,
      kFileNameNewTargetSchema: scenario.newSchemaJson,
      kFileNameUserPrompt: scenario.userPrompt,
    };
    return _uploadFiles(sandboxId, filesToUpload);
  }

  /// Uploads a map of fileName -> content to the sandbox.
  Future<DaytonaClaudeCodeResult?> _uploadFiles(
    String sandboxId,
    Map<String, String> files,
  ) async {
    for (final entry in files.entries) {
      final error = await _uploadFileToSandbox(
        sandboxId,
        fileName: entry.key,
        content: entry.value,
      );
      if (error != null) {
        return error;
      }
    }
    return null; // All uploads successful
  }

  // --------------------------------------------------------------------------
  // PROMPT GENERATION
  // --------------------------------------------------------------------------

  /// Builds the complete prompt for Claude Code based on the scenario.
  String _buildPromptForScenario(TemplateScenario scenario) {
    switch (scenario) {
      case CreateNewTemplateScenario():
        return _buildCreateNewPrompt(scenario);
      case EditExistingTemplateScenario():
        return _buildEditExistingPrompt(scenario);
      case ChangeSchemaTemplateScenario():
        return _buildChangeSchemaPrompt(scenario);
    }
  }

  /// Prompt for creating a brand new Jinja2 template.
  String _buildCreateNewPrompt(CreateNewTemplateScenario scenario) {
    return '''
You are a Jinja2 template expert. Your task is to create a professional HTML/CSS template for PDF generation.

## Context

The user wants to create a new Jinja2 HTML/CSS template from scratch.
Read the following uploaded files to understand the requirements:

- @$kFileNameUserPrompt - The user's description of what they want
- @$kFileNamePayloadExample - An example JSON payload that will be passed to the template
- @$kFileNameCurrentSchema - The JSON schema defining the structure of the payload

## Your Task

1. Read @$kFileNameUserPrompt to understand what the user wants
2. Read @$kFileNameCurrentSchema to understand the available variables
3. Read @$kFileNamePayloadExample to see a real example of the data
4. Create the HTML template file (@$kFileNameHtml) using Jinja2 syntax
5. Create the CSS file (@$kFileNameCss) with professional styling

$kCommonPromptInstructions

$kFinalSummaryInstruction
''';
  }

  /// Prompt for editing an existing template.
  String _buildEditExistingPrompt(EditExistingTemplateScenario scenario) {
    return '''
You are a Jinja2 template expert. Your task is to modify an existing HTML/CSS template for PDF generation.

## Context

The user wants to edit an existing Jinja2 HTML/CSS template.
Read the following uploaded files:

- @$kFileNameUserPrompt - The user's description of changes they want
- @$kFileNameHtml - The current HTML template (Jinja2)
- @$kFileNameCss - The current CSS styles
- @$kFileNamePayloadExample - An example JSON payload
- @$kFileNameCurrentSchema - The JSON schema for the payload

## Your Task

1. Read @$kFileNameUserPrompt to understand what changes the user wants
2. Read the current @$kFileNameHtml and @$kFileNameCss to understand the existing template
3. Read @$kFileNameCurrentSchema to understand available variables
4. Modify the HTML and/or CSS according to the user's request
5. Save the updated files as @$kFileNameHtml and @$kFileNameCss

IMPORTANT: Preserve all existing multi-language support. If you add new hardcoded strings, they must also support all languages.

$kCommonPromptInstructions

$kFinalSummaryInstruction
''';
  }

  /// Prompt for changing the schema of an existing template.
  String _buildChangeSchemaPrompt(ChangeSchemaTemplateScenario scenario) {
    return '''
You are a Jinja2 template expert. Your task is to update an existing HTML/CSS template to accommodate a new data schema.

## Context

The user is changing the data schema for their template. The template must be updated to work with the new schema while maintaining the overall design.

Read the following uploaded files:

- @$kFileNameUserPrompt - The user's description of the schema change and any other modifications
- @$kFileNameHtml - The current HTML template (Jinja2)
- @$kFileNameCss - The current CSS styles
- @$kFileNameCurrentSchema - The CURRENT/OLD schema (what the template currently uses)
- @$kFileNameNewTargetSchema - The NEW schema (what the template must now support)
- @$kFileNamePayloadExample - An example payload matching the NEW schema

## Your Task

1. Read @$kFileNameUserPrompt to understand the user's intent
2. Compare @$kFileNameCurrentSchema with @$kFileNameNewTargetSchema to understand what changed:
   - Identify new fields that need to be displayed
   - Identify removed fields that should be cleaned up
   - Identify renamed/restructured fields that need path updates
3. Read @$kFileNamePayloadExample to see how the new data looks
4. Update @$kFileNameHtml to:
   - Use the new variable names/paths from the new schema
   - Add sections for new fields
   - Remove references to deleted fields
   - Maintain existing design and multi-language support
5. Update @$kFileNameCss if new sections need styling
6. Save the updated files as @$kFileNameHtml and @$kFileNameCss

CRITICAL: Ensure NO references to old schema fields remain. The template must work entirely with the new schema.

$kCommonPromptInstructions

$kFinalSummaryInstruction
''';
  }

  // --------------------------------------------------------------------------
  // CLAUDE CODE EXECUTION
  // --------------------------------------------------------------------------

  /// Runs Claude Code in the sandbox with the given prompt.
  ///
  /// If [previousSessionId] is provided, resumes that session.
  /// Captures the new session ID from the stream output.
  Future<_ClaudeRunResult> _runClaudeCode(
    String sandboxId, {
    required String prompt,
    String? previousSessionId,
    required void Function(String data) onData,
  }) async {
    // Escape the prompt for shell usage
    final escapedPrompt = _escapeForShell(prompt);

    // Build the Claude Code command
    final resumeFlag = previousSessionId != null
        ? '--resume $previousSessionId'
        : '';

    final command = '''
cd $kSandboxWorkDir && \\
export ANTHROPIC_API_KEY=$anthropicApiKey && \\
claude --dangerously-skip-permissions \\
  -p '$escapedPrompt' \\
  --model $kDaytonaClaudeModel \\
  --output-format stream-json \\
  --verbose \\
  $resumeFlag
''';

    final result = await _executeCommand(
      sandboxId,
      command,
      timeout: executionTimeout,
    );

    // Process the output through the callback
    if (result.stdout != null && result.stdout!.isNotEmpty) {
      onData(result.stdout!);
    }
    if (result.stderr != null && result.stderr!.isNotEmpty) {
      // stderr might contain session info or warnings
      onData(result.stderr!);
    }

    return _ClaudeRunResult(
      success: result.exitCode == 0,
      output: result.stdout,
      error: result.stderr,
      exitCode: result.exitCode,
    );
  }

  // --------------------------------------------------------------------------
  // STREAM JSON PARSER
  // --------------------------------------------------------------------------

  /// Parses Claude Code stream-json output and dispatches to callbacks.
  void _parseStreamJsonLine(
    String data, {
    OnThinkingCallback? onThinking,
    OnToolUseCallback? onToolUse,
    OnTextCallback? onText,
    void Function(String sessionId)? onSessionId,
    OnRawEventCallback? onRawEvent,
  }) {
    final lines = data.split('\n');

    for (final line in lines) {
      if (line.trim().isEmpty) continue;

      try {
        final json = jsonDecode(line.trim()) as Map<String, dynamic>;
        final event = _parseJsonEvent(json);

        // Check for session_id in system/init messages
        _extractSessionId(json, onSessionId);

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
              break;
          }
        }
      } catch (_) {
        // Not valid JSON - might be regular terminal output
        final trimmed = line.trim();
        if (trimmed.isNotEmpty && !trimmed.startsWith('{')) {
          onText?.call(trimmed);
        }
      }
    }
  }

  /// Extracts session_id from Claude Code stream-json system messages.
  void _extractSessionId(
    Map<String, dynamic> json,
    void Function(String sessionId)? onSessionId,
  ) {
    if (onSessionId == null) return;

    // Session ID can appear in different message types
    final type = json['type'] as String?;

    if (type == 'system' || type == 'init') {
      final sessionId = json['session_id'] as String?;
      if (sessionId != null) {
        onSessionId(sessionId);
      }
    }

    // Also check in the 'message' field for system subtype init
    final subtype = json['subtype'] as String?;
    if (subtype == 'init') {
      final sessionId = json['session_id'] as String?;
      if (sessionId != null) {
        onSessionId(sessionId);
      }
    }

    // Check top-level session_id field
    if (json.containsKey('session_id') && json['session_id'] is String) {
      final sessionId = json['session_id'] as String;
      if (sessionId.isNotEmpty) {
        onSessionId(sessionId);
      }
    }
  }

  /// Parses a single JSON event from the stream.
  ClaudeStreamEvent? _parseJsonEvent(Map<String, dynamic> json) {
    final type = json['type'] as String?;

    switch (type) {
      case 'assistant':
        final message = json['message'] as Map<String, dynamic>?;
        final content = message?['content'] as List?;
        if (content != null) {
          for (final block in content) {
            if (block is Map<String, dynamic>) {
              final blockType = block['type'] as String?;
              if (blockType == 'thinking') {
                final thinking = block['thinking'] as String?;
                if (thinking != null) return ThinkingEvent(thinking);
              } else if (blockType == 'text') {
                final text = block['text'] as String?;
                if (text != null) return TextEvent(text);
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
          if (thinking != null) return ThinkingEvent(thinking);
        } else if (deltaType == 'text_delta') {
          final text = delta?['text'] as String?;
          if (text != null) return TextEvent(text);
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
        final sessionId = json['session_id'] as String?;
        final error = json['error'] as String?;
        return ResultEvent(success, sessionId: sessionId, error: error);

      default:
        return null;
    }
  }

  // --------------------------------------------------------------------------
  // SANDBOX MANAGEMENT
  // --------------------------------------------------------------------------

  /// Creates a new Daytona sandbox configured for Claude Code execution.
  Future<_SandboxCreateResult> _createSandbox() async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse('$apiUrl/sandbox'),
            headers: _headers,
            body: jsonEncode({
              'image': kSandboxImage,
              'envVars': {'ANTHROPIC_API_KEY': anthropicApiKey},
              'resources': {
                'cpu': kSandboxCpu,
                'memory': kSandboxMemoryGb,
                'disk': kSandboxDiskGb,
              },
              'autoStopInterval': kAutoStopIntervalMinutes,
              'autoArchiveInterval': kAutoArchiveIntervalMinutes,
              'autoDeleteInterval': kAutoDeleteIntervalMinutes,
              'target': target,
              'labels': {'purpose': 'jinja2-template-generation'},
            }),
          )
          .timeout(kSandboxCreationTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final sandboxId = data['id'] as String? ?? data['name'] as String?;
        if (sandboxId == null) {
          return _SandboxCreateResult(
            error: 'No sandbox ID in response: ${response.body}',
          );
        }
        return _SandboxCreateResult(sandboxId: sandboxId);
      }
      return _SandboxCreateResult(
        error: 'HTTP ${response.statusCode}: ${response.body}',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return _SandboxCreateResult(error: 'Failed to create sandbox: $e');
    }
  }

  /// Waits for the sandbox to reach a running state.
  Future<bool> _waitForSandboxReady(String sandboxId) async {
    for (var i = 0; i < kMaxSandboxPollAttempts; i++) {
      try {
        final response = await _httpClient.get(
          Uri.parse('$apiUrl/sandbox/$sandboxId'),
          headers: _headers,
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final state = (data['state'] as String?)?.toLowerCase();
          if (state == 'running' || state == 'started' || state == 'ready') {
            return true;
          }
          if (state == 'error' || state == 'failed' || state == 'stopped') {
            return false;
          }
        }
      } catch (_) {
        // Continue polling
      }
      await Future.delayed(kSandboxPollInterval);
    }
    return false;
  }

  /// Deletes a sandbox. Fails silently on errors (best-effort cleanup).
  Future<void> _deleteSandbox(String sandboxId) async {
    try {
      await _httpClient
          .delete(
            Uri.parse('$apiUrl/sandbox/$sandboxId'),
            headers: _headers,
          )
          .timeout(kSandboxDeletionTimeout);
    } catch (_) {
      // Best-effort cleanup - sandbox will auto-delete anyway
    }
  }

  // --------------------------------------------------------------------------
  // FILE OPERATIONS
  // --------------------------------------------------------------------------

  /// Uploads a single file to the sandbox.
  Future<DaytonaClaudeCodeResult?> _uploadFileToSandbox(
    String sandboxId, {
    required String fileName,
    required String content,
  }) async {
    try {
      final filePath = '$kSandboxWorkDir/$fileName';
      final response = await _httpClient
          .post(
            Uri.parse('$apiUrl/toolbox/$sandboxId/toolbox/files/upload'),
            headers: _headers,
            body: jsonEncode({
              'path': filePath,
              'content': base64Encode(utf8.encode(content)),
            }),
          )
          .timeout(kFileUploadTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return null; // Success
      }

      // Fallback: Try using exec to write the file
      final escapedContent = _escapeForShell(content);
      final writeResult = await _executeCommand(
        sandboxId,
        "mkdir -p $kSandboxWorkDir && cat > $filePath << 'HEREDOC_EOF'\n$escapedContent\nHEREDOC_EOF",
      );

      if (writeResult.exitCode != 0) {
        return DaytonaFileUploadError(
          'Failed to upload file: HTTP ${response.statusCode}. '
          'Fallback also failed: ${writeResult.stderr}',
          fileName,
        );
      }
      return null; // Fallback succeeded
    } catch (e) {
      // Try exec-based fallback on exception
      try {
        final filePath = '$kSandboxWorkDir/$fileName';
        final escapedContent = content
            .replaceAll('\\', '\\\\')
            .replaceAll("'", "'\\''");
        final writeResult = await _executeCommand(
          sandboxId,
          "mkdir -p $kSandboxWorkDir && printf '%s' '$escapedContent' > $filePath",
        );
        if (writeResult.exitCode == 0) return null;
      } catch (_) {
        // Both methods failed
      }
      return DaytonaFileUploadError(
        'Failed to upload file: $e',
        fileName,
      );
    }
  }

  /// Downloads a file from the sandbox by file name.
  Future<String?> _downloadFileFromSandbox(
    String sandboxId,
    String fileName,
  ) async {
    final paths = [
      '$kSandboxWorkDir/$fileName',
      '/home/daytona/$fileName',
      fileName,
      './$fileName',
    ];

    for (final path in paths) {
      final content = await _downloadFile(sandboxId, path);
      if (content != null && content.trim().isNotEmpty) {
        return content;
      }
    }
    return null;
  }

  /// Finds and downloads the first file matching a glob pattern.
  Future<String?> _findAndDownloadFile(
    String sandboxId,
    String pattern,
  ) async {
    final findResult = await _executeCommand(
      sandboxId,
      'find $kSandboxWorkDir -name "$pattern" -type f 2>/dev/null | head -3',
    );
    if (findResult.exitCode == 0 && findResult.stdout?.isNotEmpty == true) {
      for (final file in findResult.stdout!
          .split('\n')
          .where((f) => f.trim().isNotEmpty)) {
        final content = await _downloadFile(sandboxId, file.trim());
        if (content != null && content.trim().isNotEmpty) {
          return content;
        }
      }
    }
    return null;
  }

  /// Downloads a file from the sandbox at a specific path.
  Future<String?> _downloadFile(String sandboxId, String path) async {
    try {
      // Try the toolbox download endpoint
      final uri = Uri.parse(
        '$apiUrl/toolbox/$sandboxId/toolbox/files/download',
      ).replace(queryParameters: {'path': path});

      final response = await _httpClient
          .get(uri, headers: _headers)
          .timeout(kFileDownloadTimeout);

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (_) {
      // Try fallback with cat command
    }

    // Fallback: Use exec to cat the file
    try {
      final catResult = await _executeCommand(sandboxId, 'cat "$path"');
      if (catResult.exitCode == 0 && catResult.stdout != null) {
        return catResult.stdout;
      }
    } catch (_) {
      // File not found at this path
    }
    return null;
  }

  // --------------------------------------------------------------------------
  // COMMAND EXECUTION
  // --------------------------------------------------------------------------

  /// Executes a command in the sandbox and returns the result.
  Future<_CommandResult> _executeCommand(
    String sandboxId,
    String command, {
    Duration? timeout,
  }) async {
    final effectiveTimeout = timeout ?? kDefaultCommandExecutionTimeout;
    try {
      final response = await _httpClient
          .post(
            Uri.parse(
              '$apiUrl/toolbox/$sandboxId/toolbox/process/execute',
            ),
            headers: _headers,
            body: jsonEncode({
              'command': command,
              'timeout': effectiveTimeout.inSeconds,
            }),
          )
          .timeout(effectiveTimeout + kCommandExecutionHttpBuffer);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _CommandResult(
          exitCode: data['exitCode'] as int? ?? data['exit_code'] as int? ?? -1,
          stdout: data['stdout'] as String? ?? data['result'] as String?,
          stderr: data['stderr'] as String?,
        );
      }
      return _CommandResult(
        exitCode: -1,
        stderr: 'HTTP ${response.statusCode}: ${response.body}',
      );
    } catch (e) {
      return _CommandResult(exitCode: -1, stderr: e.toString());
    }
  }

  // --------------------------------------------------------------------------
  // UTILITY
  // --------------------------------------------------------------------------

  /// Escapes a string for safe shell usage.
  String _escapeForShell(String input) {
    return input
        .replaceAll('\\', '\\\\')
        .replaceAll("'", "'\\''")
        .replaceAll('\$', '\\\$')
        .replaceAll('`', '\\`');
  }

  /// HTTP headers for Daytona API requests.
  Map<String, String> get _headers => {
    'Authorization': 'Bearer $daytonaApiKey',
    'Content-Type': 'application/json',
  };
}

// ============================================================================
// INTERNAL TYPES
// ============================================================================

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

class _ClaudeRunResult {
  final bool success;
  final String? output;
  final String? error;
  final int exitCode;

  _ClaudeRunResult({
    required this.success,
    this.output,
    this.error,
    this.exitCode = 0,
  });
}
