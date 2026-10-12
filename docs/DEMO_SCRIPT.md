# FauxShield demo video script (≤ 2 minutes)

Target length: **1:55**. Record at 1440p if possible; use the deployed URL so the
video matches the judges' experience. Keep the cursor deliberate and let the
live feed do the talking.

## Before recording

- Deployed (or local) server is running with a seeded demo workspace.
- Two browser windows ready:
  1. Landing page `https://<host>/`
  2. `/verify` page
- Operator app at `https://<host>/app`, signed in, demo workspace open.
- Close extra tabs; silence notifications.

## Shot list

| Time | Scene | On screen | Narration |
| --- | --- | --- | --- |
| 0:00–0:12 | **Hook** | Landing page. Slow scroll past the counters: products, serialized units, verifications, fraud alerts. | "Counterfeit goods cost brands billions. FauxShield serializes every unit a brand makes and verifies it in seconds — all on Serverpod 4." |
| 0:12–0:35 | **Consumer flow** | Click **Try demo code** → `/verify` shows the product, tap through to the PIN prompt → type the demo PIN shown on the landing page → verdict appears: **Authentic**. | "A shopper scans the code, enters the PIN from under the scratch panel, and gets an authoritative verdict — no account, no app. The session is device-bound, replay-protected, and the server only ever returns an allow-listed view." |
| 0:35–0:50 | **Report + recall** | Scroll to the result, tap **Report this product**, send a quick report. Switch to the app's **Alerts** tab: the consumer report is already in the triage queue. | "Suspicious products turn into consumer reports that land in the brand's triage queue immediately." |
| 0:50–1:15 | **Command center** | Operator app → **Dashboard** (stats, trend, outcome mix) → **Live** feed while a simulation runs. | "Operators get a live command center. Every scan, signal, and alert streams in over Serverpod's streaming channel." |
| 1:15–1:45 | **Attack rehearsal** | **More → Simulations → Clone attack** (fast pace). Cut to **Live** feed: verification events, then a clone signal, then a critical alert. Open the alert: evidence, signals, map. | "Teams rehearse real attacks through the real pipeline: a clone attack scans one token across distant cities until the fraud engine fires. Signals, risk score, and evidence are attached to the alert automatically." |
| 1:45–1:55 | **Close** | Flip to the catalog: batch → **Recall batch** → the recalled badge. End on the landing page or repo. | "Then it's one tap to recall a batch. QR identities, fraud intelligence, offline field inspections, webhooks, audit logs — FauxShield, built end to end with Flutter and Serverpod 4." |

## Alternative 30-second cuts

- **Journey cut:** landing → `/verify` authentic scan → simulation → alert → close.
- **Builder cut:** emphasize Serverpod features: 15 endpoints, streaming, future
  calls, offline sync, auth/RBAC, Serverpod Cloud deploy.

## Recording tips

- Use the live feed with the simulation paced at 2 seconds per step so events
  arrive while you narrate.
- Type the PIN with the on-screen keypad visible; it makes the flow obvious.
- If a step fails, re-record from the nearest checkpoint rather than editing
  around it — judges should see a clean, working system.
