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
import '../enums/risk_score.dart' as _ikrsd51m;
import '../enums/scan_source.dart' as _iv29sx9n;
import '../enums/verification_outcome.dart' as _iq7ze9sg;
import '../enums/verification_state.dart' as _ikmf2cvr;

/// A stateful consumer verification attempt. Sessions are bound to a device
/// fingerprint and expire after 15 minutes of inactivity. Fraud evaluation runs
/// before the session can advance to PIN entry.
abstract class VerificationSession
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  VerificationSession._({
    this.id,
    required this.workspaceId,
    required this.identityId,
    required this.qrToken,
    this.deviceFingerprint,
    this.ipAddress,
    this.country,
    this.countryCode,
    this.city,
    this.latitude,
    this.longitude,
    _ikmf2cvr.VerificationState? state,
    this.outcome,
    this.riskScore,
    _iv29sx9n.ScanSource? source,
    this.offlineScanId,
    this.simulationId,
    DateTime? createdAt,
    DateTime? lastStateChange,
    required this.expiresAt,
    this.completedAt,
  }) : state = state ?? _ikmf2cvr.VerificationState.tokenResolved,
       source = source ?? _iv29sx9n.ScanSource.consumerWeb,
       createdAt = createdAt ?? DateTime.now(),
       lastStateChange = lastStateChange ?? DateTime.now();

  factory VerificationSession({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required _is.UuidValue identityId,
    required String qrToken,
    String? deviceFingerprint,
    String? ipAddress,
    String? country,
    String? countryCode,
    String? city,
    double? latitude,
    double? longitude,
    _ikmf2cvr.VerificationState? state,
    _iq7ze9sg.VerificationOutcome? outcome,
    _ikrsd51m.RiskScore? riskScore,
    _iv29sx9n.ScanSource? source,
    _is.UuidValue? offlineScanId,
    _is.UuidValue? simulationId,
    DateTime? createdAt,
    DateTime? lastStateChange,
    required DateTime expiresAt,
    DateTime? completedAt,
  }) = _VerificationSessionImpl;

  factory VerificationSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return VerificationSession(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      identityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['identityId'],
      ),
      qrToken: jsonSerialization['qrToken'] as String,
      deviceFingerprint: jsonSerialization['deviceFingerprint'] as String?,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      country: jsonSerialization['country'] as String?,
      countryCode: jsonSerialization['countryCode'] as String?,
      city: jsonSerialization['city'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      state: jsonSerialization['state'] == null
          ? null
          : _ikmf2cvr.VerificationState.fromJson(
              (jsonSerialization['state'] as String),
            ),
      outcome: jsonSerialization['outcome'] == null
          ? null
          : _iq7ze9sg.VerificationOutcome.fromJson(
              (jsonSerialization['outcome'] as String),
            ),
      riskScore: jsonSerialization['riskScore'] == null
          ? null
          : _ikrsd51m.RiskScore.fromJson(
              (jsonSerialization['riskScore'] as String),
            ),
      source: jsonSerialization['source'] == null
          ? null
          : _iv29sx9n.ScanSource.fromJson(
              (jsonSerialization['source'] as String),
            ),
      offlineScanId: jsonSerialization['offlineScanId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['offlineScanId'],
            ),
      simulationId: jsonSerialization['simulationId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['simulationId'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastStateChange: jsonSerialization['lastStateChange'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastStateChange'],
            ),
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
    );
  }

  static final t = VerificationSessionTable();

  static const db = VerificationSessionRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  _is.UuidValue identityId;

  String qrToken;

  /// Random per device identifier supplied by the client and revalidated on every state change.
  String? deviceFingerprint;

  String? ipAddress;

  String? country;

  String? countryCode;

  String? city;

  double? latitude;

  double? longitude;

  _ikmf2cvr.VerificationState state;

  _iq7ze9sg.VerificationOutcome? outcome;

  _ikrsd51m.RiskScore? riskScore;

  _iv29sx9n.ScanSource source;

  /// Set when this session was created from an offline field scan.
  _is.UuidValue? offlineScanId;

  /// Set when this session was created by an attack simulation run.
  _is.UuidValue? simulationId;

  DateTime createdAt;

  DateTime lastStateChange;

  DateTime expiresAt;

  DateTime? completedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [VerificationSession]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  VerificationSession copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    _is.UuidValue? identityId,
    String? qrToken,
    String? deviceFingerprint,
    String? ipAddress,
    String? country,
    String? countryCode,
    String? city,
    double? latitude,
    double? longitude,
    _ikmf2cvr.VerificationState? state,
    _iq7ze9sg.VerificationOutcome? outcome,
    _ikrsd51m.RiskScore? riskScore,
    _iv29sx9n.ScanSource? source,
    _is.UuidValue? offlineScanId,
    _is.UuidValue? simulationId,
    DateTime? createdAt,
    DateTime? lastStateChange,
    DateTime? expiresAt,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VerificationSession',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'identityId': identityId.toJson(),
      'qrToken': qrToken,
      if (deviceFingerprint != null) 'deviceFingerprint': deviceFingerprint,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (country != null) 'country': country,
      if (countryCode != null) 'countryCode': countryCode,
      if (city != null) 'city': city,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'state': state.toJson(),
      if (outcome != null) 'outcome': outcome?.toJson(),
      if (riskScore != null) 'riskScore': riskScore?.toJson(),
      'source': source.toJson(),
      if (offlineScanId != null) 'offlineScanId': offlineScanId?.toJson(),
      if (simulationId != null) 'simulationId': simulationId?.toJson(),
      'createdAt': createdAt.toJson(),
      'lastStateChange': lastStateChange.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VerificationSession',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'identityId': identityId.toJson(),
      'qrToken': qrToken,
      if (deviceFingerprint != null) 'deviceFingerprint': deviceFingerprint,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (country != null) 'country': country,
      if (countryCode != null) 'countryCode': countryCode,
      if (city != null) 'city': city,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'state': state.toJson(),
      if (outcome != null) 'outcome': outcome?.toJson(),
      if (riskScore != null) 'riskScore': riskScore?.toJson(),
      'source': source.toJson(),
      if (offlineScanId != null) 'offlineScanId': offlineScanId?.toJson(),
      if (simulationId != null) 'simulationId': simulationId?.toJson(),
      'createdAt': createdAt.toJson(),
      'lastStateChange': lastStateChange.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  static VerificationSessionInclude include() {
    return VerificationSessionInclude._();
  }

  static VerificationSessionIncludeList includeList({
    _is.WhereExpressionBuilder<VerificationSessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VerificationSessionTable>? orderBy,
    _is.OrderByListBuilder<VerificationSessionTable>? orderByList,
    VerificationSessionInclude? include,
  }) {
    return VerificationSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VerificationSession.t),
      orderByList: orderByList?.call(VerificationSession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VerificationSessionImpl extends VerificationSession {
  _VerificationSessionImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required _is.UuidValue identityId,
    required String qrToken,
    String? deviceFingerprint,
    String? ipAddress,
    String? country,
    String? countryCode,
    String? city,
    double? latitude,
    double? longitude,
    _ikmf2cvr.VerificationState? state,
    _iq7ze9sg.VerificationOutcome? outcome,
    _ikrsd51m.RiskScore? riskScore,
    _iv29sx9n.ScanSource? source,
    _is.UuidValue? offlineScanId,
    _is.UuidValue? simulationId,
    DateTime? createdAt,
    DateTime? lastStateChange,
    required DateTime expiresAt,
    DateTime? completedAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         identityId: identityId,
         qrToken: qrToken,
         deviceFingerprint: deviceFingerprint,
         ipAddress: ipAddress,
         country: country,
         countryCode: countryCode,
         city: city,
         latitude: latitude,
         longitude: longitude,
         state: state,
         outcome: outcome,
         riskScore: riskScore,
         source: source,
         offlineScanId: offlineScanId,
         simulationId: simulationId,
         createdAt: createdAt,
         lastStateChange: lastStateChange,
         expiresAt: expiresAt,
         completedAt: completedAt,
       );

  /// Returns a shallow copy of this [VerificationSession]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  VerificationSession copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    _is.UuidValue? identityId,
    String? qrToken,
    Object? deviceFingerprint = _Undefined,
    Object? ipAddress = _Undefined,
    Object? country = _Undefined,
    Object? countryCode = _Undefined,
    Object? city = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    _ikmf2cvr.VerificationState? state,
    Object? outcome = _Undefined,
    Object? riskScore = _Undefined,
    _iv29sx9n.ScanSource? source,
    Object? offlineScanId = _Undefined,
    Object? simulationId = _Undefined,
    DateTime? createdAt,
    DateTime? lastStateChange,
    DateTime? expiresAt,
    Object? completedAt = _Undefined,
  }) {
    return VerificationSession(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      identityId: identityId ?? this.identityId,
      qrToken: qrToken ?? this.qrToken,
      deviceFingerprint: deviceFingerprint is String?
          ? deviceFingerprint
          : this.deviceFingerprint,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      country: country is String? ? country : this.country,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
      city: city is String? ? city : this.city,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      state: state ?? this.state,
      outcome: outcome is _iq7ze9sg.VerificationOutcome?
          ? outcome
          : this.outcome,
      riskScore: riskScore is _ikrsd51m.RiskScore? ? riskScore : this.riskScore,
      source: source ?? this.source,
      offlineScanId: offlineScanId is _is.UuidValue?
          ? offlineScanId
          : this.offlineScanId,
      simulationId: simulationId is _is.UuidValue?
          ? simulationId
          : this.simulationId,
      createdAt: createdAt ?? this.createdAt,
      lastStateChange: lastStateChange ?? this.lastStateChange,
      expiresAt: expiresAt ?? this.expiresAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}

class VerificationSessionUpdateTable
    extends _is.UpdateTable<VerificationSessionTable> {
  VerificationSessionUpdateTable(super.table);

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

  _is.ColumnValue<String, String> qrToken(String value) => _is.ColumnValue(
    table.qrToken,
    value,
  );

  _is.ColumnValue<String, String> deviceFingerprint(String? value) =>
      _is.ColumnValue(
        table.deviceFingerprint,
        value,
      );

  _is.ColumnValue<String, String> ipAddress(String? value) => _is.ColumnValue(
    table.ipAddress,
    value,
  );

  _is.ColumnValue<String, String> country(String? value) => _is.ColumnValue(
    table.country,
    value,
  );

  _is.ColumnValue<String, String> countryCode(String? value) => _is.ColumnValue(
    table.countryCode,
    value,
  );

  _is.ColumnValue<String, String> city(String? value) => _is.ColumnValue(
    table.city,
    value,
  );

  _is.ColumnValue<double, double> latitude(double? value) => _is.ColumnValue(
    table.latitude,
    value,
  );

  _is.ColumnValue<double, double> longitude(double? value) => _is.ColumnValue(
    table.longitude,
    value,
  );

  _is.ColumnValue<_ikmf2cvr.VerificationState, _ikmf2cvr.VerificationState>
  state(_ikmf2cvr.VerificationState value) => _is.ColumnValue(
    table.state,
    value,
  );

  _is.ColumnValue<_iq7ze9sg.VerificationOutcome, _iq7ze9sg.VerificationOutcome>
  outcome(_iq7ze9sg.VerificationOutcome? value) => _is.ColumnValue(
    table.outcome,
    value,
  );

  _is.ColumnValue<_ikrsd51m.RiskScore, _ikrsd51m.RiskScore> riskScore(
    _ikrsd51m.RiskScore? value,
  ) => _is.ColumnValue(
    table.riskScore,
    value,
  );

  _is.ColumnValue<_iv29sx9n.ScanSource, _iv29sx9n.ScanSource> source(
    _iv29sx9n.ScanSource value,
  ) => _is.ColumnValue(
    table.source,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> offlineScanId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.offlineScanId,
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

  _is.ColumnValue<DateTime, DateTime> lastStateChange(DateTime value) =>
      _is.ColumnValue(
        table.lastStateChange,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> completedAt(DateTime? value) =>
      _is.ColumnValue(
        table.completedAt,
        value,
      );
}

class VerificationSessionTable extends _is.Table<_is.UuidValue?> {
  VerificationSessionTable({super.tableRelation})
    : super(tableName: 'verification_session') {
    updateTable = VerificationSessionUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    identityId = _is.ColumnUuid(
      'identityId',
      this,
    );
    qrToken = _is.ColumnString(
      'qrToken',
      this,
    );
    deviceFingerprint = _is.ColumnString(
      'deviceFingerprint',
      this,
    );
    ipAddress = _is.ColumnString(
      'ipAddress',
      this,
    );
    country = _is.ColumnString(
      'country',
      this,
    );
    countryCode = _is.ColumnString(
      'countryCode',
      this,
    );
    city = _is.ColumnString(
      'city',
      this,
    );
    latitude = _is.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _is.ColumnDouble(
      'longitude',
      this,
    );
    state = _is.ColumnEnum(
      'state',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    outcome = _is.ColumnEnum(
      'outcome',
      this,
      _is.EnumSerialization.byName,
    );
    riskScore = _is.ColumnEnum(
      'riskScore',
      this,
      _is.EnumSerialization.byName,
    );
    source = _is.ColumnEnum(
      'source',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    offlineScanId = _is.ColumnUuid(
      'offlineScanId',
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
    lastStateChange = _is.ColumnDateTime(
      'lastStateChange',
      this,
      hasDefault: true,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    completedAt = _is.ColumnDateTime(
      'completedAt',
      this,
    );
  }

  late final VerificationSessionUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  late final _is.ColumnUuid identityId;

  late final _is.ColumnString qrToken;

  /// Random per device identifier supplied by the client and revalidated on every state change.
  late final _is.ColumnString deviceFingerprint;

  late final _is.ColumnString ipAddress;

  late final _is.ColumnString country;

  late final _is.ColumnString countryCode;

  late final _is.ColumnString city;

  late final _is.ColumnDouble latitude;

  late final _is.ColumnDouble longitude;

  late final _is.ColumnEnum<_ikmf2cvr.VerificationState> state;

  late final _is.ColumnEnum<_iq7ze9sg.VerificationOutcome> outcome;

  late final _is.ColumnEnum<_ikrsd51m.RiskScore> riskScore;

  late final _is.ColumnEnum<_iv29sx9n.ScanSource> source;

  /// Set when this session was created from an offline field scan.
  late final _is.ColumnUuid offlineScanId;

  /// Set when this session was created by an attack simulation run.
  late final _is.ColumnUuid simulationId;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime lastStateChange;

  late final _is.ColumnDateTime expiresAt;

  late final _is.ColumnDateTime completedAt;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    identityId,
    qrToken,
    deviceFingerprint,
    ipAddress,
    country,
    countryCode,
    city,
    latitude,
    longitude,
    state,
    outcome,
    riskScore,
    source,
    offlineScanId,
    simulationId,
    createdAt,
    lastStateChange,
    expiresAt,
    completedAt,
  ];
}

class VerificationSessionInclude extends _is.IncludeObject {
  VerificationSessionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => VerificationSession.t;
}

class VerificationSessionIncludeList extends _is.IncludeList {
  VerificationSessionIncludeList._({
    _is.WhereExpressionBuilder<VerificationSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(VerificationSession.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => VerificationSession.t;
}

class VerificationSessionRepository {
  const VerificationSessionRepository._();

  /// Returns a list of [VerificationSession]s matching the given query parameters.
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
  Future<List<VerificationSession>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VerificationSessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VerificationSessionTable>? orderBy,
    _is.OrderByListBuilder<VerificationSessionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<VerificationSession>(
      where: where?.call(VerificationSession.t),
      orderBy: orderBy?.call(VerificationSession.t),
      orderByList: orderByList?.call(VerificationSession.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [VerificationSession] matching the given query parameters.
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
  Future<VerificationSession?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VerificationSessionTable>? where,
    int? offset,
    _is.OrderByBuilder<VerificationSessionTable>? orderBy,
    _is.OrderByListBuilder<VerificationSessionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<VerificationSession>(
      where: where?.call(VerificationSession.t),
      orderBy: orderBy?.call(VerificationSession.t),
      orderByList: orderByList?.call(VerificationSession.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [VerificationSession] by its [id] or null if no such row exists.
  Future<VerificationSession?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<VerificationSession>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [VerificationSession]s in the list and returns the inserted rows.
  ///
  /// The returned [VerificationSession]s will have their `id` fields set.
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
  Future<List<VerificationSession>> insert(
    _is.DatabaseSession session,
    List<VerificationSession> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<VerificationSession>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [VerificationSession] and returns the inserted row.
  ///
  /// The returned [VerificationSession] will have its `id` field set.
  Future<VerificationSession> insertRow(
    _is.DatabaseSession session,
    VerificationSession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<VerificationSession>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [VerificationSession]s in the list and returns the resulting rows.
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
  /// The returned [VerificationSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<VerificationSession>> upsert(
    _is.DatabaseSession session,
    List<VerificationSession> rows, {
    required _is.ColumnSelections<VerificationSessionTable> conflictColumns,
    _is.ColumnSelections<VerificationSessionTable>? updateColumns,
    _is.WhereExpressionBuilder<VerificationSessionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<VerificationSession>(
      rows,
      conflictColumns: conflictColumns(VerificationSession.t),
      updateColumns: updateColumns?.call(VerificationSession.t),
      updateWhere: updateWhere?.call(VerificationSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [VerificationSession] and returns the resulting row.
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
  /// The returned [VerificationSession] will have its `id` field set.
  Future<VerificationSession?> upsertRow(
    _is.DatabaseSession session,
    VerificationSession row, {
    required _is.ColumnSelections<VerificationSessionTable> conflictColumns,
    _is.ColumnSelections<VerificationSessionTable>? updateColumns,
    _is.WhereExpressionBuilder<VerificationSessionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<VerificationSession>(
      row,
      conflictColumns: conflictColumns(VerificationSession.t),
      updateColumns: updateColumns?.call(VerificationSession.t),
      updateWhere: updateWhere?.call(VerificationSession.t),
      transaction: transaction,
    );
  }

  /// Updates all [VerificationSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<VerificationSession>> update(
    _is.DatabaseSession session,
    List<VerificationSession> rows, {
    _is.ColumnSelections<VerificationSessionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<VerificationSession>(
      rows,
      columns: columns?.call(VerificationSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [VerificationSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<VerificationSession> updateRow(
    _is.DatabaseSession session,
    VerificationSession row, {
    _is.ColumnSelections<VerificationSessionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<VerificationSession>(
      row,
      columns: columns?.call(VerificationSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VerificationSession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<VerificationSession?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<VerificationSessionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<VerificationSession>(
      id,
      columnValues: columnValues(VerificationSession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [VerificationSession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<VerificationSession>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<VerificationSessionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<VerificationSessionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VerificationSessionTable>? orderBy,
    _is.OrderByListBuilder<VerificationSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<VerificationSession>(
      columnValues: columnValues(VerificationSession.t.updateTable),
      where: where(VerificationSession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VerificationSession.t),
      orderByList: orderByList?.call(VerificationSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [VerificationSession]s in the list and returns the deleted rows.
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
  Future<List<VerificationSession>> delete(
    _is.DatabaseSession session,
    List<VerificationSession> rows, {
    _is.OrderByBuilder<VerificationSessionTable>? orderBy,
    _is.OrderByListBuilder<VerificationSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<VerificationSession>(
      rows,
      orderBy: orderBy?.call(VerificationSession.t),
      orderByList: orderByList?.call(VerificationSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [VerificationSession].
  Future<VerificationSession> deleteRow(
    _is.DatabaseSession session,
    VerificationSession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<VerificationSession>(
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
  Future<List<VerificationSession>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<VerificationSessionTable> where,
    _is.OrderByBuilder<VerificationSessionTable>? orderBy,
    _is.OrderByListBuilder<VerificationSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<VerificationSession>(
      where: where(VerificationSession.t),
      orderBy: orderBy?.call(VerificationSession.t),
      orderByList: orderByList?.call(VerificationSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VerificationSessionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<VerificationSession>(
      where: where?.call(VerificationSession.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [VerificationSession] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<VerificationSessionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<VerificationSession>(
      where: where(VerificationSession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
