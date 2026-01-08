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
import 'package:serverpod/serverpod.dart' as _i1;
import '../../../api/pdf_related/entities/schema_property.dart' as _i2;
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i3;

abstract class SchemaDefinition
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  SchemaDefinition._({required this.properties});

  factory SchemaDefinition({
    required Map<String, _i2.SchemaProperty> properties,
  }) = _SchemaDefinitionImpl;

  factory SchemaDefinition.fromJson(Map<String, dynamic> jsonSerialization) {
    return SchemaDefinition(
      properties: _i3.Protocol().deserialize<Map<String, _i2.SchemaProperty>>(
        jsonSerialization['properties'],
      ),
    );
  }

  Map<String, _i2.SchemaProperty> properties;

  /// Returns a shallow copy of this [SchemaDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SchemaDefinition copyWith({Map<String, _i2.SchemaProperty>? properties});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SchemaDefinition',
      'properties': properties.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SchemaDefinition',
      'properties': properties.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SchemaDefinitionImpl extends SchemaDefinition {
  _SchemaDefinitionImpl({required Map<String, _i2.SchemaProperty> properties})
    : super._(properties: properties);

  /// Returns a shallow copy of this [SchemaDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SchemaDefinition copyWith({Map<String, _i2.SchemaProperty>? properties}) {
    return SchemaDefinition(
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
