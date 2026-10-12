import 'dart:io';

import 'package:fauxshield_mcp/fauxshield_mcp.dart';

/// Starts the FauxShield MCP server on stdin/stdout.
///
/// A misconfiguration is reported as one readable line on stderr and a non-zero
/// exit, because the client would otherwise show an empty tool list with no
/// explanation. The server only claims stdout once it is configured.
Future<void> main(List<String> arguments) async {
  if (arguments.contains('--version') || arguments.contains('-v')) {
    stdout.writeln('fauxshield-mcp $mcpServerVersion');
    return;
  }
  if (arguments.contains('--help') || arguments.contains('-h')) {
    stdout
      ..writeln('fauxshield-mcp $mcpServerVersion')
      ..writeln()
      ..writeln('Speaks the Model Context Protocol on stdin/stdout.')
      ..writeln('Configure it with environment variables:')
      ..writeln('  FAUXSHIELD_URL             API base URL')
      ..writeln('  FAUXSHIELD_API_KEY         API key (fs_live_...)')
      ..writeln('  FAUXSHIELD_TOKEN           session JWT instead of a key')
      ..writeln('  FAUXSHIELD_WORKSPACE_ID    workspace to act on')
      ..writeln('  FAUXSHIELD_READ_ONLY       true to hide all mutating tools');
    return;
  }

  try {
    await runFauxShieldMcp();
  } on McpConfigError catch (error) {
    stderr.writeln('fauxshield-mcp: ${error.message}');
    exitCode = 78; // EX_CONFIG
  } catch (error) {
    stderr.writeln('fauxshield-mcp: failed to start: $error');
    exitCode = 1;
  }
}
