# Account Directory Transparency V1

Status: **normative implementation target for the first public release**

Signed account artifacts alone do not prove freshness to a sender with no local
history. This contract prevents a revoked contact publisher from serving an old but
cryptographically valid DMD1/DRS1 branch. It is a transparency and freshness layer,
not a public account search service.

## 1. Privacy boundary and roles

- Each permanent DID1 derives a network-scoped `directoryLookupKey32` using
  `SHA256-D("Deep/AccountDirectory/V1/lookup", networkId16 || exactDID1)`.
  It is not derived from DeepAccountId, survives device recovery and is shared
  only by holders of the Deep ID/established E2EE state.
- Witness-private transition preimages and the current-value map use
  `directoryLeafKey32 = SHA256-D("Deep/AccountDirectory/V1/leaf",
  directoryLookupKey32)`, not an account ID.
- Lookup is sent either through the XPoint three-hop path or through the exact
  RFC 9458 role split `client -> Oblivious Relay Resource -> Oblivious Gateway
  Resource/directory target`. The directory gateway sees a stable opaque leaf
  key but not client IP; the relay sees client IP but not the encapsulated key.
  Calling these two roles “two relays” is forbidden.
- A directory response contains signed DPA1/DRS1/DMD1 closure and therefore reveals
  the contacted account to the holder of its Deep ID. It reveals no contact graph.
- Directory authorities necessarily validate the DID1 hash/address-key-to-account
  binding when admitting ADC1 or authoring XPA1 and can observe that stable
  pseudonymous mapping. OHTTP/XPoint hides the requesting/publishing source IP;
  padding and batching limit timing, but a malicious threshold or global observer
  remains a metadata non-claim. Invite stores receive only XPA1 and do not receive
  that mapping.
- `deep-registry-api` may distribute byte-identical heads/proofs but cannot author
  them. Directory witnesses and clients gossip heads.

The directory is not a zero-knowledge membership service. An admitting authority
or gateway that receives a lookup key can distinguish a currently admitted key
from an absent key and can correlate repeated use of that key. The design does not
hide the set of known opaque keys from a colluding directory threshold and does not
claim Sybil-resistant, human-unique, reachable or currently operated accounts.
Possession or lookup of a key, including a valid non-membership proof, neither
reserves the key nor creates an account/DID claim. Admission requires exact DID1,
DAB1, DPA1, DRS1 and DMD1 closure, both DAB1 signatures, proof of possession of the
DID1 address key, and the ADC1 signer rule below. A non-membership proof means only
“no current ADC1 is committed for this opaque key at this exact ADH1”.

Initial D0 uses three independently keyed witness roles and threshold 2-of-3. This
does not claim independent operators until deployment evidence proves them. At D2+
the signed policy requires `ceil(2N/3)` witnesses and bounded operator/provider
diversity.

## 2. Canonical artifacts

All hashes below use the exact `SHA256-D` framing and all `ArtifactRef38` values use
the exact canonical reference grammar in the production crypto specification.
Unsigned signed-record bytes omit the signature field rather than zeroing it.

### 2.1 `ADC1` account directory checkpoint

```text
networkId16, directoryLeafKey32, accountGeneration:u64
checkpointGeneration:u64, predecessorCheckpointHash32
exactDPA1Ref38, exactDRS1Ref38, exactDMD1Hash32, exactDAB1Hash32
revokedDCAAuthorizationIdsHash32
issuedAt:u64, minimumReader:u16
DPA1DeviceIssuerSignature64
```

An enrollment, revocation, DMD1 change or DCA1 revoke MUST produce the next ADC1
before a new contact bundle or pre-key claim is accepted. Same-generation changed
bytes permanently fork-latch that account leaf.

ADC1 is account-authored, not a directory ownership assertion. Its sole signer role
is the `device-issuer` account role in the exact DPA1 named by `exactDPA1Ref38`; the
verification key is the Ed25519 public key resolved from that exact artifact. The
signature is exactly:

```text
Ed25519.Sign(
  DPA1.deviceIssuerPrivateKey,
  SIGINPUT("Deep/AccountDirectory/V1/ADC1/account", 0x0201, unsignedADC1))
```

