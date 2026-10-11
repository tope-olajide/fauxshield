import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

/// A stable per-install device fingerprint used to bind verification
/// sessions to one device.
///
/// It is persisted locally (localStorage on web) so re-verifications from
/// the same device are recognized as "already verified by you" across app
/// restarts instead of counting as a new device every time.
class DeviceFingerprint {
  DeviceFingerprint._();

  static const String _storageKey = 'fauxshield_device_fingerprint';
  static String? _cached;

  /// Returns the stored fingerprint, generating and persisting one on first
  /// use.
  static Future<String> load() async {
    final cached = _cached;
    if (cached != null && cached.isNotEmpty) return cached;

    String? stored;
    try {
      final prefs = await SharedPreferences.getInstance();
      stored = prefs.getString(_storageKey);
    } catch (_) {
      // Storage may be unavailable (private browsing, blocked cookies).
      // Fall back to an in-memory fingerprint for this app run.
    }

    if (stored == null || stored.isEmpty) {
      final random = Random.secure();
      final bytes = List<int>.generate(16, (_) => random.nextInt(256));
      stored = bytes
          .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
          .join();
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_storageKey, stored);
      } catch (_) {
        // Keep it in memory for this run; a new one is minted next launch.
      }
    }
    return _cached = stored;
  }
}
