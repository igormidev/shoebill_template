import 'dart:convert';

import 'package:shoebill_template_server/src/core/utils/consts.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';
import 'package:shoebill_template_server/src/services/ai_services.dart';

// ============================================================================
// REVIEW SCENARIO ENUM
// ============================================================================

/// Defines the three scenarios under which a template review can occur.
enum ReviewScenario {
  /// Creating a brand new template from scratch.
  /// No previous HTML/CSS exists; we are generating for the first time.
  creatingNew,

  /// Editing an existing template's UI (HTML/CSS changes only).
  /// Schema remains unchanged; only visual/layout modifications.
  editingExisting,

  /// Schema has changed, requiring template adaptation.
  /// Both old and new schemas are compared; template must use new fields
  /// and stop referencing removed ones.
  schemaChange,
}

// ============================================================================
// SEALED REVIEW RESULT CLASSES
// ============================================================================

/// Base sealed class for template review outcomes.
sealed class ReviewResult {
  const ReviewResult();
}

/// The template passed review and is approved for deployment.
final class ReviewApproved extends ReviewResult {
  /// User-friendly summary of what was validated.
  final String feedbackForUser;

  const ReviewApproved({required this.feedbackForUser});
}

/// The template failed review and needs corrections.
final class ReviewRejected extends ReviewResult {
  /// Detailed technical feedback for Claude Code to fix the issues.
  final String feedbackForClaude;

  /// User-friendly explanation of what is being fixed.
  final String feedbackForUser;

  /// Specific list of issues found during review.
  final List<String> issues;

  const ReviewRejected({
    required this.feedbackForClaude,
    required this.feedbackForUser,
    required this.issues,
  });
}

/// The review process itself failed (API error, timeout, etc.).
final class ReviewError extends ReviewResult {
  /// Description of what went wrong during the review process.
  final String errorMessage;

  /// Number of retry attempts that were made before failure.
  final int attemptsMade;

  const ReviewError({required this.errorMessage, required this.attemptsMade});
}

// ============================================================================
// REVIEW STREAM EVENT
// ============================================================================

/// Events emitted during the review process for real-time feedback.
sealed class ReviewStreamEvent {
  const ReviewStreamEvent();
}

/// A thinking chunk from the reviewer AI during analysis.
final class ReviewThinkingEvent extends ReviewStreamEvent {
  final AiThinkingChunk thinkingChunk;
  const ReviewThinkingEvent(this.thinkingChunk);
}

/// The final review result has been determined.
final class ReviewCompleteEvent extends ReviewStreamEvent {
  final ReviewResult result;
  const ReviewCompleteEvent(this.result);
}

/// A status message about what the reviewer is currently doing.
final class ReviewStatusEvent extends ReviewStreamEvent {
  final String message;
  const ReviewStatusEvent(this.message);
}

// ============================================================================
// TEMPLATE REVIEWER SERVICE
// ============================================================================

/// Service responsible for validating Claude Code generated HTML/CSS templates.
///
/// This service acts as a "reviewer AI" that checks whether the generated
/// Jinja2 templates meet the user's requirements, follow proper syntax,
/// support multi-language, use correct schema variables, and adhere to
/// the project's conventions (Noto Sans CJK font, language conditionals, etc.).
///
/// ## Usage Example:
/// ```dart
/// final reviewer = TemplateReviewerService(openAiService: myOpenAiService);
///
/// // For a new template:
/// await for (final event in reviewer.reviewTemplateStream(
///   htmlContent: generatedHtml,
///   cssContent: generatedCss,
///   userPrompt: 'Create an invoice template with header and footer',
///   schema: mySchema,
///   scenario: ReviewScenario.creatingNew,
/// )) {
///   switch (event) {
///     case ReviewThinkingEvent(:final thinkingChunk):
///       print('Thinking: ${thinkingChunk.thinkingText}');
///     case ReviewStatusEvent(:final message):
///       print('Status: $message');
///     case ReviewCompleteEvent(:final result):
///       // Handle final result
///       break;
///   }
/// }
/// ```
///
/// ## Integration with Chat Flow:
/// After Daytona Claude Code generates HTML/CSS, call [reviewTemplate] or
/// [reviewTemplateStream]. If [ReviewRejected] is returned, feed the
/// [feedbackForClaude] back to the Daytona instance for corrections.
/// Repeat up to [kMaxReviewRetryAttempts] times.
class TemplateReviewerService {
  final IOpenAiService _openAiService;

