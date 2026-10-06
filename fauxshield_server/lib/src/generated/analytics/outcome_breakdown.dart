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
import '../enums/verification_outcome.dart' as _iq7ze9sg;

abstract class OutcomeBreakdown
    implements _is.SerializableModel, _is.ProtocolSerialization {
  OutcomeBreakdown._({
    required this.outcome,
    required this.count,
  });

  factory OutcomeBreakdown({
    required _iq7ze9sg.VerificationOutcome outcome,
    required int count,
  }) = _OutcomeBreakdownImpl;

  factory OutcomeBreakdown.fromJson(Map<String, dynamic> jsonSerialization) {
    return OutcomeBreakdown(
      outcome: _iq7ze9sg.VerificationOutcome.fromJson(
        (jsonSerialization['outcome'] as String),
      ),
      count: jsonSerialization['count'] as int,
    );
  }

  _iq7ze9sg.VerificationOutcome outcome;

  int count;

  /// Returns a shallow copy of this [OutcomeBreakdown]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  OutcomeBreakdown copyWith({
    _iq7ze9sg.VerificationOutcome? outcome,
    int? count,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OutcomeBreakdown',
      'outcome': outcome.toJson(),
      'count': count,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OutcomeBreakdown',
      'outcome': outcome.toJson(),
      'count': count,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _OutcomeBreakdownImpl extends OutcomeBreakdown {
  _OutcomeBreakdownImpl({
    required _iq7ze9sg.VerificationOutcome outcome,
    required int count,
  }) : super._(
         outcome: outcome,
         count: count,
       );

  /// Returns a shallow copy of this [OutcomeBreakdown]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  OutcomeBreakdown copyWith({
    _iq7ze9sg.VerificationOutcome? outcome,
    int? count,
  }) {
    return OutcomeBreakdown(
      outcome: outcome ?? this.outcome,
      count: count ?? this.count,
    );
  }
}
