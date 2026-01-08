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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class PdfContent
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = PdfContentTable();

  static const db = PdfContentRepository._();

  @override
  int? id;

  String name;

  String description;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PdfContent',
      if (id != null) 'id': id,
      'name': name,
      'description': description,
    };
  }

  static PdfContentInclude include() {
    return PdfContentInclude._();
  }

  static PdfContentIncludeList includeList({
    _i1.WhereExpressionBuilder<PdfContentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PdfContentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PdfContentTable>? orderByList,
    PdfContentInclude? include,
  }) {
    return PdfContentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PdfContent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PdfContent.t),
      include: include,
    );
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

class PdfContentUpdateTable extends _i1.UpdateTable<PdfContentTable> {
  PdfContentUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );
}

class PdfContentTable extends _i1.Table<int?> {
  PdfContentTable({super.tableRelation}) : super(tableName: 'pdf_content') {
    updateTable = PdfContentUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
  }

  late final PdfContentUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    description,
  ];
}

class PdfContentInclude extends _i1.IncludeObject {
  PdfContentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PdfContent.t;
}

class PdfContentIncludeList extends _i1.IncludeList {
  PdfContentIncludeList._({
    _i1.WhereExpressionBuilder<PdfContentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PdfContent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PdfContent.t;
}

class PdfContentRepository {
  const PdfContentRepository._();

  /// Returns a list of [PdfContent]s matching the given query parameters.
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
  Future<List<PdfContent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PdfContentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PdfContentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PdfContentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PdfContent>(
      where: where?.call(PdfContent.t),
      orderBy: orderBy?.call(PdfContent.t),
      orderByList: orderByList?.call(PdfContent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PdfContent] matching the given query parameters.
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
  Future<PdfContent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PdfContentTable>? where,
    int? offset,
    _i1.OrderByBuilder<PdfContentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PdfContentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PdfContent>(
      where: where?.call(PdfContent.t),
      orderBy: orderBy?.call(PdfContent.t),
      orderByList: orderByList?.call(PdfContent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PdfContent] by its [id] or null if no such row exists.
  Future<PdfContent?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PdfContent>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PdfContent]s in the list and returns the inserted rows.
  ///
  /// The returned [PdfContent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PdfContent>> insert(
    _i1.Session session,
    List<PdfContent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PdfContent>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PdfContent] and returns the inserted row.
  ///
  /// The returned [PdfContent] will have its `id` field set.
  Future<PdfContent> insertRow(
    _i1.Session session,
    PdfContent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PdfContent>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PdfContent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PdfContent>> update(
    _i1.Session session,
    List<PdfContent> rows, {
    _i1.ColumnSelections<PdfContentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PdfContent>(
      rows,
      columns: columns?.call(PdfContent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PdfContent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PdfContent> updateRow(
    _i1.Session session,
    PdfContent row, {
    _i1.ColumnSelections<PdfContentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PdfContent>(
      row,
      columns: columns?.call(PdfContent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PdfContent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PdfContent?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PdfContentUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PdfContent>(
      id,
      columnValues: columnValues(PdfContent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PdfContent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PdfContent>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PdfContentUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PdfContentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PdfContentTable>? orderBy,
    _i1.OrderByListBuilder<PdfContentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PdfContent>(
      columnValues: columnValues(PdfContent.t.updateTable),
      where: where(PdfContent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PdfContent.t),
      orderByList: orderByList?.call(PdfContent.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PdfContent]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PdfContent>> delete(
    _i1.Session session,
    List<PdfContent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PdfContent>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PdfContent].
  Future<PdfContent> deleteRow(
    _i1.Session session,
    PdfContent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PdfContent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PdfContent>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PdfContentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PdfContent>(
      where: where(PdfContent.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PdfContentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PdfContent>(
      where: where?.call(PdfContent.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
