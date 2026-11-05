# Deep Native Protocol contracts

Active release: [`v3.0.0`](releases/v3.0.0/README.md). Decision owner: Mr. X.

Start with the [current architecture](../architecture/README.md). This directory
holds protocol/governance inputs and operation-specific technical contracts.
Consult only the contract for the affected boundary; accepted decision files are
not a chronological reading list or implementation queue. [NEXT-SPRINT](../NEXT-SPRINT.md)
owns unfinished status; [IMPLEMENTATION-PLAN](../architecture/IMPLEMENTATION-PLAN-V1.md)
owns execution dependencies and acceptance.

## Contract inputs

- [`DR-0003`](decisions/DR-0003-deep-native-session-clean-break.md) and
  [`program-manifest.json`](releases/v3.0.0/program-manifest.json) bind the clean
  break, inventory and exact frozen document/machine sets.
- The applicable registry/schema/vector under [`specs`](releases/v3.0.0/specs)
  defines bytes and verifier boundaries. Evidence manifests, attestations,
  source snapshots and inventories are integrity/provenance inputs even when
  they are reference-only in the production graph.
- Repository contracts, `AGENTS.md`, code and executable tests define the local
  producer/consumer mapping and required qualification.

Machine registry widths, domains, field order, versions, ownership and activation order are normative. Missing authority/origin semantics must not be invented in runtime code.

The connected route-coordination increment is owned by
[DR-0077](decisions/DR-0077-did2-route-successor-coordination.md), with machine
bounds in [CONTACT-COORDINATION-02](releases/v3.0.0/specs/contact-coordination-v2.registry.json).
Accepted source changes are not production/device activation evidence.

## Integration qualification

Preserve DID2/E2EE/onion and durable mailbox ownership. The plan first joins
contact, text, durable recipient materialization and authenticated application
receipt on one exact source/artifact matrix, then retained-state recovery,
physical Android/Windows delivery and the remaining files/groups/calls/carriers
release gates. This ordering does not reduce product scope.

Liveness, current-authority readiness, Store/quorum receipt, recipient
materialization and application receipt are distinct facts. Recovery retains
exact durable intent with bounded retry/reconciliation; network loss or authority
expiry cannot erase the account, history or queue. Invalid/forked custody rejects.
Control-plane refresh remains proactive and single-flight, independent of UI
polling; historical catch-up cannot mint current authority. `OfficialXPoint3`
retains outage/recovery obligations without promising delivery while an obligatory
routing node is absent.

S00 qualifies reproducible fixtures, the exact source matrix, classified failures,
fresh required Node/Registry gates and governance. S08 owns the actual shipping
package/API/resource graph and installed-client matrix. Existing package failures
remain explicit S08/release blockers; moving their execution assignment never
waives assertions, missing cases, skips or failures. Source-cutover integration
uses only the frozen current DID2/MCG3/MAU3 path. S09/S13 retain recovery and the
complete product/evidence scope. Compiler success is not shipping qualification.

The exact retirement scope, forbidden replacements and native PMA1/PMR1
constraints of [DR-0093](decisions/DR-0093-retired-mailbox-route-control-source-api.md)
and [DR-0094](decisions/DR-0094-retired-mailbox-issuance-and-revocation-adapter.md)
remain binding. PMA2 is not a node-certificate issuer; MGR1 is not PMR1.
Further native removal requires its reviewed current-owner mapping and separate
source/API or grammar authorization. Account/device verification, ReleaseRoot,
reset/recovery, replay, quorum, retention and protected floors remain mandatory.
No removed experimental request-admission journal is restored by this ordering.

## Local custody owners

- [Authored counters](../../deep-client-shared/docs/architecture/owned-authored-counter-custody.md#one-local-reader-and-bounded-layout)
  own independent protected floors, local readers, SQL bindings and exact recovery.
  Working-row removal cannot derive/reset counters from counts or erase pending
  work; original event/role ownership, typed namespaces, consent and independent
  endpoint checks survive. The semantic owner remains
  [messaging §8.4.3](../architecture/TRANSPORT-NEUTRAL-MESSAGING.md#843-compaction-and-boundedness).
- [Idle mailbox counter retirement](../../deep-client-shared/docs/architecture/owned-mailbox-counter-retirement.md#held-selection-and-exact-dependencies)
  owns its exact private dependency index, one-root plan and cold recovery.
  Held epoch exclusion is necessary but insufficient: independently current
  signed policy, original ceiling, protected native floor and complete unchanged
  application/native SQL guards must agree under the account lease. Grants,
  holders, traversals, objects, receipt obligations and last retained read/ACK
  paths remain pinned. No SQL row or semantic/history evidence is deleted by
  this counter-only disposition. Activation and qualification remain separate.

## Witness runtime

The [canonical gate](../../scripts/TestGate.psm1) requires SDK10.0.301 and
Windows PowerShell5.1 for ordinary Windows gates. Protocol executable witnesses
require the explicitly selected existing PowerShell7.6.5/.NET10 executable and
an SDK-compatible architecture. Probe actual MSBuild type loading before
build/full, record runtime/version/architecture and restore the native-child PATH
scope. A version string alone is insufficient. No interpreter installation,
silent substitution, SDK downgrade, resolver fallback or weakened package check
is allowed. Retained diagnostic failures remain failures; witness execution does
not qualify a rejected package or activate a release.

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
