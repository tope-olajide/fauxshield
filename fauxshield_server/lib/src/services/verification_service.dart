import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../core/geo_dataset.dart';
import '../core/identity_crypto.dart';
import '../core/public_url.dart';
import '../generated/protocol.dart';
import 'alert_service.dart';
import 'audit_service.dart';
import 'fraud_engine.dart';
import 'fraud_rules.dart';
import 'geo_service.dart';
import 'live_events.dart';
import 'platform_keys.dart';
import 'webhook_service.dart';
import 'workspace_service.dart';

/// The stateful consumer verification flow.
///
/// ```text
/// token_resolved -> pin_prompted -> pin_submitted -> result_determined
/// ```
///
/// * Sessions are bound to a device fingerprint and expire after 15 minutes of
///   inactivity. Every state change renews the window, so a refresh or a short
///   network drop can recover the session instead of restarting.
/// * Fraud evaluation runs once, before the session can advance to PIN entry.
///   A `FRAUD_SUSPECTED` result jumps straight to the final state, so a cloned
///   code never reaches the PIN prompt.
/// * PIN submission is protected by a per-identity lockout after five failed
///   attempts, and each failure escalates through the fraud pipeline.
/// * Outcome precedence is `RECALLED` > `FRAUD_SUSPECTED` > `INVALID_PIN` >
///   `HIGH_RISK` > `ALREADY_VERIFIED` > `AUTHENTIC`.
class VerificationService {
  VerificationService({FraudEngine? fraudEngine, GeoService? geoService})
    : _fraudEngine = fraudEngine ?? FraudEngine(),
      _geoService = geoService ?? GeoService();

  final FraudEngine _fraudEngine;
  final GeoService _geoService;

  /// Resolves a QR token into a verification session.
  ///
  /// Token resolution is the only place the platform accepts an untrusted
  /// token. Everything after this point is addressed by session id plus the
  /// device fingerprint that created the session.
  Future<VerificationSession> resolveToken(
    Session session, {
    required String token,
    required String deviceFingerprint,
    ScanSource source = ScanSource.consumerWeb,
    String? ipOverride,
    GeoResult? locationOverride,
    UuidValue? offlineScanId,
    UuidValue? simulationId,
    List<SignalAssessment> extraSignals = const <SignalAssessment>[],
  }) async {
    final normalized = token.trim().toLowerCase();
    if (normalized.length < 16) {
      throw VerificationException(
        message: 'That code does not look like a FauxShield code.',
        reason: VerificationErrorReason.tokenInvalid,
      );
    }

    final identity = await ProductIdentity.db.findFirstRow(
      session,
      where: (t) => t.qrToken.equals(normalized) & t.deletedAt.equals(null),
    );
    if (identity == null) {
      throw VerificationException(
        message: 'This code is not registered by any brand on FauxShield.',
        reason: VerificationErrorReason.tokenNotFound,
      );
    }

    final batch = await Batch.db.findById(session, identity.batchId);
    if (batch == null) {
      throw VerificationException(
        message: 'This code is not registered by any brand on FauxShield.',
        reason: VerificationErrorReason.tokenNotFound,
      );
    }

    // Signature check binds the token to workspace, product, and identity.
    final signatureOk = IdentityCrypto.verifyTokenSignature(
      secret: PlatformKeys.hmacSecret(session),
      workspaceId: identity.workspaceId.uuid,
      productId: batch.productId.uuid,
      identityId: identity.id!.uuid,
      token: identity.qrToken,
      signature: identity.hmacSignature,
    );
    if (!signatureOk) {
      await AuditService.record(
        session,
        workspaceId: identity.workspaceId,
        action: 'verification.token_integrity_failed',
        targetType: 'product_identity',
        targetId: identity.id,
        actorType: ActorType.consumer,
        metadata: <String, dynamic>{
          'token': IdentityCrypto.maskToken(normalized),
          'source': source.name,
        },
        ipAddress: ipOverride ?? _remoteIp(session),
      );
      throw VerificationException(
        message:
            'This code failed its integrity check. Treat the product as suspicious.',
        reason: VerificationErrorReason.tokenInvalid,
      );
    }

    final workspace = await WorkspaceResolver.resolve(
      session,
      identity.workspaceId,
    );
    final ip = ipOverride ?? _remoteIp(session);
    final location =
        locationOverride ??
        (await _geoService.resolveLocation(session, ip)) ??
        const GeoResult(country: 'Unknown', countryCode: '', city: 'Unknown');

    // Replay protection: a refresh from the same device recovers the live
    // session instead of burning a new one.
    final existing = await VerificationSession.db.findFirstRow(
      session,
      where: (t) =>
          t.identityId.equals(identity.id!) &
          t.qrToken.equals(normalized) &
          t.deviceFingerprint.equals(deviceFingerprint) &
          (t.expiresAt > DateTime.now().toUtc()) &
          t.state.notEquals(VerificationState.resultDetermined),
      orderBy: (t) => t.createdAt.desc(),
    );
    if (existing != null) {
      return existing;
    }

    final recalled = identity.status == IdentityStatus.recalled;
    final locked = identity.status == IdentityStatus.locked;

    final now = DateTime.now().toUtc();
    var verificationSession = VerificationSession(
      workspaceId: identity.workspaceId,
      identityId: identity.id!,
      qrToken: normalized,
      deviceFingerprint: deviceFingerprint,
      ipAddress: ip,
      country: location.country,
      countryCode: location.countryCode,
      city: location.city,
      latitude: location.latitude,
      longitude: location.longitude,
      state: recalled || locked
          ? VerificationState.resultDetermined
          : VerificationState.tokenResolved,
      outcome: recalled
          ? VerificationOutcome.recalled
          : locked
          ? VerificationOutcome.fraudSuspected
          : null,
      source: source,
      offlineScanId: offlineScanId,
      simulationId: simulationId,
      createdAt: now,
      lastStateChange: now,
      expiresAt: now.add(FauxShieldLimits.sessionExpiry),
      completedAt: recalled || locked ? now : null,
    );
    verificationSession = await VerificationSession.db.insertRow(
      session,
      verificationSession,
    );

    await _recordTransition(
      session,
      verificationSession,
      previous: null,
      next: verificationSession.state,
      actorType: ActorType.consumer,
    );

    // Fraud evaluation runs before the consumer can reach the PIN prompt.
    if (verificationSession.state == VerificationState.tokenResolved) {
      verificationSession = await _applyFraudAssessment(
        session,
        verificationSession: verificationSession,
        identity: identity,
        batch: batch,
        workspace: workspace,
        extraSignals: extraSignals,
      );
    }

    return verificationSession;
  }

