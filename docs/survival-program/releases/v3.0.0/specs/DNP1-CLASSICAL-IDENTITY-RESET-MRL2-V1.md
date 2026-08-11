# DNP1 Classical Identity, Reset and Native Routing V1

Status: **normative clean-break specification; implementation not yet
authorized by this document**.

Work package: `DNP1-PROTO-classical-identity-reset-routing`.

Decision: [DR-0003](../../../decisions/DR-0003-deep-native-session-clean-break.md).

Machine registry:
[`dnp1-classical-v1.registry.json`](dnp1-classical-v1.registry.json).
Negative-vector skeleton:
[`dnp1-classical-v1.vectors.skeleton.json`](dnp1-classical-v1.vectors.skeleton.json).

This specification is the reviewed Wave 1 classical identity-authentication,
anti-rollback and native peer-contact baseline. It does not define message
confidentiality, a ratchet or a post-quantum production provider. The
experimental suites in
[`DEEP-CRYPTO-V1-DRAFT.md`](DEEP-CRYPTO-V1-DRAFT.md) remain dark-path only and
are not accepted by any grammar in this specification.

## 1. Clean-break boundary

- `IdentityAuthV1Ed25519 = 0x0001` is the only accepted public authentication
  suite. Every other suite, including `0x0101` and `0x0102`, is rejected before
  allocation or a cryptographic callback.
- Existing reviewed D--G route-continuity artifacts, `MNG1`, `MDG1`, `MRV1`,
  `MMC1`, `MSM1`, `PRQ2`, `MRR2`, PMA and PMR retain their exact bytes, domains
  and public APIs. They are referenced externally; they are not versioned or
  extended here.
- Session identities, onion contacts, storage IDs, compatibility branches and
  databases are not migrated. A consumer activates this baseline only after a
  destructive, manifest-bound reset.
- Ed25519 signing keys and X25519 agreement keys are generated independently.
  Ed25519-to-X25519 conversion is forbidden.

## 2. Canonical grammar

Public records use a 12-byte header:

```text
magic[4] || version:u16be || authSuite:u16be || fieldCount:u16be || reserved:u16be
```

`reserved` is zero. Protected records use the same header with
`integritySuite = 0x8001` for HMAC-SHA-256. Each field is:

```text
tag:u16be || flags:u16be || length:u32be || value[length]
```

Tags are exactly `0x0001..fieldCount` in the order in the machine registry.
Flags are zero. Unknown, missing, duplicate or out-of-order tags, nonzero
reserved bytes, inconsistent lengths and trailing bytes are rejected before a
value copy. All additions use checked arithmetic and validate scalar/count
limits before allocation.

`ArtifactRef38` is:

```text
artifactType:u16be || canonicalLength:u32be || canonicalSha256[32]
```

The target is decoded and recomposed canonically, then its exact type, length
and domain-separated hash are compared. A zero reference is accepted only at
an explicitly named genesis predecessor.

`SHA256-D(domain,payload)` is exactly
`SHA256(U16BE(ASCII-byte-length(domain)) || ASCII(domain) ||
U32BE(payload-length) || payload)`. Every new artifact type has exactly one
closed mapping to `Deep/Artifact/V1/<magic>` in the machine registry and its
`ArtifactRef38.canonicalSha256` is `SHA256-D(mapped-domain,
exact-canonical-bytes)`. A missing, duplicate or cross-type mapping rejects.
The retained unchanged artifact types are verified by their unchanged
reviewed hash rules and cannot be reinterpreted through this mapping.
The closed retained type table also assigns exact `ArtifactRef38` IDs to MSM1,
PRQ2, MRR2, PMA1, PMR1, D--G source, MNG1, MDG1, MRV1 and MMC1. Their hash
bytes are computed by their unchanged reviewed canonical/source hash rules,
not by a new Wave 1 domain. A retained type without its named rule rejects.

For a signed TLV record, the unsigned canonical form omits every signature and
proof-of-possession TLV and decrements `fieldCount`; it never substitutes 64
zero bytes. The signature input is:

```text
U16BE(domainLength) || ASCII(domain) || U16BE(0x0001) ||
U32BE(unsignedLength) || unsignedCanonical
```

An external signer result is frozen once, required to be exactly 64 bytes,
verified locally with Sodium and used only from that owned copy.

