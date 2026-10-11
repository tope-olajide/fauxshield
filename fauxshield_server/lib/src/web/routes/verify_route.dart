import 'package:serverpod/serverpod.dart';

import '../../cache_busting.dart';
import '../../core/identity_crypto.dart';
import '../../generated/protocol.dart';
import '../../services/fake_report_service.dart';
import '../../services/verification_service.dart';
import '../widgets/verify_page.dart';

/// The consumer verification web page.
///
/// Renders the full verification flow as server-rendered HTML: QR token
/// entry, PIN entry, result, and product reporting. It uses the same
/// [VerificationService] as the Flutter app, so outcomes, fraud detection,
/// alerts, and audit records are identical to an in-app scan.
///
/// QR codes point at `/verify?t=<token>`.
class VerifyRoute extends WidgetRoute {
  VerifyRoute()
    : super(
        methods: const <Method>{Method.get, Method.post},
        cacheBustingConfig: cacheBustingConfig,
      );

  VerificationService get _service => VerificationService();

  @override
  Future<WebWidget> build(Session session, Request request) async {
    try {
      if (request.method == Method.post) {
        return await _handlePost(session, request);
      }
      return await _handleGet(session, request);
    } on VerificationException catch (error) {
      return VerifyPageWidget.failure(message: error.message);
    } on ValidationException catch (error) {
      return VerifyPageWidget.failure(message: error.message);
    } on RateLimitException catch (error) {
      return VerifyPageWidget.failure(message: error.message);
    } catch (error) {
      session.log('verify page failed: $error', level: LogLevel.error);
      return VerifyPageWidget.failure(
        message: 'Something went wrong on our side. Please try again.',
      );
    }
  }

  Future<WebWidget> _handleGet(Session session, Request request) async {
    final params = request.url.queryParameters;
    final token = params['t']?.trim();
    final fingerprint = _fingerprint(request, params['fp']);
    if (token == null || token.isEmpty) {
      return VerifyPageWidget.tokenEntry();
    }

    final verification = await _service.resolveToken(
      session,
      token: token,
      deviceFingerprint: fingerprint,
      source: ScanSource.consumerWeb,
      // WebCallSession carries no request, so the service cannot see the
      // caller's address; without it geo lookup yields "Unknown" country.
      ipOverride: request.remoteInfo,
      // The browser's timezone names the consumer's region when the IP is
      // local (localhost scans carry no routable address).
      timezoneHint: params['tz']?.trim(),
    );
    var presentation = await _service.presentation(
      session,
      sessionId: verification.id!,
      deviceFingerprint: fingerprint,
    );
    // A healthy unit stops at the PIN prompt: the token resolved, and the
    // consumer now proves possession of the packaging PIN. Recalled, locked
    // and fraud-flagged sessions already carry a result and skip this step.
    if (presentation.state == VerificationState.tokenResolved) {
      await _service.advanceState(
        session,
        sessionId: verification.id!,
        deviceFingerprint: fingerprint,
        targetState: VerificationState.pinPrompted,
      );
      presentation = await _service.presentation(
        session,
        sessionId: verification.id!,
        deviceFingerprint: fingerprint,
      );
    }
    return _pageFor(presentation, fingerprint, token);
  }

  Future<WebWidget> _handlePost(Session session, Request request) async {
    final body = await request.readAsString();
    final form = Uri.splitQueryString(body);
    final action = form['action'] ?? '';
    final fingerprint = _fingerprint(request, form['fp']);
    final sessionIdRaw = form['sessionId'];

    switch (action) {
      case 'pin':
        return _handlePin(session, request, form, sessionIdRaw, fingerprint);
      case 'report':
        return _handleReport(session, form, sessionIdRaw, fingerprint);
      default:
        return VerifyPageWidget.tokenEntry();
    }
  }

