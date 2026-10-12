/// Renders the documentation portal from the [DocsSite] data.
///
/// Everything a crawler or a reader without JavaScript sees is produced here,
/// on the server: the sidebar, the breadcrumbs, the table of contents, the
/// parameter tables, and the previous/next links. The only script on the page
/// adds the search dropdown, the copy buttons, and the sidebar toggle on a
/// narrow screen.
library;

import 'dart:convert';

import 'docs_model.dart';
import '../widgets/site_chrome.dart';

/// Language labels used on code blocks and in the tabs of a sample.
abstract final class DocsLang {
  static const String curl = 'cURL';
  static const String dart = 'Dart';
  static const String ts = 'TypeScript';
  static const String python = 'Python';
  static const String cli = 'CLI';
  static const String json = 'JSON';
  static const String bash = 'Shell';

  /// The per-language SDK call for an endpoint method.
  static String example(
    String language,
    DocsEndpoint endpoint,
    DocsMethod method,
  ) {
    final args = _exampleArgs(method, language);
    switch (language) {
      case curl:
        return _curlExample(endpoint, method);
      case dart:
        return 'final result = await client.${endpoint.name}.${method.name}(${args.dart});';
      case ts:
        return 'const result = await client.${endpoint.name}.${method.name}(${args.ts});';
      case python:
        return 'result = client.${endpoint.name}.${method.name}(${args.python})';
      default:
        return '';
    }
  }

  /// Argument text in each language's calling convention.
  ///
  /// The conventions are the SDKs' real ones: the generated Dart client takes a
  /// lone required argument positionally and the rest by name, while the
  /// Node.js client takes one options object and the Python client takes
  /// keyword arguments.
  static _ExampleArgs _exampleArgs(DocsMethod method, String language) {
    if (method.params.isEmpty) {
      return const _ExampleArgs(dart: '', ts: '', python: '');
    }

    final single = method.params.length == 1 && method.params.single.required;
    final dart = StringBuffer();
    final ts = StringBuffer();
    final python = StringBuffer();
    for (final param in method.params) {
      final value = jsonValueFor(param.display);
      dart.writeln('    ${param.name}: $value,');
      ts.writeln('  ${param.name}: $value,');
      python.write('${python.isEmpty ? '' : ', '}${_snake(param.name)}=$value');
    }

    return _ExampleArgs(
      dart: single ? jsonValueFor(method.params.single.display) : '\n$dart  ',
      ts: '{\n$ts}',
      python: python.toString(),
    );
  }

  static String _snake(String name) => name
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (match) => '${match.group(1)}_${match.group(2)}',
      )
      .toLowerCase();

  /// A request a reader can paste into a terminal: the same JSON-RPC shape the
  /// Dart client speaks, with textual placeholders that say what to fill in.
  static String _curlExample(DocsEndpoint endpoint, DocsMethod method) {
    final body = <String>[
      for (final param in method.params)
        '"${param.name}": ${curlValueFor(param.display)}',
    ].join(', ');
    final host = SiteChrome.hostedApiUrl;
    return 'curl -s -X POST $host/${endpoint.name}/${method.name} \\\n'
        "  -H 'Content-Type: application/json' \\\n"
        '  -H "Authorization: Bearer \$FAUXSHIELD_API_KEY" \\\n'
        "  -d '{$body}'";
  }
}

class _ExampleArgs {
  const _ExampleArgs({
    required this.dart,
    required this.ts,
    required this.python,
  });

  final String dart;
  final String ts;
  final String python;
}

/// A JSON-shaped example value for a contract type.
String jsonValueFor(String type) => _value(type, quoted: true);

/// The same value, with `"<uuid>"`-style placeholders for ids and tokens, which
/// read better in a shell example than an empty string.
String curlValueFor(String type) => _value(type, quoted: true);

String _value(String type, {required bool quoted}) {
  final trimmed = type.endsWith('?')
      ? type.substring(0, type.length - 1)
      : type;
  if (trimmed.startsWith('List<')) return '[]';
  if (trimmed.startsWith('Map<')) return '{}';
  switch (trimmed) {
    case 'String':
      return '"<string>"';
    case 'int':
      return '0';
    case 'double':
    case 'num':
      return '0.0';
    case 'bool':
      return 'true';
    case 'UuidValue':
      return '"<uuid>"';
    case 'DateTime':
      return '"2026-01-01T00:00:00Z"';
    case 'Duration':
      return '0';
    case 'ByteData':
      return '"<base64>"';
    default:
      // A model or an enum. The placeholder says what belongs there while
      // keeping the example valid JSON, which matters because it is meant to
      // be pasted into a terminal.
      return '"<$trimmed>"';
  }
}