  TemplateReviewerService({required IOpenAiService openAiService})
    : _openAiService = openAiService;

  // ==========================================================================
  // PUBLIC API
  // ==========================================================================

  /// Reviews a template and returns the result directly.
  ///
  /// This is a convenience method that collects the stream and returns
  /// only the final [ReviewResult]. Use [reviewTemplateStream] if you need
  /// real-time thinking chunks for UI display.
  Future<ReviewResult> reviewTemplate({
    required String htmlContent,
    required String cssContent,
    required String userPrompt,
    required SchemaDefinition schema,
    required ReviewScenario scenario,
    String? previousHtml,
    String? previousCss,
    SchemaDefinition? previousSchema,
  }) async {
    ReviewResult? finalResult;

    await for (final event in reviewTemplateStream(
      htmlContent: htmlContent,
      cssContent: cssContent,
      userPrompt: userPrompt,
      schema: schema,
      scenario: scenario,
      previousHtml: previousHtml,
      previousCss: previousCss,
      previousSchema: previousSchema,
    )) {
      if (event is ReviewCompleteEvent) {
        finalResult = event.result;
      }
    }

    return finalResult ??
        const ReviewError(
          errorMessage: 'Review stream completed without producing a result.',
          attemptsMade: 0,
        );
  }

  /// Reviews a template with streaming support for real-time feedback.
  ///
  /// Yields [ReviewThinkingEvent] for AI thinking chunks (to display in UI),
  /// [ReviewStatusEvent] for status updates, and finally [ReviewCompleteEvent]
  /// with the definitive result.
  ///
  /// The review process:
  /// 1. First validates HTML/CSS syntax (basic structural check)
  /// 2. Then performs AI-powered comprehensive review
  /// 3. Returns structured result with approval/rejection and feedback
  Stream<ReviewStreamEvent> reviewTemplateStream({
    required String htmlContent,
    required String cssContent,
    required String userPrompt,
    required SchemaDefinition schema,
    required ReviewScenario scenario,
    String? previousHtml,
    String? previousCss,
    SchemaDefinition? previousSchema,
  }) async* {
    // Step 1: Basic HTML/CSS syntax validation
    yield const ReviewStatusEvent(
      'Performing initial HTML/CSS syntax validation...',
    );

    final syntaxErrors = _validateHtmlCssSyntax(htmlContent, cssContent);
    if (syntaxErrors.isNotEmpty) {
      yield ReviewCompleteEvent(
        ReviewRejected(
          feedbackForClaude: _buildSyntaxErrorFeedbackForClaude(syntaxErrors),
          feedbackForUser:
              'The generated template has syntax errors that need to be fixed before further review.',
          issues: syntaxErrors,
        ),
      );
      return;
    }

    yield const ReviewStatusEvent(
      'Syntax validation passed. Starting AI-powered comprehensive review...',
    );

    // Step 2: AI-powered comprehensive review
    final prompt = _buildReviewPrompt(
      htmlContent: htmlContent,
      cssContent: cssContent,
      userPrompt: userPrompt,
      schema: schema,
      scenario: scenario,
      previousHtml: previousHtml,
      previousCss: previousCss,
      previousSchema: previousSchema,
    );

    final reviewSchema = _buildReviewResponseSchema();

    try {
      await for (final streamItem
          in _openAiService.streamPromptGenerationWithSchemaResponse(
        prompt: prompt,
        properties: reviewSchema,
        model: kReviewerModel,
        maxRetries: kAiServiceDefaultRetryCount,
      )) {
        switch (streamItem) {
          case AiThinkItem(:final thinkingChunk):
            yield ReviewThinkingEvent(thinkingChunk);
          case AiSchemaThinkItem(:final thinkingChunk):
            yield ReviewThinkingEvent(thinkingChunk);
          case AiSchemaResultItem(:final result):
            yield ReviewCompleteEvent(_parseReviewResponse(result));
          case AiResultItem():
            // Intermediate text chunks are not relevant for schema responses
            break;
        }
      }
    } catch (e) {
      yield ReviewCompleteEvent(
        ReviewError(
          errorMessage:
              'AI review failed: $e',
          attemptsMade: 1,
        ),
      );
    }
  }

