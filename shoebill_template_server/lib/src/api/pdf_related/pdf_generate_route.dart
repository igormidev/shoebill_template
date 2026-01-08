import 'dart:async';
import 'package:serverpod/serverpod.dart';
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
    );
    if (pdfDeclaration == null) {
      return Response.notFound(
        body: Body.fromString('PDF Declaration not found for uuid=$uuid'),
      );
    }

    throw UnimplementedError();
  }
}
