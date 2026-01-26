import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/core/mixins/jinja_pdf_renderer_mixin.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';

/// POST endpoint that accepts HTML, CSS, payload JSON, and language,
/// then returns a rendered PDF for live preview in the chat interface.
///
/// This endpoint is designed for speed - it skips schema validation
/// (already handled elsewhere) and renders directly from the provided inputs.
///
/// **Request body (JSON):**
///   - `htmlContent` (string, required): The Jinja2 HTML template content
///   - `cssContent` (string, required): The CSS stylesheet content
///   - `payloadJson` (string, required): Stringified JSON payload for template variables
///   - `language` (string, required): A valid [SupportedLanguage] enum name
///
/// **Responses:**
///   - 200: PDF bytes with `application/pdf` content type and inline disposition
///   - 400: Missing/invalid parameters (JSON error response)
///   - 500: Rendering failure (JSON error response with details)
class PdfPreviewRoute extends Route with RouteMixin, JinjaPdfRendererMixin {
  PdfPreviewRoute() : super(methods: {Method.post});

  // ─── Field Name Constants ───────────────────────────────────────────────────
  static const String _kFieldHtmlContent = 'htmlContent';
  static const String _kFieldCssContent = 'cssContent';
  static const String _kFieldPayloadJson = 'payloadJson';
  static const String _kFieldLanguage = 'language';

  // ─── Size Limits ────────────────────────────────────────────────────────────
  /// Maximum allowed size for HTML content (1 MB).
  static const int _kMaxHtmlSizeBytes = 1024 * 1024;

  /// Maximum allowed size for CSS content (1 MB).
  static const int _kMaxCssSizeBytes = 1024 * 1024;

  // ─── Response Constants ─────────────────────────────────────────────────────
  static const String _kPreviewFilename = 'preview.pdf';

  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    // ─── 1. Parse Request Body ──────────────────────────────────────────
    final (requestData, bodyError) = await getPayload(request);
    if (bodyError != null) return bodyError;
    if (requestData == null) {
      return createErrorResponse(
        400,
        'Missing request body',
        'Request body is required. Send a JSON object with '
            '"$_kFieldHtmlContent", "$_kFieldCssContent", '
            '"$_kFieldPayloadJson", and "$_kFieldLanguage" fields.',
      );
    }

    // ─── 2. Validate Required String Fields ─────────────────────────────
    final htmlError = _validateRequiredStringField(
      requestData,
      _kFieldHtmlContent,
      'The Jinja2 HTML template',
    );
    if (htmlError != null) return htmlError;

    final cssError = _validateRequiredStringField(
      requestData,
      _kFieldCssContent,
      'The CSS stylesheet',
    );
    if (cssError != null) return cssError;

    final payloadJsonError = _validateRequiredStringField(
      requestData,
      _kFieldPayloadJson,
      'A stringified JSON object',
    );
    if (payloadJsonError != null) return payloadJsonError;

    final languageError = _validateRequiredStringField(
      requestData,
      _kFieldLanguage,
      'A valid SupportedLanguage enum name '
      '(e.g., "english", "spanish", "japanese")',
    );
    if (languageError != null) return languageError;

    final htmlContent = requestData[_kFieldHtmlContent] as String;
    final cssContent = requestData[_kFieldCssContent] as String;
    final payloadJson = requestData[_kFieldPayloadJson] as String;
    final language = requestData[_kFieldLanguage] as String;

    // ─── 3. Validate Size Limits ────────────────────────────────────────
    final htmlSizeError = _validateSizeLimit(
      htmlContent,
      _kFieldHtmlContent,
      _kMaxHtmlSizeBytes,
    );
    if (htmlSizeError != null) return htmlSizeError;

    final cssSizeError = _validateSizeLimit(
      cssContent,
      _kFieldCssContent,
      _kMaxCssSizeBytes,
    );
    if (cssSizeError != null) return cssSizeError;

    // ─── 4. Parse Payload JSON ──────────────────────────────────────────
    final (payload, payloadError) = _parseJsonObject(
      payloadJson,
      _kFieldPayloadJson,
    );
    if (payloadError != null) return payloadError;