  /// Advances a fingerprint-bound session one step in the state machine.
  ///
  /// Transitions renew the inactivity window. Skipping states or moving
  /// backwards is rejected with [VerificationErrorReason.invalidState].
  Future<VerificationSession> advanceState(
    Session session, {
    required UuidValue sessionId,
    required String deviceFingerprint,
    required VerificationState targetState,
  }) async {
    final current = await _loadBoundSession(
      session,
      sessionId: sessionId,
      deviceFingerprint: deviceFingerprint,
    );
    if (!_isValidTransition(current.state, targetState)) {
      throw VerificationException(
        message:
            'Cannot move from ${current.state.name} to ${targetState.name}.',
        reason: VerificationErrorReason.invalidState,
      );
    }

    final now = DateTime.now().toUtc();
    final updated = await VerificationSession.db.updateRow(
      session,
      current.copyWith(
        state: targetState,
        lastStateChange: now,
        expiresAt: now.add(FauxShieldLimits.sessionExpiry),
      ),
    );
    await _recordTransition(
      session,
      updated,
      previous: current.state,
      next: targetState,
      actorType: ActorType.consumer,
    );
    return updated;
  }

  /// Verifies the consumer's PIN and determines the outcome.
  ///
  /// The identity row is locked for the duration of the transaction so
  /// concurrent PIN attempts cannot race the lockout counter.
  Future<VerificationSession> submitPin(
    Session session, {
    required UuidValue sessionId,
    required String deviceFingerprint,
    required String pin,
  }) async {
    if (pin.length != FauxShieldLimits.pinLength || int.tryParse(pin) == null) {
      throw ValidationException(
        message:
            'Enter the ${FauxShieldLimits.pinLength} digit PIN from the packaging.',
        field: 'pin',
      );
    }

    final current = await _loadBoundSession(
      session,
      sessionId: sessionId,
      deviceFingerprint: deviceFingerprint,
    );
    if (current.state != VerificationState.pinSubmitted) {
      throw VerificationException(
        message:
            'PIN submission requires the session to be in pinSubmitted state.',
        reason: VerificationErrorReason.invalidState,
      );
    }

    late VerificationSession result;
    late ProductIdentity identityAfter;
    var pinWasCorrect = false;
    var lockoutTriggered = false;

    await session.db.transaction((tx) async {
      final identity = await ProductIdentity.db.findById(
        session,
        current.identityId,
        transaction: tx,
        lockMode: LockMode.forUpdate,
      );
      if (identity == null || identity.deletedAt != null) {
        throw VerificationException(
          message: 'This code is no longer registered.',
          reason: VerificationErrorReason.tokenNotFound,
        );
      }

      final now = DateTime.now().toUtc();
      final lockedUntil = identity.lockedUntil;
      if (lockedUntil != null && lockedUntil.isAfter(now)) {
        throw VerificationException(
          message:
              'Too many wrong PINs. Try again in ${_minutesUntil(lockedUntil)} minutes.',
          reason: VerificationErrorReason.pinLockout,
        );
      }

      final pinHash = identity.pinHash;
      pinWasCorrect =
          pinHash != null && await IdentityCrypto.verifyPin(pin, pinHash);

      var updatedIdentity = identity;
      if (pinWasCorrect) {
        updatedIdentity = identity.copyWith(
          firstVerified: true,
          failedPinAttempts: 0,
          lockedUntil: null,
          verificationCount: identity.verificationCount + 1,
          firstVerifiedAt: identity.firstVerifiedAt ?? now,
          lastVerifiedAt: now,
        );
      } else {
        final attempts = identity.failedPinAttempts + 1;
        lockoutTriggered = attempts >= FauxShieldLimits.pinLockoutThreshold;
        updatedIdentity = identity.copyWith(
          failedPinAttempts: attempts,
          lockedUntil: lockoutTriggered
              ? now.add(FauxShieldLimits.pinLockoutDuration)
              : null,
        );
      }
      await ProductIdentity.db.updateRow(
        session,
        updatedIdentity,
        transaction: tx,
      );
      identityAfter = updatedIdentity;

      // Outcome precedence: recall and fraud lock override everything.
      late VerificationOutcome outcome;
      if (updatedIdentity.status == IdentityStatus.recalled) {
        outcome = VerificationOutcome.recalled;
      } else if (updatedIdentity.status == IdentityStatus.locked) {
        outcome = VerificationOutcome.fraudSuspected;
      } else if (!pinWasCorrect) {
        outcome = VerificationOutcome.invalidPin;
      } else if (identity.firstVerified || identity.verificationCount > 0) {
        outcome = VerificationOutcome.alreadyVerified;
      } else {
        outcome = VerificationOutcome.authentic;
      }

      result = await VerificationSession.db.updateRow(
        session,
        current.copyWith(
          state: VerificationState.resultDetermined,
          outcome: outcome,
          lastStateChange: now,
          expiresAt: now.add(FauxShieldLimits.sessionExpiry),
          completedAt: now,
        ),
        transaction: tx,
      );

      await AuditService.record(
        session,
        workspaceId: current.workspaceId,
        action: 'verification.pin_${pinWasCorrect ? 'accepted' : 'rejected'}',
        targetType: 'verification_session',
        targetId: current.id,
        actorType: ActorType.consumer,
        metadata: <String, dynamic>{
          'outcome': outcome.name,
          'failed_attempts': updatedIdentity.failedPinAttempts,
          'lockout': lockoutTriggered,
        },
        ipAddress: current.ipAddress,
        transaction: tx,
      );
    });

    // Post-processing outside the transaction: fraud escalation, alerts,
    // webhooks, and live events.
    await _postVerification(
      session,
      verificationSession: result,
      identity: identityAfter,
      pinWasCorrect: pinWasCorrect,
      lockoutTriggered: lockoutTriggered,
    );

    return result;
  }

