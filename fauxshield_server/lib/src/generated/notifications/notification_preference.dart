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
import '../enums/alert_severity.dart' as _ivfuu0vh;
import '../enums/notification_channel.dart' as _ico4u50j;

/// Per-member preference for one notification channel.
abstract class NotificationPreference
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  NotificationPreference._({
    this.id,
    required this.workspaceId,
    required this.userIdentifier,
    required this.channel,
    bool? enabled,
    _ivfuu0vh.AlertSeverity? minSeverity,
    this.email,
    DateTime? updatedAt,
  }) : enabled = enabled ?? true,
       minSeverity = minSeverity ?? _ivfuu0vh.AlertSeverity.low,
       updatedAt = updatedAt ?? DateTime.now();

  factory NotificationPreference({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required String userIdentifier,
    required _ico4u50j.NotificationChannel channel,
    bool? enabled,
    _ivfuu0vh.AlertSeverity? minSeverity,
    String? email,
    DateTime? updatedAt,
  }) = _NotificationPreferenceImpl;

  factory NotificationPreference.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationPreference(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      channel: _ico4u50j.NotificationChannel.fromJson(
        (jsonSerialization['channel'] as String),
      ),
      enabled: jsonSerialization['enabled'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
      minSeverity: jsonSerialization['minSeverity'] == null
          ? null
          : _ivfuu0vh.AlertSeverity.fromJson(
              (jsonSerialization['minSeverity'] as String),
            ),
      email: jsonSerialization['email'] as String?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = NotificationPreferenceTable();

  static const db = NotificationPreferenceRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  String userIdentifier;

  _ico4u50j.NotificationChannel channel;

  bool enabled;

  /// Only notify for alerts at or above this severity.
  _ivfuu0vh.AlertSeverity minSeverity;

  String? email;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotificationPreference]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotificationPreference copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    String? userIdentifier,
    _ico4u50j.NotificationChannel? channel,
    bool? enabled,
    _ivfuu0vh.AlertSeverity? minSeverity,
    String? email,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationPreference',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'userIdentifier': userIdentifier,
      'channel': channel.toJson(),
      'enabled': enabled,
      'minSeverity': minSeverity.toJson(),
      if (email != null) 'email': email,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotificationPreference',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'userIdentifier': userIdentifier,
      'channel': channel.toJson(),
      'enabled': enabled,
      'minSeverity': minSeverity.toJson(),
      if (email != null) 'email': email,
      'updatedAt': updatedAt.toJson(),
    };
  }

  static NotificationPreferenceInclude include() {
    return NotificationPreferenceInclude._();
  }

  static NotificationPreferenceIncludeList includeList({
    _is.WhereExpressionBuilder<NotificationPreferenceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotificationPreferenceTable>? orderBy,
    _is.OrderByListBuilder<NotificationPreferenceTable>? orderByList,
    NotificationPreferenceInclude? include,
  }) {
    return NotificationPreferenceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationPreference.t),
      orderByList: orderByList?.call(NotificationPreference.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationPreferenceImpl extends NotificationPreference {
  _NotificationPreferenceImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required String userIdentifier,
    required _ico4u50j.NotificationChannel channel,
    bool? enabled,
    _ivfuu0vh.AlertSeverity? minSeverity,
    String? email,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         userIdentifier: userIdentifier,
         channel: channel,
         enabled: enabled,
         minSeverity: minSeverity,
         email: email,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NotificationPreference]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotificationPreference copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    String? userIdentifier,
    _ico4u50j.NotificationChannel? channel,
    bool? enabled,
    _ivfuu0vh.AlertSeverity? minSeverity,
    Object? email = _Undefined,
    DateTime? updatedAt,
  }) {
    return NotificationPreference(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      channel: channel ?? this.channel,
      enabled: enabled ?? this.enabled,
      minSeverity: minSeverity ?? this.minSeverity,
      email: email is String? ? email : this.email,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotificationPreferenceUpdateTable
    extends _is.UpdateTable<NotificationPreferenceTable> {
  NotificationPreferenceUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<String, String> userIdentifier(String value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );

  _is.ColumnValue<_ico4u50j.NotificationChannel, _ico4u50j.NotificationChannel>
  channel(_ico4u50j.NotificationChannel value) => _is.ColumnValue(
    table.channel,
    value,
  );

  _is.ColumnValue<bool, bool> enabled(bool value) => _is.ColumnValue(
    table.enabled,
    value,
  );

  _is.ColumnValue<_ivfuu0vh.AlertSeverity, _ivfuu0vh.AlertSeverity> minSeverity(
    _ivfuu0vh.AlertSeverity value,
  ) => _is.ColumnValue(
    table.minSeverity,
    value,
  );

  _is.ColumnValue<String, String> email(String? value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class NotificationPreferenceTable extends _is.Table<_is.UuidValue?> {
  NotificationPreferenceTable({super.tableRelation})
    : super(tableName: 'notification_preference') {
    updateTable = NotificationPreferenceUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
    channel = _is.ColumnEnum(
      'channel',
      this,
      _is.EnumSerialization.byName,
    );
    enabled = _is.ColumnBool(
      'enabled',
      this,
      hasDefault: true,
    );
    minSeverity = _is.ColumnEnum(
      'minSeverity',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final NotificationPreferenceUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  late final _is.ColumnString userIdentifier;

  late final _is.ColumnEnum<_ico4u50j.NotificationChannel> channel;

  late final _is.ColumnBool enabled;

  /// Only notify for alerts at or above this severity.
  late final _is.ColumnEnum<_ivfuu0vh.AlertSeverity> minSeverity;

  late final _is.ColumnString email;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    userIdentifier,
    channel,
    enabled,
    minSeverity,
    email,
    updatedAt,
  ];
}

class NotificationPreferenceInclude extends _is.IncludeObject {
  NotificationPreferenceInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => NotificationPreference.t;
}

class NotificationPreferenceIncludeList extends _is.IncludeList {
  NotificationPreferenceIncludeList._({
    _is.WhereExpressionBuilder<NotificationPreferenceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotificationPreference.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => NotificationPreference.t;
}

class NotificationPreferenceRepository {
  const NotificationPreferenceRepository._();

  /// Returns a list of [NotificationPreference]s matching the given query parameters.
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
  Future<List<NotificationPreference>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotificationPreferenceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotificationPreferenceTable>? orderBy,
    _is.OrderByListBuilder<NotificationPreferenceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotificationPreference>(
      where: where?.call(NotificationPreference.t),
      orderBy: orderBy?.call(NotificationPreference.t),
      orderByList: orderByList?.call(NotificationPreference.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotificationPreference] matching the given query parameters.
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
  Future<NotificationPreference?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotificationPreferenceTable>? where,
    int? offset,
    _is.OrderByBuilder<NotificationPreferenceTable>? orderBy,
    _is.OrderByListBuilder<NotificationPreferenceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotificationPreference>(
      where: where?.call(NotificationPreference.t),
      orderBy: orderBy?.call(NotificationPreference.t),
      orderByList: orderByList?.call(NotificationPreference.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotificationPreference] by its [id] or null if no such row exists.
  Future<NotificationPreference?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotificationPreference>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotificationPreference]s in the list and returns the inserted rows.
  ///
  /// The returned [NotificationPreference]s will have their `id` fields set.
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
  Future<List<NotificationPreference>> insert(
    _is.DatabaseSession session,
    List<NotificationPreference> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NotificationPreference>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NotificationPreference] and returns the inserted row.
  ///
  /// The returned [NotificationPreference] will have its `id` field set.
  Future<NotificationPreference> insertRow(
    _is.DatabaseSession session,
    NotificationPreference row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotificationPreference>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NotificationPreference]s in the list and returns the resulting rows.
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
  /// The returned [NotificationPreference]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotificationPreference>> upsert(
    _is.DatabaseSession session,
    List<NotificationPreference> rows, {
    required _is.ColumnSelections<NotificationPreferenceTable> conflictColumns,
    _is.ColumnSelections<NotificationPreferenceTable>? updateColumns,
    _is.WhereExpressionBuilder<NotificationPreferenceTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NotificationPreference>(
      rows,
      conflictColumns: conflictColumns(NotificationPreference.t),
      updateColumns: updateColumns?.call(NotificationPreference.t),
      updateWhere: updateWhere?.call(NotificationPreference.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NotificationPreference] and returns the resulting row.
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
  /// The returned [NotificationPreference] will have its `id` field set.
  Future<NotificationPreference?> upsertRow(
    _is.DatabaseSession session,
    NotificationPreference row, {
    required _is.ColumnSelections<NotificationPreferenceTable> conflictColumns,
    _is.ColumnSelections<NotificationPreferenceTable>? updateColumns,
    _is.WhereExpressionBuilder<NotificationPreferenceTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NotificationPreference>(
      row,
      conflictColumns: conflictColumns(NotificationPreference.t),
      updateColumns: updateColumns?.call(NotificationPreference.t),
      updateWhere: updateWhere?.call(NotificationPreference.t),
      transaction: transaction,
    );
  }

  /// Updates all [NotificationPreference]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotificationPreference>> update(
    _is.DatabaseSession session,
    List<NotificationPreference> rows, {
    _is.ColumnSelections<NotificationPreferenceTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NotificationPreference>(
      rows,
      columns: columns?.call(NotificationPreference.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NotificationPreference]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotificationPreference> updateRow(
    _is.DatabaseSession session,
    NotificationPreference row, {
    _is.ColumnSelections<NotificationPreferenceTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotificationPreference>(
      row,
      columns: columns?.call(NotificationPreference.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationPreference] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotificationPreference?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<NotificationPreferenceUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NotificationPreference>(
      id,
      columnValues: columnValues(NotificationPreference.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotificationPreference]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotificationPreference>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NotificationPreferenceUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<NotificationPreferenceTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotificationPreferenceTable>? orderBy,
    _is.OrderByListBuilder<NotificationPreferenceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NotificationPreference>(
      columnValues: columnValues(NotificationPreference.t.updateTable),
      where: where(NotificationPreference.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationPreference.t),
      orderByList: orderByList?.call(NotificationPreference.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NotificationPreference]s in the list and returns the deleted rows.
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
  Future<List<NotificationPreference>> delete(
    _is.DatabaseSession session,
    List<NotificationPreference> rows, {
    _is.OrderByBuilder<NotificationPreferenceTable>? orderBy,
    _is.OrderByListBuilder<NotificationPreferenceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NotificationPreference>(
      rows,
      orderBy: orderBy?.call(NotificationPreference.t),
      orderByList: orderByList?.call(NotificationPreference.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NotificationPreference].
  Future<NotificationPreference> deleteRow(
    _is.DatabaseSession session,
    NotificationPreference row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotificationPreference>(
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
  Future<List<NotificationPreference>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotificationPreferenceTable> where,
    _is.OrderByBuilder<NotificationPreferenceTable>? orderBy,
    _is.OrderByListBuilder<NotificationPreferenceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NotificationPreference>(
      where: where(NotificationPreference.t),
      orderBy: orderBy?.call(NotificationPreference.t),
      orderByList: orderByList?.call(NotificationPreference.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotificationPreferenceTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NotificationPreference>(
      where: where?.call(NotificationPreference.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotificationPreference] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotificationPreferenceTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotificationPreference>(
      where: where(NotificationPreference.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
