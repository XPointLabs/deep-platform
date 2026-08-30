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
| 10 | successful redemption limit (`0` for non-consuming reusable, `1` for one-time) | 4 |
| 11 | maximum concurrently reserved unresolved operations | 2 |
| 12 | anti-spam policy hash | 32 |
| 13 | issued-at Unix seconds | 8 |
| 14 | expires-at Unix seconds | 8 |
| 15 | exact issuer DPD1 ArtifactRef | 38 |
| 16 | exact DCA1 ArtifactRef | 38 |
| 17 | issuer device signature | 64 |
| 18 | exact long-lived XRA1 reachability-authorization ref | 38 |

The rendezvous and placement values are CSPRNG output and are not derived from an
account, device, mailbox or recovery key. Reusable and one-time lifetime follows
`RET-DCR-PUBLICATION-V1` and never outlives the signed closure. The DCB1 issuer signs
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

Every request is a canonical tagged record with common tags `1=networkId16`,
`2=operationId32`, `3=viewHash32`, `4=placementHash32`,
`5=issuedAt:u64`, `6=expiresAt:u64`; operation-specific tags start at 16.
Operation IDs are random, stable across retry and never reused for another body.
Transport attempt IDs remain separate. The request identity is:

```text
requestHash32 = SHA256-D(
  "Deep/ContactResolver/V1/request",
  exactCanonicalRequest)
```

Every result record uses common tags `1=networkId16`, `2=operationId32`,
`3=requestHash32`, `4=status:u16`, `5=mutationOutcome:u8`,
`6=serverTime:u64`, `7=retryAfterSeconds:u32`,
`8=responsePaddingClass:u16`; operation payload starts at tag 16.
`mutationOutcome` is `0=None`, `1=DurablyCommitted`, `2=OutcomeUnknown`.
Base padding classes are `0=256`, `1=1024`, `2=4096`, `3=16384` outer bytes.
XUS1/GSS1 alone additionally allow `4=65536`; other operations reject class 4 unless
their own contract explicitly opts in. The canonical result is followed only by
authenticated zero padding to the selected class. For an operation without a request
padding field, the server selects the smallest allowed class that fits. For XUQ1/GSQ1
fetch, result tag 8 MUST equal request tag 20 and the server MUST NOT silently promote
it. A result that cannot fit the selected class returns the operation's closed
`RecordTooLarge`; a write body outside its operation bound returns closed
`SizeFailure` before mutation. Arbitrary lengths reject. Unknown
status/class/outcome,
non-empty payload on a status that requires empty, non-zero retry-after outside
`RateLimited/OutcomeUnknown`, or request-hash mismatch rejects before mutation.

### 3.1 Publish: `XPU1`

Before publication, the client obtains exact `XPA1` from the account-directory
threshold over the XPoint/OHTTP path. The threshold validates current
ADC1/ADH1/ADP1 plus exact DID1 hash/address public key, DAB1/DCA1/DCB1/XIR1
closure, but XPA1 exposes to the invite store only this canonical record:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | authorization ID | 32 |
| 3 | exact authorized XPU1 operation ID | 32 |
| 4 | locator hash | 32 |
| 5 | publication kind | 1 |
| 6 | DCR1 hash | 32 |
| 7 | DCB1 hash | 32 |
| 8 | XIR1 hash | 32 |
| 9 | generation | 8 |
| 10 | predecessor object hash | 32 |
| 11 | object ciphertext hash | 32 |
| 12 | usage limit | 4 |
| 13 | effective expires-at | 8 |
| 14 | policy hash | 32 |
| 15 | issued-at | 8 |
| 16 | not-before | 8 |
| 17 | authorization expires-at | 8 |
| 18 | directory head hash | 32 |
| 19 | authorized XPU body hash | 32 |
| 20 | witness count | 1 |
| 21 | sorted `witnessId32 || signature64` | `96 * count` |

Each witness signs the identical unsigned tags 1..20 with
`SIGINPUT("Deep/ContactResolver/V1/publication-authorization", 0x0201,
unsignedXPA1)`. Count, signer set and threshold must equal the exact directory
policy committed by tag 18; duplicate/unordered/unknown witnesses reject.

