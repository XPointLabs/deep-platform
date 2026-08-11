# DeepRecoveryV1 and Deep Hybrid Messaging V1

Status: **design draft; dark-path work only; not production activation
authority**

Decision: DR-0003

Work package: DNP1-SPEC-crypto

## 1. Security objective

This document freezes the first reviewable shape of:

- a 24-word Deep recovery phrase backed by 256 bits of operating-system CSPRNG
  entropy;
- role-separated account, recovery and device key roots;
- an asynchronous hybrid X25519 + ML-KEM handshake;
- a path to hybrid classical/PQ authentication and a reviewed hybrid ratchet.

It does not authorize a public security claim or production activation. The
current DPE1/DMC1 construction is evidence only and must not be renamed into
this profile.

## 2. Normative language and byte rules

`MUST`, `MUST NOT`, `SHOULD` and `MAY` are normative.

- Octet strings are length-exact. No parser accepts trailing bytes.
- Integers are unsigned, fixed-width and big-endian.
- Text in cryptographic domains is printable ASCII and is never locale
  normalized.
- Human recovery text is UTF-8 NFKD before BIP-39 processing.
- `LP32(x)` is `u32be(length(x)) || x`.
- `SHA256-D(label, x)` is
  `SHA-256(ASCII(label) || 0x00 || LP32(x))`.
- `SHA512-D(label, x)` is
  `SHA-512(ASCII(label) || 0x00 || LP32(x))`.
- `HKDF-Extract-512` and `HKDF-Expand-512` are RFC 5869 HKDF with SHA-512.
- `SIGINPUT(label, suite, record)` is
  `ASCII(label) || 0x00 || suite:u16 || LP32(record)`.
- Secret intermediates MUST be zeroed as soon as their successor state is
  committed.
- Every all-zero X25519 shared secret is rejected.
- Unknown suite, version, field tag, flag or non-zero reserved field is
  rejected before a signer, KEM decapsulation, state mutation or payload
  allocation.

### 2.1 Canonical record

All records in this draft use:

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

Tags are strictly increasing and unique. A record is at most 65535 (65,535)
bytes.
All scalar, count-derived and total-length checks occur before copying or
cryptographic callbacks.

## 3. DeepRecoveryV1

### 3.1 Phrase generation and decoding

1. Generate exactly 32 bytes from the platform OS CSPRNG.
2. Encode those 256 bits with the canonical English BIP-39 word list:
   eight checksum bits and exactly 24 words.
3. The only accepted word-list identifier is `bip39-en-v1`.
4. Input is trimmed between words, lower-cased with invariant rules and
   normalized to UTF-8 NFKD. Exactly 24 known words and a valid checksum are
   required before any derivation.
5. V1 accepts only the empty BIP-39 passphrase. A non-empty passphrase is a
   future explicit profile, not an automatically probed alternative.
6. The UI calls this a **Deep Recovery Phrase**. It MUST NOT claim wallet
   interoperability and MUST warn against importing a wallet mnemonic.

BIP-39 defines 24 words as 256 bits of entropy plus an 8-bit checksum. Its
checksum detects many transcription errors but is not authentication and has
a 1-in-256 random false-accept probability.

### 3.2 BIP-39 seed boundary

The phrase is converted to the standard 64-byte BIP-39 seed:

```text
bip39Seed = PBKDF2-HMAC-SHA512(
    password = UTF8_NFKD(mnemonic),
    salt     = UTF8_NFKD("mnemonic"),
    rounds   = 2048,
    length   = 64)
```

That value is never used directly as an Ed25519, X25519, ML-KEM, ML-DSA,
mailbox, device, push, storage or AEAD key.

### 3.3 Deep recovery root

For a 16-byte network identifier and an unsigned 64-bit account generation:

```text
extractSalt = SHA-512(ASCII("Deep/Recovery/V1/extract"))
recoveryPrk = HKDF-Extract-512(extractSalt, bip39Seed)
context     = networkId16 || accountGeneration:u64

accountSigningSeed32 = HKDF-Expand-512(
    recoveryPrk,
    ASCII("Deep/Recovery/V1/account-signing-seed") || 0x00 || LP32(context),
    32)

accountPqSigningSeed32 = HKDF-Expand-512(
    recoveryPrk,
    ASCII("Deep/Recovery/V1/account-pq-signing-seed") || 0x00 || LP32(context),
    32)

recoveryAuthorizationSeed32 = HKDF-Expand-512(
    recoveryPrk,
    ASCII("Deep/Recovery/V1/recovery-authorization-seed") || 0x00 || LP32(context),
    32)

backupWrappingSeed32 = HKDF-Expand-512(
    recoveryPrk,
    ASCII("Deep/Recovery/V1/backup-wrapping-seed") || 0x00 || LP32(context),
    32)
```

