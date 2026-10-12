/// Shared chrome for the public marketing pages.
///
/// Serverpod's `TemplateWidget` renders Mustache templates and has no partial
/// support, so the nav, footer, icons, and code showcase are built here as HTML
/// strings and injected into each template as unescaped values.
///
/// Everything is plain HTML and CSS: no framework, no build step, and the code
/// tabs work with hidden radio inputs, so the pages need no JavaScript.
abstract final class SiteChrome {
  /// Link that opens the consumer verification page.
  static const String verifyPath = '/verify';

  /// Link that opens the Flutter operator app.
  static const String appPath = '/app';

  /// Public source repository, shown in the footer.
  static const String repoUrl = 'https://github.com/tope-olajide/fauxshield';

  /// The hosted API. Every published client defaults to it, and the docs use it
  /// in examples so a reader sees the same URL the SDKs do.
  static const String hostedApiUrl = 'https://fauxshield.api.serverpod.space';

  /// The API a local `serverpod start` serves, used in local-development
  /// instructions only.
  static const String localApiUrl = 'http://localhost:8080';

  /// Primary navigation, mirroring the reference site's information structure.
  static const List<(String, String, String)> navItems =
      <(String, String, String)>[
        ('features', 'Product', '/features'),
        ('docs', 'Developers', '/docs'),
        ('pricing', 'Pricing', '/pricing'),
        ('about', 'About', '/about'),
      ];

  /// Values every public page needs: title, description, nav, footer, and the
  /// small set of icons referenced directly from the templates.
  static Map<String, dynamic> pageValues({
    required String title,
    required String description,
    required String active,
  }) {
    return <String, dynamic>{
      'pageTitle': title,
      'pageDescription': description,
      'siteNav': nav(active: active),
      'siteFooter': footer(),
      'iconShield': icon('shield'),
      'iconArrow': icon('arrow-right'),
      'iconWifiOff': icon('wifi-off'),
      'iconCode': icon('code'),
      'iconActivity': icon('activity'),
      'iconTimer': icon('timer'),
    };
  }

  /// The sticky site header. [active] is one of the nav item keys.
  ///
  /// The single action on the right is the dashboard, not a sign in or sign up
  /// pair: every page that carries this chrome is public, and the app behind
  /// [appPath] already routes a visitor without a session to its own sign in
  /// screen. The consumer verification page has its own header and is not
  /// rendered from here, so a scan never offers an operator way out.
  static String nav({required String active}) {
    final links = StringBuffer();
    for (final (key, label, href) in navItems) {
      final isActive = key == active || (key == 'features' && active == 'home');
      links.write(
        '<a class="site-nav-link${isActive ? ' is-active' : ''}" '
        'href="$href">$label</a>',
      );
    }

    return '''
<header class="site-nav">
  <nav class="wrap site-nav-inner" aria-label="Main navigation">
    <div class="site-nav-left">
      <a href="/" aria-label="FauxShield home">${logo()}</a>
      <div class="site-nav-links">$links</div>
    </div>
    <div class="site-nav-actions">
      <a class="btn btn-ghost btn-sm" href="$verifyPath">Verify a product</a>
      <a class="btn btn-primary btn-sm" href="$appPath"
        title="Open the operator dashboard">
        Dashboard${icon('chevron-right')}
      </a>
    </div>
  </nav>
</header>''';
  }

