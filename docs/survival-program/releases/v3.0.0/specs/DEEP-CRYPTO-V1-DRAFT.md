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

The older `deep-crypto-v1.registry.json` remains non-production dark-path
evidence. Its retired `DPAC`, `DPDC`, `DPKB` and `DPHI` records MUST NOT be
accepted as aliases for this profile. The implementation work package MUST
generate a new machine registry and vectors for the records defined below
before code is activated.

For governance reproducibility, the retained dark-path registry has the exact
primitive-size inventory below. These values are test-oracle inputs, not an
authorization to emit its retired records:

| Registry item | Bytes |
|---|---:|
| Ed25519 public key / signature | 32 / 64 |
| X25519 public key / shared secret | 32 / 32 |
| ML-KEM-768 encapsulation key / decapsulation key | 1184 / 2400 |
| ML-KEM-768 ciphertext / shared secret | 1088 / 32 |
| ML-DSA-65 public key / private key / signature | 1952 / 4032 / 3309 |
| XChaCha20 nonce / AEAD tag | 24 / 16 |
| retained registry record maximum | 65535 |

The retained registry's domain inventory is likewise frozen only as evidence:
`Deep/Recovery/V1/extract`, `Deep/Recovery/V1/account-signing-seed`,
`Deep/Recovery/V1/account-pq-signing-seed`,
`Deep/Recovery/V1/recovery-authorization-seed`,
`Deep/Recovery/V1/backup-wrapping-seed`,
`Deep/Identity/V1/account-certificate`,
`Deep/Identity/V1/device-certificate`, `Deep/Identity/V1/account-id`,
`Deep/Handshake/V1/prekey-bundle`, `Deep/Handshake/V1/transcript`,
`Deep/Handshake/V1/ec-root`, `Deep/Handshake/V1/pq-root` and
`Deep/Handshake/V1/initial-aead`. None is an alias for a V2 messaging domain.

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
- `HKDF-Extract-512` and `HKDF-Expand-512` are RFC 5869 HKDF with SHA-512.
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
| `0x0201` | `DHM2-X25519-MLKEM768-TRIPLE-XCHACHA20` | X25519, ML-KEM-768, Ed25519 certificate/prekey authentication, SHA-256/SHA-512, HKDF-SHA-512, XChaCha20-Poly1305-IETF, Double Ratchet and SPQR/ML-KEM Braid |

Both classical and PQ components are mandatory. There is no classical-only,
PQ-only, retry-with-weaker-suite or environment-controlled downgrade path.
Suite `0x0202` is reserved for later hybrid long-lived authentication and MUST
reject until separately frozen. Negotiation means selecting an exact mutually
supported signed suite before session creation; it never means probing weaker
algorithms after failure.

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
2. derive the four DPA1 signing roles for account generation zero and the
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
zero only. A destructive account reset creates a new phrase/account lineage;
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

## 7. `DPK2` asynchronous prekey bundle

`DPK2`, version 1, suite `0x0201`, has:

| Tag | Value | Exact size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | responder DeepAccountId hash | 32 |
| 3 | responder device ID | 32 |
| 4 | exact DPD1 ArtifactRef | 38 |
| 5 | device-directory generation | 8 |
| 6 | device-directory head hash | 32 |
| 7 | bundle ID | 32 |
| 8 | issued-at Unix seconds | 8 |
| 9 | expires-at Unix seconds | 8 |
| 10 | device X25519 identity public key | 32 |
| 11 | signed X25519 prekey public key | 32 |
| 12 | signed X25519 prekey ID | 32 |
| 13 | one-time X25519 prekey public key | 0 or 32 |
| 14 | one-time X25519 prekey ID | 0 or 32 |
| 15 | ML-KEM-768 encapsulation key | 1184 |
| 16 | ML-KEM prekey ID | 32 |
| 17 | ML-KEM key kind (`1=one-time`, `2=last-resort`) | 1 |
| 18 | last-resort reuse limit (`0` for one-time, otherwise `1..64`) | 2 |
| 19 | policy generation | 8 |
| 20 | device Ed25519 signature | 64 |
| 21 | not-before Unix seconds | 8 |

Tags 13 and 14 are both empty or both exact. Tag 17 value one requires reuse
limit zero; value two requires `1..64`, expiry no later than 30 days and a
durable per-key claim counter. Each active bundle epoch lasts at most 30 days.
Signed X25519 prekeys rotate at least every 30 days and after 10,000
sessions, whichever comes first. A device publishes enough one-time keys for
its measured epoch peak plus 25%, bounded to `32..4096`.

