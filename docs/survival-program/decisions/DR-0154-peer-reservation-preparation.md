# DR-0154 — Protected peer preparation before native reservation

Status: accepted; implementation and connected qualification separate
Date: 2026-10-20
Owner: Mr. X (delegated authority)

The normative lifecycle owner is TRANSPORT-NEUTRAL-MESSAGING §3.1. PRQ2
verification must support a non-mutating, closed preparation followed by native
reservation. Preparation is NOT NewReserved, a receipt, mutation permission or
proof of persistence. Protocol alone constructs it after complete request,
membership and signature verification. Node records its exact prospective
replay/mutation identity in the existing independently protected document,
checks the actual current lease, and only then commits the native reservation.
Slow custody recovery must recheck an unaided first candidate's freshness at its
actual post-recovery clock before protecting/reserving it. A closed preparation
cannot freeze first-admission time; original source/owned admission evidence is
purpose-separated. Object expiry is checked again after recovery in every path.
No synchronous wait inside a native lock or simulated journal reservation.

The existing pending floor is a write-ahead intent: missing native replay is
recoverable ONLY when MutationCompleted=false and ResponseDigest is empty.
Its immutable digest must match the exact authenticated PRQ2 and an admission
second within the original closed 120-second window. Bounded enumeration of
those 121 seconds reconstructs only a hash-bound original, never caller time or
new authority. Full current admission and original object expiry still apply.
Missing completed replay, missing mutation after its protected completion,
extra native history, changed request and changed independent digest reject.
Native completion ahead of the pending response floor remains a recoverable
prefix: exact signed cached MRR2 must verify before its digest is anchored.

The already existing unpaired Pending is NOT covered by this preparation.
It must remain fail-closed until separately authenticated source evidence and
a reviewed recovery transition justify the exact original operation. Do not
delete it, accept it as authority, reset profiles, or substitute a fresh Store.

No wire, domain, schema generation, keys, timeout or grant lifetime changes.
New Protocol APIs are PrepareReplayReservation, PrepareOwnedAckReservation,
PrepareForwardedTombstoneReservation, CommitPreparedReservation and the closed
PreparedMailboxPeerReservationV2. Current synchronous verifiers remain valid
for owners with atomic native custody, not the split protected Node owner.
Positive interruption/reopen cases and negative custody/expiry/currentness
cases are required before connected activation.
