# DR-0016 — current-recipient V2 pre-key claim receipt boundary

Status: **accepted bounded API extension; runtime activation remains gated**
Date: 2026-09-30
Decision owner: **Mr. X** (delegated architecture authority)

## Decision

DR-0008 requires a DID2 recipient-bound receipt, not an adapter for the old
`VerifiedXpc1PreKeyClaimReceipt`. Protocol owns the new closed API:

```csharp
DeepIdV2PreKeyClaimReceiptVerifier.VerifyAsync(
    ParsedXpk1V2 request,
    ParsedXpc1V2 result,
    VerifiedContactServicePlacement placement,
    DeepIdV2CurrentContactAuthorization recipientAuthorization,
    ParsedDcr1V2 recipientClosure,
    OnionTrustedTimeAuthority trustedTimeAuthority,
    CancellationToken cancellationToken = default)
    -> ValueTask<VerifiedXpc1V2PreKeyClaimReceipt>
```

The sealed result has no public constructor or raw-key/signature callback.
It retains the exact V2 request and padded result internally, the verified
offering and current recipient closure, and exposes only typed evidence,
identifiers, hashes and bounded scalar facts. It grants no session, durable
outbox/inbox mutation or ACK by itself. No V1 request/result, freshness,
authorization or contact bundle can satisfy this API.

The normative verification and exact-replay rules belong to
[`CONTACT-RESOLVER-V1`, §3.4](../../architecture/CONTACT-RESOLVER-V1.md#34-atomic-pre-key-claim-xpk1--xpc1).
Existing wire shapes, pre-key kinds, primitive suites and signature tuples
are unchanged. No new remote record or service operation is introduced.

## Activation and evidence

Verify current boot/sample and both authenticated time intervals; exact
DCB1/XPS1/device/capability binding; current DID2/DAB2/ADC1/DMD1/DCA1;
signed XPI1/DPK2 plus inclusion; both selected replicas; last-resort limit;
malformed, foreign, expired, revoked, substitution and cancellation cases.
Publish matching Debug/Release API snapshots and rebuild downstream consumers.

The signatures authenticate the claim tuple, not a storage read-back. The
coordinator must still complete both durable replicas and return their exact
common result over the authenticated selected-exit response; persistence,
restart reconciliation and DPH2 promotion remain separate composition gates.
Neither this decision nor the verifier activates the shipping MSG path.