  /// The site footer.
  static String footer() {
    final year = DateTime.now().year;
    return '''
<footer class="site-footer">
  <div class="wrap">
    <div class="footer-grid">
      <div class="footer-brand">
        <a href="/" aria-label="FauxShield home">${logo(size: 'md')}</a>
        <p>
          Product authenticity infrastructure for modern brands. Protecting
          consumers and businesses from counterfeits, built end to end on
          Serverpod 4 and Flutter.
        </p>
      </div>
      <div class="footer-col">
        <h3>Product</h3>
        <ul>
          <li><a href="/features">Features</a></li>
          <li><a href="/pricing">Pricing</a></li>
          <li><a href="/about">About</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h3>Developers</h3>
        <ul>
          <li><a href="/docs">Documentation</a></li>
          <li><a href="/docs#api">API reference</a></li>
          <li><a href="/docs#webhooks">Webhooks</a></li>
          <li><a href="/docs#offline">Offline sync</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h3>Project</h3>
        <ul>
          <li><a href="$repoUrl" rel="noreferrer">Source on GitHub</a></li>
          <li><a href="$verifyPath">Verify a product</a></li>
          <li><a href="$appPath">Operator app</a></li>
        </ul>
      </div>
    </div>
    <div class="footer-bottom">
      &copy; $year FauxShield. Built for the Build Something Real hackathon.
    </div>
  </div>
</footer>''';
  }

  /// The brand mark: a filled shield with a check, matching the reference logo.
  static String logo({String size = 'sm'}) {
    return '''
<span class="logo logo-$size">
  <span class="logo-mark">
    <svg viewBox="0 0 24 24" fill="none" aria-hidden="true">
      <path d="M12 2 4 6v6c0 5.25 3.5 10.15 8 11.5 4.5-1.35 8-6.25 8-11.5V6l-8-4Z" fill="currentColor" fill-opacity="0.9"/>
      <path d="m9 12 2 2 4-4" stroke="#ffffff" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
  </span>
  <span class="logo-word">FauxShield</span>
</span>''';
  }

  /// Render an inline stroke icon. See [_iconPaths] for the available names.
  static String icon(String name) {
    final path = _iconPaths[name];
    if (path == null) return '';
    return '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" '
        'stroke-width="2" stroke-linecap="round" stroke-linejoin="round" '
        'aria-hidden="true">$path</svg>';
  }

  /// A bordered card with an icon, a title, and body copy.
  static String featureCard({
    required String iconName,
    required String title,
    required String body,
    String tone = 'primary',
  }) {
    return '''
<article class="card card-hover">
  <div class="card-head">
    <span class="icon-tile icon-tile-$tone">${icon(iconName)}</span>
    <h3>$title</h3>
  </div>
  <p>$body</p>
</article>''';
  }

  /// A centred statistic tile: a large value, a label, and an optional note.
  static String statCard({
    required String value,
    required String label,
    String? iconName,
    String tone = 'destructive',
    String? note,
  }) {
    final iconHtml = iconName == null
        ? ''
        : '<span style="display:block;color:inherit">${icon(iconName)}</span>';
    final noteHtml = note == null
        ? ''
        : '<p class="stat-note">${escape(note)}</p>';
    return '''
<div class="stat-card">
  <span class="text-$tone">$iconHtml</span>
  <p class="stat-value text-$tone">$value</p>
  <p class="stat-note">${escape(label)}</p>
  $noteHtml
</div>''';
  }

  /// A responsive grid of icon cards.
  static String cardGrid(List<CardSpec> cards, {int columns = 3}) {
    final buffer = StringBuffer('<div class="grid-$columns">');
    for (final card in cards) {
      buffer.write(
        featureCard(
          iconName: card.iconName,
          title: card.title,
          body: card.body,
          tone: card.tone,
        ),
      );
    }
    buffer.write('</div>');
    return buffer.toString();
  }

  /// A responsive grid of statistic tiles.
  static String statGrid(List<CardSpec> cards, {int columns = 4}) {
    final buffer = StringBuffer('<div class="grid-$columns">');
    for (final card in cards) {
      buffer.write(
        statCard(
          value: card.title,
          label: card.body,
          iconName: card.iconName,
          tone: card.tone,
        ),
      );
    }
    buffer.write('</div>');
    return buffer.toString();
  }

