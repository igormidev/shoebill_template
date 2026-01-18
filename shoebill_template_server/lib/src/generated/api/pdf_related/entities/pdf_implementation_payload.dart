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
import '../../../entities/others/supported_languages.dart' as _i2;
import '../../../api/pdf_related/entities/pdf_declaration.dart' as _i3;
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i4;

abstract class PdfImplementationPayload
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PdfImplementationPayload._({
    this.id,
    required this.stringifiedJson,
    required this.language,
    DateTime? createdAt,
    required this.pdfDeclarationId,
    this.pdfDeclaration,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PdfImplementationPayload({
    int? id,
    required String stringifiedJson,
    required _i2.SupportedLanguages language,
    DateTime? createdAt,
    required _i1.UuidValue pdfDeclarationId,
    _i3.PdfDeclaration? pdfDeclaration,
  }) = _PdfImplementationPayloadImpl;

  factory PdfImplementationPayload.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PdfImplementationPayload(
      id: jsonSerialization['id'] as int?,
      stringifiedJson: jsonSerialization['stringifiedJson'] as String,
      language: _i2.SupportedLanguages.fromJson(
        (jsonSerialization['language'] as String),
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      pdfDeclarationId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['pdfDeclarationId'],
      ),
      pdfDeclaration: jsonSerialization['pdfDeclaration'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.PdfDeclaration>(
              jsonSerialization['pdfDeclaration'],
            ),
    );
  }

  static final t = PdfImplementationPayloadTable();

  static const db = PdfImplementationPayloadRepository._();

  @override
  int? id;

  String stringifiedJson;

  _i2.SupportedLanguages language;

  DateTime createdAt;

  _i1.UuidValue pdfDeclarationId;

  _i3.PdfDeclaration? pdfDeclaration;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PdfImplementationPayload]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PdfImplementationPayload copyWith({
    int? id,
    String? stringifiedJson,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
    _i1.UuidValue? pdfDeclarationId,
    _i3.PdfDeclaration? pdfDeclaration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PdfImplementationPayload',
      if (id != null) 'id': id,
      'stringifiedJson': stringifiedJson,
      'language': language.toJson(),
      'createdAt': createdAt.toJson(),
      'pdfDeclarationId': pdfDeclarationId.toJson(),
      if (pdfDeclaration != null) 'pdfDeclaration': pdfDeclaration?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PdfImplementationPayload',
      if (id != null) 'id': id,
      'stringifiedJson': stringifiedJson,
      'language': language.toJson(),
      'createdAt': createdAt.toJson(),
      'pdfDeclarationId': pdfDeclarationId.toJson(),
      if (pdfDeclaration != null)
        'pdfDeclaration': pdfDeclaration?.toJsonForProtocol(),
    };
  }

  static PdfImplementationPayloadInclude include({
    _i3.PdfDeclarationInclude? pdfDeclaration,
  }) {
    return PdfImplementationPayloadInclude._(pdfDeclaration: pdfDeclaration);
  }

  static PdfImplementationPayloadIncludeList includeList({
    _i1.WhereExpressionBuilder<PdfImplementationPayloadTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PdfImplementationPayloadTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PdfImplementationPayloadTable>? orderByList,
    PdfImplementationPayloadInclude? include,
  }) {
    return PdfImplementationPayloadIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PdfImplementationPayload.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PdfImplementationPayload.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PdfImplementationPayloadImpl extends PdfImplementationPayload {
  _PdfImplementationPayloadImpl({
    int? id,
    required String stringifiedJson,
    required _i2.SupportedLanguages language,
    DateTime? createdAt,
    required _i1.UuidValue pdfDeclarationId,
    _i3.PdfDeclaration? pdfDeclaration,
  }) : super._(
         id: id,
         stringifiedJson: stringifiedJson,
         language: language,
         createdAt: createdAt,
         pdfDeclarationId: pdfDeclarationId,
         pdfDeclaration: pdfDeclaration,
       );

  /// Returns a shallow copy of this [PdfImplementationPayload]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PdfImplementationPayload copyWith({
    Object? id = _Undefined,
    String? stringifiedJson,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
    _i1.UuidValue? pdfDeclarationId,
    Object? pdfDeclaration = _Undefined,
  }) {
    return PdfImplementationPayload(
      id: id is int? ? id : this.id,
      stringifiedJson: stringifiedJson ?? this.stringifiedJson,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      pdfDeclarationId: pdfDeclarationId ?? this.pdfDeclarationId,
      pdfDeclaration: pdfDeclaration is _i3.PdfDeclaration?
          ? pdfDeclaration
          : this.pdfDeclaration?.copyWith(),
    );
  }
}