The header suite is closed by record class. `0x0001` authenticates DPA, DPD,
DPM, DRS, KRT, KRF, DCM, DRA, DWD, DCP, DCS, DCT, DCN, DCQ, DHL, DCL, DNR,
DPC, DPR and DPS (including receipt-authenticated composites). `0x0000` is not
an authentication suite and is accepted only for the committed unsigned DRT
and MRL2 records. `0x8001` is HMAC-SHA-256 and is accepted only for DPL, DBG,
RIB, XIB, DWL, MRLC and DPJ. `0x8002` is accepted only for the AEAD-protected
DRC; its canonical metadata is authenticated as associated data and the final
16 bytes are the XChaCha20-Poly1305 tag. DXP is the sole fixed transcript and
has no 12-byte TLV header. Every record/suite cross-feed rejects before a
cryptographic callback.

The complete domain registry is closed for Wave 1:

```text
Deep/IdentityAuth/V1/account-certificate
Deep/IdentityAuth/V1/device-certificate
Deep/IdentityAuth/V1/mailbox-role-certificate
Deep/IdentityAuth/V1/account-id
Deep/IdentityAuth/V1/revocation-target-hash
Deep/IdentityAuth/V1/revocation-snapshot
Deep/IdentityAuth/V1/revocation-entry-head
Deep/IdentityAuth/V1/key-rotation
Deep/IdentityAuth/V1/key-revocation
Deep/IdentityAuth/V1/x25519-pop-salt
Deep/IdentityAuth/V1/x25519-pop-key/device
Deep/IdentityAuth/V1/x25519-pop-key/router
Deep/IdentityAuth/V1/x25519-pop-transcript-hash
Deep/IdentityAuth/V1/mailbox-owner-id
Deep/Artifact/V1/DPA1
Deep/Artifact/V1/DPD1
Deep/Artifact/V1/DPM1
Deep/Artifact/V1/DRT1
Deep/Artifact/V1/DRS1
Deep/Artifact/V1/KRT1
Deep/Artifact/V1/KRF1
Deep/Artifact/V1/DCM1
Deep/Artifact/V1/DRA1
Deep/Artifact/V1/DWD1
Deep/Artifact/V1/DCP1
Deep/Artifact/V1/DCS1
Deep/Artifact/V1/DCT1
Deep/Artifact/V1/DCN1
Deep/Artifact/V1/DCQ1
Deep/Artifact/V1/DHL1
Deep/Artifact/V1/DCL1
Deep/Artifact/V1/DWL1
Deep/Artifact/V1/DRC1
Deep/Artifact/V1/DPL1
Deep/Artifact/V1/DBG1
Deep/Artifact/V1/RIB1
Deep/Artifact/V1/XIB1
Deep/Artifact/V1/DNR1
Deep/Artifact/V1/MRL2
Deep/Artifact/V1/DPC1
Deep/Artifact/V1/DPR1
Deep/Artifact/V1/DPS1
Deep/Artifact/V1/DPJ1
Deep/Cutover/V1/manifest
Deep/Cutover/V1/account-reset
Deep/Cutover/V1/witness-delegation
Deep/Cutover/V1/component-checkpoint
Deep/Cutover/V1/deployment-set
Deep/Cutover/V1/cas-transcript
Deep/Cutover/V1/witness-receipt
Deep/Cutover/V1/quorum-receipt
Deep/Cutover/V1/head-lease
Deep/Cutover/V1/quorum-lease
Deep/Cutover/V1/deployment-subject
Deep/Cutover/V1/component-subject
Deep/Cutover/V1/witness-set-root
Deep/Cutover/V1/witness-heads
Deep/Cutover/V1/witness-log-leaf
Deep/Cutover/V1/witness-log-node
Deep/Cutover/V1/witness-log-head
Deep/Cutover/V1/witness-empty-root
Deep/Cutover/V1/quorum-digest
Deep/Cutover/V1/lease-digest
Deep/Cutover/V1/recovery-capsule
Deep/Cutover/V1/recovery-aead
Deep/Cutover/V1/recovery-kdf-salt
Deep/Cutover/V1/recovery-aead-key
Deep/Cutover/V1/recovery-aead-nonce
Deep/Cutover/V1/recovery-drm-hash
Deep/Cutover/V1/recovery-shadow-state
Deep/Cutover/V1/recovery-pin-core
Deep/NativeRouting/V1/router-certificate
Deep/NativeRouting/V1/router-id
Deep/NativeRouting/V1/contact
Deep/NativeRouting/V1/request
Deep/NativeRouting/V1/response
Deep/NativeRouting/V2/mrl2-canonical-hash
Deep/NativeRouting/V2/mrl-leaf
Deep/NativeRouting/V2/mrl-node
Deep/NativeRouting/V2/mrl-root
Deep/NativeRouting/V2/membership-closure
Deep/NativeRouting/V2/membership-transition-container
Deep/NativeRouting/V2/composite-selection
Deep/NativeRouting/V2/catalog-hash
Deep/NativeRouting/V1/outer-journal-key
Deep/ProtectedState/V1/DPL1
Deep/ProtectedState/V1/DDBG1
Deep/ProtectedState/V1/DRIB1
Deep/ProtectedState/V1/DXIB1
Deep/ProtectedState/V1/DWL1
Deep/ProtectedState/V1/MRLC1
Deep/ProtectedState/V1/DPJ1
```

