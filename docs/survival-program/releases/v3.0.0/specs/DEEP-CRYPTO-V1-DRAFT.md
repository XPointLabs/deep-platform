# Deep Production Cryptography and Pairwise Messaging V1

Status: **normative implementation target; clean-break production profile**

Decision: DR-0003

Work package: DNP1-SPEC-crypto

This specification replaces the earlier dark-path crypto draft. There are no
deployed Deep-native users and therefore no legacy account, database, envelope,
session, key or migration requirement. Implementations MUST NOT read or emit
Session-derived identities, 13-word phrases, DPE1, DMC1, the retired DPAC/DPDC
draft records, or any transitional dual format.

Production activation still requires the implementation and evidence gates in
section 18. Normative contact, multi-device and group behavior is defined by
[`CONTACT-AND-GROUP-PROTOCOL-V1.md`](../../../../architecture/CONTACT-AND-GROUP-PROTOCOL-V1.md).

## 1. Goals and non-goals

This profile provides:

- a new 24-word Deep recovery generation;
- one authoritative DNP1 account lineage and independently generated device
  keys;
- asynchronous first contact while the recipient is offline;
- per-device hybrid X25519 + ML-KEM-768 initial key agreement;
- a mandatory Triple Ratchet: classical Double Ratchet plus SPQR/ML-KEM Braid;
- forward secrecy, post-compromise security and passive post-quantum
  confidentiality for 1:1 device sessions;
- cryptographic deniability for ordinary message content;
- fail-closed suite, generation, rollback and replay handling;
- transport-independent ciphertext usable over XPoint, direct P2P mesh,
  on-premise XNode and later transports.

This profile does not by itself provide anonymity, censorship resistance,
traffic-analysis resistance, immediate revocation knowledge while a peer is
offline, post-quantum authentication against an active quantum attacker,
post-quantum MLS group confidentiality, or plaintext history recovery without
an explicit encrypted backup or history transfer. Those boundaries MUST appear
in product security claims.

## 2. Normative dependencies and authority

`MUST`, `MUST NOT`, `SHOULD` and `MAY` are normative.

The exact `DPA1`, `DPD1`, `DRS1`, `DRA1`, reset, witness, membership and
ArtifactRef bytes remain owned by
[`DNP1-CLASSICAL-IDENTITY-RESET-MRL2-V1.md`](DNP1-CLASSICAL-IDENTITY-RESET-MRL2-V1.md)
and its machine registry. This document does not redefine those bytes.
`DPA1.minimumSuite=0x0001` and `DPD1.suite=0x0001` are values in the closed
DNP1 identity-artifact suite namespace. Messaging suite `0x0201` is a separate
closed namespace and never replaces or negotiates those identity values.

The production account authority graph is exactly:

```text
DPA1 account generation
  -> account signing role
  -> device-certificate issuer role
  -> account revocation role
  -> reset-control role
  -> DPD1 independently generated device identities
  -> DRS1 monotonic revocation state
```

[`deep-crypto-v1.registry.json`](deep-crypto-v1.registry.json) is the machine
contract for the clean-break messaging codec family. `E2EE-01` owns `DPK2`,
`DPH2`, embedded `DTR2` and `DPE2`; `APPLICATION-CORE-CODEC-01` owns the frozen
DID1/DAB1/DMD1/DCA1/DAO1 and base DMC2 records; `ATTACHMENT-CODEC-01` owns DAM1
and DMC2 kinds 18/19. Exact application bytes are normatively defined once in
[`CONTACT-AND-GROUP-PROTOCOL-V1.md`](../../../../architecture/CONTACT-AND-GROUP-PROTOCOL-V1.md)
and mirrored by the registry. Each frozen package has marker
`FROZEN_CLEAN_BREAK`; production activation remains false until its vector,
platform and independent-review gates pass. The old umbrella label
`APPLICATION-CODEC-01` is not a package-complete marker. The retired
`DPAC`, `DPDC`, `DPKB`, `DPHI`, suites `0x0101/0x0102` and all V1 handshake
domains are explicit `RETIRED_REJECT` values and MUST NOT be accepted as
aliases, imported as opaque upstream records or probed as fallback.

The machine registry has the exact primitive-size inventory below:

| Registry item | Bytes |
|---|---:|
| Ed25519 public key / signature | 32 / 64 |
| X25519 public key / shared secret | 32 / 32 |
| ML-KEM-768 encapsulation key / decapsulation key | 1184 / 2400 |
| ML-KEM-768 ciphertext / shared secret | 1088 / 32 |
| ML-DSA-65 public key / private key / signature | 1952 / 4032 / 3309 |
| XChaCha20 nonce / AEAD tag | 24 / 16 |
| canonical record maximum | 65535 |

No `Deep/Handshake/V1/*` label is an alias for a V2 messaging domain. Exact V2
domains and transcript constructions are listed in the machine registry and in
sections 7 through 10.

The following external documents are incorporated as algorithm references,
not as wire compatibility:

- Signal PQXDH, revision 3, for asynchronous hybrid AKE;
- Signal Double Ratchet specification including the 2025 Triple Ratchet and
  SPQR construction;
- NIST FIPS 203 and its published errata for ML-KEM;
- NIST SP 800-227 for KEM use and key lifecycle.

Deep owns its outer canonical records, limits, persistence, identity binding
and error behavior. An upstream library's private serialization is never a
Deep wire format.

## 3. Canonical grammar

### 3.1 Primitive encodings

- Octet strings are length-exact. Parsers reject trailing bytes.
- Integers are unsigned, fixed-width and big-endian.
- Cryptographic domain labels are printable ASCII and are not locale
  normalized.
- Human recovery text is UTF-8 NFKD before BIP-39 processing.
- `LP16(x) = u16be(length(x)) || x`.
- `LP32(x) = u32be(length(x)) || x`.
- `SHA256-D(label, x) = SHA-256(ASCII(label) || 0x00 || LP32(x))`.
- `SHA512-D(label, x) = SHA-512(ASCII(label) || 0x00 || LP32(x))`.
- `SHA3-256` is the FIPS 202 function and `HMAC-SHA-256` is RFC 2104 with a
  32-byte output; neither is substituted by SHA-256 or keyed BLAKE variants.
- `HKDF-Extract-512` and `HKDF-Expand-512` are RFC 5869 HKDF with SHA-512.
- `CTX(label, suite, p...) = ASCII(label) || 0x00 || suite:u16be ||
  partCount:u16be || LP32(p[0]) || ... || LP32(p[n-1])`; empty parts are
  explicit zero-length `LP32` values.
- `SIGINPUT(label, suite, record) = ASCII(label) || 0x00 || suite:u16 ||
  LP32(record)`.
- `ZERO32` means exactly 32 zero octets and is permitted only where explicitly
  stated.

Every all-zero X25519 shared secret is rejected. Secret intermediates and
retired ratchet keys MUST be zeroed as soon as successor state is durably
committed.

### 3.2 Canonical record

All Deep messaging records use:

```text
offset  size  field
0       4     magic ASCII
4       2     version
6       2     suite
8       2     fieldCount
10      2     reserved = 0
12      ...   fields

field := tag:u16 || reserved:u16(0) || length:u32 || value:length
```

Tags are strictly increasing and unique. Unknown tags, versions, suites,
flags, enums and non-zero reserved values reject. No parser accepts a partial
known prefix. The total record limit is 65,535 bytes unless a lower per-record
limit is specified.

Scalar, count, individual-length and total-length validation happens before
allocation, hashing, signature verification, KEM decapsulation, database
mutation or application callback. Decoders return owned immutable bytes or a
sealed validated value; they never expose a mutable view over attacker input.

### 3.3 Version and suite closure

The only production pairwise suite is:

| ID | Name | Required algorithms |
|---:|---|---|
| `0x0201` | `DHM2-X25519-MLKEM768-TRIPLE-XCHACHA20` | X25519, ML-KEM-768, Ed25519 certificate/prekey authentication, SHA-256/SHA-512, SHA3-256 and HMAC-SHA-256 for ML-KEM Braid, HKDF-SHA-512, XChaCha20-Poly1305-IETF, Double Ratchet and SPQR/ML-KEM Braid |

