import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../core/backoff.dart';
import '../core/constants.dart';
import '../core/identity_crypto.dart';
import '../core/webhook_signing.dart';
import '../generated/protocol.dart';
import 'audit_service.dart';
import 'platform_keys.dart';

/// Outbox based webhook delivery.
///
/// * Events are written to `webhook_delivery` rows (the outbox) inside the same
///   request that produced them.
/// * A recurring scheduled task drains due deliveries, so retries survive
///   server restarts.
/// * Payloads are signed Stripe-style with an HMAC-SHA256 secret that is
///   encrypted at rest with AES-256-GCM and bound to workspace and endpoint.
/// * Delivery targets are validated at registration and delivery time against
///   SSRF patterns (scheme, localhost, private network ranges).
abstract final class WebhookService {
  static http.Client? clientOverride;

  /// Writes one delivery per subscribed, enabled endpoint.
  static Future<int> enqueue(
    Session session, {
    required UuidValue workspaceId,
    required WebhookEventType eventType,
    required Map<String, dynamic> payload,
  }) async {
    final endpoints = await WebhookEndpoint.db.find(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          t.enabled.equals(true) &
          t.deletedAt.equals(null),
      limit: 50,
    );
    final matching = endpoints
        .where((endpoint) => endpoint.subscribedEvents.contains(eventType))
        .toList();
    if (matching.isEmpty) return 0;

    final now = DateTime.now().toUtc();
    final deliveryId = const Uuid().v4obj();
    final body = jsonEncode(<String, dynamic>{
      'event': eventType.name,
      'delivery_id': deliveryId.uuid,
      'occurred_at': now.toIso8601String(),
      'workspace_id': workspaceId.uuid,
      'data': payload,
    });

    final rows = matching
        .map(
          (endpoint) => WebhookDelivery(
            workspaceId: workspaceId,
            endpointId: endpoint.id!,
            eventType: eventType,
            payloadJson: body,
            status: DeliveryStatus.pending,
            nextAttemptAt: now,
            createdAt: now,
          ),
        )
        .toList();
    final inserted = await WebhookDelivery.db.insert(session, rows);
    return inserted.length;
  }

  /// Processes due deliveries. Called by the recurring outbox task.
  static Future<int> drain(Session session, {int limit = 25}) async {
    final now = DateTime.now().toUtc();
    final due = await WebhookDelivery.db.find(
      session,
      where: (t) =>
          (t.status.equals(DeliveryStatus.pending) |
              t.status.equals(DeliveryStatus.retrying)) &
          (t.nextAttemptAt <= now),
      orderBy: (t) => t.nextAttemptAt,
      limit: limit,
    );

    var processed = 0;
    for (final delivery in due) {
      await attempt(session, delivery);
      processed++;
    }
    return processed;
  }

