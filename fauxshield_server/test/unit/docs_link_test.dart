import 'package:fauxshield_server/src/web/docs/docs_model.dart';
import 'package:fauxshield_server/src/web/docs/docs_render.dart';
import 'package:fauxshield_server/src/web/docs/docs_site.dart';
import 'package:test/test.dart';

/// Internal links are the most common way documentation rots: a page is
/// renamed, the sidebar is updated, and a paragraph three pages away still
/// points at the old URL. Every link in the rendered HTML is checked here
/// against the pages and anchors that actually exist, so a rename that misses
/// one fails this test rather than a reader's click.
void main() {
  final site = docsSite;

  /// The anchor ids a page answers to: its sections, and the ids the renderer
  /// adds for its own structure.
  Set<String> anchorsOf(DocsPage page) => <String>{
    for (final section in page.sections) section.id,
    'docs-main',
  };

  /// Matches `href="/..."` in rendered HTML, ignoring external links.
  List<String> internalLinks(String html) => RegExp(
    r'href="(/[^"#?]*)(#[^"]*)?"',
  ).allMatches(html).map((match) => match.group(0)!).toList(growable: false);

  group('Given every page of the documentation', () {
    test('its internal links resolve to a page that exists', () {
      final problems = <String>[];

      for (final page in site.pages) {
        final rendered = render(site, page);
        final html = <String>[
          rendered.body,
          rendered.sidebar,
          rendered.pager,
          rendered.toc,
          rendered.breadcrumbs,
        ].join();

        for (final link in internalLinks(html)) {
          final target = link.replaceFirst('href="', '').replaceFirst('"', '');
          final path = target.split('#').first;
          if (!path.startsWith('/docs')) {
            continue; // the marketing pages are checked by their own tests
          }
          final slug = path.replaceFirst('/docs', '').replaceFirst('/', '');
          if (site.pageAt(slug) == null) {
            problems.add('${page.path} links to $target, which does not exist');
          }
        }
      }

      expect(problems, isEmpty, reason: problems.join('\n'));
    });

    test('its internal links resolve to an anchor that exists', () {
      final problems = <String>[];

      for (final page in site.pages) {
        final rendered = render(site, page);
        final html = <String>[
          rendered.body,
          rendered.sidebar,
          rendered.pager,
          rendered.toc,
          rendered.breadcrumbs,
        ].join();

        for (final link in internalLinks(html)) {
          final target = link.replaceFirst('href="', '').replaceFirst('"', '');
          final parts = target.split('#');
          if (parts.length < 2 || parts[1].isEmpty) continue;
          final path = parts.first;
          if (!path.startsWith('/docs')) continue;
          final slug = path.replaceFirst('/docs', '').replaceFirst('/', '');
          final targetPage = site.pageAt(slug);
          if (targetPage == null) continue; // reported by the previous test
          if (!anchorsOf(targetPage).contains(parts[1])) {
            problems.add(
              '${page.path} links to $target, which has no such anchor',
            );
          }
        }
      }

      expect(problems, isEmpty, reason: problems.join('\n'));
    });

    test('the previous and next links walk the whole site exactly once', () {
      final visited = <String>[];
      DocsPage? current = site.pages.first;
      while (current != null) {
        visited.add(current.slug);
        current = site.nextAfter(current);
      }
      expect(visited, site.pages.map((page) => page.slug).toList());
      expect(visited.length, site.pages.length);
    });
  });
}
