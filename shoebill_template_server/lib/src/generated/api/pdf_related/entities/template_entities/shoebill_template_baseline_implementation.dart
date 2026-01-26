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
import '../../../../api/pdf_related/entities/template_entities/shoebill_template_baseline.dart'
    as _i3;
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i4;

abstract class ShoebillTemplateBaselineImplementation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ShoebillTemplateBaselineImplementation._({
    this.id,
    required this.stringifiedPayload,
    required this.language,
    DateTime? createdAt,
    required this.baselineId,
    this.baseline,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ShoebillTemplateBaselineImplementation({
    int? id,
    required String stringifiedPayload,
    required _i2.SupportedLanguage language,
    DateTime? createdAt,
    required _i1.UuidValue baselineId,
    _i3.ShoebillTemplateBaseline? baseline,
  }) = _ShoebillTemplateBaselineImplementationImpl;

  factory ShoebillTemplateBaselineImplementation.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ShoebillTemplateBaselineImplementation(
      id: jsonSerialization['id'] as int?,
      stringifiedPayload: jsonSerialization['stringifiedPayload'] as String,
      language: _i2.SupportedLanguage.fromJson(
        (jsonSerialization['language'] as String),
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      baselineId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['baselineId'],
      ),
      baseline: jsonSerialization['baseline'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.ShoebillTemplateBaseline>(
              jsonSerialization['baseline'],
            ),
    );
  }

  static final t = ShoebillTemplateBaselineImplementationTable();

  static const db = ShoebillTemplateBaselineImplementationRepository._();

  @override
  int? id;

  String stringifiedPayload;

  _i2.SupportedLanguage language;

  DateTime createdAt;

  _i1.UuidValue baselineId;

  _i3.ShoebillTemplateBaseline? baseline;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ShoebillTemplateBaselineImplementation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoebillTemplateBaselineImplementation copyWith({
    int? id,
    String? stringifiedPayload,
    _i2.SupportedLanguage? language,
    DateTime? createdAt,
    _i1.UuidValue? baselineId,
    _i3.ShoebillTemplateBaseline? baseline,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoebillTemplateBaselineImplementation',
      if (id != null) 'id': id,
      'stringifiedPayload': stringifiedPayload,
      'language': language.toJson(),
      'createdAt': createdAt.toJson(),
      'baselineId': baselineId.toJson(),
      if (baseline != null) 'baseline': baseline?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShoebillTemplateBaselineImplementation',
      if (id != null) 'id': id,
      'stringifiedPayload': stringifiedPayload,
      'language': language.toJson(),
      'createdAt': createdAt.toJson(),
      'baselineId': baselineId.toJson(),
      if (baseline != null) 'baseline': baseline?.toJsonForProtocol(),
    };
  }

  static ShoebillTemplateBaselineImplementationInclude include({
    _i3.ShoebillTemplateBaselineInclude? baseline,
  }) {
    return ShoebillTemplateBaselineImplementationInclude._(baseline: baseline);
  }

  static ShoebillTemplateBaselineImplementationIncludeList includeList({
    _i1.WhereExpressionBuilder<ShoebillTemplateBaselineImplementationTable>?
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateBaselineImplementationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateBaselineImplementationTable>?
    orderByList,
    ShoebillTemplateBaselineImplementationInclude? include,
  }) {
    return ShoebillTemplateBaselineImplementationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoebillTemplateBaselineImplementation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ShoebillTemplateBaselineImplementation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoebillTemplateBaselineImplementationImpl
    extends ShoebillTemplateBaselineImplementation {
  _ShoebillTemplateBaselineImplementationImpl({
    int? id,
    required String stringifiedPayload,
    required _i2.SupportedLanguage language,
    DateTime? createdAt,
    required _i1.UuidValue baselineId,
    _i3.ShoebillTemplateBaseline? baseline,
  }) : super._(
         id: id,
         stringifiedPayload: stringifiedPayload,
         language: language,
         createdAt: createdAt,
         baselineId: baselineId,
         baseline: baseline,
       );

  /// Returns a shallow copy of this [ShoebillTemplateBaselineImplementation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShoebillTemplateBaselineImplementation copyWith({
    Object? id = _Undefined,
    String? stringifiedPayload,
    _i2.SupportedLanguage? language,
    DateTime? createdAt,
    _i1.UuidValue? baselineId,
    Object? baseline = _Undefined,
  }) {
    return ShoebillTemplateBaselineImplementation(
      id: id is int? ? id : this.id,
      stringifiedPayload: stringifiedPayload ?? this.stringifiedPayload,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      baselineId: baselineId ?? this.baselineId,
      baseline: baseline is _i3.ShoebillTemplateBaseline?
          ? baseline
          : this.baseline?.copyWith(),
    );
  }
}

class ShoebillTemplateBaselineImplementationUpdateTable
    extends _i1.UpdateTable<ShoebillTemplateBaselineImplementationTable> {
  ShoebillTemplateBaselineImplementationUpdateTable(super.table);

  _i1.ColumnValue<String, String> stringifiedPayload(String value) =>
      _i1.ColumnValue(
        table.stringifiedPayload,
        value,
      );

  _i1.ColumnValue<_i2.SupportedLanguage, _i2.SupportedLanguage> language(
    _i2.SupportedLanguage value,
  ) => _i1.ColumnValue(
    table.language,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> baselineId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.baselineId,
    value,
  );
}

class ShoebillTemplateBaselineImplementationTable extends _i1.Table<int?> {
  ShoebillTemplateBaselineImplementationTable({super.tableRelation})
    : super(tableName: 'shoebill_template_baseline_implementations') {
    updateTable = ShoebillTemplateBaselineImplementationUpdateTable(this);
    stringifiedPayload = _i1.ColumnString(
      'stringifiedPayload',
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
    baselineId = _i1.ColumnUuid(
      'baselineId',
      this,
    );
  }

  late final ShoebillTemplateBaselineImplementationUpdateTable updateTable;

  late final _i1.ColumnString stringifiedPayload;

  late final _i1.ColumnEnum<_i2.SupportedLanguage> language;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnUuid baselineId;

  _i3.ShoebillTemplateBaselineTable? _baseline;

  _i3.ShoebillTemplateBaselineTable get baseline {
    if (_baseline != null) return _baseline!;
    _baseline = _i1.createRelationTable(
      relationFieldName: 'baseline',
      field: ShoebillTemplateBaselineImplementation.t.baselineId,
      foreignField: _i3.ShoebillTemplateBaseline.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _i3.ShoebillTemplateBaselineTable(
        tableRelation: foreignTableRelation,
      ),
    );
    return _baseline!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    stringifiedPayload,
    language,
    createdAt,
    baselineId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'baseline') {
      return baseline;
    }
    return null;
  }
}

class ShoebillTemplateBaselineImplementationInclude extends _i1.IncludeObject {
  ShoebillTemplateBaselineImplementationInclude._({
    _i3.ShoebillTemplateBaselineInclude? baseline,
  }) {
    _baseline = baseline;
  }

  _i3.ShoebillTemplateBaselineInclude? _baseline;

  @override
  Map<String, _i1.Include?> get includes => {'baseline': _baseline};

  @override
  _i1.Table<int?> get table => ShoebillTemplateBaselineImplementation.t;
}

class ShoebillTemplateBaselineImplementationIncludeList
    extends _i1.IncludeList {
  ShoebillTemplateBaselineImplementationIncludeList._({
    _i1.WhereExpressionBuilder<ShoebillTemplateBaselineImplementationTable>?
    where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ShoebillTemplateBaselineImplementation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ShoebillTemplateBaselineImplementation.t;
}

class ShoebillTemplateBaselineImplementationRepository {
  const ShoebillTemplateBaselineImplementationRepository._();

  final attachRow =
      const ShoebillTemplateBaselineImplementationAttachRowRepository._();

  /// Returns a list of [ShoebillTemplateBaselineImplementation]s matching the given query parameters.
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
  Future<List<ShoebillTemplateBaselineImplementation>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateBaselineImplementationTable>?
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateBaselineImplementationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateBaselineImplementationTable>?
    orderByList,
    _i1.Transaction? transaction,
    ShoebillTemplateBaselineImplementationInclude? include,
  }) async {
    return session.db.find<ShoebillTemplateBaselineImplementation>(
      where: where?.call(ShoebillTemplateBaselineImplementation.t),
      orderBy: orderBy?.call(ShoebillTemplateBaselineImplementation.t),
      orderByList: orderByList?.call(ShoebillTemplateBaselineImplementation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ShoebillTemplateBaselineImplementation] matching the given query parameters.
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
  Future<ShoebillTemplateBaselineImplementation?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateBaselineImplementationTable>?
    where,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateBaselineImplementationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateBaselineImplementationTable>?
    orderByList,
    _i1.Transaction? transaction,
    ShoebillTemplateBaselineImplementationInclude? include,
  }) async {
    return session.db.findFirstRow<ShoebillTemplateBaselineImplementation>(
      where: where?.call(ShoebillTemplateBaselineImplementation.t),
      orderBy: orderBy?.call(ShoebillTemplateBaselineImplementation.t),
      orderByList: orderByList?.call(ShoebillTemplateBaselineImplementation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ShoebillTemplateBaselineImplementation] by its [id] or null if no such row exists.
  Future<ShoebillTemplateBaselineImplementation?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ShoebillTemplateBaselineImplementationInclude? include,
  }) async {
    return session.db.findById<ShoebillTemplateBaselineImplementation>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ShoebillTemplateBaselineImplementation]s in the list and returns the inserted rows.
  ///
  /// The returned [ShoebillTemplateBaselineImplementation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ShoebillTemplateBaselineImplementation>> insert(
    _i1.Session session,
    List<ShoebillTemplateBaselineImplementation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ShoebillTemplateBaselineImplementation>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ShoebillTemplateBaselineImplementation] and returns the inserted row.
  ///
  /// The returned [ShoebillTemplateBaselineImplementation] will have its `id` field set.
  Future<ShoebillTemplateBaselineImplementation> insertRow(
    _i1.Session session,
    ShoebillTemplateBaselineImplementation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ShoebillTemplateBaselineImplementation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ShoebillTemplateBaselineImplementation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ShoebillTemplateBaselineImplementation>> update(
    _i1.Session session,
    List<ShoebillTemplateBaselineImplementation> rows, {
    _i1.ColumnSelections<ShoebillTemplateBaselineImplementationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ShoebillTemplateBaselineImplementation>(
      rows,
      columns: columns?.call(ShoebillTemplateBaselineImplementation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoebillTemplateBaselineImplementation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ShoebillTemplateBaselineImplementation> updateRow(
    _i1.Session session,
    ShoebillTemplateBaselineImplementation row, {
    _i1.ColumnSelections<ShoebillTemplateBaselineImplementationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ShoebillTemplateBaselineImplementation>(
      row,
      columns: columns?.call(ShoebillTemplateBaselineImplementation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoebillTemplateBaselineImplementation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ShoebillTemplateBaselineImplementation?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<
      ShoebillTemplateBaselineImplementationUpdateTable
    >
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ShoebillTemplateBaselineImplementation>(
      id,
      columnValues: columnValues(
        ShoebillTemplateBaselineImplementation.t.updateTable,
      ),
      transaction: transaction,
    );
  }

  /// Updates all [ShoebillTemplateBaselineImplementation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ShoebillTemplateBaselineImplementation>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<
      ShoebillTemplateBaselineImplementationUpdateTable
    >
    columnValues,
    required _i1.WhereExpressionBuilder<
      ShoebillTemplateBaselineImplementationTable
    >
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateBaselineImplementationTable>? orderBy,
    _i1.OrderByListBuilder<ShoebillTemplateBaselineImplementationTable>?
    orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ShoebillTemplateBaselineImplementation>(
      columnValues: columnValues(
        ShoebillTemplateBaselineImplementation.t.updateTable,
      ),
      where: where(ShoebillTemplateBaselineImplementation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoebillTemplateBaselineImplementation.t),
      orderByList: orderByList?.call(ShoebillTemplateBaselineImplementation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ShoebillTemplateBaselineImplementation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ShoebillTemplateBaselineImplementation>> delete(
    _i1.Session session,
    List<ShoebillTemplateBaselineImplementation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ShoebillTemplateBaselineImplementation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ShoebillTemplateBaselineImplementation].
  Future<ShoebillTemplateBaselineImplementation> deleteRow(
    _i1.Session session,
    ShoebillTemplateBaselineImplementation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ShoebillTemplateBaselineImplementation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ShoebillTemplateBaselineImplementation>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<
      ShoebillTemplateBaselineImplementationTable
    >
    where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ShoebillTemplateBaselineImplementation>(
      where: where(ShoebillTemplateBaselineImplementation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateBaselineImplementationTable>?
    where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ShoebillTemplateBaselineImplementation>(
      where: where?.call(ShoebillTemplateBaselineImplementation.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ShoebillTemplateBaselineImplementationAttachRowRepository {
  const ShoebillTemplateBaselineImplementationAttachRowRepository._();

  /// Creates a relation between the given [ShoebillTemplateBaselineImplementation] and [ShoebillTemplateBaseline]
  /// by setting the [ShoebillTemplateBaselineImplementation]'s foreign key `baselineId` to refer to the [ShoebillTemplateBaseline].
  Future<void> baseline(
    _i1.Session session,
    ShoebillTemplateBaselineImplementation
    shoebillTemplateBaselineImplementation,
    _i3.ShoebillTemplateBaseline baseline, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateBaselineImplementation.id == null) {
      throw ArgumentError.notNull('shoebillTemplateBaselineImplementation.id');
    }
    if (baseline.id == null) {
      throw ArgumentError.notNull('baseline.id');
    }

    var $shoebillTemplateBaselineImplementation =
        shoebillTemplateBaselineImplementation.copyWith(
          baselineId: baseline.id,
        );
    await session.db.updateRow<ShoebillTemplateBaselineImplementation>(
      $shoebillTemplateBaselineImplementation,
      columns: [ShoebillTemplateBaselineImplementation.t.baselineId],
      transaction: transaction,
    );
  }
}
