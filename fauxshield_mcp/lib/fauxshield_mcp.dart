/// Model Context Protocol server for the FauxShield anti-counterfeit platform.
///
/// It is a thin wrapper over the generated `fauxshield_client` SDK: every tool
/// is one API call, authorized with the caller's own API key or session token,
/// so an agent can never do more than the credential it was given.
library;

export 'src/config.dart';
export 'src/gateway.dart';
export 'src/server.dart';
export 'src/tool_support.dart';
export 'src/tools/catalog_tools.dart';
export 'src/tools/fraud_tools.dart';
export 'src/tools/operations_tools.dart';
export 'src/tools/platform_tools.dart';
