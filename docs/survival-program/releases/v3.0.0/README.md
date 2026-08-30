# Deep Native Protocol Program v3.0.0

Status: approved for local execution. Decision owner: Mr. X.

This is the only retained program release in the working tree. Earlier stages remain in Git history and are not active requirements, runtime compatibility promises or agent input.

## Frozen inputs

- Clean-break decision: [`DR-0003`](../../decisions/DR-0003-deep-native-session-clean-break.md).
- Canonical program: [`DEEP-NATIVE-CLEAN-BREAK-RU.md`](DEEP-NATIVE-CLEAN-BREAK-RU.md).
- Machine identity: [`program-manifest.json`](program-manifest.json).
- Production inventory: [`inventory/session-production-boundaries.v1.json`](inventory/session-production-boundaries.v1.json), reference-only.
- Classical DNP1 source and registry: [`specs`](specs).

The machine registries and frozen specifications remain authoritative for bytes, domains, state transitions, evidence ownership and activation order. They do not authorize production publication by themselves.

## Active work

The only sprint backlog is [`docs/NEXT-SPRINT.md`](../../../NEXT-SPRINT.md). Do not recreate per-phase prompt packs. New work must be a bounded issue against the sprint item and the owning repository.

Local commits and UAT are allowed. Push, publication and production deployment require a separate Go/No-Go decision.
