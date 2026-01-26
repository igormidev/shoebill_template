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
import '../../../../protocol.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;
import 'schema_property.dart' as _i3;
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i4;
part 'schema_property_array.dart';
part 'schema_property_boolean.dart';
part 'schema_property_double.dart';
part 'schema_property_enum.dart';
part 'schema_property_integer.dart';
part 'schema_property_object_with_undefined_properties.dart';
part 'schema_property_string.dart';
part 'schema_property_structured_object.dart';

sealed class SchemaProperty
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  SchemaProperty({
    required this.nullable,
    this.description,
  });

  bool nullable;

  String? description;

  /// Returns a shallow copy of this [SchemaProperty]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  SchemaProperty copyWith({
    bool? nullable,
    String? description,
  });
}
