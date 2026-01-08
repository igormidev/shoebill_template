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

abstract class PdfDeclaration implements _i1.SerializableModel {
  PdfDeclaration._({
    this.id,
    required this.pdfId,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
  }) : referenceLanguage = referenceLanguage ?? _i2.SupportedLanguages.english,
       createdAt = createdAt ?? DateTime.now();

  factory PdfDeclaration({
    int? id,
    required _i1.UuidValue pdfId,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
  }) = _PdfDeclarationImpl;

  factory PdfDeclaration.fromJson(Map<String, dynamic> jsonSerialization) {
    return PdfDeclaration(
      id: jsonSerialization['id'] as int?,
      pdfId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['pdfId']),
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

  _i2.SupportedLanguages referenceLanguage;

  DateTime createdAt;

  /// Returns a shallow copy of this [PdfDeclaration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PdfDeclaration copyWith({
    int? id,
    _i1.UuidValue? pdfId,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PdfDeclaration',
      if (id != null) 'id': id,
      'pdfId': pdfId.toJson(),
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
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
  }) : super._(
         id: id,
         pdfId: pdfId,
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
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
  }) {
    return PdfDeclaration(
      id: id is int? ? id : this.id,
      pdfId: pdfId ?? this.pdfId,
      referenceLanguage: referenceLanguage ?? this.referenceLanguage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