Both classical and PQ components are mandatory. There is no classical-only,
PQ-only, retry-with-weaker-suite or environment-controlled downgrade path.
Suite `0x0202` is reserved for later hybrid long-lived authentication and MUST
reject until separately frozen. Negotiation means selecting an exact mutually
supported signed suite before session creation; it never means probing weaker
algorithms after failure.

### 3.4 Messaging codec freeze and parser order

The clean-break codec marker is `FROZEN_CLEAN_BREAK` for the E2EE records and
the application-core/attachment records listed above. It means every field,
type, bound, projection and transcript in those package rows is closed. DCB1,
DCR1 and DIA1 remain `TARGET_UNFROZEN`; DMC2 kinds depending on contact, group,
call or history producer bytes are `RESERVED_REJECT`. No generic payload is
accepted for them. A frozen codec does not mean its runtime is active. The
production activation marker remains `NOT_ACTIVE` until section 18 evidence
passes.

Every parser performs this exact pre-validation order:

1. reject an input outside the record's exact allowed total-size set or closed
   size formula and bound;
2. read only the 12-byte fixed header and reject wrong magic, version, suite,
   field count or nonzero reserved value;
3. scan field headers with checked arithmetic, rejecting truncation, duplicate,
   non-increasing or unknown tags and nonzero field-reserved values;
4. validate every field length, embedded-record size, padding bucket and total
   end offset without allocating field-sized buffers;
5. validate closed enums, zero/nonzero rules, generations, counters and
   cross-field presence/time relationships;
6. copy into bounded owned immutable storage and parse embedded DTR2;
7. compute each derived identifier, projection and replay hash exactly once
   over the bounded owned snapshot;
8. resolve and verify exact DPA1/DPD1/DRS1/DMD1/XPS1/XPC1 references and
   signatures;
9. perform X25519/ML-KEM and KDF work, then AEAD authentication;
10. parse canonical DMC2 and only then prepare one atomic state/dedup mutation.

Steps 1 through 5 invoke no hash, signature, KEM, database, network or
application callback. Any failure leaves prekeys, ratchets, dedup, inbox and
outbox byte-equivalent to their prior durable state. There is one decoder per
magic/version/suite and no legacy, permissive or "ignore unknown" mode.

Raw decoded `DPK2`/`DPH2`/`DTR2`/`DPE2` values prove canonical syntax only.
Consumers MUST cross the narrow protocol-owned verification facade and receive
an unforgeable `Verified*` capability before durable state, plaintext, claim or
delivery logic may use a record. Capability constructors are not public; no
broad friend-assembly access is part of the integration contract.

The dependency graph is acyclic: DPK2 references frozen DNP1 identity and
device-directory state; DPH2 references the exact DPK2 hash and XPC1 receipt;
its session ID and handshake transcript exclude the encrypted payload; the full
DPH2 replay hash is computed only after that payload exists; DPE2 references
only an already committed session and embedded DTR2. No signature, identifier,
nonce or plaintext includes a hash that recursively includes itself.

## 4. DeepRecoveryV1

### 4.1 Phrase creation

1. Generate exactly 32 bytes with the platform OS CSPRNG.
2. Encode them with the canonical English BIP-39 list as 256 entropy bits,
   eight checksum bits and exactly 24 words.
3. The sole word-list identifier is `bip39-en-v1`.
4. Canonical display is lower-case words separated by one ASCII space.
5. Restore collapses whitespace, applies UTF-8 NFKD and invariant lower-case,
   then requires exactly 24 known words and a valid checksum.
6. V1 accepts only the empty BIP-39 passphrase. It does not silently probe a
   user passphrase or another word count.
7. The UI calls it **Deep Recovery Phrase**, warns that it is not a wallet
   mnemonic and never offers wallet import.

The checksum is error detection, not authentication. A valid but wrong phrase
creates another account and MUST NOT be searched against public services to
reveal whether that account exists.

### 4.2 Seed and role derivation

The BIP-39 seed is:

```text
bip39Seed = PBKDF2-HMAC-SHA512(
    password = UTF8_NFKD(mnemonic),
    salt     = UTF8_NFKD("mnemonic"),
    rounds   = 2048,
    length   = 64)

extractSalt = SHA-512(ASCII("Deep/Recovery/V1/extract"))
recoveryPrk = HKDF-Extract-512(extractSalt, bip39Seed)
context     = networkId16 || accountGeneration:u64be
```

Except for the two permanent address values below, each following seed is 32 bytes from
`HKDF-Expand-512(recoveryPrk, ASCII(label) || 0x00 || LP32(context), 32)`:

| DPA1 role or local role | Label |
|---|---|
| account signing | `Deep/Recovery/V1/account-signing-seed` |
| device-certificate issuer | `Deep/Recovery/V1/device-issuer-signing-seed` |
| account revocation | `Deep/Recovery/V1/revocation-signing-seed` |
| reset control | `Deep/Recovery/V1/reset-control-signing-seed` |
| permanent Deep ID address signing | `Deep/Recovery/V1/public-address-signing-seed` |
| permanent Deep ID resolver read capability | `Deep/Recovery/V1/public-address-read-capability` |
| backup wrapping | `Deep/Recovery/V1/backup-wrapping-seed` |
| reserved future ML-DSA account role | `Deep/Recovery/V1/account-pq-signing-seed` |

The first four seeds instantiate the exact pairwise-distinct Ed25519 roles in
`DPA1`. The public-address seed instantiates the stable Ed25519 key carried by
`DID1`; it signs only `DAB1` address/account bindings, never a message, device
certificate or key agreement. To keep DID1 independent of a network transport
and account-generation reset, its seed is instead exactly:

```text
addressSigningSeed32 = HKDF-Expand-512(
  recoveryPrk,
  ASCII("Deep/Recovery/V1/public-address-signing-seed") || 0x00 ||
    LP32(ASCII("DeepGlobalAddressV1")),
  32)
addressReadCapability16 = HKDF-Expand-512(
  recoveryPrk,
  ASCII("Deep/Recovery/V1/public-address-read-capability") || 0x00 ||
    LP32(ASCII("DeepGlobalAddressV1")),
  16)
```

The backup
seed is input to a separately domain-separated backup KDF;
it is never an AEAD key directly. The PQ seed remains reserved and MUST NOT be
passed to ML-KEM, another signature algorithm or a provider whose deterministic
key generation contract has not been frozen.

Changing network ID or account generation creates unrelated account-role keys
but intentionally leaves both permanent DID1 values unchanged. Changing
the phrase or any label creates unrelated keys. The BIP-39 seed and no role seed is used directly as a device, X25519,
ML-KEM, MLS, mailbox, router, storage, push, database or content key.

### 4.3 Device generation

Every logical device independently generates with the device OS CSPRNG:

- random 32-byte `deviceId` required by `DPD1`;
- Ed25519 device signing key;
- X25519 device identity-agreement key;
- `DPD1` revocation handle;
- signed and one-time X25519 prekeys;
- ML-KEM-768 prekeys;
- Triple Ratchet state and ephemeral keys;
- no MLS key in v1; a future MLS profile generates independent per-group keys
  only after that profile is explicitly activated;
- local SQLCipher/database and platform-keystore wrapping keys.

Ed25519 and X25519 key pairs are independently generated. Ed25519-to-X25519 or
X25519-to-Ed25519 conversion is forbidden in every profile and test fixture.
Account, issuer, revocation, reset and device signing keys never perform key
agreement.

### 4.4 Recovery-root handling

Recovery-derived private material is loaded only during account creation,
account recovery, explicit device enrollment, revocation or account reset. It
is erased after the signed transaction commits. Routine messaging, sync,
push, mailbox polling, attachment transfer and calls use device-scoped keys.

