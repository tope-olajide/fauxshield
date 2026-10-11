import 'package:fauxshield_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the product recycle bin', (sessionBuilder, endpoints) {
    late TestSessionBuilder owner;
    late BrandFixture fixture;

    setUp(() async {
      owner = authenticatedAs(sessionBuilder, 'owner-1');
      fixture = await setUpBrand(endpoints, owner);
    });

    test(
      'deleting a product hides it from the catalog until restored',
      () async {
        final deleted = await endpoints.product.delete(
          owner,
          workspaceId: fixture.workspaceId,
          productId: fixture.product.id!,
          reason: 'Discontinued line.',
        );
        expect(deleted.deletedAt, isNotNull);
        expect(deleted.deleteReason, 'Discontinued line.');

        final listed = await endpoints.product.list(
          owner,
          workspaceId: fixture.workspaceId,
          includeArchived: false,
        );
        expect(listed.map((p) => p.id), isNot(contains(fixture.product.id)));

        final bin = await endpoints.product.listDeleted(
          owner,
          workspaceId: fixture.workspaceId,
        );
        expect(bin.single.id, fixture.product.id);

        final restored = await endpoints.product.restore(
          owner,
          workspaceId: fixture.workspaceId,
          productId: fixture.product.id!,
        );
        expect(restored.deletedAt, isNull);

        final listedAgain = await endpoints.product.list(
          owner,
          workspaceId: fixture.workspaceId,
          includeArchived: false,
        );
        expect(listedAgain.map((p) => p.id), contains(fixture.product.id));

        final emptyBin = await endpoints.product.listDeleted(
          owner,
          workspaceId: fixture.workspaceId,
        );
        expect(emptyBin, isEmpty);
      },
    );

    test('delete impact counts the whole tree under the product', () async {
      final impact = await endpoints.product.deleteImpact(
        owner,
        workspaceId: fixture.workspaceId,
        productId: fixture.product.id!,
      );
      expect(impact.productName, fixture.product.name);
      expect(impact.batchCount, 1);
      expect(impact.identityCount, fixture.identities.length);
      expect(impact.inRecycleBin, isFalse);
    });

    test('batches cannot be created under a recycled product', () async {
      await endpoints.product.delete(
        owner,
        workspaceId: fixture.workspaceId,
        productId: fixture.product.id!,
      );
      expect(
        () => endpoints.batch.create(
          owner,
          workspaceId: fixture.workspaceId,
          productId: fixture.product.id!,
          reference: 'LOT-9',
          manufactureDate: DateTime.now().toUtc(),
          distributionRegion: 'NG',
          quantity: 10,
        ),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  // The purge runs its own database transaction, which cannot be nested
  // inside the per-test rollback transaction, so this group disables rollbacks.
  withServerpod(
    'Given a recycled product with a full tree',
    (sessionBuilder, endpoints) {
      late TestSessionBuilder owner;
      late BrandFixture fixture;

      setUp(() async {
        owner = authenticatedAs(sessionBuilder, 'owner-1');
        fixture = await setUpBrand(endpoints, owner);
      });

      test('purge erases the product, its batches, and its units', () async {
        final impact = await endpoints.product.deleteImpact(
          owner,
          workspaceId: fixture.workspaceId,
          productId: fixture.product.id!,
        );
        expect(impact.identityCount, greaterThan(0));

        await endpoints.product.purge(
          owner,
          workspaceId: fixture.workspaceId,
          productId: fixture.product.id!,
        );

        expect(
          () => endpoints.product.get(owner, fixture.product.id!),
          throwsA(isA<NotFoundException>()),
        );
        final batches = await endpoints.batch.list(
          owner,
          workspaceId: fixture.workspaceId,
          productId: fixture.product.id!,
        );
        expect(batches, isEmpty);
        final identities = await endpoints.identity.list(
          owner,
          workspaceId: fixture.workspaceId,
          batchId: fixture.batch.id,
          onlyFlagged: false,
          page: 0,
          pageSize: 25,
        );
        expect(identities, isEmpty);

        // A purged unit's token no longer resolves for consumers.
        await expectLater(
          endpoints.verification.start(
            anonymous(sessionBuilder),
            fixture.identities.first.qrToken,
            'device-purged',
          ),
          throwsA(isA<VerificationException>()),
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
