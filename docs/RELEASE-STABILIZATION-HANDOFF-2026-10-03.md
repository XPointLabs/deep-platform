# Release stabilization handoff — 2026-10-03

Owner: Mr. X. Branch: `release-candidate/prod-20260909`.
This is a compilation/checkpoint handoff, **not release qualification**.

## Scope frozen by the operator

Feature work and physical E2E were stopped at the operator's request.
The uncommitted DR-0082/request-admission API/journal experiment from this pass
was removed; no new protocol or journal is introduced by this stabilization.
Already committed DR-0081 framing is preserved for independent review, not
claimed to be deployed or physically working.

Compilation repairs removed eight node and seven Registry test files whose
production APIs had already been deleted. No legacy production API, alias or
reader was restored. Current DID2 Registry tests now use a narrow signed
network/view/genesis fixture instead of a fixture carrying retired identity
and positive V1 directory branches. MAUI Smoke/Device tests now reference the
same DID2 Core as the actual application; the obsolete Core project is outside
the current solution, not a hidden compatibility dependency.

The current DevOps bootstrap source cutover (including the previously pending
offline authoring files) is retained and compiles. The dev initializer now uses
the existing candidate/proof/completion APIs instead of the deleted AuthorAsync.
It has **not** provisioned or changed an environment in this pass.

## Exact source heads

| Repository | Commit |
| --- | --- |
| deep-protocol | c037aee6af66e1f88a36f91d2fffba041a26b246 |
| deep-client-shared | 07ae50d3408fbcebf0e545104d4a207fda3d02a8 |
| xnode | b5899c90707c7c12b30849f05e0bb3ff9090217b |
| deep-registry-api | 5c79cb07620915769f673fd4b92624d774ad709e |
| deep-client-maui | 5dd1c34c3ee333a23583dd05b9f6f0fbc8fcf96f |
| deep-devops | af4f833787b2dcb41e8aac7ed8b54d69d4cbdfe3 |
| xpoint-node-installer (existing pending branch commits) | 381893257926732af1fb143d054f03f8a2b073c0 |

Author and committer for stabilization commits:
zhigubigule <286287771+zhigubigule@users.noreply.github.com>.

## Compilation evidence

Run the commands from their respective repository directories.

```powershell
# Protocol: 0 warnings / 0 errors
dotnet build Deep.Protocol.slnx -c Release -clp:ErrorsOnly --verbosity quiet

# Shared current production solution: 0 / 0
dotnet build Deep.Client.Shared.Production.slnx -c Release -clp:ErrorsOnly --verbosity quiet

# Node complete solution, including all current test assemblies: 0 / 0
dotnet build XNode.slnx -c Release -p:DeepProtocolSourceCutover=true -clp:ErrorsOnly --verbosity quiet

# Registry complete solution, including all current test assemblies: 0 / 0
dotnet build Deep.Registry.Api.slnx -c Release -p:DeepProtocolLocalCutover=true -p:DeepProtocolSourceCutover=true -clp:ErrorsOnly --verbosity quiet

# MAUI actual Windows and Android applications, separately: each 0 / 0
dotnet build src/Deep.Client.Maui/Deep.Client.Maui.csproj -c Debug -f net10.0-windows10.0.19041.0 -p:RuntimeIdentifierOverride=win-arm64 -p:DeepProtocolSourceCutover=true -clp:ErrorsOnly --verbosity quiet
dotnet build src/Deep.Client.Maui/Deep.Client.Maui.csproj -c Debug -f net10.0-android -p:DeepProtocolSourceCutover=true -clp:ErrorsOnly --verbosity quiet

# Complete current MAUI solution: 2 warnings / 0 errors
dotnet build Deep.Client.Maui.slnx -c Debug -p:RuntimeIdentifierOverride=win-arm64 -p:DeepProtocolSourceCutover=true -clp:ErrorsOnly --verbosity quiet

# DevOps tools: each 0 / 0
dotnet build tools/production-authority-bootstrap-tests/ProductionAuthority.Bootstrap.Tests.csproj -c Release -clp:ErrorsOnly --verbosity quiet
dotnet build tools/deep-dev/Deep.Dev.csproj -c Release -clp:ErrorsOnly --verbosity quiet
```

MAUI Clean and Smoke test projects also build Release with 0 / 0; DeviceTests
builds Release with 2 warnings / 0 errors. Windows evidence is ARM64 Debug,
not Windows x64 Release or a signed release package. Android is Debug and was
not installed or launched. Apple platforms were not built.

The historical Shared solution and retired MAUI Core/UiTests harness are not
current production gates. This checkpoint does not pretend they were repaired.

## Test evidence and remaining failures

- MAUI Clean: **93 passed, 0 failed, 0 skipped**.
- Affected node capability/business invariant slice: **39/39**.
- Affected node DID2 proof/staging/claim/mailbox integration slice: **23/23**.
- Replacement Registry DID2 genesis/state/restorer/network fixtures: **4/4**.
- DevOps bootstrap synthetic-input executable: all five named scenarios pass;
  it authors only isolated test custody, never production custody.
