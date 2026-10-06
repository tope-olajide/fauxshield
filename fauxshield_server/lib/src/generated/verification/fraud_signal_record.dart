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
import '../enums/risk_score.dart' as _ikrsd51m;
import '../enums/signal_type.dart' as _ihijuu0z;

/// One fraud signal produced by the fraud engine for a verification session.
/// Signals are immutable evidence and may be linked to alerts.
abstract class FraudSignalRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  FraudSignalRecord._({
    this.id,
    required this.workspaceId,
    required this.sessionId,
    required this.identityId,
    required this.batchId,
    required this.type,
    required this.severity,
    String? dataJson,
    DateTime? detectedAt,
  }) : dataJson = dataJson ?? '{}',
       detectedAt = detectedAt ?? DateTime.now();

  factory FraudSignalRecord({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required _is.UuidValue sessionId,
    required _is.UuidValue identityId,
    required _is.UuidValue batchId,
    required _ihijuu0z.SignalType type,
    required _ikrsd51m.RiskScore severity,
    String? dataJson,
    DateTime? detectedAt,
  }) = _FraudSignalRecordImpl;

  factory FraudSignalRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return FraudSignalRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      sessionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['sessionId'],
      ),
      identityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['identityId'],
      ),
      batchId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['batchId'],
      ),
      type: _ihijuu0z.SignalType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      severity: _ikrsd51m.RiskScore.fromJson(
        (jsonSerialization['severity'] as String),
      ),
      dataJson: jsonSerialization['dataJson'] as String?,
      detectedAt: jsonSerialization['detectedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['detectedAt']),
    );
  }

  static final t = FraudSignalRecordTable();

  static const db = FraudSignalRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  _is.UuidValue sessionId;

  /// Denormalized for fast batch level queries.
  _is.UuidValue identityId;

  _is.UuidValue batchId;

  _ihijuu0z.SignalType type;

  _ikrsd51m.RiskScore severity;

  /// Signal specific structured evidence serialized as JSON.
  String dataJson;

  DateTime detectedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [FraudSignalRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FraudSignalRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    _is.UuidValue? sessionId,
    _is.UuidValue? identityId,
    _is.UuidValue? batchId,
    _ihijuu0z.SignalType? type,
    _ikrsd51m.RiskScore? severity,
    String? dataJson,
    DateTime? detectedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FraudSignalRecord',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'sessionId': sessionId.toJson(),
      'identityId': identityId.toJson(),
      'batchId': batchId.toJson(),
      'type': type.toJson(),
      'severity': severity.toJson(),
      'dataJson': dataJson,
      'detectedAt': detectedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FraudSignalRecord',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'sessionId': sessionId.toJson(),
      'identityId': identityId.toJson(),
      'batchId': batchId.toJson(),
      'type': type.toJson(),
      'severity': severity.toJson(),
      'dataJson': dataJson,
      'detectedAt': detectedAt.toJson(),
    };
  }

  static FraudSignalRecordInclude include() {
    return FraudSignalRecordInclude._();
  }

  static FraudSignalRecordIncludeList includeList({
    _is.WhereExpressionBuilder<FraudSignalRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FraudSignalRecordTable>? orderBy,
    _is.OrderByListBuilder<FraudSignalRecordTable>? orderByList,
    FraudSignalRecordInclude? include,
  }) {
    return FraudSignalRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FraudSignalRecord.t),
      orderByList: orderByList?.call(FraudSignalRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FraudSignalRecordImpl extends FraudSignalRecord {
  _FraudSignalRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required _is.UuidValue sessionId,
    required _is.UuidValue identityId,
    required _is.UuidValue batchId,
    required _ihijuu0z.SignalType type,
    required _ikrsd51m.RiskScore severity,
    String? dataJson,
    DateTime? detectedAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         sessionId: sessionId,
         identityId: identityId,
         batchId: batchId,
         type: type,
         severity: severity,
         dataJson: dataJson,
         detectedAt: detectedAt,
       );

  /// Returns a shallow copy of this [FraudSignalRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FraudSignalRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    _is.UuidValue? sessionId,
    _is.UuidValue? identityId,
    _is.UuidValue? batchId,
    _ihijuu0z.SignalType? type,
    _ikrsd51m.RiskScore? severity,
    String? dataJson,
    DateTime? detectedAt,
  }) {
    return FraudSignalRecord(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      sessionId: sessionId ?? this.sessionId,
      identityId: identityId ?? this.identityId,
      batchId: batchId ?? this.batchId,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      dataJson: dataJson ?? this.dataJson,
      detectedAt: detectedAt ?? this.detectedAt,
    );
  }
}