  /// Finalizes a scan that does not use a consumer PIN, such as a field
  /// inspector scan captured offline and later synchronized.
  ///
  /// The outcome is derived from recall state, the fraud risk score, and
  /// whether the identity had ever been verified before:
  /// `recalled` > `fraudSuspected` > `highRisk` > `alreadyVerified` >
  /// `authentic`.
  Future<VerificationSession> finalizeInspectorScan(
    Session session, {
    required UuidValue sessionId,
    required String deviceFingerprint,
  }) async {
    final current = await _loadBoundSession(
      session,
      sessionId: sessionId,
      deviceFingerprint: deviceFingerprint,
    );
    if (current.state == VerificationState.resultDetermined) {
      return current;
    }

    final identity = await ProductIdentity.db.findById(
      session,
      current.identityId,
    );
    if (identity == null || identity.deletedAt != null) {
      throw VerificationException(
        message: 'This code is no longer registered.',
        reason: VerificationErrorReason.tokenNotFound,
      );
    }
    final batch = await Batch.db.findById(session, identity.batchId);
    if (batch == null) {
      throw VerificationException(
        message: 'This code is no longer registered.',
        reason: VerificationErrorReason.tokenNotFound,
      );
    }
    final workspace = await WorkspaceResolver.resolve(
      session,
      identity.workspaceId,
    );

    final outcome = _inspectorOutcome(current, identity);
    final now = DateTime.now().toUtc();
    final updated = await VerificationSession.db.updateRow(
      session,
      current.copyWith(
        state: VerificationState.resultDetermined,
        outcome: outcome,
        lastStateChange: now,
        completedAt: now,
        expiresAt: now.add(FauxShieldLimits.sessionExpiry),
      ),
    );
    await _recordTransition(
      session,
      updated,
      previous: current.state,
      next: VerificationState.resultDetermined,
      actorType: ActorType.system,
    );
    await AuditService.record(
      session,
      workspaceId: current.workspaceId,
      action: 'verification.inspector_finalized',
      targetType: 'verification_session',
      targetId: current.id,
      actorType: ActorType.system,
      metadata: <String, dynamic>{
        'outcome': outcome.name,
        'risk_score': current.riskScore?.name,
        'source': current.source.name,
      },
      ipAddress: current.ipAddress,
    );
    await _publishCompletion(
      session,
      verificationSession: updated,
      identity: identity,
      batch: batch,
      workspace: workspace,
    );
    return updated;
  }

