# P09C — Client mailbox deposit/retrieve adapter

## Role/repository

Work only in `deep-client-shared` after P07A/P09B/P10B are pinned.

## Objective

Present rotating deposit/retrieve capabilities, verify durable quorum receipts and map mailbox state into the persistent outbox without raw Session addressing.

## In scope

- managed deposit/read/delete APIs using pinned H2/mailbox contracts;
- verify generation, expiry, two replica signatures and placement/membership commitment;
- `accepted` vs `durable` UI/domain state; do not synthesize `delivered`;
- R2 cursor merge, duplicate suppression and retry/restart;
- legacy/v2 dual-read/mirror-window behavior and downgrade prevention;
- SQLite/in-memory migrations with locked schema ownership.

## Out of scope

Capability issuance, server storage, transport racing, UI rendering and payment.

## Acceptance

Forged/single-replica/equivocating receipts fail; crash/retry preserves state; rollback window retains acknowledged reads; no raw sender-recipient pair appears in request/log fixtures.