  // ==========================================================================
  // SYNTAX VALIDATION
  // ==========================================================================

  /// Performs basic structural validation of HTML and CSS content.
  ///
  /// This is not a full W3C validator, but catches common structural issues
  /// that would prevent the template from rendering correctly.
  List<String> _validateHtmlCssSyntax(String html, String css) {
    final errors = <String>[];

    // --- HTML Validation ---
    if (html.trim().isEmpty) {
      errors.add('HTML content is empty.');
      return errors;
    }

    // Check for basic HTML structure
    if (!html.contains('<html') && !html.contains('<!DOCTYPE')) {
      // Jinja2 templates might not always have full HTML structure,
      // but they should at least have some HTML tags
      if (!html.contains('<') || !html.contains('>')) {
        errors.add(
          'HTML content does not appear to contain valid HTML markup.',
        );
      }
    }

    // Check for unclosed critical tags
    final criticalTags = ['html', 'head', 'body', 'table', 'div', 'style'];
    for (final tag in criticalTags) {
      final openCount = RegExp('<$tag[\\s>]', caseSensitive: false)
          .allMatches(html)
          .length;
      final closeCount = RegExp('</$tag>', caseSensitive: false)
          .allMatches(html)
          .length;
      // Self-closing tags and Jinja blocks can cause mismatches,
      // so only flag severe discrepancies
      if (openCount > 0 && closeCount == 0 && tag != 'html' && tag != 'head') {
        errors.add(
          'HTML tag <$tag> appears to be opened $openCount time(s) but never closed.',
        );
      }
    }

    // Check for broken Jinja2 syntax (unclosed blocks)
    final jinja2OpenBlocks = RegExp(r'\{%\s*(?:if|for|block|macro)\b')
        .allMatches(html)
        .length;
    final jinja2EndBlocks = RegExp(r'\{%\s*end(?:if|for|block|macro)\b')
        .allMatches(html)
        .length;
    if (jinja2OpenBlocks > jinja2EndBlocks) {
      errors.add(
        'Jinja2 template has ${jinja2OpenBlocks - jinja2EndBlocks} unclosed '
        'block(s) ({% if/for/block/macro %} without matching {% end... %}).',
      );
    }

    // Check for unclosed Jinja2 expressions
    final openExpressions = '{{'.allMatches(html).length;
    final closeExpressions = '}}'.allMatches(html).length;
    if (openExpressions > closeExpressions) {
      errors.add(
        'Jinja2 template has ${openExpressions - closeExpressions} unclosed '
        'expression(s) ({{ without matching }}).',
      );
    }

    // --- CSS Validation ---
    if (css.trim().isEmpty) {
      errors.add('CSS content is empty.');
      return errors;
    }

    // Check for unbalanced braces in CSS
    final openBraces = '{'.allMatches(css).length;
    final closeBraces = '}'.allMatches(css).length;
    if (openBraces != closeBraces) {
      errors.add(
        'CSS has unbalanced braces: $openBraces opening vs $closeBraces closing.',
      );
    }

    // Check for obviously broken CSS (no selectors at all)
    if (!css.contains('{')) {
      errors.add(
        'CSS content does not contain any rule blocks (no { found).',
      );
    }

    return errors;
  }

