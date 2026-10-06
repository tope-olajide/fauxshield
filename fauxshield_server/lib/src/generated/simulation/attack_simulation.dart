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
import '../enums/simulation_status.dart' as _i3nrcxzu;
import '../enums/simulation_type.dart' as _i8tlthbq;

/// A scripted attack simulation run. Brands rehearse their fraud response
/// against realistic attack patterns; the platform produces real verification
/// sessions, real signals, and real alerts that flow through the normal pipeline.
abstract class AttackSimulation
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  AttackSimulation._({
    this.id,
    required this.workspaceId,
    required this.type,
    _i3nrcxzu.SimulationStatus? status,
    this.label,
    this.paramsJson,
    int? progress,
    int? totalSteps,
    this.summaryJson,
    required this.createdBy,
    DateTime? createdAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
  }) : status = status ?? _i3nrcxzu.SimulationStatus.queued,
       progress = progress ?? 0,
       totalSteps = totalSteps ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory AttackSimulation({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required _i8tlthbq.SimulationType type,
    _i3nrcxzu.SimulationStatus? status,
    String? label,
    String? paramsJson,
    int? progress,
    int? totalSteps,
    String? summaryJson,
    required String createdBy,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
  }) = _AttackSimulationImpl;

  factory AttackSimulation.fromJson(Map<String, dynamic> jsonSerialization) {
    return AttackSimulation(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      type: _i8tlthbq.SimulationType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      status: jsonSerialization['status'] == null
          ? null
          : _i3nrcxzu.SimulationStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      label: jsonSerialization['label'] as String?,
      paramsJson: jsonSerialization['paramsJson'] as String?,
      progress: jsonSerialization['progress'] as int?,
      totalSteps: jsonSerialization['totalSteps'] as int?,
      summaryJson: jsonSerialization['summaryJson'] as String?,
      createdBy: jsonSerialization['createdBy'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
      cancelledAt: jsonSerialization['cancelledAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['cancelledAt'],
            ),
    );
  }

  static final t = AttackSimulationTable();

  static const db = AttackSimulationRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  _i8tlthbq.SimulationType type;

  _i3nrcxzu.SimulationStatus status;

  String? label;

  /// Simulation specific parameters serialized as JSON.
  String? paramsJson;

  int progress;

  int totalSteps;

  /// Result summary serialized as JSON.
  String? summaryJson;

  String createdBy;

  DateTime createdAt;

  DateTime? startedAt;

  DateTime? completedAt;

  DateTime? cancelledAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AttackSimulation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AttackSimulation copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    _i8tlthbq.SimulationType? type,
    _i3nrcxzu.SimulationStatus? status,
    String? label,
    String? paramsJson,
    int? progress,
    int? totalSteps,
    String? summaryJson,
    String? createdBy,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AttackSimulation',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'type': type.toJson(),
      'status': status.toJson(),
      if (label != null) 'label': label,
      if (paramsJson != null) 'paramsJson': paramsJson,
      'progress': progress,
      'totalSteps': totalSteps,
      if (summaryJson != null) 'summaryJson': summaryJson,
      'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AttackSimulation',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'type': type.toJson(),
      'status': status.toJson(),
      if (label != null) 'label': label,
      if (paramsJson != null) 'paramsJson': paramsJson,
      'progress': progress,
      'totalSteps': totalSteps,
      if (summaryJson != null) 'summaryJson': summaryJson,
      'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
    };
  }

  static AttackSimulationInclude include() {
    return AttackSimulationInclude._();
  }

  static AttackSimulationIncludeList includeList({
    _is.WhereExpressionBuilder<AttackSimulationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AttackSimulationTable>? orderBy,
    _is.OrderByListBuilder<AttackSimulationTable>? orderByList,
    AttackSimulationInclude? include,
  }) {
    return AttackSimulationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AttackSimulation.t),
      orderByList: orderByList?.call(AttackSimulation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttackSimulationImpl extends AttackSimulation {
  _AttackSimulationImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required _i8tlthbq.SimulationType type,
    _i3nrcxzu.SimulationStatus? status,
    String? label,
    String? paramsJson,
    int? progress,
    int? totalSteps,
    String? summaryJson,
    required String createdBy,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         type: type,
         status: status,
         label: label,
         paramsJson: paramsJson,
         progress: progress,
         totalSteps: totalSteps,
         summaryJson: summaryJson,
         createdBy: createdBy,
         createdAt: createdAt,
         startedAt: startedAt,
         completedAt: completedAt,
         cancelledAt: cancelledAt,
       );

  /// Returns a shallow copy of this [AttackSimulation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AttackSimulation copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    _i8tlthbq.SimulationType? type,
    _i3nrcxzu.SimulationStatus? status,
    Object? label = _Undefined,
    Object? paramsJson = _Undefined,
    int? progress,
    int? totalSteps,
    Object? summaryJson = _Undefined,
    String? createdBy,
    DateTime? createdAt,
    Object? startedAt = _Undefined,
    Object? completedAt = _Undefined,
    Object? cancelledAt = _Undefined,
  }) {
    return AttackSimulation(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      type: type ?? this.type,
      status: status ?? this.status,
      label: label is String? ? label : this.label,
      paramsJson: paramsJson is String? ? paramsJson : this.paramsJson,
      progress: progress ?? this.progress,
      totalSteps: totalSteps ?? this.totalSteps,
      summaryJson: summaryJson is String? ? summaryJson : this.summaryJson,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt is DateTime? ? startedAt : this.startedAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      cancelledAt: cancelledAt is DateTime? ? cancelledAt : this.cancelledAt,
    );
  }
}