class FraudSignalRecordUpdateTable
    extends _is.UpdateTable<FraudSignalRecordTable> {
  FraudSignalRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> sessionId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.sessionId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> identityId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.identityId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> batchId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.batchId,
        value,
      );

  _is.ColumnValue<_ihijuu0z.SignalType, _ihijuu0z.SignalType> type(
    _ihijuu0z.SignalType value,
  ) => _is.ColumnValue(
    table.type,
    value,
  );

  _is.ColumnValue<_ikrsd51m.RiskScore, _ikrsd51m.RiskScore> severity(
    _ikrsd51m.RiskScore value,
  ) => _is.ColumnValue(
    table.severity,
    value,
  );

  _is.ColumnValue<String, String> dataJson(String value) => _is.ColumnValue(
    table.dataJson,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> detectedAt(DateTime value) =>
      _is.ColumnValue(
        table.detectedAt,
        value,
      );
}

class FraudSignalRecordTable extends _is.Table<_is.UuidValue?> {
  FraudSignalRecordTable({super.tableRelation})
    : super(tableName: 'fraud_signal_record') {
    updateTable = FraudSignalRecordUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    sessionId = _is.ColumnUuid(
      'sessionId',
      this,
    );
    identityId = _is.ColumnUuid(
      'identityId',
      this,
    );
    batchId = _is.ColumnUuid(
      'batchId',
      this,
    );
    type = _is.ColumnEnum(
      'type',
      this,
      _is.EnumSerialization.byName,
    );
    severity = _is.ColumnEnum(
      'severity',
      this,
      _is.EnumSerialization.byName,
    );
    dataJson = _is.ColumnString(
      'dataJson',
      this,
      hasDefault: true,
    );
    detectedAt = _is.ColumnDateTime(
      'detectedAt',
      this,
      hasDefault: true,
    );
  }

  late final FraudSignalRecordUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  late final _is.ColumnUuid sessionId;

  /// Denormalized for fast batch level queries.
  late final _is.ColumnUuid identityId;

  late final _is.ColumnUuid batchId;

  late final _is.ColumnEnum<_ihijuu0z.SignalType> type;

  late final _is.ColumnEnum<_ikrsd51m.RiskScore> severity;

  /// Signal specific structured evidence serialized as JSON.
  late final _is.ColumnString dataJson;

  late final _is.ColumnDateTime detectedAt;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    sessionId,
    identityId,
    batchId,
    type,
    severity,
    dataJson,
    detectedAt,
  ];
}

class FraudSignalRecordInclude extends _is.IncludeObject {
  FraudSignalRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => FraudSignalRecord.t;
}

