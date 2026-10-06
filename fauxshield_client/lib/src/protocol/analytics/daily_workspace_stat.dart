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

/// Daily analytics rollup materialized by a recurring scheduled task so the
/// dashboard stays fast even on large verification volumes.
abstract class DailyWorkspaceStat
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DailyWorkspaceStat._({
    this.id,
    required this.workspaceId,
    required this.date,
    int? verifications,
    int? authentic,
    int? alreadyVerified,
    int? invalidPin,
    int? fraudSuspected,
    int? highRisk,
    int? recalled,
    int? alertsCreated,
    int? alertsResolved,
    this.topCountriesJson,
    DateTime? createdAt,
  }) : verifications = verifications ?? 0,
       authentic = authentic ?? 0,
       alreadyVerified = alreadyVerified ?? 0,
       invalidPin = invalidPin ?? 0,
       fraudSuspected = fraudSuspected ?? 0,
       highRisk = highRisk ?? 0,
       recalled = recalled ?? 0,
       alertsCreated = alertsCreated ?? 0,
       alertsResolved = alertsResolved ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory DailyWorkspaceStat({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required DateTime date,
    int? verifications,
    int? authentic,
    int? alreadyVerified,
    int? invalidPin,
    int? fraudSuspected,
    int? highRisk,
    int? recalled,
    int? alertsCreated,
    int? alertsResolved,
    String? topCountriesJson,
    DateTime? createdAt,
  }) = _DailyWorkspaceStatImpl;

  factory DailyWorkspaceStat.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyWorkspaceStat(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      verifications: jsonSerialization['verifications'] as int?,
      authentic: jsonSerialization['authentic'] as int?,
      alreadyVerified: jsonSerialization['alreadyVerified'] as int?,
      invalidPin: jsonSerialization['invalidPin'] as int?,
      fraudSuspected: jsonSerialization['fraudSuspected'] as int?,
      highRisk: jsonSerialization['highRisk'] as int?,
      recalled: jsonSerialization['recalled'] as int?,
      alertsCreated: jsonSerialization['alertsCreated'] as int?,
      alertsResolved: jsonSerialization['alertsResolved'] as int?,
      topCountriesJson: jsonSerialization['topCountriesJson'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue workspaceId;

  /// UTC date (midnight) this rollup covers.
  DateTime date;

  int verifications;

  int authentic;

  int alreadyVerified;

  int invalidPin;

  int fraudSuspected;

  int highRisk;

  int recalled;

  int alertsCreated;

  int alertsResolved;

  /// JSON list of country activity for the day.
  String? topCountriesJson;

  DateTime createdAt;

  /// Returns a shallow copy of this [DailyWorkspaceStat]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DailyWorkspaceStat copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    DateTime? date,
    int? verifications,
    int? authentic,
    int? alreadyVerified,
    int? invalidPin,
    int? fraudSuspected,
    int? highRisk,
    int? recalled,
    int? alertsCreated,
    int? alertsResolved,
    String? topCountriesJson,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyWorkspaceStat',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'date': date.toJson(),
      'verifications': verifications,
      'authentic': authentic,
      'alreadyVerified': alreadyVerified,
      'invalidPin': invalidPin,
      'fraudSuspected': fraudSuspected,
      'highRisk': highRisk,
      'recalled': recalled,
      'alertsCreated': alertsCreated,
      'alertsResolved': alertsResolved,
      if (topCountriesJson != null) 'topCountriesJson': topCountriesJson,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DailyWorkspaceStat',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'date': date.toJson(),
      'verifications': verifications,
      'authentic': authentic,
      'alreadyVerified': alreadyVerified,
      'invalidPin': invalidPin,
      'fraudSuspected': fraudSuspected,
      'highRisk': highRisk,
      'recalled': recalled,
      'alertsCreated': alertsCreated,
      'alertsResolved': alertsResolved,
      if (topCountriesJson != null) 'topCountriesJson': topCountriesJson,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DailyWorkspaceStatImpl extends DailyWorkspaceStat {
  _DailyWorkspaceStatImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required DateTime date,
    int? verifications,
    int? authentic,
    int? alreadyVerified,
    int? invalidPin,
    int? fraudSuspected,
    int? highRisk,
    int? recalled,
    int? alertsCreated,
    int? alertsResolved,
    String? topCountriesJson,
    DateTime? createdAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         date: date,
         verifications: verifications,
         authentic: authentic,
         alreadyVerified: alreadyVerified,
         invalidPin: invalidPin,
         fraudSuspected: fraudSuspected,
         highRisk: highRisk,
         recalled: recalled,
         alertsCreated: alertsCreated,
         alertsResolved: alertsResolved,
         topCountriesJson: topCountriesJson,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DailyWorkspaceStat]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DailyWorkspaceStat copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    DateTime? date,
    int? verifications,
    int? authentic,
    int? alreadyVerified,
    int? invalidPin,
    int? fraudSuspected,
    int? highRisk,
    int? recalled,
    int? alertsCreated,
    int? alertsResolved,
    Object? topCountriesJson = _Undefined,
    DateTime? createdAt,
  }) {
    return DailyWorkspaceStat(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      date: date ?? this.date,
      verifications: verifications ?? this.verifications,
      authentic: authentic ?? this.authentic,
      alreadyVerified: alreadyVerified ?? this.alreadyVerified,
      invalidPin: invalidPin ?? this.invalidPin,
      fraudSuspected: fraudSuspected ?? this.fraudSuspected,
      highRisk: highRisk ?? this.highRisk,
      recalled: recalled ?? this.recalled,
      alertsCreated: alertsCreated ?? this.alertsCreated,
      alertsResolved: alertsResolved ?? this.alertsResolved,
      topCountriesJson: topCountriesJson is String?
          ? topCountriesJson
          : this.topCountriesJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