`publicationKind` is `1=PermanentAddress` or `2=OneTimeInvite`. XPA1 contains no
Deep ID/address key, account, device, directory leaf, resolver key or route.
Witnesses sign only after recomputing the locator from the DCB1 address public
key for kind 1, or from the one-time DIA1 locator commitment/expected DCB hash/
expiry for kind 2; no resolver/decryption key is a witness input in either
case. Witnesses validate exact DCR1 and its hash, and verify an authorized
publisher-device signature over `(locatorHash32, DCR1Hash32,
objectCiphertextHash32, generation, predecessorObjectHash32, effectiveExpiresAt)`.
They do not receive the resolver read capability and therefore do not claim to
validate encryption itself; a wrong ciphertext can only make that authorized
publisher's address unavailable and is rejected by holders after AEAD/decode.
XPA1 additionally contains `authorizationId32`, exact XPU1 `operationId32`,
`authorizedBodyHash32`, `notBefore:u64` and `authorizationExpiresAt:u64`.
`authorizedBodyHash32` is
`SHA256-D("Deep/ContactResolver/V1/XPU-authorized-body", canonical XPU1 tags
1..6 and 16..23)`, explicitly excluding the XPA1 field itself. XPA1 lifetime
cannot exceed its DCB1/DCA1/XIR1/XRA1/XPS1 closure or 24 hours from issue; the
short token controls one publication transaction and does not shorten the
already committed DCR1.

The exact XPU1 tags are:

| Tag | Value | Size |
|---:|---|---:|
| 16 | locator hash | 32 |
| 17 | exact XIR1 hash | 32 |
| 18 | generation | 8 |
| 19 | predecessor object hash | 32 |
| 20 | object ciphertext hash | 32 |
| 21 | `nonce24 || encryptedDCR1` | `40..1048576` |
| 22 | usage limit | 4 |
| 23 | effective expires-at | 8 |
| 24 | exact XPA1 | canonical bytes |

For a permanent DID1, `locatorHash32` is the exact `permanentLocator32` derivation
in the contact protocol. For a one-time DIA1,
`locatorHash32 = SHA256-D("Deep/ContactResolver/V1/one-time-locator", DIA1.locator)`.
The store verifies XPA1 threshold, exact hashes and bounds without receiving
DID1, DIA1, DAB1, DCA1 or DCR1 plaintext. Publication
is compare-and-swap on `(locatorHash, generation, predecessorObjectHash)` and
commits only after both replicas fsync the same bytes. Same-generation changed
bytes fork-latch the locator. A successor never extends any signed inner expiry.

The store verifies XPA1 authorization ID, operation ID, authorized body hash and
time window before reserving it. Reservation and publication CAS are one durable
saga: `Available -> Reserved(requestHash) -> Committed(commitCertificate)`.
Crash in `Reserved` reconciles both replicas; it never makes the authorization
available to different bytes. Same operation/request exact-replays; the same
authorization or operation with changed bytes returns `Conflict`.

`XPO1` is the only XPU1 result. Status IDs are `1=Committed`, `2=ExactReplay`,
`3=Expired`, `4=Unauthorized`, `5=StaleView`, `6=Conflict`,
`7=RateLimited`, `8=OutcomeUnknown`, `9=TemporarilyUnavailable`.
`Committed/ExactReplay` require `mutationOutcome=DurablyCommitted` and tags
`16=publishedGeneration:u64`, `17=objectCiphertextHash32`,
`18=commitGeneration:u64`, `19=sortedReplicaReceipts`. Tag 19 is exactly
`count:u8(2) || (replicaId32 || signature64)[2]`, sorted by replica ID; each
replica signs `SIGINPUT("Deep/ContactResolver/V1/publish-commit", 0x0201,
requestHash32 || objectCiphertextHash32 || commitGeneration)`. `StaleView` alone
returns tag 16 as required view hash32; `Conflict` alone returns a sanitized
fork-evidence hash32; all other payloads are empty. `OutcomeUnknown` carries no
receipt and MUST be reconciled with the same request.

### 3.2 Resolve: `XIQ1` / `XIS1`

`XIQ1` uses common request tags plus:

| Tag | Value | Size |
|---:|---|---:|
| 16 | locator hash | 32 |
| 17 | requested generation; zero means current | 8 |
| 18 | redemption operation ID | 32 |
| 19 | anti-spam token type | 2 |
| 20 | anti-spam token | `0..4096` |
| 21 | response padding class | 2 |

