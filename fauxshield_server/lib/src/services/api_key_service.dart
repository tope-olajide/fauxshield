import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../core/identity_crypto.dart';
import '../generated/protocol.dart';
import 'audit_service.dart';

/// API keys for machine access to a workspace.
///
/// Only a SHA-256 hash of the key is stored, so a database leak cannot be
/// turned into workspace access. Rate limiting is a per-key sliding window
/// enforced in memory on each server instance.
abstract final class ApiKeyService {
  static final Map<String, List<int>> _requestLog = <String, List<int>>{};

  /// Creates a key and returns the plaintext exactly once.
  static Future<ApiKeySecret> create(
    Session session, {
    required UuidValue workspaceId,
    required String label,
    required List<ApiScope> scopes,
    int rateLimitPerMinute = 120,
    String? actorIdentifier,
  }) async {
    final trimmed = label.trim();
    if (trimmed.length < 2) {
      throw ValidationException(
        message: 'Give the key a label of at least 2 characters.',
        field: 'label',
      );
    }
    if (scopes.isEmpty) {
      throw ValidationException(
        message: 'Select at least one scope for the key.',
        field: 'scopes',
      );
    }
    if (rateLimitPerMinute < 1 || rateLimitPerMinute > 100000) {
      throw ValidationException(
        message: 'Rate limit must be between 1 and 100000 requests per minute.',
        field: 'rateLimitPerMinute',
      );
    }

    final secret =
        '${FauxShieldLimits.apiKeyPrefix}${IdentityCrypto.generateApiKeyBody(byteLength: 24)}';
    final now = DateTime.now().toUtc();
    final apiKey = await ApiKey.db.insertRow(
      session,
      ApiKey(
        workspaceId: workspaceId,
        label: trimmed,
        keyHash: IdentityCrypto.sha256Hex(secret),
        keyPrefix: secret.substring(0, 16),
        scopes: scopes,
        rateLimitPerMinute: rateLimitPerMinute,
        createdBy: actorIdentifier,
        createdAt: now,
      ),
    );
    await AuditService.record(
      session,
      workspaceId: workspaceId,
      action: 'api_key.created',
      targetType: 'api_key',
      targetId: apiKey.id,
      actorType: ActorType.user,
      actorIdentifier: actorIdentifier,
      metadata: <String, dynamic>{
        'label': trimmed,
        'scopes': scopes.map((scope) => scope.name).toList(),
      },
    );
    return ApiKeySecret(
      apiKey: apiKey,
      secret: secret,
      warning: 'Copy this key now. It is shown exactly once.',
    );
  }

  /// Revokes a key. Revocation is immediate.
  static Future<ApiKey> revoke(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue apiKeyId,
    String? actorIdentifier,
  }) async {
    final apiKey = await ApiKey.db.findById(session, apiKeyId);
    if (apiKey == null || apiKey.workspaceId != workspaceId) {
      throw NotFoundException(
        message: 'API key not found.',
        resource: 'api_key',
      );
    }
    if (apiKey.revoked) {
      throw ConflictException(
        message: 'This key is already revoked.',
        resource: 'api_key',
      );
    }
    final updated = await ApiKey.db.updateRow(
      session,
      apiKey.copyWith(revoked: true, revokedAt: DateTime.now().toUtc()),
    );
    await AuditService.record(
      session,
      workspaceId: workspaceId,
      action: 'api_key.revoked',
      targetType: 'api_key',
      targetId: apiKeyId,
      actorType: ActorType.user,
      actorIdentifier: actorIdentifier,
      metadata: <String, dynamic>{'label': apiKey.label},
    );
    return updated;
  }

  /// Authenticates a presented key and updates its usage timestamp.
  ///
  /// Returns null when the key is unknown or revoked.
  static Future<ApiKey?> authenticate(
    Session session,
    String presentedKey,
  ) async {
    final trimmed = presentedKey.trim();
    if (trimmed.isEmpty) return null;
    final apiKey = await ApiKey.db.findFirstRow(
      session,
      where: (t) =>
          t.keyHash.equals(IdentityCrypto.sha256Hex(trimmed)) &
          t.revoked.equals(false),
    );
    if (apiKey == null) return null;
    await ApiKey.db.updateRow(
      session,
      apiKey.copyWith(lastUsedAt: DateTime.now().toUtc()),
    );
    return apiKey;
  }

  /// Throws when [apiKey] exceeds its rate limit, otherwise records the call.
  static void enforceRateLimit(ApiKey apiKey) {
    final key = apiKey.id!.uuid;
    final now = DateTime.now().millisecondsSinceEpoch;
    final windowStart = now - 60000;
    final log = _requestLog.putIfAbsent(key, () => <int>[]);
    log.removeWhere((timestamp) => timestamp < windowStart);
    if (log.length >= apiKey.rateLimitPerMinute) {
      throw RateLimitException(
        message: 'Rate limit exceeded for ${apiKey.label}.',
        retryAfterSeconds: 60,
      );
    }
    log.add(now);
    // Bound memory: drop the oldest bucket when the tracker grows.
    if (_requestLog.length > 2048) {
      _requestLog.remove(_requestLog.keys.first);
    }
  }

  static bool hasScope(ApiKey apiKey, ApiScope scope) =>
      apiKey.scopes.contains(scope);
}
