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
import '../../../../api/pdf_related/entities/schema_definition.dart' as _i2;
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_version_input.dart'
    as _i3;
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_scaffold.dart'
    as _i4;
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_baseline.dart'
    as _i5;
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i6;

abstract class ShoebillTemplateVersion
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ShoebillTemplateVersion._({
    this.id,
    DateTime? createdAt,
    required this.schemaId,
    this.schema,
    required this.inputId,
    this.input,
    required this.scaffoldId,
    this.scaffold,
    this.implementations,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ShoebillTemplateVersion({
    int? id,
    DateTime? createdAt,
    required int schemaId,
    _i2.SchemaDefinition? schema,
    required int inputId,
    _i3.ShoebillTemplateVersionInput? input,
    required _i1.UuidValue scaffoldId,
    _i4.ShoebillTemplateScaffold? scaffold,
    List<_i5.ShoebillTemplateBaseline>? implementations,
  }) = _ShoebillTemplateVersionImpl;

  factory ShoebillTemplateVersion.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ShoebillTemplateVersion(
      id: jsonSerialization['id'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      schemaId: jsonSerialization['schemaId'] as int,
      schema: jsonSerialization['schema'] == null
          ? null
          : _i6.Protocol().deserialize<_i2.SchemaDefinition>(
              jsonSerialization['schema'],
            ),
      inputId: jsonSerialization['inputId'] as int,
      input: jsonSerialization['input'] == null
          ? null
          : _i6.Protocol().deserialize<_i3.ShoebillTemplateVersionInput>(
              jsonSerialization['input'],
            ),
      scaffoldId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['scaffoldId'],
      ),
      scaffold: jsonSerialization['scaffold'] == null
          ? null
          : _i6.Protocol().deserialize<_i4.ShoebillTemplateScaffold>(
              jsonSerialization['scaffold'],
            ),
      implementations: jsonSerialization['implementations'] == null
          ? null
          : _i6.Protocol().deserialize<List<_i5.ShoebillTemplateBaseline>>(
              jsonSerialization['implementations'],
            ),
    );
  }

  static final t = ShoebillTemplateVersionTable();

  static const db = ShoebillTemplateVersionRepository._();

  @override
  int? id;

  DateTime createdAt;

  int schemaId;

  _i2.SchemaDefinition? schema;

  int inputId;

  _i3.ShoebillTemplateVersionInput? input;

  _i1.UuidValue scaffoldId;

  _i4.ShoebillTemplateScaffold? scaffold;

  List<_i5.ShoebillTemplateBaseline>? implementations;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ShoebillTemplateVersion]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoebillTemplateVersion copyWith({
    int? id,
    DateTime? createdAt,
    int? schemaId,
    _i2.SchemaDefinition? schema,
    int? inputId,
    _i3.ShoebillTemplateVersionInput? input,
    _i1.UuidValue? scaffoldId,
    _i4.ShoebillTemplateScaffold? scaffold,
    List<_i5.ShoebillTemplateBaseline>? implementations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoebillTemplateVersion',
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      'schemaId': schemaId,
      if (schema != null) 'schema': schema?.toJson(),
      'inputId': inputId,
      if (input != null) 'input': input?.toJson(),
      'scaffoldId': scaffoldId.toJson(),
      if (scaffold != null) 'scaffold': scaffold?.toJson(),
      if (implementations != null)
        'implementations': implementations?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShoebillTemplateVersion',
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      'schemaId': schemaId,
      if (schema != null) 'schema': schema?.toJsonForProtocol(),
      'inputId': inputId,
      if (input != null) 'input': input?.toJsonForProtocol(),
      'scaffoldId': scaffoldId.toJson(),
      if (scaffold != null) 'scaffold': scaffold?.toJsonForProtocol(),
      if (implementations != null)
        'implementations': implementations?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  static ShoebillTemplateVersionInclude include({
    _i2.SchemaDefinitionInclude? schema,
    _i3.ShoebillTemplateVersionInputInclude? input,
    _i4.ShoebillTemplateScaffoldInclude? scaffold,
    _i5.ShoebillTemplateBaselineIncludeList? implementations,
  }) {
    return ShoebillTemplateVersionInclude._(
      schema: schema,
      input: input,
      scaffold: scaffold,
      implementations: implementations,
    );
  }

  static ShoebillTemplateVersionIncludeList includeList({
    _i1.WhereExpressionBuilder<ShoebillTemplateVersionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateVersionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateVersionTable>? orderByList,
    ShoebillTemplateVersionInclude? include,
  }) {
    return ShoebillTemplateVersionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoebillTemplateVersion.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ShoebillTemplateVersion.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoebillTemplateVersionImpl extends ShoebillTemplateVersion {
  _ShoebillTemplateVersionImpl({
    int? id,
    DateTime? createdAt,
    required int schemaId,
    _i2.SchemaDefinition? schema,
    required int inputId,
    _i3.ShoebillTemplateVersionInput? input,
    required _i1.UuidValue scaffoldId,
    _i4.ShoebillTemplateScaffold? scaffold,
    List<_i5.ShoebillTemplateBaseline>? implementations,
  }) : super._(
         id: id,
         createdAt: createdAt,
         schemaId: schemaId,
         schema: schema,
         inputId: inputId,
         input: input,
         scaffoldId: scaffoldId,
         scaffold: scaffold,
         implementations: implementations,
       );

  /// Returns a shallow copy of this [ShoebillTemplateVersion]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShoebillTemplateVersion copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    int? schemaId,
    Object? schema = _Undefined,
    int? inputId,
    Object? input = _Undefined,
    _i1.UuidValue? scaffoldId,
    Object? scaffold = _Undefined,
    Object? implementations = _Undefined,
  }) {
    return ShoebillTemplateVersion(
      id: id is int? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      schemaId: schemaId ?? this.schemaId,
      schema: schema is _i2.SchemaDefinition?
          ? schema
          : this.schema?.copyWith(),
      inputId: inputId ?? this.inputId,
      input: input is _i3.ShoebillTemplateVersionInput?
          ? input
          : this.input?.copyWith(),
      scaffoldId: scaffoldId ?? this.scaffoldId,
      scaffold: scaffold is _i4.ShoebillTemplateScaffold?
          ? scaffold
          : this.scaffold?.copyWith(),
      implementations: implementations is List<_i5.ShoebillTemplateBaseline>?
          ? implementations
          : this.implementations?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class ShoebillTemplateVersionUpdateTable
    extends _i1.UpdateTable<ShoebillTemplateVersionTable> {
  ShoebillTemplateVersionUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<int, int> schemaId(int value) => _i1.ColumnValue(
    table.schemaId,
    value,
  );

  _i1.ColumnValue<int, int> inputId(int value) => _i1.ColumnValue(
    table.inputId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> scaffoldId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.scaffoldId,
    value,
  );
}

class ShoebillTemplateVersionTable extends _i1.Table<int?> {
  ShoebillTemplateVersionTable({super.tableRelation})
    : super(tableName: 'shoebill_template_versions') {
    updateTable = ShoebillTemplateVersionUpdateTable(this);
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    schemaId = _i1.ColumnInt(
      'schemaId',
      this,
    );
    inputId = _i1.ColumnInt(
      'inputId',
      this,
    );
    scaffoldId = _i1.ColumnUuid(
      'scaffoldId',
      this,
    );
  }

  late final ShoebillTemplateVersionUpdateTable updateTable;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnInt schemaId;

  _i2.SchemaDefinitionTable? _schema;

  late final _i1.ColumnInt inputId;

  _i3.ShoebillTemplateVersionInputTable? _input;

  late final _i1.ColumnUuid scaffoldId;

  _i4.ShoebillTemplateScaffoldTable? _scaffold;

  _i5.ShoebillTemplateBaselineTable? ___implementations;

  _i1.ManyRelation<_i5.ShoebillTemplateBaselineTable>? _implementations;

  _i2.SchemaDefinitionTable get schema {
    if (_schema != null) return _schema!;
    _schema = _i1.createRelationTable(
      relationFieldName: 'schema',
      field: ShoebillTemplateVersion.t.schemaId,
      foreignField: _i2.SchemaDefinition.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.SchemaDefinitionTable(tableRelation: foreignTableRelation),
    );
    return _schema!;
  }

  _i3.ShoebillTemplateVersionInputTable get input {
    if (_input != null) return _input!;
    _input = _i1.createRelationTable(
      relationFieldName: 'input',
      field: ShoebillTemplateVersion.t.inputId,
      foreignField: _i3.ShoebillTemplateVersionInput.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ShoebillTemplateVersionInputTable(
            tableRelation: foreignTableRelation,
          ),
    );
    return _input!;
  }

  _i4.ShoebillTemplateScaffoldTable get scaffold {
    if (_scaffold != null) return _scaffold!;
    _scaffold = _i1.createRelationTable(
      relationFieldName: 'scaffold',
      field: ShoebillTemplateVersion.t.scaffoldId,
      foreignField: _i4.ShoebillTemplateScaffold.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _i4.ShoebillTemplateScaffoldTable(
        tableRelation: foreignTableRelation,
      ),
    );
    return _scaffold!;
  }

  _i5.ShoebillTemplateBaselineTable get __implementations {
    if (___implementations != null) return ___implementations!;
    ___implementations = _i1.createRelationTable(
      relationFieldName: '__implementations',
      field: ShoebillTemplateVersion.t.id,
      foreignField: _i5.ShoebillTemplateBaseline.t.versionId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _i5.ShoebillTemplateBaselineTable(
        tableRelation: foreignTableRelation,
      ),
    );
    return ___implementations!;
  }

  _i1.ManyRelation<_i5.ShoebillTemplateBaselineTable> get implementations {
    if (_implementations != null) return _implementations!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'implementations',
      field: ShoebillTemplateVersion.t.id,
      foreignField: _i5.ShoebillTemplateBaseline.t.versionId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _i5.ShoebillTemplateBaselineTable(
        tableRelation: foreignTableRelation,
      ),
    );
    _implementations = _i1.ManyRelation<_i5.ShoebillTemplateBaselineTable>(
      tableWithRelations: relationTable,
      table: _i5.ShoebillTemplateBaselineTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _implementations!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    createdAt,
    schemaId,
    inputId,
    scaffoldId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'schema') {
      return schema;
    }
    if (relationField == 'input') {
      return input;
    }
    if (relationField == 'scaffold') {
      return scaffold;
    }
    if (relationField == 'implementations') {
      return __implementations;
    }
    return null;
  }
}

class ShoebillTemplateVersionInclude extends _i1.IncludeObject {
  ShoebillTemplateVersionInclude._({
    _i2.SchemaDefinitionInclude? schema,
    _i3.ShoebillTemplateVersionInputInclude? input,
    _i4.ShoebillTemplateScaffoldInclude? scaffold,
    _i5.ShoebillTemplateBaselineIncludeList? implementations,
  }) {
    _schema = schema;
    _input = input;
    _scaffold = scaffold;
    _implementations = implementations;
  }

  _i2.SchemaDefinitionInclude? _schema;

  _i3.ShoebillTemplateVersionInputInclude? _input;

  _i4.ShoebillTemplateScaffoldInclude? _scaffold;

  _i5.ShoebillTemplateBaselineIncludeList? _implementations;

  @override
  Map<String, _i1.Include?> get includes => {
    'schema': _schema,
    'input': _input,
    'scaffold': _scaffold,
    'implementations': _implementations,
  };

  @override
  _i1.Table<int?> get table => ShoebillTemplateVersion.t;
}

class ShoebillTemplateVersionIncludeList extends _i1.IncludeList {
  ShoebillTemplateVersionIncludeList._({
    _i1.WhereExpressionBuilder<ShoebillTemplateVersionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ShoebillTemplateVersion.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ShoebillTemplateVersion.t;
}

class ShoebillTemplateVersionRepository {
  const ShoebillTemplateVersionRepository._();

  final attach = const ShoebillTemplateVersionAttachRepository._();

  final attachRow = const ShoebillTemplateVersionAttachRowRepository._();

  /// Returns a list of [ShoebillTemplateVersion]s matching the given query parameters.
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
  Future<List<ShoebillTemplateVersion>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateVersionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateVersionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateVersionTable>? orderByList,
    _i1.Transaction? transaction,
    ShoebillTemplateVersionInclude? include,
  }) async {
    return session.db.find<ShoebillTemplateVersion>(
      where: where?.call(ShoebillTemplateVersion.t),
      orderBy: orderBy?.call(ShoebillTemplateVersion.t),
      orderByList: orderByList?.call(ShoebillTemplateVersion.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ShoebillTemplateVersion] matching the given query parameters.
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
  Future<ShoebillTemplateVersion?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateVersionTable>? where,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateVersionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateVersionTable>? orderByList,
    _i1.Transaction? transaction,
    ShoebillTemplateVersionInclude? include,
  }) async {
    return session.db.findFirstRow<ShoebillTemplateVersion>(
      where: where?.call(ShoebillTemplateVersion.t),
      orderBy: orderBy?.call(ShoebillTemplateVersion.t),
      orderByList: orderByList?.call(ShoebillTemplateVersion.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ShoebillTemplateVersion] by its [id] or null if no such row exists.
  Future<ShoebillTemplateVersion?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ShoebillTemplateVersionInclude? include,
  }) async {
    return session.db.findById<ShoebillTemplateVersion>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ShoebillTemplateVersion]s in the list and returns the inserted rows.
  ///
  /// The returned [ShoebillTemplateVersion]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ShoebillTemplateVersion>> insert(
    _i1.Session session,
    List<ShoebillTemplateVersion> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ShoebillTemplateVersion>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ShoebillTemplateVersion] and returns the inserted row.
  ///
  /// The returned [ShoebillTemplateVersion] will have its `id` field set.
  Future<ShoebillTemplateVersion> insertRow(
    _i1.Session session,
    ShoebillTemplateVersion row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ShoebillTemplateVersion>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ShoebillTemplateVersion]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ShoebillTemplateVersion>> update(
    _i1.Session session,
    List<ShoebillTemplateVersion> rows, {
    _i1.ColumnSelections<ShoebillTemplateVersionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ShoebillTemplateVersion>(
      rows,
      columns: columns?.call(ShoebillTemplateVersion.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoebillTemplateVersion]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ShoebillTemplateVersion> updateRow(
    _i1.Session session,
    ShoebillTemplateVersion row, {
    _i1.ColumnSelections<ShoebillTemplateVersionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ShoebillTemplateVersion>(
      row,
      columns: columns?.call(ShoebillTemplateVersion.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoebillTemplateVersion] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ShoebillTemplateVersion?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ShoebillTemplateVersionUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ShoebillTemplateVersion>(
      id,
      columnValues: columnValues(ShoebillTemplateVersion.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ShoebillTemplateVersion]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ShoebillTemplateVersion>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ShoebillTemplateVersionUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ShoebillTemplateVersionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateVersionTable>? orderBy,
    _i1.OrderByListBuilder<ShoebillTemplateVersionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ShoebillTemplateVersion>(
      columnValues: columnValues(ShoebillTemplateVersion.t.updateTable),
      where: where(ShoebillTemplateVersion.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoebillTemplateVersion.t),
      orderByList: orderByList?.call(ShoebillTemplateVersion.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ShoebillTemplateVersion]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ShoebillTemplateVersion>> delete(
    _i1.Session session,
    List<ShoebillTemplateVersion> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ShoebillTemplateVersion>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ShoebillTemplateVersion].
  Future<ShoebillTemplateVersion> deleteRow(
    _i1.Session session,
    ShoebillTemplateVersion row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ShoebillTemplateVersion>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ShoebillTemplateVersion>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ShoebillTemplateVersionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ShoebillTemplateVersion>(
      where: where(ShoebillTemplateVersion.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateVersionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ShoebillTemplateVersion>(
      where: where?.call(ShoebillTemplateVersion.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ShoebillTemplateVersionAttachRepository {
  const ShoebillTemplateVersionAttachRepository._();

  /// Creates a relation between this [ShoebillTemplateVersion] and the given [ShoebillTemplateBaseline]s
  /// by setting each [ShoebillTemplateBaseline]'s foreign key `versionId` to refer to this [ShoebillTemplateVersion].
  Future<void> implementations(
    _i1.Session session,
    ShoebillTemplateVersion shoebillTemplateVersion,
    List<_i5.ShoebillTemplateBaseline> shoebillTemplateBaseline, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateBaseline.any((e) => e.id == null)) {
      throw ArgumentError.notNull('shoebillTemplateBaseline.id');
    }
    if (shoebillTemplateVersion.id == null) {
      throw ArgumentError.notNull('shoebillTemplateVersion.id');
    }

    var $shoebillTemplateBaseline = shoebillTemplateBaseline
        .map((e) => e.copyWith(versionId: shoebillTemplateVersion.id))
        .toList();
    await session.db.update<_i5.ShoebillTemplateBaseline>(
      $shoebillTemplateBaseline,
      columns: [_i5.ShoebillTemplateBaseline.t.versionId],
      transaction: transaction,
    );
  }
}

class ShoebillTemplateVersionAttachRowRepository {
  const ShoebillTemplateVersionAttachRowRepository._();

  /// Creates a relation between the given [ShoebillTemplateVersion] and [SchemaDefinition]
  /// by setting the [ShoebillTemplateVersion]'s foreign key `schemaId` to refer to the [SchemaDefinition].
  Future<void> schema(
    _i1.Session session,
    ShoebillTemplateVersion shoebillTemplateVersion,
    _i2.SchemaDefinition schema, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateVersion.id == null) {
      throw ArgumentError.notNull('shoebillTemplateVersion.id');
    }
    if (schema.id == null) {
      throw ArgumentError.notNull('schema.id');
    }

    var $shoebillTemplateVersion = shoebillTemplateVersion.copyWith(
      schemaId: schema.id,
    );
    await session.db.updateRow<ShoebillTemplateVersion>(
      $shoebillTemplateVersion,
      columns: [ShoebillTemplateVersion.t.schemaId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ShoebillTemplateVersion] and [ShoebillTemplateVersionInput]
  /// by setting the [ShoebillTemplateVersion]'s foreign key `inputId` to refer to the [ShoebillTemplateVersionInput].
  Future<void> input(
    _i1.Session session,
    ShoebillTemplateVersion shoebillTemplateVersion,
    _i3.ShoebillTemplateVersionInput input, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateVersion.id == null) {
      throw ArgumentError.notNull('shoebillTemplateVersion.id');
    }
    if (input.id == null) {
      throw ArgumentError.notNull('input.id');
    }

    var $shoebillTemplateVersion = shoebillTemplateVersion.copyWith(
      inputId: input.id,
    );
    await session.db.updateRow<ShoebillTemplateVersion>(
      $shoebillTemplateVersion,
      columns: [ShoebillTemplateVersion.t.inputId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ShoebillTemplateVersion] and [ShoebillTemplateScaffold]
  /// by setting the [ShoebillTemplateVersion]'s foreign key `scaffoldId` to refer to the [ShoebillTemplateScaffold].
  Future<void> scaffold(
    _i1.Session session,
    ShoebillTemplateVersion shoebillTemplateVersion,
    _i4.ShoebillTemplateScaffold scaffold, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateVersion.id == null) {
      throw ArgumentError.notNull('shoebillTemplateVersion.id');
    }
    if (scaffold.id == null) {
      throw ArgumentError.notNull('scaffold.id');
    }

    var $shoebillTemplateVersion = shoebillTemplateVersion.copyWith(
      scaffoldId: scaffold.id,
    );
    await session.db.updateRow<ShoebillTemplateVersion>(
      $shoebillTemplateVersion,
      columns: [ShoebillTemplateVersion.t.scaffoldId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [ShoebillTemplateVersion] and the given [ShoebillTemplateBaseline]
  /// by setting the [ShoebillTemplateBaseline]'s foreign key `versionId` to refer to this [ShoebillTemplateVersion].
  Future<void> implementations(
    _i1.Session session,
    ShoebillTemplateVersion shoebillTemplateVersion,
    _i5.ShoebillTemplateBaseline shoebillTemplateBaseline, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateBaseline.id == null) {
      throw ArgumentError.notNull('shoebillTemplateBaseline.id');
    }
    if (shoebillTemplateVersion.id == null) {
      throw ArgumentError.notNull('shoebillTemplateVersion.id');
    }

    var $shoebillTemplateBaseline = shoebillTemplateBaseline.copyWith(
      versionId: shoebillTemplateVersion.id,
    );
    await session.db.updateRow<_i5.ShoebillTemplateBaseline>(
      $shoebillTemplateBaseline,
      columns: [_i5.ShoebillTemplateBaseline.t.versionId],
      transaction: transaction,
    );
  }
}
