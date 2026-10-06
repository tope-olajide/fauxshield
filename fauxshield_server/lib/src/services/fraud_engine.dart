import 'package:serverpod/serverpod.dart';

import '../core/geo_dataset.dart';
import '../generated/protocol.dart';
import 'alert_service.dart';
import 'fraud_rules.dart';

/// Result of one complete fraud evaluation.
class FraudEvaluation implements FraudEvaluationLike {
  const FraudEvaluation({
    required this.signals,
    required this.riskScore,
    required this.skippedSignals,
  });

  @override
  final List<SignalAssessment> signals;
  @override
  final RiskScore riskScore;
  final List<String> skippedSignals;
}

/// Evaluates verification sessions for the six fraud signals:
///
/// * `clone_detection`: the same identity scanned in distant locations inside
///   one time window.
/// * `velocity_anomaly`: an unusual number of scans for one token.
/// * `pin_attack`: repeated failed PIN submissions against one identity.
/// * `batch_duplication`: fraud flagged units accumulating inside one batch.
/// * `distributor_leakage`: verification outside the batch's distribution
///   region.
/// * `grey_market`: verification from a country the brand restricted.
///
/// Geographic checks run when the session has coordinates; otherwise they are
/// skipped and reported, so verification never blocks on geo enrichment.
class FraudEngine {
  Future<FraudEvaluation> evaluate(
    Session session, {
    required VerificationSession verificationSession,
    required ProductIdentity identity,
    required Batch batch,
    required Workspace workspace,
    List<SignalAssessment> extraSignals = const <SignalAssessment>[],
  }) async {
    final policy = workspace.fraudPolicy ?? FraudPolicy();
    final signals = <SignalAssessment>[...extraSignals];
    final skipped = <String>[];

    final independent = await Future.wait<SignalAssessment?>([
      _checkVelocity(session, verificationSession, identity, policy),
      _checkPinAttack(session, identity, policy),
      _checkBatchDuplication(session, batch, policy),
    ]);
    signals.addAll(independent.whereType<SignalAssessment>());

    final hasCoordinates =
        verificationSession.latitude != null &&
        verificationSession.longitude != null;
    if (hasCoordinates) {
      final location = GeoResult(
        country: verificationSession.country ?? 'Unknown',
        countryCode: verificationSession.countryCode ?? '',
        city: verificationSession.city ?? 'Unknown',
        latitude: verificationSession.latitude,
        longitude: verificationSession.longitude,
      );
      final geographic = await Future.wait<SignalAssessment?>([
        _checkClone(session, verificationSession, location, policy),
        _checkDistributorLeakage(session, batch, location),
        _checkGreyMarket(session, workspace, location),
      ]);
      signals.addAll(geographic.whereType<SignalAssessment>());
    } else {
      skipped.addAll(<String>[
        'clone_detection',
        'distributor_leakage',
        'grey_market',
      ]);
    }

    return FraudEvaluation(
      signals: signals,
      riskScore: calculateRiskScore(signals),
      skippedSignals: skipped,
    );
  }

  Future<SignalAssessment?> _checkVelocity(
    Session session,
    VerificationSession verificationSession,
    ProductIdentity identity,
    FraudPolicy policy,
  ) async {
    final windowStart = DateTime.now().toUtc().subtract(
      Duration(minutes: policy.velocityWindowMinutes),
    );
    final count = await VerificationSession.db.count(
      session,
      where: (t) =>
          t.identityId.equals(identity.id!) &
          (t.qrToken.equals(verificationSession.qrToken)) &
          (t.createdAt > windowStart),
    );
    if (count < policy.velocityThreshold) return null;
    return SignalAssessment(
      type: SignalType.velocityAnomaly,
      severity: signalSeverity(SignalType.velocityAnomaly),
      reasons: <String>[
        '$count scans in ${policy.velocityWindowMinutes} minutes '
            '(threshold ${policy.velocityThreshold})',
      ],
    );
  }

  Future<SignalAssessment?> _checkPinAttack(
    Session session,
    ProductIdentity identity,
    FraudPolicy policy,
  ) async {
    if (identity.failedPinAttempts < policy.pinAttackThreshold) return null;
    return SignalAssessment(
      type: SignalType.pinAttack,
      severity: signalSeverity(SignalType.pinAttack),
      reasons: <String>[
        '${identity.failedPinAttempts} failed PIN attempts '
            '(threshold ${policy.pinAttackThreshold})',
      ],
    );
  }

