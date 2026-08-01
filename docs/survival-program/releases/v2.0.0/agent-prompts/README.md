# Atomic implementation prompts

These prompts replace the broad sprint prompts as execution units. An orchestrator instantiates one prompt per subagent with exact base SHA, branch/worktree and locked files. No prompt authorizes merge, deployment, contract activation or work in another repository.

Default human/accountable owner and `DECISION_OWNER` is **Mr. X**. Codex/subagents are implementation executors. Independent external crypto/security review and specialized legal advice remain external gates and cannot be self-approved by Mr. X or an implementation agent.

## Required order

> `P00` is superseded. Start with P00A, then P00B. The dependency table below is a compact view; the additional producer/consumer prompts listed after it close the cross-repository gaps found in second-pass review.

| Wave | Prompt | Repository | Can run with |
|---|---|---|---|
| W0 | [P00A Governance source of truth](P00A-governance-source-of-truth.md) | XPointLabs superproject | P01/P02 after approval |
| W0 | [P00B Pinned manifest CI](P00B-pinned-manifest-ci.md) | deep-devops | after P00A |
| W0 | [P01 Metadata red tests](P01-metadata-red-tests.md) | deep-client-shared / push is separate follow-up | P00, P02 |
| W0 | [P02 Update trust and distribution ADR](P02-update-trust.md) | deep-devops | P00, P01 |
| W1 | [P03 Opaque bundle contract](P03-opaque-bundle-contract.md) | deep-protocol | P04, after W0 decisions |
| W1 | [P04 Membership/key hierarchy contract](P04-membership-contract.md) | deep-protocol | P03, P05 design |
| W1 | [P05 Storage replication ADR](P05-storage-replication-adr.md) | xnode | P03, P04 |
| W2 | [P06 Registry checkpoint projection](P06-registry-checkpoint.md) | deep-registry-api | P07/P08 after P04 version pinned |
| W2 | [P07 Client last-known-good trust](P07-client-membership.md) | deep-client-shared | P06 after P04 version pinned |
| W2 | [P08 Deterministic placement](P08-storage-placement.md) | xnode | P06/P07 after P04/P05 |
| W2 | [P09 Replicated mailbox MVP](P09-replicated-mailbox.md) | xnode | P10 after P08 |
| W2 | [P10 Stateless ingress](P10-stateless-ingress.md) | xnode | P09 unless ADR permits parallel files |
| W3 | [P11 Transport coordinator/outbox](P11-transport-outbox.md) | deep-client-shared | P12/P13 after P03/P07 |
| W3 | [P12 Android power and nearby](P12-android-nearby.md) | deep-client-maui | P11 consumer contract pinned |
| W3 | [P13 iOS foreground spike](P13-ios-nearby-spike.md) | deep-client-maui | not same hot files/time as P12 |
| W3 | [P14 Self-hosted profiles](P14-self-hosted-profiles.md) | deep-client-shared | P07 contract pinned |
| W3–W4 | [P15 Integration/impairment lab](P15-integration-lab.md) | deep-devops | consumes pinned SHA manifest |
| Shadow | [P16 Private entitlement design](P16-entitlement-design.md) | design/backend owner to be approved | does not block Beta |
| Shadow | [P17 Rewards V3 shadow](P17-rewards-shadow.md) | xpoint-staking-backend | does not change contracts |
| Shadow | [P18 LoRa simulator/pilot](P18-lora-pilot.md) | owner chosen after bundle contract | does not block Beta |
| W4 | [P19 Security/Beta reviewer](P19-security-beta-review.md) | read-only across repos | after evidence exists |

## Mandatory gap-closing producer/consumer prompts