  Future<WebWidget> _handlePin(
    Session session,
    Request request,
    Map<String, String> form,
    String? sessionIdRaw,
    String fingerprint,
  ) async {
    final pin = form['pin']?.trim() ?? '';
    final token = form['t']?.trim();

    // The session may have expired between the PIN prompt and the submit, or
    // the page was re-opened later. Instead of dead-ending with "scan again",
    // re-resolve the token (carried in the form) into a fresh session so the
    // consumer can simply re-enter the PIN.
    VerificationSession? verification;
    if (sessionIdRaw != null) {
      try {
        verification = await VerificationSession.db.findById(
          session,
          UuidValue.fromString(sessionIdRaw),
        );
      } catch (_) {
        verification = null;
      }
      if (verification != null &&
          verification.deviceFingerprint != fingerprint) {
        verification = null;
      }
      if (verification != null &&
          verification.expiresAt.isBefore(DateTime.now().toUtc()) &&
          verification.state != VerificationState.resultDetermined) {
        verification = null;
      }
    }

    if (verification == null) {
      if (token == null || token.isEmpty) {
        return VerifyPageWidget.failure(
          message: 'Your session expired. Scan again.',
        );
      }
      verification = await _service.resolveToken(
        session,
        token: token,
        deviceFingerprint: fingerprint,
        source: ScanSource.consumerWeb,
        ipOverride: request.remoteInfo,
        timezoneHint: form['tz']?.trim(),
      );
    }

    final sessionId = verification.id!;
    var presentation = await _service.presentation(
      session,
      sessionId: sessionId,
      deviceFingerprint: fingerprint,
    );
    if (presentation.state == VerificationState.tokenResolved) {
      await _service.advanceState(
        session,
        sessionId: sessionId,
        deviceFingerprint: fingerprint,
        targetState: VerificationState.pinPrompted,
      );
      presentation = await _service.presentation(
        session,
        sessionId: sessionId,
        deviceFingerprint: fingerprint,
      );
    }
    if (presentation.state == VerificationState.pinPrompted) {
      await _service.advanceState(
        session,
        sessionId: sessionId,
        deviceFingerprint: fingerprint,
        targetState: VerificationState.pinSubmitted,
      );
      await _service.submitPin(
        session,
        sessionId: sessionId,
        deviceFingerprint: fingerprint,
        pin: pin,
      );
      presentation = await _service.presentation(
        session,
        sessionId: sessionId,
        deviceFingerprint: fingerprint,
      );
    }
    return _pageFor(presentation, fingerprint, token);
  }

  Future<WebWidget> _handleReport(
    Session session,
    Map<String, String> form,
    String? sessionIdRaw,
    String fingerprint,
  ) async {
    if (sessionIdRaw == null) {
      return VerifyPageWidget.failure(
        message: 'Your session expired. Scan again.',
      );
    }
    final verification = await VerificationSession.db.findById(
      session,
      UuidValue.fromString(sessionIdRaw),
    );
    if (verification == null || verification.deviceFingerprint != fingerprint) {
      return VerifyPageWidget.failure(
        message: 'Your session expired. Scan again.',
      );
    }
    final acknowledgement = await FakeReportService.create(
      session,
      verification: verification,
      deviceFingerprint: fingerprint,
      reason: form['reason'] ?? 'Suspicious product',
      comment: form['comment'],
    );
    return VerifyPageWidget.reported(message: acknowledgement.message);
  }

  WebWidget _pageFor(
    VerificationPresentation presentation,
    String fingerprint,
    String? token,
  ) {
    final branding = presentation.branding;
    final brandName = branding?.displayName ?? presentation.workspaceName;
    final themeColor = _themeColor(branding?.themeColor);
    final location = presentation.location;
    final locationLabel = location == null
        ? null
        : <String?>[location.city, location.country]
              .whereType<String>()
              .where((part) => part.isNotEmpty && part != 'Unknown')
              .join(', ');

    if (presentation.state == VerificationState.pinPrompted) {
      return VerifyPageWidget.pinEntry(
        sessionId: presentation.sessionId.uuid,
        tokenMasked: presentation.tokenMasked,
        fingerprint: fingerprint,
        token: token,
        productName: presentation.productName,
        sku: presentation.sku,
        batchReference: presentation.batchReference,
        brandName: brandName,
        logoUrl: branding?.logoUrl,
        tagline: branding?.tagline,
        themeColor: themeColor,
      );
    }

    final outcome = presentation.outcome;
    final title = _titleFor(outcome);
    final message = _messageFor(presentation);
    final resultClass = switch (outcome) {
      VerificationOutcome.authentic => 'authentic',
      VerificationOutcome.alreadyVerified => 'already',
      VerificationOutcome.recalled ||
      VerificationOutcome.fraudSuspected => 'danger',
      VerificationOutcome.highRisk ||
      VerificationOutcome.invalidPin => 'warning',
      null => 'pending',
    };

    return VerifyPageWidget.result(
      sessionId: presentation.sessionId.uuid,
      resultTitle: title,
      resultMessage: message,
      resultClass: resultClass,
      tokenMasked: presentation.tokenMasked,
      fingerprint: fingerprint,
      alreadyVerified: outcome == VerificationOutcome.alreadyVerified,
      recalled: outcome == VerificationOutcome.recalled,
      fraudSuspected: outcome == VerificationOutcome.fraudSuspected,
      productName: presentation.productName,
      sku: presentation.sku,
      batchReference: presentation.batchReference,
      recallReason: presentation.recallReason,
      authenticMessage: presentation.authenticMessage,
      locationLabel: locationLabel == null || locationLabel.isEmpty
          ? null
          : locationLabel,
      imageUrl:
          presentation.imageUrls == null || presentation.imageUrls!.isEmpty
          ? null
          : presentation.imageUrls!.first,
      description: presentation.description,
      packaging: presentation.packaging,
      shelfLife: presentation.shelfLife,
      countryRestrictions:
          presentation.countryRestrictions == null ||
              presentation.countryRestrictions!.isEmpty
          ? 'None'
          : presentation.countryRestrictions!.join(', '),
      safetyInstructions: presentation.safetyInstructions,
      verificationCount: presentation.verificationCount,
      firstVerifiedAtLabel: presentation.verifiedAt
          .toIso8601String()
          .split('T')
          .first,
      verifiedByThisDeviceAtLabel: presentation.verifiedByThisDevice
          ?.toIso8601String()
          .split('T')
          .first,
      brandName: brandName,
      logoUrl: branding?.logoUrl,
      tagline: branding?.tagline,
      themeColor: themeColor,
    );
  }

