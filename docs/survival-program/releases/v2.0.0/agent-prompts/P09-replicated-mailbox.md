# P09 — Replicated mailbox umbrella (do not issue directly)

Issue P09A replica runtime, then P09B coordinator and P09C client adapter. This umbrella remains the combined acceptance reference only.

## Role

Work only in `C:\Work\DeepSession\XPointLabs\xnode` after P08 is accepted. You own the storage runtime files locked in the invocation.

## Objective

Implement the P05 append-only small-envelope mailbox with `N=3/W=2/R=2`, idempotent receipts, repair and legacy rollback. This is not blob storage or chat history.

## In scope

- per-replica durable local backend under the owner chosen by ADR;
- coordinator write fan-out and acknowledgement only after two independently signed durable replica receipts; the quorum receipt identifies commitments without exposing mailbox identity and is client-verifiable;
- R2/available-union read with signed monotonic cursors and stale detection;
- idempotency by end-to-end dedup material, one logical quota charge;
- TTL/tombstones, read repair, restart/corruption behavior;
- E/E+1 overlap and bounded write amplification;
- coordinator-equivocation tests and a migration phase plan: new readers, dual-read, bounded dual-write, replicated-primary, rollback mirror window, legacy retirement;
- aggregate metrics without mailbox/raw Session labels;
- mixed old/new cluster and one-replica chaos tests.

## Out of scope

Attachments, backups, unlimited history, novel custody proof, entitlement issuer and using DevOps tools as production runtime.

## Acceptance

Zero acknowledged-envelope loss in mandatory one-replica suite; stale replica cannot hide newer data; client verifies two independent replica signatures; coordinator equivocation is detected; repair P95 evidence is emitted; duplicate retry creates no duplicate object/quota; raw sender-recipient pair does not enter storage/log fixtures; rollback inside the declared mirror window preserves reading every acknowledged v2 envelope.

## Verification

Run `dotnet test XNode.slnx`, no-mock/multi-node rehearsal and P15-compatible chaos artifacts. Stop if durability depends on an unowned external service.
