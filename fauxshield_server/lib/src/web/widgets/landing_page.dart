import 'package:serverpod/serverpod.dart';

import 'site_chrome.dart';

/// The FauxShield public landing page.
///
/// Structure and visual language follow the reference site (hero, crisis,
/// solution, how it works, features, fraud intelligence, offline, developer
/// platform, use cases, security, closing call to action). The copy describes
/// what this build actually does, and the counters are read from the live
/// database on every request.
class LandingPageWidget extends TemplateWidget {
  LandingPageWidget() : super(name: 'landing');

  factory LandingPageWidget.withStats({
    required int workspaces,
    required int products,
    required int identities,
    required int verifications,
    required int alerts,
  }) {
    return LandingPageWidget()
      ..values.addAll(
        SiteChrome.pageValues(
          title: 'FauxShield — anti-counterfeit infrastructure for brands',
          description:
              'Serialized product identities, consumer verification, fraud '
              'intelligence, and recalls. Built on Serverpod 4 and Flutter.',
          active: 'home',
        ),
      )
      ..values.addAll(<String, dynamic>{
        'workspaces': workspaces,
        'products': products,
        'identities': identities,
        'verifications': verifications,
        'alerts': alerts,
        'crisisStats': _crisisStats(),
        'crisisImpact': _crisisImpact(),
        'shortfalls': _shortfalls(),
        'solutionFlow': _solutionFlow(),
        'featureCards': _featureCards(),
        'signalCards': _signalCards(),
        'useCaseCards': _useCaseCards(),
        'securityCards': _securityCards(),
        'developerShowcase': _developerShowcase(),
      });
  }

  factory LandingPageWidget.unavailable() {
    return LandingPageWidget.withStats(
      workspaces: 0,
      products: 0,
      identities: 0,
      verifications: 0,
      alerts: 0,
    );
  }

