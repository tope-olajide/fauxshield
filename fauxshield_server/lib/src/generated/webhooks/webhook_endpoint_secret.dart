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
import '../webhooks/webhook_endpoint.dart' as _i2lryufc;

/// Result of creating a webhook endpoint or rotating its secret. The plaintext
/// signing secret is shown exactly once.
abstract class WebhookEndpointSecret
    implements _is.SerializableModel, _is.ProtocolSerialization {
  WebhookEndpointSecret._({
    required this.endpoint,
    required this.secret,
    required this.warning,
  });

  factory WebhookEndpointSecret({
    required _i2lryufc.WebhookEndpoint endpoint,
    required String secret,
    required String warning,
  }) = _WebhookEndpointSecretImpl;

  factory WebhookEndpointSecret.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return WebhookEndpointSecret(
      endpoint: _ipgzzizd.Protocol().deserialize<_i2lryufc.WebhookEndpoint>(
        jsonSerialization['endpoint'],
      ),
      secret: jsonSerialization['secret'] as String,
      warning: jsonSerialization['warning'] as String,
    );
  }

  _i2lryufc.WebhookEndpoint endpoint;

  String secret;

  String warning;

  /// Returns a shallow copy of this [WebhookEndpointSecret]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WebhookEndpointSecret copyWith({
    _i2lryufc.WebhookEndpoint? endpoint,
    String? secret,
    String? warning,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WebhookEndpointSecret',
      'endpoint': endpoint.toJson(),
      'secret': secret,
      'warning': warning,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WebhookEndpointSecret',
      'endpoint': endpoint.toJsonForProtocol(),
      'secret': secret,
      'warning': warning,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _WebhookEndpointSecretImpl extends WebhookEndpointSecret {
  _WebhookEndpointSecretImpl({
    required _i2lryufc.WebhookEndpoint endpoint,
    required String secret,
    required String warning,
  }) : super._(
         endpoint: endpoint,
         secret: secret,
         warning: warning,
       );

  /// Returns a shallow copy of this [WebhookEndpointSecret]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WebhookEndpointSecret copyWith({
    _i2lryufc.WebhookEndpoint? endpoint,
    String? secret,
    String? warning,
  }) {
    return WebhookEndpointSecret(
      endpoint: endpoint ?? this.endpoint.copyWith(),
      secret: secret ?? this.secret,
      warning: warning ?? this.warning,
    );
  }
}
