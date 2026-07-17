# P09A — Local storage replica runtime

## Role/repository

Work only in the product-runtime repository approved by P05 (`TARGET_REPOSITORY`). Do not start if `APPROVED_ADR_SHA` or ownership is missing.

## Objective

Implement one durable ciphertext-only mailbox replica with idempotent append, retrieve cursor, TTL/tombstone, restart and corruption behavior. No quorum coordination in this task.

## In scope

- pinned P03B object/presentation/receipt contracts;
- atomic metadata/blob persistence and capacity/expiry indexes;
- per-replica signing identity and durable receipt after fsync/transaction commit;
- idempotency and logical-object identity without raw Session ID;
- local read/cursor/tombstone API, compaction, backup/restore and corruption quarantine;
- aggregate capacity/latency metrics without stable mailbox labels.

## Out of scope

Fan-out/quorum, repair, membership placement, entitlement issuer, attachments and DevOps compatibility runtime.

## Acceptance

Crash after/before commit has deterministic receipt behavior; duplicate append is idempotent; tampered capability/receipt fails; expired/tombstoned objects do not reappear after restart; logs/data inventory pass metadata gate.

