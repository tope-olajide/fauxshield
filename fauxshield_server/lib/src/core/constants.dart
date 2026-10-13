/// Platform wide constants and safety bounds.
///
/// These values are deliberate implementation defaults, documented in the
/// README so operators know exactly what the platform enforces.
abstract final class FauxShieldLimits {
  /// Verification sessions expire after this much inactivity.
  static const Duration sessionExpiry = Duration(minutes: 15);

  /// Failed PIN attempts on one identity before a temporary lockout.
  static const int pinLockoutThreshold = 5;

  /// How long PIN submissions stay locked after the threshold is reached.
  static const Duration pinLockoutDuration = Duration(minutes: 15);

  /// Total budget for one fraud evaluation.
  static const Duration fraudEvaluationBudget = Duration(seconds: 2);

  /// Budget for one geo lookup.
  ///
  /// This wraps a real HTTPS call to a geolocation service, so it has to cover
  /// a cold connection: DNS, TCP, TLS, and the response. Measured against
  /// ipwho.is the round trip alone ran 0.6-0.8s, and a 500ms budget failed
  /// intermittently — which surfaced to consumers as an unknown location, and
  /// before the fabricated fallback was removed, as an invented city.
  static const Duration geoLookupTimeout = Duration(milliseconds: 1500);

  /// Maximum rows returned by a synchronous identity export.
  static const int maxExportRows = 10000;

  /// Audit queries are capped at this many rows per page.
  static const int maxAuditPageSize = 100;

  /// Batch list queries are capped at this many rows per page.
  static const int maxPageSize = 50;

  /// Idempotency records are retained this long.
  static const Duration idempotencyRetention = Duration(hours: 24);

  /// Fake reports per device and identity within 24 hours.
  static const int fakeReportsPerDayPerIdentity = 3;

  /// Consecutive delivery failures before an endpoint is disabled.
  static const int webhookDisableThreshold = 20;

  /// Webhook delivery attempts before a delivery is marked failed.
  static const int webhookMaxAttempts = 5;

  /// How often the webhook outbox is drained.
  static const Duration webhookDrainInterval = Duration(seconds: 30);

  /// How often queued offline scans are converted into sessions.
  static const Duration offlineScanProcessInterval = Duration(seconds: 45);

  /// How often attack simulations advance their next step.
  static const Duration simulationTickInterval = Duration(seconds: 2);

  /// Optional demo/seed tooling is gated behind this secret name.
  static const String seedSecretName = 'demoSeedSecret';

  /// API key prefix shown to operators.
  static const String apiKeyPrefix = 'fs_live_';

  /// PIN length printed on packaging.
  static const int pinLength = 6;

  /// Maximum page of results returned in one call.
  static const int maxVerificationPageSize = 100;

  /// Offline scans accepted in one upload batch.
  static const int maxOfflineBatchSize = 200;

  /// A scan older than this when it reaches the server is flagged as a
  /// backfilled scan so fraud analysis can weigh the delay.
  static const Duration offlineBackfillThreshold = Duration(hours: 1);

  /// Safety bound for inline simulation runs.
  static const int maxSimulationSteps = 120;

  /// Default seconds between scheduled simulation steps.
  static const int defaultSimulationStepSeconds = 2;
}
