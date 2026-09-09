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
| path/placement verifier | verifies XNV1/PMT2, derives service shards, and separately verifies returned PMS2 route closures | `deep-client-shared` |
| distribution cache | byte-identical signed public network objects only | `deep-registry-api` |

The Registry MUST NOT receive invite locators, resolver operation IDs, pre-key
claims, contact account IDs or plaintext DCR1. Invite storage is a deterministic
two-replica shard in the initial three-node profile. A mutation succeeds only after
both replicas durably commit; reads may use either and reconcile by signed/hash-bound
generation. This is availability quorum, not a disjointness claim.

## 2. Long-lived invite rendezvous: `XIR1`

### 2.1 CONTACT-CODEC canonical record rule

`CONTACT-CODEC-01` owns `DCB1`, `DCR1`, `DIA1`, `XIR1`, `XPS1`, `XPI1`,
`XPP1`, `XIC1`, `XPK1`, `XPC1`, `XUR1`, and the
DR-0004 route/placement records `XRA1`, `XRC1`, `XRR1`, `XSS1`, `PMT2`, `PMS2`.
They use exactly this one binary grammar; this section is the sole grammar source
for those records:

```text
Record = magic:ASCII[4] || version:u16be(1) || suite:u16be(0x0201)
         || fieldCount:u16be || reserved:u16be(0)
         || Field[1] || ... || Field[fieldCount]
Field  = tag:u16be || reserved:u16be(0) || length:u32be || value:length
```

Tags are exactly contiguous `1..fieldCount`, strictly increasing, unique and
known. `length` is an unsigned checked u32; the complete record is at most
65,535 bytes and has no trailing byte. Parsing order is: complete-size cap,
12-byte header/reserved/version/suite, field-header scan and exact tag set,
length/bounds/list arithmetic, closed scalars/zero/time rules, deterministic
derived hashes, typed-reference resolution, signature verification, then
closure/fork transition and one atomic mutation. An error at a stage performs
no later callback or allocation. `ArtifactRef38 = magic4 || version:u16be ||
SHA256(exactCanonicalRecord)`; `CoreRef38` is defined only where the individual
record table says so. `SIGINPUT(D, 0x0201, P)` and `SHA256-D(D, P)` use the
baseline's exact domain framing. A projection is rebuilt with its own header and
field count containing only its listed complete fields: an omitted signature
field has no placeholder. All `u*` values are fixed-width big-endian; all
`LP32` values are `u32be || bytes`; all all-zero identifiers, capabilities,
keys, hashes, refs and signatures reject except an explicit generation-zero
predecessor field. No text encoding, compression, JSON/CBOR representation,
unknown extension or dual reader is valid.

The service-facing shard key is always 32 bytes: InviteResolver receives the
domain-separated opaque permanent/one-time locator, while PreKeyClaim and
ContactUpdate receive a random capability. The service receives that key, opaque
ciphertext and a derived placement commitment under the verified public
XNV1/PMT2 closure only; it
MUST NOT receive or derive DID1, DeepAccountId, device ID, DCR1 plaintext,
relationship ID, address key or resolver read key. Records carrying device
references are a client-side closure and are never sent as the service request
body.

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

XIR1 is exactly 611 bytes. Tag 9 is `1=Reusable` or `2=OneTime`; tag 10 is
exactly zero for Reusable and one for OneTime; tag 11 is `1..256`. Tag 4 is
ZERO32 iff tag 3 is zero and otherwise names the exact accepted XIR1 hash.
Tags 15/16 resolve the issuer DPD1/DCA1 closure. Tag 18 resolves an XRA1 whose
network, PMT2 ref, placement input, sealing-key ID/public key, issue/expiry and
issuer device exactly equal XIR1 tags 1,5,6,7,8,13,14,15; it has only
`ContactInitiation` permission. The signed projection is tags 1..16 and 18
(17 fields, 539 bytes), and tag 17 verifies
`SIGINPUT("Deep/ContactResolver/V1/XIR1", 0x0201, projection)`. Its canonical
object hash is `SHA256(exactXIR1)`. A successor has the same network/rendezvous
ID, exact generation plus one, predecessor hash equality and overlapping
effective validity; same-generation changed bytes or two successors fork-latch.

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
Service records use the baseline sparse-tag rule: their listed tags are the exact
strictly increasing known set and tags `7..15` are absent. Their default canonical
record limit is 65,535 bytes. XPU1 has the exact 69,649-byte request limit
defined in section 3.1, XIS1 Success has the exact 89,388-byte canonical result
limit defined in section 3.2, and XPP1 has the exact 8,362,607-byte publication
limit defined in section 3.3.2. These are closed per-record exceptions, not a
general larger-record profile.

### 3.0 Exact current-view and service-shard derivation

Common tags 3 and 4 are closed derived values, not caller-selected routing hints:

```text
viewHash32 = XNVCoreHash32
```

