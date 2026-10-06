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
import '../enums/risk_score.dart' as _ikrsd51m;
import '../enums/scan_source.dart' as _iv29sx9n;
import '../enums/verification_outcome.dart' as _iq7ze9sg;
import '../enums/verification_state.dart' as _ikmf2cvr;

/// A stateful consumer verification attempt. Sessions are bound to a device
/// fingerprint and expire after 15 minutes of inactivity. Fraud evaluation runs
/// before the session can advance to PIN entry.
abstract class VerificationSession
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _isc.UuidValue identityId,
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
    _isc.UuidValue? offlineScanId,
    _isc.UuidValue? simulationId,
    DateTime? createdAt,
    DateTime? lastStateChange,
    required DateTime expiresAt,
    DateTime? completedAt,
  }) = _VerificationSessionImpl;

  factory VerificationSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return VerificationSession(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      identityId: _isc.UuidValueJsonExtension.fromJson(
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
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['offlineScanId'],
            ),
      simulationId: jsonSerialization['simulationId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['simulationId'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastStateChange: jsonSerialization['lastStateChange'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastStateChange'],
            ),
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue workspaceId;

  _isc.UuidValue identityId;

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
  _isc.UuidValue? offlineScanId;

  /// Set when this session was created by an attack simulation run.
  _isc.UuidValue? simulationId;

  DateTime createdAt;

  DateTime lastStateChange;

  DateTime expiresAt;

  DateTime? completedAt;

  /// Returns a shallow copy of this [VerificationSession]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  VerificationSession copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? identityId,
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
    _isc.UuidValue? offlineScanId,
    _isc.UuidValue? simulationId,
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VerificationSessionImpl extends VerificationSession {
  _VerificationSessionImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _isc.UuidValue identityId,
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
    _isc.UuidValue? offlineScanId,
    _isc.UuidValue? simulationId,
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
  @_isc.useResult
  @override
  VerificationSession copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? identityId,
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
      id: id is _isc.UuidValue? ? id : this.id,
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
      offlineScanId: offlineScanId is _isc.UuidValue?
          ? offlineScanId
          : this.offlineScanId,
      simulationId: simulationId is _isc.UuidValue?
          ? simulationId
          : this.simulationId,
      createdAt: createdAt ?? this.createdAt,
      lastStateChange: lastStateChange ?? this.lastStateChange,
      expiresAt: expiresAt ?? this.expiresAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}
