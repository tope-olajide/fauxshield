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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;

/// A fake product report queued on the device while offline and sent when
/// connectivity returns.
abstract class QueuedFakeReport
    implements _isd.TableRow<_isc.UuidValue?>, _isc.ProtocolSerialization {
  QueuedFakeReport._({
    this.id,
    required this.identityId,
    required this.qrToken,
    required this.reason,
    this.comment,
    this.photoLocalPath,
    DateTime? createdAt,
    bool? synced,
    this.syncedAt,
    this.lastError,
  }) : createdAt = createdAt ?? DateTime.now(),
       synced = synced ?? false;

  factory QueuedFakeReport({
    _isc.UuidValue? id,
    required _isc.UuidValue identityId,
    required String qrToken,
    required String reason,
    String? comment,
    String? photoLocalPath,
    DateTime? createdAt,
    bool? synced,
    DateTime? syncedAt,
    String? lastError,
  }) = _QueuedFakeReportImpl;

  factory QueuedFakeReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return QueuedFakeReport(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      identityId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['identityId'],
      ),
      qrToken: jsonSerialization['qrToken'] as String,
      reason: jsonSerialization['reason'] as String,
      comment: jsonSerialization['comment'] as String?,
      photoLocalPath: jsonSerialization['photoLocalPath'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      synced: jsonSerialization['synced'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['synced']),
      syncedAt: jsonSerialization['syncedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['syncedAt']),
      lastError: jsonSerialization['lastError'] as String?,
    );
  }

  static final t = QueuedFakeReportTable();

  static const db = QueuedFakeReportRepository._();

  @override
  _isc.UuidValue? id;

  _isc.UuidValue identityId;

  String qrToken;

  String reason;

  String? comment;

  String? photoLocalPath;

  DateTime createdAt;

  bool synced;

  DateTime? syncedAt;

  String? lastError;

  @override
  _isd.Table<_isc.UuidValue?> get table => t;

  /// Returns a shallow copy of this [QueuedFakeReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  QueuedFakeReport copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? identityId,
    String? qrToken,
    String? reason,
    String? comment,
    String? photoLocalPath,
    DateTime? createdAt,
    bool? synced,
    DateTime? syncedAt,
    String? lastError,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QueuedFakeReport',
      if (id != null) 'id': id?.toJson(),
      'identityId': identityId.toJson(),
      'qrToken': qrToken,
      'reason': reason,
      if (comment != null) 'comment': comment,
      if (photoLocalPath != null) 'photoLocalPath': photoLocalPath,
      'createdAt': createdAt.toJson(),
      'synced': synced,
      if (syncedAt != null) 'syncedAt': syncedAt?.toJson(),
      if (lastError != null) 'lastError': lastError,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QueuedFakeReport',
      if (id != null) 'id': id?.toJson(),
      'identityId': identityId.toJson(),
      'qrToken': qrToken,
      'reason': reason,
      if (comment != null) 'comment': comment,
      if (photoLocalPath != null) 'photoLocalPath': photoLocalPath,
      'createdAt': createdAt.toJson(),
      'synced': synced,
      if (syncedAt != null) 'syncedAt': syncedAt?.toJson(),
      if (lastError != null) 'lastError': lastError,
    };
  }

  static QueuedFakeReportInclude include() {
    return QueuedFakeReportInclude._();
  }

  static QueuedFakeReportIncludeList includeList({
    _isd.WhereExpressionBuilder<QueuedFakeReportTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<QueuedFakeReportTable>? orderBy,
    _isd.OrderByListBuilder<QueuedFakeReportTable>? orderByList,
    QueuedFakeReportInclude? include,
  }) {
    return QueuedFakeReportIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(QueuedFakeReport.t),
      orderByList: orderByList?.call(QueuedFakeReport.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QueuedFakeReportImpl extends QueuedFakeReport {
  _QueuedFakeReportImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue identityId,
    required String qrToken,
    required String reason,
    String? comment,
    String? photoLocalPath,
    DateTime? createdAt,
    bool? synced,
    DateTime? syncedAt,
    String? lastError,
  }) : super._(
         id: id,
         identityId: identityId,
         qrToken: qrToken,
         reason: reason,
         comment: comment,
         photoLocalPath: photoLocalPath,
         createdAt: createdAt,
         synced: synced,
         syncedAt: syncedAt,
         lastError: lastError,
       );

  /// Returns a shallow copy of this [QueuedFakeReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  QueuedFakeReport copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? identityId,
    String? qrToken,
    String? reason,
    Object? comment = _Undefined,
    Object? photoLocalPath = _Undefined,
    DateTime? createdAt,
    bool? synced,
    Object? syncedAt = _Undefined,
    Object? lastError = _Undefined,
  }) {
    return QueuedFakeReport(
      id: id is _isc.UuidValue? ? id : this.id,
      identityId: identityId ?? this.identityId,
      qrToken: qrToken ?? this.qrToken,
      reason: reason ?? this.reason,
      comment: comment is String? ? comment : this.comment,
      photoLocalPath: photoLocalPath is String?
          ? photoLocalPath
          : this.photoLocalPath,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
      syncedAt: syncedAt is DateTime? ? syncedAt : this.syncedAt,
      lastError: lastError is String? ? lastError : this.lastError,
    );
  }
}

