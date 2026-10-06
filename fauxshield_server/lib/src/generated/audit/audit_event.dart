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
import '../enums/actor_type.dart' as _iau4lzx2;

/// Append-only audit event. Every significant operator, machine, and consumer
/// action is recorded with its actor so changes can be traced back.
abstract class AuditEvent
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  AuditEvent._({
    this.id,
    required this.workspaceId,
    _iau4lzx2.ActorType? actorType,
    this.actorIdentifier,
    this.apiKeyId,
    required this.action,
    required this.targetType,
    this.targetId,
    this.metadataJson,
    this.ipAddress,
    DateTime? createdAt,
  }) : actorType = actorType ?? _iau4lzx2.ActorType.system,
       createdAt = createdAt ?? DateTime.now();

  factory AuditEvent({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    _iau4lzx2.ActorType? actorType,
    String? actorIdentifier,
    _is.UuidValue? apiKeyId,
    required String action,
    required String targetType,
    _is.UuidValue? targetId,
    String? metadataJson,
    String? ipAddress,
    DateTime? createdAt,
  }) = _AuditEventImpl;

  factory AuditEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditEvent(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      actorType: jsonSerialization['actorType'] == null
          ? null
          : _iau4lzx2.ActorType.fromJson(
              (jsonSerialization['actorType'] as String),
            ),
      actorIdentifier: jsonSerialization['actorIdentifier'] as String?,
      apiKeyId: jsonSerialization['apiKeyId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['apiKeyId']),
      action: jsonSerialization['action'] as String,
      targetType: jsonSerialization['targetType'] as String,
      targetId: jsonSerialization['targetId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['targetId']),
      metadataJson: jsonSerialization['metadataJson'] as String?,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = AuditEventTable();

  static const db = AuditEventRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  _iau4lzx2.ActorType actorType;

  /// Auth user identifier, api key id, or system component name.
  String? actorIdentifier;

  _is.UuidValue? apiKeyId;

  /// Dotted action name such as identity.generated or alert.resolved.
  String action;

  String targetType;

  _is.UuidValue? targetId;

  /// Structured context serialized as JSON.
  String? metadataJson;

  String? ipAddress;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AuditEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AuditEvent copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    _iau4lzx2.ActorType? actorType,
    String? actorIdentifier,
    _is.UuidValue? apiKeyId,
    String? action,
    String? targetType,
    _is.UuidValue? targetId,
    String? metadataJson,
    String? ipAddress,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditEvent',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'actorType': actorType.toJson(),
      if (actorIdentifier != null) 'actorIdentifier': actorIdentifier,
      if (apiKeyId != null) 'apiKeyId': apiKeyId?.toJson(),
      'action': action,
      'targetType': targetType,
      if (targetId != null) 'targetId': targetId?.toJson(),
      if (metadataJson != null) 'metadataJson': metadataJson,
      if (ipAddress != null) 'ipAddress': ipAddress,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuditEvent',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'actorType': actorType.toJson(),
      if (actorIdentifier != null) 'actorIdentifier': actorIdentifier,
      if (apiKeyId != null) 'apiKeyId': apiKeyId?.toJson(),
      'action': action,
      'targetType': targetType,
      if (targetId != null) 'targetId': targetId?.toJson(),
      if (metadataJson != null) 'metadataJson': metadataJson,
      if (ipAddress != null) 'ipAddress': ipAddress,
      'createdAt': createdAt.toJson(),
    };
  }

  static AuditEventInclude include() {
    return AuditEventInclude._();
  }

  static AuditEventIncludeList includeList({
    _is.WhereExpressionBuilder<AuditEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuditEventTable>? orderBy,
    _is.OrderByListBuilder<AuditEventTable>? orderByList,
    AuditEventInclude? include,
  }) {
    return AuditEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuditEvent.t),
      orderByList: orderByList?.call(AuditEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuditEventImpl extends AuditEvent {
  _AuditEventImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    _iau4lzx2.ActorType? actorType,
    String? actorIdentifier,
    _is.UuidValue? apiKeyId,
    required String action,
    required String targetType,
    _is.UuidValue? targetId,
    String? metadataJson,
    String? ipAddress,
    DateTime? createdAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         actorType: actorType,
         actorIdentifier: actorIdentifier,
         apiKeyId: apiKeyId,
         action: action,
         targetType: targetType,
         targetId: targetId,
         metadataJson: metadataJson,
         ipAddress: ipAddress,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AuditEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AuditEvent copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    _iau4lzx2.ActorType? actorType,
    Object? actorIdentifier = _Undefined,
    Object? apiKeyId = _Undefined,
    String? action,
    String? targetType,
    Object? targetId = _Undefined,
    Object? metadataJson = _Undefined,
    Object? ipAddress = _Undefined,
    DateTime? createdAt,
  }) {
    return AuditEvent(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      actorType: actorType ?? this.actorType,
      actorIdentifier: actorIdentifier is String?
          ? actorIdentifier
          : this.actorIdentifier,
      apiKeyId: apiKeyId is _is.UuidValue? ? apiKeyId : this.apiKeyId,
      action: action ?? this.action,
      targetType: targetType ?? this.targetType,
      targetId: targetId is _is.UuidValue? ? targetId : this.targetId,
      metadataJson: metadataJson is String? ? metadataJson : this.metadataJson,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AuditEventUpdateTable extends _is.UpdateTable<AuditEventTable> {
  AuditEventUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<_iau4lzx2.ActorType, _iau4lzx2.ActorType> actorType(
    _iau4lzx2.ActorType value,
  ) => _is.ColumnValue(
    table.actorType,
    value,
  );

  _is.ColumnValue<String, String> actorIdentifier(String? value) =>
      _is.ColumnValue(
        table.actorIdentifier,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> apiKeyId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.apiKeyId,
    value,
  );

  _is.ColumnValue<String, String> action(String value) => _is.ColumnValue(
    table.action,
    value,
  );

  _is.ColumnValue<String, String> targetType(String value) => _is.ColumnValue(
    table.targetType,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> targetId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.targetId,
    value,
  );

  _is.ColumnValue<String, String> metadataJson(String? value) =>
      _is.ColumnValue(
        table.metadataJson,
        value,
      );

  _is.ColumnValue<String, String> ipAddress(String? value) => _is.ColumnValue(
    table.ipAddress,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class AuditEventTable extends _is.Table<_is.UuidValue?> {
  AuditEventTable({super.tableRelation}) : super(tableName: 'audit_event') {
    updateTable = AuditEventUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    actorType = _is.ColumnEnum(
      'actorType',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    actorIdentifier = _is.ColumnString(
      'actorIdentifier',
      this,
    );
    apiKeyId = _is.ColumnUuid(
      'apiKeyId',
      this,
    );
    action = _is.ColumnString(
      'action',
      this,
    );
    targetType = _is.ColumnString(
      'targetType',
      this,
    );
    targetId = _is.ColumnUuid(
      'targetId',
      this,
    );
    metadataJson = _is.ColumnString(
      'metadataJson',
      this,
    );
    ipAddress = _is.ColumnString(
      'ipAddress',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final AuditEventUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  late final _is.ColumnEnum<_iau4lzx2.ActorType> actorType;

  /// Auth user identifier, api key id, or system component name.
  late final _is.ColumnString actorIdentifier;

  late final _is.ColumnUuid apiKeyId;

  /// Dotted action name such as identity.generated or alert.resolved.
  late final _is.ColumnString action;

  late final _is.ColumnString targetType;

  late final _is.ColumnUuid targetId;

  /// Structured context serialized as JSON.
  late final _is.ColumnString metadataJson;

  late final _is.ColumnString ipAddress;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    actorType,
    actorIdentifier,
    apiKeyId,
    action,
    targetType,
    targetId,
    metadataJson,
    ipAddress,
    createdAt,
  ];
}

class AuditEventInclude extends _is.IncludeObject {
  AuditEventInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => AuditEvent.t;
}

class AuditEventIncludeList extends _is.IncludeList {
  AuditEventIncludeList._({
    _is.WhereExpressionBuilder<AuditEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuditEvent.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => AuditEvent.t;
}

class AuditEventRepository {
  const AuditEventRepository._();

  /// Returns a list of [AuditEvent]s matching the given query parameters.
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
  Future<List<AuditEvent>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuditEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuditEventTable>? orderBy,
    _is.OrderByListBuilder<AuditEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AuditEvent>(
      where: where?.call(AuditEvent.t),
      orderBy: orderBy?.call(AuditEvent.t),
      orderByList: orderByList?.call(AuditEvent.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AuditEvent] matching the given query parameters.
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
  Future<AuditEvent?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuditEventTable>? where,
    int? offset,
    _is.OrderByBuilder<AuditEventTable>? orderBy,
    _is.OrderByListBuilder<AuditEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AuditEvent>(
      where: where?.call(AuditEvent.t),
      orderBy: orderBy?.call(AuditEvent.t),
      orderByList: orderByList?.call(AuditEvent.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AuditEvent] by its [id] or null if no such row exists.
  Future<AuditEvent?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AuditEvent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AuditEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [AuditEvent]s will have their `id` fields set.
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
  Future<List<AuditEvent>> insert(
    _is.DatabaseSession session,
    List<AuditEvent> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AuditEvent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AuditEvent] and returns the inserted row.
  ///
  /// The returned [AuditEvent] will have its `id` field set.
  Future<AuditEvent> insertRow(
    _is.DatabaseSession session,
    AuditEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuditEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AuditEvent]s in the list and returns the resulting rows.
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
  /// The returned [AuditEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuditEvent>> upsert(
    _is.DatabaseSession session,
    List<AuditEvent> rows, {
    required _is.ColumnSelections<AuditEventTable> conflictColumns,
    _is.ColumnSelections<AuditEventTable>? updateColumns,
    _is.WhereExpressionBuilder<AuditEventTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AuditEvent>(
      rows,
      conflictColumns: conflictColumns(AuditEvent.t),
      updateColumns: updateColumns?.call(AuditEvent.t),
      updateWhere: updateWhere?.call(AuditEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AuditEvent] and returns the resulting row.
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
  /// The returned [AuditEvent] will have its `id` field set.
  Future<AuditEvent?> upsertRow(
    _is.DatabaseSession session,
    AuditEvent row, {
    required _is.ColumnSelections<AuditEventTable> conflictColumns,
    _is.ColumnSelections<AuditEventTable>? updateColumns,
    _is.WhereExpressionBuilder<AuditEventTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AuditEvent>(
      row,
      conflictColumns: conflictColumns(AuditEvent.t),
      updateColumns: updateColumns?.call(AuditEvent.t),
      updateWhere: updateWhere?.call(AuditEvent.t),
      transaction: transaction,
    );
  }

  /// Updates all [AuditEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuditEvent>> update(
    _is.DatabaseSession session,
    List<AuditEvent> rows, {
    _is.ColumnSelections<AuditEventTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AuditEvent>(
      rows,
      columns: columns?.call(AuditEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AuditEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuditEvent> updateRow(
    _is.DatabaseSession session,
    AuditEvent row, {
    _is.ColumnSelections<AuditEventTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuditEvent>(
      row,
      columns: columns?.call(AuditEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuditEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AuditEvent?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<AuditEventUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AuditEvent>(
      id,
      columnValues: columnValues(AuditEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AuditEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuditEvent>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AuditEventUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AuditEventTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuditEventTable>? orderBy,
    _is.OrderByListBuilder<AuditEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AuditEvent>(
      columnValues: columnValues(AuditEvent.t.updateTable),
      where: where(AuditEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuditEvent.t),
      orderByList: orderByList?.call(AuditEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AuditEvent]s in the list and returns the deleted rows.
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
  Future<List<AuditEvent>> delete(
    _is.DatabaseSession session,
    List<AuditEvent> rows, {
    _is.OrderByBuilder<AuditEventTable>? orderBy,
    _is.OrderByListBuilder<AuditEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AuditEvent>(
      rows,
      orderBy: orderBy?.call(AuditEvent.t),
      orderByList: orderByList?.call(AuditEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AuditEvent].
  Future<AuditEvent> deleteRow(
    _is.DatabaseSession session,
    AuditEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuditEvent>(
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
  Future<List<AuditEvent>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AuditEventTable> where,
    _is.OrderByBuilder<AuditEventTable>? orderBy,
    _is.OrderByListBuilder<AuditEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AuditEvent>(
      where: where(AuditEvent.t),
      orderBy: orderBy?.call(AuditEvent.t),
      orderByList: orderByList?.call(AuditEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuditEventTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AuditEvent>(
      where: where?.call(AuditEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AuditEvent] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AuditEventTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AuditEvent>(
      where: where(AuditEvent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