  /// Builds detailed feedback for Claude Code when syntax errors are found.
  String _buildSyntaxErrorFeedbackForClaude(List<String> syntaxErrors) {
    final buffer = StringBuffer();
    buffer.writeln(
      'CRITICAL: The generated HTML/CSS has syntax errors that must be fixed:',
    );
    buffer.writeln();
    for (var i = 0; i < syntaxErrors.length; i++) {
      buffer.writeln('${i + 1}. ${syntaxErrors[i]}');
    }
    buffer.writeln();
    buffer.writeln('Please fix these syntax errors and regenerate the files.');
    buffer.writeln(
      'Ensure all HTML tags are properly closed, all Jinja2 blocks have '
      'matching end tags, and CSS braces are balanced.',
    );
    return buffer.toString();
  }

  // ==========================================================================
  // REVIEW PROMPT BUILDERS
  // ==========================================================================

  /// Builds the complete review prompt based on the scenario.
  String _buildReviewPrompt({
    required String htmlContent,
    required String cssContent,
    required String userPrompt,
    required SchemaDefinition schema,
    required ReviewScenario scenario,
    String? previousHtml,
    String? previousCss,
    SchemaDefinition? previousSchema,
  }) {
    final schemaJson = _schemaToJsonString(schema);

    return switch (scenario) {
      ReviewScenario.creatingNew => _buildNewTemplateReviewPrompt(
        htmlContent: htmlContent,
        cssContent: cssContent,
        userPrompt: userPrompt,
        schemaJson: schemaJson,
      ),
      ReviewScenario.editingExisting => _buildEditTemplateReviewPrompt(
        htmlContent: htmlContent,
        cssContent: cssContent,
        userPrompt: userPrompt,
        schemaJson: schemaJson,
        previousHtml: previousHtml ?? '',
        previousCss: previousCss ?? '',
      ),
      ReviewScenario.schemaChange => _buildSchemaChangeReviewPrompt(
        htmlContent: htmlContent,
        cssContent: cssContent,
        userPrompt: userPrompt,
        newSchemaJson: schemaJson,
        previousHtml: previousHtml ?? '',
        previousCss: previousCss ?? '',
        previousSchemaJson: previousSchema != null
            ? _schemaToJsonString(previousSchema)
            : '{}',
      ),
    };
  }

  // --------------------------------------------------------------------------
  // SHARED PROMPT SECTIONS
  // --------------------------------------------------------------------------

  /// Common instructions that apply to all review scenarios.
  static const String _commonReviewInstructions = '''
You are an expert template reviewer for a PDF generation SaaS platform. Your job is to thoroughly validate Jinja2 HTML/CSS templates that will be rendered into PDFs.

CRITICAL REVIEW CRITERIA (apply to ALL scenarios):

1. JINJA2 SYNTAX CORRECTNESS:
   - All Jinja2 expressions {{ variable }} must use correct syntax
   - All Jinja2 control blocks {% if/for/block %} must have matching {% endif/endfor/endblock %}
   - Variables referenced must exist in the provided schema
   - Filters used must be valid Jinja2 filters
   - No invalid syntax that is not valid Jinja2
   - Nested loops and conditions must be properly indented and closed
   - Check for proper use of {% set %}, {% macro %}, {% include %} if present

2. SCHEMA VARIABLE USAGE:
   - ALL variables used in the template ({{ var }}) must correspond to fields in the schema
   - Nested object access ({{ obj.field }}) must match the schema structure
   - Array iteration ({% for item in items %}) must reference array-type schema fields
   - Nullable fields should have appropriate {% if field %} guards
   - No undefined variables should be referenced
   - Type-appropriate usage (don't use string operations on integers, etc.)

3. MULTI-LANGUAGE SUPPORT:
   - ALL hardcoded strings (labels, headers, footers, static text) MUST have language conditionals
   - Language conditionals should use the pattern: {% if language == "en" %}English{% elif language == "ja" %}Japanese{% elif ... %}...{% endif %}
   - The template must support ALL languages from the SupportedLanguages enum:
     english, simplifiedMandarinChinese, traditionalChinese, spanish, french,
     brazilianPortuguese, portugalPortuguese, russian, ukrainian, polish,
     indonesian, malay, german, dutch, japanese, swahili, turkish, vietnamese,
     korean, italian, filipino, romanian, swedish, czech
   - The "language" variable is always available in the template context
   - Payload strings marked with shouldBeTranslated are handled externally (already translated before reaching the template)
   - Only HARDCODED strings in the template itself need language conditionals

4. FONT USAGE:
   - The template MUST use "Noto Sans CJK" as the default font family
   - CSS must include proper font-family declarations with Noto Sans CJK
   - Font weights should be properly specified (100-900 or named weights)
   - Fallback fonts should be appropriate (sans-serif as fallback)

5. HTML/CSS QUALITY:
   - Valid HTML5 structure (doctype, html, head, body)
   - CSS should be well-organized and not contain dead/unused rules
   - Responsive considerations for PDF rendering (fixed widths appropriate for A4/Letter)
   - No external resource references (all styles inline or in the CSS file)
   - No JavaScript (PDFs don't support scripts)
   - Proper use of CSS for page breaks (@page, page-break-before/after)
   - Print-friendly styling (no screen-only media queries)

6. PDF-SPECIFIC REQUIREMENTS:
   - Page size and margins should be properly set via @page CSS rule
   - Headers and footers should use appropriate CSS (fixed positioning or @page margins)
   - Content should not overflow page boundaries
   - Tables should handle page breaks gracefully
   - Images should use proper sizing to fit within page width

7. ACCESSIBILITY AND ENCODING:
   - UTF-8 charset declaration in the HTML head
   - Proper lang attribute on the html tag (should be dynamic based on language)
   - Alt attributes on images if any
   - Semantic HTML where appropriate (h1-h6, p, table, etc.)
''';

