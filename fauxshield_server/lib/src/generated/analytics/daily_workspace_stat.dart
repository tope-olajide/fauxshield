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

/// Daily analytics rollup materialized by a recurring scheduled task so the
/// dashboard stays fast even on large verification volumes.
abstract class DailyWorkspaceStat
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  DailyWorkspaceStat._({
    this.id,
    required this.workspaceId,
    required this.date,
    int? verifications,
    int? authentic,
    int? alreadyVerified,
    int? invalidPin,
    int? fraudSuspected,
    int? highRisk,
    int? recalled,
    int? alertsCreated,
    int? alertsResolved,
    this.topCountriesJson,
    DateTime? createdAt,
  }) : verifications = verifications ?? 0,
       authentic = authentic ?? 0,
       alreadyVerified = alreadyVerified ?? 0,
       invalidPin = invalidPin ?? 0,
       fraudSuspected = fraudSuspected ?? 0,
       highRisk = highRisk ?? 0,
       recalled = recalled ?? 0,
       alertsCreated = alertsCreated ?? 0,
       alertsResolved = alertsResolved ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory DailyWorkspaceStat({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required DateTime date,
    int? verifications,
    int? authentic,
    int? alreadyVerified,
    int? invalidPin,
    int? fraudSuspected,
    int? highRisk,
    int? recalled,
    int? alertsCreated,
    int? alertsResolved,
    String? topCountriesJson,
    DateTime? createdAt,
  }) = _DailyWorkspaceStatImpl;

  factory DailyWorkspaceStat.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyWorkspaceStat(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      date: _is.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      verifications: jsonSerialization['verifications'] as int?,
      authentic: jsonSerialization['authentic'] as int?,
      alreadyVerified: jsonSerialization['alreadyVerified'] as int?,
      invalidPin: jsonSerialization['invalidPin'] as int?,
      fraudSuspected: jsonSerialization['fraudSuspected'] as int?,
      highRisk: jsonSerialization['highRisk'] as int?,
      recalled: jsonSerialization['recalled'] as int?,
      alertsCreated: jsonSerialization['alertsCreated'] as int?,
      alertsResolved: jsonSerialization['alertsResolved'] as int?,
      topCountriesJson: jsonSerialization['topCountriesJson'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = DailyWorkspaceStatTable();

  static const db = DailyWorkspaceStatRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  /// UTC date (midnight) this rollup covers.
  DateTime date;

  int verifications;

  int authentic;

  int alreadyVerified;

  int invalidPin;

  int fraudSuspected;

  int highRisk;

  int recalled;

  int alertsCreated;

  int alertsResolved;

  /// JSON list of country activity for the day.
  String? topCountriesJson;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [DailyWorkspaceStat]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DailyWorkspaceStat copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    DateTime? date,
    int? verifications,
    int? authentic,
    int? alreadyVerified,
    int? invalidPin,
    int? fraudSuspected,
    int? highRisk,
    int? recalled,
    int? alertsCreated,
    int? alertsResolved,
    String? topCountriesJson,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyWorkspaceStat',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'date': date.toJson(),
      'verifications': verifications,
      'authentic': authentic,
      'alreadyVerified': alreadyVerified,
      'invalidPin': invalidPin,
      'fraudSuspected': fraudSuspected,
      'highRisk': highRisk,
      'recalled': recalled,
      'alertsCreated': alertsCreated,
      'alertsResolved': alertsResolved,
      if (topCountriesJson != null) 'topCountriesJson': topCountriesJson,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DailyWorkspaceStat',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'date': date.toJson(),
      'verifications': verifications,
      'authentic': authentic,
      'alreadyVerified': alreadyVerified,
      'invalidPin': invalidPin,
      'fraudSuspected': fraudSuspected,
      'highRisk': highRisk,
      'recalled': recalled,
      'alertsCreated': alertsCreated,
      'alertsResolved': alertsResolved,
      if (topCountriesJson != null) 'topCountriesJson': topCountriesJson,
      'createdAt': createdAt.toJson(),
    };
  }

  static DailyWorkspaceStatInclude include() {
    return DailyWorkspaceStatInclude._();
  }

  static DailyWorkspaceStatIncludeList includeList({
    _is.WhereExpressionBuilder<DailyWorkspaceStatTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DailyWorkspaceStatTable>? orderBy,
    _is.OrderByListBuilder<DailyWorkspaceStatTable>? orderByList,
    DailyWorkspaceStatInclude? include,
  }) {
    return DailyWorkspaceStatIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DailyWorkspaceStat.t),
      orderByList: orderByList?.call(DailyWorkspaceStat.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DailyWorkspaceStatImpl extends DailyWorkspaceStat {
  _DailyWorkspaceStatImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required DateTime date,
    int? verifications,
    int? authentic,
    int? alreadyVerified,
    int? invalidPin,
    int? fraudSuspected,
    int? highRisk,
    int? recalled,
    int? alertsCreated,
    int? alertsResolved,
    String? topCountriesJson,
    DateTime? createdAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         date: date,
         verifications: verifications,
         authentic: authentic,
         alreadyVerified: alreadyVerified,
         invalidPin: invalidPin,
         fraudSuspected: fraudSuspected,
         highRisk: highRisk,
         recalled: recalled,
         alertsCreated: alertsCreated,
         alertsResolved: alertsResolved,
         topCountriesJson: topCountriesJson,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DailyWorkspaceStat]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DailyWorkspaceStat copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    DateTime? date,
    int? verifications,
    int? authentic,
    int? alreadyVerified,
    int? invalidPin,
    int? fraudSuspected,
    int? highRisk,
    int? recalled,
    int? alertsCreated,
    int? alertsResolved,
    Object? topCountriesJson = _Undefined,
    DateTime? createdAt,
  }) {
    return DailyWorkspaceStat(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      date: date ?? this.date,
      verifications: verifications ?? this.verifications,
      authentic: authentic ?? this.authentic,
      alreadyVerified: alreadyVerified ?? this.alreadyVerified,
      invalidPin: invalidPin ?? this.invalidPin,
      fraudSuspected: fraudSuspected ?? this.fraudSuspected,
      highRisk: highRisk ?? this.highRisk,
      recalled: recalled ?? this.recalled,
      alertsCreated: alertsCreated ?? this.alertsCreated,
      alertsResolved: alertsResolved ?? this.alertsResolved,
      topCountriesJson: topCountriesJson is String?
          ? topCountriesJson
          : this.topCountriesJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DailyWorkspaceStatUpdateTable
    extends _is.UpdateTable<DailyWorkspaceStatTable> {
  DailyWorkspaceStatUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> date(DateTime value) => _is.ColumnValue(
    table.date,
    value,
  );

  _is.ColumnValue<int, int> verifications(int value) => _is.ColumnValue(
    table.verifications,
    value,
  );

  _is.ColumnValue<int, int> authentic(int value) => _is.ColumnValue(
    table.authentic,
    value,
  );

  _is.ColumnValue<int, int> alreadyVerified(int value) => _is.ColumnValue(
    table.alreadyVerified,
    value,
  );

  _is.ColumnValue<int, int> invalidPin(int value) => _is.ColumnValue(
    table.invalidPin,
    value,
  );

  _is.ColumnValue<int, int> fraudSuspected(int value) => _is.ColumnValue(
    table.fraudSuspected,
    value,
  );

  _is.ColumnValue<int, int> highRisk(int value) => _is.ColumnValue(
    table.highRisk,
    value,
  );

  _is.ColumnValue<int, int> recalled(int value) => _is.ColumnValue(
    table.recalled,
    value,
  );

  _is.ColumnValue<int, int> alertsCreated(int value) => _is.ColumnValue(
    table.alertsCreated,
    value,
  );

  _is.ColumnValue<int, int> alertsResolved(int value) => _is.ColumnValue(
    table.alertsResolved,
    value,
  );

  _is.ColumnValue<String, String> topCountriesJson(String? value) =>
      _is.ColumnValue(
        table.topCountriesJson,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class DailyWorkspaceStatTable extends _is.Table<_is.UuidValue?> {
  DailyWorkspaceStatTable({super.tableRelation})
    : super(tableName: 'daily_workspace_stat') {
    updateTable = DailyWorkspaceStatUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    date = _is.ColumnDateTime(
      'date',
      this,
    );
    verifications = _is.ColumnInt(
      'verifications',
      this,
      hasDefault: true,
    );
    authentic = _is.ColumnInt(
      'authentic',
      this,
      hasDefault: true,
    );
    alreadyVerified = _is.ColumnInt(
      'alreadyVerified',
      this,
      hasDefault: true,
    );
    invalidPin = _is.ColumnInt(
      'invalidPin',
      this,
      hasDefault: true,
    );
    fraudSuspected = _is.ColumnInt(
      'fraudSuspected',
      this,
      hasDefault: true,
    );
    highRisk = _is.ColumnInt(
      'highRisk',
      this,
      hasDefault: true,
    );
    recalled = _is.ColumnInt(
      'recalled',
      this,
      hasDefault: true,
    );
    alertsCreated = _is.ColumnInt(
      'alertsCreated',
      this,
      hasDefault: true,
    );
    alertsResolved = _is.ColumnInt(
      'alertsResolved',
      this,
      hasDefault: true,
    );
    topCountriesJson = _is.ColumnString(
      'topCountriesJson',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final DailyWorkspaceStatUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  /// UTC date (midnight) this rollup covers.
  late final _is.ColumnDateTime date;

  late final _is.ColumnInt verifications;

  late final _is.ColumnInt authentic;

  late final _is.ColumnInt alreadyVerified;

  late final _is.ColumnInt invalidPin;

  late final _is.ColumnInt fraudSuspected;

  late final _is.ColumnInt highRisk;

  late final _is.ColumnInt recalled;

  late final _is.ColumnInt alertsCreated;

  late final _is.ColumnInt alertsResolved;

  /// JSON list of country activity for the day.
  late final _is.ColumnString topCountriesJson;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    date,
    verifications,
    authentic,
    alreadyVerified,
    invalidPin,
    fraudSuspected,
    highRisk,
    recalled,
    alertsCreated,
    alertsResolved,
    topCountriesJson,
    createdAt,
  ];
}

class DailyWorkspaceStatInclude extends _is.IncludeObject {
  DailyWorkspaceStatInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => DailyWorkspaceStat.t;
}

class DailyWorkspaceStatIncludeList extends _is.IncludeList {
  DailyWorkspaceStatIncludeList._({
    _is.WhereExpressionBuilder<DailyWorkspaceStatTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DailyWorkspaceStat.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => DailyWorkspaceStat.t;
}

class DailyWorkspaceStatRepository {
  const DailyWorkspaceStatRepository._();

  /// Returns a list of [DailyWorkspaceStat]s matching the given query parameters.
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
  Future<List<DailyWorkspaceStat>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DailyWorkspaceStatTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DailyWorkspaceStatTable>? orderBy,
    _is.OrderByListBuilder<DailyWorkspaceStatTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DailyWorkspaceStat>(
      where: where?.call(DailyWorkspaceStat.t),
      orderBy: orderBy?.call(DailyWorkspaceStat.t),
      orderByList: orderByList?.call(DailyWorkspaceStat.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DailyWorkspaceStat] matching the given query parameters.
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
  Future<DailyWorkspaceStat?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DailyWorkspaceStatTable>? where,
    int? offset,
    _is.OrderByBuilder<DailyWorkspaceStatTable>? orderBy,
    _is.OrderByListBuilder<DailyWorkspaceStatTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DailyWorkspaceStat>(
      where: where?.call(DailyWorkspaceStat.t),
      orderBy: orderBy?.call(DailyWorkspaceStat.t),
      orderByList: orderByList?.call(DailyWorkspaceStat.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DailyWorkspaceStat] by its [id] or null if no such row exists.
  Future<DailyWorkspaceStat?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DailyWorkspaceStat>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DailyWorkspaceStat]s in the list and returns the inserted rows.
  ///
  /// The returned [DailyWorkspaceStat]s will have their `id` fields set.
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
  Future<List<DailyWorkspaceStat>> insert(
    _is.DatabaseSession session,
    List<DailyWorkspaceStat> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DailyWorkspaceStat>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DailyWorkspaceStat] and returns the inserted row.
  ///
  /// The returned [DailyWorkspaceStat] will have its `id` field set.
  Future<DailyWorkspaceStat> insertRow(
    _is.DatabaseSession session,
    DailyWorkspaceStat row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DailyWorkspaceStat>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DailyWorkspaceStat]s in the list and returns the resulting rows.
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
  /// The returned [DailyWorkspaceStat]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DailyWorkspaceStat>> upsert(
    _is.DatabaseSession session,
    List<DailyWorkspaceStat> rows, {
    required _is.ColumnSelections<DailyWorkspaceStatTable> conflictColumns,
    _is.ColumnSelections<DailyWorkspaceStatTable>? updateColumns,
    _is.WhereExpressionBuilder<DailyWorkspaceStatTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DailyWorkspaceStat>(
      rows,
      conflictColumns: conflictColumns(DailyWorkspaceStat.t),
      updateColumns: updateColumns?.call(DailyWorkspaceStat.t),
      updateWhere: updateWhere?.call(DailyWorkspaceStat.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DailyWorkspaceStat] and returns the resulting row.
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
  /// The returned [DailyWorkspaceStat] will have its `id` field set.
  Future<DailyWorkspaceStat?> upsertRow(
    _is.DatabaseSession session,
    DailyWorkspaceStat row, {
    required _is.ColumnSelections<DailyWorkspaceStatTable> conflictColumns,
    _is.ColumnSelections<DailyWorkspaceStatTable>? updateColumns,
    _is.WhereExpressionBuilder<DailyWorkspaceStatTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DailyWorkspaceStat>(
      row,
      conflictColumns: conflictColumns(DailyWorkspaceStat.t),
      updateColumns: updateColumns?.call(DailyWorkspaceStat.t),
      updateWhere: updateWhere?.call(DailyWorkspaceStat.t),
      transaction: transaction,
    );
  }

  /// Updates all [DailyWorkspaceStat]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DailyWorkspaceStat>> update(
    _is.DatabaseSession session,
    List<DailyWorkspaceStat> rows, {
    _is.ColumnSelections<DailyWorkspaceStatTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DailyWorkspaceStat>(
      rows,
      columns: columns?.call(DailyWorkspaceStat.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DailyWorkspaceStat]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DailyWorkspaceStat> updateRow(
    _is.DatabaseSession session,
    DailyWorkspaceStat row, {
    _is.ColumnSelections<DailyWorkspaceStatTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DailyWorkspaceStat>(
      row,
      columns: columns?.call(DailyWorkspaceStat.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DailyWorkspaceStat] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DailyWorkspaceStat?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<DailyWorkspaceStatUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DailyWorkspaceStat>(
      id,
      columnValues: columnValues(DailyWorkspaceStat.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DailyWorkspaceStat]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DailyWorkspaceStat>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DailyWorkspaceStatUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DailyWorkspaceStatTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DailyWorkspaceStatTable>? orderBy,
    _is.OrderByListBuilder<DailyWorkspaceStatTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DailyWorkspaceStat>(
      columnValues: columnValues(DailyWorkspaceStat.t.updateTable),
      where: where(DailyWorkspaceStat.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DailyWorkspaceStat.t),
      orderByList: orderByList?.call(DailyWorkspaceStat.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DailyWorkspaceStat]s in the list and returns the deleted rows.
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
  Future<List<DailyWorkspaceStat>> delete(
    _is.DatabaseSession session,
    List<DailyWorkspaceStat> rows, {
    _is.OrderByBuilder<DailyWorkspaceStatTable>? orderBy,
    _is.OrderByListBuilder<DailyWorkspaceStatTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DailyWorkspaceStat>(
      rows,
      orderBy: orderBy?.call(DailyWorkspaceStat.t),
      orderByList: orderByList?.call(DailyWorkspaceStat.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DailyWorkspaceStat].
  Future<DailyWorkspaceStat> deleteRow(
    _is.DatabaseSession session,
    DailyWorkspaceStat row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DailyWorkspaceStat>(
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
  Future<List<DailyWorkspaceStat>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DailyWorkspaceStatTable> where,
    _is.OrderByBuilder<DailyWorkspaceStatTable>? orderBy,
    _is.OrderByListBuilder<DailyWorkspaceStatTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DailyWorkspaceStat>(
      where: where(DailyWorkspaceStat.t),
      orderBy: orderBy?.call(DailyWorkspaceStat.t),
      orderByList: orderByList?.call(DailyWorkspaceStat.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DailyWorkspaceStatTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DailyWorkspaceStat>(
      where: where?.call(DailyWorkspaceStat.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DailyWorkspaceStat] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DailyWorkspaceStatTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DailyWorkspaceStat>(
      where: where(DailyWorkspaceStat.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