`XNVCoreHash32` is the exact receipt-independent unsigned-core hash defined by
XPOINT-NETWORK-V1. The client obtains it from its current, fork-free network LKG
after validating XNA1/XVP1/XNV1/XNH1 continuity and fresh DTT1-backed trusted
time. An XNV1 artifact-envelope hash, Registry response hash, hostname, static
configuration value or server-returned value is never valid for tag 3.

The service placement class and per-operation shard key are exact:

| Request | `serviceClass:u8` | `shardKey32` |
|---|---:|---|
| XPU1, XIQ1 | 1 (`InviteResolver`) | tag 16 `locatorHash32` |
| XPK1 | 2 (`PreKeyClaim`) | tag 16 `serviceCapability32` |
| XUW1, XUQ1 | 3 (`ContactUpdate`) | tag 16 `serviceCapability32` |

XPU1 and XIQ1 deliberately share one class and one shard key, as do XUW1 and
XUQ1. Unknown classes, a zero shard key or a request whose tag-16 meaning does
not match its magic reject before placement or service dispatch.

For the exact current PMT2 bound to tag-3 XNV1, derive:

```text
servicePlacementInput32 = SHA256-D(
  "Deep/ContactResolver/V1/service-placement-input",
  networkId16 || serviceClass:u8 || shardKey32)

rank32(node) = SHA256(
  ASCII("Deep/ContactResolver/V1/service-rendezvous-sha256/v1") || 0x00 ||
  networkId16 || PMT2.selectionEpoch:u64be ||
  servicePlacementInput32 || nodeId32)
```

Rank every eligible PMT2 tag-9 node by ascending unsigned `rank32`, then
ascending `nodeId32` as the sole tie-break. `replicaCount` is exact PMT2 tag 7;
`rankedReplicaNodeIds` is the first `replicaCount` node IDs in that order. The
request commitment is:

```text
placementHash32 = SHA256-D(
  "Deep/ContactResolver/V1/service-placement",
  networkId16 || XNVCoreRef38 || PMT2ArtifactRef38 ||
  PMT2.selectionEpoch:u64be || serviceClass:u8 || shardKey32 ||
  servicePlacementInput32 || replicaCount:u8 ||
  rankedReplicaNodeIds[32 * replicaCount])
```

All concatenated fields above have their displayed fixed widths. The PMT2
artifact is the exact threshold-complete, byte-identical envelope accepted by
the network-view verifier; the Registry cannot choose another envelope or
ranking. The active XVP1 requires its PMT generation, PMT2 tag 5 equals the
exact tag-3 XNVCoreRef38, PMT2 is current under trusted time, and its node
projection/replication factor is revalidated against that XNV1 before either
hash can be emitted.

For V1, every node admitted to PMT2 is required to host all three contact-service
classes. The candidate set is therefore exactly PMT2 tag 9: local health,
latency, carrier reachability, Registry answers and request fields cannot add,
remove or reweight a candidate. If one selected replica is unreachable, the
client tries the other selected replica with the byte-identical request; it does
not rank a third storage replica. Unavailability of both selected replicas is a
coarse temporary failure until signed PMT handover changes the candidate/replica
set.

This derivation intentionally does **not** use XIR1 tag 6, XRA1 tag 6, XRR1,
PMS2, DCR1 plaintext or any server-provided route. XIR1's random placement input
selects the initial message-deposit closure returned after resolve; a holder of
only DID1 cannot know it before decrypting DCR1. Requiring it for XIQ1 would make
first resolution circular. PMS2 remains mandatory for the returned
XRR1/XRA1/XRC1/XSS1 deposit-route closure, but no per-locator PMS2 is authored or
published for the resolver service shard.

The service rank deliberately omits XNV/PMT artifact hashes. Those exact current
artifacts still bind `placementHash32` and the eligible candidate set, but a
byte-identical candidate set does not reshuffle merely because the six-hour XNV
head or its PMT envelope advances inside one seven-day selection epoch. A changed
epoch reshuffles all shards; an eligibility change produces ordinary rendezvous
minimal remapping. This service-specific domain cannot be cross-fed as a PMS2
selection proof.

The Protocol NETCODEC verifier mints a non-serializable verified
service-placement context only after the complete checks above; the client
network-state owner retains the protected artifacts/LKG and holds that capability.
CONTACT-CODEC consumes the capability and tag-16 input to produce tags 3/4 and the
ranked replica set; public encoders do not accept unrelated raw hashes. ROUTE-01 chooses an exact three-hop path whose
Exit is one of those replicas. For first permanent-address resolution the client
therefore needs only canonical DID1 plus the normal global network bootstrap: it
derives `locatorHash32` locally, acquires a current verified network/PMT context,
and can address either resolver replica without XIR1 or DCR1.

