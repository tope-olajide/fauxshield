/// The shape of the developer documentation site.
///
/// The pages are data, not templates: the sidebar, the search index, the
/// breadcrumbs, and the previous/next links are all derived from one list of
/// [DocsPage]s, so a page cannot exist in the navigation without existing at a
/// URL, and a new page cannot be forgotten by search.
library;

/// One parameter of an API method, or one field of a model.
class DocsParam {
  const DocsParam({
    required this.name,
    required this.type,
    this.required = false,
    this.nullable = false,
    this.defaultValue,
  });

  final String name;
  final String type;

  /// Whether a caller must supply it. Model fields are never required: the
  /// server fills in a default, which is what makes them optional on the wire.
  final bool required;
  final bool nullable;
  final String? defaultValue;

  /// `String`, `bool`, `UuidValue?`, `List<Product>?` — as the contract spells it.
  String get display => nullable ? '$type?' : type;
}

/// One callable method on an API endpoint.
class DocsMethod {
  const DocsMethod({
    required this.name,
    required this.returns,
    required this.params,
    this.summary = '',
  });

  /// Method name as the server knows it, for example `list`.
  final String name;

  /// The unwrapped return type: `List<Product>`, not `Future<List<Product>>`.
  final String returns;

  final List<DocsParam> params;

  /// The doc comment on the server's implementation, when it has one.
  final String summary;

  List<DocsParam> get requiredParams =>
      params.where((param) => param.required).toList(growable: false);
}

/// One API endpoint, with every method the client exposes.
class DocsEndpoint {
  const DocsEndpoint({
    required this.name,
    required this.title,
    required this.summary,
    required this.methods,
  });

  final String name;
  final String title;
  final String summary;
  final List<DocsMethod> methods;

  /// The slug of the reference page for this endpoint, under `/docs/api`.
  String get slug => 'api/$name';
}

/// One data model the API sends or receives.
class DocsModel {
  const DocsModel({
    required this.name,
    required this.fields,
    this.summary = '',
  });

  final String name;
  final List<DocsParam> fields;
  final String summary;
}

/// One enum and its wire values.
class DocsEnum {
  const DocsEnum({required this.name, required this.values});

  final String name;

  /// The values as they travel on the wire, in declaration order.
  final List<String> values;
}

/// Everything read out of the API contract.
class DocsApi {
  const DocsApi({
    required this.endpoints,
    required this.models,
    required this.enums,
  });

  final List<DocsEndpoint> endpoints;
  final List<DocsModel> models;
  final List<DocsEnum> enums;

  int get methodCount =>
      endpoints.fold(0, (total, endpoint) => total + endpoint.methods.length);

  DocsEndpoint? endpointNamed(String name) {
    for (final endpoint in endpoints) {
      if (endpoint.name == name) return endpoint;
    }
    return null;
  }

  DocsModel? modelNamed(String name) {
    for (final model in models) {
      if (model.name == name) return model;
    }
    return null;
  }
}

/// One section of a page: a heading with an id, and the HTML under it.
///
/// Sections are the unit of both the table of contents and the search index,
/// so a long page is navigable and searchable without special cases.
class DocsSection {
  const DocsSection({
    required this.id,
    required this.title,
    required this.html,
  });

  final String id;
  final String title;
  final String html;
}

/// One page of the documentation.
class DocsPage {
  const DocsPage({
    required this.slug,
    required this.title,
    required this.description,
    required this.group,
    required this.sections,
    this.draft = false,
  });

  /// Path under `/docs`, without a leading slash. The home page is `''`.
  final String slug;

  final String title;

  /// One sentence: the meta description, and the fallback search snippet.
  final String description;

  /// The id of the [DocsGroup] this page belongs to.
  final String group;

  final List<DocsSection> sections;

  /// A draft is written but not published: it is never routed, never linked,
  /// and never indexed.
  final bool draft;

  String get path => slug.isEmpty ? '/docs' : '/docs/$slug';

  /// The text a search looks through: the title, the description, and every
  /// section's heading and prose.
  String get searchableText => <String>[
    title,
    description,
    for (final section in sections)
      '${section.title} ${htmlToText(section.html)}',
  ].join(' ');
}

/// One sidebar group: a heading and the pages under it.
class DocsGroup {
  const DocsGroup({required this.id, required this.title, required this.pages});

  final String id;
  final String title;
  final List<DocsPage> pages;

  /// Anchor-safe id for the group heading.
  String get anchor => 'group-$id';
}

/// The whole site: the groups (for navigation) derived from the pages.
class DocsSite {
  const DocsSite({required this.groups, required this.api});

  final List<DocsGroup> groups;
  final DocsApi api;

  List<DocsPage> get pages => <DocsPage>[
    for (final group in groups) ...group.pages,
  ];

  DocsPage? pageAt(String slug) {
    for (final page in pages) {
      if (page.slug == slug) return page;
    }
    return null;
  }

  DocsPage? get home => pageAt('');

  /// The page after [page] in reading order, for the "next" link.
  DocsPage? nextAfter(DocsPage page) {
    final all = pages;
    for (var index = 0; index < all.length - 1; index++) {
      if (all[index].slug == page.slug) return all[index + 1];
    }
    return null;
  }

  /// The page before [page] in reading order, for the "previous" link.
  DocsPage? previousBefore(DocsPage page) {
    final all = pages;
    for (var index = 1; index < all.length; index++) {
      if (all[index].slug == page.slug) return all[index - 1];
    }
    return null;
  }

  /// The group a page belongs to.
  DocsGroup groupOf(DocsPage page) {
    for (final group in groups) {
      if (group.id == page.group) return group;
    }
    return groups.first;
  }
}

/// Strips tags and collapses whitespace, for search snippets and plain-text
/// output. Links keep their text, script and style are removed entirely.
String htmlToText(String html) {
  var text = html
      .replaceAll(RegExp(r'<(script|style)[^>]*>.*?</\1>', dotAll: true), ' ')
      .replaceAll(RegExp(r'<[^>]+>'), ' ')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&hellip;', '…')
      .replaceAll('&mdash;', '—')
      .replaceAll(RegExp(r'\s+'), ' ');
  return text.trim();
}