  /// Instructions for how the reviewer should format its response.
  static const String _responseFormatInstructions = '''
RESPONSE FORMAT:
You must respond with a JSON object containing these exact fields:
- "isApproved": boolean - true if the template passes ALL checks, false if ANY issue is found
- "feedbackForClaude": string - Detailed, technical feedback for Claude Code to fix issues.
  If approved, this should be "No issues found. Template is ready for deployment."
  If rejected, this should contain specific instructions on what to fix, with line references where possible.
- "feedbackForUser": string - A user-friendly explanation.
  If approved: "Your template has been validated and is ready to use."
  If rejected: Explain in simple terms what is being fixed (e.g., "I noticed the template is missing translations for some labels. The AI is fixing this now.")
- "issues": array of strings - Each string is a specific, actionable issue found.
  If approved, this should be an empty array [].
  Each issue should be self-contained and describe: what is wrong, where it is, and what the fix should be.

IMPORTANT REVIEW GUIDELINES:
- Be THOROUGH. Check every single variable reference against the schema.
- Be STRICT about multi-language support. Every single hardcoded string must have ALL language variants.
- Be PRACTICAL. Minor formatting preferences are not issues. Focus on correctness and functionality.
- DO NOT flag issues about things that are intentionally handled externally (like payload translation).
- If the template uses {{ variable }} and that variable exists in the schema with the correct type, it is CORRECT.
- Consider that the template will be rendered with Jinja2 in Dart, so ensure compatibility.
''';

  // --------------------------------------------------------------------------
  // PROMPT FOR CREATING NEW TEMPLATE
  // --------------------------------------------------------------------------