No XNode identity, witness, directory operator, DCA publisher device or DID1 address
key may satisfy this field. Directory authorities validate the signature and exact
closure before admission; they do not replace it with a service signature.

### 2.2 `ADH1` witnessed log head

`ADH1`, version 1, suite `0x0201`, has exact canonical tags:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | log generation | `u64` |
| 3 | predecessor ADH1 core hash | 32; zero only at generation 0 |
| 4 | tree size | `u64` |
| 5 | append-log Merkle root | 32 |
| 6 | current-value map root | 32 |
| 7 | exact authorizing XNAAuthorityCoreRef38 | 38; stable authority-core reference |
| 8 | witness-policy hash | 32 |
| 9 | valid-from | `u64` |
| 10 | valid-until | `u64` |
| 11 | minimum reader | `u16` |
| 12 | witness count | `u8`; XNA witness threshold..witness count |
| 13 | sorted witness ID/signature entries | exactly `96 * tag12` bytes |

ADH1 is valid for at most 24 hours and is normally issued every six hours. The
signed policy defines exact witness set/threshold. A head below a protected local
floor, a second root for one `(generation, treeSize)`, or a non-successor without a
root-authorized forward checkpoint blocks account mutation and first contact.

`currentValueMapRoot32` is a depth-256 sparse Merkle map keyed by the 256 bits of
`directoryLeafKey32`, read most-significant bit first. Its exact hashes are:

```text
empty[0] = SHA256-D("Deep/AccountDirectory/V1/map-empty-leaf", EMPTY)
empty[level + 1] = SHA256-D(
  "Deep/AccountDirectory/V1/map-node", empty[level] || empty[level])
presentLeaf = SHA256-D(
  "Deep/AccountDirectory/V1/map-present",
  directoryLeafKey32 || exactCurrentADC1Ref38)
parent = SHA256-D("Deep/AccountDirectory/V1/map-node", left32 || right32)
```

`empty[256]` is the empty-map root. Level 0 is the leaf level and level 255 is
immediately below the root. A key is never silently deleted: first admission changes
empty to its generation-0 ADC1 reference and every later mutation replaces that
reference with the exact successor. Account revocation is represented by a successor
ADC1 and its closure, not by absence.

Every append-log leaf is the RFC-6962 leaf hash
`SHA256(0x00 || transitionCommitment32)`, where
`transitionCommitment32 = SHA256-D("Deep/AccountDirectory/V1/transition",
exactDirectoryTransition)` and the witness-private canonical transition is:

```text
transitionVersion:u16be = 1
logIndex:u64be
directoryLeafKey32
previousADC1Ref38        # all-zero only for first admission
nextADC1Ref38
previousCurrentValueMapRoot32
nextCurrentValueMapRoot32
```

RFC-6962 inner nodes are `SHA256(0x01 || left32 || right32)`. Within one candidate
head, transitions are ordered lexicographically by
`(directoryLeafKey32, nextADC1.checkpointGeneration, nextADC1Ref38)`. A duplicate
generation, a gap, two successors of one predecessor, a transition whose previous
reference is not the map's current value, or any intermediate-root mismatch rejects
the whole candidate head.

The map and log move atomically. Starting from the predecessor ADH1, witnesses apply
the complete ordered transition batch: the first transition's previous map root MUST
equal the predecessor `currentValueMapRoot32`, each next transition MUST consume the
prior transition's next root, `logIndex` MUST start at predecessor `treeSize` and
advance by one, and the final roots/tree size MUST equal the candidate ADH1. A witness
recomputes that complete `(appendLogMerkleRoot32, currentValueMapRoot32, treeSize)`
triple before signing the full unsigned head below. A head is committed and
distributable only after its threshold is complete;
partial map state, partial log state and a threshold-incomplete head are never lookup
results. Crash recovery either republishes the byte-identical committed triple or
discards the uncommitted batch.

