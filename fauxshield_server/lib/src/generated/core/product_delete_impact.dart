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

/// What a product deletion would touch, shown in the operator UI before the
/// delete or permanent purge is confirmed. Counts are for the product's whole
/// tree: batches, serialized units, verification sessions, and fraud alerts.
abstract class ProductDeleteImpact
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ProductDeleteImpact._({
    required this.productId,
    required this.productName,
    required this.batchCount,
    required this.identityCount,
    required this.verificationCount,
    required this.alertCount,
    required this.inRecycleBin,
  });

  factory ProductDeleteImpact({
    required _is.UuidValue productId,
    required String productName,
    required int batchCount,
    required int identityCount,
    required int verificationCount,
    required int alertCount,
    required bool inRecycleBin,
  }) = _ProductDeleteImpactImpl;

  factory ProductDeleteImpact.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductDeleteImpact(
      productId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['productId'],
      ),
      productName: jsonSerialization['productName'] as String,
      batchCount: jsonSerialization['batchCount'] as int,
      identityCount: jsonSerialization['identityCount'] as int,
      verificationCount: jsonSerialization['verificationCount'] as int,
      alertCount: jsonSerialization['alertCount'] as int,
      inRecycleBin: _is.BoolJsonExtension.fromJson(
        jsonSerialization['inRecycleBin'],
      ),
    );
  }

  _is.UuidValue productId;

  String productName;

  int batchCount;

  int identityCount;

  int verificationCount;

  int alertCount;

  /// True when the product already sits in the recycle bin, so the UI can
  /// label the destructive action as permanent.
  bool inRecycleBin;

  /// Returns a shallow copy of this [ProductDeleteImpact]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProductDeleteImpact copyWith({
    _is.UuidValue? productId,
    String? productName,
    int? batchCount,
    int? identityCount,
    int? verificationCount,
    int? alertCount,
    bool? inRecycleBin,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductDeleteImpact',
      'productId': productId.toJson(),
      'productName': productName,
      'batchCount': batchCount,
      'identityCount': identityCount,
      'verificationCount': verificationCount,
      'alertCount': alertCount,
      'inRecycleBin': inRecycleBin,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductDeleteImpact',
      'productId': productId.toJson(),
      'productName': productName,
      'batchCount': batchCount,
      'identityCount': identityCount,
      'verificationCount': verificationCount,
      'alertCount': alertCount,
      'inRecycleBin': inRecycleBin,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ProductDeleteImpactImpl extends ProductDeleteImpact {
  _ProductDeleteImpactImpl({
    required _is.UuidValue productId,
    required String productName,
    required int batchCount,
    required int identityCount,
    required int verificationCount,
    required int alertCount,
    required bool inRecycleBin,
  }) : super._(
         productId: productId,
         productName: productName,
         batchCount: batchCount,
         identityCount: identityCount,
         verificationCount: verificationCount,
         alertCount: alertCount,
         inRecycleBin: inRecycleBin,
       );

  /// Returns a shallow copy of this [ProductDeleteImpact]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProductDeleteImpact copyWith({
    _is.UuidValue? productId,
    String? productName,
    int? batchCount,
    int? identityCount,
    int? verificationCount,
    int? alertCount,
    bool? inRecycleBin,
  }) {
    return ProductDeleteImpact(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      batchCount: batchCount ?? this.batchCount,
      identityCount: identityCount ?? this.identityCount,
      verificationCount: verificationCount ?? this.verificationCount,
      alertCount: alertCount ?? this.alertCount,
      inRecycleBin: inRecycleBin ?? this.inRecycleBin,
    );
  }
}
