import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/api/pdf_related/entities/schema_property_extensions.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';
import 'package:crypto/crypto.dart';

class PdfGenerateRoute extends Route with RouteMixin {
  PdfGenerateRoute() : super(methods: {Method.post});

  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    final languageCode = getLanguageCode(request);
    if (languageCode == null) {
      return Response.badRequest(
        body: Body.fromString(
          'Invalid or missing language code in query parameters. Available codes: "${SupportedLanguages.values.map((e) => e.name).join('", "')}"',
        ),
      );
    }
    final (payload, payloadError) = await getPayload(request);
    if (payload == null) return payloadError!;

    final uuid = sha1OfMap(payload);
    final PdfDeclaration? pdfDeclaration = await PdfDeclaration.db.findFirstRow(
      session,
      where: (p) => p.pdfId.equals(UuidValue.fromString(uuid)),
      include: PdfDeclaration.include(schema: SchemaDefinition.include()),
    );
    if (pdfDeclaration == null) {
      return Response.notFound(
        body: Body.fromString('PDF Declaration not found for uuid=$uuid'),
      );
    }
    final SchemaDefinition? schemaDefinition = pdfDeclaration.schema;
    if (schemaDefinition == null) {
      return Response.internalServerError(
        body: Body.fromString(
          'SchemaDefinition not found for PDF Declaration uuid=$uuid',
        ),
      );
    }

    final error = pdfDeclaration.schema?.validateJsonFollowsSchemaStructure(
      payload,
    );
    if (error != null) {
      return Response.badRequest(
        body: Body.fromString('Payload does not conform to schema: $error'),
      );
    }

    final PdfDeclaration pdfDeclaration = PdfDeclaration(
      pdfId: UuidValue.fromString(uuid),
      schemaId: schemaDefinition.id!,
      pdfContent: ,
    );

    throw UnimplementedError();
  }
}

/// Returns the hex SHA-1 of a Map of String, String
String sha1OfMap(Map<String, dynamic>? map) {
  // Canonicalize: sort keys to get stable ordering.
  final canonical = SplayTreeMap<String, dynamic>.from(map ?? {});

  // Stable JSON string (keys sorted, values escaped).
  final json = jsonEncode(canonical);

  // Hash UTF-8 bytes of the canonical representation.
  final digest = sha1.convert(utf8.encode(json));
  return digest.toString(); // hex
}
