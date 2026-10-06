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
import '../recall/recall_record.dart' as _iencp73h;

/// Result of issuing or lifting a recall, including how many units changed state.
abstract class RecallResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RecallResult._({
    required this.recall,
    required this.affected,
  });

  factory RecallResult({
    required _iencp73h.RecallRecord recall,
    required int affected,
  }) = _RecallResultImpl;

  factory RecallResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return RecallResult(
      recall: _iuzkm0gn.Protocol().deserialize<_iencp73h.RecallRecord>(
        jsonSerialization['recall'],
      ),
      affected: jsonSerialization['affected'] as int,
    );
  }

  _iencp73h.RecallRecord recall;

  int affected;

  /// Returns a shallow copy of this [RecallResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RecallResult copyWith({
    _iencp73h.RecallRecord? recall,
    int? affected,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecallResult',
      'recall': recall.toJson(),
      'affected': affected,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RecallResult',
      'recall': recall.toJsonForProtocol(),
      'affected': affected,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _RecallResultImpl extends RecallResult {
  _RecallResultImpl({
    required _iencp73h.RecallRecord recall,
    required int affected,
  }) : super._(
         recall: recall,
         affected: affected,
       );

  /// Returns a shallow copy of this [RecallResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RecallResult copyWith({
    _iencp73h.RecallRecord? recall,
    int? affected,
  }) {
    return RecallResult(
      recall: recall ?? this.recall.copyWith(),
      affected: affected ?? this.affected,
    );
  }
}
