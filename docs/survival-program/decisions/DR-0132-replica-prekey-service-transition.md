# DR-0132 — replica prekey service transition

Status: accepted semantic allocation; source/runtime/device qualification required
Date: 2026-10-16
Decision owner: Mr. X (delegated architecture authority)

Owner: [CONTACT-RESOLVER §3.3](../../architecture/CONTACT-RESOLVER-V1.md).
DR-0129/0131 authored service successors cannot be activated against an
initial/same-service-only replica CAS. A signed service+1/epoch1 must not be
mistaken for a conflicting epoch of its predecessor service.

## Closed boundary, unchanged formats

Keep existing XPS1/XPI1/XPP1/XIC1 bytes, signatures, placement, native snapshot
and claim-state formats, limits and API signatures. No migration, compatibility
reader, new journal, reset, marker removal or resource extension is allocated.

The existing manifest `VerifySuccessor` remains a read-only structural lineage
verifier, not signature/currentness/commit authority. Within one service it keeps
the exact tags1..6, immediate epoch and prior XPI hash. Across services require
unchanged tags1..4, a nonoverflowing immediate service generation, changed exact
XPS reference, epoch1 and zero XPI predecessor. The XPS chain, not an old XPI
hash, links those two service generations. Every authoritative commit must
independently verify the complete current candidate and the XPS transition.

For a changed service the final committer holds the actual inventory lease and
reads the exact predecessor XPS from that predecessor operation's existing
bounded manifest under `did2-prekey-stage`. Its raw SHA256/version/generation
must match the exact XPS reference in the replica's node-signed durable manifest.
Missing, malformed, linked or substituted support rejects without changing the
active snapshot or clearing/creating a fork latch. This is existing historical
public custody, never a current authorization or another service's state.

Use DR-0131's one `VerifyServiceTransition` with the independently current exact
device key before commit; both signatures, scope, policy, immediate hash/gen,
issue and expiry rules remain mandatory. Recheck original current authority,
placement/time and cancellation after the historical read and before signing.
The expired predecessor is never passed off as current. A signed node snapshot
may reopen its two structurally linked committed slots without a network request;
its own signature still anchors their exact XPS references and accepted history.

Epoch equivocation is keyed by service generation plus epoch. Reuse of one
operation ID with different bytes is still a conflict across all retained slots.
True same-service forks remain permanently latched. Never clear an existing
latch based on this change; a bare prior marker does not prove its cause.
Retain claim reservations, counters, original operations and old receiver/Initial
custody. Neither a service transition nor native replay authorizes a fresh claim.

## Required evidence

Preserve the original real-signature false-fork failure. Test both replicas,
ordinary and expired-predecessor succession, cold reopen, exact old/new replay,
same-service equivocation and conflicting operation IDs. Fully signed invalid
XPS predecessor/generation/policy/window and missing/forged historical support
must reject before mutation; valid retry then succeeds. Currentness after read,
source/package gates and retained-account Windows/Android recovery are separate
requirements. This is not S05/S06 or release acceptance.
