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
import 'package:serverpod/serverpod.dart' as _is;

/// A fake product report queued on the device while offline and sent when
/// connectivity returns.
abstract class QueuedFakeReport
    implements _is.SerializableModel, _is.ProtocolSerialization {
  QueuedFakeReport._({
    this.id,
    required this.identityId,
    required this.qrToken,
    required this.reason,
    this.comment,
    this.photoLocalPath,
    DateTime? createdAt,
    bool? synced,
    this.syncedAt,
    this.lastError,
  }) : createdAt = createdAt ?? DateTime.now(),
       synced = synced ?? false;

  factory QueuedFakeReport({
    _is.UuidValue? id,
    required _is.UuidValue identityId,
    required String qrToken,
    required String reason,
    String? comment,
    String? photoLocalPath,
    DateTime? createdAt,
    bool? synced,
    DateTime? syncedAt,
    String? lastError,
  }) = _QueuedFakeReportImpl;

  factory QueuedFakeReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return QueuedFakeReport(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      identityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['identityId'],
      ),
      qrToken: jsonSerialization['qrToken'] as String,
      reason: jsonSerialization['reason'] as String,
      comment: jsonSerialization['comment'] as String?,
      photoLocalPath: jsonSerialization['photoLocalPath'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      synced: jsonSerialization['synced'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['synced']),
      syncedAt: jsonSerialization['syncedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['syncedAt']),
      lastError: jsonSerialization['lastError'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _is.UuidValue? id;

  _is.UuidValue identityId;

  String qrToken;

  String reason;

  String? comment;

  String? photoLocalPath;

  DateTime createdAt;

  bool synced;

  DateTime? syncedAt;

  String? lastError;

  /// Returns a shallow copy of this [QueuedFakeReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  QueuedFakeReport copyWith({
    _is.UuidValue? id,
    _is.UuidValue? identityId,
    String? qrToken,
    String? reason,
    String? comment,
    String? photoLocalPath,
    DateTime? createdAt,
    bool? synced,
    DateTime? syncedAt,
    String? lastError,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QueuedFakeReport',
      if (id != null) 'id': id?.toJson(),
      'identityId': identityId.toJson(),
      'qrToken': qrToken,
      'reason': reason,
      if (comment != null) 'comment': comment,
      if (photoLocalPath != null) 'photoLocalPath': photoLocalPath,
      'createdAt': createdAt.toJson(),
      'synced': synced,
      if (syncedAt != null) 'syncedAt': syncedAt?.toJson(),
      if (lastError != null) 'lastError': lastError,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QueuedFakeReport',
      if (id != null) 'id': id?.toJson(),
      'identityId': identityId.toJson(),
      'qrToken': qrToken,
      'reason': reason,
      if (comment != null) 'comment': comment,
      if (photoLocalPath != null) 'photoLocalPath': photoLocalPath,
      'createdAt': createdAt.toJson(),
      'synced': synced,
      if (syncedAt != null) 'syncedAt': syncedAt?.toJson(),
      if (lastError != null) 'lastError': lastError,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QueuedFakeReportImpl extends QueuedFakeReport {
  _QueuedFakeReportImpl({
    _is.UuidValue? id,
    required _is.UuidValue identityId,
    required String qrToken,
    required String reason,
    String? comment,
    String? photoLocalPath,
    DateTime? createdAt,
    bool? synced,
    DateTime? syncedAt,
    String? lastError,
  }) : super._(
         id: id,
         identityId: identityId,
         qrToken: qrToken,
         reason: reason,
         comment: comment,
         photoLocalPath: photoLocalPath,
         createdAt: createdAt,
         synced: synced,
         syncedAt: syncedAt,
         lastError: lastError,
       );

  /// Returns a shallow copy of this [QueuedFakeReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  QueuedFakeReport copyWith({
    Object? id = _Undefined,
    _is.UuidValue? identityId,
    String? qrToken,
    String? reason,
    Object? comment = _Undefined,
    Object? photoLocalPath = _Undefined,
    DateTime? createdAt,
    bool? synced,
    Object? syncedAt = _Undefined,
    Object? lastError = _Undefined,
  }) {
    return QueuedFakeReport(
      id: id is _is.UuidValue? ? id : this.id,
      identityId: identityId ?? this.identityId,
      qrToken: qrToken ?? this.qrToken,
      reason: reason ?? this.reason,
      comment: comment is String? ? comment : this.comment,
      photoLocalPath: photoLocalPath is String?
          ? photoLocalPath
          : this.photoLocalPath,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
      syncedAt: syncedAt is DateTime? ? syncedAt : this.syncedAt,
      lastError: lastError is String? ? lastError : this.lastError,
    );
  }
}
