import 'package:serverpod/serverpod.dart';

import 'site_chrome.dart';

/// The `/pricing` page.
///
/// This project has no billing system, so the page describes the deployment
/// options that actually exist rather than inventing a hosted price list. Every
/// module ships in the single MIT licensed codebase.
class PricingPageWidget extends TemplateWidget {
  PricingPageWidget() : super(name: 'pricing');

  factory PricingPageWidget.build() {
    return PricingPageWidget()
      ..values.addAll(
        SiteChrome.pageValues(
          title: 'Pricing — FauxShield',
          description:
              'Self-host the whole platform for free under the MIT licence, or '
              'deploy it to Serverpod Cloud in one command.',
          active: 'pricing',
        ),
      )
      ..values.addAll(<String, dynamic>{
        'includedCards': _includedCards(),
        'faqCards': _faqCards(),
      });
  }

  static String _includedCards() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'package',
        title: 'Serialization',
        body:
            'Products, batches, identity generation, PIN handling, exports, '
            'and idempotent retries.',
      ),
      CardSpec(
        iconName: 'shield-check',
        title: 'Consumer verification',
        body:
            'Token resolution, replay protection, PIN submission, lockout, '
            'recalls, and consumer reports.',
      ),
      CardSpec(
        iconName: 'radar',
        title: 'Fraud engine',
        body:
            'All eight signals, per workspace policy, alerts with evidence, '
            'and the simulation suite.',
      ),
      CardSpec(
        iconName: 'users',
        title: 'Administration',
        body:
            'Roles, permissions, invitations, API keys, audit log, '
            'notifications, and analytics.',
      ),
    ],
  );

  static String _faqCards() => SiteChrome.cardGrid(
    const <CardSpec>[
      CardSpec(
        iconName: 'terminal',
        title: 'Do I need Serverpod Cloud?',
        body:
            'No. The server runs anywhere Dart runs, and development uses '
            "Serverpod's embedded PostgreSQL, so there is no container or "
            'database to install first.',
      ),
      CardSpec(
        iconName: 'lock',
        title: 'Who holds the keys?',
        body:
            'You do. The HMAC signing key, PIN encryption key, and webhook '
            'encryption key live in your configuration, and the server refuses '
            'to start without them.',
      ),
      CardSpec(
        iconName: 'database',
        title: 'What about the data?',
        body:
            'Everything is plain PostgreSQL owned by your deployment. Models '
            'are versioned as migrations you can read, review, and apply.',
      ),
      CardSpec(
        iconName: 'rocket',
        title: 'Is there a demo I can try?',
        body:
            'Yes. Sign in to the operator app and open the demo workspace. It '
            'seeds a brand with products, units, verifications, alerts, and a '
            'recall.',
      ),
    ],
  );
}
