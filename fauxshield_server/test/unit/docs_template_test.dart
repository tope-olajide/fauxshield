import 'dart:io';

import 'package:fauxshield_server/src/web/docs/docs_site.dart';
import 'package:fauxshield_server/src/web/routes/docs_routes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

/// Rendering every page through the real template is the closest thing to
/// loading it in a browser that a unit test can do: a missing value shows up as
/// an unresolved `{{placeholder}}`, and a template that stops using a value
/// shows up here too. The search, the copy buttons, and the sidebar toggle are
/// the script's job; what this checks is the HTML the server sends.
void main() {
  final route = DocsRoute();

  // The server loads its templates at start-up; a test does the same, so the
  // pages are rendered from the files that ship, not from a copy.
  setUpAll(() async {
    await templates.loadAll(Directory('web/templates'));
  });

  /// Renders a page the way a request does.
  ///
  /// The server resolves `{{{@/path}}}` cache-busting values before rendering;
  /// here the `@` is stripped, which is what a reader would see in the URL. A
  /// value the template asks for that nobody set is left visible as
  /// `{{name}}`, so a typo fails the test instead of quietly rendering blank.
  String renderPage(TemplateWidget widget) => widget.render(
    onMissingVariable: (name) =>
        name.startsWith('@') ? name.substring(1) : '{{$name}}',
  );

  group('Given the docs page template', () {
    test('every page renders with no unresolved placeholders', () {
      for (final page in docsSite.pages) {
        final html = renderPage(route.pageWidget(page));

        expect(
          html.contains('{{'),
          isFalse,
          reason: '${page.path} has an unresolved placeholder',
        );
        expect(html, contains('<title>${page.title}'), reason: page.path);
        expect(
          html,
          contains(page.description),
          reason: '${page.path} does not carry its description',
        );
      }
    });

    test(
      'a page brings its sidebar, breadcrumbs, table of contents, and pager',
      () {
        // A reference page: long enough to have a table of contents, and late
        // enough in the reading order to have both a previous and a next link.
        final page = docsSite.pageAt('api/models')!;
        final html = renderPage(route.pageWidget(page));

        expect(html, contains('docs-sidebar'));
        expect(html, contains('docs-breadcrumbs'));
        expect(html, contains('docs-toc'));
        expect(html, contains('docs-pager'));
        expect(html, contains('href="/docs/api"'));
        expect(html, contains('id="docs-search-input"'));
        expect(html, contains('/web/js/docs.js'));
        expect(html, contains('/web/css/docs.css'));
      },
    );

    test('the sidebar marks the current page for assistive technology', () {
      final page = docsSite.pageAt('quickstart')!;
      final html = renderPage(route.pageWidget(page));

      // The sidebar link, and the breadcrumb's trailing crumb, are both marked
      // as the current page — which is what a screen reader needs in each.
      final marker = RegExp(
        r'<a href="/docs/quickstart"[^>]*aria-current="page"',
      );
      expect(marker.hasMatch(html), isTrue);
      expect(RegExp('aria-current="page"').allMatches(html).length, 2);
    });

    test('the group the page belongs to is open in the sidebar', () {
      final page = docsSite.pageAt('cli')!;
      final html = renderPage(route.pageWidget(page));

      final cliGroup = RegExp(
        r'<details class="docs-group" open>\s*<summary>CLI</summary>',
      );
      expect(cliGroup.hasMatch(html), isTrue);
    });

    test('the not-found page asks crawlers to stay away', () {
      final html = renderPage(
        route.pageWidget(notFoundPage(docsSite, 'nope'), noindex: true),
      );

      expect(html, contains('name="robots" content="noindex"'));
      expect(html, contains('That page does not exist'));
    });
  });

  group('Given the docs route', () {
    test('a path maps to the slug of a page', () {
      expect(DocsRoute.slugOf('/docs'), '');
      expect(DocsRoute.slugOf('/docs/'), '');
      expect(DocsRoute.slugOf('/docs/quickstart'), 'quickstart');
      expect(DocsRoute.slugOf('/docs/api/product'), 'api/product');
      expect(DocsRoute.slugOf('/docs/api/product/'), 'api/product');
    });

    test('every page in the site is reachable at its own path', () {
      for (final page in docsSite.pages) {
        expect(
          docsSite.pageAt(DocsRoute.slugOf(page.path)),
          isNotNull,
          reason: '${page.path} does not resolve to a page',
        );
      }
    });
  });
}
