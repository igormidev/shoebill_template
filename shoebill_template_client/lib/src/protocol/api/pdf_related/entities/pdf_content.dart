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

abstract class PdfContent implements _i1.SerializableModel {
  PdfContent._({
    this.id,
    required this.name,
    required this.description,
  });

  factory PdfContent({
    int? id,
    required String name,
    required String description,
  }) = _PdfContentImpl;

  factory PdfContent.fromJson(Map<String, dynamic> jsonSerialization) {
    return PdfContent(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String description;

  /// Returns a shallow copy of this [PdfContent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PdfContent copyWith({
    int? id,
    String? name,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PdfContent',
      if (id != null) 'id': id,
      'name': name,
      'description': description,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PdfContentImpl extends PdfContent {
  _PdfContentImpl({
    int? id,
    required String name,
    required String description,
  }) : super._(
         id: id,
         name: name,
         description: description,
       );

  /// Returns a shallow copy of this [PdfContent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PdfContent copyWith({
    Object? id = _Undefined,
    String? name,
    String? description,
  }) {
    return PdfContent(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
