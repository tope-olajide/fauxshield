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
import '../enums/simulation_status.dart' as _i3nrcxzu;
import '../enums/simulation_type.dart' as _i8tlthbq;

/// A scripted attack simulation run. Brands rehearse their fraud response
/// against realistic attack patterns; the platform produces real verification
/// sessions, real signals, and real alerts that flow through the normal pipeline.
abstract class AttackSimulation
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AttackSimulation._({
    this.id,
    required this.workspaceId,
    required this.type,
    _i3nrcxzu.SimulationStatus? status,
    this.label,
    this.paramsJson,
    int? progress,
    int? totalSteps,
    this.summaryJson,
    required this.createdBy,
    DateTime? createdAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
  }) : status = status ?? _i3nrcxzu.SimulationStatus.queued,
       progress = progress ?? 0,
       totalSteps = totalSteps ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory AttackSimulation({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _i8tlthbq.SimulationType type,
    _i3nrcxzu.SimulationStatus? status,
    String? label,
    String? paramsJson,
    int? progress,
    int? totalSteps,
    String? summaryJson,
    required String createdBy,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
  }) = _AttackSimulationImpl;

  factory AttackSimulation.fromJson(Map<String, dynamic> jsonSerialization) {
    return AttackSimulation(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      type: _i8tlthbq.SimulationType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      status: jsonSerialization['status'] == null
          ? null
          : _i3nrcxzu.SimulationStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      label: jsonSerialization['label'] as String?,
      paramsJson: jsonSerialization['paramsJson'] as String?,
      progress: jsonSerialization['progress'] as int?,
      totalSteps: jsonSerialization['totalSteps'] as int?,
      summaryJson: jsonSerialization['summaryJson'] as String?,
      createdBy: jsonSerialization['createdBy'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
      cancelledAt: jsonSerialization['cancelledAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['cancelledAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue workspaceId;

  _i8tlthbq.SimulationType type;

  _i3nrcxzu.SimulationStatus status;

  String? label;

  /// Simulation specific parameters serialized as JSON.
  String? paramsJson;

  int progress;

  int totalSteps;

  /// Result summary serialized as JSON.
  String? summaryJson;

  String createdBy;

  DateTime createdAt;

  DateTime? startedAt;

  DateTime? completedAt;

  DateTime? cancelledAt;

  /// Returns a shallow copy of this [AttackSimulation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AttackSimulation copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    _i8tlthbq.SimulationType? type,
    _i3nrcxzu.SimulationStatus? status,
    String? label,
    String? paramsJson,
    int? progress,
    int? totalSteps,
    String? summaryJson,
    String? createdBy,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AttackSimulation',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'type': type.toJson(),
      'status': status.toJson(),
      if (label != null) 'label': label,
      if (paramsJson != null) 'paramsJson': paramsJson,
      'progress': progress,
      'totalSteps': totalSteps,
      if (summaryJson != null) 'summaryJson': summaryJson,
      'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AttackSimulation',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'type': type.toJson(),
      'status': status.toJson(),
      if (label != null) 'label': label,
      if (paramsJson != null) 'paramsJson': paramsJson,
      'progress': progress,
      'totalSteps': totalSteps,
      if (summaryJson != null) 'summaryJson': summaryJson,
      'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttackSimulationImpl extends AttackSimulation {
  _AttackSimulationImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _i8tlthbq.SimulationType type,
    _i3nrcxzu.SimulationStatus? status,
    String? label,
    String? paramsJson,
    int? progress,
    int? totalSteps,
    String? summaryJson,
    required String createdBy,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         type: type,
         status: status,
         label: label,
         paramsJson: paramsJson,
         progress: progress,
         totalSteps: totalSteps,
         summaryJson: summaryJson,
         createdBy: createdBy,
         createdAt: createdAt,
         startedAt: startedAt,
         completedAt: completedAt,
         cancelledAt: cancelledAt,
       );

  /// Returns a shallow copy of this [AttackSimulation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AttackSimulation copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    _i8tlthbq.SimulationType? type,
    _i3nrcxzu.SimulationStatus? status,
    Object? label = _Undefined,
    Object? paramsJson = _Undefined,
    int? progress,
    int? totalSteps,
    Object? summaryJson = _Undefined,
    String? createdBy,
    DateTime? createdAt,
    Object? startedAt = _Undefined,
    Object? completedAt = _Undefined,
    Object? cancelledAt = _Undefined,
  }) {
    return AttackSimulation(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      type: type ?? this.type,
      status: status ?? this.status,
      label: label is String? ? label : this.label,
      paramsJson: paramsJson is String? ? paramsJson : this.paramsJson,
      progress: progress ?? this.progress,
      totalSteps: totalSteps ?? this.totalSteps,
      summaryJson: summaryJson is String? ? summaryJson : this.summaryJson,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt is DateTime? ? startedAt : this.startedAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      cancelledAt: cancelledAt is DateTime? ? cancelledAt : this.cancelledAt,
    );
  }
}