class FraudSignalRecordIncludeList extends _is.IncludeList {
  FraudSignalRecordIncludeList._({
    _is.WhereExpressionBuilder<FraudSignalRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FraudSignalRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => FraudSignalRecord.t;
}

class FraudSignalRecordRepository {
  const FraudSignalRecordRepository._();

  /// Returns a list of [FraudSignalRecord]s matching the given query parameters.
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
  Future<List<FraudSignalRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FraudSignalRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FraudSignalRecordTable>? orderBy,
    _is.OrderByListBuilder<FraudSignalRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FraudSignalRecord>(
      where: where?.call(FraudSignalRecord.t),
      orderBy: orderBy?.call(FraudSignalRecord.t),
      orderByList: orderByList?.call(FraudSignalRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FraudSignalRecord] matching the given query parameters.
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
  Future<FraudSignalRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FraudSignalRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<FraudSignalRecordTable>? orderBy,
    _is.OrderByListBuilder<FraudSignalRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FraudSignalRecord>(
      where: where?.call(FraudSignalRecord.t),
      orderBy: orderBy?.call(FraudSignalRecord.t),
      orderByList: orderByList?.call(FraudSignalRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FraudSignalRecord] by its [id] or null if no such row exists.
  Future<FraudSignalRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FraudSignalRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FraudSignalRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [FraudSignalRecord]s will have their `id` fields set.
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
  Future<List<FraudSignalRecord>> insert(
    _is.DatabaseSession session,
    List<FraudSignalRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FraudSignalRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FraudSignalRecord] and returns the inserted row.
  ///
  /// The returned [FraudSignalRecord] will have its `id` field set.
  Future<FraudSignalRecord> insertRow(
    _is.DatabaseSession session,
    FraudSignalRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FraudSignalRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FraudSignalRecord]s in the list and returns the resulting rows.
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
  /// The returned [FraudSignalRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FraudSignalRecord>> upsert(
    _is.DatabaseSession session,
    List<FraudSignalRecord> rows, {
    required _is.ColumnSelections<FraudSignalRecordTable> conflictColumns,
    _is.ColumnSelections<FraudSignalRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<FraudSignalRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FraudSignalRecord>(
      rows,
      conflictColumns: conflictColumns(FraudSignalRecord.t),
      updateColumns: updateColumns?.call(FraudSignalRecord.t),
      updateWhere: updateWhere?.call(FraudSignalRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FraudSignalRecord] and returns the resulting row.
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
  /// The returned [FraudSignalRecord] will have its `id` field set.
  Future<FraudSignalRecord?> upsertRow(
    _is.DatabaseSession session,
    FraudSignalRecord row, {
    required _is.ColumnSelections<FraudSignalRecordTable> conflictColumns,
    _is.ColumnSelections<FraudSignalRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<FraudSignalRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FraudSignalRecord>(
      row,
      conflictColumns: conflictColumns(FraudSignalRecord.t),
      updateColumns: updateColumns?.call(FraudSignalRecord.t),
      updateWhere: updateWhere?.call(FraudSignalRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [FraudSignalRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FraudSignalRecord>> update(
    _is.DatabaseSession session,
    List<FraudSignalRecord> rows, {
    _is.ColumnSelections<FraudSignalRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FraudSignalRecord>(
      rows,
      columns: columns?.call(FraudSignalRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FraudSignalRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FraudSignalRecord> updateRow(
    _is.DatabaseSession session,
    FraudSignalRecord row, {
    _is.ColumnSelections<FraudSignalRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FraudSignalRecord>(
      row,
      columns: columns?.call(FraudSignalRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FraudSignalRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FraudSignalRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<FraudSignalRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FraudSignalRecord>(
      id,
      columnValues: columnValues(FraudSignalRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FraudSignalRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FraudSignalRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FraudSignalRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<FraudSignalRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FraudSignalRecordTable>? orderBy,
    _is.OrderByListBuilder<FraudSignalRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FraudSignalRecord>(
      columnValues: columnValues(FraudSignalRecord.t.updateTable),
      where: where(FraudSignalRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FraudSignalRecord.t),
      orderByList: orderByList?.call(FraudSignalRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FraudSignalRecord]s in the list and returns the deleted rows.
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
  Future<List<FraudSignalRecord>> delete(
    _is.DatabaseSession session,
    List<FraudSignalRecord> rows, {
    _is.OrderByBuilder<FraudSignalRecordTable>? orderBy,
    _is.OrderByListBuilder<FraudSignalRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FraudSignalRecord>(
      rows,
      orderBy: orderBy?.call(FraudSignalRecord.t),
      orderByList: orderByList?.call(FraudSignalRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FraudSignalRecord].
  Future<FraudSignalRecord> deleteRow(
    _is.DatabaseSession session,
    FraudSignalRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FraudSignalRecord>(
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
  Future<List<FraudSignalRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FraudSignalRecordTable> where,
    _is.OrderByBuilder<FraudSignalRecordTable>? orderBy,
    _is.OrderByListBuilder<FraudSignalRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FraudSignalRecord>(
      where: where(FraudSignalRecord.t),
      orderBy: orderBy?.call(FraudSignalRecord.t),
      orderByList: orderByList?.call(FraudSignalRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FraudSignalRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FraudSignalRecord>(
      where: where?.call(FraudSignalRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FraudSignalRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FraudSignalRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FraudSignalRecord>(
      where: where(FraudSignalRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
