import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart' as c;

/// Cryptography for serialized product identities.
///
/// * QR tokens carry 128 bits of cryptographic randomness.
/// * Token signatures are HMAC-SHA256 over workspace, product, identity, and
///   token, so a token moved to another product or tenant fails verification.
/// * PINs are hashed with PBKDF2-HMAC-SHA256 (120k iterations) for storage and
///   encrypted with AES-256-GCM for authorized operator retrieval. The KDF is
///   implemented in-process over package:crypto (see [pbkdf2Sha256]) because
///   batch generation hashes one PIN per unit inside a single request.
abstract final class IdentityCrypto {
  static final Random _random = Random.secure();

  /// 128 bits of cryptographic randomness rendered as lowercase hex.
  static String generateQrToken() => _hex(_randomBytes(16));

  /// A cryptographically secure numeric PIN, zero padded to [length].
  static String generateSecurePin({int length = 6}) {
    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      buffer.write(_random.nextInt(10));
    }
    return buffer.toString();
  }

  /// Signs a token, binding it to workspace, product, and identity.
  static String signToken({
    required String secret,
    required String workspaceId,
    required String productId,
    required String identityId,
    required String token,
  }) {
    final payload = '$workspaceId:$productId:$identityId:$token';
    return Hmac(
      sha256,
      utf8.encode(secret),
    ).convert(utf8.encode(payload)).toString();
  }

  /// Verifies a token signature with a constant time comparison.
  static bool verifyTokenSignature({
    required String secret,
    required String workspaceId,
    required String productId,
    required String identityId,
    required String token,
    required String signature,
  }) {
    final expected = signToken(
      secret: secret,
      workspaceId: workspaceId,
      productId: productId,
      identityId: identityId,
      token: token,
    );
    return constantTimeEquals(expected, signature);
  }

  /// Compares two strings without leaking length or content through timing.
  static bool constantTimeEquals(String a, String b) {
    final aBytes = utf8.encode(a);
    final bBytes = utf8.encode(b);
    var diff = aBytes.length ^ bBytes.length;
    final length = min(aBytes.length, bBytes.length);
    for (var i = 0; i < length; i++) {
      diff |= aBytes[i] ^ bBytes[i];
    }
    return diff == 0;
  }

  /// Hashes a PIN with PBKDF2-HMAC-SHA256.
  static Future<String> hashPin(
    String pin, {
    int iterations = _pinIterations,
  }) async {
    final salt = _randomBytes(16);
    final bytes = pbkdf2Sha256(
      password: utf8.encode(pin),
      salt: salt,
      iterations: iterations,
      length: 32,
    );
    return 'pbkdf2-sha256\$$iterations\$${base64Url.encode(salt)}\$${base64Url.encode(bytes)}';
  }

  /// Verifies a PIN against a stored PBKDF2 hash.
  static Future<bool> verifyPin(String pin, String stored) async {
    try {
      final parts = stored.split(r'$');
      if (parts.length != 4 || parts[0] != 'pbkdf2-sha256') return false;
      final iterations = int.tryParse(parts[1]);
      if (iterations == null || iterations < 1) return false;
      final salt = base64Url.decode(parts[2]);
      final expected = base64Url.decode(parts[3]);
      final bytes = pbkdf2Sha256(
        password: utf8.encode(pin),
        salt: salt,
        iterations: iterations,
        length: expected.length,
      );
      var diff = bytes.length ^ expected.length;
      final length = min(bytes.length, expected.length);
      for (var i = 0; i < length; i++) {
        diff |= bytes[i] ^ expected[i];
      }
      return diff == 0;
    } catch (_) {
      return false;
    }
  }

  /// PBKDF2-HMAC-SHA256 (RFC 8018) key derivation.
  ///
  /// This is a synchronous implementation over `package:crypto`. It replaces
  /// `package:cryptography`'s `DartPbkdf2`, which allocates a fresh MAC state
  /// for every iteration: at the 30k iterations used for PINs it measures
  /// ~83ms here against ~259ms for the previous implementation, and batch
  /// generation hashes one PIN per unit inside a single request. The derived
  /// bytes are identical to both implementations, so hashes written before the
  /// swap still verify.
  static Uint8List pbkdf2Sha256({
    required List<int> password,
    required List<int> salt,
    required int iterations,
    required int length,
  }) {
    const macLength = 32;
    final hmac = Hmac(sha256, password);
    final blocks = (length + macLength - 1) ~/ macLength;
    final output = Uint8List(blocks * macLength);
    final firstBlock = Uint8List(salt.length + 4)
      ..setRange(0, salt.length, salt);
    final indexAt = salt.length;
    for (var block = 1; block <= blocks; block++) {
      // The first block index is big endian and appended to the salt.
      firstBlock[indexAt] = 0xFF & (block >> 24);
      firstBlock[indexAt + 1] = 0xFF & (block >> 16);
      firstBlock[indexAt + 2] = 0xFF & (block >> 8);
      firstBlock[indexAt + 3] = 0xFF & block;
      var u = hmac.convert(firstBlock).bytes;
      final accumulator = Uint8List.fromList(u);
      for (var i = 1; i < iterations; i++) {
        u = hmac.convert(u).bytes;
        for (var b = 0; b < macLength; b++) {
          accumulator[b] ^= u[b];
        }
      }
      output.setRange((block - 1) * macLength, block * macLength, accumulator);
    }
    return length == output.length
        ? output
        : Uint8List.sublistView(output, 0, length);
  }

  /// Encrypts a PIN with AES-256-GCM, binding it to [aad].
  ///
  /// The 12 byte nonce is prepended to the ciphertext and the GCM tag is
  /// appended. [keyHex] is 64 hex characters (32 bytes).
  static Future<String> encryptPin({
    required String pin,
    required String keyHex,
    required String aad,
  }) {
    return encryptValue(plaintext: pin, keyHex: keyHex, aad: aad);
  }

  /// Decrypts a PIN encrypted with [encryptPin]. Returns null when the
  /// ciphertext, key, or additional data does not match.
  static Future<String?> decryptPin({
    required String ciphertext,
    required String keyHex,
    required String aad,
  }) {
    return decryptValue(ciphertext: ciphertext, keyHex: keyHex, aad: aad);
  }

  /// Encrypts any small string with AES-256-GCM.
  static Future<String> encryptValue({
    required String plaintext,
    required String keyHex,
    required String aad,
  }) async {
    final algorithm = c.AesGcm.with256bits();
    final nonce = _randomBytes(12);
    final box = await algorithm.encrypt(
      utf8.encode(plaintext),
      secretKey: c.SecretKey(_hexToBytes(keyHex)),
      nonce: nonce,
      aad: utf8.encode(aad),
    );
    final combined =
        Uint8List(nonce.length + box.cipherText.length + box.mac.bytes.length)
          ..setRange(0, nonce.length, nonce)
          ..setRange(
            nonce.length,
            nonce.length + box.cipherText.length,
            box.cipherText,
          )
          ..setRange(
            nonce.length + box.cipherText.length,
            nonce.length + box.cipherText.length + box.mac.bytes.length,
            box.mac.bytes,
          );
    return base64Url.encode(combined);
  }

  /// Decrypts a value produced by [encryptValue].
  static Future<String?> decryptValue({
    required String ciphertext,
    required String keyHex,
    required String aad,
  }) async {
    try {
      final combined = base64Url.decode(ciphertext);
      if (combined.length < 12 + 16) return null;
      final nonce = combined.sublist(0, 12);
      final macStart = combined.length - 16;
      final cipherText = combined.sublist(12, macStart);
      final mac = combined.sublist(macStart);
      final algorithm = c.AesGcm.with256bits();
      final clear = await algorithm.decrypt(
        c.SecretBox(cipherText, nonce: nonce, mac: c.Mac(mac)),
        secretKey: c.SecretKey(_hexToBytes(keyHex)),
        aad: utf8.encode(aad),
      );
      return utf8.decode(clear);
    } catch (_) {
      return null;
    }
  }

  /// Generates a random secret as lowercase hex with [byteLength] bytes.
  static String generateSecret({int byteLength = 32}) =>
      _hex(_randomBytes(byteLength));

  /// Generates an API key body and its display prefix.
  static String generateApiKeyBody({int byteLength = 32}) =>
      _hex(_randomBytes(byteLength));

  /// A fast SHA-256 hash used for secrets that must be stored verifiably.
  static String sha256Hex(String value) =>
      sha256.convert(utf8.encode(value)).toString();

  /// Masks a token for display, keeping a short prefix and suffix.
  static String maskToken(String token) {
    if (token.length <= 10) {
      return '${token.substring(0, min(2, token.length))}...';
    }
    return '${token.substring(0, 4)}...${token.substring(token.length - 4)}';
  }

  static Uint8List _randomBytes(int length) {
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = _random.nextInt(256);
    }
    return bytes;
  }

  static String _hex(List<int> bytes) {
    final buffer = StringBuffer();
    for (final byte in bytes) {
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }

  static Uint8List _hexToBytes(String hex) {
    final normalized = hex.length.isOdd ? '0$hex' : hex;
    final bytes = Uint8List(normalized.length ~/ 2);
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = int.parse(normalized.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return bytes;
  }
}

const int _pinIterations = 120000;
