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
import '../enums/alert_severity.dart' as _ivfuu0vh;
import '../enums/live_event_type.dart' as _ipqmis7l;
import '../enums/risk_score.dart' as _ikrsd51m;
import '../enums/verification_outcome.dart' as _iq7ze9sg;

/// A live event pushed to connected operator apps over Serverpod's streaming
/// APIs. Events cover verifications, fraud alerts, recalls, offline ingest, and
/// simulation progress so the command center updates in real time.
abstract class LiveEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LiveEvent._({
    required this.type,
    required this.workspaceId,
    required this.occurredAt,
    required this.title,
    this.subtitle,
    this.severity,
    this.outcome,
    this.riskScore,
    this.country,
    this.countryCode,
    this.city,
    this.latitude,
    this.longitude,
    this.identityId,
    this.sessionId,
    this.alertId,
    this.batchId,
    this.payloadJson,
  });

  factory LiveEvent({
    required _ipqmis7l.LiveEventType type,
    required _isc.UuidValue workspaceId,
    required DateTime occurredAt,
    required String title,
    String? subtitle,
    _ivfuu0vh.AlertSeverity? severity,
    _iq7ze9sg.VerificationOutcome? outcome,
    _ikrsd51m.RiskScore? riskScore,
    String? country,
    String? countryCode,
    String? city,
    double? latitude,
    double? longitude,
    _isc.UuidValue? identityId,
    _isc.UuidValue? sessionId,
    _isc.UuidValue? alertId,
    _isc.UuidValue? batchId,
    String? payloadJson,
  }) = _LiveEventImpl;

  factory LiveEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return LiveEvent(
      type: _ipqmis7l.LiveEventType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      occurredAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurredAt'],
      ),
      title: jsonSerialization['title'] as String,
      subtitle: jsonSerialization['subtitle'] as String?,
      severity: jsonSerialization['severity'] == null
          ? null
          : _ivfuu0vh.AlertSeverity.fromJson(
              (jsonSerialization['severity'] as String),
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
      country: jsonSerialization['country'] as String?,
      countryCode: jsonSerialization['countryCode'] as String?,
      city: jsonSerialization['city'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      identityId: jsonSerialization['identityId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['identityId'],
            ),
      sessionId: jsonSerialization['sessionId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['sessionId'],
            ),
      alertId: jsonSerialization['alertId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['alertId']),
      batchId: jsonSerialization['batchId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['batchId']),
      payloadJson: jsonSerialization['payloadJson'] as String?,
    );
  }

  _ipqmis7l.LiveEventType type;

  _isc.UuidValue workspaceId;

  DateTime occurredAt;

  String title;

  String? subtitle;

  _ivfuu0vh.AlertSeverity? severity;

  _iq7ze9sg.VerificationOutcome? outcome;

  _ikrsd51m.RiskScore? riskScore;

  String? country;

  String? countryCode;

  String? city;

  double? latitude;

  double? longitude;

  _isc.UuidValue? identityId;

  _isc.UuidValue? sessionId;

  _isc.UuidValue? alertId;

  _isc.UuidValue? batchId;

  /// Event specific structured extras serialized as JSON.
  String? payloadJson;

  /// Returns a shallow copy of this [LiveEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LiveEvent copyWith({
    _ipqmis7l.LiveEventType? type,
    _isc.UuidValue? workspaceId,
    DateTime? occurredAt,
    String? title,
    String? subtitle,
    _ivfuu0vh.AlertSeverity? severity,
    _iq7ze9sg.VerificationOutcome? outcome,
    _ikrsd51m.RiskScore? riskScore,
    String? country,
    String? countryCode,
    String? city,
    double? latitude,
    double? longitude,
    _isc.UuidValue? identityId,
    _isc.UuidValue? sessionId,
    _isc.UuidValue? alertId,
    _isc.UuidValue? batchId,
    String? payloadJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LiveEvent',
      'type': type.toJson(),
      'workspaceId': workspaceId.toJson(),
      'occurredAt': occurredAt.toJson(),
      'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (severity != null) 'severity': severity?.toJson(),
      if (outcome != null) 'outcome': outcome?.toJson(),
      if (riskScore != null) 'riskScore': riskScore?.toJson(),
      if (country != null) 'country': country,
      if (countryCode != null) 'countryCode': countryCode,
      if (city != null) 'city': city,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (identityId != null) 'identityId': identityId?.toJson(),
      if (sessionId != null) 'sessionId': sessionId?.toJson(),
      if (alertId != null) 'alertId': alertId?.toJson(),
      if (batchId != null) 'batchId': batchId?.toJson(),
      if (payloadJson != null) 'payloadJson': payloadJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LiveEvent',
      'type': type.toJson(),
      'workspaceId': workspaceId.toJson(),
      'occurredAt': occurredAt.toJson(),
      'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (severity != null) 'severity': severity?.toJson(),
      if (outcome != null) 'outcome': outcome?.toJson(),
      if (riskScore != null) 'riskScore': riskScore?.toJson(),
      if (country != null) 'country': country,
      if (countryCode != null) 'countryCode': countryCode,
      if (city != null) 'city': city,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (identityId != null) 'identityId': identityId?.toJson(),
      if (sessionId != null) 'sessionId': sessionId?.toJson(),
      if (alertId != null) 'alertId': alertId?.toJson(),
      if (batchId != null) 'batchId': batchId?.toJson(),
      if (payloadJson != null) 'payloadJson': payloadJson,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LiveEventImpl extends LiveEvent {
  _LiveEventImpl({
    required _ipqmis7l.LiveEventType type,
    required _isc.UuidValue workspaceId,
    required DateTime occurredAt,
    required String title,
    String? subtitle,
    _ivfuu0vh.AlertSeverity? severity,
    _iq7ze9sg.VerificationOutcome? outcome,
    _ikrsd51m.RiskScore? riskScore,
    String? country,
    String? countryCode,
    String? city,
    double? latitude,
    double? longitude,
    _isc.UuidValue? identityId,
    _isc.UuidValue? sessionId,
    _isc.UuidValue? alertId,
    _isc.UuidValue? batchId,
    String? payloadJson,
  }) : super._(
         type: type,
         workspaceId: workspaceId,
         occurredAt: occurredAt,
         title: title,
         subtitle: subtitle,
         severity: severity,
         outcome: outcome,
         riskScore: riskScore,
         country: country,
         countryCode: countryCode,
         city: city,
         latitude: latitude,
         longitude: longitude,
         identityId: identityId,
         sessionId: sessionId,
         alertId: alertId,
         batchId: batchId,
         payloadJson: payloadJson,
       );

  /// Returns a shallow copy of this [LiveEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LiveEvent copyWith({
    _ipqmis7l.LiveEventType? type,
    _isc.UuidValue? workspaceId,
    DateTime? occurredAt,
    String? title,
    Object? subtitle = _Undefined,
    Object? severity = _Undefined,
    Object? outcome = _Undefined,
    Object? riskScore = _Undefined,
    Object? country = _Undefined,
    Object? countryCode = _Undefined,
    Object? city = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? identityId = _Undefined,
    Object? sessionId = _Undefined,
    Object? alertId = _Undefined,
    Object? batchId = _Undefined,
    Object? payloadJson = _Undefined,
  }) {
    return LiveEvent(
      type: type ?? this.type,
      workspaceId: workspaceId ?? this.workspaceId,
      occurredAt: occurredAt ?? this.occurredAt,
      title: title ?? this.title,
      subtitle: subtitle is String? ? subtitle : this.subtitle,
      severity: severity is _ivfuu0vh.AlertSeverity? ? severity : this.severity,
      outcome: outcome is _iq7ze9sg.VerificationOutcome?
          ? outcome
          : this.outcome,
      riskScore: riskScore is _ikrsd51m.RiskScore? ? riskScore : this.riskScore,
      country: country is String? ? country : this.country,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
      city: city is String? ? city : this.city,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      identityId: identityId is _isc.UuidValue? ? identityId : this.identityId,
      sessionId: sessionId is _isc.UuidValue? ? sessionId : this.sessionId,
      alertId: alertId is _isc.UuidValue? ? alertId : this.alertId,
      batchId: batchId is _isc.UuidValue? ? batchId : this.batchId,
      payloadJson: payloadJson is String? ? payloadJson : this.payloadJson,
    );
  }
}
