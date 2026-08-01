# Sprint 02 — deterministic replicated storage swarm

Duration: 2 weeks. Exit outcome: acknowledged envelopes survive one storage-node loss and can be located after network growth.

## STR-01: deterministic placement

Replace per-request `routeNonce` as the storage ownership key. Use a contact-scoped rotating deposit capability issued by the recipient and a separate retrieve capability. The sender must never receive the recipient master routing secret; nodes must not recover the raw identity.

```text
contact handshake -> depositCapability + opaque placementKey
recipient device  -> separate retrieveCapability
replicaSet        = RendezvousHash(placementKey, eligibleStorageNodes, replicaCount=3)
```

The request nonce remains only for replay/correlation defense. A membership checkpoint identifies the eligible set. Specify migration across membership epochs with overlap.

Acceptance: repeated write/read requests with different nonces select the same replica set for an epoch; distribution simulation across 20 nodes has no unexpected hotspot; removal of one node minimally remaps keys.

## STR-02: quorum write and read repair

- default replication `N=3`, durable acknowledgement `W=2`, read queries `R=2` (or unions all available append-only responses) plus background consistency/repair;
- idempotency by bundle ID;
- signed receipt containing opaque object ID, epoch, replica commitments and expiry;
- tombstones replicated before physical deletion;
- bounded retry and cancellation.

Acceptance: one replica offline during write/read causes no acknowledged loss; a stale replica cannot hide newer acknowledged data; a recovered replica is repaired; duplicate upload does not duplicate quota or objects. Onion route hops and storage replica identities are tested as independent concepts.

## STR-03: production storage adapter

Abstract the current JSON/journal implementation behind a storage engine. Add a production database/object-store adapter with atomic metadata, ciphertext-only blobs, expiry indexes, compaction, backup/restore and capacity alarms. Exact product choice requires a benchmark ADR; avoid provider lock-in in protocol types.

## STR-04: managed quota boundary

Meter opaque stored byte-days, object count, TTL class and egress at the official storage API. Accept an abstract `ResourceCapability`; Sprint 05 will issue it. Self-hosted profiles can use an unlimited/local policy and do not call official entitlement services.

Quota exhaustion must still permit retrieval/deletion/export and small-text emergency behavior defined by policy. Storage nodes must not learn payment identity.

## STR-05: tests and observability

- deterministic-placement property tests for 4, 20, 100 and 1,000 nodes;
- chaos tests: one loss, restart, delayed replica, duplicate delivery, membership epoch transition;
- metrics: aggregate ciphertext bytes, repair backlog, replica health, write quorum latency—no stable user labels;
- E2E fixture in `deep-tests-e2e`.

## Out of scope

Payment collection, final pricing, on-chain proof settlement and mobile radio transports.
