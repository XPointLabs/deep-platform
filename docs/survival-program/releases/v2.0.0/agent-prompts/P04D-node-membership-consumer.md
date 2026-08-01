# P04D — Node-only membership distribution and XNode consumer

## Role/repository

Work only in `xnode`. Consume pinned P04/P04B node-only membership artifacts. Public registry/client endpoints must not expose the topology.

## Objective

Authenticate and persist node-only core/storage membership for placement and overlay routing.

## In scope

- authenticated fetch/gossip source contract approved by P04B;
- threshold/delegation/sequence/fork verification through pinned package;
- atomic last-known-good node membership and bounded stale grace;
- eligible storage set/epoch API consumed by P08;
- role/capability validation, restart/corruption and reconciliation diagnostics;
- source transport is not authority; all state chains to network genesis.

## Out of scope

Signing/building snapshots, publishing topology to clients, reward decisions and placement algorithm changes.

## Acceptance

P08 receives an explicit pinned membership provider; invalid/rollback/fork fails; one source outage uses LKG; public bootstrap/API tests prove core/storage endpoints are absent; mixed-epoch fixture is available.

## Verification

Run `dotnet test XNode.slnx` and operator docs/readiness checks.