class PdfImplementationPayloadUpdateTable
    extends _i1.UpdateTable<PdfImplementationPayloadTable> {
  PdfImplementationPayloadUpdateTable(super.table);

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

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> pdfDeclarationId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.pdfDeclarationId,
    value,
  );
}

class PdfImplementationPayloadTable extends _i1.Table<int?> {
  PdfImplementationPayloadTable({super.tableRelation})
    : super(tableName: 'pdf_implementation_payload') {
    updateTable = PdfImplementationPayloadUpdateTable(this);
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
    pdfDeclarationId = _i1.ColumnUuid(
      'pdfDeclarationId',
      this,
    );
  }

  late final PdfImplementationPayloadUpdateTable updateTable;

  late final _i1.ColumnString stringifiedJson;

  late final _i1.ColumnEnum<_i2.SupportedLanguages> language;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnUuid pdfDeclarationId;

  _i3.PdfDeclarationTable? _pdfDeclaration;

  _i3.PdfDeclarationTable get pdfDeclaration {
    if (_pdfDeclaration != null) return _pdfDeclaration!;
    _pdfDeclaration = _i1.createRelationTable(
      relationFieldName: 'pdfDeclaration',
      field: PdfImplementationPayload.t.pdfDeclarationId,
      foreignField: _i3.PdfDeclaration.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.PdfDeclarationTable(tableRelation: foreignTableRelation),
    );
    return _pdfDeclaration!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    stringifiedJson,
    language,
    createdAt,
    pdfDeclarationId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'pdfDeclaration') {
      return pdfDeclaration;
    }
    return null;
  }
}

class PdfImplementationPayloadInclude extends _i1.IncludeObject {
  PdfImplementationPayloadInclude._({
    _i3.PdfDeclarationInclude? pdfDeclaration,
  }) {
    _pdfDeclaration = pdfDeclaration;
  }

  _i3.PdfDeclarationInclude? _pdfDeclaration;

  @override
  Map<String, _i1.Include?> get includes => {'pdfDeclaration': _pdfDeclaration};

  @override
  _i1.Table<int?> get table => PdfImplementationPayload.t;
}

