## 1.0.0

First production version of the FauxShield client, generated from the
fauxshield_server Serverpod server at 4.0.4.

- Typed models for the whole domain: products, batches, serialized units and
  packaging PINs, verification sessions and presentations, fraud alerts and
  signals, shopper reports, recalls, webhook endpoints and deliveries, attack
  simulations, API keys, workspace members and invitations, notifications,
  offline scans, audit events, and analytics summaries.
- Endpoint classes for authentication (email identity provider), products,
  batches, identities, alerts, verifications (consumer and operator),
  analytics, audit, recall, simulation, webhook administration, workspace and
  team, API keys, notifications, offline ingest, demo seeding, and live
  workspace events.
- Exception models for refused calls, all extending `ApiException`.
- `watchWorkspace()` stream for live command center events.

The package is generated. Change the `.spy.yaml` models or the endpoints in
`fauxshield_server` and regenerate rather than editing `lib/src/protocol/`.
