# FauxShield demo video script (≤ 2 minutes)

Target length: **1:55**. Record at 1440p if possible; use the deployed URL so the
video matches the judges' experience. Keep the cursor deliberate and let the
live feed do the talking.

## Before recording

- Deployed (or local) server is running with a seeded demo workspace.
- Operator app at `https://<host>/app`, signed in, demo workspace open.
- A second window on the `/verify` page, with one unit's token and PIN copied
  from the catalog beforehand. That window is the shopper scene: QR token →
  PIN entry → authentic/flagged verdict.
- Close extra tabs; silence notifications.

## How the consumer verification flow actually works

This is the part of the script you are recording, so it should match the
implementation exactly:

1. **Scan / open the code** — A product's QR code encodes a FauxShield
   verification URL, usually `https://<host>/verify?t=<token>`. Opening it hits
   the consumer verification route on the server. No app, no account, no sign-in.

2. **Token resolution** — The server looks up the token as a `ProductIdentity`
   row. Each token is cryptographically random, and it is signed with HMAC-SHA256
   over workspace, product, identity, and token, so a copied token from a
   different product or tenant fails immediately. The server starts a
   `VerificationSession` bound to the device fingerprint and the caller's
   network location. Geo is looked up from the IP at city level — the platform
   never asks for device GPS.

3. **Fraud scoring before the PIN prompt** — Before the shopper ever sees a PIN
   field, the fraud engine runs. Clone detection, velocity, PIN attack, batch
   duplication, distributor leakage, and grey market are evaluated against the
   brand's `FraudPolicy`. If the scan is clean, the session lands on the PIN
   prompt. If it is already suspicious, the server short-circuits straight to the
   result screen and the shopper never gets to the PIN step.

4. **PIN entry** — The packaging PIN is 6 digits, printed under a scratch panel.
   The server stores a PBKDF2 hash of it. When the shopper types the PIN and
   submits, the identity row is locked for the transaction so two PIN attempts
   cannot race the counter. A correct PIN advances the session to the result
   screen; a wrong one increments the failed-attempt counter. After 5 failures the
   identity is temporarily locked and the shopper gets a lockout message.

5. **The verdict** — What the shopper sees is an allow-listed
   `VerificationPresentation`, built from the session, the identity, the batch,
   the product, and the brand's workspace settings. Possible outcomes, in
   precedence order:
   - `recalled` — the unit or its batch was recalled; show the recall notice and
     tell the shopper to stop using the product.
   - `fraudSuspected` — the session was flagged before or during the scan; the
     brand's fraud team was alerted, the identity is locked.
   - `invalidPin` — the PIN did not match.
   - `highRisk` — the code is genuine but the scan pattern looks unusual.
   - `alreadyVerified` — this unit was verified before, possibly from another
     device.
   - `authentic` — the code resolves to a registered unit and the PIN matched.

   The page shows the brand name, product, SKU, masked token, batch reference,
   approximate location, verification count, and any brand-supplied message,
   packaging notes, shelf life, restricted countries, and safety instructions.

6. **What happens after the shopper leaves** — A completed verification publishes a
   live event to the workspace channel and enqueues a webhook. If the scan
   triggered fraud, an alert is created with the signals, risk score, and evidence
   attached, the team is notified, and if the policy says so the identity is locked
   automatically. A shopper can also tap "Report a suspicious product" from the
   result screen; those reports land in the brand's triage queue immediately.

The important nuance for the demo narration: the PIN is only one part of the
answer. The authenticity verdict is the combination of token integrity,
device-bound session, fraud scoring, and PIN matching. That is why a copied code
usually never reaches the PIN prompt in the first place.

## Shot list

| Time | Scene | On screen | Narration |
| --- | --- | --- | --- |
| 0:00–0:12 | **Hook** | Landing page. Slow scroll past the counters: products, serialized units, verifications, fraud alerts. | "Counterfeit goods cost brands billions. FauxShield serializes every unit a brand makes and verifies it in seconds — all on Serverpod 4." |
| 0:12–0:35 | **Consumer flow** | Cut to the `/verify` window with the token already in the URL: the product resolves, the PIN prompt appears, type the PIN → verdict appears: **Authentic**. Then cut back to the app's **Verify a product** screen running the same flow with **Demo unit**. | "A shopper scans the code, enters the PIN from under the scratch panel, and gets an authoritative verdict — no account, no app. The session is device-bound, replay-protected, and the server only ever returns an allow-listed view." |
| 0:35–0:50 | **Report + recall** | Scroll to the result, tap **Report this product**, send a quick report. Switch to the app's **Alerts** tab: the consumer report is already in the triage queue. | "Suspicious products turn into consumer reports that land in the brand's triage queue immediately." |
| 0:50–1:15 | **Command center** | Operator app → **Dashboard** (stats, trend, outcome mix) → **Live** feed while a simulation runs. | "Operators get a live command center. Every scan, signal, and alert streams in over Serverpod's streaming channel." |
| 1:15–1:45 | **Attack rehearsal** | **More → Simulations → Clone attack** (fast pace). Cut to **Live** feed: verification events, then a clone signal, then a critical alert. Open the alert: evidence, signals, map. | "Teams rehearse real attacks through the real pipeline: a clone attack scans one token across distant cities until the fraud engine fires. Signals, risk score, and evidence are attached to the alert automatically." |
| 1:45–1:55 | **Close** | Flip to the catalog: batch → **Recall batch** → the recalled badge. End on the landing page or repo. | "Then it's one tap to recall a batch. QR identities, fraud intelligence, offline field inspections, webhooks, audit logs — FauxShield, built end to end with Flutter and Serverpod 4." |

## What to show during the consumer-verification cut

If you want the shot to be unambiguously correct, sequence it like this:

1. Start with the token already in the URL bar:
   `https://<host>/verify?t=<paste a real demo identity token>`
2. The page should resolve the product name, masked token, and batch reference,
   then ask for the 6-digit PIN.
3. Type the PIN with the keypad visible. The result screen should read
   **This product is authentic** for a clean demo unit.
4. Optional second pass: use a recalled or fraud-suspected demo unit and show a
   different verdict. Do not fake the result with an edit; the point of the demo
   is that the server decides.

If you need a clean authentic shot and a clean flagged shot in the same take,
use two different browser tabs and two different demo units. That is easier to
stage than trying to drive one tab into a fraud outcome on cue.

## Recommended narration for the consumer-verification cut

> "A shopper scans the QR code on the packaging and lands on a verification page.
> The server first checks the code itself — it is cryptographically signed to one
> product and one brand, so a copied code fails immediately.
>
> Then it scores the scan for fraud before the shopper ever sees the PIN field.
> If the code is clean, the page asks for the six-digit PIN under the scratch
> panel. That PIN is hashed, so the server is checking a fingerprint, not storing
> the number.
>
> When the PIN matches, the shopper gets the brand's authoritative verdict: the
> product is authentic, recalled, or flagged. Every completed scan streams into the
> command center and can fire a webhook, so the brand sees real verifications and
> real attacks as they happen."

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
- For the consumer cut, copy the token and PIN from the catalog, not from
  memory. A mistyped PIN is the most common way this shot goes wrong.
