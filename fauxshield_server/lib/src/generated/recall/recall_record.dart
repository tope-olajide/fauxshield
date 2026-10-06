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
import '../enums/recall_scope.dart' as _ikvp6e9n;

/// An immutable record of a recall action, either for a whole batch or for a
/// single identity. Verification returns the recalled outcome while active.
abstract class RecallRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  RecallRecord._({
    this.id,
    required this.workspaceId,
    required this.batchId,
    this.identityId,
    required this.scope,
    required this.reason,
    required this.issuedBy,
    DateTime? issuedAt,
    bool? lifted,
    this.liftedAt,
    this.liftedBy,
    this.notes,
  }) : issuedAt = issuedAt ?? DateTime.now(),
       lifted = lifted ?? false;

  factory RecallRecord({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required _is.UuidValue batchId,
    _is.UuidValue? identityId,
    required _ikvp6e9n.RecallScope scope,
    required String reason,
    required String issuedBy,
    DateTime? issuedAt,
    bool? lifted,
    DateTime? liftedAt,
    String? liftedBy,
    String? notes,
  }) = _RecallRecordImpl;

  factory RecallRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return RecallRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      batchId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['batchId'],
      ),
      identityId: jsonSerialization['identityId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['identityId'],
            ),
      scope: _ikvp6e9n.RecallScope.fromJson(
        (jsonSerialization['scope'] as String),
      ),
      reason: jsonSerialization['reason'] as String,
      issuedBy: jsonSerialization['issuedBy'] as String,
      issuedAt: jsonSerialization['issuedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['issuedAt']),
      lifted: jsonSerialization['lifted'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['lifted']),
      liftedAt: jsonSerialization['liftedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['liftedAt']),
      liftedBy: jsonSerialization['liftedBy'] as String?,
      notes: jsonSerialization['notes'] as String?,
    );
  }

  static final t = RecallRecordTable();

  static const db = RecallRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  _is.UuidValue batchId;

  _is.UuidValue? identityId;

  _ikvp6e9n.RecallScope scope;

  String reason;

  String issuedBy;

  DateTime issuedAt;

  bool lifted;

  DateTime? liftedAt;

  String? liftedBy;

  String? notes;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [RecallRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RecallRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    _is.UuidValue? batchId,
    _is.UuidValue? identityId,
    _ikvp6e9n.RecallScope? scope,
    String? reason,
    String? issuedBy,
    DateTime? issuedAt,
    bool? lifted,
    DateTime? liftedAt,
    String? liftedBy,
    String? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecallRecord',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'batchId': batchId.toJson(),
      if (identityId != null) 'identityId': identityId?.toJson(),
      'scope': scope.toJson(),
      'reason': reason,
      'issuedBy': issuedBy,
      'issuedAt': issuedAt.toJson(),
      'lifted': lifted,
      if (liftedAt != null) 'liftedAt': liftedAt?.toJson(),
      if (liftedBy != null) 'liftedBy': liftedBy,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RecallRecord',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'batchId': batchId.toJson(),
      if (identityId != null) 'identityId': identityId?.toJson(),
      'scope': scope.toJson(),
      'reason': reason,
      'issuedBy': issuedBy,
      'issuedAt': issuedAt.toJson(),
      'lifted': lifted,
      if (liftedAt != null) 'liftedAt': liftedAt?.toJson(),
      if (liftedBy != null) 'liftedBy': liftedBy,
      if (notes != null) 'notes': notes,
    };
  }

  static RecallRecordInclude include() {
    return RecallRecordInclude._();
  }

  static RecallRecordIncludeList includeList({
    _is.WhereExpressionBuilder<RecallRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RecallRecordTable>? orderBy,
    _is.OrderByListBuilder<RecallRecordTable>? orderByList,
    RecallRecordInclude? include,
  }) {
    return RecallRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RecallRecord.t),
      orderByList: orderByList?.call(RecallRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecallRecordImpl extends RecallRecord {
  _RecallRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required _is.UuidValue batchId,
    _is.UuidValue? identityId,
    required _ikvp6e9n.RecallScope scope,
    required String reason,
    required String issuedBy,
    DateTime? issuedAt,
    bool? lifted,
    DateTime? liftedAt,
    String? liftedBy,
    String? notes,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         batchId: batchId,
         identityId: identityId,
         scope: scope,
         reason: reason,
         issuedBy: issuedBy,
         issuedAt: issuedAt,
         lifted: lifted,
         liftedAt: liftedAt,
         liftedBy: liftedBy,
         notes: notes,
       );

  /// Returns a shallow copy of this [RecallRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RecallRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    _is.UuidValue? batchId,
    Object? identityId = _Undefined,
    _ikvp6e9n.RecallScope? scope,
    String? reason,
    String? issuedBy,
    DateTime? issuedAt,
    bool? lifted,
    Object? liftedAt = _Undefined,
    Object? liftedBy = _Undefined,
    Object? notes = _Undefined,
  }) {
    return RecallRecord(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      batchId: batchId ?? this.batchId,
      identityId: identityId is _is.UuidValue? ? identityId : this.identityId,
      scope: scope ?? this.scope,
      reason: reason ?? this.reason,
      issuedBy: issuedBy ?? this.issuedBy,
      issuedAt: issuedAt ?? this.issuedAt,
      lifted: lifted ?? this.lifted,
      liftedAt: liftedAt is DateTime? ? liftedAt : this.liftedAt,
      liftedBy: liftedBy is String? ? liftedBy : this.liftedBy,
      notes: notes is String? ? notes : this.notes,
    );
  }
}

