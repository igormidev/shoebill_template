import 'dart:async';

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
  final IPdfController pdfController = getIt<IPdfController>();
  final IGetLocaleOfIpService getLocaleOfIpService =
      getIt<IGetLocaleOfIpService>();

  PdfVisualizeRoute() : super(methods: {Method.get});

  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    // ─── 1. Validate UUID ────────────────────────────────────────────────
    final (uuid, uuidError) = validateUuid(request);
    if (uuidError != null) return uuidError;

    // ─── 2. Load and validate the baseline with its relations ────────────
    final (baselineData, baselineError) = await _loadValidatedBaseline(
      session,
      uuid!,
    );
    if (baselineError != null) return baselineError;
    final (baseline, _, versionInput) = baselineData!;

    // ─── 3. Detect language (IP-based or session-based) ──────────────────
    final selectedLanguage = await _detectLanguage(request);

    // ─── 4. Find or create implementation for the selected language ──────
    final (implementation, implError) = await _findOrCreateImplementation(
      session: session,
      baseline: baseline,
      selectedLanguage: selectedLanguage,
    );
    if (implError != null) return implError;

    // ─── 5. Parse the payload from the implementation ────────────────────
    final payload = tryDecode(implementation!.stringifiedPayload);
    if (payload == null) {
      return createErrorResponse(
        500,
        'Invalid payload format',
        'The implementation payload is not a valid JSON object.',
      );
    }

    // ─── 6. Render PDF using Jinja2 ─────────────────────────────────────
    return _renderPdfResponse(
      htmlTemplate: versionInput.htmlContent,
      cssContent: versionInput.cssContent,
      payload: payload,
      language: selectedLanguage,
    );
  }

  /// Loads the baseline by [uuid] with its nested version, versionInput, and
  /// schema relations, then validates that all required relations are present.
  ///
  /// Returns a tuple containing either:
  /// - A valid triple of (baseline, version, versionInput) and null error, or
  /// - Null data and an error [Response]
  Future<
    (
      (
        ShoebillTemplateBaseline,
        ShoebillTemplateVersion,
        ShoebillTemplateVersionInput,
      )?,
      Response?,
    )
  >
  _loadValidatedBaseline(Session session, String uuid) async {
    final baseline = await ShoebillTemplateBaseline.db.findById(
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
      return (
        null,
        createErrorResponse(
          404,
          'Baseline not found',
          'No ShoebillTemplateBaseline found for the provided ID: $uuid',
        ),
      );
    }

    final version = baseline.version;
    if (version == null) {
      return (
        null,
        createErrorResponse(
          500,
          'Version not found',
          'No ShoebillTemplateVersion associated with baseline ID: $uuid',
        ),
      );
    }

    final versionInput = version.input;
    if (versionInput == null) {
      return (
        null,
        createErrorResponse(
          500,
          'Version input not found',
          'No ShoebillTemplateVersionInput associated with version ID: '
              '${version.id}',
        ),
      );
    }

    if (version.schema == null) {
      return (
        null,
        createErrorResponse(
          500,
          'Schema not found',
          'No SchemaDefinition associated with version ID: ${version.id}',
        ),
      );
    }

    return ((baseline, version, versionInput), null);
  }

  /// Finds an existing [ShoebillTemplateBaselineImplementation] for the given
  /// language, or creates one by translating from the reference implementation.
  ///
  /// When translation is needed, the [IPdfController.addNewLanguageToBaseline]
  /// method handles extracting translatable strings from the payload (as
  /// defined by the schema's `shouldBeTranslated` flags) and translates them
  /// in parallel batches using [Future.wait] for optimal performance.
  ///
  /// Returns a tuple of either:
  /// - The implementation and null error, or
  /// - Null and an error [Response]
  Future<(ShoebillTemplateBaselineImplementation?, Response?)>
  _findOrCreateImplementation({
    required Session session,
    required ShoebillTemplateBaseline baseline,
    required SupportedLanguage selectedLanguage,
  }) async {
    final existing = await ShoebillTemplateBaselineImplementation.db
        .findFirstRow(
          session,
          where: (t) =>
              t.baselineId.equals(baseline.id) &
              t.language.equals(selectedLanguage),
        );

    if (existing != null) {
      return (existing, null);
    }

    // No implementation exists for this language yet - create one by translating
    try {
      final created = await pdfController.addNewLanguageToBaseline(
        session: session,
        baselineId: baseline.id,
        targetLanguage: selectedLanguage,
      );
      return (created, null);
    } on ShoebillException catch (e) {
      return (null, createErrorResponse(500, e.title, e.description));
    }
  }

  /// Renders a PDF from the given Jinja2 template and returns the response.
  ///
  /// Wraps [renderPdfFromJinja] with standardized error handling, returning
  /// either a successful PDF response or a JSON error response.
  Future<Response> _renderPdfResponse({
    required String htmlTemplate,
    required String cssContent,
    required Map<String, dynamic> payload,
    required SupportedLanguage language,
  }) async {
    try {
      final pdfBytes = await renderPdfFromJinja(
        htmlTemplate: htmlTemplate,
        cssContent: cssContent,
        payload: payload,
        language: language,
      );

      return Response.ok(
        body: Body.fromData(
          pdfBytes,
          mimeType: MimeType.pdf,
        ),
      );
    } on ShoebillException catch (e) {
      return createErrorResponse(500, e.title, e.description);
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
  Future<SupportedLanguage> _detectLanguage(Request request) async {
    final userIp = request.remoteInfo;
    final sessionId = request.queryParameters.raw['sI'];

    if (sessionId == null) {
      return getLocaleOfIpService.detectLanguageForCurrentUser(userIp);
    }

    // Try to match session ID against known language+IP hashes.
    // The hash uses SHA-256 (via hashString) to prevent session ID forgery.
    final sessionLanguage = SupportedLanguage.values.firstWhereOrNull(
      (t) => hashString(t.name + userIp) == sessionId,
    );

    if (sessionLanguage != null) {
      return sessionLanguage;
    }

    // Session ID does not match any language for this IP.
    // This means the link was likely shared from someone with a different IP,
    // so we fall back to IP-based detection to avoid keeping another user's config.
    return getLocaleOfIpService.detectLanguageForCurrentUser(userIp);
  }
}