  /// The horizontal "products to APIs" pipeline diagram.
  static String flow(List<(String, String)> steps) {
    final buffer = StringBuffer('<div class="flow">');
    for (var i = 0; i < steps.length; i++) {
      final (iconName, label) = steps[i];
      buffer.write(
        '<div class="flow-step">'
        '<div class="flow-node">'
        '<span class="flow-node-icon">${icon(iconName)}</span>'
        '<span>${escape(label)}</span>'
        '</div>',
      );
      if (i < steps.length - 1) {
        buffer.write(
          icon('arrow-right').replaceFirst('<svg', '<svg class="flow-arrow"'),
        );
      }
      buffer.write('</div>');
    }
    buffer.write('</div>');
    return buffer.toString();
  }

  /// A numbered code block. Content is escaped and annotated line by line.
  static String codeBlock(String code) {
    final lines = code.trim().split('\n');
    final buffer = StringBuffer('<pre class="code-block">');
    for (var i = 0; i < lines.length; i++) {
      buffer.write(
        '<div class="code-line">'
        '<span class="code-line-no">${i + 1}</span>'
        '<span class="code-line-text">${escape(lines[i])}</span>'
        '</div>',
      );
    }
    buffer.write('</pre>');
    return buffer.toString();
  }

  /// A tabbed code showcase. Tabs switch with hidden radio inputs, no JS.
  static String codeShowcase({
    required String name,
    required List<CodeSample> samples,
  }) {
    final switches = StringBuffer();
    final tabs = StringBuffer();
    final panes = StringBuffer();

    for (var i = 0; i < samples.length; i++) {
      final sample = samples[i];
      switches.write(
        '<input class="code-switch" type="radio" name="$name" '
        'id="$name-$i"${i == 0 ? ' checked' : ''}>',
      );
      tabs.write(
        '<label class="code-tab" for="$name-$i">'
        '${escape(sample.label)}</label>',
      );
      panes.write(
        '<div class="code-pane">'
        '<div class="code-install"><code>\$ ${escape(sample.install)}</code></div>'
        '${codeBlock(sample.code)}'
        '</div>',
      );
    }

    return '''
<div class="code-card">
  $switches
  <div class="code-tabs">$tabs</div>
  <div class="code-panes">$panes</div>
</div>''';
  }

