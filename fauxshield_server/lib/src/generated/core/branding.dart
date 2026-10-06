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

/// Brand presentation for consumer-facing verification pages and app screens.
abstract class Branding
    implements _is.SerializableModel, _is.ProtocolSerialization {
  Branding._({
    this.displayName,
    this.logoUrl,
    this.themeColor,
    this.tagline,
  });

  factory Branding({
    String? displayName,
    String? logoUrl,
    String? themeColor,
    String? tagline,
  }) = _BrandingImpl;

  factory Branding.fromJson(Map<String, dynamic> jsonSerialization) {
    return Branding(
      displayName: jsonSerialization['displayName'] as String?,
      logoUrl: jsonSerialization['logoUrl'] as String?,
      themeColor: jsonSerialization['themeColor'] as String?,
      tagline: jsonSerialization['tagline'] as String?,
    );
  }

  /// Display name shown to consumers. Falls back to the workspace name.
  String? displayName;

  /// Public URL of the brand logo.
  String? logoUrl;

  /// Primary theme color as a hex string, for example #126B4F.
  String? themeColor;

  /// Short tagline shown under the brand name.
  String? tagline;

  /// Returns a shallow copy of this [Branding]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Branding copyWith({
    String? displayName,
    String? logoUrl,
    String? themeColor,
    String? tagline,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Branding',
      if (displayName != null) 'displayName': displayName,
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (themeColor != null) 'themeColor': themeColor,
      if (tagline != null) 'tagline': tagline,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Branding',
      if (displayName != null) 'displayName': displayName,
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (themeColor != null) 'themeColor': themeColor,
      if (tagline != null) 'tagline': tagline,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BrandingImpl extends Branding {
  _BrandingImpl({
    String? displayName,
    String? logoUrl,
    String? themeColor,
    String? tagline,
  }) : super._(
         displayName: displayName,
         logoUrl: logoUrl,
         themeColor: themeColor,
         tagline: tagline,
       );

  /// Returns a shallow copy of this [Branding]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Branding copyWith({
    Object? displayName = _Undefined,
    Object? logoUrl = _Undefined,
    Object? themeColor = _Undefined,
    Object? tagline = _Undefined,
  }) {
    return Branding(
      displayName: displayName is String? ? displayName : this.displayName,
      logoUrl: logoUrl is String? ? logoUrl : this.logoUrl,
      themeColor: themeColor is String? ? themeColor : this.themeColor,
      tagline: tagline is String? ? tagline : this.tagline,
    );
  }
}
