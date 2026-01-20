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
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i4;

abstract class ShoebillTemplateVersionImplementation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ShoebillTemplateVersionImplementation._({
    this.id,
    required this.stringifiedPayload,
    required this.language,
    DateTime? createdAt,
    required this.versionId,
    this.version,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ShoebillTemplateVersionImplementation({
    int? id,
    required String stringifiedPayload,
    required _i2.SupportedLanguages language,
    DateTime? createdAt,
    required int versionId,
    _i3.ShoebillTemplateVersion? version,
  }) = _ShoebillTemplateVersionImplementationImpl;

  factory ShoebillTemplateVersionImplementation.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ShoebillTemplateVersionImplementation(
      id: jsonSerialization['id'] as int?,
      stringifiedPayload: jsonSerialization['stringifiedPayload'] as String,
      language: _i2.SupportedLanguages.fromJson(
        (jsonSerialization['language'] as String),
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      versionId: jsonSerialization['versionId'] as int,
      version: jsonSerialization['version'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.ShoebillTemplateVersion>(
              jsonSerialization['version'],
            ),
    );
  }

  static final t = ShoebillTemplateVersionImplementationTable();

  static const db = ShoebillTemplateVersionImplementationRepository._();

  @override
  int? id;

  String stringifiedPayload;

  _i2.SupportedLanguages language;

  DateTime createdAt;

  int versionId;

  _i3.ShoebillTemplateVersion? version;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ShoebillTemplateVersionImplementation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoebillTemplateVersionImplementation copyWith({
    int? id,
    String? stringifiedPayload,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
    int? versionId,
    _i3.ShoebillTemplateVersion? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoebillTemplateVersionImplementation',
      if (id != null) 'id': id,
      'stringifiedPayload': stringifiedPayload,
      'language': language.toJson(),
      'createdAt': createdAt.toJson(),
      'versionId': versionId,
      if (version != null) 'version': version?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShoebillTemplateVersionImplementation',
      if (id != null) 'id': id,
      'stringifiedPayload': stringifiedPayload,
      'language': language.toJson(),
      'createdAt': createdAt.toJson(),
      'versionId': versionId,
      if (version != null) 'version': version?.toJsonForProtocol(),
    };
  }

  static ShoebillTemplateVersionImplementationInclude include({
    _i3.ShoebillTemplateVersionInclude? version,
  }) {
    return ShoebillTemplateVersionImplementationInclude._(version: version);
  }

  static ShoebillTemplateVersionImplementationIncludeList includeList({
    _i1.WhereExpressionBuilder<ShoebillTemplateVersionImplementationTable>?
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateVersionImplementationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateVersionImplementationTable>?
    orderByList,
    ShoebillTemplateVersionImplementationInclude? include,
  }) {
    return ShoebillTemplateVersionImplementationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoebillTemplateVersionImplementation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ShoebillTemplateVersionImplementation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoebillTemplateVersionImplementationImpl
    extends ShoebillTemplateVersionImplementation {
  _ShoebillTemplateVersionImplementationImpl({
    int? id,
    required String stringifiedPayload,
    required _i2.SupportedLanguages language,
    DateTime? createdAt,
    required int versionId,
    _i3.ShoebillTemplateVersion? version,
  }) : super._(
         id: id,
         stringifiedPayload: stringifiedPayload,
         language: language,
         createdAt: createdAt,
         versionId: versionId,
         version: version,
       );

  /// Returns a shallow copy of this [ShoebillTemplateVersionImplementation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShoebillTemplateVersionImplementation copyWith({
    Object? id = _Undefined,
    String? stringifiedPayload,
    _i2.SupportedLanguages? language,
    DateTime? createdAt,
    int? versionId,
    Object? version = _Undefined,
  }) {
    return ShoebillTemplateVersionImplementation(
      id: id is int? ? id : this.id,
      stringifiedPayload: stringifiedPayload ?? this.stringifiedPayload,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      versionId: versionId ?? this.versionId,
      version: version is _i3.ShoebillTemplateVersion?
          ? version
          : this.version?.copyWith(),
    );
  }
}

class ShoebillTemplateVersionImplementationUpdateTable
    extends _i1.UpdateTable<ShoebillTemplateVersionImplementationTable> {
  ShoebillTemplateVersionImplementationUpdateTable(super.table);

  _i1.ColumnValue<String, String> stringifiedPayload(String value) =>
      _i1.ColumnValue(
        table.stringifiedPayload,
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

  _i1.ColumnValue<int, int> versionId(int value) => _i1.ColumnValue(
    table.versionId,
    value,
  );
}

class ShoebillTemplateVersionImplementationTable extends _i1.Table<int?> {
  ShoebillTemplateVersionImplementationTable({super.tableRelation})
    : super(tableName: 'shoebill_template_version_implementations') {
    updateTable = ShoebillTemplateVersionImplementationUpdateTable(this);
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
    versionId = _i1.ColumnInt(
      'versionId',
      this,
    );
  }

  late final ShoebillTemplateVersionImplementationUpdateTable updateTable;

  late final _i1.ColumnString stringifiedPayload;

  late final _i1.ColumnEnum<_i2.SupportedLanguages> language;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnInt versionId;

  _i3.ShoebillTemplateVersionTable? _version;

  _i3.ShoebillTemplateVersionTable get version {
    if (_version != null) return _version!;
    _version = _i1.createRelationTable(
      relationFieldName: 'version',
      field: ShoebillTemplateVersionImplementation.t.versionId,
      foreignField: _i3.ShoebillTemplateVersion.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ShoebillTemplateVersionTable(tableRelation: foreignTableRelation),
    );
    return _version!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    stringifiedPayload,
    language,
    createdAt,
    versionId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'version') {
      return version;
    }
    return null;
  }
}

class ShoebillTemplateVersionImplementationInclude extends _i1.IncludeObject {
  ShoebillTemplateVersionImplementationInclude._({
    _i3.ShoebillTemplateVersionInclude? version,
  }) {
    _version = version;
  }

  _i3.ShoebillTemplateVersionInclude? _version;

  @override
  Map<String, _i1.Include?> get includes => {'version': _version};

  @override
  _i1.Table<int?> get table => ShoebillTemplateVersionImplementation.t;
}

class ShoebillTemplateVersionImplementationIncludeList extends _i1.IncludeList {
  ShoebillTemplateVersionImplementationIncludeList._({
    _i1.WhereExpressionBuilder<ShoebillTemplateVersionImplementationTable>?
    where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ShoebillTemplateVersionImplementation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ShoebillTemplateVersionImplementation.t;
}

class ShoebillTemplateVersionImplementationRepository {
  const ShoebillTemplateVersionImplementationRepository._();

  final attachRow =
      const ShoebillTemplateVersionImplementationAttachRowRepository._();

  /// Returns a list of [ShoebillTemplateVersionImplementation]s matching the given query parameters.
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
  Future<List<ShoebillTemplateVersionImplementation>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateVersionImplementationTable>?
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateVersionImplementationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateVersionImplementationTable>?
    orderByList,
    _i1.Transaction? transaction,
    ShoebillTemplateVersionImplementationInclude? include,
  }) async {
    return session.db.find<ShoebillTemplateVersionImplementation>(
      where: where?.call(ShoebillTemplateVersionImplementation.t),
      orderBy: orderBy?.call(ShoebillTemplateVersionImplementation.t),
      orderByList: orderByList?.call(ShoebillTemplateVersionImplementation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ShoebillTemplateVersionImplementation] matching the given query parameters.
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
  Future<ShoebillTemplateVersionImplementation?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateVersionImplementationTable>?
    where,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateVersionImplementationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoebillTemplateVersionImplementationTable>?
    orderByList,
    _i1.Transaction? transaction,
    ShoebillTemplateVersionImplementationInclude? include,
  }) async {
    return session.db.findFirstRow<ShoebillTemplateVersionImplementation>(
      where: where?.call(ShoebillTemplateVersionImplementation.t),
      orderBy: orderBy?.call(ShoebillTemplateVersionImplementation.t),
      orderByList: orderByList?.call(ShoebillTemplateVersionImplementation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ShoebillTemplateVersionImplementation] by its [id] or null if no such row exists.
  Future<ShoebillTemplateVersionImplementation?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ShoebillTemplateVersionImplementationInclude? include,
  }) async {
    return session.db.findById<ShoebillTemplateVersionImplementation>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ShoebillTemplateVersionImplementation]s in the list and returns the inserted rows.
  ///
  /// The returned [ShoebillTemplateVersionImplementation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ShoebillTemplateVersionImplementation>> insert(
    _i1.Session session,
    List<ShoebillTemplateVersionImplementation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ShoebillTemplateVersionImplementation>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ShoebillTemplateVersionImplementation] and returns the inserted row.
  ///
  /// The returned [ShoebillTemplateVersionImplementation] will have its `id` field set.
  Future<ShoebillTemplateVersionImplementation> insertRow(
    _i1.Session session,
    ShoebillTemplateVersionImplementation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ShoebillTemplateVersionImplementation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ShoebillTemplateVersionImplementation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ShoebillTemplateVersionImplementation>> update(
    _i1.Session session,
    List<ShoebillTemplateVersionImplementation> rows, {
    _i1.ColumnSelections<ShoebillTemplateVersionImplementationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ShoebillTemplateVersionImplementation>(
      rows,
      columns: columns?.call(ShoebillTemplateVersionImplementation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoebillTemplateVersionImplementation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ShoebillTemplateVersionImplementation> updateRow(
    _i1.Session session,
    ShoebillTemplateVersionImplementation row, {
    _i1.ColumnSelections<ShoebillTemplateVersionImplementationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ShoebillTemplateVersionImplementation>(
      row,
      columns: columns?.call(ShoebillTemplateVersionImplementation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoebillTemplateVersionImplementation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ShoebillTemplateVersionImplementation?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<
      ShoebillTemplateVersionImplementationUpdateTable
    >
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ShoebillTemplateVersionImplementation>(
      id,
      columnValues: columnValues(
        ShoebillTemplateVersionImplementation.t.updateTable,
      ),
      transaction: transaction,
    );
  }

  /// Updates all [ShoebillTemplateVersionImplementation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ShoebillTemplateVersionImplementation>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<
      ShoebillTemplateVersionImplementationUpdateTable
    >
    columnValues,
    required _i1.WhereExpressionBuilder<
      ShoebillTemplateVersionImplementationTable
    >
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoebillTemplateVersionImplementationTable>? orderBy,
    _i1.OrderByListBuilder<ShoebillTemplateVersionImplementationTable>?
    orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ShoebillTemplateVersionImplementation>(
      columnValues: columnValues(
        ShoebillTemplateVersionImplementation.t.updateTable,
      ),
      where: where(ShoebillTemplateVersionImplementation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoebillTemplateVersionImplementation.t),
      orderByList: orderByList?.call(ShoebillTemplateVersionImplementation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ShoebillTemplateVersionImplementation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ShoebillTemplateVersionImplementation>> delete(
    _i1.Session session,
    List<ShoebillTemplateVersionImplementation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ShoebillTemplateVersionImplementation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ShoebillTemplateVersionImplementation].
  Future<ShoebillTemplateVersionImplementation> deleteRow(
    _i1.Session session,
    ShoebillTemplateVersionImplementation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ShoebillTemplateVersionImplementation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ShoebillTemplateVersionImplementation>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<
      ShoebillTemplateVersionImplementationTable
    >
    where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ShoebillTemplateVersionImplementation>(
      where: where(ShoebillTemplateVersionImplementation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoebillTemplateVersionImplementationTable>?
    where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ShoebillTemplateVersionImplementation>(
      where: where?.call(ShoebillTemplateVersionImplementation.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ShoebillTemplateVersionImplementationAttachRowRepository {
  const ShoebillTemplateVersionImplementationAttachRowRepository._();

  /// Creates a relation between the given [ShoebillTemplateVersionImplementation] and [ShoebillTemplateVersion]
  /// by setting the [ShoebillTemplateVersionImplementation]'s foreign key `versionId` to refer to the [ShoebillTemplateVersion].
  Future<void> version(
    _i1.Session session,
    ShoebillTemplateVersionImplementation shoebillTemplateVersionImplementation,
    _i3.ShoebillTemplateVersion version, {
    _i1.Transaction? transaction,
  }) async {
    if (shoebillTemplateVersionImplementation.id == null) {
      throw ArgumentError.notNull('shoebillTemplateVersionImplementation.id');
    }
    if (version.id == null) {
      throw ArgumentError.notNull('version.id');
    }

    var $shoebillTemplateVersionImplementation =
        shoebillTemplateVersionImplementation.copyWith(versionId: version.id);
    await session.db.updateRow<ShoebillTemplateVersionImplementation>(
      $shoebillTemplateVersionImplementation,
      columns: [ShoebillTemplateVersionImplementation.t.versionId],
      transaction: transaction,
    );
  }
}
