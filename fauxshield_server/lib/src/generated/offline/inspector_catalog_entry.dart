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
import '../enums/batch_status.dart' as _i9kwsvqp;
import '../enums/identity_status.dart' as _iqacwrhy;

/// Catalog row delivered to inspector devices so field checks keep working
/// without connectivity. The device stores these locally and matches scans
/// against them. Holds no secret material: offline checks are identity lookups
/// and status checks, never cryptographic authentication.
abstract class InspectorCatalogEntry
    implements _is.SerializableModel, _is.ProtocolSerialization {
  InspectorCatalogEntry._({
    required this.identityId,
    required this.qrToken,
    required this.productName,
    this.sku,
    this.productDescription,
    this.imageUrls,
    this.packaging,
    this.shelfLife,
    this.countryRestrictions,
    this.safetyInstructions,
    required this.batchReference,
    required this.batchStatus,
    this.manufactureDate,
    required this.distributionRegion,
    required this.identityStatus,
    this.recallReason,
    this.recalledAt,
  });

  factory InspectorCatalogEntry({
    required _is.UuidValue identityId,
    required String qrToken,
    required String productName,
    String? sku,
    String? productDescription,
    List<String>? imageUrls,
    String? packaging,
    String? shelfLife,
    List<String>? countryRestrictions,
    String? safetyInstructions,
    required String batchReference,
    required _i9kwsvqp.BatchStatus batchStatus,
    DateTime? manufactureDate,
    required String distributionRegion,
    required _iqacwrhy.IdentityStatus identityStatus,
    String? recallReason,
    DateTime? recalledAt,
  }) = _InspectorCatalogEntryImpl;

  factory InspectorCatalogEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return InspectorCatalogEntry(
      identityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['identityId'],
      ),
      qrToken: jsonSerialization['qrToken'] as String,
      productName: jsonSerialization['productName'] as String,
      sku: jsonSerialization['sku'] as String?,
      productDescription: jsonSerialization['productDescription'] as String?,
      imageUrls: jsonSerialization['imageUrls'] == null
          ? null
          : _ipgzzizd.Protocol().deserialize<List<String>>(
              jsonSerialization['imageUrls'],
            ),
      packaging: jsonSerialization['packaging'] as String?,
      shelfLife: jsonSerialization['shelfLife'] as String?,
      countryRestrictions: jsonSerialization['countryRestrictions'] == null
          ? null
          : _ipgzzizd.Protocol().deserialize<List<String>>(
              jsonSerialization['countryRestrictions'],
            ),
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
    );
  }

  _is.UuidValue identityId;

  String qrToken;

  String productName;

  String? sku;

  String? productDescription;

  List<String>? imageUrls;

  String? packaging;

  String? shelfLife;

  List<String>? countryRestrictions;

  String? safetyInstructions;

  String batchReference;

  _i9kwsvqp.BatchStatus batchStatus;

  DateTime? manufactureDate;

  String distributionRegion;

  _iqacwrhy.IdentityStatus identityStatus;

  String? recallReason;

  DateTime? recalledAt;

  /// Returns a shallow copy of this [InspectorCatalogEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  InspectorCatalogEntry copyWith({
    _is.UuidValue? identityId,
    String? qrToken,
    String? productName,
    String? sku,
    String? productDescription,
    List<String>? imageUrls,
    String? packaging,
    String? shelfLife,
    List<String>? countryRestrictions,
    String? safetyInstructions,
    String? batchReference,
    _i9kwsvqp.BatchStatus? batchStatus,
    DateTime? manufactureDate,
    String? distributionRegion,
    _iqacwrhy.IdentityStatus? identityStatus,
    String? recallReason,
    DateTime? recalledAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InspectorCatalogEntry',
      'identityId': identityId.toJson(),
      'qrToken': qrToken,
      'productName': productName,
      if (sku != null) 'sku': sku,
      if (productDescription != null) 'productDescription': productDescription,
      if (imageUrls != null) 'imageUrls': imageUrls?.toJson(),
      if (packaging != null) 'packaging': packaging,
      if (shelfLife != null) 'shelfLife': shelfLife,
      if (countryRestrictions != null)
        'countryRestrictions': countryRestrictions?.toJson(),
      if (safetyInstructions != null) 'safetyInstructions': safetyInstructions,
      'batchReference': batchReference,
      'batchStatus': batchStatus.toJson(),
      if (manufactureDate != null) 'manufactureDate': manufactureDate?.toJson(),
      'distributionRegion': distributionRegion,
      'identityStatus': identityStatus.toJson(),
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InspectorCatalogEntry',
      'identityId': identityId.toJson(),
      'qrToken': qrToken,
      'productName': productName,
      if (sku != null) 'sku': sku,
      if (productDescription != null) 'productDescription': productDescription,
      if (imageUrls != null) 'imageUrls': imageUrls?.toJson(),
      if (packaging != null) 'packaging': packaging,
      if (shelfLife != null) 'shelfLife': shelfLife,
      if (countryRestrictions != null)
        'countryRestrictions': countryRestrictions?.toJson(),
      if (safetyInstructions != null) 'safetyInstructions': safetyInstructions,
      'batchReference': batchReference,
      'batchStatus': batchStatus.toJson(),
      if (manufactureDate != null) 'manufactureDate': manufactureDate?.toJson(),
      'distributionRegion': distributionRegion,
      'identityStatus': identityStatus.toJson(),
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InspectorCatalogEntryImpl extends InspectorCatalogEntry {
  _InspectorCatalogEntryImpl({
    required _is.UuidValue identityId,
    required String qrToken,
    required String productName,
    String? sku,
    String? productDescription,
    List<String>? imageUrls,
    String? packaging,
    String? shelfLife,
    List<String>? countryRestrictions,
    String? safetyInstructions,
    required String batchReference,
    required _i9kwsvqp.BatchStatus batchStatus,
    DateTime? manufactureDate,
    required String distributionRegion,
    required _iqacwrhy.IdentityStatus identityStatus,
    String? recallReason,
    DateTime? recalledAt,
  }) : super._(
         identityId: identityId,
         qrToken: qrToken,
         productName: productName,
         sku: sku,
         productDescription: productDescription,
         imageUrls: imageUrls,
         packaging: packaging,
         shelfLife: shelfLife,
         countryRestrictions: countryRestrictions,
         safetyInstructions: safetyInstructions,
         batchReference: batchReference,
         batchStatus: batchStatus,
         manufactureDate: manufactureDate,
         distributionRegion: distributionRegion,
         identityStatus: identityStatus,
         recallReason: recallReason,
         recalledAt: recalledAt,
       );

  /// Returns a shallow copy of this [InspectorCatalogEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  InspectorCatalogEntry copyWith({
    _is.UuidValue? identityId,
    String? qrToken,
    String? productName,
    Object? sku = _Undefined,
    Object? productDescription = _Undefined,
    Object? imageUrls = _Undefined,
    Object? packaging = _Undefined,
    Object? shelfLife = _Undefined,
    Object? countryRestrictions = _Undefined,
    Object? safetyInstructions = _Undefined,
    String? batchReference,
    _i9kwsvqp.BatchStatus? batchStatus,
    Object? manufactureDate = _Undefined,
    String? distributionRegion,
    _iqacwrhy.IdentityStatus? identityStatus,
    Object? recallReason = _Undefined,
    Object? recalledAt = _Undefined,
  }) {
    return InspectorCatalogEntry(
      identityId: identityId ?? this.identityId,
      qrToken: qrToken ?? this.qrToken,
      productName: productName ?? this.productName,
      sku: sku is String? ? sku : this.sku,
      productDescription: productDescription is String?
          ? productDescription
          : this.productDescription,
      imageUrls: imageUrls is List<String>?
          ? imageUrls
          : this.imageUrls?.map((e0) => e0).toList(),
      packaging: packaging is String? ? packaging : this.packaging,
      shelfLife: shelfLife is String? ? shelfLife : this.shelfLife,
      countryRestrictions: countryRestrictions is List<String>?
          ? countryRestrictions
          : this.countryRestrictions?.map((e0) => e0).toList(),
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
    );
  }
}
