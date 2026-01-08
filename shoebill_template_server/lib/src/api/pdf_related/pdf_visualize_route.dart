import 'dart:async';
import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/generated/entities/others/supported_languages.dart';

class PdfVisualizeRoute extends Route with RouteMixin {
  PdfVisualizeRoute() : super(methods: {Method.get});
  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    final (uuid, uuidError) = validateUuid(request);
    if (uuidError != null) return uuidError;
    final languageCode = getLanguageCode(request);
    if (languageCode == null) {
      return Response.badRequest(
        body: Body.fromString(
          'Invalid or missing language code in query parameters. Available codes: "${SupportedLanguages.values.map((e) => e.name).join('", "')}"',
        ),
      );
    }

    throw UnimplementedError();
  }
}
