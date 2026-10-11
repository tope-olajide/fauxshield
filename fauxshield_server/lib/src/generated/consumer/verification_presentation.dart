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
import '../core/branding.dart' as _i1x92ga0;
import '../enums/recall_scope.dart' as _ikvp6e9n;
import '../enums/risk_score.dart' as _ikrsd51m;
import '../enums/verification_outcome.dart' as _iq7ze9sg;
import '../enums/verification_state.dart' as _ikmf2cvr;
import '../verification/geo_summary.dart' as _ipimbe5a;

/// The allow-listed view of a verification shown to consumers. Contains only
/// what a consumer may see: brand presentation, product facts, outcome, and
/// recall state. No internal identifiers or fraud internals are exposed.
abstract class VerificationPresentation
    implements _is.SerializableModel, _is.ProtocolSerialization {
  VerificationPresentation._({
    required this.sessionId,
    required this.state,
    this.outcome,
    this.riskScore,
    required this.verifiedAt,
    required this.firstVerified,
    required this.verificationCount,
    this.location,
    this.branding,
    required this.workspaceName,
    this.authenticMessage,
    required this.productName,
    this.description,
    this.sku,
    required this.batchReference,
    this.imageUrls,
    this.packaging,
    this.shelfLife,
    this.countryRestrictions,
    this.safetyInstructions,
    this.recallReason,
    this.recalledAt,
    this.recallScope,
    required this.tokenMasked,
    this.verifyUrl,
    this.verifiedByThisDevice,
  });

  factory VerificationPresentation({
    required _is.UuidValue sessionId,
    required _ikmf2cvr.VerificationState state,
    _iq7ze9sg.VerificationOutcome? outcome,
    _ikrsd51m.RiskScore? riskScore,
    required DateTime verifiedAt,
    required bool firstVerified,
    required int verificationCount,
    _ipimbe5a.GeoSummary? location,
    _i1x92ga0.Branding? branding,
    required String workspaceName,
    String? authenticMessage,
    required String productName,
    String? description,
    String? sku,
    required String batchReference,
    List<String>? imageUrls,
    String? packaging,
    String? shelfLife,
    List<String>? countryRestrictions,
    String? safetyInstructions,
    String? recallReason,
    DateTime? recalledAt,
    _ikvp6e9n.RecallScope? recallScope,
    required String tokenMasked,
    String? verifyUrl,
    DateTime? verifiedByThisDevice,
  }) = _VerificationPresentationImpl;

  factory VerificationPresentation.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VerificationPresentation(
      sessionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['sessionId'],
      ),
      state: _ikmf2cvr.VerificationState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      outcome: jsonSerialization['outcome'] == null
          ? null
          : _iq7ze9sg.VerificationOutcome.fromJson(
              (jsonSerialization['outcome'] as String),
            ),
      riskScore: jsonSerialization['riskScore'] == null
          ? null
          : _ikrsd51m.RiskScore.fromJson(
              (jsonSerialization['riskScore'] as String),
            ),
      verifiedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['verifiedAt'],
      ),
      firstVerified: _is.BoolJsonExtension.fromJson(
        jsonSerialization['firstVerified'],
      ),
      verificationCount: jsonSerialization['verificationCount'] as int,
      location: jsonSerialization['location'] == null
          ? null
          : _ipgzzizd.Protocol().deserialize<_ipimbe5a.GeoSummary>(
              jsonSerialization['location'],
            ),
      branding: jsonSerialization['branding'] == null
          ? null
          : _ipgzzizd.Protocol().deserialize<_i1x92ga0.Branding>(
              jsonSerialization['branding'],
            ),
      workspaceName: jsonSerialization['workspaceName'] as String,
      authenticMessage: jsonSerialization['authenticMessage'] as String?,
      productName: jsonSerialization['productName'] as String,
      description: jsonSerialization['description'] as String?,
      sku: jsonSerialization['sku'] as String?,
      batchReference: jsonSerialization['batchReference'] as String,
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
      recallReason: jsonSerialization['recallReason'] as String?,
      recalledAt: jsonSerialization['recalledAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['recalledAt']),
      recallScope: jsonSerialization['recallScope'] == null
          ? null
          : _ikvp6e9n.RecallScope.fromJson(
              (jsonSerialization['recallScope'] as String),
            ),
      tokenMasked: jsonSerialization['tokenMasked'] as String,
      verifyUrl: jsonSerialization['verifyUrl'] as String?,
      verifiedByThisDevice: jsonSerialization['verifiedByThisDevice'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['verifiedByThisDevice'],
            ),
    );
  }

  _is.UuidValue sessionId;

  _ikmf2cvr.VerificationState state;

  _iq7ze9sg.VerificationOutcome? outcome;

  _ikrsd51m.RiskScore? riskScore;

  DateTime verifiedAt;

  bool firstVerified;

  int verificationCount;

  _ipimbe5a.GeoSummary? location;

  _i1x92ga0.Branding? branding;

  String workspaceName;

  String? authenticMessage;

  String productName;

  String? description;

  String? sku;

  String batchReference;

  List<String>? imageUrls;

  String? packaging;

  String? shelfLife;

  List<String>? countryRestrictions;

  String? safetyInstructions;

  String? recallReason;

  DateTime? recalledAt;

  _ikvp6e9n.RecallScope? recallScope;

  /// Fully masked token for display, for example ab12...ef90.
  String tokenMasked;

  String? verifyUrl;

  /// Set when THIS device (same stored fingerprint) completed an earlier
  /// verification of the same unit; carries the previous completion time so
  /// the UI can say "you already verified this on ...".
  DateTime? verifiedByThisDevice;

  /// Returns a shallow copy of this [VerificationPresentation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  VerificationPresentation copyWith({
    _is.UuidValue? sessionId,
    _ikmf2cvr.VerificationState? state,
    _iq7ze9sg.VerificationOutcome? outcome,
    _ikrsd51m.RiskScore? riskScore,
    DateTime? verifiedAt,
    bool? firstVerified,
    int? verificationCount,
    _ipimbe5a.GeoSummary? location,
    _i1x92ga0.Branding? branding,
    String? workspaceName,
    String? authenticMessage,
    String? productName,
    String? description,
    String? sku,
    String? batchReference,
    List<String>? imageUrls,
    String? packaging,
    String? shelfLife,
    List<String>? countryRestrictions,
    String? safetyInstructions,
    String? recallReason,
    DateTime? recalledAt,
    _ikvp6e9n.RecallScope? recallScope,
    String? tokenMasked,
    String? verifyUrl,
    DateTime? verifiedByThisDevice,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VerificationPresentation',
      'sessionId': sessionId.toJson(),
      'state': state.toJson(),
      if (outcome != null) 'outcome': outcome?.toJson(),
      if (riskScore != null) 'riskScore': riskScore?.toJson(),
      'verifiedAt': verifiedAt.toJson(),
      'firstVerified': firstVerified,
      'verificationCount': verificationCount,
      if (location != null) 'location': location?.toJson(),
      if (branding != null) 'branding': branding?.toJson(),
      'workspaceName': workspaceName,
      if (authenticMessage != null) 'authenticMessage': authenticMessage,
      'productName': productName,
      if (description != null) 'description': description,
      if (sku != null) 'sku': sku,
      'batchReference': batchReference,
      if (imageUrls != null) 'imageUrls': imageUrls?.toJson(),
      if (packaging != null) 'packaging': packaging,
      if (shelfLife != null) 'shelfLife': shelfLife,
      if (countryRestrictions != null)
        'countryRestrictions': countryRestrictions?.toJson(),
      if (safetyInstructions != null) 'safetyInstructions': safetyInstructions,
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
      if (recallScope != null) 'recallScope': recallScope?.toJson(),
      'tokenMasked': tokenMasked,
      if (verifyUrl != null) 'verifyUrl': verifyUrl,
      if (verifiedByThisDevice != null)
        'verifiedByThisDevice': verifiedByThisDevice?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VerificationPresentation',
      'sessionId': sessionId.toJson(),
      'state': state.toJson(),
      if (outcome != null) 'outcome': outcome?.toJson(),
      if (riskScore != null) 'riskScore': riskScore?.toJson(),
      'verifiedAt': verifiedAt.toJson(),
      'firstVerified': firstVerified,
      'verificationCount': verificationCount,
      if (location != null) 'location': location?.toJsonForProtocol(),
      if (branding != null) 'branding': branding?.toJsonForProtocol(),
      'workspaceName': workspaceName,
      if (authenticMessage != null) 'authenticMessage': authenticMessage,
      'productName': productName,
      if (description != null) 'description': description,
      if (sku != null) 'sku': sku,
      'batchReference': batchReference,
      if (imageUrls != null) 'imageUrls': imageUrls?.toJson(),
      if (packaging != null) 'packaging': packaging,
      if (shelfLife != null) 'shelfLife': shelfLife,
      if (countryRestrictions != null)
        'countryRestrictions': countryRestrictions?.toJson(),
      if (safetyInstructions != null) 'safetyInstructions': safetyInstructions,
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
      if (recallScope != null) 'recallScope': recallScope?.toJson(),
      'tokenMasked': tokenMasked,
      if (verifyUrl != null) 'verifyUrl': verifyUrl,
      if (verifiedByThisDevice != null)
        'verifiedByThisDevice': verifiedByThisDevice?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VerificationPresentationImpl extends VerificationPresentation {
  _VerificationPresentationImpl({
    required _is.UuidValue sessionId,
    required _ikmf2cvr.VerificationState state,
    _iq7ze9sg.VerificationOutcome? outcome,
    _ikrsd51m.RiskScore? riskScore,
    required DateTime verifiedAt,
    required bool firstVerified,
    required int verificationCount,
    _ipimbe5a.GeoSummary? location,
    _i1x92ga0.Branding? branding,
    required String workspaceName,
    String? authenticMessage,
    required String productName,
    String? description,
    String? sku,
    required String batchReference,
    List<String>? imageUrls,
    String? packaging,
    String? shelfLife,
    List<String>? countryRestrictions,
    String? safetyInstructions,
    String? recallReason,
    DateTime? recalledAt,
    _ikvp6e9n.RecallScope? recallScope,
    required String tokenMasked,
    String? verifyUrl,
    DateTime? verifiedByThisDevice,
  }) : super._(
         sessionId: sessionId,
         state: state,
         outcome: outcome,
         riskScore: riskScore,
         verifiedAt: verifiedAt,
         firstVerified: firstVerified,
         verificationCount: verificationCount,
         location: location,
         branding: branding,
         workspaceName: workspaceName,
         authenticMessage: authenticMessage,
         productName: productName,
         description: description,
         sku: sku,
         batchReference: batchReference,
         imageUrls: imageUrls,
         packaging: packaging,
         shelfLife: shelfLife,
         countryRestrictions: countryRestrictions,
         safetyInstructions: safetyInstructions,
         recallReason: recallReason,
         recalledAt: recalledAt,
         recallScope: recallScope,
         tokenMasked: tokenMasked,
         verifyUrl: verifyUrl,
         verifiedByThisDevice: verifiedByThisDevice,
       );

  /// Returns a shallow copy of this [VerificationPresentation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  VerificationPresentation copyWith({
    _is.UuidValue? sessionId,
    _ikmf2cvr.VerificationState? state,
    Object? outcome = _Undefined,
    Object? riskScore = _Undefined,
    DateTime? verifiedAt,
    bool? firstVerified,
    int? verificationCount,
    Object? location = _Undefined,
    Object? branding = _Undefined,
    String? workspaceName,
    Object? authenticMessage = _Undefined,
    String? productName,
    Object? description = _Undefined,
    Object? sku = _Undefined,
    String? batchReference,
    Object? imageUrls = _Undefined,
    Object? packaging = _Undefined,
    Object? shelfLife = _Undefined,
    Object? countryRestrictions = _Undefined,
    Object? safetyInstructions = _Undefined,
    Object? recallReason = _Undefined,
    Object? recalledAt = _Undefined,
    Object? recallScope = _Undefined,
    String? tokenMasked,
    Object? verifyUrl = _Undefined,
    Object? verifiedByThisDevice = _Undefined,
  }) {
    return VerificationPresentation(
      sessionId: sessionId ?? this.sessionId,
      state: state ?? this.state,
      outcome: outcome is _iq7ze9sg.VerificationOutcome?
          ? outcome
          : this.outcome,
      riskScore: riskScore is _ikrsd51m.RiskScore? ? riskScore : this.riskScore,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      firstVerified: firstVerified ?? this.firstVerified,
      verificationCount: verificationCount ?? this.verificationCount,
      location: location is _ipimbe5a.GeoSummary?
          ? location
          : this.location?.copyWith(),
      branding: branding is _i1x92ga0.Branding?
          ? branding
          : this.branding?.copyWith(),
      workspaceName: workspaceName ?? this.workspaceName,
      authenticMessage: authenticMessage is String?
          ? authenticMessage
          : this.authenticMessage,
      productName: productName ?? this.productName,
      description: description is String? ? description : this.description,
      sku: sku is String? ? sku : this.sku,
      batchReference: batchReference ?? this.batchReference,
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
      recallReason: recallReason is String? ? recallReason : this.recallReason,
      recalledAt: recalledAt is DateTime? ? recalledAt : this.recalledAt,
      recallScope: recallScope is _ikvp6e9n.RecallScope?
          ? recallScope
          : this.recallScope,
      tokenMasked: tokenMasked ?? this.tokenMasked,
      verifyUrl: verifyUrl is String? ? verifyUrl : this.verifyUrl,
      verifiedByThisDevice: verifiedByThisDevice is DateTime?
          ? verifiedByThisDevice
          : this.verifiedByThisDevice,
    );
  }
}
