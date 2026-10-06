import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Signs and verifies webhook payloads.
///
/// The signature header has the form `t=<unix seconds>,v1=<hex digest>` where
/// the digest is HMAC-SHA256 over `<timestamp>.<body>`. Including the timestamp
/// in the signed payload lets receivers reject replays outside a tolerance.
abstract final class WebhookSigner {
  static const String signatureHeader = 'X-FauxShield-Signature';
  static const String eventHeader = 'X-FauxShield-Event';
  static const String deliveryHeader = 'X-FauxShield-Delivery';
  static const String timestampToleranceHeader =
      'X-FauxShield-Timestamp-Tolerance';

  /// Builds the signature header for an outgoing delivery.
  static String sign({
    required String secret,
    required String body,
    required DateTime timestamp,
  }) {
    final seconds = timestamp.toUtc().millisecondsSinceEpoch ~/ 1000;
    final digest = Hmac(
      sha256,
      utf8.encode(secret),
    ).convert(utf8.encode('$seconds.$body')).toString();
    return 't=$seconds,v1=$digest';
  }

  /// Verifies a signature header against a body.
  ///
  /// [tolerance] of null accepts any timestamp; otherwise the timestamp must be
  /// within the tolerance of [now].
  static bool verify({
    required String secret,
    required String body,
    required String header,
    Duration? tolerance,
    DateTime? now,
  }) {
    try {
      final parts = <String, String>{};
      for (final part in header.split(',')) {
        final index = part.indexOf('=');
        if (index <= 0) continue;
        parts[part.substring(0, index).trim()] = part
            .substring(index + 1)
            .trim();
      }
      final timestamp = int.tryParse(parts['t'] ?? '');
      final provided = parts['v1'] ?? '';
      if (timestamp == null || provided.isEmpty) return false;
      if (tolerance != null) {
        final reference =
            (now ?? DateTime.now()).toUtc().millisecondsSinceEpoch ~/ 1000;
        final delta = (reference - timestamp).abs();
        if (delta > tolerance.inSeconds) return false;
      }
      final expected = Hmac(
        sha256,
        utf8.encode(secret),
      ).convert(utf8.encode('$timestamp.$body')).toString();
      return _constantTimeEquals(expected, provided);
    } catch (_) {
      return false;
    }
  }

  static bool _constantTimeEquals(String a, String b) {
    final aBytes = utf8.encode(a);
    final bBytes = utf8.encode(b);
    if (aBytes.length != bBytes.length) return false;
    var diff = 0;
    for (var i = 0; i < aBytes.length; i++) {
      diff |= aBytes[i] ^ bBytes[i];
    }
    return diff == 0;
  }
}
