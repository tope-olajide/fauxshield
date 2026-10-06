/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../enums/identity_status.dart' as _iqacwrhy;

/// A serialized identity for one physical unit. The QR token is bound to the
/// workspace, product, and identity through an HMAC-SHA256 signature, so a copy
/// of a token that was moved to another product or tenant fails resolution.
abstract class ProductIdentity
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProductIdentity._({
    this.id,
    required this.workspaceId,
    required this.batchId,
    required this.qrToken,
    required this.hmacSignature,
    _iqacwrhy.IdentityStatus? status,
    int? failedPinAttempts,
    this.lockedUntil,
    bool? firstVerified,
    int? verificationCount,
    this.firstVerifiedAt,
    this.lastVerifiedAt,
    this.recallReason,
    this.recalledAt,
    this.regeneratedFromId,
    this.deletedAt,
    this.deletedBy,
    this.deleteReason,
    DateTime? createdAt,
  }) : status = status ?? _iqacwrhy.IdentityStatus.active,
       failedPinAttempts = failedPinAttempts ?? 0,
       firstVerified = firstVerified ?? false,
       verificationCount = verificationCount ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory ProductIdentity({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _isc.UuidValue batchId,
    required String qrToken,
    required String hmacSignature,
    _iqacwrhy.IdentityStatus? status,
    int? failedPinAttempts,
    DateTime? lockedUntil,
    bool? firstVerified,
    int? verificationCount,
    DateTime? firstVerifiedAt,
    DateTime? lastVerifiedAt,
    String? recallReason,
    DateTime? recalledAt,
    _isc.UuidValue? regeneratedFromId,
    DateTime? deletedAt,
    String? deletedBy,
    String? deleteReason,
    DateTime? createdAt,
  }) = _ProductIdentityImpl;

  factory ProductIdentity.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductIdentity(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      batchId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['batchId'],
      ),
      qrToken: jsonSerialization['qrToken'] as String,
      hmacSignature: jsonSerialization['hmacSignature'] as String,
      status: jsonSerialization['status'] == null
          ? null
          : _iqacwrhy.IdentityStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      failedPinAttempts: jsonSerialization['failedPinAttempts'] as int?,
      lockedUntil: jsonSerialization['lockedUntil'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lockedUntil'],
            ),
      firstVerified: jsonSerialization['firstVerified'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['firstVerified']),
      verificationCount: jsonSerialization['verificationCount'] as int?,
      firstVerifiedAt: jsonSerialization['firstVerifiedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstVerifiedAt'],
            ),
      lastVerifiedAt: jsonSerialization['lastVerifiedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastVerifiedAt'],
            ),
      recallReason: jsonSerialization['recallReason'] as String?,
      recalledAt: jsonSerialization['recalledAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['recalledAt'],
            ),
      regeneratedFromId: jsonSerialization['regeneratedFromId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['regeneratedFromId'],
            ),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      deletedBy: jsonSerialization['deletedBy'] as String?,
      deleteReason: jsonSerialization['deleteReason'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue workspaceId;

  _isc.UuidValue batchId;

  /// Cryptographically random token printed as the QR payload.
  String qrToken;

  /// HMAC-SHA256 signature over workspace, product, identity, and token.
  String hmacSignature;

  _iqacwrhy.IdentityStatus status;

  int failedPinAttempts;

  DateTime? lockedUntil;

  bool firstVerified;

  int verificationCount;

  DateTime? firstVerifiedAt;

  DateTime? lastVerifiedAt;

  String? recallReason;

  DateTime? recalledAt;

  /// Identity this token was regenerated from, if the original was compromised.
  _isc.UuidValue? regeneratedFromId;

  DateTime? deletedAt;

  String? deletedBy;

  String? deleteReason;

  DateTime createdAt;

  /// Returns a shallow copy of this [ProductIdentity]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProductIdentity copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? batchId,
    String? qrToken,
    String? hmacSignature,
    _iqacwrhy.IdentityStatus? status,
    int? failedPinAttempts,
    DateTime? lockedUntil,
    bool? firstVerified,
    int? verificationCount,
    DateTime? firstVerifiedAt,
    DateTime? lastVerifiedAt,
    String? recallReason,
    DateTime? recalledAt,
    _isc.UuidValue? regeneratedFromId,
    DateTime? deletedAt,
    String? deletedBy,
    String? deleteReason,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductIdentity',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'batchId': batchId.toJson(),
      'qrToken': qrToken,
      'hmacSignature': hmacSignature,
      'status': status.toJson(),
      'failedPinAttempts': failedPinAttempts,
      if (lockedUntil != null) 'lockedUntil': lockedUntil?.toJson(),
      'firstVerified': firstVerified,
      'verificationCount': verificationCount,
      if (firstVerifiedAt != null) 'firstVerifiedAt': firstVerifiedAt?.toJson(),
      if (lastVerifiedAt != null) 'lastVerifiedAt': lastVerifiedAt?.toJson(),
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
      if (regeneratedFromId != null)
        'regeneratedFromId': regeneratedFromId?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (deletedBy != null) 'deletedBy': deletedBy,
      if (deleteReason != null) 'deleteReason': deleteReason,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductIdentity',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'batchId': batchId.toJson(),
      'qrToken': qrToken,
      'hmacSignature': hmacSignature,
      'status': status.toJson(),
      'failedPinAttempts': failedPinAttempts,
      if (lockedUntil != null) 'lockedUntil': lockedUntil?.toJson(),
      'firstVerified': firstVerified,
      'verificationCount': verificationCount,
      if (firstVerifiedAt != null) 'firstVerifiedAt': firstVerifiedAt?.toJson(),
      if (lastVerifiedAt != null) 'lastVerifiedAt': lastVerifiedAt?.toJson(),
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
      if (regeneratedFromId != null)
        'regeneratedFromId': regeneratedFromId?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (deletedBy != null) 'deletedBy': deletedBy,
      if (deleteReason != null) 'deleteReason': deleteReason,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductIdentityImpl extends ProductIdentity {
  _ProductIdentityImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _isc.UuidValue batchId,
    required String qrToken,
    required String hmacSignature,
    _iqacwrhy.IdentityStatus? status,
    int? failedPinAttempts,
    DateTime? lockedUntil,
    bool? firstVerified,
    int? verificationCount,
    DateTime? firstVerifiedAt,
    DateTime? lastVerifiedAt,
    String? recallReason,
    DateTime? recalledAt,
    _isc.UuidValue? regeneratedFromId,
    DateTime? deletedAt,
    String? deletedBy,
    String? deleteReason,
    DateTime? createdAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         batchId: batchId,
         qrToken: qrToken,
         hmacSignature: hmacSignature,
         status: status,
         failedPinAttempts: failedPinAttempts,
         lockedUntil: lockedUntil,
         firstVerified: firstVerified,
         verificationCount: verificationCount,
         firstVerifiedAt: firstVerifiedAt,
         lastVerifiedAt: lastVerifiedAt,
         recallReason: recallReason,
         recalledAt: recalledAt,
         regeneratedFromId: regeneratedFromId,
         deletedAt: deletedAt,
         deletedBy: deletedBy,
         deleteReason: deleteReason,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ProductIdentity]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProductIdentity copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? batchId,
    String? qrToken,
    String? hmacSignature,
    _iqacwrhy.IdentityStatus? status,
    int? failedPinAttempts,
    Object? lockedUntil = _Undefined,
    bool? firstVerified,
    int? verificationCount,
    Object? firstVerifiedAt = _Undefined,
    Object? lastVerifiedAt = _Undefined,
    Object? recallReason = _Undefined,
    Object? recalledAt = _Undefined,
    Object? regeneratedFromId = _Undefined,
    Object? deletedAt = _Undefined,
    Object? deletedBy = _Undefined,
    Object? deleteReason = _Undefined,
    DateTime? createdAt,
  }) {
    return ProductIdentity(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      batchId: batchId ?? this.batchId,
      qrToken: qrToken ?? this.qrToken,
      hmacSignature: hmacSignature ?? this.hmacSignature,
      status: status ?? this.status,
      failedPinAttempts: failedPinAttempts ?? this.failedPinAttempts,
      lockedUntil: lockedUntil is DateTime? ? lockedUntil : this.lockedUntil,
      firstVerified: firstVerified ?? this.firstVerified,
      verificationCount: verificationCount ?? this.verificationCount,
      firstVerifiedAt: firstVerifiedAt is DateTime?
          ? firstVerifiedAt
          : this.firstVerifiedAt,
      lastVerifiedAt: lastVerifiedAt is DateTime?
          ? lastVerifiedAt
          : this.lastVerifiedAt,
      recallReason: recallReason is String? ? recallReason : this.recallReason,
      recalledAt: recalledAt is DateTime? ? recalledAt : this.recalledAt,
      regeneratedFromId: regeneratedFromId is _isc.UuidValue?
          ? regeneratedFromId
          : this.regeneratedFromId,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      deletedBy: deletedBy is String? ? deletedBy : this.deletedBy,
      deleteReason: deleteReason is String? ? deleteReason : this.deleteReason,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