Public mirrors expose ADH1 roots and consistency proofs, never transition
preimages, stable leaf keys or a downloadable leaf-key index. The exact transition
and inclusion path are disclosed only inside an oblivious ADP1 `CurrentValue`
response to a requester already holding `directoryLookupKey32`. Witnesses and the
directory threshold necessarily see the mapping; a holder of one DID1 can observe
that DID's current generation when actively resolving it, but cannot passively scan
all account-update timing from the public log. This is an explicit metadata boundary,
not a zero-knowledge claim.

Every ADH1 witness verifies that tag 7 resolves to the exact XNA1 whose canonical
tags 7..14 derive tag 8 `witnessPolicyHash32`; count, threshold, key generation and
failure domains come only from that XNA1. Each sorted witness signs the identical complete unsigned
ADH1 tags 1..11 (count/signature tags omitted):

```text
Ed25519.Sign(
  witnessKey,
  SIGINPUT("Deep/AccountDirectory/V1/ADH1/witness", 0x0201,
           unsignedADH1))
```

Cross-policy/key-generation, duplicate/unsorted signer, partial-field and
root-triple-only signatures reject. Network, predecessor, generations, both roots,
tree size, validity, reader floor and witness policy are therefore inseparable.

`ADH1CoreHash32 = SHA256-D("Deep/AccountDirectory/V1/ADH1/core", exact
unsigned tags 1..11)` and `ADH1CoreRef38 = ASCII("ADH1") || U16BE(1) ||
ADH1CoreHash32`. Predecessor, LKG, DTT, group/contact closure and forward-checkpoint
fields use this stable core. Valid witness receipt subsets may aggregate by witness
ID and do not create another head; different unsigned bytes at one generation/tree
size are a fork.

### 2.3 `ADP1` lookup proof and `ADL1` capability

ADL1 is shared in DCB1:

```text
networkId16, directoryLookupKey32, minimumAdhGeneration:u64
minimumAdhHash32, serviceProfile:u16
exactOhttpXOD1CoreRef38, exactOhttpXOD1CoreHash32
```

`serviceProfile` is `1=XPointOnly`, `2=OhttpOnly`, `3=Either`. XOD1 fields are
nonzero exactly when OHTTP is allowed and its purpose is `AccountDirectory`; DTT1
requests use a separate XOD1 with purpose `LiveTimeAttestation`. Unknown profile,
omitted descriptor, purpose substitution or descriptor below the protected XCC1
catalog root rejects before lookup.

OHTTP transport framing is not redefined here. An account-directory request is the
exact `XOQ1` `AccountDirectory` union and its response is exact `XOR1` containing
ADP1; a live-time request is the exact `XOQ1` `LiveTimeAttestation` union and its
response is exact `XOR1` containing DTT1. Both records, replay keys and padding are
owned exclusively by `CIRCUMVENTION-CARRIERS-V1.md`.

`ADP1`, version 1, suite `0x0201`, is the only lookup result. Its exact canonical
tags are:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | result kind | `u8`: `1=CurrentValue`, `2=NonMembership` |
| 3 | queried directory leaf key | 32 |
| 4 | exact ADH1 | canonical bytes |
| 5 | caller LKG tree size | `u64`; zero iff tag 12 is 0 |
| 6 | caller LKG ADH1 core hash | 32; `ZERO32` iff tag 12 is 0 |
| 7 | consistency-proof node count | `u8`, `0..64` |
| 8 | consistency-proof nodes | exactly `32 * tag7` bytes |
| 9 | sparse-map bitmap | 32 |
| 10 | sparse-map sibling count | `u16`, `0..256` |
| 11 | sparse-map siblings | exactly `32 * tag10` bytes |
| 12 | has LKG | `u8`: 0 or 1; distinguishes no LKG from a valid empty tree |
| 13 | history proof mode | `u8`: `0=ConsistencyOrGenesis`, `1=ForwardCheckpoint` |
| 14 | exact AFP1 | empty for mode 0; canonical bytes for mode 1 |
| 15 | exact live DTT1 core hash | 32; DTT1 links tag 4 ADH1/current XNV1 |
| 16 | exact ADC1 | present only for CurrentValue |
| 17 | exact DID1 hash | 32, CurrentValue only |
| 18 | DID1 address public key | 32, CurrentValue only |
| 19 | exact DAB1 | canonical bytes, CurrentValue only |
| 20 | exact DPA1 | canonical bytes, CurrentValue only |
| 21 | exact DRS1 | canonical bytes, CurrentValue only |
| 22 | exact DMD1 | canonical bytes, CurrentValue only |
| 23 | DPD1 count | `u8`, CurrentValue only; equals DMD1 active-device count |
| 24 | sorted exact DPD1 records | `LP32(record)` repeated tag 23 times |
| 25 | exact directory transition | canonical bytes, CurrentValue only |
| 26 | append-log index | `u64`, CurrentValue only; equals transition logIndex |
| 27 | inclusion-proof node count | `u8`, `0..64`, CurrentValue only |
| 28 | inclusion-proof nodes | exactly `32 * tag27` bytes, CurrentValue only |

