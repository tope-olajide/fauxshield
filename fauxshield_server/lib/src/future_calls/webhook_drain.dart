import 'package:serverpod/serverpod.dart';

import '../services/webhook_service.dart';

/// Drains the webhook outbox.
///
/// Due deliveries are attempted with retry backoff (30s, 5m, 30m, 2h, 12h).
/// Endpoints that fail twenty consecutive deliveries are disabled and the
/// workspace is notified through the live event channel.
class WebhookDrain extends FutureCall {
  Future<void> drain(Session session) async {
    await WebhookService.drain(session);
  }
}
