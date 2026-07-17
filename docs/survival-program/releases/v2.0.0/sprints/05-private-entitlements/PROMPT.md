# Base prompt — Sprint 05: private cloud entitlements

Implement Sprint 05 in `C:\Work\DeepSession\XPointLabs`.

Read the program README, business model, tokenomics document, Sprints 01/02 outputs, `xpoint-staking-contracts/AGENTS.md`, `xpoint-staking-backend/AGENTS.md`, and the current `SubscriptionManager.sol` plus tests and ABI consumers.

Goal: sell Deep-managed capacity without linking payment identity to messaging identity and without placing an entitlement check in P2P/self-hosted paths.

Repositories: [xpoint-staking-contracts](https://github.com/XPointLabs/xpoint-staking-contracts), [xpoint-staking-backend](https://github.com/XPointLabs/xpoint-staking-backend), [deep-client-shared](https://github.com/XPointLabs/deep-client-shared), [xpoint-staking-portal](https://github.com/XPointLabs/xpoint-staking-portal).

Treat prices/quotas as versioned configuration. Preserve the existing 40/20/40 allocation until cost evidence approves a change. Do not deploy contract changes in this sprint without a separate privacy/security review and deployment authorization.

