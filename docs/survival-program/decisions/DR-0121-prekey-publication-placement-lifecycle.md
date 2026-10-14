# DR-0121 — prekey publication survives operational view renewal

Status: accepted pre-production clean break; connected/device activation gated
Date: 2026-10-15
Decision owner: Mr. X (delegated architecture authority)

The semantics owner is [CONTACT-RESOLVER](../../architecture/CONTACT-RESOLVER-V1.md).
The old publication placement committed a short-lived XNV/PMT envelope inside an
immutable XPP1 and its permanent XIC1 receipts. Ordinary operational renewal
therefore stranded both pending publication and completed inventory. Changing
keys, operation IDs, signed inventory or dropping current authority is not a fix.

For `PublishPreKeyInventory` only, `placementHash32` now commits the independently
derived logical assignment rather than the current view/PMT artifact. Its exact
SHA256-D domain and fixed-width preimage are defined by the semantics owner and
the `preKeyPublicationPlacement` machine entry in
`deep-protocol/registry/deep-id-v2.registry.json`. Other request kinds retain
their current view/PMT-bound placement hash. Ranking is unchanged. The publication
hash binds network, selection epoch, service class/capability, placement input,
replica count and ordered selected node identities. A changed epoch or selected
set cannot authorize retry or claim; supported inventory/handover is a separate
boundary, not an implicit copy of one-time claim state to new replicas.

XPP1/XIC1/fragment versions, suites, layouts, signature/hash domains and bounds
are unchanged. No new public API or legacy reader is introduced. The existing
NETCODEC placement factory mints the new publication value after full current
network verification; callers cannot select its value. Current fragment tag4
is still checked against independently acquired current authority on every
client route, terminal dispatch, peer dispatch and final commit. Tag5 remains the
publication placement hash. A historical fragment view is never current authority.

Across an ordinary view renewal, the logical aggregate, operation ID, XPI1/DPK2,
public support, descriptors and chunk bytes remain exact. Only fragment tag4 is
refreshed from current verified authority before dispatch. The private replica
journal compares immutable logical fields, not a short-lived carriage view;
it may retain original exact fragments and complete with newly admitted current
fragments. Before any stage mutation, incoming tag4 must equal the current
independently minted view and every other scope check remains mandatory. A stale
or foreign view must not poison an existing logical operation as an inventory
fork. Any changed immutable field still conflicts/fork-latches. Stored view
metadata is not reused for route, signature, final-commit or claim authority.

Final commit independently refreshes DID2/device/network/time, validates the
complete signed inventory, and uses the current assignment. An existing exact
receipt returns without re-signing. Both receipts must still verify against the
same exact aggregate, current selected identities and signed inventory interval;
claim reservation/use counters remain in their original service custody.

This is a semantic clean break, not migration. Previously authored view-bound
publication hashes fail the new current assignment check; they are not rewritten
or interpreted through an old path. Preserve the existing probe as negative
evidence. Use a separately scoped disposable current account for positive
post-cutover checks; no production/account/node key or floor reset is implied.

Required tests: real signed operational successors with stable publication hash
but changed view and non-publication placement; epoch/service/network/set
separation; partial-stage and post-commit cold reopen across views; unchanged
aggregate/operation/secret inventory and exact receipt replay without signer
callbacks; stale/foreign view rejection before mutation without poisoning;
immutable-content conflicts; actual current owned-client publication/claim after
renewal. Source fixtures, health and an empty mailbox are not physical delivery.

All affected consumers must rebuild together. Production deployment, package
qualification, S06 and GitHub Releases remain independently gated.

The obsolete node test
`XNode.Tests.Core.DeepIdV2PublicationJournalTests.ChunkFromDifferentView_LatchesForkBeforeAnyChunkIsWritten`
is replaced by
`XNode.Tests.Core.DeepIdV2PublicationJournalTests.ChunkFromDifferentView_IsRejectedWithoutMutationOrPoisoningInventory`.
This is an exact semantic case retirement for canonical qualification: the old
case must be absent, the replacement must pass, and unrelated cases remain
required. Stale-view rejection and zero chunk mutation remain asserted; only
the incorrect inventory-fork side effect is retired.
