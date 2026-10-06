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
import '../enums/fake_report_status.dart' as _igwoz7s7;
import '../enums/scan_source.dart' as _iv29sx9n;

/// A suspicious or fake product report submitted by a consumer from the
/// verification flow. Reports feed the fraud pipeline and the brand's triage queue.
abstract class FakeReport
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  FakeReport._({
    this.id,
    required this.workspaceId,
    required this.identityId,
    this.sessionId,
    required this.reason,
    this.comment,
    this.photoStorageId,
    this.photoPath,
    this.deviceFingerprint,
    this.country,
    this.city,
    _igwoz7s7.FakeReportStatus? status,
    _iv29sx9n.ScanSource? source,
    DateTime? createdAt,
    this.triagedAt,
    this.triagedBy,
  }) : status = status ?? _igwoz7s7.FakeReportStatus.open,
       source = source ?? _iv29sx9n.ScanSource.consumerWeb,
       createdAt = createdAt ?? DateTime.now();

  factory FakeReport({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required _is.UuidValue identityId,
    _is.UuidValue? sessionId,
    required String reason,
    String? comment,
    String? photoStorageId,
    String? photoPath,
    String? deviceFingerprint,
    String? country,
    String? city,
    _igwoz7s7.FakeReportStatus? status,
    _iv29sx9n.ScanSource? source,
    DateTime? createdAt,
    DateTime? triagedAt,
    String? triagedBy,
  }) = _FakeReportImpl;

  factory FakeReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return FakeReport(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      identityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['identityId'],
      ),
      sessionId: jsonSerialization['sessionId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['sessionId']),
      reason: jsonSerialization['reason'] as String,
      comment: jsonSerialization['comment'] as String?,
      photoStorageId: jsonSerialization['photoStorageId'] as String?,
      photoPath: jsonSerialization['photoPath'] as String?,
      deviceFingerprint: jsonSerialization['deviceFingerprint'] as String?,
      country: jsonSerialization['country'] as String?,
      city: jsonSerialization['city'] as String?,
      status: jsonSerialization['status'] == null
          ? null
          : _igwoz7s7.FakeReportStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      source: jsonSerialization['source'] == null
          ? null
          : _iv29sx9n.ScanSource.fromJson(
              (jsonSerialization['source'] as String),
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      triagedAt: jsonSerialization['triagedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['triagedAt']),
      triagedBy: jsonSerialization['triagedBy'] as String?,
    );
  }

  static final t = FakeReportTable();

  static const db = FakeReportRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  _is.UuidValue identityId;

  _is.UuidValue? sessionId;

  String reason;

  String? comment;

  String? photoStorageId;

  String? photoPath;

  String? deviceFingerprint;

  String? country;

  String? city;

  _igwoz7s7.FakeReportStatus status;

  _iv29sx9n.ScanSource source;

  DateTime createdAt;

  DateTime? triagedAt;

  String? triagedBy;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [FakeReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FakeReport copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    _is.UuidValue? identityId,
    _is.UuidValue? sessionId,
    String? reason,
    String? comment,
    String? photoStorageId,
    String? photoPath,
    String? deviceFingerprint,
    String? country,
    String? city,
    _igwoz7s7.FakeReportStatus? status,
    _iv29sx9n.ScanSource? source,
    DateTime? createdAt,
    DateTime? triagedAt,
    String? triagedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FakeReport',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'identityId': identityId.toJson(),
      if (sessionId != null) 'sessionId': sessionId?.toJson(),
      'reason': reason,
      if (comment != null) 'comment': comment,
      if (photoStorageId != null) 'photoStorageId': photoStorageId,
      if (photoPath != null) 'photoPath': photoPath,
      if (deviceFingerprint != null) 'deviceFingerprint': deviceFingerprint,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      'status': status.toJson(),
      'source': source.toJson(),
      'createdAt': createdAt.toJson(),
      if (triagedAt != null) 'triagedAt': triagedAt?.toJson(),
      if (triagedBy != null) 'triagedBy': triagedBy,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FakeReport',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'identityId': identityId.toJson(),
      if (sessionId != null) 'sessionId': sessionId?.toJson(),
      'reason': reason,
      if (comment != null) 'comment': comment,
      if (photoStorageId != null) 'photoStorageId': photoStorageId,
      if (photoPath != null) 'photoPath': photoPath,
      if (deviceFingerprint != null) 'deviceFingerprint': deviceFingerprint,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      'status': status.toJson(),
      'source': source.toJson(),
      'createdAt': createdAt.toJson(),
      if (triagedAt != null) 'triagedAt': triagedAt?.toJson(),
      if (triagedBy != null) 'triagedBy': triagedBy,
    };
  }

  static FakeReportInclude include() {
    return FakeReportInclude._();
  }

  static FakeReportIncludeList includeList({
    _is.WhereExpressionBuilder<FakeReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FakeReportTable>? orderBy,
    _is.OrderByListBuilder<FakeReportTable>? orderByList,
    FakeReportInclude? include,
  }) {
    return FakeReportIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FakeReport.t),
      orderByList: orderByList?.call(FakeReport.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FakeReportImpl extends FakeReport {
  _FakeReportImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required _is.UuidValue identityId,
    _is.UuidValue? sessionId,
    required String reason,
    String? comment,
    String? photoStorageId,
    String? photoPath,
    String? deviceFingerprint,
    String? country,
    String? city,
    _igwoz7s7.FakeReportStatus? status,
    _iv29sx9n.ScanSource? source,
    DateTime? createdAt,
    DateTime? triagedAt,
    String? triagedBy,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         identityId: identityId,
         sessionId: sessionId,
         reason: reason,
         comment: comment,
         photoStorageId: photoStorageId,
         photoPath: photoPath,
         deviceFingerprint: deviceFingerprint,
         country: country,
         city: city,
         status: status,
         source: source,
         createdAt: createdAt,
         triagedAt: triagedAt,
         triagedBy: triagedBy,
       );

  /// Returns a shallow copy of this [FakeReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FakeReport copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    _is.UuidValue? identityId,
    Object? sessionId = _Undefined,
    String? reason,
    Object? comment = _Undefined,
    Object? photoStorageId = _Undefined,
    Object? photoPath = _Undefined,
    Object? deviceFingerprint = _Undefined,
    Object? country = _Undefined,
    Object? city = _Undefined,
    _igwoz7s7.FakeReportStatus? status,
    _iv29sx9n.ScanSource? source,
    DateTime? createdAt,
    Object? triagedAt = _Undefined,
    Object? triagedBy = _Undefined,
  }) {
    return FakeReport(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      identityId: identityId ?? this.identityId,
      sessionId: sessionId is _is.UuidValue? ? sessionId : this.sessionId,
      reason: reason ?? this.reason,
      comment: comment is String? ? comment : this.comment,
      photoStorageId: photoStorageId is String?
          ? photoStorageId
          : this.photoStorageId,
      photoPath: photoPath is String? ? photoPath : this.photoPath,
      deviceFingerprint: deviceFingerprint is String?
          ? deviceFingerprint
          : this.deviceFingerprint,
      country: country is String? ? country : this.country,
      city: city is String? ? city : this.city,
      status: status ?? this.status,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      triagedAt: triagedAt is DateTime? ? triagedAt : this.triagedAt,
      triagedBy: triagedBy is String? ? triagedBy : this.triagedBy,
    );
  }
}

