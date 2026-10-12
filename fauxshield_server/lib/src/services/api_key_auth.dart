import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../generated/protocol.dart';
import 'api_key_service.dart';
import 'rbac.dart';

/// The permission each API scope grants.
///
/// Scope names mirror the permission list one to one, so a machine key can
/// only do what an operator with the same capability can do. Anything absent
/// from this table (revealing a PIN, running simulations, managing other keys,
/// changing the workspace or the team) is operator-only and cannot be granted
/// to a key at all.
const Map<ApiScope, Permission> scopePermissions = <ApiScope, Permission>{
  ApiScope.productsRead: Permission.productsRead,
  ApiScope.productsWrite: Permission.productsWrite,
  ApiScope.batchesRead: Permission.batchesRead,
  ApiScope.batchesWrite: Permission.batchesWrite,
  ApiScope.identitiesRead: Permission.identitiesRead,
  ApiScope.identitiesGenerate: Permission.identitiesGenerate,
  ApiScope.identitiesExport: Permission.identitiesExport,
  ApiScope.verificationsRead: Permission.verificationsRead,
  ApiScope.fraudRead: Permission.fraudRead,
  ApiScope.fraudWrite: Permission.fraudWrite,
  ApiScope.auditRead: Permission.auditRead,
  ApiScope.analyticsRead: Permission.analyticsRead,
  ApiScope.webhooksRead: Permission.webhooksRead,
  ApiScope.webhooksWrite: Permission.webhooksWrite,
  ApiScope.teamRead: Permission.teamRead,
  ApiScope.teamWrite: Permission.teamWrite,
};

/// The scope an endpoint permission needs, when a key can be granted it.
ApiScope? scopeForPermission(Permission permission) {
  for (final entry in scopePermissions.entries) {
    if (entry.value == permission) return entry.key;
  }
  return null;
}

/// The permissions a key's scopes add up to.
///
/// `workspaceRead` is always included: a key belongs to exactly one workspace
/// and every endpoint needs the caller to be able to read it.
Set<Permission> apiKeyPermissions(List<ApiScope> scopes) => <Permission>{
  Permission.workspaceRead,
  for (final scope in scopes)
    if (scopePermissions[scope] != null) scopePermissions[scope]!,
};

/// Prefix that marks the identity of a request authenticated with an API key.
///
/// Keeping the marker in the identity string lets the workspace gate tell a
/// machine caller from a signed-in operator without another database read, and
/// makes the caller obvious in audit records and `createdBy` columns.
const String apiKeyIdentifierPrefix = 'api-key:';

/// The audit and authorization identity for [apiKeyId].
String apiKeyIdentifier(UuidValue apiKeyId) =>
    '$apiKeyIdentifierPrefix${apiKeyId.uuid}';

/// Whether [userIdentifier] belongs to an API key rather than a person.
bool isApiKeyIdentifier(String userIdentifier) =>
    userIdentifier.startsWith(apiKeyIdentifierPrefix);

/// Reads the key id out of an API key identity, or null when malformed.
UuidValue? apiKeyIdFromIdentifier(String userIdentifier) {
  if (!isApiKeyIdentifier(userIdentifier)) return null;
  final raw = userIdentifier.substring(apiKeyIdentifierPrefix.length);
  try {
    return UuidValue.fromString(raw);
  } catch (_) {
    return null;
  }
}

/// Adds API key authentication in front of the token manager [inner].
///
/// Machine keys are prefixed ([FauxShieldLimits.apiKeyPrefix]) so the check is
/// a string comparison on the common path: a bearer token that is not a key is
/// handed straight to the token manager. A recognized key resolves to the
/// identity `api-key:<id>`; `WorkspaceService` then loads the key to scope the
/// request, which is also where the rate limit is enforced. When no token
/// manager is installed, a non-key bearer token is simply not authenticated.
AuthenticationHandler withApiKeyAuthentication(AuthenticationHandler? inner) {
  return (Session session, String token) async {
    if (!token.startsWith(FauxShieldLimits.apiKeyPrefix)) {
      return inner == null ? null : inner(session, token);
    }
    final apiKey = await ApiKeyService.authenticate(session, token);
    if (apiKey == null) return null;
    return AuthenticationInfo(
      apiKeyIdentifier(apiKey.id!),
      <Scope>{Scope.none},
      authId: apiKey.id!.uuid,
    );
  };
}
