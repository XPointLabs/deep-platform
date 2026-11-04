# Shared case qualification bindings — 2026-11-04

Status: accepted qualification mapping; no test or runtime acceptance.
Owner: Mr. X (delegated architecture authority).

This records exact case-name replacements for the combined Shared source gate.
Production semantics remain owned by the linked decisions. Original receipts
are unchanged; every replacement must actually pass. A mapping cannot waive
a failure, skip, missing current case or native nonzero exit.

Reviewed additional bindings preserve the corresponding requirement: indexed
lookup replaces full-scan cost expectations under DR-0177 at the same three
corpus sizes; bounded public retry tests eight actual reads inside the original
deadline; current immutable publication submission replaces the lease/winner-read
path under DR-0125, preserving the four lost-reply cuts and hostile input modes.
The replacement suite retains its additional outcomes and lost-Store cases.
DR-0178/0179 staging preserves expired history without current-L permission,
with actual fork, ACK and crash checks retained.

## Historical and reviewed clean-break bindings

Source: [DR-0126-independent-grant-after-unresolved-acquisition.md](../survival-program/decisions/DR-0126-independent-grant-after-unresolved-acquisition.md).

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2GrantCustody_ExpiredUnknownClosesUnderActualLeaseWithoutReissueAndSurvivesBothFaults(failAfterClosure: False) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2GrantCustody_ExpiredUnknownRetainsOriginalWhileIndependentNewWorkSurvivesBothFaults(failAfterClosure: False)

Source: [DR-0126-independent-grant-after-unresolved-acquisition.md](../survival-program/decisions/DR-0126-independent-grant-after-unresolved-acquisition.md).

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2GrantCustody_ExpiredUnknownClosesUnderActualLeaseWithoutReissueAndSurvivesBothFaults(failAfterClosure: True) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2GrantCustody_ExpiredUnknownRetainsOriginalWhileIndependentNewWorkSurvivesBothFaults(failAfterClosure: True)

Source: [DR-0126-independent-grant-after-unresolved-acquisition.md](../survival-program/decisions/DR-0126-independent-grant-after-unresolved-acquisition.md).

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_RequestExpiryAloneClosesUnknownWithoutReissueOrRetirement -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_IndependentNewReadRetainsUnknownWithoutRetirementOrOriginalReissue(fault: "none")

Source: [DR-0126-independent-grant-after-unresolved-acquisition.md](../survival-program/decisions/DR-0126-independent-grant-after-unresolved-acquisition.md).

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_RequestExpiryAloneClosesUnknownWithoutReissueOrRetirement -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_IndependentNewReadRetainsUnknownWithoutRetirementOrOriginalReissue(fault: "reply")

Source: [DR-0126-independent-grant-after-unresolved-acquisition.md](../survival-program/decisions/DR-0126-independent-grant-after-unresolved-acquisition.md).

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_RequestExpiryAloneClosesUnknownWithoutReissueOrRetirement -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_IndependentNewReadRetainsUnknownWithoutRetirementOrOriginalReissue(fault: "selection")

Source: [DR-0126-independent-grant-after-unresolved-acquisition.md](../survival-program/decisions/DR-0126-independent-grant-after-unresolved-acquisition.md).

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_RequestExpiryAloneClosesUnknownWithoutReissueOrRetirement -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_IndependentNewReadRetainsUnknownWithoutRetirementOrOriginalReissue(fault: "after-sql")

Source: [DR-0126-independent-grant-after-unresolved-acquisition.md](../survival-program/decisions/DR-0126-independent-grant-after-unresolved-acquisition.md).

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_RequestExpiryAloneClosesUnknownWithoutReissueOrRetirement -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_IndependentNewReadRetainsUnknownWithoutRetirementOrOriginalReissue(fault: "late")

Source: [DR-0131-owned-prekey-maintenance-author.md](../survival-program/decisions/DR-0131-owned-prekey-maintenance-author.md).

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.CompletedPublication_ExpiredInventoryRemainsExpiredDespiteValidStoredSignatures -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.CompletedPublication_ExpiredInventoryMaintainsBeforeDispatchAndPreservesOriginalCustody

Source: [DR-0176-bounded-protected-storage-inventory.md](../survival-program/decisions/DR-0176-bounded-protected-storage-inventory.md).

Deep.Client.Shared.Production.Tests.SecureStorageCompareExchangeTests.SelectedDecodeAvoidsUnrequestedValueBuffersWhileFullMutationDecodeRetainsThem -> Deep.Client.Shared.Production.Tests.SecureStorageCompareExchangeTests.SelectedReadLoadsBoundedManifestWithoutUnrequestedObjectPayloads

