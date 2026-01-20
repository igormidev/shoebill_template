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
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_version.dart'
    as _i2;
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i3;

abstract class ShoebillTemplateVersionInput
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ShoebillTemplateVersionInputTable();

  static const db = ShoebillTemplateVersionInputRepository._();

  @override
  int? id;

  _i2.ShoebillTemplateVersion? user;

  String htmlContent;

  String cssContent;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShoebillTemplateVersionInput',
      if (id != null) 'id': id,
      if (user != null) 'user': user?.toJsonForProtocol(),
      'htmlContent': htmlContent,
      'cssContent': cssContent,
    };
  }

  static ShoebillTemplateVersionInputInclude include({
    _i2.ShoebillTemplateVersionInclude? user,
  }) {
    return ShoebillTemplateVersionInputInclude._(user: user);
  }

  static ShoebillTemplateVersionInputIncludeList includeList({
    _i1.WhereExpressionBuilder<ShoebillTemplateVersionInputTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateVersionInputTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateVersionInputTable>? orderByList,
    ShoebillTemplateVersionInputInclude? include,
  }) {
    return ShoebillTemplateVersionInputIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoebillTemplateVersionInput.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ShoebillTemplateVersionInput.t),
      include: include,
    );
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

class ShoebillTemplateVersionInputUpdateTable
    extends _i1.UpdateTable<ShoebillTemplateVersionInputTable> {
  ShoebillTemplateVersionInputUpdateTable(super.table);

  _i1.ColumnValue<String, String> htmlContent(String value) => _i1.ColumnValue(
    table.htmlContent,
    value,
  );

  _i1.ColumnValue<String, String> cssContent(String value) => _i1.ColumnValue(
    table.cssContent,
    value,
  );
}

class ShoebillTemplateVersionInputTable extends _i1.Table<int?> {
  ShoebillTemplateVersionInputTable({super.tableRelation})
    : super(tableName: 'shoebill_template_version_inputs') {
    updateTable = ShoebillTemplateVersionInputUpdateTable(this);
    htmlContent = _i1.ColumnString(
      'htmlContent',
      this,
    );
    cssContent = _i1.ColumnString(
      'cssContent',
      this,
    );
  }

  late final ShoebillTemplateVersionInputUpdateTable updateTable;

  _i2.ShoebillTemplateVersionTable? _user;

  late final _i1.ColumnString htmlContent;

  late final _i1.ColumnString cssContent;

  _i2.ShoebillTemplateVersionTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: ShoebillTemplateVersionInput.t.id,
      foreignField: _i2.ShoebillTemplateVersion.t.inputId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ShoebillTemplateVersionTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    htmlContent,
    cssContent,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'user') {
      return user;
    }
    return null;
  }
}

class ShoebillTemplateVersionInputInclude extends _i1.IncludeObject {
  ShoebillTemplateVersionInputInclude._({
    _i2.ShoebillTemplateVersionInclude? user,
  }) {
    _user = user;
  }

  _i2.ShoebillTemplateVersionInclude? _user;

  @override
  Map<String, _i1.Include?> get includes => {'user': _user};

  @override
  _i1.Table<int?> get table => ShoebillTemplateVersionInput.t;
}

