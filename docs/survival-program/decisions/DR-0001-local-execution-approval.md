# DR-0001 — local execution approval

Status: accepted

Decision owner: Mr. X

Recorded: 2026-07-17

Applies to program: `deep-survival` release `2.0.0`

Program revision: `sha256:ca5ad9f0c9d4dfb509dedcbf8133524c15867fce5534816da21ff86a07057383`

## Decision

Mr. X approves iterative local implementation of the Deep Survival Program using isolated worktrees, subagents and local commits. Mr. X is the accountable owner for every internal human role and internal go/no-go decision named by the program.

The execution policy is:

- work in isolated local worktrees and preserve the existing dirty checkout;
- local commits are allowed to provide reversible iteration boundaries;
- no GitHub push, fetch, pull, PR, merge or release publication;
- no external package publication;
- local Docker networks and local application builds may be produced by their assigned work packages;
- review each implementation iteration with architecture, lead-development, security/privacy and relevant specialist roles before advancing;
- keep production, public rollout and blockchain deployment disabled unless Mr. X grants a later explicit, narrowly scoped authorization.

No secret, private key or mnemonic may be written to source, prompts, logs, artifacts or command history. The existence of UAT credentials is not deployment authority.

## Scope decision

Horizon A / Survival Beta is active. Horizon B/C items remain deferred unless an explicit dependency decision promotes them. Rewards V3, production billing, production LoRa, public node enrollment and new contract activation do not block the Beta path.

All local/P2P/off-grid/self-hosted communication remains free and independent of subscription, token ownership and the managed Deep infrastructure.

## Independence limits

Mr. X may own and accept internal engineering, product, operations and program decisions. The following gates still require genuinely independent or qualified external input where the active program says so:

- focused crypto/security design review before pilot security claims;
- independent audit before public smart-contract activation;
- specialized legal advice for jurisdictions, Russian infrastructure roles, operator safety, payments and public launch;
- store/platform approvals controlled by third parties.

Subagent review is required during implementation but does not satisfy these external gates.

## Consequences

The pending approval cells in the mirrored 2026-07-15 CEO memo are superseded only for the local engineering start and the named internal owner. Budget, runway, `B_free`, external reviewer booking, device/carrier access and legal approval remain measured inputs or later gates; they are not fabricated by this decision.
