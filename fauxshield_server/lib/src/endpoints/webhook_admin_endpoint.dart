import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../generated/protocol.dart';
import '../services/rbac.dart';
import '../services/webhook_service.dart';
import '../services/workspace_service.dart';

/// Webhook endpoint administration and delivery inspection.
class WebhookAdminEndpoint extends Endpoint {
  /// Lists active webhook endpoints.
  Future<List<WebhookEndpoint>> list(
    Session session, {
    UuidValue? workspaceId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.webhooksRead);
    final endpoints = await WebhookEndpoint.db.find(
      session,
      where: (t) =>
          t.workspaceId.equals(context.workspaceId) & t.deletedAt.equals(null),
      orderBy: (t) => t.createdAt.desc(),
      limit: 100,
    );
    return endpoints
        .map(
          (endpoint) => endpoint.copyWith(
            encryptedSecret: null,
            previousEncryptedSecret: null,
          ),
        )
        .toList(growable: false);
  }

  /// Registers a webhook endpoint. The signing secret is shown once.
  Future<WebhookEndpointSecret> create(
    Session session, {
    UuidValue? workspaceId,
    required String url,
    required List<WebhookEventType> events,
    String? description,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.webhooksWrite);
    return WebhookService.createEndpoint(
      session,
      workspaceId: context.workspaceId,
      url: url,
      events: events,
      description: description,
      actorIdentifier: context.userIdentifier,
    );
  }

  /// Updates a webhook endpoint.
  Future<WebhookEndpoint> update(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue endpointId,
    String? url,
    List<WebhookEventType>? events,
    String? description,
    bool? enabled,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.webhooksWrite);
    final updated = await WebhookService.updateEndpoint(
      session,
      workspaceId: context.workspaceId,
      endpointId: endpointId,
      url: url,
      events: events,
      description: description,
      enabled: enabled,
      actorIdentifier: context.userIdentifier,
    );
    return updated.copyWith(
      encryptedSecret: null,
      previousEncryptedSecret: null,
    );
  }

  /// Soft deletes a webhook endpoint.
  Future<WebhookEndpoint> delete(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue endpointId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.webhooksWrite);
    final deleted = await WebhookService.deleteEndpoint(
      session,
      workspaceId: context.workspaceId,
      endpointId: endpointId,
      actorIdentifier: context.userIdentifier,
    );
    return deleted.copyWith(
      encryptedSecret: null,
      previousEncryptedSecret: null,
    );
  }

  /// Rotates the signing secret. The previous secret stays valid during
  /// rotation so in-flight deliveries still verify.
  Future<WebhookEndpointSecret> rotateSecret(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue endpointId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.webhooksWrite);
    return WebhookService.rotateSecret(
      session,
      workspaceId: context.workspaceId,
      endpointId: endpointId,
      actorIdentifier: context.userIdentifier,
    );
  }

  /// Sends a signed test delivery and reports the result inline.
  Future<WebhookTestResult> test(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue endpointId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.webhooksWrite);
    return WebhookService.testDelivery(
      session,
      workspaceId: context.workspaceId,
      endpointId: endpointId,
      actorIdentifier: context.userIdentifier,
    );
  }

  /// Lists recent deliveries for an endpoint.
  Future<List<WebhookDelivery>> deliveries(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue endpointId,
    int page = 0,
    int pageSize = 25,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.webhooksRead);
    final size = pageSize.clamp(1, FauxShieldLimits.maxPageSize);
    final offset = (page < 0 ? 0 : page) * size;
    return WebhookDelivery.db.find(
      session,
      where: (t) =>
          t.workspaceId.equals(context.workspaceId) &
          t.endpointId.equals(endpointId),
      orderBy: (t) => t.createdAt.desc(),
      limit: size,
      offset: offset,
    );
  }

  /// Requeues a delivery and attempts it immediately.
  Future<WebhookDelivery> redeliver(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue deliveryId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.webhooksWrite);
    final delivery = await WebhookDelivery.db.findById(session, deliveryId);
    if (delivery == null || delivery.workspaceId != context.workspaceId) {
      throw NotFoundException(
        message: 'Delivery not found.',
        resource: 'webhook_delivery',
      );
    }
    final now = DateTime.now().toUtc();
    final requeued = await WebhookDelivery.db.updateRow(
      session,
      delivery.copyWith(
        status: DeliveryStatus.pending,
        nextAttemptAt: now,
        lastError: null,
        maxAttempts: delivery.attemptCount + 3,
      ),
    );
    return WebhookService.attempt(session, requeued);
  }

  /// Drains the outbox immediately instead of waiting for the scheduled task.
  Future<int> drainNow(Session session, {UuidValue? workspaceId}) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.webhooksWrite);
    return WebhookService.drain(session, limit: 50);
  }
}
