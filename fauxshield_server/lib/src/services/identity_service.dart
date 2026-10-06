import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../core/identity_crypto.dart';
import '../generated/protocol.dart';
import 'audit_service.dart';
import 'platform_keys.dart';

/// Generates and manages serialized product identities.
///
/// * QR tokens carry 128 bits of randomness and are signed with HMAC-SHA256
///   binding workspace, product, identity, and token. A token copied to another
///   product or tenant fails resolution.
/// * PINs are hashed with PBKDF2 for storage and encrypted with AES-256-GCM,
///   bound to the identity, so only an authorized audited operation can read
///   them back for packaging.
/// * Batch generation takes a row lock on the batch so a concurrent recall can
///   never race a generation run.
class IdentityService {
  IdentityService({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  static const int _chunkSize = 1000;
  static const int _pinHashIterations = 30000;
  static const int _maxGeneratePerCall = 5000;

  String _aad(UuidValue workspaceId, UuidValue identityId) =>
      '${workspaceId.uuid}:${identityId.uuid}';

  /// Signs a QR token for one identity.
  String signToken(
    Session session, {
    required String token,
    required UuidValue workspaceId,
    required UuidValue productId,
    required UuidValue identityId,
  }) {
    return IdentityCrypto.signToken(
      secret: PlatformKeys.hmacSecret(session),
      workspaceId: workspaceId.uuid,
      productId: productId.uuid,
      identityId: identityId.uuid,
      token: token,
    );
  }

  /// Verifies a token signature with a constant time comparison.
  bool verifySignature(
    Session session, {
    required String token,
    required String signature,
    required UuidValue workspaceId,
    required UuidValue productId,
    required UuidValue identityId,
  }) {
    return IdentityCrypto.verifyTokenSignature(
      secret: PlatformKeys.hmacSecret(session),
      workspaceId: workspaceId.uuid,
      productId: productId.uuid,
      identityId: identityId.uuid,
      token: token,
      signature: signature,
    );
  }

  /// Generates [quantity] identities for a non-recalled batch.
  ///
  /// The batch row is locked for the duration of the transaction, mirroring
  /// recall, so a recalled batch can never receive new active identities.
  Future<IdentityGenerationResult> generateForBatch(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue batchId,
    required int quantity,
    required String actorIdentifier,
  }) async {
    if (quantity < 1 || quantity > _maxGeneratePerCall) {
      throw ValidationException(
        message: 'Quantity must be between 1 and $_maxGeneratePerCall.',
        field: 'quantity',
      );
    }

    final startedAt = DateTime.now().toUtc();
    final hmacSecret = PlatformKeys.hmacSecret(session);
    final pinKey = PlatformKeys.pinEncryptionKey(session);

    var created = 0;
    await session.db.transaction((tx) async {
      final batch = await Batch.db.findById(
        session,
        batchId,
        transaction: tx,
        lockMode: LockMode.forUpdate,
      );
      if (batch == null || batch.workspaceId != workspaceId) {
        throw NotFoundException(message: 'Batch not found.', resource: 'batch');
      }
      if (batch.status == BatchStatus.recalled) {
        throw ConflictException(
          message: 'Cannot generate identities for a recalled batch.',
          resource: 'batch',
        );
      }

      var remaining = quantity;
      var attempts = 0;
      while (remaining > 0 && attempts < 20) {
        attempts++;
        final chunk = remaining > _chunkSize ? _chunkSize : remaining;
        final rows = <ProductIdentity>[];
        for (var i = 0; i < chunk; i++) {
          final identityId = _uuid.v4obj();
          final token = IdentityCrypto.generateQrToken();
          final signature = IdentityCrypto.signToken(
            secret: hmacSecret,
            workspaceId: workspaceId.uuid,
            productId: batch.productId.uuid,
            identityId: identityId.uuid,
            token: token,
          );
          final pin = IdentityCrypto.generateSecurePin(
            length: FauxShieldLimits.pinLength,
          );
          final pinHash = await IdentityCrypto.hashPin(
            pin,
            iterations: _pinHashIterations,
          );
          final ciphertext = await IdentityCrypto.encryptPin(
            pin: pin,
            keyHex: pinKey,
            aad: _aad(workspaceId, identityId),
          );
          rows.add(
            ProductIdentity(
              id: identityId,
              workspaceId: workspaceId,
              batchId: batchId,
              qrToken: token,
              hmacSignature: signature,
              pinHash: pinHash,
              pinCiphertext: ciphertext,
              status: IdentityStatus.active,
              createdAt: DateTime.now().toUtc(),
            ),
          );
        }

        // ignoreConflicts lets the globally unique token index stay
        // authoritative: any collided row is skipped and retried with fresh
        // randomness in the next round.
        final inserted = await ProductIdentity.db.insert(
          session,
          rows,
          transaction: tx,
          ignoreConflicts: true,
        );
        created += inserted.length;
        remaining = quantity - created;
      }

      if (created < quantity) {
        throw ConflictException(
          message: 'Could not generate all identities, please retry.',
          resource: 'identity',
        );
      }

      await AuditService.record(
        session,
        workspaceId: workspaceId,
        action: 'identity.generated',
        targetType: 'batch',
        targetId: batchId,
        actorType: ActorType.user,
        actorIdentifier: actorIdentifier,
        metadata: <String, dynamic>{
          'batch_id': batchId.uuid,
          'quantity': created,
        },
        transaction: tx,
      );
    });

    return IdentityGenerationResult(
      batchId: batchId,
      requested: quantity,
      created: created,
      startedAt: startedAt,
      completedAt: DateTime.now().toUtc(),
    );
  }

  /// Reveals the PIN for an identity. Only reachable from an authorized,
  /// audited operator operation.
  Future<RevealedPin> revealPin(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue identityId,
    required String actorIdentifier,
  }) async {
    final identity = await ProductIdentity.db.findById(session, identityId);
    if (identity == null ||
        identity.workspaceId != workspaceId ||
        identity.deletedAt != null) {
      throw NotFoundException(
        message: 'Identity not found.',
        resource: 'identity',
      );
    }
    final ciphertext = identity.pinCiphertext;
    if (ciphertext == null) {
      throw NotFoundException(
        message: 'This identity has no retrievable PIN.',
        resource: 'identity',
      );
    }
    final pin = await IdentityCrypto.decryptPin(
      ciphertext: ciphertext,
      keyHex: PlatformKeys.pinEncryptionKey(session),
      aad: _aad(workspaceId, identityId),
    );
    if (pin == null) {
      throw ConflictException(
        message: 'The PIN could not be decrypted with the configured key.',
        resource: 'identity',
      );
    }
    await AuditService.record(
      session,
      workspaceId: workspaceId,
      action: 'identity.pin_revealed',
      targetType: 'identity',
      targetId: identityId,
      actorType: ActorType.user,
      actorIdentifier: actorIdentifier,
    );
    return RevealedPin(
      identityId: identityId,
      pin: pin,
      revealedAt: DateTime.now().toUtc(),
    );
  }

