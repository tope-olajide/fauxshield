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
import '../enums/alert_severity.dart' as _ivfuu0vh;
import '../enums/alert_status.dart' as _if1md3kb;
import '../enums/signal_type.dart' as _ihijuu0z;

/// A fraud alert for the brand's operations team. Alerts carry their own
/// workflow state and point at the evidence needed to investigate.
abstract class FraudAlert
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  FraudAlert._({
    this.id,
    required this.workspaceId,
    this.identityId,
    this.batchId,
    this.sessionId,
    required this.severity,
    _if1md3kb.AlertStatus? status,
    required this.title,
    required this.description,
    this.recommendedAction,
    this.signalTypes,
    required this.dedupeKey,
    bool? autoLocked,
    this.assignee,
    this.simulationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.acknowledgedAt,
    this.resolvedAt,
    this.resolvedBy,
    this.resolutionNote,
  }) : status = status ?? _if1md3kb.AlertStatus.open,
       autoLocked = autoLocked ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory FraudAlert({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    _is.UuidValue? identityId,
    _is.UuidValue? batchId,
    _is.UuidValue? sessionId,
    required _ivfuu0vh.AlertSeverity severity,
    _if1md3kb.AlertStatus? status,
    required String title,
    required String description,
    String? recommendedAction,
    List<_ihijuu0z.SignalType>? signalTypes,
    required String dedupeKey,
    bool? autoLocked,
    String? assignee,
    _is.UuidValue? simulationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? acknowledgedAt,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNote,
  }) = _FraudAlertImpl;

  factory FraudAlert.fromJson(Map<String, dynamic> jsonSerialization) {
    return FraudAlert(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      identityId: jsonSerialization['identityId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['identityId'],
            ),
      batchId: jsonSerialization['batchId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['batchId']),
      sessionId: jsonSerialization['sessionId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['sessionId']),
      severity: _ivfuu0vh.AlertSeverity.fromJson(
        (jsonSerialization['severity'] as String),
      ),
      status: jsonSerialization['status'] == null
          ? null
          : _if1md3kb.AlertStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      recommendedAction: jsonSerialization['recommendedAction'] as String?,
      signalTypes: jsonSerialization['signalTypes'] == null
          ? null
          : _ipgzzizd.Protocol().deserialize<List<_ihijuu0z.SignalType>>(
              jsonSerialization['signalTypes'],
            ),
      dedupeKey: jsonSerialization['dedupeKey'] as String,
      autoLocked: jsonSerialization['autoLocked'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['autoLocked']),
      assignee: jsonSerialization['assignee'] as String?,
      simulationId: jsonSerialization['simulationId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['simulationId'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      acknowledgedAt: jsonSerialization['acknowledgedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['acknowledgedAt'],
            ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
      resolvedBy: jsonSerialization['resolvedBy'] as String?,
      resolutionNote: jsonSerialization['resolutionNote'] as String?,
    );
  }

  static final t = FraudAlertTable();

  static const db = FraudAlertRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  /// Optional links to evidence. Plain ids so alerts survive identity deletion.
  _is.UuidValue? identityId;

  _is.UuidValue? batchId;

  _is.UuidValue? sessionId;

  _ivfuu0vh.AlertSeverity severity;

  _if1md3kb.AlertStatus status;

  String title;

  String description;

  String? recommendedAction;

  List<_ihijuu0z.SignalType>? signalTypes;

  /// Stable key that prevents duplicate alerts for the same underlying event.
  String dedupeKey;

  /// True when the platform automatically locked the identity for this alert.
  bool autoLocked;

  String? assignee;

  _is.UuidValue? simulationId;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? acknowledgedAt;

  DateTime? resolvedAt;

  String? resolvedBy;

  String? resolutionNote;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [FraudAlert]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FraudAlert copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    _is.UuidValue? identityId,
    _is.UuidValue? batchId,
    _is.UuidValue? sessionId,
    _ivfuu0vh.AlertSeverity? severity,
    _if1md3kb.AlertStatus? status,
    String? title,
    String? description,
    String? recommendedAction,
    List<_ihijuu0z.SignalType>? signalTypes,
    String? dedupeKey,
    bool? autoLocked,
    String? assignee,
    _is.UuidValue? simulationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? acknowledgedAt,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNote,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FraudAlert',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      if (identityId != null) 'identityId': identityId?.toJson(),
      if (batchId != null) 'batchId': batchId?.toJson(),
      if (sessionId != null) 'sessionId': sessionId?.toJson(),
      'severity': severity.toJson(),
      'status': status.toJson(),
      'title': title,
      'description': description,
      if (recommendedAction != null) 'recommendedAction': recommendedAction,
      if (signalTypes != null)
        'signalTypes': signalTypes?.toJson(valueToJson: (v) => v.toJson()),
      'dedupeKey': dedupeKey,
      'autoLocked': autoLocked,
      if (assignee != null) 'assignee': assignee,
      if (simulationId != null) 'simulationId': simulationId?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      if (resolvedBy != null) 'resolvedBy': resolvedBy,
      if (resolutionNote != null) 'resolutionNote': resolutionNote,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FraudAlert',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      if (identityId != null) 'identityId': identityId?.toJson(),
      if (batchId != null) 'batchId': batchId?.toJson(),
      if (sessionId != null) 'sessionId': sessionId?.toJson(),
      'severity': severity.toJson(),
      'status': status.toJson(),
      'title': title,
      'description': description,
      if (recommendedAction != null) 'recommendedAction': recommendedAction,
      if (signalTypes != null)
        'signalTypes': signalTypes?.toJson(valueToJson: (v) => v.toJson()),
      'dedupeKey': dedupeKey,
      'autoLocked': autoLocked,
      if (assignee != null) 'assignee': assignee,
      if (simulationId != null) 'simulationId': simulationId?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      if (resolvedBy != null) 'resolvedBy': resolvedBy,
      if (resolutionNote != null) 'resolutionNote': resolutionNote,
    };
  }

  static FraudAlertInclude include() {
    return FraudAlertInclude._();
  }

  static FraudAlertIncludeList includeList({
    _is.WhereExpressionBuilder<FraudAlertTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FraudAlertTable>? orderBy,
    _is.OrderByListBuilder<FraudAlertTable>? orderByList,
    FraudAlertInclude? include,
  }) {
    return FraudAlertIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FraudAlert.t),
      orderByList: orderByList?.call(FraudAlert.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FraudAlertImpl extends FraudAlert {
  _FraudAlertImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    _is.UuidValue? identityId,
    _is.UuidValue? batchId,
    _is.UuidValue? sessionId,
    required _ivfuu0vh.AlertSeverity severity,
    _if1md3kb.AlertStatus? status,
    required String title,
    required String description,
    String? recommendedAction,
    List<_ihijuu0z.SignalType>? signalTypes,
    required String dedupeKey,
    bool? autoLocked,
    String? assignee,
    _is.UuidValue? simulationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? acknowledgedAt,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNote,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         identityId: identityId,
         batchId: batchId,
         sessionId: sessionId,
         severity: severity,
         status: status,
         title: title,
         description: description,
         recommendedAction: recommendedAction,
         signalTypes: signalTypes,
         dedupeKey: dedupeKey,
         autoLocked: autoLocked,
         assignee: assignee,
         simulationId: simulationId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         acknowledgedAt: acknowledgedAt,
         resolvedAt: resolvedAt,
         resolvedBy: resolvedBy,
         resolutionNote: resolutionNote,
       );

  /// Returns a shallow copy of this [FraudAlert]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FraudAlert copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    Object? identityId = _Undefined,
    Object? batchId = _Undefined,
    Object? sessionId = _Undefined,
    _ivfuu0vh.AlertSeverity? severity,
    _if1md3kb.AlertStatus? status,
    String? title,
    String? description,
    Object? recommendedAction = _Undefined,
    Object? signalTypes = _Undefined,
    String? dedupeKey,
    bool? autoLocked,
    Object? assignee = _Undefined,
    Object? simulationId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? acknowledgedAt = _Undefined,
    Object? resolvedAt = _Undefined,
    Object? resolvedBy = _Undefined,
    Object? resolutionNote = _Undefined,
  }) {
    return FraudAlert(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      identityId: identityId is _is.UuidValue? ? identityId : this.identityId,
      batchId: batchId is _is.UuidValue? ? batchId : this.batchId,
      sessionId: sessionId is _is.UuidValue? ? sessionId : this.sessionId,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      recommendedAction: recommendedAction is String?
          ? recommendedAction
          : this.recommendedAction,
      signalTypes: signalTypes is List<_ihijuu0z.SignalType>?
          ? signalTypes
          : this.signalTypes?.map((e0) => e0).toList(),
      dedupeKey: dedupeKey ?? this.dedupeKey,
      autoLocked: autoLocked ?? this.autoLocked,
      assignee: assignee is String? ? assignee : this.assignee,
      simulationId: simulationId is _is.UuidValue?
          ? simulationId
          : this.simulationId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      acknowledgedAt: acknowledgedAt is DateTime?
          ? acknowledgedAt
          : this.acknowledgedAt,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
      resolvedBy: resolvedBy is String? ? resolvedBy : this.resolvedBy,
      resolutionNote: resolutionNote is String?
          ? resolutionNote
          : this.resolutionNote,
    );
  }
}