class PdfImplementationPayloadIncludeList extends _i1.IncludeList {
  PdfImplementationPayloadIncludeList._({
    _i1.WhereExpressionBuilder<PdfImplementationPayloadTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PdfImplementationPayload.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PdfImplementationPayload.t;
}

class PdfImplementationPayloadRepository {
  const PdfImplementationPayloadRepository._();

  final attachRow = const PdfImplementationPayloadAttachRowRepository._();

  /// Returns a list of [PdfImplementationPayload]s matching the given query parameters.
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
  Future<List<PdfImplementationPayload>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PdfImplementationPayloadTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PdfImplementationPayloadTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PdfImplementationPayloadTable>? orderByList,
    _i1.Transaction? transaction,
    PdfImplementationPayloadInclude? include,
  }) async {
    return session.db.find<PdfImplementationPayload>(
      where: where?.call(PdfImplementationPayload.t),
      orderBy: orderBy?.call(PdfImplementationPayload.t),
      orderByList: orderByList?.call(PdfImplementationPayload.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [PdfImplementationPayload] matching the given query parameters.
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
  Future<PdfImplementationPayload?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PdfImplementationPayloadTable>? where,
    int? offset,
    _i1.OrderByBuilder<PdfImplementationPayloadTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PdfImplementationPayloadTable>? orderByList,
    _i1.Transaction? transaction,
    PdfImplementationPayloadInclude? include,
  }) async {
    return session.db.findFirstRow<PdfImplementationPayload>(
      where: where?.call(PdfImplementationPayload.t),
      orderBy: orderBy?.call(PdfImplementationPayload.t),
      orderByList: orderByList?.call(PdfImplementationPayload.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [PdfImplementationPayload] by its [id] or null if no such row exists.
  Future<PdfImplementationPayload?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    PdfImplementationPayloadInclude? include,
  }) async {
    return session.db.findById<PdfImplementationPayload>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [PdfImplementationPayload]s in the list and returns the inserted rows.
  ///
  /// The returned [PdfImplementationPayload]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PdfImplementationPayload>> insert(
    _i1.Session session,
    List<PdfImplementationPayload> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PdfImplementationPayload>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PdfImplementationPayload] and returns the inserted row.
  ///
  /// The returned [PdfImplementationPayload] will have its `id` field set.
  Future<PdfImplementationPayload> insertRow(
    _i1.Session session,
    PdfImplementationPayload row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PdfImplementationPayload>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PdfImplementationPayload]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PdfImplementationPayload>> update(
    _i1.Session session,
    List<PdfImplementationPayload> rows, {
    _i1.ColumnSelections<PdfImplementationPayloadTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PdfImplementationPayload>(
      rows,
      columns: columns?.call(PdfImplementationPayload.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PdfImplementationPayload]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PdfImplementationPayload> updateRow(
    _i1.Session session,
    PdfImplementationPayload row, {
    _i1.ColumnSelections<PdfImplementationPayloadTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PdfImplementationPayload>(
      row,
      columns: columns?.call(PdfImplementationPayload.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PdfImplementationPayload] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PdfImplementationPayload?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PdfImplementationPayloadUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PdfImplementationPayload>(
      id,
      columnValues: columnValues(PdfImplementationPayload.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PdfImplementationPayload]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PdfImplementationPayload>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PdfImplementationPayloadUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PdfImplementationPayloadTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PdfImplementationPayloadTable>? orderBy,
    _i1.OrderByListBuilder<PdfImplementationPayloadTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PdfImplementationPayload>(
      columnValues: columnValues(PdfImplementationPayload.t.updateTable),
      where: where(PdfImplementationPayload.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PdfImplementationPayload.t),
      orderByList: orderByList?.call(PdfImplementationPayload.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PdfImplementationPayload]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PdfImplementationPayload>> delete(
    _i1.Session session,
    List<PdfImplementationPayload> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PdfImplementationPayload>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PdfImplementationPayload].
  Future<PdfImplementationPayload> deleteRow(
    _i1.Session session,
    PdfImplementationPayload row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PdfImplementationPayload>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PdfImplementationPayload>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PdfImplementationPayloadTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PdfImplementationPayload>(
      where: where(PdfImplementationPayload.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PdfImplementationPayloadTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PdfImplementationPayload>(
      where: where?.call(PdfImplementationPayload.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class PdfImplementationPayloadAttachRowRepository {
  const PdfImplementationPayloadAttachRowRepository._();

  /// Creates a relation between the given [PdfImplementationPayload] and [PdfDeclaration]
  /// by setting the [PdfImplementationPayload]'s foreign key `pdfDeclarationId` to refer to the [PdfDeclaration].
  Future<void> pdfDeclaration(
    _i1.Session session,
    PdfImplementationPayload pdfImplementationPayload,
    _i3.PdfDeclaration pdfDeclaration, {
    _i1.Transaction? transaction,
  }) async {
    if (pdfImplementationPayload.id == null) {
      throw ArgumentError.notNull('pdfImplementationPayload.id');
    }
    if (pdfDeclaration.id == null) {
      throw ArgumentError.notNull('pdfDeclaration.id');
    }

    var $pdfImplementationPayload = pdfImplementationPayload.copyWith(
      pdfDeclarationId: pdfDeclaration.id,
    );
    await session.db.updateRow<PdfImplementationPayload>(
      $pdfImplementationPayload,
      columns: [PdfImplementationPayload.t.pdfDeclarationId],
      transaction: transaction,
    );
  }
}
