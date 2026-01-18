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
import '../../../api/pdf_related/entities/schema_definition.dart' as _i3;
import '../../../api/pdf_related/entities/pdf_content.dart' as _i4;
import '../../../api/pdf_related/entities/pdf_implementation_payload.dart'
    as _i5;
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i6;

abstract class PdfDeclaration
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  PdfDeclaration._({
    _i1.UuidValue? id,
    required this.schemaId,
    this.schema,
    _i2.SupportedLanguages? referenceLanguage,
    required this.referencePdfContentId,
    this.referencePdfContent,
    DateTime? createdAt,
    required this.pythonGeneratorScript,
    this.pdfImplementationsPayloads,
  }) : id = id ?? _i1.Uuid().v7obj(),
       referenceLanguage = referenceLanguage ?? _i2.SupportedLanguages.english,
       createdAt = createdAt ?? DateTime.now();

  factory PdfDeclaration({
    _i1.UuidValue? id,
    required int schemaId,
    _i3.SchemaDefinition? schema,
    _i2.SupportedLanguages? referenceLanguage,
    required int referencePdfContentId,
    _i4.PdfContent? referencePdfContent,
    DateTime? createdAt,
    required String pythonGeneratorScript,
    List<_i5.PdfImplementationPayload>? pdfImplementationsPayloads,
  }) = _PdfDeclarationImpl;

  factory PdfDeclaration.fromJson(Map<String, dynamic> jsonSerialization) {
    return PdfDeclaration(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      schemaId: jsonSerialization['schemaId'] as int,
      schema: jsonSerialization['schema'] == null
          ? null
          : _i6.Protocol().deserialize<_i3.SchemaDefinition>(
              jsonSerialization['schema'],
            ),
      referenceLanguage: jsonSerialization['referenceLanguage'] == null
          ? null
          : _i2.SupportedLanguages.fromJson(
              (jsonSerialization['referenceLanguage'] as String),
            ),
      referencePdfContentId: jsonSerialization['referencePdfContentId'] as int,
      referencePdfContent: jsonSerialization['referencePdfContent'] == null
          ? null
          : _i6.Protocol().deserialize<_i4.PdfContent>(
              jsonSerialization['referencePdfContent'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      pythonGeneratorScript:
          jsonSerialization['pythonGeneratorScript'] as String,
      pdfImplementationsPayloads:
          jsonSerialization['pdfImplementationsPayloads'] == null
          ? null
          : _i6.Protocol().deserialize<List<_i5.PdfImplementationPayload>>(
              jsonSerialization['pdfImplementationsPayloads'],
            ),
    );
  }

  static final t = PdfDeclarationTable();

  static const db = PdfDeclarationRepository._();

  @override
  _i1.UuidValue id;

  int schemaId;

  _i3.SchemaDefinition? schema;

  _i2.SupportedLanguages referenceLanguage;

  int referencePdfContentId;

  _i4.PdfContent? referencePdfContent;

  DateTime createdAt;

  String pythonGeneratorScript;

  List<_i5.PdfImplementationPayload>? pdfImplementationsPayloads;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  /// Returns a shallow copy of this [PdfDeclaration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PdfDeclaration copyWith({
    _i1.UuidValue? id,
    int? schemaId,
    _i3.SchemaDefinition? schema,
    _i2.SupportedLanguages? referenceLanguage,
    int? referencePdfContentId,
    _i4.PdfContent? referencePdfContent,
    DateTime? createdAt,
    String? pythonGeneratorScript,
    List<_i5.PdfImplementationPayload>? pdfImplementationsPayloads,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PdfDeclaration',
      'id': id.toJson(),
      'schemaId': schemaId,
      if (schema != null) 'schema': schema?.toJson(),
      'referenceLanguage': referenceLanguage.toJson(),
      'referencePdfContentId': referencePdfContentId,
      if (referencePdfContent != null)
        'referencePdfContent': referencePdfContent?.toJson(),
      'createdAt': createdAt.toJson(),
      'pythonGeneratorScript': pythonGeneratorScript,
      if (pdfImplementationsPayloads != null)
        'pdfImplementationsPayloads': pdfImplementationsPayloads?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PdfDeclaration',
      'id': id.toJson(),
      'schemaId': schemaId,
      if (schema != null) 'schema': schema?.toJsonForProtocol(),
      'referenceLanguage': referenceLanguage.toJson(),
      'referencePdfContentId': referencePdfContentId,
      if (referencePdfContent != null)
        'referencePdfContent': referencePdfContent?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
      'pythonGeneratorScript': pythonGeneratorScript,
      if (pdfImplementationsPayloads != null)
        'pdfImplementationsPayloads': pdfImplementationsPayloads?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  static PdfDeclarationInclude include({
    _i3.SchemaDefinitionInclude? schema,
    _i4.PdfContentInclude? referencePdfContent,
    _i5.PdfImplementationPayloadIncludeList? pdfImplementationsPayloads,
  }) {
    return PdfDeclarationInclude._(
      schema: schema,
      referencePdfContent: referencePdfContent,
      pdfImplementationsPayloads: pdfImplementationsPayloads,
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
    _i1.UuidValue? id,
    required int schemaId,
    _i3.SchemaDefinition? schema,
    _i2.SupportedLanguages? referenceLanguage,
    required int referencePdfContentId,
    _i4.PdfContent? referencePdfContent,
    DateTime? createdAt,
    required String pythonGeneratorScript,
    List<_i5.PdfImplementationPayload>? pdfImplementationsPayloads,
  }) : super._(
         id: id,
         schemaId: schemaId,
         schema: schema,
         referenceLanguage: referenceLanguage,
         referencePdfContentId: referencePdfContentId,
         referencePdfContent: referencePdfContent,
         createdAt: createdAt,
         pythonGeneratorScript: pythonGeneratorScript,
         pdfImplementationsPayloads: pdfImplementationsPayloads,
       );

  /// Returns a shallow copy of this [PdfDeclaration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PdfDeclaration copyWith({
    _i1.UuidValue? id,
    int? schemaId,
    Object? schema = _Undefined,
    _i2.SupportedLanguages? referenceLanguage,
    int? referencePdfContentId,
    Object? referencePdfContent = _Undefined,
    DateTime? createdAt,
    String? pythonGeneratorScript,
    Object? pdfImplementationsPayloads = _Undefined,
  }) {
    return PdfDeclaration(
      id: id ?? this.id,
      schemaId: schemaId ?? this.schemaId,
      schema: schema is _i3.SchemaDefinition?
          ? schema
          : this.schema?.copyWith(),
      referenceLanguage: referenceLanguage ?? this.referenceLanguage,
      referencePdfContentId:
          referencePdfContentId ?? this.referencePdfContentId,
      referencePdfContent: referencePdfContent is _i4.PdfContent?
          ? referencePdfContent
          : this.referencePdfContent?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      pythonGeneratorScript:
          pythonGeneratorScript ?? this.pythonGeneratorScript,
      pdfImplementationsPayloads:
          pdfImplementationsPayloads is List<_i5.PdfImplementationPayload>?
          ? pdfImplementationsPayloads
          : this.pdfImplementationsPayloads
                ?.map((e0) => e0.copyWith())
                .toList(),
    );
  }
}

