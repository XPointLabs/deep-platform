# DR-0052 — complete mailbox-authority distribution

Status: accepted pre-production clean break; grant custody/device gates remain
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

The identity-neutral network distribution must carry the public root-signed
PMA2 needed to verify the role-separated mailbox issuers. The candidate
NCQ2/NCP2 envelope remains version 2, suite 0x0201 and its existing media types;
freeze its response to exactly eight nonempty chains in this order: XNA1,
DTS1, XVP1, XNV1, XNH1, active XND1, PMT2, PMA2. The previous seven-chain
candidate is rejected, not accepted by an optional reader or repaired by a
second endpoint. Request bytes, per-chain/record/response limits and paired
XNA/DTS and XNV/XNH counts are unchanged. No signed NETCODEC bytes change.

Shared raw distribution models require and defensively own all eight chains.
The account-bound source selects exactly one canonical PMA2 by the core
reference in its NETCODEC-verified current PMT2, never by response position or
caller keys. It verifies root authorization and full nonce-fresh proof time
projected by the actual monotonic clock before protected network advancement
and again before releasing its internal owned authoring context. Retained PMT2
history/floors prevent a distributed older issuer from substituting current
policy; the current route/result verifier must still independently recheck it.
Registry remains a bounded byte distributor, not issuer or freshness authority.
Export and renewal tools retain the exact PMA2 lineage alongside PMT2; they
must not manufacture a missing record, open new signing custody or silently
convert an old public bundle. Regenerate the public bundle from retained signed
ceremony records and roll out matching consumers together before activation.

For current DID2 grants, the independently authenticated mailbox membership
commitment is SHA-256 of the exact current PMT2 canonical bytes. Its epoch is
PMS2 tag 4 under that exact projection. PMT2 is the sole current topology,
not a second P04/BLS/PRA topology. A fresh DID2 route verifies PMA2 against its
exact XNA1 and the complete authenticated time interval, and verifies the
PMA2 core reference in PMT2. Raw distributed PMA2 is never trusted by receipt
or TLS alone. Minimum generation, role-specific active issuer, maximum grant
lifetime, issuer signature and the entire grant time interval remain mandatory.

Freeze `DeepIdV2MailboxGrantResultVerifier.VerifySuccessAsync(currentDid2Route,
authoredRequest, exactXmc1, exactPma2, cancellationToken)` returning only an
immutable `VerifiedDeepIdV2MailboxGrant` with no public constructor. Capture
bounded exact records before any await. The exact request must cover the full
route-authenticated time interval at acquisition; response expiry must exceed
its upper bound. Response server time lies inside the request window and is
not beyond that authenticated upper bound, but is never used as trusted time
or required to precede the uncertain lower bound.
Verify request/response/route hashes and role capability bindings, root-signed
PMA2/current PMT2, active role issuer signature and generation, exact PMT2
membership/PMS2 epoch, maximum lifetime, and every retained route/issuer/network
expiry. Recheck the route and complete interval before releasing the result,
rejecting clock rollback, foreign boot, expiry and cancellation.

`EnsureCurrentAsync` on that immutable result rechecks the retained grant,
issuer and route, not the historical acquisition-envelope lifetime. It never
renews a request or issuer and cannot bypass fresh owned floor checks or turn
retained bytes into dispatch/installation authority. Getter bytes are copies.
Non-success XMC1 cannot become this result, nor can bare parsed records or
caller timestamps, issuer keys, topology hashes, trust flags or clocks mint it.

This increment does not preserve a holder, authorize mailbox dispatch, activate
the old issuance branch or prove physical delivery. Account-owned holder/request/
winner custody, private issuer composition, closed result verification and
physical Windows/Android tests remain the connected business-batch gates.
Protocol API/evidence snapshots, downstream rebuild/repin and public bundle
re-export are mandatory at the final batch gate.
