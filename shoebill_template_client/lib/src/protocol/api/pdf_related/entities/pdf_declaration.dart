/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../../entities/others/supported_languages.dart' as _i2;
import '../../../api/pdf_related/entities/schema_definition.dart' as _i3;
import '../../../api/pdf_related/entities/pdf_content.dart' as _i4;
import '../../../api/pdf_related/entities/pdf_implementation_payload.dart'
    as _i5;
import 'package:shoebill_template_client/src/protocol/protocol.dart' as _i6;

abstract class PdfDeclaration implements _i1.SerializableModel {
  PdfDeclaration._({
    _i1.UuidValue? id,
    required this.schemaId,
    this.schema,
    _i2.SupportedLanguages? referenceLanguage,
    required this.referencePdfContentId,
    this.referencePdfContent,
    DateTime? createdAt,
    required this.pythonGeneratorScript,
    this.pdfImplementationsPayloads,
  }) : id = id ?? _i1.Uuid().v7obj(),
       referenceLanguage = referenceLanguage ?? _i2.SupportedLanguages.english,
       createdAt = createdAt ?? DateTime.now();

  factory PdfDeclaration({
    _i1.UuidValue? id,
    required int schemaId,
    _i3.SchemaDefinition? schema,
    _i2.SupportedLanguages? referenceLanguage,
    required int referencePdfContentId,
    _i4.PdfContent? referencePdfContent,
    DateTime? createdAt,
    required String pythonGeneratorScript,
    List<_i5.PdfImplementationPayload>? pdfImplementationsPayloads,
  }) = _PdfDeclarationImpl;

  factory PdfDeclaration.fromJson(Map<String, dynamic> jsonSerialization) {
    return PdfDeclaration(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      schemaId: jsonSerialization['schemaId'] as int,
      schema: jsonSerialization['schema'] == null
          ? null
          : _i6.Protocol().deserialize<_i3.SchemaDefinition>(
              jsonSerialization['schema'],
            ),
      referenceLanguage: _i2.SupportedLanguages.fromJson(
        (jsonSerialization['referenceLanguage'] as String),
      ),
      referencePdfContentId: jsonSerialization['referencePdfContentId'] as int,
      referencePdfContent: jsonSerialization['referencePdfContent'] == null
          ? null
          : _i6.Protocol().deserialize<_i4.PdfContent>(
              jsonSerialization['referencePdfContent'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      pythonGeneratorScript:
          jsonSerialization['pythonGeneratorScript'] as String,
      pdfImplementationsPayloads:
          jsonSerialization['pdfImplementationsPayloads'] == null
          ? null
          : _i6.Protocol().deserialize<List<_i5.PdfImplementationPayload>>(
              jsonSerialization['pdfImplementationsPayloads'],
            ),
    );
  }

  /// The id of the object.
  _i1.UuidValue id;

  int schemaId;

  _i3.SchemaDefinition? schema;

  _i2.SupportedLanguages referenceLanguage;

  int referencePdfContentId;

  _i4.PdfContent? referencePdfContent;

  DateTime createdAt;

  String pythonGeneratorScript;

  List<_i5.PdfImplementationPayload>? pdfImplementationsPayloads;

  /// Returns a shallow copy of this [PdfDeclaration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PdfDeclaration copyWith({
    _i1.UuidValue? id,
    int? schemaId,
    _i3.SchemaDefinition? schema,
    _i2.SupportedLanguages? referenceLanguage,
    int? referencePdfContentId,
    _i4.PdfContent? referencePdfContent,
    DateTime? createdAt,
    String? pythonGeneratorScript,
    List<_i5.PdfImplementationPayload>? pdfImplementationsPayloads,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PdfDeclaration',
      'id': id.toJson(),
      'schemaId': schemaId,
      if (schema != null) 'schema': schema?.toJson(),
      'referenceLanguage': referenceLanguage.toJson(),
      'referencePdfContentId': referencePdfContentId,
      if (referencePdfContent != null)
        'referencePdfContent': referencePdfContent?.toJson(),
      'createdAt': createdAt.toJson(),
      'pythonGeneratorScript': pythonGeneratorScript,
      if (pdfImplementationsPayloads != null)
        'pdfImplementationsPayloads': pdfImplementationsPayloads?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PdfDeclarationImpl extends PdfDeclaration {
  _PdfDeclarationImpl({
    _i1.UuidValue? id,
    required int schemaId,
    _i3.SchemaDefinition? schema,
    _i2.SupportedLanguages? referenceLanguage,
    required int referencePdfContentId,
    _i4.PdfContent? referencePdfContent,
    DateTime? createdAt,
    required String pythonGeneratorScript,
    List<_i5.PdfImplementationPayload>? pdfImplementationsPayloads,
  }) : super._(
         id: id,
         schemaId: schemaId,
         schema: schema,
         referenceLanguage: referenceLanguage,
         referencePdfContentId: referencePdfContentId,
         referencePdfContent: referencePdfContent,
         createdAt: createdAt,
         pythonGeneratorScript: pythonGeneratorScript,
         pdfImplementationsPayloads: pdfImplementationsPayloads,
       );

  /// Returns a shallow copy of this [PdfDeclaration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PdfDeclaration copyWith({
    _i1.UuidValue? id,
    int? schemaId,
    Object? schema = _Undefined,
    _i2.SupportedLanguages? referenceLanguage,
    int? referencePdfContentId,
    Object? referencePdfContent = _Undefined,
    DateTime? createdAt,
    String? pythonGeneratorScript,
    Object? pdfImplementationsPayloads = _Undefined,
  }) {
    return PdfDeclaration(
      id: id ?? this.id,
      schemaId: schemaId ?? this.schemaId,
      schema: schema is _i3.SchemaDefinition?
          ? schema
          : this.schema?.copyWith(),
      referenceLanguage: referenceLanguage ?? this.referenceLanguage,
      referencePdfContentId:
          referencePdfContentId ?? this.referencePdfContentId,
      referencePdfContent: referencePdfContent is _i4.PdfContent?
          ? referencePdfContent
          : this.referencePdfContent?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      pythonGeneratorScript:
          pythonGeneratorScript ?? this.pythonGeneratorScript,
      pdfImplementationsPayloads:
          pdfImplementationsPayloads is List<_i5.PdfImplementationPayload>?
          ? pdfImplementationsPayloads
          : this.pdfImplementationsPayloads
                ?.map((e0) => e0.copyWith())
                .toList(),
    );
  }
}
