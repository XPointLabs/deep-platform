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
  `MMC1`, `MSM1`, outer `MIP1`, `PRQ2`, `MRR2`, PMA and PMR retain their exact bytes, domains
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
Every field named `reserved` is all zero. Every opaque hash, ID, nonce, key,
reference and transcript value has exactly its declared width and is not
text-decoded or normalized. Zero is accepted only for a predecessor or time
field explicitly named as a genesis/sentinel in this specification. Unknown
enum values, unknown bit-mask bits and noncanonical boolean bytes reject before
cryptographic, storage or network callbacks. Every boolean byte is exactly
`0x00` or `0x01`.

Every suite-`0x8001` protected record uses one exact HMAC construction. For a
stored record with `N` fields whose field `N` is `HMAC32`, form
`unsignedCanonical` from the same magic/version/suite header but with
`fieldCount=N-1`, followed by canonical fields 1 through `N-1` with their
original tags, zero flags, lengths and values. The HMAC field/tag is absent.
Let `unsignedLength` be the checked byte length of that complete unsigned
record, including its 12-byte header. Then:

```text
HMAC-SHA-256(protectedStateKey32,
  U16BE(len(domain)) || ASCII(domain) || U16BE(0x8001) ||
  U32BE(unsignedLength) || unsignedCanonical)
```

The non-DB deployment protected-state key is exactly 32 bytes and is selected
by the component's pinned protected-state key ID; missing/wrong keys fail
closed. The record/domain mapping is closed: DPL1 uses
`Deep/ProtectedState/V1/DPL1`, DBG1 uses `Deep/ProtectedState/V1/DDBG1`, RIB1
uses `Deep/ProtectedState/V1/DRIB1`, XIB1 uses
`Deep/ProtectedState/V1/DXIB1`, DWL1 uses `Deep/ProtectedState/V1/DWL1`, MRLC
uses `Deep/ProtectedState/V1/MRLC1`, DPJ1 uses
`Deep/ProtectedState/V1/DPJ1`, and RRL1 uses
`Deep/ProtectedState/V1/RRL1`. A cross-record domain, stored header count `N`
in the unsigned form, omitted suite/length prefix, or included/zeroed final
HMAC field rejects.

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
DPC, DPR, DPS, RRM and DWT (including receipt-authenticated composites). `0x0000` is not
an authentication suite and is accepted only for the committed unsigned DRT,
MRL2 and RIP2 records. `0x8001` is HMAC-SHA-256 and is accepted only for DPL, DBG,
RIB, XIB, DWL, MRLC, DPJ and RRL. `0x8002` is accepted only for the AEAD-protected
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
Deep/IdentityAuth/V1/key-hash
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
Deep/Artifact/V1/RIP2
Deep/Artifact/V1/RRM1
Deep/Artifact/V1/RRL1
Deep/Artifact/V1/DWT1
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
Deep/Cutover/V1/release-root-genesis
Deep/Cutover/V1/release-root-manifest
Deep/Cutover/V1/release-manifest-key-id
Deep/Cutover/V1/release-root-chain
Deep/Cutover/V1/release-root-authority-head
Deep/Cutover/V1/witness-terminal-receipt
Deep/Cutover/V1/witness-terminal-quorum
Deep/Cutover/V1/witness-set-root
Deep/Cutover/V1/witness-set-successor
Deep/Cutover/V1/subject-policy
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
Deep/ProtectedState/V1/RRL1
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
| `DCN1` | `758 + 32*(P+Q)`, `P,Q <= 32`, maximum 2,806 |
| `DCQ1` | `375 + receiptBlob`, exactly three receipts, maximum 8,805 |
| `DHL1` / `DCL1` | `710 + 32*Q`, maximum 1,734 / maximum 5,623 |
| `DWL1` / `DRC1` / `DPL1` | 708 / `482 + ciphertext` / 576 |
| `DBG1` / `RIB1` / `XIB1` | 296 / 772 / 452 |
| `DNR1` / `MRL2` | 756 / 326 |
| `RIP2` | `573 + 32*N`, `0 <= N <= 12`, maximum 957 |
| `DPC1` | `427 + addressLength`; IPv4 431, IPv6 443, DNS 430..680 |
| `DXP1` | fixed transcript 168 |
| `DPR1` / `DPS1` | 408 / 444; successful response frame 748 |
| `MRLC1` | `898 + catalogBytes`, maximum 16,778,114 |
| `DPJ1` | 609 |
| `RRM1` / `RRL1` / `DWT1` | 332 / 502 / 714 |

## 3. Identity and key authority

`DPA1` binds one account generation to pairwise-distinct account,
device-certificate-issuer, revocation and reset-control Ed25519 keys. The
account key self-signs and the other three keys prove possession over the same
unsigned bytes. `DeepAccountId` is a domain-separated hash of network,
generation and account key.
`DPA1.minimumSuite` is exactly `0x0001`; `DPD1.suite` is exactly `0x0001`.
No other value is a fallback or negotiation signal.

