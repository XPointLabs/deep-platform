# DR-0123 — retained publication intent is not a mutation lease

Status: accepted API increment; fresh dispatch/reconciliation activation open
Date: 2026-10-15
Decision owner: Mr. X (delegated architecture authority)

## Observed boundary

The same retained Windows owner passes current network, strict TLS and exact
prekey-pair restoration after DR-0122, but its phase-6 publication request has
expired. Its current route/object remain verifiable. Replacing the original
request, operation, nonce, ciphertext, generation or XPA would change replay
identity and contradict the permanent issuer fence. An unsigned None outcome
does not prove durable absence on both replicas.

Separate authenticated original intent from a fresh mutation lease. This API
increment closes only the former; it does not grant permission to replay an
expired request. The normative owner is
[CONTACT-RESOLVER](../../architecture/CONTACT-RESOLVER-V1.md).

## Closed original-intent facts

Freeze two nonconstructible, nonserializable read-only results:
`VerifiedDeepIdV2OwnedPublicationIntent` and
`VerifiedDeepIdV2IssuerPublicationIntent`. Neither exposes dispatch, current
mutation, signing, commit or generation-reservation authority. The owner result
requires its authenticated signed/decrypted contact object. The issuer result
verifies signed public object/support and exact ciphertext hashes, but cannot
claim decryption and receives no resolver capability.

`DeepIdV2PublicationCommitVerifier.VerifyOwnedRetainedIntentAsync` takes the
current verified reusable route, owned object, exact original publisher request
and XPU. `VerifyIssuerRetainedIntentAsync` takes the current verified reusable
route, exact original publisher request and XPU without client decryption
evidence. Both use the route's protected clock; no caller time, raw key,
historical/currentness switch, fake XPO or saved verified object is accepted.

Before callbacks, bound and defensively own all candidate bytes. Verify exact
request/body/object/route/generation/locator/owner and publisher signature,
original XPA witness signatures under their actual authenticated issuance XNA,
original carriage placement and selected pair, canonical original request/XPA
windows and signed inner containment. Original issue cannot be future. The
original request/XPA may be expired, but the current DID2/DCA/device, current
logical assignment, live route/object/service, network, policy and protected
time must independently remain current at entry and final release. Recheck
boot/sample and trusted interval continuity across callbacks. Wrong issuer,
missing history, changed epoch/cohort, mutated inputs or cancellation reject.

The result identifies the original exact request and generation only. It does
not prove zero/one/two replicas committed, release a permanent issuer fence,
retire a pending record, renew the object or adopt a successor. Both-node XPO
verification remains separate and mandatory for commitment.

The private Registry journal may read a completed original winner by exact
network-scoped nonce, expected directory leaf and exact original XPU request
hash. Copy/bound lookup inputs before awaits, acquire the existing network
transaction lock, authenticate canonical row projections/response pairing and
require its permanent generation fence and completed predecessor. Missing,
pending, substituted, ambiguous or corrupt state rejects without signer calls,
reservation, count change, deletion, repair or DDL. Returned bytes are not
Protocol authority and must pass the independent current intent verifier.

## Remaining connected recovery

A subsequent frozen short-lease operation must bind this exact original intent,
current owner/witness authority and current carriage independently, preserve the
original request/replay/receipt identity at both stores, and keep unknown-outcome
and interrupted adoption custody. It must authenticate the issuer's permanent
winner rather than reserve another winner. No wire allocation, old mutation
replay, new journal version, compatibility reader, reset or deployment is
authorized by this API increment. Expired inner resources require their own
closed settlement/handover; this fact cannot make them live.

Use genuine account/device/witness signatures, current proof renewal and exact
old bytes after request expiry. Cover owner versus issuer decryption claims,
substituted publisher/ciphertext/threshold/route, future issue, hostile lengths,
callback mutation, cancellation and clock discontinuity. Ordinary expired-XPU
verification must still reject. Source/API/package, permanent-winner/peer/client
recovery, real retained owner and Windows/Android E2E remain activation gates.
