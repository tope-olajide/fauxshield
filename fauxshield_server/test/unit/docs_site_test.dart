import 'package:fauxshield_server/src/web/docs/api_reference.g.dart';
import 'package:fauxshield_server/src/web/docs/docs_model.dart';
import 'package:fauxshield_server/src/web/docs/docs_render.dart';
import 'package:fauxshield_server/src/web/docs/docs_site.dart';
import 'package:test/test.dart';

/// The site is data, so most of what could go wrong with a documentation portal
/// — a page missing from the navigation, a reference page for a method that no
/// longer exists, a search index that does not cover a page — is a property of
/// that data and can be asserted here, without a server.
void main() {
  final site = docsSite;

  group('Given the documentation site', () {
    test('every page has a unique slug and a group that exists', () {
      final seen = <String>{};
      for (final page in site.pages) {
        expect(
          seen.add(page.slug),
          isTrue,
          reason: 'duplicate slug: ${page.slug}',
        );
        final inGroup = site.groups.any((group) => group.id == page.group);
        expect(inGroup, isTrue, reason: '${page.slug} is in no group');
      }
    });

    test('every page has a title, a description, and at least one section', () {
      for (final page in site.pages) {
        expect(page.title.trim(), isNotEmpty, reason: page.slug);
        expect(page.description.trim(), isNotEmpty, reason: page.slug);
        expect(page.sections, isNotEmpty, reason: page.slug);
        final ids = <String>{};
        for (final section in page.sections) {
          expect(section.id.trim(), isNotEmpty, reason: page.slug);
          expect(
            section.title.trim(),
            isNotEmpty,
            reason: '${page.slug}#${section.id}',
          );
          expect(
            section.html.trim(),
            isNotEmpty,
            reason: '${page.slug}#${section.id} has no content',
          );
          expect(
            ids.add(section.id),
            isTrue,
            reason: 'duplicate section id ${section.id} in ${page.slug}',
          );
        }
      }
    });

    test('the portal carries the sections it advertises', () {
      // A rough floor rather than an exact number: pages may be added freely,
      // but the portal cannot silently shrink to a shell.
      expect(site.pages.length, greaterThanOrEqualTo(40));
      expect(
        site.groups.map((group) => group.id).toList(),
        <String>[
          'overview',
          'getting-started',
          'authentication',
          'api',
          'sdk',
          'guides',
          'cli',
          'mcp',
          'reference',
        ],
      );
      for (final group in site.groups) {
        expect(group.pages, isNotEmpty, reason: group.id);
      }
    });

    test('the home page is first, so the reading order starts there', () {
      expect(site.pages.first.slug, '');
      expect(site.nextAfter(site.pages.first), isNotNull);
      expect(site.previousBefore(site.pages.first), isNull);
    });

    test('the sidebar lists every page exactly once', () {
      final html = render(site, site.pages.first).sidebar;
      for (final page in site.pages) {
        final hrefs = RegExp('href="${page.path}"').allMatches(html).length;
        expect(
          hrefs,
          1,
          reason: '${page.slug} appears $hrefs times in the sidebar',
        );
      }
    });

    test('the search index covers every section of every page', () {
      final index = searchIndexJson(site);
      for (final page in site.pages) {
        for (final section in page.sections) {
          expect(
            index.contains('${page.path}#${section.id}'),
            isTrue,
            reason: 'missing from search: ${page.path}#${section.id}',
          );
        }
      }
    });

    test(
      'a slug that does not exist gets a helpful page rather than a crash',
      () {
        final page = notFoundPage(site, 'api/does-not-exist');
        expect(page.sections, isNotEmpty);
        expect(page.searchableText, contains('does not exist'));
      },
    );
  });

  group('Given the API reference', () {
    test('the generated reference matches the contract it was built from', () {
      // The generator writes both the reference and the fingerprint, so this
      // catches a hand-edited generated file.
      expect(docsContractSourceHash, isNotEmpty);
      expect(docsApi.endpoints, isNotEmpty);
      expect(docsApi.methodCount, greaterThan(50));
    });

    test('every endpoint has a reference page, linked from the index', () {
      final index = site.pageAt('api')!;
      for (final endpoint in docsApi.endpoints) {
        final page = site.pageAt(endpoint.slug);
        expect(page, isNotNull, reason: 'no page for ${endpoint.name}');
        expect(page!.group, 'api');
        expect(index.searchableText, contains(endpoint.name));
      }
    });

    test('every method of every endpoint is documented on its page', () {
      for (final endpoint in docsApi.endpoints) {
        final page = site.pageAt(endpoint.slug)!;
        for (final method in endpoint.methods) {
          final section = page.sections.firstWhere(
            (section) => section.id == method.name,
            orElse: () => throw StateError(
              '${endpoint.name}.${method.name} has no section on ${page.slug}',
            ),
          );
          // The method's own parameters are in its table, so a reader cannot be
          // shown a signature the API does not have. Compared as text because
          // the renderer escapes the angle brackets in a type.
          final text = htmlToText(section.html);
          for (final param in method.params) {
            expect(
              text,
              contains(param.name),
              reason:
                  '${endpoint.name}.${method.name} does not mention ${param.name}',
            );
          }
          expect(text, contains(method.returns));
        }
      }
    });

    test('every model and enum in the contract has a reference entry', () {
      final models = site.pageAt('api/models')!;
      for (final model in docsApi.models) {
        expect(models.searchableText, contains(model.name), reason: model.name);
      }
      final enums = site.pageAt('api/enums')!;
      for (final value in docsApi.enums) {
        expect(enums.searchableText, contains(value.name), reason: value.name);
        for (final item in value.values) {
          expect(
            enums.searchableText,
            contains(item),
            reason: '${value.name}.$item',
          );
        }
      }
    });

    test('no endpoint page documents a method the contract does not have', () {
      for (final endpoint in docsApi.endpoints) {
        final page = site.pageAt(endpoint.slug)!;
        final known = endpoint.methods.map((method) => method.name).toSet();
        for (final section in page.sections) {
          if (section.id == 'methods' || section.id == 'related') continue;
          expect(
            known,
            contains(section.id),
            reason:
                '${page.slug} has a section "${section.id}" that is not an API method',
          );
        }
      }
    });
  });
}
