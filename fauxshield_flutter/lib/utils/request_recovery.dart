import 'package:fauxshield_client/fauxshield_client.dart';

/// Whether a failed API call may still be running on the server.
///
/// A request that outlives the client's timeout or the API gateway in front of
/// it keeps running server side, and only the response is lost: the browser
/// reports that as a dropped connection or a 5xx. Calls that carry an
/// idempotency key are safe to send again, because the server either replays the
/// finished result or answers that it is still processing.
bool isRecoverableServerError(Object error) {
  // No response arrived at all: client timeout, dropped connection, or a
  // gateway that gave up in front of a server that is still working.
  if (error is ServerpodClientNetworkException) return true;
  if (error is ServerpodClientHttpException) {
    return error.statusCode >= 500 ||
        error.statusCode == 408 ||
        error.statusCode == 429;
  }
  // A duplicate of a run that is still holding its idempotency key.
  if (error is ConflictException) {
    return error.message.contains('still processing');
  }
  return false;
}

/// The wait before retry number [attempt] (the first retry is attempt 1).
Duration defaultRetryDelay(int attempt) =>
    Duration(seconds: attempt < 6 ? attempt * 2 : 12);

/// Runs [attempt], retrying while the server is busy or unreachable.
///
/// Retrying continues until [attempt] succeeds, a failure that cannot be
/// recovered reports back, or [budget] runs out. [onRetry] fires before each
/// wait so callers can show that work is still in flight.
Future<T> retryWhileServerBusy<T>({
  required Future<T> Function() attempt,
  required Duration budget,
  Duration Function(int attempt) delayFor = defaultRetryDelay,
  void Function(int attempt)? onRetry,
}) async {
  final deadline = DateTime.now().add(budget);
  for (var count = 1; ; count++) {
    try {
      return await attempt();
    } catch (error) {
      if (!isRecoverableServerError(error) ||
          !DateTime.now().isBefore(deadline)) {
        rethrow;
      }
      onRetry?.call(count);
      await Future<void>.delayed(delayFor(count));
    }
  }
}
