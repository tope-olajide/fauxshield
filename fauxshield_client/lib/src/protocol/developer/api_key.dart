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
import 'package:fauxshield_client/src/protocol/protocol.dart' as _iuzkm0gn;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../enums/api_scope.dart' as _itulxfrc;

/// An API key for machine access to the workspace. Only a hash of the key is
/// stored; the plaintext is shown exactly once when the key is created.
abstract class ApiKey
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ApiKey._({
    this.id,
    required this.workspaceId,
    required this.label,
    required this.keyPrefix,
    required this.scopes,
    int? rateLimitPerMinute,
    this.lastUsedAt,
    bool? revoked,
    this.createdBy,
    DateTime? createdAt,
    this.revokedAt,
  }) : rateLimitPerMinute = rateLimitPerMinute ?? 120,
       revoked = revoked ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory ApiKey({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String label,
    required String keyPrefix,
    required List<_itulxfrc.ApiScope> scopes,
    int? rateLimitPerMinute,
    DateTime? lastUsedAt,
    bool? revoked,
    String? createdBy,
    DateTime? createdAt,
    DateTime? revokedAt,
  }) = _ApiKeyImpl;

  factory ApiKey.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApiKey(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      label: jsonSerialization['label'] as String,
      keyPrefix: jsonSerialization['keyPrefix'] as String,
      scopes: _iuzkm0gn.Protocol().deserialize<List<_itulxfrc.ApiScope>>(
        jsonSerialization['scopes'],
      ),
      rateLimitPerMinute: jsonSerialization['rateLimitPerMinute'] as int?,
      lastUsedAt: jsonSerialization['lastUsedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastUsedAt'],
            ),
      revoked: jsonSerialization['revoked'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['revoked']),
      createdBy: jsonSerialization['createdBy'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      revokedAt: jsonSerialization['revokedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['revokedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue workspaceId;

  String label;

  /// First characters of the key so operators can identify it, for example fs_live_ab12.
  String keyPrefix;

  List<_itulxfrc.ApiScope> scopes;

  int rateLimitPerMinute;

  DateTime? lastUsedAt;

  bool revoked;

  String? createdBy;

  DateTime createdAt;

  DateTime? revokedAt;

  /// Returns a shallow copy of this [ApiKey]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ApiKey copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    String? label,
    String? keyPrefix,
    List<_itulxfrc.ApiScope>? scopes,
    int? rateLimitPerMinute,
    DateTime? lastUsedAt,
    bool? revoked,
    String? createdBy,
    DateTime? createdAt,
    DateTime? revokedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApiKey',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'label': label,
      'keyPrefix': keyPrefix,
      'scopes': scopes.toJson(valueToJson: (v) => v.toJson()),
      'rateLimitPerMinute': rateLimitPerMinute,
      if (lastUsedAt != null) 'lastUsedAt': lastUsedAt?.toJson(),
      'revoked': revoked,
      if (createdBy != null) 'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApiKey',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'label': label,
      'keyPrefix': keyPrefix,
      'scopes': scopes.toJson(valueToJson: (v) => v.toJson()),
      'rateLimitPerMinute': rateLimitPerMinute,
      if (lastUsedAt != null) 'lastUsedAt': lastUsedAt?.toJson(),
      'revoked': revoked,
      if (createdBy != null) 'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApiKeyImpl extends ApiKey {
  _ApiKeyImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String label,
    required String keyPrefix,
    required List<_itulxfrc.ApiScope> scopes,
    int? rateLimitPerMinute,
    DateTime? lastUsedAt,
    bool? revoked,
    String? createdBy,
    DateTime? createdAt,
    DateTime? revokedAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         label: label,
         keyPrefix: keyPrefix,
         scopes: scopes,
         rateLimitPerMinute: rateLimitPerMinute,
         lastUsedAt: lastUsedAt,
         revoked: revoked,
         createdBy: createdBy,
         createdAt: createdAt,
         revokedAt: revokedAt,
       );

  /// Returns a shallow copy of this [ApiKey]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ApiKey copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    String? label,
    String? keyPrefix,
    List<_itulxfrc.ApiScope>? scopes,
    int? rateLimitPerMinute,
    Object? lastUsedAt = _Undefined,
    bool? revoked,
    Object? createdBy = _Undefined,
    DateTime? createdAt,
    Object? revokedAt = _Undefined,
  }) {
    return ApiKey(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      label: label ?? this.label,
      keyPrefix: keyPrefix ?? this.keyPrefix,
      scopes: scopes ?? this.scopes.map((e0) => e0).toList(),
      rateLimitPerMinute: rateLimitPerMinute ?? this.rateLimitPerMinute,
      lastUsedAt: lastUsedAt is DateTime? ? lastUsedAt : this.lastUsedAt,
      revoked: revoked ?? this.revoked,
      createdBy: createdBy is String? ? createdBy : this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      revokedAt: revokedAt is DateTime? ? revokedAt : this.revokedAt,
    );
  }
}