To support an offline recipient, a device MAY pre-generate and sign up to
fourteen non-overlapping future epochs covering at most 400 days. Each epoch has
independent X25519/ML-KEM prekeys and locally protected private material; the
service exposes only the currently valid epoch plus one overlap epoch and cannot
move `not-before` or expiry. Future private keys are never uploaded. Inventory
exhaustion is an explicit `PreKeysUnavailable`, not classical fallback.

The signature covers
`SIGINPUT("Deep/Messaging/V2/prekey-bundle", 0x0201, unsignedDPK2)`, where
tag 20 is omitted. The verifier resolves exact DPD1, DPA1, DRS1 and device
directory heads, checks tag 10 against DPD1, and checks every generation,
expiry and revocation binding before signature or KEM use.

## 8. `DPH2` hybrid initiation

`DPH2`, version 1, suite `0x0201`, has:

| Tag | Value | Exact size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | initiator account hash | 32 |
| 3 | initiator device ID | 32 |
| 4 | initiator DPD1 ArtifactRef | 38 |
| 5 | responder account hash | 32 |
| 6 | responder device ID | 32 |
| 7 | responder DPK2 hash | 32 |
| 8 | session ID | 32 |
| 9 | initiator device X25519 identity public key | 32 |
| 10 | initiator ephemeral X25519 public key | 32 |
| 11 | responder signed-prekey ID | 32 |
| 12 | responder one-time-X25519 ID | 0 or 32 |
| 13 | responder ML-KEM prekey ID | 32 |
| 14 | ML-KEM-768 ciphertext | 1088 |
| 15 | initiator's fresh initial Double Ratchet X25519 public key | 32 |
| 16 | initial payload nonce | 24 |
| 17 | initial encrypted DMC2 payload | `16..32784` |

`sessionId = SHA256-D("Deep/Messaging/V2/session-id", network16 ||
initiatorAccount32 || initiatorDevice32 || responderAccount32 ||
responderDevice32 || DPK2Hash32 || initiatorEphemeral32 || randomNonce32)`.
The random nonce is included inside encrypted SessionInit DMC2 content;
session IDs are not caller-selected or reused.

Before computing the transcript, the initiator generates a fresh X25519
Double-Ratchet key pair for this initiation; its public key is tag 15. The
responder signed X25519 prekey (DPK2 tag 11) is Bob's initial ratchet public
key. These session ratchet keys are not device agreement keys.

After full responder lineage and DPK2 validation, the initiator computes:

```text
DH1 = X25519(initiatorDeviceIdentityPrivate,
             responderSignedPrekeyPublic)
DH2 = X25519(initiatorEphemeralPrivate,
             responderDeviceIdentityPublic)
DH3 = X25519(initiatorEphemeralPrivate,
             responderSignedPrekeyPublic)
DH4 = X25519(initiatorEphemeralPrivate,
             responderOneTimePrekeyPublic) // only when present
PQ  = ML-KEM-768.Encaps(responderMlKemPrekey).sharedSecret
```

All DH outputs are nonzero. Define `header` as canonical DPH2 with tag 17
omitted and tag 16 present:

```text
transcriptHash = SHA512-D(
  "Deep/Messaging/V2/handshake-transcript",
  LP32(exactDPK2) || LP32(header))

ikm = DH1 || DH2 || DH3 || [DH4] || PQ
prk = HKDF-Extract-512(transcriptHash, ikm)

SKec = HKDF-Expand-512(prk,
  "Deep/Messaging/V2/ec-root" || 0x00 || LP32(transcriptHash), 32)
SKscka = HKDF-Expand-512(prk,
  "Deep/Messaging/V2/spqr-root" || 0x00 || LP32(transcriptHash), 32)
initKey = HKDF-Expand-512(prk,
  "Deep/Messaging/V2/initial-aead" || 0x00 || LP32(transcriptHash), 32)
```

Tag 17 is XChaCha20-Poly1305-IETF under `initKey`, tag 16 and associated data
`header || transcriptHash`. The initial plaintext is exactly one DMC2 record
with content kind `SessionInit`. Its canonical payload contains the random
session nonce, exact initiator ADC1/ADP1/DPA1/DRS1/DMD1/DPD1 closure, the exact
DPH2-header hash and zero or one length-prefixed first application event. The
optional event uses the same closed application-kind/payload codec as DMC2 but
has no independent ratchet envelope; first-contact `ContactHello` is carried
here and materialized only after the session transaction commits.