  static VerificationOutcome _inspectorOutcome(
    VerificationSession verificationSession,
    ProductIdentity identity,
  ) {
    if (identity.status == IdentityStatus.recalled) {
      return VerificationOutcome.recalled;
    }
    if (identity.status == IdentityStatus.locked ||
        verificationSession.riskScore == RiskScore.fraudSuspected) {
      return VerificationOutcome.fraudSuspected;
    }
    if (verificationSession.riskScore == RiskScore.high) {
      return VerificationOutcome.highRisk;
    }
    if (identity.firstVerified || identity.verificationCount > 0) {
      return VerificationOutcome.alreadyVerified;
    }
    return VerificationOutcome.authentic;
  }

  /// Runs the fraud engine for a session and persists what it finds.
  ///
  /// A `FRAUD_SUSPECTED` score jumps straight to `result_determined`, so a
  /// cloned code never reaches the PIN prompt.
  Future<VerificationSession> _applyFraudAssessment(
    Session session, {
    required VerificationSession verificationSession,
    required ProductIdentity identity,
    required Batch batch,
    required Workspace workspace,
    List<SignalAssessment> extraSignals = const <SignalAssessment>[],
  }) async {
    FraudEvaluation evaluation;
    try {
      evaluation = await _fraudEngine
          .evaluate(
            session,
            verificationSession: verificationSession,
            identity: identity,
            batch: batch,
            workspace: workspace,
            extraSignals: extraSignals,
          )
          .timeout(FauxShieldLimits.fraudEvaluationBudget);
    } on TimeoutException {
      // A slow evaluation must never block a consumer verification. The
      // session continues, and the skipped checks are logged for operators.
      await AuditService.record(
        session,
        workspaceId: verificationSession.workspaceId,
        action: 'fraud.evaluation_timeout',
        targetType: 'verification_session',
        targetId: verificationSession.id,
        actorType: ActorType.system,
        metadata: <String, dynamic>{
          'budget_ms': FauxShieldLimits.fraudEvaluationBudget.inMilliseconds,
        },
      );
      return verificationSession;
    }

    final now = DateTime.now().toUtc();
    if (evaluation.signals.isNotEmpty) {
      final rows = evaluation.signals
          .map(
            (signal) => FraudSignalRecord(
              workspaceId: verificationSession.workspaceId,
              sessionId: verificationSession.id!,
              identityId: identity.id!,
              batchId: batch.id!,
              type: signal.type,
              severity: signal.severity,
              dataJson: jsonEncode(<String, dynamic>{
                'reasons': signal.reasons,
                'source': verificationSession.source.name,
              }),
              detectedAt: now,
            ),
          )
          .toList();
      await FraudSignalRecord.db.insert(session, rows);

      for (final signal in evaluation.signals) {
        await AuditService.record(
          session,
          workspaceId: verificationSession.workspaceId,
          action: 'fraud.signal_detected',
          targetType: 'verification_session',
          targetId: verificationSession.id,
          actorType: ActorType.system,
          metadata: <String, dynamic>{
            'signal_type': signal.type.name,
            'severity': signal.severity.name,
            'reasons': signal.reasons,
          },
        );
      }
    }

    var updated = verificationSession;
    if (evaluation.riskScore != RiskScore.low) {
      updated = await VerificationSession.db.updateRow(
        session,
        updated.copyWith(riskScore: evaluation.riskScore),
      );
      await AuditService.record(
        session,
        workspaceId: verificationSession.workspaceId,
        action: 'verification.risk_assessed',
        targetType: 'verification_session',
        targetId: verificationSession.id,
        actorType: ActorType.system,
        metadata: <String, dynamic>{
          'risk_score': evaluation.riskScore.name,
          'signal_count': evaluation.signals.length,
          'skipped': evaluation.skippedSignals,
        },
      );
    }

    final alert = await AlertService.createFromAssessment(
      session,
      workspace: workspace,
      assessment: evaluation,
      identity: identity,
      batch: batch,
      verificationSession: updated,
      sourceLabel: 'source: ${updated.source.name}',
    );

    if (evaluation.riskScore == RiskScore.fraudSuspected) {
      updated = await VerificationSession.db.updateRow(
        session,
        updated.copyWith(
          state: VerificationState.resultDetermined,
          outcome: VerificationOutcome.fraudSuspected,
          lastStateChange: now,
          completedAt: now,
        ),
      );
      await _recordTransition(
        session,
        updated,
        previous: VerificationState.tokenResolved,
        next: VerificationState.resultDetermined,
        actorType: ActorType.system,
      );
      await _publishCompletion(
        session,
        verificationSession: updated,
        identity: identity,
        batch: batch,
        workspace: workspace,
      );
    }

    if (alert != null) {
      await AuditService.record(
        session,
        workspaceId: verificationSession.workspaceId,
        action: 'fraud.alert_linked',
        targetType: 'verification_session',
        targetId: verificationSession.id,
        actorType: ActorType.system,
        metadata: <String, dynamic>{'alert_id': alert.id!.uuid},
      );
    }

    return updated;
  }

