import 'package:serverpod/serverpod.dart';

/// The FauxShield landing page.
///
/// Shows what the platform does, live platform counters read from the
/// database, and one-tap entry points: the operator app, the consumer
/// verification page, and a demo product code.
class LandingPageWidget extends TemplateWidget {
  LandingPageWidget() : super(name: 'landing');

  factory LandingPageWidget.withStats({
    required int workspaces,
    required int products,
    required int identities,
    required int verifications,
    required int alerts,
    String? demoToken,
    String? demoProductName,
    String? demoBrandName,
    String? demoPin,
  }) {
    return LandingPageWidget()
      ..values.addAll(<String, dynamic>{
        'workspaces': workspaces,
        'products': products,
        'identities': identities,
        'verifications': verifications,
        'alerts': alerts,
        'hasDemo': demoToken != null && demoToken.isNotEmpty,
        'demoToken': demoToken,
        'demoProductName': demoProductName,
        'demoBrandName': demoBrandName,
        'hasDemoPin': demoPin != null && demoPin.isNotEmpty,
        'demoPin': demoPin,
      });
  }

  factory LandingPageWidget.unavailable() {
    return LandingPageWidget()
      ..values.addAll(<String, dynamic>{
        'workspaces': 0,
        'products': 0,
        'identities': 0,
        'verifications': 0,
        'alerts': 0,
        'hasDemo': false,
      });
  }
}
