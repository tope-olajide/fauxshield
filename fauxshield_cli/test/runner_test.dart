import 'package:fauxshield_cli/fauxshield.dart';
import 'package:test/test.dart';

void main() {
  test('an unknown command is a usage error', () async {
    expect(await runCli(<String>['nonsense']), exitUsage);
  });

  test('a missing required option is a usage error, not a crash', () async {
    expect(await runCli(<String>['verify']), exitUsage);
    expect(await runCli(<String>['alerts', 'show']), exitUsage);
    expect(await runCli(<String>['batches', 'create']), exitUsage);
  });

  test('a mistake in the invocation is a usage error', () async {
    expect(
      await runCli(<String>['auth', 'login', '--email', 'someone@brand.test']),
      exitUsage,
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
        'verify',
      ]),
    );
  });
}
