import 'dart:convert';

import 'package:fauxshield_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

/// A one pixel PNG: enough for the magic-byte check, and small enough to keep
/// the assertion about stored bytes exact.
final List<int> _pixelPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8DwHwAF'
  'AAH/q842iQAAAABJRU5ErkJggg==',
);

void main() {
  withServerpod('Given product images', (sessionBuilder, endpoints) {
    late TestSessionBuilder owner;
    late BrandFixture fixture;

    setUp(() async {
      owner = authenticatedAs(sessionBuilder, 'owner-images');
      fixture = await setUpBrand(endpoints, owner);
    });

    test(
      'an uploaded image is stored durably and served by the API host',
      () async {
        final url = await endpoints.product.uploadImage(
          owner,
          workspaceId: fixture.workspaceId,
          fileName: 'label.png',
          data: base64Encode(_pixelPng),
          productId: fixture.product.id,
        );

        // The old code wrote the bytes under web/static on the podlet's own
        // disk and handed back a /web/media path, so the image survived only
        // until the next deploy and every later request 404ed. The URL must
        // now be absolute and point at the storage endpoint instead.
        expect(url, startsWith('http'));
        expect(url, contains('serverpod_cloud_storage'));
        expect(url, isNot(contains('/web/media/')));

        // And the bytes have to be readable back from that storage, because a
        // URL that nothing serves is the bug we are fixing.
        final session = owner.build();
        final storage = session.serverpod.storage['public'];
        expect(storage, isNotNull, reason: 'the public storage must be set up');
        final storedPath = Uri.parse(url).queryParameters['path'];
        expect(storedPath, isNotNull, reason: 'the URL must address a file');
        expect(
          await storage!.fileExists(session: session, path: storedPath!),
          isTrue,
        );
        final stored = await storage.retrieveFile(
          session: session,
          path: storedPath,
        );
        expect(
          stored.buffer.asUint8List(
            stored.offsetInBytes,
            stored.lengthInBytes,
          ),
          _pixelPng,
        );
      },
    );

    test('the URL is kept on the product and never overwritten', () async {
      final first = await endpoints.product.uploadImage(
        owner,
        workspaceId: fixture.workspaceId,
        fileName: 'front.png',
        data: base64Encode(_pixelPng),
        productId: fixture.product.id,
      );
      final second = await endpoints.product.uploadImage(
        owner,
        workspaceId: fixture.workspaceId,
        fileName: 'back.png',
        data: base64Encode(_pixelPng),
        productId: fixture.product.id,
      );
      expect(first, isNot(second), reason: 'a name is never reused');

      final product = await endpoints.product.get(owner, fixture.product.id!);
      expect(product.imageUrls, <String>[first, second]);

      // Reading the product again is what a second podlet or a later request
      // does: the row, not a container disk, has to carry the images.
      final reread = await endpoints.product.get(owner, fixture.product.id!);
      expect(reread.imageUrls, contains(first));
    });
  });
}
