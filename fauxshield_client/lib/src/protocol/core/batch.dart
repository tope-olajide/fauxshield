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
import '../enums/batch_status.dart' as _i9kwsvqp;

/// A manufacturing batch for one product. Identities are generated per batch,
/// and a batch can be recalled as a whole.
abstract class Batch
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Batch._({
    this.id,
    required this.workspaceId,
    required this.productId,
    required this.reference,
    required this.manufactureDate,
    this.expiryDate,
    required this.distributionRegion,
    required this.quantity,
    _i9kwsvqp.BatchStatus? status,
    this.notes,
    this.recallReason,
    this.recalledAt,
    this.recalledBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? _i9kwsvqp.BatchStatus.created,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Batch({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _isc.UuidValue productId,
    required String reference,
    required DateTime manufactureDate,
    DateTime? expiryDate,
    required String distributionRegion,
    required int quantity,
    _i9kwsvqp.BatchStatus? status,
    String? notes,
    String? recallReason,
    DateTime? recalledAt,
    String? recalledBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BatchImpl;

  factory Batch.fromJson(Map<String, dynamic> jsonSerialization) {
    return Batch(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      productId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['productId'],
      ),
      reference: jsonSerialization['reference'] as String,
      manufactureDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['manufactureDate'],
      ),
      expiryDate: jsonSerialization['expiryDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['expiryDate'],
            ),
      distributionRegion: jsonSerialization['distributionRegion'] as String,
      quantity: jsonSerialization['quantity'] as int,
      status: jsonSerialization['status'] == null
          ? null
          : _i9kwsvqp.BatchStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      notes: jsonSerialization['notes'] as String?,
      recallReason: jsonSerialization['recallReason'] as String?,
      recalledAt: jsonSerialization['recalledAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['recalledAt'],
            ),
      recalledBy: jsonSerialization['recalledBy'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue workspaceId;

  _isc.UuidValue productId;

  /// Manufacturing reference or lot number printed on packaging.
  String reference;

  DateTime manufactureDate;

  DateTime? expiryDate;

  /// Expected distribution region, for example NG or West Africa.
  String distributionRegion;

  /// Planned unit quantity for this batch.
  int quantity;

  _i9kwsvqp.BatchStatus status;

  String? notes;

  String? recallReason;

  DateTime? recalledAt;

  String? recalledBy;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Batch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Batch copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? productId,
    String? reference,
    DateTime? manufactureDate,
    DateTime? expiryDate,
    String? distributionRegion,
    int? quantity,
    _i9kwsvqp.BatchStatus? status,
    String? notes,
    String? recallReason,
    DateTime? recalledAt,
    String? recalledBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Batch',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'productId': productId.toJson(),
      'reference': reference,
      'manufactureDate': manufactureDate.toJson(),
      if (expiryDate != null) 'expiryDate': expiryDate?.toJson(),
      'distributionRegion': distributionRegion,
      'quantity': quantity,
      'status': status.toJson(),
      if (notes != null) 'notes': notes,
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
      if (recalledBy != null) 'recalledBy': recalledBy,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Batch',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'productId': productId.toJson(),
      'reference': reference,
      'manufactureDate': manufactureDate.toJson(),
      if (expiryDate != null) 'expiryDate': expiryDate?.toJson(),
      'distributionRegion': distributionRegion,
      'quantity': quantity,
      'status': status.toJson(),
      if (notes != null) 'notes': notes,
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
      if (recalledBy != null) 'recalledBy': recalledBy,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BatchImpl extends Batch {
  _BatchImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _isc.UuidValue productId,
    required String reference,
    required DateTime manufactureDate,
    DateTime? expiryDate,
    required String distributionRegion,
    required int quantity,
    _i9kwsvqp.BatchStatus? status,
    String? notes,
    String? recallReason,
    DateTime? recalledAt,
    String? recalledBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         productId: productId,
         reference: reference,
         manufactureDate: manufactureDate,
         expiryDate: expiryDate,
         distributionRegion: distributionRegion,
         quantity: quantity,
         status: status,
         notes: notes,
         recallReason: recallReason,
         recalledAt: recalledAt,
         recalledBy: recalledBy,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Batch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Batch copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? productId,
    String? reference,
    DateTime? manufactureDate,
    Object? expiryDate = _Undefined,
    String? distributionRegion,
    int? quantity,
    _i9kwsvqp.BatchStatus? status,
    Object? notes = _Undefined,
    Object? recallReason = _Undefined,
    Object? recalledAt = _Undefined,
    Object? recalledBy = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Batch(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      productId: productId ?? this.productId,
      reference: reference ?? this.reference,
      manufactureDate: manufactureDate ?? this.manufactureDate,
      expiryDate: expiryDate is DateTime? ? expiryDate : this.expiryDate,
      distributionRegion: distributionRegion ?? this.distributionRegion,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      notes: notes is String? ? notes : this.notes,
      recallReason: recallReason is String? ? recallReason : this.recallReason,
      recalledAt: recalledAt is DateTime? ? recalledAt : this.recalledAt,
      recalledBy: recalledBy is String? ? recalledBy : this.recalledBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
