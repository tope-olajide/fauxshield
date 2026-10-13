# FauxShield — 2:30 product video script

Total runtime: ~2:30. Two columns: what the viewer sees, and what is said.
Pacing is deliberate; let the screen do work before the next line lands.

---

## Scene 1 — The problem  (≈0:00–0:35)

Visual:
- Black screen, then a fast montage of the kind of imagery you said you would use:
  - seized counterfeit bottles, labels, meds, parts
  - each one with a red cancel symbol over it
  - short text cards alternating with the images:
    - "Is this real?"
    - "Can the customer tell?"
    - "Can the brand prove it?"
- Cut to one clean shot of a genuine-looking product on a shelf, then a near-identical fake next to it.

Narration:
- "Counterfeit product is not a packaging problem. It is a trust problem."
- "A customer buys what looks like your product. A distributor moves it. A clinic, a shop, or another customer ends up with the fake."
- "By the time anyone proves it, the money is gone, the stock is mixed, and in some categories people get hurt."
- "And the hard part is not catching one fake unit. It is trying to do that at scale, across markets, with no easy way to tell the real thing from the copy."

Optional on-screen text during this scene:
- "Counterfeit goods move through the same supply chains as the real thing."
- "A QR code alone is not enough if anyone can copy it."

---

## Scene 2 — FauxShield as the solution  (≈0:35–0:55)

Visual:
- Clean transition. The FauxShield name/wordmark appears, then the public verify page URL concept:
  - a single short verification URL / QR scan experience
- Then the operator side: the command center app, briefly, with the dashboard and live feed visible.

Narration:
- "FauxShield is built for that trust gap."
- "It gives every unit you sell a verifiable identity: a signed QR code for the customer, and a hidden packaging PIN underneath."
- "A customer scans, enters the PIN, and gets a clear answer. Authentic, or not."
- "Behind that simple moment is a full platform: a product catalog, manufacturing batches, serialized units, live fraud signals, alerts, recalls, offline field scans, webhooks, and an audit trail."
- "For the customer, it feels like one scan. For the brand, it is a real anti-counterfeit system."

Optional on-screen text:
- "Serialized units, not copied codes."
- "PIN-protected verification."
- "Live fraud command center."

---

## Scene 3 — How it works  (≈0:55–1:55)

This is the spine of the video. Keep the flow: product → batch → unit → packaging → customer.

Visual 1 — Create a product
- Screen: the product form in the operator app.
- Fields shown: product name, SKU, category, description, packaging notes, shelf life, images.
- Narration:
  - "Start with the product. Name it, give it an SKU, describe it, add packaging notes and images."
  - "This is the thing customers will eventually verify."

Visual 2 — Create a batch
- Screen: create a batch for that product.
- Fields shown: batch reference or lot number, manufacture date, distribution region, planned quantity.
- Narration:
  - "Then create a manufacturing batch for that product."
  - "A batch is a real production run: a lot reference, when it was made, where it is meant to go, and how many units you plan to sell."

Visual 3 — Generate units
- Screen: generate identities for the batch.
- Show the result: a list of serialized units.
- Each unit card or row shows:
  - a QR token
  - a URL
  - a packaging PIN
- Narration:
  - "Now generate the units for that batch."
  - "For each unit, FauxShield creates a signed QR code, a verification URL, and a packaging PIN."
  - "These are not generic codes. They are the unit's identity."

Visual 4 — Packaging: QR on the outside
- Visual: product mockup. A label on the outside of the package with the QR code on it.
- Narration:
  - "The manufacturer attaches the QR code where customers can reach it easily."
  - "A label, a carton panel, a pouch, your packaging — the point is that the customer can scan it without opening the product."

Visual 5 — Packaging: scratchable PIN
- Visual: the same product, scratch panel emphasized.
- Narration:
  - "Underneath, there is a scratchable PIN."
  - "That PIN is what turns a scanned code into a real verification."
  - "Without it, the code is only half the proof."

Visual 6 — Hidden inside the product
- Visual: a few different packaging styles, showing that hiding the PIN is a design choice.
- Narration:
  - "The PIN can be hidden in the way that fits the product best."
  - "A seal that says do not buy if broken. A panel under the label. A foil scratch area. A hidden card inside the pack."
  - "You decide how to protect it. FauxShield gives you the verification; your packaging decides how hard the PIN is to get at."

