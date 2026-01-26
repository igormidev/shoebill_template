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
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_baseline.dart'
    as _i3;
import 'package:shoebill_template_client/src/protocol/protocol.dart' as _i4;

abstract class ShoebillTemplateBaselineImplementation
    implements _i1.SerializableModel {
  ShoebillTemplateBaselineImplementation._({
    this.id,
    required this.stringifiedPayload,
    required this.language,
    DateTime? createdAt,
    required this.baselineId,
    this.baseline,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ShoebillTemplateBaselineImplementation({
    int? id,
    required String stringifiedPayload,
    required _i2.SupportedLanguage language,
    DateTime? createdAt,
    required _i1.UuidValue baselineId,
    _i3.ShoebillTemplateBaseline? baseline,
  }) = _ShoebillTemplateBaselineImplementationImpl;

  factory ShoebillTemplateBaselineImplementation.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ShoebillTemplateBaselineImplementation(
      id: jsonSerialization['id'] as int?,
      stringifiedPayload: jsonSerialization['stringifiedPayload'] as String,
      language: _i2.SupportedLanguage.fromJson(
        (jsonSerialization['language'] as String),
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      baselineId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['baselineId'],
      ),
      baseline: jsonSerialization['baseline'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.ShoebillTemplateBaseline>(
              jsonSerialization['baseline'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String stringifiedPayload;

  _i2.SupportedLanguage language;

  DateTime createdAt;

  _i1.UuidValue baselineId;

  _i3.ShoebillTemplateBaseline? baseline;

  /// Returns a shallow copy of this [ShoebillTemplateBaselineImplementation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoebillTemplateBaselineImplementation copyWith({
    int? id,
    String? stringifiedPayload,
    _i2.SupportedLanguage? language,
    DateTime? createdAt,
    _i1.UuidValue? baselineId,
    _i3.ShoebillTemplateBaseline? baseline,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoebillTemplateBaselineImplementation',
      if (id != null) 'id': id,
      'stringifiedPayload': stringifiedPayload,
      'language': language.toJson(),
      'createdAt': createdAt.toJson(),
      'baselineId': baselineId.toJson(),
      if (baseline != null) 'baseline': baseline?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoebillTemplateBaselineImplementationImpl
    extends ShoebillTemplateBaselineImplementation {
  _ShoebillTemplateBaselineImplementationImpl({
    int? id,
    required String stringifiedPayload,
    required _i2.SupportedLanguage language,
    DateTime? createdAt,
    required _i1.UuidValue baselineId,
    _i3.ShoebillTemplateBaseline? baseline,
  }) : super._(
         id: id,
         stringifiedPayload: stringifiedPayload,
         language: language,
         createdAt: createdAt,
         baselineId: baselineId,
         baseline: baseline,
       );

  /// Returns a shallow copy of this [ShoebillTemplateBaselineImplementation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShoebillTemplateBaselineImplementation copyWith({
    Object? id = _Undefined,
    String? stringifiedPayload,
    _i2.SupportedLanguage? language,
    DateTime? createdAt,
    _i1.UuidValue? baselineId,
    Object? baseline = _Undefined,
  }) {
    return ShoebillTemplateBaselineImplementation(
      id: id is int? ? id : this.id,
      stringifiedPayload: stringifiedPayload ?? this.stringifiedPayload,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      baselineId: baselineId ?? this.baselineId,
      baseline: baseline is _i3.ShoebillTemplateBaseline?
          ? baseline
          : this.baseline?.copyWith(),
    );
  }
}
