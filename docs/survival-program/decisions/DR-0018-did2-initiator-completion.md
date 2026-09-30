# DR-0018 — DID2-only initiator completion

Status: **accepted bounded API clean break; runtime activation remains gated**
Date: 2026-09-30
Decision owner: **Mr. X** (delegated architecture authority)

## Decision

The only preparation completion API is:

```csharp
InitiatorDph2ClaimPreparation.CompleteAsync(
    VerifiedXpc1V2PreKeyClaimReceipt verifiedClaim,
    VerifiedDeepIdV2DirectoryFreshness initiatorFreshness,
    OnionTrustedTimeAuthority trustedTimeAuthority,
    ReadOnlyMemory<byte> exactSessionInitDmc2,
    ReadOnlyMemory<byte> exactFirstApplicationDmc2 = default,
    CancellationToken cancellationToken = default)
    -> ValueTask<InitiatorInitialSessionCommitCapability>
```

There is no synchronous V1 receipt overload. Each completion attempt consumes
the preparation, including malformed events, cancellation and expired proof.
Bounded events are copied before the first suspension. Current initiator/device
and recipient are checked at an initial protected-clock sample and again at
one final sample before the exact DPH2/TRS1 capability can escape. Disposing
the preparation during either suspension rejects completion. On failure all
owned preparation, event and result buffers are disposed or zeroed.

The single sender and responder payload grammar always includes the exact
V2 XPK1/XPC1 prefix from DR-0017, including in recovery tests. Receipt handoff
is internal and single-use; a receipt alone grants no public session or ACK.
No wire, suite, KDF, signature domain or service operation changes.

## Remaining activation gates

Protected pending preparation/result custody, two-replica durable evidence,
ContactHello V2, semantic inbox/ACK and shipping callers remain independent
release blockers. Old Shared orchestration must not call the removed API or
adapt a V1 receipt; an unavailable old entry point is not a V2 runtime.
Rebuild the three-assembly production graph and downstream consumers, update
actual API snapshots, and retain recovery/tamper/ownership coverage with exact
V2 fixtures. Incompatible isolated QA state needs explicit reset, never a
migration. Preserve node keys, genesis and protected network floors.
