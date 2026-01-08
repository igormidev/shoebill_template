import 'dart:async';
import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/api/pdf_related/entities/schema_property_extensions.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';

class PdfGenerateRoute extends Route with RouteMixin {
  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    final (uuid, uuidError) = validateUuid(request);
    if (uuidError != null) return uuidError;
    final (payload, payloadError) = await getPayload(request);
    if (payload == null) return payloadError!;

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

    throw UnimplementedError();
  }
}
