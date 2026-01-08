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
import '../../../api/pdf_related/entities/pdf_content.dart' as _i3;
import '../../../api/pdf_related/entities/schema_definition.dart' as _i4;
import 'package:shoebill_template_client/src/protocol/protocol.dart' as _i5;

abstract class PdfDeclaration implements _i1.SerializableModel {
  PdfDeclaration._({
    this.id,
    required this.pdfId,
    required this.pdfContentId,
    this.pdfContent,
    required this.schemaId,
    this.schema,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
  }) : referenceLanguage = referenceLanguage ?? _i2.SupportedLanguages.english,
       createdAt = createdAt ?? DateTime.now();

  factory PdfDeclaration({
    int? id,
    required _i1.UuidValue pdfId,
    required int pdfContentId,
    _i3.PdfContent? pdfContent,
    required int schemaId,
    _i4.SchemaDefinition? schema,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
  }) = _PdfDeclarationImpl;

  factory PdfDeclaration.fromJson(Map<String, dynamic> jsonSerialization) {
    return PdfDeclaration(
      id: jsonSerialization['id'] as int?,
      pdfId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['pdfId']),
      pdfContentId: jsonSerialization['pdfContentId'] as int,
      pdfContent: jsonSerialization['pdfContent'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.PdfContent>(
              jsonSerialization['pdfContent'],
            ),
      schemaId: jsonSerialization['schemaId'] as int,
      schema: jsonSerialization['schema'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.SchemaDefinition>(
              jsonSerialization['schema'],
            ),
      referenceLanguage: _i2.SupportedLanguages.fromJson(
        (jsonSerialization['referenceLanguage'] as String),
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue pdfId;

  int pdfContentId;

  _i3.PdfContent? pdfContent;

  int schemaId;

  _i4.SchemaDefinition? schema;

  _i2.SupportedLanguages referenceLanguage;

  DateTime createdAt;

  /// Returns a shallow copy of this [PdfDeclaration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PdfDeclaration copyWith({
    int? id,
    _i1.UuidValue? pdfId,
    int? pdfContentId,
    _i3.PdfContent? pdfContent,
    int? schemaId,
    _i4.SchemaDefinition? schema,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PdfDeclaration',
      if (id != null) 'id': id,
      'pdfId': pdfId.toJson(),
      'pdfContentId': pdfContentId,
      if (pdfContent != null) 'pdfContent': pdfContent?.toJson(),
      'schemaId': schemaId,
      if (schema != null) 'schema': schema?.toJson(),
      'referenceLanguage': referenceLanguage.toJson(),
      'createdAt': createdAt.toJson(),
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
    int? id,
    required _i1.UuidValue pdfId,
    required int pdfContentId,
    _i3.PdfContent? pdfContent,
    required int schemaId,
    _i4.SchemaDefinition? schema,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
  }) : super._(
         id: id,
         pdfId: pdfId,
         pdfContentId: pdfContentId,
         pdfContent: pdfContent,
         schemaId: schemaId,
         schema: schema,
         referenceLanguage: referenceLanguage,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PdfDeclaration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PdfDeclaration copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? pdfId,
    int? pdfContentId,
    Object? pdfContent = _Undefined,
    int? schemaId,
    Object? schema = _Undefined,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
  }) {
    return PdfDeclaration(
      id: id is int? ? id : this.id,
      pdfId: pdfId ?? this.pdfId,
      pdfContentId: pdfContentId ?? this.pdfContentId,
      pdfContent: pdfContent is _i3.PdfContent?
          ? pdfContent
          : this.pdfContent?.copyWith(),
      schemaId: schemaId ?? this.schemaId,
      schema: schema is _i4.SchemaDefinition?
          ? schema
          : this.schema?.copyWith(),
      referenceLanguage: referenceLanguage ?? this.referenceLanguage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
