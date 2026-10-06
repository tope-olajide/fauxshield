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
import 'package:serverpod/serverpod.dart' as _is;

/// Postgres backed idempotency record. Create operations accept a client
/// supplied key and replay the stored response instead of duplicating work.
abstract class IdempotencyRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  IdempotencyRecord._({
    this.id,
    required this.workspaceId,
    required this.idempotencyKey,
    required this.operation,
    required this.requestHash,
    this.responseJson,
    this.statusCode,
    DateTime? createdAt,
    required this.expiresAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory IdempotencyRecord({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required String idempotencyKey,
    required String operation,
    required String requestHash,
    String? responseJson,
    int? statusCode,
    DateTime? createdAt,
    required DateTime expiresAt,
  }) = _IdempotencyRecordImpl;

  factory IdempotencyRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return IdempotencyRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      idempotencyKey: jsonSerialization['idempotencyKey'] as String,
      operation: jsonSerialization['operation'] as String,
      requestHash: jsonSerialization['requestHash'] as String,
      responseJson: jsonSerialization['responseJson'] as String?,
      statusCode: jsonSerialization['statusCode'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  static final t = IdempotencyRecordTable();

  static const db = IdempotencyRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  /// Composed key of workspace, operation, and caller supplied value.
  String idempotencyKey;

  String operation;

  String requestHash;

  String? responseJson;

  int? statusCode;

  DateTime createdAt;

  DateTime expiresAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [IdempotencyRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IdempotencyRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    String? idempotencyKey,
    String? operation,
    String? requestHash,
    String? responseJson,
    int? statusCode,
    DateTime? createdAt,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IdempotencyRecord',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'idempotencyKey': idempotencyKey,
      'operation': operation,
      'requestHash': requestHash,
      if (responseJson != null) 'responseJson': responseJson,
      if (statusCode != null) 'statusCode': statusCode,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IdempotencyRecord',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'idempotencyKey': idempotencyKey,
      'operation': operation,
      'requestHash': requestHash,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  static IdempotencyRecordInclude include() {
    return IdempotencyRecordInclude._();
  }

  static IdempotencyRecordIncludeList includeList({
    _is.WhereExpressionBuilder<IdempotencyRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IdempotencyRecordTable>? orderBy,
    _is.OrderByListBuilder<IdempotencyRecordTable>? orderByList,
    IdempotencyRecordInclude? include,
  }) {
    return IdempotencyRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IdempotencyRecord.t),
      orderByList: orderByList?.call(IdempotencyRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IdempotencyRecordImpl extends IdempotencyRecord {
  _IdempotencyRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required String idempotencyKey,
    required String operation,
    required String requestHash,
    String? responseJson,
    int? statusCode,
    DateTime? createdAt,
    required DateTime expiresAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         idempotencyKey: idempotencyKey,
         operation: operation,
         requestHash: requestHash,
         responseJson: responseJson,
         statusCode: statusCode,
         createdAt: createdAt,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [IdempotencyRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IdempotencyRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    String? idempotencyKey,
    String? operation,
    String? requestHash,
    Object? responseJson = _Undefined,
    Object? statusCode = _Undefined,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return IdempotencyRecord(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      operation: operation ?? this.operation,
      requestHash: requestHash ?? this.requestHash,
      responseJson: responseJson is String? ? responseJson : this.responseJson,
      statusCode: statusCode is int? ? statusCode : this.statusCode,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

class IdempotencyRecordUpdateTable
    extends _is.UpdateTable<IdempotencyRecordTable> {
  IdempotencyRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<String, String> idempotencyKey(String value) =>
      _is.ColumnValue(
        table.idempotencyKey,
        value,
      );

  _is.ColumnValue<String, String> operation(String value) => _is.ColumnValue(
    table.operation,
    value,
  );

  _is.ColumnValue<String, String> requestHash(String value) => _is.ColumnValue(
    table.requestHash,
    value,
  );

  _is.ColumnValue<String, String> responseJson(String? value) =>
      _is.ColumnValue(
        table.responseJson,
        value,
      );

  _is.ColumnValue<int, int> statusCode(int? value) => _is.ColumnValue(
    table.statusCode,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );
}

class IdempotencyRecordTable extends _is.Table<_is.UuidValue?> {
  IdempotencyRecordTable({super.tableRelation})
    : super(tableName: 'idempotency_record') {
    updateTable = IdempotencyRecordUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    idempotencyKey = _is.ColumnString(
      'idempotencyKey',
      this,
    );
    operation = _is.ColumnString(
      'operation',
      this,
    );
    requestHash = _is.ColumnString(
      'requestHash',
      this,
    );
    responseJson = _is.ColumnString(
      'responseJson',
      this,
    );
    statusCode = _is.ColumnInt(
      'statusCode',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
  }

  late final IdempotencyRecordUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  /// Composed key of workspace, operation, and caller supplied value.
  late final _is.ColumnString idempotencyKey;

  late final _is.ColumnString operation;

  late final _is.ColumnString requestHash;

  late final _is.ColumnString responseJson;

  late final _is.ColumnInt statusCode;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime expiresAt;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    idempotencyKey,
    operation,
    requestHash,
    responseJson,
    statusCode,
    createdAt,
    expiresAt,
  ];
}

class IdempotencyRecordInclude extends _is.IncludeObject {
  IdempotencyRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => IdempotencyRecord.t;
}

class IdempotencyRecordIncludeList extends _is.IncludeList {
  IdempotencyRecordIncludeList._({
    _is.WhereExpressionBuilder<IdempotencyRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IdempotencyRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => IdempotencyRecord.t;
}

class IdempotencyRecordRepository {
  const IdempotencyRecordRepository._();

  /// Returns a list of [IdempotencyRecord]s matching the given query parameters.
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
  Future<List<IdempotencyRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IdempotencyRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IdempotencyRecordTable>? orderBy,
    _is.OrderByListBuilder<IdempotencyRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<IdempotencyRecord>(
      where: where?.call(IdempotencyRecord.t),
      orderBy: orderBy?.call(IdempotencyRecord.t),
      orderByList: orderByList?.call(IdempotencyRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [IdempotencyRecord] matching the given query parameters.
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
  Future<IdempotencyRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IdempotencyRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<IdempotencyRecordTable>? orderBy,
    _is.OrderByListBuilder<IdempotencyRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<IdempotencyRecord>(
      where: where?.call(IdempotencyRecord.t),
      orderBy: orderBy?.call(IdempotencyRecord.t),
      orderByList: orderByList?.call(IdempotencyRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [IdempotencyRecord] by its [id] or null if no such row exists.
  Future<IdempotencyRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<IdempotencyRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [IdempotencyRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [IdempotencyRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IdempotencyRecord>> insert(
    _is.DatabaseSession session,
    List<IdempotencyRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<IdempotencyRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [IdempotencyRecord] and returns the inserted row.
  ///
  /// The returned [IdempotencyRecord] will have its `id` field set.
  Future<IdempotencyRecord> insertRow(
    _is.DatabaseSession session,
    IdempotencyRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<IdempotencyRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [IdempotencyRecord]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [IdempotencyRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IdempotencyRecord>> upsert(
    _is.DatabaseSession session,
    List<IdempotencyRecord> rows, {
    required _is.ColumnSelections<IdempotencyRecordTable> conflictColumns,
    _is.ColumnSelections<IdempotencyRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<IdempotencyRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<IdempotencyRecord>(
      rows,
      conflictColumns: conflictColumns(IdempotencyRecord.t),
      updateColumns: updateColumns?.call(IdempotencyRecord.t),
      updateWhere: updateWhere?.call(IdempotencyRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [IdempotencyRecord] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [IdempotencyRecord] will have its `id` field set.
  Future<IdempotencyRecord?> upsertRow(
    _is.DatabaseSession session,
    IdempotencyRecord row, {
    required _is.ColumnSelections<IdempotencyRecordTable> conflictColumns,
    _is.ColumnSelections<IdempotencyRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<IdempotencyRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<IdempotencyRecord>(
      row,
      conflictColumns: conflictColumns(IdempotencyRecord.t),
      updateColumns: updateColumns?.call(IdempotencyRecord.t),
      updateWhere: updateWhere?.call(IdempotencyRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [IdempotencyRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IdempotencyRecord>> update(
    _is.DatabaseSession session,
    List<IdempotencyRecord> rows, {
    _is.ColumnSelections<IdempotencyRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<IdempotencyRecord>(
      rows,
      columns: columns?.call(IdempotencyRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [IdempotencyRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IdempotencyRecord> updateRow(
    _is.DatabaseSession session,
    IdempotencyRecord row, {
    _is.ColumnSelections<IdempotencyRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<IdempotencyRecord>(
      row,
      columns: columns?.call(IdempotencyRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IdempotencyRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<IdempotencyRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<IdempotencyRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<IdempotencyRecord>(
      id,
      columnValues: columnValues(IdempotencyRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [IdempotencyRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IdempotencyRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<IdempotencyRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<IdempotencyRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IdempotencyRecordTable>? orderBy,
    _is.OrderByListBuilder<IdempotencyRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<IdempotencyRecord>(
      columnValues: columnValues(IdempotencyRecord.t.updateTable),
      where: where(IdempotencyRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IdempotencyRecord.t),
      orderByList: orderByList?.call(IdempotencyRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [IdempotencyRecord]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IdempotencyRecord>> delete(
    _is.DatabaseSession session,
    List<IdempotencyRecord> rows, {
    _is.OrderByBuilder<IdempotencyRecordTable>? orderBy,
    _is.OrderByListBuilder<IdempotencyRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<IdempotencyRecord>(
      rows,
      orderBy: orderBy?.call(IdempotencyRecord.t),
      orderByList: orderByList?.call(IdempotencyRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [IdempotencyRecord].
  Future<IdempotencyRecord> deleteRow(
    _is.DatabaseSession session,
    IdempotencyRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IdempotencyRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IdempotencyRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IdempotencyRecordTable> where,
    _is.OrderByBuilder<IdempotencyRecordTable>? orderBy,
    _is.OrderByListBuilder<IdempotencyRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<IdempotencyRecord>(
      where: where(IdempotencyRecord.t),
      orderBy: orderBy?.call(IdempotencyRecord.t),
      orderByList: orderByList?.call(IdempotencyRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IdempotencyRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<IdempotencyRecord>(
      where: where?.call(IdempotencyRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [IdempotencyRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IdempotencyRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<IdempotencyRecord>(
      where: where(IdempotencyRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