Each XNode obtains the same XNA/XVP/XNV/XNH/PMT/DTT closure through its local
verified control-plane state. Production service dispatch MUST NOT use static
`CurrentViewHash`/`CurrentPlacementHash` configuration, copy values from the
request, query a Registry-selected placement, or trust another replica's routing
claim. After canonical decode and before reservation, lookup, crypto-heavy work or
mutation, the Exit recomputes both values from its independently verified current
context and exact request magic/tag 16. It serves the request only if its own node
ID is in the derived replica set. Inter-replica commit/repair may contact only the
other derived replica IDs under the same context.

Stale-view handling is exact for XPU1/XIQ1. If tag 3 names a verified non-forked
predecessor rather than the service's current view, no lookup or mutation occurs
and XPO1/XIS1 returns `StaleView` with only the current `XNVCoreHash32` in result
tag 16. That hash is an acquisition hint, never authority: the client discards the
attempt context and independently obtains and verifies the complete successor
XNV/XNH/PMT/DTT closure. Because tags 3/4 then change, a definitive `StaleView`
preserves the higher-level user intent but creates a fresh service operation ID;
XPU1 also obtains a fresh XPA1 bound to the new body. If the response is lost or
mutation may have begun, the client instead reconciles the byte-identical old
request and never guesses that `StaleView` occurred. An unknown,
forked or same-current-view request with a wrong placement hash is malformed or
authorization-rejected, not `StaleView`, and reveals no expected placement. A
node outside the derived replica set returns only a coarse unavailable/rejected
terminal failure and never forwards the plaintext request to a caller-selected
node.

The service snapshots one verified context for validation and rechecks it before
publishing a read result or the first durable write. If the current context changes
before mutation, it returns `StaleView`; if it changes after any replica may have
committed, the result is `OutcomeUnknown` and reconciliation uses the same exact
request/operation ID. A retained predecessor replica may participate only in the
signed handover/read-repair protocol; it cannot authorize a new old-view request.

Privacy consequence: the global view hash discloses no account fact. A selected
InviteResolver pair can correlate retries and repeated resolutions of the same
opaque locator, and the selected prekey/update pair can correlate use of its random
capability; those services necessarily already receive that shard key. Weekly PMT
selection epochs reshuffle the pair; eligibility changes minimally remap affected
shards while an unchanged candidate set stays stable across six-hour view refresh.
The
derivation adds no DID1, account/device ID, read/decryption key, relationship ID or
contact graph to the service, but it does not claim to hide same-capability access
patterns from the selected replicas or a global observer.

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
XUS1/GSS1 alone additionally allow `4=65536`. XIS1 Success alone additionally
allows `5=131072`, only when its canonical Success result does not fit class 3;
XIS1 rejects class 4. All other operation/class combinations reject. The canonical result is followed only by
authenticated zero padding to the selected class. For an operation without a request
padding field, the server selects the smallest allowed class that fits. For XUQ1/GSQ1
fetch, result tag 8 MUST equal request tag 20 and the server MUST NOT silently promote
it. A result that cannot fit the selected class returns the operation's closed
`RecordTooLarge`; a write body outside its operation bound returns closed
`SizeFailure` before mutation. Arbitrary lengths reject. Unknown
status/class/outcome,
non-empty payload on a status that requires empty, non-zero retry-after outside
`RateLimited/OutcomeUnknown`, or request-hash mismatch rejects before mutation.
`RateLimited` and `OutcomeUnknown` require a positive retry-after for every result
type; every other status requires zero.

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
| 20 | witness count | 1; exact XNA1 policy threshold..32 |
| 21 | sorted `witnessId32 || signature64` | `96 * count` |

