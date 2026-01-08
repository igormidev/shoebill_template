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

abstract class SchemaPropertyStructuredObjectWithDefinedProperties
    extends _i1.SchemaProperty
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  SchemaPropertyStructuredObjectWithDefinedProperties._({
    required super.nullable,
    super.description,
    required this.properties,
  });

  factory SchemaPropertyStructuredObjectWithDefinedProperties({
    required bool nullable,
    String? description,
    required Map<String, _i3.SchemaProperty> properties,
  }) = _SchemaPropertyStructuredObjectWithDefinedPropertiesImpl;

  factory SchemaPropertyStructuredObjectWithDefinedProperties.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SchemaPropertyStructuredObjectWithDefinedProperties(
      nullable: jsonSerialization['nullable'] as bool,
      description: jsonSerialization['description'] as String?,
      properties: _i4.Protocol().deserialize<Map<String, _i3.SchemaProperty>>(
        jsonSerialization['properties'],
      ),
    );
  }

  Map<String, _i3.SchemaProperty> properties;

  /// Returns a shallow copy of this [SchemaPropertyStructuredObjectWithDefinedProperties]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  SchemaPropertyStructuredObjectWithDefinedProperties copyWith({
    bool? nullable,
    Object? description,
    Map<String, _i3.SchemaProperty>? properties,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SchemaPropertyStructuredObjectWithDefinedProperties',
      'nullable': nullable,
      if (description != null) 'description': description,
      'properties': properties.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SchemaPropertyStructuredObjectWithDefinedProperties',
      'nullable': nullable,
      if (description != null) 'description': description,
      'properties': properties.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _SchemaPropertyStructuredObjectWithDefinedPropertiesImpl
    extends SchemaPropertyStructuredObjectWithDefinedProperties {
  _SchemaPropertyStructuredObjectWithDefinedPropertiesImpl({
    required bool nullable,
    String? description,
    required Map<String, _i3.SchemaProperty> properties,
  }) : super._(
         nullable: nullable,
         description: description,
         properties: properties,
       );

  /// Returns a shallow copy of this [SchemaPropertyStructuredObjectWithDefinedProperties]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  SchemaPropertyStructuredObjectWithDefinedProperties copyWith({
    bool? nullable,
    Object? description = _Undefined,
    Map<String, _i3.SchemaProperty>? properties,
  }) {
    return SchemaPropertyStructuredObjectWithDefinedProperties(
      nullable: nullable ?? this.nullable,
      description: description is String? ? description : this.description,
      properties:
          properties ??
          this.properties.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0.copyWith(),
            ),
          ),
    );
  }
}
