# P11B — H2/proxy/REALITY adapter and bounded racing

## Role/repository

Work only in `deep-client-shared` after P07B/P10B/P11A and server endpoint fixtures are pinned.

## Objective

Implement managed transport selection without duplicate logical delivery or unbounded connection/battery churn.

## In scope

- H2 adapter, system HTTP/SOCKS proxy and existing REALITY capability/platform adapter;
- verified bridge candidate set from P07B;
- cached winner, at most two simultaneous attempts, deadline, jitter/backoff/circuit breaker;
- attempt IDs/outbox transitions through P11A;
- network lifecycle/cancellation and privacy-safe metrics;
- timeout/reset/DNS/TLS/proxy fixtures.

## Out of scope

Server ingress code, BLE, domain fronting, mailbox business semantics and claiming operation when all paths are blocked.

## Acceptance

50/90% dead endpoint fixtures meet defined behavior; no duplicate logical deposit; proxy works; all-failed state is explicit; legacy adapter rollback does not discard outbox state.

