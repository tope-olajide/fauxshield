import 'package:fauxshield_server/src/generated/protocol.dart';
import 'package:fauxshield_server/src/services/api_key_auth.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given API key authentication', (sessionBuilder, endpoints) {
    late TestSessionBuilder owner;
    late BrandFixture fixture;
    late String secret;
    late UuidValue keyId;

    Future<ApiKeySecret> issueKey({
      List<ApiScope> scopes = const <ApiScope>[
        ApiScope.productsRead,
        ApiScope.batchesRead,
      ],
      int rateLimitPerMinute = 120,
      String label = 'agent',
    }) {
      return endpoints.apiKey.create(
        owner,
        workspaceId: fixture.workspaceId,
        label: label,
        scopes: scopes,
        rateLimitPerMinute: rateLimitPerMinute,
      );
    }

    setUp(() async {
      owner = authenticatedAs(sessionBuilder, 'owner-key');
      fixture = await setUpBrand(endpoints, owner, quantity: 3);
      final issued = await issueKey();
      secret = issued.secret;
      keyId = issued.apiKey.id!;
    });

    test('turns a presented key into a machine identity', () async {
      final info = await withApiKeyAuthentication(null)(
        sessionBuilder.build(),
        secret,
      );
      expect(info, isNotNull);
      expect(info!.userIdentifier, apiKeyIdentifier(keyId));
      expect(info.authId, keyId.uuid);
    });

    test('leaves an unknown key unauthenticated', () async {
      final session = sessionBuilder.build();
      expect(
        await withApiKeyAuthentication(null)(session, 'fs_live_0000deadbeef'),
        isNull,
      );
      expect(
        await withApiKeyAuthentication(null)(session, 'not-a-key'),
        isNull,
      );
    });

    test(
      'reads what its scopes allow and is refused what they do not',
      () async {
        final agent = authenticatedAs(sessionBuilder, apiKeyIdentifier(keyId));

        final products = await endpoints.product.list(
          agent,
          workspaceId: fixture.workspaceId,
          includeArchived: false,
        );
        expect(products, hasLength(1));

        await expectLater(
          endpoints.product.create(
            agent,
            workspaceId: fixture.workspaceId,
            name: 'Sneaky clone',
          ),
          throwsA(
            isA<AuthenticationException>().having(
              (error) => error.message,
              'message',
              contains('productsWrite'),
            ),
          ),
        );
      },
    );

    test('cannot reach operator-only operations', () async {
      final agent = authenticatedAs(sessionBuilder, apiKeyIdentifier(keyId));
      await expectLater(
        endpoints.identity.revealPin(
          agent,
          workspaceId: fixture.workspaceId,
          identityId: fixture.identities.first.id!,
        ),
        throwsA(
          isA<AuthenticationException>().having(
            (error) => error.message,
            'message',
            contains('reserved for signed in operators'),
          ),
        ),
      );
    });

    test('stops working the moment the key is revoked', () async {
      await endpoints.apiKey.revoke(
        owner,
        workspaceId: fixture.workspaceId,
        apiKeyId: keyId,
      );
      final agent = authenticatedAs(sessionBuilder, apiKeyIdentifier(keyId));
      await expectLater(
        endpoints.product.list(
          agent,
          workspaceId: fixture.workspaceId,
          includeArchived: false,
        ),
        throwsA(
          isA<AuthenticationException>().having(
            (error) => error.message,
            'message',
            contains('no longer valid'),
          ),
        ),
      );
    });

    test('cannot be pointed at another workspace', () async {
      final stranger = await endpoints.workspace.create(
        authenticatedAs(sessionBuilder, 'owner-other'),
        'Other Brand',
      );
      final agent = authenticatedAs(sessionBuilder, apiKeyIdentifier(keyId));
      await expectLater(
        endpoints.product.list(
          agent,
          workspaceId: stranger.workspace.id!,
          includeArchived: false,
        ),
        throwsA(
          isA<AuthenticationException>().having(
            (error) => error.message,
            'message',
            contains('do not have access'),
          ),
        ),
      );
    });

    test('is rate limited per key', () async {
      final limited = await issueKey(
        label: 'limited',
        scopes: const <ApiScope>[ApiScope.productsRead],
        rateLimitPerMinute: 1,
      );
      final agent = authenticatedAs(
        sessionBuilder,
        apiKeyIdentifier(limited.apiKey.id!),
      );

      await endpoints.product.list(
        agent,
        workspaceId: fixture.workspaceId,
        includeArchived: false,
      );
      await expectLater(
        endpoints.product.list(
          agent,
          workspaceId: fixture.workspaceId,
          includeArchived: false,
        ),
        throwsA(isA<RateLimitException>()),
      );
    });

    test('records the key as the actor in the audit log', () async {
      final agent = authenticatedAs(sessionBuilder, apiKeyIdentifier(keyId));
      await issueKey(rateLimitPerMinute: 120, label: 'audited');

      final events = await endpoints.audit.query(
        owner,
        workspaceId: fixture.workspaceId,
        action: 'api_key.created',
        page: 0,
        pageSize: 50,
      );
      expect(events, isNotEmpty);
      expect(
        events.map((event) => event.actorIdentifier),
        contains('owner-key'),
      );

      // The key itself can read the audit trail when it carries the scope.
      final auditor = await issueKey(
        label: 'auditor',
        scopes: const <ApiScope>[ApiScope.auditRead],
      );
      final auditorSession = authenticatedAs(
        sessionBuilder,
        apiKeyIdentifier(auditor.apiKey.id!),
      );
      expect(
        await endpoints.audit.query(
          auditorSession,
          workspaceId: fixture.workspaceId,
          page: 0,
          pageSize: 50,
        ),
        isNotEmpty,
      );
      expect(agent, isNotNull);
    });
  });
}
