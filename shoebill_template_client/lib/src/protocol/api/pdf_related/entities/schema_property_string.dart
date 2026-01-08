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

abstract class SchemaPropertyString extends _i1.SchemaProperty
    implements _i2.SerializableModel {
  SchemaPropertyString._({
    required super.nullable,
    super.description,
    required this.shouldBeTranslated,
  });

  factory SchemaPropertyString({
    required bool nullable,
    String? description,
    required bool shouldBeTranslated,
  }) = _SchemaPropertyStringImpl;

  factory SchemaPropertyString.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SchemaPropertyString(
      nullable: jsonSerialization['nullable'] as bool,
      description: jsonSerialization['description'] as String?,
      shouldBeTranslated: jsonSerialization['shouldBeTranslated'] as bool,
    );
  }

  bool shouldBeTranslated;

  /// Returns a shallow copy of this [SchemaPropertyString]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  SchemaPropertyString copyWith({
    bool? nullable,
    Object? description,
    bool? shouldBeTranslated,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SchemaPropertyString',
      'nullable': nullable,
      if (description != null) 'description': description,
      'shouldBeTranslated': shouldBeTranslated,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _SchemaPropertyStringImpl extends SchemaPropertyString {
  _SchemaPropertyStringImpl({
    required bool nullable,
    String? description,
    required bool shouldBeTranslated,
  }) : super._(
         nullable: nullable,
         description: description,
         shouldBeTranslated: shouldBeTranslated,
       );

  /// Returns a shallow copy of this [SchemaPropertyString]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  SchemaPropertyString copyWith({
    bool? nullable,
    Object? description = _Undefined,
    bool? shouldBeTranslated,
  }) {
    return SchemaPropertyString(
      nullable: nullable ?? this.nullable,
      description: description is String? ? description : this.description,
      shouldBeTranslated: shouldBeTranslated ?? this.shouldBeTranslated,
    );
  }
}
