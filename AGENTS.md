# XPointLabs agent map

## Scope and authority

- This workspace is pre-production. Implement clean breaks; do not add legacy readers, migrations, aliases, compatibility fallbacks, or dual paths unless the user explicitly asks.
- Local edits, builds, Docker/UAT runs, UAT data resets, and local commits are allowed. Never push, publish, deploy to production, or alter production app data without explicit authorization.
- Secrets live under `C:\Work\DeepSession\secrets`; never print, copy into artifacts, or commit them. Use only the exact secret/input requested by an existing script.
- Preserve unrelated dirty files. Commit each repository separately, then update the superproject submodule pointers in a final local commit.

## Read order

1. This file.
2. The nearest repository `AGENTS.md`.
3. `docs/NEXT-SPRINT.md` for current unfinished work.
4. The relevant code, tests, and repo-native architecture/runbook docs.
5. Frozen protocol inputs under `docs/survival-program/releases/v3.0.0/` only when protocol bytes, crypto, identity, reset, or evidence ownership are in scope.

Do not load historical plans. If code, tests, and docs disagree, stop the affected claim, verify the implementation, and update the stale source in the same change.

## Repository map

- `deep-protocol`: normative codecs, cryptography boundaries, exact packages and evidence gates.
- `deep-client-shared`: portable domain, SQLCipher persistence, E2EE/message/attachment/call orchestration and transport interfaces.
- `deep-client-maui`: MAUI UI, platform adapters, UAT/device automation and release composition.
- `xnode`: node runtime, path selection, transport supervision, bootstrap and registry heartbeat.
- `deep-registry-api`: authenticated registry, membership, call signaling/ICE and operational state.
- `deep-push-notification-server`: encrypted provider delivery and push ingress.
- `deep-devops`: Docker/UAT topology, TLS/PKI, release gates, chaos and operational evidence.
- `deep-tests-e2e`: black-box cross-service fixtures and tests.
- `xpoint-docs`: user and administrator documentation.
- `xpoint-node-installer`: supported node installation and upgrade workflow.
- staking repos: contracts, indexing/projection and `xpoint-staking-portal` UI only.

## Working rules

- Search first with `rg`/`rg --files`; read the exact call path and matching tests before editing.
- Treat UAT/dev tests as production paths: real TLS validation, authenticated transports, durable state, bounded retries, fail-closed errors, and no mock evidence.
- Do not weaken assertions to make a gate pass. Distinguish product defects from harness defects with exact evidence.
- Keep public APIs and wire formats closed and canonical. Unknown versions, states, fields, and hostile sizes reject before mutation/callbacks.
- Keep logs/artifacts free of payloads, identifiers, capabilities, keys, tokens, recovery material and private paths unless a sanitized schema explicitly permits a hash/count.
- Update user/admin docs whenever behavior, configuration, recovery, security or operations change.
- Use subagents only for disjoint bounded audits or implementations; the owning agent must review the final diff and gates.

## Definition of done

- Focused tests pass; run the repo's full required gate when risk or `AGENTS.md` requires it.
- Builds finish with zero warnings where the existing gate requires zero warnings.
- Physical claims are backed by a real device/run artifact; simulated or compile-only evidence is labelled accordingly.
- `git diff --check` is clean, no generated/temp artifact is accidentally tracked, and the repository has a focused local commit.
- Report exact tests, residual blockers and commits. Do not claim production readiness while any `docs/NEXT-SPRINT.md` release blocker remains.
