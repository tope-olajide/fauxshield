import 'package:serverpod/serverpod.dart';

import 'site_chrome.dart';

/// The `/docs` page: practical documentation for this build.
///
/// Every command and endpoint shown here is taken from the working
/// implementation.
class DocsPageWidget extends TemplateWidget {
  DocsPageWidget() : super(name: 'docs');

  factory DocsPageWidget.build() {
    return DocsPageWidget()
      ..values.addAll(
        SiteChrome.pageValues(
          title: 'Documentation — FauxShield',
          description:
              'Run the stack locally, understand the core concepts, and call '
              'the API, webhooks, and offline sync paths.',
          active: 'docs',
        ),
      )
      ..values.addAll(<String, dynamic>{
        'startCode': SiteChrome.codeBlock(_startCommands),
        'dartCode': SiteChrome.codeBlock(_dartSample),
        'curlAuthCode': SiteChrome.codeBlock(_curlAuth),
        'curlBatchCode': SiteChrome.codeBlock(_curlBatch),
        'curlVerifyCode': SiteChrome.codeBlock(_curlVerify),
        'webhookCode': SiteChrome.codeBlock(_webhookSample),
        'cliCode': SiteChrome.codeBlock(_cliCommands),
        'opsCode': SiteChrome.codeBlock(_opsCommands),
      });
  }

  static const String _startCommands = '''
# 1. Start the server (embedded PostgreSQL, no Docker needed)
cd fauxshield_server
dart pub get
dart run bin/main.dart --mode development --apply-migrations

# 2. Open the operator app
#    http://localhost:8082/app   (prebuilt, served by the server)
#    Or with hot reload:
cd fauxshield_flutter && flutter run -d chrome

# 3. Open the consumer flow
#    http://localhost:8082/      landing page, live stats and demo code
#    http://localhost:8082/verify
''';

  static const String _dartSample = '''
import 'package:fauxshield_client/fauxshield_client.dart';

final client = Client('http://localhost:8080');

// Create a product
final product = await client.product.create(
  name: 'Aurelia Extra Virgin Olive Oil 1L',
  sku: 'AUR-OIL-1L',
  category: 'food',
);

// Create a batch. distributionRegion drives distributor leakage detection.
final batch = await client.batch.create(
  productId: product.id!,
  reference: 'LOT-2026-04',
  manufactureDate: DateTime.now(),
  distributionRegion: 'NG',
  quantity: 500,
);

// Mint 500 units: signed QR token plus packaging PIN per unit
final generated = await client.batch.generateIdentities(
  batchId: batch.id!,
  quantity: 500,
  idempotencyKey: 'lot-2026-04-500',
);

// Per batch statistics for the dashboard
final stats = await client.batch.stats(batch.id!);''';

  static const String _curlAuth = '''
# Register a user. In development the verification code is written to the
# server log, so you do not need an email provider to test locally.
curl -s -X POST http://localhost:8080/emailIdp/startRegistration \\
  -H 'Content-Type: application/json' \\
  -d '{"email":"you@brand.test"}'

curl -s -X POST http://localhost:8080/emailIdp/verifyRegistrationCode \\
  -H 'Content-Type: application/json' \\
  -d '{"accountRequestId":"<uuid>","verificationCode":"<code from log>"}'

# Exchange the registration token for a JWT session
curl -s -X POST http://localhost:8080/emailIdp/finishRegistration \\
  -H 'Content-Type: application/json' \\
  -d '{"registrationToken":"<token>","password":"your-password"}''';

