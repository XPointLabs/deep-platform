# P03B — Mailbox capability protocol contract

## Role/repository

Work only in `deep-protocol`, sequentially after P03/P03A packaging decisions.

## Objective

Define wire-visible contact-scoped deposit, retrieve and presentation contracts before client or storage agents implement lifecycle.

## Contract scope

- opaque rotating deposit capability shareable with an authenticated contact;
- retrieve capability never shared with sender;
- opaque placement key distinct from both capabilities and raw Session ID;
- issuance generation/version, validity overlap, revoke/recovery and mixed-version marker;
- storage presentation, error classes, replay/idempotency and canonical limits;
- replica receipt, durable quorum receipt, cursor/tombstone and accepted/durable error schemas;
- client verification of two independent replica signatures and coordinator-equivocation evidence;
- free-admission slot as an orthogonal bounded authorization, not payment identity.

## Out of scope

Issuer persistence, contact UX, quota algorithm, storage execution and novel crypto. Opaque types must not imply secrecy without approved construction.

## Acceptance

Golden/malformed/cross-domain/replay vectors exist; sender cannot derive retrieve capability; stable raw Session ID is absent; old/new behavior and rollback/mirror window are documented; P07A/P09A/P09B/P09C receive one pinned package/hash.

## Verification

Run protocol suite/fuzz and local immutable pack only.

