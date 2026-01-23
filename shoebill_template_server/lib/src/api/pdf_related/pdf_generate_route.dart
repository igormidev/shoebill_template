import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/api/pdf_related/entities/schema_property_extensions.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';

/// POST endpoint that creates a new [ShoebillTemplateBaseline] and its first
/// [ShoebillTemplateBaselineImplementation].
///
/// **Query parameters:**
///   - `versionId` (required): The integer ID of the [ShoebillTemplateVersion]
///     this baseline is based on.
///   - `language` (required): The reference language for the baseline
///     (must match a [SupportedLanguages] enum value name).
///
/// **Request body (JSON):**
///   The payload JSON object that conforms to the version's schema.
///
/// **Responses:**
///   - 201: Baseline created successfully. Returns JSON with `baselineId` and
///     `implementationId`.
///   - 400: Missing parameters or payload does not conform to schema.
///   - 404: Template version not found or schema not found.
///   - 500: Internal server error.
class PdfGenerateEndpoint extends Route with RouteMixin {
  PdfGenerateEndpoint() : super(methods: {Method.post});

  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    // 1. Extract and validate language query parameter
    final language = getLanguageCode(request);
    if (language == null) {
      return createErrorResponse(
        400,
        'Missing or invalid language',
        'The "language" query parameter is required and must be a valid '
            'SupportedLanguages enum value name '
            '(e.g., "english", "spanish", "french").',
      );
    }

    // 2. Extract and validate versionId query parameter
    final queryParameters = request.queryParameters.raw;
    final versionIdParam = queryParameters['versionId'];
    if (versionIdParam == null || versionIdParam.isEmpty) {
      return createErrorResponse(
        400,
        'Missing versionId',
        'The "versionId" query parameter is required.',
      );
    }

    final int? versionId = int.tryParse(versionIdParam);
    if (versionId == null) {
      return createErrorResponse(
        400,
        'Invalid versionId',
        'The "versionId" query parameter must be a valid integer.',
      );
    }

    // 3. Parse request body as JSON payload
    final (payload, payloadError) = await getPayload(request);
    if (payloadError != null) return payloadError;
    if (payload == null) {
      return createErrorResponse(
        400,
        'Missing payload',
        'Request body must contain a valid JSON object.',
      );
    }

    // 4. Look up the ShoebillTemplateVersion and include its schema
    final ShoebillTemplateVersion? templateVersion =
        await ShoebillTemplateVersion.db.findById(
      session,
      versionId,
      include: ShoebillTemplateVersion.include(
        schema: SchemaDefinition.include(),
      ),
    );

    if (templateVersion == null) {
      return createErrorResponse(
        404,
        'Template version not found',
        'No template version found for the provided ID.',
      );
    }

    // 5. Load and validate the schema
    final SchemaDefinition? schema = templateVersion.schema;
    if (schema == null) {
      return _logAndCreateInternalError(
        'Schema missing for template version ID: $versionId',
      );
    }

    // 6. Validate the payload against the schema
    final validationError = schema.validateJsonFollowsSchemaStructure(payload);
    if (validationError != null) {
      return createErrorResponse(
        400,
        'Payload does not conform to schema',
        validationError,
      );
    }

    // 7. Stringify the validated payload for storage
    final stringifiedPayload = JsonEncoder.withIndent('  ').convert(payload);

    // 8. Create baseline and implementation inside a transaction.
    // Foreign keys (versionId, baselineId) are set during construction,
    // so the relations are established automatically upon insert -
    // no attachRow calls are needed.
    try {
      final result = await session.db.transaction((tx) async {
        // Create the ShoebillTemplateBaseline (versionId links to version)
        final baseline = await ShoebillTemplateBaseline.db.insertRow(
          session,
          ShoebillTemplateBaseline(
            referenceLanguage: language,
            versionId: templateVersion.id!,
          ),
          transaction: tx,
        );

        // Create the first ShoebillTemplateBaselineImplementation (baselineId links to baseline)
        final implementation =
            await ShoebillTemplateBaselineImplementation.db.insertRow(
          session,
          ShoebillTemplateBaselineImplementation(
            stringifiedPayload: stringifiedPayload,
            language: language,
            baselineId: baseline.id,
          ),
          transaction: tx,
        );

        return (baseline, implementation);
      });

      final (baseline, implementation) = result;

      // 9. Return 201 Created with the new IDs
      final responseBody = jsonEncode({
        'baselineId': baseline.id.toString(),
        'implementationId': implementation.id,
      });

      return Response(
        201,
        body: Body.fromString(responseBody, mimeType: MimeType.json),
      );
    } catch (e, stackTrace) {
      return _logAndCreateInternalError(
        'Failed to create baseline: $e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Logs detailed error information server-side and returns a generic
  /// 500 error response to the client without leaking internals.
  Response _logAndCreateInternalError(
    String internalMessage, {
    StackTrace? stackTrace,
  }) {
    developer.log(
      internalMessage,
      name: 'PdfGenerateEndpoint',
      error: internalMessage,
      stackTrace: stackTrace,
    );
    return createErrorResponse(
      500,
      'Internal server error',
      'An unexpected error occurred. Please try again later.',
    );
  }
}
