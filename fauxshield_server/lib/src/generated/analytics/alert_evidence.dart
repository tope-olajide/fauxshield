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
import '../consumer/fake_report.dart' as _ik5x98gl;
import '../core/batch.dart' as _ij2kxn3i;
import '../core/product.dart' as _ib1643h3;
import '../core/product_identity.dart' as _iriqvrbr;
import '../recall/recall_record.dart' as _iencp73h;
import '../verification/fraud_alert.dart' as _iwg48j9o;
import '../verification/fraud_signal_record.dart' as _ij6wumru;
import '../verification/verification_session.dart' as _inu3bbc1;

/// Everything an investigator or an AI agent needs to understand one alert in a
/// single call: the alert, the identity, the batch and product, every related
/// session, the detected signals, consumer reports, and recall history.
abstract class AlertEvidence
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AlertEvidence._({
    required this.alert,
    this.identity,
    this.batch,
    this.product,
    required this.sessions,
    required this.identitySessions,
    required this.signals,
    required this.reports,
    this.recall,
    required this.generatedAt,
  });

  factory AlertEvidence({
    required _iwg48j9o.FraudAlert alert,
    _iriqvrbr.ProductIdentity? identity,
    _ij2kxn3i.Batch? batch,
    _ib1643h3.Product? product,
    required List<_inu3bbc1.VerificationSession> sessions,
    required List<_inu3bbc1.VerificationSession> identitySessions,
    required List<_ij6wumru.FraudSignalRecord> signals,
    required List<_ik5x98gl.FakeReport> reports,
    _iencp73h.RecallRecord? recall,
    required DateTime generatedAt,
  }) = _AlertEvidenceImpl;

  factory AlertEvidence.fromJson(Map<String, dynamic> jsonSerialization) {
    return AlertEvidence(
      alert: _ipgzzizd.Protocol().deserialize<_iwg48j9o.FraudAlert>(
        jsonSerialization['alert'],
      ),
      identity: jsonSerialization['identity'] == null
          ? null
          : _ipgzzizd.Protocol().deserialize<_iriqvrbr.ProductIdentity>(
              jsonSerialization['identity'],
            ),
      batch: jsonSerialization['batch'] == null
          ? null
          : _ipgzzizd.Protocol().deserialize<_ij2kxn3i.Batch>(
              jsonSerialization['batch'],
            ),
      product: jsonSerialization['product'] == null
          ? null
          : _ipgzzizd.Protocol().deserialize<_ib1643h3.Product>(
              jsonSerialization['product'],
            ),
      sessions: _ipgzzizd.Protocol()
          .deserialize<List<_inu3bbc1.VerificationSession>>(
            jsonSerialization['sessions'],
          ),
      identitySessions: _ipgzzizd.Protocol()
          .deserialize<List<_inu3bbc1.VerificationSession>>(
            jsonSerialization['identitySessions'],
          ),
      signals: _ipgzzizd.Protocol()
          .deserialize<List<_ij6wumru.FraudSignalRecord>>(
            jsonSerialization['signals'],
          ),
      reports: _ipgzzizd.Protocol().deserialize<List<_ik5x98gl.FakeReport>>(
        jsonSerialization['reports'],
      ),
      recall: jsonSerialization['recall'] == null
          ? null
          : _ipgzzizd.Protocol().deserialize<_iencp73h.RecallRecord>(
              jsonSerialization['recall'],
            ),
      generatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
    );
  }

  _iwg48j9o.FraudAlert alert;

  _iriqvrbr.ProductIdentity? identity;

  _ij2kxn3i.Batch? batch;

  _ib1643h3.Product? product;

  /// Sessions directly linked to the alert.
  List<_inu3bbc1.VerificationSession> sessions;

  /// All sessions for the identity, newest first.
  List<_inu3bbc1.VerificationSession> identitySessions;

  List<_ij6wumru.FraudSignalRecord> signals;

  List<_ik5x98gl.FakeReport> reports;

  _iencp73h.RecallRecord? recall;

  DateTime generatedAt;

  /// Returns a shallow copy of this [AlertEvidence]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AlertEvidence copyWith({
    _iwg48j9o.FraudAlert? alert,
    _iriqvrbr.ProductIdentity? identity,
    _ij2kxn3i.Batch? batch,
    _ib1643h3.Product? product,
    List<_inu3bbc1.VerificationSession>? sessions,
    List<_inu3bbc1.VerificationSession>? identitySessions,
    List<_ij6wumru.FraudSignalRecord>? signals,
    List<_ik5x98gl.FakeReport>? reports,
    _iencp73h.RecallRecord? recall,
    DateTime? generatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AlertEvidence',
      'alert': alert.toJson(),
      if (identity != null) 'identity': identity?.toJson(),
      if (batch != null) 'batch': batch?.toJson(),
      if (product != null) 'product': product?.toJson(),
      'sessions': sessions.toJson(valueToJson: (v) => v.toJson()),
      'identitySessions': identitySessions.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'signals': signals.toJson(valueToJson: (v) => v.toJson()),
      'reports': reports.toJson(valueToJson: (v) => v.toJson()),
      if (recall != null) 'recall': recall?.toJson(),
      'generatedAt': generatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AlertEvidence',
      'alert': alert.toJsonForProtocol(),
      if (identity != null) 'identity': identity?.toJsonForProtocol(),
      if (batch != null) 'batch': batch?.toJsonForProtocol(),
      if (product != null) 'product': product?.toJsonForProtocol(),
      'sessions': sessions.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'identitySessions': identitySessions.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'signals': signals.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'reports': reports.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (recall != null) 'recall': recall?.toJsonForProtocol(),
      'generatedAt': generatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AlertEvidenceImpl extends AlertEvidence {
  _AlertEvidenceImpl({
    required _iwg48j9o.FraudAlert alert,
    _iriqvrbr.ProductIdentity? identity,
    _ij2kxn3i.Batch? batch,
    _ib1643h3.Product? product,
    required List<_inu3bbc1.VerificationSession> sessions,
    required List<_inu3bbc1.VerificationSession> identitySessions,
    required List<_ij6wumru.FraudSignalRecord> signals,
    required List<_ik5x98gl.FakeReport> reports,
    _iencp73h.RecallRecord? recall,
    required DateTime generatedAt,
  }) : super._(
         alert: alert,
         identity: identity,
         batch: batch,
         product: product,
         sessions: sessions,
         identitySessions: identitySessions,
         signals: signals,
         reports: reports,
         recall: recall,
         generatedAt: generatedAt,
       );

  /// Returns a shallow copy of this [AlertEvidence]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AlertEvidence copyWith({
    _iwg48j9o.FraudAlert? alert,
    Object? identity = _Undefined,
    Object? batch = _Undefined,
    Object? product = _Undefined,
    List<_inu3bbc1.VerificationSession>? sessions,
    List<_inu3bbc1.VerificationSession>? identitySessions,
    List<_ij6wumru.FraudSignalRecord>? signals,
    List<_ik5x98gl.FakeReport>? reports,
    Object? recall = _Undefined,
    DateTime? generatedAt,
  }) {
    return AlertEvidence(
      alert: alert ?? this.alert.copyWith(),
      identity: identity is _iriqvrbr.ProductIdentity?
          ? identity
          : this.identity?.copyWith(),
      batch: batch is _ij2kxn3i.Batch? ? batch : this.batch?.copyWith(),
      product: product is _ib1643h3.Product?
          ? product
          : this.product?.copyWith(),
      sessions: sessions ?? this.sessions.map((e0) => e0.copyWith()).toList(),
      identitySessions:
          identitySessions ??
          this.identitySessions.map((e0) => e0.copyWith()).toList(),
      signals: signals ?? this.signals.map((e0) => e0.copyWith()).toList(),
      reports: reports ?? this.reports.map((e0) => e0.copyWith()).toList(),
      recall: recall is _iencp73h.RecallRecord?
          ? recall
          : this.recall?.copyWith(),
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }
}
