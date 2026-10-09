import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield auth ...`
class AuthCommand extends Command<int> {
  AuthCommand() {
    addSubcommand(AuthLoginCommand());
    addSubcommand(AuthLogoutCommand());
    addSubcommand(AuthWhoamiCommand());
    addSubcommand(AuthTokenCommand());
  }

  @override
  String get name => 'auth';

  @override
  String get description => 'Sign in, sign out, and inspect the session.';

  @override
  String get invocation => 'fauxshield auth <login|logout|whoami|token>';
}

/// Exchanges an email and password for a JWT and stores it.
class AuthLoginCommand extends CliCommand {
  AuthLoginCommand() {
    argParser
      ..addOption(
        'email',
        abbr: 'e',
        help: 'Account email.',
        valueHelp: 'you@brand.test',
      )
      ..addOption(
        'password',
        abbr: 'p',
        help: 'Account password. Falls back to FAUXSHIELD_PASSWORD.',
      );
  }

  @override
  String get name => 'login';

  @override
  String get description => 'Sign in and store the session token.';

  @override
  Future<int> run() async {
    final email = (argResults?['email'] as String?)?.trim();
    final flagPassword = (argResults?['password'] as String?)?.trim();
    final environmentPassword = Platform.environment['FAUXSHIELD_PASSWORD']
        ?.trim();
    final password = flagPassword != null && flagPassword.isNotEmpty
        ? flagPassword
        : environmentPassword;
    if (email == null || email.isEmpty) {
      throw CliException.usage('Pass the account with --email.');
    }
    if (password == null || password.isEmpty) {
      throw CliException.usage(
        'Pass the password with --password, or set FAUXSHIELD_PASSWORD.',
      );
    }

    // `--url` is registered on every leaf command, so whatever it resolved to
    // is what gets remembered.
    final url = resolvedUrl;

    final session = await _signIn(url, email, password);
    CliConfig(url: url, token: session.token).save();

    if (jsonOutput) {
      printJson(<String, dynamic>{
        'url': url,
        'email': email,
        'authUserId': session.authUserId,
        'authStrategy': session.authStrategy,
        'scopes': session.scopes,
      });
      return 0;
    }

    stdout.writeln('Signed in to $url as $email.');
    if (session.scopes.isNotEmpty) {
      stdout.writeln('Scopes: ${session.scopes.join(', ')}');
    }
    stdout.writeln('Credentials stored in ${CliConfig.path}');
    return 0;
  }

  /// Exchanges the credentials for a session and keeps only what is printed.
  ///
  /// The generated client returns the auth model from
  /// `serverpod_auth_core_client`, which the SDK does not re-export, so the
  /// handful of fields this command needs are lifted into a record rather than
  /// reaching around the SDK for the type name.
  Future<
    ({
      String token,
      String authUserId,
      String authStrategy,
      List<String> scopes,
    })
  >
  _signIn(String url, String email, String password) async {
    try {
      final result = await Client(url).emailIdp.login(
        email: email,
        password: password,
      );
      return (
        token: result.token,
        authUserId: result.authUserId.uuid,
        authStrategy: result.authStrategy,
        scopes: result.scopeNames.toList()..sort(),
      );
    } catch (error) {
      throw CliException('Sign in failed: ${describeError(error)}');
    }
  }
}

/// Removes the stored token.
class AuthLogoutCommand extends CliCommand {
  @override
  String get name => 'logout';

  @override
  String get description => 'Forget the stored session token.';

  @override
  Future<int> run() async {
    CliConfig.clear();
    if (jsonOutput) {
      printJson(<String, dynamic>{'signedOut': true});
    } else {
      stdout.writeln('Signed out.');
    }
    return 0;
  }
}

/// Shows which workspace the token resolves to.
class AuthWhoamiCommand extends CliCommand {
  @override
  String get name => 'whoami';

  @override
  String get description => 'Show the workspace and role for the active token.';

  @override
  Future<int> run() async {
    final context = connect();
    final WorkspaceBootstrap? bootstrap;
    try {
      bootstrap = await context.client.workspace.bootstrap();
    } catch (error) {
      throw CliException('Could not read the session: ${describeError(error)}');
    }

    if (bootstrap == null) {
      throw CliException(
        'That token is not a member of any workspace. Create one in the '
        'operator app, or join the demo workspace.',
      );
    }

    if (context.json) {
      printJson(<String, dynamic>{
        'url': context.url,
        'workspaceId': bootstrap.workspace.id?.uuid,
        'workspace': bootstrap.workspace.name,
        'slug': bootstrap.workspace.slug,
        'role': bootstrap.role.name,
        'isDemo': bootstrap.isDemo,
        'permissions': bootstrap.permissions,
      });
      return 0;
    }

    stdout.writeln('Server:     ${context.url}');
    stdout.writeln('Workspace:  ${bootstrap.workspace.name}');
    stdout.writeln('Slug:       ${bootstrap.workspace.slug}');
    stdout.writeln('Role:       ${bootstrap.role.name}');
    stdout.writeln('Demo:       ${yesNo(bootstrap.isDemo)}');
    stdout.writeln('Permissions: ${bootstrap.permissions.length}');
    return 0;
  }
}

/// Prints the active token, so it can be piped into other tools.
class AuthTokenCommand extends CliCommand {
  @override
  String get name => 'token';

  @override
  String get description => 'Print the active session token.';

  @override
  Future<int> run() async {
    final token = resolvedToken;
    if (token == null) {
      throw CliException('No token available. Run `fauxshield auth login`.');
    }
    if (jsonOutput) {
      printJson(<String, dynamic>{'url': resolvedUrl, 'token': token});
    } else {
      stdout.writeln(token);
    }
    return 0;
  }
}