  /// Fraud escalation and side effects after a PIN submission.
  Future<void> _postVerification(
    Session session, {
    required VerificationSession verificationSession,
    required ProductIdentity identity,
    required bool pinWasCorrect,
    required bool lockoutTriggered,
  }) async {
    final batch = await Batch.db.findById(session, identity.batchId);
    if (batch == null) return;
    final workspace = await WorkspaceResolver.resolve(
      session,
      identity.workspaceId,
    );

    final extra = <SignalAssessment>[];
    if (!pinWasCorrect) {
      extra.add(
        SignalAssessment(
          type: SignalType.pinAttack,
          severity: signalSeverity(SignalType.pinAttack),
          reasons: <String>[
            'Wrong PIN submitted (attempt ${identity.failedPinAttempts})',
          ],
        ),
      );
    }
    if (lockoutTriggered) {
      extra.add(
        SignalAssessment(
          type: SignalType.pinLockout,
          severity: signalSeverity(SignalType.pinLockout),
          reasons: <String>[
            'Identity locked for ${FauxShieldLimits.pinLockoutDuration.inMinutes} minutes '
                'after ${identity.failedPinAttempts} failed attempts',
          ],
        ),
      );
      await AuditService.record(
        session,
        workspaceId: identity.workspaceId,
        action: 'identity.pin_lockout',
        targetType: 'identity',
        targetId: identity.id,
        actorType: ActorType.system,
        metadata: <String, dynamic>{
          'failed_attempts': identity.failedPinAttempts,
          'locked_until': identity.lockedUntil?.toIso8601String(),
        },
      );
    }

    if (extra.isNotEmpty) {
      final evaluation = await _fraudEngine.evaluate(
        session,
        verificationSession: verificationSession,
        identity: identity,
        batch: batch,
        workspace: workspace,
        extraSignals: extra,
      );
      final now = DateTime.now().toUtc();
      final rows = evaluation.signals
          .map(
            (signal) => FraudSignalRecord(
              workspaceId: verificationSession.workspaceId,
              sessionId: verificationSession.id!,
              identityId: identity.id!,
              batchId: batch.id!,
              type: signal.type,
              severity: signal.severity,
              dataJson: jsonEncode(<String, dynamic>{
                'reasons': signal.reasons,
                'source': verificationSession.source.name,
              }),
              detectedAt: now,
            ),
          )
          .toList();
      if (rows.isNotEmpty) {
        await FraudSignalRecord.db.insert(session, rows);
      }
      if (evaluation.riskScore != RiskScore.low) {
        await VerificationSession.db.updateRow(
          session,
          verificationSession.copyWith(riskScore: evaluation.riskScore),
        );
      }
      await AlertService.createFromAssessment(
        session,
        workspace: workspace,
        assessment: evaluation,
        identity: identity,
        batch: batch,
        verificationSession: verificationSession,
        sourceLabel: 'post-PIN signal',
      );
    }

    await _publishCompletion(
      session,
      verificationSession: verificationSession,
      identity: identity,
      batch: batch,
      workspace: workspace,
    );
  }

