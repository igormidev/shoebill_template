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
import '../../../../api/pdf_related/entities/schema_definition.dart' as _i2;
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_version_input.dart'
    as _i3;
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_scaffold.dart'
    as _i4;
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_baseline.dart'
    as _i5;
import 'package:shoebill_template_client/src/protocol/protocol.dart' as _i6;

abstract class ShoebillTemplateVersion implements _i1.SerializableModel {
  ShoebillTemplateVersion._({
    this.id,
    DateTime? createdAt,
    required this.schemaId,
    this.schema,
    required this.inputId,
    this.input,
    required this.scaffoldId,
    this.scaffold,
    this.implementations,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ShoebillTemplateVersion({
    int? id,
    DateTime? createdAt,
    required int schemaId,
    _i2.SchemaDefinition? schema,
    required int inputId,
    _i3.ShoebillTemplateVersionInput? input,
    required _i1.UuidValue scaffoldId,
    _i4.ShoebillTemplateScaffold? scaffold,
    List<_i5.ShoebillTemplateBaseline>? implementations,
  }) = _ShoebillTemplateVersionImpl;

  factory ShoebillTemplateVersion.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ShoebillTemplateVersion(
      id: jsonSerialization['id'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      schemaId: jsonSerialization['schemaId'] as int,
      schema: jsonSerialization['schema'] == null
          ? null
          : _i6.Protocol().deserialize<_i2.SchemaDefinition>(
              jsonSerialization['schema'],
            ),
      inputId: jsonSerialization['inputId'] as int,
      input: jsonSerialization['input'] == null
          ? null
          : _i6.Protocol().deserialize<_i3.ShoebillTemplateVersionInput>(
              jsonSerialization['input'],
            ),
      scaffoldId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['scaffoldId'],
      ),
      scaffold: jsonSerialization['scaffold'] == null
          ? null
          : _i6.Protocol().deserialize<_i4.ShoebillTemplateScaffold>(
              jsonSerialization['scaffold'],
            ),
      implementations: jsonSerialization['implementations'] == null
          ? null
          : _i6.Protocol().deserialize<List<_i5.ShoebillTemplateBaseline>>(
              jsonSerialization['implementations'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime createdAt;

  int schemaId;

  _i2.SchemaDefinition? schema;

  int inputId;

  _i3.ShoebillTemplateVersionInput? input;

  _i1.UuidValue scaffoldId;

  _i4.ShoebillTemplateScaffold? scaffold;

  List<_i5.ShoebillTemplateBaseline>? implementations;

  /// Returns a shallow copy of this [ShoebillTemplateVersion]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoebillTemplateVersion copyWith({
    int? id,
    DateTime? createdAt,
    int? schemaId,
    _i2.SchemaDefinition? schema,
    int? inputId,
    _i3.ShoebillTemplateVersionInput? input,
    _i1.UuidValue? scaffoldId,
    _i4.ShoebillTemplateScaffold? scaffold,
    List<_i5.ShoebillTemplateBaseline>? implementations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoebillTemplateVersion',
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      'schemaId': schemaId,
      if (schema != null) 'schema': schema?.toJson(),
      'inputId': inputId,
      if (input != null) 'input': input?.toJson(),
      'scaffoldId': scaffoldId.toJson(),
      if (scaffold != null) 'scaffold': scaffold?.toJson(),
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

class _ShoebillTemplateVersionImpl extends ShoebillTemplateVersion {
  _ShoebillTemplateVersionImpl({
    int? id,
    DateTime? createdAt,
    required int schemaId,
    _i2.SchemaDefinition? schema,
    required int inputId,
    _i3.ShoebillTemplateVersionInput? input,
    required _i1.UuidValue scaffoldId,
    _i4.ShoebillTemplateScaffold? scaffold,
    List<_i5.ShoebillTemplateBaseline>? implementations,
  }) : super._(
         id: id,
         createdAt: createdAt,
         schemaId: schemaId,
         schema: schema,
         inputId: inputId,
         input: input,
         scaffoldId: scaffoldId,
         scaffold: scaffold,
         implementations: implementations,
       );

  /// Returns a shallow copy of this [ShoebillTemplateVersion]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShoebillTemplateVersion copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    int? schemaId,
    Object? schema = _Undefined,
    int? inputId,
    Object? input = _Undefined,
    _i1.UuidValue? scaffoldId,
    Object? scaffold = _Undefined,
    Object? implementations = _Undefined,
  }) {
    return ShoebillTemplateVersion(
      id: id is int? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      schemaId: schemaId ?? this.schemaId,
      schema: schema is _i2.SchemaDefinition?
          ? schema
          : this.schema?.copyWith(),
      inputId: inputId ?? this.inputId,
      input: input is _i3.ShoebillTemplateVersionInput?
          ? input
          : this.input?.copyWith(),
      scaffoldId: scaffoldId ?? this.scaffoldId,
      scaffold: scaffold is _i4.ShoebillTemplateScaffold?
          ? scaffold
          : this.scaffold?.copyWith(),
      implementations: implementations is List<_i5.ShoebillTemplateBaseline>?
          ? implementations
          : this.implementations?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
