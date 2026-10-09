# DR-0105 — idle mailbox counter retirement without path deletion

Status: accepted S01 private owner profile; runtime activation remains closed
Date: 2026-10-09
Decision owner: Mr. X (delegated architecture authority)

## Decision and sole owners

Implement the independently excluded counter disposition already required by
[DR-0084](DR-0084-owned-delivery-settlement-and-retirement.md),
[DR-0092](DR-0092-did2-owned-mailbox-counter-floors.md) and
[TRANSPORT-NEUTRAL-MESSAGING §8.4.3](../../architecture/TRANSPORT-NEUTRAL-MESSAGING.md#843-compaction-and-boundedness).
The private API, exact dependency index and stored recovery profile belong to
[Shared counter custody](../../../deep-client-shared/docs/architecture/owned-mailbox-counter-retirement.md).
DR-0097 remains a prerequisite, never sufficient deletion permission by itself.

Do not conflate floor removal with grant/holder/object-path retirement. This
profile retains those exact dependencies; unknown send work and active
Retrieve/ACK using the counter remain pinned. Complete current signed policy,
original conservative ceiling, actual protected native exclusion and complete
dependency readbacks must agree under the actual account lease before staging.
The sole private owner defines the additional unchanged application/native SQL
guard for counter retirement and rejects prior unqualified counter plans that
lack it, without a compatibility reader.
The protected plan changes only one idle counter root. No SQL row, semantic
receipt, history, traversal, acquisition or original capability is deleted.

## Scope and qualification

The existing local plan supports this profile; no magic, wire, suite, generation,
public authority API or legacy reader is allocated. Frozen Protocol semantics
and dispatch checks are unchanged. This is not a runtime compactor, renewal
scheduler, proof of non-delivery, whole S01 acceptance or release activation.

Require source evidence for actual known grant custody; real owned Retrieve
completion and semantic receive/ACK; preservation of the last retained route and
other roots; pinning of active exact work; every stored-plan handover; cold owner
recovery, abort/cancel, missing parts/roots and native fence disagreement.
The isolated unused Store-floor fixture does not prove settled real Store work.
Full current Shared qualification is mandatory after the complete source batch.
Known send-work/acquisition/traversal retirement is a separate dependency-closure
obligation, not waived by freeing an idle floor. The current ordinary outbox
increment has its own [closed profile](../../../deep-client-shared/docs/architecture/owned-authored-counter-custody.md#owned-ordinary-outbox-only-api)
and preserves original SQL/evidence while removing only selected completed send
entries. Its used-Store floor test is additional source evidence, not authority
to delete initial-contact/acceptance work, grants or traversal paths; current
qualification remains tracked in NEXT-SPRINT and the Shared checkpoint.