  /// Publishes the live event and webhook for a finished verification.
  Future<void> _publishCompletion(
    Session session, {
    required VerificationSession verificationSession,
    required ProductIdentity identity,
    required Batch batch,
    required Workspace workspace,
  }) async {
    final outcome = verificationSession.outcome;
    await LiveEvents.publish(
      session,
      workspaceId: verificationSession.workspaceId,
      type: LiveEventType.verificationCompleted,
      title: _outcomeTitle(outcome),
      subtitle: '${workspace.name} · ${batch.reference}',
      outcome: outcome,
      riskScore: verificationSession.riskScore,
      country: verificationSession.country,
      countryCode: verificationSession.countryCode,
      city: verificationSession.city,
      latitude: verificationSession.latitude,
      longitude: verificationSession.longitude,
      identityId: identity.id,
      sessionId: verificationSession.id,
      batchId: batch.id,
      payload: <String, dynamic>{
        'source': verificationSession.source.name,
        'first_verified': identity.firstVerified,
      },
    );

    await WebhookService.enqueue(
      session,
      workspaceId: verificationSession.workspaceId,
      eventType: WebhookEventType.verificationCompleted,
      payload: <String, dynamic>{
        'session_id': verificationSession.id!.uuid,
        'identity_id': identity.id!.uuid,
        'batch_id': batch.id!.uuid,
        'outcome': outcome?.name,
        'risk_score': verificationSession.riskScore?.name,
        'source': verificationSession.source.name,
        'country': verificationSession.country,
        'city': verificationSession.city,
        'occurred_at': verificationSession.lastStateChange.toIso8601String(),
      },
    );
  }