  static const String _curlBatch = '''
# Endpoints follow /<endpoint>/<method>, with the arguments as the JSON body.
# Authenticated calls carry the JWT as a bearer token.
curl -s -X POST http://localhost:8080/batch/generateIdentities \\
  -H 'Content-Type: application/json' \\
  -H "Authorization: Bearer \$TOKEN" \\
  -d '{"batchId":"<uuid>","quantity":500,
       "idempotencyKey":"lot-2026-04-500"}'

# Read the fraud queue
curl -s -X POST http://localhost:8080/alert/list \\
  -H 'Content-Type: application/json' \\
  -H "Authorization: Bearer \$TOKEN" \\
  -d '{"page":1,"pageSize":20}'

# Dashboard summary for the workspace
curl -s -X POST http://localhost:8080/analytics/dashboard \\
  -H 'Content-Type: application/json' \\
  -H "Authorization: Bearer \$TOKEN" \\
  -d '{}' ''';

  static const String _curlVerify = '''
# Public, unauthenticated. The consumer flow runs in two calls.

# 1. Resolve a scanned token
curl -s -X POST http://localhost:8080/verification/start \\
  -H 'Content-Type: application/json' \\
  -d '{"token":"3f7c1a9e64b25d80a1b2c3d4e5f60718",
       "deviceFingerprint":"browser-abc123"}'

# 2. Submit the packaging PIN for the returned session
curl -s -X POST http://localhost:8080/verification/submitPin \\
  -H 'Content-Type: application/json' \\
  -d '{"sessionId":"<uuid>","deviceFingerprint":"browser-abc123",
       "pin":"666499"}'

# Possible outcomes: authentic, alreadyVerified, invalidPin,
# highRisk, fraudSuspected, recalled.''';

  static const String _webhookSample = '''
# Deliveries are signed. The signature is a timestamp and an HMAC over
# "<timestamp>.<body>", so a captured payload cannot be replayed later.
POST /your/endpoint HTTP/1.1
Content-Type: application/json
X-FauxShield-Signature: t=1791296579,v1=6f3c...9ad2
X-FauxShield-Event: fraudAlertCreated

{
  "event": "fraudAlertCreated",
  "deliveryId": "9c1f2a44-...",
  "data": { "alertId": "1f5dcbb1-...", "severity": "critical" }
}

# Verify by recomputing the HMAC over "<t>.<raw body>" with the endpoint
# secret, then comparing in constant time. Deliveries retry with backoff and
# endpoints on private or loopback addresses are rejected before sending.''';

  static const String _cliCommands = '''
# The CLI is a plain Dart console package that speaks the same JSON-RPC API as
# the operator app, so it needs no Flutter runtime. Install it, then sign in.
dart pub global activate --source path fauxshield_cli
fauxshield auth login --email you@brand.test --password '<your password>'

# Every command is scoped to the workspace behind that token
fauxshield auth whoami
fauxshield products list
fauxshield batches list --product <uuid>

# Create a product and a batch to manufacture
fauxshield products create --name 'Aurelia Olive Oil 1L' --sku AUR-OIL-1L
fauxshield batches create --product <uuid> --reference LOT-2026-04 \\
  --region NG --quantity 500

# Mint the signed units, then check the batch
fauxshield identities generate --batch <uuid> --quantity 500
fauxshield batches stats --batch <uuid>

# Work the fraud queue, with the evidence behind each alert
fauxshield alerts list --severity critical
fauxshield alerts show --alert <uuid>

# Reproduce a consumer scan without a browser: resolve the token, then PIN
fauxshield verify --token <token> --pin <pin>

# Every command takes --json, and the URL or token can come from the
# environment instead of the config file
fauxshield alerts list --json
FAUXSHIELD_URL=http://localhost:8080 FAUXSHIELD_TOKEN=\$TOKEN \\
  fauxshield products list''';

  static const String _opsCommands = '''
# Regenerate server and client code after editing a .spy.yaml model
serverpod generate

# Create and apply a migration
serverpod create-migration
dart run bin/main.dart --mode development --apply-migrations

# Tests: crypto, verification, fraud, recall, and the demo seeder
cd fauxshield_server && dart test

# Static analysis exactly as CI runs it
dart analyze --fatal-infos

# Deploy to Serverpod Cloud (Postgres, migrations, URLs, storage)
cd fauxshield_server && serverpod cloud launch''';
}
