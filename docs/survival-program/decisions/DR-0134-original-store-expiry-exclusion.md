# DR-0134 — original Store expiry exclusion

Status: accepted bounded source/API allocation; connected activation gated
Date: 2026-10-17
Decision owner: Mr. X (delegated architecture authority)

Semantic owner: [XPOINT-NETWORK §9.1](../../architecture/XPOINT-NETWORK-V1.md#91-current-two-replica-store-ordering).
This increment closes the expiry alternative left open by DR-0086. An original
Store may remain uncertain after its short admission grant expires. A timeout,
an upper-time overlap or a persisted terminal label cannot release its prefix.

## Closed historical verification

Allocate on the existing closed host:

```csharp
ValueTask VerifyStoreExpiryExclusionAsync(
    ReadOnlyMemory<byte> exactPrq2,
    CancellationToken cancellationToken = default);
```

Capture and bound the canonical original Store and inner envelope before any
callback. Authenticate both descriptor keys, original issuer signature, Active
Deposit grant, network/epoch/placement/membership, exact retained PMT2 and signed
PMS2 writer/recipient order, body digest/bindings and sender signature. The
original creation time must lie inside the signed grant. Retained assignment
coverage follows DR-0122; this bounded implementation requires the current
verified issuer key and its signed interval/lifetime limits. Missing historical
issuer, descriptor or cohort evidence rejects, never uses a saved raw key.

Only independently current authenticated **lower time >= original grant
expiry**, checked before and after verification, proves that the exact old
permission cannot authorize a future Store. Full current host/network/policy,
protected monotonic clock and cancellation checks remain mandatory. Return no
authority object, current grant, request, raw key, clock, callback or trust flag.
An old grant is authenticated historical input, never current admission.

## Native consumers

The writer may pass an earlier exact intent only through a verified saved
two-node quorum or this permanent expiry exclusion. Keep all original bytes,
uncertainty, cursor authorities and replay/protected floors unchanged. A durable
state with absent/invalid MQR3 still rejects; it cannot fall back to exclusion.
No collection, replacement nonce/grant/body, journal generation or reset.

A reader may omit only an actual native Pending Store matched to its original
protected intent and verified exclusion, under native mutation serialization.
Recheck protected and native custody after external callbacks; never trust a
caller collection/boolean or state label as proof. Preserve ledger -> mutation
lock order. Missing exact original custody on a non-writer remains refusal;
this allocation does not invent a peer recovery RPC or reconstruct signed bytes.
Completed objects remain readable even when their original grant expired.

Exclusion is not noncommit, non-delivery, successful settlement, a tombstone,
application acknowledgement or authority to discard uncertain client work.
All actual mutations, including replay/cached-result paths, still require
independently current original admission. Native serialization must exclude an
in-flight completion before omitting Pending; expiry alone is not a lock.

## Required evidence

Require overlap refusal (lower < expiry <= upper), equality acceptance, forged
expiry/signatures, foreign scope/pair/body, missing history, rollback/boot loss,
callback mutation and cancellation. Native consumers require before-mutation
and native-Pending faults, actual independent TLS stores, cold reopen, unchanged
original bytes/floors, preserved completed objects, invalid durable-quorum
refusal, and no late old completion below a later cursor. Source qualification
does not close matching runtime, package or Windows/Android acceptance. No
wire/magic/suite/domain allocation or Releases/main authorization is added.
