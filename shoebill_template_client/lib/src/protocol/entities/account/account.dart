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
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i2;
import '../../api/pdf_related/entities/template_entities/shoebill_template_scaffold.dart'
    as _i3;
import 'package:shoebill_template_client/src/protocol/protocol.dart' as _i4;

abstract class AccountInfo implements _i1.SerializableModel {
  AccountInfo._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.email,
    this.name,
    DateTime? createdAt,
    this.scaffolds,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AccountInfo({
    int? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String email,
    String? name,
    DateTime? createdAt,
    List<_i3.ShoebillTemplateScaffold>? scaffolds,
  }) = _AccountInfoImpl;

  factory AccountInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountInfo(
      id: jsonSerialization['id'] as int?,
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.AuthUser>(
              jsonSerialization['authUser'],
            ),
      email: jsonSerialization['email'] as String,
      name: jsonSerialization['name'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      scaffolds: jsonSerialization['scaffolds'] == null
          ? null
          : _i4.Protocol().deserialize<List<_i3.ShoebillTemplateScaffold>>(
              jsonSerialization['scaffolds'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue authUserId;

  _i2.AuthUser? authUser;

  String email;

  String? name;

  DateTime createdAt;

  List<_i3.ShoebillTemplateScaffold>? scaffolds;

  /// Returns a shallow copy of this [AccountInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountInfo copyWith({
    int? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    String? email,
    String? name,
    DateTime? createdAt,
    List<_i3.ShoebillTemplateScaffold>? scaffolds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountInfo',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'email': email,
      if (name != null) 'name': name,
      'createdAt': createdAt.toJson(),
      if (scaffolds != null)
        'scaffolds': scaffolds?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountInfoImpl extends AccountInfo {
  _AccountInfoImpl({
    int? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String email,
    String? name,
    DateTime? createdAt,
    List<_i3.ShoebillTemplateScaffold>? scaffolds,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         email: email,
         name: name,
         createdAt: createdAt,
         scaffolds: scaffolds,
       );

  /// Returns a shallow copy of this [AccountInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountInfo copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? email,
    Object? name = _Undefined,
    DateTime? createdAt,
    Object? scaffolds = _Undefined,
  }) {
    return AccountInfo(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      email: email ?? this.email,
      name: name is String? ? name : this.name,
      createdAt: createdAt ?? this.createdAt,
      scaffolds: scaffolds is List<_i3.ShoebillTemplateScaffold>?
          ? scaffolds
          : this.scaffolds?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
