import 'package:serverpod/serverpod.dart';

import '../../cache_busting.dart';
import '../docs/docs_model.dart';
import '../docs/docs_render.dart';
import '../docs/docs_site.dart';
import '../widgets/site_chrome.dart';

/// The documentation portal, served under `/docs`.
///
/// One route serves the whole portal: the home page, every written page, every
/// generated reference page, the search index the browser fetches, and a
/// helpful page for a slug that does not exist. Nothing is registered per page,
/// so a page cannot be added to the sidebar without also being reachable, and a
/// slug can never fall through to a bare 404.
class DocsRoute extends WidgetRoute {
  DocsRoute()
    : super(
        methods: const {Method.get},
        cacheBustingConfig: cacheBustingConfig,
      );

  /// The slug a request path asks for: `/docs` is the home page, and
  /// `/docs/api/models` is `api/models`.
  static String slugOf(String path) {
    var slug = path;
    if (slug.startsWith('/docs')) slug = slug.substring('/docs'.length);
    while (slug.startsWith('/')) {
      slug = slug.substring(1);
    }
    while (slug.endsWith('/')) {
      slug = slug.substring(0, slug.length - 1);
    }
    return slug;
  }

  @override
  Future<WebWidget> build(Session session, Request request) async {
    final slug = slugOf(request.url.path);

    // The search box on every page fetches this. It is rendered from the same
    // pages the reader is looking at, so it cannot go stale.
    if (slug == 'search.json') {
      return JsonWidget(object: searchIndexJson(docsSite));
    }

    final page = docsSite.pageAt(slug);
    if (page == null) {
      session.log(
        'docs page not found: ${request.url.path}',
        level: LogLevel.debug,
      );
      return pageWidget(notFoundPage(docsSite, slug), noindex: true);
    }

    return pageWidget(page);
  }

  /// The template and values for one page.
  ///
  /// Public because the tests render every page through it: a template that
  /// forgets a value, or a value the template does not use, is caught without
  /// starting a server.
  TemplateWidget pageWidget(DocsPage page, {bool noindex = false}) {
    final rendered = render(docsSite, page);
    final group = docsSite.groupOf(page);
    return TemplateWidget(name: 'docs_page')
      ..values.addAll(
        SiteChrome.pageValues(
          title: '${page.title} — FauxShield documentation',
          description: page.description,
          active: 'docs',
        ),
      )
      ..values.addAll(<String, dynamic>{
        'docsSidebar': rendered.sidebar,
        'docsBody': rendered.body,
        'docsBreadcrumbs': rendered.breadcrumbs,
        'docsToc': rendered.toc,
        'docsPager': rendered.pager,
        'docsGroup': group.title,
        'docsNoindex': noindex ? '<meta name="robots" content="noindex">' : '',
      });
  }
}