  /// Attempts one delivery and schedules the retry when it fails.
  static Future<WebhookDelivery> attempt(
    Session session,
    WebhookDelivery delivery,
  ) async {
    final endpoint = await WebhookEndpoint.db.findById(
      session,
      delivery.endpointId,
    );
    if (endpoint == null || endpoint.deletedAt != null) {
      return WebhookDelivery.db.updateRow(
        session,
        delivery.copyWith(
          status: DeliveryStatus.failed,
          lastError: 'Endpoint removed',
        ),
      );
    }

    final now = DateTime.now().toUtc();
    if (!endpoint.enabled) {
      return WebhookDelivery.db.updateRow(
        session,
        delivery.copyWith(
          status: DeliveryStatus.failed,
          lastAttemptAt: now,
          lastError: 'Endpoint disabled',
        ),
      );
    }

    String? secret;
    try {
      final encryptionKey = PlatformKeys.webhookEncryptionKey(session);
      final encrypted = endpoint.encryptedSecret;
      if (encrypted == null) {
        throw StateError('Endpoint has no secret');
      }
      secret = await IdentityCrypto.decryptValue(
        ciphertext: encrypted,
        keyHex: encryptionKey,
        aad: _secretAad(endpoint.workspaceId, endpoint.id!),
      );
      if (secret == null) throw StateError('Secret decryption failed');
    } catch (error) {
      return WebhookDelivery.db.updateRow(
        session,
        delivery.copyWith(
          status: DeliveryStatus.failed,
          lastAttemptAt: now,
          lastError: 'Signing secret unavailable: $error',
        ),
      );
    }

    final safety = await validateTargetUrl(
      endpoint.url,
      allowLocalhost: _isDevMode,
    );
    if (!safety.ok) {
      return WebhookDelivery.db.updateRow(
        session,
        delivery.copyWith(
          status: DeliveryStatus.failed,
          lastAttemptAt: now,
          lastError: 'Blocked target: ${safety.reason}',
        ),
      );
    }

    final started = DateTime.now();
    int? statusCode;
    String? error;
    var success = false;
    try {
      final request = http.Request('POST', Uri.parse(endpoint.url))
        ..headers.addAll(<String, String>{
          'Content-Type': 'application/json',
          WebhookSigner.signatureHeader: WebhookSigner.sign(
            secret: secret,
            body: delivery.payloadJson,
            timestamp: now,
          ),
          WebhookSigner.eventHeader: delivery.eventType.name,
          WebhookSigner.deliveryHeader: delivery.id?.uuid ?? '',
          'User-Agent': 'FauxShield-Webhooks/1.0',
        })
        ..body = delivery.payloadJson;
      final client = clientOverride ?? http.Client();
      final response = await client
          .send(request)
          .timeout(const Duration(seconds: 10));
      statusCode = response.statusCode;
      success = response.statusCode >= 200 && response.statusCode < 300;
      if (!success) {
        error = 'HTTP $statusCode';
      }
    } on TimeoutException {
      error = 'Timed out after 10s';
    } catch (exception) {
      error = exception.toString();
    }

    final responseTimeMs = DateTime.now().difference(started).inMilliseconds;
    final attemptCount = delivery.attemptCount + 1;

    if (success) {
      final updated = await WebhookDelivery.db.updateRow(
        session,
        delivery.copyWith(
          status: DeliveryStatus.delivered,
          attemptCount: attemptCount,
          lastAttemptAt: now,
          lastHttpStatus: statusCode,
          lastError: null,
          responseTimeMs: responseTimeMs,
          deliveredAt: now,
        ),
      );
      await _resetFailures(session, endpoint);
      return updated;
    }

    final nextAttempt = WebhookBackoff.nextAttemptAt(now, attemptCount);
    final exhausted =
        nextAttempt == null || attemptCount >= delivery.maxAttempts;
    final updated = await WebhookDelivery.db.updateRow(
      session,
      delivery.copyWith(
        status: exhausted ? DeliveryStatus.failed : DeliveryStatus.retrying,
        attemptCount: attemptCount,
        lastAttemptAt: now,
        nextAttemptAt: exhausted ? delivery.nextAttemptAt : nextAttempt,
        lastHttpStatus: statusCode,
        lastError: error,
        responseTimeMs: responseTimeMs,
      ),
    );

    final failures = endpoint.consecutiveFailures + 1;
    var updatedEndpoint = endpoint.copyWith(consecutiveFailures: failures);
    if (failures >= FauxShieldLimits.webhookDisableThreshold) {
      updatedEndpoint = updatedEndpoint.copyWith(enabled: false);
      await AuditService.record(
        session,
        workspaceId: endpoint.workspaceId,
        action: 'webhook.endpoint_disabled',
        targetType: 'webhook_endpoint',
        targetId: endpoint.id,
        actorType: ActorType.system,
        metadata: <String, dynamic>{'consecutive_failures': failures},
      );
    }
    await WebhookEndpoint.db.updateRow(session, updatedEndpoint);

    return updated;
  }

  static Future<void> _resetFailures(
    Session session,
    WebhookEndpoint endpoint,
  ) {
    if (endpoint.consecutiveFailures == 0) return Future.value();
    return WebhookEndpoint.db.updateRow(
      session,
      endpoint.copyWith(consecutiveFailures: 0),
    );
  }

  /// Registers a new endpoint and returns its plaintext secret exactly once.
  static Future<WebhookEndpointSecret> createEndpoint(
    Session session, {
    required UuidValue workspaceId,
    required String url,
    required List<WebhookEventType> events,
    String? description,
    required String actorIdentifier,
  }) async {
    final safety = await validateTargetUrl(url, allowLocalhost: _isDevMode);
    if (!safety.ok) {
      throw ValidationException(
        message: 'URL rejected: ${safety.reason}',
        field: 'url',
      );
    }
    if (events.isEmpty) {
      throw ValidationException(
        message: 'Subscribe to at least one event.',
        field: 'events',
      );
    }

    final secret = IdentityCrypto.generateSecret(byteLength: 32);
    final now = DateTime.now().toUtc();
    var endpoint = WebhookEndpoint(
      workspaceId: workspaceId,
      url: url,
      description: description,
      subscribedEvents: events,
      enabled: true,
      createdAt: now,
      updatedAt: now,
    );
    endpoint = await WebhookEndpoint.db.insertRow(session, endpoint);

    final encrypted = await IdentityCrypto.encryptValue(
      plaintext: secret,
      keyHex: PlatformKeys.webhookEncryptionKey(session),
      aad: _secretAad(workspaceId, endpoint.id!),
    );
    endpoint = await WebhookEndpoint.db.updateRow(
      session,
      endpoint.copyWith(encryptedSecret: encrypted),
    );

    await AuditService.record(
      session,
      workspaceId: workspaceId,
      action: 'webhook.endpoint_created',
      targetType: 'webhook_endpoint',
      targetId: endpoint.id,
      actorType: ActorType.user,
      actorIdentifier: actorIdentifier,
      metadata: <String, dynamic>{
        'url': url,
        'events': events.map((e) => e.name).toList(),
      },
    );

    return WebhookEndpointSecret(
      endpoint: endpoint,
      secret: secret,
      warning:
          'Store this signing secret now. It is stored hashed from here on and cannot be shown again.',
    );
  }

