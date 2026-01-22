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
import '../../../../entities/others/supported_languages.dart' as _i2;
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_version.dart'
    as _i3;
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_baseline_implementation.dart'
    as _i4;
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i5;

abstract class ShoebillTemplateBaseline
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  ShoebillTemplateBaseline._({
    _i1.UuidValue? id,
    required this.referenceLanguage,
    DateTime? createdAt,
    required this.versionId,
    this.version,
    this.implementations,
  }) : id = id ?? _i1.Uuid().v7obj(),
       createdAt = createdAt ?? DateTime.now();

  factory ShoebillTemplateBaseline({
    _i1.UuidValue? id,
    required _i2.SupportedLanguages referenceLanguage,
    DateTime? createdAt,
    required int versionId,
    _i3.ShoebillTemplateVersion? version,
    List<_i4.ShoebillTemplateBaselineImplementation>? implementations,
  }) = _ShoebillTemplateBaselineImpl;

  factory ShoebillTemplateBaseline.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ShoebillTemplateBaseline(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      referenceLanguage: _i2.SupportedLanguages.fromJson(
        (jsonSerialization['referenceLanguage'] as String),
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      versionId: jsonSerialization['versionId'] as int,
      version: jsonSerialization['version'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.ShoebillTemplateVersion>(
              jsonSerialization['version'],
            ),
      implementations: jsonSerialization['implementations'] == null
          ? null
          : _i5.Protocol()
                .deserialize<List<_i4.ShoebillTemplateBaselineImplementation>>(
                  jsonSerialization['implementations'],
                ),
    );
  }

  static final t = ShoebillTemplateBaselineTable();

  static const db = ShoebillTemplateBaselineRepository._();

  @override
  _i1.UuidValue id;

  _i2.SupportedLanguages referenceLanguage;

  DateTime createdAt;

  int versionId;

  _i3.ShoebillTemplateVersion? version;

  List<_i4.ShoebillTemplateBaselineImplementation>? implementations;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  /// Returns a shallow copy of this [ShoebillTemplateBaseline]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoebillTemplateBaseline copyWith({
    _i1.UuidValue? id,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
    int? versionId,
    _i3.ShoebillTemplateVersion? version,
    List<_i4.ShoebillTemplateBaselineImplementation>? implementations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoebillTemplateBaseline',
      'id': id.toJson(),
      'referenceLanguage': referenceLanguage.toJson(),
      'createdAt': createdAt.toJson(),
      'versionId': versionId,
      if (version != null) 'version': version?.toJson(),
      if (implementations != null)
        'implementations': implementations?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShoebillTemplateBaseline',
      'id': id.toJson(),
      'referenceLanguage': referenceLanguage.toJson(),
      'createdAt': createdAt.toJson(),
      'versionId': versionId,
      if (version != null) 'version': version?.toJsonForProtocol(),
      if (implementations != null)
        'implementations': implementations?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  static ShoebillTemplateBaselineInclude include({
    _i3.ShoebillTemplateVersionInclude? version,
    _i4.ShoebillTemplateBaselineImplementationIncludeList? implementations,
  }) {
    return ShoebillTemplateBaselineInclude._(
      version: version,
      implementations: implementations,
    );
  }

  static ShoebillTemplateBaselineIncludeList includeList({
    _i1.WhereExpressionBuilder<ShoebillTemplateBaselineTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateBaselineTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateBaselineTable>? orderByList,
    ShoebillTemplateBaselineInclude? include,
  }) {
    return ShoebillTemplateBaselineIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoebillTemplateBaseline.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ShoebillTemplateBaseline.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoebillTemplateBaselineImpl extends ShoebillTemplateBaseline {
  _ShoebillTemplateBaselineImpl({
    _i1.UuidValue? id,
    required _i2.SupportedLanguages referenceLanguage,
    DateTime? createdAt,
    required int versionId,
    _i3.ShoebillTemplateVersion? version,
    List<_i4.ShoebillTemplateBaselineImplementation>? implementations,
  }) : super._(
         id: id,
         referenceLanguage: referenceLanguage,
         createdAt: createdAt,
         versionId: versionId,
         version: version,
         implementations: implementations,
       );

  /// Returns a shallow copy of this [ShoebillTemplateBaseline]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShoebillTemplateBaseline copyWith({
    _i1.UuidValue? id,
    _i2.SupportedLanguages? referenceLanguage,
    DateTime? createdAt,
    int? versionId,
    Object? version = _Undefined,
    Object? implementations = _Undefined,
  }) {
    return ShoebillTemplateBaseline(
      id: id ?? this.id,
      referenceLanguage: referenceLanguage ?? this.referenceLanguage,
      createdAt: createdAt ?? this.createdAt,
      versionId: versionId ?? this.versionId,
      version: version is _i3.ShoebillTemplateVersion?
          ? version
          : this.version?.copyWith(),
      implementations:
          implementations is List<_i4.ShoebillTemplateBaselineImplementation>?
          ? implementations
          : this.implementations?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class ShoebillTemplateBaselineUpdateTable
    extends _i1.UpdateTable<ShoebillTemplateBaselineTable> {
  ShoebillTemplateBaselineUpdateTable(super.table);

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

  _i1.ColumnValue<int, int> versionId(int value) => _i1.ColumnValue(
    table.versionId,
    value,
  );
}

class ShoebillTemplateBaselineTable extends _i1.Table<_i1.UuidValue> {
  ShoebillTemplateBaselineTable({super.tableRelation})
    : super(tableName: 'shoebill_template_baselines') {
    updateTable = ShoebillTemplateBaselineUpdateTable(this);
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
    versionId = _i1.ColumnInt(
      'versionId',
      this,
    );
  }

  late final ShoebillTemplateBaselineUpdateTable updateTable;

  late final _i1.ColumnEnum<_i2.SupportedLanguages> referenceLanguage;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnInt versionId;

  _i3.ShoebillTemplateVersionTable? _version;

  _i4.ShoebillTemplateBaselineImplementationTable? ___implementations;

  _i1.ManyRelation<_i4.ShoebillTemplateBaselineImplementationTable>?
  _implementations;

  _i3.ShoebillTemplateVersionTable get version {
    if (_version != null) return _version!;
    _version = _i1.createRelationTable(
      relationFieldName: 'version',
      field: ShoebillTemplateBaseline.t.versionId,
      foreignField: _i3.ShoebillTemplateVersion.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ShoebillTemplateVersionTable(tableRelation: foreignTableRelation),
    );
    return _version!;
  }

  _i4.ShoebillTemplateBaselineImplementationTable get __implementations {
    if (___implementations != null) return ___implementations!;
    ___implementations = _i1.createRelationTable(
      relationFieldName: '__implementations',
      field: ShoebillTemplateBaseline.t.id,
      foreignField: _i4.ShoebillTemplateBaselineImplementation.t.baselineId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.ShoebillTemplateBaselineImplementationTable(
            tableRelation: foreignTableRelation,
          ),
    );
    return ___implementations!;
  }

  _i1.ManyRelation<_i4.ShoebillTemplateBaselineImplementationTable>
  get implementations {
    if (_implementations != null) return _implementations!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'implementations',
      field: ShoebillTemplateBaseline.t.id,
      foreignField: _i4.ShoebillTemplateBaselineImplementation.t.baselineId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.ShoebillTemplateBaselineImplementationTable(
            tableRelation: foreignTableRelation,
          ),
    );
    _implementations =
        _i1.ManyRelation<_i4.ShoebillTemplateBaselineImplementationTable>(
          tableWithRelations: relationTable,
          table: _i4.ShoebillTemplateBaselineImplementationTable(
            tableRelation: relationTable.tableRelation!.lastRelation,
          ),
        );
    return _implementations!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    referenceLanguage,
    createdAt,
    versionId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'version') {
      return version;
    }
    if (relationField == 'implementations') {
      return __implementations;
    }
    return null;
  }
}

class ShoebillTemplateBaselineInclude extends _i1.IncludeObject {
  ShoebillTemplateBaselineInclude._({
    _i3.ShoebillTemplateVersionInclude? version,
    _i4.ShoebillTemplateBaselineImplementationIncludeList? implementations,
  }) {
    _version = version;
    _implementations = implementations;
  }

  _i3.ShoebillTemplateVersionInclude? _version;

  _i4.ShoebillTemplateBaselineImplementationIncludeList? _implementations;

  @override
  Map<String, _i1.Include?> get includes => {
    'version': _version,
    'implementations': _implementations,
  };

  @override
  _i1.Table<_i1.UuidValue> get table => ShoebillTemplateBaseline.t;
}

class ShoebillTemplateBaselineIncludeList extends _i1.IncludeList {
  ShoebillTemplateBaselineIncludeList._({
    _i1.WhereExpressionBuilder<ShoebillTemplateBaselineTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ShoebillTemplateBaseline.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => ShoebillTemplateBaseline.t;
}

class ShoebillTemplateBaselineRepository {
  const ShoebillTemplateBaselineRepository._();

  final attach = const ShoebillTemplateBaselineAttachRepository._();

  final attachRow = const ShoebillTemplateBaselineAttachRowRepository._();

  final detach = const ShoebillTemplateBaselineDetachRepository._();

  final detachRow = const ShoebillTemplateBaselineDetachRowRepository._();

  /// Returns a list of [ShoebillTemplateBaseline]s matching the given query parameters.
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
  Future<List<ShoebillTemplateBaseline>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateBaselineTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateBaselineTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateBaselineTable>? orderByList,
    _i1.Transaction? transaction,
    ShoebillTemplateBaselineInclude? include,
  }) async {
    return session.db.find<ShoebillTemplateBaseline>(
      where: where?.call(ShoebillTemplateBaseline.t),
      orderBy: orderBy?.call(ShoebillTemplateBaseline.t),
      orderByList: orderByList?.call(ShoebillTemplateBaseline.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ShoebillTemplateBaseline] matching the given query parameters.
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
  Future<ShoebillTemplateBaseline?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateBaselineTable>? where,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateBaselineTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateBaselineTable>? orderByList,
    _i1.Transaction? transaction,
    ShoebillTemplateBaselineInclude? include,
  }) async {
    return session.db.findFirstRow<ShoebillTemplateBaseline>(
      where: where?.call(ShoebillTemplateBaseline.t),
      orderBy: orderBy?.call(ShoebillTemplateBaseline.t),
      orderByList: orderByList?.call(ShoebillTemplateBaseline.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ShoebillTemplateBaseline] by its [id] or null if no such row exists.
  Future<ShoebillTemplateBaseline?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    ShoebillTemplateBaselineInclude? include,
  }) async {
    return session.db.findById<ShoebillTemplateBaseline>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ShoebillTemplateBaseline]s in the list and returns the inserted rows.
  ///
  /// The returned [ShoebillTemplateBaseline]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ShoebillTemplateBaseline>> insert(
    _i1.Session session,
    List<ShoebillTemplateBaseline> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ShoebillTemplateBaseline>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ShoebillTemplateBaseline] and returns the inserted row.
  ///
  /// The returned [ShoebillTemplateBaseline] will have its `id` field set.
  Future<ShoebillTemplateBaseline> insertRow(
    _i1.Session session,
    ShoebillTemplateBaseline row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ShoebillTemplateBaseline>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ShoebillTemplateBaseline]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ShoebillTemplateBaseline>> update(
    _i1.Session session,
    List<ShoebillTemplateBaseline> rows, {
    _i1.ColumnSelections<ShoebillTemplateBaselineTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ShoebillTemplateBaseline>(
      rows,
      columns: columns?.call(ShoebillTemplateBaseline.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoebillTemplateBaseline]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ShoebillTemplateBaseline> updateRow(
    _i1.Session session,
    ShoebillTemplateBaseline row, {
    _i1.ColumnSelections<ShoebillTemplateBaselineTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ShoebillTemplateBaseline>(
      row,
      columns: columns?.call(ShoebillTemplateBaseline.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoebillTemplateBaseline] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ShoebillTemplateBaseline?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ShoebillTemplateBaselineUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ShoebillTemplateBaseline>(
      id,
      columnValues: columnValues(ShoebillTemplateBaseline.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ShoebillTemplateBaseline]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ShoebillTemplateBaseline>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ShoebillTemplateBaselineUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ShoebillTemplateBaselineTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateBaselineTable>? orderBy,
    _i1.OrderByListBuilder<ShoebillTemplateBaselineTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ShoebillTemplateBaseline>(
      columnValues: columnValues(ShoebillTemplateBaseline.t.updateTable),
      where: where(ShoebillTemplateBaseline.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoebillTemplateBaseline.t),
      orderByList: orderByList?.call(ShoebillTemplateBaseline.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ShoebillTemplateBaseline]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ShoebillTemplateBaseline>> delete(
    _i1.Session session,
    List<ShoebillTemplateBaseline> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ShoebillTemplateBaseline>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ShoebillTemplateBaseline].
  Future<ShoebillTemplateBaseline> deleteRow(
    _i1.Session session,
    ShoebillTemplateBaseline row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ShoebillTemplateBaseline>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ShoebillTemplateBaseline>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ShoebillTemplateBaselineTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ShoebillTemplateBaseline>(
      where: where(ShoebillTemplateBaseline.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateBaselineTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ShoebillTemplateBaseline>(
      where: where?.call(ShoebillTemplateBaseline.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ShoebillTemplateBaselineAttachRepository {
  const ShoebillTemplateBaselineAttachRepository._();

  /// Creates a relation between this [ShoebillTemplateBaseline] and the given [ShoebillTemplateBaselineImplementation]s
  /// by setting each [ShoebillTemplateBaselineImplementation]'s foreign key `baselineId` to refer to this [ShoebillTemplateBaseline].
  Future<void> implementations(
    _i1.Session session,
    ShoebillTemplateBaseline shoebillTemplateBaseline,
    List<_i4.ShoebillTemplateBaselineImplementation>
    shoebillTemplateBaselineImplementation, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateBaselineImplementation.any((e) => e.id == null)) {
      throw ArgumentError.notNull('shoebillTemplateBaselineImplementation.id');
    }
    if (shoebillTemplateBaseline.id == null) {
      throw ArgumentError.notNull('shoebillTemplateBaseline.id');
    }

    var $shoebillTemplateBaselineImplementation =
        shoebillTemplateBaselineImplementation
            .map((e) => e.copyWith(baselineId: shoebillTemplateBaseline.id))
            .toList();
    await session.db.update<_i4.ShoebillTemplateBaselineImplementation>(
      $shoebillTemplateBaselineImplementation,
      columns: [_i4.ShoebillTemplateBaselineImplementation.t.baselineId],
      transaction: transaction,
    );
  }
}

class ShoebillTemplateBaselineAttachRowRepository {
  const ShoebillTemplateBaselineAttachRowRepository._();

  /// Creates a relation between the given [ShoebillTemplateBaseline] and [ShoebillTemplateVersion]
  /// by setting the [ShoebillTemplateBaseline]'s foreign key `versionId` to refer to the [ShoebillTemplateVersion].
  Future<void> version(
    _i1.Session session,
    ShoebillTemplateBaseline shoebillTemplateBaseline,
    _i3.ShoebillTemplateVersion version, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateBaseline.id == null) {
      throw ArgumentError.notNull('shoebillTemplateBaseline.id');
    }
    if (version.id == null) {
      throw ArgumentError.notNull('version.id');
    }

    var $shoebillTemplateBaseline = shoebillTemplateBaseline.copyWith(
      versionId: version.id,
    );
    await session.db.updateRow<ShoebillTemplateBaseline>(
      $shoebillTemplateBaseline,
      columns: [ShoebillTemplateBaseline.t.versionId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [ShoebillTemplateBaseline] and the given [ShoebillTemplateBaselineImplementation]
  /// by setting the [ShoebillTemplateBaselineImplementation]'s foreign key `baselineId` to refer to this [ShoebillTemplateBaseline].
  Future<void> implementations(
    _i1.Session session,
    ShoebillTemplateBaseline shoebillTemplateBaseline,
    _i4.ShoebillTemplateBaselineImplementation
    shoebillTemplateBaselineImplementation, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateBaselineImplementation.id == null) {
      throw ArgumentError.notNull('shoebillTemplateBaselineImplementation.id');
    }
    if (shoebillTemplateBaseline.id == null) {
      throw ArgumentError.notNull('shoebillTemplateBaseline.id');
    }

    var $shoebillTemplateBaselineImplementation =
        shoebillTemplateBaselineImplementation.copyWith(
          baselineId: shoebillTemplateBaseline.id,
        );
    await session.db.updateRow<_i4.ShoebillTemplateBaselineImplementation>(
      $shoebillTemplateBaselineImplementation,
      columns: [_i4.ShoebillTemplateBaselineImplementation.t.baselineId],
      transaction: transaction,
    );
  }
}

class ShoebillTemplateBaselineDetachRepository {
  const ShoebillTemplateBaselineDetachRepository._();

  /// Detaches the relation between this [ShoebillTemplateBaseline] and the given [ShoebillTemplateBaselineImplementation]
  /// by setting the [ShoebillTemplateBaselineImplementation]'s foreign key `baselineId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> implementations(
    _i1.Session session,
    List<_i4.ShoebillTemplateBaselineImplementation>
    shoebillTemplateBaselineImplementation, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateBaselineImplementation.any((e) => e.id == null)) {
      throw ArgumentError.notNull('shoebillTemplateBaselineImplementation.id');
    }

    var $shoebillTemplateBaselineImplementation =
        shoebillTemplateBaselineImplementation
            .map((e) => e.copyWith(baselineId: null))
            .toList();
    await session.db.update<_i4.ShoebillTemplateBaselineImplementation>(
      $shoebillTemplateBaselineImplementation,
      columns: [_i4.ShoebillTemplateBaselineImplementation.t.baselineId],
      transaction: transaction,
    );
  }
}

class ShoebillTemplateBaselineDetachRowRepository {
  const ShoebillTemplateBaselineDetachRowRepository._();

  /// Detaches the relation between this [ShoebillTemplateBaseline] and the given [ShoebillTemplateBaselineImplementation]
  /// by setting the [ShoebillTemplateBaselineImplementation]'s foreign key `baselineId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> implementations(
    _i1.Session session,
    _i4.ShoebillTemplateBaselineImplementation
    shoebillTemplateBaselineImplementation, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateBaselineImplementation.id == null) {
      throw ArgumentError.notNull('shoebillTemplateBaselineImplementation.id');
    }

    var $shoebillTemplateBaselineImplementation =
        shoebillTemplateBaselineImplementation.copyWith(baselineId: null);
    await session.db.updateRow<_i4.ShoebillTemplateBaselineImplementation>(
      $shoebillTemplateBaselineImplementation,
      columns: [_i4.ShoebillTemplateBaselineImplementation.t.baselineId],
      transaction: transaction,
    );
  }
}