Each witness signs the identical unsigned tags 1..20 with
`SIGINPUT("Deep/ContactResolver/V1/publication-authorization", 0x0201,
unsignedXPA1)`. Count, signer set and threshold must equal the exact directory
policy committed by tag 18; duplicate/unordered/unknown witnesses reject.
Consequently XPA1 is at most `594 + 96*32 = 3,666` bytes.

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
1..6 and 16..23)`, explicitly excluding the XPA1 field itself. Before signing,
every directory witness independently verifies that XPU1 tags 3/4 equal section
3.0 under its exact current XNV1/PMT2 context and that tag 16 selects the same
InviteResolver replicas. XPA1 lifetime cannot exceed its
DCB1/DCA1/XIR1/XRA1/XPS1 closure, the named XNV1/PMT2 validity intersection or
24 hours from issue; the short token controls one publication transaction and
does not shorten the already committed DCR1.

The exact XPU1 tags are:

| Tag | Value | Size |
|---:|---|---:|
| 16 | locator hash | 32 |
| 17 | exact XIR1 hash | 32 |
| 18 | generation | 8 |
| 19 | predecessor object hash | 32 |
| 20 | object ciphertext hash | 32 |
| 21 | exact `nonce24 || XChaCha20-Poly1305(exactDCR1)` | `40..65575` |
| 22 | usage limit | 4 |
| 23 | effective expires-at | 8 |
| 24 | exact XPA1 | canonical bytes |

The XPU1 canonical size is `408 + tag21Bytes + exactXPA1Bytes`; its closed
maximum is therefore `408 + 65,575 + 3,666 = 69,649` bytes. No other request
inherits this exception and neither field may be padded to reach the maximum.

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
returns tag 16 as the current required XNVCoreHash32; `Conflict` alone returns a sanitized
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
| 20 | anti-spam token | exactly `0` bytes for registered V1 type 0 |
| 21 | response padding class | 2 |

The public V1 profile has exactly one token type: `0=None`, and it requires tag 20
to be exactly empty. Manual recipient approval and service quotas are the V1 abuse
controls; public resolution does not require proof of work. A future proof-of-work
or unlinkable-token mechanism requires a separately registered nonzero token type
and exact token specification; unknown/opaque token types reject.

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
two-replica receipt container as XPO1. For a consumed one-time invite, each
replica signs the exact 160-byte tuple:

```text
SIGINPUT("Deep/ContactResolver/V1/invite-claim-commit", 0x0201,
  requestHash32 || locatorHash32 || publicationGeneration:u64be ||
  currentPublicationExpiresAt:u64be || objectCiphertextHash32 ||
  routeClosureHash32 || claimCommitGeneration:u64be ||
  serverTime:u64be)