Tag 2 and tag 18 MUST be byte-identical; the duplicate field is retained in the
one-time claim transcript and disagreement rejects. For permanent DID1 resolution, `redemptionOperationId32` provides idempotent
accounting but never consumes the address. For one-time DIA1 it is the atomic
claim identity. `XIS1` status IDs are `1=Success`, `2=Expired`,
`3=AlreadyClaimed`, `4=NotFound`, `5=TemporarilyUnavailable`,
`6=RateLimited`, `7=StaleView`, `8=Conflict`, `9=OutcomeUnknown`.
Only `Success` uses `mutationOutcome=DurablyCommitted` for a one-time claim;
permanent resolution uses `None`. Success returns tags
`16=publicationGeneration:u64`, `17=currentPublicationExpiresAt:u64`,
`18=objectCiphertextHash32`, `19=stored nonce24||encryptedDCR1`,
`20=routeClosureHash32`, `21=exactRouteClosure`, and for a consumed one-time
invite `22=claimCommitGeneration:u64`, `23=sortedReplicaReceipts` with the same
two-replica receipt grammar as XPO1. Thus it returns exact stored ciphertext plus a
hash-closed current `XRR1/XRA1/XRC1/XSS1/PMT2/PMS2` initial-deposit closure,
generation and current-publication expiry. XPU1 commits only encrypted DCR1 bytes.
The returned route closure is independently verified against exact XIR1/XRA1,
current XNV1/PMT2/PMS2 placement and XRC1/XSS1 lineage; it cannot replace or modify
the DCR commitment. `Expired` applies only to a one-time invitation or signed
publication, never to DID1.

`StaleView` returns only tag 16 as required view hash32; `Conflict` returns only
a sanitized fork-evidence hash32; all other non-success payloads are empty.
`RateLimited` sets retry-after, and `OutcomeUnknown` uses
`mutationOutcome=OutcomeUnknown`; every other status has zero retry-after and
`mutationOutcome=None`.

A lost successful one-time response is replayed byte-for-byte only for the same
`redemptionOperationId32` and request hash. A different operation receives
`AlreadyClaimed` without object bytes. Replay retention follows
`RET-DPK-CLAIM-V1`. `OutcomeUnknown` is reconciled by retrying the
same operation; clients MUST NOT mint a new redemption operation.

### 3.3 Pre-key service descriptor: `XPS1`

DCB1 carries one signed XPS1 per active device, not consumable pre-key bytes:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | random service capability | 32 |
| 3 | responder device ID | 32 |
| 4 | exact responder DPD1 ArtifactRef | 38 |
| 5 | service generation | 8 |
| 6 | predecessor XPS1 hash | 32 |
| 7 | supported suite | 2 |
| 8 | minimum one-time inventory | 2 |
| 9 | last-resort reuse limit | 2 |
| 10 | issued-at | 8 |
| 11 | expires-at | 8 |
| 12 | publisher device signature | 64 |

XPS1 authorization is part of the encrypted DCR1 closure and is bounded by
`RET-DCR-PUBLICATION-V1`; its capability/placement is random.
It authorizes at most fourteen non-overlapping pre-signed DPK2 epoch
inventories; only the current epoch plus one overlap epoch may be served. The
signature domain is `Deep/ContactResolver/V1/prekey-service`. It authorizes the
store to return only a DPK2 signed by the exact responder DPD1, for the exact
service generation and current witnessed DMD1/DRS1 head.

### 3.4 Atomic pre-key claim: `XPK1` / `XPC1`

`XPK1` uses common request tags plus:

| Tag | Value | Size |
|---:|---|---:|
| 16 | service capability | 32 |
| 17 | exact DCB1 hash | 32 |
| 18 | exact XPS1 hash | 32 |
| 19 | responder device ID | 32 |
| 20 | requested suite | 2 |
| 21 | sender ephemeral commitment | 32 |
| 22 | claim operation ID | 32 |

Tag 2 and tag 22 MUST be byte-identical. `senderEphemeralCommitment32` is
`SHA256-D("Deep/ContactResolver/V1/sender-ephemeral", exact DPH2 sender
ephemeral public inputs)` and is later verified against DPH2; it is not an
account identifier.

