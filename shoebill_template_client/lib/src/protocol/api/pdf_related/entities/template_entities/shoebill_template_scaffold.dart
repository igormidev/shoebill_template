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
import '../../../../api/pdf_related/entities/pdf_content.dart' as _i2;
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_version.dart'
    as _i3;
import '../../../../entities/account/account.dart' as _i4;
import 'package:shoebill_template_client/src/protocol/protocol.dart' as _i5;

abstract class ShoebillTemplateScaffold implements _i1.SerializableModel {
  ShoebillTemplateScaffold._({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required this.referencePdfContentId,
    this.referencePdfContent,
    this.versions,
    this.accountId,
    this.account,
  }) : id = id ?? _i1.Uuid().v7obj(),
       createdAt = createdAt ?? DateTime.now();

  factory ShoebillTemplateScaffold({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required int referencePdfContentId,
    _i2.PdfContent? referencePdfContent,
    List<_i3.ShoebillTemplateVersion>? versions,
    int? accountId,
    _i4.AccountInfo? account,
  }) = _ShoebillTemplateScaffoldImpl;

  factory ShoebillTemplateScaffold.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ShoebillTemplateScaffold(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      referencePdfContentId: jsonSerialization['referencePdfContentId'] as int,
      referencePdfContent: jsonSerialization['referencePdfContent'] == null
          ? null
          : _i5.Protocol().deserialize<_i2.PdfContent>(
              jsonSerialization['referencePdfContent'],
            ),
      versions: jsonSerialization['versions'] == null
          ? null
          : _i5.Protocol().deserialize<List<_i3.ShoebillTemplateVersion>>(
              jsonSerialization['versions'],
            ),
      accountId: jsonSerialization['accountId'] as int?,
      account: jsonSerialization['account'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.AccountInfo>(
              jsonSerialization['account'],
            ),
    );
  }

  /// The id of the object.
  _i1.UuidValue id;

  DateTime createdAt;

  int referencePdfContentId;

  _i2.PdfContent? referencePdfContent;

  List<_i3.ShoebillTemplateVersion>? versions;

  int? accountId;

  _i4.AccountInfo? account;

  /// Returns a shallow copy of this [ShoebillTemplateScaffold]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoebillTemplateScaffold copyWith({
    _i1.UuidValue? id,
    DateTime? createdAt,
    int? referencePdfContentId,
    _i2.PdfContent? referencePdfContent,
    List<_i3.ShoebillTemplateVersion>? versions,
    int? accountId,
    _i4.AccountInfo? account,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoebillTemplateScaffold',
      'id': id.toJson(),
      'createdAt': createdAt.toJson(),
      'referencePdfContentId': referencePdfContentId,
      if (referencePdfContent != null)
        'referencePdfContent': referencePdfContent?.toJson(),
      if (versions != null)
        'versions': versions?.toJson(valueToJson: (v) => v.toJson()),
      if (accountId != null) 'accountId': accountId,
      if (account != null) 'account': account?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoebillTemplateScaffoldImpl extends ShoebillTemplateScaffold {
  _ShoebillTemplateScaffoldImpl({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required int referencePdfContentId,
    _i2.PdfContent? referencePdfContent,
    List<_i3.ShoebillTemplateVersion>? versions,
    int? accountId,
    _i4.AccountInfo? account,
  }) : super._(
         id: id,
         createdAt: createdAt,
         referencePdfContentId: referencePdfContentId,
         referencePdfContent: referencePdfContent,
         versions: versions,
         accountId: accountId,
         account: account,
       );

  /// Returns a shallow copy of this [ShoebillTemplateScaffold]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShoebillTemplateScaffold copyWith({
    _i1.UuidValue? id,
    DateTime? createdAt,
    int? referencePdfContentId,
    Object? referencePdfContent = _Undefined,
    Object? versions = _Undefined,
    Object? accountId = _Undefined,
    Object? account = _Undefined,
  }) {
    return ShoebillTemplateScaffold(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      referencePdfContentId:
          referencePdfContentId ?? this.referencePdfContentId,
      referencePdfContent: referencePdfContent is _i2.PdfContent?
          ? referencePdfContent
          : this.referencePdfContent?.copyWith(),
      versions: versions is List<_i3.ShoebillTemplateVersion>?
          ? versions
          : this.versions?.map((e0) => e0.copyWith()).toList(),
      accountId: accountId is int? ? accountId : this.accountId,
      account: account is _i4.AccountInfo? ? account : this.account?.copyWith(),
    );
  }
}
