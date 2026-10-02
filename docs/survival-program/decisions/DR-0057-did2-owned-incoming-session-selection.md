# DR-0057 — DID2 owned incoming session selection

Status: accepted local receive API contract; mailbox/ACK/device gates remain
Date: 2026-10-02
Decision owner: Mr. X (delegated architecture authority)

Keep current DPE2 and the existing protected messaging catalog. The internal
incoming-message entry accepts bounded encrypted bytes and the actual account
source, never a caller-selected session, SQL path/key or trusted callback flag.
Copy and canonically decode before asynchronous work. Under the actual account
lease, verify the current account/instance and read its protected catalog. Select
only the exact initialized session with matching network and both device IDs.
An alias rejects; unknown/uninitialized sessions never create a SQL session,
import state, query an arbitrary caller peer or authorize ACK.

The returned internal scope is key-free historical selection metadata, not
authentication or freshness. Release the lookup lease before independently
refreshing both endpoints from the protected stored peer credential. Then use
the existing account-owned DPE2 ratchet/commit/materialization path under its
own actual lease. All replay, current head/device, protected floor, initial-key
retirement and semantic materialization checks remain mandatory. No recursive
account acquisition or legacy session fallback.

There is one ordinary service receive entry. Remove the unused service overload
accepting a caller-selected scope; the owner's private scoped engine remains an
implementation detail after protected selection, never a second service path.

This consumer applies to existing ordinary pairwise sessions, including their
authenticated ContactAccept and AttachmentOffer events. It does not complete a
DPH2 initial contact, trust mailbox input, consume a traversal, or mint semantic
ACK. Mailbox Retrieve, protected received-page custody and materialization-before-
ACK orchestration, initial delivery, remote chunks/groups and physical Windows/
USB Android remain required connected gates.
