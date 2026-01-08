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
import '../../../api/pdf_related/entities/schemas_implementations/schema_property.dart'
    as _i2;
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i3;

abstract class SchemaDefinition
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SchemaDefinition._({
    this.id,
    required this.properties,
  });

  factory SchemaDefinition({
    int? id,
    required Map<String, _i2.SchemaProperty> properties,
  }) = _SchemaDefinitionImpl;

  factory SchemaDefinition.fromJson(Map<String, dynamic> jsonSerialization) {
    return SchemaDefinition(
      id: jsonSerialization['id'] as int?,
      properties: _i3.Protocol().deserialize<Map<String, _i2.SchemaProperty>>(
        jsonSerialization['properties'],
      ),
    );
  }

  static final t = SchemaDefinitionTable();

  static const db = SchemaDefinitionRepository._();

  @override
  int? id;

  Map<String, _i2.SchemaProperty> properties;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SchemaDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SchemaDefinition copyWith({
    int? id,
    Map<String, _i2.SchemaProperty>? properties,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SchemaDefinition',
      if (id != null) 'id': id,
      'properties': properties.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SchemaDefinition',
      if (id != null) 'id': id,
      'properties': properties.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  static SchemaDefinitionInclude include() {
    return SchemaDefinitionInclude._();
  }

  static SchemaDefinitionIncludeList includeList({
    _i1.WhereExpressionBuilder<SchemaDefinitionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SchemaDefinitionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SchemaDefinitionTable>? orderByList,
    SchemaDefinitionInclude? include,
  }) {
    return SchemaDefinitionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SchemaDefinition.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SchemaDefinition.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SchemaDefinitionImpl extends SchemaDefinition {
  _SchemaDefinitionImpl({
    int? id,
    required Map<String, _i2.SchemaProperty> properties,
  }) : super._(
         id: id,
         properties: properties,
       );

  /// Returns a shallow copy of this [SchemaDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SchemaDefinition copyWith({
    Object? id = _Undefined,
    Map<String, _i2.SchemaProperty>? properties,
  }) {
    return SchemaDefinition(
      id: id is int? ? id : this.id,
      properties:
          properties ??
          this.properties.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0.copyWith(),
            ),
          ),
    );
  }
}

class SchemaDefinitionUpdateTable
    extends _i1.UpdateTable<SchemaDefinitionTable> {
  SchemaDefinitionUpdateTable(super.table);

  _i1.ColumnValue<
    Map<String, _i2.SchemaProperty>,
    Map<String, _i2.SchemaProperty>
  >
  properties(Map<String, _i2.SchemaProperty> value) => _i1.ColumnValue(
    table.properties,
    value,
  );
}

class SchemaDefinitionTable extends _i1.Table<int?> {
  SchemaDefinitionTable({super.tableRelation})
    : super(tableName: 'schema_definitions') {
    updateTable = SchemaDefinitionUpdateTable(this);
    properties = _i1.ColumnSerializable<Map<String, _i2.SchemaProperty>>(
      'properties',
      this,
    );
  }

  late final SchemaDefinitionUpdateTable updateTable;

  late final _i1.ColumnSerializable<Map<String, _i2.SchemaProperty>> properties;

  @override
  List<_i1.Column> get columns => [
    id,
    properties,
  ];
}

class SchemaDefinitionInclude extends _i1.IncludeObject {
  SchemaDefinitionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SchemaDefinition.t;
}

class SchemaDefinitionIncludeList extends _i1.IncludeList {
  SchemaDefinitionIncludeList._({
    _i1.WhereExpressionBuilder<SchemaDefinitionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SchemaDefinition.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SchemaDefinition.t;
}

class SchemaDefinitionRepository {
  const SchemaDefinitionRepository._();

  /// Returns a list of [SchemaDefinition]s matching the given query parameters.
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
  Future<List<SchemaDefinition>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SchemaDefinitionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SchemaDefinitionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SchemaDefinitionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SchemaDefinition>(
      where: where?.call(SchemaDefinition.t),
      orderBy: orderBy?.call(SchemaDefinition.t),
      orderByList: orderByList?.call(SchemaDefinition.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [SchemaDefinition] matching the given query parameters.
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
  Future<SchemaDefinition?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SchemaDefinitionTable>? where,
    int? offset,
    _i1.OrderByBuilder<SchemaDefinitionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SchemaDefinitionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SchemaDefinition>(
      where: where?.call(SchemaDefinition.t),
      orderBy: orderBy?.call(SchemaDefinition.t),
      orderByList: orderByList?.call(SchemaDefinition.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [SchemaDefinition] by its [id] or null if no such row exists.
  Future<SchemaDefinition?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SchemaDefinition>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [SchemaDefinition]s in the list and returns the inserted rows.
  ///
  /// The returned [SchemaDefinition]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SchemaDefinition>> insert(
    _i1.Session session,
    List<SchemaDefinition> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SchemaDefinition>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SchemaDefinition] and returns the inserted row.
  ///
  /// The returned [SchemaDefinition] will have its `id` field set.
  Future<SchemaDefinition> insertRow(
    _i1.Session session,
    SchemaDefinition row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SchemaDefinition>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SchemaDefinition]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SchemaDefinition>> update(
    _i1.Session session,
    List<SchemaDefinition> rows, {
    _i1.ColumnSelections<SchemaDefinitionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SchemaDefinition>(
      rows,
      columns: columns?.call(SchemaDefinition.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SchemaDefinition]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SchemaDefinition> updateRow(
    _i1.Session session,
    SchemaDefinition row, {
    _i1.ColumnSelections<SchemaDefinitionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SchemaDefinition>(
      row,
      columns: columns?.call(SchemaDefinition.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SchemaDefinition] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SchemaDefinition?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<SchemaDefinitionUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SchemaDefinition>(
      id,
      columnValues: columnValues(SchemaDefinition.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SchemaDefinition]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SchemaDefinition>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SchemaDefinitionUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<SchemaDefinitionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SchemaDefinitionTable>? orderBy,
    _i1.OrderByListBuilder<SchemaDefinitionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SchemaDefinition>(
      columnValues: columnValues(SchemaDefinition.t.updateTable),
      where: where(SchemaDefinition.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SchemaDefinition.t),
      orderByList: orderByList?.call(SchemaDefinition.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SchemaDefinition]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SchemaDefinition>> delete(
    _i1.Session session,
    List<SchemaDefinition> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SchemaDefinition>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SchemaDefinition].
  Future<SchemaDefinition> deleteRow(
    _i1.Session session,
    SchemaDefinition row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SchemaDefinition>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SchemaDefinition>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SchemaDefinitionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SchemaDefinition>(
      where: where(SchemaDefinition.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SchemaDefinitionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SchemaDefinition>(
      where: where?.call(SchemaDefinition.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
