# S03 current peer replication: requirement-to-evidence review

Date: 2026-10-11. Owner: Mr. X. Scope: the S03 node source/composition stage in
[the sole execution plan](architecture/IMPLEMENTATION-PLAN-V1.md#s03--grant-bound-peer-replication-и-quorum).
Status: **S03 source/composition stage accepted** on matching full and transport evidence.
Production activation, shipping and physical delivery are not accepted here.
Accepted Node commit: `ddcf4b645bc7bb738b4230e82184d3c005cdaf70`, pushed to
`release-candidate/prod-20260909`; remote SHA matches and the Node tree is clean.
Current status and the next stage belong to [NEXT-SPRINT](NEXT-SPRINT.md).

This is an evidence mapping, not a second specification. Semantic owners remain
DR-0081/0086/0087 and the [protocol registry](architecture/PROTOCOL-REGISTRY-V1.md).
Exact local facts and crash transitions belong solely to
[XNode operation custody](../xnode/docs/mailbox-operation-custody.md).

## Requirement mapping

The common receipt reader finds all **35 named groups / 83 required cases** in
the accepted matching full, not merely in a union of earlier focused receipts.
The groups below partition those83 cases without counting a row twice.

| S03 requirement | Actual implementation and executable proof | Cases |
| --- | --- | ---: |
| Actual registered/configured owners, selected ingress and fresh recovery | Receiver/coordinator share the admitted native owners. `ActualRegisteredOwnersCompleteNativeStoreRetrieveAckAndColdExactRetryOverPinnedHttp`, `ConfiguredProgramSourcesEnrollRecoverAndCompleteStoreRetrieveAckOverPinnedHttp`, single authenticated snapshot, post-join time/refusal and actual loaded Release dependency checks cover the configured/native cycle. | 7 |
| Authenticate exact proof/body/source before reservation; recheck after callbacks | `HostilePeerProofOrBodyRejectsBeforeNativeReservation`, `HostileOrExpiredHttpCallbackCannotProduceQuorum` and borrowed-admission-owner refusal preserve the current proof, role, placement, signature and source boundaries. | 11 |
| Independent durable stores, distinct identity/receipt keys, retained object/route horizon | Two-store pinned HTTP cycle, `DistinctDescriptorKeysCompleteStorePaginationAckAndExactRecovery`, object lifetime beyond short authority and original-epoch read/ACK after genuine signed projection advance/cold retry. Original expired Store is not readmitted. | 6 |
| Partial commit, lost reply, deadline, concurrent exact Store and expiry inside mutation | Peer/client concurrency each produce one original effect. Lost response and actual deadline preserve native Pending; cold exact retry reconciles both stores. Expiry during persistence cannot mint a receipt. | 6 |
| ACK on either replica, exact replay, page continuity and no resurrection | Either-coordinator ACK, lost response, crash after blob deletion, concurrent exact ACK, cross-replica page token and refusal to rebind a tombstoned target. | 7 |
| Independent peer history survives native loss/rollback and all local replacement crashes | Twelve Store and twelve tombstone crash cases cover either replica; four cold-loss/pre-ACK rollback cases, two known-Pending cases, three strict protected-metadata cases, bounded capacity and refusal of neutral collection/reader mutation. | 35 |
| Sole authenticated Store writer and signed settled prefix | Nonwriter client/peer rejection, four different-grant Pending barriers, three hostile saved-settlement refusals, past expired-grant settlement without new authority and two quorum-save crash recoveries. | 11 |

`CurrentMailboxReplicaReceiver` validates both exact grant-bound proofs and the
source before replay reservation. Both selected replicas and descriptor keys
come from the closed verifier, not an unsigned replica list or node-ID/key alias.
`ApplyAndSignLocalAsync` protects mutation completion before signing. Recipient
and coordinator completion protect the exact replica response digest, including
cached completion, before response release; the client operation owner retains
the complete quorum. Quorum construction verifies both distinct receipts and
current authority before/after its work. One local persistence success is not a
two-replica receipt.

Protected peer facts extend the existing independently protected schema8
operation document, not a second full journal or new wire. A fresh authenticated
operation snapshot joins both client and peer history. The native mutation
owner joins floor/index/blob custody from one fresh inventory under its lock;
the returned authority time is checked after callbacks. Combined native loss
and authentic pre-ACK rollback cannot become an empty first run. Known exact
Pending can resume, but cannot reconstruct a missing reservation. Capacity
exhaustion refuses new work rather than evicting history.

## Qualification and limits

Commands, receipt hashes, exact group names and original failures remain in the
[Node checkpoint](../xnode/docs/testing/s03-peer-cycle-2026-10-10.md).
Final canonical `node-peer-custody-full-04` started
`2026-10-10T19:23:53.5708781Z` and ended
`2026-10-10T20:13:05.1566119Z`, WindowsPowerShell5.1.26100.9457 / SDK10.0.301.
Build0/zero warnings and errors; preflight/test/qualification0;
**1479 pass / 0 fail / 0 skip**, exact1479 cases, **2142 unchanged inputs**,
`FullAccepted=true`. No failed/skipped outcome exceptions were allowed.

Fresh matching external/no-mock smoke02 and three-node rehearsal finish native0.
Smoke has a running real transport, zero runtime failures/warnings and a successful
original parallel Linux-arm64 source publish. Rehearsal has three distinct running
real Xray nodes, Registry count3 and zero reconciliation issues. Expected privacy
503 without verified authority remains fail-closed, not messaging evidence.
Both disposable projects were removed; all six existing deep-dev containers were
preserved. Unrelated Dockerfile ARG-default lint warnings remain explicitly separate
from the zero-warning C# build and runtime gate.
Changed-source secret review before staging covers40 regular files (36 Node,
4 root), zero findings; root/Node diff checks pass. No generated artifacts,
private inputs or deployment credentials are committed.

Original full01/full02 and smoke01 failures remain recorded. Neutral discovery
anchors and loaded dependency assertions were preserved. The final build fix
scopes foreign-reference metadata to solution mode while retaining the explicit
source-cutover consumer settings; ordinary project publish is not serialized or
retried to hide the collision. Removed network-memo experiments are not evidence.

Configured/native integration uses test-owned signed authority, a fixture
monotonic clock and loopback TLS/pinned HTTP; its configured fixture disables
Xray. Separate real-Xray transport gates do not turn it into installed clients.
No sustained retirement/compaction, issuer rollout, client lifecycle, shipping
package or independent root-plus-data anti-rollback guarantee is claimed.
Concurrent exact ACK is covered on one coordinator; this review does not invent
a stronger simultaneous dual-coordinator concurrency guarantee.

Physical contacts/messages/files/groups: **0/4 confirmed**. S04 lifecycle,
S05 issuer/provisioning, S06 connected clients, S08 shipping/physical text and
later files/groups/full release requirements remain open. No production deploy,
GitHub Release or main merge occurred in this S03 package.
