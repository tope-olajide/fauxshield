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

/// Identity level statistics for one batch, used by the batch detail screen.
abstract class BatchStats
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  BatchStats._({
    required this.batchId,
    required this.totalIdentities,
    required this.active,
    required this.verified,
    required this.locked,
    required this.recalled,
    required this.deleted,
    required this.flagged,
    required this.generatedAt,
  });

  factory BatchStats({
    required _isc.UuidValue batchId,
    required int totalIdentities,
    required int active,
    required int verified,
    required int locked,
    required int recalled,
    required int deleted,
    required int flagged,
    required DateTime generatedAt,
  }) = _BatchStatsImpl;

  factory BatchStats.fromJson(Map<String, dynamic> jsonSerialization) {
    return BatchStats(
      batchId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['batchId'],
      ),
      totalIdentities: jsonSerialization['totalIdentities'] as int,
      active: jsonSerialization['active'] as int,
      verified: jsonSerialization['verified'] as int,
      locked: jsonSerialization['locked'] as int,
      recalled: jsonSerialization['recalled'] as int,
      deleted: jsonSerialization['deleted'] as int,
      flagged: jsonSerialization['flagged'] as int,
      generatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
    );
  }

  _isc.UuidValue batchId;

  int totalIdentities;

  int active;

  int verified;

  int locked;

  int recalled;

  int deleted;

  /// Distinct units in this batch that carry fraud signals.
  int flagged;

  DateTime generatedAt;

  /// Returns a shallow copy of this [BatchStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  BatchStats copyWith({
    _isc.UuidValue? batchId,
    int? totalIdentities,
    int? active,
    int? verified,
    int? locked,
    int? recalled,
    int? deleted,
    int? flagged,
    DateTime? generatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BatchStats',
      'batchId': batchId.toJson(),
      'totalIdentities': totalIdentities,
      'active': active,
      'verified': verified,
      'locked': locked,
      'recalled': recalled,
      'deleted': deleted,
      'flagged': flagged,
      'generatedAt': generatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BatchStats',
      'batchId': batchId.toJson(),
      'totalIdentities': totalIdentities,
      'active': active,
      'verified': verified,
      'locked': locked,
      'recalled': recalled,
      'deleted': deleted,
      'flagged': flagged,
      'generatedAt': generatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _BatchStatsImpl extends BatchStats {
  _BatchStatsImpl({
    required _isc.UuidValue batchId,
    required int totalIdentities,
    required int active,
    required int verified,
    required int locked,
    required int recalled,
    required int deleted,
    required int flagged,
    required DateTime generatedAt,
  }) : super._(
         batchId: batchId,
         totalIdentities: totalIdentities,
         active: active,
         verified: verified,
         locked: locked,
         recalled: recalled,
         deleted: deleted,
         flagged: flagged,
         generatedAt: generatedAt,
       );

  /// Returns a shallow copy of this [BatchStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  BatchStats copyWith({
    _isc.UuidValue? batchId,
    int? totalIdentities,
    int? active,
    int? verified,
    int? locked,
    int? recalled,
    int? deleted,
    int? flagged,
    DateTime? generatedAt,
  }) {
    return BatchStats(
      batchId: batchId ?? this.batchId,
      totalIdentities: totalIdentities ?? this.totalIdentities,
      active: active ?? this.active,
      verified: verified ?? this.verified,
      locked: locked ?? this.locked,
      recalled: recalled ?? this.recalled,
      deleted: deleted ?? this.deleted,
      flagged: flagged ?? this.flagged,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }
}
