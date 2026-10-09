# DR-0106 — independent public Store-outcome custody

Status: accepted S01 producer/consumer contract; activation and qualification open
Date: 2026-10-09
Decision owner: Mr. X (delegated architecture authority)

## Decision

Implement the retained outcome dependency required by
[TRANSPORT-NEUTRAL-MESSAGING §8.4.3](../../architecture/TRANSPORT-NEUTRAL-MESSAGING.md#843-compaction-and-boundedness).
Deleting completed working commitments or old acquisition/holder custody must
not orphan the independently verifiable original Store result. SQL `Durable`,
a cached boolean, a current issuer or current descriptor is not that evidence.

Reuse actual native committed event/semantic history, exact original MAU3/MQR3,
the recorded coordinator statement and the original peer route authenticated
by native Hello/Accept custody. Preserve original public PMA2 and signed XNV1
plus the two exact XND1 receipt-key descriptors in account-owned SQLCipher.
Do not copy holder secrets or duplicate an already authenticated Hello/Accept
peer route into another journal.
The original policy authenticates the original signed grant/acceptance interval,
not a new dispatch. Independently current own authority/time and the actual
protected native network lineage must still agree under the held account lease.

The same original-outcome closure applies to a locally authored ContactAccept.
It binds the exact protected explicit-command winner, actual authenticated
initial Hello, committed native send, retained semantic acceptance and original
Hello return route. It cannot require renewed peer admission merely to report
its already verified Store result. The local acceptance winner and mandatory
send/authoring registrations remain present and unchanged; this contract does
not authorize their deletion or claim that the peer materialized the acceptance.

Unlike ordinary working commands, ContactAccept has no protected Stored bit.
Retain its immutable public records before ingress can become durable. Evidence
without an actual durable transport outcome is still pending and resumes only
the exact original request. SQL Durable is only a selection condition: the
reader independently authenticates all original native/semantic/MAU/quorum/
coordinator joins. A durable candidate missing its original public records
rejects without a new issuer callback or reconstruction. Cancellation before
ingress may leave public records, never a synthetic success. After ingress,
the producer repeats exact public-record and explicit/native/semantic checks
before returning; changed/missing custody preserves the actual durable Store
but returns outcome-unknown without repairing local evidence.

Initial DPH2 has no recipient route in its retained Hello: that is the sender's
return route. For this operation alone, extend the same immutable public SQL
record with the exact original DCR1 V2, recipient route and positive peer ADP1 V2.
The three fields are jointly absent for ordinary/ContactAccept and jointly
present for initial Store, with existing codec bounds enforced before allocation.
They bind the actual protected draft's exact DCR hash, native initial events,
key-retired sender source, registered scope and protected peer DID2 credential.
Original ADH witnesses, ADC/DAB/PQ identity, map/append inclusion, revocations,
DCA, DCR support/device signatures and route joins are independently verified
at the authenticated original Store creation/acceptance times. This produces
historical facts only, never nonce-bound current freshness or a dispatch grant.
Both initial dispatch and the public StartContact retry use this closure;
missing/changed durable evidence rejects before peer resolve or new issuance.
Before-ingress evidence remains pending; after-ingress loss returns unknown
without reconstruction. The SQL schema10 source is still an unqualified,
pre-production clean break: its final shape requires reset of earlier local
schema10 candidates, not a migration, dual reader or another journal generation.

## Closed Protocol boundary

`MailboxStoreReplicaEvidence` owns bounded untrusted exact XNV1/first-XND1/
second-XND1 bytes; its constructor establishes only shape. No serialized trust
flag or network encoding is allocated. `MailboxStoreReplicaEvidenceVerifier`
has two entries:

- `CaptureAsync(VerifiedDeepIdV2ContactRouteClosure, CancellationToken)` copies
  the current verified view and original selected descriptors, rechecking the
  actual route before/after capture; it grants no deletion permission.
- `Verify(VerifiedOnionNetworkContext, VerifiedXPointNetworkAuthority,
  ParsedContactRouteClosure, MailboxStoreReplicaEvidence)` authenticates the
  original PMT2 in the independently verified retained lineage, exact deterministic
  PMS2 pair and signed original XNV1/XND1 descriptor bindings. It returns only
  immutable original receipt-key facts and the original view interval, never
  a current host, route, grant, holder, replay reservation or dispatch capability.

The authority lineage must match exactly. Missing retained original projection,
different XNA1, changed policy/descriptor/view, invalid signature, pair reorder,
duplicate node, absent/revoked original node or clock/context expiry rejects.
Issuer and descriptor rotation within that authenticated lineage cannot replace
the original keys; they do not erase a previously signed Store commitment.

## Shared closure and gates

Shared owns the exact private SQL representation, immutable write/read-back,
native/event/history/MAU/grant/coordinator joins and dependency-closed retirement
plan. A producer stores public evidence before deleting its last acquisition
source. Recovery compares actual SQL and all protected roots; missing public
evidence cannot be reconstructed by a reader from the newest policy/roster.
Unknown work and last Retrieve/ACK/receipt/object dependencies stay pinned.

An application schema change is a pre-production clean break: no migration,
dual reader or fallback. No new public magic, wire suite, crypto primitive,
provider, journal generation or runtime scheduler is introduced. Frozen record
bytes/signature domains remain unchanged. Current Store admission remains
current-only; historical verification returns no renewed admission authority.

Require real Store followed by encrypted cold reopen, working/floor/acquisition
retirement and unchanged outcome; original issuer/receipt-key rollover;
missing/changed public policy/view/descriptors, wrong pair/network/native event,
changed exact MAU/quorum/coordinator, missing semantic history, cancelled/expired
own context and every stored-plan handover. Matching full/connected/package and
physical gates remain open; no release, deployment or account reset is implied.