class ShoebillTemplateVersionInputIncludeList extends _i1.IncludeList {
  ShoebillTemplateVersionInputIncludeList._({
    _i1.WhereExpressionBuilder<ShoebillTemplateVersionInputTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ShoebillTemplateVersionInput.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ShoebillTemplateVersionInput.t;
}

class ShoebillTemplateVersionInputRepository {
  const ShoebillTemplateVersionInputRepository._();

  final attachRow = const ShoebillTemplateVersionInputAttachRowRepository._();

  /// Returns a list of [ShoebillTemplateVersionInput]s matching the given query parameters.
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
  Future<List<ShoebillTemplateVersionInput>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateVersionInputTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateVersionInputTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateVersionInputTable>? orderByList,
    _i1.Transaction? transaction,
    ShoebillTemplateVersionInputInclude? include,
  }) async {
    return session.db.find<ShoebillTemplateVersionInput>(
      where: where?.call(ShoebillTemplateVersionInput.t),
      orderBy: orderBy?.call(ShoebillTemplateVersionInput.t),
      orderByList: orderByList?.call(ShoebillTemplateVersionInput.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ShoebillTemplateVersionInput] matching the given query parameters.
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
  Future<ShoebillTemplateVersionInput?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateVersionInputTable>? where,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateVersionInputTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateVersionInputTable>? orderByList,
    _i1.Transaction? transaction,
    ShoebillTemplateVersionInputInclude? include,
  }) async {
    return session.db.findFirstRow<ShoebillTemplateVersionInput>(
      where: where?.call(ShoebillTemplateVersionInput.t),
      orderBy: orderBy?.call(ShoebillTemplateVersionInput.t),
      orderByList: orderByList?.call(ShoebillTemplateVersionInput.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ShoebillTemplateVersionInput] by its [id] or null if no such row exists.
  Future<ShoebillTemplateVersionInput?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ShoebillTemplateVersionInputInclude? include,
  }) async {
    return session.db.findById<ShoebillTemplateVersionInput>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ShoebillTemplateVersionInput]s in the list and returns the inserted rows.
  ///
  /// The returned [ShoebillTemplateVersionInput]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ShoebillTemplateVersionInput>> insert(
    _i1.Session session,
    List<ShoebillTemplateVersionInput> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ShoebillTemplateVersionInput>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ShoebillTemplateVersionInput] and returns the inserted row.
  ///
  /// The returned [ShoebillTemplateVersionInput] will have its `id` field set.
  Future<ShoebillTemplateVersionInput> insertRow(
    _i1.Session session,
    ShoebillTemplateVersionInput row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ShoebillTemplateVersionInput>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ShoebillTemplateVersionInput]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ShoebillTemplateVersionInput>> update(
    _i1.Session session,
    List<ShoebillTemplateVersionInput> rows, {
    _i1.ColumnSelections<ShoebillTemplateVersionInputTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ShoebillTemplateVersionInput>(
      rows,
      columns: columns?.call(ShoebillTemplateVersionInput.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoebillTemplateVersionInput]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ShoebillTemplateVersionInput> updateRow(
    _i1.Session session,
    ShoebillTemplateVersionInput row, {
    _i1.ColumnSelections<ShoebillTemplateVersionInputTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ShoebillTemplateVersionInput>(
      row,
      columns: columns?.call(ShoebillTemplateVersionInput.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoebillTemplateVersionInput] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ShoebillTemplateVersionInput?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ShoebillTemplateVersionInputUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ShoebillTemplateVersionInput>(
      id,
      columnValues: columnValues(ShoebillTemplateVersionInput.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ShoebillTemplateVersionInput]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ShoebillTemplateVersionInput>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ShoebillTemplateVersionInputUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ShoebillTemplateVersionInputTable>
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateVersionInputTable>? orderBy,
    _i1.OrderByListBuilder<ShoebillTemplateVersionInputTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ShoebillTemplateVersionInput>(
      columnValues: columnValues(ShoebillTemplateVersionInput.t.updateTable),
      where: where(ShoebillTemplateVersionInput.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoebillTemplateVersionInput.t),
      orderByList: orderByList?.call(ShoebillTemplateVersionInput.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ShoebillTemplateVersionInput]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ShoebillTemplateVersionInput>> delete(
    _i1.Session session,
    List<ShoebillTemplateVersionInput> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ShoebillTemplateVersionInput>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ShoebillTemplateVersionInput].
  Future<ShoebillTemplateVersionInput> deleteRow(
    _i1.Session session,
    ShoebillTemplateVersionInput row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ShoebillTemplateVersionInput>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ShoebillTemplateVersionInput>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ShoebillTemplateVersionInputTable>
    where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ShoebillTemplateVersionInput>(
      where: where(ShoebillTemplateVersionInput.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateVersionInputTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ShoebillTemplateVersionInput>(
      where: where?.call(ShoebillTemplateVersionInput.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ShoebillTemplateVersionInputAttachRowRepository {
  const ShoebillTemplateVersionInputAttachRowRepository._();

  /// Creates a relation between the given [ShoebillTemplateVersionInput] and [ShoebillTemplateVersion]
  /// by setting the [ShoebillTemplateVersionInput]'s foreign key `id` to refer to the [ShoebillTemplateVersion].
  Future<void> user(
    _i1.Session session,
    ShoebillTemplateVersionInput shoebillTemplateVersionInput,
    _i2.ShoebillTemplateVersion user, {
    _i1.Transaction? transaction,
  }) async {
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }
    if (shoebillTemplateVersionInput.id == null) {
      throw ArgumentError.notNull('shoebillTemplateVersionInput.id');
    }

    var $user = user.copyWith(inputId: shoebillTemplateVersionInput.id);
    await session.db.updateRow<_i2.ShoebillTemplateVersion>(
      $user,
      columns: [_i2.ShoebillTemplateVersion.t.inputId],
      transaction: transaction,
    );
  }
}
