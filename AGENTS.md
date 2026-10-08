# XPointLabs agent map

## Scope and authority

- This workspace is pre-production. Implement clean breaks; do not add legacy readers, migrations, aliases, compatibility fallbacks, or dual paths unless the user explicitly asks.
- Local edits, builds, Docker/UAT runs, UAT data resets, and local commits are allowed. Never push, publish, deploy to production, or alter production app data without explicit authorization.
- Secrets live under `C:\Work\DeepSession\secrets`; never print, copy into artifacts, or commit them. Use only the exact secret/input requested by an existing script.
- Preserve unrelated dirty files. Commit each repository separately, then update the superproject submodule pointers in a final local commit.

## Read order

1. This file.
2. The nearest repository `AGENTS.md`.
3. `docs/architecture/README.md`, `PROTOCOL-REGISTRY-V1.md` and the relevant
   S00–S13 stage in `IMPLEMENTATION-PLAN-V1.md`. The 2026-10-03 source audit is
   baseline evidence; the implementation plan is the only execution sequence.
4. `docs/NEXT-SPRINT.md` for current unfinished work.
5. The relevant code, tests, and repo-native architecture/runbook docs.
6. Frozen protocol inputs under `docs/survival-program/releases/v3.0.0/` only when protocol bytes, crypto, identity, reset, or evidence ownership are in scope.

Do not load historical plans. Old WP/CB/NET-STAB ordering is superseded by the
unified plan; dated checkpoints and SPRINT-HISTORY are evidence, not a second
backlog or authorization for new production/reset actions. If code, tests, and
docs disagree, stop the affected claim, verify the implementation, and update
the stale source in the same change.
The documentation ownership matrix in `docs/architecture/README.md` is
mandatory: edit the single normative owner and replace downstream duplicated
requirements with links plus repository-specific consequences. `xpoint-docs`
contains public user/operator behavior, not a second protocol specification.

## Repository map

- `deep-protocol`: normative codecs, cryptography boundaries, exact packages and evidence gates.
- `deep-client-shared`: portable domain, SQLCipher persistence, E2EE/message/attachment/call orchestration and transport interfaces.
- `deep-client-maui`: MAUI UI, platform adapters, UAT/device automation and release composition.
- `xnode`: Entry/Relay/Mailbox/InviteStore/Blob/CallRelay runtime, epoch keys,
  forwarding, replication, quotas and heartbeat; never client path selection.
- `deep-registry-api`: byte-identical signed network/directory/catalog
  distribution, membership projection and witness coordination; no steady-state
  contact resolver, call signaling/ICE inbox or call-allocation authority.
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

- Windows native test gates use Windows PowerShell 5.1 explicitly. Run the
  repository command from that shell; PowerShell 7 callers must explicitly
  select `-Interpreter PowerShell7`. The terminal records the actual edition,
  version and SDK10.0.301. Do not guess an interpreter for historical scripts.
- Protocol's executable witnesses separately require PowerShell7.5.4:
  resolve `pwsh` or pass `-WitnessPowerShellPath` explicitly. Absence/wrong
  version rejects before full; the gate records the witness version and scopes
  its PATH addition to native children. It does not install interpreters.
- Use `scripts/Invoke-RepositoryTestGate.ps1` for full Shared, Node, Protocol
  and Registry source gates. Pass a fresh repo-owned artifacts directory and
  the exact prior-full/new-focused reference receipts. The canonical flow is
  build -> frozen inputs -> `FixturePreflight=true` -> unfiltered full ->
  exact TRX qualification -> unchanged-input check -> terminal.
- A failed/skipped/missing fixture prerequisite never launches full. Preflight
  checks actual signed windows, successor overlap, lease after setup/reopen,
  required frozen vectors and native providers; it does not extend authority.
  Registry additionally requires its disposable loopback PostgreSQL provider.
- Native children use a fresh user-local temporary directory and no inherited
  Git authority/config overrides; parent TEMP/TMP/PATH/Git variables are restored.
  Production Git validation is not relaxed. Mutable test-generated `artifacts`
  beneath binary outputs are not executable inputs; binaries, dependency/config
  files, source and normative vectors remain captured. Changed inputs during
  preflight reject before full, and the final input check is still mandatory.
- `scripts/TestGate.psm1` is the single runner/input/TRX implementation. Do not
  copy new per-run validators into artifacts. Empty filtered-project receipts
  require exact zero counters; shared theory definitions/display-name collisions
  are mapped by stable test identity plus exact case name and unique execution.
  Named historical FAIL/skips must be declared explicitly; classification cannot
  turn a nonzero native exit, interruption or lost terminal into full PASS.
- The canonical gates hold one workspace-wide lease. Run heavy gates serially.
  `-PreflightOnly` is diagnostic and never qualifies full. Inspect a stopped
  run with `Get-TestGateStatus`; missing exits remain interrupted/unqualified.
- Focused tests pass; run the repo's full required gate when risk or `AGENTS.md` requires it.
- Builds finish with zero warnings where the existing gate requires zero warnings.
- Physical claims are backed by a real device/run artifact; simulated or compile-only evidence is labelled accordingly.
- `git diff --check` is clean, no generated/temp artifact is accidentally tracked, and the repository has a focused local commit.
- Report exact tests, residual blockers and commits. Do not claim production readiness while any `docs/NEXT-SPRINT.md` release blocker remains.

## Canonical local test invocation

Run in Windows PowerShell5.1, with actual existing receipts chosen before launch:

```powershell
$references = @($PriorFullTrx, $NewFocusedTrx)
& .\scripts\Invoke-RepositoryTestGate.ps1 -Repository deep-client-shared `
  -RunDirectory $FreshSharedArtifactsDirectory -ReferencePaths $references
```

For Registry, pass those arrays through
`deep-devops/scripts/test-registry-postgres.ps1` with `-GateReferencePaths`,
`-GateRunDirectory` and the exact `-GateAllowedSkippedCases`. Invoke scripts
inside the selected shell; do not serialize array parameters through an external
`powershell.exe -File` command. Restore missing dependencies explicitly before
the gate; build uses `--no-restore`. Test the common mechanism with
`scripts/Test-RepositoryTestGateContracts.ps1`, not another artifact-local parser.