All unknown tags are forbidden. DPD1 records sort by their exact
device ID and must close the DMD1 active-device set without omission or addition.
`CurrentValue` proves the present leaf and the exact transition that appended its
ADC1. `NonMembership` omits every tag 16..28 and proves the empty leaf against the
same map root. Supplying a present leaf under kind 2, an empty leaf under kind 1,
duplicate/unsorted DPD1, or a present-only tag under kind 2 rejects.

A sparse-map proof is exactly ADP1 tags 9..11.
Bitmap bit `i` (MSB first in each byte) corresponds to level `i`, from leaf sibling
through root sibling; `1` means the corresponding non-default sibling is present in
the list. Siblings are listed in increasing level order. `siblingCount` MUST equal
the bitmap popcount and is bounded to 256. A zero bit supplies `empty[i]`. Left/right
placement is selected by bit `255-i` of `directoryLeafKey32`. The recomputed root
MUST equal ADH1 `currentValueMapRoot32`.

In mode 0 with `hasLkg=1`, both result kinds contain an RFC-6962 consistency proof
from exact caller LKG `treeSize/appendLogMerkleRoot32` to returned ADH1. A caller
without LKG uses pinned genesis plus live DTT1 and has zero consistency nodes. In
mode 1, tags 7/8 are zero/empty and exact AFP1 supplies the forward proof from a
present LKG. Append-log proof nodes
are exactly 32 bytes, ordered by RFC-6962, count-prefixed and bounded to 64 nodes per
list. Forward checkpoint never replaces the current-value/non-membership map proof.

No unauthenticated pagination or “latest” pointer is accepted. ADL1 has no wall-clock
expiry; its generation/hash is a rollback floor. A current ADH1 and one of the two
current-map result kinds are still mandatory and cannot be replaced by the floor.

## 3. Validation and freshness

For first contact the client obtains ADH1 from at least two acquisition paths when
available, verifies threshold signatures, requires `validUntil` to be current under
the secure-time rules below, then validates ADP1 and exact artifact closure. DCB1's
DPA/DRS/DMD/DAB and DCA publisher MUST match the current ADC1 exactly. A revoked DCA ID
or stale device fails before ML-KEM, storage or UI mutation.

An established contact verifies monotonic ADC1/ADH1 against protected LKG. Gossip
piggybacks `(generation, treeSize, headHash)` in ratcheted control events; a mismatch
requests complete fork evidence and pauses sending. Group commit packages include
each member's exact ADC1/ADH1 reference so an owner cannot select an unseen stale
device branch.

V1 fixes `revocationFreshnessTTL` at 86,400 seconds; policy may lower but never raise
it. After a successful ADP1 `CurrentValue` validation at secure interval `[L,U]` and
monotonic sample `M`, the client sets
`revocationDeadlineMonotonic = M + max(0, min(revocationFreshnessTTL,
ADH1.validUntil - U))`, using saturating unsigned subtraction. Reaching that
deadline, losing secure-time continuity, receiving a higher gossip floor, or failing
to obtain a proof enters `RevocationRefreshRequired`. In that state established
contacts fail closed for outbound envelope emission, new pre-key/ratchet setup,
contact acceptance, receipts that mutate remote state, and group membership/device
changes. Local history remains readable; newly received ciphertext may be retained
without an acknowledgement but is not used to advance trusted contact/group state.
The UI may queue a local draft but MUST NOT report it sent.