/// The pieces of a documentation page the layout needs, rendered.
class DocsRendered {
  const DocsRendered({
    required this.sidebar,
    required this.body,
    required this.breadcrumbs,
    required this.toc,
    required this.pager,
    required this.searchIndex,
  });

  final String sidebar;
  final String body;
  final String breadcrumbs;
  final String toc;
  final String pager;
  final String searchIndex;
}

/// Renders one page of the site.
DocsRendered render(DocsSite site, DocsPage page) {
  return DocsRendered(
    sidebar: sidebar(site, active: page),
    body: bodyOf(page),
    breadcrumbs: breadcrumbsOf(site, page),
    toc: tocOf(page),
    pager: pagerOf(site, page),
    searchIndex: searchIndexJson(site),
  );
}

/// The persistent sidebar: one collapsible group per part of the site.
String sidebar(DocsSite site, {required DocsPage active}) {
  final buffer = StringBuffer()
    ..writeln('<nav class="docs-nav" aria-label="Documentation">');
  for (final group in site.groups) {
    final isOpen = group.pages.any((page) => page.slug == active.slug);
    buffer.writeln(
      '<details class="docs-group"${isOpen ? ' open' : ''}>'
      '<summary>${SiteChrome.escape(group.title)}</summary>'
      '<ul>',
    );
    for (final page in group.pages) {
      final isActive = page.slug == active.slug;
      buffer.writeln(
        '<li><a href="${page.path}"'
        '${isActive ? ' class="is-active" aria-current="page"' : ''}>'
        '${SiteChrome.escape(page.title)}</a></li>',
      );
    }
    buffer.writeln('</ul></details>');
  }
  buffer.writeln('</nav>');
  return buffer.toString();
}

/// The title, description, and sections of a page.
String bodyOf(DocsPage page) {
  final buffer = StringBuffer()
    ..writeln('<header class="docs-header">')
    ..writeln('<h1>${SiteChrome.escape(page.title)}</h1>')
    ..writeln('<p class="docs-lede">${SiteChrome.escape(page.description)}</p>')
    ..writeln('</header>');
  for (final section in page.sections) {
    buffer
      ..writeln(
        '<section class="docs-section" aria-labelledby="${section.id}">',
      )
      ..writeln(
        '<h2 id="${section.id}">${SiteChrome.escape(section.title)}'
        '<a class="docs-anchor" href="#${section.id}" aria-label="Link to this section">#</a>'
        '</h2>',
      )
      ..writeln(section.html)
      ..writeln('</section>');
  }
  return buffer.toString();
}

/// `Docs › Group › Page`, with the group linking to its first page.
String breadcrumbsOf(DocsSite site, DocsPage page) {
  final group = site.groupOf(page);
  return '<nav class="docs-breadcrumbs" aria-label="Breadcrumb"><ol>'
      '<li><a href="/docs">Docs</a></li>'
      '<li><a href="${group.pages.first.path}">${SiteChrome.escape(group.title)}</a></li>'
      '<li aria-current="page">${SiteChrome.escape(page.title)}</li>'
      '</ol></nav>';
}

/// The on-page table of contents. Pages with a single section do not get one:
/// a list with one entry is noise.
String tocOf(DocsPage page) {
  if (page.sections.length < 2) return '';
  final buffer = StringBuffer()
    ..writeln('<aside class="docs-toc" aria-label="On this page">')
    ..writeln('<p class="docs-toc-title">On this page</p>')
    ..writeln('<ul>');
  for (final section in page.sections) {
    buffer.writeln(
      '<li><a class="docs-toc-link" href="#${section.id}">'
      '${SiteChrome.escape(section.title)}</a></li>',
    );
  }
  buffer.writeln('</ul></aside>');
  return buffer.toString();
}