class QueuedFakeReportUpdateTable
    extends _isd.UpdateTable<QueuedFakeReportTable> {
  QueuedFakeReportUpdateTable(super.table);

  _isd.ColumnValue<_isc.UuidValue, _isc.UuidValue> identityId(
    _isc.UuidValue value,
  ) => _isd.ColumnValue(
    table.identityId,
    value,
  );

  _isd.ColumnValue<String, String> qrToken(String value) => _isd.ColumnValue(
    table.qrToken,
    value,
  );

  _isd.ColumnValue<String, String> reason(String value) => _isd.ColumnValue(
    table.reason,
    value,
  );

  _isd.ColumnValue<String, String> comment(String? value) => _isd.ColumnValue(
    table.comment,
    value,
  );

  _isd.ColumnValue<String, String> photoLocalPath(String? value) =>
      _isd.ColumnValue(
        table.photoLocalPath,
        value,
      );

  _isd.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _isd.ColumnValue(
        table.createdAt,
        value,
      );

  _isd.ColumnValue<bool, bool> synced(bool value) => _isd.ColumnValue(
    table.synced,
    value,
  );

  _isd.ColumnValue<DateTime, DateTime> syncedAt(DateTime? value) =>
      _isd.ColumnValue(
        table.syncedAt,
        value,
      );

  _isd.ColumnValue<String, String> lastError(String? value) => _isd.ColumnValue(
    table.lastError,
    value,
  );
}

class QueuedFakeReportTable extends _isd.Table<_isc.UuidValue?> {
  QueuedFakeReportTable({super.tableRelation})
    : super(tableName: 'queued_fake_report') {
    updateTable = QueuedFakeReportUpdateTable(this);
    identityId = _isd.ColumnUuid(
      'identityId',
      this,
    );
    qrToken = _isd.ColumnString(
      'qrToken',
      this,
    );
    reason = _isd.ColumnString(
      'reason',
      this,
    );
    comment = _isd.ColumnString(
      'comment',
      this,
    );
    photoLocalPath = _isd.ColumnString(
      'photoLocalPath',
      this,
    );
    createdAt = _isd.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    synced = _isd.ColumnBool(
      'synced',
      this,
      hasDefault: true,
    );
    syncedAt = _isd.ColumnDateTime(
      'syncedAt',
      this,
    );
    lastError = _isd.ColumnString(
      'lastError',
      this,
    );
  }

  late final QueuedFakeReportUpdateTable updateTable;

  late final _isd.ColumnUuid identityId;

  late final _isd.ColumnString qrToken;

  late final _isd.ColumnString reason;

  late final _isd.ColumnString comment;

  late final _isd.ColumnString photoLocalPath;

  late final _isd.ColumnDateTime createdAt;

  late final _isd.ColumnBool synced;

  late final _isd.ColumnDateTime syncedAt;

  late final _isd.ColumnString lastError;

  @override
  List<_isd.Column> get columns => [
    id,
    identityId,
    qrToken,
    reason,
    comment,
    photoLocalPath,
    createdAt,
    synced,
    syncedAt,
    lastError,
  ];
}

class QueuedFakeReportInclude extends _isd.IncludeObject {
  QueuedFakeReportInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<_isc.UuidValue?> get table => QueuedFakeReport.t;
}

