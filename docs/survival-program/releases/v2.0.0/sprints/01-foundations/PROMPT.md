# Base prompt — Sprint 01: foundations

You are implementing Sprint 01 of the Deep Resilient Network Program in `C:\Work\DeepSession\XPointLabs`.

## Goal

Define and enforce the boundary between the always-free communication plane and the Deep-managed cloud plane. Produce protocol contracts and tests that later transports, storage, billing and rewards can depend on.

## Read first

1. `C:\Work\DeepSession\docs\resilient-network-program\README.md`
2. `C:\Work\DeepSession\docs\resilient-network-program\tokenomics-and-node-economics.md`
3. `deep-protocol/AGENTS.md`, `deep-client-shared/AGENTS.md`, `xnode/AGENTS.md`
4. `deep-client-shared/docs/ARCHITECTURE.md`
5. Current transport: `deep-client-shared/src/Deep.Client.Shared/Services/RoutedSessionTransport.cs`
6. Current router: `xnode/src/XNode.Core/Runtime/RouterRuntime.cs`

Repositories: [deep-protocol](https://github.com/XPointLabs/deep-protocol), [deep-client-shared](https://github.com/XPointLabs/deep-client-shared), [xnode](https://github.com/XPointLabs/xnode).

## Immutable constraints

- P2P/local/self-hosted messaging imports no wallet, billing, subscription or XPNT dependency.
- Encryption and identity are identical across free and paid plans.
- The encrypted message bundle is independent of its transport.
- Do not alter wire formats without versioning and golden vectors.
- Preserve unrelated local changes and follow every repository `AGENTS.md`.

## Deliver

Implement the tasks in `TASKS.md`, add tests before broad integration, update architecture documentation, and report changed files, test commands/results, unresolved risks, and any protocol migration requirement. Do not implement speculative UI or token contract changes in this sprint.

