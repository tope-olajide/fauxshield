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

/// Signs in with an email and password, or stores an API key.
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
      )
      ..addOption(
        'api-key',
        help:
            'Store an API key instead of signing in. Create one with '
            '`fauxshield keys create`.',
        valueHelp: 'fs_live_…',
      );
  }

  /// `login` defines its own `--api-key`, so the shared session overrides are
  /// not registered here; signing in is what this command is for.
  @override
  bool get acceptsAuthToken => false;

  @override
  String get name => 'login';

  @override
  String get description => 'Sign in and store the session token.';

  @override
  Future<int> run() async {
    final apiKey = (argResults?['api-key'] as String?)?.trim();
    if (apiKey != null && apiKey.isNotEmpty) return _storeApiKey(apiKey);

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

  /// Stores a key handed in on the command line.
  ///
  /// The key is checked against the server before it is written, so a typo is
  /// caught here rather than halfway through a script. `workspace.bootstrap`
  /// is used because every authenticated caller may read it, and a successful
  /// answer proves the key is live rather than revoked.
  Future<int> _storeApiKey(String apiKey) async {
    if (!apiKey.startsWith('fs_live_')) {
      throw CliException.usage(
        'That does not look like a FauxShield API key; keys start with '
        '`fs_live_`.',
      );
    }
    final url = resolvedUrl;

    final client = Client(url);
    client.authKeyProvider = BearerTokenProvider(apiKey);
    try {
      await client.workspace.bootstrap();
    } catch (error) {
      throw CliException(
        'The server rejected that key: ${describeError(error)}',
      );
    }

    CliConfig(url: url, apiKey: apiKey).save();

    if (jsonOutput) {
      printJson(<String, dynamic>{
        'url': url,
        'credential': 'apiKey',
        'apiKeyPrefix': maskSecret(apiKey),
      });
      return 0;
    }
    stdout.writeln('Stored API key ${maskSecret(apiKey)} for $url.');
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

/// Shows which workspace the credential resolves to.
class AuthWhoamiCommand extends CliCommand {
  @override
  String get name => 'whoami';

  @override
  String get description =>
      'Show the account, workspace, and role for the active credential.';

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
      if (!context.isApiKey) {
        throw CliException(
          'That token is not a member of any workspace. Create one in the '
          'operator app, or join the demo workspace.',
        );
      }
      // A key is not a person, so there is no workspace membership to report:
      // it carries scopes and acts on the workspace it was created in. The
      // bootstrap call above still proved the key is live and accepted.
      if (context.json) {
        printJson(<String, dynamic>{
          'url': context.url,
          'credential': 'apiKey',
          'apiKeyPrefix': context.apiKeyPrefix,
        });
        return 0;
      }
      stdout.writeln('Server:      ${context.url}');
      stdout.writeln('Credential:  API key ${context.apiKeyPrefix}');
      stdout.writeln('Workspace:   created in one workspace, set by the key');
      stdout.writeln(
        'Scopes:      run `fauxshield keys list` to see them',
      );
      return 0;
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
    stdout.writeln(
      'Credential: ${context.isApiKey ? 'API key ${context.apiKeyPrefix}' : 'session token'}',
    );
    stdout.writeln('Workspace:  ${bootstrap.workspace.name}');
    stdout.writeln('Slug:       ${bootstrap.workspace.slug}');
    stdout.writeln('Role:       ${bootstrap.role.name}');
    stdout.writeln('Demo:       ${yesNo(bootstrap.isDemo)}');
    stdout.writeln('Permissions: ${bootstrap.permissions.length}');
    return 0;
  }
}

/// Prints the active credential, so it can be piped into other tools.
class AuthTokenCommand extends CliCommand {
  @override
  String get name => 'token';

  @override
  String get description => 'Print the active session token or API key.';

  @override
  Future<int> run() async {
    final token = resolvedCredential;
    if (token == null) {
      throw CliException(
        'No credential available. Run `fauxshield auth login`.',
      );
    }
    if (jsonOutput) {
      printJson(<String, dynamic>{
        'url': resolvedUrl,
        'credential': resolvedApiKey != null ? 'apiKey' : 'token',
        'token': token,
      });
    } else {
      stdout.writeln(token);
    }
    return 0;
  }
}
