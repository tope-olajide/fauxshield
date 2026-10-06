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

/// One queued offline scan submitted to the server for authoritative processing.
abstract class OfflineScanInput
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  OfflineScanInput._({
    required this.localId,
    required this.deviceId,
    this.deviceFingerprint,
    this.identityId,
    required this.qrToken,
    required this.scannedAt,
    this.latitude,
    this.longitude,
    this.country,
    this.city,
    this.provisionalOutcome,
  });

  factory OfflineScanInput({
    required String localId,
    required String deviceId,
    String? deviceFingerprint,
    _isc.UuidValue? identityId,
    required String qrToken,
    required DateTime scannedAt,
    double? latitude,
    double? longitude,
    String? country,
    String? city,
    String? provisionalOutcome,
  }) = _OfflineScanInputImpl;

  factory OfflineScanInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return OfflineScanInput(
      localId: jsonSerialization['localId'] as String,
      deviceId: jsonSerialization['deviceId'] as String,
      deviceFingerprint: jsonSerialization['deviceFingerprint'] as String?,
      identityId: jsonSerialization['identityId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['identityId'],
            ),
      qrToken: jsonSerialization['qrToken'] as String,
      scannedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['scannedAt'],
      ),
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      country: jsonSerialization['country'] as String?,
      city: jsonSerialization['city'] as String?,
      provisionalOutcome: jsonSerialization['provisionalOutcome'] as String?,
    );
  }

  /// Client generated local identifier used to correlate the verdict.
  String localId;

  String deviceId;

  String? deviceFingerprint;

  _isc.UuidValue? identityId;

  String qrToken;

  DateTime scannedAt;

  double? latitude;

  double? longitude;

  String? country;

  String? city;

  String? provisionalOutcome;

  /// Returns a shallow copy of this [OfflineScanInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  OfflineScanInput copyWith({
    String? localId,
    String? deviceId,
    String? deviceFingerprint,
    _isc.UuidValue? identityId,
    String? qrToken,
    DateTime? scannedAt,
    double? latitude,
    double? longitude,
    String? country,
    String? city,
    String? provisionalOutcome,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OfflineScanInput',
      'localId': localId,
      'deviceId': deviceId,
      if (deviceFingerprint != null) 'deviceFingerprint': deviceFingerprint,
      if (identityId != null) 'identityId': identityId?.toJson(),
      'qrToken': qrToken,
      'scannedAt': scannedAt.toJson(),
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      if (provisionalOutcome != null) 'provisionalOutcome': provisionalOutcome,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OfflineScanInput',
      'localId': localId,
      'deviceId': deviceId,
      if (deviceFingerprint != null) 'deviceFingerprint': deviceFingerprint,
      if (identityId != null) 'identityId': identityId?.toJson(),
      'qrToken': qrToken,
      'scannedAt': scannedAt.toJson(),
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      if (provisionalOutcome != null) 'provisionalOutcome': provisionalOutcome,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OfflineScanInputImpl extends OfflineScanInput {
  _OfflineScanInputImpl({
    required String localId,
    required String deviceId,
    String? deviceFingerprint,
    _isc.UuidValue? identityId,
    required String qrToken,
    required DateTime scannedAt,
    double? latitude,
    double? longitude,
    String? country,
    String? city,
    String? provisionalOutcome,
  }) : super._(
         localId: localId,
         deviceId: deviceId,
         deviceFingerprint: deviceFingerprint,
         identityId: identityId,
         qrToken: qrToken,
         scannedAt: scannedAt,
         latitude: latitude,
         longitude: longitude,
         country: country,
         city: city,
         provisionalOutcome: provisionalOutcome,
       );

  /// Returns a shallow copy of this [OfflineScanInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  OfflineScanInput copyWith({
    String? localId,
    String? deviceId,
    Object? deviceFingerprint = _Undefined,
    Object? identityId = _Undefined,
    String? qrToken,
    DateTime? scannedAt,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? country = _Undefined,
    Object? city = _Undefined,
    Object? provisionalOutcome = _Undefined,
  }) {
    return OfflineScanInput(
      localId: localId ?? this.localId,
      deviceId: deviceId ?? this.deviceId,
      deviceFingerprint: deviceFingerprint is String?
          ? deviceFingerprint
          : this.deviceFingerprint,
      identityId: identityId is _isc.UuidValue? ? identityId : this.identityId,
      qrToken: qrToken ?? this.qrToken,
      scannedAt: scannedAt ?? this.scannedAt,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      country: country is String? ? country : this.country,
      city: city is String? ? city : this.city,
      provisionalOutcome: provisionalOutcome is String?
          ? provisionalOutcome
          : this.provisionalOutcome,
    );
  }
}