Only a fresh monotonic ADP1 returns `RevocationRefreshRequired -> Current`. A current
ADC1 that revokes the selected authorization/device enters
`RevokedAuthorization`; that exact authorization/device state is terminal. An
ADC/ADH generation conflict enters `DirectoryForkBlocked`. Neither state can be
cleared by retrying an older proof. `DirectoryForkBlocked` requires newer
root-authorized ADF1 resolution. Account recovery moves
`RevokedAuthorization -> ReEnrollmentPending -> Current` only through a strictly
higher account-signed ADC1 naming a newly enrolled DPA/device generation; it never
resurrects the revoked authorization. Offline account
creation and local account use do not enter this state machine.

## 4. Trusted time and live current-head attestation

`DTS1`, version 1, suite `0x0001`, is the sole canonical preimage of
`timeSourcePolicyHash32`; the witness policy commits its exact hash but DTS1 never
contains a witness-policy/XNA1 hash, so the authority direction is acyclic:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | policy generation | `u64` |
| 3 | predecessor timeSourcePolicyHash32 | 32; zero only at generation 0 |
| 4 | source count | `u8`, `2..8` |
| 5 | sorted source entries | `LP16(entry)` repeated exactly tag 4 times; total `1..4096` |
| 6 | required source count | `u8`; exactly 2 for V1 |
| 7 | required distinct failure families | `u8`; exactly 2 for V1 |
| 8 | maximum resulting interval width seconds | `u32`; exactly 30 |
| 9 | maximum source-sample age seconds | `u16`, `1..30` |
| 10 | not-before | `u64` |
| 11 | expires-at | `u64`; `notBefore < expiresAt <= notBefore+2592000` |
| 12 | minimum reader | `u16` |
| 13 | root-authority generation | `u64`; resolves through protected XNA1 lineage |
| 14 | root-signature count | `u8`; XNA1 root threshold..root-key count |
| 15 | sorted root-key ID/signature entries | exactly `96 * tag14` bytes |

Each source entry is the closed sequence
`sourceId32 || failureFamilyHash32 || protocol:u16 || LP8(hostAscii[1..253]) ||
port:u16 || tlsSpkiSha25632 || maxRadiusSeconds:u16`. Protocol is exactly
`1=NTS-over-NTPv4` under RFC 8915; port is nonzero and `maxRadiusSeconds` is `1..10`.
Entries sort by source ID; IDs and `(host,port,SPKI)` tuples are unique, and the
policy contains at least tag-7 distinct nonzero failure-family hashes. Unknown
protocol, Unicode/noncanonical host, IP-literal host, shared failure family presented
as two families or an expired/predecessor-forked policy rejects.

Every root signer signs identical unsigned DTS1 tags 1..13 with
`SIGINPUT("Deep/AccountDirectory/V1/DTS1/root", 0x0001, unsignedDTS1)` using the
exact tag-13 XNA1 root key generation. `timeSourcePolicyHash32` is exactly
`SHA256-D("Deep/AccountDirectory/V1/time-source-policy", exact unsigned DTS1
tags 1..13)`. `DTS1PolicyCoreRef38 = ASCII("DTS1") || U16BE(1) ||
timeSourcePolicyHash32`; root-receipt subsets may aggregate and do not alter the
policy core. Genesis has generation zero and a zero predecessor. Every successor
increments the generation by exactly one and tag 3 equals the predecessor's
`timeSourcePolicyHash32`. Two different policy cores at one generation, or two
successors of one predecessor, fork-latch trusted time until the conflict is
resolved by a later clean-break protocol version. A witness
policy may commit a successor DTS1 only after its root threshold is complete; DTS1
does not select DTT witnesses and a DTT coordinator cannot author or override it.