  String _buildNewTemplateReviewPrompt({
    required String htmlContent,
    required String cssContent,
    required String userPrompt,
    required String schemaJson,
  }) {
    return '''
$_commonReviewInstructions

REVIEW SCENARIO: CREATING A NEW TEMPLATE
You are reviewing a BRAND NEW template that was just generated from the user's specification.
This is the first version of this template - there is no previous version to compare against.

SPECIFIC CHECKS FOR NEW TEMPLATE CREATION:
1. Does the generated HTML/CSS match what the user asked for in their specification prompt?
   - Check if the page structure matches (number of pages, sections, layout)
   - Check if mentioned elements are present (tables, headers, footers, images, charts)
   - Check if the visual style matches the description (colors, fonts, spacing)
   - Check if all data fields mentioned by the user are included in the template

2. Is the template COMPLETE?
   - Does it have a proper HTML structure (DOCTYPE, html, head, body)?
   - Does it have CSS for page sizing (@page rule)?
   - Are all schema fields actually used somewhere in the template?
   - If the user mentioned headers/footers, are they implemented?

3. Are schema variables used CORRECTLY?
   - Each {{ variable }} must correspond to a schema field
   - Object traversal ({{ obj.nested.field }}) must match schema nesting
   - Arrays must be iterated with {% for %} loops
   - Nullable fields must have {% if %} guards

4. Is multi-language support COMPLETE?
   - Every hardcoded label, title, header text, footer text must have language conditionals
   - The language variable must be checked correctly
   - All 24 supported languages must be covered in each conditional block
   - Translations should be reasonable (not just the English text repeated)

USER'S SPECIFICATION PROMPT:
"""
$userPrompt
"""

SCHEMA DEFINITION (JSON):
The template must use these variables and ONLY these variables:
```json
$schemaJson
```

GENERATED HTML TEMPLATE:
```html
$htmlContent
```

GENERATED CSS:
```css
$cssContent
```

Now perform your thorough review. Think carefully about each criterion before making your judgment.
Remember: You must check EVERY variable reference against the schema, EVERY hardcoded string for language support, and EVERY structural requirement from the user's prompt.

$_responseFormatInstructions
''';
  }

  // --------------------------------------------------------------------------
  // PROMPT FOR EDITING EXISTING TEMPLATE
  // --------------------------------------------------------------------------

  String _buildEditTemplateReviewPrompt({
    required String htmlContent,
    required String cssContent,
    required String userPrompt,
    required String schemaJson,
    required String previousHtml,
    required String previousCss,
  }) {
    return '''
$_commonReviewInstructions

REVIEW SCENARIO: EDITING AN EXISTING TEMPLATE (UI-ONLY CHANGES)
You are reviewing changes made to an EXISTING template. The user requested specific UI modifications.
The schema has NOT changed - only the HTML/CSS should be different.

SPECIFIC CHECKS FOR TEMPLATE EDITING:
1. Were the user's requested changes ACTUALLY implemented?
   - Read the user's edit request carefully
   - Verify each requested change is reflected in the new HTML/CSS
   - Check that the changes are correct and complete (not partial implementations)

2. Were any UNINTENDED changes made?
   - Compare the old and new HTML/CSS carefully
   - Flag any changes that were NOT requested by the user
   - Structural changes that break existing functionality are critical issues
   - Removed features that were not asked to be removed are issues
   - Changed variable references are issues (schema did not change)

3. Is the schema still used correctly?
   - Since the schema did not change, all variable references should still be valid
   - No new variables should be introduced that don't exist in the schema
   - No existing variable references should be removed unless the user explicitly asked

4. Is multi-language support still intact?
   - Editing should not have broken any existing language conditionals
   - Any NEW hardcoded strings added must have language conditionals
   - Existing translations should not have been removed

5. Did the edit maintain template quality?
   - CSS changes should not break page layout
   - Font changes should still include Noto Sans CJK
   - Page structure (@page rules) should not be unintentionally modified

USER'S EDIT REQUEST:
"""
$userPrompt
"""

SCHEMA DEFINITION (unchanged - JSON):
```json
$schemaJson
```

PREVIOUS HTML TEMPLATE (before edit):
```html
$previousHtml
```

PREVIOUS CSS (before edit):
```css
$previousCss
```

NEW HTML TEMPLATE (after edit):
```html
$htmlContent
```

NEW CSS (after edit):
```css
$cssContent
```

Now perform your thorough review. Focus on:
1. Did the requested changes get implemented correctly?
2. Were any unintended side effects introduced?
3. Is everything that was working before still working?

$_responseFormatInstructions
''';
  }

  // --------------------------------------------------------------------------
  // PROMPT FOR SCHEMA CHANGE
  // --------------------------------------------------------------------------

