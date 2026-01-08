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
import '../../../api/pdf_related/entities/pdf_content.dart' as _i3;
import '../../../api/pdf_related/entities/schema_definition.dart' as _i4;
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i5;

abstract class PdfDeclaration
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PdfDeclaration._({
    this.id,
    required this.pdfId,
    required this.pdfContentId,
    this.pdfContent,
    required this.schemaId,
    this.schema,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
  }) : referenceLanguage = referenceLanguage ?? _i2.SupportedLanguages.english,
       createdAt = createdAt ?? DateTime.now();

  factory PdfDeclaration({
    int? id,
    required _i1.UuidValue pdfId,
    required int pdfContentId,
    _i3.PdfContent? pdfContent,
    required int schemaId,
    _i4.SchemaDefinition? schema,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
  }) = _PdfDeclarationImpl;

  factory PdfDeclaration.fromJson(Map<String, dynamic> jsonSerialization) {
    return PdfDeclaration(
      id: jsonSerialization['id'] as int?,
      pdfId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['pdfId']),
      pdfContentId: jsonSerialization['pdfContentId'] as int,
      pdfContent: jsonSerialization['pdfContent'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.PdfContent>(
              jsonSerialization['pdfContent'],
            ),
      schemaId: jsonSerialization['schemaId'] as int,
      schema: jsonSerialization['schema'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.SchemaDefinition>(
              jsonSerialization['schema'],
            ),
      referenceLanguage: _i2.SupportedLanguages.fromJson(
        (jsonSerialization['referenceLanguage'] as String),
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = PdfDeclarationTable();

  static const db = PdfDeclarationRepository._();

  @override
  int? id;

  _i1.UuidValue pdfId;

  int pdfContentId;

  _i3.PdfContent? pdfContent;

  int schemaId;

  _i4.SchemaDefinition? schema;

  _i2.SupportedLanguages referenceLanguage;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PdfDeclaration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PdfDeclaration copyWith({
    int? id,
    _i1.UuidValue? pdfId,
    int? pdfContentId,
    _i3.PdfContent? pdfContent,
    int? schemaId,
    _i4.SchemaDefinition? schema,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PdfDeclaration',
      if (id != null) 'id': id,
      'pdfId': pdfId.toJson(),
      'pdfContentId': pdfContentId,
      if (pdfContent != null) 'pdfContent': pdfContent?.toJson(),
      'schemaId': schemaId,
      if (schema != null) 'schema': schema?.toJson(),
      'referenceLanguage': referenceLanguage.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PdfDeclaration',
      if (id != null) 'id': id,
      'pdfId': pdfId.toJson(),
      'pdfContentId': pdfContentId,
      if (pdfContent != null) 'pdfContent': pdfContent?.toJsonForProtocol(),
      'schemaId': schemaId,
      if (schema != null) 'schema': schema?.toJsonForProtocol(),
      'referenceLanguage': referenceLanguage.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static PdfDeclarationInclude include({
    _i3.PdfContentInclude? pdfContent,
    _i4.SchemaDefinitionInclude? schema,
  }) {
    return PdfDeclarationInclude._(
      pdfContent: pdfContent,
      schema: schema,
    );
  }

  static PdfDeclarationIncludeList includeList({
    _i1.WhereExpressionBuilder<PdfDeclarationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PdfDeclarationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PdfDeclarationTable>? orderByList,
    PdfDeclarationInclude? include,
  }) {
    return PdfDeclarationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PdfDeclaration.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PdfDeclaration.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PdfDeclarationImpl extends PdfDeclaration {
  _PdfDeclarationImpl({
    int? id,
    required _i1.UuidValue pdfId,
    required int pdfContentId,
    _i3.PdfContent? pdfContent,
    required int schemaId,
    _i4.SchemaDefinition? schema,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
  }) : super._(
         id: id,
         pdfId: pdfId,
         pdfContentId: pdfContentId,
         pdfContent: pdfContent,
         schemaId: schemaId,
         schema: schema,
         referenceLanguage: referenceLanguage,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PdfDeclaration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PdfDeclaration copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? pdfId,
    int? pdfContentId,
    Object? pdfContent = _Undefined,
    int? schemaId,
    Object? schema = _Undefined,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
  }) {
    return PdfDeclaration(
      id: id is int? ? id : this.id,
      pdfId: pdfId ?? this.pdfId,
      pdfContentId: pdfContentId ?? this.pdfContentId,
      pdfContent: pdfContent is _i3.PdfContent?
          ? pdfContent
          : this.pdfContent?.copyWith(),
      schemaId: schemaId ?? this.schemaId,
      schema: schema is _i4.SchemaDefinition?
          ? schema
          : this.schema?.copyWith(),
      referenceLanguage: referenceLanguage ?? this.referenceLanguage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class PdfDeclarationUpdateTable extends _i1.UpdateTable<PdfDeclarationTable> {
  PdfDeclarationUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> pdfId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.pdfId,
        value,
      );

  _i1.ColumnValue<int, int> pdfContentId(int value) => _i1.ColumnValue(
    table.pdfContentId,
    value,
  );

  _i1.ColumnValue<int, int> schemaId(int value) => _i1.ColumnValue(
    table.schemaId,
    value,
  );

  _i1.ColumnValue<_i2.SupportedLanguages, _i2.SupportedLanguages>
  referenceLanguage(_i2.SupportedLanguages value) => _i1.ColumnValue(
    table.referenceLanguage,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class PdfDeclarationTable extends _i1.Table<int?> {
  PdfDeclarationTable({super.tableRelation})
    : super(tableName: 'pdf_declarations') {
    updateTable = PdfDeclarationUpdateTable(this);
    pdfId = _i1.ColumnUuid(
      'pdfId',
      this,
    );
    pdfContentId = _i1.ColumnInt(
      'pdfContentId',
      this,
    );
    schemaId = _i1.ColumnInt(
      'schemaId',
      this,
    );
    referenceLanguage = _i1.ColumnEnum(
      'referenceLanguage',
      this,
      _i1.EnumSerialization.byName,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final PdfDeclarationUpdateTable updateTable;

  late final _i1.ColumnUuid pdfId;

  late final _i1.ColumnInt pdfContentId;

  _i3.PdfContentTable? _pdfContent;

  late final _i1.ColumnInt schemaId;

  _i4.SchemaDefinitionTable? _schema;

  late final _i1.ColumnEnum<_i2.SupportedLanguages> referenceLanguage;

  late final _i1.ColumnDateTime createdAt;

  _i3.PdfContentTable get pdfContent {
    if (_pdfContent != null) return _pdfContent!;
    _pdfContent = _i1.createRelationTable(
      relationFieldName: 'pdfContent',
      field: PdfDeclaration.t.pdfContentId,
      foreignField: _i3.PdfContent.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.PdfContentTable(tableRelation: foreignTableRelation),
    );
    return _pdfContent!;
  }

  _i4.SchemaDefinitionTable get schema {
    if (_schema != null) return _schema!;
    _schema = _i1.createRelationTable(
      relationFieldName: 'schema',
      field: PdfDeclaration.t.schemaId,
      foreignField: _i4.SchemaDefinition.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.SchemaDefinitionTable(tableRelation: foreignTableRelation),
    );
    return _schema!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    pdfId,
    pdfContentId,
    schemaId,
    referenceLanguage,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'pdfContent') {
      return pdfContent;
    }
    if (relationField == 'schema') {
      return schema;
    }
    return null;
  }
}

class PdfDeclarationInclude extends _i1.IncludeObject {
  PdfDeclarationInclude._({
    _i3.PdfContentInclude? pdfContent,
    _i4.SchemaDefinitionInclude? schema,
  }) {
    _pdfContent = pdfContent;
    _schema = schema;
  }

  _i3.PdfContentInclude? _pdfContent;

  _i4.SchemaDefinitionInclude? _schema;

  @override
  Map<String, _i1.Include?> get includes => {
    'pdfContent': _pdfContent,
    'schema': _schema,
  };

  @override
  _i1.Table<int?> get table => PdfDeclaration.t;
}

class PdfDeclarationIncludeList extends _i1.IncludeList {
  PdfDeclarationIncludeList._({
    _i1.WhereExpressionBuilder<PdfDeclarationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PdfDeclaration.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PdfDeclaration.t;
}

class PdfDeclarationRepository {
  const PdfDeclarationRepository._();

  final attachRow = const PdfDeclarationAttachRowRepository._();

  /// Returns a list of [PdfDeclaration]s matching the given query parameters.
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
  Future<List<PdfDeclaration>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PdfDeclarationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PdfDeclarationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PdfDeclarationTable>? orderByList,
    _i1.Transaction? transaction,
    PdfDeclarationInclude? include,
  }) async {
    return session.db.find<PdfDeclaration>(
      where: where?.call(PdfDeclaration.t),
      orderBy: orderBy?.call(PdfDeclaration.t),
      orderByList: orderByList?.call(PdfDeclaration.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [PdfDeclaration] matching the given query parameters.
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
  Future<PdfDeclaration?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PdfDeclarationTable>? where,
    int? offset,
    _i1.OrderByBuilder<PdfDeclarationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PdfDeclarationTable>? orderByList,
    _i1.Transaction? transaction,
    PdfDeclarationInclude? include,
  }) async {
    return session.db.findFirstRow<PdfDeclaration>(
      where: where?.call(PdfDeclaration.t),
      orderBy: orderBy?.call(PdfDeclaration.t),
      orderByList: orderByList?.call(PdfDeclaration.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [PdfDeclaration] by its [id] or null if no such row exists.
  Future<PdfDeclaration?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    PdfDeclarationInclude? include,
  }) async {
    return session.db.findById<PdfDeclaration>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [PdfDeclaration]s in the list and returns the inserted rows.
  ///
  /// The returned [PdfDeclaration]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PdfDeclaration>> insert(
    _i1.Session session,
    List<PdfDeclaration> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PdfDeclaration>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PdfDeclaration] and returns the inserted row.
  ///
  /// The returned [PdfDeclaration] will have its `id` field set.
  Future<PdfDeclaration> insertRow(
    _i1.Session session,
    PdfDeclaration row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PdfDeclaration>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PdfDeclaration]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PdfDeclaration>> update(
    _i1.Session session,
    List<PdfDeclaration> rows, {
    _i1.ColumnSelections<PdfDeclarationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PdfDeclaration>(
      rows,
      columns: columns?.call(PdfDeclaration.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PdfDeclaration]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PdfDeclaration> updateRow(
    _i1.Session session,
    PdfDeclaration row, {
    _i1.ColumnSelections<PdfDeclarationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PdfDeclaration>(
      row,
      columns: columns?.call(PdfDeclaration.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PdfDeclaration] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PdfDeclaration?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PdfDeclarationUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PdfDeclaration>(
      id,
      columnValues: columnValues(PdfDeclaration.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PdfDeclaration]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PdfDeclaration>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PdfDeclarationUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PdfDeclarationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PdfDeclarationTable>? orderBy,
    _i1.OrderByListBuilder<PdfDeclarationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PdfDeclaration>(
      columnValues: columnValues(PdfDeclaration.t.updateTable),
      where: where(PdfDeclaration.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PdfDeclaration.t),
      orderByList: orderByList?.call(PdfDeclaration.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PdfDeclaration]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PdfDeclaration>> delete(
    _i1.Session session,
    List<PdfDeclaration> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PdfDeclaration>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PdfDeclaration].
  Future<PdfDeclaration> deleteRow(
    _i1.Session session,
    PdfDeclaration row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PdfDeclaration>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PdfDeclaration>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PdfDeclarationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PdfDeclaration>(
      where: where(PdfDeclaration.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PdfDeclarationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PdfDeclaration>(
      where: where?.call(PdfDeclaration.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class PdfDeclarationAttachRowRepository {
  const PdfDeclarationAttachRowRepository._();

  /// Creates a relation between the given [PdfDeclaration] and [PdfContent]
  /// by setting the [PdfDeclaration]'s foreign key `pdfContentId` to refer to the [PdfContent].
  Future<void> pdfContent(
    _i1.Session session,
    PdfDeclaration pdfDeclaration,
    _i3.PdfContent pdfContent, {
    _i1.Transaction? transaction,
  }) async {
    if (pdfDeclaration.id == null) {
      throw ArgumentError.notNull('pdfDeclaration.id');
    }
    if (pdfContent.id == null) {
      throw ArgumentError.notNull('pdfContent.id');
    }

    var $pdfDeclaration = pdfDeclaration.copyWith(pdfContentId: pdfContent.id);
    await session.db.updateRow<PdfDeclaration>(
      $pdfDeclaration,
      columns: [PdfDeclaration.t.pdfContentId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [PdfDeclaration] and [SchemaDefinition]
  /// by setting the [PdfDeclaration]'s foreign key `schemaId` to refer to the [SchemaDefinition].
  Future<void> schema(
    _i1.Session session,
    PdfDeclaration pdfDeclaration,
    _i4.SchemaDefinition schema, {
    _i1.Transaction? transaction,
  }) async {
    if (pdfDeclaration.id == null) {
      throw ArgumentError.notNull('pdfDeclaration.id');
    }
    if (schema.id == null) {
      throw ArgumentError.notNull('schema.id');
    }

    var $pdfDeclaration = pdfDeclaration.copyWith(schemaId: schema.id);
    await session.db.updateRow<PdfDeclaration>(
      $pdfDeclaration,
      columns: [PdfDeclaration.t.schemaId],
      transaction: transaction,
    );
  }
}
