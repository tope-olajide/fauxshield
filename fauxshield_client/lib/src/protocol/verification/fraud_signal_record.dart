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
import '../enums/signal_type.dart' as _ihijuu0z;

/// One fraud signal produced by the fraud engine for a verification session.
/// Signals are immutable evidence and may be linked to alerts.
abstract class FraudSignalRecord
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FraudSignalRecord._({
    this.id,
    required this.workspaceId,
    required this.sessionId,
    required this.identityId,
    required this.batchId,
    required this.type,
    required this.severity,
    String? dataJson,
    DateTime? detectedAt,
  }) : dataJson = dataJson ?? '{}',
       detectedAt = detectedAt ?? DateTime.now();

  factory FraudSignalRecord({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _isc.UuidValue sessionId,
    required _isc.UuidValue identityId,
    required _isc.UuidValue batchId,
    required _ihijuu0z.SignalType type,
    required _ikrsd51m.RiskScore severity,
    String? dataJson,
    DateTime? detectedAt,
  }) = _FraudSignalRecordImpl;

  factory FraudSignalRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return FraudSignalRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      sessionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['sessionId'],
      ),
      identityId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['identityId'],
      ),
      batchId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['batchId'],
      ),
      type: _ihijuu0z.SignalType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      severity: _ikrsd51m.RiskScore.fromJson(
        (jsonSerialization['severity'] as String),
      ),
      dataJson: jsonSerialization['dataJson'] as String?,
      detectedAt: jsonSerialization['detectedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['detectedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue workspaceId;

  _isc.UuidValue sessionId;

  /// Denormalized for fast batch level queries.
  _isc.UuidValue identityId;

  _isc.UuidValue batchId;

  _ihijuu0z.SignalType type;

  _ikrsd51m.RiskScore severity;

  /// Signal specific structured evidence serialized as JSON.
  String dataJson;

  DateTime detectedAt;

  /// Returns a shallow copy of this [FraudSignalRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FraudSignalRecord copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? sessionId,
    _isc.UuidValue? identityId,
    _isc.UuidValue? batchId,
    _ihijuu0z.SignalType? type,
    _ikrsd51m.RiskScore? severity,
    String? dataJson,
    DateTime? detectedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FraudSignalRecord',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'sessionId': sessionId.toJson(),
      'identityId': identityId.toJson(),
      'batchId': batchId.toJson(),
      'type': type.toJson(),
      'severity': severity.toJson(),
      'dataJson': dataJson,
      'detectedAt': detectedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FraudSignalRecord',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'sessionId': sessionId.toJson(),
      'identityId': identityId.toJson(),
      'batchId': batchId.toJson(),
      'type': type.toJson(),
      'severity': severity.toJson(),
      'dataJson': dataJson,
      'detectedAt': detectedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FraudSignalRecordImpl extends FraudSignalRecord {
  _FraudSignalRecordImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _isc.UuidValue sessionId,
    required _isc.UuidValue identityId,
    required _isc.UuidValue batchId,
    required _ihijuu0z.SignalType type,
    required _ikrsd51m.RiskScore severity,
    String? dataJson,
    DateTime? detectedAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         sessionId: sessionId,
         identityId: identityId,
         batchId: batchId,
         type: type,
         severity: severity,
         dataJson: dataJson,
         detectedAt: detectedAt,
       );

  /// Returns a shallow copy of this [FraudSignalRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FraudSignalRecord copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? sessionId,
    _isc.UuidValue? identityId,
    _isc.UuidValue? batchId,
    _ihijuu0z.SignalType? type,
    _ikrsd51m.RiskScore? severity,
    String? dataJson,
    DateTime? detectedAt,
  }) {
    return FraudSignalRecord(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      sessionId: sessionId ?? this.sessionId,
      identityId: identityId ?? this.identityId,
      batchId: batchId ?? this.batchId,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      dataJson: dataJson ?? this.dataJson,
      detectedAt: detectedAt ?? this.detectedAt,
    );
  }
}
