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
import '../developer/api_key.dart' as _ioqqduad;

/// Result of creating an API key. The plaintext secret is shown exactly once
/// and never stored in recoverable form.
abstract class ApiKeySecret
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ApiKeySecret._({
    required this.apiKey,
    required this.secret,
    required this.warning,
  });

  factory ApiKeySecret({
    required _ioqqduad.ApiKey apiKey,
    required String secret,
    required String warning,
  }) = _ApiKeySecretImpl;

  factory ApiKeySecret.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApiKeySecret(
      apiKey: _ipgzzizd.Protocol().deserialize<_ioqqduad.ApiKey>(
        jsonSerialization['apiKey'],
      ),
      secret: jsonSerialization['secret'] as String,
      warning: jsonSerialization['warning'] as String,
    );
  }

  _ioqqduad.ApiKey apiKey;

  String secret;

  String warning;

  /// Returns a shallow copy of this [ApiKeySecret]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ApiKeySecret copyWith({
    _ioqqduad.ApiKey? apiKey,
    String? secret,
    String? warning,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApiKeySecret',
      'apiKey': apiKey.toJson(),
      'secret': secret,
      'warning': warning,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApiKeySecret',
      'apiKey': apiKey.toJsonForProtocol(),
      'secret': secret,
      'warning': warning,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ApiKeySecretImpl extends ApiKeySecret {
  _ApiKeySecretImpl({
    required _ioqqduad.ApiKey apiKey,
    required String secret,
    required String warning,
  }) : super._(
         apiKey: apiKey,
         secret: secret,
         warning: warning,
       );

  /// Returns a shallow copy of this [ApiKeySecret]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ApiKeySecret copyWith({
    _ioqqduad.ApiKey? apiKey,
    String? secret,
    String? warning,
  }) {
    return ApiKeySecret(
      apiKey: apiKey ?? this.apiKey.copyWith(),
      secret: secret ?? this.secret,
      warning: warning ?? this.warning,
    );
  }
}