`DTT1`, version 1, suite `0x0201`, is the only fresh-install current-time anchor.
It is a nonce-bound threshold response, never a cacheable “latest” object:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | client nonce | 32 nonzero CSPRNG bytes |
| 3 | observed Unix time | `u64` |
| 4 | uncertainty seconds | `u32`, `0..30` |
| 5 | exact current ADH1 core hash | 32 |
| 6 | current ADH1 generation | `u64` |
| 7 | exact current XNV1 hash | 32 |
| 8 | current XNV1 generation | `u64` |
| 9 | exact authorizing XNAAuthorityCoreRef38 | 38; stable authority-core reference |
| 10 | witness-policy hash | 32 |
| 11 | issued-at | `u64`; equals tag 3 within tag 4 uncertainty |
| 12 | expires-at | `u64`; `issuedAt < expiresAt <= issuedAt+60` |
| 13 | witness count | `u8`; policy threshold..witness count |
| 14 | sorted witness receipts | exactly `96 * tag13` bytes |

Each receipt is `witnessId32 || signature64`, sorted by witness ID, and signs
`SIGINPUT("Deep/AccountDirectory/V1/DTT1/live-time", 0x0201,
unsignedDTT1 tags 1..12)`. Witnesses issue it only for a just-received unique nonce
and exact currently committed ADH1/XNV1 under tag 9 policy. A nonce is never reused
by a client; another nonce, expired response, changed same-generation head, unknown
policy/key generation or non-current linked head rejects.

`DTT1CoreHash32 = SHA256-D("Deep/AccountDirectory/V1/DTT1/core", exact
unsigned tags 1..12)`. Every field named DTT1 hash uses this core; valid witness
receipt subsets may aggregate without changing the attested time/head tuple.

The witness policy contains the exact current DTS1-derived
`timeSourcePolicyHash32`. Every witness maintains
protected `witnessTimeInterval=[WL,WU]` from at least two authenticated UTC sources in
different signed failure families, advances both bounds only by a monotonic clock,
persists the greatest lower bound, and enters `TimeSourceUnavailable` after rollback,
boot discontinuity without re-attestation, source-family collapse, interval width
greater than 30 seconds or empty source intersection. OS wall time alone is never a
witness source. Source protocols, endpoints, SPKI keys, radius bounds and failure
families come only from exact DTS1; they cannot be selected by the DTT coordinator.
For each source, the witness verifies the exact NTS server identity/SPKI, rejects a
reported radius above that source entry's bound, rejects a sample older than DTS1
tag 9 by its protected monotonic receive age, and intersects samples only after both
the required source count and required distinct-family count are met. DNS, an
unauthenticated NTP packet, the coordinator and duplicate endpoints contribute no
time interval.

The coordinator proposes one complete unsigned DTT1. Before signing, each witness
derives `proposed=[observedAt-uncertainty, observedAt+uncertainty]`, advances its own
protected interval to the signing monotonic sample, and requires `proposed` to be a
non-empty subset of its own `[WL,WU]`. It also requires `issuedAt` inside `proposed`,
the exact nonce to be outstanding and unused, and both linked heads to equal its
locally committed current heads. It signs no coordinator-supplied time/source fact
that was not independently checked. All threshold witnesses sign byte-identical tags
1..12; if no common proposed interval satisfies every signer, no DTT1 exists and the
request fails closed. A witness durably consumes `(policyHash, nonce)` before
returning its signature, so crash/retry returns only the byte-identical signature.

The client records monotonic `nonceCreatedAt` before dispatch and accepts the first
valid response only by `nonceCreatedAt+30s`; later responses for that nonce are
discarded even if their signed window is wider. It persists accepted DTT1 and the
resulting interval atomically before authorizing mutation. Thus freshness derives
from an unpredictable live challenge plus a bounded local round trip, not from the
fresh install's wall clock.

The DTT1 interval is exactly
`[observedAt-uncertainty, observedAt+uncertainty]` with saturating subtraction.
ADH1/XNV1 windows are artifact validity bounds and MUST NOT be used as time
observations or to prove their own freshness. A fresh install obtains DTT1 through
XPoint or the exact OHTTP profile, verifies its nonce/threshold, then requires its
exact linked ADH1/XNV1. Without DTT1 it remains `RecoveryRequired`: offline account
creation/history stay available, but first-contact, network, mailbox, pre-key, group
and call mutations are forbidden.

