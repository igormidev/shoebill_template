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
///   - `language` (string, required): A valid [SupportedLanguages] enum name
///
/// **Responses:**
///   - 200: PDF bytes with `application/pdf` content type and inline disposition
///   - 400: Missing/invalid parameters (JSON error response)
///   - 500: Rendering failure (JSON error response with details)
class PdfPreviewRoute extends Route with RouteMixin, JinjaPdfRendererMixin {
  PdfPreviewRoute() : super(methods: {Method.post});

  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    // ─── 1. Parse Request Body ──────────────────────────────────────────
    final body = await request.readAsString();
    if (body.isEmpty) {
      return createErrorResponse(
        400,
        'Missing request body',
        'Request body is required. Send a JSON object with '
            '"htmlContent", "cssContent", "payloadJson", and "language" fields.',
      );
    }

    final Map<String, dynamic> requestData;
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        return createErrorResponse(
          400,
          'Invalid request body',
          'Request body must be a JSON object.',
        );
      }
      requestData = decoded;
    } catch (e) {
      return createErrorResponse(
        400,
        'Invalid JSON',
        'Failed to parse request body as JSON: $e',
      );
    }

    // ─── 2. Validate Required Fields ────────────────────────────────────
    final htmlContent = requestData['htmlContent'];
    final cssContent = requestData['cssContent'];
    final payloadJson = requestData['payloadJson'];
    final language = requestData['language'];

    if (htmlContent is! String || htmlContent.isEmpty) {
      return createErrorResponse(
        400,
        'Missing or invalid htmlContent',
        'The "htmlContent" field is required and must be a non-empty string '
            'containing the Jinja2 HTML template.',
      );
    }

    if (cssContent is! String || cssContent.isEmpty) {
      return createErrorResponse(
        400,
        'Missing or invalid cssContent',
        'The "cssContent" field is required and must be a non-empty string '
            'containing the CSS stylesheet.',
      );
    }

    if (payloadJson is! String || payloadJson.isEmpty) {
      return createErrorResponse(
        400,
        'Missing or invalid payloadJson',
        'The "payloadJson" field is required and must be a non-empty string '
            'containing a stringified JSON object.',
      );
    }

    if (language is! String || language.isEmpty) {
      return createErrorResponse(
        400,
        'Missing or invalid language',
        'The "language" field is required and must be a valid '
            'SupportedLanguages enum name '
            '(e.g., "english", "spanish", "japanese").',
      );
    }

    // ─── 3. Parse Payload JSON ──────────────────────────────────────────
    final Map<String, dynamic> payload;
    try {
      final decoded = jsonDecode(payloadJson);
      if (decoded is! Map<String, dynamic>) {
        return createErrorResponse(
          400,
          'Invalid payloadJson',
          'The "payloadJson" field must be a stringified JSON object (not an '
              'array, string, or primitive). Received type: ${decoded.runtimeType}.',
        );
      }
      payload = decoded;
    } catch (e) {
      return createErrorResponse(
        400,
        'Invalid payloadJson format',
        'Failed to parse "payloadJson" as JSON: $e. '
            'Ensure it is a properly stringified JSON object.',
      );
    }

    // ─── 4. Validate Language ───────────────────────────────────────────
    final SupportedLanguages? supportedLanguage = SupportedLanguages.values
        .firstWhereOrNull((lang) => lang.name == language);

    if (supportedLanguage == null) {
      final validValues =
          SupportedLanguages.values.map((e) => e.name).join(', ');
      return createErrorResponse(
        400,
        'Invalid language',
        'The language "$language" is not a valid SupportedLanguages value. '
            'Valid values are: $validValues.',
      );
    }

    // ─── 5. Render PDF ──────────────────────────────────────────────────
    try {
      final pdfBytes = await renderPdfFromJinja(
        htmlTemplate: htmlContent,
        cssContent: cssContent,
        payload: payload,
        language: supportedLanguage,
      );

      final headers = Headers.build((h) {
        h.contentDisposition = ContentDispositionHeader(
          type: 'inline',
          parameters: [
            ContentDispositionParameter(name: 'filename', value: 'preview.pdf'),
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
      return createErrorResponse(
        500,
        e.title,
        e.description,
      );
    } catch (e) {
      return createErrorResponse(
        500,
        'PDF rendering failed',
        'An unexpected error occurred while rendering the PDF preview: $e',
      );
    }
  }
}
