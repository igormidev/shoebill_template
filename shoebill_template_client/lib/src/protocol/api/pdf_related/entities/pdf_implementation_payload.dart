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
import '../../../api/pdf_related/entities/pdf_declaration.dart' as _i3;
import 'package:shoebill_template_client/src/protocol/protocol.dart' as _i4;

abstract class PdfImplementationPayload implements _i1.SerializableModel {
  PdfImplementationPayload._({
    this.id,
    required this.stringifiedJson,
    required this.language,
    DateTime? createdAt,
    required this.pdfDeclarationId,
    this.pdfDeclaration,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PdfImplementationPayload({
    int? id,
    required String stringifiedJson,
    required _i2.SupportedLanguages language,
    DateTime? createdAt,
    required _i1.UuidValue pdfDeclarationId,
    _i3.PdfDeclaration? pdfDeclaration,
  }) = _PdfImplementationPayloadImpl;

  factory PdfImplementationPayload.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PdfImplementationPayload(
      id: jsonSerialization['id'] as int?,
      stringifiedJson: jsonSerialization['stringifiedJson'] as String,
      language: _i2.SupportedLanguages.fromJson(
        (jsonSerialization['language'] as String),
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      pdfDeclarationId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['pdfDeclarationId'],
      ),
      pdfDeclaration: jsonSerialization['pdfDeclaration'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.PdfDeclaration>(
              jsonSerialization['pdfDeclaration'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String stringifiedJson;

  _i2.SupportedLanguages language;

  DateTime createdAt;

  _i1.UuidValue pdfDeclarationId;

  _i3.PdfDeclaration? pdfDeclaration;

  /// Returns a shallow copy of this [PdfImplementationPayload]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PdfImplementationPayload copyWith({
    int? id,
    String? stringifiedJson,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
    _i1.UuidValue? pdfDeclarationId,
    _i3.PdfDeclaration? pdfDeclaration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PdfImplementationPayload',
      if (id != null) 'id': id,
      'stringifiedJson': stringifiedJson,
      'language': language.toJson(),
      'createdAt': createdAt.toJson(),
      'pdfDeclarationId': pdfDeclarationId.toJson(),
      if (pdfDeclaration != null) 'pdfDeclaration': pdfDeclaration?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PdfImplementationPayloadImpl extends PdfImplementationPayload {
  _PdfImplementationPayloadImpl({
    int? id,
    required String stringifiedJson,
    required _i2.SupportedLanguages language,
    DateTime? createdAt,
    required _i1.UuidValue pdfDeclarationId,
    _i3.PdfDeclaration? pdfDeclaration,
  }) : super._(
         id: id,
         stringifiedJson: stringifiedJson,
         language: language,
         createdAt: createdAt,
         pdfDeclarationId: pdfDeclarationId,
         pdfDeclaration: pdfDeclaration,
       );

  /// Returns a shallow copy of this [PdfImplementationPayload]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PdfImplementationPayload copyWith({
    Object? id = _Undefined,
    String? stringifiedJson,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
    _i1.UuidValue? pdfDeclarationId,
    Object? pdfDeclaration = _Undefined,
  }) {
    return PdfImplementationPayload(
      id: id is int? ? id : this.id,
      stringifiedJson: stringifiedJson ?? this.stringifiedJson,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      pdfDeclarationId: pdfDeclarationId ?? this.pdfDeclarationId,
      pdfDeclaration: pdfDeclaration is _i3.PdfDeclaration?
          ? pdfDeclaration
          : this.pdfDeclaration?.copyWith(),
    );
  }
}
