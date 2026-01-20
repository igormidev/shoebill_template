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
import '../../../../api/pdf_related/entities/pdf_content.dart' as _i2;
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_version.dart'
    as _i3;
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i4;

abstract class ShoebillTemplateScaffold
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  ShoebillTemplateScaffold._({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required this.referencePdfContentId,
    this.referencePdfContent,
    this.versions,
  }) : id = id ?? _i1.Uuid().v7obj(),
       createdAt = createdAt ?? DateTime.now();

  factory ShoebillTemplateScaffold({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required int referencePdfContentId,
    _i2.PdfContent? referencePdfContent,
    List<_i3.ShoebillTemplateVersion>? versions,
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
          : _i4.Protocol().deserialize<_i2.PdfContent>(
              jsonSerialization['referencePdfContent'],
            ),
      versions: jsonSerialization['versions'] == null
          ? null
          : _i4.Protocol().deserialize<List<_i3.ShoebillTemplateVersion>>(
              jsonSerialization['versions'],
            ),
    );
  }

  static final t = ShoebillTemplateScaffoldTable();

  static const db = ShoebillTemplateScaffoldRepository._();

  @override
  _i1.UuidValue id;

  DateTime createdAt;

  int referencePdfContentId;

  _i2.PdfContent? referencePdfContent;

  List<_i3.ShoebillTemplateVersion>? versions;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  /// Returns a shallow copy of this [ShoebillTemplateScaffold]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoebillTemplateScaffold copyWith({
    _i1.UuidValue? id,
    DateTime? createdAt,
    int? referencePdfContentId,
    _i2.PdfContent? referencePdfContent,
    List<_i3.ShoebillTemplateVersion>? versions,
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
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShoebillTemplateScaffold',
      'id': id.toJson(),
      'createdAt': createdAt.toJson(),
      'referencePdfContentId': referencePdfContentId,
      if (referencePdfContent != null)
        'referencePdfContent': referencePdfContent?.toJsonForProtocol(),
      if (versions != null)
        'versions': versions?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static ShoebillTemplateScaffoldInclude include({
    _i2.PdfContentInclude? referencePdfContent,
    _i3.ShoebillTemplateVersionIncludeList? versions,
  }) {
    return ShoebillTemplateScaffoldInclude._(
      referencePdfContent: referencePdfContent,
      versions: versions,
    );
  }

  static ShoebillTemplateScaffoldIncludeList includeList({
    _i1.WhereExpressionBuilder<ShoebillTemplateScaffoldTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateScaffoldTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateScaffoldTable>? orderByList,
    ShoebillTemplateScaffoldInclude? include,
  }) {
    return ShoebillTemplateScaffoldIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoebillTemplateScaffold.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ShoebillTemplateScaffold.t),
      include: include,
    );
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
  }) : super._(
         id: id,
         createdAt: createdAt,
         referencePdfContentId: referencePdfContentId,
         referencePdfContent: referencePdfContent,
         versions: versions,
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
    );
  }
}

class ShoebillTemplateScaffoldUpdateTable
    extends _i1.UpdateTable<ShoebillTemplateScaffoldTable> {
  ShoebillTemplateScaffoldUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<int, int> referencePdfContentId(int value) => _i1.ColumnValue(
    table.referencePdfContentId,
    value,
  );
}

class ShoebillTemplateScaffoldTable extends _i1.Table<_i1.UuidValue> {
  ShoebillTemplateScaffoldTable({super.tableRelation})
    : super(tableName: 'shoebill_template_scaffolds') {
    updateTable = ShoebillTemplateScaffoldUpdateTable(this);
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    referencePdfContentId = _i1.ColumnInt(
      'referencePdfContentId',
      this,
    );
  }

  late final ShoebillTemplateScaffoldUpdateTable updateTable;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnInt referencePdfContentId;

  _i2.PdfContentTable? _referencePdfContent;

  _i3.ShoebillTemplateVersionTable? ___versions;

  _i1.ManyRelation<_i3.ShoebillTemplateVersionTable>? _versions;

