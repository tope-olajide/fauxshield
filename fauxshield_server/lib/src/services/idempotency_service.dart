import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../core/identity_crypto.dart';
import '../generated/protocol.dart';

/// Postgres backed idempotency for create-style API calls.
///
/// The client sends an `Idempotency-Key`; the first request executes and its
/// response is stored. Replays return the stored response, and concurrent
/// duplicates get a typed conflict instead of doing the work twice. This is
/// what makes identity generation, recalls, and webhook test deliveries safe
/// to retry from flaky field connections.
abstract final class IdempotencyService {
  /// How long a stored response can be replayed.
  static const Duration defaultTtl = Duration(hours: 24);

  /// Stable hash of a request payload.
  ///
  /// Reusing a key with a different payload is rejected, so a retry can never
  /// silently execute a different operation.
  static String hashRequest(Object? request) {
    if (request == null) return IdentityCrypto.sha256Hex('null');
    if (request is String) return IdentityCrypto.sha256Hex(request);
    return IdentityCrypto.sha256Hex(jsonEncode(request));
  }

  /// Runs [action] at most once for `workspace + operation + key`.
  ///
  /// [encode] and [decode] bridge the typed result to the stored JSON
  /// response. Replays return an equivalent reconstructed value without
  /// touching [action] again.
  static Future<T> run<T>(
    Session session, {
    required UuidValue workspaceId,
    required String operation,
    required String key,
    required Object? request,
    required T Function(Map<String, dynamic> json) decode,
    required Map<String, dynamic> Function(T value) encode,
    required Future<T> Function() action,
    Duration ttl = defaultTtl,
  }) async {
    final trimmedKey = key.trim();
    if (trimmedKey.isEmpty || trimmedKey.length > 200) {
      throw ValidationException(
        message: 'Idempotency keys must be between 1 and 200 characters.',
        field: 'idempotencyKey',
      );
    }

    final now = DateTime.now().toUtc();
    final composedKey = '${workspaceId.uuid}:$operation:$trimmedKey';
    final requestHash = hashRequest(request);

    var existing = await IdempotencyRecord.db.findFirstRow(
      session,
      where: (t) => t.idempotencyKey.equals(composedKey),
    );
    if (existing != null && existing.expiresAt.isBefore(now)) {
      // Expired keys are free to reuse.
      final expired = existing;
      await IdempotencyRecord.db.deleteWhere(
        session,
        where: (t) => t.id.equals(expired.id!),
      );
      existing = null;
    }
    if (existing != null) {
      return _replay(existing, requestHash, decode);
    }

    final record = IdempotencyRecord(
      workspaceId: workspaceId,
      idempotencyKey: composedKey,
      operation: operation,
      requestHash: requestHash,
      createdAt: now,
      expiresAt: now.add(ttl),
    );
    final inserted = await IdempotencyRecord.db.insert(
      session,
      <IdempotencyRecord>[record],
      ignoreConflicts: true,
    );
    if (inserted.isEmpty) {
      // Another caller won the race. If it already finished, replay; otherwise
      // ask the client to retry once the original call completes.
      final raced = await IdempotencyRecord.db.findFirstRow(
        session,
        where: (t) => t.idempotencyKey.equals(composedKey),
      );
      if (raced != null) {
        return _replay(raced, requestHash, decode);
      }
      throw ConflictException(
        message:
            'A request with this idempotency key is still processing. Retry shortly.',
        resource: 'idempotency_key',
      );
    }

    final stored = inserted.first;
    final T result;
    try {
      result = await action();
    } catch (_) {
      // Failed attempts must not poison the key: the caller can retry.
      await IdempotencyRecord.db.deleteWhere(
        session,
        where: (t) => t.id.equals(stored.id!),
      );
      rethrow;
    }

    await IdempotencyRecord.db.updateRow(
      session,
      stored.copyWith(
        responseJson: jsonEncode(encode(result)),
        statusCode: 200,
      ),
    );
    return result;
  }

  static T _replay<T>(
    IdempotencyRecord record,
    String requestHash,
    T Function(Map<String, dynamic> json) decode,
  ) {
    if (record.requestHash != requestHash) {
      throw ConflictException(
        message:
            'This idempotency key was already used with a different payload.',
        resource: 'idempotency_key',
      );
    }
    final stored = record.responseJson;
    if (stored == null) {
      throw ConflictException(
        message:
            'A request with this idempotency key is still processing. Retry shortly.',
        resource: 'idempotency_key',
      );
    }
    return decode(jsonDecode(stored) as Map<String, dynamic>);
  }

  /// Deletes expiry records. Called by a recurring maintenance task.
  static Future<int> prune(Session session, {int batchSize = 500}) async {
    final deleted = await IdempotencyRecord.db.deleteWhere(
      session,
      where: (t) => t.expiresAt < DateTime.now().toUtc(),
    );
    return deleted.length;
  }
}
