# DR-0129 — owned prekey service succession

Status: accepted semantic allocation; connected custody/runtime/device qualification remains
Date: 2026-10-16
Decision owner: Mr. X (delegated architecture authority)

The retained Android account reaches the existing authenticated XPI1 expiry
predicate. Its identity is intact. Replacing the account or extending the old
signed interval is not recovery. The sole semantic owner is
[CONTACT-RESOLVER](../../architecture/CONTACT-RESOLVER-V1.md), section3.3.

## Contact-object boundary

Supersede only DR-0076's exact XPS1-list immutability for a closed same-device
service successor. Keep the existing public author/verifier APIs, wire versions,
suite, domains, error codes, route/publication generation rules and two distinct
predecessor hash domains. No caller flag, mutable clock, generic signer or new
parsed-as-authoritative type is allocated.

Each current active device keeps exactly one descriptor in canonical directory
order. An unchanged descriptor must remain byte-identical. A changed descriptor
must have both exact predecessor and successor device signatures under that
same current DPD1 key; preserve network, service capability, device, DPD1 ref,
suite and signed inventory/reuse policy. Its generation is exactly predecessor+1
without overflow, and its predecessor is raw SHA256 of the exact prior XPS1 V2.
Issue time is nondecreasing and expiry strictly increases. A changed account,
device/DPD1, capability, policy, missing/duplicate/reordered service, skipped or
replayed generation, substituted predecessor or invalid signature rejects.
Existing current-time/service coverage checks independently constrain the new
bundle; the predecessor's expired interval is historical evidence only.

The owned object author must not hardcode XPS1 generation1 for a new contact
object. An independently versioned current signed XPS1 may already be at a later
generation when a reusable or one-time object is first created. Exact active
device/scope/signature/time checks remain mandatory before bundle signing and
at final release. This authors a candidate, not a replica inventory commit,
claim, consent, session, dispatch or current publication capability.

Preserve DCB bundle ID, identity/support, profile/policy, owner Retrieve capability
and permanent locator. DCB/XIR/publication generation advances exactly once and
binds the actual prior bundle/ciphertext/request/result as before. The same
lineage predicate must be used by client and independent issuer; do not activate
only one consumer. DR-0127 still controls nondecreasing contact-object validity.

## Connected owner work still required

Persist exact pending and committed inventory/service generations under the
actual account lease and protected tip. A timeout never regenerates a pending
inventory or publication intent. Complete authenticated two-replica publication
before adopting new current contact support. Retain prior DPK2 secret custody,
claimed offerings, receiver/Initial imports and replay floors until their own
existing retirement predicates permit deletion. A service successor is not
retirement evidence and must not resurrect consumed one-time keys.

The existing initial-only SQL store is not sufficient. Any additional protected
state/schema/API allocation must be frozen before its implementation. This
decision alone does not allocate a compatibility reader, reset, journal format,
resource-limit increase, nonce replacement or retrospective noncommit claim.

## Qualification

Retain original rejection, then verify real signed owned successor object and
independent issuer publication, including ordinary unchanged-service renewal
and further service generations. Cover signature/predecessor/scope/policy/
generation/overflow/window/ordering negatives before signing, callback expiry
and cancellation. Initial object with a current later-generation service also
requires positive and invalid-signature coverage. Predicate-only tests are not
native owner/issuer evidence. Protected crash/CAS/reopen, old pending Hello,
replica lineage, source/package gates and same-account physical Windows/Android
recovery remain separate mandatory requirements; this is not release approval.

## 2026-10-28 — bounded service lineage across interrupted publication

Accepted by Mr. X's delegated architecture authority. This amendment supersedes
the direct-contact-hop restriction above, not the per-hop XPS predicate. Retained
contact publication may lag independently committed prekey maintenance. A signed
intermediate XPS is historical lineage evidence, never a current service or a
reason to accept expired inventory. The actual retained case is contact XPS5,
signed XPS6 and current committed XPS7; signing another XPS6 is forbidden.

Allocate DCR1 V2 support kind3 to one exact 352-byte XPS1 V2. Keep the existing
u16 kind/u32 length framing, strict kind then raw SHA256 ordering, 16,384-byte
support cap, 65,535-byte DCR cap and 171,614-byte publication cap. Unknown kinds,
wrong widths, duplicates and trailing bytes reject. The count is exactly one
DRS1, one DPD1 per active device and the bounded intermediate XPS entries;
the existing byte cap permits at most45 intermediates before other support.
DCB tag12 still contains exactly one current XPS per active device. No new
primitive, outer publication version, compatibility reader or larger cap.

Each intermediate must belong to an active device, preserve its exact network,
service capability, DPD reference, suite and signed policy, and participate once
in a contiguous generation/hash chain ending at that device's current DCB XPS.
Every adjacent pair uses the unchanged VerifyServiceTransition predicate and
the independently current device key. Foreign, dangling, cyclic, duplicate,
unused or endpoint witnesses reject. Generic resolve authenticates this suffix
but cannot infer that its left boundary was a published contact: that boundary
reference alone is not publication evidence.

Both owned successor author and independent publication issuer additionally
anchor the full chain in their actual authenticated prior DCR. The witness set
is exactly the strict intermediates between that prior XPS and the candidate;
no omitted hop, unnecessary prefix or witnesses for an unchanged/direct-adjacent
service are allowed. Current endpoint freshness, authority, policy, inventory
and the two exact replica receipts remain independently mandatory. Historical
intermediates need signed structural verification, not fabricated old AccountProofs
or live validity. Their expired intervals are neither extended nor published.

Shared selects this exact chain from authenticated protected prekey history,
deduplicating identical XPS records repeated across inventory epochs. It retains
all original keys and contact intents. Protocol, Shared, Registry and XNode must
build with the same allocation; no one-sided runtime activation. Frozen machine
inputs and matching hostile vectors must be updated before connected testing.
Qualification includes unchanged/direct-hop cases, signed5→6→7 owned author and
independent issuer, and omission/foreign/duplicate/order/cycle/dangling/unused/
signature negatives. This allocation does not resolve an expired threshold
reservation; that distinct lifecycle belongs to DR-0078.
