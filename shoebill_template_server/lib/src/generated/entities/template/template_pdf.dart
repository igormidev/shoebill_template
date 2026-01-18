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
    implements _i2.TableRow<_i2.UuidValue?>, _i2.ProtocolSerialization {
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
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i2.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i2.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      pythonGeneratorScript:
          jsonSerialization['pythonGeneratorScript'] as String,
    );
  }

  static final t = TemplatePdfTable();

  static const db = TemplatePdfRepository._();

  @override
  _i2.UuidValue? id;

  String pythonGeneratorScript;

  @override
  _i2.Table<_i2.UuidValue?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TemplatePdf',
      if (id != null) 'id': id?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'pythonGeneratorScript': pythonGeneratorScript,
    };
  }

  static TemplatePdfInclude include() {
    return TemplatePdfInclude._();
  }

  static TemplatePdfIncludeList includeList({
    _i2.WhereExpressionBuilder<TemplatePdfTable>? where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<TemplatePdfTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<TemplatePdfTable>? orderByList,
    TemplatePdfInclude? include,
  }) {
    return TemplatePdfIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TemplatePdf.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TemplatePdf.t),
      include: include,
    );
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

class TemplatePdfUpdateTable extends _i2.UpdateTable<TemplatePdfTable> {
  TemplatePdfUpdateTable(super.table);

  _i2.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i2.ColumnValue(
        table.createdAt,
        value,
      );

  _i2.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i2.ColumnValue(
        table.updatedAt,
        value,
      );

  _i2.ColumnValue<String, String> pythonGeneratorScript(String value) =>
      _i2.ColumnValue(
        table.pythonGeneratorScript,
        value,
      );
}

class TemplatePdfTable extends _i2.Table<_i2.UuidValue?> {
  TemplatePdfTable({super.tableRelation}) : super(tableName: 'template_pdf') {
    updateTable = TemplatePdfUpdateTable(this);
    createdAt = _i2.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _i2.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
    pythonGeneratorScript = _i2.ColumnString(
      'pythonGeneratorScript',
      this,
    );
  }

  late final TemplatePdfUpdateTable updateTable;

  late final _i2.ColumnDateTime createdAt;

  late final _i2.ColumnDateTime updatedAt;

  late final _i2.ColumnString pythonGeneratorScript;

  @override
  List<_i2.Column> get columns => [
    id,
    createdAt,
    updatedAt,
    pythonGeneratorScript,
  ];
}

class TemplatePdfInclude extends _i2.IncludeObject {
  TemplatePdfInclude._();

  @override
  Map<String, _i2.Include?> get includes => {};

  @override
  _i2.Table<_i2.UuidValue?> get table => TemplatePdf.t;
}

class TemplatePdfIncludeList extends _i2.IncludeList {
  TemplatePdfIncludeList._({
    _i2.WhereExpressionBuilder<TemplatePdfTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TemplatePdf.t);
  }

  @override
  Map<String, _i2.Include?> get includes => include?.includes ?? {};

  @override
  _i2.Table<_i2.UuidValue?> get table => TemplatePdf.t;
}

class TemplatePdfRepository {
  const TemplatePdfRepository._();

  /// Returns a list of [TemplatePdf]s matching the given query parameters.
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
  Future<List<TemplatePdf>> find(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<TemplatePdfTable>? where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<TemplatePdfTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<TemplatePdfTable>? orderByList,
    _i2.Transaction? transaction,
  }) async {
    return session.db.find<TemplatePdf>(
      where: where?.call(TemplatePdf.t),
      orderBy: orderBy?.call(TemplatePdf.t),
      orderByList: orderByList?.call(TemplatePdf.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TemplatePdf] matching the given query parameters.
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
  Future<TemplatePdf?> findFirstRow(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<TemplatePdfTable>? where,
    int? offset,
    _i2.OrderByBuilder<TemplatePdfTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<TemplatePdfTable>? orderByList,
    _i2.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TemplatePdf>(
      where: where?.call(TemplatePdf.t),
      orderBy: orderBy?.call(TemplatePdf.t),
      orderByList: orderByList?.call(TemplatePdf.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TemplatePdf] by its [id] or null if no such row exists.
  Future<TemplatePdf?> findById(
    _i2.Session session,
    _i2.UuidValue id, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.findById<TemplatePdf>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TemplatePdf]s in the list and returns the inserted rows.
  ///
  /// The returned [TemplatePdf]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TemplatePdf>> insert(
    _i2.Session session,
    List<TemplatePdf> rows, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.insert<TemplatePdf>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TemplatePdf] and returns the inserted row.
  ///
  /// The returned [TemplatePdf] will have its `id` field set.
  Future<TemplatePdf> insertRow(
    _i2.Session session,
    TemplatePdf row, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.insertRow<TemplatePdf>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TemplatePdf]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TemplatePdf>> update(
    _i2.Session session,
    List<TemplatePdf> rows, {
    _i2.ColumnSelections<TemplatePdfTable>? columns,
    _i2.Transaction? transaction,
  }) async {
    return session.db.update<TemplatePdf>(
      rows,
      columns: columns?.call(TemplatePdf.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TemplatePdf]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TemplatePdf> updateRow(
    _i2.Session session,
    TemplatePdf row, {
    _i2.ColumnSelections<TemplatePdfTable>? columns,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateRow<TemplatePdf>(
      row,
      columns: columns?.call(TemplatePdf.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TemplatePdf] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TemplatePdf?> updateById(
    _i2.Session session,
    _i2.UuidValue id, {
    required _i2.ColumnValueListBuilder<TemplatePdfUpdateTable> columnValues,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateById<TemplatePdf>(
      id,
      columnValues: columnValues(TemplatePdf.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TemplatePdf]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TemplatePdf>> updateWhere(
    _i2.Session session, {
    required _i2.ColumnValueListBuilder<TemplatePdfUpdateTable> columnValues,
    required _i2.WhereExpressionBuilder<TemplatePdfTable> where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<TemplatePdfTable>? orderBy,
    _i2.OrderByListBuilder<TemplatePdfTable>? orderByList,
    bool orderDescending = false,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TemplatePdf>(
      columnValues: columnValues(TemplatePdf.t.updateTable),
      where: where(TemplatePdf.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TemplatePdf.t),
      orderByList: orderByList?.call(TemplatePdf.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TemplatePdf]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TemplatePdf>> delete(
    _i2.Session session,
    List<TemplatePdf> rows, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.delete<TemplatePdf>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TemplatePdf].
  Future<TemplatePdf> deleteRow(
    _i2.Session session,
    TemplatePdf row, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TemplatePdf>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TemplatePdf>> deleteWhere(
    _i2.Session session, {
    required _i2.WhereExpressionBuilder<TemplatePdfTable> where,
    _i2.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TemplatePdf>(
      where: where(TemplatePdf.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<TemplatePdfTable>? where,
    int? limit,
    _i2.Transaction? transaction,
  }) async {
    return session.db.count<TemplatePdf>(
      where: where?.call(TemplatePdf.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
