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
import '../enums/fake_report_status.dart' as _igwoz7s7;
import '../enums/scan_source.dart' as _iv29sx9n;

/// A suspicious or fake product report submitted by a consumer from the
/// verification flow. Reports feed the fraud pipeline and the brand's triage queue.
abstract class FakeReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FakeReport._({
    this.id,
    required this.workspaceId,
    required this.identityId,
    this.sessionId,
    required this.reason,
    this.comment,
    this.photoStorageId,
    this.photoPath,
    this.deviceFingerprint,
    this.country,
    this.city,
    _igwoz7s7.FakeReportStatus? status,
    _iv29sx9n.ScanSource? source,
    DateTime? createdAt,
    this.triagedAt,
    this.triagedBy,
  }) : status = status ?? _igwoz7s7.FakeReportStatus.open,
       source = source ?? _iv29sx9n.ScanSource.consumerWeb,
       createdAt = createdAt ?? DateTime.now();

  factory FakeReport({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _isc.UuidValue identityId,
    _isc.UuidValue? sessionId,
    required String reason,
    String? comment,
    String? photoStorageId,
    String? photoPath,
    String? deviceFingerprint,
    String? country,
    String? city,
    _igwoz7s7.FakeReportStatus? status,
    _iv29sx9n.ScanSource? source,
    DateTime? createdAt,
    DateTime? triagedAt,
    String? triagedBy,
  }) = _FakeReportImpl;

  factory FakeReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return FakeReport(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      identityId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['identityId'],
      ),
      sessionId: jsonSerialization['sessionId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['sessionId'],
            ),
      reason: jsonSerialization['reason'] as String,
      comment: jsonSerialization['comment'] as String?,
      photoStorageId: jsonSerialization['photoStorageId'] as String?,
      photoPath: jsonSerialization['photoPath'] as String?,
      deviceFingerprint: jsonSerialization['deviceFingerprint'] as String?,
      country: jsonSerialization['country'] as String?,
      city: jsonSerialization['city'] as String?,
      status: jsonSerialization['status'] == null
          ? null
          : _igwoz7s7.FakeReportStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      source: jsonSerialization['source'] == null
          ? null
          : _iv29sx9n.ScanSource.fromJson(
              (jsonSerialization['source'] as String),
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      triagedAt: jsonSerialization['triagedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['triagedAt']),
      triagedBy: jsonSerialization['triagedBy'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue workspaceId;

  _isc.UuidValue identityId;

  _isc.UuidValue? sessionId;

  String reason;

  String? comment;

  String? photoStorageId;

  String? photoPath;

  String? deviceFingerprint;

  String? country;

  String? city;

  _igwoz7s7.FakeReportStatus status;

  _iv29sx9n.ScanSource source;

  DateTime createdAt;

  DateTime? triagedAt;

  String? triagedBy;

  /// Returns a shallow copy of this [FakeReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FakeReport copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? identityId,
    _isc.UuidValue? sessionId,
    String? reason,
    String? comment,
    String? photoStorageId,
    String? photoPath,
    String? deviceFingerprint,
    String? country,
    String? city,
    _igwoz7s7.FakeReportStatus? status,
    _iv29sx9n.ScanSource? source,
    DateTime? createdAt,
    DateTime? triagedAt,
    String? triagedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FakeReport',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'identityId': identityId.toJson(),
      if (sessionId != null) 'sessionId': sessionId?.toJson(),
      'reason': reason,
      if (comment != null) 'comment': comment,
      if (photoStorageId != null) 'photoStorageId': photoStorageId,
      if (photoPath != null) 'photoPath': photoPath,
      if (deviceFingerprint != null) 'deviceFingerprint': deviceFingerprint,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      'status': status.toJson(),
      'source': source.toJson(),
      'createdAt': createdAt.toJson(),
      if (triagedAt != null) 'triagedAt': triagedAt?.toJson(),
      if (triagedBy != null) 'triagedBy': triagedBy,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FakeReport',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'identityId': identityId.toJson(),
      if (sessionId != null) 'sessionId': sessionId?.toJson(),
      'reason': reason,
      if (comment != null) 'comment': comment,
      if (photoStorageId != null) 'photoStorageId': photoStorageId,
      if (photoPath != null) 'photoPath': photoPath,
      if (deviceFingerprint != null) 'deviceFingerprint': deviceFingerprint,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      'status': status.toJson(),
      'source': source.toJson(),
      'createdAt': createdAt.toJson(),
      if (triagedAt != null) 'triagedAt': triagedAt?.toJson(),
      if (triagedBy != null) 'triagedBy': triagedBy,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FakeReportImpl extends FakeReport {
  _FakeReportImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _isc.UuidValue identityId,
    _isc.UuidValue? sessionId,
    required String reason,
    String? comment,
    String? photoStorageId,
    String? photoPath,
    String? deviceFingerprint,
    String? country,
    String? city,
    _igwoz7s7.FakeReportStatus? status,
    _iv29sx9n.ScanSource? source,
    DateTime? createdAt,
    DateTime? triagedAt,
    String? triagedBy,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         identityId: identityId,
         sessionId: sessionId,
         reason: reason,
         comment: comment,
         photoStorageId: photoStorageId,
         photoPath: photoPath,
         deviceFingerprint: deviceFingerprint,
         country: country,
         city: city,
         status: status,
         source: source,
         createdAt: createdAt,
         triagedAt: triagedAt,
         triagedBy: triagedBy,
       );

  /// Returns a shallow copy of this [FakeReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FakeReport copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? identityId,
    Object? sessionId = _Undefined,
    String? reason,
    Object? comment = _Undefined,
    Object? photoStorageId = _Undefined,
    Object? photoPath = _Undefined,
    Object? deviceFingerprint = _Undefined,
    Object? country = _Undefined,
    Object? city = _Undefined,
    _igwoz7s7.FakeReportStatus? status,
    _iv29sx9n.ScanSource? source,
    DateTime? createdAt,
    Object? triagedAt = _Undefined,
    Object? triagedBy = _Undefined,
  }) {
    return FakeReport(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      identityId: identityId ?? this.identityId,
      sessionId: sessionId is _isc.UuidValue? ? sessionId : this.sessionId,
      reason: reason ?? this.reason,
      comment: comment is String? ? comment : this.comment,
      photoStorageId: photoStorageId is String?
          ? photoStorageId
          : this.photoStorageId,
      photoPath: photoPath is String? ? photoPath : this.photoPath,
      deviceFingerprint: deviceFingerprint is String?
          ? deviceFingerprint
          : this.deviceFingerprint,
      country: country is String? ? country : this.country,
      city: city is String? ? city : this.city,
      status: status ?? this.status,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      triagedAt: triagedAt is DateTime? ? triagedAt : this.triagedAt,
      triagedBy: triagedBy is String? ? triagedBy : this.triagedBy,
    );
  }
}