The account signing seed is input to the reviewed deterministic Ed25519 key
generation API. The PQ account seed is reserved for the FIPS 204 deterministic
ML-DSA key-generation input exposed by the selected provider; it is never
passed to a different algorithm. The recovery authorization key has a distinct
signing domain and cannot sign messages, devices or routing artifacts. The
backup seed is input to a separately specified backup KDF; it is not an AEAD
key directly.

Device signing, device agreement, mailbox holder, router, storage, push and
per-conversation roots are generated independently by the device CSPRNG. They
are authorized by versioned public certificates. They are not deterministic
children of the mnemonic.

Recovery-derived account private material is loaded only inside an explicit
recovery or device-enrollment ceremony and is erased afterward. Routine
messaging, sync, push, mailbox and calls use device-scoped keys. The later
multi-device specification must define how an already authorized device and
the recovery authority approve or revoke another device without copying an
account private key between devices.

### 3.4 Recovery security policy

- Phrase display is an explicit local ceremony with screenshot, screen-share,
  clipboard, accessibility announcement, telemetry and crash-dump suppression.
- The phrase, `bip39Seed`, `recoveryPrk` and role seeds never leave the client
  in plaintext and never enter logs, metrics, Registry, XNode, push/file
  services or cloud backup.
- Restore derives a new account instance only after the user confirms the
  profile, network and destructive-reset warning.
- A wrong valid phrase derives a different account; it is not searched against
  server data to reveal account existence.
- SLIP-39 is a possible later split-backup profile. It does not silently
  replace or reinterpret DeepRecoveryV1.

## 4. Key hierarchy

The final hierarchy separates roles:

```text
Deep Recovery Phrase
  -> account Ed25519 signing root
  -> account ML-DSA signing root
  -> recovery authorization root
  -> backup wrapping root

Device CSPRNG root
  -> device signing key
  -> device X25519 identity-agreement key
  -> device signed X25519 prekeys
  -> device one-time X25519 prekeys
  -> device ML-KEM prekeys
  -> local database and push wrapping keys
```

Ed25519 and X25519 keys are independently generated. Ed25519-to-X25519 key
conversion is forbidden in the new profile. Account and device signing keys do
not perform key agreement.

### 4.1 DeepAccountId hash

The binary account identifier used in signed and wire records is:

```text
DeepAccountIdHash32 = SHA256-D(
    "Deep/Identity/V1/account-id",
    networkId16 || accountGeneration:u64 ||
    LP32(accountEd25519Public32) ||
    LP32(accountMlDsa65PublicOrEmpty))
```

Suite `0x0101` uses an empty ML-DSA field. Suite `0x0102` uses exactly 1952
bytes. Changing either genesis account key or account generation creates a new
identifier. Minimum-suite and algorithm-policy rotations are signed successor
state and do not silently change the account identifier.

## 5. Algorithm registry

The machine-readable registry beside this document is normative for sizes and
identifiers.

- `0x0101`: X25519 + ML-KEM-768 confidentiality, Ed25519 authentication.
  Dark-path interoperability and passive-quantum-confidentiality evaluation
  only. It does not provide post-quantum authentication.
- `0x0102`: X25519 + ML-KEM-768 confidentiality, Ed25519 + ML-DSA-65
  long-lived certificate authentication. This is the release-target candidate,
  subject to provider, size, mobile and independent review gates.

Both suites require both the X25519 and ML-KEM components. There is no
classical-only or PQ-only negotiation, retry or fallback. A receiver either
supports the exact signed suite or fails closed.

ML-KEM-768 has a 1184-byte encapsulation key, 2400-byte decapsulation key,
1088-byte ciphertext and 32-byte shared secret. ML-DSA-65 has a 1952-byte
public key, 4032-byte private key and 3309-byte signature. Those sizes are not
inserted into every message.

## 6. Account and device certificates

`DPAC`, version 1, is the self-authenticating account genesis certificate:

| Tag | Value | Exact size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | account generation | 8 |
| 3 | account Ed25519 public key | 32 |
| 4 | account ML-DSA-65 public key | 0 or 1952 |
| 5 | created-at Unix seconds | 8 |
| 6 | policy generation | 8 |
| 7 | minimum accepted suite | 2 |
| 8 | account Ed25519 self-signature | 64 |
| 9 | account ML-DSA-65 self-signature | 0 or 3309 |

Both signatures cover `SIGINPUT("Deep/Identity/V1/account-certificate",
suite, unsignedDPAC)`, where `unsignedDPAC` omits tags 8 and 9. Suite `0x0102`
requires the ML-DSA key and signature; suite `0x0101` requires both fields to be
empty. The DeepAccountId hash is recomputed from tags 1 through 4 before either
callback.

`DPDC`, version 1, is the account-authorized device certificate:

| Tag | Value | Exact size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | account hash | 32 |
| 3 | account generation | 8 |
| 4 | device ID | 32 |
| 5 | device generation | 8 |
| 6 | device Ed25519 signing key | 32 |
| 7 | device X25519 identity-agreement key | 32 |
| 8 | device ML-DSA-65 signing key | 0 or 1952 |
| 9 | issued-at Unix seconds | 8 |
| 10 | expires-at Unix seconds | 8 |
| 11 | capability bits | 8 |
| 12 | minimum accepted suite | 2 |
| 13 | predecessor device-certificate hash | 32 |
| 14 | revocation generation | 8 |
| 15 | account Ed25519 signature | 64 |
| 16 | account ML-DSA-65 signature | 0 or 3309 |

Both signatures cover `SIGINPUT("Deep/Identity/V1/device-certificate",
suite, unsignedDPDC)`, where `unsignedDPDC` omits tags 15 and 16. The account
keys must match the exact DPAC/DeepAccountId lineage. Suite-specific empty/exact
ML-DSA rules are identical to DPAC.

A device certificate binds:

- network ID and account generation;
- account public key and DeepAccountId hash;
- device ID and generation;
- device Ed25519 signing key;
- device X25519 identity-agreement key;
- optional ML-DSA-65 authentication key;
- issued-at, expires-at, capabilities and minimum suite;
- predecessor certificate hash and revocation generation.

Removing either required signature changes the certificate shape/hash and
fails; there is no one-signature fallback.

Low-bandwidth frames carry the 32-byte certificate hash only after the full
certificate has been obtained and verified over another bounded channel.

## 7. Asynchronous prekey bundle

`DPKB`, version 1, is a canonical record with these tags:

| Tag | Value | Exact size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | responder DeepAccountId hash | 32 |
| 3 | responder device ID | 32 |
| 4 | device certificate hash | 32 |
| 5 | bundle ID | 32 |
| 6 | issued-at Unix seconds | 8 |
| 7 | expires-at Unix seconds | 8 |
| 8 | responder device X25519 identity key | 32 |
| 9 | signed X25519 prekey | 32 |
| 10 | signed X25519 prekey ID | 32 |
| 11 | optional one-time X25519 prekey | 0 or 32 |
| 12 | optional one-time X25519 prekey ID | 0 or 32 |
| 13 | ML-KEM-768 prekey | 1184 |
| 14 | ML-KEM prekey ID | 32 |
| 15 | ML-KEM key kind (`1=one-time`, `2=last-resort`) | 1 |
| 16 | minimum accepted suite | 2 |
| 17 | Ed25519 bundle signature | 64 |
| 18 | ML-DSA-65 bundle signature | 0 or 3309 |

Tags 11 and 12 are both present or both absent. Tag 18 is absent for suite
`0x0101` and exact for `0x0102`. Signature input is
`SIGINPUT("Deep/Handshake/V1/prekey-bundle", suite, unsignedDPKB)`, where
`unsignedDPKB` is the canonical record with tags 17 and 18 omitted. Both device
signatures cover identical bytes.

The server atomically claims one-time keys. A last-resort ML-KEM key is allowed
only with an explicit kind, bounded reuse count, short expiry and a durable
replay journal. Key IDs are hints; signatures, public keys, account/device
identity and the full bundle hash are cryptographic bindings.

## 8. Initial hybrid handshake

`DPHI`, version 1, is the initiator record:

| Tag | Value | Exact size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | initiator account hash | 32 |
| 3 | initiator device ID | 32 |
| 4 | responder account hash | 32 |
| 5 | responder device ID | 32 |
| 6 | initiator device certificate hash | 32 |
| 7 | responder prekey-bundle hash | 32 |
| 8 | initiator device X25519 identity key | 32 |
| 9 | initiator ephemeral X25519 key | 32 |
| 10 | responder signed X25519 prekey ID | 32 |
| 11 | responder one-time X25519 prekey ID | 0 or 32 |
| 12 | responder ML-KEM prekey ID | 32 |
| 13 | ML-KEM-768 ciphertext | 1088 |
| 14 | initial AEAD nonce | 24 |
| 15 | initial AEAD ciphertext | 16..32784 |

The initiator first verifies the responder device certificate and every bundle
signature, identity, time, suite and predecessor binding. It then generates an
ephemeral X25519 key and encapsulates to the exact ML-KEM key.

Let:

```text
DH1 = X25519(initiatorDeviceIdentityPrivate, responderSignedPrekeyPublic)
DH2 = X25519(initiatorEphemeralPrivate, responderDeviceIdentityPublic)
DH3 = X25519(initiatorEphemeralPrivate, responderSignedPrekeyPublic)
DH4 = X25519(initiatorEphemeralPrivate, responderOneTimePrekeyPublic) // optional
PQ  = ML-KEM-768 shared secret
```

`DH4` is included only when both one-time fields are present. Every DH output
must be non-zero. The responder reconstructs the same values using its exact
claimed private keys.

Before tag 15 is populated, define `header` as the canonical DPHI record with
tag 15 omitted and tag 14 present. Then:

```text
transcriptHash = SHA512-D(
    "Deep/Handshake/V1/transcript",
    prekeyBundleCanonical || header)

ikm = DH1 || DH2 || DH3 || [DH4] || PQ
prk = HKDF-Extract-512(transcriptHash, ikm)

SKec   = HKDF-Expand-512(prk,
         ASCII("Deep/Handshake/V1/ec-root") || 0x00 || LP32(transcriptHash), 32)
SKpq   = HKDF-Expand-512(prk,
         ASCII("Deep/Handshake/V1/pq-root") || 0x00 || LP32(transcriptHash), 32)
initK  = HKDF-Expand-512(prk,
         ASCII("Deep/Handshake/V1/initial-aead") || 0x00 || LP32(transcriptHash), 32)
```

Tag 15 is XChaCha20-Poly1305-IETF encryption under `initK`, tag 14, and
associated data `header || transcriptHash`. Failure is a single coarse
handshake error. KEM decapsulation failure, key mismatch and ciphertext failure
are not distinguished externally.

Both sides delete the ephemeral private key, DH outputs, ML-KEM shared secret,
`ikm`, `prk` and `initK` after the ratchet state and one-time-key consumption
commit atomically.

## 9. Ratchet boundary

`SKec` and `SKpq` are two independent 32-byte inputs to a reviewed hybrid
ratchet. The target is a Triple-Ratchet-class construction: an ordinary
X25519 Double Ratchet and a reviewed sparse post-quantum ratchet run in
parallel, and every message key requires a domain-separated KDF combination of
both outputs.

Deep does not invent that ratchet in this work package. Production code is
blocked until:

- a maintained implementation or a separately reviewable implementation plan
  is selected;
- skipped-key, out-of-order, replay, deletion and maximum-state rules are
  frozen;
- fresh PQ secret reinjection and recovery after compromise are demonstrated;
- two independent implementations agree on golden and negative vectors.

An initial PQ handshake alone is not sufficient evidence of post-compromise
security.

## 10. Transport budgets

- Internet/XPoint: full DPKB/DPHI are allowed within the 65,535-byte record
  cap. Concurrent handshakes use byte-weighted admission.
- Nearby/BLE: exact records are fragmented by the reviewed bounded transport;
  fragments never change transcript bytes.
- LoRa: a first-contact ML-KEM/ML-DSA bootstrap is not admitted in ordinary
  frames. A peer must reference a previously verified certificate/prekey hash
  or use an independently reviewed bounded bootstrap. No PQ or anonymity claim
  is made for LoRa until size, airtime, replay and battery tests pass.
- ML-DSA keys/signatures live in long-lived account/device/prekey
  certificates, not every message.