  static String _titleFor(VerificationOutcome? outcome) {
    switch (outcome) {
      case VerificationOutcome.authentic:
        return 'This product is authentic';
      case VerificationOutcome.alreadyVerified:
        return 'This product was already verified';
      case VerificationOutcome.invalidPin:
        return 'The PIN did not match';
      case VerificationOutcome.highRisk:
        return 'Verified with caution';
      case VerificationOutcome.fraudSuspected:
        return 'Counterfeit suspected';
      case VerificationOutcome.recalled:
        return 'This product is recalled';
      case null:
        return 'Verification status';
    }
  }

  static String _messageFor(VerificationPresentation presentation) {
    switch (presentation.outcome) {
      case VerificationOutcome.authentic:
        return presentation.authenticMessage ??
            'The code resolves to a registered unit of ${presentation.productName} '
                'and the PIN matched. Keep the packaging for your records.';
      case VerificationOutcome.alreadyVerified:
        if (presentation.verifiedByThisDevice != null) {
          return 'You already verified this product from this device — the unit '
              'checks out and its verification history is below.';
        }
        return 'This code was already verified ${presentation.verificationCount} time(s) '
            'by another device. If you just bought this product sealed, treat it as '
            'suspicious and report it.';
      case VerificationOutcome.invalidPin:
        return 'The PIN you entered does not match this code. Check the digits and try again, '
            'and report the product if it keeps failing.';
      case VerificationOutcome.highRisk:
        return 'The code is genuine but the scan pattern looks unusual. '
            'The brand has been notified.';
      case VerificationOutcome.fraudSuspected:
        return 'This code looks like a copy. Please do not use the product and report it '
            'to the brand. The unit has been locked.';
      case VerificationOutcome.recalled:
        final reason = presentation.recallReason;
        return reason == null || reason.isEmpty
            ? 'The brand recalled this product. Stop using it and return it to the seller.'
            : 'The brand recalled this product: $reason. Stop using it and return it to the seller.';
      case null:
        return 'Scan status recorded.';
    }
  }

  static String _themeColor(String? candidate) {
    final trimmed = candidate?.trim();
    if (trimmed == null || trimmed.isEmpty) return '#0f766e';
    return trimmed.startsWith('#') ? trimmed : '#$trimmed';
  }

  /// Returns a stable device fingerprint.
  ///
  /// The page stores a random id in localStorage and posts it with every form;
  /// when it is missing (for example on the first QR hit or with JavaScript
  /// disabled) a deterministic hash of the request is used instead.
  String _fingerprint(Request request, String? submitted) {
    final provided = submitted?.trim();
    if (provided != null && provided.length >= 8) return provided;
    final ip = request.remoteInfo;
    final agent = request.headers['user-agent'] ?? 'unknown';
    return 'web:${IdentityCrypto.sha256Hex('$ip|$agent').substring(0, 32)}';
  }
}
