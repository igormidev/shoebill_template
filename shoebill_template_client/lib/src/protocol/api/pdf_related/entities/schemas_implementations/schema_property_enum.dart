/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of 'schema_property.dart';

abstract class SchemaPropertyEnum extends _i1.SchemaProperty
    implements _i2.SerializableModel {
  SchemaPropertyEnum._({
    required super.nullable,
    super.description,
    required this.enumValues,
  });

  factory SchemaPropertyEnum({
    required bool nullable,
    String? description,
    required List<String> enumValues,
  }) = _SchemaPropertyEnumImpl;

  factory SchemaPropertyEnum.fromJson(Map<String, dynamic> jsonSerialization) {
    return SchemaPropertyEnum(
      nullable: jsonSerialization['nullable'] as bool,
      description: jsonSerialization['description'] as String?,
      enumValues: _i4.Protocol().deserialize<List<String>>(
        jsonSerialization['enumValues'],
      ),
    );
  }

  List<String> enumValues;

  /// Returns a shallow copy of this [SchemaPropertyEnum]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  SchemaPropertyEnum copyWith({
    bool? nullable,
    Object? description,
    List<String>? enumValues,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SchemaPropertyEnum',
      'nullable': nullable,
      if (description != null) 'description': description,
      'enumValues': enumValues.toJson(),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _SchemaPropertyEnumImpl extends SchemaPropertyEnum {
  _SchemaPropertyEnumImpl({
    required bool nullable,
    String? description,
    required List<String> enumValues,
  }) : super._(
         nullable: nullable,
         description: description,
         enumValues: enumValues,
       );

  /// Returns a shallow copy of this [SchemaPropertyEnum]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  SchemaPropertyEnum copyWith({
    bool? nullable,
    Object? description = _Undefined,
    List<String>? enumValues,
  }) {
    return SchemaPropertyEnum(
      nullable: nullable ?? this.nullable,
      description: description is String? ? description : this.description,
      enumValues: enumValues ?? this.enumValues.map((e0) => e0).toList(),
    );
  }
}
