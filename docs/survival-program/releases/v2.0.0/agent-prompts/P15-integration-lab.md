# P15 — Pinned integration, impairment and evidence lab

## Role

Work only in `C:\Work\DeepSession\XPointLabs\deep-devops`; update `deep-tests-e2e` only through a separate invocation/agent. Do not put product runtime in DevOps tools.

## Objective

Compose manifest-pinned builds and produce reproducible evidence for mixed versions, replica loss, bridge blocking, DNS/TLS/UDP failure and rollback.

## In scope

- consume P00 integration manifest and reject floating/default refs;
- separate ingress/core/storage compose roles using product images;
- Toxiproxy for TCP reset/timeout/latency, CoreDNS/test resolver for DNS, Linux network namespace/netem for loss/delay/UDP drop, and controlled TLS endpoints for certificate/SNI failure; 50/90% bridge-loss combinations use these fixtures;
- one-replica loss/recovery/stale repair and mixed old/new cluster;
- machine-readable delivery, repair, connection and privacy-log artifacts;
- strict Survival Beta gate and cleanup/volume isolation;
- carrier/device result ingestion schema without sensitive live bridge inventory.

## Out of scope

Implementing storage/ingress in `tools`, live interference with third-party networks, deployment, weakening release assertions and secret collection.

## Acceptance

Every test proves it contacted the intended pinned component; strict mode fails missing evidence; one-replica and bridge-loss gates produce deterministic JSON; cleanup prevents state leakage; artifacts contain no secrets/raw Session pairs.

## Verification

Run release contract/readiness scripts, smoke/external/no-mock/multi-node suites and focused tool tests required by `AGENTS.md`. Report environmental skips as blockers, not passes.
