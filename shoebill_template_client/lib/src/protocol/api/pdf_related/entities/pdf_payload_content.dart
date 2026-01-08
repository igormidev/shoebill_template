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

abstract class PdfPayloadContent implements _i1.SerializableModel {
  PdfPayloadContent._({
    this.id,
    required this.pdfId,
    required this.stringifiedJson,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
  }) : language = language ?? _i2.SupportedLanguages.english,
       createdAt = createdAt ?? DateTime.now();

  factory PdfPayloadContent({
    int? id,
    required _i1.UuidValue pdfId,
    required String stringifiedJson,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
  }) = _PdfPayloadContentImpl;

  factory PdfPayloadContent.fromJson(Map<String, dynamic> jsonSerialization) {
    return PdfPayloadContent(
      id: jsonSerialization['id'] as int?,
      pdfId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['pdfId']),
      stringifiedJson: jsonSerialization['stringifiedJson'] as String,
      language: _i2.SupportedLanguages.fromJson(
        (jsonSerialization['language'] as String),
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

  String stringifiedJson;

  _i2.SupportedLanguages language;

  DateTime createdAt;

  /// Returns a shallow copy of this [PdfPayloadContent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PdfPayloadContent copyWith({
    int? id,
    _i1.UuidValue? pdfId,
    String? stringifiedJson,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PdfPayloadContent',
      if (id != null) 'id': id,
      'pdfId': pdfId.toJson(),
      'stringifiedJson': stringifiedJson,
      'language': language.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PdfPayloadContentImpl extends PdfPayloadContent {
  _PdfPayloadContentImpl({
    int? id,
    required _i1.UuidValue pdfId,
    required String stringifiedJson,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
  }) : super._(
         id: id,
         pdfId: pdfId,
         stringifiedJson: stringifiedJson,
         language: language,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PdfPayloadContent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PdfPayloadContent copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? pdfId,
    String? stringifiedJson,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
  }) {
    return PdfPayloadContent(
      id: id is int? ? id : this.id,
      pdfId: pdfId ?? this.pdfId,
      stringifiedJson: stringifiedJson ?? this.stringifiedJson,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
