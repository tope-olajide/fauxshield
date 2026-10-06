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

/// Postgres backed idempotency record. Create operations accept a client
/// supplied key and replay the stored response instead of duplicating work.
abstract class IdempotencyRecord
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  IdempotencyRecord._({
    this.id,
    required this.workspaceId,
    required this.idempotencyKey,
    required this.operation,
    required this.requestHash,
    DateTime? createdAt,
    required this.expiresAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory IdempotencyRecord({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String idempotencyKey,
    required String operation,
    required String requestHash,
    DateTime? createdAt,
    required DateTime expiresAt,
  }) = _IdempotencyRecordImpl;

  factory IdempotencyRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return IdempotencyRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      idempotencyKey: jsonSerialization['idempotencyKey'] as String,
      operation: jsonSerialization['operation'] as String,
      requestHash: jsonSerialization['requestHash'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue workspaceId;

  /// Composed key of workspace, operation, and caller supplied value.
  String idempotencyKey;

  String operation;

  String requestHash;

  DateTime createdAt;

  DateTime expiresAt;

  /// Returns a shallow copy of this [IdempotencyRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  IdempotencyRecord copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    String? idempotencyKey,
    String? operation,
    String? requestHash,
    DateTime? createdAt,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IdempotencyRecord',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'idempotencyKey': idempotencyKey,
      'operation': operation,
      'requestHash': requestHash,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IdempotencyRecord',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'idempotencyKey': idempotencyKey,
      'operation': operation,
      'requestHash': requestHash,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IdempotencyRecordImpl extends IdempotencyRecord {
  _IdempotencyRecordImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String idempotencyKey,
    required String operation,
    required String requestHash,
    DateTime? createdAt,
    required DateTime expiresAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         idempotencyKey: idempotencyKey,
         operation: operation,
         requestHash: requestHash,
         createdAt: createdAt,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [IdempotencyRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  IdempotencyRecord copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    String? idempotencyKey,
    String? operation,
    String? requestHash,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return IdempotencyRecord(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      operation: operation ?? this.operation,
      requestHash: requestHash ?? this.requestHash,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