```

All values are copied from the exact XIQ1/XIS1 transaction. In particular,
`routeClosureHash32 = SHA256(exactRouteClosure)` and `serverTime` is XIS1 tag 6.
This receipt cannot be replayed for another locator/publication, cannot replace
the returned route closure after commit and has no recursive dependency on tag
23. Permanent non-consuming resolution has no tags 22/23 and no replica claim
receipt. Thus XIS1 returns exact stored ciphertext plus a
hash-closed current `XRR1/XRA1/XRC1/XSS1/PMT2/PMS2` initial-deposit closure,
generation and current-publication expiry. XPU1 commits only encrypted DCR1 bytes.
`exactRouteClosure` is exactly `count:u8(6) || LP32(exactXRR1) ||
LP32(exactXRA1) || LP32(exactXRC1) || LP32(exactXSS1) || LP32(exactPMT2) ||
LP32(exactPMS2)` in that order. It is `4,143..23,295` bytes from the closed
component bounds in section 3.6. The permanent Success canonical maximum is
89,171 bytes; adding one-time tags 22/23 makes the overall XIS1 Success maximum
89,388 bytes. A Success of at most 16,384 outer bytes uses the smallest class
`0..3`; a larger Success uses exactly class `5=131072`. Non-success XIS1 results
use the smallest class `0..3`; every XIS1 class-4 result and every unnecessary
class-5 result rejects.
The returned route closure is independently verified against exact XIR1/XRA1,
current XNV1/PMT2/PMS2 placement and XRC1/XSS1 lineage; it cannot replace or modify
the DCR commitment. `Expired` applies only to a one-time invitation or signed
publication, never to DID1.

`StaleView` returns only tag 16 as the current required XNVCoreHash32; `Conflict` returns only
a sanitized fork-evidence hash32; all other non-success payloads are empty.
`RateLimited` sets retry-after, and `OutcomeUnknown` uses
`mutationOutcome=OutcomeUnknown`; every other status has zero retry-after and
`mutationOutcome=None`.

A lost successful one-time response is replayed byte-for-byte only for the same
`redemptionOperationId32` and request hash. A different operation receives
`AlreadyClaimed` without object bytes. Replay retention follows
`RET-DPK-CLAIM-V1`. `OutcomeUnknown` is reconciled by retrying the same operation;
clients MUST NOT mint a new redemption operation.

#### 3.2.1 Route-closure distribution boundary

The directory publication owner stores the exact current
`XRR1/XRA1/XRC1/XSS1/PMT2/PMS2` container under only
`(networkId16, locatorHash32, generation)`. It may expose those canonical bytes
through a bounded HTTPS cache/distribution endpoint for XNode exits. The index
and response contain no Deep ID, account/device identifier, DCR1 plaintext,
resolver-read capability or caller-supplied trust flag. A locator lookup is not
an account-directory search and no enumerable list endpoint exists.

The endpoint is transport only. Before XIS1 construction, the XNode decodes all
six exact records and reruns `ContactCodec.VerifyRouteUpdateClosure` against its
current Protocol-minted XNA1/DTT1/XNV1/PMT2 authority snapshot. It then requires
the exact request network/locator, XIR1 commitment, publication generation and
validity intersection. Registry TLS, a successful HTTP status, catalog metadata
or cached bytes never mint `VerifiedContactRouteClosure`.

Missing, stale, conflicting, oversized or unavailable route data yields the same
coarse `TemporarilyUnavailable` family and no DCR1 ciphertext. It never becomes
`NotFound` evidence that can enumerate an account. The client reaches this
boundary only through the selected three-hop ContactResolve operation; there is
no client-to-Registry or direct-service fallback. An on-prem deployment may
replace the distribution adapter, but it must satisfy the identical verified
closure interface and cannot change this wire or trust rule.

The public v1 distribution adapter uses
`POST /api/v1/contact-route-closures` with request media type
`application/vnd.deep.contact-route-closure-request.v1+octet-stream` and an
exact 50-byte body `version:u16be(1) || networkId16 || locatorHash32`.
`Content-Length` is mandatory. A successful response uses
`application/vnd.deep.contact-route-closure.v1+octet-stream` and exactly
`count:u8(6) || LP32(XRR1) || LP32(XRA1) || LP32(XRC1) || LP32(XSS1) ||
LP32(PMT2) || LP32(PMS2)`, with total size 4,143..23,295 bytes, exact
`Content-Length`, `Cache-Control: no-store`, no redirect and no trailing bytes.
The adapter exposes no list method. Unknown locator, wrong network and rejected
publication are normalized to HTTP 404; a dormant or globally unavailable
source is HTTP 503. Both remain transport outcomes and MUST NOT be interpreted
as verified account non-membership.

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
`RET-DCR-PUBLICATION-V1`; its capability/placement is random. XPS1 is exactly
352 bytes. Its canonical signature projection is tags 1..11 (280 bytes), rebuilt
under the CONTACT-CODEC record rule; tag 12 verifies
`SIGINPUT("Deep/ContactResolver/V1/prekey-service", 0x0201, projection)`. Tag 6
is ZERO32 iff tag 5 is zero; otherwise a successor is exact generation+1 for the
same capability/device and names `SHA256(exact predecessor XPS1)`.
It authorizes at most fourteen non-overlapping pre-signed DPK2 epoch
inventories; only the current epoch plus one overlap epoch may be served. The
signature domain is `Deep/ContactResolver/V1/prekey-service`. It authorizes the
store to return only a DPK2 signed by the exact responder DPD1, for the exact
service generation and current witnessed DMD1/DRS1 head.

#### 3.3.1 Complete pre-key inventory manifest: `XPI1`

An XPS1 generation is not publication authority for an arbitrary subset of
DPK2. Every published epoch therefore has one device-signed XPI1 manifest:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | exact XPS1 service capability | 32 |
| 3 | responder device ID | 32 |
| 4 | exact responder DPD1 ArtifactRef | 38 |
| 5 | XPS1 service generation | 8 |
| 6 | exact XPS1 ArtifactRef | 38 |
| 7 | inventory epoch | 8 |
| 8 | predecessor XPI1 hash; zero only for epoch 1 | 32 |
| 9 | one-time DPK2 count | 2 |
| 10 | ordered one-time DPK2 Merkle root | 32 |
| 11 | exact last-resort DPK2 hash | 32 |
| 12 | exact current DMD1 hash | 32 |
| 13 | exact current DRS1 ArtifactRef | 38 |
| 14 | issued-at Unix seconds | 8 |
| 15 | expires-at Unix seconds | 8 |
| 16 | publisher device signature | 64 |

XPI1 is exactly 560 bytes. Its 488-byte canonical projection is tags 1..15;
tag 16 is `Ed25519.Sign(deviceSigningKey,
SIGINPUT("Deep/ContactResolver/V1/prekey-inventory", 0x0201, projection))`.
Every XPI1 predecessor, receipt and claim binding uses exactly
`xpi1Hash32 = SHA256-D("Deep/ContactResolver/V1/exact-xpi1", exactXPI1)`;
raw SHA-256 and the CONTACT-CODEC ArtifactRef hash are not interchangeable.
Tags 1..6 must equal the exact verified XPS1/DPD1 closure. Tag 7 is `1..14`,
tag 8 is ZERO32 iff tag 7 is 1 and otherwise names the exact accepted prior
XPI1. Tag 9 is `32..4096` and is at least XPS1 tag 8. The validity interval is
non-empty, is contained by XPS1, DMD1 and DRS1 freshness, and covers every
committed DPK2. XPI1 and every member DPK2 have identical network, device,
device generation, DPD1 ref, DMD1 generation/hash, XPS1 generation and inventory
epoch. Every member has `DPK2.notBefore == XPI1.issuedAt`,
`DPK2.expiresAt == XPI1.expiresAt` and `DPK2.issuedAt <= XPI1.issuedAt`.
Changed bytes at the same epoch or two accepted
successors permanently fork-latch that service generation.

One-time DPK2 records are sorted by their nonzero tag-19 pre-key ID; duplicate
IDs or hashes reject. For zero-based position `i`, the leaf is
`SHA256-D("Deep/ContactResolver/V1/prekey-inventory-leaf",
i:u16be || dpk2Hash32)`. The tree is padded to the next power of two with
`SHA256-D("Deep/ContactResolver/V1/prekey-inventory-empty", i:u16be)` leaves;
an internal node is
`SHA256-D("Deep/ContactResolver/V1/prekey-inventory-node", left32 || right32)`.
Tag 10 is the root. Tag 11 is the exact domain-separated DPK2 hash of the sole
LastResort record and is not a tree leaf. Thus the manifest commits the complete
ordered set, not a server-selected subset.

#### 3.3.2 Atomic two-replica inventory publication: `XPP1` / `XIC1`

The client sends one operation-bound XPP1 to both exact PreKeyClaim placement
replicas over authenticated replica transport. XPP1 uses CONTACT-CODEC with
tags `1=networkId16`, `2=publicationOperationId32`, `3=placementHash32`,
`4=exactXPI1`, `5=inventoryBody`. `inventoryBody` is
`oneTimeCount:u16be || LP32(exactDPK2)[count] || LP32(exactLastResortDPK2)`.
XPP1 has a closed maximum of 8,362,607 bytes; implementations must parse it
streaming or under an equivalent hard allocation budget. Both replicas verify
the complete XPI1 identity/freshness/signature/lineage, every DPK2 signature and
binding, exact order/count/root/last-resort hash and current placement before a
single durable commit. A malformed or partial body changes no state.

Each replica returns one 284-byte XIC1 with tags `1=networkId16`,
`2=publicationOperationId32`, `3=exactXPI1Hash32`, `4=placementHash32`,
`5=replicaId32`, `6=committedAt:u64be`, `7=replicaSignature64`. Tag 7 signs the
212-byte tags-1..6 projection under
`SIGINPUT("Deep/ContactResolver/V1/prekey-inventory-commit", 0x0201,
projection)`. Success requires two valid XIC1 records from the exact ranked
replicas, identical tags 1..4 and a committed time inside XPI1 validity. Same
operation and identical XPP1 exact-replays byte-identically after restart;
same operation with changed bytes, same epoch with changed XPI1, partial commit
or disagreeing replica state returns conflict/outcome-unknown and MUST NOT make
the epoch claimable. Registry publication, a single receipt or caller-provided
inventory metadata is never authority.

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
`24=claimCommitGeneration:u64`, `25=sortedReplicaReceipts`, `26=exactXPI1`,
`27=inventoryIndex:u16`, `28=MerkleInclusionProof`. For a one-time DPK2, tag 27
is its zero-based sorted index and tag 28 is exactly the concatenated 32-byte
sibling path of the padded XPI1 tree (direction follows index bits). For the
last-resort DPK2, tag 27 is `0xffff` and tag 28 is empty; its hash must equal
XPI1 tag 11. Receipt grammar is
the two sorted `(replicaId32, signature64)` entries; each replica signs
`SIGINPUT("Deep/ContactResolver/V1/prekey-claim-commit", 0x0201,
requestHash32 || dpk2Hash32 || xpi1Hash32 || oneTimePreKeyId32 ||
claimCommitGeneration:u64be || lastResortUseCounter:u16be)` where
`dpk2Hash32 = SHA256-D("Deep/Messaging/V2/exact-dpk2", exactDPK2)`. The unsigned
tuple is exactly 138 bytes. Tag 18 is exactly
`SHA256-D("Deep/ContactResolver/V1/prekey-claim-receipt", that138ByteTuple)`;
neither tag 18 nor replica signatures are part of the tuple, so the derivation is
non-circular. The claim receipt hash commits that complete input and
is included in the DPH2 handshake transcript. `StaleBundle` returns only the
required DCB1/XPS1/XPI1 hashes; `Conflict` only a sanitized fork-evidence hash;
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

```text
eventHash32 = SHA256-D(
  "Deep/ContactResolver/V1/update-event",
  eventGeneration:u64be || predecessorEventHash32 || eventCiphertextHash32 ||
  effectiveExpiresAt:u64be || LP32(sealedDPE2Update))
