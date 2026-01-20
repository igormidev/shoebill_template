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
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_version.dart'
    as _i2;
import 'package:shoebill_template_client/src/protocol/protocol.dart' as _i3;

abstract class ShoebillTemplateVersionInput implements _i1.SerializableModel {
  ShoebillTemplateVersionInput._({
    this.id,
    this.user,
    required this.htmlContent,
    required this.cssContent,
  });

  factory ShoebillTemplateVersionInput({
    int? id,
    _i2.ShoebillTemplateVersion? user,
    required String htmlContent,
    required String cssContent,
  }) = _ShoebillTemplateVersionInputImpl;

  factory ShoebillTemplateVersionInput.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ShoebillTemplateVersionInput(
      id: jsonSerialization['id'] as int?,
      user: jsonSerialization['user'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.ShoebillTemplateVersion>(
              jsonSerialization['user'],
            ),
      htmlContent: jsonSerialization['htmlContent'] as String,
      cssContent: jsonSerialization['cssContent'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2.ShoebillTemplateVersion? user;

  String htmlContent;

  String cssContent;

  /// Returns a shallow copy of this [ShoebillTemplateVersionInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoebillTemplateVersionInput copyWith({
    int? id,
    _i2.ShoebillTemplateVersion? user,
    String? htmlContent,
    String? cssContent,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoebillTemplateVersionInput',
      if (id != null) 'id': id,
      if (user != null) 'user': user?.toJson(),
      'htmlContent': htmlContent,
      'cssContent': cssContent,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoebillTemplateVersionInputImpl extends ShoebillTemplateVersionInput {
  _ShoebillTemplateVersionInputImpl({
    int? id,
    _i2.ShoebillTemplateVersion? user,
    required String htmlContent,
    required String cssContent,
  }) : super._(
         id: id,
         user: user,
         htmlContent: htmlContent,
         cssContent: cssContent,
       );

  /// Returns a shallow copy of this [ShoebillTemplateVersionInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShoebillTemplateVersionInput copyWith({
    Object? id = _Undefined,
    Object? user = _Undefined,
    String? htmlContent,
    String? cssContent,
  }) {
    return ShoebillTemplateVersionInput(
      id: id is int? ? id : this.id,
      user: user is _i2.ShoebillTemplateVersion? ? user : this.user?.copyWith(),
      htmlContent: htmlContent ?? this.htmlContent,
      cssContent: cssContent ?? this.cssContent,
    );
  }
}
