# DR-0087 — protected custody of the existing mailbox operation ledger

Status: accepted native S01/S03 local-state contract; shipping activation gated
Date: 2026-10-04
Decision owner: Mr. X (delegated architecture authority)

The sole semantic owner is XPOINT-NETWORK-V1 §9.1. The local format and native
mapping belong to [XNode custody](../../../xnode/docs/mailbox-operation-custody.md).
No client wire, Protocol public API, account identity or cryptographic suite changes.
This is not another operation journal or a legacy reader.

An independent protected root anchors the exact existing schema-8 operation
document before its allocator is used. Missing or rolled-back data cannot be
treated as an empty first run, even before any native mutation exists. Readers
never enroll a scope. Explicit new-node provisioning must reject existing or
interrupted custody before creating an empty document.

The 2026-10-10 local-state amendment, implementing DR-0084's independent replay
floor obligation, extends this same document with protected current client
scope/counter/claim floors and completed outcome digests. The exact mapping and
crash boundary remain solely in the XNode local contract above. Schema6 rejects;
no migration, second journal, wire value or reader enrollment is added. Native
client replay/outcome cold loss or rollback cannot be accepted as an empty scope
while this independent operation root remains intact. Peer mutation/blob-wide
anti-rollback and retention activation remain separate evidence requirements.

The S03 peer-recovery amendment extends the same document with required bounded
hash-only peer replay/mutation/completion facts. Exact transitions and native
join mapping remain solely in the XNode local owner above. Schema7 rejects
without migration; no second full journal or new network allocation is created.
Independent custody must detect combined native peer loss and authentic pre-ACK
rollback on either replica, guarding readiness and authenticated client/peer
effects before response release. Known Pending/crash recovery and object/replay
retention cannot be replaced by reader repair or wall time.

Save uses the existing exact temporary document, then a protected bounded
pending transition, then replacement/read-back, then protected root commit.
Startup can finish only that exact authenticated transition. It cannot remint
peer bytes, infer a new cursor from blobs, or adopt an unanchored temporary.
If required bytes are missing/corrupt, leave custody unchanged and unready.

Native startup uses an independently current closed host and both actual MGR1
role leases, without obtaining or inventing a client grant. Client Store/ACK
authenticate the holder and verify this custody before client replay reservation.
All current ledger loads/saves require the live lease and protected owner;
neutral primitive APIs cannot mutate a current-owned ledger.

Protection binds stable node ID, network and fixed local relative document path,
not mutable PMA/PMT generation. Key ring and protected root must be independent
of replaceable node data. A coordinated rollback of the independent protected
root and matching data can be undetected even with the key ring intact, and
remains outside this local mechanism's guarantee. Hardware or
external anti-rollback claims are not made.

Qualification includes loss/rollback before first mutation, either-side native
replacement failures, exact reopen/retry, missing/hostile pending bytes, wrong
scope/key protection and no replay/HTTP on rejection. Program startup/DI,
retained-route and retirement/horizon remain activation requirements; this
decision neither publishes a release nor resets deployed node data.