  /// Builds the allow-listed presentation a consumer is allowed to see.
  Future<VerificationPresentation> presentation(
    Session session, {
    required UuidValue sessionId,
    required String deviceFingerprint,
    String? verifyUrl,
  }) async {
    final verificationSession = await _loadBoundSession(
      session,
      sessionId: sessionId,
      deviceFingerprint: deviceFingerprint,
    );
    final identity = await ProductIdentity.db.findById(
      session,
      verificationSession.identityId,
    );
    if (identity == null) {
      throw VerificationException(
        message: 'This code is no longer registered.',
        reason: VerificationErrorReason.tokenNotFound,
      );
    }
    final batch = await Batch.db.findById(session, identity.batchId);
    if (batch == null) {
      throw VerificationException(
        message: 'This code is no longer registered.',
        reason: VerificationErrorReason.tokenNotFound,
      );
    }
    final product = await Product.db.findById(session, batch.productId);
    final workspace = await WorkspaceResolver.resolve(
      session,
      identity.workspaceId,
    );

    final recalled =
        identity.recalledAt != null ||
        batch.recalledAt != null ||
        identity.status == IdentityStatus.recalled;

    return VerificationPresentation(
      sessionId: verificationSession.id!,
      state: verificationSession.state,
      outcome: verificationSession.outcome,
      riskScore: verificationSession.riskScore,
      verifiedAt: verificationSession.createdAt,
      firstVerified: identity.firstVerified,
      verificationCount: identity.verificationCount,
      location: GeoSummary(
        country: verificationSession.country,
        countryCode: verificationSession.countryCode,
        city: verificationSession.city,
        latitude: verificationSession.latitude,
        longitude: verificationSession.longitude,
      ),
      branding: workspace.branding,
      workspaceName: workspace.name,
      authenticMessage: workspace.authenticMessage,
      productName: product?.name ?? 'Unknown product',
      description: product?.description,
      sku: product?.sku,
      batchReference: batch.reference,
      imageUrls: absoluteWebUrls(session, product?.imageUrls),
      packaging: product?.packaging,
      shelfLife: product?.shelfLife,
      countryRestrictions: product?.countryRestrictions,
      safetyInstructions: product?.safetyInstructions,
      recallReason: identity.recallReason ?? batch.recallReason,
      recalledAt: identity.recalledAt ?? batch.recalledAt,
      recallScope: recalled
          ? (identity.recallReason != null
                ? RecallScope.instance
                : RecallScope.batch)
          : null,
      tokenMasked: IdentityCrypto.maskToken(identity.qrToken),
      verifyUrl: verifyUrl,
    );
  }

  /// Loads a session that is bound to [deviceFingerprint] and still alive.
  Future<VerificationSession> _loadBoundSession(
    Session session, {
    required UuidValue sessionId,
    required String deviceFingerprint,
  }) async {
    final verificationSession = await VerificationSession.db.findById(
      session,
      sessionId,
    );
    if (verificationSession == null ||
        verificationSession.deviceFingerprint != deviceFingerprint) {
      throw VerificationException(
        message: 'Verification session not found. Scan the code again.',
        reason: VerificationErrorReason.sessionNotFound,
      );
    }
    if (verificationSession.expiresAt.isBefore(DateTime.now().toUtc())) {
      throw VerificationException(
        message: 'This verification session expired. Scan the code again.',
        reason: VerificationErrorReason.sessionExpired,
      );
    }
    return verificationSession;
  }

  Future<void> _recordTransition(
    Session session,
    VerificationSession verificationSession, {
    required VerificationState? previous,
    required VerificationState next,
    required ActorType actorType,
  }) {
    return AuditService.record(
      session,
      workspaceId: verificationSession.workspaceId,
      action: 'verification.state_changed',
      targetType: 'verification_session',
      targetId: verificationSession.id,
      actorType: actorType,
      metadata: <String, dynamic>{
        'previous_state': previous?.name,
        'new_state': next.name,
        'outcome': verificationSession.outcome?.name,
        'source': verificationSession.source.name,
      },
      ipAddress: verificationSession.ipAddress,
    );
  }

  static bool _isValidTransition(VerificationState from, VerificationState to) {
    const order = <VerificationState>[
      VerificationState.tokenResolved,
      VerificationState.pinPrompted,
      VerificationState.pinSubmitted,
      VerificationState.resultDetermined,
    ];
    final fromIndex = order.indexOf(from);
    final toIndex = order.indexOf(to);
    if (fromIndex < 0 || toIndex < 0) return false;
    return toIndex == fromIndex + 1;
  }

  static String _outcomeTitle(VerificationOutcome? outcome) {
    switch (outcome) {
      case VerificationOutcome.authentic:
        return 'Authentic product verified';
      case VerificationOutcome.alreadyVerified:
        return 'Product verified again';
      case VerificationOutcome.invalidPin:
        return 'Wrong PIN submitted';
      case VerificationOutcome.fraudSuspected:
        return 'Fraud suspected';
      case VerificationOutcome.highRisk:
        return 'High risk verification';
      case VerificationOutcome.recalled:
        return 'Recalled product scanned';
      case null:
        return 'Verification update';
    }
  }

  static int _minutesUntil(DateTime moment) {
    final remaining = moment.difference(DateTime.now().toUtc()).inSeconds;
    if (remaining <= 0) return 0;
    return (remaining / 60).ceil();
  }

  static String? _remoteIp(Session session) {
    try {
      return session.request?.remoteInfo;
    } catch (_) {
      return null;
    }
  }
}
