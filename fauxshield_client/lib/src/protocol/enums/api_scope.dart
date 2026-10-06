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

enum ApiScope implements _isc.SerializableModel {
  productsRead,
  productsWrite,
  batchesRead,
  batchesWrite,
  identitiesRead,
  identitiesGenerate,
  identitiesExport,
  verificationsRead,
  fraudRead,
  fraudWrite,
  auditRead,
  analyticsRead,
  webhooksRead,
  webhooksWrite,
  teamRead,
  teamWrite;

  static ApiScope fromJson(String name) {
    switch (name) {
      case 'productsRead':
        return ApiScope.productsRead;
      case 'productsWrite':
        return ApiScope.productsWrite;
      case 'batchesRead':
        return ApiScope.batchesRead;
      case 'batchesWrite':
        return ApiScope.batchesWrite;
      case 'identitiesRead':
        return ApiScope.identitiesRead;
      case 'identitiesGenerate':
        return ApiScope.identitiesGenerate;
      case 'identitiesExport':
        return ApiScope.identitiesExport;
      case 'verificationsRead':
        return ApiScope.verificationsRead;
      case 'fraudRead':
        return ApiScope.fraudRead;
      case 'fraudWrite':
        return ApiScope.fraudWrite;
      case 'auditRead':
        return ApiScope.auditRead;
      case 'analyticsRead':
        return ApiScope.analyticsRead;
      case 'webhooksRead':
        return ApiScope.webhooksRead;
      case 'webhooksWrite':
        return ApiScope.webhooksWrite;
      case 'teamRead':
        return ApiScope.teamRead;
      case 'teamWrite':
        return ApiScope.teamWrite;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "ApiScope"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
