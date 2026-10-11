import 'package:serverpod/serverpod.dart';

/// Media stored by this project is saved as web-root-relative paths (for
/// example `/web/media/products/<file>`), which keeps database rows portable
/// across environments. Clients that are not served by the same origin as the
/// web server — most importantly the Flutter app running on its own dev
/// server — cannot resolve those paths, so every URL handed out at a read
/// boundary is expanded with [absoluteWebUrl]. URLs written back by clients
/// are collapsed again with [relativeWebPath], so rows stay relative.

/// Expands a web-root-relative [url] into an absolute URL on the configured
/// web server's public origin. Absolute and external URLs pass through
/// unchanged.
String absoluteWebUrl(Session session, String url) {
  if (!url.startsWith('/')) return url;
  final web = session.serverpod.config.webServer;
  if (web == null) return url;
  final scheme = web.publicScheme;
  final port = web.publicPort;
  final defaultPort = scheme == 'https' ? 443 : 80;
  final host = port == defaultPort ? web.publicHost : '${web.publicHost}:$port';
  return '$scheme://$host$url';
}

/// Collapses an absolute URL that points at this server's web origin back to
/// a web-root-relative path for storage. External URLs (CDNs, other hosts)
/// pass through unchanged.
String relativeWebPath(Session session, String url) {
  if (!url.startsWith('/')) {
    final web = session.serverpod.config.webServer;
    if (web == null) return url;
    final scheme = web.publicScheme;
    final port = web.publicPort;
    final defaultPort = scheme == 'https' ? 443 : 80;
    final host = port == defaultPort
        ? web.publicHost
        : '${web.publicHost}:$port';
    final origin = '$scheme://$host';
    if (url.startsWith('$origin/')) return url.substring(origin.length);
  }
  return url;
}

/// Convenience for nullable lists of stored URLs.
List<String>? absoluteWebUrls(Session session, List<String>? urls) =>
    urls == null
    ? null
    : [for (final url in urls) absoluteWebUrl(session, url)];

/// Convenience for nullable lists of client-supplied URLs.
List<String>? relativeWebPaths(Session session, List<String>? urls) =>
    urls == null
    ? null
    : [for (final url in urls) relativeWebPath(session, url)];
