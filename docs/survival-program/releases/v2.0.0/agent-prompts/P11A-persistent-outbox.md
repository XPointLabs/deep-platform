# P11A — Persistent outbox state machine

## Role/repository

Work only in `deep-client-shared`. Own SQLite migration files exclusively for this wave.

## Objective

Implement transport-neutral durable outbox states before H2/racing/mobile adapters.

## State contract

`prepared -> attempted -> accepted -> durable -> delivered | expired`, with explicit transition source, attempt-local ID and end-to-end dedup material. `delivered` requires recipient-device acknowledgement; otherwise highest state is `durable`.

## In scope

- SQLite/in-memory aligned repository and migration;
- atomic transitions, retry scheduling, cancellation, expiry and crash recovery;
- multiple attempts mapped to one logical bundle/quota event;
- observer-safe diagnostics;
- adapter interfaces for P09C/P11B/P12/P13.

## Out of scope

Network adapter, bridge selection, mailbox receipt verification, UI and billing.

## Acceptance

Restart at every transition is tested; simultaneous attempt success yields one logical state; invalid regression/duplicate transition fails; old database migrates/rolls back within declared window.

