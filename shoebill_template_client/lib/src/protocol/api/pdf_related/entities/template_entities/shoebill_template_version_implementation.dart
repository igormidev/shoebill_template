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
import '../../../../entities/others/supported_languages.dart' as _i2;
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_version.dart'
    as _i3;
import 'package:shoebill_template_client/src/protocol/protocol.dart' as _i4;

abstract class ShoebillTemplateVersionImplementation
    implements _i1.SerializableModel {
  ShoebillTemplateVersionImplementation._({
    this.id,
    required this.stringifiedPayload,
    required this.language,
    DateTime? createdAt,
    required this.versionId,
    this.version,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ShoebillTemplateVersionImplementation({
    int? id,
    required String stringifiedPayload,
    required _i2.SupportedLanguages language,
    DateTime? createdAt,
    required int versionId,
    _i3.ShoebillTemplateVersion? version,
  }) = _ShoebillTemplateVersionImplementationImpl;

  factory ShoebillTemplateVersionImplementation.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ShoebillTemplateVersionImplementation(
      id: jsonSerialization['id'] as int?,
      stringifiedPayload: jsonSerialization['stringifiedPayload'] as String,
      language: _i2.SupportedLanguages.fromJson(
        (jsonSerialization['language'] as String),
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      versionId: jsonSerialization['versionId'] as int,
      version: jsonSerialization['version'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.ShoebillTemplateVersion>(
              jsonSerialization['version'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String stringifiedPayload;

  _i2.SupportedLanguages language;

  DateTime createdAt;

  int versionId;

  _i3.ShoebillTemplateVersion? version;

  /// Returns a shallow copy of this [ShoebillTemplateVersionImplementation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoebillTemplateVersionImplementation copyWith({
    int? id,
    String? stringifiedPayload,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
    int? versionId,
    _i3.ShoebillTemplateVersion? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoebillTemplateVersionImplementation',
      if (id != null) 'id': id,
      'stringifiedPayload': stringifiedPayload,
      'language': language.toJson(),
      'createdAt': createdAt.toJson(),
      'versionId': versionId,
      if (version != null) 'version': version?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoebillTemplateVersionImplementationImpl
    extends ShoebillTemplateVersionImplementation {
  _ShoebillTemplateVersionImplementationImpl({
    int? id,
    required String stringifiedPayload,
    required _i2.SupportedLanguages language,
    DateTime? createdAt,
    required int versionId,
    _i3.ShoebillTemplateVersion? version,
  }) : super._(
         id: id,
         stringifiedPayload: stringifiedPayload,
         language: language,
         createdAt: createdAt,
         versionId: versionId,
         version: version,
       );

  /// Returns a shallow copy of this [ShoebillTemplateVersionImplementation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShoebillTemplateVersionImplementation copyWith({
    Object? id = _Undefined,
    String? stringifiedPayload,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
    int? versionId,
    Object? version = _Undefined,
  }) {
    return ShoebillTemplateVersionImplementation(
      id: id is int? ? id : this.id,
      stringifiedPayload: stringifiedPayload ?? this.stringifiedPayload,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      versionId: versionId ?? this.versionId,
      version: version is _i3.ShoebillTemplateVersion?
          ? version
          : this.version?.copyWith(),
    );
  }
}