`KRT1` rotates a release-root, device-issuer, revocation or reset-control key.
The old key signs and the new key proves possession. `KRF1` terminally revokes
one role. Generations advance exactly by one and bind the predecessor. A
same-generation byte change or ancestry conflict sets a permanent fork latch.
The shared key-scope byte is closed as `ReleaseRoot=0x01`,
`DeviceCertificateIssuer=0x02`, `AccountRevocation=0x03`, and
`ResetControl=0x04`; zero and all other scopes reject. The shared action byte
is `Rotate=0x01` and `Revoke=0x02`: KRT requires Rotate and KRF requires
Revoke. A record/action mismatch rejects before signature verification.

The initial ReleaseRoot is never caller supplied and is not inferred from an
account artifact. It is carried by the signed 332-byte `RRM1` release-root
manifest. Its exact ten fields are:

```text
network16, manifestGeneration8, environmentResetId32,
releaseRootGeneration8, releaseRootEd25519Public32, activationAt8,
componentMask8, schemaFingerprint32, manifestSignerKeyId32,
manifestSignature64
```

Wave 1 requires manifest generation zero, ReleaseRoot generation zero,
component mask `0x0f`, nonzero reset ID/root key/schema fingerprint/key ID, and
`txNow >= activationAt`. The unsigned form is fields 1..9 and the signature
domain is `Deep/Cutover/V1/release-root-manifest`. `manifestSignerKeyId32` is
`SHA256-D(Deep/Cutover/V1/release-manifest-key-id,
manifestSignerEd25519Public32)`.

Each component receives an immutable `ReleaseRootManifestPinV1` from the
signed application-release/cutover deployment input through a read-only path
outside every resettable store. Its exact canonical tuple is
`network16||manifestSignerKeyId32||manifestSignerEd25519Public32||
minimumManifestGeneration:u64be=0||expectedRRM1Ref38`. The source is verified
by the component's existing offline software-release trust root before process
startup and contains exactly one row for the configured network. Network,
key-ID derivation, generation, exact RRM1 reference and RRM1 signature must all
match; unknown, duplicate, zero, missing, caller-provided or DB-only values
fail before signature/network callbacks. The exact source fingerprint is:

```text
SHA256-D(Deep/Cutover/V1/release-root-genesis,
  network16||manifestSignerKeyId32||manifestSignerEd25519Public32||
  minimumManifestGeneration:u64be=0||expectedRRM1Ref38)
```

The consumer-internal deployment-source verifier emits the complete immutable
pin value, not authority. The public Protocol relative verifier accepts only
that complete value, exact RRM1 and `txNow`; it returns a sealed
signature-relative fact. No public API accepts a standalone root public key,
fingerprint, manifest policy or an `alreadyVerified` flag, and no public
factory converts the pin or relative fact into a ReleaseRoot genesis
capability. Consumer-local authority exists only after its internal source
verifier joins the same immutable source to the relative result.

The current ReleaseRoot LKG is the protected 502-byte `RRL1`. Its exact 16
fields are:

```text
network16, genesisRRM1Ref38, currentGeneration8, currentPublic32,
currentTransitionRef38, terminalKRF1Ref38, terminalState1, forkLatch1,
latestDWDGeneration8, latestDWDRef38, latestWitnessEpoch8,
chainEntryCount2, chainCheckpointHash32, terminalDWT1Ref38,
protectedStateKeyId32, HMAC32
```

Its HMAC uses the generic protected-record construction and
`Deep/ProtectedState/V1/RRL1`; the 32-byte non-DB protected-state key and key
ID come only from the component's read-only protected-state configuration.
Genesis stores generation zero, the RRM1 root key, and `currentTransitionRef`
equal to the exact RRM1 reference. RRL is not created before its first DWD:
one initialization transaction stores first DWD generation zero with
witnessEpoch one and zero DWD predecessor plus the genesis RRL whose
latest-DWD fields reference that exact DWD. A crash before commit leaves no
RRL/DWD; retry stores the same pair. A production RRL never has a zero latest
DWD reference or zero witness epoch. Terminal and fork latches are canonical
boolean bytes and permanent once one. `terminalKRF1Ref` and `terminalDWT1Ref`
are both zero iff terminal is zero and both exact nonzero refs iff terminal is
one. `chainEntryCount` is the ReleaseRoot transition count only: the number of
ordered KRT/KRF records, `0..64`. It is not the DWD ancestry count. Its
checkpoint is:

```text
SHA256-D(Deep/Cutover/V1/release-root-chain,
  genesisRRM1Ref38||entryCount:u16be||orderedExactKRT1OrKRF1Refs||
  latestDWDRef38)
```

Every RRL read verifies HMAC before scalar use. Its public authority-head hash
is independent of the local HMAC key:

```text
SHA256-D(Deep/Cutover/V1/release-root-authority-head,
  genesisRRM1Ref38||currentGeneration8||currentPublic32||
  currentTransitionRef38||terminalKRF1Ref38||terminalState1||forkLatch1||
  latestDWDGeneration8||latestDWDRef38||latestWitnessEpoch8||
  chainEntryCount2||chainCheckpointHash32||terminalDWT1Ref38)
```

