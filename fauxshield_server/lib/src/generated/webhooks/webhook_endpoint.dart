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
import '../enums/webhook_event_type.dart' as _ih562tcf;

/// A webhook receiver registered by the brand. Payloads are signed with an
/// HMAC-SHA256 secret that is stored encrypted with AES-256-GCM and bound to
/// the workspace and endpoint.
abstract class WebhookEndpoint
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  WebhookEndpoint._({
    this.id,
    required this.workspaceId,
    required this.url,
    this.description,
    required this.subscribedEvents,
    bool? enabled,
    int? consecutiveFailures,
    this.encryptedSecret,
    this.previousEncryptedSecret,
    this.secretRotatedAt,
    this.deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : enabled = enabled ?? true,
       consecutiveFailures = consecutiveFailures ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory WebhookEndpoint({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required String url,
    String? description,
    required List<_ih562tcf.WebhookEventType> subscribedEvents,
    bool? enabled,
    int? consecutiveFailures,
    String? encryptedSecret,
    String? previousEncryptedSecret,
    DateTime? secretRotatedAt,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WebhookEndpointImpl;

  factory WebhookEndpoint.fromJson(Map<String, dynamic> jsonSerialization) {
    return WebhookEndpoint(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      url: jsonSerialization['url'] as String,
      description: jsonSerialization['description'] as String?,
      subscribedEvents: _ipgzzizd.Protocol()
          .deserialize<List<_ih562tcf.WebhookEventType>>(
            jsonSerialization['subscribedEvents'],
          ),
      enabled: jsonSerialization['enabled'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
      consecutiveFailures: jsonSerialization['consecutiveFailures'] as int?,
      encryptedSecret: jsonSerialization['encryptedSecret'] as String?,
      previousEncryptedSecret:
          jsonSerialization['previousEncryptedSecret'] as String?,
      secretRotatedAt: jsonSerialization['secretRotatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['secretRotatedAt'],
            ),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = WebhookEndpointTable();

  static const db = WebhookEndpointRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  String url;

  String? description;

  List<_ih562tcf.WebhookEventType> subscribedEvents;

  bool enabled;

  int consecutiveFailures;

  /// AES-256-GCM encrypted signing secret. Server only.
  String? encryptedSecret;

  /// Previous secret kept during rotation so in-flight deliveries still verify.
  String? previousEncryptedSecret;

  DateTime? secretRotatedAt;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [WebhookEndpoint]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WebhookEndpoint copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    String? url,
    String? description,
    List<_ih562tcf.WebhookEventType>? subscribedEvents,
    bool? enabled,
    int? consecutiveFailures,
    String? encryptedSecret,
    String? previousEncryptedSecret,
    DateTime? secretRotatedAt,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WebhookEndpoint',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'url': url,
      if (description != null) 'description': description,
      'subscribedEvents': subscribedEvents.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'enabled': enabled,
      'consecutiveFailures': consecutiveFailures,
      if (encryptedSecret != null) 'encryptedSecret': encryptedSecret,
      if (previousEncryptedSecret != null)
        'previousEncryptedSecret': previousEncryptedSecret,
      if (secretRotatedAt != null) 'secretRotatedAt': secretRotatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WebhookEndpoint',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'url': url,
      if (description != null) 'description': description,
      'subscribedEvents': subscribedEvents.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'enabled': enabled,
      'consecutiveFailures': consecutiveFailures,
      if (secretRotatedAt != null) 'secretRotatedAt': secretRotatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static WebhookEndpointInclude include() {
    return WebhookEndpointInclude._();
  }

  static WebhookEndpointIncludeList includeList({
    _is.WhereExpressionBuilder<WebhookEndpointTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WebhookEndpointTable>? orderBy,
    _is.OrderByListBuilder<WebhookEndpointTable>? orderByList,
    WebhookEndpointInclude? include,
  }) {
    return WebhookEndpointIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WebhookEndpoint.t),
      orderByList: orderByList?.call(WebhookEndpoint.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WebhookEndpointImpl extends WebhookEndpoint {
  _WebhookEndpointImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required String url,
    String? description,
    required List<_ih562tcf.WebhookEventType> subscribedEvents,
    bool? enabled,
    int? consecutiveFailures,
    String? encryptedSecret,
    String? previousEncryptedSecret,
    DateTime? secretRotatedAt,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         url: url,
         description: description,
         subscribedEvents: subscribedEvents,
         enabled: enabled,
         consecutiveFailures: consecutiveFailures,
         encryptedSecret: encryptedSecret,
         previousEncryptedSecret: previousEncryptedSecret,
         secretRotatedAt: secretRotatedAt,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [WebhookEndpoint]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WebhookEndpoint copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    String? url,
    Object? description = _Undefined,
    List<_ih562tcf.WebhookEventType>? subscribedEvents,
    bool? enabled,
    int? consecutiveFailures,
    Object? encryptedSecret = _Undefined,
    Object? previousEncryptedSecret = _Undefined,
    Object? secretRotatedAt = _Undefined,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WebhookEndpoint(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      url: url ?? this.url,
      description: description is String? ? description : this.description,
      subscribedEvents:
          subscribedEvents ?? this.subscribedEvents.map((e0) => e0).toList(),
      enabled: enabled ?? this.enabled,
      consecutiveFailures: consecutiveFailures ?? this.consecutiveFailures,
      encryptedSecret: encryptedSecret is String?
          ? encryptedSecret
          : this.encryptedSecret,
      previousEncryptedSecret: previousEncryptedSecret is String?
          ? previousEncryptedSecret
          : this.previousEncryptedSecret,
      secretRotatedAt: secretRotatedAt is DateTime?
          ? secretRotatedAt
          : this.secretRotatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class WebhookEndpointUpdateTable extends _is.UpdateTable<WebhookEndpointTable> {
  WebhookEndpointUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<String, String> url(String value) => _is.ColumnValue(
    table.url,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<
    List<_ih562tcf.WebhookEventType>,
    List<_ih562tcf.WebhookEventType>
  >
  subscribedEvents(List<_ih562tcf.WebhookEventType> value) => _is.ColumnValue(
    table.subscribedEvents,
    value,
  );

  _is.ColumnValue<bool, bool> enabled(bool value) => _is.ColumnValue(
    table.enabled,
    value,
  );

  _is.ColumnValue<int, int> consecutiveFailures(int value) => _is.ColumnValue(
    table.consecutiveFailures,
    value,
  );

  _is.ColumnValue<String, String> encryptedSecret(String? value) =>
      _is.ColumnValue(
        table.encryptedSecret,
        value,
      );

  _is.ColumnValue<String, String> previousEncryptedSecret(String? value) =>
      _is.ColumnValue(
        table.previousEncryptedSecret,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> secretRotatedAt(DateTime? value) =>
      _is.ColumnValue(
        table.secretRotatedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _is.ColumnValue(
        table.deletedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class WebhookEndpointTable extends _is.Table<_is.UuidValue?> {
  WebhookEndpointTable({super.tableRelation})
    : super(tableName: 'webhook_endpoint') {
    updateTable = WebhookEndpointUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    url = _is.ColumnString(
      'url',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    subscribedEvents = _is.ColumnSerializable<List<_ih562tcf.WebhookEventType>>(
      'subscribedEvents',
      this,
    );
    enabled = _is.ColumnBool(
      'enabled',
      this,
      hasDefault: true,
    );
    consecutiveFailures = _is.ColumnInt(
      'consecutiveFailures',
      this,
      hasDefault: true,
    );
    encryptedSecret = _is.ColumnString(
      'encryptedSecret',
      this,
    );
    previousEncryptedSecret = _is.ColumnString(
      'previousEncryptedSecret',
      this,
    );
    secretRotatedAt = _is.ColumnDateTime(
      'secretRotatedAt',
      this,
    );
    deletedAt = _is.ColumnDateTime(
      'deletedAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final WebhookEndpointUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  late final _is.ColumnString url;

  late final _is.ColumnString description;

  late final _is.ColumnSerializable<List<_ih562tcf.WebhookEventType>>
  subscribedEvents;

  late final _is.ColumnBool enabled;

  late final _is.ColumnInt consecutiveFailures;

  /// AES-256-GCM encrypted signing secret. Server only.
  late final _is.ColumnString encryptedSecret;

  /// Previous secret kept during rotation so in-flight deliveries still verify.
  late final _is.ColumnString previousEncryptedSecret;

  late final _is.ColumnDateTime secretRotatedAt;

  late final _is.ColumnDateTime deletedAt;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    url,
    description,
    subscribedEvents,
    enabled,
    consecutiveFailures,
    encryptedSecret,
    previousEncryptedSecret,
    secretRotatedAt,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}

class WebhookEndpointInclude extends _is.IncludeObject {
  WebhookEndpointInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => WebhookEndpoint.t;
}

class WebhookEndpointIncludeList extends _is.IncludeList {
  WebhookEndpointIncludeList._({
    _is.WhereExpressionBuilder<WebhookEndpointTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WebhookEndpoint.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => WebhookEndpoint.t;
}

class WebhookEndpointRepository {
  const WebhookEndpointRepository._();

  /// Returns a list of [WebhookEndpoint]s matching the given query parameters.
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
  Future<List<WebhookEndpoint>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WebhookEndpointTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WebhookEndpointTable>? orderBy,
    _is.OrderByListBuilder<WebhookEndpointTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WebhookEndpoint>(
      where: where?.call(WebhookEndpoint.t),
      orderBy: orderBy?.call(WebhookEndpoint.t),
      orderByList: orderByList?.call(WebhookEndpoint.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [WebhookEndpoint] matching the given query parameters.
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
  Future<WebhookEndpoint?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WebhookEndpointTable>? where,
    int? offset,
    _is.OrderByBuilder<WebhookEndpointTable>? orderBy,
    _is.OrderByListBuilder<WebhookEndpointTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WebhookEndpoint>(
      where: where?.call(WebhookEndpoint.t),
      orderBy: orderBy?.call(WebhookEndpoint.t),
      orderByList: orderByList?.call(WebhookEndpoint.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WebhookEndpoint] by its [id] or null if no such row exists.
  Future<WebhookEndpoint?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WebhookEndpoint>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WebhookEndpoint]s in the list and returns the inserted rows.
  ///
  /// The returned [WebhookEndpoint]s will have their `id` fields set.
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
  Future<List<WebhookEndpoint>> insert(
    _is.DatabaseSession session,
    List<WebhookEndpoint> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<WebhookEndpoint>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [WebhookEndpoint] and returns the inserted row.
  ///
  /// The returned [WebhookEndpoint] will have its `id` field set.
  Future<WebhookEndpoint> insertRow(
    _is.DatabaseSession session,
    WebhookEndpoint row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<WebhookEndpoint>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [WebhookEndpoint]s in the list and returns the resulting rows.
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
  /// The returned [WebhookEndpoint]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WebhookEndpoint>> upsert(
    _is.DatabaseSession session,
    List<WebhookEndpoint> rows, {
    required _is.ColumnSelections<WebhookEndpointTable> conflictColumns,
    _is.ColumnSelections<WebhookEndpointTable>? updateColumns,
    _is.WhereExpressionBuilder<WebhookEndpointTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<WebhookEndpoint>(
      rows,
      conflictColumns: conflictColumns(WebhookEndpoint.t),
      updateColumns: updateColumns?.call(WebhookEndpoint.t),
      updateWhere: updateWhere?.call(WebhookEndpoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [WebhookEndpoint] and returns the resulting row.
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
  /// The returned [WebhookEndpoint] will have its `id` field set.
  Future<WebhookEndpoint?> upsertRow(
    _is.DatabaseSession session,
    WebhookEndpoint row, {
    required _is.ColumnSelections<WebhookEndpointTable> conflictColumns,
    _is.ColumnSelections<WebhookEndpointTable>? updateColumns,
    _is.WhereExpressionBuilder<WebhookEndpointTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<WebhookEndpoint>(
      row,
      conflictColumns: conflictColumns(WebhookEndpoint.t),
      updateColumns: updateColumns?.call(WebhookEndpoint.t),
      updateWhere: updateWhere?.call(WebhookEndpoint.t),
      transaction: transaction,
    );
  }

  /// Updates all [WebhookEndpoint]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WebhookEndpoint>> update(
    _is.DatabaseSession session,
    List<WebhookEndpoint> rows, {
    _is.ColumnSelections<WebhookEndpointTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<WebhookEndpoint>(
      rows,
      columns: columns?.call(WebhookEndpoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [WebhookEndpoint]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WebhookEndpoint> updateRow(
    _is.DatabaseSession session,
    WebhookEndpoint row, {
    _is.ColumnSelections<WebhookEndpointTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<WebhookEndpoint>(
      row,
      columns: columns?.call(WebhookEndpoint.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WebhookEndpoint] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WebhookEndpoint?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<WebhookEndpointUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<WebhookEndpoint>(
      id,
      columnValues: columnValues(WebhookEndpoint.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WebhookEndpoint]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WebhookEndpoint>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<WebhookEndpointUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<WebhookEndpointTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WebhookEndpointTable>? orderBy,
    _is.OrderByListBuilder<WebhookEndpointTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<WebhookEndpoint>(
      columnValues: columnValues(WebhookEndpoint.t.updateTable),
      where: where(WebhookEndpoint.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WebhookEndpoint.t),
      orderByList: orderByList?.call(WebhookEndpoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [WebhookEndpoint]s in the list and returns the deleted rows.
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
  Future<List<WebhookEndpoint>> delete(
    _is.DatabaseSession session,
    List<WebhookEndpoint> rows, {
    _is.OrderByBuilder<WebhookEndpointTable>? orderBy,
    _is.OrderByListBuilder<WebhookEndpointTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<WebhookEndpoint>(
      rows,
      orderBy: orderBy?.call(WebhookEndpoint.t),
      orderByList: orderByList?.call(WebhookEndpoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [WebhookEndpoint].
  Future<WebhookEndpoint> deleteRow(
    _is.DatabaseSession session,
    WebhookEndpoint row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WebhookEndpoint>(
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
  Future<List<WebhookEndpoint>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WebhookEndpointTable> where,
    _is.OrderByBuilder<WebhookEndpointTable>? orderBy,
    _is.OrderByListBuilder<WebhookEndpointTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<WebhookEndpoint>(
      where: where(WebhookEndpoint.t),
      orderBy: orderBy?.call(WebhookEndpoint.t),
      orderByList: orderByList?.call(WebhookEndpoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WebhookEndpointTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<WebhookEndpoint>(
      where: where?.call(WebhookEndpoint.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WebhookEndpoint] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WebhookEndpointTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WebhookEndpoint>(
      where: where(WebhookEndpoint.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