class QueuedFakeReportIncludeList extends _isd.IncludeList {
  QueuedFakeReportIncludeList._({
    _isd.WhereExpressionBuilder<QueuedFakeReportTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(QueuedFakeReport.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<_isc.UuidValue?> get table => QueuedFakeReport.t;
}

class QueuedFakeReportRepository {
  const QueuedFakeReportRepository._();

  /// Returns a list of [QueuedFakeReport]s matching the given query parameters.
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
  Future<List<QueuedFakeReport>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<QueuedFakeReportTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<QueuedFakeReportTable>? orderBy,
    _isd.OrderByListBuilder<QueuedFakeReportTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<QueuedFakeReport>(
      where: where?.call(QueuedFakeReport.t),
      orderBy: orderBy?.call(QueuedFakeReport.t),
      orderByList: orderByList?.call(QueuedFakeReport.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [QueuedFakeReport] matching the given query parameters.
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
  Future<QueuedFakeReport?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<QueuedFakeReportTable>? where,
    int? offset,
    _isd.OrderByBuilder<QueuedFakeReportTable>? orderBy,
    _isd.OrderByListBuilder<QueuedFakeReportTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<QueuedFakeReport>(
      where: where?.call(QueuedFakeReport.t),
      orderBy: orderBy?.call(QueuedFakeReport.t),
      orderByList: orderByList?.call(QueuedFakeReport.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [QueuedFakeReport] by its [id] or null if no such row exists.
  Future<QueuedFakeReport?> findById(
    _isd.DatabaseSession session,
    _isc.UuidValue id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<QueuedFakeReport>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [QueuedFakeReport]s in the list and returns the inserted rows.
  ///
  /// The returned [QueuedFakeReport]s will have their `id` fields set.
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
  Future<List<QueuedFakeReport>> insert(
    _isd.DatabaseSession session,
    List<QueuedFakeReport> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<QueuedFakeReport>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [QueuedFakeReport] and returns the inserted row.
  ///
  /// The returned [QueuedFakeReport] will have its `id` field set.
  Future<QueuedFakeReport> insertRow(
    _isd.DatabaseSession session,
    QueuedFakeReport row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<QueuedFakeReport>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [QueuedFakeReport]s in the list and returns the resulting rows.
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
  /// The returned [QueuedFakeReport]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<QueuedFakeReport>> upsert(
    _isd.DatabaseSession session,
    List<QueuedFakeReport> rows, {
    required _isd.ColumnSelections<QueuedFakeReportTable> conflictColumns,
    _isd.ColumnSelections<QueuedFakeReportTable>? updateColumns,
    _isd.WhereExpressionBuilder<QueuedFakeReportTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<QueuedFakeReport>(
      rows,
      conflictColumns: conflictColumns(QueuedFakeReport.t),
      updateColumns: updateColumns?.call(QueuedFakeReport.t),
      updateWhere: updateWhere?.call(QueuedFakeReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [QueuedFakeReport] and returns the resulting row.
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
  /// The returned [QueuedFakeReport] will have its `id` field set.
  Future<QueuedFakeReport?> upsertRow(
    _isd.DatabaseSession session,
    QueuedFakeReport row, {
    required _isd.ColumnSelections<QueuedFakeReportTable> conflictColumns,
    _isd.ColumnSelections<QueuedFakeReportTable>? updateColumns,
    _isd.WhereExpressionBuilder<QueuedFakeReportTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<QueuedFakeReport>(
      row,
      conflictColumns: conflictColumns(QueuedFakeReport.t),
      updateColumns: updateColumns?.call(QueuedFakeReport.t),
      updateWhere: updateWhere?.call(QueuedFakeReport.t),
      transaction: transaction,
    );
  }

  /// Updates all [QueuedFakeReport]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<QueuedFakeReport>> update(
    _isd.DatabaseSession session,
    List<QueuedFakeReport> rows, {
    _isd.ColumnSelections<QueuedFakeReportTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<QueuedFakeReport>(
      rows,
      columns: columns?.call(QueuedFakeReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [QueuedFakeReport]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<QueuedFakeReport> updateRow(
    _isd.DatabaseSession session,
    QueuedFakeReport row, {
    _isd.ColumnSelections<QueuedFakeReportTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<QueuedFakeReport>(
      row,
      columns: columns?.call(QueuedFakeReport.t),
      transaction: transaction,
    );
  }

  /// Updates a single [QueuedFakeReport] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<QueuedFakeReport?> updateById(
    _isd.DatabaseSession session,
    _isc.UuidValue id, {
    required _isd.ColumnValueListBuilder<QueuedFakeReportUpdateTable>
    columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<QueuedFakeReport>(
      id,
      columnValues: columnValues(QueuedFakeReport.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [QueuedFakeReport]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<QueuedFakeReport>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<QueuedFakeReportUpdateTable>
    columnValues,
    required _isd.WhereExpressionBuilder<QueuedFakeReportTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<QueuedFakeReportTable>? orderBy,
    _isd.OrderByListBuilder<QueuedFakeReportTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<QueuedFakeReport>(
      columnValues: columnValues(QueuedFakeReport.t.updateTable),
      where: where(QueuedFakeReport.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(QueuedFakeReport.t),
      orderByList: orderByList?.call(QueuedFakeReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [QueuedFakeReport]s in the list and returns the deleted rows.
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
  Future<List<QueuedFakeReport>> delete(
    _isd.DatabaseSession session,
    List<QueuedFakeReport> rows, {
    _isd.OrderByBuilder<QueuedFakeReportTable>? orderBy,
    _isd.OrderByListBuilder<QueuedFakeReportTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<QueuedFakeReport>(
      rows,
      orderBy: orderBy?.call(QueuedFakeReport.t),
      orderByList: orderByList?.call(QueuedFakeReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [QueuedFakeReport].
  Future<QueuedFakeReport> deleteRow(
    _isd.DatabaseSession session,
    QueuedFakeReport row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<QueuedFakeReport>(
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
  Future<List<QueuedFakeReport>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<QueuedFakeReportTable> where,
    _isd.OrderByBuilder<QueuedFakeReportTable>? orderBy,
    _isd.OrderByListBuilder<QueuedFakeReportTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<QueuedFakeReport>(
      where: where(QueuedFakeReport.t),
      orderBy: orderBy?.call(QueuedFakeReport.t),
      orderByList: orderByList?.call(QueuedFakeReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<QueuedFakeReportTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<QueuedFakeReport>(
      where: where?.call(QueuedFakeReport.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [QueuedFakeReport] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<QueuedFakeReportTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<QueuedFakeReport>(
      where: where(QueuedFakeReport.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