The protected state is
`secureTimeInterval = (lowerUnix:u64, upperUnix:u64, monotonicSample, bootId,
sourceSetHash32)`, plus the greatest previously persisted `lowerUnix` as an
independent rollback floor. Bounds are inclusive. During one boot, before every use,
both bounds advance by the exact non-negative monotonic elapsed seconds. After a boot
change the persisted lower bound remains a floor, while the old upper bound becomes
unknown until authenticated sources re-establish it; OS wall time never supplies a
floor or upper bound.

After signature, authority-lineage and predecessor checks that do not depend on wall
time, only DTT1 contributes a new authenticated time interval. Its linked ADH1/XNV1
contribute validity constraints, not time observations. For protected state, one new
DTT1 interval may be merged with the advanced protected interval. Inputs are sorted
by exact DTT1 hash and merged exactly as:

```text
mergedLower = max(protectedRollbackFloor, all input lower bounds)
mergedUpper = min(all finite input upper bounds)
sourceSetHash32 = SHA256-D(
  "Deep/AccountDirectory/V1/secure-time-attestations",
  U16BE(sourceCount) || sortedExactSourceHashes)
```

The merge succeeds only when `mergedLower <= mergedUpper`; otherwise it makes no
state change and enters `ClockCorrectionRequired`. A successful merge replaces the
stored interval atomically and cannot widen it except by monotonic advancement.
Artifact time validation succeeds only when the complete merged interval lies within
`[artifact.validFrom - 600, artifact.validUntil + 600]` using saturating unsigned
arithmetic. Thus uncertainty fails closed near either boundary and a signed hint can
neither move the protected lower bound backward nor extend signed expiry.

An OS clock outside the merged authenticated interval is a displayed clock warning,
not an alternate merge input. If authenticated DTT1/protected inputs cannot establish a
non-empty interval, the client enters `ClockCorrectionRequired`; it may perform
read-only bootstrap but MUST NOT authorize account-directory, node, pre-key or
mailbox mutation. Account creation remains fully offline and independent of secure
time.

## 5. Retention and recovery

Witnesses apply the `ADC1/ADH1 account-directory history` and indefinite root-lineage
classes from `RETENTION-AND-RECOVERY-V1.md`; this document does not redefine
their limits.

`ADF1`, version 1, root suite `0x0001`, is the canonical beyond-horizon
account-directory forward checkpoint:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | checkpoint generation | `u64` |
| 3 | predecessor ADF1 core hash | 32; zero only at generation 0 |
| 4 | covered first ADH generation | `u64` |
| 5 | covered last ADH generation | `u64`, >= tag 4 |
| 6 | covered-head count | `u64`, nonzero |
| 7 | covered-head Merkle root | 32 |
| 8 | target ADH1CoreRef38 | 38 |
| 9 | target tree size | `u64` |
| 10 | target append-log root | 32 |
| 11 | target current-value map root | 32 |
| 12 | authority XNAAuthorityCoreRef38 | 38 |
| 13 | issued-at | `u64` |
| 14 | minimum reader | `u16` |
| 15 | root-signature count | `u8`; XNA root threshold..root-key count |
| 16 | sorted root-key ID/signature entries | exactly `96 * tag15` bytes |

`AFP1`, version 1, suite `0x0201`, is the exact ADP1 tag-14 proof package:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | source LKG ADH generation/tree size/hash | `u64 || u64 || 32` |
| 3 | target ADH1 core hash | 32; equals core derived from ADP1 tag 4 |
| 4 | XNA1 authority-chain count | `u8`, `1..64` |
| 5 | ordered exact XNA1 authority chain | repeated `LP32(record)` |
| 6 | ADF1 count | `u8`, `1..64` |
| 7 | ordered exact predecessor-linked ADF1 chain | repeated `LP32(record)` |
| 8 | source leaf index | `u64` |
| 9 | source-membership node count | `u8`, `0..64` |
| 10 | RFC-6962 membership nodes | exactly `32 * tag9` bytes |
| 11 | exact live DTT1 core hash | 32; equals ADP1 tag 15 |