The exact type numbers, magics, domains, field order and arithmetic are in the
machine registry. The required headline lengths are:

| Artifact | Exact length |
|---|---:|
| `DPA1` | 644 |
| `DPD1` | 776 |
| `DPM1` | 670 |
| `DRT1` | 179 |
| `DRS1` | `356 + 62*N`, `0 <= N <= 1024`, maximum 63,844 |
| `KRT1` / `KRF1` | 412 / 300 |
| `DCM1` / `DRA1` | 812 / 788 |
| `DWD1` / `DCP1` / `DCS1` / `DCT1` | 1,217 / 706 / 839 / 414 |
| `DCN1` | `555 + 32*(P+Q)`, `P,Q <= 32`, maximum 2,603 |
| `DCQ1` | `375 + receiptBlob`, exactly three receipts, maximum 8,196 |
| `DHL1` / `DCL1` | `507 + 32*Q`, maximum 1,531 / maximum 4,974 |
| `DWL1` / `DRC1` / `DPL1` | 708 / `482 + ciphertext` / 576 |
| `DBG1` / `RIB1` / `XIB1` | 296 / 772 / 452 |
| `DNR1` / `MRL2` | 756 / 326 |
| `DPC1` | `427 + addressLength`; IPv4 431, IPv6 443, DNS 430..680 |
| `DXP1` | fixed transcript 168 |
| `DPR1` / `DPS1` | 408 / 444; successful response frame 748 |
| `MRLC1` | `898 + catalogBytes`, maximum 16,778,114 |
| `DPJ1` | 609 |

## 3. Identity and key authority

`DPA1` binds one account generation to pairwise-distinct account,
device-certificate-issuer, revocation and reset-control Ed25519 keys. The
account key self-signs and the other three keys prove possession over the same
unsigned bytes. `DeepAccountId` is a domain-separated hash of network,
generation and account key.

`KRT1` rotates a release-root, device-issuer, revocation or reset-control key.
The old key signs and the new key proves possession. `KRF1` terminally revokes
one role. Generations advance exactly by one and bind the predecessor. A
same-generation byte change or ancestry conflict sets a permanent fork latch.

`DPD1` binds independent device Ed25519 and X25519 keys, a random device ID and
random 32-byte revocation handle. `DPM1` binds a mailbox role key and its own
random revocation handle to an exact `DPD1`; the device authorizes and the role
key proves possession. Their observed DRS revision/reference/count/head must be
the exact current snapshot at issuance.

`mailboxOwnerId32` is nonzero and equals
`SHA256-D(Deep/IdentityAuth/V1/mailbox-owner-id,
network16||accountHash32||DPMCRef38||mailboxEd25519Public32)`. `routerId32` is
nonzero and equals `SHA256-D(Deep/NativeRouting/V1/router-id,
network16||mailboxOwnerId32||routerGeneration:u64be||routerEd25519Public32)`.
The canonical certificate preimage is retained with the ID. Within one network
and account, the same owner ID with a different preimage latches the account;
within one network, the same router ID with a different preimage latches the
routing domain. Zero IDs, caller-selected IDs and silently regenerated IDs are
invalid.

The exact `DXP1` possession transcript is:

```text
"DXP1" || version:1 || role:1 || reserved:2 || network[16] ||
subjectUnsignedCanonicalHash[32] || holderX25519Public[32] ||
issuerEphemeralPublic[32] || nonce[32] || issuedAt:u64be || expiresAt:u64be
```

