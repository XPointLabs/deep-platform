# DR-0093 — retire the pre-cutover mailbox route-control source/API

Status: accepted, frozen source/API retirement authorization; implementation and package closure gated
Date: 2026-10-05
Decision owner: Mr. X (delegated pre-user architecture authority)

## Decision and exact boundary

DR-0081's current PMA2/PMT2/PMS2 and MCG3/MCP3/MAU3/XMC2 path must not coexist
with the pre-cutover PMA1-owned route-control producer/consumer surface merely
because the latter is disabled. Remove the old route topology, advertisement,
continuity, selection-successor, owner-control, history, issuer authoring and
cache source/API, with its positive implementation-specific corpus. Git history
is the historical record. Do not rename that implementation into a current
verifier, add aliases, or retain a compatibility reader.

This is the separately frozen authorization required by the retained D--G
API clause in DNP1-CLASSICAL-IDENTITY-RESET-MRL2-V1. Its scope is exactly the
public types in `Deep.Protocol.DeepExtension.MailboxTopology` implemented by
`deep-protocol/src/Deep.Protocol.MembershipRoutes/ProductionMailbox*.cs`,
plus `Deep.Protocol.DeepExtension.MailboxAuthority.ProductionMailboxRoutesVerificationFacade`.
Input Protocol is `83a0f32656d1cc5315b548c3488111cc6fa05886`; input root is
`c7284f6d373bc5cec11f552b4bb7f76bfa676b83`. The authorization permits removal
only, not replacement public authority factories or new signing/restore inputs.
These old APIs cannot be used as current contact, mailbox or renewal authority.

It does not authorize changing retained D--G record bytes/domains, introducing
another wire generation, reallocating a magic/ID, or accepting old bytes in a
current reader. Allocations remain permanently reserved. Current owned DID2
route/contact/one-time and counter-floor APIs are unchanged. The exact-three
production package graph remains mandatory; no dark package is substituted.

The local allocation lifecycle follows the actual authorized removal: OCR1,
PMCQ, PMCR, PMFA, PMS1, PMT1, POC1, PRC1, RCH1, RHB1, ROL1, PRA1, PSS1,
RCD1, RDA1, RCR1, RHC1, RTC1, RCA1, PRA2 and PSS2 become RETIRED_REJECT once
their implementation paths are absent. Preserve every allocation row; remove
their generated public encoding constants and inactive-implementation entries.
PMA1/PMR1 imported native dependencies are not retired by this leaf. Review
source inventory and normative anchor deltas before mechanical repinning;
frozen DNP1 imports, IDs, domains and record grammar remain unchanged.

## Preserved guarantees and excluded changes

Independent verifier-issued DNP1 account/device/revocation evidence required by
DR-0069 remains mandatory. No raw-to-verified conversion, caller-supplied time,
unsigned node list, empty revocation source or configuration authority is added.
ReleaseRoot, reset, retention, recovery, replay, protected floors and the full
V1 product guarantees are not removed from the release scope.

The native DNP1 membership/routing and recovery consumers of PMA1/PMR1 are not
changed by this authorization. They remain an explicit S00 dependency; the old
PMA1 codec cannot be deleted by replacing a verified input with a parsed object,
zero/empty fact or a weakened recovery check. Closing that dependency requires
its own reviewed current-owner mapping before source/API or protected grammar
changes. No S00 acceptance follows from deleting the route-control leaf alone.

Identity-neutral membership descriptor/inclusion and MIP1 framing are outside
this removal. Where a retained helper reads only the old topology clock-skew
constant, preserve the exact bound locally; do not retain topology authority
types merely as a constants provider. This does not activate that helper or
qualify its release path. Its remaining legacy dependencies remain S00 work.

## Consumer, API and acceptance rules

Current Protocol/Registry/XNode/Shared/MAUI source consumers must build against
the removal. Old excluded/default-client services are removal inputs, never
fallbacks for the production whitelist. Preserve unrelated live primitives and
their independent malformed, signature, quorum and crash/retry assertions.
The downstream retired `XNode.Core.Mailbox.Client.MailboxClientStoreAdapter`
and its delivery partial still call the removed PMT1 selection helper, but
current Program/NativeMailboxExitDispatcher do not use them. Remove those two
source files and the wholly adapter-owned MailboxNativeMau2BusinessInvariantTests
corpus, after verifying its preceding full receipt contains no failures. Do not
copy the PMT1 commitment into a new helper or substitute it for authenticated
MCG3 selection. Preserve mixed current ingress/no-fallback and peer-observer
checks against the current coordinator, and the independent capacity codecs.
Current native replay, operation-ledger, replication/receipt and crash/retry
owners remain unchanged and must receive a fresh downstream full qualification.
Retire only tests whose entire owner is removed; any neutral scenario in a mixed
file must remain. A current full receipt must show the removed cases were not
unexplained failures, and new tests must inspect the actual assembled surface.

Review the actual public-API delta against the exact retired type scope: no
unrelated removal, addition or authority widening is permitted. Re-freeze strict
Debug/Release package/API/resource snapshots only after the coherent production
graph is reviewed; never accept an observed arbitrary hash or old snapshot as
a compatibility exception. Source and actual-package rejection gates remain
strict while the remaining graph is open.

Run focused retained/absence tests, required full gates and downstream builds on
one recorded source matrix; distinguish leaf evidence from S00/package/release
acceptance. Final artifact pins, operator provisioning and physical Windows /
Android contact/text/restart remain prerequisites for release qualification.
No deployed data, registered key, authority lineage, genesis, protected floor or
operational secret is reset by source removal. No publication or activation is
authorized by this decision.