`XPC1` status IDs are `1=Claimed`, `2=Replay`,
`3=PreKeysUnavailable`, `4=Expired`, `5=StaleBundle`, `6=RateLimited`,
`7=Conflict`, `8=OutcomeUnknown`. `Claimed/Replay` require
`mutationOutcome=DurablyCommitted` and contain tags `16=exactDPK2`,
`17=oneTimePreKeyId32` (zero only for last-resort),
`18=claimReceiptHash32`, `19=exactCurrentDMD1Hash32`,
`20=exactCurrentDRS1Ref38`, `21=serviceGeneration:u64`,
`22=preKeyExpiresAt:u64`, `23=lastResortUseCounter:u16`,
`24=claimCommitGeneration:u64`, `25=sortedReplicaReceipts`. Receipt grammar is
the two sorted `(replicaId32, signature64)` entries; each replica signs
`SIGINPUT("Deep/ContactResolver/V1/prekey-claim-commit", 0x0201,
requestHash32 || DPK2Hash32 || oneTimePreKeyId32 || claimCommitGeneration ||
lastResortUseCounter)`. The claim receipt hash commits that complete input and
is included in the DPH2 handshake transcript. `StaleBundle` returns only the
required DCB1/XPS1 hashes; `Conflict` only a sanitized fork-evidence hash;
other non-success payloads are empty. No unsigned device/pre-key list is accepted.

The first quorum-committed result for one `claimOperationId32` wins. The durable
CAS key is `(serviceCapability32, serviceGeneration, claimOperationId32)` and
its value is `(requestHash32, selectedPreKeyId32, DPK2Hash32,
lastResortCounter, commitGeneration, replicaReceipts)`. A retry with
the same operation and request hash exact-replays; the same operation ID with a
different request hash returns `Conflict`. A new operation may atomically claim a
different available one-time pre-key subject to admission/quota. One one-time
pre-key ID MUST appear in at most one committed non-replay XPC1 across both
replicas; a second receipt for the same ID fork-latches the service. If one-time
ML-KEM inventory is exhausted, a signed last-resort key may be reused
only up to XPS1's durable server-side counter and the response carries that counter;
clients surface degraded pre-key status and the publisher replenishes inventory.
Coordinator failover requires a higher signed PMT2 generation plus a handover
proof containing old/new placement refs, last committed generation, state root
and both old-replica signatures. New replicas import and verify the complete
unexpired CAS/replay set before serving; a lease or an unreplicated Registry
decision cannot authorize a second claim.

### 3.5 Established-contact update service: `XUR1` / `XUW1` / `XUQ1` / `XUS1`

`XUR1`, version 1, suite `0x0201`, is direction-specific and shared only inside
accepted pairwise E2EE:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | random update service capability | 32 |
| 3 | random direction ID | 32 |
| 4 | generation | 8 |
| 5 | predecessor XUR1 hash | 32 |
| 6 | exact PMT2 ArtifactRef | 38 |
| 7 | random placement input | 32 |
| 8 | metadata-sealing key ID | 32 |
| 9 | metadata-sealing X25519 public key | 32 |
| 10 | allowed event mask | 2 |
| 11 | issued-at | 8 |
| 12 | expires-at | 8 |
| 13 | author device ID | 32 |
| 14 | author DPD1 ArtifactRef | 38 |
| 15 | author device signature | 64 |

Mask bits are `0=DeviceListUpdate`, `1=DeviceRevocation`,
`2=ContactRouteUpdate`; all other bits reject. The signature covers unsigned
tags 1..14 with `SIGINPUT("Deep/Application/V1/contact-update-rendezvous",
0x0201, unsignedXUR1)`. Capability/direction/placement/key material are CSPRNG
or independent generated keys, never account/conversation derivations.

`XUW1` uses common request tags plus
`16=serviceCapability32`, `17=exactXUR1Hash32`,
`18=eventGeneration:u64`, `19=predecessorEventHash32`,
`20=eventCiphertextHash32`, `21=LP32(sealedDPE2Update[1..32768])`,
`22=effectiveExpiresAt:u64`. It is a two-replica CAS on generation/predecessor;
same operation exact-replays and changed same-generation bytes fork-latch.

`XUQ1` uses common tags plus `16=serviceCapability32`,
`17=exactXUR1Hash32`, `18=afterGeneration:u64`,
`19=maxEvents:u16(1..64)`, `20=responsePaddingClass:u16(0..4)`. It never marks an
event read or reveals online state. Class 4 is mandatory to request a page that may
contain one maximum-size event.