  _i2.PdfContentTable get referencePdfContent {
    if (_referencePdfContent != null) return _referencePdfContent!;
    _referencePdfContent = _i1.createRelationTable(
      relationFieldName: 'referencePdfContent',
      field: ShoebillTemplateScaffold.t.referencePdfContentId,
      foreignField: _i2.PdfContent.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PdfContentTable(tableRelation: foreignTableRelation),
    );
    return _referencePdfContent!;
  }

  _i3.ShoebillTemplateVersionTable get __versions {
    if (___versions != null) return ___versions!;
    ___versions = _i1.createRelationTable(
      relationFieldName: '__versions',
      field: ShoebillTemplateScaffold.t.id,
      foreignField: _i3.ShoebillTemplateVersion.t.scaffoldId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ShoebillTemplateVersionTable(tableRelation: foreignTableRelation),
    );
    return ___versions!;
  }

  _i1.ManyRelation<_i3.ShoebillTemplateVersionTable> get versions {
    if (_versions != null) return _versions!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'versions',
      field: ShoebillTemplateScaffold.t.id,
      foreignField: _i3.ShoebillTemplateVersion.t.scaffoldId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ShoebillTemplateVersionTable(tableRelation: foreignTableRelation),
    );
    _versions = _i1.ManyRelation<_i3.ShoebillTemplateVersionTable>(
      tableWithRelations: relationTable,
      table: _i3.ShoebillTemplateVersionTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _versions!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    createdAt,
    referencePdfContentId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'referencePdfContent') {
      return referencePdfContent;
    }
    if (relationField == 'versions') {
      return __versions;
    }
    return null;
  }
}

class ShoebillTemplateScaffoldInclude extends _i1.IncludeObject {
  ShoebillTemplateScaffoldInclude._({
    _i2.PdfContentInclude? referencePdfContent,
    _i3.ShoebillTemplateVersionIncludeList? versions,
  }) {
    _referencePdfContent = referencePdfContent;
    _versions = versions;
  }

  _i2.PdfContentInclude? _referencePdfContent;

  _i3.ShoebillTemplateVersionIncludeList? _versions;

  @override
  Map<String, _i1.Include?> get includes => {
    'referencePdfContent': _referencePdfContent,
    'versions': _versions,
  };

  @override
  _i1.Table<_i1.UuidValue> get table => ShoebillTemplateScaffold.t;
}