```

The hash input is exactly `80 + tag21Bytes`; tag 21 already contains its one
canonical LP32 prefix and is not wrapped again. XUS1 write-success tag 18 equals
this value for the exact XUW1 request. In an Events page, every record after the
first has `predecessorHash32` equal to the immediately preceding record's computed
eventHash32; the first is checked against the client's retained cursor hash before
state mutation.

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

### 3.6 Exact route and mailbox closure

The following records are client-verifiable closure objects. They are never
serialized into XPU1/XIQ1/XPK1/XUW1 service requests except as an opaque hash or
the already-authorized random service capability. References below are exact
`ArtifactRef38`, unless a `CoreRef38` is explicitly stated.

`XUR1` is exactly 538 bytes. Tag 5 is ZERO32 iff generation is zero. Tag 10 is
the closed nonzero mask `0x0001..0x0007`; a ContactHello/Accept embedded XUR1
requires exactly `0x0007`. Tags 11/12 have `issuedAt < expiresAt` and a maximum
30-day lifetime. The signed projection is tags 1..14 (466 bytes); tag 15 verifies
`SIGINPUT("Deep/Application/V1/contact-update-rendezvous", 0x0201, projection)`.
Its hash is `SHA256(exactXUR1)`. Same `(networkId,directionId,generation)` with
changed bytes, a gap, or a wrong predecessor permanently forks the direction.

`XRA1` (recipient reachability authorization) has exactly 16 fields:

| Tag | Value | Size / bound |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | random authorization ID | 32 |
| 3 | generation | 8 |
| 4 | predecessor XRA1 hash | 32; ZERO32 iff generation 0 |
| 5 | PMT2 ArtifactRef | 38 |
| 6 | random placement input | 32 |
| 7 | operation-class mask | 2; exactly bit 0 `ContactInitiation` |
| 8 | maximum accepted hellos | 4; `1..65535` |
| 9 | anti-spam policy hash | 32 |
| 10 | metadata-sealing key ID | 32 |
| 11 | metadata-sealing X25519 public key | 32 |
| 12 | issued-at | 8 |
| 13 | expires-at | 8; `issuedAt < expiresAt`, maximum 30 days |
| 14 | recipient device ID | 32 |
| 15 | recipient DPD1 ArtifactRef | 38 |
| 16 | recipient device signature | 64 |

XRA1 is exactly 550 bytes. Its signature projection is tags 1..15 (478 bytes)
under `SIGINPUT("Deep/XPoint/V1/XRA1", 0x0201, projection)` and its core hash is
`SHA256-D("Deep/XPoint/V1/XRA1/core", projection)`. Tag 15 resolves an active
device whose ID/key equal tags 14/16. A successor preserves network,
authorization ID, PMT2, placement input and recipient device; it may rotate only
anti-spam and sealing-key material. It must exactly increment generation and name
the accepted core hash in tag 4. The client sends neither tags 14/15 nor tag 16 to
the route service. These totals are the complete canonical grammar calculation:
`12 + 16*8 + 410 = 550`, and omitting only tag 16 gives
`12 + 15*8 + 358 = 478`; V1 has no reserved extension field or padding.

`PMT2` (mailbox projection) has 16 fields:

| Tag | Value | Size / bound |
|---:|---|---:|
| 1..6 | network ID, generation, predecessor hash, PMA2 CoreRef, XNV1 CoreRef, selection epoch | `16,8,32,38,38,8` |
| 7 | replication factor | u8, `2..5` |
| 8 | projected mailbox-node count | u16, `2..56` |
| 9 | sorted node entries | exactly `136*tag8`: `nodeId32 || mailboxCapacity:u64be || originId32 || currentSpki32 || nextSpki32` |
| 10..12 | issued-at, not-before, expires-at | u64; `issuedAt<=notBefore<expiresAt`, lifetime at most 14 days |
| 13 | next PMT2 core-hash commitment | 32; ZERO32 allowed only when no successor is committed |
| 14 | ADH1 CoreRef | 38 |
| 15 | directory witness count | u8, threshold..32 |
| 16 | sorted witness receipts | exactly `96*tag15`: `witnessId32 || signature64` |

PMT2 has total `378 + 136*N + 96*W` bytes, `N=2..56`, `W=2..32`. Entries sort
by node ID, are unique, and exactly equal the unrevoked Mailbox-role XND1
projection in the named XNV1; omission is allowed only for a signed XNV1
drain/quarantine reason. Witnesses resolve from tag 14's directory policy and
sign tags 1..14 using `SIGINPUT("Deep/XPoint/V1/PMT2", 0x0201, projection)`.
`PMT2CoreHash32 = SHA256-D("Deep/XPoint/V1/PMT2/core", projection)`. A successor
is exact generation+1/predecessor-core; tag 13 of predecessor, when nonzero,
must equal successor core. Any violation, different same-generation core or two
successors fork-latches the PMT lineage.

`PMS2` (deterministic blinded selection) has 11 fields: `1=networkId16`,
`2=PMT2ArtifactRef38`, `3=randomPlacementInput32`, `4=selectionEpoch:u64be`,
`5=replicaCount:u8(2..5)`, `6=rankedReplicaNodeIds` exactly `32*tag5`,
`7=selectionHash32`, `8=issuedAt:u64be`, `9=expiresAt:u64be`,
`10=directoryWitnessCount:u8`, `11=sortedWitnessReceipts` exactly `96*tag10`.
Its total is `244 + 32*N + 96*W`, N=`2..5`, W=directory threshold..32. Replica
entries are in exact `Rendezvous-SHA256-v2` rank order, unique and must be the
first N eligible PMT2 entries recomputed using tag 3. For each eligible node,
the rank is `SHA256("Deep/XPoint/V1/PMS2/rendezvous-sha256/v2" || 0x00 ||
networkId16 || PMT2ArtifactRef38 || selectionEpoch:u64be ||
randomPlacementInput32 || nodeId32)`; ascending unsigned hash bytes, then
ascending node ID bytes, is the sole tie-break order. Tag 7 equals
`SHA256-D("Deep/XPoint/V1/PMS2/selection", exact tags 1..6)`. Tags 8/9 are
inside the named PMT2 window and expire no later than its selection epoch.
Witnesses sign tags 1..9 under `SIGINPUT("Deep/XPoint/V1/PMS2", 0x0201,
projection)`. The PMS2 exact hash is `SHA256(exactPMS2)`; a changed selection or
receipt envelope for the same `(PMT2,placementInput,epoch)` is fork evidence.

`XRC1` (directory live route) has 21 fields: `1=networkId16`,
`2=randomRouteId32`, `3=generation:u64be`, `4=predecessorXRC1CoreHash32`,
`5=XRA1ArtifactRef38`, `6=PMT2ArtifactRef38`, `7=PMS2Hash32`,
`8=XNV1CoreRef38`, `9=XNH1CoreRef38`, `10=randomDepositCapability32`,
`11=sealingKeyId32`, `12=sealingX25519Public32`, `13=onionTrafficKeyEpoch:u64be`,
`14=replicaCount:u8(2..5)`, `15=sortedReplicaEntries` exactly
`64*tag14` (`nodeId32||replicaDepositCapability32`), `16=issuedAt:u64be`,
`17=notBefore:u64be`, `18=expiresAt:u64be`, `19=ADH1CoreRef38`,
`20=directoryWitnessCount:u8`, `21=sortedWitnessReceipts` exactly `96*tag20`.
It is `620 + 64*N + 96*W` bytes, N=`2..5`, W=threshold..32. Tags 5..13 equal
the named XRA1/PMT2/PMS2/XNV1/XNH1 closure exactly; tag 15 names exactly PMS2's
ranked replicas and no others. It has a maximum 24-hour lifetime, wholly inside
the XRA1/PMT2/XNV/XNH/key validity intersection. Witnesses sign tags 1..19 under
`SIGINPUT("Deep/XPoint/V1/XRC1", 0x0201, projection)`. Its core is
`SHA256-D("Deep/XPoint/V1/XRC1/core", projection)`. Only the random tag-10/tag-15
capabilities go to storage nodes; account/device/Deep-ID material never does.

`XSS1` (retained route successor/checkpoint) has 14 fields:
`networkId16 || routeId32 || successorGeneration:u64be || predecessorXRC1CoreHash32
|| currentXRC1ArtifactRef38 || predecessorXRC1ArtifactRef38 || PMT2ArtifactRef38
|| XNV1CoreRef38 || PMS2Hash32 || issuedAt:u64be || expiresAt:u64be || ADH1CoreRef38
|| witnessCount:u8 || witnessReceipts[96*count]`. Its total is `451 + 96*W`,
W=threshold..32. It keeps exactly the prior/current XRC lineage and named
placement closure for the route's retention horizon; it does not authorize a new
route. Witnesses sign tags 1..12 with `SIGINPUT("Deep/XPoint/V1/XSS1", 0x0201,
projection)`, and `XSS1CoreHash32 = SHA256-D("Deep/XPoint/V1/XSS1/core",
projection)`. Same `(networkId,routeId,successorGeneration)` changed core or
inconsistent predecessor/current XRC is permanent fork evidence.

`XRR1` (recipient-shared reachability) has 20 fields:
`networkId16 || randomRendezvousId32 || generation:u64be || predecessorXRR1CoreHash32
|| XRA1ArtifactRef38 || XRC1ArtifactRef38 || XSS1ArtifactRef38 || PMT2ArtifactRef38
|| PMS2Hash32 || randomDepositCapability32 || antiSpamPolicyHash32 || usePolicy:u8
|| maximumAcceptedHellos:u32be || minimumReader:u16be || issuedAt:u64be || notBefore:u64be
|| expiresAt:u64be || recipientDPD1ArtifactRef38 || recipientDeviceSignature64 || reserved:u16be(0)`.
It is exactly 643 bytes. `usePolicy` is `1=SingleUse`, `2=BoundedUse`,
`3=PublicAddress`; single use requires maximum=1, bounded requires 2..65535,
public requires 1..65535. It is valid only when all six named closure objects
verify and its timing is inside XRC1. Tags 1..18 and 20 are signed by the
device key resolved from tag 18 using `SIGINPUT("Deep/XPoint/V1/XRR1", 0x0201, projection)`;
tag 19 is the signature and tag 20 is
reserved fixed zero and is intentionally included to prohibit extension. The
core is `SHA256-D("Deep/XPoint/V1/XRR1/core", projection)`. The resolver returns
this complete client closure only inside the read-capability-protected response;
the deposit service receives only tag 10 or a tag-15 replica capability.

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
