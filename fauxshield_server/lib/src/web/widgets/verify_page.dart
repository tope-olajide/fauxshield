import 'package:serverpod/serverpod.dart';

import '../../core/constants.dart';

/// The consumer verification web page widget.
///
/// One template handles every state of the flow: token entry, PIN entry,
/// the determined result, the report form, and failure states.
class VerifyPageWidget extends TemplateWidget {
  VerifyPageWidget() : super(name: 'verify');

  factory VerifyPageWidget.tokenEntry({
    String brandName = 'FauxShield',
    String? logoUrl,
    String? tagline,
    String themeColor = '#0f766e',
  }) {
    return VerifyPageWidget()
      ..values.addAll(<String, dynamic>{
        'pageTitle': '$brandName verification',
        'brandName': brandName,
        'logoUrl': logoUrl,
        'tagline': tagline,
        'themeColor': themeColor,
        'needsToken': true,
      });
  }

  factory VerifyPageWidget.pinEntry({
    required String sessionId,
    required String tokenMasked,
    String? productName,
    String brandName = 'FauxShield',
    String? logoUrl,
    String? tagline,
    String themeColor = '#0f766e',
  }) {
    return VerifyPageWidget()
      ..values.addAll(<String, dynamic>{
        'pageTitle': 'Enter your PIN',
        'brandName': brandName,
        'logoUrl': logoUrl,
        'tagline': tagline,
        'themeColor': themeColor,
        'needsPin': true,
        'sessionId': sessionId,
        'tokenMasked': tokenMasked,
        'productName': productName,
        'pinLength': FauxShieldLimits.pinLength,
      });
  }

  factory VerifyPageWidget.result({
    required String sessionId,
    required String resultTitle,
    required String resultMessage,
    required String resultClass,
    required String tokenMasked,
    bool alreadyVerified = false,
    bool recalled = false,
    bool fraudSuspected = false,
    String? productName,
    String? sku,
    String? batchReference,
    String? recallReason,
    String? authenticMessage,
    String? locationLabel,
    int verificationCount = 0,
    String? firstVerifiedAtLabel,
    String brandName = 'FauxShield',
    String? logoUrl,
    String? tagline,
    String themeColor = '#0f766e',
  }) {
    return VerifyPageWidget()
      ..values.addAll(<String, dynamic>{
        'pageTitle': resultTitle,
        'brandName': brandName,
        'logoUrl': logoUrl,
        'tagline': tagline,
        'themeColor': themeColor,
        'hasResult': true,
        'sessionId': sessionId,
        'resultTitle': resultTitle,
        'resultMessage': resultMessage,
        'resultClass': resultClass,
        'tokenMasked': tokenMasked,
        'productName': productName,
        'sku': sku,
        'batchReference': batchReference,
        'recallReason': recallReason,
        'authenticMessage': authenticMessage,
        'locationLabel': locationLabel,
        'alreadyVerified': alreadyVerified,
        'recalled': recalled,
        'fraudSuspected': fraudSuspected,
        'verificationCount': verificationCount,
        'firstVerifiedAtLabel': firstVerifiedAtLabel,
        'canReport': !fraudSuspected,
      });
  }

  factory VerifyPageWidget.reported({required String message}) {
    return VerifyPageWidget()
      ..values.addAll(<String, dynamic>{
        'pageTitle': 'Report received',
        'brandName': 'FauxShield',
        'themeColor': '#0f766e',
        'reported': true,
        'message': message,
      });
  }

  factory VerifyPageWidget.failure({required String message}) {
    return VerifyPageWidget()
      ..values.addAll(<String, dynamic>{
        'pageTitle': 'Verification failed',
        'brandName': 'FauxShield',
        'themeColor': '#0f766e',
        'failure': true,
        'message': message,
      });
  }
}
