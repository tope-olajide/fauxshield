import 'package:fauxshield_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test/serverpod_test.dart' as st;

import 'test_tools/serverpod_test_tools.dart';

/// A fully provisioned brand used by integration tests.
class BrandFixture {
  BrandFixture({
    required this.bootstrap,
    required this.product,
    required this.batch,
    required this.identities,
  });

  final WorkspaceBootstrap bootstrap;
  final Product product;
  final Batch batch;
  final List<ProductIdentity> identities;

  UuidValue get workspaceId => bootstrap.workspace.id!;
}

/// Creates a workspace with one product, one batch, and generated identities.
///
/// The default fraud policy is tightened so tests reach fraud thresholds in a
/// handful of steps instead of dozens.
Future<BrandFixture> setUpBrand(
  TestEndpoints endpoints,
  TestSessionBuilder owner, {
  String name = 'Test Brand',
  String distributionRegion = 'NG',
  int quantity = 3,
  FraudPolicy? fraudPolicy,
}) async {
  final stamp = DateTime.now().microsecondsSinceEpoch;
  final bootstrap = await endpoints.workspace.create(
    owner,
    '$name $stamp',
    branding: Branding(
      displayName: 'Test Brand Display',
      themeColor: '#0f766e',
      tagline: 'Test tagline',
    ),
  );

  await endpoints.workspace.update(
    owner,
    workspaceId: bootstrap.workspace.id,
    fraudPolicy:
        fraudPolicy ??
        FraudPolicy(
          velocityWindowMinutes: 60,
          velocityThreshold: 3,
          pinAttackThreshold: 2,
          batchDuplicationThreshold: 2,
          cloneWindowMinutes: 60,
          cloneDistanceThresholdKm: 50,
          autoLockOnFraud: true,
          alertOnHigh: true,
        ),
  );

  final product = await endpoints.product.create(
    owner,
    workspaceId: bootstrap.workspace.id,
    name: 'Test Olive Oil $stamp',
    sku: 'TST-$stamp',
    description: 'Integration test product.',
  );

  final batch = await endpoints.batch.create(
    owner,
    workspaceId: bootstrap.workspace.id,
    productId: product.id!,
    reference: 'REF-$stamp',
    manufactureDate: DateTime.now().toUtc(),
    distributionRegion: distributionRegion,
    quantity: quantity,
  );

  await endpoints.batch.generateIdentities(
    owner,
    workspaceId: bootstrap.workspace.id,
    batchId: batch.id!,
    quantity: quantity,
    idempotencyKey: 'fixture-$stamp',
  );

  final identities = await endpoints.identity.list(
    owner,
    workspaceId: bootstrap.workspace.id,
    batchId: batch.id!,
    onlyFlagged: false,
    page: 0,
    pageSize: 25,
  );

  return BrandFixture(
    bootstrap: bootstrap,
    product: product,
    batch: batch,
    identities: identities,
  );
}

/// Builds an authenticated session builder for a test user.
TestSessionBuilder authenticatedAs(
  TestSessionBuilder base,
  String userIdentifier,
) {
  return base.copyWith(
    authentication: st.AuthenticationOverride.authenticationInfo(
      userIdentifier,
      const <Scope>{},
    ),
  );
}

/// Builds an anonymous session builder for public consumer calls.
TestSessionBuilder anonymous(TestSessionBuilder base) {
  return base.copyWith(
    authentication: st.AuthenticationOverride.unauthenticated(),
  );
}

/// A wrong six digit PIN that is guaranteed to differ from [pin].
String wrongPin(String pin) {
  final candidate = pin == '000000' ? '000001' : '000000';
  return candidate;
}
