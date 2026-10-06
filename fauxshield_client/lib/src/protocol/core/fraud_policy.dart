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

/// Per-workspace fraud detection policy. Every threshold can be tuned per brand.
abstract class FraudPolicy
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FraudPolicy._({
    int? velocityWindowMinutes,
    int? velocityThreshold,
    int? pinAttackThreshold,
    int? batchDuplicationThreshold,
    int? cloneWindowMinutes,
    int? cloneDistanceThresholdKm,
    int? geoIpTimeoutMs,
    int? evaluationBudgetMs,
    bool? autoLockOnFraud,
    bool? alertOnHigh,
  }) : velocityWindowMinutes = velocityWindowMinutes ?? 60,
       velocityThreshold = velocityThreshold ?? 10,
       pinAttackThreshold = pinAttackThreshold ?? 5,
       batchDuplicationThreshold = batchDuplicationThreshold ?? 3,
       cloneWindowMinutes = cloneWindowMinutes ?? 60,
       cloneDistanceThresholdKm = cloneDistanceThresholdKm ?? 100,
       geoIpTimeoutMs = geoIpTimeoutMs ?? 500,
       evaluationBudgetMs = evaluationBudgetMs ?? 2000,
       autoLockOnFraud = autoLockOnFraud ?? true,
       alertOnHigh = alertOnHigh ?? true;

  factory FraudPolicy({
    int? velocityWindowMinutes,
    int? velocityThreshold,
    int? pinAttackThreshold,
    int? batchDuplicationThreshold,
    int? cloneWindowMinutes,
    int? cloneDistanceThresholdKm,
    int? geoIpTimeoutMs,
    int? evaluationBudgetMs,
    bool? autoLockOnFraud,
    bool? alertOnHigh,
  }) = _FraudPolicyImpl;

  factory FraudPolicy.fromJson(Map<String, dynamic> jsonSerialization) {
    return FraudPolicy(
      velocityWindowMinutes: jsonSerialization['velocityWindowMinutes'] as int?,
      velocityThreshold: jsonSerialization['velocityThreshold'] as int?,
      pinAttackThreshold: jsonSerialization['pinAttackThreshold'] as int?,
      batchDuplicationThreshold:
          jsonSerialization['batchDuplicationThreshold'] as int?,
      cloneWindowMinutes: jsonSerialization['cloneWindowMinutes'] as int?,
      cloneDistanceThresholdKm:
          jsonSerialization['cloneDistanceThresholdKm'] as int?,
      geoIpTimeoutMs: jsonSerialization['geoIpTimeoutMs'] as int?,
      evaluationBudgetMs: jsonSerialization['evaluationBudgetMs'] as int?,
      autoLockOnFraud: jsonSerialization['autoLockOnFraud'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['autoLockOnFraud'],
            ),
      alertOnHigh: jsonSerialization['alertOnHigh'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['alertOnHigh']),
    );
  }

  /// Time window for velocity checks in minutes.
  int velocityWindowMinutes;

  /// Verification attempts for one identity within the window before a velocity signal.
  int velocityThreshold;

  /// Failed PIN attempts on one identity before a pin attack signal.
  int pinAttackThreshold;

  /// Fraud flagged identities in one batch before a batch duplication signal.
  int batchDuplicationThreshold;

  /// Time window for clone detection in minutes.
  int cloneWindowMinutes;

  /// Distance in kilometers between two scans of one identity that counts as impossible travel.
  int cloneDistanceThresholdKm;

  /// Geo lookup budget in milliseconds.
  int geoIpTimeoutMs;

  /// Total fraud evaluation budget in milliseconds.
  int evaluationBudgetMs;

  /// Automatically lock identities when fraud is suspected.
  bool autoLockOnFraud;

  /// Create fraud alerts for high risk results.
  bool alertOnHigh;

  /// Returns a shallow copy of this [FraudPolicy]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FraudPolicy copyWith({
    int? velocityWindowMinutes,
    int? velocityThreshold,
    int? pinAttackThreshold,
    int? batchDuplicationThreshold,
    int? cloneWindowMinutes,
    int? cloneDistanceThresholdKm,
    int? geoIpTimeoutMs,
    int? evaluationBudgetMs,
    bool? autoLockOnFraud,
    bool? alertOnHigh,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FraudPolicy',
      'velocityWindowMinutes': velocityWindowMinutes,
      'velocityThreshold': velocityThreshold,
      'pinAttackThreshold': pinAttackThreshold,
      'batchDuplicationThreshold': batchDuplicationThreshold,
      'cloneWindowMinutes': cloneWindowMinutes,
      'cloneDistanceThresholdKm': cloneDistanceThresholdKm,
      'geoIpTimeoutMs': geoIpTimeoutMs,
      'evaluationBudgetMs': evaluationBudgetMs,
      'autoLockOnFraud': autoLockOnFraud,
      'alertOnHigh': alertOnHigh,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FraudPolicy',
      'velocityWindowMinutes': velocityWindowMinutes,
      'velocityThreshold': velocityThreshold,
      'pinAttackThreshold': pinAttackThreshold,
      'batchDuplicationThreshold': batchDuplicationThreshold,
      'cloneWindowMinutes': cloneWindowMinutes,
      'cloneDistanceThresholdKm': cloneDistanceThresholdKm,
      'geoIpTimeoutMs': geoIpTimeoutMs,
      'evaluationBudgetMs': evaluationBudgetMs,
      'autoLockOnFraud': autoLockOnFraud,
      'alertOnHigh': alertOnHigh,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _FraudPolicyImpl extends FraudPolicy {
  _FraudPolicyImpl({
    int? velocityWindowMinutes,
    int? velocityThreshold,
    int? pinAttackThreshold,
    int? batchDuplicationThreshold,
    int? cloneWindowMinutes,
    int? cloneDistanceThresholdKm,
    int? geoIpTimeoutMs,
    int? evaluationBudgetMs,
    bool? autoLockOnFraud,
    bool? alertOnHigh,
  }) : super._(
         velocityWindowMinutes: velocityWindowMinutes,
         velocityThreshold: velocityThreshold,
         pinAttackThreshold: pinAttackThreshold,
         batchDuplicationThreshold: batchDuplicationThreshold,
         cloneWindowMinutes: cloneWindowMinutes,
         cloneDistanceThresholdKm: cloneDistanceThresholdKm,
         geoIpTimeoutMs: geoIpTimeoutMs,
         evaluationBudgetMs: evaluationBudgetMs,
         autoLockOnFraud: autoLockOnFraud,
         alertOnHigh: alertOnHigh,
       );

  /// Returns a shallow copy of this [FraudPolicy]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FraudPolicy copyWith({
    int? velocityWindowMinutes,
    int? velocityThreshold,
    int? pinAttackThreshold,
    int? batchDuplicationThreshold,
    int? cloneWindowMinutes,
    int? cloneDistanceThresholdKm,
    int? geoIpTimeoutMs,
    int? evaluationBudgetMs,
    bool? autoLockOnFraud,
    bool? alertOnHigh,
  }) {
    return FraudPolicy(
      velocityWindowMinutes:
          velocityWindowMinutes ?? this.velocityWindowMinutes,
      velocityThreshold: velocityThreshold ?? this.velocityThreshold,
      pinAttackThreshold: pinAttackThreshold ?? this.pinAttackThreshold,
      batchDuplicationThreshold:
          batchDuplicationThreshold ?? this.batchDuplicationThreshold,
      cloneWindowMinutes: cloneWindowMinutes ?? this.cloneWindowMinutes,
      cloneDistanceThresholdKm:
          cloneDistanceThresholdKm ?? this.cloneDistanceThresholdKm,
      geoIpTimeoutMs: geoIpTimeoutMs ?? this.geoIpTimeoutMs,
      evaluationBudgetMs: evaluationBudgetMs ?? this.evaluationBudgetMs,
      autoLockOnFraud: autoLockOnFraud ?? this.autoLockOnFraud,
      alertOnHigh: alertOnHigh ?? this.alertOnHigh,
    );
  }
}