Phrase display and entry suppress screenshots, screen sharing, clipboard,
accessibility announcements, telemetry, crash dumps and diagnostic snapshots.
The phrase and derived secrets never enter logs, metrics, Registry, XNode,
push/file services or plaintext cloud backup.

## 5. Account and device lifecycle

### 5.1 Account creation

Account creation is completely offline:

1. create and confirm DeepRecoveryV1;
2. derive the four DPA1 signing roles for account generation one and the
   transport-neutral permanent DID1 address role;
3. author exact `DPA1` and initial `DRS1` according to the frozen DNP1
   authority specification;
4. generate local device keys independently;
5. prove possession and author exact `DPD1`;
6. create empty device-directory and messaging state atomically;
7. only then attempt transport registration and prekey publication.

Network failure cannot invalidate the local account. It changes UI state to
`Account ready; network registration pending`, never `Deep failed to start`.

### 5.2 Device enrollment

V1 enrollment requires both authenticated proximity or a scanned one-time
enrollment QR between an already authorized device and the new device, and
Deep Recovery Phrase confirmation on the new device to authorize exact `DPD1`
issuance with the DPA1 device-issuer role.

The existing device transfers only public lineage, current signed device
directory, revocation state, route-update capabilities and an encrypted
history/backup capability if the user explicitly enables it. It never exports
the DPA1 issuer private key or another device private key.

This ceremony is intentionally stricter than a phrase-free link. A future
delegated enrollment authority would require a change to the frozen DNP1
issuer graph and is not silently introduced here.

### 5.3 Recovery on a new device

Recovery re-derives the same DPA1 roles for the exact network and account
generation, verifies recovered DPA1 byte-for-byte, then generates a new device
identity and DPD1. It does not recreate an old device or its ratchet keys.

Public V1 account creation and phrase-only recovery support account generation
one only. Generation zero remains invalid under the frozen DNP1 verifier. A
destructive account reset creates a new phrase/account lineage;
the client never guesses or enumerates generations over the network. A future
same-phrase generation advance requires an authenticated recovery package that
stores the exact generation and DPA1 hash; it is not a hidden V1 behavior.

Without an encrypted backup, recovery restores account authority but not
plaintext messages, contact aliases, group application history or old ratchet
state. Signed contact/device/group heads may be reacquired from their
continuity channels. With backup enabled, the backup profile must use a new
random data-encryption key, wrap it under a key derived from the backup seed
and bind network/account/generation/schema/rollback counters.

### 5.4 Revocation

Revoking a device advances exact DRS1 state and the messaging device directory.
Senders stop creating ciphertext for the revoked device after learning the
new head. Remaining devices establish fresh pairwise sessions where needed;
every group containing the account removes the revoked leaf and commits a new
epoch.

The same transaction advances ADC1 and rotates every mailbox, XUR1, invite,
pre-key and push capability known to the revoked device. Successors are wrapped
only to remaining devices/contacts. Revocation that changes keys but leaves a
shared fetch/ack capability live is incomplete.

Revocation is eventual across offline partitions. No document or UI may claim
that an offline peer instantly knows about a remote revocation. The accepted
stale-state window and reconnect behavior are specified in the contact/group
document.

## 6. Prekey service boundary

The prekey service is an untrusted availability service. It may withhold,
reorder, replay or equivocate, but cannot mint a valid device or bundle.
Clients access it through a transport privacy layer; account/device identifiers
MUST NOT appear in an unmasked XPoint outer frame.

The service supports atomic publish, fetch-and-claim, exact replay of a lost
response, revoked-device fencing and predecessor retention. The server never
receives a device private key. Same bundle ID with changed bytes is a permanent
conflict. Claim identifiers are random and unrelated to account, mailbox or
transport route identifiers.

## 7. `DPK2` asynchronous prekey offering

`DPK2`, version 1, suite `0x0201`, is one atomic claimable hybrid offering.
An epoch inventory is a service-side set of byte-distinct DPK2 records; it is
not a repeated or nested field inside one record.
`networkId16` is nonzero; `ZERO16` is a non-canonical clean-break input and
rejects before signature projection, directory resolution or claim work.

| Tag | Value | Type / exact size |
|---:|---|---:|
| 1 | network ID | octets, 16 |
| 2 | responder `DeepAccountId32` | octets, 32 |
| 3 | responder device ID | octets, 32 |
| 4 | responder device generation | `u64be`, 8 |
| 5 | exact DPD1 ArtifactRef | octets, 38 |
| 6 | device-directory generation | `u64be`, 8 |
| 7 | exact device-directory head hash | octets, 32 |
| 8 | XPS1 prekey-service generation | `u64be`, 8 |
| 9 | inventory epoch | `u64be`, 8 |
| 10 | random bundle ID | octets, 32 |
| 11 | signed policy generation | `u64be`, 8 |
| 12 | not-before Unix seconds | `u64be`, 8 |
| 13 | issued-at Unix seconds | `u64be`, 8 |
| 14 | expires-at Unix seconds | `u64be`, 8 |
| 15 | device X25519 agreement public key | octets, 32 |
| 16 | signed X25519 prekey ID | octets, 32 |
| 17 | signed X25519 prekey public key | octets, 32 |
| 18 | signed-X25519-prekey device signature | octets, 64 |
| 19 | one-time X25519 prekey ID | octets, 0 or 32 |
| 20 | one-time X25519 prekey public key | octets, 0 or 32 |
| 21 | ML-KEM-768 prekey ID | octets, 32 |
| 22 | ML-KEM-768 encapsulation key | octets, 1184 |
| 23 | ML-KEM kind (`1=OneTime`, `2=LastResort`) | `u8`, 1 |
| 24 | signed reuse limit | `u16be`, 2 |
| 25 | ML-KEM-prekey device signature | octets, 64 |
| 26 | complete-bundle device signature | octets, 64 |

All IDs and public keys are nonzero. Generations and epoch are nonzero.
`issuedAt <= notBefore < expiresAt`, and `expiresAt - notBefore` is at most
2,592,000 seconds. For `OneTime`, tags 19 and 20 are both exact 32-byte values
and tag 24 is zero. For `LastResort`, tags 19 and 20 are both empty and tag 24
is `1..64`. No other combination parses. The exact record size is therefore
2,037 bytes for `OneTime` and 1,973 bytes for `LastResort`.

The three signatures use canonical DPK2 projections, each with a recomputed
field count and no omitted-field placeholder:

```text
xspkProjection = canonical DPK2 containing tags 1..17
mlkemProjection = canonical DPK2 containing tags 1..17 and 21..24
unsignedDPK2 = canonical DPK2 containing tags 1..25

tag18 = Ed25519.Sign(deviceSigningKey,
  SIGINPUT("Deep/Messaging/V2/x25519-signed-prekey", 0x0201,
           xspkProjection))
tag25 = Ed25519.Sign(deviceSigningKey,
  SIGINPUT("Deep/Messaging/V2/mlkem-prekey", 0x0201,
           mlkemProjection))
tag26 = Ed25519.Sign(deviceSigningKey,
  SIGINPUT("Deep/Messaging/V2/prekey-bundle", 0x0201,
           unsignedDPK2))
```

The verifier resolves the exact DPA1/DPD1/DRS1/DMD1 closure, requires tag 15
to equal the X25519 key in DPD1, requires the device to be active at the exact
tag-6/tag-7 head and verifies all three signatures before exposing any key to
the AKE. It also requires the exact device-signed XPI1 manifest, XPC1-bound
XPI1 hash and a valid inclusion proof (or the exact XPI1 last-resort hash);
an independently valid DPK2 outside the complete quorum-committed manifest is
not claimable. XPI1 grammar, complete-set Merkle commitment and two-replica
XPP1/XIC1 publication is defined solely by CONTACT-RESOLVER-V1. One inventory
epoch contains `32..4096` one-time DPK2 offerings and
exactly one last-resort offering. A device MAY pre-sign at most fourteen
non-overlapping epochs covering at most 400 days; the service exposes only the
current epoch and one overlap epoch. Signed X25519 prekeys rotate after 30 days
or 10,000 successful sessions, whichever occurs first. Every offering owns
independent one-time X25519 and ML-KEM private material; no private key is
uploaded. Exhaustion is `PreKeysUnavailable`, never a weaker-suite retry.

