# P04B — Checkpoint builder and threshold signer

## Role/repository

Work only in the signer-service repository approved by P00A. If no product owner/repository/key-custody design is approved, stop after proposing the ownership ADR. Never place this runtime in `deep-devops/tools`.

## Objective

Build node-membership commitments and public bridge snapshots from authoritative inputs, obtain approved 2-of-3 online signatures delegated by 3-of-5 offline roots, and publish fork-witness records.

## In scope

- deterministic builder from signed node/registry projections;
- signer request/approval API with domain separation, sequence/previous hash and policy version;
- two independent online signature shares; no private share leaves its signer boundary;
- delegation/revoke/expiry and signer-health evidence;
- append-only transparency/fork-witness record;
- test-key local implementation and production-like HSM/offline interfaces;
- equivocation prevention/detection and disaster-recovery runbook.

## Out of scope

Generating/importing production roots without ceremony authorization, client fetch, registry mutation, billing/rewards and deployment.

## Acceptance

One signer cannot publish; two valid shares form a canonical snapshot; conflicting sequence is witnessed/rejected; expired/revoked delegation fails; node-only endpoints never enter public bridge snapshot; standard evidence contains no private material.

