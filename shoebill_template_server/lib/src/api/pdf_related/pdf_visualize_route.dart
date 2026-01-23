import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/server.dart';
import 'package:shoebill_template_server/src/core/mixins/jinja_pdf_renderer_mixin.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';
import 'package:shoebill_template_server/src/services/get_locale_of_ip_service.dart';
import 'package:shoebill_template_server/src/services/pdf_controller.dart';

/// Route that visualizes a PDF for a given [ShoebillTemplateBaseline] UUID.
///
/// The route:
/// 1. Receives the baseline UUID via query parameter
/// 2. Detects the appropriate language (IP-based or session-based)
/// 3. Finds or creates a [ShoebillTemplateBaselineImplementation] for that language
/// 4. Renders the PDF using Jinja2 templates (HTML + CSS from the version input)
/// 5. Returns the PDF bytes with the correct MIME type
class PdfVisualizeRoute extends Route with RouteMixin, JinjaPdfRendererMixin {
  final PdfController pdfController = getIt<PdfController>();
  final IGetLocaleOfIpService getLocaleOfIpService =
      getIt<IGetLocaleOfIpService>();

  PdfVisualizeRoute() : super(methods: {Method.get});

  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    // ─── 1. Validate UUID ────────────────────────────────────────────────
    final (uuid, uuidError) = validateUuid(request);
    if (uuidError != null) return uuidError;

    // ─── 2. Find the ShoebillTemplateBaseline ────────────────────────────
    final ShoebillTemplateBaseline? baseline =
        await ShoebillTemplateBaseline.db.findById(
      session,
      UuidValue.fromString(uuid),
      include: ShoebillTemplateBaseline.include(
        version: ShoebillTemplateVersion.include(
          input: ShoebillTemplateVersionInput.include(),
          schema: SchemaDefinition.include(),
        ),
      ),
    );
    if (baseline == null) {
      return createErrorResponse(
        404,
        'Baseline not found',
        'No ShoebillTemplateBaseline found for the provided ID: $uuid',
      );
    }

    // ─── 3. Validate version and input relations ─────────────────────────
    final version = baseline.version;
    if (version == null) {
      return createErrorResponse(
        500,
        'Version not found',
        'No ShoebillTemplateVersion associated with baseline ID: $uuid',
      );
    }

    final versionInput = version.input;
    if (versionInput == null) {
      return createErrorResponse(
        500,
        'Version input not found',
        'No ShoebillTemplateVersionInput associated with version ID: ${version.id}',
      );
    }

    final schema = version.schema;
    if (schema == null) {
      return createErrorResponse(
        500,
        'Schema not found',
        'No SchemaDefinition associated with version ID: ${version.id}',
      );
    }

    // ─── 4. Detect language (IP-based or session-based) ──────────────────
    final selectedLanguage = await _detectLanguage(request);

    // ─── 5. Find or create implementation for the selected language ───────
    ShoebillTemplateBaselineImplementation? implementation =
        await ShoebillTemplateBaselineImplementation.db.findFirstRow(
      session,
      where: (t) =>
          t.baselineId.equals(baseline.id) &
          t.language.equals(selectedLanguage),
    );

    if (implementation == null) {
      // No implementation exists for this language yet - create one by translating
      try {
        implementation = await pdfController.addNewLanguageToBaseline(
          session: session,
          baselineId: baseline.id,
          targetLanguage: selectedLanguage,
        );
      } on ShoebillException catch (e) {
        return createErrorResponse(
          500,
          e.title,
          e.description,
        );
      }
    }

    // ─── 6. Parse the payload from the implementation ─────────────────────
    final Map<String, dynamic>? payload;
    try {
      final decoded = jsonDecode(implementation.stringifiedPayload);
      if (decoded is Map<String, dynamic>) {
        payload = decoded;
      } else {
        return createErrorResponse(
          500,
          'Invalid payload format',
          'The implementation payload is not a valid JSON object.',
        );
      }
    } catch (e) {
      return createErrorResponse(
        500,
        'Payload parse error',
        'Failed to parse the implementation payload as JSON: $e',
      );
    }

    // ─── 7. Render PDF using Jinja2 ──────────────────────────────────────
    try {
      final pdfBytes = await renderPdfFromJinja(
        htmlTemplate: versionInput.htmlContent,
        cssContent: versionInput.cssContent,
        payload: payload,
        language: selectedLanguage,
      );

      return Response.ok(
        body: Body.fromData(
          pdfBytes,
          mimeType: MimeType.pdf,
        ),
      );
    } on ShoebillException catch (e) {
      return createErrorResponse(
        500,
        e.title,
        e.description,
      );
    }
  }

  /// Detects the appropriate language for the current request.
  ///
  /// The language detection rules are:
  /// - If a `sI` (session ID) query parameter is present and matches a known
  ///   language+IP hash, use that language.
  /// - If the session ID does not match (e.g., the link was shared from another
  ///   user with a different IP), fall back to IP-based detection.
  /// - If no session ID is provided, use IP-based detection directly.
  Future<SupportedLanguages> _detectLanguage(Request request) async {
    final userIp = request.remoteInfo;
    final queryParameters = request.queryParameters.raw;
    final sessionId = queryParameters['sI'];

    if (sessionId == null) {
      // No session ID provided - detect from IP
      return getLocaleOfIpService.detectLanguageForCurrentUser(userIp);
    }

    // Try to match session ID against known language+IP hashes
    final SupportedLanguages? sessionLanguage = SupportedLanguages.values
        .firstWhereOrNull((t) => sha1OfString(t.name + userIp) == sessionId);

    if (sessionLanguage != null) {
      return sessionLanguage;
    }

    // Session ID does not match any language for this IP.
    // This means the link was likely shared from someone with a different IP,
    // so we fall back to IP-based detection to avoid keeping another user's config.
    return getLocaleOfIpService.detectLanguageForCurrentUser(userIp);
  }
}