class RecallRecordUpdateTable extends _is.UpdateTable<RecallRecordTable> {
  RecallRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> batchId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.batchId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> identityId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.identityId,
    value,
  );

  _is.ColumnValue<_ikvp6e9n.RecallScope, _ikvp6e9n.RecallScope> scope(
    _ikvp6e9n.RecallScope value,
  ) => _is.ColumnValue(
    table.scope,
    value,
  );

  _is.ColumnValue<String, String> reason(String value) => _is.ColumnValue(
    table.reason,
    value,
  );

  _is.ColumnValue<String, String> issuedBy(String value) => _is.ColumnValue(
    table.issuedBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> issuedAt(DateTime value) =>
      _is.ColumnValue(
        table.issuedAt,
        value,
      );

  _is.ColumnValue<bool, bool> lifted(bool value) => _is.ColumnValue(
    table.lifted,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> liftedAt(DateTime? value) =>
      _is.ColumnValue(
        table.liftedAt,
        value,
      );

  _is.ColumnValue<String, String> liftedBy(String? value) => _is.ColumnValue(
    table.liftedBy,
    value,
  );

  _is.ColumnValue<String, String> notes(String? value) => _is.ColumnValue(
    table.notes,
    value,
  );
}

class RecallRecordTable extends _is.Table<_is.UuidValue?> {
  RecallRecordTable({super.tableRelation}) : super(tableName: 'recall_record') {
    updateTable = RecallRecordUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    batchId = _is.ColumnUuid(
      'batchId',
      this,
    );
    identityId = _is.ColumnUuid(
      'identityId',
      this,
    );
    scope = _is.ColumnEnum(
      'scope',
      this,
      _is.EnumSerialization.byName,
    );
    reason = _is.ColumnString(
      'reason',
      this,
    );
    issuedBy = _is.ColumnString(
      'issuedBy',
      this,
    );
    issuedAt = _is.ColumnDateTime(
      'issuedAt',
      this,
      hasDefault: true,
    );
    lifted = _is.ColumnBool(
      'lifted',
      this,
      hasDefault: true,
    );
    liftedAt = _is.ColumnDateTime(
      'liftedAt',
      this,
    );
    liftedBy = _is.ColumnString(
      'liftedBy',
      this,
    );
    notes = _is.ColumnString(
      'notes',
      this,
    );
  }

  late final RecallRecordUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  late final _is.ColumnUuid batchId;

  late final _is.ColumnUuid identityId;

  late final _is.ColumnEnum<_ikvp6e9n.RecallScope> scope;

  late final _is.ColumnString reason;

  late final _is.ColumnString issuedBy;

  late final _is.ColumnDateTime issuedAt;

  late final _is.ColumnBool lifted;

  late final _is.ColumnDateTime liftedAt;

  late final _is.ColumnString liftedBy;

  late final _is.ColumnString notes;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    batchId,
    identityId,
    scope,
    reason,
    issuedBy,
    issuedAt,
    lifted,
    liftedAt,
    liftedBy,
    notes,
  ];
}

class RecallRecordInclude extends _is.IncludeObject {
  RecallRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => RecallRecord.t;
}

