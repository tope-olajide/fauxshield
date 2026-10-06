/// Retry schedule for webhook deliveries.
///
/// Deliveries are attempted immediately, then retried after
/// 30 seconds, 5 minutes, 30 minutes, 2 hours, and 12 hours.
abstract final class WebhookBackoff {
  static const List<Duration> delays = <Duration>[
    Duration(seconds: 30),
    Duration(minutes: 5),
    Duration(minutes: 30),
    Duration(hours: 2),
    Duration(hours: 12),
  ];

  /// Delay before the next attempt given how many attempts have failed so far.
  ///
  /// Returns null when the retry budget is exhausted.
  static Duration? delayForFailedAttempt(int failedAttempts) {
    if (failedAttempts <= 0) return Duration.zero;
    final index = failedAttempts - 1;
    if (index >= delays.length) return null;
    return delays[index];
  }

  /// The time of the next attempt after [failedAttempts] failures, or null
  /// when the delivery should be marked failed.
  static DateTime? nextAttemptAt(DateTime now, int failedAttempts) {
    final delay = delayForFailedAttempt(failedAttempts);
    if (delay == null) return null;
    return now.toUtc().add(delay);
  }
}
