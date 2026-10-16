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
