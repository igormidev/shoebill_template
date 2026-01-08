import 'dart:async';
import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';

class PdfVisualizeRoute extends Route with RouteMixin {
  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    final (uuid, uuidError) = validateUuid(request);
    if (uuidError != null) return uuidError;

    throw UnimplementedError();
  }
}
