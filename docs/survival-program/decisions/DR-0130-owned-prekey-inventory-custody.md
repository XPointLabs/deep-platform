# DR-0130 — owned prekey inventory custody

Status: accepted local-state allocation; connected implementation/qualification required
Date: 2026-10-16
Decision owner: Mr. X (delegated architecture authority)

The semantic owner remains [CONTACT-RESOLVER](../../architecture/CONTACT-RESOLVER-V1.md),
section3.3, and [DR-0129](DR-0129-owned-prekey-service-succession.md). The existing
initial-only store cannot replace its inventory: its receiver ledger and consumed
key deletion refer to that exact inventory. Resetting profiles, converting SQL
schemas or creating independent receiver ledgers is not this recovery path.

## One protected pointer, ordinary successors

Keep SQLCipher PKV2 schema4, its exact initial inventory, initial commit-pair
slot, receiver checkpoint/history and account instance unchanged. The existing
64-byte `deep.store.v2.prekey-inventory-tip` remains `scopeHash32 || XPP1Hash32`.
The scope hash is the existing account/device/DPD1/instance-bound owner hash;
the publication hash is raw SHA256 of exact XPP1. No caller-selected path, new
wire/API/suite/domain, compatibility reader or SQL migration is allocated.

For a successor, atomically CAS that exact pointer and insert the new protected
inventory record through the existing `CompareExchangeAndInsertAsync`. The slot
is `deep.store.v2.prekey-inventory/` followed by the lowercase64 hex publication
hash. It is not a caller label. An insertion collision or changed predecessor
must leave the whole previous state unchanged. No separate write emulation.
The account lease encloses selection, authoring, staging and reconciliation.

The initial SQL inventory is the chain's explicit base case, not a fallback:
the pointer may name it directly, or name an exact protected successor whose
predecessor chain ends at that exact initial publication. Missing noninitial
records, cycles, scope/hash substitution and disconnected chains reject. Never
search another generation or regenerate keys after such a failure. A pointer
that advanced to a successor cannot be explained by rolled-back initial SQL.
Capture the pointer again after traversal; a changed pointer invalidates the
read rather than mixing snapshots. Traversal is bounded by the existing secure
store entry limit. Protected records are custody, not currentness/dispatch facts.

## Private record layout

Version1 only, big endian integers, no optional/trailing fields. Header108 bytes:
`version:u8=1 || reserved3=0 || scopeHash32 || predecessorXppHash32 ||
publicationHash32 || exactXppLength:u32 || secretCount:u16 || reserved2=0`.
Then exact352-byte XPS1, exact XPP1 of the declared length, and `secretCount`
`LP32(sealedDPK2)` values in exact XPP1 one-time-member order followed by the
last-resort member. The publication's own canonical bounds/counts apply.
`secretCount == oneTimeCount+1`; scope and hashes are nonzero and predecessor
differs from the current publication. The record fits the unchanged1MiB
per-slot limit; global1024-slot/8MiB limits still apply before any mutation.
Do not raise limits or silently reduce the signed inventory. Local owned
authoring keeps its current32 one-time-key policy; larger remote inventories
remain independently supported by their existing wire verifier.

Sealed values use the existing `Dpk2PreKeyPersistenceProtector`, exact DPK2
binding and account/device persistence scope; no new crypto primitive or raw
secret export. Authoring validates exact complete public/private member
correspondence before sealing. Decode is bounded structural custody parsing,
not an authenticated claim or permission to restore/use a key. Native crypto,
full current complete inventory verification and actual protected history remain
independent owner requirements before release.

Zero-length sealed value denotes completed secret destruction only. New staging
requires every sealed value present. A reader may explain absence only from the
same authenticated global receiver ledger and its exact signed reuse limit.
An unexplained deletion rejects; historical public support stays intact.

## Integration and retention

Same-service epoch succession uses the existing exact XPI1 lineage. A service
successor uses DR-0129's same-device exact XPS1 link, starts XPI1 epoch1 and keeps
the existing service policy. Neither branch resets consumed claims or native
floors. Do not issue another inventory because a protected pending publication
timed out. Resume the exact retained XPP1, operation and sealed secrets.

Successor commit-pair custody is per publication at
`deep.store.v2.prekey-commit/` plus the same lowercase hash; it binds the same
scope/publication and exact two authenticated XIC1 as the initial pair. Both
replicas must be independently verified before recording it or adopting current
contact support. This does not change replica wire/state or admit new claims.

Keep one receiver SQL/checkpoint lineage for all inventories. A successor secret
is removed only after its exact receiver SQL commit and before protected
receiver stabilization; pending checkpoint recovery finishes that same deletion
idempotently. Do not copy keys into an untracked SQL row or leave a second secret
copy. Reopen validates every retained member and every explained deletion against
that global history before returning restored capabilities. Old pending Initial,
receiver imports, retirement journals and permanent replay fences retain their
existing authority. Service expiry/succession alone is not deletion evidence.

Account/source compaction readback must include the exact protected successor
chain, commit records and current pointer, as well as the unchanged original
encrypted SQL file and receiver checkpoint. Missing/changed data pins an active
cleanup plan. Resource pressure causes explicit backpressure before authoring/
dispatch, never eviction, slot reuse, nonce replacement or implicit reset.

## Required evidence / activation

Implement canonical parsing, atomic pending custody and exact chain recovery;
then integrate owner publication, current-support adoption, receiver consumption
and compaction readback together. Cover native authoring, actual encrypted
storage/reopen, concurrent successor CAS, cancellation/lost response, missing/
changed/rolled-back entries, hostile lengths, both epoch/service lineage,
consumption/crash windows and old pending Hello. Partial storage tests do not
activate the business path. Canonical source/package gates, matched replicas/
issuer/clients and retained-account Windows/Android E2E remain mandatory.
