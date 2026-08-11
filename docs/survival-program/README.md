# Deep Survival Program — source of truth

Status: **approved for local execution** on 2026-07-17. Accountable owner and human decision maker: **Mr. X**.

The active immutable program release is [`v3.0.0`](releases/v3.0.0/README.md).
It supersedes `v2.0.0` for new implementation scope while retaining that
release as immutable evidence. Its machine-readable identity is
[`program-manifest.json`](releases/v3.0.0/program-manifest.json), with program
revision:

```text
sha256:c69d4cf2f57e37eaef97aff16028807e314b36737a4667aabc6a4da15aa6df8e
```

Run `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-survival-program.ps1` from the superproject root before accepting governance changes.

## Precedence

Agents must read sources in this order:

1. this active-release pointer;
2. the active release manifest and applicable decision records;
3. [`REVISED-PROGRAM-RU.md`](releases/v2.0.0/REVISED-PROGRAM-RU.md);
4. the repository-scoped atomic prompt under [`agent-prompts/`](releases/v2.0.0/agent-prompts/README.md);
5. the current repository `AGENTS.md`, when present, for repository-local execution rules;
6. `roadmap.md` and `docs/delivery-plan.md` only as retained historical implementation evidence.

An `AGENTS.md` may narrow execution mechanics but may not silently change the active program, security gates, product invariants or human authority. A conflict stops the package until Mr. X records a decision. Scope or contract changes require a new SemVer program release and revision hash.

## Active decision and authority

[`DR-0001`](decisions/DR-0001-local-execution-approval.md) records Mr. X's approval to execute iteratively in isolated local worktrees and create local commits. It does **not** authorize push, pull, fetch, PR creation, merge, external package publication, UAT/production contract deployment or public rollout.

[`DR-0003`](decisions/DR-0003-deep-native-session-clean-break.md) records
Mr. X's accepted strategic decision to replace Session compatibility with one
Deep-native protocol through a staged pre-production clean break. The decision
freezes new compatibility work and defines the boundary for the next sprint;
implementation still requires a new SemVer program release and revision, so
the immutable `v2.0.0` manifest is not silently changed.

Mr. X fills every internal human role named in the program. Independent crypto/security review and specialized legal advice remain external gates where independence or professional qualification is required; they cannot be self-approved by an implementation agent.

## Work-package identity

Active clean-break work packages use a bounded `DNP1` owner prefix and an
optional lowercase split. The exact pattern is:

```regex
^DNP1-(?:GOV|INV|SPEC|PROTO|CLIENT|NODE|OPS|SEC)(?:-[a-z0-9]+)*$
```

The `DSP2-*` work packages and top-level `prompts/01..13` pack are retained
`v2.0.0` evidence/backlog only and must not be assigned for new implementation.

## Manifests and packages

- Program manifest schema: [`schemas/program-manifest.schema.json`](schemas/program-manifest.schema.json).
- Dependency manifest schema location: `deep-devops/schemas/survival/dependency-manifest.schema.json`.
- Active pinned manifest location: `deep-devops/manifests/deep-native/<wave>/<work-package-id>.json`.
- Package and immutable local artifact rules: [`PACKAGE-POLICY.md`](PACKAGE-POLICY.md).

`DNP1-GOV` and then `DNP1-INV` are the only initially executable work
packages. Consumer implementation starts only after the inventory verdict is
GO and its producer SHA/package hash is pinned.
