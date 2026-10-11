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
    required String fingerprint,
    String? token,
    String? productName,
    String? sku,
    String? batchReference,
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
        'sku': sku,
        'batchReference': batchReference,
        // Rendered server-side so the POST carries the exact fingerprint
        // the session was bound to; client-side rewrites would break it.
        'fp': fingerprint,
        // Raw token so an expired session can be re-resolved into a fresh
        // one without forcing the consumer to scan the QR code again.
        'token': token,
        'pinLength': FauxShieldLimits.pinLength,
      });
  }

  factory VerifyPageWidget.result({
    required String sessionId,
    required String resultTitle,
    required String resultMessage,
    required String resultClass,
    required String tokenMasked,
    required String fingerprint,
    bool alreadyVerified = false,
    bool recalled = false,
    bool fraudSuspected = false,
    String? productName,
    String? sku,
    String? batchReference,
    String? recallReason,
    String? authenticMessage,
    String? locationLabel,
    String? imageUrl,
    String? description,
    String? packaging,
    String? shelfLife,
    String? countryRestrictions,
    String? safetyInstructions,
    int verificationCount = 0,
    String? firstVerifiedAtLabel,
    String? verifiedByThisDeviceAtLabel,
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
        'imageUrl': imageUrl,
        'description': description,
        'packaging': packaging,
        'shelfLife': shelfLife,
        'countryRestrictions': countryRestrictions,
        'safetyInstructions': safetyInstructions,
        'fp': fingerprint,
        'alreadyVerified': alreadyVerified,
        'recalled': recalled,
        'fraudSuspected': fraudSuspected,
        'verificationCount': verificationCount,
        'firstVerifiedAtLabel': firstVerifiedAtLabel,
        'verifiedByThisDeviceAtLabel': verifiedByThisDeviceAtLabel,
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
