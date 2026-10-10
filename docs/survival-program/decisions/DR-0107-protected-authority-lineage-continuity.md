# DR-0107 — exact protected history across verified authority renewal

Status: accepted S01 contract; source candidate, connected/host activation pending
Date: 2026-10-09
Decision owner: Mr. X (explicitly delegated architecture authority)

## Decision and sole owners

Extend DR-0012's initial same-authority restriction to the existing fully
verified XNA1/DTS1 lineage. Sole network semantics are in
[XPOINT-NETWORK §8](../../architecture/XPOINT-NETWORK-V1.md#8-bootstrap-and-network-view-state-machine);
directory head renewal remains owned by
[ACCOUNT-DIRECTORY](../../architecture/ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md).
This allocates no public API, record, signature domain, codec generation, reader,
compatibility path or persisted marker. Existing genesis pins, exact DNH2/DNF2,
independent native anchors and complete signed chains remain mandatory.

## Verified gap and boundary

DTS1 has a30-day bound and directory/network heads have independent short signed
windows. Accepted mailbox objects outlive short grants. Extending a genesis
validity cannot supply current time/heads beyond those windows. Root/DTS renewal
changes XNA1 and its DTS-bound witness-policy hash even when witness keys remain.
Fail-closed same-core checks therefore prevent legitimate preserved-history
renewal, including the remaining S01 archived-path scenario.

Historical policies, view/head pairs and PMT steps must authenticate under their
own exact member of the pinned, already verified authority chain, with original
root/witness keys, thresholds, failure domains and enclosing authority intervals.
Ordered network policies/views cannot regress to an earlier authority generation.
Every original predecessor, transparency append and nondecreasing selection epoch
must still verify. The terminal policy/view/head, DTT1 and current descriptors
remain bound to terminal current authority and current authenticated time.

Cold history requires the exact protected prior authority to occur in that chain
and to equal the authority of its included original policy/view/head. The prior
LKG, exact policy and PMT bytes are checked, not replaced by an ancestor hash.
The result preserves the actual predecessor and any checkpoint marker; the host
still requires its full protected-capsule binding under the existing writer lease
and independent anchor read-back. Root renewal does not revive an expired old
traffic-key capability, erase PMT history or authorize lost-floor repair.

## Explicit non-claims

This history fact is not current mailbox issuer/holder permission, retained route
renewal, epoch exclusion, non-issuance or deletion authority. The existing
same-root exclusion stays closed until its distinct original namespace/current
native-floor proof is implemented and qualified. Merely removing that check is
not this decision. Forward-only resets do not substitute for original PMT custody.
New genesis, widened signed windows, SQL flags and caller timestamps are excluded.

## Required evidence

Genuinely signed XNA1/DTS1 renewal and changed root/witness keys; warm and cold
exact original history inclusion; rejection of signatures using the wrong
generation's keys, forged prior authority, missing/forked history, authority or
selection-epoch regression, stale terminal and expired current time. Whole owned
client/host native custody and current mailbox/exclusion transitions must pass
separately, together with matching canonical full/API/package and physical gates.
Unit network time fixtures alone are not DID2 account admission or device E2E.
No production rollout, reset, release publication or main merge is activated.
