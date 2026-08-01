# P15B — Cross-repository E2E fixtures and Survival Beta assertions

## Role/repository

Work only in `deep-tests-e2e`, consuming the exact P00B manifest. Do not edit DevOps orchestration.

## Objective

Define black-box fixtures/assertions for signed control planes, durable mailbox, ingress, outbox, self-host isolation and update/privacy gates.

## In scope

- deterministic fixtures for bridge/node membership, capabilities, receipts and mixed versions;
- externally visible success, failure, idempotency and rollback assertions;
- one-replica loss/read/repair contract;
- 50/90% bridge-result ingestion, cold/warm source behavior and isolated self-host flow;
- log artifact scan for synthetic IDs/stable cross-domain identifiers;
- machine-readable strict gate consumed by P15/P19.

## Out of scope

Service internals, compose, weakening Session-visible compatibility and live secrets/endpoints.

## Acceptance/verification

Every test proves intended service contact and pinned SHA; fixtures validate deterministically; strict missing evidence fails. Run `npm run fixtures:validate`, `npm run compat`, then smoke/full/load via the DevOps harness.

