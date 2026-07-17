# Base prompt — Sprint 02: storage swarm

Implement Sprint 02 in `C:\Work\DeepSession\XPointLabs` after Sprint 01 contracts are merged.

Read the program README, Sprint 01 ADR/bundle specification, `xnode/AGENTS.md`, `deep-client-shared/AGENTS.md`, [`RouterRuntime.cs`](../../../../../../xnode/src/XNode.Core/Runtime/RouterRuntime.cs), and [`RoutedSessionTransport.cs`](../../../../../../deep-client-shared/src/Deep.Client.Shared/Services/RoutedSessionTransport.cs).

Goal: replace request-random storage exit selection with deterministic, replicated, repairable storage. Quotas apply only when the selected profile is the Deep-managed cloud; self-hosted profiles control their own policy.

Constraints: no billing field in encrypted bundles; no acknowledgement before durability threshold; no single-node data ownership; version all storage RPC changes; preserve a rollback path.

Repositories: [xnode](https://github.com/XPointLabs/xnode), [deep-client-shared](https://github.com/XPointLabs/deep-client-shared), [deep-tests-e2e](https://github.com/XPointLabs/deep-tests-e2e).

Deliver all `TASKS.md` items, migrations, tests, failure evidence and operator documentation. Report measured write/read latency and behavior with one replica unavailable.
