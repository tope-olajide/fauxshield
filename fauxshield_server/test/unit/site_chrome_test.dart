import 'dart:io';

import 'package:fauxshield_server/src/web/widgets/site_chrome.dart';
import 'package:test/test.dart';

/// Strips the whitespace a template literal carries, so assertions read the
/// rendered markup rather than the Dart source indentation.
String _flat(String html) => html.replaceAll(RegExp(r'\s+'), ' ');

void main() {
  group('Given the public site chrome', () {
    test('the header offers the dashboard, not a sign in pair', () {
      final nav = _flat(SiteChrome.nav(active: 'docs'));

      expect(nav, contains('href="/app"'));
      expect(nav, contains('Dashboard'));
      expect(nav, isNot(contains('Sign in')));
      expect(nav, isNot(contains('Sign up')));
      expect(nav, isNot(contains('Get started')));
    });

    test('the header still reaches the consumer verification page', () {
      final nav = _flat(SiteChrome.nav(active: 'features'));

      expect(nav, contains('href="/verify"'));
      expect(nav, contains('Verify a product'));
    });

    test('every public page gets the same header', () {
      for (final active in <String>['home', 'features', 'docs', 'pricing']) {
        final values = SiteChrome.pageValues(
          title: 'Title',
          description: 'Description',
          active: active,
        );
        final nav = _flat(values['siteNav'] as String);

        expect(nav, contains('Dashboard'), reason: active);
        expect(nav, contains('href="/app"'), reason: active);
      }
    });

    test(
      'every public page leads to the dashboard, not to an account form',
      () {
        // The page bodies carry their own calls to action in addition to the
        // header, so the header alone is not enough to check.
        for (final name in <String>[
          'landing',
          'features',
          'pricing',
          'about',
        ]) {
          final html = File('web/templates/$name.html').readAsStringSync();

          expect(html, contains('href="/app"'), reason: name);
          for (final wrong in <String>[
            'Sign in</a>',
            'Sign up</a>',
            'Get started</a>',
            'Create account',
            'Open the operator app',
          ]) {
            expect(
              html,
              isNot(contains(wrong)),
              reason: '$name offers "$wrong"',
            );
          }
        }
      },
    );

    test('the docs template takes its header from the shared chrome', () {
      final html = File('web/templates/docs_page.html').readAsStringSync();

      // The dashboard action arrives with the nav, so the docs cannot drift
      // into offering a different way in.
      expect(html, contains('{{{siteNav}}}'));
      expect(html, isNot(contains('href="/app"')));
    });

    test('the dashboard is what the landing page advertises', () {
      final html = File('web/templates/landing.html').readAsStringSync();

      expect(html, contains('Open the dashboard'));
      expect(html, contains('/docs')); // the secondary action stays the docs
    });

    test('the verification page never shows operator chrome', () {
      // The consumer page is a separate template with its own header; this
      // guards the exclusion rather than assuming it.
      final template = File('web/templates/verify.html').readAsStringSync();

      expect(template, isNot(contains('href="/app"')));
      expect(template, isNot(contains('Dashboard')));
    });
  });
}
