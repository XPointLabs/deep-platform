# Contact Resolver and Pre-Key Claim V1

Status: **normative implementation target for the first public release**

This contract closes the service side of arbitrary-contact bootstrap. It is a
clean-break protocol: the Registry is not an invite directory, a bare account ID
is not resolvable, and a short-lived deposit route is not embedded in a long-lived
Deep ID. All requests travel as opaque operations through the selected transport;
`OfficialXPoint3` carries them over the exact three-hop XPoint path.

## 1. Roles and ownership

| Role | Responsibility | Owner repository |
|---|---|---|
| address publisher | creates DID1/DAB1 and rotating DCB1/XIR1, encrypts DCR1 | `deep-client-shared` |
| invite store | quorum publication, resolve, one-time claim and replay | `xnode` |
| pre-key claim store | atomic DPK2 one-time-key claim | `xnode` |
| path/placement verifier | verifies XNV1/PMT2/PMS2 and selects replicas | `deep-client-shared` |
| distribution cache | byte-identical signed public network objects only | `deep-registry-api` |

The Registry MUST NOT receive invite locators, resolver operation IDs, pre-key
claims, contact account IDs or plaintext DCR1. Invite storage is a deterministic
two-replica shard in the initial three-node profile. A mutation succeeds only after
both replicas durably commit; reads may use either and reconcile by signed/hash-bound
generation. This is availability quorum, not a disjointness claim.

## 2. Long-lived invite rendezvous: `XIR1`

`XIR1`, version 1, suite `0x0201`, is the reachability descriptor embedded in
DCB1. It is not the current message deposit route.

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | random invite rendezvous ID | 32 |
| 3 | generation | 8 |
| 4 | predecessor XIR1 hash; zero at generation 0 | 32 |
| 5 | exact PMT2 ArtifactRef used for placement | 38 |
| 6 | random placement input | 32 |
| 7 | metadata-sealing X25519 key ID | 32 |
| 8 | metadata-sealing X25519 public key | 32 |
| 9 | invite policy (`Reusable` or `OneTime`) | 1 |
| 10 | maximum resolves | 4 |
| 11 | maximum pending claims | 2 |
| 12 | anti-spam policy hash | 32 |
| 13 | issued-at Unix seconds | 8 |
| 14 | expires-at Unix seconds | 8 |
| 15 | exact issuer DPD1 ArtifactRef | 38 |
| 16 | exact DCA1 ArtifactRef | 38 |
| 17 | issuer device signature | 64 |
| 18 | exact long-lived XRA1 reachability-authorization ref | 38 |

The rendezvous and placement values are CSPRNG output and are not derived from an
account, device, mailbox or recovery key. Lifetime is at most 400 days for a
reusable XIR1 and at most 30 days for a one-time XIR1. The DCB1 issuer signs
`SIGINPUT("Deep/ContactResolver/V1/XIR1", 0x0201, unsignedXIR1)` and must be
authorized by exact DCA1/DMD1. A permanent Deep ID resolves a signed successor
XIR1/DCB1; a one-time invite never silently changes target.

Permanent DID1 has no expiry. Its current first-contact availability ends at the
minimum of DCB1, DCA1, XIR1, XRA1 and
XPS1 authorization. ADH1 is separately required as fresh verification evidence:
its short publication lifetime does not shorten a permanent Deep ID, and every
resolve obtains a current witnessed ADH1/ADP1 result before device or pre-key
selection. A current DPK2 epoch may shorten one handshake but never the permanent
Deep ID. UI MUST distinguish permanent ID validity from current reachability and
show any temporary-unavailability reason. A permanent-address publisher normally refreshes
its encrypted DCR1 before the 20% margin; while the client is offline, the
directory threshold may refresh only the network-dependent XRC1 route closure
under exact XRA1. It cannot extend signed DCB1/XIR1/XPS1 expiry or change identity,
device, suite, quota or placement scope.

## 3. Closed operations

Every operation has `networkId16`, `operationId32`, `viewHash32`,
`placementHash32`, `issuedAt`, `expiresAt` and an exact operation body. Unknown
operation or status rejects. Operation IDs are random, stable across retry and never
reused for another body. Transport attempt IDs remain separate.

### 3.1 Publish: `XPU1`

