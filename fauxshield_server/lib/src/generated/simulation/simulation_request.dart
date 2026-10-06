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
import '../enums/simulation_type.dart' as _i8tlthbq;

/// Parameters for starting an attack simulation.
abstract class SimulationRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SimulationRequest._({
    required this.type,
    this.label,
    this.batchId,
    this.steps,
    this.stepDelaySeconds,
  });

  factory SimulationRequest({
    required _i8tlthbq.SimulationType type,
    String? label,
    _is.UuidValue? batchId,
    int? steps,
    int? stepDelaySeconds,
  }) = _SimulationRequestImpl;

  factory SimulationRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return SimulationRequest(
      type: _i8tlthbq.SimulationType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      label: jsonSerialization['label'] as String?,
      batchId: jsonSerialization['batchId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['batchId']),
      steps: jsonSerialization['steps'] as int?,
      stepDelaySeconds: jsonSerialization['stepDelaySeconds'] as int?,
    );
  }

  _i8tlthbq.SimulationType type;

  /// Optional label shown in the command center.
  String? label;

  /// Optional batch to target. When omitted a batch is picked automatically.
  _is.UuidValue? batchId;

  /// Number of simulated scan steps. Defaults per scenario when null.
  int? steps;

  /// Delay between steps in seconds. Defaults to a fast demo pace.
  int? stepDelaySeconds;

  /// Returns a shallow copy of this [SimulationRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SimulationRequest copyWith({
    _i8tlthbq.SimulationType? type,
    String? label,
    _is.UuidValue? batchId,
    int? steps,
    int? stepDelaySeconds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SimulationRequest',
      'type': type.toJson(),
      if (label != null) 'label': label,
      if (batchId != null) 'batchId': batchId?.toJson(),
      if (steps != null) 'steps': steps,
      if (stepDelaySeconds != null) 'stepDelaySeconds': stepDelaySeconds,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SimulationRequest',
      'type': type.toJson(),
      if (label != null) 'label': label,
      if (batchId != null) 'batchId': batchId?.toJson(),
      if (steps != null) 'steps': steps,
      if (stepDelaySeconds != null) 'stepDelaySeconds': stepDelaySeconds,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SimulationRequestImpl extends SimulationRequest {
  _SimulationRequestImpl({
    required _i8tlthbq.SimulationType type,
    String? label,
    _is.UuidValue? batchId,
    int? steps,
    int? stepDelaySeconds,
  }) : super._(
         type: type,
         label: label,
         batchId: batchId,
         steps: steps,
         stepDelaySeconds: stepDelaySeconds,
       );

  /// Returns a shallow copy of this [SimulationRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SimulationRequest copyWith({
    _i8tlthbq.SimulationType? type,
    Object? label = _Undefined,
    Object? batchId = _Undefined,
    Object? steps = _Undefined,
    Object? stepDelaySeconds = _Undefined,
  }) {
    return SimulationRequest(
      type: type ?? this.type,
      label: label is String? ? label : this.label,
      batchId: batchId is _is.UuidValue? ? batchId : this.batchId,
      steps: steps is int? ? steps : this.steps,
      stepDelaySeconds: stepDelaySeconds is int?
          ? stepDelaySeconds
          : this.stepDelaySeconds,
    );
  }
}
