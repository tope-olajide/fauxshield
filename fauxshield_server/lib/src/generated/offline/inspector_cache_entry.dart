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
import '../enums/batch_status.dart' as _i9kwsvqp;
import '../enums/identity_status.dart' as _iqacwrhy;

/// Device-local cache of catalog entries for offline inspector checks. This
/// table lives only in the app's SQLite database and is refreshed from the
/// server catalog endpoint.
abstract class InspectorCacheEntry
    implements _is.SerializableModel, _is.ProtocolSerialization {
  InspectorCacheEntry._({
    this.id,
    required this.identityId,
    required this.qrToken,
    required this.productName,
    this.sku,
    this.productDescription,
    this.imageUrlsJson,
    this.packaging,
    this.shelfLife,
    this.countryRestrictionsJson,
    this.safetyInstructions,
    required this.batchReference,
    required this.batchStatus,
    this.manufactureDate,
    required this.distributionRegion,
    required this.identityStatus,
    this.recallReason,
    this.recalledAt,
    required this.refreshedAt,
  });

  factory InspectorCacheEntry({
    _is.UuidValue? id,
    required _is.UuidValue identityId,
    required String qrToken,
    required String productName,
    String? sku,
    String? productDescription,
    String? imageUrlsJson,
    String? packaging,
    String? shelfLife,
    String? countryRestrictionsJson,
    String? safetyInstructions,
    required String batchReference,
    required _i9kwsvqp.BatchStatus batchStatus,
    DateTime? manufactureDate,
    required String distributionRegion,
    required _iqacwrhy.IdentityStatus identityStatus,
    String? recallReason,
    DateTime? recalledAt,
    required DateTime refreshedAt,
  }) = _InspectorCacheEntryImpl;

  factory InspectorCacheEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return InspectorCacheEntry(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      identityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['identityId'],
      ),
      qrToken: jsonSerialization['qrToken'] as String,
      productName: jsonSerialization['productName'] as String,
      sku: jsonSerialization['sku'] as String?,
      productDescription: jsonSerialization['productDescription'] as String?,
      imageUrlsJson: jsonSerialization['imageUrlsJson'] as String?,
      packaging: jsonSerialization['packaging'] as String?,
      shelfLife: jsonSerialization['shelfLife'] as String?,
      countryRestrictionsJson:
          jsonSerialization['countryRestrictionsJson'] as String?,
      safetyInstructions: jsonSerialization['safetyInstructions'] as String?,
      batchReference: jsonSerialization['batchReference'] as String,
      batchStatus: _i9kwsvqp.BatchStatus.fromJson(
        (jsonSerialization['batchStatus'] as String),
      ),
      manufactureDate: jsonSerialization['manufactureDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['manufactureDate'],
            ),
      distributionRegion: jsonSerialization['distributionRegion'] as String,
      identityStatus: _iqacwrhy.IdentityStatus.fromJson(
        (jsonSerialization['identityStatus'] as String),
      ),
      recallReason: jsonSerialization['recallReason'] as String?,
      recalledAt: jsonSerialization['recalledAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['recalledAt']),
      refreshedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['refreshedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _is.UuidValue? id;

  _is.UuidValue identityId;

  String qrToken;

  String productName;

  String? sku;

  String? productDescription;

  String? imageUrlsJson;

  String? packaging;

  String? shelfLife;

  String? countryRestrictionsJson;

  String? safetyInstructions;

  String batchReference;

  _i9kwsvqp.BatchStatus batchStatus;

  DateTime? manufactureDate;

  String distributionRegion;

  _iqacwrhy.IdentityStatus identityStatus;

  String? recallReason;

  DateTime? recalledAt;

  DateTime refreshedAt;

  /// Returns a shallow copy of this [InspectorCacheEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  InspectorCacheEntry copyWith({
    _is.UuidValue? id,
    _is.UuidValue? identityId,
    String? qrToken,
    String? productName,
    String? sku,
    String? productDescription,
    String? imageUrlsJson,
    String? packaging,
    String? shelfLife,
    String? countryRestrictionsJson,
    String? safetyInstructions,
    String? batchReference,
    _i9kwsvqp.BatchStatus? batchStatus,
    DateTime? manufactureDate,
    String? distributionRegion,
    _iqacwrhy.IdentityStatus? identityStatus,
    String? recallReason,
    DateTime? recalledAt,
    DateTime? refreshedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InspectorCacheEntry',
      if (id != null) 'id': id?.toJson(),
      'identityId': identityId.toJson(),
      'qrToken': qrToken,
      'productName': productName,
      if (sku != null) 'sku': sku,
      if (productDescription != null) 'productDescription': productDescription,
      if (imageUrlsJson != null) 'imageUrlsJson': imageUrlsJson,
      if (packaging != null) 'packaging': packaging,
      if (shelfLife != null) 'shelfLife': shelfLife,
      if (countryRestrictionsJson != null)
        'countryRestrictionsJson': countryRestrictionsJson,
      if (safetyInstructions != null) 'safetyInstructions': safetyInstructions,
      'batchReference': batchReference,
      'batchStatus': batchStatus.toJson(),
      if (manufactureDate != null) 'manufactureDate': manufactureDate?.toJson(),
      'distributionRegion': distributionRegion,
      'identityStatus': identityStatus.toJson(),
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
      'refreshedAt': refreshedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InspectorCacheEntry',
      if (id != null) 'id': id?.toJson(),
      'identityId': identityId.toJson(),
      'qrToken': qrToken,
      'productName': productName,
      if (sku != null) 'sku': sku,
      if (productDescription != null) 'productDescription': productDescription,
      if (imageUrlsJson != null) 'imageUrlsJson': imageUrlsJson,
      if (packaging != null) 'packaging': packaging,
      if (shelfLife != null) 'shelfLife': shelfLife,
      if (countryRestrictionsJson != null)
        'countryRestrictionsJson': countryRestrictionsJson,
      if (safetyInstructions != null) 'safetyInstructions': safetyInstructions,
      'batchReference': batchReference,
      'batchStatus': batchStatus.toJson(),
      if (manufactureDate != null) 'manufactureDate': manufactureDate?.toJson(),
      'distributionRegion': distributionRegion,
      'identityStatus': identityStatus.toJson(),
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
      'refreshedAt': refreshedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InspectorCacheEntryImpl extends InspectorCacheEntry {
  _InspectorCacheEntryImpl({
    _is.UuidValue? id,
    required _is.UuidValue identityId,
    required String qrToken,
    required String productName,
    String? sku,
    String? productDescription,
    String? imageUrlsJson,
    String? packaging,
    String? shelfLife,
    String? countryRestrictionsJson,
    String? safetyInstructions,
    required String batchReference,
    required _i9kwsvqp.BatchStatus batchStatus,
    DateTime? manufactureDate,
    required String distributionRegion,
    required _iqacwrhy.IdentityStatus identityStatus,
    String? recallReason,
    DateTime? recalledAt,
    required DateTime refreshedAt,
  }) : super._(
         id: id,
         identityId: identityId,
         qrToken: qrToken,
         productName: productName,
         sku: sku,
         productDescription: productDescription,
         imageUrlsJson: imageUrlsJson,
         packaging: packaging,
         shelfLife: shelfLife,
         countryRestrictionsJson: countryRestrictionsJson,
         safetyInstructions: safetyInstructions,
         batchReference: batchReference,
         batchStatus: batchStatus,
         manufactureDate: manufactureDate,
         distributionRegion: distributionRegion,
         identityStatus: identityStatus,
         recallReason: recallReason,
         recalledAt: recalledAt,
         refreshedAt: refreshedAt,
       );

  /// Returns a shallow copy of this [InspectorCacheEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  InspectorCacheEntry copyWith({
    Object? id = _Undefined,
    _is.UuidValue? identityId,
    String? qrToken,
    String? productName,
    Object? sku = _Undefined,
    Object? productDescription = _Undefined,
    Object? imageUrlsJson = _Undefined,
    Object? packaging = _Undefined,
    Object? shelfLife = _Undefined,
    Object? countryRestrictionsJson = _Undefined,
    Object? safetyInstructions = _Undefined,
    String? batchReference,
    _i9kwsvqp.BatchStatus? batchStatus,
    Object? manufactureDate = _Undefined,
    String? distributionRegion,
    _iqacwrhy.IdentityStatus? identityStatus,
    Object? recallReason = _Undefined,
    Object? recalledAt = _Undefined,
    DateTime? refreshedAt,
  }) {
    return InspectorCacheEntry(
      id: id is _is.UuidValue? ? id : this.id,
      identityId: identityId ?? this.identityId,
      qrToken: qrToken ?? this.qrToken,
      productName: productName ?? this.productName,
      sku: sku is String? ? sku : this.sku,
      productDescription: productDescription is String?
          ? productDescription
          : this.productDescription,
      imageUrlsJson: imageUrlsJson is String?
          ? imageUrlsJson
          : this.imageUrlsJson,
      packaging: packaging is String? ? packaging : this.packaging,
      shelfLife: shelfLife is String? ? shelfLife : this.shelfLife,
      countryRestrictionsJson: countryRestrictionsJson is String?
          ? countryRestrictionsJson
          : this.countryRestrictionsJson,
      safetyInstructions: safetyInstructions is String?
          ? safetyInstructions
          : this.safetyInstructions,
      batchReference: batchReference ?? this.batchReference,
      batchStatus: batchStatus ?? this.batchStatus,
      manufactureDate: manufactureDate is DateTime?
          ? manufactureDate
          : this.manufactureDate,
      distributionRegion: distributionRegion ?? this.distributionRegion,
      identityStatus: identityStatus ?? this.identityStatus,
      recallReason: recallReason is String? ? recallReason : this.recallReason,
      recalledAt: recalledAt is DateTime? ? recalledAt : this.recalledAt,
      refreshedAt: refreshedAt ?? this.refreshedAt,
    );
  }
}