Before publication, the client obtains exact `XPA1` from the account-directory
threshold over the XPoint/OHTTP path. The threshold validates current
ADC1/ADH1/ADP1 plus exact DID1 hash/address public key, DAB1/DCA1/DCB1/XIR1
closure, but XPA1 exposes to
the invite store only:

```text
networkId16, locatorHash32, publicationKind:u8
DCR1Hash32, DCB1Hash32, XIR1Hash32, generation:u64, predecessorObjectHash32
objectCiphertextHash32, usageLimit:u32, effectiveExpiresAt:u64
policyHash32, issuedAt:u64, directoryHeadHash32
sorted directory-witness signatures
```

`publicationKind` is `1=PermanentAddress` or `2=OneTimeInvite`. XPA1 contains no
Deep ID/address key, account, device, directory leaf, resolver key or route.
Witnesses sign only after recomputing the locator from the DCB1 address public
key for kind 1, or from the one-time DIA1 locator commitment/expected DCB hash/
expiry with tag 6 omitted for kind 2. They never receive either resolver read
key. Witnesses validate exact DCR1 and its hash, and verify an authorized
publisher-device signature over `(locatorHash32, DCR1Hash32,
objectCiphertextHash32, generation, predecessorObjectHash32, effectiveExpiresAt)`.
They do not receive the resolver read capability and therefore do not claim to
validate encryption itself; a wrong ciphertext can only make that authorized
publisher's address unavailable and is rejected by holders after AEAD/decode.
XPA1 lifetime cannot exceed its
DCB1/DCA1/XIR1/XRA1/XPS1 closure or 24 hours from issue; the short token controls
one publication transaction and does not shorten the already committed DCR1.

The exact XPU1 body is:

```text
locatorHash32, exactXIR1Hash32, generation:u64, predecessorObjectHash32
objectCiphertextHash32, LP32(nonce24 || encryptedDCR1)
usageLimit:u32, effectiveExpiresAt:u64, exact XPA1
```

For a permanent DID1, `locatorHash32` is the exact `permanentLocator32` derivation
in the contact protocol. For a one-time DIA1,
`locatorHash32 = SHA256-D("Deep/ContactResolver/V1/one-time-locator", DIA1.locator)`.
The store verifies XPA1 threshold, exact hashes and bounds without receiving
DID1, DIA1, DAB1, DCA1 or DCR1 plaintext. Publication
is compare-and-swap on `(locatorHash, generation, predecessorObjectHash)` and
commits only after both replicas fsync the same bytes. Same-generation changed
bytes fork-latch the locator. A successor never extends any signed inner expiry.

### 3.2 Resolve: `XIQ1` / `XIS1`

`XIQ1` body:

```text
locatorHash32, requestedGeneration:u64-or-zero, redemptionOperationId32
antiSpamTokenType:u16, LP16(antiSpamToken), responsePaddingClass:u16
```

For permanent DID1 resolution, `redemptionOperationId32` provides idempotent
accounting but never consumes the address. For one-time DIA1 it is the atomic
claim identity. `XIS1` returns one closed
status and, only on success, exact stored `nonce24 || encryptedDCR1` plus a
hash-closed current `XRR1/XRA1/XRC1/XSS1/PMT2/PMS2` initial-deposit closure,
generation and current-publication expiry. The encrypted DCR1 and route-closure hashes are
jointly bound by XPU1. Statuses are `Success`, `Expired`, `AlreadyClaimed`,
`NotFound`, `TemporarilyUnavailable`, `RateLimited`, `StaleView`, `Conflict`,
`OutcomeUnknown`. `Expired` applies only to a one-time invitation or signed
publication, never to DID1.

A lost successful one-time response is replayed byte-for-byte only for the same
`redemptionOperationId32` and request hash. A different operation receives
`AlreadyClaimed` without object bytes. The replay record is retained until the later
of object expiry or 30 days after claim. `OutcomeUnknown` is reconciled by retrying
the same operation; clients MUST NOT mint a new redemption operation.

### 3.3 Pre-key service descriptor: `XPS1`

DCB1 carries one signed XPS1 per active device, not consumable pre-key bytes:

```text
networkId16, serviceCapability32, responderDeviceId32, exactDPD1Ref38
serviceGeneration:u64, predecessorHash32, supportedSuite:u16
minimumInventory:u16, lastResortReuseLimit:u16
issuedAt:u64, expiresAt:u64, publisherDeviceSignature64
```

