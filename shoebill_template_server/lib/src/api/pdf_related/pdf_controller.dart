import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/api/pdf_related/entities/schema_property_extensions.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';

class PdfController {
  Future<PdfImplementationPayload> addNewLanguageToExistingPdf({
    required Session session,
    required UuidValue pdfDeclarationId,
    required SupportedLanguages targetLanguage,
  }) async {
    final pdfDeclaration = await PdfDeclaration.db.findById(
      session,
      pdfDeclarationId,
      include: PdfDeclaration.include(
        referencePdfContent: PdfContent.include(),
        schema: SchemaDefinition.include(),
      ),
    );
    if (pdfDeclaration == null) {
      throw ShoebillException(
        title: 'PDF Declaration not found',
        description:
            'No PDF Declaration found for the provided ID: $pdfDeclarationId',
      );
    }
    final SchemaDefinition? schema = pdfDeclaration.schema;
    if (schema == null) {
      throw ShoebillException(
        title: 'SchemaDefinition not found',
        description:
            'No SchemaDefinition found for the PDF Declaration with ID: $pdfDeclarationId',
      );
    }

    final pdfContent = pdfDeclaration.referencePdfContent;
    if (pdfContent == null) {
      throw ShoebillException(
        title: 'PDF Content not found',
        description:
            'No PDF Content found for the PDF Declaration with ID: $pdfDeclarationId',
      );
    }

    final alreadyExists =
        (await PdfImplementationPayload.db.count(
          session,
          where: (t) =>
              t.pdfDeclarationId.equals(pdfDeclarationId) &
              t.language.equals(targetLanguage),
        )) >
        0;
    if (alreadyExists) {
      throw ShoebillException(
        title: 'PDF Implementation already exists',
        description:
            'A PDF Implementation for the provided language already exists for this PDF Declaration.',
      );
    }

    final PdfImplementationPayload? referenceImplementation =
        await PdfImplementationPayload.db.findFirstRow(
          session,
          // get from the original language and translate from it...
          where: (t) =>
              t.pdfDeclarationId.equals(pdfDeclarationId) &
              t.language.equals(pdfDeclaration.referenceLanguage),
        );
    if (referenceImplementation == null) {
      throw ShoebillException(
        title: 'Reference PDF Implementation not found',
        description:
            'No reference PDF Implementation found for the PDF Declaration with ID: $pdfDeclarationId and language: ${pdfDeclaration.referenceLanguage}',
      );
    }

    final String translatedJson;
    try {
      translatedJson = await schema.translateBasedOnSchema(
        stringifiedJson: referenceImplementation.stringifiedJson,
        sourceLanguage: pdfDeclaration.referenceLanguage,
        targetLanguage: targetLanguage,
      );
    } on ShoebillException catch (_) {
      rethrow;
    } catch (e) {
      throw ShoebillException(
        title: 'Translation failed',
        description:
            'An error occurred while translating the PDF Implementation:\n$e',
      );
    }

    return session.db.transaction((tx) async {
      final implementation = await PdfImplementationPayload.db.insertRow(
        session,
        PdfImplementationPayload(
          stringifiedJson: translatedJson,
          pdfDeclarationId: pdfDeclarationId,
          language: targetLanguage,
        ),
        transaction: tx,
      );

      await PdfDeclaration.db.attachRow.pdfImplementationsPayloads(
        session,
        pdfDeclaration,
        implementation,
        transaction: tx,
      );

      return implementation;
    });
  }

  Future<void> createNewPdf({
    required Session session,
    required SupportedLanguages language,
    required String stringifiedJson,
    required SchemaDefinition schemaDefinition,
    required PdfContent pdfContent,
    required String pythonGeneratorScript,
  }) async {
    final Map<String, dynamic>? payload = tryDecode(stringifiedJson);
    if (payload == null) {
      throw ShoebillException(
        title: 'Invalid JSON',
        description: 'Provided string is not valid JSON.',
      );
    }

    final error = schemaDefinition.validateJsonFollowsSchemaStructure(payload);
    if (error != null) {
      throw ShoebillException(
        title: 'Payload does not conform to schema',
        description: error,
      );
    }
    if (schemaDefinition.id != null) {
      throw ShoebillException(
        title: 'SchemaDefinition already exists',
        description:
            'SchemaDefinition should not have an ID when generating a new PDF.',
      );
    }
    if (pdfContent.id != null) {
      throw ShoebillException(
        title: 'PDF Content already exists',
        description:
            'PDF Content should not have an ID when generating a new PDF.',
      );
    }

    await session.db.transaction((tx) async {
      schemaDefinition = await SchemaDefinition.db.insertRow(
        session,
        schemaDefinition,
        transaction: tx,
      );
      pdfContent = await PdfContent.db.insertRow(session, pdfContent);

      final PdfDeclaration pdfDeclaration = await PdfDeclaration.db.insertRow(
        session,
        PdfDeclaration(
          schemaId: schemaDefinition.id!,
          referencePdfContentId: pdfContent.id!,
          referencePdfContent: pdfContent,
          schema: schemaDefinition,
          pythonGeneratorScript: pythonGeneratorScript,
        ),
        transaction: tx,
      );

      final insertedPayload = await PdfImplementationPayload.db.insertRow(
        session,
        PdfImplementationPayload(
          language: language,
          stringifiedJson: stringifiedJson,
          pdfDeclarationId: pdfDeclaration.id,
          pdfDeclaration: pdfDeclaration,
        ),
        transaction: tx,
      );
      await PdfDeclaration.db.attachRow.pdfImplementationsPayloads(
        session,
        pdfDeclaration,
        insertedPayload,
        transaction: tx,
      );
    });
  }
}