It is 168 bytes. The window is at most 300 seconds. The holder derives an
X25519 shared secret, an HKDF-SHA-256 key under the registry domain and returns
HMAC-SHA-256 over `U32BE(168)||DXP1`. The issuer independently verifies it,
stores the domain hash of transcript plus proof, and erases the ephemeral
private key, shared secret, HKDF key and proof. All-zero/low-order results,
role/network/subject changes and nonce reuse reject.

## 4. Revocation and account reset

`DRT1` is private catalog data. Public `DRS1` entries contain only its typed
hash. A DRS entry is exactly 62 bytes:

```text
targetKind:1 || DRT1Ref:38 || targetGeneration:u64be ||
revokedAt:u64be || reason:u16be || reserved[5]
```

The chained head is
`SHA256-D(Deep/IdentityAuth/V1/revocation-entry-head,
accountTuple||index:u64be||previousHead||entry)`. One current signed cumulative
snapshot retains at most 1,024 entries and is replayed in O(N). Ordinary
entries stop at 1,023. `AccountTerminal` may be the final entry at any
`N=1..1024`; no successor is valid.

`snapshotRevision` is independent of entry count. A successor increments the
revision and performs exactly one action: append one entry under the same key,
or re-sign byte-identical entries/head after one exact `KRT1` revocation-key
rotation. Combining them, skipping a revision or changing bytes at the same
revision is a fork.

An `AccountTerminal` DRT targets the exact `DPA1`, uses its random account
revocation handle and uses `targetNotAfter=0` as the only permitted zero
sentinel. It and the terminal DRS remain until a verified reset cutoff plus the
rollback horizon, then compact only to an authenticated terminal tombstone.
Other DRT records require nonzero `targetNotAfter` and remain through that time
plus the horizon. DRT bytes never enter node wire, logs or diagnostics.

Before DNRC issue/verify, membership acceptance, DPC use, DPR processing or
replay, the consumer restores the current DCP/DCM/DRS and protected DRT
catalog, reconstructs the observed issuance prefix and proves absence of
account, device and mailbox revocation. The result is sealed to the exact
current DCP/DCM/DRS fingerprint; any advance invalidates it.

`DRA1` is the sole account-generation reset. It binds the complete old
DPAC/DCM/DRS tuple to `newAccountGeneration=old+1`, a new DPAC, new DCM, cutoff
and nonce. Old reset-control authorizes it; new account and reset keys prove
possession. The new external DCP exact-references the DRA. No state migration
or implicit fork-latch clearing exists.

## 5. External monotonic witness

A root key is never online for each account update. `DWD1` is a time-bounded
release-root-authorized set of exactly four distinct witness descriptors. Each
descriptor fixes witness ID, Ed25519 key, public IP endpoint, port and TLS SPKI;
all four prove possession. Wave 1 assumes at most one Byzantine witness and
requires 3-of-4 receipts.

Each descriptor is exactly 116 bytes:
`witnessId32||Ed25519Public32||endpointKind1||reservedZero1||address16||port2||TLS-SPKI32`.
IPv4 occupies the first four address bytes and requires a zero tail. A DWD
rotation advances exactly by one from the signed predecessor. Retained witness
heads copy byte-exact; a newly added witness starts only from a DWD-authorized
genesis head and cannot vote until its inclusion/consistency bootstrap is
verified; a removed witness remains in historical LKG evidence but cannot vote
in the successor epoch.

`DWD1.maximumTreeSize` is nonzero, at most `2^32`, never decreases for a
retained witness and fences every receipt, proof and lease before signature
verification. The predecessor-final-heads commitment is
`SHA256-D(Deep/Cutover/V1/witness-heads,
predecessorEpoch:u64be||fourSortedHeads288)`. A successor set root is
`SHA256-D(Deep/Cutover/V1/witness-set-root,
witnessEpoch:u64be||witnessCount:u8=4||fourSortedDescriptors464)`.
Rotation requires the exact predecessor `DWD1` reference, the exact final four
heads commitment, an old release-root signature and all four successor witness
PoPs. For a new witness the authorized genesis head is tree size zero and the
domain-separated empty root
`SHA256-D(Deep/Cutover/V1/witness-empty-root,
witnessEpoch:u64be||witnessId32||maximumTreeSize:u64be||
treeSize:u64be=0)`; a removed witness's final head remains in the historical
`DWL1`. Epoch reuse, retained-head rollback, tree growth beyond the old or new
minimum fence, and activation before all replacement bootstrap proofs latch the
deployment fork.

The deployment subject is:

```text
SHA256-D(Deep/Cutover/V1/deployment-subject,
network||accountHash||resetId)
```

