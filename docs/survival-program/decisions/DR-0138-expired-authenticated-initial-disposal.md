# DR-0138 — Terminal disposal of an authenticated expired Initial

Status: accepted bounded contract; source and physical qualification remain
Date: 2026-10-17
Decision owner: Mr. X (delegated architecture authority)

An expired first ContactHello must neither become a live contact/session nor
permanently block its captured mailbox page. Parsed expiry, a callback result,
an SQL flag or an expired XUR alone cannot authorize disposal.

## Closed Protocol handoff

`OwnedGenesisDeviceSecrets.PrepareInitialMailboxSessionAsync` has the same
verified claim, endpoint, restored-prekey, clock, ratchet-limit and cancellation
inputs as the existing strict `PrepareInitialSessionAsync`. Its sealed
`ResponderInitialMailboxPreparation` transfers exactly once either the existing
live capability (`ConsumeLive`) or a sealed
`ResponderExpiredInitialAtomicStorePayload` (`ConsumeExpiredForAtomicStore`).
`IsExpired` is selection metadata, never ACK authority. Neither new type has a
public constructor or accepts caller-authored success/expiry flags.

Only the owned AEAD-authenticated SessionInit plus first ContactHello can enter
the terminal branch. Verify exact claim/reservation, current recipient and
initiator proof, original XUR signature/device/directory/conversation/safety
bindings at creation, protected clock continuity, and recipient protected
**lower** bound at or beyond the ceiling in seconds of **both** DMC expiries.
An upper-bound-only overlap, unknown event kind, forged signature, changed
device scope or cancellation fails closed. Live first admission retains its
current-XUR and current-time checks. The existing strict preparation never
returns an expired event as a live capability.

Before returning expired custody, destroy the derived ratchet state. The
terminal payload exposes only the matching reservation, exact authenticated
SessionInit/ContactHello, `ProvenLowerUnixSeconds` and `DiscardedStateHash`.
It exposes no TRS, key, mutable session or factory. Preparation is not durable
consumption, consent, materialization or ACK.

## Existing native atomic owner

Use the existing bounded receiver ledger, protected pending/stable checkpoint
and atomic prekey-consumption transaction. The private current receiver record
header byte6 is the closed disposition:0 live,1 expired disposal; byte7 stays0.
The terminal stored-state blob is exactly40 bytes: proven lower `u64be` then
discarded-state SHA256. Its exact length/hash remain in the existing header.
It must exist and validate on every terminal read; missing state is never
interpreted as disposal. No new table, slot, version, compatibility reader,
retention bound, eviction or account reset is introduced. Existing live records
and their native key-retirement rules are unchanged.

Atomically consume the selected one-time key or exact last-resort use with the
terminal receipt. Recover the exact pending transaction after crash; reject
substitution, duplicate use and rollback. Terminal records cannot be imported
as mutable messaging sources, retired as transferred ratchet keys or registered
in the messaging catalog. Durable replay requires that exact native receipt,
not a repeated expired-plaintext admission or now-live old XUR.

## Current independent ACK

The mailbox owner independently rereads the exact native receipt and protected
history, checks current own account/device/floor/time and absence of live
catalog registration for that session. Only then can the existing current ACK
path include that exact captured cursor/digest. It still requires the actual
protected page, SQL/read-back, fresh grant/holder/route/replica authority and
durable tombstone quorum. No callback boolean or session-shaped placeholder.
No expired grant, pending ACK, pagination or peer Store authority is renewed by
this decision. After completed ACK, the next ordinary poll remains necessary.

Qualify live/expired, ambiguous time, malformed/wrong-scope, cancellation,
single-use, native crash/reopen/tamper/missing proof/prekey consumption and exact
page ACK before device acceptance. Package/API/frozen input and matching
physical qualification remain separate; S05 and release are not accepted.