## 8. `DPH2` hybrid initiation

`DPH2`, version 1, suite `0x0201`, is the complete initiator handshake record:

`networkId16` and every other DPH2 identifier are nonzero. A `ZERO16`
network identifier is a non-canonical clean-break input and MUST be rejected
before any hash, signature, claim, KEM, DH or storage operation.

| Tag | Value | Type / exact size |
|---:|---|---:|
| 1 | network ID | octets, 16 |
| 2 | initiator `DeepAccountId32` | octets, 32 |
| 3 | initiator device ID | octets, 32 |
| 4 | initiator device generation | `u64be`, 8 |
| 5 | exact initiator DPD1 ArtifactRef | octets, 38 |
| 6 | responder `DeepAccountId32` | octets, 32 |
| 7 | responder device ID | octets, 32 |
| 8 | responder device generation | `u64be`, 8 |
| 9 | exact DPK2 hash | octets, 32 |
| 10 | XPK1/XPC1 claim operation ID | octets, 32 |
| 11 | exact XPC1 claim receipt hash | octets, 32 |
| 12 | last-resort use counter; zero for one-time | `u16be`, 2 |
| 13 | derived session ID | octets, 32 |
| 14 | initiator device X25519 agreement public key | octets, 32 |
| 15 | initiator ephemeral X25519 public key | octets, 32 |
| 16 | selected prekey tuple | octets, 97 |
| 17 | actual ML-KEM-768 ciphertext | octets, 1088 |
| 18 | initiator initial Double-Ratchet X25519 public key | octets, 32 |
| 19 | initial-payload XChaCha20 nonce | octets, 24 |
| 20 | encrypted initial plaintext plus AEAD tag | octets, 4112, 16400 or 32784 |

Tag 16 is exactly `signedX25519Id32 || oneTimeX25519IdOrZero32 ||
mlKemId32 || mlKemKind:u8`. It must equal the exact DPK2 selection. For a
one-time DPK2, the second ID equals DPK2 tag 19, kind is 1 and tag 12 is zero.
For a last-resort DPK2, the second ID is `ZERO32`, kind is 2 and tag 12 is
`1..DPK2.tag24`; it must equal the counter in the exact XPC1 receipt. DPH2 has
only three legal total sizes: 5,917, 18,205 and 34,589 bytes.

Define these non-circular values:

```text
dpk2Hash32 = SHA256-D("Deep/Messaging/V2/exact-dpk2", exactDPK2)

senderEphemeralCommitment32 = SHA256-D(
  "Deep/ContactResolver/V1/sender-ephemeral",
  network16 || initiatorAccount32 || initiatorDevice32 ||
  initiatorDPD1Ref38 || initiatorDeviceAgreement32 ||
  initiatorEphemeral32 || initiatorInitialRatchet32)

sessionId32 = SHA256-D(
  "Deep/Messaging/V2/session-id",
  network16 || initiatorAccount32 || initiatorDevice32 ||
  initiatorDeviceGeneration:u64be || initiatorDPD1Ref38 ||
  responderAccount32 || responderDevice32 ||
  responderDeviceGeneration:u64be || dpk2Hash32 ||
  claimOperationId32 || claimReceiptHash32 ||
  lastResortUseCounter:u16be || selectedPrekeyTuple97 ||
  initiatorEphemeral32 || mlKemCiphertext1088 ||
  initiatorInitialRatchet32)
```

The initiator generates tags 10, 15, 18 and 19 freshly. Tag 10 is the exact
random operation ID already committed by XPK1/XPC1. The XPC1 request carries
`senderEphemeralCommitment32`; its success receipt binds the request hash,
exact DPK2 hash, selected one-time ID or zero, service generation, last-resort
counter and commit generation. Tags 9 through 12 must reproduce that receipt.
No session or claim ID is caller-selected after seeing a conflicting result.

After validating responder DPA1/DPD1/DRS1/DMD1, XPS1, XPC1 and all DPK2
signatures, the initiator computes:

```text
DH1 = X25519(initiatorDeviceAgreementPrivate, responderSignedPrekeyPublic)
DH2 = X25519(initiatorEphemeralPrivate, responderDeviceAgreementPublic)
DH3 = X25519(initiatorEphemeralPrivate, responderSignedPrekeyPublic)
DH4 = X25519(initiatorEphemeralPrivate, responderOneTimePrekeyPublic)
      // empty CTX part for LastResort
PQ  = ML-KEM-768.Encaps(responderMlKemPrekey).sharedSecret

handshakeHeader = canonical DPH2 containing tags 1..19
transcriptHash64 = SHA512-D(
  "Deep/Messaging/V2/handshake-transcript",
  LP32(exactDPK2) || LP32(handshakeHeader))
akeIkm = CTX("Deep/Messaging/V2/ake-ikm", 0x0201,
             DH1, DH2, DH3, DH4-or-empty, PQ)
prk64 = HKDF-Extract-512(transcriptHash64, akeIkm)
SKec32 = HKDF-Expand-512(prk64,
  CTX("Deep/Messaging/V2/ec-root", 0x0201,
      transcriptHash64, sessionId32), 32)
SKscka32 = HKDF-Expand-512(prk64,
  CTX("Deep/Messaging/V2/spqr-root", 0x0201,
      transcriptHash64, sessionId32), 32)
initKey32 = HKDF-Expand-512(prk64,
  CTX("Deep/Messaging/V2/initial-aead", 0x0201,
      transcriptHash64, sessionId32), 32)
handshakeHeaderHash32 = SHA256-D(
  "Deep/Messaging/V2/dph2-header", handshakeHeader)
```

Every DH result and PQ shared secret is exactly 32 nonzero bytes. Tag 20 is
XChaCha20-Poly1305-IETF under `initKey32`, nonce tag 19 and:

```text
initialAad = CTX("Deep/Messaging/V2/dph2-initial-aead-ad", 0x0201,
                 handshakeHeader, transcriptHash64)
```

The unpadded initial plaintext is exactly
`eventCount:u8 || LP32(SessionInitDMC2) || [LP32(firstApplicationDMC2)]`, where
`eventCount` is 1 or 2. Both records are canonical DMC2. `SessionInit` uses the
companion codec unchanged: its handshake nonce, exact sender DMD1 and capability
bits are checked against the independently resolved initiator
ADC1/ADP1/DPA1/DRS1/DMD1/DPD1 closure. The enclosing verified DPH2 capability
binds `sessionId32`, `claimOperationId32` and `handshakeHeaderHash32`; those
values are not duplicated into DMC2. An optional second event is the same
immutable logical event used by all device fanout copies; first contact uses
`ContactHello`.
For this codec, companion prose saying that SessionInit "embeds" ContactHello
means this second LP32 DMC2 record; it never means nesting ContactHello bytes
inside the closed SessionInit tag-12 payload.
Random padding and a final `u32be` unpadded length fill the smallest allowed
plaintext bucket 4,096, 16,384 or 32,768 bytes.

After tag 20 exists, define the distinct replay value:

```text
fullDph2ReplayHash32 = SHA256-D(
  "Deep/Messaging/V2/exact-dph2-replay", exactDPH2)
claimBinding32 = SHA256-D(
  "Deep/Messaging/V2/prekey-claim-binding",
  claimOperationId32 || sessionId32 || dpk2Hash32 ||
  claimReceiptHash32 || fullDph2ReplayHash32)
```

The transcript hash never includes tag 20; the replay and claim hashes always
include it through the exact full record. The responder first verifies all
lineage, DPK2/XPC1 selection and claim bindings without consuming them, then
decapsulates, derives, authenticates and parses both DMC2 records. One durable
transaction atomically consumes the exact prekeys/counter, commits Triple
Ratchet state, full-DPH2 replay hash, claim binding and logical dedup. The same
claim/session with byte-identical DPH2 exact-replays; changed full bytes reject
and latch that claim/session. KEM, lineage, transcript, AEAD and claim failures
are externally one coarse `HandshakeRejected`.