The exact component subject is
`SHA256-D(Deep/Cutover/V1/component-subject,
network16||accountHash32||componentKind:u16be||accountRevocationHandle32)`.
Witness tree and quorum transcripts are exact:

```text
leaf = SHA256-D(Deep/Cutover/V1/witness-log-leaf,
       deploymentSubject32||sequence:u64be||DCSRef38||DCTRef38)
node = SHA256-D(Deep/Cutover/V1/witness-log-node,
       level:u16be||nodeIndex:u64be||left32||right32)
head = SHA256-D(Deep/Cutover/V1/witness-log-head,
       witnessEpoch:u64be||treeSize:u64be||treeRoot32)
quorumDigest = SHA256-D(Deep/Cutover/V1/quorum-digest,
       deploymentSubject32||sequence:u64be||DCSRef38||DCTRef38||
       threeOrderedDCNRefs114)
leaseDigest = SHA256-D(Deep/Cutover/V1/lease-digest,
       deploymentSubject32||sequence:u64be||DCSRef38||queryNonce32||
       threeOrderedDHLRefs114)
```

The tree uses RFC6962-style left-balanced splitting, but never its domains:
the real-leaf and internal-node formulas above are the only accepted formulas.
Proof indices, sizes and levels are unsigned big-endian and checked against
`maximumTreeSize` before reading any proof hashes.

Each DRS successor is first represented by four component `DCP1` records. A
single `DCS1` binds the common account/DCM/transaction and exactly four sorted
rows `componentKind||componentSubject||DCP1Ref||schemaFingerprint`. The
canonical dependency order is acyclic:

```text
DCP1[4] -> DCS1 -> DCT1 -> DCN1/DCQ1 -> local DPL1
```

A DCP cannot reference the DCS that references it. The protected DPL binds both
after the quorum receipt exists.

`DCT1` performs one external CAS
`(deploymentSubject, expectedSequence, expectedDCSRef) -> candidateDCSRef`.
An honest witness keeps one head per subject and never signs two candidates at
the same sequence. Three-of-four quorums intersect in at least two witnesses
and therefore at least one honest witness. Conflicting signed evidence sets a
global fork latch.

Each `DCN1` proves inclusion in that witness's append-only tree, consistency
from the caller's retained tree head, exact DCP/DCS/DCT/key/TTL validation and
fsync durability of both checkpoint and referenced recovery capsule. `DCQ1`
contains exactly three ordered distinct receipts. A fresh `DHL1` also binds the
caller's prior tree size/root and a consistency proof; `DCL1` requires three
matching current subject sequence/DCS heads. Sensitive issue/use requires a
fresh lease. Offline operation stops when the lease expires.

`DWL1` retains all four 72-byte heads
`witnessId32||treeSize8||treeRoot32`. A 3-of-4 DCL updates exactly its three
returned heads and carries the fourth forward unchanged. Omitting the fourth
head is invalid because a later quorum may contain that witness.

Crash-safe publication order is mandatory:

1. Reserve durable idempotent HSM keys and a content-addressed recovery capsule.
2. Write immutable component shadow generations and fsync data/catalogs.
3. Write and fsync `PREPARE` with exact old/new hashes and transaction ID.
4. Execute the one DCS external CAS and verify the 3-of-4 DCQ.
5. Verify the capsule and receipt, write and fsync `COMMIT`.
6. Atomically switch each component's full local pointer.
7. Author or use credentials only after the common activation time and a fresh
   lease over the same DCS.

A crash before CAS leaves the old state current. A committed external head with
valid shadow state exact-replays COMMIT. An external head ahead of missing or
corrupt shadow/capsule fails closed as `ExternalCheckpointAhead`; it never
rolls back. A component that has not completed its local atomic switch exposes
nothing. The external witnesses observe stable per-account-generation update
frequency; the privacy limitation is accepted and must be documented.

`DRC1` cannot reference DCP or DPL because DCP references the capsule and DPL
references DCP. It instead binds the exact DCM/DRS, shadow hash and a
`nextPinCoreHash` that excludes DCP/DCS/DCQ references. Its DRM plaintext is a
sorted unique bounded artifact table, protected with the already reviewed
XChaCha20-Poly1305 recovery protector. It carries no exported private key.

The protector is nevertheless frozen here so independent implementations
cannot diverge. Suite `1` is XChaCha20-Poly1305-IETF with HKDF-SHA-512. Input
key material is the nonexportable `DeepRecoveryV1` 32-byte backup-wrapping
seed. `transactionId32` is CSPRNG output unique per component subject and
account generation. Compute:

```text
salt = SHA512(U16BE(len("Deep/Cutover/V1/recovery-kdf-salt")) ||
       ASCII("Deep/Cutover/V1/recovery-kdf-salt") || network16 ||
       componentSubject32 || transactionId32)
prk = HKDF-SHA-512-Extract(salt, backupWrappingSeed32)
key = HKDF-SHA-512-Expand(prk,
      U16BE(len("Deep/Cutover/V1/recovery-aead-key")) ||
      ASCII("Deep/Cutover/V1/recovery-aead-key") || protectorKeyId32, 32)
nonce = HKDF-SHA-512-Expand(prk,
        U16BE(len("Deep/Cutover/V1/recovery-aead-nonce")) ||
        ASCII("Deep/Cutover/V1/recovery-aead-nonce") || protectorKeyId32, 24)
AD = U32BE(metadataLength) ||
     canonical DRC1 fields 1..15 encoded with fieldCount=15
```

`DRM1` plaintext is `"DRM1"||version:u8=1||reserved:u8=0||
artifactCount:u16be`, followed by sorted unique rows
`artifactType:u16be||length:u32be||canonicalHash32||exactBytes`; count is
`0..64` and plaintext/ciphertext are bounded by the registry before
allocation. `DRMHash`, `shadowStateHash`, and `nextPinCoreHash` use exactly
the three recovery hash transcripts in the registry. Reusing a derived nonce
for different metadata/ciphertext latches the recovery key. Decryption order
is fixed: metadata preflight; checked lengths/counts; derive and compare nonce;
freeze AD; bounded AEAD open; zero PRK/key; DRM preflight; every canonical row
hash; required-artifact and Protocol restore; shadow/pin-core compare; only
then authorize COMMIT. No parser or callback runs before its bound is known.

## 6. Independent membership and mailbox authority

The MRLC protected catalog contains two independent verified closures:

1. exact `MNG1` genesis plus the complete ordered signed `MDG1`/`MRV1`
   delegation/revocation chain, yielding the sealed signer set that alone
   verifies `MSM1/MMC1`;
2. exact current PMA/PMR closure, yielding the issuer that alone verifies
   `DNR1`.

No signer authority is inferred across the two chains. The required join is
`PMA.CurrentEpoch.MembershipCommitment == verified MSM/MMC MRL2 root`.
Protected state retains both LKGs and one atomic composite-selection record
binding network, exact MSM sequence/hash/member count/root, PMA hash/generation
and epoch, PMR generation/head/snapshot hash, and DNRC hash/role/capabilities.

`MRL2` is an unsigned row committed by unchanged `MMC1/MSM1`. V2 leaf, node and
root domains include reset ID, epoch, descriptor generation, member count and
protocol version so V1/V2 roots cannot cross-feed. The MRLC stores exact
MNG/MDG/MRV, PMA/PMR, MSM/MMC and every MRL2/DNRC/anchor-DPC byte sequence. It
preflights at most 4,096 rows and 16,777,216 total bytes before copying, then
recomputes the root and signatures before its final HMAC.

The protected `MRLC1` wire magic is `MRLC`, version 1. Its base is 898 bytes
and its maximum is 16,778,114 bytes. Its exact 27-field table is:

```text
network16, resetId32, DCPRef38, DCSRef38, DCQRef38, DWLRef38,
DRSRevision8, DRSRef38, MNG1Ref38, membershipClosureHash32,
MSM1Ref38, MSMSequence8, memberCount4, MRLRoot32, PMARef38,
PMAGeneration8, PMAEpoch8, PMRRef38, PMRGeneration8, PMRHead32,
PMRSnapshotHash32, DNRCSelectionHash32, artifactEntryCount4,
catalogBytesLength8, catalogSha25632, catalogBytes, HMAC32
```

Its HMAC input is canonical fields 1..26 with the 12-byte protected header and
exact lengths. The HMAC key is the deployment's non-DB protected-state key
under `Deep/ProtectedState/V1/MRLC1`. `catalogSha256` is
`SHA256-D(Deep/NativeRouting/V2/catalog-hash,
artifactEntryCount:u32be||catalogLength:u64be||catalogBytes)`. The membership closure is
`SHA256-D(Deep/NativeRouting/V2/membership-closure,
MNG1Ref38||orderedSignedMDG1MRV1ContainerHash32||MSM1Ref38)`; the composite
selection transcript is exactly the machine-registry formula. The current
DRS revision/reference is part of the same HMAC and must equal the restored
DCM/DPL tuple. Every cold load verifies HMAC, exact catalog row framing,
membership signatures/root, PMA/PMR closure, DNRC and current revocation before
returning a sealed composite LKG.

