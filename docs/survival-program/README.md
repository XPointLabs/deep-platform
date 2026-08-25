# Deep Native Protocol source of truth

Active release: [`v3.0.0`](releases/v3.0.0/README.md). Decision owner: Mr. X.

This directory contains frozen protocol/governance inputs, not the active sprint backlog. The only current execution plan is [`docs/NEXT-SPRINT.md`](../NEXT-SPRINT.md). Prior stages remain available in Git history and are intentionally absent from the working tree.

## Read order

1. [`DR-0003`](decisions/DR-0003-deep-native-session-clean-break.md).
2. [`program-manifest.json`](releases/v3.0.0/program-manifest.json).
3. The applicable specification and machine registry under [`releases/v3.0.0/specs`](releases/v3.0.0/specs).
4. Repository `AGENTS.md`, code and executable tests.
5. [`docs/NEXT-SPRINT.md`](../NEXT-SPRINT.md) for unfinished release work.

Machine registry widths, domains, field order, versions, ownership and activation order are normative. Missing authority/origin semantics must not be invented in runtime code.

## Execution policy

- Local edits, tests, Docker/UAT runs, UAT state reset and local commits are allowed.
- Push, external publication and production deployment require a separate decision.
- No new Session/legacy compatibility, migration, fallback, dual-read or downgrade path.
- Historical inventory/reference material is audit input only and cannot enter production graphs.

## Checks

```powershell
powershell -NoProfile -File .\scripts\check-survival-program.ps1 -RequiredEvidenceClaim ClassificationOnly
powershell -NoProfile -File .\scripts\check-dnp1-classical-spec.ps1
```

Package publication and final-release claims require their stricter evidence modes and independent review; a green classification check alone is not authority to publish.
