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

/// Result of generating identities for a batch.
abstract class IdentityGenerationResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  IdentityGenerationResult._({
    required this.batchId,
    required this.requested,
    required this.created,
    required this.startedAt,
    required this.completedAt,
  });

  factory IdentityGenerationResult({
    required _is.UuidValue batchId,
    required int requested,
    required int created,
    required DateTime startedAt,
    required DateTime completedAt,
  }) = _IdentityGenerationResultImpl;

  factory IdentityGenerationResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return IdentityGenerationResult(
      batchId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['batchId'],
      ),
      requested: jsonSerialization['requested'] as int,
      created: jsonSerialization['created'] as int,
      startedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      completedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['completedAt'],
      ),
    );
  }

  _is.UuidValue batchId;

  int requested;

  int created;

  DateTime startedAt;

  DateTime completedAt;

  /// Returns a shallow copy of this [IdentityGenerationResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IdentityGenerationResult copyWith({
    _is.UuidValue? batchId,
    int? requested,
    int? created,
    DateTime? startedAt,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IdentityGenerationResult',
      'batchId': batchId.toJson(),
      'requested': requested,
      'created': created,
      'startedAt': startedAt.toJson(),
      'completedAt': completedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IdentityGenerationResult',
      'batchId': batchId.toJson(),
      'requested': requested,
      'created': created,
      'startedAt': startedAt.toJson(),
      'completedAt': completedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _IdentityGenerationResultImpl extends IdentityGenerationResult {
  _IdentityGenerationResultImpl({
    required _is.UuidValue batchId,
    required int requested,
    required int created,
    required DateTime startedAt,
    required DateTime completedAt,
  }) : super._(
         batchId: batchId,
         requested: requested,
         created: created,
         startedAt: startedAt,
         completedAt: completedAt,
       );

  /// Returns a shallow copy of this [IdentityGenerationResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IdentityGenerationResult copyWith({
    _is.UuidValue? batchId,
    int? requested,
    int? created,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return IdentityGenerationResult(
      batchId: batchId ?? this.batchId,
      requested: requested ?? this.requested,
      created: created ?? this.created,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