## 9. Mandatory Triple Ratchet

### 9.1 Construction

Suite `0x0201` uses these closed transitions:

1. `CreateInitiation`: Alice generates the DPH2 tag-18 key pair and KEM/DH material,
   derives SKec/SKscka, then calls `InitAlice(SKec,
   bobSignedPrekeyPublic, aliceTag18KeyPair)` and `InitSckaAlice(SKscka)`.
2. `AcceptInitiation`: Bob validates/claims DPK2, derives the same secrets,
   calls `InitBob(SKec, bobSignedPrekeyKeyPair)` and
   `InitSckaBob(SKscka)`, then processes Alice's tag-18 receive step.
3. `ProcessFirstRatchetMessage`: Bob's first DPE2 response advances with a fresh
   Bob ratchet key and carries
   `SessionAck(fullDph2ReplayHash32, sessionId32)`. Alice marks the initiation
   acknowledged only after that authenticated response commits.

The responder signed-prekey private key remains available only for the bounded
DPK2 claim/replay horizon.

The application-specific KDF surface left open by the upstream Double/Triple
Ratchet specifications is closed for suite `0x0201` as follows. These constants
are exact printable ASCII and are protocol inputs, not diagnostic names:

```text
doubleRatchetProtocolInfo = ASCII(
  "DeepDoubleRatchetV1_X25519_HKDF-SHA-512_HMAC-SHA-256")
spqrProtocolInfo = ASCII(
  "DeepSparsePqRatchetV1_MLKEM768_HKDF-SHA-512_HMAC-SHA-256")
tripleRatchetProtocolInfo = ASCII(
  "DeepTripleRatchetV1_X25519_MLKEM768_XCHACHA20")
```

The classical root step is exact `KDF_RK`:

```text
ecRootAndChain64 = HKDF-Expand-512(
  HKDF-Extract-512(oldEcRootKey32, x25519Output32),
  CTX("Deep/Messaging/V2/ec-root-step", 0x0201,
      doubleRatchetProtocolInfo),
  64)
newEcRootKey32 = ecRootAndChain64[0..32]
newEcChainKey32 = ecRootAndChain64[32..64]
```

An all-zero X25519 output rejects before HKDF. The classical symmetric step is
exact `KDF_CK`; both HMAC inputs are different fixed constants and neither
output is truncated from a shared HMAC invocation:

```text
ecMessageKey32 = HMAC-SHA-256(
  oldEcChainKey32,
  CTX("Deep/Messaging/V2/ec-chain-message", 0x0201,
      doubleRatchetProtocolInfo))
newEcChainKey32 = HMAC-SHA-256(
  oldEcChainKey32,
  CTX("Deep/Messaging/V2/ec-chain-next", 0x0201,
      doubleRatchetProtocolInfo))
```

The SPQR KDFs are exact. `direction:u8` is `1=A-to-B` or `2=B-to-A` and names
the logical direction, so both peers use the same value for a matching chain.
`epoch` and `counter` are `u64be`, start at the values emitted by the pinned
Signal state machine and never wrap:

```text
spqrInitial96 = HKDF-Expand-512(
  HKDF-Extract-512(ZERO64, SKscka32),
  CTX("Deep/Messaging/V2/spqr-chain-start", 0x0201,
      spqrProtocolInfo),
  96)
initialSpqrRoot32 = spqrInitial96[0..32]
initialAtoBChain32 = spqrInitial96[32..64]
initialBtoAChain32 = spqrInitial96[64..96]

spqrEpoch96 = HKDF-Expand-512(
  HKDF-Extract-512(oldSpqrRoot32, braidOutputKey32),
  CTX("Deep/Messaging/V2/spqr-chain-add-epoch", 0x0201,
      spqrProtocolInfo, epoch:u64be),
  96)
newSpqrRoot32 = spqrEpoch96[0..32]
newAtoBChain32 = spqrEpoch96[32..64]
newBtoAChain32 = spqrEpoch96[64..96]

spqrChainStep64 = HKDF-Expand-512(
  HKDF-Extract-512(ZERO64, oldSpqrChainKey32),
  CTX("Deep/Messaging/V2/spqr-chain-step", 0x0201,
      spqrProtocolInfo, epoch:u64be, direction:u8, counter:u64be),
  64)
newSpqrChainKey32 = spqrChainStep64[0..32]
pqMessageKey32 = spqrChainStep64[32..64]
```

`ZERO64` is exactly 64 zero octets, matching the SHA-512 HKDF hash length.
Alice and Bob swap only which of the canonical A-to-B/B-to-A outputs they store
as send/receive; they never change output order or derive role-local variants.
Raw concatenation, omitted protocol info, an inferred direction, a different
counter encoding, or the upstream document's illustrative/default constants
reject. Every old root/chain key and temporary 64/96-byte expansion is wiped
only after the successor transaction is durable.

The public Triple-Ratchet header is the embedded canonical record `DTR2`,
version 1, suite `0x0201`. It is not a transport object and MUST occur only as
DPE2 tag 6:

| Tag | Value | Type / exact size |
|---:|---|---:|
| 1 | network ID | octets, 16 |
| 2 | Double-Ratchet X25519 public key | octets, 32 |
| 3 | Double-Ratchet previous sending-chain length | `u64be`, 8 |
| 4 | Double-Ratchet message number | `u64be`, 8 |
| 5 | SPQR sending epoch used for the message key | `u64be`, 8 |
| 6 | SPQR previous sending-chain length | `u64be`, 8 |
| 7 | SPQR message number | `u64be`, 8 |
| 8 | ML-KEM-Braid negotiation epoch | `u64be`, 8 |
| 9 | ML-KEM-Braid message kind | `u8`, 1 |
| 10 | complete typed ML-KEM-Braid payload | octets, 0, 96, 160, 960 or 1152 |

Tag 1 is nonzero and MUST equal the enclosing DPE2 tag 1. This clean-break
binding makes an extracted DTR2 snapshot network-specific before any ratchet
callback or hash is evaluated. The message-kind registry is `0=None`, `1=Hdr`, `2=Ek`, `3=EkCt1Ack`,
`4=Ct1Ack`, `5=Ct1`, `6=Ct2`. Payloads are exact: None/Ct1Ack empty;
Hdr is `ekSeed32 || SHA3-256(ekVector1152 || ekSeed32) || headerHmac32`
(96 bytes); Ek/EkCt1Ack is `ekVector1152`; Ct1 is `ct1_960`; Ct2 is
`ct2_128 || ciphertextHmac32` (160 bytes). `braidEpoch` is nonzero. Counters
are unsigned, may begin at zero and MUST NOT wrap. The exact DTR2 sizes are
189 (None/Ct1Ack), 285 (Hdr), 1,341 (Ek/EkCt1Ack), 1,149 (Ct1) and 349 (Ct2)
bytes.

The internal Braid profile is also closed:

```text
braidProtocolInfo = ASCII(
  "DeepMlKemBraidFullV1_MLKEM768_HMAC-SHA-256")
braidAuth64 = HKDF-Expand-512(
  HKDF-Extract-512(oldBraidAuthRoot32, freshBraidOutput32),
  CTX("Deep/Messaging/V2/braid-auth-update", 0x0201,
      braidProtocolInfo, braidEpoch:u64be), 64)
newBraidAuthRoot32 = braidAuth64[0..32]
braidHmacKey32 = braidAuth64[32..64]
braidOutputKey32 = HKDF-Expand-512(
  HKDF-Extract-512(ZERO64, mlKemSharedSecret32),
  CTX("Deep/Messaging/V2/braid-output-key", 0x0201,
      braidProtocolInfo, braidEpoch:u64be), 32)
headerHmac32 = HMAC-SHA-256(
  braidHmacKey32,
  CTX("Deep/Messaging/V2/braid-header-auth", 0x0201,
      braidEpoch:u64be, ekSeed32 || ekHash32))
ciphertextHmac32 = HMAC-SHA-256(
  braidHmacKey32,
  CTX("Deep/Messaging/V2/braid-ciphertext-auth", 0x0201,
      braidEpoch:u64be, ct1_960, ct2_128))
```