class RecallRecordIncludeList extends _is.IncludeList {
  RecallRecordIncludeList._({
    _is.WhereExpressionBuilder<RecallRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RecallRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => RecallRecord.t;
}

class RecallRecordRepository {
  const RecallRecordRepository._();

  /// Returns a list of [RecallRecord]s matching the given query parameters.
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
  Future<List<RecallRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RecallRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RecallRecordTable>? orderBy,
    _is.OrderByListBuilder<RecallRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RecallRecord>(
      where: where?.call(RecallRecord.t),
      orderBy: orderBy?.call(RecallRecord.t),
      orderByList: orderByList?.call(RecallRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RecallRecord] matching the given query parameters.
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
  Future<RecallRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RecallRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<RecallRecordTable>? orderBy,
    _is.OrderByListBuilder<RecallRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RecallRecord>(
      where: where?.call(RecallRecord.t),
      orderBy: orderBy?.call(RecallRecord.t),
      orderByList: orderByList?.call(RecallRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RecallRecord] by its [id] or null if no such row exists.
  Future<RecallRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RecallRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RecallRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [RecallRecord]s will have their `id` fields set.
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
  Future<List<RecallRecord>> insert(
    _is.DatabaseSession session,
    List<RecallRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RecallRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RecallRecord] and returns the inserted row.
  ///
  /// The returned [RecallRecord] will have its `id` field set.
  Future<RecallRecord> insertRow(
    _is.DatabaseSession session,
    RecallRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RecallRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RecallRecord]s in the list and returns the resulting rows.
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
  /// The returned [RecallRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RecallRecord>> upsert(
    _is.DatabaseSession session,
    List<RecallRecord> rows, {
    required _is.ColumnSelections<RecallRecordTable> conflictColumns,
    _is.ColumnSelections<RecallRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<RecallRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RecallRecord>(
      rows,
      conflictColumns: conflictColumns(RecallRecord.t),
      updateColumns: updateColumns?.call(RecallRecord.t),
      updateWhere: updateWhere?.call(RecallRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RecallRecord] and returns the resulting row.
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
  /// The returned [RecallRecord] will have its `id` field set.
  Future<RecallRecord?> upsertRow(
    _is.DatabaseSession session,
    RecallRecord row, {
    required _is.ColumnSelections<RecallRecordTable> conflictColumns,
    _is.ColumnSelections<RecallRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<RecallRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RecallRecord>(
      row,
      conflictColumns: conflictColumns(RecallRecord.t),
      updateColumns: updateColumns?.call(RecallRecord.t),
      updateWhere: updateWhere?.call(RecallRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [RecallRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RecallRecord>> update(
    _is.DatabaseSession session,
    List<RecallRecord> rows, {
    _is.ColumnSelections<RecallRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RecallRecord>(
      rows,
      columns: columns?.call(RecallRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RecallRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RecallRecord> updateRow(
    _is.DatabaseSession session,
    RecallRecord row, {
    _is.ColumnSelections<RecallRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RecallRecord>(
      row,
      columns: columns?.call(RecallRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RecallRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RecallRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<RecallRecordUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RecallRecord>(
      id,
      columnValues: columnValues(RecallRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RecallRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RecallRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RecallRecordUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RecallRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RecallRecordTable>? orderBy,
    _is.OrderByListBuilder<RecallRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RecallRecord>(
      columnValues: columnValues(RecallRecord.t.updateTable),
      where: where(RecallRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RecallRecord.t),
      orderByList: orderByList?.call(RecallRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RecallRecord]s in the list and returns the deleted rows.
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
  Future<List<RecallRecord>> delete(
    _is.DatabaseSession session,
    List<RecallRecord> rows, {
    _is.OrderByBuilder<RecallRecordTable>? orderBy,
    _is.OrderByListBuilder<RecallRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RecallRecord>(
      rows,
      orderBy: orderBy?.call(RecallRecord.t),
      orderByList: orderByList?.call(RecallRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RecallRecord].
  Future<RecallRecord> deleteRow(
    _is.DatabaseSession session,
    RecallRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RecallRecord>(
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
  Future<List<RecallRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RecallRecordTable> where,
    _is.OrderByBuilder<RecallRecordTable>? orderBy,
    _is.OrderByListBuilder<RecallRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RecallRecord>(
      where: where(RecallRecord.t),
      orderBy: orderBy?.call(RecallRecord.t),
      orderByList: orderByList?.call(RecallRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RecallRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RecallRecord>(
      where: where?.call(RecallRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RecallRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RecallRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RecallRecord>(
      where: where(RecallRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