class ShoebillTemplateScaffoldIncludeList extends _i1.IncludeList {
  ShoebillTemplateScaffoldIncludeList._({
    _i1.WhereExpressionBuilder<ShoebillTemplateScaffoldTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ShoebillTemplateScaffold.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => ShoebillTemplateScaffold.t;
}

class ShoebillTemplateScaffoldRepository {
  const ShoebillTemplateScaffoldRepository._();

  final attach = const ShoebillTemplateScaffoldAttachRepository._();

  final attachRow = const ShoebillTemplateScaffoldAttachRowRepository._();

  final detach = const ShoebillTemplateScaffoldDetachRepository._();

  final detachRow = const ShoebillTemplateScaffoldDetachRowRepository._();

  /// Returns a list of [ShoebillTemplateScaffold]s matching the given query parameters.
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
  Future<List<ShoebillTemplateScaffold>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateScaffoldTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateScaffoldTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateScaffoldTable>? orderByList,
    _i1.Transaction? transaction,
    ShoebillTemplateScaffoldInclude? include,
  }) async {
    return session.db.find<ShoebillTemplateScaffold>(
      where: where?.call(ShoebillTemplateScaffold.t),
      orderBy: orderBy?.call(ShoebillTemplateScaffold.t),
      orderByList: orderByList?.call(ShoebillTemplateScaffold.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ShoebillTemplateScaffold] matching the given query parameters.
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
  Future<ShoebillTemplateScaffold?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateScaffoldTable>? where,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateScaffoldTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateScaffoldTable>? orderByList,
    _i1.Transaction? transaction,
    ShoebillTemplateScaffoldInclude? include,
  }) async {
    return session.db.findFirstRow<ShoebillTemplateScaffold>(
      where: where?.call(ShoebillTemplateScaffold.t),
      orderBy: orderBy?.call(ShoebillTemplateScaffold.t),
      orderByList: orderByList?.call(ShoebillTemplateScaffold.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ShoebillTemplateScaffold] by its [id] or null if no such row exists.
  Future<ShoebillTemplateScaffold?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    ShoebillTemplateScaffoldInclude? include,
  }) async {
    return session.db.findById<ShoebillTemplateScaffold>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ShoebillTemplateScaffold]s in the list and returns the inserted rows.
  ///
  /// The returned [ShoebillTemplateScaffold]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ShoebillTemplateScaffold>> insert(
    _i1.Session session,
    List<ShoebillTemplateScaffold> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ShoebillTemplateScaffold>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ShoebillTemplateScaffold] and returns the inserted row.
  ///
  /// The returned [ShoebillTemplateScaffold] will have its `id` field set.
  Future<ShoebillTemplateScaffold> insertRow(
    _i1.Session session,
    ShoebillTemplateScaffold row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ShoebillTemplateScaffold>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ShoebillTemplateScaffold]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ShoebillTemplateScaffold>> update(
    _i1.Session session,
    List<ShoebillTemplateScaffold> rows, {
    _i1.ColumnSelections<ShoebillTemplateScaffoldTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ShoebillTemplateScaffold>(
      rows,
      columns: columns?.call(ShoebillTemplateScaffold.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoebillTemplateScaffold]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ShoebillTemplateScaffold> updateRow(
    _i1.Session session,
    ShoebillTemplateScaffold row, {
    _i1.ColumnSelections<ShoebillTemplateScaffoldTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ShoebillTemplateScaffold>(
      row,
      columns: columns?.call(ShoebillTemplateScaffold.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoebillTemplateScaffold] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ShoebillTemplateScaffold?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ShoebillTemplateScaffoldUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ShoebillTemplateScaffold>(
      id,
      columnValues: columnValues(ShoebillTemplateScaffold.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ShoebillTemplateScaffold]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ShoebillTemplateScaffold>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ShoebillTemplateScaffoldUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ShoebillTemplateScaffoldTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateScaffoldTable>? orderBy,
    _i1.OrderByListBuilder<ShoebillTemplateScaffoldTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ShoebillTemplateScaffold>(
      columnValues: columnValues(ShoebillTemplateScaffold.t.updateTable),
      where: where(ShoebillTemplateScaffold.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoebillTemplateScaffold.t),
      orderByList: orderByList?.call(ShoebillTemplateScaffold.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ShoebillTemplateScaffold]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ShoebillTemplateScaffold>> delete(
    _i1.Session session,
    List<ShoebillTemplateScaffold> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ShoebillTemplateScaffold>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ShoebillTemplateScaffold].
  Future<ShoebillTemplateScaffold> deleteRow(
    _i1.Session session,
    ShoebillTemplateScaffold row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ShoebillTemplateScaffold>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ShoebillTemplateScaffold>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ShoebillTemplateScaffoldTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ShoebillTemplateScaffold>(
      where: where(ShoebillTemplateScaffold.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateScaffoldTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ShoebillTemplateScaffold>(
      where: where?.call(ShoebillTemplateScaffold.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ShoebillTemplateScaffoldAttachRepository {
  const ShoebillTemplateScaffoldAttachRepository._();

  /// Creates a relation between this [ShoebillTemplateScaffold] and the given [ShoebillTemplateVersion]s
  /// by setting each [ShoebillTemplateVersion]'s foreign key `scaffoldId` to refer to this [ShoebillTemplateScaffold].
  Future<void> versions(
    _i1.Session session,
    ShoebillTemplateScaffold shoebillTemplateScaffold,
    List<_i3.ShoebillTemplateVersion> shoebillTemplateVersion, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateVersion.any((e) => e.id == null)) {
      throw ArgumentError.notNull('shoebillTemplateVersion.id');
    }
    if (shoebillTemplateScaffold.id == null) {
      throw ArgumentError.notNull('shoebillTemplateScaffold.id');
    }

    var $shoebillTemplateVersion = shoebillTemplateVersion
        .map((e) => e.copyWith(scaffoldId: shoebillTemplateScaffold.id))
        .toList();
    await session.db.update<_i3.ShoebillTemplateVersion>(
      $shoebillTemplateVersion,
      columns: [_i3.ShoebillTemplateVersion.t.scaffoldId],
      transaction: transaction,
    );
  }
}

class ShoebillTemplateScaffoldAttachRowRepository {
  const ShoebillTemplateScaffoldAttachRowRepository._();

  /// Creates a relation between the given [ShoebillTemplateScaffold] and [PdfContent]
  /// by setting the [ShoebillTemplateScaffold]'s foreign key `referencePdfContentId` to refer to the [PdfContent].
  Future<void> referencePdfContent(
    _i1.Session session,
    ShoebillTemplateScaffold shoebillTemplateScaffold,
    _i2.PdfContent referencePdfContent, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateScaffold.id == null) {
      throw ArgumentError.notNull('shoebillTemplateScaffold.id');
    }
    if (referencePdfContent.id == null) {
      throw ArgumentError.notNull('referencePdfContent.id');
    }

    var $shoebillTemplateScaffold = shoebillTemplateScaffold.copyWith(
      referencePdfContentId: referencePdfContent.id,
    );
    await session.db.updateRow<ShoebillTemplateScaffold>(
      $shoebillTemplateScaffold,
      columns: [ShoebillTemplateScaffold.t.referencePdfContentId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [ShoebillTemplateScaffold] and the given [ShoebillTemplateVersion]
  /// by setting the [ShoebillTemplateVersion]'s foreign key `scaffoldId` to refer to this [ShoebillTemplateScaffold].
  Future<void> versions(
    _i1.Session session,
    ShoebillTemplateScaffold shoebillTemplateScaffold,
    _i3.ShoebillTemplateVersion shoebillTemplateVersion, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateVersion.id == null) {
      throw ArgumentError.notNull('shoebillTemplateVersion.id');
    }
    if (shoebillTemplateScaffold.id == null) {
      throw ArgumentError.notNull('shoebillTemplateScaffold.id');
    }

    var $shoebillTemplateVersion = shoebillTemplateVersion.copyWith(
      scaffoldId: shoebillTemplateScaffold.id,
    );
    await session.db.updateRow<_i3.ShoebillTemplateVersion>(
      $shoebillTemplateVersion,
      columns: [_i3.ShoebillTemplateVersion.t.scaffoldId],
      transaction: transaction,
    );
  }
}

class ShoebillTemplateScaffoldDetachRepository {
  const ShoebillTemplateScaffoldDetachRepository._();

  /// Detaches the relation between this [ShoebillTemplateScaffold] and the given [ShoebillTemplateVersion]
  /// by setting the [ShoebillTemplateVersion]'s foreign key `scaffoldId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> versions(
    _i1.Session session,
    List<_i3.ShoebillTemplateVersion> shoebillTemplateVersion, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateVersion.any((e) => e.id == null)) {
      throw ArgumentError.notNull('shoebillTemplateVersion.id');
    }

    var $shoebillTemplateVersion = shoebillTemplateVersion
        .map((e) => e.copyWith(scaffoldId: null))
        .toList();
    await session.db.update<_i3.ShoebillTemplateVersion>(
      $shoebillTemplateVersion,
      columns: [_i3.ShoebillTemplateVersion.t.scaffoldId],
      transaction: transaction,
    );
  }
}

class ShoebillTemplateScaffoldDetachRowRepository {
  const ShoebillTemplateScaffoldDetachRowRepository._();

  /// Detaches the relation between this [ShoebillTemplateScaffold] and the given [ShoebillTemplateVersion]
  /// by setting the [ShoebillTemplateVersion]'s foreign key `scaffoldId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> versions(
    _i1.Session session,
    _i3.ShoebillTemplateVersion shoebillTemplateVersion, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateVersion.id == null) {
      throw ArgumentError.notNull('shoebillTemplateVersion.id');
    }

    var $shoebillTemplateVersion = shoebillTemplateVersion.copyWith(
      scaffoldId: null,
    );
    await session.db.updateRow<_i3.ShoebillTemplateVersion>(
      $shoebillTemplateVersion,
      columns: [_i3.ShoebillTemplateVersion.t.scaffoldId],
      transaction: transaction,
    );
  }
}
