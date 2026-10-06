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
import '../enums/verification_error_reason.dart' as _i9xcs559;
import '../protocol.dart' as _iv35mfmj;
part 'authentication_exception.dart';
part 'conflict_exception.dart';
part 'not_found_exception.dart';
part 'rate_limit_exception.dart';
part 'service_unavailable_exception.dart';
part 'validation_exception.dart';
part 'verification_exception.dart';

/// Base class for every typed failure the API returns to clients. Sealed so
/// apps get exhaustiveness checking when they handle failures.
sealed class ApiException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  ApiException({
    required this.message,
    String? code,
  }) : code = code ?? 'api_error';

  String message;

  String code;

  /// Returns a shallow copy of this [ApiException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ApiException copyWith({
    String? message,
    String? code,
  });
}

class _Undefined {}