The responder validates the initiator closure against a fresh account-directory
head, checks tag 9 against exact DPD1, then atomically consumes exact prekeys, creates Triple
Ratchet state, decrypts DMC2 and commits inbox dedup in one transaction. A lost
response exact-replays the committed outcome. Changed bytes under a claimed
operation or session ID reject and latch the affected session.

KEM decapsulation, lineage, transcript, AEAD and prekey errors are externally
one coarse `HandshakeRejected`; diagnostics contain only a local error class
and random correlation ID.

## 9. Mandatory Triple Ratchet

### 9.1 Construction

Suite `0x0201` uses these closed transitions:

1. `CreateInitiation`: Alice generates tag-15 key pair and KEM/DH material,
   derives SKec/SKscka, then calls `InitAlice(SKec,
   bobSignedPrekeyPublic, aliceTag15KeyPair)` and `InitSckaAlice(SKscka)`.
2. `AcceptInitiation`: Bob validates/claims DPK2, derives the same secrets,
   calls `InitBob(SKec, bobSignedPrekeyKeyPair)` and
   `InitSckaBob(SKscka)`, then processes Alice's tag-15 receive step.
3. `ProcessFirstRatchetMessage`: Bob's first DPE2 response advances with a fresh
   Bob ratchet key and carries `SessionAck(DPH2Hash32, sessionId32)`. Alice marks
   the initiation acknowledged only after that authenticated response commits.

The responder signed-prekey private key remains available only for the bounded
DPK2 claim/replay horizon. Signal Triple Ratchet/SPQR behavior is pinned by
revision; Deep freezes its own canonical headers and transition vectors.

Each logical message step obtains `ecMessageKey32` and `pqMessageKey32` from
the two ratchets and derives:

```text
messageKey32 = HKDF-Expand-512(
  HKDF-Extract-512(
    SHA512-D("Deep/Messaging/V2/triple-ratchet-salt", sessionId32),
    ecMessageKey32 || pqMessageKey32),
  "Deep/Messaging/V2/message-key" || 0x00 ||
    LP32(sessionId32 || ecN:u64be || sckaEpoch:u64be ||
      sckaN:u64be || headerHash32),
  32)
```

`ecN`, `sckaEpoch` and `sckaN` are exact counters committed by the canonical
combined header. Neither component may be replaced by zeros, cached across
counter tuples or
treated as optional. Ratchet algorithm behavior follows the pinned Signal
Triple Ratchet specification. The implementation work package MUST pin exact
upstream source revisions and freeze an independent Deep codec/vector set
before activation.

### 9.2 State limits

- Maximum forward message-number gap per chain: `2048`.
- Maximum retained skipped keys per device session: `2048`.
- Maximum inactive sessions per remote device: `4`.
- Maximum simultaneous unacknowledged initiations per device pair: `2`.
- Maximum session state including SPQR state: `2 MiB`.
- One remote account may expose at most `16` active devices.
- Limits are identical across supported clients and are not remotely raised.

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

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | session ID | 32 |
| 3 | sender device ID | 32 |
| 4 | recipient device ID | 32 |
| 5 | operation ID | 32 |
| 6 | ratchet header | `1..8192` |
| 7 | padded ciphertext | `32..49152` |

`operationId` is a random idempotency identifier and not a content hash. The
ratchet header is the canonical Deep encoding of the exact Double Ratchet and
SPQR public header for one step. Its codec is part of the required machine
registry; opaque upstream serialization is forbidden.

Associated data is canonical DPE2 with tag 7 omitted plus
`SHA256-D("Deep/Messaging/V2/ratchet-header", tag6)`. Tag 7 is
XChaCha20-Poly1305-IETF ciphertext under the combined message key; the nonce is
derived by the frozen ratchet codec from session ID and message number and can
never repeat under one key.

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

Production GO requires all of the following:

1. New machine registry and schemas for DPK2, DPH2, DPE2, DMC2 and companion
   records, with no retired alias.
2. BIP-39 official vectors plus Deep Recovery role vectors for network and
   account-generation changes.
3. Exact DPA1/DPD1/DRS1 integration and cross-role-key negative tests.
4. FIPS 203 KATs, current errata handling and two-provider ML-KEM agreement.
5. Pinned Triple Ratchet source and Deep-owned canonical header vectors from
   two independent implementations.
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
3. **Canonical codecs** — generate registry/codecs/vectors for DPK2, DPH2,
   DPE2 and DMC2 with hostile-input tests.
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