`ZERO64` is exactly 64 zero bytes and is used only as the HKDF salt above.
Every Braid KDF/HMAC input is length-prefixed through CTX; raw string
concatenation and upstream default `PROTOCOL_INFO` values reject.

`DTR2` is the Deep-owned mapping of Signal's logical SCKA message
`{epoch,type,data}` plus the Double-Ratchet and SPQR counters. The
`DeepMlKemBraidFullV1` profile uses an identity encoder: one complete logical
Braid payload is carried in one DTR2 rather than an implementation-specific
erasure-code chunk stream. This is the maximum-chunk special case of the
referenced Braid state machine and removes an otherwise ambiguous Reed-Solomon
wire dependency. Transport fragmentation, retransmission and padding remain
outside DTR2. No provider-private protobuf/Rust/.NET serialization is accepted
on wire. The internal Braid HMAC-SHA-256 authenticator is mandatory and its
32-byte outputs are the Hdr/Ct2 suffixes above; outer DPE2 AEAD additionally
authenticates the whole DTR2.

Each logical message step obtains `ecMessageKey32` and `pqMessageKey32` from
the two ratchets and derives:

```text
headerHash32 = SHA256-D("Deep/Messaging/V2/ratchet-header", exactDTR2)
hybridIkm = CTX("Deep/Messaging/V2/hybrid-message-ikm", 0x0201,
                tripleRatchetProtocolInfo,
                ecMessageKey32, pqMessageKey32)
messageKey32 = HKDF-Expand-512(
  HKDF-Extract-512(
    SHA512-D("Deep/Messaging/V2/triple-ratchet-salt", sessionId32),
    hybridIkm),
  CTX("Deep/Messaging/V2/message-key", 0x0201,
      tripleRatchetProtocolInfo,
      sessionId32,
      ecMessageNumber:u64be,
      sckaSendingEpoch:u64be,
      sckaMessageNumber:u64be,
      headerHash32),
  32)
```

The three KDF counters are DTR2 tags 4, 5 and 7 exactly. Neither component key
may be zero, reused for another counter/header tuple, cached after commit or
treated as optional. A durable PQ-key commitment fence covers retained and
consumed tuples. Ratchet algorithm behavior follows the pinned Signal Triple
Ratchet and ML-KEM-Braid specifications; Deep owns the codec, transaction and
resource limits.

### 9.2 State limits

- Maximum forward message-number gap per chain: `2048`.
- Maximum retained skipped keys per device session: `2048`.
- Maximum inactive sessions per remote device: `4`.
- Maximum simultaneous unacknowledged initiations per device pair: `2`.
- Maximum session state including SPQR state: `2 MiB`.
- One remote account may expose at most `16` active devices.
- Limits are identical across supported clients and are not remotely raised.

The local persistence identifiers are closed: `MBA1` is the version-1 managed
ML-KEM-Braid profile plaintext before protected-store sealing, `MBM1` is the
version-1 managed Braid state-machine snapshot, `TRC1` is the version-1 managed
Triple-Ratchet component-provider snapshot, and `TRS1` is the complete
version-1 account-scoped durable session state that binds its exact component
snapshot. None is accepted from a peer or transport. Unknown version/suite,
non-canonical length, nested-state mismatch, trailing bytes or a state larger
than the fixed provider/2 MiB session bounds rejects before ratchet, replay or
application mutation. These identifiers do not create exportable plaintext
state: the containing account store remains authenticated and encrypted.

Skipped keys are deleted immediately after successful use and after the
session's deterministic retirement boundary. Message-key and old chain-key
deletion is part of the same durable transaction as ciphertext acceptance.
Clock time alone never decides skipped-key deletion.

### 9.3 Session convergence

Each local device maintains one active and up to four inactive sessions per
remote device, following Sesame-style convergence:

- a successfully decrypted initiation becomes active;
- the former active session moves to inactive;
- receiving a valid message on an inactive session reactivates it;
- identical simultaneous initiations converge by lexicographically comparing
  authenticated 32-byte session IDs; the lower ID is canonical;
- the non-canonical session remains decrypt-only until the mailbox retention
  horizon passes, then is destroyed;
- a changed device key or revoked device never silently creates a replacement
  session.

All state changes are transactional. Failure leaves ratchet state, dedup and
outbox byte-equivalent to their prior committed state.

The initiator retransmits byte-identical DPH2 with the same logical/pre-key
claim operation until authenticated `SessionAck` or signed expiry; transport
retries change only outer attempt IDs. A recipient receiving DPE2 before DPH2
may hold at most two opaque envelopes and 128 KiB per unknown session for ten
minutes. It performs no trial decryption, fetches/reconciles exact DPH2, then
processes canonical order. Overflow, expiry or changed DPH2 bytes reject
without session state.

## 10. `DPE2` pairwise envelope

`DPE2`, version 1, suite `0x0201`, has:

| Tag | Value | Type / exact size |
|---:|---|---:|
| 1 | network ID | octets, 16 |
| 2 | session ID | octets, 32 |
| 3 | sender device ID | octets, 32 |
| 4 | recipient device ID | octets, 32 |
| 5 | random envelope operation ID | octets, 32 |
| 6 | exact embedded DTR2 | octets, 189, 285, 349, 1149 or 1341 |
| 7 | padded DMC2 ciphertext plus AEAD tag | octets, 4112, 16400, 32784 or 49152 |

All IDs are nonzero. Tag 6 must independently pass the closed DTR2 parser and
its nonzero network ID must equal DPE2 tag 1.
The only legal total DPE2 sizes are 4,513, 4,609, 4,673, 5,473, 5,665,
16,801, 16,897, 16,961, 17,761, 17,953, 33,185, 33,281, 33,345, 34,145,
34,337, 49,553, 49,649, 49,713, 50,513 and 50,705 bytes. They are exactly
`212 + exactDTR2Bytes + ciphertextBytes`; no size inside the intervals parses.

Define:

```text
dpe2Header = canonical DPE2 containing tags 1..6
headerHash32 = SHA256-D("Deep/Messaging/V2/ratchet-header", exactDTR2)
nonce24 = first24(SHA256-D(
  "Deep/Messaging/V2/dpe2-nonce",
  sessionId32 || operationId32 || headerHash32))
dpe2Aad = CTX("Deep/Messaging/V2/dpe2-aead-ad", 0x0201,
              dpe2Header, headerHash32)
exactEnvelopeHash32 = SHA256-D(
  "Deep/Messaging/V2/exact-dpe2-replay", exactDPE2)
```

Tag 7 is XChaCha20-Poly1305-IETF under the combined message key, `nonce24` and
`dpe2Aad`. A message key and its authenticated counter tuple are single-use, so
the nonce cannot repeat under one key. `operationId32` is generated once per
destination envelope, survives transport retry and is neither a content hash
nor the DMC2 logical message ID.

Before releasing plaintext, durable dedup binds the exact ratchet-state
commitment, session ID, authenticated DTR2 counters, operation ID,
`headerHash32`, `exactEnvelopeHash32`, inbox-journal predecessor and retention
commitment. The same operation with the same exact envelope returns the prior
outcome without advancing either ratchet. The same operation with changed
bytes, or a reused authenticated counter/PQ-key commitment, latches the
session. The inner DMC2 `conversationId || logicalMessageId` is checked only
after AEAD and canonical DMC2 validation and provides cross-device/fanout
logical dedup.

DPE2 has no Ed25519 or account signature. Authentication comes from the
authenticated handshake and evolving ratchet state. Ordinary content therefore
does not create a transferable long-term signature. Explicit signed documents,
device directories and group governance use separate content types and domains.

