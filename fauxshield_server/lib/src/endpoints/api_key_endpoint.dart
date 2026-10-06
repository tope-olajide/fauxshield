import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/api_key_service.dart';
import '../services/rbac.dart';
import '../services/workspace_service.dart';

/// API key management for machine access.
class ApiKeyEndpoint extends Endpoint {
  /// Lists keys without their hashes.
  Future<List<ApiKey>> list(Session session, {UuidValue? workspaceId}) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.apiKeysRead);
    final keys = await ApiKey.db.find(
      session,
      where: (t) => t.workspaceId.equals(context.workspaceId),
      orderBy: (t) => t.createdAt.desc(),
      limit: 100,
    );
    return keys
        .map((key) => key.copyWith(keyHash: null))
        .toList(growable: false);
  }

  /// Creates a key. The secret is returned exactly once.
  Future<ApiKeySecret> create(
    Session session, {
    UuidValue? workspaceId,
    required String label,
    required List<ApiScope> scopes,
    int rateLimitPerMinute = 120,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.apiKeysWrite);
    return ApiKeyService.create(
      session,
      workspaceId: context.workspaceId,
      label: label,
      scopes: scopes,
      rateLimitPerMinute: rateLimitPerMinute,
      actorIdentifier: context.userIdentifier,
    );
  }

  /// Revokes a key immediately.
  Future<ApiKey> revoke(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue apiKeyId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.apiKeysWrite);
    final revoked = await ApiKeyService.revoke(
      session,
      workspaceId: context.workspaceId,
      apiKeyId: apiKeyId,
      actorIdentifier: context.userIdentifier,
    );
    return revoked.copyWith(keyHash: null);
  }
}
