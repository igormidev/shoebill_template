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
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_baseline_implementation.dart'
    as _i4;
import 'package:shoebill_template_client/src/protocol/protocol.dart' as _i5;

abstract class ShoebillTemplateBaseline implements _i1.SerializableModel {
  ShoebillTemplateBaseline._({
    _i1.UuidValue? id,
    required this.referenceLanguage,
    DateTime? createdAt,
    required this.versionId,
    this.version,
    this.implementations,
  }) : id = id ?? _i1.Uuid().v7obj(),
       createdAt = createdAt ?? DateTime.now();

  factory ShoebillTemplateBaseline({
    _i1.UuidValue? id,
    required _i2.SupportedLanguages referenceLanguage,
    DateTime? createdAt,
    required int versionId,
    _i3.ShoebillTemplateVersion? version,
    List<_i4.ShoebillTemplateBaselineImplementation>? implementations,
  }) = _ShoebillTemplateBaselineImpl;

  factory ShoebillTemplateBaseline.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ShoebillTemplateBaseline(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      referenceLanguage: _i2.SupportedLanguages.fromJson(
        (jsonSerialization['referenceLanguage'] as String),
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      versionId: jsonSerialization['versionId'] as int,
      version: jsonSerialization['version'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.ShoebillTemplateVersion>(
              jsonSerialization['version'],
            ),
      implementations: jsonSerialization['implementations'] == null
          ? null
          : _i5.Protocol()
                .deserialize<List<_i4.ShoebillTemplateBaselineImplementation>>(
                  jsonSerialization['implementations'],
                ),
    );
  }

  /// The id of the object.
  _i1.UuidValue id;

  _i2.SupportedLanguages referenceLanguage;

  DateTime createdAt;

  int versionId;

  _i3.ShoebillTemplateVersion? version;

  List<_i4.ShoebillTemplateBaselineImplementation>? implementations;

  /// Returns a shallow copy of this [ShoebillTemplateBaseline]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoebillTemplateBaseline copyWith({
    _i1.UuidValue? id,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
    int? versionId,
    _i3.ShoebillTemplateVersion? version,
    List<_i4.ShoebillTemplateBaselineImplementation>? implementations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoebillTemplateBaseline',
      'id': id.toJson(),
      'referenceLanguage': referenceLanguage.toJson(),
      'createdAt': createdAt.toJson(),
      'versionId': versionId,
      if (version != null) 'version': version?.toJson(),
      if (implementations != null)
        'implementations': implementations?.toJson(
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

class _ShoebillTemplateBaselineImpl extends ShoebillTemplateBaseline {
  _ShoebillTemplateBaselineImpl({
    _i1.UuidValue? id,
    required _i2.SupportedLanguages referenceLanguage,
    DateTime? createdAt,
    required int versionId,
    _i3.ShoebillTemplateVersion? version,
    List<_i4.ShoebillTemplateBaselineImplementation>? implementations,
  }) : super._(
         id: id,
         referenceLanguage: referenceLanguage,
         createdAt: createdAt,
         versionId: versionId,
         version: version,
         implementations: implementations,
       );

  /// Returns a shallow copy of this [ShoebillTemplateBaseline]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShoebillTemplateBaseline copyWith({
    _i1.UuidValue? id,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
    int? versionId,
    Object? version = _Undefined,
    Object? implementations = _Undefined,
  }) {
    return ShoebillTemplateBaseline(
      id: id ?? this.id,
      referenceLanguage: referenceLanguage ?? this.referenceLanguage,
      createdAt: createdAt ?? this.createdAt,
      versionId: versionId ?? this.versionId,
      version: version is _i3.ShoebillTemplateVersion?
          ? version
          : this.version?.copyWith(),
      implementations:
          implementations is List<_i4.ShoebillTemplateBaselineImplementation>?
          ? implementations
          : this.implementations?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
