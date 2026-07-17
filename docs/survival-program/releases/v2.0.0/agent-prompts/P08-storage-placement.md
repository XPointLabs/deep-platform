# P08 — Deterministic storage placement

## Role

Work only in `C:\Work\DeepSession\XPointLabs\xnode`. You own `RouterRuntime.cs` for this wave; no other task may edit it concurrently.

## Objective

Implement the accepted P05 placement ADR so different request nonces select the same storage replica set for a placement key and membership epoch, without changing privacy-route hop selection.

## In scope

- versioned placement request/result using opaque placement key;
- rendezvous/accepted algorithm from ADR with stable canonical inputs;
- distinct APIs/types for route hops and replicas;
- legacy single-exit feature flag and mixed-version behavior;
- E/E+1 membership selection data needed by P09;
- property/integration tests for distribution, removal/addition and nonce independence.

## Out of scope

Replicating data, changing onion hop count, deriving placement from raw Session ID, billing and client UI.

## Acceptance

4/20/100/1000-node tests pass defined balance/remapping bounds; request nonce has zero ownership effect; duplicate route hops remain forbidden; storage replicas may be tested independently from route hops; legacy path can be restored without data deletion.

## Verification

Run `dotnet test XNode.slnx` and required no-mock/multi-node checks for touched release paths. Update operator/Session docs.

