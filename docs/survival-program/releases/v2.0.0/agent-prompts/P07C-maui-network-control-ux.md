# P07C — MAUI network control and degraded-state UX

## Role/repository

Work only in `deep-client-maui` after P07/P07B/P11B shared APIs are pinned.

## Objective

Wire signed membership/bridge cache, transport state and explicit metadata mode into startup and user-visible diagnostics without leaking endpoints/identities.

## In scope

- bootstrap/LKG/degraded/stale/blocked states and recovery actions;
- current network profile and private/direct/nearby mode disclosures;
- bridge refresh/import handoff, not signing;
- transport outbox states `accepted/durable/delivered/expired`;
- release fail-closed wiring and stable automation IDs;
- tests for missing/expired/forked state and no-stub release.

## Out of scope

Shared trust validation, QR profile UX (P14B), endpoint list exposure and claiming anonymity beyond mode contract.

## Acceptance

User can distinguish locally prepared, accepted, durable and device-delivered; stale/forked trust cannot silently continue; release has no stub fallback; diagnostics contain no live bridge inventory or Session IDs.