class PdfDeclarationUpdateTable extends _i1.UpdateTable<PdfDeclarationTable> {
  PdfDeclarationUpdateTable(super.table);

  _i1.ColumnValue<int, int> schemaId(int value) => _i1.ColumnValue(
    table.schemaId,
    value,
  );

  _i1.ColumnValue<_i2.SupportedLanguages, _i2.SupportedLanguages>
  referenceLanguage(_i2.SupportedLanguages value) => _i1.ColumnValue(
    table.referenceLanguage,
    value,
  );

  _i1.ColumnValue<int, int> referencePdfContentId(int value) => _i1.ColumnValue(
    table.referencePdfContentId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<String, String> pythonGeneratorScript(String value) =>
      _i1.ColumnValue(
        table.pythonGeneratorScript,
        value,
      );
}

class PdfDeclarationTable extends _i1.Table<_i1.UuidValue> {
  PdfDeclarationTable({super.tableRelation})
    : super(tableName: 'pdf_declarations') {
    updateTable = PdfDeclarationUpdateTable(this);
    schemaId = _i1.ColumnInt(
      'schemaId',
      this,
    );
    referenceLanguage = _i1.ColumnEnum(
      'referenceLanguage',
      this,
      _i1.EnumSerialization.byName,
    );
    referencePdfContentId = _i1.ColumnInt(
      'referencePdfContentId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    pythonGeneratorScript = _i1.ColumnString(
      'pythonGeneratorScript',
      this,
    );
  }

  late final PdfDeclarationUpdateTable updateTable;

  late final _i1.ColumnInt schemaId;

  _i3.SchemaDefinitionTable? _schema;

  late final _i1.ColumnEnum<_i2.SupportedLanguages> referenceLanguage;

  late final _i1.ColumnInt referencePdfContentId;

  _i4.PdfContentTable? _referencePdfContent;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnString pythonGeneratorScript;

  _i5.PdfImplementationPayloadTable? ___pdfImplementationsPayloads;

  _i1.ManyRelation<_i5.PdfImplementationPayloadTable>?
  _pdfImplementationsPayloads;

