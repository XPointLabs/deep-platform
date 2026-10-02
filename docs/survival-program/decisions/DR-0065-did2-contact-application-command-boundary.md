# DR-0065 — DID2 contact application commands and key-free UI handles

Status: **accepted application boundary; connected/live/device activation gated**
Date: 2026-10-02
Decision owner: **Mr. X** (delegated architecture authority)

Expose the already owned DR-0063/64 vertical as business commands, not raw
Init/Hello/DPE2, ratchet state, peer proofs, keys, routes, signers or callbacks.
No wire, cryptographic primitive, protected grammar or legacy reader changes.
Normative business owner remains CONTACT-AND-GROUP-PROTOCOL and CONTACT-CLIENT-01.

## Public boundary

- Start consumes the canonical DID2 address, a nonzero stable intent32 and the
  source bound to this actual account. Own all mutable operation bytes before
  the first await. UI retains/reuses the intent for an explicit retry; it must
  not allocate a new intent just because an outcome is unknown. Authenticate
  permanent resolve, retain/reopen DR64 draft, complete/recover actual sender,
  import and retire initial keys, then Store through the existing selected-entry
  engine. No public caller chooses events, prekey service, time or endpoint.
- Return an internally constructed, key-free conversation handle and the
  existing mailbox Store receipt. The handle wraps actual protected catalog
  metadata only, not identity, acceptance, delivery, freshness or ACK authority.
  It has no public constructor/restorer, raw scope or key/state export. Every
  use independently rechecks the actual account/instance/catalog/peer.
- List reads actual current protected catalog under the owner lease; project
  initialized sessions only. After release independently refresh each endpoint
  pair and read authenticated acceptance state. Do not persist a trust marker
  in the UI or silently fall back to an old cached projection on verification
  failure. Phase1 work remains resumable by its original explicit Start intent.
  A separate bounded local start-operation projection exposes intent32, peer
  DID2 hash and retained Hello creation/expiry only. It reads the actual mandatory
  DR64 root under the account lease and grants no peer/network/transport authority.
  UI matches canonical descriptor hash and reuses the newest retained intent
  across restart; an expired or substituted intent is rejected by Start, not
  silently replaced. A separately explicit new request may choose a new intent.
- Accept consumes only the handle, stable local operation32 and account source.
  The owner must be the pending recipient. Retain the existing explicit Accept
  winner; send its actual returned operation/bytes; Store via authenticated
  Hello private route. Repeat retains the original winner, not the new input ID.
- Text consumes handle, stable operation32, text and source. Require actual
  local/peer acceptance according to initiator/responder role before authoring.
  Retain the exact owned text outbox event, send through current ratchet custody,
  then Store via the authenticated private route. Retry cannot change the text,
  event, operation or ciphertext. Message list exposes only actual authenticated
  semantic SQL rows; no caller materialization flag or raw envelope.
- Synchronize is the existing bounded owned page/semantic-before-ACK command.
  UI may explicitly poll or schedule bounded cancellation-aware polling, but
  must not construct ACK items, treat socket write as delivery or auto-accept.

## Ownership, failure and composition

Transport-injection overloads stay internal for connected fixture evidence.
Shipping commands construct only the existing account-owned ONION/grant engine;
no fixed node URL, direct Registry fallback, mock evidence or hidden retry.
Unknown Store/claim/cancellation retain exact custody for explicit reconciliation;
never create a replacement logical operation to make an error disappear.
Mailbox receipt is durable storage evidence, not peer acceptance/read receipt.
UI maps error classes to fixed sanitized text; never display/log private exception
messages, addresses, capabilities, payloads or host details in diagnostics.

MAUI keeps pre-clean-break visual language/layout, but uses a DID2-only ViewModel
and these handles; no old Session contact/runtime adapter. Native signed fixture
evidence must be joined to the new command consumers, then Windows/USB Android
must exercise actual contact/accept/text/restart. BLOB and governed groups require
their real independent owners and device evidence; they cannot be simulated by
local ciphertext copies or unsequenced fanout. Full API/graph review and consumer
repins remain final batch gates before release. Three production nodes remain.
