import 'dart:collection';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:shoebill_template_server/src/api/pdf_related/entities/schema_property_extensions.dart';
import 'package:shoebill_template_server/src/core/mixins/route_mixin.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';

class PdfController {
  Future<void> addNewLanguageToExistingPdf({
    required Session session,
    required SupportedLanguages language,
  }) {}

  Future<void> createNewPdf({
    required Session session,
    required SupportedLanguages language,
    required String stringifiedJson,
    required SchemaDefinition schemaDefinition,
    required PdfContent pdfContent,
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

    schemaDefinition = await SchemaDefinition.db.insertRow(
      session,
      schemaDefinition,
    );
    pdfContent = await PdfContent.db.insertRow(session, pdfContent);

    final uuidString = sha1OfMap(payload);
    final uuid = UuidValue.fromString(uuidString);
    final bool alreadyExistsUuid =
        (await PdfDeclaration.db.findFirstRow(
          session,
          where: (p) => p.pdfId.equals(uuid),
        )) !=
        null;

    if (alreadyExistsUuid) {
      throw ShoebillException(
        title: 'PDF Declaration already exists',
        description: 'A PDF Declaration with the same content already exists.',
      );
    }

    final PdfDeclaration pdfDeclaration = await PdfDeclaration.db.insertRow(
      session,
      PdfDeclaration(
        pdfId: uuid,
        schemaId: schemaDefinition.id!,
        pdfContentId: pdfContent.id!,
        pdfContent: pdfContent,
        schema: schemaDefinition,
      ),
    );

    await PdfImplementationPayload.db.insertRow(
      session,
      PdfImplementationPayload(
        language: language,
        stringifiedJson: stringifiedJson,
        pdfId: pdfDeclaration.pdfId,
      ),
    );
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
