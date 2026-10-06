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
import 'package:fauxshield_server/src/generated/protocol.dart' as _ipgzzizd;
import 'package:serverpod/serverpod.dart' as _is;
import '../enums/api_scope.dart' as _itulxfrc;

/// An API key for machine access to the workspace. Only a hash of the key is
/// stored; the plaintext is shown exactly once when the key is created.
abstract class ApiKey
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ApiKey._({
    this.id,
    required this.workspaceId,
    required this.label,
    this.keyHash,
    required this.keyPrefix,
    required this.scopes,
    int? rateLimitPerMinute,
    this.lastUsedAt,
    bool? revoked,
    this.createdBy,
    DateTime? createdAt,
    this.revokedAt,
  }) : rateLimitPerMinute = rateLimitPerMinute ?? 120,
       revoked = revoked ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory ApiKey({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required String label,
    String? keyHash,
    required String keyPrefix,
    required List<_itulxfrc.ApiScope> scopes,
    int? rateLimitPerMinute,
    DateTime? lastUsedAt,
    bool? revoked,
    String? createdBy,
    DateTime? createdAt,
    DateTime? revokedAt,
  }) = _ApiKeyImpl;

  factory ApiKey.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApiKey(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      label: jsonSerialization['label'] as String,
      keyHash: jsonSerialization['keyHash'] as String?,
      keyPrefix: jsonSerialization['keyPrefix'] as String,
      scopes: _ipgzzizd.Protocol().deserialize<List<_itulxfrc.ApiScope>>(
        jsonSerialization['scopes'],
      ),
      rateLimitPerMinute: jsonSerialization['rateLimitPerMinute'] as int?,
      lastUsedAt: jsonSerialization['lastUsedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['lastUsedAt']),
      revoked: jsonSerialization['revoked'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['revoked']),
      createdBy: jsonSerialization['createdBy'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      revokedAt: jsonSerialization['revokedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['revokedAt']),
    );
  }

  static final t = ApiKeyTable();

  static const db = ApiKeyRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  String label;

  String? keyHash;

  /// First characters of the key so operators can identify it, for example fs_live_ab12.
  String keyPrefix;

  List<_itulxfrc.ApiScope> scopes;

  int rateLimitPerMinute;

  DateTime? lastUsedAt;

  bool revoked;

  String? createdBy;

  DateTime createdAt;

  DateTime? revokedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ApiKey]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ApiKey copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    String? label,
    String? keyHash,
    String? keyPrefix,
    List<_itulxfrc.ApiScope>? scopes,
    int? rateLimitPerMinute,
    DateTime? lastUsedAt,
    bool? revoked,
    String? createdBy,
    DateTime? createdAt,
    DateTime? revokedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApiKey',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'label': label,
      if (keyHash != null) 'keyHash': keyHash,
      'keyPrefix': keyPrefix,
      'scopes': scopes.toJson(valueToJson: (v) => v.toJson()),
      'rateLimitPerMinute': rateLimitPerMinute,
      if (lastUsedAt != null) 'lastUsedAt': lastUsedAt?.toJson(),
      'revoked': revoked,
      if (createdBy != null) 'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApiKey',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'label': label,
      'keyPrefix': keyPrefix,
      'scopes': scopes.toJson(valueToJson: (v) => v.toJson()),
      'rateLimitPerMinute': rateLimitPerMinute,
      if (lastUsedAt != null) 'lastUsedAt': lastUsedAt?.toJson(),
      'revoked': revoked,
      if (createdBy != null) 'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
    };
  }

  static ApiKeyInclude include() {
    return ApiKeyInclude._();
  }

  static ApiKeyIncludeList includeList({
    _is.WhereExpressionBuilder<ApiKeyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ApiKeyTable>? orderBy,
    _is.OrderByListBuilder<ApiKeyTable>? orderByList,
    ApiKeyInclude? include,
  }) {
    return ApiKeyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ApiKey.t),
      orderByList: orderByList?.call(ApiKey.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApiKeyImpl extends ApiKey {
  _ApiKeyImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required String label,
    String? keyHash,
    required String keyPrefix,
    required List<_itulxfrc.ApiScope> scopes,
    int? rateLimitPerMinute,
    DateTime? lastUsedAt,
    bool? revoked,
    String? createdBy,
    DateTime? createdAt,
    DateTime? revokedAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         label: label,
         keyHash: keyHash,
         keyPrefix: keyPrefix,
         scopes: scopes,
         rateLimitPerMinute: rateLimitPerMinute,
         lastUsedAt: lastUsedAt,
         revoked: revoked,
         createdBy: createdBy,
         createdAt: createdAt,
         revokedAt: revokedAt,
       );

  /// Returns a shallow copy of this [ApiKey]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ApiKey copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    String? label,
    Object? keyHash = _Undefined,
    String? keyPrefix,
    List<_itulxfrc.ApiScope>? scopes,
    int? rateLimitPerMinute,
    Object? lastUsedAt = _Undefined,
    bool? revoked,
    Object? createdBy = _Undefined,
    DateTime? createdAt,
    Object? revokedAt = _Undefined,
  }) {
    return ApiKey(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      label: label ?? this.label,
      keyHash: keyHash is String? ? keyHash : this.keyHash,
      keyPrefix: keyPrefix ?? this.keyPrefix,
      scopes: scopes ?? this.scopes.map((e0) => e0).toList(),
      rateLimitPerMinute: rateLimitPerMinute ?? this.rateLimitPerMinute,
      lastUsedAt: lastUsedAt is DateTime? ? lastUsedAt : this.lastUsedAt,
      revoked: revoked ?? this.revoked,
      createdBy: createdBy is String? ? createdBy : this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      revokedAt: revokedAt is DateTime? ? revokedAt : this.revokedAt,
    );
  }
}

