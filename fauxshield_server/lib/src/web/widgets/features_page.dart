import 'package:serverpod/serverpod.dart';

import 'site_chrome.dart';

/// The `/features` marketing page.
///
/// Every card here maps to a module that exists in this build.
class FeaturesPageWidget extends TemplateWidget {
  FeaturesPageWidget() : super(name: 'features');

  factory FeaturesPageWidget.build() {
    return FeaturesPageWidget()
      ..values.addAll(
        SiteChrome.pageValues(
          title: 'Features — FauxShield',
          description:
              'Serialized identities, consumer verification, fraud scoring, '
              'recalls, offline field work, and platform administration.',
          active: 'features',
        ),
      )
      ..values.addAll(<String, dynamic>{
        'identityCards': _identityCards(),
        'fraudCards': _fraudCards(),
        'responseCards': _responseCards(),
        'fieldCards': _fieldCards(),
        'adminCards': _adminCards(),
        'apiFlow': SiteChrome.flow(
          const <(String, String)>[
            ('fingerprint', 'Token'),
            ('qr-code', 'Scan'),
            ('shield-check', 'Verdict'),
            ('radar', 'Score'),
            ('bell', 'Alert'),
            ('webhook', 'Notify'),
          ],
        ),
      });
  }

  static String _identityCards() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'package',
        title: 'Product catalogue',
        body:
            'Products carry SKU, category, packaging notes, shelf life, '
            'country restrictions, and safety instructions that surface on the '
            'consumer page.',
      ),
      CardSpec(
        iconName: 'layers',
        title: 'Batches with regions',
        body:
            'Each batch declares a reference, manufacture and expiry dates, a '
            'distribution region, and a quantity. The region is what makes '
            'distributor leakage detectable later.',
      ),
      CardSpec(
        iconName: 'fingerprint',
        title: 'Per unit identity',
        body:
            'Minting a batch produces a 128 bit QR token and a six digit PIN '
            'per unit, with an HMAC signature binding the token to its '
            'workspace, product, and identity.',
      ),
      CardSpec(
        iconName: 'key',
        title: 'PIN storage',
        body:
            'PINs are kept as salted PBKDF2 hashes plus an AES-256-GCM '
            'ciphertext bound to additional authenticated data, so a reveal is '
            'possible but always audited.',
      ),
      CardSpec(
        iconName: 'repeat',
        title: 'Idempotent generation',
        body:
            'Generation takes an idempotency key, so a retried request '
            'returns the original result instead of minting a second set of '
            'codes.',
      ),
      CardSpec(
        iconName: 'file-text',
        title: 'Export for print',
        body:
            'Export a batch as CSV or TSV for the print line, without ever '
            'leaking PIN material into the file.',
      ),
    ],
  );

  static String _fraudCards() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'radar',
        title: 'Signal evaluation',
        body:
            'Eight checks run per scan inside a configurable time budget, so '
            'a slow geo lookup can never hold a consumer at the scanner.',
      ),
      CardSpec(
        iconName: 'activity',
        title: 'Configurable policy',
        body:
            'Velocity window and threshold, PIN attack threshold, batch '
            'duplication threshold, clone window, impossible travel distance, '
            'auto lock, and alert-on-high are all per workspace.',
      ),
      CardSpec(
        iconName: 'bell',
        title: 'Escalation rules',
        body:
            'A lone high signal stays high. A high signal combined with any '
            'other escalates to fraud suspected, which is what auto locking and '
            'critical alerts key off.',
      ),
      CardSpec(
        iconName: 'shield-alert',
        title: 'Alert evidence',
        body:
            'Each alert stores the contributing signals, their reasons, the '
            'scan, and the batch, so an investigator sees why it fired rather '
            'than that it fired.',
      ),
      CardSpec(
        iconName: 'map-pin',
        title: 'Coarse geolocation',
        body:
            'Location comes from IP, resolved through a pluggable provider '
            'with a deterministic dataset for local work and tests. No browser '
            'GPS and no precise coordinates are stored.',
      ),
      CardSpec(
        iconName: 'zap',
        title: 'Attack simulations',
        body:
            'Clone attack, PIN brute force, scan burst, and grey market leak '
            'drive the real pipeline so you can rehearse the response before '
            'you need it.',
      ),
    ],
  );

  static String _responseCards() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'alert-triangle',
        title: 'Recalls',
        body:
            'Recall a batch or a single unit with a reason. Verification '
            'outcomes flip to recalled immediately, and lifting the recall '
            'restores the previous behaviour.',
      ),
      CardSpec(
        iconName: 'key',
        title: 'Countermeasures',
        body:
            'Lock a suspect unit, unlock it, regenerate a compromised token, '
            'or soft delete and restore an identity without losing its '
            'history.',
      ),
      CardSpec(
        iconName: 'bell',
        title: 'Triage workflow',
        body:
            'Alerts carry status, severity, and assignee. Operators can take '
            'ownership, update status, and attach notes as an investigation '
            'progresses.',
      ),
      CardSpec(
        iconName: 'users',
        title: 'Consumer reports',
        body:
            'A consumer can report a suspected fake from the verification '
            'page. Reports land in a triage queue and can be promoted into the '
            'alert stream.',
      ),
      CardSpec(
        iconName: 'webhook',
        title: 'Outbound webhooks',
        body:
            'Subscribe an HTTPS endpoint to verification, alert, batch, '
            'identity, and recall events, with signed payloads and retry '
            'backoff.',
      ),
      CardSpec(
        iconName: 'file-text',
        title: 'Notifications',
        body:
            'In-app notifications and per-user channel preferences keep an '
            'operator informed after the first alert lands.',
      ),
    ],
  );

  static String _fieldCards() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'wifi-off',
        title: 'Offline scanning',
        body:
            'Inspectors keep scanning without a connection. Each scan is '
            'stored device side with a local id, device id, timestamp, and '
            'coarse location.',
      ),
      CardSpec(
        iconName: 'smartphone',
        title: 'Provisional verdicts',
        body:
            'The device issues its own provisional outcome immediately so the '
            'inspector is never blocked, then the server reconciles it.',
      ),
      CardSpec(
        iconName: 'repeat',
        title: 'Catalogue cache',
        body:
            'The inspector catalogue and cache entries let a device work from '
            'a known-good picture of the batches it is responsible for.',
      ),
      CardSpec(
        iconName: 'timer',
        title: 'Scheduled conversion',
        body:
            'A recurring job converts synced scans into authoritative '
            'verification sessions and pushes the final verdict back.',
      ),
      CardSpec(
        iconName: 'database',
        title: 'Database sync',
        body:
            'Queued scans and reports travel through Serverpod sync, so the '
            'same records exist on device and server without bespoke plumbing.',
      ),
      CardSpec(
        iconName: 'bar-chart',
        title: 'Field analytics',
        body:
            'Offline backfill is its own signal, so a late sync is visible as '
            'a pattern rather than silently counted as normal traffic.',
      ),
    ],
  );

  static String _adminCards() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'users',
        title: 'Roles and permissions',
        body:
            'Owner, admin, member, and viewer across 22 permissions, with '
            'permission checks resolved server side from the membership record '
            'on every call.',
      ),
      CardSpec(
        iconName: 'key',
        title: 'API keys',
        body:
            'Scoped keys for machine callers, shown once at creation and '
            'revocable, with idempotency records protecting retried writes.',
      ),
      CardSpec(
        iconName: 'file-text',
        title: 'Audit log',
        body:
            'Privileged actions, risk assessments, and state transitions are '
            'appended with actor type, actor id, and metadata.',
      ),
      CardSpec(
        iconName: 'bar-chart',
        title: 'Analytics',
        body:
            'Dashboard summaries, trend points, outcome breakdowns, and '
            'country statistics, materialised by a recurring rollup job.',
      ),
      CardSpec(
        iconName: 'globe',
        title: 'Workspace branding',
        body:
            'Display name, tagline, logo, and theme colour flow through to '
            'the consumer verification page a shopper actually sees.',
      ),
      CardSpec(
        iconName: 'rocket',
        title: 'Demo mode',
        body:
            'A disposable demo workspace with products, batches, verifications, '
            'alerts, a recall, and simulations already in it, resettable by '
            'secret.',
      ),
    ],
  );
}