The precise deniability claim is limited: an online peer authenticates ordinary
content inside its session, but a stored DPE2 is not a third-party-verifiable
long-term signature by the account/device authority. Signed DPA1/DPD1/DMD1/DCB1/
group governance records are intentionally non-deniable. PQXDH/Triple Ratchet do
not claim deniability against an active quantum adversary or a compromised
endpoint, and service timing/metadata may still be evidence independent of
message cryptography.

## 11. Payload and padding boundary

The DPE2 plaintext is exactly one canonical `DMC2` defined by the companion
contact/group specification, followed by random padding and a final `u32be`
unpadded length. The total plaintext uses the smallest permitted bucket:

`4096`, `16384`, `32768` or `49136` bytes.

Content larger than the largest bucket is an encrypted attachment and DMC2
carries only its bounded descriptor. Implementations SHOULD batch acknowledgments
and apply transport-level jitter; crypto padding alone does not prevent timing
correlation.

Padding is generated by the OS CSPRNG and authenticated. Parsers verify the
bucket, length trailer and exact inner DMC2 before application callbacks.

## 12. Multi-device fanout

One logical user message has one 32-byte `logicalMessageId` and one immutable
canonical DMC2 plaintext. The sending device encrypts independent DPE2 copies
to every active recipient device and every other active sender device. Ratchet
state, envelope operation ID and ciphertext differ per destination.

The permanent Deep ID (`DID1`) never appears in DPK2, DPH2, DTR2 or DPE2 and
is never a session, prekey, mailbox or dedup key. Contact bootstrap resolves
DID1/DAB1/DCB1 to a current `DeepAccountId32` plus exact DPA1/DRS1/DMD1/DPD1
closure before selecting DPK2. A future account binding may change that current
account closure without changing the permanent DID1; existing sessions do not
reinterpret it and a new verified session is required.

`ContactHello`, `ContactAccept`, device updates, call signaling and group
governance/application objects are canonical DMC2 events. Group fanout uses the
same immutable DMC2/DGM1 logical ID but independent DPE2 operation IDs and
ciphertexts for every active member device. No contact or group consumer may
copy `logicalMessageId` into DPE2 tag 5, derive one from the other or use an
outer operation ID as application materialization authority.

The receiver materializes a logical message at most once by
`conversationId || logicalMessageId`, while retaining per-device delivery and
receipt state. The guarantee is at-least-once transport attempts, idempotent
mailbox storage and outbox retry, and at-most-once local materialization after
successful authentication. The protocol does not claim exactly-once network
delivery.

## 13. Offline and retention semantics

Cryptographic identity continuity is independent of message retention.

- A fresh install can create an account without a network.
- A returning device can reacquire signed current heads after any offline
  period supported by the authority-history service.
- Ordinary message retention is a signed policy with production default and
  maximum `30 days`; disappearing-message policy may select a shorter value.
- Expired ordinary ciphertext may be unavailable even though the account
  reconnects successfully.
- Device directory, revocation, contact-route and group state checkpoints are
  retained for at least `400 days`, with root-anchored re-enrollment after that
  horizon.
- A durable outbox surfaces `pending`, `delivered`, `expired` and
  `outcome-unknown`; it never reports failure merely because one attempt timed
  out.

After trust-history expiry, re-enrollment preserves the account only after
recovery-root verification and a fresh externally witnessed current head. It
does not reinterpret stale routing or ratchet state.

## 14. Rollback, replay and compromise

- Protected ratchet state includes session ID, suite, transcript hash, local
  and remote device generations, directory heads, counters and a monotonic
  storage generation.
- The immutable device/directory axes are committed before a ratchet state can
  be used.  The directional ordering below is exact; implementations MUST NOT
  sort or swap the local and remote halves:

  ```text
  stateBinding32 = SHA256-D(
    "Deep/Messaging/V2/state-binding",
    u16be(suite) || sessionId32 || transcriptHash64 ||
    localDeviceId32 || u64be(localDeviceGeneration) || localDirectoryHead32 ||
    remoteDeviceId32 || u64be(remoteDeviceGeneration) || remoteDirectoryHead32)
  ```

  `suite` is exactly `0x0201`; both generations are at least one; every fixed
  octet field is nonzero.  A durable state whose recomputed binding differs
  rejects before ratchet, dedup or application mutation.
- Every accepted send/receive transition fences the hybrid ratchet material
  and the durable replay mutation with these exact commitments:

  ```text
  pqKeyReuse32 = SHA256-D(
    "Deep/Messaging/V2/pq-key-reuse", pqMessageKey32)

  pqTuple32 = SHA256-D(
    "Deep/Messaging/V2/pq-tuple",
    stateBinding32 || u64be(ecN) || u64be(sckaEpoch) || u64be(sckaN) ||
    nextPqStateCommitment32)

  dedupMutation32 = SHA256-D(
    "Deep/Messaging/V2/dedup-mutation",
    stateBinding32 || sessionId32 ||
    u64be(ecN) || u64be(sckaEpoch) || u64be(sckaN) ||
    operationId32 || exactHeaderHash32 || exactEnvelopeHash32 ||
    u64be(expectedJournalGeneration) || journalPredecessor32 ||
    retentionCommitment32 || u32be(consumedPqTupleCount) ||
    consumedPqTuple32[0] || ... || consumedPqTuple32[N-1])
  ```

  `consumedPqTupleCount` is at least one, fits `u32`, and every listed tuple is
  nonzero and unique.  Tuple order is the exact transition order and MUST NOT
  be sorted.  Reuse of `pqKeyReuse32`, mismatch of `pqTuple32`, journal CAS
  failure or mutation-commitment mismatch aborts the entire durable mutation.
- Restoring older protected state while a newer external/device checkpoint
  exists latches the session and requires a new handshake.
- Duplicate exact DPE2 returns the prior result without advancing a ratchet.
- Same operation ID with different bytes is a conflict.
- Replayed DPH2 after a consumed one-time prekey exact-replays only if every
  byte and committed session match; otherwise it rejects.
- Account reset, changed DeepAccountId generation or device revocation cannot
  be repaired by trying a legacy decoder. A fresh exact session is required.
- Compromise of a current device exposes its local plaintext and active state.
  It does not expose recovery roots or other devices by design. PCS begins only
  after both sides contribute fresh uncompromised ratchet material.

## 15. Post-quantum claim

Suite `0x0201` targets hybrid confidentiality and FS/PCS: an attacker must
break both the classical and ML-KEM ratchet components to recover combined
message keys under the assumptions of the pinned construction.

Authentication remains Ed25519. Therefore an active cryptographically relevant
quantum attacker is outside the authentication claim. ML-DSA-65 is not placed
into every message or activated merely to use a PQ label. It remains a future
rare-certificate option after mobile provider, bandwidth, lifecycle and
independent-review gates.

FIPS 203 errata and SP 800-227 guidance are release inputs. A provider is pinned
by source revision, build provenance, enabled algorithm set and KAT result.
Custom ML-KEM, Ed25519, X25519, XChaCha20 or SPQR arithmetic is forbidden.

## 16. Implementation source policy

To reduce development time, the preferred evaluation order is:

1. Signal's Rust `libsignal` PQXDH and
   `signalapp/SparsePostQuantumRatchet` for 1:1 algorithm behavior;
2. a thin memory-safe native boundary exposing Deep-owned canonical inputs and
   outputs to .NET/Android/Windows;
3. an independent implementation only for vectors and differential tests.

Before adoption, engineering and legal review MUST approve license obligations,
upstream support policy, platform ABI, reproducible builds and security-update
ownership. The application MUST NOT depend on unversioned private libsignal
wire bytes. A pinned fork may contain only reviewed portability, zeroization and
Deep codec adapters; protocol changes require a new Deep suite/version.
When upstream provider internals do not clear all secret intermediates, such a
minimal pinned zeroization fork is mandatory rather than optional. The review
must cover success, implicit-rejection, error and unwind paths; an outer FFI
buffer wipe does not satisfy this requirement.

