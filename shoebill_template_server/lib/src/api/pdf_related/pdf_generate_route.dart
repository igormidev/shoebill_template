import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/services/pdf_controller.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';

class PdfGenerateEndpoint extends Endpoint {
  Future<void> call(
    Session session, {
    required SupportedLanguages language,
    required String stringifiedJson,
    required SchemaDefinition schemaDefinition,
    required PdfContent pdfContent,
    required String pythonGeneratorScript,
  }) async {
    return GetIt.instance<PdfController>().createNewPdf(
      session: session,
      language: language,
      stringifiedJson: stringifiedJson,
      schemaDefinition: schemaDefinition,
      pdfContent: pdfContent,
      pythonGeneratorScript: pythonGeneratorScript,
    );
  }
}