  /// Escapes text for safe inclusion in HTML.
  static String escape(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');

  /// Lucide-style path data for the icons used across the public pages.
  static const Map<String, String> _iconPaths = <String, String>{
    'arrow-right': '<path d="M5 12h14"/><path d="m12 5 7 7-7 7"/>',
    'chevron-right': '<path d="m9 18 6-6-6-6"/>',
    'check': '<path d="M20 6 9 17l-5-5"/>',
    'shield':
        '<path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/>',
    'shield-check':
        '<path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/>'
        '<path d="m9 12 2 2 4-4"/>',
    'shield-alert':
        '<path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/>'
        '<path d="M12 8v4"/><path d="M12 16h.01"/>',
    'package':
        '<path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/>'
        '<path d="m3.3 7 8.7 5 8.7-5"/><path d="M12 22V12"/>',
    'layers':
        '<path d="m12.83 2.18a2 2 0 0 0-1.66 0L2.6 6.08a1 1 0 0 0 0 1.83l8.58 3.91a2 2 0 0 0 1.66 0l8.58-3.9a1 1 0 0 0 0-1.83Z"/>'
        '<path d="m6.08 9.5-3.5 1.6a1 1 0 0 0 0 1.81l8.6 3.91a2 2 0 0 0 1.65 0l8.58-3.9a1 1 0 0 0 0-1.83l-3.5-1.59"/>'
        '<path d="m6.08 14.5-3.5 1.6a1 1 0 0 0 0 1.81l8.6 3.91a2 2 0 0 0 1.65 0l8.58-3.9a1 1 0 0 0 0-1.83l-3.5-1.59"/>',
    'fingerprint':
        '<path d="M12 10a2 2 0 0 0-2 2c0 1.02-.1 2.51-.26 4"/><path d="M14 13.12c0 2.38 0 6.38-1 8.88"/>'
        '<path d="M17.29 21.02c.12-.6.43-2.3.5-3.02"/><path d="M2 12a10 10 0 0 1 18-6"/>'
        '<path d="M2 16h.01"/><path d="M21.8 16c.2-2 .131-5.354 0-6"/>'
        '<path d="M5 19.5C5.5 18 6 15 6 12a6 6 0 0 1 .34-2"/>'
        '<path d="M8.65 22c.21-.66.45-1.32.57-2"/><path d="M9 6.8a6 6 0 0 1 9 5.2v2"/>',
    'qr-code':
        '<rect width="5" height="5" x="3" y="3" rx="1"/><rect width="5" height="5" x="16" y="3" rx="1"/>'
        '<rect width="5" height="5" x="3" y="16" rx="1"/>'
        '<path d="M21 16h-3a2 2 0 0 0-2 2v3"/><path d="M21 21v.01"/>'
        '<path d="M12 7v3a2 2 0 0 1-2 2H7"/><path d="M3 12h.01"/><path d="M12 3h.01"/>'
        '<path d="M12 16v.01"/><path d="M16 12h1"/><path d="M21 12v.01"/><path d="M12 21v-1"/>',
    'radar':
        '<path d="M19.07 4.93A10 10 0 0 0 6.99 3.34"/><path d="M4 6h.01"/>'
        '<path d="M2.29 9.62a10 10 0 1 0 19.02-1.27"/><path d="M16.24 7.76a6 6 0 1 0-8.01 8.91"/>'
        '<path d="M12 18h.01"/><path d="M17.99 11.66a6 6 0 0 1-2.22 5.01"/>'
        '<circle cx="12" cy="12" r="2"/><path d="m13.41 10.59 5.66-5.66"/>',
    'alert-triangle':
        '<path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/>'
        '<path d="M12 9v4"/><path d="M12 17h.01"/>',
    'webhook':
        '<path d="M18 16.98h-5.99c-1.1 0-1.95.94-2.48 1.9A4 4 0 0 1 2 17c.01-.7.19-1.4.57-2"/>'
        '<path d="m6 17 3.13-5.78c.53-.97.1-2.18-.5-3.1a4 4 0 1 1 6.89-4.06"/>'
        '<path d="m12 6 3.13 5.73C15.66 12.7 16.9 13 18 13a4 4 0 0 1 0 8"/>',
    'bell':
        '<path d="M10.268 21a2 2 0 0 0 3.464 0"/>'
        '<path d="M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.327"/>',
    'lock':
        '<rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>',
    'key':
        '<path d="M2.586 17.414A2 2 0 0 0 2 18.828V21a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h1a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h.172a2 2 0 0 0 1.414-.586l.814-.814a6.5 6.5 0 1 0-4-4z"/>'
        '<circle cx="16.5" cy="7.5" r=".5" fill="currentColor"/>',
    'truck':
        '<path d="M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2"/>'
        '<path d="M15 18H9"/><path d="M19 18h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.624l-3.48-4.35A1 1 0 0 0 17.52 8H14"/>'
        '<circle cx="17" cy="18" r="2"/><circle cx="7" cy="18" r="2"/>',
    'map-pin':
        '<path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0"/>'
        '<circle cx="12" cy="10" r="3"/>',
    'bar-chart':
        '<path d="M3 3v16a2 2 0 0 0 2 2h16"/><path d="M18 17V9"/><path d="M13 17V5"/><path d="M8 17v-3"/>',
    'database':
        '<ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M3 5V19A9 3 0 0 0 21 19V5"/>'
        '<path d="M3 12A9 3 0 0 0 21 12"/>',
    'wifi-off':
        '<path d="M12 20h.01"/><path d="M8.5 16.429a5 5 0 0 1 7 0"/>'
        '<path d="M5 12.859a10 10 0 0 1 5.17-2.69"/><path d="M19 12.859a10 10 0 0 0-2.007-1.523"/>'
        '<path d="M2 8.82a15 15 0 0 1 4.177-2.643"/>'
        '<path d="M22 8.82a15 15 0 0 0-11.288-3.764"/><path d="m2 2 20 20"/>',
    'repeat':
        '<path d="m17 2 4 4-4 4"/><path d="M3 11v-1a4 4 0 0 1 4-4h14"/>'
        '<path d="m7 22-4-4 4-4"/><path d="M21 13v1a4 4 0 0 1-4 4H3"/>',
    'file-text':
        '<path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"/>'
        '<path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M10 9H8"/><path d="M16 13H8"/><path d="M16 17H8"/>',
    'activity':
        '<path d="M22 12h-2.48a2 2 0 0 0-1.93 1.46l-2.35 8.36a.25.25 0 0 1-.48 0L9.24 2.18a.25.25 0 0 0-.48 0l-2.35 8.36A2 2 0 0 1 4.49 12H2"/>',
    'timer':
        '<line x1="10" x2="14" y1="2" y2="2"/><line x1="12" x2="15" y1="14" y2="11"/>'
        '<circle cx="12" cy="14" r="8"/>',
    'zap':
        '<path d="M4 14a1 1 0 0 1-.78-1.63l9.9-10.2a.5.5 0 0 1 .86.46l-1.92 6.02A1 1 0 0 0 13 10h7a1 1 0 0 1 .78 1.63l-9.9 10.2a.5.5 0 0 1-.86-.46l1.92-6.02A1 1 0 0 0 11 14z"/>',
    'rocket':
        '<path d="M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09z"/>'
        '<path d="m12 15-3-3a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-6 11a22.35 22.35 0 0 1-4 2z"/>'
        '<path d="M9 12H4s.55-3.03 2-4c1.62-1.08 5 0 5 0"/><path d="M12 15v5s3.03-.55 4-2c1.08-1.62 0-5 0-5"/>',
    'smartphone':
        '<rect width="14" height="20" x="5" y="2" rx="2" ry="2"/><path d="M12 18h.01"/>',
    'globe':
        '<circle cx="12" cy="12" r="10"/>'
        '<path d="M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20"/><path d="M2 12h20"/>',
    'pill':
        '<path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"/>'
        '<path d="m8.5 8.5 7 7"/>',
    'sparkles':
        '<path d="m12 3-1.9 5.8a2 2 0 0 1-1.287 1.288L3 12l5.8 1.9a2 2 0 0 1 1.288 1.287L12 21l1.9-5.8a2 2 0 0 1 1.287-1.288L21 12l-5.8-1.9a2 2 0 0 1-1.288-1.287Z"/>',
    'users':
        '<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/>'
        '<path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>',
    'terminal': '<path d="m4 17 6-6-6-6"/><path d="M12 19h8"/>',
    'code': '<path d="m16 18 6-6-6-6"/><path d="m8 6-6 6 6 6"/>',
    'server':
        '<rect width="20" height="8" x="2" y="2" rx="2" ry="2"/><rect width="20" height="8" x="2" y="14" rx="2" ry="2"/>'
        '<line x1="6" x2="6.01" y1="6" y2="6"/><line x1="6" x2="6.01" y1="18" y2="18"/>',
  };
}

/// One card in [SiteChrome.cardGrid] or [SiteChrome.statGrid].
class CardSpec {
  const CardSpec({
    required this.iconName,
    required this.title,
    required this.body,
    this.tone = 'primary',
  });

  /// Icon name understood by [SiteChrome.icon].
  final String iconName;

  /// Card heading, or the large value for a statistic tile.
  final String title;

  /// Card body copy, or the label for a statistic tile.
  final String body;

  /// Colour tone: `primary`, `destructive`, `warning`, or `success`.
  final String tone;
}

/// One tab in a [SiteChrome.codeShowcase].
class CodeSample {
  const CodeSample({
    required this.label,
    required this.install,
    required this.code,
  });

  /// Tab label, for example `Dart`.
  final String label;

  /// Command shown above the snippet, for example `dart pub add fauxshield_client`.
  final String install;

  /// The snippet body.
  final String code;
}
