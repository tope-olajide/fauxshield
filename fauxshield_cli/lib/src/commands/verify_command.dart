import 'dart:io';
import 'dart:math';

import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield verify --token <token> --pin <pin>`
///
/// Runs the same two calls the consumer web page makes. No sign in required,
/// because verification is a public endpoint.
class VerifyCommand extends CliCommand {
  VerifyCommand() {
    argParser
      ..addOption(
        'token',
        abbr: 't',
        help: 'QR token from the packaging.',
      )
      ..addOption('pin', abbr: 'p', help: 'Packaging PIN.')
      ..addOption(
        'fingerprint',
        abbr: 'f',
        help: 'Device fingerprint. Defaults to a random value per run.',
      );
  }

  /// `--token` here is the QR token from the packaging, not a session token,
  /// so the inherited session override is switched off.
  @override
  bool get acceptsAuthToken => false;

  @override
  String get name => 'verify';

  @override
  String get description => 'Verify a unit as a consumer would.';

  @override
  String get invocation => 'fauxshield verify --token <token> [--pin <pin>]';

  @override
  Future<int> run() async {
    final token = requiredOption('token');
    final pin = (argResults?['pin'] as String?)?.trim();
    final fingerprint =
        (argResults?['fingerprint'] as String?)?.trim().isNotEmpty == true
        ? (argResults!['fingerprint'] as String).trim()
        : 'fauxshield-cli-${_randomHex(6)}';
    final context = connect(requireAuth: false);

    final VerificationPresentation presentation;
    try {
      presentation = await context.client.verification.start(
        token,
        fingerprint,
      );
    } catch (error) {
      throw CliException(
        'Could not resolve that token: '
        '${describeError(error)}',
      );
    }

    var result = presentation;

    // A resolved session still owes the packaging PIN. The server advances
    // `tokenResolved` to `pinPrompted` and then to `pinSubmitted` inside this
    // single call, so the CLI does not have to walk the state machine itself.
    if (pin != null &&
        pin.isNotEmpty &&
        (result.state == VerificationState.tokenResolved ||
            result.state == VerificationState.pinPrompted)) {
      try {
        result = await context.client.verification.submitPin(
          result.sessionId,
          fingerprint,
          pin,
        );
      } catch (error) {
        throw CliException(
          'Could not submit the PIN: '
          '${describeError(error)}',
        );
      }
    }

    if (context.json) {
      printJson(result.toJson());
      return 0;
    }

    final outcome = result.outcome;
    if (outcome != null) {
      stdout.writeln('Verdict: ${outcome.name}');
    } else {
      stdout.writeln('State:   ${result.state.name}');
    }
    if (result.productName.isNotEmpty) {
      stdout.writeln('  product: ${result.productName}');
    }
    if (result.batchReference.isNotEmpty) {
      stdout.writeln('  batch:   ${result.batchReference}');
    }
    stdout.writeln('  brand:   ${result.workspaceName}');
    if (result.riskScore != null) {
      stdout.writeln('  risk:    ${result.riskScore!.name}');
    }
    stdout.writeln(
      '  first:   ${yesNo(result.firstVerified)} '
      '(${result.verificationCount} scan(s))',
    );
    if (result.location != null) {
      final location = result.location!;
      stdout.writeln('  where:   ${location.city}, ${location.country}');
    }

    if (result.state == VerificationState.tokenResolved ||
        result.state == VerificationState.pinPrompted) {
      stdout.writeln(
        '\nThis unit is wrapped. Finish the flow with the packaging PIN:\n'
        '  fauxshield verify --token $token --pin <pin>',
      );
    }

    return 0;
  }

  static String _randomHex(int bytes) {
    final random = Random.secure();
    final buffer = StringBuffer();
    for (var i = 0; i < bytes; i++) {
      buffer.write(random.nextInt(256).toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}
