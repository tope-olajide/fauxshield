import 'package:fauxshield_cli/fauxshield_cli.dart';
import 'package:test/test.dart';

void main() {
  test('an unknown command is a usage error', () async {
    expect(await runCli(<String>['nonsense']), exitUsage);
  });

  test('a missing required option is a usage error, not a crash', () async {
    expect(await runCli(<String>['verify']), exitUsage);
    expect(await runCli(<String>['alerts', 'show']), exitUsage);
    expect(await runCli(<String>['batches', 'create']), exitUsage);
    expect(await runCli(<String>['keys', 'create']), exitUsage);
    expect(await runCli(<String>['recalls', 'issue']), exitUsage);
    expect(await runCli(<String>['webhooks', 'create']), exitUsage);
  });

  test('a mistake in the invocation is a usage error', () async {
    expect(
      await runCli(<String>['auth', 'login', '--email', 'someone@brand.test']),
      exitUsage,
    );
  });

  test('an API key that is not a key is refused before any call', () async {
    expect(
      await runCli(<String>[
        'auth',
        'login',
        '--api-key',
        'not-a-key',
        '--url',
        'http://127.0.0.1:1',
      ]),
      exitUsage,
    );
  });

  test('--api-key is honoured with a stored credential', () async {
    // The key is only used to build the header, so the call fails on the
    // closed port rather than on a missing credential.
    expect(
      await runCli(<String>[
        'products',
        'list',
        '--api-key',
        'fs_live_abcdefghijklmnop',
        '--url',
        'http://127.0.0.1:1',
      ]),
      exitFailure,
    );
  });

  test('a refused connection fails without a stack trace', () async {
    // Port 1 is closed, so this fails the way an unreachable server does.
    expect(
      await runCli(<String>[
        'verify',
        '--token',
        '0123456789abcdef0123456789abcdef',
        '--url',
        'http://127.0.0.1:1',
      ]),
      exitFailure,
    );
  });

  test('every command group is registered', () {
    final runner = FauxShieldRunner();
    expect(
      runner.commands.keys,
      containsAll(<String>[
        'auth',
        'products',
        'batches',
        'identities',
        'alerts',
        'verifications',
        'recalls',
        'simulations',
        'analytics',
        'audit',
        'team',
        'keys',
        'webhooks',
        'notifications',
        'offline',
        'workspace',
        'demo',
        'verify',
      ]),
    );
  });

  test('a secret keeps only its identifying prefix', () {
    expect(maskSecret('fs_live_9f2c4b1a'), 'fs_live_9f2c…');
  });
}
