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

sealed class ShoebillTemplate implements _i1.SerializableModel {
  ShoebillTemplate({
    this.id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  _i1.UuidValue? id;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [ShoebillTemplate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoebillTemplate copyWith({
    _i1.UuidValue? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}
