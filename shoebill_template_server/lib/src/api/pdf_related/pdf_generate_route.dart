import 'dart:async';
import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/server.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';

mixin GeneratePdfVersion {
  Future<void> generatePdfVersion(
    Session session, {
    required SupportedLanguages language,
    required String stringifiedJson,
    required SchemaDefinition schemaDefinition,
    required PdfContent pdfContent,
  }) async {}
}

class PdfGenerateEndpoint extends Endpoint {
  Future<void> call(
    Session session, {
    required SupportedLanguages language,
    required String stringifiedJson,
    required SchemaDefinition schemaDefinition,
    required PdfContent pdfContent,
    required String pythonGeneratorScript,
  }) async {
    return pdfController.createNewPdf(
      session: session,
      language: language,
      stringifiedJson: stringifiedJson,
      schemaDefinition: schemaDefinition,
      pdfContent: pdfContent,
      pythonGeneratorScript: pythonGeneratorScript,
    );
  }
}