class AttackSimulationUpdateTable
    extends _is.UpdateTable<AttackSimulationTable> {
  AttackSimulationUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<_i8tlthbq.SimulationType, _i8tlthbq.SimulationType> type(
    _i8tlthbq.SimulationType value,
  ) => _is.ColumnValue(
    table.type,
    value,
  );

  _is.ColumnValue<_i3nrcxzu.SimulationStatus, _i3nrcxzu.SimulationStatus>
  status(_i3nrcxzu.SimulationStatus value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> label(String? value) => _is.ColumnValue(
    table.label,
    value,
  );

  _is.ColumnValue<String, String> paramsJson(String? value) => _is.ColumnValue(
    table.paramsJson,
    value,
  );

  _is.ColumnValue<int, int> progress(int value) => _is.ColumnValue(
    table.progress,
    value,
  );

  _is.ColumnValue<int, int> totalSteps(int value) => _is.ColumnValue(
    table.totalSteps,
    value,
  );

  _is.ColumnValue<String, String> summaryJson(String? value) => _is.ColumnValue(
    table.summaryJson,
    value,
  );

  _is.ColumnValue<String, String> createdBy(String value) => _is.ColumnValue(
    table.createdBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> startedAt(DateTime? value) =>
      _is.ColumnValue(
        table.startedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> completedAt(DateTime? value) =>
      _is.ColumnValue(
        table.completedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> cancelledAt(DateTime? value) =>
      _is.ColumnValue(
        table.cancelledAt,
        value,
      );
}

class AttackSimulationTable extends _is.Table<_is.UuidValue?> {
  AttackSimulationTable({super.tableRelation})
    : super(tableName: 'attack_simulation') {
    updateTable = AttackSimulationUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    type = _is.ColumnEnum(
      'type',
      this,
      _is.EnumSerialization.byName,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    label = _is.ColumnString(
      'label',
      this,
    );
    paramsJson = _is.ColumnString(
      'paramsJson',
      this,
    );
    progress = _is.ColumnInt(
      'progress',
      this,
      hasDefault: true,
    );
    totalSteps = _is.ColumnInt(
      'totalSteps',
      this,
      hasDefault: true,
    );
    summaryJson = _is.ColumnString(
      'summaryJson',
      this,
    );
    createdBy = _is.ColumnString(
      'createdBy',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    startedAt = _is.ColumnDateTime(
      'startedAt',
      this,
    );
    completedAt = _is.ColumnDateTime(
      'completedAt',
      this,
    );
    cancelledAt = _is.ColumnDateTime(
      'cancelledAt',
      this,
    );
  }

  late final AttackSimulationUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  late final _is.ColumnEnum<_i8tlthbq.SimulationType> type;

  late final _is.ColumnEnum<_i3nrcxzu.SimulationStatus> status;

  late final _is.ColumnString label;

  /// Simulation specific parameters serialized as JSON.
  late final _is.ColumnString paramsJson;

  late final _is.ColumnInt progress;

  late final _is.ColumnInt totalSteps;

  /// Result summary serialized as JSON.
  late final _is.ColumnString summaryJson;

  late final _is.ColumnString createdBy;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime startedAt;

  late final _is.ColumnDateTime completedAt;

  late final _is.ColumnDateTime cancelledAt;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    type,
    status,
    label,
    paramsJson,
    progress,
    totalSteps,
    summaryJson,
    createdBy,
    createdAt,
    startedAt,
    completedAt,
    cancelledAt,
  ];
}

class AttackSimulationInclude extends _is.IncludeObject {
  AttackSimulationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => AttackSimulation.t;
}

class AttackSimulationIncludeList extends _is.IncludeList {
  AttackSimulationIncludeList._({
    _is.WhereExpressionBuilder<AttackSimulationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AttackSimulation.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => AttackSimulation.t;
}

class AttackSimulationRepository {
  const AttackSimulationRepository._();

  /// Returns a list of [AttackSimulation]s matching the given query parameters.
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
  Future<List<AttackSimulation>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AttackSimulationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AttackSimulationTable>? orderBy,
    _is.OrderByListBuilder<AttackSimulationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AttackSimulation>(
      where: where?.call(AttackSimulation.t),
      orderBy: orderBy?.call(AttackSimulation.t),
      orderByList: orderByList?.call(AttackSimulation.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AttackSimulation] matching the given query parameters.
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
  Future<AttackSimulation?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AttackSimulationTable>? where,
    int? offset,
    _is.OrderByBuilder<AttackSimulationTable>? orderBy,
    _is.OrderByListBuilder<AttackSimulationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AttackSimulation>(
      where: where?.call(AttackSimulation.t),
      orderBy: orderBy?.call(AttackSimulation.t),
      orderByList: orderByList?.call(AttackSimulation.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AttackSimulation] by its [id] or null if no such row exists.
  Future<AttackSimulation?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AttackSimulation>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AttackSimulation]s in the list and returns the inserted rows.
  ///
  /// The returned [AttackSimulation]s will have their `id` fields set.
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
  Future<List<AttackSimulation>> insert(
    _is.DatabaseSession session,
    List<AttackSimulation> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AttackSimulation>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AttackSimulation] and returns the inserted row.
  ///
  /// The returned [AttackSimulation] will have its `id` field set.
  Future<AttackSimulation> insertRow(
    _is.DatabaseSession session,
    AttackSimulation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AttackSimulation>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AttackSimulation]s in the list and returns the resulting rows.
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
  /// The returned [AttackSimulation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AttackSimulation>> upsert(
    _is.DatabaseSession session,
    List<AttackSimulation> rows, {
    required _is.ColumnSelections<AttackSimulationTable> conflictColumns,
    _is.ColumnSelections<AttackSimulationTable>? updateColumns,
    _is.WhereExpressionBuilder<AttackSimulationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AttackSimulation>(
      rows,
      conflictColumns: conflictColumns(AttackSimulation.t),
      updateColumns: updateColumns?.call(AttackSimulation.t),
      updateWhere: updateWhere?.call(AttackSimulation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AttackSimulation] and returns the resulting row.
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
  /// The returned [AttackSimulation] will have its `id` field set.
  Future<AttackSimulation?> upsertRow(
    _is.DatabaseSession session,
    AttackSimulation row, {
    required _is.ColumnSelections<AttackSimulationTable> conflictColumns,
    _is.ColumnSelections<AttackSimulationTable>? updateColumns,
    _is.WhereExpressionBuilder<AttackSimulationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AttackSimulation>(
      row,
      conflictColumns: conflictColumns(AttackSimulation.t),
      updateColumns: updateColumns?.call(AttackSimulation.t),
      updateWhere: updateWhere?.call(AttackSimulation.t),
      transaction: transaction,
    );
  }

  /// Updates all [AttackSimulation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AttackSimulation>> update(
    _is.DatabaseSession session,
    List<AttackSimulation> rows, {
    _is.ColumnSelections<AttackSimulationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AttackSimulation>(
      rows,
      columns: columns?.call(AttackSimulation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AttackSimulation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AttackSimulation> updateRow(
    _is.DatabaseSession session,
    AttackSimulation row, {
    _is.ColumnSelections<AttackSimulationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AttackSimulation>(
      row,
      columns: columns?.call(AttackSimulation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AttackSimulation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AttackSimulation?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<AttackSimulationUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AttackSimulation>(
      id,
      columnValues: columnValues(AttackSimulation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AttackSimulation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AttackSimulation>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AttackSimulationUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<AttackSimulationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AttackSimulationTable>? orderBy,
    _is.OrderByListBuilder<AttackSimulationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AttackSimulation>(
      columnValues: columnValues(AttackSimulation.t.updateTable),
      where: where(AttackSimulation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AttackSimulation.t),
      orderByList: orderByList?.call(AttackSimulation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AttackSimulation]s in the list and returns the deleted rows.
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
  Future<List<AttackSimulation>> delete(
    _is.DatabaseSession session,
    List<AttackSimulation> rows, {
    _is.OrderByBuilder<AttackSimulationTable>? orderBy,
    _is.OrderByListBuilder<AttackSimulationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AttackSimulation>(
      rows,
      orderBy: orderBy?.call(AttackSimulation.t),
      orderByList: orderByList?.call(AttackSimulation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AttackSimulation].
  Future<AttackSimulation> deleteRow(
    _is.DatabaseSession session,
    AttackSimulation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AttackSimulation>(
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
  Future<List<AttackSimulation>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AttackSimulationTable> where,
    _is.OrderByBuilder<AttackSimulationTable>? orderBy,
    _is.OrderByListBuilder<AttackSimulationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AttackSimulation>(
      where: where(AttackSimulation.t),
      orderBy: orderBy?.call(AttackSimulation.t),
      orderByList: orderByList?.call(AttackSimulation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AttackSimulationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AttackSimulation>(
      where: where?.call(AttackSimulation.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AttackSimulation] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AttackSimulationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AttackSimulation>(
      where: where(AttackSimulation.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
