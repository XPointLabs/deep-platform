# XPointLabs agent map

## Scope and authority

- This workspace is pre-production. Implement clean breaks; do not add legacy readers, migrations, aliases, compatibility fallbacks, or dual paths unless the user explicitly asks.
- Local edits, builds, Docker/UAT runs, UAT data resets, and local commits are allowed. Never push, publish, deploy to production, or alter production app data without explicit authorization.
- Secrets live under `C:\Work\DeepSession\secrets`; never print, copy into artifacts, or commit them. Use only the exact secret/input requested by an existing script.
- Preserve unrelated dirty files. Commit each repository separately, then update the superproject submodule pointers in a final local commit.

## Read order

1. [Current system specification](docs/architecture/README.md). Its module table links the actual implementation.
2. [Current sprint](docs/NEXT-SPRINT.md) for acceptance state and priority on the release-candidate branch.
3. The nearest repository `AGENTS.md`, the code and the tests for the affected path.
4. For protocol changes, consult the applicable field contract and executable vectors via the [protocol registry](docs/architecture/PROTOCOL-REGISTRY-V1.md). Consult the [stage plan](docs/architecture/IMPLEMENTATION-PLAN-V1.md) for stage acceptance criteria.

Keep system architecture in the specification and open work in the sprint. Replace the current status on change. Detailed wire contracts, hashed inputs, gate case bindings and operational runbooks each retain their own authority. Git history holds superseded narratives.

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
- Protocol's executable witnesses separately require PowerShell7.6.5/.NET10
  for the selected SDK architecture (see [witness runtime](docs/survival-program/README.md#witness-runtime)):
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
  An accepted semantic clean break may declare exact old-case -> replacement
  bindings with `-RetiredCaseReplacements` and `-RetirementDecisionPath`.
  Original reference TRX stay unchanged; current retired cases must be absent,
  all replacements must actually pass (never waived FAIL/skip), and qualification
  records old method bindings plus decision SHA256. Unrelated missing/new cases
  still reject. The decision is a captured input, not a per-run validator.
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
