import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

/// Short human label for a verification outcome.
String outcomeLabel(VerificationOutcome? outcome) {
  switch (outcome) {
    case VerificationOutcome.authentic:
      return 'Authentic';
    case VerificationOutcome.alreadyVerified:
      return 'Already verified';
    case VerificationOutcome.invalidPin:
      return 'Invalid PIN';
    case VerificationOutcome.fraudSuspected:
      return 'Fraud suspected';
    case VerificationOutcome.highRisk:
      return 'High risk';
    case VerificationOutcome.recalled:
      return 'Recalled';
    case null:
      return 'Pending';
  }
}

/// Icon for a verification outcome.
IconData outcomeIcon(VerificationOutcome? outcome) {
  switch (outcome) {
    case VerificationOutcome.authentic:
      return Icons.verified_rounded;
    case VerificationOutcome.alreadyVerified:
      return Icons.replay_circle_filled_rounded;
    case VerificationOutcome.invalidPin:
      return Icons.pin_rounded;
    case VerificationOutcome.fraudSuspected:
      return Icons.dangerous_rounded;
    case VerificationOutcome.highRisk:
      return Icons.warning_amber_rounded;
    case VerificationOutcome.recalled:
      return Icons.campaign_rounded;
    case null:
      return Icons.hourglass_empty_rounded;
  }
}

/// Color for a verification outcome.
Color outcomeColor(BuildContext context, VerificationOutcome? outcome) {
  final scheme = Theme.of(context).colorScheme;
  switch (outcome) {
    case VerificationOutcome.authentic:
      return const Color(0xFF0F7B4D);
    case VerificationOutcome.alreadyVerified:
      return const Color(0xFF2563EB);
    case VerificationOutcome.invalidPin:
      return const Color(0xFFB45309);
    case VerificationOutcome.fraudSuspected:
      return scheme.error;
    case VerificationOutcome.highRisk:
      return const Color(0xFFB45309);
    case VerificationOutcome.recalled:
      return const Color(0xFF9F1239);
    case null:
      return scheme.outline;
  }
}

/// Color for an alert severity.
Color severityColor(BuildContext context, AlertSeverity severity) {
  final scheme = Theme.of(context).colorScheme;
  switch (severity) {
    case AlertSeverity.low:
      return const Color(0xFF2563EB);
    case AlertSeverity.medium:
      return const Color(0xFFB45309);
    case AlertSeverity.high:
      return const Color(0xFFC2410C);
    case AlertSeverity.critical:
      return scheme.error;
  }
}

/// Human label for a fraud signal.
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

/// Human label for a live event type.
String liveEventLabel(LiveEventType type) {
  switch (type) {
    case LiveEventType.verificationCompleted:
      return 'Verification';
    case LiveEventType.fraudAlertCreated:
      return 'Fraud alert';
    case LiveEventType.fraudAlertUpdated:
      return 'Alert update';
    case LiveEventType.batchRecalled:
      return 'Recall';
    case LiveEventType.identityStatusChanged:
      return 'Identity status';
    case LiveEventType.offlineScanIngested:
      return 'Offline scan';
    case LiveEventType.simulationProgress:
      return 'Simulation';
    case LiveEventType.fakeReportCreated:
      return 'Consumer report';
  }
}

/// Icon for a live event type.
IconData liveEventIcon(LiveEventType type) {
  switch (type) {
    case LiveEventType.verificationCompleted:
      return Icons.qr_code_scanner_rounded;
    case LiveEventType.fraudAlertCreated:
      return Icons.gpp_maybe_rounded;
    case LiveEventType.fraudAlertUpdated:
      return Icons.rule_rounded;
    case LiveEventType.batchRecalled:
      return Icons.campaign_rounded;
    case LiveEventType.identityStatusChanged:
      return Icons.lock_rounded;
    case LiveEventType.offlineScanIngested:
      return Icons.cloud_sync_rounded;
    case LiveEventType.simulationProgress:
      return Icons.science_rounded;
    case LiveEventType.fakeReportCreated:
      return Icons.report_rounded;
  }
}

/// Formats a timestamp as a compact relative string.
String relativeTime(DateTime moment) {
  final now = DateTime.now().toUtc();
  final delta = now.difference(moment.toUtc());
  if (delta.inSeconds < 45) return 'just now';
  if (delta.inMinutes < 60) return '${delta.inMinutes}m ago';
  if (delta.inHours < 24) return '${delta.inHours}h ago';
  if (delta.inDays < 7) return '${delta.inDays}d ago';
  return '${moment.year}-${_pad(moment.month)}-${_pad(moment.day)}';
}

/// Formats a date as YYYY-MM-DD.
String shortDate(DateTime moment) =>
    '${moment.year}-${_pad(moment.month)}-${_pad(moment.day)}';

String _pad(int value) => value.toString().padLeft(2, '0');

/// Human label for a membership role.
String roleLabel(MembershipRole role) {
  switch (role) {
    case MembershipRole.viewer:
      return 'Viewer';
    case MembershipRole.member:
      return 'Member';
    case MembershipRole.admin:
      return 'Admin';
    case MembershipRole.owner:
      return 'Owner';
  }
}

/// Human label for a simulation type.
String simulationTypeLabel(SimulationType type) {
  switch (type) {
    case SimulationType.cloneAttack:
      return 'Clone attack';
    case SimulationType.pinBruteForce:
      return 'PIN brute force';
    case SimulationType.scanBurst:
      return 'Scan burst';
    case SimulationType.greyMarketLeak:
      return 'Grey market leak';
  }
}