XPS1 authorization lifetime is at most 400 days and its capability/placement is
random. It commits up to fourteen non-overlapping pre-signed DPK2 epoch
inventories; every active epoch lasts at most 30 days and only current plus one
overlap epoch may be served. The
signature domain is `Deep/ContactResolver/V1/prekey-service`. It authorizes the
store to return only a DPK2 signed by the exact responder DPD1, for the exact
service generation and current witnessed DMD1/DRS1 head.

### 3.4 Atomic pre-key claim: `XPK1` / `XPC1`

`XPK1` binds:

```text
serviceCapability32, exactDCB1Hash32, exactXPS1Hash32
responderDeviceId32, requestedSuite:u16
senderEphemeralCommitment32, claimOperationId32
```

`XPC1` returns `Claimed`, `Replay`, `PreKeysUnavailable`, `Expired`, `StaleBundle`,
`RateLimited`, `Conflict` or `OutcomeUnknown`. `Claimed` and `Replay` contain the
same fresh exact DPK2, one-time pre-key ID, claim receipt hash, witnessed
DMD1/DRS1 head, service generation and
expiry. The claim receipt binds the complete XPK1 hash and quorum commit generation;
it is included in the DPH2 handshake transcript. No unsigned device/pre-key list is
accepted.

The first quorum-committed claim wins. A retry with the same operation and request
hash exact-replays; any other operation for that pre-key receives `AlreadyClaimed`.
If one-time ML-KEM inventory is exhausted, a signed last-resort key may be reused
only up to XPS1's durable server-side counter and the response carries that counter;
clients surface degraded pre-key status and the publisher replenishes inventory.
Coordinator failover requires a higher signed PMT2 generation and recovered quorum
state; a lease or an unreplicated Registry decision cannot authorize a second claim.

## 4. Rotation, quotas and abuse

- A DCB1 contains one valid XPS1 for every active public-release device. It never
  embeds one-time DPK2 bytes. Empty inventory returns `PreKeysUnavailable` or a
  bounded last-resort response; omission cannot make a signed device silently
  unreachable.
- The publisher replenishes one-time pre-keys before 25% remain and republishes a
  successor DCB1/DCR1 atomically.
- Default bounds are 1,000 stored unresolved requests and 100 visible local pending
  requests per invite capability. Over-limit requests receive coarse `RateLimited`.
- Proof-of-work or unlinkable admission tokens are verified before public-key-heavy
  work. Policy comes from signed XIR1/network policy, never request fields.
- Responses use fixed size classes and coarse timing. Services log no locator,
  account, device, IP or ciphertext; operational metrics are aggregate buckets.
- Revoking a one-time invite rotates/removes its locator. Blocking a contact
  rotates relationship XUR1/XRR1 and rejects that account/session locally, but
  never changes the permanent DID1 locator; a public address cannot prevent a
  blocked party from resolving public DCB1 again, so admission tokens, quotas
  and manual approval remain mandatory. Report is a separate user-authorized
  abuse object and is never automatic plaintext upload.

## 5. Failure and recovery rules

An expired or missing publication affects only new contact establishment. It does
not delete an account, permanent DID1 or existing contacts. Existing contacts use
pairwise XUR1 and message reachability. A fresh device restored from the recovery
phrase derives the same DID1 and can publish a new DAB1/DCB1 generation after the
account recovery/enrollment ceremony. It cannot derive old one-time DIA1, XIR1,
XUR1, message routes, ratchets or contact capabilities; those require an encrypted
backup/device transfer or replacement.

Replica divergence, lower generation, changed bytes at one generation, invalid
predecessor, mismatched PMT2/XNV1 or conflicting claim receipts fail closed and emit
sanitized fork evidence. Clients never resolve a locator through direct Registry
HTTPS as a hidden fallback.

## 6. Required vectors and gates

1. Publish/resolve/rotate vectors with exact canonical hashes and size limits.
2. Concurrent 100-way claim proves one winner and deterministic exact replay.
3. Crash before/after each replica fsync and coordinator failover.
4. Publication availability is the minimum of all nested artifacts; stale XRR1
   cannot invalidate permanent DID1 because XIR1, not XRR1, is current public
   reachability and DID1 is the stable address.
5. Spam, malformed-token, locator enumeration, padding and timing-negative tests.
6. Android-to-Windows and Windows-to-Android first contact while recipient is
   offline, with Registry unavailable after verified network bootstrap.