Mutation takes a network-scoped
lock and CASes the exact old RRM/current generation/ref/terminal/fork/chain/DWD
tuple; it stores canonical KRT/KRF/DWD bytes and the recomputed RRL HMAC in one
transaction. Exact replay returns the same LKG. Same-generation changed bytes,
different ancestry, or two candidates permanently sets the fork latch.

`oldKeyHash32` is nonzero and exactly
`SHA256-D(Deep/IdentityAuth/V1/key-hash,
network16||scope1||accountHash32||accountGeneration:u64be||currentPublic32)`.
The candidate public key is nonzero and differs from current. A ReleaseRoot
KRT1 has scope one, zero account hash/generation, transition generation
`current+1`, and predecessor equal to the exact current RRM1 (first rotation)
or KRT1 reference. Non-genesis predecessor bytes are re-decoded as exact KRT1,
with type, scope, network, zero account tuple, generation, public key and
signatures reverified. Old-root signature and new-root PoP are both required.

A root rotation prepares one KRT1 and one successor DWD1. Every DWD successor,
including a byte-identical witness set reauthorization, advances both DWD
delegation generation and the network-global witness epoch exactly by one;
witness epoch zero is forbidden and no two DWD refs share an epoch. The DWD advances
exactly from the current DWD, references the candidate KRT1, is signed by the
new root, has `validFrom >= KRT1.effectiveAt`, and satisfies configured clock
skew. Activation also requires `txNow >= KRT1.effectiveAt` and
`txNow >= DWD1.validFrom`. Neither becomes current alone: one CAS/transaction commits exact KRT,
DWD and RRL; crash recovery exact-replays or leaves the old pair current.
Ordinary DWD rotation uses the unchanged current root/reference. At genesis a
DWD references the exact RRM1, never a zero authority reference.
The ReleaseRoot transition chain contains at most 64 KRT/KRF records. The
independent complete DWD ancestry contains genesis plus at most 64 successors,
therefore `1..65` exact DWD records. Every KRT has exactly one paired successor
DWD that references it; an ordinary DWD successor has no KRT. A KRF never
fabricates a DWD successor and instead terminates through exact DWT.

A ReleaseRoot KRF1 has the same exact ancestry, action two and old signature,
but does not terminally update RRL until terminal state is quorum durable. The
fixed 714-byte `DWT1` contains ten fields:

```text
network16, priorDWD1Ref38, witnessEpoch8, releaseRootGeneration8,
releaseRootTransitionRef38, KRF1Ref38, effectiveAt8, receiptCount1=3,
threeSortedReceiptRows435, quorumDigest32
```

Each 145-byte row is
`witnessId32||treeSize8||treeRoot32||durabilityClass1||issuedAt8||signature64`
and comes from a distinct witness in the exact prior DWD. The row signature is
the standard signature wrapper under
`Deep/Cutover/V1/witness-terminal-receipt` over the 235-byte payload formed by
DWT fields 1..7 followed by that row's witness ID, tree size/root, durability
and issuedAt. Durability class is one and witnesses sign only after fsyncing
the KRF terminal leaf/checkpoint. The quorum digest is:

```text
SHA256-D(Deep/Cutover/V1/witness-terminal-quorum,
  fields1Through7CanonicalValues||receiptCount1||threeSortedReceiptRows435)
```

Exactly three valid sorted distinct receipts are required. Only after DWT
verification does one RRL CAS keep generation/current public/current
transition/latest-DWD fields unchanged, set terminal KRF/DWT refs and state,
increment chain count by one, and recompute chain checkpoint/HMAC. Crash after
external durability but before local commit replays the same DWT and completes
that exact CAS. At `effectiveAt`, DWDs authorized by that root and all leases
referencing them are unusable; witnesses issue no successor receipt or lease.
Sensitive use reloads the current nonterminal RRL and a fresh 3-of-4 DCL whose
inner DHL signatures bind exact DWD ref, root generation/transition,
terminal KRF ref/state and exact RRL authority-head hash. A restored or empty store must
recover exact RRM1, `0..64` ordered KRT/KRF records, and every one of the
`1..65` DWD ancestry records. Each KRT/DWD pair and every independent DWD
successor is reverified. A nonterminal restore additionally requires one fresh
exact externally witnessed DCL from the authenticated recovery capsule and
verifies it before creating a new local RRL HMAC. A terminal restore requires
the exact durable DWT, returns a sealed terminal/no-use result, and neither
requires nor accepts DCL. DWT is present if and only if RRL is terminal;
otherwise DCL is present and DWT is absent. Missing, expired, forked,
inconsistent or externally newer evidence fails closed. Thus a rolled-back DB
cannot reactivate an old root or DWD.

ReleaseRoot transition 65 or DWD ancestry record 66 is terminal
`ReleaseRootChainExhausted`; Wave 1 has no compaction or online checkpoint
rollover. Continuing requires a separately reviewed offline signed manifest
and destructive clean break, never automatic import.

