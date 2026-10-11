import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../generated/protocol.dart';
import '../services/fake_report_service.dart';
import '../services/live_events.dart';
import '../services/rbac.dart';
import '../services/verification_service.dart';
import '../services/workspace_service.dart';

/// The verification flow.
///
/// Consumer calls are unauthenticated by design: a shopper scans a QR code on
/// a product without an account. Every call after the first is addressed by a
/// session id plus the device fingerprint that created the session, and only
/// allow-listed `VerificationPresentation` data ever leaves the server.
class VerificationEndpoint extends Endpoint {
  VerificationService get _service => VerificationService();

  /// Resolves a scanned QR token and returns the consumer facing state.
  @unauthenticatedClientCall
  Future<VerificationPresentation> start(
    Session session,
    String token,
    String deviceFingerprint,
  ) async {
    final verification = await _service.resolveToken(
      session,
      token: token,
      deviceFingerprint: deviceFingerprint,
      source: ScanSource.consumerWeb,
    );
    return _service.presentation(
      session,
      sessionId: verification.id!,
      deviceFingerprint: deviceFingerprint,
    );
  }

  /// Moves a resolved session to the PIN prompt.
  @unauthenticatedClientCall
  Future<VerificationPresentation> acknowledge(
    Session session,
    UuidValue sessionId,
    String deviceFingerprint,
  ) async {
    var verification = await _service.presentation(
      session,
      sessionId: sessionId,
      deviceFingerprint: deviceFingerprint,
    );
    if (verification.state == VerificationState.tokenResolved) {
      await _service.advanceState(
        session,
        sessionId: sessionId,
        deviceFingerprint: deviceFingerprint,
        targetState: VerificationState.pinPrompted,
      );
    }
    return _service.presentation(
      session,
      sessionId: sessionId,
      deviceFingerprint: deviceFingerprint,
    );
  }

  /// Submits the packaging PIN and returns the final outcome.
  @unauthenticatedClientCall
  Future<VerificationPresentation> submitPin(
    Session session,
    UuidValue sessionId,
    String deviceFingerprint,
    String pin,
  ) async {
    var verification = await _service.presentation(
      session,
      sessionId: sessionId,
      deviceFingerprint: deviceFingerprint,
    );
    if (verification.state == VerificationState.tokenResolved) {
      await _service.advanceState(
        session,
        sessionId: sessionId,
        deviceFingerprint: deviceFingerprint,
        targetState: VerificationState.pinPrompted,
      );
      verification = await _service.presentation(
        session,
        sessionId: sessionId,
        deviceFingerprint: deviceFingerprint,
      );
    }
    if (verification.state == VerificationState.pinPrompted) {
      await _service.advanceState(
        session,
        sessionId: sessionId,
        deviceFingerprint: deviceFingerprint,
        targetState: VerificationState.pinSubmitted,
      );
      await _service.submitPin(
        session,
        sessionId: sessionId,
        deviceFingerprint: deviceFingerprint,
        pin: pin,
      );
    }
    return _service.presentation(
      session,
      sessionId: sessionId,
      deviceFingerprint: deviceFingerprint,
    );
  }

  /// Re-reads the current state of a session, for page refreshes.
  @unauthenticatedClientCall
  Future<VerificationPresentation> result(
    Session session,
    UuidValue sessionId,
    String deviceFingerprint,
  ) {
    return _service.presentation(
      session,
      sessionId: sessionId,
      deviceFingerprint: deviceFingerprint,
    );
  }

  /// Reports a suspicious product from the verification result screen.
  ///
  /// Reports are rate limited per device and feed the brand's triage queue.
  @unauthenticatedClientCall
  Future<ReportAcknowledgement> reportFake(
    Session session,
    UuidValue sessionId,
    String deviceFingerprint,
    String reason, {
    String? comment,
  }) async {
    final verification = await VerificationSession.db.findById(
      session,
      sessionId,
    );
    if (verification == null ||
        verification.deviceFingerprint != deviceFingerprint) {
      throw VerificationException(
        message: 'Verification session not found. Scan the code again.',
        reason: VerificationErrorReason.sessionNotFound,
      );
    }
    return FakeReportService.create(
      session,
      verification: verification,
      deviceFingerprint: deviceFingerprint,
      reason: reason,
      comment: comment,
    );
  }

