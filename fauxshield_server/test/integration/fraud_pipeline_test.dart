import 'package:fauxshield_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the FauxShield fraud pipeline', (
    sessionBuilder,
    endpoints,
  ) {
    late TestSessionBuilder owner;
    late BrandFixture fixture;

    setUp(() async {
      owner = authenticatedAs(sessionBuilder, 'owner-1');
      fixture = await setUpBrand(endpoints, owner);
    });

    test(
      'a clone attack simulation raises alerts with evidence',
      () async {
        final simulation = await endpoints.simulation.start(
          owner,
          workspaceId: fixture.workspaceId,
          request: SimulationRequest(
            type: SimulationType.cloneAttack,
            label: 'Integration clone rehearsal',
            batchId: fixture.batch.id,
            steps: 6,
            stepDelaySeconds: 0,
          ),
        );
        expect(simulation.status, SimulationStatus.completed);
        expect(simulation.progress, 6);

        final alerts = await endpoints.alert.list(
          owner,
          workspaceId: fixture.workspaceId,
          page: 0,
          pageSize: 25,
        );
        expect(alerts, isNotEmpty);

        final evidence = await endpoints.alert.evidence(
          owner,
          alerts.first.id!,
        );
        expect(evidence.signals, isNotEmpty);
        expect(evidence.sessions, isNotEmpty);
        expect(evidence.identity, isNotNull);

        final sessions = await endpoints.verification.list(
          owner,
          workspaceId: fixture.workspaceId,
          source: ScanSource.simulation,
          page: 0,
          pageSize: 25,
        );
        expect(sessions, isNotEmpty);
      },
    );

    test('a PIN brute force simulation produces pin attack signals', () async {
      final simulation = await endpoints.simulation.start(
        owner,
        workspaceId: fixture.workspaceId,
        request: SimulationRequest(
          type: SimulationType.pinBruteForce,
          batchId: fixture.batch.id,
          stepDelaySeconds: 0,
        ),
      );
      expect(simulation.status, SimulationStatus.completed);

      final signals = await endpoints.alert.signals(
        owner,
        workspaceId: fixture.workspaceId,
        type: SignalType.pinAttack,
        page: 0,
        pageSize: 25,
      );
      expect(signals, isNotEmpty);

      final identities = await endpoints.identity.list(
        owner,
        workspaceId: fixture.workspaceId,
        batchId: fixture.batch.id!,
        onlyFlagged: false,
        page: 0,
        pageSize: 25,
      );
      expect(
        identities.any((identity) => identity.lockedUntil != null),
        isTrue,
        reason: 'the brute forced unit should carry a lockout timestamp',
      );
    });

    test('offline scans convert into authoritative verdicts', () async {
      final identity = fixture.identities.first;
      final verdicts = await endpoints.offline.ingest(
        owner,
        workspaceId: fixture.workspaceId,
        deviceId: 'inspector-1',
        scans: <OfflineScanInput>[
          OfflineScanInput(
            localId: 'local-1',
            deviceId: 'inspector-1',
            qrToken: identity.qrToken,
            scannedAt: DateTime.now().toUtc().subtract(
              const Duration(hours: 3),
            ),
            latitude: 6.5244,
            longitude: 3.3792,
            country: 'Nigeria',
            city: 'Lagos',
          ),
        ],
      );

      expect(verdicts.single.outcome, VerificationOutcome.authentic);
      expect(verdicts.single.sessionId, isNotNull);
      expect(verdicts.single.message, contains('Authentic'));
    });

    test('consumer reports reach the triage queue', () async {
      final identity = fixture.identities.first;
      final consumer = anonymous(sessionBuilder);
      var presentation = await endpoints.verification.start(
        consumer,
        identity.qrToken,
        'device-report',
      );
      presentation = await endpoints.verification.acknowledge(
        consumer,
        presentation.sessionId,
        'device-report',
      );

      final acknowledgement = await endpoints.verification.reportFake(
        consumer,
        presentation.sessionId,
        'device-report',
        'Packaging looks different',
        comment: 'The print quality is poor.',
      );
      expect(acknowledgement.reportId, isNotNull);

      final reports = await endpoints.alert.reports(
        owner,
        workspaceId: fixture.workspaceId,
        page: 0,
        pageSize: 25,
      );
      expect(reports, isNotEmpty);
      expect(reports.first.reason, 'Packaging looks different');
    });
  });
}