`catalogBytes` is a complete canonical `MRC1` container:

```text
"MRC1" || version:u8=1 || reserved:u8=0 || artifactEntryCount:u32be || rows
row = artifactType:u16be || canonicalLength:u32be ||
      canonicalHash32 || exactCanonicalBytes[canonicalLength]
```

It has 8..16,389 artifact entries and at most 16,777,216 total bytes, with all
lengths, counts and the whole maximum checked before any row copy. There are at
most 4,096 MDG1/MRV1 transition entries and 1..4,096 router members. Rows occur
exactly once in this order: one exact MNG1; the complete MDG1/MRV1 signed
successor chain in verification order; one MMC1; one MSM1; one PMA; one PMR;
then exactly three entries per member, as complete DNR1/MRL2/anchor-DPC1 tuples
sorted by nonzero router ID. Within each tuple the order is DNR1, MRL2, DPC1.
Thus `artifactEntryCount = 5 + transitionEntryCount + 3*memberCount`, bounded
by 16,389. Outer MRLC `artifactEntryCount` equals the MRC header exactly, and
outer `memberCount` equals the tuple count and the exact verified MMC/MSM
member count. Missing, unused, duplicate, cross-type, out-of-order,
same-generation-fork and trailing rows reject.

The transition-container preimage is
`entryCount:u16be ||` the exact contiguous MDG1/MRV1 rows above (including
each row's type, length, hash and bytes). Its hash is
`SHA256-D(Deep/NativeRouting/V2/membership-transition-container, preimage)`
and is the `orderedSignedMDG1MRV1ContainerHash32` input to the membership
closure. The empty transition chain is encoded with count zero and no rows.

MRL hashes are exact:

```text
realLeaf = SHA256-D(Deep/NativeRouting/V2/mrl-leaf,
  0x00||resetId32||epoch:u64be||descriptorGeneration:u64be||
  index:u32be||U32BE(326)||MRL2)
emptyLeaf = SHA256-D(Deep/NativeRouting/V2/mrl-leaf,
  0x01||resetId32||epoch:u64be||index:u32be)
node = SHA256-D(Deep/NativeRouting/V2/mrl-node,
  level:u16be||nodeIndex:u32be||left32||right32)
root = SHA256-D(Deep/NativeRouting/V2/mrl-root,
  resetId32||epoch:u64be||protocolVersion:u16be=2||memberCount:u32be||
  paddedLeafCount:u32be||nodeRoot32)
```

`DNR1` binds exact DPMC, PMA and PMR provenance, independent router Ed25519 and
X25519 keys, a random revocation handle, roles and capabilities. `DPC1` is
signed by that router and advances exactly by one from the exact MRL2 anchor
DPC hash, never from an MRL hash.

DNS DPC addresses are 3..253 lower-case ASCII bytes with at least two labels.
Labels are 1..63 LDH bytes and start/end alphanumeric. Empty labels, trailing
dots, wildcards, underscores and Unicode reject. Each connection resolves once
to at most 16 A/AAAA results; every address must be public unicast. The exact
set is frozen through the socket callback, remote endpoint check, SNI and TLS
SPKI verification. A second DNS resolution is forbidden.

## 7. Native peer request and endpoint

`DPR1` binds both sender and recipient DPC references, the exact reviewed PRQ2
hash/length, identities, operation and identical time window. Its request ID is
exactly the PRQ2 replay nonce. Only reviewed MailboxPeerV2 Store/Tombstone
operation `1` is accepted; storage/privacy IDs remain reserved and reject.
`DPS1` repeats both DPC references and binds the exact DPR and exact 296-byte
MRR2. It never wraps the client-side 776-byte MQR3.

The HTTP/2 request body is:

```text
U32BE(408) || DPR1 || U32BE(prq2Length) || PRQ2
```

Store totals are 1,202..91,128 bytes and Tombstone totals are 1,050..9,240.
The successful response is exactly:

```text
U32BE(444) || DPS1 || U32BE(296) || MRR2
```

or 748 bytes. The only endpoint is
`POST /api/peer/native/v1/mailbox` with exact media types
`application/vnd.deep.peer.dpr1+prq2` and
`application/vnd.deep.peer.dps1+mrr2`. Chunked bodies, compression, trailing
bytes and mismatched inner/outer lengths reject. Responses use identity
encoding, `Cache-Control: no-store, no-transform` and `X-Content-Type-Options:
nosniff`. Admission occurs before body allocation, errors are coarse, and logs
contain no artifact, identity, subject or route bytes.

The outer pending/HMAC row is durable before invoking the existing inner PRQ2
state machine. A crash after durable MRR2 but before DPS CAS invokes only inner
exact replay and outer CAS; it never invokes the inner mutation again.

The outer journal is the fixed 609-byte protected `DPJ1`. Its lookup key is
`HMAC-SHA-256(journalIndexKey,
U16BE(len("Deep/NativeRouting/V1/outer-journal-key"))||
ASCII("Deep/NativeRouting/V1/outer-journal-key")||network16||sender32||
recipient32||requestId32)`. Its exact 21 fields are network, both router IDs,
request ID, journal key, DPR/PRQ references, operation, creation/expiry times,
phase, delivery-authorized and terminal-stale latches, request/outcome hashes, DPS/MRR references,
retention, fork latch, reserved zeros and HMAC, in the machine-registry order.
Its row HMAC uses
`Deep/ProtectedState/V1/DPJ1`.

Phase values are `Prepared=0`, `InnerPending=1`, and `Completed=2`.
`deliveryAuthorized` and `terminalStale` are separate one-byte HMAC-covered
latches and cannot both be set. Prepared and InnerPending require zero
outcome/DPS/MRR fields; Completed requires all three exact nonzero fields.
Expiry sets terminalStale without changing the phase or any prior field; an
authorized-delivery row never becomes stale. Delivery authorization requires
Completed and the final source/time checks. The fork latch is also orthogonal
and HMAC-covered; no phase or bound field is discarded. The same live key with changed canonical request
hash latches a fork. Equality at expiry is stale and produces zero inner
callbacks. Exact replay resumes or returns stored bytes with zero inner
mutation callbacks at every phase. Rows are retained through the unchanged
PRQ2 replay horizon and authority epoch retirement. Existing reviewed
per-router-pair/per-epoch count and byte caps apply before insertion. Garbage
collection reads at most configured max plus one, verifies HMAC before trusting
expiry, deletes only terminal retained rows, and quarantines corrupt rows. No
live row is evicted to admit work.

## 8. Package and consumer cutover

The reproducible package closure has exactly these current package names:

1. `Deep.Protocol` -- Session-free retained P03B/mailbox/membership core plus
   new identity, reset and peer outer primitives;
2. `Deep.Protocol.MembershipRoutes` -- exact-bracket dependency on
   `Deep.Protocol`, byte/API-identical D--G surface plus sealed DNRC/MRL2/DPC
   APIs;
3. `Deep.Protocol.ProfileCarrier` -- its current exact `Deep.Protocol`
   dependency and byte/API-identical carrier surface.

`Deep.Protocol.Native*` remains absent and unreferenced. There are no shims,
type forwards, reflection/internal access or Session dependencies. Consumers
repin only after reproducible exact-package review.

Cutover order is normative and fail-closed: governance and machine gates;
reviewed exact-three Protocol packages; deployed external-witness tooling plus
a four-witness quorum/rotation/lease rehearsal; recovery-capsule loss and
whole-store rollback rehearsal; only then Registry reset, XNode reset,
Shared/MAUI reset, and the devops clean rebuild. Registry 4C/4D remains blocked
until every preceding baseline receives its own P0/P1-zero frozen review.
Destructive reset must not be started merely because wire packages exist.

## 9. Required negative and recovery coverage

The machine vector skeleton is normative for test names and outcomes. It
requires arithmetic/truncation/tag/suite tests, key-role and PoP substitution,
all DRS boundaries and forks, DRA/reset rollback, independent membership/PMA
substitution, MRL root cross-feed, DPC DNS/rebinding, sender/recipient swaps,
PRQ/MRR type confusion, every PREPARE/CAS/COMMIT crash point, witness quorum
split/equivocation/consistency/freeze, lease expiry, capsule loss/corruption,
whole-store rollback, exact replay and package inventory checks.

No production implementation, package publication, consumer reset or security
claim is authorized until its own exact source scope passes independent review
with P0=0/P1=0.
