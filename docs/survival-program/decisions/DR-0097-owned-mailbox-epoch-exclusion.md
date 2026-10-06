# DR-0097 — account-owned mailbox epoch-exclusion prerequisite

Status: accepted bounded S01 contract/API; source-qualified locally, cleanup inactive
Date: 2026-10-06
Decision owner: Mr. X (delegated architecture authority)

## Decision and sole owners

Freeze the narrow epoch-exclusion producer/consumer in
[TRANSPORT-NEUTRAL-MESSAGING §8.4.2](../../architecture/TRANSPORT-NEUTRAL-MESSAGING.md#842-grant-and-route-transitions).
That section owns its evidence/error/reopen obligations; Shared owns the
[internal local API](../../../deep-client-shared/docs/architecture/owned-mailbox-grant-custody.md#held-epoch-exclusion-prerequisite).
No wire, magic, crypto suite, signature domain, public Protocol API, local
generation or new persisted marker is allocated. Existing grant generation5
and actual account-owned DNH2/anchor remain the sole durable inputs.

The non-serializable capability retains the actual account writer lease and
must be rechecked by the consuming owner. Original acquisition/root binding
and independently current signed policy/floor verification are not caller
options. A copied acquisition/root hash is a selector/fact, not an authority.
Cold reopen remints from actual protected custody and fresh signed evidence;
it never deserializes a deletion permission or infers trust from an empty store.

## Why this boundary

DR-0096 prevents an accepted PMT2 chain from returning to an old epoch, but an
operational refresh normally preserves the epoch. Expiry alone does not close
the complete namespace contract. The bounded API qualifies their exact join
with actual client floors, rather than adding an unused diagnostic count or
inventing a public trust callback. Genuine threshold-signed fixture transitions
are source evidence only, not production storage handover/provisioning.

This closes one prerequisite, not retirement itself: dependency closure,
protected compaction-plan read-back, independent counters, accepted-object
horizon and retained-route read/ACK remain mandatory. No journal/key/floor
cleanup, renewal scheduler, production rollout, device reset or release
activation follows. Whole S01 remains partial.

## Required source qualification

Actual known and closed-unresolved acquisition custody; signed advanced and
unchanged epochs; original conservative ceiling lower-bound boundary; exact
native DNH2/anchor and journal rechecks; cold reopen without issuer callback;
missing root/anchor, clock rollback, stale proof, cancellation and disposed
capability rejection. The required full Shared gate must qualify the final
frozen dependencies; focused fixtures/builds cannot replace it or physical E2E.
