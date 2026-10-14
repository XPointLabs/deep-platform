# S04 client lifecycle: requirement-to-evidence review

Updated: 2026-10-14. Owner: Mr. X.
Status: **S04 source accepted; repo commits pushed and remote SHA verified**.
The sole execution order remains
[IMPLEMENTATION-PLAN](architecture/IMPLEMENTATION-PLAN-V1.md#s04--завершить-client-grantsendroute-lifecycle).
This document maps acceptance evidence; it allocates no protocol or deletion authority.

## Reviewed local package

The requirement mapping below, canonical receipts, current owned-export callers,
producer registry/anchor closure, MAUI creation/retry consumer and final staged
diffs were reviewed. Protocol's source matrix preserves its original S08 package
failure and named provider skips; neither this review nor commit activates that
shipping graph. No unresolved S04 source defect was found in this review.
Independent live asset retirement and deployed/physical obligations remain open
in their named later stages, not silently qualified here.

Local release-candidate commits (all by zhigubigule, GitHub no-reply email):

- Protocol: `f6cd57f` — route/Braid producer contracts and frozen registrations.
- Shared: `599edf2` — durable send/grant/route lifecycle and its actual tests.
- MAUI: `02a1ea1` — owned new text command versus exact retry.
- DevOps: `ee55b90` — awaited source-expression classification; matching25 tests passed.

All four repository working trees are clean. Their release-candidate branches
were pushed and actual remote SHA matched each local HEAD. Root pointers and
the stage checkpoint were separately committed and pushed as `659bb9d`;
its remote SHA was also verified. S04 source acceptance is complete; S05 is next.
No Release/main mutation or physical result is implied.

## Current requirement mapping

| Requirement | Current source and executable proof to qualify |
| --- | --- |
| New command versus exact retry; no resurrection after retirement | Shared `ProtectedDeepIdV2AccountOwner.TextOutbox`, owned Queue/Retry facade and MAUI consumer. The single semantic owner is [creation/compaction](architecture/TRANSPORT-NEUTRAL-MESSAGING.md#843-compaction-and-boundedness). Missing retry must not author; current and compacted changed-command retry must reject. |
| Original unknown Store, safe renewal and immutable deadlines | Shared mailbox dispatch, original Store settlement and attempt-successor owners; `StoreSettlement`, `SendAttemptSuccessor`, `HistoricalPeerRoutes` and Initial/Accept expiry cases. Every original attempt, signed quorum, MAU, acquisition, native event and SQL commitment remains independently joined. |
| Grant/path retirement only after dependency and irreversible exclusion closure | Actual namespace maintenance, used/unused Deposit, superseded Retrieve and archived-path owners. Tests require signed epoch successors, retained issuance/route joins, completed replacement reads and cold plan recovery. Ordinary/attachment/unknown/read/ACK dependencies must remain pinned. |
| Bounded working state, independent floors and terminal retention | Actual prefix/outbox compaction, stopped work, successful/control audit and pre-session key/payload owners; fault/cancellation/rollback cases and mixed terminal outbox. Minimal audit metadata cannot become payload/key custody or prove non-delivery. |
| Authenticated peer route changes and exhausted PQ recovery | Actual route processing/history owners and Braid SQL/protected-floor/control mailbox owners. [DR-0110](survival-program/decisions/DR-0110-did2-private-route-update-custody.md) and [DR-0111–0114](survival-program/decisions/DR-0114-owned-braid-mailbox-lifecycle.md) remain the accepted contracts. Required cases include native-prefix recovery, fork/gap refusal, actual exhausted peers, unknown Store, control-before-ACK and fresh bidirectional data. |
| Genuine capacity crossing and backpressure without reset | `Did2SustainedRetrieve_Crosses128DistinctGrantsWithoutResetAndColdResumesRead`, genuine128-grant backpressure and `Did2SustainedSend_PublicSendCrosses512WithoutResetAndPreservesColdExactReplay`. The changed513-send scenario now also carries pending/unknown/cold exact retry at its final operation. Its33-send companion is diagnostic only, never proof of crossing512. |

An attachment offer's redundant ordinary working payload/key copies and its
independent live DAM1/history/object obligations are not interchangeable.
`Did2StoppedWork_RetiredAttachmentOfferPreservesIndependentHistoryAndNextAuthor`
checks this separation. Independent attachment-key retirement is not proved by
that test and remains open; no S04 acceptance may silently claim it. Remote
upload/download, object expiry/resume and the installed media workflow remain
the separate S10 release requirement. The normative dependency owner above is
unchanged, and retained keys/objects cannot be evicted merely to make capacity.

## Evidence and remaining acceptance

Current canonical Shared full-05 completed **1424/0/0** across1424 exact case
keys, with build/preflight/native/qualification0 and1984 unchanged inputs.
Canonical interval2026-10-13T18:55:58.8686776Z–2026-10-14T01:03:49.1853523Z;
TRX SHA256:CBBD74409145EF0A4A3D69AB1C4D79FE571931DC034A871C2806FE229E6089F4.
The common receipt reader independently checked the exact mappings and actual
513-send,129-grant,128-grant backpressure, both exhausted-peer recovery methods
and both mixed-route cases: all passed. The canonical final input comparison
completed before qualification0/FullAccepted=true; this is not the earlier
interim comparison. MAUI95/smoke119 and platform compiler evidence below remain
current because no runtime source changes followed those builds. Final source/API/
frozen/provider/diff review and separate repo commits/push completed the S04
source stage. This proves no deployed, installed, physical or release outcome.

One post-full source edit removes an extra empty EOF line in the newly tracked
Did2MessagingPageCacheTests.cs, discovered by the staged diff check. No C#
statement changed. The full-05 receipt retains its original input snapshot;
separate post-format Release build0/zero warnings/errors and actual page-cache
case1/0/0 are recorded in the Shared checkpoint, not substituted for that full.

The following dated observations preserve the failed runs and correction
sequence; their earlier pending statements are historical, not the current queue.

Shared full-03 is now terminal FAIL:1412/2/0 across1414 mapped cases,
build/preflight0, native/qualification1. The common receipt reader validated
the exact result/definition/execution mappings; a separate post-terminal check
before source edits confirmed1981 unchanged inputs. The failed canonical runner
rejected outcomes before its final input comparison; no full acceptance follows.
Both failures are AccountDirectoryProofAuthoringException/CurrentViewTimeMismatch
at HistoricalPeerRoutes line278, when retirement asks the fixture issuer for a
fresh proof whose interval no longer fits its original XNV1. The strict Protocol
guard correctly rejects; the earlier120-second grant hypothesis was not the
observed failure. Exact hash/time/source remediation are in the Shared checkpoint.

The connected correction moves the already-required genuine signed epoch/view
successor after both original Store attempts/replies, before the long cold
settlement segment. The existing exclusion/retirement assertions remain intact.
The managed-memory package below is now applied to current DID2 outbox/inbox/
projection consumers, with explicit temporary-record disposal and caller-owned
exports transferred/erased without modifying borrowed records or durable keys.
Its Release build0/zero warnings/errors is complete; the declared141-case
matching scope qualified141/0/0, native/wrapper0 and1981 unchanged inputs at
2026-10-13T17:23:22.4063436Z–17:27:52.2577651Z. New current full and downstream
review are still required; this does not qualify the later installed runtime.

The current MAUI Clean consumer built0/zero warnings/errors and qualified95/0/0,
native0/exact matrix with2516 unchanged inputs at
2026-10-13T17:34:34.5334324Z–17:34:39.5414897Z; TRX SHA256
82021FB86021EAEDA7F2FC43028E920ED5B125AF457E2DE24D8AF5BD1AC82314.
Windows ARM64 Debug compiled0/zero warnings/errors at
2026-10-13T17:40:03.0177825Z–17:40:39.3895255Z; Android Debug likewise at
2026-10-13T17:42:51.2457356Z–17:48:04.7967276Z. No install, signing, launch,
physical receipt or release artifact follows from these compiler checks.

### Managed attachment scratch ownership: implemented and scoped-qualified

The connected package explicitly disposes independently decoded attachment
manifests and consumes caller-owned defensive exports in protected text
authoring/retry, compaction/projection, SQL and in-memory semantic inboxes.
The full-array export transfers to the caller's existing finally; sliced
exports copy their exact range and erase only the owned source range.
Canonical comparisons erase their temporary export without touching borrowed
records or independent durable DAM1/history/object keys.

The matching141-case receipt above includes actual manifest ownership tests,
attachment authoring/custody/materialization, outbox/inbox paths, both previously
failed mixed-route variants and all six fixture prerequisites. The earlier
in-memory helper diagnostic is superseded by this real producer build/test
evidence, not counted separately toward acceptance.

Historical live observations and the corrected full-03 failure diagnosis are
retained in the
[Shared checkpoint](../deep-client-shared/docs/testing/s04-successful-audit-2026-10-12.md).
Full-04 was launched with1420 predeclared exact case keys from full-03 plus
the141-case matching receipt. It was deliberately interrupted after read-only
review confirmed missing owned-export erasure in cancelled draft/stop paths
and missing parsed attachment disposal in retry-deadline reads. The exact owned
testhost was stopped before edits; terminal native/qualification1 and
FullAccepted=false at2026-10-13T18:06:58.7828345Z. The incomplete matrix cannot
be a reference full or acceptance evidence.

The follow-up package erases these caller-owned exports, disposes the decoded
deadline manifest and removes the remaining redundant DirectTextOutboxEntry
export copies in current route/text consumers. Deadline values, authority
validation, original requests and independent history/asset keys are unchanged.
Actual codec tests check disposal and unchanged borrowed manifest ownership;
the declared connected-02 scope additionally covers cancelled drafts, stopped
work and route processing. Connected-02 qualified201/0/0, native/wrapper0,
1982 unchanged inputs at2026-10-13T18:11:02.6555814Z–18:40:54.2095031Z;
TRX SHA256:966F8D45A05A4D33F2C1C3374FA44BEADFC41FA162ED593EB7EB5239ACF7829D.
Current downstream requalification and new canonical full remain required.

The follow-up MAUI Clean consumer qualified95/0/0 at
2026-10-13T18:43:01.0273720Z–18:43:05.9533743Z, native0/exact matrix and2517
unchanged inputs; TRX SHA256
450EAC624ABB6CC24FD9ADA09940A1EABF7061234BBA3B487C6358B55EDADED3.
The required MAUI smoke set separately qualified119/0/0 at
2026-10-13T18:44:41.6458827Z–18:46:42.0123988Z, native0/exact matrix and2517
unchanged inputs; TRX SHA256
089B426FF04C02C9248704818DEA6A7FFF48380C8386337E1657456E4B972253.
Both Release builds completed with zero warnings/errors. These are current
source consumers, not installed/physical composition or delivery evidence.
Current Windows ARM64 Debug completed0/zero warnings/errors at
2026-10-13T18:47:39.1718080Z–18:48:11.6226815Z; Android Debug likewise at
2026-10-13T18:49:08.2237906Z–18:54:57.0828833Z. Both compile-only; no installation,
signing, launch or physical result. The full-05 reference union was independently
read and checked as1424 exact case keys, with zero allowed failures/skips.
Canonical full-05 and final review/commit remain required for S04 acceptance.

- Canonical Shared full-02 is FAIL:1397/16/0, not current full acceptance.
  Its genuine513-send,129-grant and exhausted-peer cases passed at those inputs;
  they do not qualify later edits. Original receipt/causes are retained in the
  [Shared checkpoint](../deep-client-shared/docs/testing/s04-successful-audit-2026-10-12.md#current-full-02-failure-and-connected-remediation-2026-10-13).
- Matching remediation connected-02 qualified77/0/0, native/wrapper0 and1971
  unchanged inputs, with a zero-warning/error build. That scope closes the
  declared full-02 corrections, not the entire stage.
- The connected outcome diagnostic qualified12/0/0 with native/wrapper0,
  a clean build and1971 unchanged inputs. Exact scope/hash/time are in the
  [sustained checkpoint](../deep-client-shared/docs/testing/s04-sustained-send-2026-10-12.md#connected-outcome-boundary-candidate-2026-10-13).
  It still requires actual current discovery, one mandatory canonical unfiltered full,
  exact method/case/execution mapping and unchanged inputs. No allowed FAIL/skip
  exceptions may turn Shared acceptance green.
- Protocol source/anchor consistency, current API/frozen/provider checks,
  downstream consumer requalification, diff review and separate repository
  commits/push are still required. The known actual shipping-package failure
  remains S08 under [DR-0095](survival-program/decisions/DR-0095-baseline-and-shipping-gate-separation.md),
  not a waived release gate or permission for a retired runtime path.

The producer consistency check exposed and corrected the missing global DBR2
registration and two handwritten magic authors. Strict generation now passes
with the previously accepted frozen owner and inactive lifecycle. Repository
registries also participate in immutable input capture, backed by37 common
runner contract checks. Matching producer tests and downstream qualification
are still required; details belong to the
[Protocol checkpoint](../deep-protocol/docs/testing/s04-braid-recovery-2026-10-11.md#registry-producer-closure-2026-10-13).
The matching canonical Protocol source full now has2286/1/7,2294 exact case keys,
build/preflight0, native1/qualification0 and1579 unchanged inputs. Only the
original S08 package failure and seven original named skips remain;
MatrixQualified=true, FullAccepted=false. It is not shipping or platform acceptance.

S05 provisioning, S06 real transport, S07 scheduler/receipts, S08 installed
composition, S09 recovery and S10–S13 remaining product/release scope are not
accepted here. No production/device result, GitHub Release or main promotion
follows from this source review.