  Future<SignalAssessment?> _checkBatchDuplication(
    Session session,
    Batch batch,
    FraudPolicy policy,
  ) async {
    // Count distinct identities in this batch that already carry signals.
    final flaggedSignals = await FraudSignalRecord.db.find(
      session,
      where: (t) =>
          t.batchId.equals(batch.id!) &
          t.type.notEquals(SignalType.offlineBackfill),
      limit: 500,
    );
    final distinctIdentities = <String>{};
    for (final signal in flaggedSignals) {
      distinctIdentities.add(signal.identityId.uuid);
    }
    if (distinctIdentities.length < policy.batchDuplicationThreshold) {
      return null;
    }
    return SignalAssessment(
      type: SignalType.batchDuplication,
      severity: signalSeverity(SignalType.batchDuplication),
      reasons: <String>[
        '${distinctIdentities.length} units in this batch carry fraud signals '
            '(threshold ${policy.batchDuplicationThreshold})',
      ],
    );
  }

  Future<SignalAssessment?> _checkClone(
    Session session,
    VerificationSession verificationSession,
    GeoResult location,
    FraudPolicy policy,
  ) async {
    final latitude = location.latitude;
    final longitude = location.longitude;
    if (latitude == null || longitude == null) return null;

    final windowStart = DateTime.now().toUtc().subtract(
      Duration(minutes: policy.cloneWindowMinutes),
    );
    final previous = await VerificationSession.db.find(
      session,
      where: (t) =>
          t.identityId.equals(verificationSession.identityId) &
          t.id.notInSet(<UuidValue>{verificationSession.id!}) &
          (t.createdAt > windowStart) &
          t.latitude.notEquals(null) &
          t.longitude.notEquals(null),
      orderBy: (t) => t.createdAt.desc(),
      limit: 20,
    );

    for (final other in previous) {
      final otherLatitude = other.latitude;
      final otherLongitude = other.longitude;
      if (otherLatitude == null || otherLongitude == null) continue;
      final distance = haversineDistanceKm(
        latitude,
        longitude,
        otherLatitude,
        otherLongitude,
      );
      if (distance > policy.cloneDistanceThresholdKm) {
        return SignalAssessment(
          type: SignalType.cloneDetection,
          severity: signalSeverity(SignalType.cloneDetection),
          reasons: <String>[
            'Impossible travel: ${distance.round()} km apart within '
                '${policy.cloneWindowMinutes} minutes '
                '(threshold ${policy.cloneDistanceThresholdKm} km)',
          ],
        );
      }
    }
    return null;
  }

  Future<SignalAssessment?> _checkDistributorLeakage(
    Session session,
    Batch batch,
    GeoResult location,
  ) async {
    final region = batch.distributionRegion.trim();
    if (region.isEmpty) return null;
    final normalizedRegion = region.toUpperCase();
    final country = location.country.toUpperCase();
    final code = location.countryCode.toUpperCase();
    final matches =
        normalizedRegion == country ||
        normalizedRegion == code ||
        country == code;
    if (matches) return null;
    return SignalAssessment(
      type: SignalType.distributorLeakage,
      severity: signalSeverity(SignalType.distributorLeakage),
      reasons: <String>[
        'Verified in ${location.country} but batch is distributed in $region',
      ],
    );
  }

  Future<SignalAssessment?> _checkGreyMarket(
    Session session,
    Workspace workspace,
    GeoResult location,
  ) async {
    final restricted = workspace.restrictedCountries;
    if (restricted == null || restricted.isEmpty) return null;
    final country = location.country.toUpperCase();
    final code = location.countryCode.toUpperCase();
    final isRestricted = restricted.any((entry) {
      final normalized = entry.trim().toUpperCase();
      return normalized == country || normalized == code;
    });
    if (!isRestricted) return null;
    return SignalAssessment(
      type: SignalType.greyMarket,
      severity: signalSeverity(SignalType.greyMarket),
      reasons: <String>[
        'Verified in restricted market ${location.country}',
      ],
    );
  }
}