  _i3.SchemaDefinitionTable get schema {
    if (_schema != null) return _schema!;
    _schema = _i1.createRelationTable(
      relationFieldName: 'schema',
      field: PdfDeclaration.t.schemaId,
      foreignField: _i3.SchemaDefinition.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.SchemaDefinitionTable(tableRelation: foreignTableRelation),
    );
    return _schema!;
  }

  _i4.PdfContentTable get referencePdfContent {
    if (_referencePdfContent != null) return _referencePdfContent!;
    _referencePdfContent = _i1.createRelationTable(
      relationFieldName: 'referencePdfContent',
      field: PdfDeclaration.t.referencePdfContentId,
      foreignField: _i4.PdfContent.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.PdfContentTable(tableRelation: foreignTableRelation),
    );
    return _referencePdfContent!;
  }

  _i5.PdfImplementationPayloadTable get __pdfImplementationsPayloads {
    if (___pdfImplementationsPayloads != null)
      return ___pdfImplementationsPayloads!;
    ___pdfImplementationsPayloads = _i1.createRelationTable(
      relationFieldName: '__pdfImplementationsPayloads',
      field: PdfDeclaration.t.id,
      foreignField: _i5.PdfImplementationPayload.t.pdfDeclarationId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _i5.PdfImplementationPayloadTable(
        tableRelation: foreignTableRelation,
      ),
    );
    return ___pdfImplementationsPayloads!;
  }

  _i1.ManyRelation<_i5.PdfImplementationPayloadTable>
  get pdfImplementationsPayloads {
    if (_pdfImplementationsPayloads != null)
      return _pdfImplementationsPayloads!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'pdfImplementationsPayloads',
      field: PdfDeclaration.t.id,
      foreignField: _i5.PdfImplementationPayload.t.pdfDeclarationId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _i5.PdfImplementationPayloadTable(
        tableRelation: foreignTableRelation,
      ),
    );
    _pdfImplementationsPayloads =
        _i1.ManyRelation<_i5.PdfImplementationPayloadTable>(
          tableWithRelations: relationTable,
          table: _i5.PdfImplementationPayloadTable(
            tableRelation: relationTable.tableRelation!.lastRelation,
          ),
        );
    return _pdfImplementationsPayloads!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    schemaId,
    referenceLanguage,
    referencePdfContentId,
    createdAt,
    pythonGeneratorScript,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'schema') {
      return schema;
    }
    if (relationField == 'referencePdfContent') {
      return referencePdfContent;
    }
    if (relationField == 'pdfImplementationsPayloads') {
      return __pdfImplementationsPayloads;
    }
    return null;
  }
}

class PdfDeclarationInclude extends _i1.IncludeObject {
  PdfDeclarationInclude._({
    _i3.SchemaDefinitionInclude? schema,
    _i4.PdfContentInclude? referencePdfContent,
    _i5.PdfImplementationPayloadIncludeList? pdfImplementationsPayloads,
  }) {
    _schema = schema;
    _referencePdfContent = referencePdfContent;
    _pdfImplementationsPayloads = pdfImplementationsPayloads;
  }

  _i3.SchemaDefinitionInclude? _schema;

  _i4.PdfContentInclude? _referencePdfContent;

  _i5.PdfImplementationPayloadIncludeList? _pdfImplementationsPayloads;

  @override
  Map<String, _i1.Include?> get includes => {
    'schema': _schema,
    'referencePdfContent': _referencePdfContent,
    'pdfImplementationsPayloads': _pdfImplementationsPayloads,
  };

  @override
  _i1.Table<_i1.UuidValue> get table => PdfDeclaration.t;
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
  _i1.Table<_i1.UuidValue> get table => PdfDeclaration.t;
}

class PdfDeclarationRepository {
  const PdfDeclarationRepository._();

  final attach = const PdfDeclarationAttachRepository._();

  final attachRow = const PdfDeclarationAttachRowRepository._();

  final detach = const PdfDeclarationDetachRepository._();

