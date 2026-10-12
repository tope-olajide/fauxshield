## 1.0.0

First published version of the FauxShield MCP server.

- Speaks the Model Context Protocol on stdin/stdout, so an MCP-speaking
  client (Claude Desktop, Cursor, …) can read the fraud queue, pull evidence,
  and — with a key that has write scopes — work alerts and recalls, always
  attributed in the audit log.
- 55 tools covering the platform's endpoints, from catalogs and verifications
  to alerts, recalls, analytics, and the audit trail.
- `FAUXSHIELD_READ_ONLY=true` hides every mutating tool.
- Configuration comes from the environment (`FAUXSHIELD_URL`,
  `FAUXSHIELD_API_KEY` or `FAUXSHIELD_TOKEN`, workspace, read-only); a
  misconfiguration is one readable line on stderr and a non-zero exit instead
  of an empty tool list.
