import 'package:serverpod/serverpod.dart';

import '../core/geo_dataset.dart';
import '../generated/protocol.dart';
import 'analytics_service.dart';
import 'identity_service.dart';
import 'recall_service.dart';
import 'simulation_service.dart';
import 'verification_service.dart';

/// Builds the public demo workspace.
///
/// The seeder creates a realistic brand: products, batches, serialized
/// identities with real cryptographic material, a recall, authentic consumer
/// verifications (using audited PIN reveals), and live attack simulations
/// that flow through the real fraud pipeline. The result is a workspace that
/// looks like a brand mid-incident as soon as someone signs in.
class DemoSeeder {
  static const String workspaceName = 'Aurelia Foods';
  static const String _seederActor = 'demo-seeder';

  /// Creates the demo workspace and returns it.
  Future<Workspace> create(
    Session session, {
    required String actorIdentifier,
  }) async {
    final now = DateTime.now().toUtc();
    var workspace = await Workspace.db.insertRow(
      session,
      Workspace(
        name: workspaceName,
        slug: 'aurelia-foods-demo',
        branding: Branding(
          displayName: 'Aurelia Foods',
          themeColor: '#0f766e',
          tagline: 'Farm honest. Seal every jar.',
        ),
        authenticMessage:
            'Aurelia verified your product as genuine. Enjoy it with confidence.',
        restrictedCountries: <String>['CN', 'RU', 'TR'],
        fraudPolicy: FraudPolicy(
          velocityWindowMinutes: 60,
          velocityThreshold: 5,
          pinAttackThreshold: 4,
          batchDuplicationThreshold: 3,
          cloneWindowMinutes: 60,
          cloneDistanceThresholdKm: 100,
          autoLockOnFraud: true,
          alertOnHigh: true,
        ),
        demoMode: true,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await WorkspaceMember.db.insertRow(
      session,
      WorkspaceMember(
        workspaceId: workspace.id!,
        userIdentifier: actorIdentifier,
        email: '$actorIdentifier@demo.fauxshield.local',
        displayName: 'Demo Owner',
        role: MembershipRole.owner,
        createdAt: now,
      ),
    );
    // A small team so the team screen has content.
    for (final teammate in const <(String, String, MembershipRole)>[
      ('quality.lead@aurelia.example', 'Amara Okafor', MembershipRole.admin),
      ('field.inspector@aurelia.example', 'Tunde Bello', MembershipRole.member),
      ('analyst@aurelia.example', 'Sofia Mendes', MembershipRole.viewer),
    ]) {
      await WorkspaceMember.db.insertRow(
        session,
        WorkspaceMember(
          workspaceId: workspace.id!,
          userIdentifier: 'demo:${teammate.$1}',
          email: teammate.$1,
          displayName: teammate.$2,
          role: teammate.$3,
          createdAt: now,
        ),
      );
    }

    await _seedData(session, workspace: workspace);
    return workspace;
  }

  /// Wipes demo workspace data and seeds it again.
  Future<Workspace> reset(
    Session session, {
    required Workspace workspace,
    required String actorIdentifier,
  }) async {
    await _wipe(session, workspace.id!);
    // Make sure the caller is still a member after the wipe.
    final existing = await WorkspaceMember.db.findFirstRow(
      session,
      where: (t) =>
          t.workspaceId.equals(workspace.id!) &
          t.userIdentifier.equals(actorIdentifier),
    );
    if (existing == null) {
      await WorkspaceMember.db.insertRow(
        session,
        WorkspaceMember(
          workspaceId: workspace.id!,
          userIdentifier: actorIdentifier,
          email: '$actorIdentifier@demo.fauxshield.local',
          displayName: 'Demo Owner',
          role: MembershipRole.owner,
        ),
      );
    }
    await _seedData(session, workspace: workspace);
    return workspace;
  }

  Future<void> _wipe(Session session, UuidValue workspaceId) async {
    await VerificationSession.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await FraudSignalRecord.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await FraudAlert.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await RecallRecord.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await FakeReport.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await Notification.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await NotificationPreference.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await WebhookDelivery.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await WebhookEndpoint.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await ApiKey.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await AttackSimulation.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await OfflineScanRecord.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await DailyWorkspaceStat.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await AuditEvent.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await ProductIdentity.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await Batch.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await Product.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    await Invitation.db.deleteWhere(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
  }

  Future<void> _seedData(
    Session session, {
    required Workspace workspace,
  }) async {
    final workspaceId = workspace.id!;
    final now = DateTime.now().toUtc();

    final products = <Product>[
      await Product.db.insertRow(
        session,
        Product(
          workspaceId: workspaceId,
          name: 'Aurelia Extra Virgin Olive Oil 1L',
          sku: 'AUR-OIL-1L',
          category: 'Pantry',
          description:
              'Cold-pressed extra virgin olive oil, single origin, harvested this season.',
          packaging:
              'Dark glass bottle, tamper evident cap, QR + scratch PIN under the label.',
          shelfLife: '18 months from pressing date',
          safetyInstructions: 'Store away from direct sunlight.',
          imageUrls: const <String>[
            'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=800',
          ],
          createdBy: _seederActor,
          createdAt: now,
          updatedAt: now,
        ),
      ),
      await Product.db.insertRow(
        session,
        Product(
          workspaceId: workspaceId,
          name: 'Aurelia Raw Wildflower Honey 500g',
          sku: 'AUR-HNY-500',
          category: 'Pantry',
          description:
              'Unfiltered wildflower honey from highland apiaries, batch traced to the harvest week.',
          packaging:
              'Glass jar with sealed lid, QR + PIN under the lid sleeve.',
          shelfLife: '24 months',
          safetyInstructions: 'Not suitable for infants under 12 months.',
          imageUrls: const <String>[
            'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=800',
          ],
          createdBy: _seederActor,
          createdAt: now,
          updatedAt: now,
        ),
      ),
      await Product.db.insertRow(
        session,
        Product(
          workspaceId: workspaceId,
          name: 'Aurelia Shea Butter Repair Cream 200ml',
          sku: 'AUR-SHEA-200',
          category: 'Personal care',
          description:
              'Unrefined shea butter cream with baobab oil, dermatologically tested.',
          packaging: 'Aluminium tube, QR + PIN printed inside the carton flap.',
          shelfLife: '24 months after opening',
          safetyInstructions: 'For external use only.',
          createdBy: _seederActor,
          createdAt: now,
          updatedAt: now,
        ),
      ),
    ];

    final batches = <Batch>[
      await _createBatch(
        session,
        workspaceId,
        products[0],
        'AUR-OIL-2609-A',
        'NG',
        20,
        now,
      ),
      await _createBatch(
        session,
        workspaceId,
        products[0],
        'AUR-OIL-2609-B',
        'KE',
        20,
        now,
      ),
      await _createBatch(
        session,
        workspaceId,
        products[1],
        'AUR-HNY-2608-A',
        'NG',
        20,
        now,
      ),
      await _createBatch(
        session,
        workspaceId,
        products[2],
        'AUR-SHEA-2607-A',
        'GH',
        20,
        now,
      ),
    ];

    final identityService = IdentityService();
    for (final batch in batches) {
      await identityService.generateForBatch(
        session,
        workspaceId: workspaceId,
        batchId: batch.id!,
        quantity: 20,
        actorIdentifier: _seederActor,
      );
    }

    // Seed scan history. Some units get authentic verifications from real
    // consumer locations, one batch gets recalled, and attack simulations
    // populate the fraud queue with realistic evidence.
    await _seedAuthenticVerifications(session, workspace, batches[0]);
    await _seedAuthenticVerifications(session, workspace, batches[2]);

    final recalledBatch = batches[1];
    await RecallService.recallBatch(
      session,
      workspace: workspace,
      batchId: recalledBatch.id!,
      reason:
          'Elevated peroxide values found in retained samples from this lot.',
      actorIdentifier: _seederActor,
      notes:
          'Retail partners notified. Distributors to quarantine remaining stock.',
    );

    await _seedFakeReports(session, workspace, batches[2]);

    final simulations = SimulationService();
    await simulations.start(
      session,
      workspaceId: workspaceId,
      request: SimulationRequest(
        type: SimulationType.cloneAttack,
        label: 'Seeded: cloned oil bottles on two continents',
        batchId: batches[0].id,
        stepDelaySeconds: 0,
      ),
      createdBy: _seederActor,
    );

    // Inline simulations (zero delay) run through the real pipeline before the
    // endpoint returns, so the workspace already contains a live clone alert
    // and an escalating grey market investigation.
    await simulations.start(
      session,
      workspaceId: workspaceId,
      request: SimulationRequest(
        type: SimulationType.greyMarketLeak,
        label: 'Seeded: grey market cream',
        batchId: batches[3].id,
        stepDelaySeconds: 0,
      ),
      createdBy: _seederActor,
    );

    // One webhook endpoint so the outbox and retry schedule are visible.
    final webhookEndpoint = await WebhookEndpoint.db.insertRow(
      session,
      WebhookEndpoint(
        workspaceId: workspaceId,
        url: 'https://example.com/fauxshield/webhook',
        description: 'Sample receiver for the demo (deliveries will fail).',
        subscribedEvents: const <WebhookEventType>[
          WebhookEventType.fraudAlertCreated,
          WebhookEventType.recallIssued,
        ],
        enabled: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await WebhookDelivery.db.insertRow(
      session,
      WebhookDelivery(
        workspaceId: workspaceId,
        endpointId: webhookEndpoint.id!,
        eventType: WebhookEventType.recallIssued,
        payloadJson:
            '{"event":"recall_issued","batch":"${recalledBatch.reference}"}',
        status: DeliveryStatus.pending,
        nextAttemptAt: now,
        createdAt: now,
      ),
    );

    // Materialize today's rollup so the analytics screen has a series.
    await AnalyticsService.rollupDay(
      session,
      workspaceId: workspaceId,
      day: now,
    );
  }

  Future<Batch> _createBatch(
    Session session,
    UuidValue workspaceId,
    Product product,
    String reference,
    String region,
    int quantity,
    DateTime now,
  ) {
    return Batch.db.insertRow(
      session,
      Batch(
        workspaceId: workspaceId,
        productId: product.id!,
        reference: reference,
        manufactureDate: now.subtract(const Duration(days: 40)),
        expiryDate: now.add(const Duration(days: 500)),
        distributionRegion: region,
        quantity: quantity,
        status: BatchStatus.shipped,
        notes: 'Seeded demo batch.',
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  /// Runs authentic consumer verifications using audited PIN reveals.
  Future<int> _seedAuthenticVerifications(
    Session session,
    Workspace workspace,
    Batch batch,
  ) async {
    final identities = await ProductIdentity.db.find(
      session,
      where: (t) => t.batchId.equals(batch.id!) & t.deletedAt.equals(null),
      orderBy: (t) => t.createdAt,
      limit: 6,
    );
    final identityService = IdentityService();
    final verificationService = VerificationService();
    var verified = 0;

    for (var i = 0; i < identities.length; i++) {
      final identity = identities[i];
      final city =
          demoCities[(stableHash(identity.id!.uuid) + i) % demoCities.length];
      final fingerprint = 'demo-device-$i';
      try {
        final revealed = await identityService.revealPin(
          session,
          workspaceId: workspace.id!,
          identityId: identity.id!,
          actorIdentifier: _seederActor,
        );
        var verification = await verificationService.resolveToken(
          session,
          token: identity.qrToken,
          deviceFingerprint: fingerprint,
          source: ScanSource.consumerWeb,
          locationOverride: city,
        );
        if (verification.state == VerificationState.tokenResolved) {
          verification = await verificationService.advanceState(
            session,
            sessionId: verification.id!,
            deviceFingerprint: fingerprint,
            targetState: VerificationState.pinPrompted,
          );
        }
        if (verification.state == VerificationState.pinPrompted) {
          verification = await verificationService.advanceState(
            session,
            sessionId: verification.id!,
            deviceFingerprint: fingerprint,
            targetState: VerificationState.pinSubmitted,
          );
        }
        if (verification.state == VerificationState.pinSubmitted) {
          await verificationService.submitPin(
            session,
            sessionId: verification.id!,
            deviceFingerprint: fingerprint,
            pin: revealed.pin,
          );
          verified++;
        }
      } catch (_) {
        // A single seeded scan failing must not abort the whole seed.
      }
    }
    return verified;
  }

  Future<void> _seedFakeReports(
    Session session,
    Workspace workspace,
    Batch batch,
  ) async {
    final identities = await ProductIdentity.db.find(
      session,
      where: (t) => t.batchId.equals(batch.id!) & t.deletedAt.equals(null),
      orderBy: (t) => t.createdAt,
      limit: 2,
    );
    final reasons = <String>[
      'Packaging looks different from the last jar I bought',
      'Code did not verify',
    ];
    for (var i = 0; i < identities.length; i++) {
      await FakeReport.db.insertRow(
        session,
        FakeReport(
          workspaceId: workspace.id!,
          identityId: identities[i].id!,
          reason: reasons[i % reasons.length],
          comment: 'Seeded consumer report for the demo.',
          deviceFingerprint: 'demo-report-$i',
          country: 'Nigeria',
          city: 'Lagos',
          status: FakeReportStatus.open,
          source: ScanSource.consumerWeb,
        ),
      );
    }
  }
}
