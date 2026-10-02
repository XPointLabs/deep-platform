# DR-0072 — DID2 route renewal lineage and expiry-gap recovery

Status: accepted clean-break increment; owned/live/device activation gated
Date: 2026-10-02
Decision owner: Mr. X (delegated architecture authority)

Close the three route-artifact phases following DR71 without minting another
genesis. This increment retains the existing exact six-record closure and
separately versioned neutral record bytes/signature domains. It corrects the
genesis-only assumptions in successor graph validation. It does not alter the
reviewed pre-cutover D--G records or introduce compatibility readers.

Freeze `VerifiedDeepIdV2ContactRoutePredecessor`, with no public constructor or
currentness/dispatch/grant methods. `DeepIdV2ContactRouteVerifier.VerifyPredecessorAsync`
takes current DID2 authorization, verified network/XNA, exact prior XIR1 V2,
exact prior six-record closure, protected time and final cancellation. Bound and
own bytes before callbacks. Independently check current identity/device/DCA,
network/PMT and witness policy, exact graph, original device signatures and all
threshold receipts. Signed prior issue times cannot be in the future; validity
and scope must be internally consistent. Past expiry is permitted only for this
read-only predecessor fact. It is not current route authority, publication
evidence or permission to replay any old mutation. Recheck current authority and
protected clock continuity before returning and before authoring from it.

Freeze `AuthorThresholdSuccessorAsync` and `CompleteSuccessorAsync` on
`DeepIdV2ContactRouteAuthor`. Their inputs are the same current authority and
owned-device/threshold roles as the genesis phases plus the closed predecessor.
The threshold phase derives issue time from the current conservative interval;
no caller-issued timestamp is accepted. XRA1 must be exactly the DR71 successor.
Preserve the XRC route ID and deposit/replica capabilities, increment its
generation exactly and link its predecessor core. Preserve the XRR and reusable
XIR rendezvous IDs, increment each generation exactly and link respectively
the predecessor core and raw exact-XIR hash. Minimum reader, quota, invite
policy, PMT, placement input and publisher remain unchanged. New sealing/policy
material must equal the signed XRA1. Current network/key/time and issuer/witness
signature checks remain mandatory at each phase and final release.

For XSS1, tag 3 remains current-XRC-generation plus one. At XRC genesis,
tags 4/6 checkpoint the current XRC itself. At nonzero XRC generation, tag 4
equals current XRC tag 4 (the prior core), and tag 6 names the exact retained
prior XRC artifact, distinct from current tag 5. Authoring/completion additionally
compare both references to the independently authenticated predecessor. A six-
record current read authenticates this historical link through the witness
receipts; it does not invent absent history or bypass any protected route floor.

PMS2 has no generation field. Renewing its signed validity envelope is permitted
only inside the same exact PMT/placement/epoch/ranked selection projection,
with nondecreasing issue time and strictly advancing expiry, and bound to the
exact XRC/XSS successor. A still-current exact prior PMS2 may instead be reused
when it covers the complete new route interval; it is not re-signed. This
supersedes treating every different timed receipt
envelope for the same selection as a fork. Changed selection projection or
changed bytes at the same signed validity window remain fork evidence. Private
issuance must permanently serialize each route generation and reject a second
different winner even under another nonce; a nonce-only journal is insufficient.
No deployed issuer is activated until that durable lineage reservation exists.

A permanent reusable XIR may have an availability gap after offline expiry.
Its newly signed successor can start at the actual current trusted interval
without backdating or claiming overlapping validity. The old invite remains
expired throughout the gap; only the verified new publication restores current
reachability. This supersedes mandatory overlap for reusable permanent-address
successors, not one-time invitation targets. No legacy reader or fallback permits
using the expired route during recovery. DCB/DCR successor publication, exact
protected predecessor/pending custody, lost-response recovery and two-replica
commit adoption are still required before replacing the current publication.

PMT/view/device/delegation rollover, prekey-service expiry/replenishment and
retention/capacity exhaustion remain separate explicit increments. Unrelated
current directory-head renewal is not a route rollover. Tests must use real
signed accounts/thresholds, verify the expired predecessor still fails normal
current-route checks, round-trip the successor through the normal verifier and
reject forged/gapped/substituted lineage before signing/adoption. This API work
alone proves neither connected durable renewal nor Windows/Android delivery.

Consumer rebuild/repin and final machine/API/evidence gates are mandatory at the
business-batch boundary; there is no account reset or node-key replacement here.
