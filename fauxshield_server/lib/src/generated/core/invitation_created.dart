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
import 'package:fauxshield_server/src/generated/protocol.dart' as _ipgzzizd;
import 'package:serverpod/serverpod.dart' as _is;
import '../core/invitation.dart' as _i1srlakn;

/// Result of inviting a teammate. The invite code is shown exactly once.
abstract class InvitationCreated
    implements _is.SerializableModel, _is.ProtocolSerialization {
  InvitationCreated._({
    required this.invitation,
    required this.code,
    required this.warning,
  });

  factory InvitationCreated({
    required _i1srlakn.Invitation invitation,
    required String code,
    required String warning,
  }) = _InvitationCreatedImpl;

  factory InvitationCreated.fromJson(Map<String, dynamic> jsonSerialization) {
    return InvitationCreated(
      invitation: _ipgzzizd.Protocol().deserialize<_i1srlakn.Invitation>(
        jsonSerialization['invitation'],
      ),
      code: jsonSerialization['code'] as String,
      warning: jsonSerialization['warning'] as String,
    );
  }

  _i1srlakn.Invitation invitation;

  String code;

  String warning;

  /// Returns a shallow copy of this [InvitationCreated]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  InvitationCreated copyWith({
    _i1srlakn.Invitation? invitation,
    String? code,
    String? warning,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InvitationCreated',
      'invitation': invitation.toJson(),
      'code': code,
      'warning': warning,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InvitationCreated',
      'invitation': invitation.toJsonForProtocol(),
      'code': code,
      'warning': warning,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _InvitationCreatedImpl extends InvitationCreated {
  _InvitationCreatedImpl({
    required _i1srlakn.Invitation invitation,
    required String code,
    required String warning,
  }) : super._(
         invitation: invitation,
         code: code,
         warning: warning,
       );

  /// Returns a shallow copy of this [InvitationCreated]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  InvitationCreated copyWith({
    _i1srlakn.Invitation? invitation,
    String? code,
    String? warning,
  }) {
    return InvitationCreated(
      invitation: invitation ?? this.invitation.copyWith(),
      code: code ?? this.code,
      warning: warning ?? this.warning,
    );
  }
}
