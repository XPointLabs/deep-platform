# P10 — Stateless ingress role

## Role

Work only in `C:\Work\DeepSession\XPointLabs\xnode`. Do not overlap `RouterRuntime.cs` edits with P08/P09 unless locks are reassigned.

## Objective

Separate disposable public ingress from authenticated core/storage so ingress compromise/restart cannot expose durable mailbox data or signing authority.

## In scope

- explicit runtime role/config/readiness for ingress vs core/storage;
- authenticated opaque-frame forwarding with bounded short-lived buffers;
- no membership/update private keys and no durable mailbox backend in ingress;
- short-lived bridge descriptor consumption from pinned P04 contract;
- minimal logs and documented raw-IP retention;
- deployment/config contract for later DevOps consumer.

## Out of scope

Domain fronting, third-party impersonation, bridge crawling evasion guarantees, core consensus redesign, reward eligibility and deployment.

## Acceptance

Ingress restart loses no acknowledged message; ingress filesystem/database dump lacks mailbox ciphertext and signing keys; invalid core authentication fails closed; readiness reflects actual forwarding; core/storage endpoints are absent from public bootstrap response.

## Verification

Run XNode unit/integration and no-mock checks. Handoff exact compose/config changes for P15, not edits to `deep-devops`.

