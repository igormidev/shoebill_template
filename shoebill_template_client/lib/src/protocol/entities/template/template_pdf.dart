/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of 'shoebill_template.dart';

abstract class TemplatePdf extends _i1.ShoebillTemplate
    implements _i2.SerializableModel {
  TemplatePdf._({
    this.id,
    super.createdAt,
    super.updatedAt,
    required this.pythonGeneratorScript,
  });

  factory TemplatePdf({
    _i2.UuidValue? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    required String pythonGeneratorScript,
  }) = _TemplatePdfImpl;

  factory TemplatePdf.fromJson(Map<String, dynamic> jsonSerialization) {
    return TemplatePdf(
      id: jsonSerialization['id'] == null
          ? null
          : _i2.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: _i2.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i2.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      pythonGeneratorScript:
          jsonSerialization['pythonGeneratorScript'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i2.UuidValue? id;

  String pythonGeneratorScript;

  /// Returns a shallow copy of this [TemplatePdf]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  TemplatePdf copyWith({
    Object? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? pythonGeneratorScript,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TemplatePdf',
      if (id != null) 'id': id?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'pythonGeneratorScript': pythonGeneratorScript,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _TemplatePdfImpl extends TemplatePdf {
  _TemplatePdfImpl({
    _i2.UuidValue? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    required String pythonGeneratorScript,
  }) : super._(
         id: id,
         createdAt: createdAt,
         updatedAt: updatedAt,
         pythonGeneratorScript: pythonGeneratorScript,
       );

  /// Returns a shallow copy of this [TemplatePdf]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  TemplatePdf copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? pythonGeneratorScript,
  }) {
    return TemplatePdf(
      id: id is _i2.UuidValue? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pythonGeneratorScript:
          pythonGeneratorScript ?? this.pythonGeneratorScript,
    );
  }
}