`DPD1` binds independent device Ed25519 and X25519 keys, a random device ID and
random 32-byte revocation handle. `DPM1` binds a mailbox role key and its own
random revocation handle to an exact `DPD1`; the device authorizes and the role
key proves possession. Their observed DRS revision/reference/count/head must be
the exact current snapshot at issuance.
DPD capabilities are a u64 mask containing only
`MailboxRoleIssuer=0x0000000000000001`; the mask is nonzero and therefore
exactly one in Wave 1. DPM capabilities are `RouteOwnerControl=0x01` and
`RouterCertificateIssuer=0x02`, with allowed mask `0x03` and at least one bit
set. Owner-control authorization requires the first bit; DNR issuance requires
the second. Unknown bits reject before signature verification.

`mailboxOwnerId32` is nonzero and equals
`SHA256-D(Deep/IdentityAuth/V1/mailbox-owner-id,
network16||accountHash32||mailboxEd25519Public32)`. This preimage deliberately
excludes `DPMCRef38`: `DPM1` contains `mailboxOwnerId32`, so including its own
reference would be circular. The DPM verifier recomputes the owner ID first,
then independently verifies the exact DPDC/account binding, device
authorization signature and mailbox-role proof of possession. Rotating the
mailbox-role Ed25519 key therefore creates a new owner ID. `routerId32` is
nonzero and equals `SHA256-D(Deep/NativeRouting/V1/router-id,
network16||mailboxOwnerId32||routerGeneration:u64be||routerEd25519Public32)`.
The canonical certificate preimage is retained with the ID. Within one network
and account, the same owner ID with a different preimage latches the account;
within one network, the same router ID with a different preimage latches the
routing domain. Zero IDs, caller-selected IDs and silently regenerated IDs are
invalid.

The router-ID preimage likewise excludes `DNRCRef38`, and the component-subject
preimage is exactly `network16||accountHash32||componentKind:u16be||
accountRevocationHandle32`; it excludes `DCPRef38` and every hash derived from
the component subject. Thus none of the three stable identifiers hashes the
artifact that contains it or a target hash derived from itself.

The exact `DXP1` possession transcript is:

```text
"DXP1" || version:1 || role:1 || reserved:2 || network[16] ||
subjectUnsignedCanonicalHash[32] || holderX25519Public[32] ||
issuerEphemeralPublic[32] || nonce[32] || issuedAt:u64be || expiresAt:u64be
```

It is 168 bytes. The window is at most 300 seconds. After rejecting all-zero
and low-order X25519 results, let `Z32` be the exact 32-byte X25519 shared
secret. Freeze the complete 168-byte transcript once. Compute:

```text
salt32 = SHA256(U16BE(len("Deep/IdentityAuth/V1/x25519-pop-salt")) ||
                ASCII("Deep/IdentityAuth/V1/x25519-pop-salt") ||
                network16 || role1 || subjectUnsignedCanonicalHash32 ||
                nonce32 || issuerEphemeralPublic32 || holderX25519Public32)
prk32 = HKDF-SHA-256-Extract(salt32, Z32)
info = U16BE(len(roleDomain)) || ASCII(roleDomain) || U32BE(168) || DXP1
key32 = HKDF-SHA-256-Expand(prk32, info, 32)
proof32 = HMAC-SHA-256(key32, U32BE(168) || DXP1)
transcriptHash32 = SHA256-D(Deep/IdentityAuth/V1/x25519-pop-transcript-hash,
                            U32BE(168)||DXP1||U32BE(32)||proof32)
```

`roleDomain` is exactly `Deep/IdentityAuth/V1/x25519-pop-key/device` for
role one and `Deep/IdentityAuth/V1/x25519-pop-key/router` for role two. No
other info, salt field, length or output size is accepted. The issuer
independently verifies the exact proof, stores only `transcriptHash32`, and
erases the ephemeral
private key, shared secret, HKDF key and proof. All-zero/low-order results,
role/network/subject changes and nonce reuse reject.
The role byte is closed as `Device=0x01` and `Router=0x02`; zero and every
other value reject before agreement. Device proof is accepted only for an
exact DPD subject and router proof only for an exact DNR subject.

## 4. Revocation and account reset

`DRT1` is private catalog data. Public `DRS1` entries contain only its typed
hash. A DRS entry is exactly 62 bytes:

```text
targetKind:1 || DRT1Ref:38 || targetGeneration:u64be ||
revokedAt:u64be || reason:u16be || reserved[5]
```

The target-kind byte is closed as `DeviceCertificate=0x01`,
`MailboxRoleCertificate=0x02`, and `AccountTerminal=0x03`; zero, `0xff` and
all other values reject before a catalog lookup. Device and mailbox targets
bind exact DPD and DPM references respectively. AccountTerminal binds the
exact DPA as described below and is the only target kind permitted to use the
zero `targetNotAfter` sentinel.
The DRS reason u16 registry is `KeyCompromise=0x0001`,
`DeviceLost=0x0002`, `RoleRetired=0x0003`, and
`AccountShutdown=0x0004`. AccountTerminal requires AccountShutdown;
nonterminal targets reject AccountShutdown. Zero and all other reasons reject.

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
Its reason u16 registry is `UserInitiatedRecovery=0x0001`,
`KeyCompromise=0x0002`, and `AdministrativeReset=0x0003`; zero and every other
value reject before the old-control signature callback.

