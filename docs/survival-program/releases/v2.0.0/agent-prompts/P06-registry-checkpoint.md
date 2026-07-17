# P06 — Registry checkpoint projection

## Role

Work only in `C:\Work\DeepSession\XPointLabs\deep-registry-api` as the registry projection owner.

## Objective

Consume the pinned P04 membership contract, persist/reconcile signed snapshots and expose client-safe bridge/control-plane data without becoming a central signer or revealing node-only topology.

## In scope

- verify canonical signatures/delegations using public roots/config;
- persist last valid sequence/hash and quarantine corrupt/forked state;
- expose public bridge snapshot and commitment/inclusion data only;
- reconciliation/readiness counters for stale, fork, invalid signer and clock skew;
- cache startup during upstream outage;
- API version/content type and compatibility tests.

## Out of scope

Private signing keys, signer service, rewriting chain/node state, client trust decisions, reward policy and publishing core/storage endpoints.

## Migration

Add endpoints/version without removing current bootstrap projection. Keep old reader path behind configuration; document support window and rollback.

## Acceptance

Unsigned/rollback/fork/expired snapshots fail; corruption quarantines without false readiness; current cached valid snapshot survives upstream outage; response contains no node-only endpoints; exact protocol package/hash is recorded.

## Verification

Run `dotnet test Deep.Registry.Api.slnx` plus recovery/reconciliation evidence required by `AGENTS.md`. Handoff names P07 client contract and P15 fixture changes.

