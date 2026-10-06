import 'package:serverpod/serverpod.dart';

/// Names of the platform secrets, looked up from the passwords file or
/// `SERVERPOD_PASSWORD_*` environment variables.
abstract final class PlatformSecretNames {
  static const String hmacSecret = 'hmacSecretKey';
  static const String pinEncryptionKey = 'pinEncryptionKey';
  static const String webhookEncryptionKey = 'webhookEncryptionKey';
  static const String demoSeedSecret = 'demoSeedSecret';
  static const String geoLookupUrlTemplate = 'geoLookupUrlTemplate';
  static const String geoProvider = 'geoProvider';
}

/// Reads platform secrets and enforces that required keys exist.
abstract final class PlatformKeys {
  static String require(Session session, String name) {
    final value = session.passwords[name];
    if (value == null || value.isEmpty) {
      throw StateError(
        'Missing platform secret "$name". Add it to config/passwords.yaml '
        'or set SERVERPOD_PASSWORD_$name.',
      );
    }
    return value;
  }

  static String? optional(Session session, String name) {
    final value = session.passwords[name];
    if (value == null || value.isEmpty) return null;
    return value;
  }

  static String hmacSecret(Session session) =>
      require(session, PlatformSecretNames.hmacSecret);

  static String pinEncryptionKey(Session session) =>
      require(session, PlatformSecretNames.pinEncryptionKey);

  static String webhookEncryptionKey(Session session) =>
      require(session, PlatformSecretNames.webhookEncryptionKey);
}
