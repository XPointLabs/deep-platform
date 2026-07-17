# Deep Survival Program — source of truth

Status: **approved for local execution** on 2026-07-17. Accountable owner and human decision maker: **Mr. X**.

The active immutable program release is [`v2.0.0`](releases/v2.0.0/README.md). Its machine-readable identity is [`program-manifest.json`](releases/v2.0.0/program-manifest.json), with program revision:

```text
sha256:ca5ad9f0c9d4dfb509dedcbf8133524c15867fce5534816da21ff86a07057383
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

Mr. X fills every internal human role named in the program. Independent crypto/security review and specialized legal advice remain external gates where independence or professional qualification is required; they cannot be self-approved by an implementation agent.

## Work-package identity

Atomic work packages use `DSP2-<PromptId>`, for example `DSP2-P00A`, `DSP2-P03B` and `DSP2-P19`. Optional implementation splits append `-<lowercase-slug>`. The exact pattern is:

```regex
^DSP2-P(?:0[0-9]|1[0-9])(?:[A-D])?(?:-[a-z0-9]+(?:-[a-z0-9]+)*)?$
```

`P00`, `P09`, `P11` and `P18` are umbrella/backlog identifiers and must not be assigned directly when their atomic child prompts exist. The old top-level `prompts/01..13` parity pack is also backlog-only.

## Manifests and packages

- Program manifest schema: [`schemas/program-manifest.schema.json`](schemas/program-manifest.schema.json).
- P00B-owned dependency manifest schema location: `deep-devops/schemas/survival/dependency-manifest.schema.json`.
- P00B-owned pinned manifest location: `deep-devops/manifests/survival/<wave>/<work-package-id>.json`.
- Package and immutable local artifact rules: [`PACKAGE-POLICY.md`](PACKAGE-POLICY.md).

P00B, P01 and P02 may start only from this exact program revision and an assigned clean worktree. Consumer work starts only after its producer SHA/package hash is pinned.