  /// Lists verification sessions for the operator console.
  Future<List<VerificationSession>> list(
    Session session, {
    UuidValue? workspaceId,
    UuidValue? identityId,
    UuidValue? batchId,
    UuidValue? productId,
    VerificationState? state,
    VerificationOutcome? outcome,
    RiskScore? riskScore,
    ScanSource? source,
    DateTime? from,
    DateTime? to,
    int page = 0,
    int pageSize = 25,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.verificationsRead);
    final size = pageSize.clamp(1, FauxShieldLimits.maxVerificationPageSize);
    final offset = (page < 0 ? 0 : page) * size;

    Set<UuidValue>? scopedIdentityIds;
    if (batchId != null) {
      final identities = await ProductIdentity.db.find(
        session,
        where: (t) => t.batchId.equals(batchId),
        limit: 5000,
      );
      if (identities.isEmpty) return <VerificationSession>[];
      scopedIdentityIds = identities.map((identity) => identity.id!).toSet();
    } else if (productId != null) {
      // Product scoping resolves through the product's batches, then their
      // identities, so the session query stays a single table scan.
      final batches = await Batch.db.find(
        session,
        where: (t) => t.productId.equals(productId),
        limit: 500,
      );
      if (batches.isEmpty) return <VerificationSession>[];
      final batchIds = batches.map((batch) => batch.id!).toSet();
      final identities = await ProductIdentity.db.find(
        session,
        where: (t) => t.batchId.inSet(batchIds),
        limit: 20000,
      );
      if (identities.isEmpty) return <VerificationSession>[];
      scopedIdentityIds = identities.map((identity) => identity.id!).toSet();
    }

    return VerificationSession.db.find(
      session,
      where: (t) {
        var expression = t.workspaceId.equals(context.workspaceId);
        if (identityId != null) {
          expression = expression & t.identityId.equals(identityId);
        }
        final scopedIds = scopedIdentityIds;
        if (scopedIds != null) {
          expression = expression & t.identityId.inSet(scopedIds);
        }
        if (state != null) {
          expression = expression & t.state.equals(state);
        }
        if (outcome != null) {
          expression = expression & t.outcome.equals(outcome);
        }
        if (riskScore != null) {
          expression = expression & t.riskScore.equals(riskScore);
        }
        if (source != null) {
          expression = expression & t.source.equals(source);
        }
        if (from != null) {
          expression = expression & (t.createdAt >= from.toUtc());
        }
        if (to != null) {
          expression = expression & (t.createdAt < to.toUtc());
        }
        return expression;
      },
      orderBy: (t) => t.createdAt.desc(),
      limit: size,
      offset: offset,
    );
  }

  /// Loads one verification session.
  Future<VerificationSession> get(Session session, UuidValue sessionId) async {
    final verification = await VerificationSession.db.findById(
      session,
      sessionId,
    );
    if (verification == null) {
      throw NotFoundException(
        message: 'Verification session not found.',
        resource: 'verification_session',
      );
    }
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: verification.workspaceId,
    );
    WorkspaceService.require(context, Permission.verificationsRead);
    return verification;
  }

  /// Streams live command center events for the workspace.
  ///
  /// The stream receives verifications, alerts, recalls, offline ingest, and
  /// simulation progress as they happen.
  Stream<LiveEvent> watchWorkspace(
    Session session, {
    UuidValue? workspaceId,
  }) async* {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.verificationsRead);
    final channel = session.messages.createStream<LiveEvent>(
      LiveEvents.channelFor(context.workspaceId),
    );
    await for (final event in channel) {
      yield event;
    }
  }
}
