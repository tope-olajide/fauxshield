import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Publishes live events to the command center.
///
/// Events are posted to the workspace channel `workspace:<id>`. Operator apps
/// subscribe with a streaming endpoint, so scans, alerts, recalls, and
/// simulation progress appear in real time. With Redis enabled the channel
/// fans out across server instances; without Redis it works on one instance.
abstract final class LiveEvents {
  static String channelFor(UuidValue workspaceId) =>
      'workspace:${workspaceId.uuid}';

  static Future<void> publish(
    Session session, {
    required UuidValue workspaceId,
    required LiveEventType type,
    required String title,
    String? subtitle,
    AlertSeverity? severity,
    VerificationOutcome? outcome,
    RiskScore? riskScore,
    String? country,
    String? countryCode,
    String? city,
    double? latitude,
    double? longitude,
    UuidValue? identityId,
    UuidValue? sessionId,
    UuidValue? alertId,
    UuidValue? batchId,
    Map<String, dynamic>? payload,
  }) async {
    final event = LiveEvent(
      type: type,
      workspaceId: workspaceId,
      occurredAt: DateTime.now().toUtc(),
      title: title,
      subtitle: subtitle,
      severity: severity,
      outcome: outcome,
      riskScore: riskScore,
      country: country,
      countryCode: countryCode,
      city: city,
      latitude: latitude,
      longitude: longitude,
      identityId: identityId,
      sessionId: sessionId,
      alertId: alertId,
      batchId: batchId,
      payloadJson: payload == null || payload.isEmpty ? null : _encode(payload),
    );
    try {
      await session.messages.postMessage(channelFor(workspaceId), event);
    } catch (error) {
      // Real-time delivery is best effort: a failed publish must never break
      // the verification or fraud pipeline.
      session.log(
        'Failed to publish live event: $error',
        level: LogLevel.warning,
      );
    }
  }

  static String _encode(Map<String, dynamic> payload) {
    final buffer = StringBuffer('{');
    var first = true;
    payload.forEach((key, value) {
      if (!first) buffer.write(',');
      first = false;
      buffer.write('"${key.replaceAll('"', r'\"')}":');
      buffer.write(_encodeValue(value));
    });
    buffer.write('}');
    return buffer.toString();
  }

  static String _encodeValue(Object? value) {
    if (value == null) return 'null';
    if (value is num || value is bool) return value.toString();
    if (value is UuidValue) return '"${value.uuid}"';
    return '"${value.toString().replaceAll('"', r'\"')}"';
  }
}
