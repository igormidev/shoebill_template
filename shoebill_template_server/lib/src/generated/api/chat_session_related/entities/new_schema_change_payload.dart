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
import '../../../api/pdf_related/entities/schema_definition.dart' as _i2;
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i3;

abstract class NewSchemaChangePayload
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  NewSchemaChangePayload._({
    required this.newSchemaDefinition,
    required this.newExamplePayloadStringified,
  });

  factory NewSchemaChangePayload({
    required _i2.SchemaDefinition newSchemaDefinition,
    required String newExamplePayloadStringified,
  }) = _NewSchemaChangePayloadImpl;

  factory NewSchemaChangePayload.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NewSchemaChangePayload(
      newSchemaDefinition: _i3.Protocol().deserialize<_i2.SchemaDefinition>(
        jsonSerialization['newSchemaDefinition'],
      ),
      newExamplePayloadStringified:
          jsonSerialization['newExamplePayloadStringified'] as String,
    );
  }

  _i2.SchemaDefinition newSchemaDefinition;

  String newExamplePayloadStringified;

  /// Returns a shallow copy of this [NewSchemaChangePayload]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NewSchemaChangePayload copyWith({
    _i2.SchemaDefinition? newSchemaDefinition,
    String? newExamplePayloadStringified,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NewSchemaChangePayload',
      'newSchemaDefinition': newSchemaDefinition.toJson(),
      'newExamplePayloadStringified': newExamplePayloadStringified,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NewSchemaChangePayload',
      'newSchemaDefinition': newSchemaDefinition.toJsonForProtocol(),
      'newExamplePayloadStringified': newExamplePayloadStringified,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _NewSchemaChangePayloadImpl extends NewSchemaChangePayload {
  _NewSchemaChangePayloadImpl({
    required _i2.SchemaDefinition newSchemaDefinition,
    required String newExamplePayloadStringified,
  }) : super._(
         newSchemaDefinition: newSchemaDefinition,
         newExamplePayloadStringified: newExamplePayloadStringified,
       );

  /// Returns a shallow copy of this [NewSchemaChangePayload]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NewSchemaChangePayload copyWith({
    _i2.SchemaDefinition? newSchemaDefinition,
    String? newExamplePayloadStringified,
  }) {
    return NewSchemaChangePayload(
      newSchemaDefinition:
          newSchemaDefinition ?? this.newSchemaDefinition.copyWith(),
      newExamplePayloadStringified:
          newExamplePayloadStringified ?? this.newExamplePayloadStringified,
    );
  }
}