  static Future<WebhookEndpoint> updateEndpoint(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue endpointId,
    String? url,
    List<WebhookEventType>? events,
    String? description,
    bool? enabled,
    required String actorIdentifier,
  }) async {
    final endpoint = await WebhookEndpoint.db.findById(session, endpointId);
    if (endpoint == null ||
        endpoint.workspaceId != workspaceId ||
        endpoint.deletedAt != null) {
      throw NotFoundException(
        message: 'Endpoint not found.',
        resource: 'webhook_endpoint',
      );
    }
    if (url != null) {
      final safety = await validateTargetUrl(url, allowLocalhost: _isDevMode);
      if (!safety.ok) {
        throw ValidationException(
          message: 'URL rejected: ${safety.reason}',
          field: 'url',
        );
      }
    }
    final updated = await WebhookEndpoint.db.updateRow(
      session,
      endpoint.copyWith(
        url: url ?? endpoint.url,
        subscribedEvents: events ?? endpoint.subscribedEvents,
        description: description ?? endpoint.description,
        enabled: enabled ?? endpoint.enabled,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await AuditService.record(
      session,
      workspaceId: workspaceId,
      action: 'webhook.endpoint_updated',
      targetType: 'webhook_endpoint',
      targetId: endpointId,
      actorType: ActorType.user,
      actorIdentifier: actorIdentifier,
    );
    return updated;
  }

  static Future<WebhookEndpoint> deleteEndpoint(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue endpointId,
    required String actorIdentifier,
  }) async {
    final endpoint = await WebhookEndpoint.db.findById(session, endpointId);
    if (endpoint == null || endpoint.workspaceId != workspaceId) {
      throw NotFoundException(
        message: 'Endpoint not found.',
        resource: 'webhook_endpoint',
      );
    }
    final updated = await WebhookEndpoint.db.updateRow(
      session,
      endpoint.copyWith(
        deletedAt: DateTime.now().toUtc(),
        enabled: false,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await AuditService.record(
      session,
      workspaceId: workspaceId,
      action: 'webhook.endpoint_deleted',
      targetType: 'webhook_endpoint',
      targetId: endpointId,
      actorType: ActorType.user,
      actorIdentifier: actorIdentifier,
    );
    return updated;
  }

  /// Rotates the signing secret, keeping the previous one for in-flight retries.
  static Future<WebhookEndpointSecret> rotateSecret(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue endpointId,
    required String actorIdentifier,
  }) async {
    final endpoint = await WebhookEndpoint.db.findById(session, endpointId);
    if (endpoint == null ||
        endpoint.workspaceId != workspaceId ||
        endpoint.deletedAt != null) {
      throw NotFoundException(
        message: 'Endpoint not found.',
        resource: 'webhook_endpoint',
      );
    }
    final secret = IdentityCrypto.generateSecret(byteLength: 32);
    final encrypted = await IdentityCrypto.encryptValue(
      plaintext: secret,
      keyHex: PlatformKeys.webhookEncryptionKey(session),
      aad: _secretAad(workspaceId, endpointId),
    );
    final updated = await WebhookEndpoint.db.updateRow(
      session,
      endpoint.copyWith(
        encryptedSecret: encrypted,
        previousEncryptedSecret: endpoint.encryptedSecret,
        secretRotatedAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await AuditService.record(
      session,
      workspaceId: workspaceId,
      action: 'webhook.secret_rotated',
      targetType: 'webhook_endpoint',
      targetId: endpointId,
      actorType: ActorType.user,
      actorIdentifier: actorIdentifier,
    );
    return WebhookEndpointSecret(
      endpoint: updated,
      secret: secret,
      warning:
          'The previous secret keeps signing retries briefly. Store the new secret now.',
    );
  }

  /// Sends a test delivery so operators can verify their receiver.
  static Future<WebhookTestResult> testDelivery(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue endpointId,
    required String actorIdentifier,
  }) async {
    final endpoint = await WebhookEndpoint.db.findById(session, endpointId);
    if (endpoint == null ||
        endpoint.workspaceId != workspaceId ||
        endpoint.deletedAt != null) {
      throw NotFoundException(
        message: 'Endpoint not found.',
        resource: 'webhook_endpoint',
      );
    }

    final now = DateTime.now().toUtc();
    final delivery = await WebhookDelivery.db.insertRow(
      session,
      WebhookDelivery(
        workspaceId: workspaceId,
        endpointId: endpointId,
        eventType: WebhookEventType.testEvent,
        payloadJson: jsonEncode(<String, dynamic>{
          'event': WebhookEventType.testEvent.name,
          'occurred_at': now.toIso8601String(),
          'workspace_id': workspaceId.uuid,
          'data': <String, dynamic>{'message': 'FauxShield test delivery'},
        }),
        status: DeliveryStatus.pending,
        nextAttemptAt: now,
        maxAttempts: 1,
        createdAt: now,
      ),
    );

    final attempted = await attempt(session, delivery);
    await AuditService.record(
      session,
      workspaceId: workspaceId,
      action: 'webhook.test_delivery',
      targetType: 'webhook_endpoint',
      targetId: endpointId,
      actorType: ActorType.user,
      actorIdentifier: actorIdentifier,
      metadata: <String, dynamic>{
        'success': attempted.status == DeliveryStatus.delivered,
        'status_code': attempted.lastHttpStatus,
      },
    );
    return WebhookTestResult(
      success: attempted.status == DeliveryStatus.delivered,
      statusCode: attempted.lastHttpStatus,
      responseTimeMs: attempted.responseTimeMs,
      error: attempted.lastError,
      deliveryId: attempted.id,
    );
  }

  /// Validates a webhook target against SSRF patterns.
  ///
  /// Rules: https everywhere; http only allowed for local development targets;
  /// hostnames must not resolve to loopback, link-local, or private ranges
  /// unless they are explicitly local.
  static Future<UrlSafety> validateTargetUrl(
    String url, {
    required bool allowLocalhost,
  }) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return const UrlSafety(false, 'Not a valid absolute URL');
    }
    if (uri.scheme != 'https' && uri.scheme != 'http') {
      return const UrlSafety(
        false,
        'Only http and https targets are supported',
      );
    }
    final host = uri.host.toLowerCase();
    final isLocal = host == 'localhost' || host == '127.0.0.1' || host == '::1';
    if (isLocal && !allowLocalhost) {
      return const UrlSafety(
        false,
        'Localhost targets are only allowed in development',
      );
    }
    if (uri.scheme == 'http' && !isLocal && !allowLocalhost) {
      return const UrlSafety(false, 'HTTPS is required for public targets');
    }
    if (isLocal) return const UrlSafety(true, '');

    try {
      final addresses = await InternetAddress.lookup(host);
      for (final address in addresses) {
        if (_isPrivateAddress(address.address)) {
          return const UrlSafety(
            false,
            'Target resolves to a private network address',
          );
        }
      }
    } catch (_) {
      return const UrlSafety(false, 'Target host could not be resolved');
    }
    return const UrlSafety(true, '');
  }

  static bool _isPrivateAddress(String address) {
    if (address.contains(':')) {
      final lower = address.toLowerCase();
      return lower == '::1' ||
          lower.startsWith('fc') ||
          lower.startsWith('fd') ||
          lower.startsWith('fe80');
    }
    final parts = address.split('.');
    if (parts.length != 4) return true;
    final first = int.tryParse(parts[0]);
    final second = int.tryParse(parts[1]);
    if (first == null || second == null) return true;
    if (first == 10 || first == 127 || first == 0) return true;
    if (first == 169 && second == 254) return true;
    if (first == 172 && second >= 16 && second <= 31) return true;
    if (first == 192 && second == 168) return true;
    if (first >= 224) return true;
    return false;
  }

  static String _secretAad(UuidValue workspaceId, UuidValue endpointId) =>
      'webhook:${workspaceId.uuid}:${endpointId.uuid}';

  static bool get _isDevMode {
    final mode = Serverpod.instance.runMode;
    return mode == 'development' || mode == 'test';
  }
}

/// Outcome of a URL safety check.
class UrlSafety {
  const UrlSafety(this.ok, this.reason);

  final bool ok;
  final String reason;
}
