# DR-0104 — current retained Retrieve issuance and owned result boundary

Status: accepted S01 producer/consumer contract; runtime activation gated
Date: 2026-10-07
Decision owner: Mr. X (delegated architecture authority)

Complete the retained-read path of DR-0099–0103 as one connected batch. Keep
XMG2/XMC2/MCG3/MCP3/MAU3 and the existing cryptographic suites unchanged. The
original route need not remain live for reading previously accepted objects;
the new request, current network/root/PMA2 and short issuer grant must be live.
Store still requires the existing current-only Deposit path.

The sole semantics and transitions are
[CONTACT-RESOLVER §3.7.3](../../architecture/CONTACT-RESOLVER-V1.md#373-current-retained-retrieve-issuance).
The separately hash-bound machine registry/schema/vectors freeze the new
136-byte independent replica attestation and its distinct signing purpose.
Do not reinterpret the current139-byte route tuple or its effective expiry.
Neither transcript construction nor parsed historical records mint authority.

Each of the two current ContactResolve stores must verify the closed current
Retrieve request and independently reread its DR-0103 protected document.
Both attest the same exact route and the same bounded readUntil. Signing must
recheck actual document/current source/signing custody immediately around its
callback. Missing custody on a newly selected store is unavailable: no copying
an unprotected table, latest-route selection, unsigned handover or reranking.

Only the original host-minted current authority may create the closed retained
issuance capability. It verifies the exact protected-history PMT2, canonical
six-record graph, holder-signed route intent and both current selected stores'
descriptor-key signatures. Their attestation supplies original admission and
Retrieve capability provenance; old route witness keys/UTC are not substituted
for current authority. A readUntil beyond the original route validity ends plus
the normative object horizon rejects. Object expiry is never increased.

Issue one fresh short Retrieve MCG3 with the current role issuer and generation
floor, a fresh serial, and the original PMT2 commitment/epoch/PMS2 selection and
placement. Its expiry is bounded by current NET/PMA2/issuer policy and readUntil,
not old route/grant expiry. Resolve the original selected Mailbox node IDs against
current admitted descriptors: removal is unavailable, never reranked. Recheck
current authority, evidence and exact result before/after asynchronous signing.

Retained request authoring is only a bounded signed request, not historical route
authority. Actual Shared author/restore/installation must remain inside its
existing held account/device/holder/guard operation and prove the original
publication/route ownership from protected local custody. Exact pending bytes
survive unknown outcomes. A new request is a new operation, never an extension
of an expired pending request. Protocol result verification accepts only a real
current Retrieve issuer signature with exact request/route/selection/holder
binding; raw holder fields or a historical boolean cannot install credentials.
Rechecking an already verified winner does not renew it or authorize Store.

Node/private Registry dispatch uses an explicit retained evidence kind, with a
different signing purpose; unknown kinds reject. Permanent winner/replay scope
must bind that kind and horizon as well as the exact request and authority scope.
This is not a second public endpoint, grant format, journal generation or legacy
reader. The node Retrieve/ACK consumer must use DR-0099 retained selection plus
current revocation, holder/request/replay/operation checks. ACK means transport
tombstone after durable receive, not application Delivered/Read.

Acceptance requires actual two independent protected stores over peer HTTP,
current issuer and owned cold reopen, then typed node Retrieve/ACK with unchanged
accepted-object expiry, tombstone/replay horizon and no resurrection. Include
wrong role/route/domain/store/key, absent history/custody, changed evidence,
callback expiry/rollback/boot/cancel, lost replies and cold/crash exact retry.
Source tests alone do not close S01, shipping graph or device E2E. No production
reset, key remint, GitHub Release or main merge follows from this decision.

## Matching object-retention implementation fence

This accepted source cutover also authorizes aligning the existing MEO1 TTL and
PRQ2 retention bounds with the sole product matrix in
[RETENTION-AND-RECOVERY](../../architecture/RETENTION-AND-RECOVERY-V1.md#1-service-and-protocol-retention)
and DEEP-CRYPTO §13. No magic, layout, signing purpose or crypto suite changes.
The retained-read machine registry already freezes that object horizon. Current
NET/PMA2/role/grant validity remains a separate admission condition, not a cap
on an accepted object's signed expiry or a permission for stale Store.

Current native Store and ACK must derive the same private replay/mutation
retention bound from the exact signed object expiry, not whichever network
authority happens to be current. The existing replay grace stays unchanged.
Exact retry cannot extend expiry or rebind an object. Consumer/package pins must
be rebuilt and qualified together. Old native records whose private retention
bound was authority-end-derived are incompatible with the new ACK invariant;
they fail closed, with no adapter, migration, silent deletion or automatic reset.
Any explicit data reset remains a separate operator action; node identity,
signing keys, protected authority history and production volumes are untouched
by the source change. Previously passing receipts do not qualify this increment.