  /// Sourced industry estimates on the scale of counterfeiting.
  static String _crisisStats() => SiteChrome.statGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'globe',
        title: '40%',
        body:
            'of products in some African markets are counterfeit or '
            'substandard',
        tone: 'destructive',
      ),
      CardSpec(
        iconName: 'pill',
        title: '1 in 10',
        body:
            'medical products in low and middle income countries are '
            'substandard or falsified',
        tone: 'warning',
      ),
      CardSpec(
        iconName: 'package',
        title: '\$500B+',
        body: 'in annual global losses attributed to counterfeiting and piracy',
        tone: 'warning',
      ),
      CardSpec(
        iconName: 'sparkles',
        title: '30-60%',
        body: 'of seeds and pesticides in some regions are reported as fake',
        tone: 'destructive',
      ),
    ],
  );

  /// Who pays the price, and why building this from scratch is hard.
  static String _crisisImpact() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'package',
        title: 'For brands',
        body:
            'Lost revenue to grey market sellers, damaged reputation when '
            'fakes carry your name, and no unit level record to support a '
            'recall or an investigation.',
        tone: 'warning',
      ),
      CardSpec(
        iconName: 'users',
        title: 'For consumers',
        body:
            'No reliable way to tell a genuine product from a fake at the '
            'point of purchase, and no way to confirm a recall or report a '
            'suspicious item.',
        tone: 'destructive',
      ),
      CardSpec(
        iconName: 'terminal',
        title: 'For developers',
        body:
            'Cryptography, verification, fraud scoring, and analytics are '
            'expensive to build and maintain. Most teams end up shipping a '
            'static QR code and calling it done.',
        tone: 'primary',
      ),
    ],
  );

  /// Why the obvious countermeasures are not enough.
  static String _shortfalls() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'smartphone',
        title: 'SMS verification',
        body:
            'Expensive at scale: millions of products multiplied by millions '
            'of messages, plus friction for the consumer.',
        tone: 'destructive',
      ),
      CardSpec(
        iconName: 'qr-code',
        title: 'Static QR codes',
        body:
            'Trivially duplicated. A counterfeiter copies the printed code '
            'onto fake packaging and it resolves exactly the same.',
        tone: 'destructive',
      ),
      CardSpec(
        iconName: 'sparkles',
        title: 'Holograms',
        body:
            'Costly to produce, need special materials, and a consumer still '
            'has no reliable way to inspect one.',
        tone: 'destructive',
      ),
      CardSpec(
        iconName: 'truck',
        title: 'Proprietary hardware',
        body:
            'NFC tags and dedicated scanners price out most manufacturers '
            'and add a device to every inspection.',
        tone: 'destructive',
      ),
    ],
    columns: 4,
  );

  static String _solutionFlow() => SiteChrome.flow(
    const <(String, String)>[
      ('package', 'Products'),
      ('layers', 'Batches'),
      ('fingerprint', 'Identities'),
      ('qr-code', 'QR + PIN'),
      ('shield-check', 'Verification'),
      ('radar', 'Fraud intel'),
      ('alert-triangle', 'Recalls'),
      ('webhook', 'Webhooks'),
    ],
  );

  static String _featureCards() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'qr-code',
        title: 'Signed identities',
        body:
            'Every unit gets a 128 bit QR token, an HMAC signature over its '
            'workspace, product and identity, and a six digit packaging PIN.',
      ),
      CardSpec(
        iconName: 'repeat',
        title: 'Replay protection',
        body:
            'The first scan of a token wins. Later scans are reported as '
            'already verified with the original time and place.',
      ),
      CardSpec(
        iconName: 'radar',
        title: 'Real time fraud engine',
        body:
            'Eight independent signals scored against a per workspace '
            'policy, inside a bounded evaluation budget.',
      ),
      CardSpec(
        iconName: 'bell',
        title: 'Alerts with evidence',
        body:
            'Escalations open an alert that carries the contributing '
            'signals, reasons, and the scan that triggered them.',
      ),
      CardSpec(
        iconName: 'alert-triangle',
        title: 'Recalls',
        body:
            'Recall a whole batch or a single unit. Verification outcomes '
            'flip immediately, and lifting the recall restores them.',
      ),
      CardSpec(
        iconName: 'wifi-off',
        title: 'Offline first inspectors',
        body:
            'Field scans queue on the device and sync through Serverpod. '
            'Verdicts are converted and pushed back automatically.',
      ),
      CardSpec(
        iconName: 'zap',
        title: 'Attack rehearsals',
        body:
            'Run clone, brute force, scan burst, and grey market simulations '
            'through the real pipeline and watch the response unfold.',
      ),
      CardSpec(
        iconName: 'webhook',
        title: 'Signed webhooks',
        body:
            'Endpoint deliveries are signed, retried with backoff, and '
            'validated against private and loopback ranges before sending.',
      ),
      CardSpec(
        iconName: 'lock',
        title: 'Team, keys, and audit',
        body:
            'Four roles across 22 permissions, scoped API keys with '
            'idempotency, and an audit trail on every privileged action.',
      ),
    ],
  );

  /// The eight signals the engine actually evaluates.
  static String _signalCards() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'fingerprint',
        title: 'Clone detection',
        body:
            'One token resolved from two locations that are too far apart to '
            'be the same physical unit.',
        tone: 'destructive',
      ),
      CardSpec(
        iconName: 'activity',
        title: 'Velocity anomaly',
        body:
            'More scans of one unit inside the policy window than a genuine '
            'packaging code should ever see.',
        tone: 'warning',
      ),
      CardSpec(
        iconName: 'key',
        title: 'PIN attack',
        body:
            'Repeated wrong PINs on a single unit past the configured '
            'threshold, the signature of a guessing attempt.',
        tone: 'warning',
      ),
      CardSpec(
        iconName: 'layers',
        title: 'Batch duplication',
        body:
            'Several units in the same batch already carry signals, which '
            'points at the print or packing step rather than one unit.',
        tone: 'destructive',
      ),
      CardSpec(
        iconName: 'truck',
        title: 'Distributor leakage',
        body:
            'A unit verified outside the distribution region declared on its '
            'batch.',
        tone: 'warning',
      ),
      CardSpec(
        iconName: 'map-pin',
        title: 'Grey market',
        body:
            'A scan in a country the brand has explicitly restricted, from '
            'the workspace restricted markets list.',
        tone: 'destructive',
      ),
      CardSpec(
        iconName: 'wifi-off',
        title: 'Offline backfill',
        body:
            'A field inspection synced after the fact, reconciled against '
            'the authoritative record when it lands.',
        tone: 'primary',
      ),
      CardSpec(
        iconName: 'timer',
        title: 'PIN lockout',
        body:
            'A unit temporarily locked after too many failed attempts, so '
            'brute forcing stops costing nothing.',
        tone: 'warning',
      ),
    ],
  );

  static String _useCaseCards() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'pill',
        title: 'Medicines and health',
        body:
            'Batch level recall and per unit verification where a fake dose '
            'is a safety event, not a lost sale.',
      ),
      CardSpec(
        iconName: 'sparkles',
        title: 'Seeds and agrochemicals',
        body:
            'Protect a growing season by proving the input a farmer bought '
            'came from the manufacturer.',
      ),
      CardSpec(
        iconName: 'package',
        title: 'Food and beverage',
        body:
            'Authenticity, expiry, and lot traceability on the same label a '
            'shopper already scans.',
      ),
      CardSpec(
        iconName: 'globe',
        title: 'Cosmetics and personal care',
        body:
            'Catch restricted market leakage and dangerous reformulations '
            'before they reach a shelf.',
      ),
      CardSpec(
        iconName: 'server',
        title: 'Electronics and parts',
        body:
            'Serial level identity for components where a counterfeit part '
            'is a warranty and fire risk.',
      ),
      CardSpec(
        iconName: 'truck',
        title: 'Auto and industrial spares',
        body:
            'Distributor level visibility so grey market stock is visible '
            'before it becomes a support problem.',
      ),
    ],
  );

  /// Security properties that exist in the implementation.
  static String _securityCards() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'shield-check',
        title: 'HMAC signed tokens',
        body:
            'QR tokens are bound to their workspace, product, and identity, '
            'so a copied code cannot be re-pointed at another product.',
      ),
      CardSpec(
        iconName: 'lock',
        title: 'PBKDF2 hashed PINs',
        body:
            'PINs are stored only as salted PBKDF2 hashes. The plaintext is '
            'recoverable only through an audited, permission gated reveal.',
      ),
      CardSpec(
        iconName: 'key',
        title: 'AES-256-GCM at rest',
        body:
            'Recoverable PIN material is encrypted with AES-GCM bound to '
            'additional authenticated data.',
      ),
      CardSpec(
        iconName: 'database',
        title: 'Row locked writes',
        body:
            'PIN submission and identity generation run in row locked '
            'transactions, so concurrent scans cannot double count.',
      ),
      CardSpec(
        iconName: 'users',
        title: 'Role based access',
        body:
            'Owner, admin, member, and viewer roles across 22 permissions, '
            'resolved server side from membership, never from the client.',
      ),
      CardSpec(
        iconName: 'file-text',
        title: 'Audit trail',
        body:
            'Every privileged action and every risk assessment is written to '
            'an append only audit log with the acting identity.',
      ),
    ],
  );

  /// Real, working entry points into the platform.
  static String _developerShowcase() => SiteChrome.codeShowcase(
    name: 'dev-sample',
    samples: const <CodeSample>[
      CodeSample(
        label: 'Dart',
        install: 'dart pub add fauxshield_client',
        code: '''
import 'package:fauxshield_client/fauxshield_client.dart';

// The hosted deployment. Point it at http://localhost:8080 to use your own.
final client = Client('https://fauxshield.api.serverpod.space');

// Create a product and a manufacturing batch
final product = await client.product.create(
  name: 'Aurelia Extra Virgin Olive Oil 1L',
  sku: 'AUR-OIL-1L',
  category: 'food',
);

final batch = await client.batch.create(
  productId: product.id!,
  reference: 'LOT-2026-04',
  manufactureDate: DateTime.now(),
  distributionRegion: 'NG',
  quantity: 500,
);

// Serialize 500 units: signed QR token plus packaging PIN
final generated = await client.batch.generateIdentities(
  batchId: batch.id!,
  quantity: 500,
  idempotencyKey: 'lot-2026-04-500',
);

// Watch verifications, alerts and offline sync arrive live
client.verification
    .watchWorkspace(workspaceId: generated.workspaceId)
    .listen((event) => print(event.type));

// Review what the fraud engine found
final alerts = await client.alert.list(page: 1, pageSize: 20);''',
      ),
      CodeSample(
        label: 'cURL',
        install: 'curl',
        code: '''
# The hosted deployment; swap in http://localhost:8080 for your own server.

# Sign in and capture the JWT from the auth strategy
curl -s -X POST https://fauxshield.api.serverpod.space/emailIdp/login \\
  -H 'Content-Type: application/json' \\
  -d '{"email":"you@brand.test","password":"your-password"}'

# Serialize 500 units for a batch
curl -s -X POST https://fauxshield.api.serverpod.space/batch/generateIdentities \\
  -H 'Content-Type: application/json' \\
  -H "Authorization: Bearer \$TOKEN" \\
  -d '{"batchId":"<uuid>","quantity":500,
       "idempotencyKey":"lot-2026-04-500"}'

# What a consumer scan does: resolve the token, then submit the PIN
curl -s -X POST https://fauxshield.api.serverpod.space/verification/start \\
  -H 'Content-Type: application/json' \\
  -d '{"token":"3f7c1a9e64b25d80...","deviceFingerprint":"pos-1"}'

curl -s -X POST https://fauxshield.api.serverpod.space/verification/submitPin \\
  -H 'Content-Type: application/json' \\
  -d '{"sessionId":"<uuid>","deviceFingerprint":"pos-1","pin":"666499"}' ''',
      ),
      CodeSample(
        label: 'fauxshield CLI',
        install: 'dart pub global activate fauxshield_cli',
        code: '''
# Sign in once. The token is kept in ~/.fauxshield/config.json
fauxshield auth login --email you@brand.test --password '<your password>'

# Create a product, then a batch to manufacture
fauxshield products create --name 'Aurelia Olive Oil 1L' --sku AUR-OIL-1L
fauxshield batches create --product <uuid> --reference LOT-2026-04 \\
  --region NG --quantity 500

# Mint the signed units, then check the batch
fauxshield identities generate --batch <uuid> --quantity 500
fauxshield batches stats --batch <uuid>

# Work the fraud queue from a terminal
fauxshield alerts show --alert <uuid>

# Reproduce a consumer scan, exactly as the web page does
fauxshield verify --token <token> --pin <pin>''',
      ),
      CodeSample(
        label: 'fauxshield MCP',
        install: 'dart pub global activate fauxshield_mcp',
        code: '''
{
  "mcpServers": {
    "fauxshield": {
      "command": "fauxshield-mcp",
      "env": {
        "FAUXSHIELD_URL": "https://fauxshield.api.serverpod.space",
        "FAUXSHIELD_API_KEY": "fs_live_...",
        "FAUXSHIELD_READ_ONLY": "true"
      }
    }
  }
}

# 55 tools over the same API: read the fraud queue and the audit log,
# pull an alert's evidence, lock a unit, or recall a batch.''',
      ),
    ],
  );
}
