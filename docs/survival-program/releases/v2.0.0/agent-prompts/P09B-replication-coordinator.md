# P09B — Mailbox replication coordinator

## Role/repository

Work only in the coordinator owner approved by P05, after P08/P09A and pinned wire contracts.

## Objective

Coordinate `N=3/W=2/R=2`, aggregate independently signed receipts, detect equivocation/staleness and preserve a bounded legacy mirror window.

## In scope

- placement-provider input from P04D/P08;
- bounded fan-out/backpressure/cancellation and idempotency;
- quorum receipt with two distinct replica signatures;
- R2/available-union append-only read, cursor merge and stale detection;
- migration phases: new readers, dual-read, bounded dual-write, replicated-primary, mirror rollback, legacy retirement;
- coordinator-equivocation evidence and failure semantics;
- one logical quota event emitted only after durable quorum.

## Out of scope

Replica storage internals, client UI, quota issuer and blob storage.

## Acceptance

100,000-write deterministic suite has zero durable-message loss under any single-replica failure; client-verifiable receipt proves two distinct replicas; rollback in mirror window reads every acknowledged v2 object; duplicate retry is one logical charge.