class FraudAlertUpdateTable extends _is.UpdateTable<FraudAlertTable> {
  FraudAlertUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> identityId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.identityId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> batchId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.batchId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> sessionId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.sessionId,
    value,
  );

  _is.ColumnValue<_ivfuu0vh.AlertSeverity, _ivfuu0vh.AlertSeverity> severity(
    _ivfuu0vh.AlertSeverity value,
  ) => _is.ColumnValue(
    table.severity,
    value,
  );

  _is.ColumnValue<_if1md3kb.AlertStatus, _if1md3kb.AlertStatus> status(
    _if1md3kb.AlertStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<String, String> recommendedAction(String? value) =>
      _is.ColumnValue(
        table.recommendedAction,
        value,
      );

  _is.ColumnValue<List<_ihijuu0z.SignalType>, List<_ihijuu0z.SignalType>>
  signalTypes(List<_ihijuu0z.SignalType>? value) => _is.ColumnValue(
    table.signalTypes,
    value,
  );

  _is.ColumnValue<String, String> dedupeKey(String value) => _is.ColumnValue(
    table.dedupeKey,
    value,
  );

  _is.ColumnValue<bool, bool> autoLocked(bool value) => _is.ColumnValue(
    table.autoLocked,
    value,
  );

  _is.ColumnValue<String, String> assignee(String? value) => _is.ColumnValue(
    table.assignee,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> simulationId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.simulationId,
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

  _is.ColumnValue<DateTime, DateTime> acknowledgedAt(DateTime? value) =>
      _is.ColumnValue(
        table.acknowledgedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> resolvedAt(DateTime? value) =>
      _is.ColumnValue(
        table.resolvedAt,
        value,
      );

  _is.ColumnValue<String, String> resolvedBy(String? value) => _is.ColumnValue(
    table.resolvedBy,
    value,
  );

  _is.ColumnValue<String, String> resolutionNote(String? value) =>
      _is.ColumnValue(
        table.resolutionNote,
        value,
      );
}

class FraudAlertTable extends _is.Table<_is.UuidValue?> {
  FraudAlertTable({super.tableRelation}) : super(tableName: 'fraud_alert') {
    updateTable = FraudAlertUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    identityId = _is.ColumnUuid(
      'identityId',
      this,
    );
    batchId = _is.ColumnUuid(
      'batchId',
      this,
    );
    sessionId = _is.ColumnUuid(
      'sessionId',
      this,
    );
    severity = _is.ColumnEnum(
      'severity',
      this,
      _is.EnumSerialization.byName,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    recommendedAction = _is.ColumnString(
      'recommendedAction',
      this,
    );
    signalTypes = _is.ColumnSerializable<List<_ihijuu0z.SignalType>>(
      'signalTypes',
      this,
    );
    dedupeKey = _is.ColumnString(
      'dedupeKey',
      this,
    );
    autoLocked = _is.ColumnBool(
      'autoLocked',
      this,
      hasDefault: true,
    );
    assignee = _is.ColumnString(
      'assignee',
      this,
    );
    simulationId = _is.ColumnUuid(
      'simulationId',
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
    acknowledgedAt = _is.ColumnDateTime(
      'acknowledgedAt',
      this,
    );
    resolvedAt = _is.ColumnDateTime(
      'resolvedAt',
      this,
    );
    resolvedBy = _is.ColumnString(
      'resolvedBy',
      this,
    );
    resolutionNote = _is.ColumnString(
      'resolutionNote',
      this,
    );
  }

  late final FraudAlertUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  /// Optional links to evidence. Plain ids so alerts survive identity deletion.
  late final _is.ColumnUuid identityId;

  late final _is.ColumnUuid batchId;

  late final _is.ColumnUuid sessionId;

  late final _is.ColumnEnum<_ivfuu0vh.AlertSeverity> severity;

  late final _is.ColumnEnum<_if1md3kb.AlertStatus> status;

  late final _is.ColumnString title;

  late final _is.ColumnString description;

  late final _is.ColumnString recommendedAction;

  late final _is.ColumnSerializable<List<_ihijuu0z.SignalType>> signalTypes;

  /// Stable key that prevents duplicate alerts for the same underlying event.
  late final _is.ColumnString dedupeKey;

  /// True when the platform automatically locked the identity for this alert.
  late final _is.ColumnBool autoLocked;

  late final _is.ColumnString assignee;

  late final _is.ColumnUuid simulationId;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  late final _is.ColumnDateTime acknowledgedAt;

  late final _is.ColumnDateTime resolvedAt;

  late final _is.ColumnString resolvedBy;

  late final _is.ColumnString resolutionNote;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    identityId,
    batchId,
    sessionId,
    severity,
    status,
    title,
    description,
    recommendedAction,
    signalTypes,
    dedupeKey,
    autoLocked,
    assignee,
    simulationId,
    createdAt,
    updatedAt,
    acknowledgedAt,
    resolvedAt,
    resolvedBy,
    resolutionNote,
  ];
}

class FraudAlertInclude extends _is.IncludeObject {
  FraudAlertInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => FraudAlert.t;
}

class FraudAlertIncludeList extends _is.IncludeList {
  FraudAlertIncludeList._({
    _is.WhereExpressionBuilder<FraudAlertTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FraudAlert.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => FraudAlert.t;
}

class FraudAlertRepository {
  const FraudAlertRepository._();

  /// Returns a list of [FraudAlert]s matching the given query parameters.
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
  Future<List<FraudAlert>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FraudAlertTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FraudAlertTable>? orderBy,
    _is.OrderByListBuilder<FraudAlertTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FraudAlert>(
      where: where?.call(FraudAlert.t),
      orderBy: orderBy?.call(FraudAlert.t),
      orderByList: orderByList?.call(FraudAlert.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FraudAlert] matching the given query parameters.
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
  Future<FraudAlert?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FraudAlertTable>? where,
    int? offset,
    _is.OrderByBuilder<FraudAlertTable>? orderBy,
    _is.OrderByListBuilder<FraudAlertTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FraudAlert>(
      where: where?.call(FraudAlert.t),
      orderBy: orderBy?.call(FraudAlert.t),
      orderByList: orderByList?.call(FraudAlert.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FraudAlert] by its [id] or null if no such row exists.
  Future<FraudAlert?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FraudAlert>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FraudAlert]s in the list and returns the inserted rows.
  ///
  /// The returned [FraudAlert]s will have their `id` fields set.
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
  Future<List<FraudAlert>> insert(
    _is.DatabaseSession session,
    List<FraudAlert> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FraudAlert>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FraudAlert] and returns the inserted row.
  ///
  /// The returned [FraudAlert] will have its `id` field set.
  Future<FraudAlert> insertRow(
    _is.DatabaseSession session,
    FraudAlert row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FraudAlert>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FraudAlert]s in the list and returns the resulting rows.
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
  /// The returned [FraudAlert]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FraudAlert>> upsert(
    _is.DatabaseSession session,
    List<FraudAlert> rows, {
    required _is.ColumnSelections<FraudAlertTable> conflictColumns,
    _is.ColumnSelections<FraudAlertTable>? updateColumns,
    _is.WhereExpressionBuilder<FraudAlertTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FraudAlert>(
      rows,
      conflictColumns: conflictColumns(FraudAlert.t),
      updateColumns: updateColumns?.call(FraudAlert.t),
      updateWhere: updateWhere?.call(FraudAlert.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FraudAlert] and returns the resulting row.
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
  /// The returned [FraudAlert] will have its `id` field set.
  Future<FraudAlert?> upsertRow(
    _is.DatabaseSession session,
    FraudAlert row, {
    required _is.ColumnSelections<FraudAlertTable> conflictColumns,
    _is.ColumnSelections<FraudAlertTable>? updateColumns,
    _is.WhereExpressionBuilder<FraudAlertTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FraudAlert>(
      row,
      conflictColumns: conflictColumns(FraudAlert.t),
      updateColumns: updateColumns?.call(FraudAlert.t),
      updateWhere: updateWhere?.call(FraudAlert.t),
      transaction: transaction,
    );
  }

  /// Updates all [FraudAlert]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FraudAlert>> update(
    _is.DatabaseSession session,
    List<FraudAlert> rows, {
    _is.ColumnSelections<FraudAlertTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FraudAlert>(
      rows,
      columns: columns?.call(FraudAlert.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FraudAlert]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FraudAlert> updateRow(
    _is.DatabaseSession session,
    FraudAlert row, {
    _is.ColumnSelections<FraudAlertTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FraudAlert>(
      row,
      columns: columns?.call(FraudAlert.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FraudAlert] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FraudAlert?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<FraudAlertUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FraudAlert>(
      id,
      columnValues: columnValues(FraudAlert.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FraudAlert]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FraudAlert>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FraudAlertUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<FraudAlertTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FraudAlertTable>? orderBy,
    _is.OrderByListBuilder<FraudAlertTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FraudAlert>(
      columnValues: columnValues(FraudAlert.t.updateTable),
      where: where(FraudAlert.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FraudAlert.t),
      orderByList: orderByList?.call(FraudAlert.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FraudAlert]s in the list and returns the deleted rows.
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
  Future<List<FraudAlert>> delete(
    _is.DatabaseSession session,
    List<FraudAlert> rows, {
    _is.OrderByBuilder<FraudAlertTable>? orderBy,
    _is.OrderByListBuilder<FraudAlertTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FraudAlert>(
      rows,
      orderBy: orderBy?.call(FraudAlert.t),
      orderByList: orderByList?.call(FraudAlert.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FraudAlert].
  Future<FraudAlert> deleteRow(
    _is.DatabaseSession session,
    FraudAlert row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FraudAlert>(
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
  Future<List<FraudAlert>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FraudAlertTable> where,
    _is.OrderByBuilder<FraudAlertTable>? orderBy,
    _is.OrderByListBuilder<FraudAlertTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FraudAlert>(
      where: where(FraudAlert.t),
      orderBy: orderBy?.call(FraudAlert.t),
      orderByList: orderByList?.call(FraudAlert.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FraudAlertTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FraudAlert>(
      where: where?.call(FraudAlert.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FraudAlert] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FraudAlertTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FraudAlert>(
      where: where(FraudAlert.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