  String _buildSchemaChangeReviewPrompt({
    required String htmlContent,
    required String cssContent,
    required String userPrompt,
    required String newSchemaJson,
    required String previousHtml,
    required String previousCss,
    required String previousSchemaJson,
  }) {
    return '''
$_commonReviewInstructions

REVIEW SCENARIO: SCHEMA CHANGE
You are reviewing a template that was modified because the SCHEMA changed.
This is a critical review because schema changes can break templates if not handled correctly.

A schema change means:
- New fields may have been added (these MUST be used in the template)
- Existing fields may have been removed (these MUST NOT be referenced anymore)
- Field types may have changed (template must use them correctly)
- Field nullability may have changed (guards may need to be added/removed)

SPECIFIC CHECKS FOR SCHEMA CHANGES:
1. Are ALL new schema fields used in the template?
   - Compare old schema vs new schema to identify added fields
   - Each new field should appear somewhere in the template ({{ new_field }})
   - New fields should be placed in logical positions within the template
   - New object fields need proper traversal
   - New array fields need iteration loops

2. Are removed schema fields NO LONGER referenced?
   - Compare old schema vs new schema to identify removed fields
   - CRITICAL: The template must NOT use {{ removed_field }} anywhere
   - Check both HTML and CSS for references to removed fields
   - Check inside Jinja2 control blocks ({% if removed_field %}, {% for x in removed_field %})
   - This is the most critical check - referencing removed fields will cause runtime errors

3. Are changed field types handled correctly?
   - If a field changed from string to array, it needs a for loop now
   - If a field changed from required to nullable, it needs an if guard
   - If a field changed from nullable to required, if guards can be removed (but are not harmful)
   - If a field type changed, template operations must match the new type

4. Is the template structure still logical?
   - New fields should be placed in semantically appropriate sections
   - The overall page layout should still make sense with the new data
   - Headers/footers should not contain data that belongs in the body
   - Tables should be restructured if columns were added/removed

5. Backward compatibility concerns:
   - This will create a NEW template version (old version remains unchanged)
   - The new version should be self-contained and work with the new schema only
   - No references to old schema structure should remain

6. Multi-language support for new content:
   - Any new hardcoded strings (labels for new fields) must have language conditionals
   - Existing language conditionals should be preserved
   - New section headers or labels need full 24-language support

USER'S CHANGE REQUEST:
"""
$userPrompt
"""

PREVIOUS SCHEMA (old - JSON):
```json
$previousSchemaJson
```

NEW SCHEMA (current - JSON):
```json
$newSchemaJson
```

PREVIOUS HTML TEMPLATE (before schema change):
```html
$previousHtml
```

PREVIOUS CSS (before schema change):
```css
$previousCss
```

NEW HTML TEMPLATE (after schema change):
```html
$htmlContent
```

NEW CSS (after schema change):
```css
$cssContent
```

SCHEMA DIFF ANALYSIS:
Please carefully compare the old and new schemas to identify:
- Fields that were ADDED (present in new but not in old)
- Fields that were REMOVED (present in old but not in new)
- Fields that were MODIFIED (type, nullability, or structure changed)

Then verify the template correctly handles ALL of these changes.

$_responseFormatInstructions
''';
  }

  // ==========================================================================
  // REVIEW RESPONSE SCHEMA
  // ==========================================================================

  /// Builds the structured response schema for the AI review.
  ///
  /// The schema ensures the AI returns a properly formatted response
  /// that can be parsed into [ReviewResult].
  Map<String, SchemaProperty> _buildReviewResponseSchema() {
    return {
      'isApproved': SchemaPropertyBoolean(
        nullable: false,
        description:
            'Whether the template passes all review checks and is approved for deployment. '
            'Set to true only if there are ZERO issues found.',
      ),
      'feedbackForClaude': SchemaPropertyString(
        nullable: false,
        shouldBeTranslated: false,
        description:
            'Detailed technical feedback for Claude Code. If approved, say "No issues found." '
            'If rejected, provide specific, actionable instructions on what to fix, '
            'referencing specific lines or sections of the template.',
      ),
      'feedbackForUser': SchemaPropertyString(
        nullable: false,
        shouldBeTranslated: false,
        description:
            'User-friendly explanation of the review result. Keep it concise and non-technical. '
            'If approved: "Your template has been validated and is ready to use." '
            'If rejected: Explain what is being fixed in simple terms.',
      ),
      'issues': SchemaPropertyArray(
        nullable: false,
        items: SchemaPropertyString(
          nullable: false,
          shouldBeTranslated: false,
          description: 'A specific, actionable issue found during review.',
        ),
        description:
            'Array of specific issues found. Empty array [] if approved. '
            'Each issue should describe: what is wrong, where it is, and what the fix should be.',
      ),
    };
  }