  /// Issues a fresh QR token and signature for an identity.
  ///
  /// Used when a printed code is compromised: the physical unit keeps its
  /// identity and PIN, while the old token stops resolving immediately.
  Future<ProductIdentity> regenerateToken(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue identityId,
    required String actorIdentifier,
    String? reason,
  }) async {
    final identity = await ProductIdentity.db.findById(session, identityId);
    if (identity == null ||
        identity.workspaceId != workspaceId ||
        identity.deletedAt != null) {
      throw NotFoundException(
        message: 'Identity not found.',
        resource: 'identity',
      );
    }
    final batch = await Batch.db.findById(session, identity.batchId);
    if (batch == null) {
      throw NotFoundException(message: 'Batch not found.', resource: 'batch');
    }

    final newToken = IdentityCrypto.generateQrToken();
    final newSignature = signToken(
      session,
      token: newToken,
      workspaceId: workspaceId,
      productId: batch.productId,
      identityId: identityId,
    );

    final updated = identity.copyWith(
      qrToken: newToken,
      hmacSignature: newSignature,
      regeneratedFromId: identity.regeneratedFromId,
      status: identity.status == IdentityStatus.regenerated
          ? IdentityStatus.active
          : identity.status,
    );
    final saved = await ProductIdentity.db.updateRow(session, updated);

    await AuditService.record(
      session,
      workspaceId: workspaceId,
      action: 'identity.token_regenerated',
      targetType: 'identity',
      targetId: identityId,
      actorType: ActorType.user,
      actorIdentifier: actorIdentifier,
      metadata: <String, dynamic>{
        'old_token': IdentityCrypto.maskToken(identity.qrToken),
        'new_token': IdentityCrypto.maskToken(newToken),
        'reason': reason,
      },
    );
    return saved;
  }

  /// Soft deletes an identity. Verification stops resolving it immediately.
  Future<ProductIdentity> softDelete(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue identityId,
    required String actorIdentifier,
    String? reason,
  }) async {
    final identity = await ProductIdentity.db.findById(session, identityId);
    if (identity == null || identity.workspaceId != workspaceId) {
      throw NotFoundException(
        message: 'Identity not found.',
        resource: 'identity',
      );
    }
    final updated = identity.copyWith(
      deletedAt: DateTime.now().toUtc(),
      deletedBy: actorIdentifier,
      deleteReason: reason,
      status: IdentityStatus.deleted,
    );
    final saved = await ProductIdentity.db.updateRow(session, updated);
    await AuditService.record(
      session,
      workspaceId: workspaceId,
      action: 'identity.deleted',
      targetType: 'identity',
      targetId: identityId,
      actorType: ActorType.user,
      actorIdentifier: actorIdentifier,
      metadata: <String, dynamic>{'reason': reason},
    );
    return saved;
  }

  /// Restores a soft deleted identity to active status.
  Future<ProductIdentity> restore(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue identityId,
    required String actorIdentifier,
  }) async {
    final identity = await ProductIdentity.db.findById(session, identityId);
    if (identity == null || identity.workspaceId != workspaceId) {
      throw NotFoundException(
        message: 'Identity not found.',
        resource: 'identity',
      );
    }
    if (identity.deletedAt == null) {
      return identity;
    }
    final updated = identity.copyWith(
      deletedAt: null,
      deletedBy: null,
      deleteReason: null,
      status: IdentityStatus.active,
    );
    final saved = await ProductIdentity.db.updateRow(session, updated);
    await AuditService.record(
      session,
      workspaceId: workspaceId,
      action: 'identity.restored',
      targetType: 'identity',
      targetId: identityId,
      actorType: ActorType.user,
      actorIdentifier: actorIdentifier,
    );
    return saved;
  }
}
