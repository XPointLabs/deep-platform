# P04C — Bridge snapshot mirrors and replacement distribution

## Role/repository

Work only in the approved publisher/mirror repository. Consume signed P04B artifacts; this service has no signing authority.

## Objective

Publish and rotate signed bridge snapshots through independent online and offline channels while measuring replacement latency and enumeration exposure.

## In scope

- immutable content-addressed snapshot publication from at least two provider/AS failure domains;
- current/future-set cache policy and expiry;
- E2EE in-band handoff artifact, QR/file bundle and mirror-fetch contract;
- no trust in transport/DNS: every artifact verifies to genesis/delegation;
- metrics: P95 replacement distribution, cache coverage, bridge lifetime, source availability;
- crawler/enumeration threat model without claims of secrecy;
- revoke/emergency replacement and offline drill runbook.

## Out of scope

Domain fronting, third-party impersonation, signer keys, client UI and promising reachability when every endpoint is blocked.

## Acceptance

Cold/warm fixtures cover timeout/reset/DNS/TLS failures; three-descriptor/two-domain device readiness is measurable; independent-channel refresh and QR/file drills produce evidence; modified/rollback snapshots fail verification.