Visual 7 — Manufacturer flexibility
- Visual: quick cuts of different attachment approaches.
- Narration:
  - "And the whole attachment strategy is up to the manufacturer."
  - "You choose how the QR code and the PIN live on the product."
  - "As long as the QR code or the unit can be tied back to your product and batch, FauxShield can verify it."

Visual 8 — Scale and worth
- Visual: a large shipment, many units, then a quick zoom into one unit being verified.
- Narration:
  - "Yes, this is more work up front than a printed code anyone can photocopy."
  - "You are serializing units, protecting PINs, and thinking about packaging."
  - "But compare that to the other side: the time spent chasing fakes, the money lost to counterfeit stock, and in some products the harm to people who trusted the wrong item."
  - "Set up once. Then every unit you ship carries real proof of what it is."

Optional on-screen text during scene 3:
- "Product → Batch → Units → QR + PIN → Packaging → Customer verification"
- "Visible: QR code / URL"
- "Hidden: scratchable packaging PIN"

---

## Scene 4 — The CLI, the SDKs, and the MCP  (≈1:55–2:30)

Visual 1 — CLI
- Screen: terminal.
- Show a realistic sequence using the actual commands:
  - create a product
  - create a batch for that product
  - mint units for the batch
  - list the units
- Keep the commands readable on screen; do not crowd the shot.
- Narration:
  - "FauxShield is not only an app."
  - "There is a CLI for the same API: create products, create batches, generate units, list them, verify a token, inspect alerts."
  - "If you already run operations from scripts or a terminal, this is the fast path."

Visual 2 — SDKs
- Screen: split view of SDK surfaces, for example:
  - Dart client import
  - Node SDK import
  - Python SDK import
- Narration:
  - "There are SDKs too, for Dart, Node, and Python."
  - "They speak the same API as the app and the CLI."
  - "That means you do not have to abandon your existing systems to use FauxShield."

Visual 3 — MCP
- Screen: an MCP client configuration snippet, then a tools list appearing.
- Show the catalog of tools concept:
  - list products
  - create product
  - list batches
  - create batch
  - generate units
  - list units
  - verify unit
  - list alerts
  - recall batch
- Narration:
  - "And if your team works through AI tools or agents, FauxShield also ships as an MCP server."
  - "It exposes the platform as tools an agent can call: product catalog, batches, units, verification, alerts, recalls, webhooks, simulations."
  - "The same rule applies: the agent can only do what the credential allows, and changes are still recorded."

Visual 4 — Integration message
- Screen: clean closing shot of the platform — app + terminal + SDKs/MCP together.
- Narration:
  - "The point is integration, not replacement."
  - "Manufacturers do not have to stop using their own website or build a whole new system just to add verification."
  - "You integrate FauxShield into what you already have: through the SDKs, the CLI, or the MCP."
  - "Same backend. Same verification. Many ways in."

Optional on-screen text:
- "CLI — same API, terminal-first"
- "SDKs — Dart, Node, Python"
- "MCP — agent-accessible tools"
- "Integrate it into your existing system"

---

## Suggested closing frame

Two options, whichever fits your brand:

Option A, product-led:
- "FauxShield: verifiable units, protected packaging, live fraud intelligence."
- Then the public verify URL concept and the operator app URL concept.

Option B, integration-led:
- "Serialize what you make. Protect what the customer checks. Integrate it where you already work."
- Then the CLI / SDK / MCP line.

---

## Notes for recording

- Scene 3 is the part to show carefully. The viewer should be able to trace:
  - product form → batch form → generate units → one unit's QR, URL, and PIN
- Do not narrate every field. Let the form and the resulting unit speak.
- For the packaging shots, it is enough to show:
  - QR on an accessible external surface
  - a scratchable or hidden PIN area
  - a note that the exact method is the manufacturer's choice
- The CLI and MCP shots should feel like real tooling, not a mockup:
  - real command structure
  - real tool names
- If you want the script tighter or longer, the easiest lever is scene 1 and scene 4. Scene 3 is the core and should stay intact.
