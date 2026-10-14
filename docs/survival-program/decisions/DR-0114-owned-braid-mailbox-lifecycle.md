# DR-0114 — owned Braid mailbox lifecycle

Status: **accepted connected implementation target; transport activation gated**
Date: 2026-10-11
Decision owner: **Mr. X** (delegated architecture authority)

## Authorization and sole owner

Freeze the control-specific transport and obsolete-purpose semantics in
[TRANSPORT-NEUTRAL-MESSAGING §8.4.5](../../architecture/TRANSPORT-NEUTRAL-MESSAGING.md#845-owned-braid-mailbox-lifecycle).
That section owns these transitions; DBR2 grammar/KDF and native custody remain
DR-0111/0112, and the closed persistence boundary/local mapping remain DR-0113.
No new wire, primitive, secret, journal, SQL table, local generation or public
caller-supplied evidence/ACK switch is allocated.

The separately frozen read-only Protocol allocation is
`ExactBraidRecoveryDurableTransactionProducer.TryVerifyObsoleteControl`
and sealed `VerifiedBraidRecoveryObsoleteControl` with internal constructor.
The method accepts exact prior TRS1, the existing stable transition context,
network16 and canonical DBR2; rejects non-Fresh contexts and wrong predecessor/
checkpoint/scope; requires actual installed output at least that Braid epoch and
the retained original control root, whole-frame MAC authentication and unchanged
slot/operation namespace. An already consumed native receive requires its exact
durable replay, not this capability. If epoch/root eligibility is absent return
null; invalid scope/MAC/custody rejects. No mutation, Braid Receive, entropy,
success receipt or public raw-key operation is authorized. The public immutable
capability binds only prior generation/commitment, Braid epoch and full-frame
SHA256; it grants no dispatch/tombstone/AppAck by itself. ACK rederives it from
the actual current SQL state under lease, never from a supplied capability.

## Local implementation boundary

Only actual SQL/protected-floor owners select outgoing kind5/direction3 controls,
classify incoming frames and rederive ACK eligibility under the account lease.
An internal SQL event-direction selector verifies the entire tip and exact event
before returning its class. Existing ordinary semantic readers remain data-only.
An internal peer-progress selector enumerates actual authenticated direction2
history, including its protected compacted prefix, and verifies the final tip.
An unverified DPE2 header, numeric epoch or SQL flag cannot mint progress.

The incoming catalog may select a session from canonical DBR2 hints only after
checking the owned network/device/account instance. This is lookup, not receive
or disposal authority. The existing fresh endpoint/native closed transaction
owns current control authentication and exact committed replay. A distinct
obsolete-purpose classification may suppress native receive only with the
protected same-peer progress proof above or that closed read-only installed-output/
original-MAC capability; it is never a kind5 authenticated row,
native successor, plaintext, semantic materialization or AppAck.

Before tombstone signing the ACK owner rederives either exact authenticated
direction4 custody or obsolete-purpose exclusion from the current actual stable
floor and captured exact page item. Orchestration supplies no trusted outcome.
Original Store/unknown requests, grants, counters and quorums retain the existing
DR-0084 owner and cannot be removed by this classifier.

For completed control Store chains, the existing protected-only Audit plan may
remove only redundant protected send commitments after independent original
native/request/acquisition/quorum/coordinator joins for every attempt. Its
existing guard roots and recovery preserve SQL/native history, exact frames,
original transport requests/evidence, grant/object/read/ACK dependencies and
replay floors. No new disposition, plan generation or journal is allocated.
The control business facade performs that maintenance on verified Stored retry;
unknown or merely obsolete-purpose work cannot qualify.

## Acceptance

Implement Store/retained retry, receive, control-before-tombstone ACK, original
unknown settlement and native dependency release as one connected source packet.
Actual exhausted-peer exchange must traverse owned mailbox transport, with cold
exact retries, lost Store replies, cancelled/crashed receive/ACK, protected-history
and object substitutions, retired-key replay/first obsolete controls, and fresh
bidirectional data. Verify no false authenticated receive, AppAck, semantic event,
non-delivery claim, reminted frame/MAU, extra root or namespace bypass. Required
full/API/package/downstream and physical gates still precede activation/release.
