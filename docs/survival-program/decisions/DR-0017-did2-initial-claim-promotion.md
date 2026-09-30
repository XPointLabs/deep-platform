# DR-0017 — DID2 encrypted initial-claim promotion

Status: **accepted bounded API clean break; runtime activation remains gated**
Date: 2026-09-30
Decision owner: **Mr. X** (delegated architecture authority)

## Decision

The single DPH2 encrypted-prefix reader accepts only exact `ParsedXpk1V2`
and padded `ParsedXpc1V2`. Neither V1 records nor an event-only prefix can
establish a production preview. Structural parsing grants no claim authority.

The closed responder promotion API is:

```csharp
Dph2InitialClaimPreview.VerifyCurrentAsync(
    VerifiedContactServicePlacement placement,
    DeepIdV2CurrentContactAuthorization recipientAuthorization,
    ParsedDcr1V2 recipientClosure,
    VerifiedDeepIdV2DirectoryFreshness initiatorFreshness,
    OnionTrustedTimeAuthority trustedTimeAuthority,
    CancellationToken cancellationToken = default)
    -> ValueTask<VerifiedDph2InitialClaim>
```

It verifies the current initiator/device and the exact decrypted pair through
DR-0016, then rechecks the initiator at a final protected-clock sample before
single-use promotion. The result retains non-null V2 initiator checkpoint and
recipient closure. A receipt alone has no public session binding method.
Only this fully verified result can expose `BindForInitialSession()` for the
two independently single-use device-prekey and Protocol-handshake lanes.
Those identity-neutral lane types belong to `MessagingCrypto`, not `ContactV1`;
the namespace change has no alias or type forward.

The exact prefix, selection and current-device semantics remain owned by
[the crypto specification](../releases/v3.0.0/specs/DEEP-CRYPTO-V1-DRAFT.md#8-dph2-hybrid-initiation)
and [CONTACT-RESOLVER §3.4](../../architecture/CONTACT-RESOLVER-V1.md#34-atomic-pre-key-claim-xpk1--xpc1).
No outer wire size, primitive suite, domain, signature tuple or service
operation changes. A successful V2 XPC1 has a minimum 4,096-byte padded wire;
the 438-byte request plus both LP32 lengths already totals 4,542 bytes before
events/trailer. Thus the 4-KiB DPH2 wire bucket remains a structural/negative
case, not a valid positive claim handshake. Positive complete-payload vectors
use the fitting 16/32-KiB buckets and both prekey kinds.

## Remaining activation gates

This is not remote durable claim read-back, pending initiator-secret custody,
ContactHello V2 semantics, a semantic inbox commit or ACK. The remaining
sender cutover and recovery fixtures must use this same V2 prefix before
runtime activation; no old receipt or test-only event format is a release
compatibility path. Rebuild consumers and republish actual Debug/Release API
snapshots. Reset only incompatible isolated QA state before device testing;
preserve network history, node keys, genesis and protected floors.