- Every platform records peak bytes, allocations, CPU time, battery/thermal
  effect and cancellation latency before a parameter set is accepted.

## 11. Downgrade, rollback and lifecycle

- Suite and minimum-suite policy are signed into device certificates and
  prekey bundles.
- A conversation stores the accepted suite, transcript hash, peer certificate
  generations and algorithm-policy generation under protected state.
- A lower suite, missing component, stale certificate/prekey, reused one-time
  key, changed same-ID object or older policy generation is a conflict, never a
  retry with weaker algorithms.
- Account/device revocation atomically fences unused prekeys and future
  messages. Already authorized in-flight delivery follows an explicit durable
  linearization boundary.
- No environment accepts Session and Deep-native account/wire/database
  generations concurrently.

## 12. Threat and claim boundary

Suite `0x0101` is intended to resist harvest-now/decrypt-later passive attacks
on the initial key agreement if ML-KEM and the implementation remain secure.
Authentication is still classical Ed25519 and must be described that way.

Suite `0x0102` targets hybrid long-lived authentication, but it is not accepted
until ML-DSA provider, certificate lifecycle and resource evidence pass.

Neither suite alone proves anonymity, censorship resistance, group security,
multi-device recovery or traffic-analysis resistance. Those require their own
Deep-specific specifications and evidence.

| Adversary/event | Required behavior or bounded claim |
|---|---|
| passive store-now/decrypt-later attacker | Initial confidentiality remains if at least one of X25519 or ML-KEM-768 and the combiner remain secure. |
| active classical network or malicious prekey server | Signed account/device/prekey lineage, contact verification and the full transcript prevent substitution; denial and withholding remain possible. |
| active quantum attacker | Suite `0x0101` does not claim PQ authentication. Suite `0x0102` is only a candidate until its hybrid certificate chain is reviewed. |
| compromised last-resort PQ prekey | Bounded reuse, short expiry, public-key transcript binding and durable replay evidence limit scope; one-time PQ keys are preferred. |
| weak initiator RNG | Both X25519 ephemeral and ML-KEM encapsulation security may fail; platform CSPRNG health is a release gate. |
| compromised routine device | Device keys and conversations may be exposed; recovery roots and other devices must remain isolated, and revoke/rekey must fence future use. |
| compromised recovery phrase | Account recovery authority is lost; the phrase cannot be remotely rate-limited, so physical secrecy and optional future split backup matter. |
| metadata/traffic observer | This crypto profile does not hide timing, sizes, social graph or endpoints; padding and privacy routing are separate reviewed layers. |

## 13. Mandatory vectors and tests

Before implementation GO:

- BIP-39 official vectors plus Deep root/role derivation vectors for empty
  passphrase, network and generation changes;
- malformed word count, checksum, unknown word, NFKD, mixed profile and
  wallet-reuse UX negatives;
- FIPS 203 ML-KEM KATs and two-provider DPKB/DPHI transcript agreement;
- all field length, order, reserved, duplicate, unknown, max+1, truncation and
  trailing-byte cases before callbacks;
- wrong account/device/certificate/prekey/suite/algorithm generation and
  cross-role key mix with zero state mutation;
- one-time key atomic claim, crash before/after KEM/sign/commit/send, exact
  lost-response replay and same-ID fork;
- passive and active quantum-adversary analysis, including the classical
  authentication limitation of suite `0x0101`;
- mobile/server/Nearby/BLE/LoRa resource measurements;
- destructive recovery, device revoke, rollback and protected-state
  corruption tests;
- independent crypto/privacy review with P0=0/P1=0.

## 14. References

- BIP-39 mnemonic construction and normalization:
  <https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki>
- NIST FIPS 203 ML-KEM:
  <https://csrc.nist.gov/pubs/fips/203/final>
- NIST FIPS 204 ML-DSA:
  <https://csrc.nist.gov/pubs/fips/204/final>
- Signal PQXDH, used as a reference design rather than wire compatibility:
  <https://signal.org/docs/specifications/pqxdh/>
- Signal Double/Sparse-PQ/Triple Ratchet specification, used as a reference
  design:
  <https://signal.org/docs/specifications/doubleratchet/>

NIST currently publishes errata notices for FIPS 203 and FIPS 204. Provider
selection and release gates must pin the exact standard revision, errata state,
package provenance and known-answer self-tests.
