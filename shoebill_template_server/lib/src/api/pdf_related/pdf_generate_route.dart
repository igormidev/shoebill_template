import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/services/pdf_controller.dart';

class PdfGenerateEndpoint extends Route with RouteMixin {
  PdfGenerateEndpoint() : super(methods: {Method.post});
  final PdfController pdfController = GetIt.instance<PdfController>();

  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    final language = getLanguageCode(request);
    final (payload, error) = await getPayload(request);
    if (error != null) return error;

    // TODO: implement handleCall
    throw UnimplementedError();
  }
}
