# Base prompt — Sprint 06: node rewards v3

Implement Sprint 06 after deterministic storage and signed membership evidence exist.

Read the program tokenomics document, Sprint 02/03 outputs, `xpoint-staking-backend/AGENTS.md`, `xpoint-staking-contracts/AGENTS.md`, current `EventIndexer.cs`, `ServiceNodeObligationService.cs`, `RewardRatePool.sol`, `SubscriptionManager.sol`, and `docs/REWARD_EMISSION_V2.md`.

Goal: replace equal “healthy presence” distribution with reproducible epoch rewards for core availability, proven storage and resilience—without measuring user traffic or P2P activity.

Repositories: [xpoint-staking-backend](https://github.com/XPointLabs/xpoint-staking-backend), [xpoint-staking-contracts](https://github.com/XPointLabs/xpoint-staking-contracts), [xnode](https://github.com/XPointLabs/xnode), [deep-tests-e2e](https://github.com/XPointLabs/deep-tests-e2e).

Preserve the V2 global emission cap unless governance separately approves a change. Build simulation and shadow accounting before any contract deployment.