## 5. External monotonic witness

A root key is never online for each account update. `DWD1` is a time-bounded
release-root-authorized set of exactly four distinct witness descriptors. Each
descriptor fixes witness ID, Ed25519 key, public IP endpoint, port and TLS SPKI;
all four prove possession. Wave 1 assumes at most one Byzantine witness and
requires 3-of-4 receipts.

Each descriptor is exactly 116 bytes:
`witnessId32||Ed25519Public32||endpointKind1||reservedZero1||address16||port2||TLS-SPKI32`.
`endpointKind` is closed as `IPv4=0x01` and `IPv6=0x02`; zero and every other
value reject before address or network work. IPv4 occupies the first four
address bytes and requires a zero tail; IPv6 occupies all 16 bytes. Port is
nonzero and the TLS SPKI hash is nonzero. A DWD rotation advances exactly by
one from the signed predecessor. A Wave 1 successor retains exactly four
witnesses or replaces exactly one: at least three successor descriptors MUST
retain the predecessor witness ID and Ed25519 public key byte-exact. Replacing
two, three or four witnesses, including an all-new epoch, rejects and
permanently latches the deployment fork before any successor activation.
Retained witness heads copy byte-exact; a newly added witness starts only from
a DWD-authorized genesis head and cannot vote until its inclusion/consistency
bootstrap is verified; a removed witness remains in historical LKG evidence
but cannot vote in the successor epoch.

The unsigned DWD core is the canonical 857-byte record containing fields 1
through 16 with `fieldCount=16` and no signature fields. The ReleaseRoot signs
`SIGINPUT(Deep/Cutover/V1/witness-delegation,0x0001,857,unsignedDWDCore857)`.
Each successor descriptor, in descriptor order, signs
`SIGINPUT(Deep/Cutover/V1/witness-set-successor,0x0001,889,
unsignedDWDCore857||signerWitnessId32)`. For every retained descriptor this is
also the predecessor-set authorization and MUST verify under the same
predecessor key. Therefore a replacement successor carries an exact old
3-of-4 authorization from the three retained witnesses plus the replacement's
new-key proof of possession; an unchanged successor carries all four retained
authorizations. No caller-supplied bootstrap approval, key alias or detached
replacement record is accepted.

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
The component-kind registry is closed: `Registry=0x0001`, `XNode=0x0002`,
`Shared=0x0003`, and `MAUI=0x0004`. Zero and every other value reject before
signature verification. Every DCM component table and DCS component table has
exactly those four rows in increasing numeric order; DCP and DPL use exactly
the row kind for their component. The DWD component mask is exactly `0x0f` for
this Wave 1 set. No repository name, deployment alias or caller-supplied value
is converted into a component kind at runtime.
`DWD1.subjectPolicyHash` is nonzero and is recomputed before signature or
network callbacks from the closed 63-byte Wave 1 policy:

```text
SHA256-D(Deep/Cutover/V1/subject-policy,
 network16 || policyVersion:u16be=1 || subjectAclKind:u8=1 ||
 componentMask:u64be=0x0f || componentCount:u8=4 ||
 sortedComponentKinds:u16be[4]=1,2,3,4 ||
 maximumComponentRows:u8=4 || maximumDCPsPerSet:u8=4 ||
 maximumActiveDCSPerSubject:u8=1 || maximumCheckpointTTL:u64be ||
 maximumLeaseTTL:u64be || maximumTreeSize:u64be)
```

`subjectAclKind=1` means only a deployment subject derived by the exact
`deployment-subject` formula and its exact four component subjects may enter
the witness tree. All scalar inputs come from the signed DWD and the closed
component registry; the immutable normative registry is the trusted policy
source. Zero, a caller-selected hash, a different network/mask/limit, or an
unknown ACL kind rejects before witness, signature, allocation or network
work.
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

Every signed DCN1 and DHL1 additionally carries and signs the exact
`DWD1Ref38`, ReleaseRoot generation, ReleaseRoot transition ref, terminal KRF
ref/state, and ReleaseRoot authority-head hash defined in section 3. The
terminal KRF ref is zero exactly when terminal state is zero. DCQ verifies all
three DCN authority tuples equal; DCL repeats the common authority-head hash
and verifies all three inner DHL tuples equal it before returning a lease.
Receipt/lease creation re-decodes the exact RRM/KRT/KRF/DWD chain; a stale
authority tuple, terminal state or fork latch rejects before signing. Thus a
fresh DCL proves the current witness set and current ReleaseRoot authority head,
not merely a set-manifest root/epoch.

