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

/// A field scan captured while offline by an inspector device. The table is
/// synchronized between the device and the server with Serverpod's offline sync,
/// and a recurring task converts pending scans into real verification sessions,
/// so fraud intelligence sees activity that happened without connectivity.
abstract class OfflineScanRecord
    implements _isd.TableRow<_isc.UuidValue?>, _isc.ProtocolSerialization {
  OfflineScanRecord._({
    this.id,
    this.spaceId,
    this.workspaceId,
    required this.deviceId,
    this.deviceFingerprint,
    this.identityId,
    required this.qrToken,
    required this.scannedAt,
    this.latitude,
    this.longitude,
    this.country,
    this.city,
    this.provisionalOutcome,
    bool? processed,
    this.processedAt,
    this.verdictJson,
    DateTime? createdAt,
  }) : processed = processed ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory OfflineScanRecord({
    _isc.UuidValue? id,
    int? spaceId,
    _isc.UuidValue? workspaceId,
    required String deviceId,
    String? deviceFingerprint,
    _isc.UuidValue? identityId,
    required String qrToken,
    required DateTime scannedAt,
    double? latitude,
    double? longitude,
    String? country,
    String? city,
    String? provisionalOutcome,
    bool? processed,
    DateTime? processedAt,
    String? verdictJson,
    DateTime? createdAt,
  }) = _OfflineScanRecordImpl;

  factory OfflineScanRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return OfflineScanRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      spaceId: jsonSerialization['spaceId'] as int?,
      workspaceId: jsonSerialization['workspaceId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['workspaceId'],
            ),
      deviceId: jsonSerialization['deviceId'] as String,
      deviceFingerprint: jsonSerialization['deviceFingerprint'] as String?,
      identityId: jsonSerialization['identityId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['identityId'],
            ),
      qrToken: jsonSerialization['qrToken'] as String,
      scannedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['scannedAt'],
      ),
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      country: jsonSerialization['country'] as String?,
      city: jsonSerialization['city'] as String?,
      provisionalOutcome: jsonSerialization['provisionalOutcome'] as String?,
      processed: jsonSerialization['processed'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['processed']),
      processedAt: jsonSerialization['processedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['processedAt'],
            ),
      verdictJson: jsonSerialization['verdictJson'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = OfflineScanRecordTable();

  static const db = OfflineScanRecordRepository._();

  @override
  _isc.UuidValue? id;

  /// The space owning this row. Maintained by the sync engine.
  int? spaceId;

  /// Workspace the inspector belongs to. Null only for legacy rows.
  _isc.UuidValue? workspaceId;

  /// Stable id for the device that captured the scan.
  String deviceId;

  String? deviceFingerprint;

  /// Null when the device could not resolve the token from its cached catalog.
  _isc.UuidValue? identityId;

  String qrToken;

  DateTime scannedAt;

  double? latitude;

  double? longitude;

  String? country;

  String? city;

  /// Provisional outcome computed on the device from the cached catalog.
  String? provisionalOutcome;

  /// Set by the server after the scan is converted into a verification session.
  bool processed;

  DateTime? processedAt;

  /// Verdict returned by the server after processing, serialized as JSON.
  String? verdictJson;

  DateTime createdAt;

  @override
  _isd.Table<_isc.UuidValue?> get table => t;

  /// Returns a shallow copy of this [OfflineScanRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  OfflineScanRecord copyWith({
    _isc.UuidValue? id,
    int? spaceId,
    _isc.UuidValue? workspaceId,
    String? deviceId,
    String? deviceFingerprint,
    _isc.UuidValue? identityId,
    String? qrToken,
    DateTime? scannedAt,
    double? latitude,
    double? longitude,
    String? country,
    String? city,
    String? provisionalOutcome,
    bool? processed,
    DateTime? processedAt,
    String? verdictJson,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OfflineScanRecord',
      if (id != null) 'id': id?.toJson(),
      if (spaceId != null) 'spaceId': spaceId,
      if (workspaceId != null) 'workspaceId': workspaceId?.toJson(),
      'deviceId': deviceId,
      if (deviceFingerprint != null) 'deviceFingerprint': deviceFingerprint,
      if (identityId != null) 'identityId': identityId?.toJson(),
      'qrToken': qrToken,
      'scannedAt': scannedAt.toJson(),
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      if (provisionalOutcome != null) 'provisionalOutcome': provisionalOutcome,
      'processed': processed,
      if (processedAt != null) 'processedAt': processedAt?.toJson(),
      if (verdictJson != null) 'verdictJson': verdictJson,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OfflineScanRecord',
      if (id != null) 'id': id?.toJson(),
      if (spaceId != null) 'spaceId': spaceId,
      if (workspaceId != null) 'workspaceId': workspaceId?.toJson(),
      'deviceId': deviceId,
      if (deviceFingerprint != null) 'deviceFingerprint': deviceFingerprint,
      if (identityId != null) 'identityId': identityId?.toJson(),
      'qrToken': qrToken,
      'scannedAt': scannedAt.toJson(),
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      if (provisionalOutcome != null) 'provisionalOutcome': provisionalOutcome,
      'processed': processed,
      if (processedAt != null) 'processedAt': processedAt?.toJson(),
      if (verdictJson != null) 'verdictJson': verdictJson,
      'createdAt': createdAt.toJson(),
    };
  }

  static OfflineScanRecordInclude include() {
    return OfflineScanRecordInclude._();
  }

  static OfflineScanRecordIncludeList includeList({
    _isd.WhereExpressionBuilder<OfflineScanRecordTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<OfflineScanRecordTable>? orderBy,
    _isd.OrderByListBuilder<OfflineScanRecordTable>? orderByList,
    OfflineScanRecordInclude? include,
  }) {
    return OfflineScanRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OfflineScanRecord.t),
      orderByList: orderByList?.call(OfflineScanRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OfflineScanRecordImpl extends OfflineScanRecord {
  _OfflineScanRecordImpl({
    _isc.UuidValue? id,
    int? spaceId,
    _isc.UuidValue? workspaceId,
    required String deviceId,
    String? deviceFingerprint,
    _isc.UuidValue? identityId,
    required String qrToken,
    required DateTime scannedAt,
    double? latitude,
    double? longitude,
    String? country,
    String? city,
    String? provisionalOutcome,
    bool? processed,
    DateTime? processedAt,
    String? verdictJson,
    DateTime? createdAt,
  }) : super._(
         id: id,
         spaceId: spaceId,
         workspaceId: workspaceId,
         deviceId: deviceId,
         deviceFingerprint: deviceFingerprint,
         identityId: identityId,
         qrToken: qrToken,
         scannedAt: scannedAt,
         latitude: latitude,
         longitude: longitude,
         country: country,
         city: city,
         provisionalOutcome: provisionalOutcome,
         processed: processed,
         processedAt: processedAt,
         verdictJson: verdictJson,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [OfflineScanRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  OfflineScanRecord copyWith({
    Object? id = _Undefined,
    Object? spaceId = _Undefined,
    Object? workspaceId = _Undefined,
    String? deviceId,
    Object? deviceFingerprint = _Undefined,
    Object? identityId = _Undefined,
    String? qrToken,
    DateTime? scannedAt,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? country = _Undefined,
    Object? city = _Undefined,
    Object? provisionalOutcome = _Undefined,
    bool? processed,
    Object? processedAt = _Undefined,
    Object? verdictJson = _Undefined,
    DateTime? createdAt,
  }) {
    return OfflineScanRecord(
      id: id is _isc.UuidValue? ? id : this.id,
      spaceId: spaceId is int? ? spaceId : this.spaceId,
      workspaceId: workspaceId is _isc.UuidValue?
          ? workspaceId
          : this.workspaceId,
      deviceId: deviceId ?? this.deviceId,
      deviceFingerprint: deviceFingerprint is String?
          ? deviceFingerprint
          : this.deviceFingerprint,
      identityId: identityId is _isc.UuidValue? ? identityId : this.identityId,
      qrToken: qrToken ?? this.qrToken,
      scannedAt: scannedAt ?? this.scannedAt,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      country: country is String? ? country : this.country,
      city: city is String? ? city : this.city,
      provisionalOutcome: provisionalOutcome is String?
          ? provisionalOutcome
          : this.provisionalOutcome,
      processed: processed ?? this.processed,
      processedAt: processedAt is DateTime? ? processedAt : this.processedAt,
      verdictJson: verdictJson is String? ? verdictJson : this.verdictJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class OfflineScanRecordUpdateTable
    extends _isd.UpdateTable<OfflineScanRecordTable> {
  OfflineScanRecordUpdateTable(super.table);

  _isd.ColumnValue<int, int> spaceId(int? value) => _isd.ColumnValue(
    table.spaceId,
    value,
  );

  _isd.ColumnValue<_isc.UuidValue, _isc.UuidValue> workspaceId(
    _isc.UuidValue? value,
  ) => _isd.ColumnValue(
    table.workspaceId,
    value,
  );

  _isd.ColumnValue<String, String> deviceId(String value) => _isd.ColumnValue(
    table.deviceId,
    value,
  );

  _isd.ColumnValue<String, String> deviceFingerprint(String? value) =>
      _isd.ColumnValue(
        table.deviceFingerprint,
        value,
      );

  _isd.ColumnValue<_isc.UuidValue, _isc.UuidValue> identityId(
    _isc.UuidValue? value,
  ) => _isd.ColumnValue(
    table.identityId,
    value,
  );

  _isd.ColumnValue<String, String> qrToken(String value) => _isd.ColumnValue(
    table.qrToken,
    value,
  );

  _isd.ColumnValue<DateTime, DateTime> scannedAt(DateTime value) =>
      _isd.ColumnValue(
        table.scannedAt,
        value,
      );

  _isd.ColumnValue<double, double> latitude(double? value) => _isd.ColumnValue(
    table.latitude,
    value,
  );

  _isd.ColumnValue<double, double> longitude(double? value) => _isd.ColumnValue(
    table.longitude,
    value,
  );

  _isd.ColumnValue<String, String> country(String? value) => _isd.ColumnValue(
    table.country,
    value,
  );

  _isd.ColumnValue<String, String> city(String? value) => _isd.ColumnValue(
    table.city,
    value,
  );

  _isd.ColumnValue<String, String> provisionalOutcome(String? value) =>
      _isd.ColumnValue(
        table.provisionalOutcome,
        value,
      );

  _isd.ColumnValue<bool, bool> processed(bool value) => _isd.ColumnValue(
    table.processed,
    value,
  );

  _isd.ColumnValue<DateTime, DateTime> processedAt(DateTime? value) =>
      _isd.ColumnValue(
        table.processedAt,
        value,
      );

  _isd.ColumnValue<String, String> verdictJson(String? value) =>
      _isd.ColumnValue(
        table.verdictJson,
        value,
      );

  _isd.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _isd.ColumnValue(
        table.createdAt,
        value,
      );
}

class OfflineScanRecordTable extends _isd.Table<_isc.UuidValue?> {
  OfflineScanRecordTable({super.tableRelation})
    : super(tableName: 'offline_scan_record') {
    updateTable = OfflineScanRecordUpdateTable(this);
    spaceId = _isd.ColumnInt(
      'spaceId',
      this,
    );
    workspaceId = _isd.ColumnUuid(
      'workspaceId',
      this,
    );
    deviceId = _isd.ColumnString(
      'deviceId',
      this,
    );
    deviceFingerprint = _isd.ColumnString(
      'deviceFingerprint',
      this,
    );
    identityId = _isd.ColumnUuid(
      'identityId',
      this,
    );
    qrToken = _isd.ColumnString(
      'qrToken',
      this,
    );
    scannedAt = _isd.ColumnDateTime(
      'scannedAt',
      this,
    );
    latitude = _isd.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _isd.ColumnDouble(
      'longitude',
      this,
    );
    country = _isd.ColumnString(
      'country',
      this,
    );
    city = _isd.ColumnString(
      'city',
      this,
    );
    provisionalOutcome = _isd.ColumnString(
      'provisionalOutcome',
      this,
    );
    processed = _isd.ColumnBool(
      'processed',
      this,
      hasDefault: true,
    );
    processedAt = _isd.ColumnDateTime(
      'processedAt',
      this,
    );
    verdictJson = _isd.ColumnString(
      'verdictJson',
      this,
    );
    createdAt = _isd.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final OfflineScanRecordUpdateTable updateTable;

  /// The space owning this row. Maintained by the sync engine.
  late final _isd.ColumnInt spaceId;

  /// Workspace the inspector belongs to. Null only for legacy rows.
  late final _isd.ColumnUuid workspaceId;

  /// Stable id for the device that captured the scan.
  late final _isd.ColumnString deviceId;

  late final _isd.ColumnString deviceFingerprint;

  /// Null when the device could not resolve the token from its cached catalog.
  late final _isd.ColumnUuid identityId;

  late final _isd.ColumnString qrToken;

  late final _isd.ColumnDateTime scannedAt;

  late final _isd.ColumnDouble latitude;

  late final _isd.ColumnDouble longitude;

  late final _isd.ColumnString country;

  late final _isd.ColumnString city;

  /// Provisional outcome computed on the device from the cached catalog.
  late final _isd.ColumnString provisionalOutcome;

  /// Set by the server after the scan is converted into a verification session.
  late final _isd.ColumnBool processed;

  late final _isd.ColumnDateTime processedAt;

  /// Verdict returned by the server after processing, serialized as JSON.
  late final _isd.ColumnString verdictJson;

  late final _isd.ColumnDateTime createdAt;

  @override
  List<_isd.Column> get columns => [
    id,
    spaceId,
    workspaceId,
    deviceId,
    deviceFingerprint,
    identityId,
    qrToken,
    scannedAt,
    latitude,
    longitude,
    country,
    city,
    provisionalOutcome,
    processed,
    processedAt,
    verdictJson,
    createdAt,
  ];
}

class OfflineScanRecordInclude extends _isd.IncludeObject {
  OfflineScanRecordInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<_isc.UuidValue?> get table => OfflineScanRecord.t;
}

class OfflineScanRecordIncludeList extends _isd.IncludeList {
  OfflineScanRecordIncludeList._({
    _isd.WhereExpressionBuilder<OfflineScanRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OfflineScanRecord.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<_isc.UuidValue?> get table => OfflineScanRecord.t;
}

class OfflineScanRecordRepository {
  const OfflineScanRecordRepository._();

  /// Returns a list of [OfflineScanRecord]s matching the given query parameters.
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
  Future<List<OfflineScanRecord>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<OfflineScanRecordTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<OfflineScanRecordTable>? orderBy,
    _isd.OrderByListBuilder<OfflineScanRecordTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OfflineScanRecord>(
      where: where?.call(OfflineScanRecord.t),
      orderBy: orderBy?.call(OfflineScanRecord.t),
      orderByList: orderByList?.call(OfflineScanRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OfflineScanRecord] matching the given query parameters.
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
  Future<OfflineScanRecord?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<OfflineScanRecordTable>? where,
    int? offset,
    _isd.OrderByBuilder<OfflineScanRecordTable>? orderBy,
    _isd.OrderByListBuilder<OfflineScanRecordTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OfflineScanRecord>(
      where: where?.call(OfflineScanRecord.t),
      orderBy: orderBy?.call(OfflineScanRecord.t),
      orderByList: orderByList?.call(OfflineScanRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OfflineScanRecord] by its [id] or null if no such row exists.
  Future<OfflineScanRecord?> findById(
    _isd.DatabaseSession session,
    _isc.UuidValue id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OfflineScanRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OfflineScanRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [OfflineScanRecord]s will have their `id` fields set.
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
  Future<List<OfflineScanRecord>> insert(
    _isd.DatabaseSession session,
    List<OfflineScanRecord> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<OfflineScanRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [OfflineScanRecord] and returns the inserted row.
  ///
  /// The returned [OfflineScanRecord] will have its `id` field set.
  Future<OfflineScanRecord> insertRow(
    _isd.DatabaseSession session,
    OfflineScanRecord row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<OfflineScanRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [OfflineScanRecord]s in the list and returns the resulting rows.
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
  /// The returned [OfflineScanRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OfflineScanRecord>> upsert(
    _isd.DatabaseSession session,
    List<OfflineScanRecord> rows, {
    required _isd.ColumnSelections<OfflineScanRecordTable> conflictColumns,
    _isd.ColumnSelections<OfflineScanRecordTable>? updateColumns,
    _isd.WhereExpressionBuilder<OfflineScanRecordTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<OfflineScanRecord>(
      rows,
      conflictColumns: conflictColumns(OfflineScanRecord.t),
      updateColumns: updateColumns?.call(OfflineScanRecord.t),
      updateWhere: updateWhere?.call(OfflineScanRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [OfflineScanRecord] and returns the resulting row.
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
  /// The returned [OfflineScanRecord] will have its `id` field set.
  Future<OfflineScanRecord?> upsertRow(
    _isd.DatabaseSession session,
    OfflineScanRecord row, {
    required _isd.ColumnSelections<OfflineScanRecordTable> conflictColumns,
    _isd.ColumnSelections<OfflineScanRecordTable>? updateColumns,
    _isd.WhereExpressionBuilder<OfflineScanRecordTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<OfflineScanRecord>(
      row,
      conflictColumns: conflictColumns(OfflineScanRecord.t),
      updateColumns: updateColumns?.call(OfflineScanRecord.t),
      updateWhere: updateWhere?.call(OfflineScanRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [OfflineScanRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OfflineScanRecord>> update(
    _isd.DatabaseSession session,
    List<OfflineScanRecord> rows, {
    _isd.ColumnSelections<OfflineScanRecordTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<OfflineScanRecord>(
      rows,
      columns: columns?.call(OfflineScanRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [OfflineScanRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OfflineScanRecord> updateRow(
    _isd.DatabaseSession session,
    OfflineScanRecord row, {
    _isd.ColumnSelections<OfflineScanRecordTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<OfflineScanRecord>(
      row,
      columns: columns?.call(OfflineScanRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OfflineScanRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OfflineScanRecord?> updateById(
    _isd.DatabaseSession session,
    _isc.UuidValue id, {
    required _isd.ColumnValueListBuilder<OfflineScanRecordUpdateTable>
    columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<OfflineScanRecord>(
      id,
      columnValues: columnValues(OfflineScanRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OfflineScanRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OfflineScanRecord>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<OfflineScanRecordUpdateTable>
    columnValues,
    required _isd.WhereExpressionBuilder<OfflineScanRecordTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<OfflineScanRecordTable>? orderBy,
    _isd.OrderByListBuilder<OfflineScanRecordTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<OfflineScanRecord>(
      columnValues: columnValues(OfflineScanRecord.t.updateTable),
      where: where(OfflineScanRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OfflineScanRecord.t),
      orderByList: orderByList?.call(OfflineScanRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [OfflineScanRecord]s in the list and returns the deleted rows.
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
  Future<List<OfflineScanRecord>> delete(
    _isd.DatabaseSession session,
    List<OfflineScanRecord> rows, {
    _isd.OrderByBuilder<OfflineScanRecordTable>? orderBy,
    _isd.OrderByListBuilder<OfflineScanRecordTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<OfflineScanRecord>(
      rows,
      orderBy: orderBy?.call(OfflineScanRecord.t),
      orderByList: orderByList?.call(OfflineScanRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [OfflineScanRecord].
  Future<OfflineScanRecord> deleteRow(
    _isd.DatabaseSession session,
    OfflineScanRecord row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OfflineScanRecord>(
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
  Future<List<OfflineScanRecord>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<OfflineScanRecordTable> where,
    _isd.OrderByBuilder<OfflineScanRecordTable>? orderBy,
    _isd.OrderByListBuilder<OfflineScanRecordTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<OfflineScanRecord>(
      where: where(OfflineScanRecord.t),
      orderBy: orderBy?.call(OfflineScanRecord.t),
      orderByList: orderByList?.call(OfflineScanRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<OfflineScanRecordTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<OfflineScanRecord>(
      where: where?.call(OfflineScanRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OfflineScanRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<OfflineScanRecordTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OfflineScanRecord>(
      where: where(OfflineScanRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