`XUS1` adds `16=operationKind:u8` (`1=Write`, `2=Fetch`). Status IDs are
`1=WriteCommitted`, `2=ExactReplay`, `3=Events`, `4=NoChange`, `5=Expired`,
`6=RateLimited`, `7=StaleGeneration`, `8=Conflict`, `9=OutcomeUnknown`,
`10=SizeFailure`, `11=RecordTooLarge`.
Write success returns `17=eventGeneration:u64`, `18=eventHash32`,
`19=commitGeneration:u64`, `20=sortedReplicaReceipts`; receipts sign the exact
request/event/commit tuple in domain `Deep/ContactResolver/V1/update-commit`.
`Events` returns `17=count:u16(1..64)`, tag 18 containing sorted records,
`19=nextAfterGeneration:u64` equal to the final returned generation and
`20=hasMore:u8(0..1)`. Each record is
`generation:u64 || predecessorHash32 || ciphertextHash32 || expiresAt:u64 ||
LP32(ciphertext[1..32768])`. `NoChange/Expired/RateLimited` have no payload;
`StaleGeneration` returns current generation/hash, `Conflict` a sanitized fork
hash, and `OutcomeUnknown` is reconciled with the same operation ID. Service
retention/compaction uses only `RET-XUR-UPDATES-V1`.

Fetch pagination is deterministic. The service takes retained records with generation
strictly greater than XUQ1 tag 18, sorts them by generation, verifies their predecessor
chain and serializes the longest prefix that satisfies both `maxEvents` and the exact
requested outer padding class. It MUST NOT skip a record to fit a later one. `hasMore`
is 1 exactly when another retained record follows the returned prefix at the response
snapshot. The next request copies `nextAfterGeneration` into XUQ1 tag 18. If no record
exists, the result is `NoChange`. Every next-page request uses a fresh operation ID
because tag 18 changes. If the first pending valid record cannot fit the
requested class, the result is `RecordTooLarge` with only
`17=requiredPaddingClass:u16` and `18=nextRecordBytes:u32`; every valid V1 record
MUST fit class 4. `requiredPaddingClass` is the smallest class in `0..4` in which
the complete result containing that one record fits; `nextRecordBytes` is the exact
canonical record length including its LP32 prefix. Failure to fit class 4 is corrupt
stored state, not a valid `RecordTooLarge` response, and fork/corruption-latches the
replica. `SizeFailure` is Write-only and returns only
`17=maximumAcceptedBytes:u32(32768)` and `18=actualBytes:u32`, where `actualBytes`
is the exact XUW1 tag-21 LP32 body length; it commits nothing. Retrying
`RecordTooLarge` with `requiredPaddingClass` also uses a fresh operation ID because
the canonical request changes.

The status matrix is closed. `WriteCommitted/ExactReplay` require operation Write,
`mutationOutcome=DurablyCommitted`, zero retry-after and tags 17..20 only. `Events`
requires Fetch, `mutationOutcome=None`, zero retry-after and tags 17..20 only.
`NoChange` requires Fetch/None and no payload; `Expired` permits either operation
with None and no payload. `RateLimited` permits either
operation, uses None, positive retry-after and no payload. `StaleGeneration` permits
either operation, uses None and only `17=currentGeneration:u64`,
`18=currentEventHash32`. `Conflict` uses None and only `17=forkEvidenceHash32`.
`OutcomeUnknown` is Write-only, uses `mutationOutcome=OutcomeUnknown`, positive
retry-after and no payload. `SizeFailure` is Write-only/None with only tags 17/18;
`RecordTooLarge` is Fetch-only/None with only tags 17/18. Both require zero
retry-after. Any other operation/status/outcome/payload combination rejects.

Tag 20 receipts are exactly
`count:u8(2) || (replicaId32 || signature64)[2]`, sorted by replica ID. Each replica
signs `SIGINPUT("Deep/ContactResolver/V1/update-commit", 0x0201,
requestHash32 || eventGeneration:u64be || eventHash32 || commitGeneration:u64be)`.
Both receipts must match the exact PMT2 replica set/generation. Exact replay returns
the same event/commit/receipt tuple; a higher server time or padding does not alter
canonical committed fields.

## 4. Rotation, quotas and abuse

Usage and abuse accounting are separate. For `Reusable`, tag 10 and XPU1
`usageLimit` are zero and a successful resolve never consumes the address;
signed policy instead defines a fixed rate-window length and token budget keyed
by `(locatorHash, policyHash, windowNumber)`. For `OneTime`, both values are
exactly one and only the first quorum-committed claim consumes redemption.
Exact replay of the same request/operation consumes neither budget again.
Tag 11 counts `Reserved` operations that have not reached a definitive result;
reservation expiry or reconciliation releases it. Rate-window exhaustion
returns `RateLimited`, redemption exhaustion returns `AlreadyClaimed`, and
neither is disguised as `NotFound`. Counters are replica state included in
handover roots; client-provided timestamps/window numbers never select a bucket.

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
