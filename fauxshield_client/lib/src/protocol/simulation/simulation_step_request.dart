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

/// Payload for the scheduled future call that advances an attack simulation.
/// Each step executes one scenario action, then schedules the next one.
abstract class SimulationStepRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SimulationStepRequest._({
    required this.simulationId,
    int? delaySeconds,
  }) : delaySeconds = delaySeconds ?? 0;

  factory SimulationStepRequest({
    required _isc.UuidValue simulationId,
    int? delaySeconds,
  }) = _SimulationStepRequestImpl;

  factory SimulationStepRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SimulationStepRequest(
      simulationId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['simulationId'],
      ),
      delaySeconds: jsonSerialization['delaySeconds'] as int?,
    );
  }

  _isc.UuidValue simulationId;

  /// Seconds until the next step should run. Zero means run immediately.
  int delaySeconds;

  /// Returns a shallow copy of this [SimulationStepRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SimulationStepRequest copyWith({
    _isc.UuidValue? simulationId,
    int? delaySeconds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SimulationStepRequest',
      'simulationId': simulationId.toJson(),
      'delaySeconds': delaySeconds,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SimulationStepRequest',
      'simulationId': simulationId.toJson(),
      'delaySeconds': delaySeconds,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SimulationStepRequestImpl extends SimulationStepRequest {
  _SimulationStepRequestImpl({
    required _isc.UuidValue simulationId,
    int? delaySeconds,
  }) : super._(
         simulationId: simulationId,
         delaySeconds: delaySeconds,
       );

  /// Returns a shallow copy of this [SimulationStepRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SimulationStepRequest copyWith({
    _isc.UuidValue? simulationId,
    int? delaySeconds,
  }) {
    return SimulationStepRequest(
      simulationId: simulationId ?? this.simulationId,
      delaySeconds: delaySeconds ?? this.delaySeconds,
    );
  }
}
