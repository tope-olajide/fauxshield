import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:fauxshield_flutter/utils/request_recovery.dart';
import 'package:flutter_test/flutter_test.dart';

/// Distinct failure shapes the server can produce for a call that may still be
/// running: no response at all, a gateway 5xx, or an idempotency key that is
/// still held by the original request.
final _recoverable = <Object>[
  const ServerpodClientNetworkException('Request timed out.'),
  ServerpodClientUnknownHttpException('gateway', 504),
  ServerpodClientInternalServerError(),
  ConflictException(
    message: 'A request with this idempotency key is still processing.',
    resource: 'idempotency_key',
  ),
];

void main() {
  group('Given isRecoverableServerError', () {
    for (final error in _recoverable) {
      test('treats ${error.runtimeType} as worth retrying', () {
        expect(isRecoverableServerError(error), isTrue);
      });
    }

    test('rejects failures that will not change on a retry', () {
      expect(
        isRecoverableServerError(
          ValidationException(
            message: 'Quantity must be between 1 and 5000.',
            field: 'quantity',
          ),
        ),
        isFalse,
      );
      expect(
        isRecoverableServerError(
          NotFoundException(message: 'Batch not found.', resource: 'batch'),
        ),
        isFalse,
      );
      // Same key, different payload: retrying can never succeed.
      expect(
        isRecoverableServerError(
          ConflictException(
            message:
                'This idempotency key was already used with a different '
                'payload.',
            resource: 'idempotency_key',
          ),
        ),
        isFalse,
      );
      expect(
        isRecoverableServerError(
          ServerpodClientUnknownHttpException('bad request', 400),
        ),
        isFalse,
      );
    });
  });

  group('Given retryWhileServerBusy', () {
    test(
      'returns the result without retrying when the call succeeds',
      () async {
        var attempts = 0;
        final result = await retryWhileServerBusy<int>(
          budget: const Duration(seconds: 1),
          attempt: () async {
            attempts++;
            return 7;
          },
        );
        expect(result, 7);
        expect(attempts, 1);
      },
    );

    test('retries a dropped response until the server answers', () async {
      var attempts = 0;
      final retries = <int>[];
      final result = await retryWhileServerBusy<String>(
        budget: const Duration(seconds: 5),
        delayFor: (_) => const Duration(milliseconds: 1),
        onRetry: retries.add,
        attempt: () async {
          attempts++;
          if (attempts < 3) {
            throw const ServerpodClientNetworkException('Request timed out.');
          }
          return 'generated';
        },
      );
      expect(result, 'generated');
      expect(attempts, 3);
      expect(retries, <int>[1, 2]);
    });

    test('reports the failure once the retry budget runs out', () async {
      var attempts = 0;
      await expectLater(
        retryWhileServerBusy<void>(
          budget: Duration.zero,
          delayFor: (_) => const Duration(milliseconds: 1),
          attempt: () async {
            attempts++;
            throw const ServerpodClientNetworkException('Request timed out.');
          },
        ),
        throwsA(isA<ServerpodClientNetworkException>()),
      );
      expect(attempts, 1);
    });

    test('propagates a failure that a retry cannot fix', () async {
      var attempts = 0;
      await expectLater(
        retryWhileServerBusy<void>(
          budget: const Duration(minutes: 1),
          delayFor: (_) => const Duration(milliseconds: 1),
          attempt: () async {
            attempts++;
            throw ConflictException(
              message: 'Cannot generate identities for a recalled batch.',
              resource: 'batch',
            );
          },
        ),
        throwsA(isA<ConflictException>()),
      );
      expect(attempts, 1);
    });
  });
}
