import '../generated/protocol.dart';

/// One evaluated signal, before it is persisted.
class SignalAssessment {
  const SignalAssessment({
    required this.type,
    required this.severity,
    required this.reasons,
  });

  final SignalType type;
  final RiskScore severity;
  final List<String> reasons;
}

/// Human readable label for a signal type.
String signalLabel(SignalType type) {
  switch (type) {
    case SignalType.cloneDetection:
      return 'Clone detection';
    case SignalType.velocityAnomaly:
      return 'Velocity anomaly';
    case SignalType.pinAttack:
      return 'PIN attack';
    case SignalType.batchDuplication:
      return 'Batch duplication';
    case SignalType.distributorLeakage:
      return 'Distributor leakage';
    case SignalType.greyMarket:
      return 'Grey market';
    case SignalType.offlineBackfill:
      return 'Offline backfill';
    case SignalType.pinLockout:
      return 'PIN lockout';
  }
}

/// Base severity per signal type. The engine may raise but never lower these.
RiskScore signalSeverity(SignalType type) {
  switch (type) {
    case SignalType.cloneDetection:
      return RiskScore.high;
    case SignalType.batchDuplication:
      return RiskScore.high;
    case SignalType.velocityAnomaly:
      return RiskScore.medium;
    case SignalType.pinAttack:
      return RiskScore.medium;
    case SignalType.distributorLeakage:
      return RiskScore.medium;
    case SignalType.greyMarket:
      return RiskScore.medium;
    case SignalType.offlineBackfill:
      return RiskScore.low;
    case SignalType.pinLockout:
      return RiskScore.medium;
  }
}

/// Suggested operator action for a signal type.
String signalRecommendedAction(SignalType type) {
  switch (type) {
    case SignalType.cloneDetection:
      return 'Inspect the physical product and compare packaging with the original batch.';
    case SignalType.velocityAnomaly:
      return 'Check where the code was printed and whether it leaked to a scannable channel.';
    case SignalType.pinAttack:
      return 'Treat the printed code as compromised and regenerate the identity token.';
    case SignalType.batchDuplication:
      return 'Quarantine the batch and audit the printing and shipping steps.';
    case SignalType.distributorLeakage:
      return 'Contact the distributor responsible for the region and verify the shipment.';
    case SignalType.greyMarket:
      return 'Review the restricted market policy and alert the regional partner.';
    case SignalType.offlineBackfill:
      return 'Review the field scan route and confirm the recorded locations.';
    case SignalType.pinLockout:
      return 'Monitor further PIN attempts; the identity is temporarily locked.';
  }
}

const List<RiskScore> _riskRanking = <RiskScore>[
  RiskScore.low,
  RiskScore.medium,
  RiskScore.high,
  RiskScore.fraudSuspected,
];

int riskRank(RiskScore score) => _riskRanking.indexOf(score);

/// Calculates the overall risk score from a list of signals.
///
/// Rules:
/// * No signals gives low risk.
/// * Otherwise the highest severity signal sets the floor.
/// * Any high severity signal combined with at least one more signal escalates
///   to fraud suspected.
RiskScore calculateRiskScore(List<SignalAssessment> signals) {
  if (signals.isEmpty) return RiskScore.low;

  var maxRank = 0;
  var hasHigh = false;
  for (final signal in signals) {
    final rank = riskRank(signal.severity);
    if (rank > maxRank) maxRank = rank;
    if (signal.severity == RiskScore.high) hasHigh = true;
  }

  if (hasHigh && signals.length > 1) {
    return RiskScore.fraudSuspected;
  }
  return _riskRanking[maxRank];
}

/// Severity of the alert that should be created for a risk score.
AlertSeverity alertSeverityFor(RiskScore score) {
  switch (score) {
    case RiskScore.low:
      return AlertSeverity.low;
    case RiskScore.medium:
      return AlertSeverity.medium;
    case RiskScore.high:
      return AlertSeverity.high;
    case RiskScore.fraudSuspected:
      return AlertSeverity.critical;
  }
}

/// Whether the risk score warrants a fraud alert under the workspace policy.
bool shouldAlert(RiskScore score, FraudPolicy policy) {
  switch (score) {
    case RiskScore.low:
    case RiskScore.medium:
      return false;
    case RiskScore.high:
      return policy.alertOnHigh;
    case RiskScore.fraudSuspected:
      return true;
  }
}

/// Whether the platform should lock the identity for this risk score.
bool shouldLockIdentity(RiskScore score, FraudPolicy policy) =>
    policy.autoLockOnFraud && score == RiskScore.fraudSuspected;
