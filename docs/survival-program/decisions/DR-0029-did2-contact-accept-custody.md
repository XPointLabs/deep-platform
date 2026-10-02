# DR-0029 — DID2 explicit contact acceptance custody

Status: **accepted local contract; Active/dispatch/ACK still gated**
Date: 2026-10-01
Decision owner: **Mr. X** (delegated architecture authority)

The version1 fixed journal grammar below is superseded by
[DR-0063](DR-0063-did2-contact-reply-route-embedding.md)'s version2-only
LP32 entries and byte capacity. It is not an alternate reader or migration
target. Explicit consent, exact winner and authenticated handoff claims remain.

## Explicit local command, not inferred consent

Only an explicit account-owner acceptance command authors the responder's
ContactAccept. Read the exact authenticated Hello from the retired active
DR-0027 session and recheck DR-0022 current endpoint metadata under the actual
account lease. Do not accept caller Hello, responder scope conversion, a
boolean consent flag or a fetched request as this command's evidence.

Before returning authored bytes, retain the exact Accept and operation in the
required protected `deep.store.v2.contact-accept-journal`, initialized atomically
with the account SQL key. Missing/foreign/old records require explicit reset.
The key-free journal uses version1/reserved-zero1/count:u16be/revision:u64be,
network16/account32/instance32 (92-byte header). Revision equals count+1.
At most128 entries, lexicographically sorted by operation32; each entry is
operation32, exact DR-0027 responder scope404, SHA256(exact Hello)32,
exact canonical ContactAccept960 (1428 bytes). Operation, scope and local
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