- Protocol: [P03A compatibility metadata envelope](P03A-compatibility-metadata-envelope.md) → [P03B mailbox capability/receipt contract](P03B-mailbox-capability-protocol.md) → [P03C nearby handshake contract](P03C-nearby-handshake-contract.md).
- Control plane: [P04B checkpoint signer](P04B-checkpoint-signer-publisher.md) → [P04C bridge mirrors](P04C-bridge-mirror-publisher.md) and [P04D node-only XNode consumer](P04D-node-membership-consumer.md) → [P07B client bridge fetch](P07B-client-bridge-fetch.md).
- Mailbox: [P07A client capability lifecycle](P07A-mailbox-capability-lifecycle.md) plus [P09A replica runtime](P09A-storage-replica-runtime.md) → [P09B coordinator](P09B-replication-coordinator.md) → [P09C client mailbox adapter](P09C-client-mailbox-adapter.md).
- Managed transport: [P10B H2 wire contract](P10B-ingress-h2-contract.md) → server P10 and [P11A outbox](P11A-persistent-outbox.md) → [P11B racing](P11B-managed-transport-racing.md).
- Push: [P11D server opaque handles](P11D-private-push-server.md) → [P11C client lifecycle](P11C-private-push-client.md); otherwise metadata-safe Beta must disable push explicitly.
- Updates: P02 design/pipeline → [P02B MAUI verifier](P02B-maui-update-verification.md).
- Self-hosting: P14 model → [P14B MAUI import UX](P14B-maui-profile-ux.md) and [P14C XNode profile generator](P14C-xnode-profile-generator.md) → [P15B E2E fixtures](P15B-e2e-fixtures.md).
- Availability: [P16A anonymous Free admission ADR](P16A-free-admission-adr.md) is required before public essential mailbox, even though paid entitlement P16 is deferred.

Additional implementation/remediation packages:

- [P01B infrastructure log privacy](P01B-infrastructure-log-privacy.md), [P02C production-like update ceremony](P02C-production-update-ceremony.md), [P07C MAUI network control UX](P07C-maui-network-control-ux.md).
- [P14D self-hosted deployment kit](P14D-self-hosted-deployment-kit.md), [P16B paid-entitlement service prototype](P16B-entitlement-service-prototype.md).
- LoRa remains non-blocking and is split into [P18A protocol](P18A-lora-fragment-contract.md), [P18B simulator](P18B-lora-simulator.md) and [P18C hardware adapter](P18C-lora-hardware-adapter.md).

## Concurrency rules for four agent slots

- Root/orchestrator owns dependency decisions, manifests and acceptance; it should not concurrently edit a hot implementation file.
- At most three implementation agents run. Prefer different repositories.
- One agent, one repo, one work package, one report.
- Contract producer finishes and publishes a pinned SHA/package before consumer code begins.
- `RoutedSessionTransport.cs`, `RouterRuntime.cs`, `MauiProgram.cs`, bootstrap/trust loader, SQLite schema/migration files and compose files each have one owner per wave.
- Android and iOS tasks never share an agent or an uncoordinated hot file.

## Mandatory invocation fields

The orchestrator must fill these before sending a prompt:

```text
TARGET_REPOSITORY=
BASE_BRANCH=
BASE_SHA=
WORKTREE_OR_BRANCH=
PROGRAM_REVISION_SHA=
DEPENDENCY_MANIFEST_PATH=
EXPECTED_DEPENDENCIES=
LOCKED_FILES=
FEATURE_FLAG=
ARTIFACT_DIR=artifacts/survival/<ID>
REPORT_PATH=artifacts/survival/<ID>/work-package-report.json
DEVICE_LAB_OR_EXTERNAL_DEPENDENCIES=
```

The first step is `git rev-parse HEAD` and `git status --short`. If the SHA differs, the worktree contains changes not explicitly assigned, a lock is occupied, or any dependency artifact/hash is missing, the subagent stops without edits. It does not “make progress” by inventing a local contract. `dotnet pack` may write to the local artifact directory; external package publication requires separate authorization.

## Required handoff

Every subagent writes these versioned artifacts inside its assigned repository:

```text
artifacts/survival/<ID>/work-package-report.json
artifacts/survival/<ID>/test-results/*
artifacts/survival/<ID>/compatibility-impact.json
artifacts/survival/<ID>/migration-and-rollback.json
artifacts/survival/<ID>/security-impact.json
artifacts/survival/<ID>/handoff.json
```

Every subagent reports:

1. repository, base SHA and resulting commit/worktree state;
2. exact changed files;
3. tests/commands with exit codes and counts;
4. contract and compatibility impact;
5. migration/feature flag/rollback behavior;
6. security/privacy implications;
7. artifacts and report path;
8. unresolved risks and exact next consumer task.

The orchestrator accepts a work package only after focused tests, repository full tests where required, and manifest-level integration evidence. `handoff.json` records schema/program revision, repository/base/result SHA, dependency hashes, changed files, exact commands/exit codes/test counts, feature flag, migration phase, rollback, blockers and next prompt.
