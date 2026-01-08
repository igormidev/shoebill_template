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

abstract class SchemaPropertyObjectWithUndefinedProperties
    extends _i1.SchemaProperty
    implements _i2.SerializableModel {
  SchemaPropertyObjectWithUndefinedProperties._({
    required super.nullable,
    super.description,
  });

  factory SchemaPropertyObjectWithUndefinedProperties({
    required bool nullable,
    String? description,
  }) = _SchemaPropertyObjectWithUndefinedPropertiesImpl;

  factory SchemaPropertyObjectWithUndefinedProperties.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SchemaPropertyObjectWithUndefinedProperties(
      nullable: jsonSerialization['nullable'] as bool,
      description: jsonSerialization['description'] as String?,
    );
  }

  /// Returns a shallow copy of this [SchemaPropertyObjectWithUndefinedProperties]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  SchemaPropertyObjectWithUndefinedProperties copyWith({
    bool? nullable,
    Object? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SchemaPropertyObjectWithUndefinedProperties',
      'nullable': nullable,
      if (description != null) 'description': description,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _SchemaPropertyObjectWithUndefinedPropertiesImpl
    extends SchemaPropertyObjectWithUndefinedProperties {
  _SchemaPropertyObjectWithUndefinedPropertiesImpl({
    required bool nullable,
    String? description,
  }) : super._(
         nullable: nullable,
         description: description,
       );

  /// Returns a shallow copy of this [SchemaPropertyObjectWithUndefinedProperties]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  SchemaPropertyObjectWithUndefinedProperties copyWith({
    bool? nullable,
    Object? description = _Undefined,
  }) {
    return SchemaPropertyObjectWithUndefinedProperties(
      nullable: nullable ?? this.nullable,
      description: description is String? ? description : this.description,
    );
  }
}
