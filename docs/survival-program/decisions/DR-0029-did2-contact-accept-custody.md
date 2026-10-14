# DR-0029 — DID2 explicit contact acceptance custody

Status: **accepted local contract; Active/dispatch/ACK still gated**
Date: 2026-10-01
Decision owner: **Mr. X** (delegated architecture authority)

The sole protected journal grammar and byte capacity belong to
[DR-0063](DR-0063-did2-contact-reply-route-embedding.md#protected-acceptance-clean-break),
including its S04 consent-preserving payload retirement. Earlier generations
are rejected, not alternate readers or migration targets. Explicit consent,
exact winner and authenticated handoff claims remain.

## Explicit local command, not inferred consent

Only an explicit account-owner acceptance command authors the responder's
ContactAccept. Read the exact authenticated Hello from the retired active
DR-0027 session and recheck DR-0022 current endpoint metadata under the actual
account lease. Do not accept caller Hello, responder scope conversion, a
boolean consent flag or a fetched request as this command's evidence.

Before returning newly authored bytes, retain the exact Accept and operation in the
required protected `deep.store.v2.contact-accept-journal`, initialized atomically
with the account SQL key. Missing/foreign/old records require explicit reset.
The key-free journal has one current bounded reader defined by DR-0063.
Operation, scope and local
conversation/device positions are unique. The Accept binds network, local
account/device, relationship/conversation, exact Hello hash and sequence3.
Its logical ID is SHA256 of ASCII `Deep/STORE-V2/contact-accept-logical`, zero,
scopeHash32 and operation32. This is local authoring, not a new wire derivation.
Repeated explicit commands for the same exact pending scope return the same
winner/operation/Accept; never reauthor a timestamp or overwrite expired custody.
For a new command, reject an already expired Hello before allocating Accept
rendezvous or custody. Recheck its expiry against the final bounded Accept
creation interval before authoring; require a new Hello, not an extended one.
Current verification still applies to retained bytes. This command grants no
transport route, delivered status or mailbox ACK.
After separately verified terminal Store closure, the protected explicit-consent
commitment and actual native/semantic event remain independently mandatory;
retirement may remove only the redundant working payload. Exact cached replay
uses that native event and cannot restore working custody or first-encrypt a
missing operation. Consent/history is not a content-free outbox audit tombstone.

## Authenticated Accept handoff

Materialization requires the actual committed DR-0027 DPE2 row and exact pending
Hello, current DR-0022 Accept/Hello endpoint closure and directional role:
initiator receives responder Accept; responder authors/sends its own Accept.
A local send additionally must match its actual protected explicit-command
winner. Raw parsed Accept or the endpoint-author result alone is insufficient.
Use the existing DR-0028 account SQL transaction/fork/replay model, not another
database or V1 scope adapter. Local retained Accept reserves sender position3;
its local SQL high-water advances to at least4 atomically with materialization.
Ordinary text must not reuse that position. SQL and in-memory parity remain
mandatory; ContactAccept is never classified as direct text.

An authenticated pending Hello alone remains pending. Retained valid Accept
proves local acceptance or peer acceptance, not `Active`: both current message
reachability directions, protected semantic/outbox-counter rollback floors,
durable fanout/receipts and consent-aware MAUI composition still must close.
The semantic state machine and event bytes remain solely owned by
CONTACT-AND-GROUP-PROTOCOL-V1 sections7–9 and DR-0022. No DMC2 wire change.