  final detachRow = const PdfDeclarationDetachRowRepository._();

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
    _i1.UuidValue id, {
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
    _i1.UuidValue id, {
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

class PdfDeclarationAttachRepository {
  const PdfDeclarationAttachRepository._();

  /// Creates a relation between this [PdfDeclaration] and the given [PdfImplementationPayload]s
  /// by setting each [PdfImplementationPayload]'s foreign key `pdfDeclarationId` to refer to this [PdfDeclaration].
  Future<void> pdfImplementationsPayloads(
    _i1.Session session,
    PdfDeclaration pdfDeclaration,
    List<_i5.PdfImplementationPayload> pdfImplementationPayload, {
    _i1.Transaction? transaction,
  }) async {
    if (pdfImplementationPayload.any((e) => e.id == null)) {
      throw ArgumentError.notNull('pdfImplementationPayload.id');
    }
    if (pdfDeclaration.id == null) {
      throw ArgumentError.notNull('pdfDeclaration.id');
    }

    var $pdfImplementationPayload = pdfImplementationPayload
        .map((e) => e.copyWith(pdfDeclarationId: pdfDeclaration.id))
        .toList();
    await session.db.update<_i5.PdfImplementationPayload>(
      $pdfImplementationPayload,
      columns: [_i5.PdfImplementationPayload.t.pdfDeclarationId],
      transaction: transaction,
    );
  }
}

class PdfDeclarationAttachRowRepository {
  const PdfDeclarationAttachRowRepository._();

  /// Creates a relation between the given [PdfDeclaration] and [SchemaDefinition]
  /// by setting the [PdfDeclaration]'s foreign key `schemaId` to refer to the [SchemaDefinition].
  Future<void> schema(
    _i1.Session session,
    PdfDeclaration pdfDeclaration,
    _i3.SchemaDefinition schema, {
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

  /// Creates a relation between the given [PdfDeclaration] and [PdfContent]
  /// by setting the [PdfDeclaration]'s foreign key `referencePdfContentId` to refer to the [PdfContent].
  Future<void> referencePdfContent(
    _i1.Session session,
    PdfDeclaration pdfDeclaration,
    _i4.PdfContent referencePdfContent, {
    _i1.Transaction? transaction,
  }) async {
    if (pdfDeclaration.id == null) {
      throw ArgumentError.notNull('pdfDeclaration.id');
    }
    if (referencePdfContent.id == null) {
      throw ArgumentError.notNull('referencePdfContent.id');
    }

    var $pdfDeclaration = pdfDeclaration.copyWith(
      referencePdfContentId: referencePdfContent.id,
    );
    await session.db.updateRow<PdfDeclaration>(
      $pdfDeclaration,
      columns: [PdfDeclaration.t.referencePdfContentId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [PdfDeclaration] and the given [PdfImplementationPayload]
  /// by setting the [PdfImplementationPayload]'s foreign key `pdfDeclarationId` to refer to this [PdfDeclaration].
  Future<void> pdfImplementationsPayloads(
    _i1.Session session,
    PdfDeclaration pdfDeclaration,
    _i5.PdfImplementationPayload pdfImplementationPayload, {
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
    await session.db.updateRow<_i5.PdfImplementationPayload>(
      $pdfImplementationPayload,
      columns: [_i5.PdfImplementationPayload.t.pdfDeclarationId],
      transaction: transaction,
    );
  }
}

class PdfDeclarationDetachRepository {
  const PdfDeclarationDetachRepository._();

  /// Detaches the relation between this [PdfDeclaration] and the given [PdfImplementationPayload]
  /// by setting the [PdfImplementationPayload]'s foreign key `pdfDeclarationId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> pdfImplementationsPayloads(
    _i1.Session session,
    List<_i5.PdfImplementationPayload> pdfImplementationPayload, {
    _i1.Transaction? transaction,
  }) async {
    if (pdfImplementationPayload.any((e) => e.id == null)) {
      throw ArgumentError.notNull('pdfImplementationPayload.id');
    }

    var $pdfImplementationPayload = pdfImplementationPayload
        .map((e) => e.copyWith(pdfDeclarationId: null))
        .toList();
    await session.db.update<_i5.PdfImplementationPayload>(
      $pdfImplementationPayload,
      columns: [_i5.PdfImplementationPayload.t.pdfDeclarationId],
      transaction: transaction,
    );
  }
}

class PdfDeclarationDetachRowRepository {
  const PdfDeclarationDetachRowRepository._();

  /// Detaches the relation between this [PdfDeclaration] and the given [PdfImplementationPayload]
  /// by setting the [PdfImplementationPayload]'s foreign key `pdfDeclarationId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> pdfImplementationsPayloads(
    _i1.Session session,
    _i5.PdfImplementationPayload pdfImplementationPayload, {
    _i1.Transaction? transaction,
  }) async {
    if (pdfImplementationPayload.id == null) {
      throw ArgumentError.notNull('pdfImplementationPayload.id');
    }

    var $pdfImplementationPayload = pdfImplementationPayload.copyWith(
      pdfDeclarationId: null,
    );
    await session.db.updateRow<_i5.PdfImplementationPayload>(
      $pdfImplementationPayload,
      columns: [_i5.PdfImplementationPayload.t.pdfDeclarationId],
      transaction: transaction,
    );
  }
}
