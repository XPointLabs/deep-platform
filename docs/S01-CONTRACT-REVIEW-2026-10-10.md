# S01: contract/API review — 2026-10-10

Review owner: Mr. X, delegated architecture authority. This is an evidence
record, not another specification or execution plan. The scope is S01 in
[the implementation plan](architecture/IMPLEMENTATION-PLAN-V1.md#s01--закрыть-недостающие-контракты-без-нового-wire-по-умолчанию),
with the implementation boundary of
[DR-0084](survival-program/decisions/DR-0084-owned-delivery-settlement-and-retirement.md#implementation-boundary).

## Requirement-to-evidence review

| S01 requirement | Sole contract / closed producer | Inspected evidence and limits |
| --- | --- | --- |
| Current node authority | XPOINT-NETWORK §9; CONTACT-RESOLVER §3.8; DR-0083/0085. `VerifiedMailboxHostAuthorityV2`, descriptor-minted replica facts, signed MGR1 and independently restored role floor | Current Protocol full02 contains 89 host-verifier and 77 MGR1 cases, all Passed. Node full02 contains 25 `CurrentMailboxAdmissionTests`, all Passed: wrong holder/body/selected exit and missing floors reject before replay; expiry/cancellation/source loss after callback suppress success and retain Pending on reopen. Neither raw PMA bytes nor a signed empty snapshot replace protected enrollment. |
| Peer mutation and Store ordering | XPOINT-NETWORK §9/9.1; DR-0081/0086/0087. Exact grant-bound peer proof, `VerifyStoreSettlementAsync`, existing anchored operation ledger | Inspected distinct-ID/key positive Store/pagination/ACK/cold-replay fixture and admission callbacks. Node full02 contains both distinct-key rows, both ACK-intent write-failure rows and all eight operation-checkpoint crash rows, all Passed. Original exact intent survives partial commit; saved quorum is historical settlement, not current mutation authority. This is local TLS/H2 fixture evidence, not a deployed Program or device claim. |
| Client grant/send/route contract | TRANSPORT-NEUTRAL-MESSAGING §8.4.1/8.4.2; DR-0084. Actual account lease, separate grant acquisition/pointer custody, protected send commitment plus exact SQL outbox | Current Shared full03 contains 17 `Did2GrantCustody_` cases and 25 send-journal cases, all Passed. Inspected `Did2OwnedMailboxSend_CommittedTextFaultsExactReopenLostReplyAndDurableReceipt`: real PQ accounts, committed ratchet ciphertext, before/after SQL and protected-CAS faults, reopen and lost reply. `ClientMailboxAdapter` durably begins an attempt before ingress and recovers exact accepted/durable evidence. The protected send journal is a commitment/floor owner, not the entire attempt outcome state machine. Its Pending/Prepared phases must not be mistaken for grant ClosedUnresolved. |
| Retirement, capacity and crash closure | TRANSPORT-NEUTRAL-MESSAGING §8.4.3/8.4.4; Shared local producers: authored-counter, grant, idle-counter and application-receipt custody docs | Current Shared full03 contains all 24 `Did2ArchivedReadPath_` cases, all Passed, including complete SQL readback, cold root-adoption handovers, cancellation, hostile SQL/floors and last-path loss. Reviewed the actual held selection/recovery code: only exact original dependencies and authenticated exclusion authorize the selected disposition; current permanent path and unsettled work stay pinned. Prior qualified prefix/outbox/Deposit/Retrieve/counter profiles remain included in the 895-case full. Staged occupancy is not sustained 128/512 delivery evidence. |
| Application receipt separation and durable obligation | CONTACT-AND-GROUP §12 and TRANSPORT-NEUTRAL-MESSAGING §8.4.1/8.4.3. Owned DID2 materialization, DMB1 schema9 and bounded obligation reader | Current Shared full03 contains 19 application-receipt persistence cases, all Passed. Inspected atomic event/dedup/obligation insertion, recipient-device binding, before/after commit faults, cancellation and fail-closed missing/changed rows. The owned receive fixture covers actual account/session integration; structural helpers alone are not authentication. Store and transport ACK do not complete the obligation or imply Delivered/Read. |
| No data-plane bootstrap cycle | XPOINT-NETWORK §8.1; `HttpDeepIdV2NetworkClosureArtifactSource.FetchCurrentAsync` and independently verified protected network history | Fetch takes public network scope and an optional existing floor, not a client grant, holder or previous data-plane success. It returns bounded **untrusted** closure bytes. Current Shared full03 contains all five distribution-client cases, all Passed, including missing-chain, wrong-scope, cancellation and unavailable-media rejection. Independent signed verification/history adoption remains mandatory. Offline rotation and deployed catch-up are later runtime tests, not proved by this transport fixture. |

Case membership and nonpassing names were read from the actual TRX through the
root `Read-TestGateReceipt`, not inferred from source declarations or test counts.
No tests were rerun and no native result was relabelled in this review.

## Source receipts

- Shared `5057069`: `artifacts/test-gate-20261010/shared-authority-path-full-03`;
  terminal Completed, build/preflight/test/qualification0, 895/0/0,
  1922 captured inputs, `FullAccepted=true`.
  [Exact receipt and prior failures](../deep-client-shared/docs/testing/s01-idle-mailbox-floors-2026-10-09.md#matching-full03--current-shared-source-qualified).
- Protocol `9700e76`: `artifacts/test-gate-20261010/protocol-authority-path-full-02`;
  terminal Completed, build/preflight0, test1, qualification0, 2197/1/7,
  1563 captured inputs, **`FullAccepted=false`**. The unchanged actual-package
  witness failure remains S08 under DR-0095; six provider skips and one
  operator-only predecessor-capture skip are not source feature passes.
  [Producer checkpoint](../deep-protocol/docs/testing/s01-authority-horizon-2026-10-09.md).
- Node `c000dc1`: prior consumer baseline
  `artifacts/test-gate-20261008/node-full-02`; Completed,
  build/preflight/test/qualification0, `FullAccepted=true`, 2108 inputs.
  These binaries predate the latest Protocol producer. They prove the inspected
  local contract fixtures at their own inputs; S02 must qualify current consumer
  composition, rather than presenting this old receipt as a current build.
- DevOps `2a43ba3`: both caller builds0 and five synthetic signer cases passed;
  no operator key, production signer or deployment was used.

## Acceptance and remaining work

S01 is accepted **as the contract/API stage**, not as client lifecycle, runtime
activation or shipping. Its state/error/crash obligations have sole owners;
the current bounded producer/reader formats and necessary local recovery APIs
are qualified at the source scopes above. No new wire or compatibility path is
introduced by this acceptance. S02 is the next execution stage.

The following are expressly **not implemented or qualified by S01 acceptance**:

- S04: automatic grant/route renewal, closed-expired send attempts and authorized
  successor dispatch retaining the same committed ciphertext; runtime cleanup,
  sustained 128/512 work and backpressure across cold restart. A grant's
  ClosedUnresolved acquisition is not proof that a send attempt was closed.
  New local shapes/readers needed for these operations must be implemented and
  qualified together; no caller status flag or new generic journal is authorized.
- S05/S09: independent issuer/root/witness/device/delegation rollover, deployed
  signed catch-up and sustained recovery with original identities/floors.
- S07: authenticated receipt authoring/apply, Delivered/Read policy and projection,
  due-work completion, offline queue and autonomous scheduler.
- S08–S13: actual package/API/resource closure, installed Windows/Android,
  physical contacts/messages/files/groups, remaining full release scope.

Every runtime transition still owes its actual fault/reopen tests at its
implementation stage. The contract's specified fault outcomes are not claims
that future runtime transitions already pass. No requirement is cancelled,
production changed, main merged or GitHub Release published by this review.
