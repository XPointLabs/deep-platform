# Deep Native Protocol Program v3.0.0

Status: **approved for local execution** on 2026-08-11.

Decision owner and accountable owner: **Mr. X**.

This release supersedes `v2.0.0` for new implementation scope. The reviewed
Deep-native artifacts and local commits produced under `v2.0.0` remain valid
evidence; its Session compatibility mission and unfinished compatibility work
do not remain active requirements.

The canonical program is
[`DEEP-NATIVE-CLEAN-BREAK-RU.md`](DEEP-NATIVE-CLEAN-BREAK-RU.md). The accepted
decision is [`DR-0003`](../../decisions/DR-0003-deep-native-session-clean-break.md).

## Immediate execution boundary

- Registry 4B2A sealed history lookup is the final atomic checkpoint completed
  before this release.
- Protocol F remains a reviewed local source commit, not an active old-graph
  package/repin requirement.
- Registry 4B2B and all further feature work wait for the dependency inventory
  and Deep-native specification gates in this release.
- The Session dependency inventory is frozen and machine-checked; the recovery
  and hybrid-PQ profile is now an active dark-path specification draft.
- The reviewed Wave 1 classical identity, reset, external-witness and native
  route baseline is frozen in
  [`DNP1-CLASSICAL-IDENTITY-RESET-MRL2-V1.md`](specs/DNP1-CLASSICAL-IDENTITY-RESET-MRL2-V1.md),
  with a machine registry and mandatory negative-vector inventory. It remains
  docs-only until each implementation slice passes an independent frozen
  review.
- No new Session compatibility, fallback or migration path may be added.
- No push, external package publication, deployment or public release is
  authorized.

## First sprint

[`01-clean-break-foundation`](sprints/01-clean-break-foundation/TASKS.md)
establishes the dependency boundary, forbidden-reference gates, identity/key
roles and new wire/version rules before production code deletion begins.
