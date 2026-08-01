# P05 — Storage ownership and replication ADR

## Role

You are the distributed-systems architect for `C:\Work\DeepSession\XPointLabs\xnode`. This task is design/tests/simulator first; do not build production replication yet.

## Objective

Choose an implementable replication architecture and eliminate the false assumption that three onion hops are three storage replicas.

## Inspect first

`AGENTS.md`, `RouterRuntime.cs`, `ISessionStorageRpcBackend` implementations, NodeDb/path selection, current integration tests, DevOps storage compatibility service and pinned P03/P04 contracts.

## Required decisions

- client fan-out vs core coordinator vs storage sidecar; recommend one with failure/trust/metadata trade-offs;
- distinct route-hop set and storage-replica set;
- opaque placement key and membership epoch input;
- append-only `N=3/W=2/R=2` semantics, receipt/cursor ordering and idempotency;
- E/E+1 overlap, dual-read/write limits, tombstone dominance and rollback;
- logical quota vs physical replication accounting;
- product runtime ownership consistent with repository `AGENTS.md`;
- mixed-version topology and legacy single-exit feature flag.

## Invocation decision fields

`DECISION_OWNER=Mr. X`, `DECISION_DEADLINE` and later `APPROVED_ADR_SHA` are mandatory. The agent proposes/recommends; only Mr. X accepts. P08/P09 do not start before approval.

## Deliverables

- proposed ADR and recommendation for named owner; accepted status only after owner records `APPROVED_ADR_SHA`;
- pure placement simulator/property tests for 4/20/100/1000 nodes;
- failure table for one replica loss, stale read, split membership and retries;
- API/DTO contract proposal referencing pinned protocol version;
- estimate and file-lock map for P08/P09.

## Out of scope

Changing production route selection, database choice, entitlement enforcement and DevOps product runtime.

## Acceptance

Simulation proves request nonce does not alter replica ownership; minimal remapping and distribution bounds are reported; route hops and replicas are separate in every diagram/test; no sender master secret is assumed.

## Verification

Run focused simulator/tests and `dotnet test XNode.slnx` if source/tests change. Stop for an architecture decision rather than implementing all three options.