For Deep V1 ML-KEM-768, the selected implementation candidate is vendored
`mlkem-native` v2.0.0 behind a Deep-owned narrow C ABI. The initial build uses
its portable C backend and upstream intermediate-zeroization behavior unchanged;
native ARM64/x64 backends require separate vector, benchmark and binary-review
evidence before activation. Bouncy Castle and RustCrypto are differential
oracles only and never runtime fallbacks.

SimpleX PQ ratchet code is useful independent design evidence for recurrent
KEM injection and transport separation, but it is not wire-compatible with
Deep and must not be copied without license and cryptographic review.

## 17. Threat and metadata boundary

| Adversary/event | Required result or bounded claim |
|---|---|
| passive network recorder | Cannot recover content; hybrid initial and ongoing secrets resist harvest-now/decrypt-later if either component and combiner remain secure. |
| malicious prekey/directory service | Can withhold or equivocate; cannot mint valid signed lineage. Client detects stale, changed same-generation and conflicting heads. |
| compromised old message key | Does not reveal later or earlier message keys after deletion. |
| temporary device compromise | Exposes current device state; future secrecy recovers only after fresh uncompromised Double and SPQR contributions. |
| compromised recovery phrase | Account authority and backup wrapping are lost; remote rate limiting cannot protect an offline mnemonic. |
| revoked device while peers offline | Device may receive data sent before peers learn revocation; eventual update stops future fanout and triggers group rekey. |
| recipient of a message | Can authenticate it within the session but ordinary content has no transferable long-term signature. |
| XNode, Registry or mailbox operator | Sees only transport capabilities, timing, padded class and operational metadata assigned to its role; never DMC2 plaintext. |
| global observer or colluding entry/exit | Traffic correlation remains possible; this profile makes no global-observer anonymity claim. |

Stable account/device IDs are inner-protocol values. Outer transports use
random, rotatable capabilities. Logs contain no account, device, session,
message, route, prekey or group identifier; approved diagnostics use local
coarse counters or separately salted non-reversible labels.

## 18. Mandatory implementation and release gates

`E2EE-01`, `APPLICATION-CORE-CODEC-01` and `ATTACHMENT-CODEC-01` are
specification-complete and their machine-registry package markers may be
`FROZEN_CLEAN_BREAK`. The old umbrella `APPLICATION-CODEC-01` is explicitly
incomplete while DCB1/DCR1/DIA1 and downstream event producers remain
unfrozen. Every production marker MUST remain `NOT_ACTIVE`.
The required vector skeleton has these positive families:

- one-time and last-resort DPK2 with all three signatures and exact sizes;
- all three DPH2 padding buckets, both prekey kinds, independent transcript and
  full-replay hashes and exact XPC1 claim binding;
- all five exact DTR2 payload-size forms covering every closed Braid kind;
- all twenty DPE2 header/bucket size combinations, exact nonce/AAD/message-key
  derivation, exact replay and out-of-order/skipped-key commit;
- Android-to-Windows and Windows-to-Android SessionInit, text and self-device
  fanout using one inner logical ID and different per-destination operation
  IDs. ContactHello and DGM1 vectors belong to CONTACT-/GROUP-CODEC after those
  reserved kinds are frozen.

Negative families cover every wrong magic/version/suite/field count/order,
unknown tag, reserved value, truncation/trailing byte, illegal exact size,
optional-pair mismatch, zero ID/key, invalid time/counter relation, signature
projection substitution, XPC1/DPK2/selection mismatch, changed DPH2 payload
under one claim/session, DTR2 kind/chunk mismatch, counter/PQ-key reuse,
cross-session dedup substitution, changed DPE2 under one operation ID and DID1
substitution into an account/device/session field. Each negative vector records
the expected pre-validation stage and zero crypto/mutation/application callback
counts where applicable.

Production GO requires all of the following:

1. Generated codecs and concrete positive/negative vectors conform to
   `deep-crypto-v1.registry.json`; each application package activates only its
   frozen DMC2 kinds, reserved kinds reject, and no retired alias exists.
2. BIP-39 official vectors plus Deep Recovery role vectors for network and
   account-generation changes.
3. Exact DPA1/DPD1/DRS1 integration and cross-role-key negative tests.
4. FIPS 203 KATs, current errata handling and two-provider ML-KEM agreement.
5. Pinned Triple Ratchet/ML-KEM-Braid source and Deep-owned DTR2 transition
   vectors from two independent implementations, including every exact full
   Braid payload form and mandatory internal HMAC.
6. Malformed tag/order/reserved/length/trailing/unknown/suite/version tests
   proving rejection before callbacks and mutation.
7. One-time-prekey atomic claim, lost response, crash-before/after commit,
   replay and same-ID fork tests.
8. Out-of-order, skipped-key, simultaneous-initiation, rollback, session
   convergence and deterministic deletion tests at every limit.
9. Android arm64, Windows x64/arm64 and server benchmarks for CPU, allocations,
   storage, battery, thermal effect and cancellation.
10. Destructive account creation/recovery/reset rehearsals proving no Session
    or 13-word material remains in database, resources, packages or logs.
11. Interoperability across at least two physical clients through XPoint and
    one transport-independent loopback/P2P adapter.
12. Independent cryptography and privacy review with P0=0 and P1=0.

No build flag, environment variable or server response may bypass these gates
or activate a lower suite.

## 19. Staged implementation plan

The stages are implementation order, not compatibility eras. Only the final
suite is releasable; intermediate formats are test-only and are deleted before
cutover.

1. **Identity cutover** — replace Session identity/recovery/database generation
   with DeepRecoveryV1 plus exact DPA1/DPD1/DRS1; reset all UAT data.
2. **Provider spike** — bind pinned ML-KEM and SPQR sources on Android and
   Windows, run KAT/resource evidence, then freeze the provider.
3. **Canonical codecs** — generate DPK2/DPH2/DTR2/DPE2 plus the frozen
   application-core/attachment codecs from the registry, preserve reserved-kind
   rejection, and run hostile-input vectors. Contact/group/call/history codecs
   advance the registry only after their exact producer closures freeze.
4. **Pairwise engine** — implement atomic prekeys, PQXDH, Triple Ratchet,
   transactional persistence and Sesame-style session convergence.
5. **Contact and multi-device** — implement the companion specification,
   self-device fanout, recovery and eventual revocation.
6. **Groups** — implement the bounded owner-sequenced `DeepSmallGroupV1`
   pairwise-ratcheted fanout from the companion specification. Keep group
   storage and transport interfaces independent so a later MLS engine replaces
   it by a clean profile cutover, never by a silent fallback.
7. **Transport integration** — carry identical envelopes over XPoint,
   on-premise and test mesh adapters with no crypto branching.
8. **Physical and adversarial gates** — complete device, crash, rollback,
   retention, censor-network and independent-review evidence.
9. **Single clean cutover** — reset all pre-production identities and stores,
   remove dark/legacy readers and ship one generation.

## 20. References

- BIP-39: <https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki>
- Signal PQXDH: <https://signal.org/docs/specifications/pqxdh/>
- Signal Double and Triple Ratchet:
  <https://signal.org/docs/specifications/doubleratchet/>
- Signal ML-KEM Braid logical state machine and ML-KEM-768 component sizes:
  <https://signal.org/docs/specifications/mlkembraid/>
- Signal SPQR implementation evidence:
  <https://github.com/signalapp/SparsePostQuantumRatchet>
- Signal Sesame multi-device session management:
  <https://signal.org/docs/specifications/sesame/>
- NIST FIPS 203 ML-KEM: <https://csrc.nist.gov/pubs/fips/203/final>
- NIST FIPS 204 ML-DSA (retained provider/vector oracle only):
  <https://csrc.nist.gov/pubs/fips/204/final>
- NIST SP 800-227 KEM guidance:
  <https://csrc.nist.gov/pubs/sp/800/227/final>
- SimpleX agent protocol, independent PQ ratchet and queue-rotation evidence:
  <https://github.com/simplex-chat/simplexmq/blob/stable/protocol/agent-protocol.md>
