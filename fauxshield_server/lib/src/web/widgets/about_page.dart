import 'package:serverpod/serverpod.dart';

import 'site_chrome.dart';

/// The `/about` page: why the project exists and how it was built.
class AboutPageWidget extends TemplateWidget {
  AboutPageWidget() : super(name: 'about');

  factory AboutPageWidget.build() {
    return AboutPageWidget()
      ..values.addAll(
        SiteChrome.pageValues(
          title: 'About — FauxShield',
          description:
              'Why FauxShield exists, what it is built on, and how this '
              'implementation was produced for the Serverpod hackathon.',
          active: 'about',
        ),
      )
      ..values.addAll(<String, dynamic>{
        'principleCards': _principleCards(),
        'stackCards': _stackCards(),
        'serverpodCards': _serverpodCards(),
      });
  }

  static String _principleCards() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'fingerprint',
        title: 'Identity, not ink',
        body:
            'A printed code is only the entry point. The product is the '
            'identity behind it: signed, serialized, and tied to a batch and a '
            'workspace.',
      ),
      CardSpec(
        iconName: 'repeat',
        title: 'A copy should be visible',
        body:
            'If a code gets duplicated, the system should notice. Replay '
            'protection, impossible travel, and velocity checks exist so '
            'copying is a detectable event, not a free win.',
      ),
      CardSpec(
        iconName: 'shield-check',
        title: 'Answer the consumer fast',
        body:
            'A shopper standing in a shop gets a real verdict from a web '
            'page, no app install, and no account.',
      ),
      CardSpec(
        iconName: 'wifi-off',
        title: 'Work where the signal is not',
        body:
            'Field inspections happen in warehouses and rural depots. Offline '
            'capture with later reconciliation is a requirement, not a '
            'nice-to-have.',
      ),
    ],
  );

  static String _stackCards() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'server',
        title: 'Serverpod 4',
        body:
            'The API, the streaming channel, the background jobs, the '
            'database schema, the migrations, and the web pages all run in one '
            'Serverpod server.',
      ),
      CardSpec(
        iconName: 'smartphone',
        title: 'Flutter',
        body:
            'One operator app for web, desktop, and mobile: dashboard, live '
            'feed, alerts, catalogue, simulations, offline queue, and admin.',
      ),
      CardSpec(
        iconName: 'database',
        title: 'PostgreSQL',
        body:
            'Relational storage with row locked writes where correctness '
            'matters, and migrations checked into the repository.',
      ),
      CardSpec(
        iconName: 'code',
        title: 'Generated client',
        body:
            'Models are declared once in .spy.yaml. The server classes, the '
            'Dart client, and the schema are generated from those definitions.',
      ),
    ],
  );

  static String _serverpodCards() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'activity',
        title: 'Streaming',
        body:
            'The command center subscribes to a workspace event channel, so '
            'scans, alerts, and simulation progress arrive without polling.',
      ),
      CardSpec(
        iconName: 'timer',
        title: 'Future calls',
        body:
            'Webhook drain, offline conversion, daily analytics rollups, and '
            'maintenance sweeps are recurring Serverpod jobs.',
      ),
      CardSpec(
        iconName: 'webhook',
        title: 'Web server',
        body:
            'The landing page, the consumer flow, and this page are '
            'server rendered by Serverpod itself, not a separate front end.',
      ),
      CardSpec(
        iconName: 'lock',
        title: 'Auth and identity',
        body:
            'Email identity provider, JWT sessions, refresh tokens, and '
            'workspace membership resolved on every authenticated call.',
      ),
    ],
  );
}