class FakeReportUpdateTable extends _is.UpdateTable<FakeReportTable> {
  FakeReportUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> identityId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.identityId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> sessionId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.sessionId,
    value,
  );

  _is.ColumnValue<String, String> reason(String value) => _is.ColumnValue(
    table.reason,
    value,
  );

  _is.ColumnValue<String, String> comment(String? value) => _is.ColumnValue(
    table.comment,
    value,
  );

  _is.ColumnValue<String, String> photoStorageId(String? value) =>
      _is.ColumnValue(
        table.photoStorageId,
        value,
      );

  _is.ColumnValue<String, String> photoPath(String? value) => _is.ColumnValue(
    table.photoPath,
    value,
  );

  _is.ColumnValue<String, String> deviceFingerprint(String? value) =>
      _is.ColumnValue(
        table.deviceFingerprint,
        value,
      );

  _is.ColumnValue<String, String> country(String? value) => _is.ColumnValue(
    table.country,
    value,
  );

  _is.ColumnValue<String, String> city(String? value) => _is.ColumnValue(
    table.city,
    value,
  );

  _is.ColumnValue<_igwoz7s7.FakeReportStatus, _igwoz7s7.FakeReportStatus>
  status(_igwoz7s7.FakeReportStatus value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<_iv29sx9n.ScanSource, _iv29sx9n.ScanSource> source(
    _iv29sx9n.ScanSource value,
  ) => _is.ColumnValue(
    table.source,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> triagedAt(DateTime? value) =>
      _is.ColumnValue(
        table.triagedAt,
        value,
      );

  _is.ColumnValue<String, String> triagedBy(String? value) => _is.ColumnValue(
    table.triagedBy,
    value,
  );
}

class FakeReportTable extends _is.Table<_is.UuidValue?> {
  FakeReportTable({super.tableRelation}) : super(tableName: 'fake_report') {
    updateTable = FakeReportUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    identityId = _is.ColumnUuid(
      'identityId',
      this,
    );
    sessionId = _is.ColumnUuid(
      'sessionId',
      this,
    );
    reason = _is.ColumnString(
      'reason',
      this,
    );
    comment = _is.ColumnString(
      'comment',
      this,
    );
    photoStorageId = _is.ColumnString(
      'photoStorageId',
      this,
    );
    photoPath = _is.ColumnString(
      'photoPath',
      this,
    );
    deviceFingerprint = _is.ColumnString(
      'deviceFingerprint',
      this,
    );
    country = _is.ColumnString(
      'country',
      this,
    );
    city = _is.ColumnString(
      'city',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    source = _is.ColumnEnum(
      'source',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    triagedAt = _is.ColumnDateTime(
      'triagedAt',
      this,
    );
    triagedBy = _is.ColumnString(
      'triagedBy',
      this,
    );
  }

  late final FakeReportUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  late final _is.ColumnUuid identityId;

  late final _is.ColumnUuid sessionId;

  late final _is.ColumnString reason;

  late final _is.ColumnString comment;

  late final _is.ColumnString photoStorageId;

  late final _is.ColumnString photoPath;

  late final _is.ColumnString deviceFingerprint;

  late final _is.ColumnString country;

  late final _is.ColumnString city;

  late final _is.ColumnEnum<_igwoz7s7.FakeReportStatus> status;

  late final _is.ColumnEnum<_iv29sx9n.ScanSource> source;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime triagedAt;

  late final _is.ColumnString triagedBy;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    identityId,
    sessionId,
    reason,
    comment,
    photoStorageId,
    photoPath,
    deviceFingerprint,
    country,
    city,
    status,
    source,
    createdAt,
    triagedAt,
    triagedBy,
  ];
}

class FakeReportInclude extends _is.IncludeObject {
  FakeReportInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => FakeReport.t;
}

class FakeReportIncludeList extends _is.IncludeList {
  FakeReportIncludeList._({
    _is.WhereExpressionBuilder<FakeReportTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FakeReport.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => FakeReport.t;
}

class FakeReportRepository {
  const FakeReportRepository._();

  /// Returns a list of [FakeReport]s matching the given query parameters.
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
  Future<List<FakeReport>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FakeReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FakeReportTable>? orderBy,
    _is.OrderByListBuilder<FakeReportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FakeReport>(
      where: where?.call(FakeReport.t),
      orderBy: orderBy?.call(FakeReport.t),
      orderByList: orderByList?.call(FakeReport.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FakeReport] matching the given query parameters.
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
  Future<FakeReport?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FakeReportTable>? where,
    int? offset,
    _is.OrderByBuilder<FakeReportTable>? orderBy,
    _is.OrderByListBuilder<FakeReportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FakeReport>(
      where: where?.call(FakeReport.t),
      orderBy: orderBy?.call(FakeReport.t),
      orderByList: orderByList?.call(FakeReport.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FakeReport] by its [id] or null if no such row exists.
  Future<FakeReport?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FakeReport>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FakeReport]s in the list and returns the inserted rows.
  ///
  /// The returned [FakeReport]s will have their `id` fields set.
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
  Future<List<FakeReport>> insert(
    _is.DatabaseSession session,
    List<FakeReport> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FakeReport>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FakeReport] and returns the inserted row.
  ///
  /// The returned [FakeReport] will have its `id` field set.
  Future<FakeReport> insertRow(
    _is.DatabaseSession session,
    FakeReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FakeReport>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FakeReport]s in the list and returns the resulting rows.
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
  /// The returned [FakeReport]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FakeReport>> upsert(
    _is.DatabaseSession session,
    List<FakeReport> rows, {
    required _is.ColumnSelections<FakeReportTable> conflictColumns,
    _is.ColumnSelections<FakeReportTable>? updateColumns,
    _is.WhereExpressionBuilder<FakeReportTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FakeReport>(
      rows,
      conflictColumns: conflictColumns(FakeReport.t),
      updateColumns: updateColumns?.call(FakeReport.t),
      updateWhere: updateWhere?.call(FakeReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FakeReport] and returns the resulting row.
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
  /// The returned [FakeReport] will have its `id` field set.
  Future<FakeReport?> upsertRow(
    _is.DatabaseSession session,
    FakeReport row, {
    required _is.ColumnSelections<FakeReportTable> conflictColumns,
    _is.ColumnSelections<FakeReportTable>? updateColumns,
    _is.WhereExpressionBuilder<FakeReportTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FakeReport>(
      row,
      conflictColumns: conflictColumns(FakeReport.t),
      updateColumns: updateColumns?.call(FakeReport.t),
      updateWhere: updateWhere?.call(FakeReport.t),
      transaction: transaction,
    );
  }

  /// Updates all [FakeReport]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FakeReport>> update(
    _is.DatabaseSession session,
    List<FakeReport> rows, {
    _is.ColumnSelections<FakeReportTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FakeReport>(
      rows,
      columns: columns?.call(FakeReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FakeReport]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FakeReport> updateRow(
    _is.DatabaseSession session,
    FakeReport row, {
    _is.ColumnSelections<FakeReportTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FakeReport>(
      row,
      columns: columns?.call(FakeReport.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FakeReport] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FakeReport?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<FakeReportUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FakeReport>(
      id,
      columnValues: columnValues(FakeReport.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FakeReport]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FakeReport>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FakeReportUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<FakeReportTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FakeReportTable>? orderBy,
    _is.OrderByListBuilder<FakeReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FakeReport>(
      columnValues: columnValues(FakeReport.t.updateTable),
      where: where(FakeReport.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FakeReport.t),
      orderByList: orderByList?.call(FakeReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FakeReport]s in the list and returns the deleted rows.
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
  Future<List<FakeReport>> delete(
    _is.DatabaseSession session,
    List<FakeReport> rows, {
    _is.OrderByBuilder<FakeReportTable>? orderBy,
    _is.OrderByListBuilder<FakeReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FakeReport>(
      rows,
      orderBy: orderBy?.call(FakeReport.t),
      orderByList: orderByList?.call(FakeReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FakeReport].
  Future<FakeReport> deleteRow(
    _is.DatabaseSession session,
    FakeReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FakeReport>(
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
  Future<List<FakeReport>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FakeReportTable> where,
    _is.OrderByBuilder<FakeReportTable>? orderBy,
    _is.OrderByListBuilder<FakeReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FakeReport>(
      where: where(FakeReport.t),
      orderBy: orderBy?.call(FakeReport.t),
      orderByList: orderByList?.call(FakeReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FakeReportTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FakeReport>(
      where: where?.call(FakeReport.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FakeReport] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FakeReportTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FakeReport>(
      where: where(FakeReport.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
