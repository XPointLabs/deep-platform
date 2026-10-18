# DR-0144 — Multi-account owned group batches

Status: accepted implementation allocation; qualification remains separate
Date: 2026-10-18
Decision owner: Mr. X (delegated authority)

Supersede DR-0143's two-account candidate limit. Use the existing sequential
ActivateAcceptedInvite reducer and exact current DID2 capabilities for every
member. Missing member lookups while holding the account lease borrow only the
actual same-account SQL/marker backend, with unchanged verification and durable
floor CAS; they cannot recursively acquire that lock or accept a caller store.
Retain the complete predecessor lineage and independently scoped
invitation/consent pairs. A member is active only if the verified commit includes
that account and device; receiving another member's lineage is not consent.

Allocate protected group journal generation2, rejecting generation1 without a
migration. Keep the existing bounds on total bytes, groups and outgoing events;
allow up to100 sequential packages and100 invitation pairs per group. Preserve
old isolated profiles as evidence and use new profiles for this clean break.
No wire, cryptographic suite or ordinary-journal generation changes.
Historical package verification evaluates consent/proposal windows at its signed
commit time. Fresh authors still require unexpired consent now, and every device/
directory capability remains independently current. A stored membership does not
expire merely because its original invitation did; no historical identity or
GSR1 transport authority is inferred from this correction.

Before any network dispatch, snapshot all current remote member/device targets,
their exact accepted sessions, one identical semantic DGM1 and independent outer
operations/sequences. Missing or ambiguous sessions reject the entire preparation.
Persist all targets atomically. Use bounded target workers, preserving per-session
order and exact unknown-outcome retries. Current global-account transport loans
must queue account operations outside the file-lock wait; parallel wire loans
remain an explicit scaling prerequisite, not a claim of this3-account candidate. Local
history deduplicates the semantic event, not its target copies.

The current implementation still rejects multi-device accounts until their
enrollment/session composition is qualified. Three-account correctness does not
qualify the20/100 or100/500 scale gates. GSR1 remains the separate long-offline
control owner; ordinary mailbox delivery cannot substitute for its two-replica
receipts, retention or explicit gap semantics. No device or release activation.