  // ==========================================================================
  // RESPONSE PARSING
  // ==========================================================================

  /// Parses the AI's structured response into a [ReviewResult].
  ReviewResult _parseReviewResponse(Map<String, dynamic> response) {
    try {
      final isApproved = response['isApproved'] as bool? ?? false;
      final feedbackForClaude =
          response['feedbackForClaude'] as String? ?? 'No feedback provided.';
      final feedbackForUser =
          response['feedbackForUser'] as String? ?? 'Review completed.';
      final issuesRaw = response['issues'] as List<dynamic>? ?? [];
      final issues = issuesRaw.map((e) => e.toString()).toList();

      if (isApproved) {
        return ReviewApproved(feedbackForUser: feedbackForUser);
      } else {
        return ReviewRejected(
          feedbackForClaude: feedbackForClaude,
          feedbackForUser: feedbackForUser,
          issues: issues,
        );
      }
    } catch (e) {
      return ReviewError(
        errorMessage: 'Failed to parse review response: $e',
        attemptsMade: 1,
      );
    }
  }

  // ==========================================================================
  // UTILITY METHODS
  // ==========================================================================

  /// Converts a [SchemaDefinition] to a formatted JSON string for prompt inclusion.
  String _schemaToJsonString(SchemaDefinition schema) {
    final schemaMap = <String, dynamic>{};
    for (final entry in schema.properties.entries) {
      schemaMap[entry.key] = _schemaPropertyToPromptJson(entry.value);
    }
    return const JsonEncoder.withIndent('  ').convert(schemaMap);
  }

  /// Converts a single [SchemaProperty] to a JSON-friendly map for prompt display.
  ///
  /// This provides more context than toSchemaJson() by including human-readable
  /// type information and descriptions that help the AI understand the structure.
  Map<String, dynamic> _schemaPropertyToPromptJson(SchemaProperty property) {
    final json = <String, dynamic>{
      'type': _schemaPropertyTypeName(property),
      'nullable': property.nullable,
    };

    if (property.description != null) {
      json['description'] = property.description;
    }

    switch (property) {
      case SchemaPropertyString(:final shouldBeTranslated):
        if (shouldBeTranslated) {
          json['shouldBeTranslated'] = true;
          json['note'] =
              'This string will be translated externally before reaching the template. '
              'Do NOT add language conditionals for this field.';
        }
      case SchemaPropertyEnum(:final enumValues):
        json['possibleValues'] = enumValues;
      case SchemaPropertyArray(:final items):
        json['items'] = _schemaPropertyToPromptJson(items);
      case SchemaPropertyStructuredObjectWithDefinedProperties(
        :final properties,
      ):
        json['properties'] = properties.map(
          (key, value) => MapEntry(key, _schemaPropertyToPromptJson(value)),
        );
      default:
        break;
    }

    return json;
  }

  /// Returns a human-readable type name for a schema property.
  String _schemaPropertyTypeName(SchemaProperty property) {
    return switch (property) {
      SchemaPropertyString() => 'string',
      SchemaPropertyInteger() => 'integer',
      SchemaPropertyDouble() => 'double',
      SchemaPropertyBoolean() => 'boolean',
      SchemaPropertyEnum() => 'enum',
      SchemaPropertyArray() => 'array',
      SchemaPropertyObjectWithUndefinedProperties() => 'dynamic_object',
      SchemaPropertyStructuredObjectWithDefinedProperties() =>
        'structured_object',
    };
  }
}
