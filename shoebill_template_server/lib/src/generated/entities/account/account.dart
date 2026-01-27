/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i2;
import '../../api/pdf_related/entities/template_entities/shoebill_template_scaffold.dart'
    as _i3;
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i4;

abstract class AccountInfo
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = AccountInfoTable();

  static const db = AccountInfoRepository._();

  @override
  int? id;

  _i1.UuidValue authUserId;

  _i2.AuthUser? authUser;

  String email;

  String? name;

  DateTime createdAt;

  List<_i3.ShoebillTemplateScaffold>? scaffolds;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountInfo',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJsonForProtocol(),
      'email': email,
      if (name != null) 'name': name,
      'createdAt': createdAt.toJson(),
      if (scaffolds != null)
        'scaffolds': scaffolds?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  static AccountInfoInclude include({
    _i2.AuthUserInclude? authUser,
    _i3.ShoebillTemplateScaffoldIncludeList? scaffolds,
  }) {
    return AccountInfoInclude._(
      authUser: authUser,
      scaffolds: scaffolds,
    );
  }

  static AccountInfoIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountInfoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountInfoTable>? orderByList,
    AccountInfoInclude? include,
  }) {
    return AccountInfoIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountInfo.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountInfo.t),
      include: include,
    );
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

class AccountInfoUpdateTable extends _i1.UpdateTable<AccountInfoTable> {
  AccountInfoUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authUserId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> name(String? value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AccountInfoTable extends _i1.Table<int?> {
  AccountInfoTable({super.tableRelation}) : super(tableName: 'account_info') {
    updateTable = AccountInfoUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final AccountInfoUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  _i2.AuthUserTable? _authUser;

  late final _i1.ColumnString email;

  late final _i1.ColumnString name;

  late final _i1.ColumnDateTime createdAt;

  _i3.ShoebillTemplateScaffoldTable? ___scaffolds;

  _i1.ManyRelation<_i3.ShoebillTemplateScaffoldTable>? _scaffolds;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: AccountInfo.t.authUserId,
      foreignField: _i2.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  _i3.ShoebillTemplateScaffoldTable get __scaffolds {
    if (___scaffolds != null) return ___scaffolds!;
    ___scaffolds = _i1.createRelationTable(
      relationFieldName: '__scaffolds',
      field: AccountInfo.t.id,
      foreignField: _i3.ShoebillTemplateScaffold.t.accountId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _i3.ShoebillTemplateScaffoldTable(
        tableRelation: foreignTableRelation,
      ),
    );
    return ___scaffolds!;
  }

  _i1.ManyRelation<_i3.ShoebillTemplateScaffoldTable> get scaffolds {
    if (_scaffolds != null) return _scaffolds!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'scaffolds',
      field: AccountInfo.t.id,
      foreignField: _i3.ShoebillTemplateScaffold.t.accountId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _i3.ShoebillTemplateScaffoldTable(
        tableRelation: foreignTableRelation,
      ),
    );
    _scaffolds = _i1.ManyRelation<_i3.ShoebillTemplateScaffoldTable>(
      tableWithRelations: relationTable,
      table: _i3.ShoebillTemplateScaffoldTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _scaffolds!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    authUserId,
    email,
    name,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    if (relationField == 'scaffolds') {
      return __scaffolds;
    }
    return null;
  }
}

class AccountInfoInclude extends _i1.IncludeObject {
  AccountInfoInclude._({
    _i2.AuthUserInclude? authUser,
    _i3.ShoebillTemplateScaffoldIncludeList? scaffolds,
  }) {
    _authUser = authUser;
    _scaffolds = scaffolds;
  }

  _i2.AuthUserInclude? _authUser;

  _i3.ShoebillTemplateScaffoldIncludeList? _scaffolds;

  @override
  Map<String, _i1.Include?> get includes => {
    'authUser': _authUser,
    'scaffolds': _scaffolds,
  };

  @override
  _i1.Table<int?> get table => AccountInfo.t;
}

class AccountInfoIncludeList extends _i1.IncludeList {
  AccountInfoIncludeList._({
    _i1.WhereExpressionBuilder<AccountInfoTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountInfo.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountInfo.t;
}

class AccountInfoRepository {
  const AccountInfoRepository._();

  final attach = const AccountInfoAttachRepository._();

  final attachRow = const AccountInfoAttachRowRepository._();

  final detach = const AccountInfoDetachRepository._();

  final detachRow = const AccountInfoDetachRowRepository._();

  /// Returns a list of [AccountInfo]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<AccountInfo>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountInfoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountInfoTable>? orderByList,
    _i1.Transaction? transaction,
    AccountInfoInclude? include,
  }) async {
    return session.db.find<AccountInfo>(
      where: where?.call(AccountInfo.t),
      orderBy: orderBy?.call(AccountInfo.t),
      orderByList: orderByList?.call(AccountInfo.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [AccountInfo] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<AccountInfo?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountInfoTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountInfoTable>? orderByList,
    _i1.Transaction? transaction,
    AccountInfoInclude? include,
  }) async {
    return session.db.findFirstRow<AccountInfo>(
      where: where?.call(AccountInfo.t),
      orderBy: orderBy?.call(AccountInfo.t),
      orderByList: orderByList?.call(AccountInfo.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [AccountInfo] by its [id] or null if no such row exists.
  Future<AccountInfo?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    AccountInfoInclude? include,
  }) async {
    return session.db.findById<AccountInfo>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [AccountInfo]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountInfo]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AccountInfo>> insert(
    _i1.Session session,
    List<AccountInfo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AccountInfo>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AccountInfo] and returns the inserted row.
  ///
  /// The returned [AccountInfo] will have its `id` field set.
  Future<AccountInfo> insertRow(
    _i1.Session session,
    AccountInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountInfo>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountInfo]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountInfo>> update(
    _i1.Session session,
    List<AccountInfo> rows, {
    _i1.ColumnSelections<AccountInfoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountInfo>(
      rows,
      columns: columns?.call(AccountInfo.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountInfo]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountInfo> updateRow(
    _i1.Session session,
    AccountInfo row, {
    _i1.ColumnSelections<AccountInfoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountInfo>(
      row,
      columns: columns?.call(AccountInfo.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountInfo] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountInfo?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountInfoUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountInfo>(
      id,
      columnValues: columnValues(AccountInfo.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountInfo]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountInfo>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AccountInfoUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AccountInfoTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountInfoTable>? orderBy,
    _i1.OrderByListBuilder<AccountInfoTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountInfo>(
      columnValues: columnValues(AccountInfo.t.updateTable),
      where: where(AccountInfo.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountInfo.t),
      orderByList: orderByList?.call(AccountInfo.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountInfo]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountInfo>> delete(
    _i1.Session session,
    List<AccountInfo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountInfo>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountInfo].
  Future<AccountInfo> deleteRow(
    _i1.Session session,
    AccountInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountInfo>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountInfo>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AccountInfoTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountInfo>(
      where: where(AccountInfo.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountInfoTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountInfo>(
      where: where?.call(AccountInfo.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AccountInfoAttachRepository {
  const AccountInfoAttachRepository._();

  /// Creates a relation between this [AccountInfo] and the given [ShoebillTemplateScaffold]s
  /// by setting each [ShoebillTemplateScaffold]'s foreign key `accountId` to refer to this [AccountInfo].
  Future<void> scaffolds(
    _i1.Session session,
    AccountInfo accountInfo,
    List<_i3.ShoebillTemplateScaffold> shoebillTemplateScaffold, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateScaffold.any((e) => e.id == null)) {
      throw ArgumentError.notNull('shoebillTemplateScaffold.id');
    }
    if (accountInfo.id == null) {
      throw ArgumentError.notNull('accountInfo.id');
    }

    var $shoebillTemplateScaffold = shoebillTemplateScaffold
        .map((e) => e.copyWith(accountId: accountInfo.id))
        .toList();
    await session.db.update<_i3.ShoebillTemplateScaffold>(
      $shoebillTemplateScaffold,
      columns: [_i3.ShoebillTemplateScaffold.t.accountId],
      transaction: transaction,
    );
  }
}

class AccountInfoAttachRowRepository {
  const AccountInfoAttachRowRepository._();

  /// Creates a relation between the given [AccountInfo] and [AuthUser]
  /// by setting the [AccountInfo]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    AccountInfo accountInfo,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (accountInfo.id == null) {
      throw ArgumentError.notNull('accountInfo.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $accountInfo = accountInfo.copyWith(authUserId: authUser.id);
    await session.db.updateRow<AccountInfo>(
      $accountInfo,
      columns: [AccountInfo.t.authUserId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [AccountInfo] and the given [ShoebillTemplateScaffold]
  /// by setting the [ShoebillTemplateScaffold]'s foreign key `accountId` to refer to this [AccountInfo].
  Future<void> scaffolds(
    _i1.Session session,
    AccountInfo accountInfo,
    _i3.ShoebillTemplateScaffold shoebillTemplateScaffold, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateScaffold.id == null) {
      throw ArgumentError.notNull('shoebillTemplateScaffold.id');
    }
    if (accountInfo.id == null) {
      throw ArgumentError.notNull('accountInfo.id');
    }

    var $shoebillTemplateScaffold = shoebillTemplateScaffold.copyWith(
      accountId: accountInfo.id,
    );
    await session.db.updateRow<_i3.ShoebillTemplateScaffold>(
      $shoebillTemplateScaffold,
      columns: [_i3.ShoebillTemplateScaffold.t.accountId],
      transaction: transaction,
    );
  }
}

class AccountInfoDetachRepository {
  const AccountInfoDetachRepository._();

  /// Detaches the relation between this [AccountInfo] and the given [ShoebillTemplateScaffold]
  /// by setting the [ShoebillTemplateScaffold]'s foreign key `accountId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> scaffolds(
    _i1.Session session,
    List<_i3.ShoebillTemplateScaffold> shoebillTemplateScaffold, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateScaffold.any((e) => e.id == null)) {
      throw ArgumentError.notNull('shoebillTemplateScaffold.id');
    }

    var $shoebillTemplateScaffold = shoebillTemplateScaffold
        .map((e) => e.copyWith(accountId: null))
        .toList();
    await session.db.update<_i3.ShoebillTemplateScaffold>(
      $shoebillTemplateScaffold,
      columns: [_i3.ShoebillTemplateScaffold.t.accountId],
      transaction: transaction,
    );
  }
}

class AccountInfoDetachRowRepository {
  const AccountInfoDetachRowRepository._();

  /// Detaches the relation between this [AccountInfo] and the given [ShoebillTemplateScaffold]
  /// by setting the [ShoebillTemplateScaffold]'s foreign key `accountId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> scaffolds(
    _i1.Session session,
    _i3.ShoebillTemplateScaffold shoebillTemplateScaffold, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateScaffold.id == null) {
      throw ArgumentError.notNull('shoebillTemplateScaffold.id');
    }

    var $shoebillTemplateScaffold = shoebillTemplateScaffold.copyWith(
      accountId: null,
    );
    await session.db.updateRow<_i3.ShoebillTemplateScaffold>(
      $shoebillTemplateScaffold,
      columns: [_i3.ShoebillTemplateScaffold.t.accountId],
      transaction: transaction,
    );
  }
}
