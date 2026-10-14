# DR-0113 — closed Braid durable transaction boundary

Status: **accepted implementation target; SQL/transport activation gated**
Date: 2026-10-11
Decision owner: **Mr. X** (delegated architecture authority)

## Scope

Extend DR-0112's actual native candidate with a separate closed persistence
producer, not a synthetic DMC2 or a message-key deletion claim. DBR2 grammar,
control KDF, TRC1 generation2, data32 fence and public TRS1 remain unchanged.
The existing SQLCipher journal/protected floor must own controls; no additional
journal or raw-key author is authorized. Until its integration is qualified,
DBR2 remains `FROZEN_TARGET_NOT_ACTIVE`.

## Closed Protocol API

The public allocation is `ExactBraidRecoveryDurableTransactionProducer`,
`ExactBraidRecoveryDurableDirection` (Send1/Receive2),
`ExactBraidRecoveryPersistencePlan`, `ExactBraidRecoveryPreparedTransition`,
`IExactBraidRecoveryDurableTransactionAuthority`,
`ExactBraidRecoveryCommitCompletion`, `ExactBraidRecoveryCommitReceipt` and
`ExactBraidRecoverySuccessCapability`. All plan/prepared/completion/receipt/
capability constructors are internal. Reuse the existing immutable
`ExactDpe2DurableTransitionContext` and durable commit dispositions; these are
store snapshots/outcomes, not DPE2 bytes or data evidence.

PrepareSend takes exact prior TRS1, context, network16 and operation32.
PrepareReceive takes exact prior TRS1, context, network16 and canonical DBR2.
Only the approved managed/native owner may prepare a fresh successor. Before
native mutation validate prior generation/commitment, protected checkpoint
equality, journal increment capacity and current network/session/device direction.
A fresh context observing an already-consumed native receive slot rejects:
native replay without a corresponding durable record is not a committed receive.

An ExactReplay context for receive may avoid the retired native key only because
the trusted durable authority must verify the original authenticated exact frame
against retained SQL history and protected floors. A caller-supplied context,
parser result or Boolean cannot grant success: only a completion bound by object
identity to this exact plan and callback attempt may produce a capability.
Changed frame, scope, direction, operation or predecessor rejects. Send replay
is selected by the owner from its original verified row, before native prepare.

The immutable wipeable plan contains direction, prior/next state generations,
checkpoint and journal predecessors, exact frame/operation, SHA-256 of the full
frame and authentication projection, exact prior/next TRS1 and their commitments,
retention commitment and deletion manifest. Fresh next generation is prior+1;
receive replay has no successor or deletion manifest. The manifest uses the
existing `Deep/Messaging/V2/deletion-manifest` encoding with the sole obligation
`PreviousStateAfterCommit`. There is no MessageKeyAfterUse, DMC2, application
dedup/PQ-fence mutation or AppAck; controls preserve these data invariants.

CommitAsync is single-flight and invokes only the trusted authority. Exceptions
leave the same prepared bytes available for a new callback attempt; cancellation
before callback does not invoke it. Terminal rejection destroys the plan. Dispose
during callback defers wiping until that callback finishes. A receipt is
single-use and bound to plan plus attempt; a receipt from an earlier failed
callback or another plan rejects. Receive replay requires ExactReplay disposition.
Fresh plans accept Committed or authority-verified ExactReplay after an unknown
commit. A success has operation/hash and replay status; only send success may
take the exact frame once. Receive success has no plaintext or message handoff.
This is local custody success, not automatic transport ACK or application receipt.

## Frozen Shared local mapping

Use the existing MSP2 version2/672-byte metadata and five length-prefixed bodies,
with new closed kind5, status1 and directions3(control send)/4(control receive).
Kind5 increments the active prior ratchet generation by one. Next TRS1 occupies
body0; canonical DBR2 exactly4112 occupies body1; bodies2–4 are empty. There is
no DMC2 or route-processing outcome. The protected pending/stable coordinator
and its current crash protocol remain the same.

Operation is at268. Event commitment300 and envelope commitment332 are both
SHA-256(exact DBR2). Header commitment364 is SHA-256(authentication projection).
Deletion manifest396 is the Protocol-sealed prior-state obligation above.
Message-key evidence428 is zero; replay evidence460 is the full-frame hash;
dedup/PQ-fence/terminal492–588 and route608–672 are zero. Existing predecessor,
next state commitment/hash and five body widths retain their existing meanings.
Validate exact scope, direction, operation, hashes and all reserved-zero fields
before allocation/pending recovery. Imported metadata is not permission for a
new mutation; only the closed plan may author kind5.

The same DMS2 SQL file becomes schema generation5, current-only; no generation4
reader or migration. Existing events accepts directions1–4. Directions3/4 require
exact4112-byte envelope and NULL plaintext. Operation remains the same primary
key across data and controls; cross-kind/direction reuse rejects. Working journal
and retained protected history count kind2 and kind5 event rows explicitly.
History/checkpoint compaction preserves exact control rows and their hashes;
normal semantic selectors continue to select only directions1/2. No additional
table, journal, plaintext handoff or delete-old-control policy is introduced.

## Shared closure still required

Integrate a distinct control mutation in the existing journal with explicit
send/receive directions, exact4112-byte frame and no plaintext. Do not route
controls through data materialization or falsify its mandatory deletion evidence.
Use the actual account lease, freshness, protected pending/stable floors, atomic
SQL ratchet/event write, cold reconciliation and exact retained-operation lookup.
Unknown sends retain their original frame and required link dependencies; only
the separately authorized same-peer purpose-progress proof in
[DR-0114](DR-0114-owned-braid-mailbox-lifecycle.md) may end a native control-key
dependency, not its original request or independent transport dependencies.
Compaction/key retirement cannot otherwise discard them. Real SQLCipher crash/cancel/replay tests,
public API/package gates, transport admission/ACK and physical devices remain
required before activation or whole-S04 acceptance.