Source: [DR-0178-paged-route-history-and-current-promotion.md](../survival-program/decisions/DR-0178-paged-route-history-and-current-promotion.md).

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualAuthenticatedGapStaysRejectedAfterLatePredecessorAndColdPrefix -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteHistoryPaged_ActualGapStagesThenLatePredecessorAndRetainedContinuationPromote

Source: [DR-0178-paged-route-history-and-current-promotion.md](../survival-program/decisions/DR-0178-paged-route-history-and-current-promotion.md).

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualAuthenticatedSameGenerationForkPreservesLiveTrsAndColdFence -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteHistoryPaged_FreshAnnouncementOfSamePublicEndpointDoesNotCreatePrivateChainFault

Source: [DR-0178-paged-route-history-and-current-promotion.md](../survival-program/decisions/DR-0178-paged-route-history-and-current-promotion.md).

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualAuthenticatedSameGenerationForkPreservesLiveTrsAndColdFence -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteHistoryPaged_ActualAuthoredPositionForkCommitsExactWholeControlFaultAndColdFence

Source: [DR-0145-owned-group-control-rendezvous.md](../survival-program/decisions/DR-0145-owned-group-control-rendezvous.md).

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2Groups_OwnedBatchNativeReceiveColdHistoryAndReplayInBothDirections -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2Groups_DescriptorNativeCustodyAndUnpublishedCommitBlocksApplicationSend

Source: [DR-0177-authenticated-native-archive-index.md](../survival-program/decisions/DR-0177-authenticated-native-archive-index.md); Shared 8a399e8.

Deep.Client.Shared.Production.Tests.Did2ActiveNativeCostTests.Did2ActiveArchive_StructuralNativeVerifierCostKeepsCompleteMapAndCipherScan(count: 100) -> Deep.Client.Shared.Production.Tests.Did2ActiveNativeCostTests.Did2IndexedArchive_StructuralSelectedLookupKeepsProofAndRowidBoundsWithoutHistoryScan(count: 100)

Source: [DR-0177-authenticated-native-archive-index.md](../survival-program/decisions/DR-0177-authenticated-native-archive-index.md); Shared 8a399e8.

Deep.Client.Shared.Production.Tests.Did2ActiveNativeCostTests.Did2ActiveArchive_StructuralNativeVerifierCostKeepsCompleteMapAndCipherScan(count: 1000) -> Deep.Client.Shared.Production.Tests.Did2ActiveNativeCostTests.Did2IndexedArchive_StructuralSelectedLookupKeepsProofAndRowidBoundsWithoutHistoryScan(count: 1000)

Source: [DR-0177-authenticated-native-archive-index.md](../survival-program/decisions/DR-0177-authenticated-native-archive-index.md); Shared 8a399e8.

Deep.Client.Shared.Production.Tests.Did2ActiveNativeCostTests.Did2ActiveArchive_StructuralNativeVerifierCostKeepsCompleteMapAndCipherScan(count: 10000) -> Deep.Client.Shared.Production.Tests.Did2ActiveNativeCostTests.Did2IndexedArchive_StructuralSelectedLookupKeepsProofAndRowidBoundsWithoutHistoryScan(count: 10000)

Source: Shared 64477cb66b24a88f5404ee142b810bf5da868c23.

Deep.Client.Shared.Production.Tests.HttpDeepIdV2NetworkClosureArtifactSourceTests.PersistentContention_StopsAfterFourPublicReads -> Deep.Client.Shared.Production.Tests.HttpDeepIdV2NetworkClosureArtifactSourceTests.PersistentContention_StopsAfterEightPublicReads

Source: [DR-0125-current-publication-submission.md](../survival-program/decisions/DR-0125-current-publication-submission.md); Shared e8a11782c8e9c83cad693e4aa70664828bc5ab3f.

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationLease_ReauthorizesExactExpiredIntentWithCurrentOwnerAndWitnesses -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationCurrent_UsesCurrentApprovalAndImmutableBody

Source: [DR-0125-current-publication-submission.md](../survival-program/decisions/DR-0125-current-publication-submission.md); Shared e8a11782c8e9c83cad693e4aa70664828bc5ab3f.

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationLease_HostileBytesCurrentScopeAndCallbacksFailClosed(mode: 6) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationCurrent_HostileBytesCurrentScopeAndCallbacksFailClosed(mode: 6)

Source: [DR-0125-current-publication-submission.md](../survival-program/decisions/DR-0125-current-publication-submission.md); Shared e8a11782c8e9c83cad693e4aa70664828bc5ab3f.

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationLease_HostileBytesCurrentScopeAndCallbacksFailClosed(mode: 7) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationCurrent_HostileBytesCurrentScopeAndCallbacksFailClosed(mode: 7)