The `DCN1.durabilityClass` byte is exactly
`FsyncReplicated=0x01`; zero and all other values reject. `DWD1.componentMask`
is exactly `0x0000000f`, denoting all four closed component kinds; subsets,
unknown bits and zero reject. The one-byte `forkLatch` fields in `DPL1` and
`DWL1` accept only zero or one, are HMAC-covered, and once one can never return
to zero.

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
artifactCount:u16be`, followed by canonical rows. A row key is the exact
38-byte `ArtifactRef`:
`artifactType:u16be||canonicalLength:u32be||canonicalHash32`; the row is
`rowKey38||exactBytes`. Because these rows are ciphertext, the AEAD provider is
invoked exactly once first. All following checks operate only on the resulting
owned plaintext. Row keys are then required to be strictly increasing under
unsigned bytewise lexicographic comparison of all 38 bytes. Equality, reversal
or any duplicate, including an equal key paired with different bytes, rejects
before per-row byte copy, artifact decode, reference hash, signature, network,
storage or mutation callback. A direct plaintext-parser unit test may exercise
the same ordering preflight with zero provider callbacks; it is not an
encrypted integration claim.

After bounds and ordering, every exact row is independently decoded and
canonically recomposed. New DNP artifact types recompute their reference only
with the exact `artifactHashDomains` entry. Retained `MSM1`, `PRQ2`, `MRR2`,
`PMA1`, `PMR1`, D--G source, `MNG1`, `MDG1`, `MRV1` and `MMC1` use only their
unchanged `retainedArtifactHashRules`. A type missing from both closed maps, in
both maps, or cross-fed between map classes rejects. Canonical length and hash
must reproduce the same `ArtifactRef38`. Authority ancestry follows decoded
predecessor references, never physical row order. The exact
maximum is 195 rows: one RRM, up to 64 KRT/KRF root transitions, all `1..65`
DWD ancestry rows, exactly one terminal DWT or nonterminal DCL, and up to 64
component-required rows. With the four-byte DRM header and 38-byte row
overhead, the conservative authority closure is
`4+(38+332)+64*(38+412)+65*(38+1217)+(38+5623)=116410` bytes. Component rows
are bounded to 33,438,022 encoded bytes, so plaintext and ciphertext remain at
most 33,554,432 bytes. Counts and total bytes are checked before allocation.
`DRMHash`, `shadowStateHash`, and `nextPinCoreHash` use exactly
the three recovery hash transcripts in the registry. Reusing a derived nonce
is keyed only by `protectorKeyId32||derivedNonce24`. The stored value is
`SHA256-D(Deep/Cutover/V1/recovery-aead,
transactionId32||U32BE(ADLength)||AD||U64BE(ciphertextLength)||ciphertext||
aeadTag16)`. The same key/value is exact replay; the same key with a different
value permanently latches before AEAD. Decryption order
is fixed: metadata preflight; checked lengths/counts; derive and compare nonce;
freeze AD; one bounded AEAD open; zero PRK/key; owned DRM plaintext
metadata/order/uniqueness preflight; closed per-type reference verification;
required-artifact and Protocol restore; shadow/pin-core compare; only
then authorize COMMIT. No parser or callback runs before its bound is known.

Recovery callback ownership is stricter than the wire grammar. Before any
callback or `await`, the implementation validates every scalar and length
bound and freezes the complete DRC metadata, ciphertext and provider input
into defensively owned storage. The public surface accepts no raw recovery
seed, key or nonce override. A typed internal provider performs the frozen
HKDF; Protocol fixed-time compares its derived nonce with the stored nonce
before AEAD open. The reuse-latch key is exactly
`protectorKeyId32||derivedNonce24`; its stored hash value binds transaction ID,
AD/metadata, ciphertext and tag as defined above. Exact key/value replay is
allowed; the same key with a changed value permanently latches that protector.
Successful plaintext is a one-shot owned value: it can be consumed
once and is zeroed in `finally` on success, failure or cancellation.
Cancellation at every signature, HMAC, agreement, AEAD and provider boundary
yields no commit authority and retains no caller-owned buffer.

### 5.1 Public API authority boundary

The ReleaseRoot manifest API first freezes one canonical 332-byte `RRM1` and
the complete immutable pin tuple `network16||manifestSignerKeyId32||
manifestSignerEd25519Public32||minimumManifestGeneration:u64be=0||
expectedRRM1Ref38`. It recomputes the artifact reference and fixed-time
compares every pin byte and scalar before invoking Ed25519. Verification
accepts one authoritative caller-supplied `txNow:u64`, copied once before any
callback; it requires `manifestGeneration == minimumManifestGeneration == 0` and
`txNow >= activationAt`. It has no clock callback. Its sealed, defensively
owned, nonserializable result is only a signature-relative fact.

No public constructor, factory, conversion or method can turn a raw key,
fingerprint, policy, pin or relative result into genesis or durable authority.
Only a consumer-internal verifier of the immutable deployment source can join
that source to the relative fact and mint consumer-local authority. Relative
types expose no authority conversion or factory.

ReleaseRoot restore preflights the entire bounded input before callbacks. It
starts from exact RRM genesis, consumes `0..64` ordered KRT/KRF root
transitions and separately consumes the complete `1..65` DWD ancestry through
the current RRL. Every KRT is paired with its exact successor DWD. Terminal
state consumes exact DWT and returns terminal/no-use without DCL; nonterminal
state consumes a fresh exact DCL and rejects DWT. Skips, tails, duplicates,
same-generation forks and unconsumed bytes reject. The complete authority
tuple is `genesisRRM1Ref38||currentGeneration:u64be||currentPublic32||
currentTransitionRef38||terminalKRF1Ref38||terminalState:u8||forkLatch:u8||
latestDWDGeneration:u64be||latestDWDRef38||latestWitnessEpoch:u64be||
chainEntryCount:u16be||chainCheckpointHash32||terminalDWT1Ref38`.
Transition plans defensively own the exact old and new tuples; storage performs
only an exact old-to-new tuple CAS. There is no independently trusted PlanHash,
generation-only CAS, boolean authorization or caller-supplied authority.

For protected records Protocol returns only the exact unsigned transcript,
domain, suite and key ID. It never accepts or returns the HMAC key and never
claims durable authority. The nonzero 32-byte key ID is fixed and preflighted
before the HMAC callback; the returned tag is frozen once, locally verified,
and only the owned copy is used. Relative and recovery results never authorize
a durable commit. The consumer's final durable transaction must recheck exact
current DPL, RRL, DWL and DRS state, `txNow`, the witness lease, key health and
kill switch, and the exact old authority tuple immediately before CAS.

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

The unchanged outer `MIP1` is the sole MRL2 membership-proof carrier. Its
opaque inclusion-proof bytes are exactly one canonical `RIP2` record; its
magic is `RIP2`, version is 2, header suite is `0x0000`, and its ArtifactRef
type is 41 under `Deep/Artifact/V1/RIP2`. The exact 14-field table is:

Here “outer MIP1” means only
`Deep.Protocol.DeepExtension.MailboxCapabilities.MailboxReplicaMembershipProof`
encoded by `MailboxPeerReplicationCodec.EncodeMembershipProof` and decoded by
`DecodeMembershipProof`. It is `120 + innerLength` bytes: magic at 0, version
at 4, reserved-zero bytes 5..7, `ReplicaId32` at 8,
`SigningPublicKey32` at 40, epoch u64be at 72, membership commitment32 at 80,
inner length u16be at 112, reserved-zero bytes 114..119, and opaque inner bytes
at 120. The field is exactly `SigningPublicKey`, not an authority alias. Wave
1 narrows its prior 4096-byte opaque allowance to canonical RIP2 573..957
bytes at every DNP entry point.

The unrelated P04
`Deep.Protocol.DeepExtension.Membership.MembershipInclusionProof` also has
magic MIP1 but is a different `72 + 32*N` record with network, sequence,
commitment, leaf index, depth and siblings and has no opaque inner carrier.
That P04 model/API and its unchanged RIP1 never enter this verifier. Dispatch
selects the exact mailbox class/API before magic inspection; a P04 MIP1, RIP1,
MRL1, or a caller-decoded generic MIP1 rejects before allocation.

```text
network16, resetId32, MSMSequence8, epoch8, protocolVersion2,
descriptorGeneration8, memberCount4, paddedLeafCount4, leafIndex4,
MRLRoot32, MRL2Length4, canonicalMRL2_326, siblingCount1,
siblingHashes32N
```

The two-byte `protocolVersion` field is exactly `0x0002`; zero, one and every
other value reject before copying the embedded descriptor or siblings.

The fixed values total 449 bytes, so the canonical length is
`12 + 14*8 + 449 + 32*N = 573 + 32*N`. `memberCount` is `1..4096`;
`paddedLeafCount` is the least power of two greater than or equal to
`memberCount`; `leafIndex < memberCount`; `siblingCount` is exactly
`log2(paddedLeafCount)` and therefore `0..12`; and total RIP2 length is
`573..957`. `MRL2Length` is exactly 326 and the embedded bytes must re-encode
byte-for-byte as canonical MRL2. Every scalar, count, multiplication and exact
outer MIP1 proof length is preflighted before copying the MRL2 or a sibling.

Sibling hashes are ordered only from the leaf level toward the root; no
direction byte exists. For sibling level `L=0..N-1`, the verifier uses bit `L`
of `leafIndex` to place the running hash left or right, uses the supplied hash
for the opposite child, and hashes with the existing MRL node formula using
`level=L` and `nodeIndex=leafIndex>>(L+1)`. The initial real leaf uses the exact
embedded MRL2 and `leafIndex`; the final node is wrapped by the exact MRL root
formula above. Empty padded leaves use the existing empty-leaf formula and
cannot be supplied as alternate real descriptors.

One high-level sealed verifier accepts canonical MIP1 bytes plus a sealed MRLC
composite LKG. Before allocation or callbacks it requires the inner header to
be exact RIP2/version2/suite0/fieldCount14, rejects `RIP1`, MRL1 and every other
inner magic, and enforces the bounds above. It then requires RIP2 network,
reset ID, MSM sequence, epoch, member count and root to equal the sealed MRLC;
descriptor generation to equal embedded MRL2; leaf index to equal the router-ID
sorted MRC tuple position; outer MIP1 replica ID/epoch/root to equal the
embedded router/epoch/root; and the outer MIP1 signing key to equal the router
Ed25519 key in the exact verified DNR1 tuple. Only after the root recomputes
does it return a defensively owned sealed MRL2 membership capability. Decoded
RIP2/MIP1 models, raw sibling lists and caller assertions are not authorization
APIs. Existing RIP1 remains valid only in its unchanged legacy verifier and is
unconditionally rejected at every DNP entry point.

`DNR1` binds exact DPMC, PMA and PMR provenance, independent router Ed25519 and
X25519 keys, a random revocation handle, roles and capabilities. `DPC1` is
signed by that router and advances exactly by one from the exact MRL2 anchor
DPC hash, never from an MRL hash.

DNR/MRL roles are one u64 bitmask: `PeerIngress=0x0000000000000001`,
`PeerCore=0x0000000000000002`, and
`MailboxReplica=0x0000000000000004`; the allowed mask is `0x7` and at least
one bit is required. Capabilities are a separate u64 bitmask:
`NativePeerMailboxV2=0x01`, `ClientMailboxIngressV2=0x02`,
`ProductionMailboxCacheV2=0x04`, `ProductionMailboxCapacityV1=0x08`, and
`MembershipCatalogV2=0x10`; the allowed mask is `0x1f` and at least one bit is
required. DNR, its exact MRL2 row, and every DPC in that descriptor's contact
chain must carry identical capability masks; DPC has no independent capability
namespace. Client ingress, cache or capacity requires `MailboxReplica`; membership-catalog service
requires `PeerIngress` or `PeerCore`; and native peer mailbox requires at least
one router role. Unknown bits and invalid combinations reject before contact
or network callbacks.

DNS DPC addresses are 3..253 lower-case ASCII bytes with at least two labels.
Labels are 1..63 LDH bytes and start/end alphanumeric. Empty labels, trailing
dots, wildcards, underscores and Unicode reject. Each connection resolves once
to at most 16 A/AAAA results; every address must be public unicast. The exact
set is frozen through the socket callback, remote endpoint check, SNI and TLS
SPKI verification. A second DNS resolution is forbidden.
The DPC endpoint-kind byte is closed as `IPv4=0x01`, `IPv6=0x02`, and
`DNS=0x03`; zero and all other values reject before address allocation. The
address length is exactly 4 for IPv4, exactly 16 for IPv6, and 3..253 for DNS.
The DPC flags u64 mask permits only `NoNextPin=0x01`. The current TLS SPKI hash
is always nonzero. When NoNextPin is set the next hash is exactly zero; when it
is clear the next hash is nonzero and differs from current. Unknown flag bits
or a flag/pin-shape mismatch reject before DNS or socket callbacks.

## 7. Native peer request and endpoint

`DPR1` binds both sender and recipient DPC references, the exact reviewed PRQ2
hash/length, identities, operation and identical time window. Its request ID is
exactly the PRQ2 replay nonce. The outer DPR1/DPJ1 `operation` is a u16 and the
only accepted value is `MailboxPeerV2=0x0001`; it selects the already reviewed
inner mailbox protocol and is not a Store/Tombstone discriminator. The retained
inner PRQ2 operation byte remains `Store=0x01` or `Tombstone=0x02`. Zero,
unknown outer values, and interpreting inner value two as an outer operation
reject before inner parsing; storage/privacy outer IDs remain reserved and reject.
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
substitution, MRL root cross-feed, exact MIP1/RIP2 proof verification and
legacy RIP1/MRL1 rejection, closed component kinds, DPC DNS/rebinding, sender/recipient swaps,
PRQ/MRR type confusion, every PREPARE/CAS/COMMIT crash point, witness quorum
split/equivocation/consistency/freeze, lease expiry, capsule loss/corruption,
whole-store rollback, exact replay and package inventory checks. It also
requires the non-circular owner/router/component identifiers; reflection that
finds no public authority-minting surface; full RRM pin mismatch before the
signature callback; bounded complete DWD ancestry; exact old/new authority
tuple CAS with no ad-hoc PlanHash; HMAC key-ID and returned-buffer TOCTOU;
recovery input mutation, nonce reuse, callback cancellation, one-shot plaintext
zeroing, absence of commit authority and the final consumer recheck. DRM
coverage includes reversed keys, an equal duplicate and an equal-reference
collision-shaped different-byte row. Each encrypted integration invokes one
AEAD/provider callback and zero downstream callbacks; the explicitly direct
owned-plaintext parser unit invokes zero callbacks. A separate encrypted case
rejects missing and DNP-versus-retained reference-rule cross-feed after its one
AEAD callback and before any per-row downstream callback.

No production implementation, package publication, consumer reset or security
claim is authorized until its own exact source scope passes independent review
with P0=0/P1=0.
