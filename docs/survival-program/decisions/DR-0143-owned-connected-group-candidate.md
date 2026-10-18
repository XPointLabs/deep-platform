# DR-0143 — Protected connected group candidate

Status: accepted allocation; connected/full/release qualification separate
Date: 2026-10-18
Decision owner: Mr. X (delegated architecture authority)

Compose DR-0142 with the current account-owned ordinary outbox, authenticated
DPE2 receive and replicated mailbox. Allocate closed typed group DMC2 authoring
for this owner, not the generic raw author: GCF1, GIV1, GIA1 and text DGM1 only.
Keep generic RuntimeActivation=false. The existing GSR1 long-offline control
service and complete S11 remain release blockers; ordinary replicated mailbox
control delivery is a connected candidate, not a claim of GSR1 retention/quorum.
No direct service URL, fake receipt, plaintext group key or new crypto is added.

The first composed candidate supports an owner and one invited account, each
with one current device/retained accepted pairwise session. Exceeding this
implementation limit rejects before mutation. The normative V1 target remains
100 accounts/500 devices; this candidate does not satisfy that release gate.
All actual targets/events are captured in one durable logical batch before any
network dispatch, then drained using their original operations and common
ordinary sender sequence namespace. Unknown Store never becomes noncommit.

Register `deep.store.v2.groups` atomically during account generation creation.
Its closed local generation1 binds network/account/database instance, revision,
exact packages/invitations/original lookup evidence, bounded received chunks,
messages/native selectors, and outgoing batches. Root size is bounded to32MiB,
groups to32 and retained outgoing events to512. Missing/corrupt registration is
not an empty group store. Native receive must be authenticated before state
adoption; ACK repeats durable group materialization from actual native custody.
No SQL projection, caller-supplied record or "processed" flag grants ACK.

Application SQL schema17 changes only the ordinary payload bound; old schemas
reject rather than migrate. Common ordinary journal generation9 admits the four owned group kinds and a
33082-byte event bound. Prior generations reject; no migration/dual reader.
Group batches reserve/capture exact outer events before ordinary adoption;
every new ordinary preparation first reconciles those reservations under the
same account lease. A crash between protected intent, ordinary SQL adoption and
stable readback resumes exact work without reallocating IDs/sequences.

This requires new isolated CLI candidate profiles. Preserve existing text/file
profiles and evidence; do not reset device/prod accounts. No MAUI/device build,
deployment or release activation is authorized by this allocation. Complete
membership/device/history/long-offline behavior remains S11, not waived.