    // ─── 5. Validate Language ───────────────────────────────────────────
    final SupportedLanguage? supportedLanguage = SupportedLanguage.values
        .firstWhereOrNull((lang) => lang.name == language);

    if (supportedLanguage == null) {
      final validValues = SupportedLanguage.values
          .map((e) => e.name)
          .join(', ');
      return createErrorResponse(
        400,
        'Invalid $_kFieldLanguage',
        'The language "$language" is not a valid SupportedLanguage value. '
            'Valid values are: $validValues.',
      );
    }

    // ─── 6. Render PDF ──────────────────────────────────────────────────
    try {
      final pdfBytes = await renderPdfFromJinja(
        htmlTemplate: htmlContent,
        cssContent: cssContent,
        payload: payload!,
        language: supportedLanguage,
      );

      final headers = Headers.build((h) {
        h.contentDisposition = ContentDispositionHeader(
          type: 'inline',
          parameters: [
            ContentDispositionParameter(
              name: 'filename',
              value: _kPreviewFilename,
            ),
          ],
        );
        h.cacheControl = CacheControlHeader(noStore: true);
      });

      return Response.ok(
        body: Body.fromData(
          pdfBytes,
          mimeType: MimeType.pdf,
        ),
        headers: headers,
      );
    } on ShoebillException catch (e) {
      return createErrorResponse(500, e.title, e.description);
    } catch (e) {
      return createErrorResponse(
        500,
        'PDF rendering failed',
        'An unexpected error occurred while rendering the PDF preview: $e',
      );
    }
  }

  // ─── Private Validation Helpers ─────────────────────────────────────────────

  /// Validates that [fieldName] exists in [data], is a [String], and is
  /// non-empty. Returns an error [Response] if validation fails, or `null`
  /// if the field is valid.
  ///
  /// [fieldDescription] is used in the error message to describe what the
  /// field should contain (e.g., "The Jinja2 HTML template").
  Response? _validateRequiredStringField(
    Map<String, dynamic> data,
    String fieldName,
    String fieldDescription,
  ) {
    final value = data[fieldName];
    if (value is! String || value.isEmpty) {
      return createErrorResponse(
        400,
        'Missing or invalid $fieldName',
        'The "$fieldName" field is required and must be a non-empty string '
            'containing: $fieldDescription.',
      );
    }
    return null;
  }

  /// Validates that [content] does not exceed [maxBytes] (measured in UTF-8).
  /// Returns an error [Response] if the limit is exceeded, or `null` if valid.
  Response? _validateSizeLimit(
    String content,
    String fieldName,
    int maxBytes,
  ) {
    final sizeInBytes = utf8.encode(content).length;
    if (sizeInBytes > maxBytes) {
      final maxMb = (maxBytes / (1024 * 1024)).toStringAsFixed(0);
      final actualKb = (sizeInBytes / 1024).toStringAsFixed(1);
      return createErrorResponse(
        400,
        'Content too large for $fieldName',
        'The "$fieldName" field exceeds the maximum allowed size of '
            '${maxMb}MB. Received ${actualKb}KB.',
      );
    }
    return null;
  }

  /// Attempts to parse [jsonString] as a JSON object (`Map<String, dynamic>`).
  /// Returns the parsed map on success, or an error [Response] if parsing
  /// fails or the result is not a JSON object.
  (Map<String, dynamic>?, Response?) _parseJsonObject(
    String jsonString,
    String fieldName,
  ) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        return (
          null,
          createErrorResponse(
            400,
            'Invalid $fieldName',
            'The "$fieldName" field must be a stringified JSON object '
                '(not an array, string, or primitive). '
                'Received type: ${decoded.runtimeType}.',
          ),
        );
      }
      return (decoded, null);
    } catch (e) {
      return (
        null,
        createErrorResponse(
          400,
          'Invalid $fieldName format',
          'Failed to parse "$fieldName" as JSON: $e. '
              'Ensure it is a properly stringified JSON object.',
        ),
      );
    }
  }
}
