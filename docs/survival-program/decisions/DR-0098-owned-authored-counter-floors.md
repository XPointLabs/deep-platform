# DR-0098 — independent account-owned authored counter floors

Status: accepted bounded S01 local contract and source slice; cleanup inactive
Date: 2026-10-06
Decision owner: Mr. X (delegated architecture authority)

## Decision and sole owners

Implement the independent authored floor required by
[TRANSPORT-NEUTRAL-MESSAGING §8.4.3](../../architecture/TRANSPORT-NEUTRAL-MESSAGING.md#843-compaction-and-boundedness)
in the existing ordinary-command root, not another outbox or counter namespace.
The exact private layout/API belongs to
[Shared custody](../../../deep-client-shared/docs/architecture/owned-authored-counter-custody.md).
This supersedes only DR-0030/0067's prior local reader and count-derived revision;
original event ownership, role baseline, typed-event namespace, SQL integrity,
Store-vs-delivery distinction and independent endpoint/consent checks remain.
No wire, protocol generation, suite, signature domain, public verification API
or network authority is allocated. Prior local text roots reject; no migration
or automatic account reset is authorized.

## Why this is required before compaction

The previous next-sequence producer and SQL mirror derived their values from
retained working entries. Removing the last entry could therefore select the
initial role baseline instead of the previously reserved position. Separate
protected counters must remain verifiable when the working set is empty; neither
SQL, row count nor a fresh session/grant can reset them. Exact pending recovery
still admits only its original before/after SQL states, not arbitrary repair.
The actual account owner performs read-back before SQL and after adoption.

This closes only the authored-floor part of the remaining S01 compaction
contract. It grants no payload deletion, namespace retirement, historic route
access or receipt completion. Dependency-closed plan/recovery, retention and
accepted-object obligations remain mandatory; whole S01 stays open.

## Required source evidence

Known initiator/responder baselines, text/offer/text, exact pending SQL recovery,
missing/regressed/advanced counters with an empty working set, canonical bounded
floor persistence, old-reader rejection and actual owner pending/SQL/stable
handover faults across newly opened account/source instances. Full current-source
Shared gate passed591/0/0 terminal0; all25 final focused +11 connected results
mapped to Passed and all14 frozen inputs rechecked after completion.
[Exact source receipt](../../../deep-client-shared/docs/testing/s01-authored-counter-floors-2026-10-06.md).
Isolated modeled cleanup is not runtime compaction,
socket/physical delivery or release qualification.