- Full Registry: **292 passed, 31 failed, 6 skipped**.
- Final full node rerun: integration **445 passed / 3 failed**; unit
  **281 passed / 16 failed**; profile generator **107 passed / 0 failed**;
  no skips. One earlier unit failure was corrected: the signature tamper
  fixture still used offsets from the previous grant length. Current public
  size constants now target the issuer and holder signatures separately.
  Both the final 39/39 slice and full rerun verify that repair. The remaining
  **19 failures** are retained for independent review.

Do not delete remaining failing tests simply to report a green gate.
Registry sample diagnosis found a catalog fixture still specifying reader 1
(the current closure requires reader 2), and a DB test deliberately failing
because its isolated PostgreSQL connection was not configured. The other
failures have not all been classified as product vs harness defects.

### Final full node failure inventory

- `XNode.IntegrationTests.Runtime.ContactReplicaTransportTests.HttpTransportRejectsAResponseSignedByTheWrongPeer`
- `XNode.IntegrationTests.Runtime.ContactServiceTerminalDispatchTests.ProductionCompositionKeepsContactRuntimeAndReplicaEndpointDormant`
- `XNode.IntegrationTests.Runtime.ContactReplicaTransportTests.HttpTransportTimeoutIsOutcomeUnknown`
- `XNode.Tests.Core.ContactPreKeyXpc1ResponseTests.PublicVerifierContractIsPresentWithoutServerRawKeyInputs`
- `XNode.Tests.Core.ContactServiceOpaqueFacadeTests.CommittedFailpointReturnsUnknownWithoutReceiptsAndRestartExactReplays`
- `XNode.Tests.Core.ContactServiceOpaqueFacadeTests.PartialReplicaCommitStaysReservedWithoutReceiptsThenReconciles`
- `XNode.Tests.Core.ContactAuthorizedPublicationReplicaTests.ExactXpaReservationAndCommitSurviveReplicaRestart`
- `XNode.Tests.Core.ContactAuthorizedPublicationReplicaTests.SameAuthorizationWithChangedAuthorizedBodyFailsBeforeSecondMutation`
- `XNode.Tests.Core.ContactServiceOpaqueFacadeTests.ContextMismatchDoesNotMutateAndAcceptedPublishDurablyExactReplays`
- `XNode.Tests.Core.ContactServiceOpaqueFacadeTests.ReservedFailpointNeverReturnsCommittedAndRestartFinishesExactRequest`
- `XNode.Tests.Core.ContactServiceOpaqueFacadeTests.SameAuthorizationChangedExactBodyPermanentlyLatchesConflict`
- `XNode.Tests.Core.ContactServiceOpaqueFacadeTests.PublishedClosureCommitsOneTimeInviteAndSuccessExactReplays`
- `XNode.Tests.Core.ContactServiceOpaqueFacadeTests.ReceiptIssuanceHonorsCallerCancellationWithoutReturningAResponse`
- `XNode.Tests.Core.ContactServiceOpaqueFacadeTests.PartialAuthorityFailureNeverEmitsTheSuccessfulPartialReceipt`
- `XNode.Tests.Core.ContactServiceOpaqueFacadeTests.ResolveUsesPublishedRouteClosureWithoutExternalLocatorLookup`
- `XNode.Tests.Core.ContactServiceOpaqueFacadeTests.InvalidSignatureSizeFailsClosedWithoutReceiptEmission`
- `XNode.Tests.Core.ContactServiceOpaqueFacadeTests.ConcurrentExactAuthorizationIsConsumedOnceAndOnlyExactReplaysFollow`
- `XNode.Tests.Core.ContactServiceOpaqueFacadeTests.RemoteShapedAuthoritiesAreDelegatedAndReceiptsStayCanonicallySorted`
- `XNode.Tests.Core.ContactServiceOpaqueFacadeTests.CrossReplicaReceiptSubstitutionFailsClosedWithoutReceiptEmission`

### Full Registry failure inventory

- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.InputsOutputsAndAnchorsAreDefensiveCopies`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.MaximumSizedFiveArtifactClosureFitsOneBoundedSegment`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.CorruptHistoricalSegmentQuarantinesOnlyWhenLazyReadTouchesIt`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.CrashRecoveryIsAtomicAtEveryCommitStage(failpointValue: 0, successorMustRecover: False)`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.CrashRecoveryIsAtomicAtEveryCommitStage(failpointValue: 1, successorMustRecover: True)`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.CrashRecoveryIsAtomicAtEveryCommitStage(failpointValue: 2, successorMustRecover: True)`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.CorruptManifestIsPersistentlyQuarantined`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.ConfiguredArtifactBoundRejectsBeforeVerifierAndMutation`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.DefaultRetentionAccepts2047_2048_And2049ContiguousGenerations`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.SameGenerationDifferentCanonicalBytesLatchesForkAcrossRestart`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.TypedVerifierCannotSubstituteDifferentCanonicalBytes`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.WrongNetworkRejectsWithoutPersistenceMutation`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.SecondInstanceReadsHeadPublishedAfterItsInMemorySnapshot`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.OpenAndCommitReadOnlyBoundedMetadataAndHeadSegment`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.RestartPreservesExactBytesHashesAndExactReplay`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.Configured2048GenerationCapacityRejectsOnlyThe2049thAppend`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.GenerationCompareExchangeIsAtomicAcrossCatalogInstances`
- `Deep.Registry.Api.Tests.DirectoryPublicationCatalogTests.AbsoluteArtifactMaxPlusOneAndResetCardinalityRejectBeforeCopy`
- `Deep.Registry.Api.Tests.DirectoryPublicationHttpTests.Concurrent_same_challenge_publish_has_one_commit_and_one_fail_closed_replay`
- `Deep.Registry.Api.Tests.DeepIdV2RouteThresholdJournalTests.PermanentJournalSurvivesCallbackFailureConcurrentRetryRestartAndCapacity(upgradeExisting: False)`
- `Deep.Registry.Api.Tests.DeepIdV2RouteThresholdJournalTests.PermanentJournalSurvivesCallbackFailureConcurrentRetryRestartAndCapacity(upgradeExisting: True)`
- `Deep.Registry.Api.Tests.DeepIdV2RouteThresholdJournalTests.OperatorFenceAbortsOnExistingCompetingNoncesWithoutChangingEvidence`
- `Deep.Registry.Api.Tests.DeepIdV2MailboxGrantJournalTests.OperatorConstraintCutoverRejectsIncompatibleWinnerWithoutRepairOrReissuance`
- `Deep.Registry.Api.Tests.DeepIdV2MailboxGrantJournalTests.HashOnlyReservationConcurrentWinnerRestartConflictCapacityAndCorruption`
- `Deep.Registry.Api.Tests.DirectoryPublicationHttpTests.Malformed_and_max_plus_one_artifacts_fail_before_verifier_or_commit`
- `Deep.Registry.Api.Tests.DeepIdV2RouteThresholdIssuerTests.ActualPqAccountAda2FloorWitnessCustodyAndJournalCloseOwnedRouteOverHttp(crashMode: 2)`
- `Deep.Registry.Api.Tests.DeepIdV2RouteThresholdIssuerTests.ActualPqAccountAda2FloorWitnessCustodyAndJournalCloseOwnedRouteOverHttp(crashMode: 0)`
- `Deep.Registry.Api.Tests.DeepIdV2RouteThresholdIssuerTests.ActualPqAccountAda2FloorWitnessCustodyAndJournalCloseOwnedRouteOverHttp(crashMode: 1)`
- `Deep.Registry.Api.Tests.DeepIdV2PublicationJournalTests.PublicationSuccessorProvisionPreservesOpaqueAuditAndUnsignedPermanentFence`
- `Deep.Registry.Api.Tests.DirectoryPublicationHttpTests.Verifier_rejection_occurs_before_catalog_commit_and_is_sanitized`
- `Deep.Registry.Api.Tests.DirectoryPublicationHttpTests.Mirror_returns_byte_identical_immutable_generation_manifest_and_head_with_cache_contracts`

## Functional release blockers

Compilation does not close the full messaging path. The last known production
mailbox authority was unready; current protected-time holder/revocation/replay/
local-selected-exit admission and grant-bound peer mutation/quorum remain open.
Retired node PMA1/P04 composition, current signed PMA2/PMT2 provisioning,
consumer/package/API/evidence repinning and matched service activation require
an independent architecture/runtime audit before deployment.

Physical contacts/consent, bidirectional text, remote file/image integrity and
governed groups on Windows/USB Android are **not qualified**. A previous Android
retry failed at `route-time-coverage-rejected / XRA1 / Expiry`; preserved Windows
QA custody was incompatible. Neither was reset in this stabilization.
A past own-publication success or in-process test is not physical peer delivery.

No production deployment, network/genesis/key/floor reset, account mutation,
main merge or GitHub Release publication was performed in this stabilization.

## Push status

Ordinary `git push --porcelain origin HEAD` was attempted using the existing Git
credential helper without a token injection. It failed before uploading:
`could not read Username for 'https://github.com': terminal prompts disabled`.
That first attempt made no upload. Token-based operations had previously been
denied by the tool; no alternate credential helper, token/header/API wrapper
was used to bypass that denial.

The operator subsequently authorized normal browser authentication.
Git Credential Manager browser login completed for zhigubigule, then ordinary
push succeeded for all seven repositories listed above, using that saved
account (no token injection, no force). Their branch is
`release-candidate/prod-20260909`. The superproject carries their exact pointers
and this handoff; no main merge or Release publication is implied.

The other repositories had no dirty files or locally pending commits against
their recorded upstreams; they were not rewritten or merged. The installer
push preserves its five already-existing local branch commits; no installer
runtime validation was performed in this stabilization.

The earlier checkpoint's “69 Registry compile errors” is superseded by the
zero-error compilation evidence above, not by a claim of green full tests.
