# DR-0099 — retained mailbox read selection

Status: accepted S01 host API increment; issuer/owner/node activation remains gated
Date: 2026-10-07
Decision owner: Mr. X (delegated architecture authority)

## Verified boundary and decision

Current MCG3 binds one selection epoch, PMT2 artifact hash and selector. The
current host verifier requires that exact current projection. The canonical
Retrieve page also requires every envelope's epoch to match its page. A current
placement cannot silently stand in for an older placement, and increasing the
object TTL alone would not close retrieval. No wire allocation is necessary to
authenticate a still-current Retrieve grant for a retained selection: those
scope fields already exist in MCG3. Expired grants remain invalid.

Freeze the additive host API
`VerifiedMailboxHostAuthorityV2.GetSelectedRetainedReadReplicasAsync(exactMcg3, ct)`.
It accepts only Active Retrieve grants and returns the same copied replica fact
type as the current-selection method, not holder/replay/mutation authority.
The exact membership hash and epoch must identify a PMT2 step already verified
in the complete current network's ordered protected lineage. There is no raw
PMT input, currentness boolean, caller-supplied issuer or historical UTC input.
Current-only methods keep their current-only behavior, including rejection of
past-selection Store and expired Retrieve grants.

The sole network/selection rules are added to
[XPOINT-NETWORK section9](../../architecture/XPOINT-NETWORK-V1.md#9-mailbox-placement-and-storage-swarms).
Retention deadlines remain owned by
[RETENTION-AND-RECOVERY](../../architecture/RETENTION-AND-RECOVERY-V1.md).
No magic, suite, signature input, algorithm profile, wire bytes or local storage
generation changes. This is not an old-version reader: all inputs are current
MCG3/PMT2/NETCODEC generations.

## Closed host verification

Capture the canonical grant before a callback. Verify the current host twice,
using its actual root, PMA2 and monotonic clock. Grant network, issuer signature,
role, generation floor, active lifecycle, full validity interval, maximum
lifetime and current policy/network hard upper bounds remain mandatory.
Only its placement selection may refer to a verified retained PMT2. Rank using
that exact historical artifact/epoch/rows and signed grant selector. Both nodes
must still be admitted as current Mailbox-role nodes; use current descriptors,
identity/receipt keys and transport facts, never saved old endpoints or SPKI.
Unavailable/removed replicas are a retention gap, not an empty page or rerank.

Retained projection facts are bounded by the existing complete-lineage count
and byte caps. Only verified steps are captured. Restoring actual DNH2 against
the complete signed history remints the facts; a tuple-only or terminal-only
rehydration cannot manufacture omitted history. A missing step rejects before
any dispatch or mutation. The aggregate cannot evict a pinned path silently.

Freeze the corresponding signed-revocation API
`VerifiedMailboxGrantRevocationV1.EnsureRetainedReadGrantNotRevokedAsync(exactMcg3, ct)`.
It verifies the same retained selection and still-current role issuer, and
requires the same exact current MGR1 protected floor read-back before and after
the external callback. Its output is only revocation/currentness validation.
It cannot consume counters or remove an original replay floor.

## Remaining producer/consumer closure

New short-lived grants for an older selection must come from the current
Retrieve issuer, with a fresh serial and exact new request. The issuer must
authenticate the protected retained route/capability lookup at both independent
current service replicas. A cached route tuple, saved XRR1 or expired XMC2 is
not that producer. Until its closed issuance/owner API and crash tests exist,
no consumer may claim renewal of an expired retained read grant.

Node admission must distinguish Store from Retrieve/ACK using its decoded typed
operation, not a caller flag. It must verify holder, exact body placement/epoch,
current revocation, selected local exit and durable replay as usual. Peer
tombstones must bind the original accepted object and both replicas. The client
retains each original object path and replay counter scope until all dependencies
are closed. DR-0097 remains an exclusion prerequisite for original admission,
not deletion permission for outstanding retained-read work.

The accepted-object horizon is independent of grant lifetime. Codec TTL,
sender deadline, node GC, replay/tombstone retention, renewed retained issuance
and Retrieve/ACK consumers must agree before the normative retention claim is
activated. The existing shorter codec limit is not raised by this increment.
Physical E2E, whole S01, S04 lifecycle and release acceptance remain open.

## Qualification

Cover signed changed projections with unchanged and advanced epochs, in-process
and cold actual-history restoration; omitted history; foreign/malformed grants;
Deposit/expired/overlap/low-generation grants; exact selector ranking; current
descriptor resolution; mutation of caller buffers; cancellation, rollback and
expiry during recheck; and MGR1 protected-floor changes/revoked serials. Run the
Protocol required gates and actual API/package/resource graph, recording any
unrelated shipping failure without weakening it. Consumer rebuild/repin is
required; no production reset or operator key change follows.