/// Previous and next links, in reading order.
String pagerOf(DocsSite site, DocsPage page) {
  final previous = site.previousBefore(page);
  final next = site.nextAfter(page);
  if (previous == null && next == null) return '';
  final buffer = StringBuffer(
    '<nav class="docs-pager" aria-label="Page navigation">',
  );
  buffer.writeln(
    previous == null
        ? '<span></span>'
        : '<a class="docs-pager-link" href="${previous.path}" rel="prev">'
              '<span class="docs-pager-label">Previous</span>'
              '<span class="docs-pager-title">${SiteChrome.escape(previous.title)}</span></a>',
  );
  buffer.writeln(
    next == null
        ? '<span></span>'
        : '<a class="docs-pager-link is-next" href="${next.path}" rel="next">'
              '<span class="docs-pager-label">Next</span>'
              '<span class="docs-pager-title">${SiteChrome.escape(next.title)}</span></a>',
  );
  buffer.writeln('</nav>');
  return buffer.toString();
}

/// The search index the browser fetches: one entry per section, so a hit can
/// point at the paragraph rather than the top of a long page.
String searchIndexJson(DocsSite site) {
  final entries = <Map<String, Object>>[];
  for (final group in site.groups) {
    for (final page in group.pages) {
      for (final section in page.sections) {
        entries.add(<String, Object>{
          'path': '${page.path}#${section.id}',
          'page': page.path,
          'title': page.title,
          'group': group.title,
          'section': section.title,
          'text': htmlToText(section.html),
        });
      }
    }
  }
  return const JsonEncoder.withIndent('  ').convert(<String, Object>{
    'generated': DateTime.now().toUtc().toIso8601String().substring(0, 10),
    'entries': entries,
  });
}

/// A code block with a language label. The copy button is added by the page's
/// script, which reads the `<code>` element so it copies the code, not the
/// label.
String code(String source, {String? lang}) {
  final label = lang == null
      ? ''
      : '<span class="code-lang">${SiteChrome.escape(lang)}</span>';
  return '<figure class="docs-code">$label<pre><code>'
      '${SiteChrome.escape(source.trim())}</code></pre>'
      '<button class="docs-copy" type="button" hidden>Copy</button></figure>';
}

/// Tabbed code in several languages, switched by hidden radio inputs so it
/// needs no script. The first tab is the one a reader without JavaScript sees.
String tabs({required String name, required List<(String, String)> samples}) {
  final switches = StringBuffer();
  final labels = StringBuffer();
  final panes = StringBuffer();
  for (var index = 0; index < samples.length; index++) {
    final (label, source) = samples[index];
    switches.write(
      '<input class="docs-switch" type="radio" name="$name" '
      'id="$name-$index"${index == 0 ? ' checked' : ''}>',
    );
    labels.write(
      '<label class="docs-tab" for="$name-$index">${SiteChrome.escape(label)}</label>',
    );
    panes.write('<div class="docs-pane">${code(source, lang: label)}</div>');
  }
  return '<div class="docs-tabs">$switches'
      '<div class="docs-tab-row">$labels</div>'
      '<div class="docs-panes">$panes</div></div>';
}

/// A parameter table. A method with no parameters gets one row that says so,
/// which reads better than an empty table.
String paramTable(List<DocsParam> params, {String empty = 'None.'}) {
  if (params.isEmpty) {
    return '<p class="docs-muted">$empty</p>';
  }
  final buffer = StringBuffer()
    ..writeln('<div class="table-wrap"><table class="data docs-table">')
    ..writeln(
      '<thead><tr><th>Name</th><th>Type</th><th>Required</th>'
      '<th>Notes</th></tr></thead><tbody>',
    );
  for (final param in params) {
    final notes = <String>[];
    if (param.nullable) {
      notes.add('nullable');
    }
    if (param.defaultValue != null) {
      notes.add('default `${param.defaultValue}`');
    }
    buffer.writeln(
      '<tr><td><code>${SiteChrome.escape(param.name)}</code></td>'
      '<td><code>${SiteChrome.escape(param.display)}</code></td>'
      '<td>${param.required ? 'yes' : 'no'}</td>'
      '<td class="muted">${notes.isEmpty ? '—' : notes.join(', ')}</td></tr>',
    );
  }
  buffer.writeln('</tbody></table></div>');
  return buffer.toString();
}

/// A callout: a note, a warning, or a tip.
String callout(String kind, String title, String html) {
  return '<aside class="docs-callout docs-callout-$kind">'
      '<p class="docs-callout-title">${SiteChrome.escape(title)}</p>'
      '$html</aside>';
}

/// The HTTP method badge used next to a method name.
String badge(String text, {String tone = 'primary'}) =>
    '<span class="docs-badge docs-badge-$tone">${SiteChrome.escape(text)}</span>';