Source: [DR-0125-current-publication-submission.md](../survival-program/decisions/DR-0125-current-publication-submission.md); Shared e8a11782c8e9c83cad693e4aa70664828bc5ab3f.

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationLease_HostileBytesCurrentScopeAndCallbacksFailClosed(mode: 8) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationCurrent_HostileBytesCurrentScopeAndCallbacksFailClosed(mode: 8)

Source: [DR-0125-current-publication-submission.md](../survival-program/decisions/DR-0125-current-publication-submission.md); Shared e8a11782c8e9c83cad693e4aa70664828bc5ab3f.

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationWinnerRead_CurrentReadRejectsHostileFramingPublisherAndClock -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationCurrent_CurrentSubmissionRejectsHostileFramingPublisherAndClock

Source: [DR-0125-current-publication-submission.md](../survival-program/decisions/DR-0125-current-publication-submission.md); Shared e8a11782c8e9c83cad693e4aa70664828bc5ab3f.

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationWinnerRead_ExpiredLostReplyColdReopenKeepsOriginalIntent(fault: 0) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationCurrent_RecoversAllUnfinishedOriginalOutcomes(outcome: 2, fault: 0, lostStore: False)

Source: [DR-0125-current-publication-submission.md](../survival-program/decisions/DR-0125-current-publication-submission.md); Shared e8a11782c8e9c83cad693e4aa70664828bc5ab3f.

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationWinnerRead_ExpiredLostReplyColdReopenKeepsOriginalIntent(fault: 1) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationCurrent_RecoversAllUnfinishedOriginalOutcomes(outcome: 2, fault: 1, lostStore: False)

Source: [DR-0125-current-publication-submission.md](../survival-program/decisions/DR-0125-current-publication-submission.md); Shared e8a11782c8e9c83cad693e4aa70664828bc5ab3f.

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationWinnerRead_ExpiredLostReplyColdReopenKeepsOriginalIntent(fault: 2) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationCurrent_RecoversAllUnfinishedOriginalOutcomes(outcome: 2, fault: 2, lostStore: False)

Source: [DR-0125-current-publication-submission.md](../survival-program/decisions/DR-0125-current-publication-submission.md); Shared e8a11782c8e9c83cad693e4aa70664828bc5ab3f.

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationWinnerRead_ExpiredLostReplyColdReopenKeepsOriginalIntent(fault: 3) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2PublicationCurrent_RecoversAllUnfinishedOriginalOutcomes(outcome: 2, fault: 3, lostStore: False)

## Staged route-control crash and ACK cases

Sources: [DR-0179](../survival-program/decisions/DR-0179-established-native-session-provenance.md) and [DR-0178](../survival-program/decisions/DR-0178-paged-route-history-and-current-promotion.md).

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualMailboxAckRetainsFirstAcceptedOrExpiredOutcome(expiredBeforeReceive: False) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualMailboxAckRetainsStagedHistoryAndExpiredProgressWithoutPromotion(expiredBeforeReceive: False)

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualMailboxAckRetainsFirstAcceptedOrExpiredOutcome(expiredBeforeReceive: True) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualMailboxAckRetainsStagedHistoryAndExpiredProgressWithoutPromotion(expiredBeforeReceive: True)

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualOwnedControlCommitsFirstOutcomeAndColdExactReplay(fault: "AfterPending", cancellation: False) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualOwnedControlCommitsStage3AndColdExactReplay(fault: "AfterPending", cancellation: False)

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualOwnedControlCommitsFirstOutcomeAndColdExactReplay(fault: "AfterPending", cancellation: True) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualOwnedControlCommitsStage3AndColdExactReplay(fault: "AfterPending", cancellation: True)

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualOwnedControlCommitsFirstOutcomeAndColdExactReplay(fault: "AfterSql", cancellation: False) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualOwnedControlCommitsStage3AndColdExactReplay(fault: "AfterSql", cancellation: False)

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualOwnedControlCommitsFirstOutcomeAndColdExactReplay(fault: "AfterSql", cancellation: True) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualOwnedControlCommitsStage3AndColdExactReplay(fault: "AfterSql", cancellation: True)

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualOwnedControlCommitsFirstOutcomeAndColdExactReplay(fault: "AfterStable", cancellation: False) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualOwnedControlCommitsStage3AndColdExactReplay(fault: "AfterStable", cancellation: False)

Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualOwnedControlCommitsFirstOutcomeAndColdExactReplay(fault: "AfterStable", cancellation: True) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualOwnedControlCommitsStage3AndColdExactReplay(fault: "AfterStable", cancellation: True)

