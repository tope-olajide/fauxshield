import 'package:fauxshield_flutter/utils/qr_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('qrPng', () {
    test('renders a valid PNG with quiet zone margins', () async {
      final bytes = await qrPng(
        'http://localhost:8082/verify?t=3f7c1a9e64b25d80a1b2c3d4e5f60718',
        size: 256,
        quietZone: 16,
      );

      // PNG magic number: 0x89 'P' 'N' 'G' \r \n 0x1A \n
      expect(
        bytes.sublist(0, 8),
        [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A],
        reason: 'qrPng must produce PNG-encoded image data',
      );
      // A rendered QR canvas is far larger than an empty image.
      expect(bytes.length, greaterThan(500));
    });

    test('output dimensions include the requested quiet zone', () async {
      final bytes = await qrPng(
        'http://localhost:8082/verify?t=abc',
        size: 128,
        quietZone: 8,
      );

      // IHDR is the first chunk: width/height are big-endian uint32 at
      // byte offsets 16 and 20.
      final width = _readUint32(bytes, 16);
      final height = _readUint32(bytes, 20);
      expect(width, 128 + 8 * 2);
      expect(height, 128 + 8 * 2);
    });
  });
}

int _readUint32(List<int> bytes, int offset) =>
    (bytes[offset] << 24) |
    (bytes[offset + 1] << 16) |
    (bytes[offset + 2] << 8) |
    bytes[offset + 3];
