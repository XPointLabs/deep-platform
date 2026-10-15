# DR-0126 — independent new-work grant after unresolved acquisition

Status: accepted semantic correction; source, bounded retirement and device gates remain
Date: 2026-10-15
Decision owner: Mr. X (delegated architecture authority)

The retained Windows physical retry reached the existing authenticated acquisition
closure, then `AcquisitionForNewWork` rejected every further read of that mailbox.
The source confused keeping an uncertain authorization namespace with forbidding
an independently authorized new namespace. A grant acquisition is not a Store,
Retrieve or ACK attempt, nor an application command or ciphertext.

The sole transition owner is
[TRANSPORT-NEUTRAL-MESSAGING §8.4.2](../../architecture/TRANSPORT-NEUTRAL-MESSAGING.md#842-grant-and-route-transitions).
Its new-work rule now distinguishes appending an independent acquisition from
reissuing, rewriting, settling or retiring an original acquisition. This
supersedes only the former unconditional closed-tail scheduling refusal.
Unadopted late results still require their exact existing recovery; active
transport work keeps its original request/grant/counter/ciphertext. All authority,
expiry, capacity, consent, outcome and irreversible-deletion checks remain.

Use the current protected predecessor graph and owner-generated independent
holder/request. No wire, signature domain, protocol/journal version, slot,
generation, limit, compatibility reader or lifetime extension is allocated.
Old uncertainty remains exact and counted. This decision is not permission to
delete old rows or floors, infer non-issuance, reset an account, replace an active
attempt or remint a sender event.

Qualification must cover actual two-direction owned acquisition, distinct new
holder/request, retained originals, pending exact replay, late-result non-
overwrite, full-bound refusal before signing, active read/Store/ACK preservation,
fault/cold reopen and dependency-closed retirement of the resulting graph.
The same retained physical accounts must then exchange contact and text. Neither
source tests nor this decision are release approval; bounded mixed-history
retirement and full/device qualification remain required before acceptance.

## Exact source-case replacement declaration

The former blanket refusal cases are replaced, not retained as a second positive
runtime path. Their original TRX remain unchanged. The canonical full runner must
require every replacement to pass, with this decision hash captured; no FAIL or
skip is waived. No other baseline case is retired by this declaration.

```text
Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2GrantCustody_ExpiredUnknownClosesUnderActualLeaseWithoutReissueAndSurvivesBothFaults(failAfterClosure: False) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2GrantCustody_ExpiredUnknownRetainsOriginalWhileIndependentNewWorkSurvivesBothFaults(failAfterClosure: False)
Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2GrantCustody_ExpiredUnknownClosesUnderActualLeaseWithoutReissueAndSurvivesBothFaults(failAfterClosure: True) -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2GrantCustody_ExpiredUnknownRetainsOriginalWhileIndependentNewWorkSurvivesBothFaults(failAfterClosure: True)
Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_RequestExpiryAloneClosesUnknownWithoutReissueOrRetirement -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_IndependentNewReadRetainsUnknownWithoutRetirementOrOriginalReissue(fault: "none")
Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_RequestExpiryAloneClosesUnknownWithoutReissueOrRetirement -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_IndependentNewReadRetainsUnknownWithoutRetirementOrOriginalReissue(fault: "reply")
Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_RequestExpiryAloneClosesUnknownWithoutReissueOrRetirement -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_IndependentNewReadRetainsUnknownWithoutRetirementOrOriginalReissue(fault: "selection")
Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_RequestExpiryAloneClosesUnknownWithoutReissueOrRetirement -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_IndependentNewReadRetainsUnknownWithoutRetirementOrOriginalReissue(fault: "after-sql")
Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_RequestExpiryAloneClosesUnknownWithoutReissueOrRetirement -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2AutomaticNamespaceRetirement_IndependentNewReadRetainsUnknownWithoutRetirementOrOriginalReissue(fault: "late")
```
