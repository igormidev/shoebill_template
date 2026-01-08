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
import '../../../entities/others/supported_languages.dart' as _i2;

abstract class PdfPayloadContent
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PdfPayloadContent._({
    this.id,
    required this.pdfId,
    required this.stringifiedJson,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
  }) : language = language ?? _i2.SupportedLanguages.english,
       createdAt = createdAt ?? DateTime.now();

  factory PdfPayloadContent({
    int? id,
    required _i1.UuidValue pdfId,
    required String stringifiedJson,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
  }) = _PdfPayloadContentImpl;

  factory PdfPayloadContent.fromJson(Map<String, dynamic> jsonSerialization) {
    return PdfPayloadContent(
      id: jsonSerialization['id'] as int?,
      pdfId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['pdfId']),
      stringifiedJson: jsonSerialization['stringifiedJson'] as String,
      language: _i2.SupportedLanguages.fromJson(
        (jsonSerialization['language'] as String),
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = PdfPayloadContentTable();

  static const db = PdfPayloadContentRepository._();

  @override
  int? id;

  _i1.UuidValue pdfId;

  String stringifiedJson;

  _i2.SupportedLanguages language;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PdfPayloadContent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PdfPayloadContent copyWith({
    int? id,
    _i1.UuidValue? pdfId,
    String? stringifiedJson,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PdfPayloadContent',
      if (id != null) 'id': id,
      'pdfId': pdfId.toJson(),
      'stringifiedJson': stringifiedJson,
      'language': language.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PdfPayloadContent',
      if (id != null) 'id': id,
      'pdfId': pdfId.toJson(),
      'stringifiedJson': stringifiedJson,
      'language': language.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static PdfPayloadContentInclude include() {
    return PdfPayloadContentInclude._();
  }

  static PdfPayloadContentIncludeList includeList({
    _i1.WhereExpressionBuilder<PdfPayloadContentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PdfPayloadContentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PdfPayloadContentTable>? orderByList,
    PdfPayloadContentInclude? include,
  }) {
    return PdfPayloadContentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PdfPayloadContent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PdfPayloadContent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PdfPayloadContentImpl extends PdfPayloadContent {
  _PdfPayloadContentImpl({
    int? id,
    required _i1.UuidValue pdfId,
    required String stringifiedJson,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
  }) : super._(
         id: id,
         pdfId: pdfId,
         stringifiedJson: stringifiedJson,
         language: language,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PdfPayloadContent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PdfPayloadContent copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? pdfId,
    String? stringifiedJson,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
  }) {
    return PdfPayloadContent(
      id: id is int? ? id : this.id,
      pdfId: pdfId ?? this.pdfId,
      stringifiedJson: stringifiedJson ?? this.stringifiedJson,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class PdfPayloadContentUpdateTable
    extends _i1.UpdateTable<PdfPayloadContentTable> {
  PdfPayloadContentUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> pdfId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.pdfId,
        value,
      );

  _i1.ColumnValue<String, String> stringifiedJson(String value) =>
      _i1.ColumnValue(
        table.stringifiedJson,
        value,
      );

  _i1.ColumnValue<_i2.SupportedLanguages, _i2.SupportedLanguages> language(
    _i2.SupportedLanguages value,
  ) => _i1.ColumnValue(
    table.language,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class PdfPayloadContentTable extends _i1.Table<int?> {
  PdfPayloadContentTable({super.tableRelation})
    : super(tableName: 'pdf_payload_content') {
    updateTable = PdfPayloadContentUpdateTable(this);
    pdfId = _i1.ColumnUuid(
      'pdfId',
      this,
    );
    stringifiedJson = _i1.ColumnString(
      'stringifiedJson',
      this,
    );
    language = _i1.ColumnEnum(
      'language',
      this,
      _i1.EnumSerialization.byName,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final PdfPayloadContentUpdateTable updateTable;

  late final _i1.ColumnUuid pdfId;

  late final _i1.ColumnString stringifiedJson;

  late final _i1.ColumnEnum<_i2.SupportedLanguages> language;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    pdfId,
    stringifiedJson,
    language,
    createdAt,
  ];
}

class PdfPayloadContentInclude extends _i1.IncludeObject {
  PdfPayloadContentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PdfPayloadContent.t;
}

class PdfPayloadContentIncludeList extends _i1.IncludeList {
  PdfPayloadContentIncludeList._({
    _i1.WhereExpressionBuilder<PdfPayloadContentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PdfPayloadContent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PdfPayloadContent.t;
}

class PdfPayloadContentRepository {
  const PdfPayloadContentRepository._();

  /// Returns a list of [PdfPayloadContent]s matching the given query parameters.
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
  Future<List<PdfPayloadContent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PdfPayloadContentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PdfPayloadContentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PdfPayloadContentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PdfPayloadContent>(
      where: where?.call(PdfPayloadContent.t),
      orderBy: orderBy?.call(PdfPayloadContent.t),
      orderByList: orderByList?.call(PdfPayloadContent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PdfPayloadContent] matching the given query parameters.
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
  Future<PdfPayloadContent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PdfPayloadContentTable>? where,
    int? offset,
    _i1.OrderByBuilder<PdfPayloadContentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PdfPayloadContentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PdfPayloadContent>(
      where: where?.call(PdfPayloadContent.t),
      orderBy: orderBy?.call(PdfPayloadContent.t),
      orderByList: orderByList?.call(PdfPayloadContent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PdfPayloadContent] by its [id] or null if no such row exists.
  Future<PdfPayloadContent?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PdfPayloadContent>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PdfPayloadContent]s in the list and returns the inserted rows.
  ///
  /// The returned [PdfPayloadContent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PdfPayloadContent>> insert(
    _i1.Session session,
    List<PdfPayloadContent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PdfPayloadContent>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PdfPayloadContent] and returns the inserted row.
  ///
  /// The returned [PdfPayloadContent] will have its `id` field set.
  Future<PdfPayloadContent> insertRow(
    _i1.Session session,
    PdfPayloadContent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PdfPayloadContent>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PdfPayloadContent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PdfPayloadContent>> update(
    _i1.Session session,
    List<PdfPayloadContent> rows, {
    _i1.ColumnSelections<PdfPayloadContentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PdfPayloadContent>(
      rows,
      columns: columns?.call(PdfPayloadContent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PdfPayloadContent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PdfPayloadContent> updateRow(
    _i1.Session session,
    PdfPayloadContent row, {
    _i1.ColumnSelections<PdfPayloadContentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PdfPayloadContent>(
      row,
      columns: columns?.call(PdfPayloadContent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PdfPayloadContent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PdfPayloadContent?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PdfPayloadContentUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PdfPayloadContent>(
      id,
      columnValues: columnValues(PdfPayloadContent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PdfPayloadContent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PdfPayloadContent>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PdfPayloadContentUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PdfPayloadContentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PdfPayloadContentTable>? orderBy,
    _i1.OrderByListBuilder<PdfPayloadContentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PdfPayloadContent>(
      columnValues: columnValues(PdfPayloadContent.t.updateTable),
      where: where(PdfPayloadContent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PdfPayloadContent.t),
      orderByList: orderByList?.call(PdfPayloadContent.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PdfPayloadContent]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PdfPayloadContent>> delete(
    _i1.Session session,
    List<PdfPayloadContent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PdfPayloadContent>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PdfPayloadContent].
  Future<PdfPayloadContent> deleteRow(
    _i1.Session session,
    PdfPayloadContent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PdfPayloadContent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PdfPayloadContent>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PdfPayloadContentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PdfPayloadContent>(
      where: where(PdfPayloadContent.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PdfPayloadContentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PdfPayloadContent>(
      where: where?.call(PdfPayloadContent.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