The source tuple exactly equals protected LKG. The authority chain begins at the
pinned/protected XNA1 and continues through the authority referenced by the last
ADF1. It contains, in successor order, every XNA authority core referenced by tag
12 of any ADF1 carried in AFP1 tag 7,
including the target-head authority equality below, and no unused authority record;
each ADF signature resolves against its own
authority key IDs/generations before its predecessor transition verifies. Tag 8 is less
than that first ADF1 tag-6 covered-head count and selects the exact sorted source
leaf; the RFC-6962 path in tags 9/10 is verified with both this index and count
against ADF1 tag 7. Counts, record lengths and membership path are closed;
omitted/extra records or a wrong index reject.

The covered-head tree uses RFC-6962 over leaves
`SHA256(0x00 || U64BE(adhGeneration) || U64BE(treeSize) || exactADH1Hash32)`, sorted
by `(adhGeneration, treeSize, exactADH1Hash32)`. It contains every threshold-valid
source head from which this checkpoint authorizes a forward merge, including an
explicitly resolved branch when emergency recovery settles a fork. Duplicate tuples
reject. ADF1 tag 8 resolves to a threshold-valid ADH1 envelope whose core matches
the reference and whose three committed
values exactly equal the target values in ADF1 and whose generation is greater than
every covered source generation.

ADF1 tag 12 resolves to a threshold-complete XNA1 envelope
whose exact authority core supplies the root key set and threshold that sign
ADF1. Every root signature covers
`SIGINPUT("Deep/AccountDirectory/V1/ADF1/root", 0x0001, unsignedADF1 tags
1..14)`. ADF1 tag 12 MUST equal the authorizing XNA authority-core ref in its exact
target ADH1 tag 7, and the ADH1 policy hash must equal that XNA1 policy derivation.
`ADF1CoreHash32 = SHA256-D("Deep/AccountDirectory/V1/ADF1/core", exact
unsigned tags 1..14)`; tag 3 and AFP predecessor verification use this core. Root
receipt subsets may aggregate without changing checkpoint identity.
AFP1
contains the exact XNA1 authority-successor chain from the client's pinned or
protected authority through every authority referenced by the complete ADF chain,
an RFC-6962 membership proof for the client's exact
LKG ADH1 tuple in the first applicable ADF1, and the exact predecessor-linked ADF1
chain to the target. ADF1 records, authority lineage and the membership proof material
are retained indefinitely; a missing link or proof fails closed.

Merge never unions map states. After all signatures, authority lineage, source-head
membership, ADF predecessor hashes and target ADH1 are verified, the client atomically
replaces its directory floor with the strictly newer target ADH1, retains its old LKG
and the accepted ADF1 chain as fork evidence, and then requires a normal ADP1 current
map proof for the queried key. Same-generation changed ADF1 bytes or two successors
of one ADF1 permanently fork-latch recovery. An ADF1 whose covered set omits the
client's exact LKG cannot advance that client.

Beyond the retained operational horizon, recovery authority publishes a new
account-signed ADC1 through the normal atomic map/log transition and clients use the
ADF1 procedure. This restores account/control trust, not old contacts or content.

## 6. Required gates

1. Fresh sender rejects a stale DMD1/DCB1 signed by a later-revoked publisher.
2. Same-generation fork, split-view witness and selective proof omission fail closed.
3. OHTTP/XPoint captures show no single directory component sees source IP and leaf
   key; this is a non-collusion property, not global anonymity.
4. Current-value substitution and authenticated non-membership proofs fail against
   the same ADH1 map root.
5. Crash at every map/log/head commit boundary exposes either the old committed triple
   or the new committed triple, never a mixed state.
6. 30/180/365-day consistency fixtures and beyond-horizon ADF1 root recovery,
   including an omitted-LKG and same-generation-fork negative fixture.
7. Clock rollback, reboot, wrong clock, disjoint signed intervals, deterministic
   interval merge and protected-floor restore.
8. Established-contact revocation TTL expiry fails closed and resumes only from a
   fresh monotonic proof.
9. 10,000-contact lookup/load and proof-size bounds on the weakest Android target.