class ApiKeyUpdateTable extends _is.UpdateTable<ApiKeyTable> {
  ApiKeyUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<String, String> label(String value) => _is.ColumnValue(
    table.label,
    value,
  );

  _is.ColumnValue<String, String> keyHash(String? value) => _is.ColumnValue(
    table.keyHash,
    value,
  );

  _is.ColumnValue<String, String> keyPrefix(String value) => _is.ColumnValue(
    table.keyPrefix,
    value,
  );

  _is.ColumnValue<List<_itulxfrc.ApiScope>, List<_itulxfrc.ApiScope>> scopes(
    List<_itulxfrc.ApiScope> value,
  ) => _is.ColumnValue(
    table.scopes,
    value,
  );

  _is.ColumnValue<int, int> rateLimitPerMinute(int value) => _is.ColumnValue(
    table.rateLimitPerMinute,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> lastUsedAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastUsedAt,
        value,
      );

  _is.ColumnValue<bool, bool> revoked(bool value) => _is.ColumnValue(
    table.revoked,
    value,
  );

  _is.ColumnValue<String, String> createdBy(String? value) => _is.ColumnValue(
    table.createdBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> revokedAt(DateTime? value) =>
      _is.ColumnValue(
        table.revokedAt,
        value,
      );
}

class ApiKeyTable extends _is.Table<_is.UuidValue?> {
  ApiKeyTable({super.tableRelation}) : super(tableName: 'api_key') {
    updateTable = ApiKeyUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    label = _is.ColumnString(
      'label',
      this,
    );
    keyHash = _is.ColumnString(
      'keyHash',
      this,
    );
    keyPrefix = _is.ColumnString(
      'keyPrefix',
      this,
    );
    scopes = _is.ColumnSerializable<List<_itulxfrc.ApiScope>>(
      'scopes',
      this,
    );
    rateLimitPerMinute = _is.ColumnInt(
      'rateLimitPerMinute',
      this,
      hasDefault: true,
    );
    lastUsedAt = _is.ColumnDateTime(
      'lastUsedAt',
      this,
    );
    revoked = _is.ColumnBool(
      'revoked',
      this,
      hasDefault: true,
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
    revokedAt = _is.ColumnDateTime(
      'revokedAt',
      this,
    );
  }

  late final ApiKeyUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  late final _is.ColumnString label;

  late final _is.ColumnString keyHash;

  /// First characters of the key so operators can identify it, for example fs_live_ab12.
  late final _is.ColumnString keyPrefix;

  late final _is.ColumnSerializable<List<_itulxfrc.ApiScope>> scopes;

  late final _is.ColumnInt rateLimitPerMinute;

  late final _is.ColumnDateTime lastUsedAt;

  late final _is.ColumnBool revoked;

  late final _is.ColumnString createdBy;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime revokedAt;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    label,
    keyHash,
    keyPrefix,
    scopes,
    rateLimitPerMinute,
    lastUsedAt,
    revoked,
    createdBy,
    createdAt,
    revokedAt,
  ];
}

class ApiKeyInclude extends _is.IncludeObject {
  ApiKeyInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ApiKey.t;
}

class ApiKeyIncludeList extends _is.IncludeList {
  ApiKeyIncludeList._({
    _is.WhereExpressionBuilder<ApiKeyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ApiKey.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ApiKey.t;
}

class ApiKeyRepository {
  const ApiKeyRepository._();

  /// Returns a list of [ApiKey]s matching the given query parameters.
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
  Future<List<ApiKey>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ApiKeyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ApiKeyTable>? orderBy,
    _is.OrderByListBuilder<ApiKeyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ApiKey>(
      where: where?.call(ApiKey.t),
      orderBy: orderBy?.call(ApiKey.t),
      orderByList: orderByList?.call(ApiKey.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ApiKey] matching the given query parameters.
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
  Future<ApiKey?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ApiKeyTable>? where,
    int? offset,
    _is.OrderByBuilder<ApiKeyTable>? orderBy,
    _is.OrderByListBuilder<ApiKeyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ApiKey>(
      where: where?.call(ApiKey.t),
      orderBy: orderBy?.call(ApiKey.t),
      orderByList: orderByList?.call(ApiKey.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ApiKey] by its [id] or null if no such row exists.
  Future<ApiKey?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ApiKey>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ApiKey]s in the list and returns the inserted rows.
  ///
  /// The returned [ApiKey]s will have their `id` fields set.
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
  Future<List<ApiKey>> insert(
    _is.DatabaseSession session,
    List<ApiKey> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ApiKey>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ApiKey] and returns the inserted row.
  ///
  /// The returned [ApiKey] will have its `id` field set.
  Future<ApiKey> insertRow(
    _is.DatabaseSession session,
    ApiKey row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ApiKey>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ApiKey]s in the list and returns the resulting rows.
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
  /// The returned [ApiKey]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ApiKey>> upsert(
    _is.DatabaseSession session,
    List<ApiKey> rows, {
    required _is.ColumnSelections<ApiKeyTable> conflictColumns,
    _is.ColumnSelections<ApiKeyTable>? updateColumns,
    _is.WhereExpressionBuilder<ApiKeyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ApiKey>(
      rows,
      conflictColumns: conflictColumns(ApiKey.t),
      updateColumns: updateColumns?.call(ApiKey.t),
      updateWhere: updateWhere?.call(ApiKey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ApiKey] and returns the resulting row.
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
  /// The returned [ApiKey] will have its `id` field set.
  Future<ApiKey?> upsertRow(
    _is.DatabaseSession session,
    ApiKey row, {
    required _is.ColumnSelections<ApiKeyTable> conflictColumns,
    _is.ColumnSelections<ApiKeyTable>? updateColumns,
    _is.WhereExpressionBuilder<ApiKeyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ApiKey>(
      row,
      conflictColumns: conflictColumns(ApiKey.t),
      updateColumns: updateColumns?.call(ApiKey.t),
      updateWhere: updateWhere?.call(ApiKey.t),
      transaction: transaction,
    );
  }

  /// Updates all [ApiKey]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ApiKey>> update(
    _is.DatabaseSession session,
    List<ApiKey> rows, {
    _is.ColumnSelections<ApiKeyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ApiKey>(
      rows,
      columns: columns?.call(ApiKey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ApiKey]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ApiKey> updateRow(
    _is.DatabaseSession session,
    ApiKey row, {
    _is.ColumnSelections<ApiKeyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ApiKey>(
      row,
      columns: columns?.call(ApiKey.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ApiKey] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ApiKey?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ApiKeyUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ApiKey>(
      id,
      columnValues: columnValues(ApiKey.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ApiKey]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ApiKey>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ApiKeyUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ApiKeyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ApiKeyTable>? orderBy,
    _is.OrderByListBuilder<ApiKeyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ApiKey>(
      columnValues: columnValues(ApiKey.t.updateTable),
      where: where(ApiKey.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ApiKey.t),
      orderByList: orderByList?.call(ApiKey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ApiKey]s in the list and returns the deleted rows.
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
  Future<List<ApiKey>> delete(
    _is.DatabaseSession session,
    List<ApiKey> rows, {
    _is.OrderByBuilder<ApiKeyTable>? orderBy,
    _is.OrderByListBuilder<ApiKeyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ApiKey>(
      rows,
      orderBy: orderBy?.call(ApiKey.t),
      orderByList: orderByList?.call(ApiKey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ApiKey].
  Future<ApiKey> deleteRow(
    _is.DatabaseSession session,
    ApiKey row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ApiKey>(
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
  Future<List<ApiKey>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ApiKeyTable> where,
    _is.OrderByBuilder<ApiKeyTable>? orderBy,
    _is.OrderByListBuilder<ApiKeyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ApiKey>(
      where: where(ApiKey.t),
      orderBy: orderBy?.call(ApiKey.t),
      orderByList: orderByList?.call(ApiKey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ApiKeyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ApiKey>(
      where: where?.call(ApiKey.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ApiKey] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ApiKeyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ApiKey>(
      where: where(ApiKey.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
