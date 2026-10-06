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
import '../enums/recall_scope.dart' as _ikvp6e9n;

/// An immutable record of a recall action, either for a whole batch or for a
/// single identity. Verification returns the recalled outcome while active.
abstract class RecallRecord
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RecallRecord._({
    this.id,
    required this.workspaceId,
    required this.batchId,
    this.identityId,
    required this.scope,
    required this.reason,
    required this.issuedBy,
    DateTime? issuedAt,
    bool? lifted,
    this.liftedAt,
    this.liftedBy,
    this.notes,
  }) : issuedAt = issuedAt ?? DateTime.now(),
       lifted = lifted ?? false;

  factory RecallRecord({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _isc.UuidValue batchId,
    _isc.UuidValue? identityId,
    required _ikvp6e9n.RecallScope scope,
    required String reason,
    required String issuedBy,
    DateTime? issuedAt,
    bool? lifted,
    DateTime? liftedAt,
    String? liftedBy,
    String? notes,
  }) = _RecallRecordImpl;

  factory RecallRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return RecallRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      batchId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['batchId'],
      ),
      identityId: jsonSerialization['identityId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['identityId'],
            ),
      scope: _ikvp6e9n.RecallScope.fromJson(
        (jsonSerialization['scope'] as String),
      ),
      reason: jsonSerialization['reason'] as String,
      issuedBy: jsonSerialization['issuedBy'] as String,
      issuedAt: jsonSerialization['issuedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['issuedAt']),
      lifted: jsonSerialization['lifted'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['lifted']),
      liftedAt: jsonSerialization['liftedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['liftedAt']),
      liftedBy: jsonSerialization['liftedBy'] as String?,
      notes: jsonSerialization['notes'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue workspaceId;

  _isc.UuidValue batchId;

  _isc.UuidValue? identityId;

  _ikvp6e9n.RecallScope scope;

  String reason;

  String issuedBy;

  DateTime issuedAt;

  bool lifted;

  DateTime? liftedAt;

  String? liftedBy;

  String? notes;

  /// Returns a shallow copy of this [RecallRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RecallRecord copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? batchId,
    _isc.UuidValue? identityId,
    _ikvp6e9n.RecallScope? scope,
    String? reason,
    String? issuedBy,
    DateTime? issuedAt,
    bool? lifted,
    DateTime? liftedAt,
    String? liftedBy,
    String? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecallRecord',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'batchId': batchId.toJson(),
      if (identityId != null) 'identityId': identityId?.toJson(),
      'scope': scope.toJson(),
      'reason': reason,
      'issuedBy': issuedBy,
      'issuedAt': issuedAt.toJson(),
      'lifted': lifted,
      if (liftedAt != null) 'liftedAt': liftedAt?.toJson(),
      if (liftedBy != null) 'liftedBy': liftedBy,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RecallRecord',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'batchId': batchId.toJson(),
      if (identityId != null) 'identityId': identityId?.toJson(),
      'scope': scope.toJson(),
      'reason': reason,
      'issuedBy': issuedBy,
      'issuedAt': issuedAt.toJson(),
      'lifted': lifted,
      if (liftedAt != null) 'liftedAt': liftedAt?.toJson(),
      if (liftedBy != null) 'liftedBy': liftedBy,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecallRecordImpl extends RecallRecord {
  _RecallRecordImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _isc.UuidValue batchId,
    _isc.UuidValue? identityId,
    required _ikvp6e9n.RecallScope scope,
    required String reason,
    required String issuedBy,
    DateTime? issuedAt,
    bool? lifted,
    DateTime? liftedAt,
    String? liftedBy,
    String? notes,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         batchId: batchId,
         identityId: identityId,
         scope: scope,
         reason: reason,
         issuedBy: issuedBy,
         issuedAt: issuedAt,
         lifted: lifted,
         liftedAt: liftedAt,
         liftedBy: liftedBy,
         notes: notes,
       );

  /// Returns a shallow copy of this [RecallRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RecallRecord copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? batchId,
    Object? identityId = _Undefined,
    _ikvp6e9n.RecallScope? scope,
    String? reason,
    String? issuedBy,
    DateTime? issuedAt,
    bool? lifted,
    Object? liftedAt = _Undefined,
    Object? liftedBy = _Undefined,
    Object? notes = _Undefined,
  }) {
    return RecallRecord(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      batchId: batchId ?? this.batchId,
      identityId: identityId is _isc.UuidValue? ? identityId : this.identityId,
      scope: scope ?? this.scope,
      reason: reason ?? this.reason,
      issuedBy: issuedBy ?? this.issuedBy,
      issuedAt: issuedAt ?? this.issuedAt,
      lifted: lifted ?? this.lifted,
      liftedAt: liftedAt is DateTime? ? liftedAt : this.liftedAt,
      liftedBy: liftedBy is String? ? liftedBy : this.liftedBy,
      notes: notes is String? ? notes : this.notes,
    );
  }
}
