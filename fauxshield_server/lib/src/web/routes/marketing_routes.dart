import 'package:serverpod/serverpod.dart';

import '../../cache_busting.dart';
import '../widgets/about_page.dart';
import '../widgets/docs_page.dart';
import '../widgets/features_page.dart';
import '../widgets/pricing_page.dart';

/// The `/features` page.
class FeaturesRoute extends WidgetRoute {
  FeaturesRoute()
    : super(
        methods: const {Method.get},
        cacheBustingConfig: cacheBustingConfig,
      );

  @override
  Future<WebWidget> build(Session session, Request request) async {
    return FeaturesPageWidget.build();
  }
}

/// The `/pricing` page.
class PricingRoute extends WidgetRoute {
  PricingRoute()
    : super(
        methods: const {Method.get},
        cacheBustingConfig: cacheBustingConfig,
      );

  @override
  Future<WebWidget> build(Session session, Request request) async {
    return PricingPageWidget.build();
  }
}

/// The `/about` page.
class AboutRoute extends WidgetRoute {
  AboutRoute()
    : super(
        methods: const {Method.get},
        cacheBustingConfig: cacheBustingConfig,
      );

  @override
  Future<WebWidget> build(Session session, Request request) async {
    return AboutPageWidget.build();
  }
}

/// The `/docs` page.
class DocsRoute extends WidgetRoute {
  DocsRoute()
    : super(
        methods: const {Method.get},
        cacheBustingConfig: cacheBustingConfig,
      );

  @override
  Future<WebWidget> build(Session session, Request request) async {
    return DocsPageWidget.build();
  }
}
