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
import '../enums/verification_outcome.dart' as _iq7ze9sg;

/// The authoritative verdict for an offline scan after the server processed it.
abstract class OfflineScanVerdict
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  OfflineScanVerdict._({
    required this.localId,
    this.outcome,
    this.riskScore,
    this.sessionId,
    required this.processedAt,
    required this.message,
  });

  factory OfflineScanVerdict({
    required String localId,
    _iq7ze9sg.VerificationOutcome? outcome,
    _ikrsd51m.RiskScore? riskScore,
    _isc.UuidValue? sessionId,
    required DateTime processedAt,
    required String message,
  }) = _OfflineScanVerdictImpl;

  factory OfflineScanVerdict.fromJson(Map<String, dynamic> jsonSerialization) {
    return OfflineScanVerdict(
      localId: jsonSerialization['localId'] as String,
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
      sessionId: jsonSerialization['sessionId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['sessionId'],
            ),
      processedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['processedAt'],
      ),
      message: jsonSerialization['message'] as String,
    );
  }

  String localId;

  _iq7ze9sg.VerificationOutcome? outcome;

  _ikrsd51m.RiskScore? riskScore;

  _isc.UuidValue? sessionId;

  DateTime processedAt;

  String message;

  /// Returns a shallow copy of this [OfflineScanVerdict]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  OfflineScanVerdict copyWith({
    String? localId,
    _iq7ze9sg.VerificationOutcome? outcome,
    _ikrsd51m.RiskScore? riskScore,
    _isc.UuidValue? sessionId,
    DateTime? processedAt,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OfflineScanVerdict',
      'localId': localId,
      if (outcome != null) 'outcome': outcome?.toJson(),
      if (riskScore != null) 'riskScore': riskScore?.toJson(),
      if (sessionId != null) 'sessionId': sessionId?.toJson(),
      'processedAt': processedAt.toJson(),
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OfflineScanVerdict',
      'localId': localId,
      if (outcome != null) 'outcome': outcome?.toJson(),
      if (riskScore != null) 'riskScore': riskScore?.toJson(),
      if (sessionId != null) 'sessionId': sessionId?.toJson(),
      'processedAt': processedAt.toJson(),
      'message': message,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OfflineScanVerdictImpl extends OfflineScanVerdict {
  _OfflineScanVerdictImpl({
    required String localId,
    _iq7ze9sg.VerificationOutcome? outcome,
    _ikrsd51m.RiskScore? riskScore,
    _isc.UuidValue? sessionId,
    required DateTime processedAt,
    required String message,
  }) : super._(
         localId: localId,
         outcome: outcome,
         riskScore: riskScore,
         sessionId: sessionId,
         processedAt: processedAt,
         message: message,
       );

  /// Returns a shallow copy of this [OfflineScanVerdict]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  OfflineScanVerdict copyWith({
    String? localId,
    Object? outcome = _Undefined,
    Object? riskScore = _Undefined,
    Object? sessionId = _Undefined,
    DateTime? processedAt,
    String? message,
  }) {
    return OfflineScanVerdict(
      localId: localId ?? this.localId,
      outcome: outcome is _iq7ze9sg.VerificationOutcome?
          ? outcome
          : this.outcome,
      riskScore: riskScore is _ikrsd51m.RiskScore? ? riskScore : this.riskScore,
      sessionId: sessionId is _isc.UuidValue? ? sessionId : this.sessionId,
      processedAt: processedAt ?? this.processedAt,
      message: message ?? this.message,
    );
  }
}
