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
import '../enums/alert_severity.dart' as _ivfuu0vh;
import '../enums/alert_status.dart' as _if1md3kb;
import '../enums/signal_type.dart' as _ihijuu0z;

/// A fraud alert for the brand's operations team. Alerts carry their own
/// workflow state and point at the evidence needed to investigate.
abstract class FraudAlert
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FraudAlert._({
    this.id,
    required this.workspaceId,
    this.identityId,
    this.batchId,
    this.sessionId,
    required this.severity,
    _if1md3kb.AlertStatus? status,
    required this.title,
    required this.description,
    this.recommendedAction,
    this.signalTypes,
    required this.dedupeKey,
    bool? autoLocked,
    this.assignee,
    this.simulationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.acknowledgedAt,
    this.resolvedAt,
    this.resolvedBy,
    this.resolutionNote,
  }) : status = status ?? _if1md3kb.AlertStatus.open,
       autoLocked = autoLocked ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory FraudAlert({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    _isc.UuidValue? identityId,
    _isc.UuidValue? batchId,
    _isc.UuidValue? sessionId,
    required _ivfuu0vh.AlertSeverity severity,
    _if1md3kb.AlertStatus? status,
    required String title,
    required String description,
    String? recommendedAction,
    List<_ihijuu0z.SignalType>? signalTypes,
    required String dedupeKey,
    bool? autoLocked,
    String? assignee,
    _isc.UuidValue? simulationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? acknowledgedAt,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNote,
  }) = _FraudAlertImpl;

  factory FraudAlert.fromJson(Map<String, dynamic> jsonSerialization) {
    return FraudAlert(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      identityId: jsonSerialization['identityId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['identityId'],
            ),
      batchId: jsonSerialization['batchId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['batchId']),
      sessionId: jsonSerialization['sessionId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['sessionId'],
            ),
      severity: _ivfuu0vh.AlertSeverity.fromJson(
        (jsonSerialization['severity'] as String),
      ),
      status: jsonSerialization['status'] == null
          ? null
          : _if1md3kb.AlertStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      recommendedAction: jsonSerialization['recommendedAction'] as String?,
      signalTypes: jsonSerialization['signalTypes'] == null
          ? null
          : _iuzkm0gn.Protocol().deserialize<List<_ihijuu0z.SignalType>>(
              jsonSerialization['signalTypes'],
            ),
      dedupeKey: jsonSerialization['dedupeKey'] as String,
      autoLocked: jsonSerialization['autoLocked'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['autoLocked']),
      assignee: jsonSerialization['assignee'] as String?,
      simulationId: jsonSerialization['simulationId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['simulationId'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      acknowledgedAt: jsonSerialization['acknowledgedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['acknowledgedAt'],
            ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['resolvedAt'],
            ),
      resolvedBy: jsonSerialization['resolvedBy'] as String?,
      resolutionNote: jsonSerialization['resolutionNote'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue workspaceId;

  /// Optional links to evidence. Plain ids so alerts survive identity deletion.
  _isc.UuidValue? identityId;

  _isc.UuidValue? batchId;

  _isc.UuidValue? sessionId;

  _ivfuu0vh.AlertSeverity severity;

  _if1md3kb.AlertStatus status;

  String title;

  String description;

  String? recommendedAction;

  List<_ihijuu0z.SignalType>? signalTypes;

  /// Stable key that prevents duplicate alerts for the same underlying event.
  String dedupeKey;

  /// True when the platform automatically locked the identity for this alert.
  bool autoLocked;

  String? assignee;

  _isc.UuidValue? simulationId;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? acknowledgedAt;

  DateTime? resolvedAt;

  String? resolvedBy;

  String? resolutionNote;

  /// Returns a shallow copy of this [FraudAlert]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FraudAlert copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? identityId,
    _isc.UuidValue? batchId,
    _isc.UuidValue? sessionId,
    _ivfuu0vh.AlertSeverity? severity,
    _if1md3kb.AlertStatus? status,
    String? title,
    String? description,
    String? recommendedAction,
    List<_ihijuu0z.SignalType>? signalTypes,
    String? dedupeKey,
    bool? autoLocked,
    String? assignee,
    _isc.UuidValue? simulationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? acknowledgedAt,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNote,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FraudAlert',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      if (identityId != null) 'identityId': identityId?.toJson(),
      if (batchId != null) 'batchId': batchId?.toJson(),
      if (sessionId != null) 'sessionId': sessionId?.toJson(),
      'severity': severity.toJson(),
      'status': status.toJson(),
      'title': title,
      'description': description,
      if (recommendedAction != null) 'recommendedAction': recommendedAction,
      if (signalTypes != null)
        'signalTypes': signalTypes?.toJson(valueToJson: (v) => v.toJson()),
      'dedupeKey': dedupeKey,
      'autoLocked': autoLocked,
      if (assignee != null) 'assignee': assignee,
      if (simulationId != null) 'simulationId': simulationId?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      if (resolvedBy != null) 'resolvedBy': resolvedBy,
      if (resolutionNote != null) 'resolutionNote': resolutionNote,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FraudAlert',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      if (identityId != null) 'identityId': identityId?.toJson(),
      if (batchId != null) 'batchId': batchId?.toJson(),
      if (sessionId != null) 'sessionId': sessionId?.toJson(),
      'severity': severity.toJson(),
      'status': status.toJson(),
      'title': title,
      'description': description,
      if (recommendedAction != null) 'recommendedAction': recommendedAction,
      if (signalTypes != null)
        'signalTypes': signalTypes?.toJson(valueToJson: (v) => v.toJson()),
      'dedupeKey': dedupeKey,
      'autoLocked': autoLocked,
      if (assignee != null) 'assignee': assignee,
      if (simulationId != null) 'simulationId': simulationId?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      if (resolvedBy != null) 'resolvedBy': resolvedBy,
      if (resolutionNote != null) 'resolutionNote': resolutionNote,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FraudAlertImpl extends FraudAlert {
  _FraudAlertImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    _isc.UuidValue? identityId,
    _isc.UuidValue? batchId,
    _isc.UuidValue? sessionId,
    required _ivfuu0vh.AlertSeverity severity,
    _if1md3kb.AlertStatus? status,
    required String title,
    required String description,
    String? recommendedAction,
    List<_ihijuu0z.SignalType>? signalTypes,
    required String dedupeKey,
    bool? autoLocked,
    String? assignee,
    _isc.UuidValue? simulationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? acknowledgedAt,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNote,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         identityId: identityId,
         batchId: batchId,
         sessionId: sessionId,
         severity: severity,
         status: status,
         title: title,
         description: description,
         recommendedAction: recommendedAction,
         signalTypes: signalTypes,
         dedupeKey: dedupeKey,
         autoLocked: autoLocked,
         assignee: assignee,
         simulationId: simulationId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         acknowledgedAt: acknowledgedAt,
         resolvedAt: resolvedAt,
         resolvedBy: resolvedBy,
         resolutionNote: resolutionNote,
       );

  /// Returns a shallow copy of this [FraudAlert]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FraudAlert copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    Object? identityId = _Undefined,
    Object? batchId = _Undefined,
    Object? sessionId = _Undefined,
    _ivfuu0vh.AlertSeverity? severity,
    _if1md3kb.AlertStatus? status,
    String? title,
    String? description,
    Object? recommendedAction = _Undefined,
    Object? signalTypes = _Undefined,
    String? dedupeKey,
    bool? autoLocked,
    Object? assignee = _Undefined,
    Object? simulationId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? acknowledgedAt = _Undefined,
    Object? resolvedAt = _Undefined,
    Object? resolvedBy = _Undefined,
    Object? resolutionNote = _Undefined,
  }) {
    return FraudAlert(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      identityId: identityId is _isc.UuidValue? ? identityId : this.identityId,
      batchId: batchId is _isc.UuidValue? ? batchId : this.batchId,
      sessionId: sessionId is _isc.UuidValue? ? sessionId : this.sessionId,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      recommendedAction: recommendedAction is String?
          ? recommendedAction
          : this.recommendedAction,
      signalTypes: signalTypes is List<_ihijuu0z.SignalType>?
          ? signalTypes
          : this.signalTypes?.map((e0) => e0).toList(),
      dedupeKey: dedupeKey ?? this.dedupeKey,
      autoLocked: autoLocked ?? this.autoLocked,
      assignee: assignee is String? ? assignee : this.assignee,
      simulationId: simulationId is _isc.UuidValue?
          ? simulationId
          : this.simulationId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      acknowledgedAt: acknowledgedAt is DateTime?
          ? acknowledgedAt
          : this.acknowledgedAt,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
      resolvedBy: resolvedBy is String? ? resolvedBy : this.resolvedBy,
      resolutionNote: resolutionNote is String?
          ? resolutionNote
          : this.resolutionNote,
    );
  }
}
