# Deep Contact, Multi-Device and Group Protocol V1

Status: **normative implementation target for the first public release**

This specification closes arbitrary-contact bootstrap, device fanout,
small-group governance, offline recovery and revocation semantics. It is a
clean-break design: no Session contact identifier, group state, DPE1/DMC1
envelope, database row or compatibility reader is part of this protocol.

Pairwise cryptography is defined by
[`DEEP-CRYPTO-V1-DRAFT.md`](../survival-program/releases/v3.0.0/specs/DEEP-CRYPTO-V1-DRAFT.md).
Transport behavior is defined by
[`TRANSPORT-NEUTRAL-MESSAGING.md`](TRANSPORT-NEUTRAL-MESSAGING.md) and the
selected deployment profile. `OfficialXPoint3` message reachability uses XRR1
from [`XPOINT-NETWORK-V1.md`](XPOINT-NETWORK-V1.md); established-contact XUR1
and resolver/pre-key service semantics are defined by
[`CONTACT-RESOLVER-V1.md`](CONTACT-RESOLVER-V1.md), account-head freshness by
[`ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md`](ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md),
and retention/recovery claims by
[`RETENTION-AND-RECOVERY-V1.md`](RETENTION-AND-RECOVERY-V1.md).

## 1. Normative language and invariants

`MUST`, `MUST NOT`, `SHOULD` and `MAY` are normative.

The following are unconditional:

1. `DeepAccountId` identifies an account lineage; it is not a mailbox address.
2. A user-facing **Deep ID** is permanent, transport-neutral `DID1`. It has no
   expiry and resolves a rotating signed contact bundle; it is not a bare
   account hash, mailbox or current route.
3. Contact bootstrap MUST work while the recipient application is offline.
4. Account creation MUST work with no network.
5. Every device has independent DPD1, agreement, prekey and ratchet keys.
6. Ordinary content is authenticated by a ratchet session and is not signed by
   the account or long-term device key.
7. A transport receives opaque encrypted objects and random capabilities. It
   does not own identity, contact, group, dedup or delivery semantics.
8. XPoint, on-premise, direct P2P and store-carry-forward mesh carry the same
   DPE2/DMC2 or group objects. A transport switch does not reset crypto state.
9. Network delivery is at-least-once. User-visible materialization is
   idempotent and at most once per semantic event.
10. Unknown version, suite, field, enum, flag, role, state or hostile size
    rejects before cryptography, mutation or callbacks.

## 2. Limits

Protocol maxima are security bounds, not dynamic server settings:

| Object | V1 bound |
|---|---:|
| active devices per account | 16 protocol; 5 public-release product limit |
| inactive pairwise sessions per device pair | 4 |
| contacts per local account | 10,000 |
| unsolicited pending requests | 100 local, 1,000 server-side per capability |
| group accounts | 100 |
| active devices per group account | 5 |
| total group target devices | 500 |
| admins including owner | 5 |
| pending group proposals | 64 |
| receipt message IDs per batch | 128 |
| UTF-8 display name | 128 bytes |
| UTF-8 text body | 16,384 bytes |
| canonical application payload | 32,768 bytes |
| attachment descriptors per event | 16 |
| retained group commits | `RET-GROUP-CONTROL-V1` |

A server cannot raise a client bound. A future larger group profile uses a new
profile ID and implementation gate.

## 3. Canonical record rules

All Deep-owned records use the canonical tagged grammar, byte primitives,
hashes and strict parsing rules in the production crypto specification. Nested
lists are count-prefixed, length-prefixed where entries vary, and sorted by the
explicit key below. Duplicate keys reject.

Record hashes are:

```text
recordHash32 = SHA256-D(
  "Deep/Application/V1/record-hash/<MAGIC>", exactCanonicalRecord)
```

No JSON, URI parser, protobuf unknown-field preservation or platform object
serialization is a cryptographic record. Text/QR/deep-link encodings decode to
one exact binary record before trust decisions.

## 4. Device directory: `DMD1`

`DMD1`, version 1, suite `0x0201`, is the authoritative messaging projection
of active DPD1 devices for one account:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | DeepAccountId hash | 32 |
| 3 | account generation | 8 |
| 4 | exact DPA1 ArtifactRef | 38 |
| 5 | exact current DRS1 ArtifactRef | 38 |
| 6 | directory generation | 8 |
| 7 | predecessor DMD1 hash; zero only at generation 0 | 32 |
| 8 | active-device count | 2 |
| 9 | sorted active entries | `70 * count` |
| 10 | minimum messaging suite | 2 |
| 11 | issued-at Unix seconds | 8 |
| 12 | DPA1 device-issuer signature | 64 |

Each entry is `deviceId32 || exactDPD1Ref38`, sorted lexicographically by
device ID. Count is `1..16`; the public-release authoring UI enforces `1..5`.
The signature covers
`SIGINPUT("Deep/Application/V1/device-directory", 0x0201, unsignedDMD1)`.

Validation resolves exact DPA1, DRS1 and every DPD1, proves that no listed
device is revoked at the referenced DRS1, and rejects any unlisted active DPD1
claim. Generation advances exactly by one and binds the exact predecessor.
Same-generation changed bytes or two successors permanently fork-latch the
account messaging projection.

DMD1 has no wall-clock expiry. Freshness is monotonic DRS1/directory continuity,
not periodic resigning with a recovery-derived key. Enrollment and revocation
are explicit recovery-authorized ceremonies that advance DMD1.

### 4.1 Permanent Deep ID and account binding: `DID1` / `DAB1`

`DID1`, version 1, suite `0x0201`, contains exactly two tagged fields: the
32-byte Ed25519 public address key derived from
`Deep/Recovery/V1/public-address-signing-seed` and the independent 16-byte
resolver read capability derived from
`Deep/Recovery/V1/public-address-read-capability`. The compact user-facing value
is Bech32m HRP `deep` over
`addressFormatVersion:u8(1) || addressPublicKey32 || readCapability16`;
decoding reconstructs canonical DID1. This 49-byte payload is exactly 90
characters including HRP/separator/checksum, the BIP-350 maximum. It contains no network ID,
account hash, device, route, server, creation time or expiry. The same value is
therefore used by XPoint, future P2P mesh and on-prem transports and is
reconstructible from the Deep Recovery Phrase.

`DAB1`, version 1, suite `0x0201`, binds that permanent address to the current
account lineage in one identity realm. The permanent DID is global, but account
authority keys are network-scoped, so each realm has an independent binding
chain:

```text
identityRealmId32 = SHA256-D(
  "Deep/Application/V1/address-binding-realm",
  networkId16 || deploymentProfileId:u16be)
```

| Tag | Value | Size |
|---:|---|---:|
| 1 | exact DID1 hash | 32 |
| 2 | identity realm ID | 32 |
| 3 | binding generation within the realm | 8 |
| 4 | predecessor DAB1 hash in the same realm; zero at generation 0 | 32 |
| 5 | DeepAccountId hash | 32 |
| 6 | account generation | 8 |
| 7 | exact DPA1 ArtifactRef | 38 |
| 8 | DID1 address-key signature | 64 |
| 9 | DPA1 account-role signature | 64 |

Both signatures cover the same unsigned record in domains
`Deep/Application/V1/address-binding/address` and
`Deep/Application/V1/address-binding/account`. A recovery-authorized
device/control-head replacement within the same recovery root advances the
binding lineage without changing DID1. A future authenticated same-phrase
account-generation advance has the same property. In public V1, a destructive
reset creates a new phrase, account lineage and DID1; it is an explicit account
replacement and cannot redirect the old address. Same-generation changed bytes
or two successors fork-latch only that realm; simultaneous valid bindings in
different realms are expected and are not forks. A DAB1 from another network or
deployment profile cannot authorize DCA1/DCB1 in the current realm. DID1 has no
automatic rotation.

Permanence is an address claim, not infinite message storage. If every signed
publication/prekey authorization has expired, resolution returns
`TemporarilyUnavailable`; after any recovery-authorized device republishes at
the deterministic transport locator, the same DID1 works again. The supported
asynchronous first-contact window while the recipient remains offline is 400
days. An implementation MUST NOT extend reusable prekeys or retained user
ciphertext indefinitely to make a stronger claim.

### 4.2 Contact-publication authorization: `DCA1`

`DCA1`, version 1, suite `0x0201`, lets one active device rotate short-lived
contact bundles without loading the recovery phrase every month. It is issued
during account creation, enrollment, revocation or explicit contact-address
management:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | account hash | 32 |
| 3 | exact DPA1 ArtifactRef | 38 |
| 4 | authorized DMD1 generation | 8 |
| 5 | authorized DMD1 hash | 32 |
| 6 | authorization ID | 32 |
| 7 | publisher device ID | 32 |
| 8 | allowed invite-kind mask | 1 |
| 9 | maximum bundle generation | 8 |
| 10 | not-before Unix seconds | 8 |
| 11 | expires-at Unix seconds | 8 |
| 12 | DPA1 account-role signature | 64 |
| 13 | exact DID1 hash | 32 |
| 14 | exact current DAB1 ArtifactRef | 38 |

The kind mask permits bit 0 permanent-address publication and bit 1 one-time
invitation; all other bits reject.
Lifetime cannot outlive `RET-DCR-PUBLICATION-V1`. The signature domain is
`Deep/Application/V1/contact-publication-authorization`. The publisher must be
active in the exact DMD1, and DID1/DAB1 must verify bidirectionally against the
same DPA1/account generation. A successor DMD1 does not silently inherit DCA1; an
enrollment/revocation ceremony issues a successor authorization for an active
publisher. Routine DCB1 rotation uses only the publisher device key.

## 5. Contact bundle: `DCB1`

### 5.1 Purpose

`DCB1` closes the first-message cycle. A sender can validate identity, discover
current recipient devices, claim fresh one-time prekeys and reach a long-lived
invite rendezvous
without an existing E2EE channel.

`DCB1`, version 1, suite `0x0201`, has:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | account hash | 32 |
| 3 | exact DPA1 bytes | exact frozen size |
| 4 | exact current DRS1 ArtifactRef | 38 |
| 5 | exact DMD1 bytes | `1..4096` |
| 6 | exact DCA1 contact-publication authorization | exact canonical size |
| 7 | bundle ID | 32 |
| 8 | bundle generation | 8 |
| 9 | predecessor bundle hash; zero at generation 0 | 32 |
| 10 | issuer device ID | 32 |
| 11 | XPS1 pre-key-service descriptor count | 1 |
| 12 | sorted length-prefixed XPS1 records | `1..8192` |
| 13 | reachability-descriptor count | 1 |
| 14 | sorted length-prefixed reachability descriptors | `1..8192` |
| 15 | optional UTF-8 profile name | `0..128` |
| 16 | unsolicited policy | 4 |
| 17 | issued-at Unix seconds | 8 |
| 18 | expires-at Unix seconds | 8 |
| 19 | issuer device signature | 64 |
| 20 | exact ADL1 account-directory lookup capability | exact canonical size |
| 21 | minimum fresh ADH1 generation/hash | 40 |
| 22 | exact DID1 hash | 32 |
| 23 | DID1 address public key | 32 |
| 24 | exact DAB1 | exact canonical size |

XPS1 records are sorted by responder device ID and exactly cover active DMD1
devices up to the product limit. They authorize atomic fetch/claim of a fresh
DPK2; a permanent-address DCB1 never embeds a consumable one-time prekey. A temporarily
empty service leaves the signed device visible and returns `PreKeysUnavailable`.

Reachability descriptors are sorted by
`transportProfile:u16 || descriptorHash32`. Each entry is:

```text
transportProfile:u16
descriptorType:u16
descriptorHash32
LP32(exactDescriptorBytes)
```

Registered V1 profiles are `1=OfficialXPoint3`, `2=UserManaged`,
`3=DirectP2P`, `4=StoreCarryForwardMesh`. Only profile 1 is activated in the
first release. Its descriptor is exact `XIR1`; current `XRR1` is resolved behind
that long-lived rendezvous and does not set public Deep ID lifetime. `XUR1` is created only
after ContactHello/Accept and is never published in a public address bundle.
Future profiles add descriptor types but do not change DCB1 parsing or crypto.
Every asynchronous descriptor MUST bind a current metadata-sealing X25519
public key and key ID for the `DAO1` wrapper below. The key is generated
independently from device, ratchet, mailbox-owner and onion keys.

`unsolicitedPolicy` is a closed bit field:

- bit 0: public reusable requests allowed;
- bit 1: one-time invitations allowed;
- bit 2: proof-of-work required;
- bit 3: manual approval required.

All other bits reject. Production defaults are bits 0, 1 and 3. Proof-of-work
parameters are signed inside the reachability service policy, not caller
supplied.

The canonical `DCR1` resolver response below supplies the exact DRS1 object
referenced by tag 4 and every DPD1 referenced by DMD1. Support objects are
individually canonical and hash-addressed; they are not part of the signed DCB1
bytes and cannot alter its interpretation. The signature covers
`SIGINPUT("Deep/Application/V1/contact-bundle", 0x0201, unsignedDCB1)`.
The issuer device must be active in exact DMD1, match DCA1 publisher/kind/
generation and DID1-hash/address-key/DAB1 policy, and its DPD1 signing key verifies
the signature. Permanent-address and one-time bundle lifetime follows
`RET-DCR-PUBLICATION-V1`. Effective expiry is the minimum
defined by the contact-resolver contract.
An expired bundle cannot authorize a new contact request, but it never expires
or redirects DID1 itself. The same DID1 may resolve a current signed successor;
an expired one-time invitation must be replaced by the recipient.

### 5.2 Canonical resolver closure: `DCR1`

`DCR1`, version 1, suite `0x0201`, is the only accepted resolver plaintext:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | exact canonical DCB1 | `1..57344` |
| 3 | support-object count | 2 |
| 4 | sorted support entries | `1..16384` |

Each support entry is `kind:u16 || length:u32 || exactCanonicalObject`. Kinds
are closed: `1=DRS1`, `2=DPD1`. Entries sort by `(kind,
SHA-256(exactCanonicalObject))`; duplicates and unreferenced objects reject.
The closure contains exactly one DRS1 matching DCB1 tag 4 and exactly one DPD1
for every DMD1 device entry, with no missing or additional object. Every XPS1
must resolve to one of those DPD1 devices. Total DCR1 size remains at most
65,535 bytes; an author unable to fit the exact closure must publish fewer
active contact devices after explicit user/device policy, never truncate an
object or split one logical response into unauthenticated pages.

DCR1 itself is not signed: all semantic objects are already signed and exact
hash/reference closure is rechecked. Changed support bytes fail before contact
state, prekey claim or network dispatch. A resolver may cache DCR1 by opaque
locator but never indexes it by account ID.

Before trusting DMD1/DRS1 freshness, a sender performs the oblivious ADL1 lookup
and verifies current ADC1/ADP1 against a recent threshold-witnessed ADH1. The DCB
publisher cannot make an old but correctly signed directory current. Resolver
publication, exact replay and pre-key claim use canonical XPU1, XIQ1/XIS1 and
XPK1/XPC1, never an improvised JSON or Registry API.

### 5.3 Metadata consequence

A permanent-address DCB1 is discoverable to anyone holding its Deep ID and
therefore cannot hide that the account accepts unsolicited requests. It does
not reveal contacts, established contact routes, message mailboxes or the
account's source IP. Users wanting stronger unlinkability use one-time invites.

### 5.4 Opaque deposit object: `DAO1`

DPH2 and DPE2 contain inner device/session routing headers needed by the
recipient. They MUST NOT be stored in clear form by an XNode, bridge, generic
mailbox or blob service. Every asynchronous transport stores exact `DAO1`,
version 1, suite `0x0201`:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | reachability sealing-key ID | 32 |
| 3 | random deposit operation ID | 32 |
| 4 | ephemeral X25519 public key | 32 |
| 5 | nonce | 24 |
| 6 | sealed DPH2 or DPE2 | `32..60000` |

The sender creates a fresh X25519 key pair, rejects an all-zero shared secret
with the descriptor's exact sealing public key and derives:

```text
salt = SHA512-D(
  "Deep/Application/V1/deposit-salt",
  networkId16 || sealingKeyId32 || ephemeralPublic32)
key = HKDF-Expand-512(
  HKDF-Extract-512(salt, X25519(ephemeralPrivate, sealingPublic)),
  "Deep/Application/V1/deposit-key" || 0x00 ||
    LP32(depositOperationId32),
  32)
```

Tag 6 is XChaCha20-Poly1305-IETF with tag 5 and associated data equal to
canonical DAO1 with tag 6 omitted. The plaintext is exactly one DPH2 or DPE2;
all other magics reject. The recipient opens DAO1 before selecting the
handshake/session and deduplicates the deposit operation atomically with inner
processing.

Sealing keys rotate with reachability state, overlap through the exact accepted
object horizon in `RET-MAILBOX-CIPHERTEXT-V1` and are securely retired after every
object under the old key is expired or
reconciled. Later compromise of a sealing key can expose recorded inner header
metadata but not DMC2 content, which remains protected by PQXDH/Triple Ratchet.
DAO1 is metadata minimization, not an additional content-security claim.

## 6. Permanent Deep ID resolution and one-time invitation

The human-facing permanent Deep ID is the `DID1` defined in section 4.1. For
OfficialXPoint3, the adapter derives, without network access:

```text
permanentLocator32 = SHA256-D(
  "Deep/ContactResolver/V1/permanent-locator",
  networkId16 || DID1.addressPublicKey32)
publicResolverKey32 = HKDF-Expand-512(
  HKDF-Extract-512(
    SHA512-D("Deep/ContactResolver/V1/public-read-salt", networkId16),
    DID1.readCapability16),
  "Deep/ContactResolver/V1/public-read-key" || 0x00 ||
    LP32(DID1.addressPublicKey32),
  32)
```

The locator is transport-specific, while DID1 is not. DCB1 carries only the
DID1 hash/address public key, never `readCapability16`; a holder compares both
against the full shared DID1. The account-directory
threshold recomputes it while authoring XPA1; the invite store receives only
the locator hash/XPA1 and never the address public key or read capability. The
read key therefore hides DCR1 from the invite store and from non-holders; every
holder of the full Deep ID can intentionally read it. DCB1/DAB1 signatures provide authenticity. Future
transport adapters define separate domain labels and never reuse an XPoint
locator.

`DIA1` is now exclusively a one-time invitation. Its text/deep-link form is
`deepinvite:` plus unpadded base64url of exact canonical DIA1; QR and binary
file carry those exact bytes. It is not Bech32m because the bounded record can
exceed the 90-character Bech32 limit. Version 1, suite `0x0201`, has:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | invitation ID | 32 |
| 3 | kind (must be `2=one-time`) | 1 |
| 4 | locator type | 2 |
| 5 | opaque locator capability | `16..512` |
| 6 | bundle decryption key | 32 |
| 7 | exact expected DCB1 hash | 32 |
| 8 | expires-at Unix seconds | 8 |
| 9 | usage limit (must be 1) | 2 |

DIA1 expiry follows the one-time bound of `RET-DCR-PUBLICATION-V1` and never
exceeds its exact DCB1/XIR1 authorization
closure. A zero hash, zero expiry, reusable flag or
usage other than one rejects.

The locator identifies an opaque encrypted bundle object. It contains no
account, device, mailbox, XNode or contact identifier. For one-time DIA1 the
untrusted resolver returns:

```text
nonce24 || XChaCha20-Poly1305(
  key=tag6,
  aad=exactDIA1 with tag6 value replaced by ZERO32,
plaintext=exactDCR1)
```

For permanent DID1 it returns:

```text
nonce24 || XChaCha20-Poly1305(
  key=publicResolverKey32,
  aad=networkId16 || exactDID1,
  plaintext=exactDCR1)
```

One-time DIA1 resolution atomically claims the locator and exact-replays a lost
response to the same random redemption operation. Permanent DID1 resolution
uses its deterministic locator, returns the current DCR1 generation without a
claim and never bypasses DAB1/DCB1 lineage, signature or closure verification.

Supported representations are text, deep link, QR and binary file. V1 never
appends or embeds DCR1 after DIA1: all DID1/DIA1 representations carry only the
exact address/invitation encoding and resolution is mandatory. This avoids a
second wrapper/framing grammar and stale embedded closure. Permanent DID1 QR displays “does not expire” and
the account fingerprint after resolution; one-time QR displays expiry.
Screenshots of a one-time QR are equivalent to sharing the capability.

## 7. Contact state and identifiers

The initiator generates random `relationshipId32`. The stable local
conversation identifier is:

```text
conversationId32 = SHA256-D(
  "Deep/Application/V1/contact-conversation",
  networkId16 || relationshipId32 ||
  min(accountA32, accountB32) || max(accountA32, accountB32))
```

It is never derived from a name, phone number, route, mailbox or device. Two
separately accepted relationships between the same accounts remain distinct
until the user explicitly merges them.

Contact state is:

```text
Absent -> BundleVerified -> RequestQueued -> RemoteStoreAccepted
  -> RequestMaterialized -> PeerAccepted -> Active
  -> Blocked/Deleted

RequestQueued/RemoteStoreAccepted/RequestMaterialized -> Rejected/Expired
Active -> IdentityConflict/DirectoryConflict/RouteStale
IdentityConflict/DirectoryConflict -> Active only after explicit verified repair
```

The names are deliberately different from outbox `Accepted`: transport storage,
recipient materialization and human acceptance are separate facts.

| From | Trigger / actor | Preconditions | Atomic local writes | Emission / retry | To |
|---|---|---|---|---|---|
| Absent | user imports DID1/DIA1 | canonical decode only | pending address record | none | BundleVerified after closure verification |
| BundleVerified | user sends request | current directory/bundle/prekey closure | relationship, identical ContactHello and durable fanout operation | retry same logical/operation IDs | RequestQueued |
| RequestQueued | authenticated remote mailbox receipt | at least one intended device copy durably accepted | per-device receipt and attempt state | reconcile unresolved copies only | RemoteStoreAccepted |
| RemoteStoreAccepted | authenticated materialization ACK | ACK binds exact relationship/logical event/device | dedup/materialization evidence | no presence inference for other devices | RequestMaterialized |
| RequestMaterialized | ratcheted ContactAccept | peer account/device/relationship and current directory match | peer acceptance and route-update operation | exact duplicate idempotent | PeerAccepted |
| PeerAccepted | both XUR directions/current message reachability verified | no identity/directory fork | active relationship head | refresh successors idempotently | Active |
| pending state | ContactReject or effective expiry | authenticated reject, or signed deadline reached | terminal reason; destroy unused prekey/send material | no new operation ID | Rejected/Expired |
| any nonterminal | local block/delete | user action | block floor or local tombstone before network work | best-effort capability rotation; never claims remote deletion | Blocked/Deleted |
| Active | verified changed identity/directory/route fork | monotonic verifier result | conflict evidence and send fence | repair uses same relationship | corresponding conflict state |

No transition is inferred from socket success, HTTP status alone, notification,
clock rollback or an unsigned service hint. A crash resumes from the last atomic
row; an external side effect with unknown outcome enters the matching durable
reconcile state and reuses its operation ID.

Deleting locally does not remotely revoke another user's history. Blocking
stops receipts, new route updates and new content acceptance and rotates local
unsolicited capabilities where needed.

## 8. `DMC2` canonical application event

`DMC2`, version 1, suite `0x0201`, is the sole pairwise application plaintext:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | logical message ID | 32 |
| 3 | conversation ID | 32 |
| 4 | sender account hash | 32 |
| 5 | sender device ID | 32 |
| 6 | sender client sequence | 8 |
| 7 | created-at Unix milliseconds | 8 |
| 8 | expires-at Unix milliseconds | 8 |
| 9 | content kind | 2 |
| 10 | flags | 4 |
| 11 | reply-to logical message ID | 0 or 32 |
| 12 | canonical kind-specific payload | `0..32768` |
| 13 | attachment-descriptor count | 1 |
| 14 | canonical attachment descriptors | `0..8192` |

`logicalMessageId` is 32 random bytes generated once when the durable outbox
operation is created. It survives retries, per-device fanout and transport
switching. `sender client sequence` is monotonic per device and provides
ordering evidence, not global delivery order. Clocks are presentation/expiry
hints and never replace sequence or predecessor validation.

Flags are closed: bit 0 `silent`, bit 1 `disappearing`, bit 2
`highPriority`, bit 3 `historyTransfer`. All other bits reject. The sender,
conversation and kind are verified against the authenticated DPE2 session and
local contact/group state before materialization.

### 8.1 Content registry

| ID | Kind | Payload and expiry |
|---:|---|---|
| 1 | `SessionInit` | random handshake nonce, sender DMD1 hash/bytes and capabilities; <=24 h |
| 2 | `ContactHello` | relationship ID, sender DCB1 hash, invite-specific reply XIR1/current XRR1 closure, optional profile; `RET-CONTACT-REQUEST-V1` |
| 3 | `ContactAccept` | relationship ID, recipient current DCB1 hash and recipient XUR1; `RET-CONTACT-REQUEST-V1` |
| 4 | `ContactReject` | relationship ID and closed reason; `RET-CONTACT-REQUEST-V1` |
| 5 | `MessageCreate` | canonical UTF-8, `1..16384`; `RET-MAILBOX-CIPHERTEXT-V1` |
| 6 | `MessageEdit` | target ID plus replacement UTF-8; `RET-MAILBOX-CIPHERTEXT-V1` |
| 7 | `MessageDelete` | target ID plus scope (`local-request` or `conversation-tombstone`); `RET-MAILBOX-CIPHERTEXT-V1` |
| 8 | `ReactionSet` | target ID, operation (`add/remove`), normalized emoji; `RET-MAILBOX-CIPHERTEXT-V1` |
| 9 | `ReceiptDelivered` | `1..128` IDs and accepted/materialized/expired status; `RET-MAILBOX-CIPHERTEXT-V1` |
| 10 | `ReceiptRead` | `1..128` IDs; `RET-MAILBOX-CIPHERTEXT-V1`, and only when user policy allows |
| 11 | `Typing` | start/stop and random activity ID; <=120 s, never durable history |
| 12 | `DeviceListUpdate` | exact DMD1 plus current DCB1/XPS1 service closure; event `RET-XUR-UPDATES-V1`, referenced history `RET-DEVICE-CONTROL-V1` |
| 13 | `DeviceRevocation` | exact DRS1/DMD1 successor evidence; event `RET-XUR-UPDATES-V1`, referenced history `RET-DEVICE-CONTROL-V1` |
| 14 | `ContactRouteUpdate` | successor reachability and XUR1 state; `RET-XUR-UPDATES-V1` |
| 15 | `GroupProposal` | exact DGP1; DMC2 copy `RET-MAILBOX-CIPHERTEXT-V1`, control object `RET-GROUP-CONTROL-V1` |
| 16 | `GroupCommit` | GCP1 hash/length/chunk manifest plus exact DGC1; DMC2 copy `RET-MAILBOX-CIPHERTEXT-V1`, control package `RET-GROUP-CONTROL-V1` |
| 17 | `GroupApplicationMessage` | exact DGM1; `RET-MAILBOX-CIPHERTEXT-V1` |
| 18 | `AttachmentOffer` | bounded encrypted manifest descriptor under `RET-MAILBOX-CIPHERTEXT-V1`; referenced ciphertext `RET-ATTACHMENT-V1` |
| 19 | `AttachmentCancel` | object ID and closed reason; `RET-MAILBOX-CIPHERTEXT-V1` |
| 20 | `CallOffer` | call ID, fresh binding secret and DTLS fingerprint; <=60 s |
| 21 | `CallAnswer` | call ID, accept/reject and DTLS fingerprint; <=120 s |
| 22 | `CallIceCandidate` | relay-only candidate/circuit descriptor; <=120 s |
| 23 | `CallReconnect` | call ID, sequence and replacement relay/circuit binding; <=120 s |
| 24 | `CallEnd` | call ID, sequence and closed reason; <=24 h |
| 25 | `HistoryTransfer` | encrypted history chunk descriptor; <=7 d |
| 26 | `GroupInvite` | exact pending GIV1; does not grant membership |
| 27 | `GroupInviteAccept` | exact GIA1 consent; does not grant membership until DGC1 |
| 28 | `GroupInviteDecline` | invitation ID and coarse reason; optional notification |
| 29 | `GroupCommitChunk` | exact GCF1 chunk; materialization waits for complete GCP1 |

Unknown kinds reject rather than appear as generic messages. New kinds require a
new registry generation and negative vectors.

### 8.2 Exact kind-payload grammar

Every tag 12 payload is exactly one ordered grammar below; `LP16/LP32` are the
canonical big-endian length prefixes from the crypto baseline. Empty optional
values are encoded with a zero length, never by omitting bytes. Trailing bytes,
alternate integer widths and embedded non-canonical records reject.

| Kind | Exact tag 12 bytes |
|---|---|
| SessionInit | `handshakeNonce32 || senderDMD1Hash32 || LP32(exactDMD1) || capabilityBits:u32` |
| ContactHello | `relationshipId32 || senderDCB1Hash32 || LP32(exactReplyXIR1) || LP32(exactInitialDepositClosure) || LP16(profileUtf8[0..256])` |
| ContactAccept | `relationshipId32 || recipientDCB1Hash32 || LP32(exactRecipientXUR1)` |
| ContactReject | `relationshipId32 || reason:u16` |
| MessageCreate | `LP16(canonicalUtf8[1..16384])` |
| MessageEdit | `targetLogicalId32 || LP16(canonicalUtf8[0..16384])` |
| MessageDelete | `targetLogicalId32 || scope:u8` where `1=LocalRequest`, `2=ConversationTombstone` |
| ReactionSet | `targetLogicalId32 || operation:u8 || LP16(normalizedEmojiUtf8[1..32])`, operation `1=Add`, `2=Remove` |
| ReceiptDelivered | `count:u8 || (logicalId32 || status:u8)[count]`, count `1..128`, status `1=StoreAccepted`, `2=Materialized`, `3=Expired`, `4=TerminalRejected` |
| ReceiptRead | `count:u8 || logicalId32[count]`, count `1..128` |
| Typing | `operation:u8 || activityId32`, operation `1=Start`, `2=Stop` |
| DeviceListUpdate | `LP32(exactDMD1) || LP32(exactDCB1)` |
| DeviceRevocation | `LP32(exactDRS1) || LP32(exactDMD1) || LP32(exactADC1)` |
| ContactRouteUpdate | `LP32(exactXUR1) || LP32(exactXRR1Closure)` |
| GroupProposal | `LP32(exactDGP1)` |
| GroupCommit | `GCP1Hash32 || totalLength:u32 || chunkCount:u32 || LP32(exactDGC1)` |
| GroupApplicationMessage | `LP32(exactDGM1)` |
| AttachmentOffer | `LP32(exactDAM1)` |
| AttachmentCancel | `objectId32 || reason:u16` |
| CallOffer/CallAnswer/CallIceCandidate/CallReconnect/CallEnd | exact corresponding closed payload from `CALL-SESSION-V1.md`; no SDP JSON or platform-native object |
| HistoryTransfer | `transferId32 || LP32(exactDAM1) || firstLogicalId32 || lastLogicalId32` |
| GroupInvite | `LP32(exactGIV1)` |
| GroupInviteAccept | `LP32(exactGIA1)` |
| GroupInviteDecline | `invitationId32 || reason:u16` |
| GroupCommitChunk | `LP32(exactGCF1)` |

Payload closed enums are generated from the protocol registry. The DMC2
authenticated sender/device/conversation must equal every duplicated inner
identity; disagreement is a substitution failure, not an update hint.

Edits, deletes and reactions are immutable new events. They never rewrite a
prior authenticated record. The materialized view applies them only if sender,
conversation, target kind, policy and ordering are valid.

## 9. Arbitrary-contact bootstrap

### 9.1 Sender algorithm

1. Decode DID1 or one-time DIA1 and validate all bounds before network access;
   a user-imported/embedded DCR1 is never accepted as a freshness shortcut.
2. Resolve and decrypt DCB1 if required.
3. Verify DID1/DAB1/DPA1/DRS1/DMD1 lineage, issuer, time, bundle predecessor and all
   reachability descriptors.
4. Display the account fingerprint and permanent/one-time metadata.
5. Create one durable relationship and ContactHello logical event.
6. For each active recipient device, use exact XPS1 and XPK1/XPC1 to atomically
   claim fresh DPK2, then create DPH2 whose SessionInit embeds the identical
   ContactHello application event.
7. Store DPH2 objects through the selected contact reachability descriptor.
8. Mark `RemoteStoreAccepted` after verified mailbox acceptance. Mark
   `RequestMaterialized` only after authenticated recipient materialization/ACK;
   a local socket write or storage acceptance is never delivery.

At least one accepted recipient device copy is success. Missing device prekeys
remain pending and are repaired after a signed directory/prekey refresh. A
server-provided unsigned device list is ignored.

### 9.2 Recipient algorithm

1. Fetch opaque initiation objects through its reachability capability.
2. Validate DPH2 lineage, atomically consume prekeys, create ratchet state and
   decrypt exact ContactHello.
3. Deduplicate by relationship and logical message ID.
4. Show a pending request without emitting read/presence traffic.
5. On accept, create local contact state and send ContactAccept independently to
   every active initiator device and own other devices.
6. Exchange fresh contact-scoped XUR1 update rendezvous descriptors.

Accept and reject are explicit. Merely fetching a request does not disclose
online status. Rejection uses a coarse response and does not expose device or
route detail.

### 9.3 Safety number

The displayed safety fingerprint is derived from network ID, sorted exact DPA1
hashes and both account generations. Device additions or a same-root
device/control-head replacement do not change it; a destructive new-phrase
account replacement does. Device details have a separate per-device
verification view.
Scanning a peer QR marks the exact account generation verified. Changed account
lineage pauses sending until explicit user confirmation.

## 10. Contact route and device updates

After acceptance, each direction owns a separate random XUR1-style update
rendezvous. It carries only DPE2-encrypted `DeviceListUpdate`,
`DeviceRevocation` and `ContactRouteUpdate` events. It is not a message mailbox and rejects application text,
attachments and calls.

Rules:

- current and next update capabilities overlap;
- each capability is random and contact-scoped, never account-derived;
- successor timing and service history use `RET-XUR-UPDATES-V1`; a successor is
  sent at 50% lifetime plus
  +/-10% jitter and immediately on route/device change;
- a contact first tries its active route, then the retained update rendezvous;
- a valid successor is monotonic and predecessor-bound;
- same-generation changed bytes, a lower generation or two successors pause
  sending with a visible conflict;
- no public mapping from DeepAccountId to an established contact route exists.

This channel removes the circular dependency where a new route could only be
sent through the already expired old route.

Exact `XUR1` fields and `XUW1/XUQ1/XUS1` publish/fetch/CAS/result contracts are
owned by [`CONTACT-RESOLVER-V1.md`](CONTACT-RESOLVER-V1.md#35-established-contact-update-service-xur1--xuw1--xuq1--xus1). No public field
contains an account or conversation ID; this document does not define a second
codec or retention value.

## 11. Multi-device behavior

### 11.1 Send and convergence

Before send, the client uses the newest verified DMD1 head and ensures an active
Triple-Ratchet session to every active target device. It also fans out to the
sender's other active devices so all devices converge on one logical history.

If an endpoint returns a newer signed DMD1, the client verifies its exact
successor chain and retries the logical event at most twice. A malicious service
cannot force an unbounded Sesame update loop. Removed devices are retained as
decrypt-only stale records until every associated `RET-MAILBOX-CIPHERTEXT-V1`
object deadline passes, then destroyed.

### 11.2 Enrollment

The production crypto specification's phrase-authorized enrollment ceremony
creates new DPD1 and DMD1. Existing devices transfer public state and an
encrypted synchronization offer, not private device or account keys.

The new device starts fresh pairwise sessions. History transfer is optional,
user-visible and separately encrypted to the new device. It is never achieved
by copying a ratchet database.

### 11.3 Revocation

Revocation is a durable saga, not a distributed transaction. Its states are
`Prepared -> LocalFloorCommitted -> PrekeysFenced -> DirectoryCommitted ->
CapabilitiesRotated -> ContactsNotified -> GroupsConverging -> Complete`, with
`ReconcileRequired` reachable after any uncertain remote result.

1. `Prepared` contains the exact successor DRS1/DMD1/ADC1 hashes, revoked device,
   one operation ID per external plane and the required contact/group worklist.
2. One local transaction installs the successor DRS1/DMD1, advances the
   protected revocation floor and marks every new send/fanout to that device
   forbidden. Only then may external work begin.
3. Pre-key stores fence all unused DPK2 for the revoked device and exact-replay
   the same fence operation after crash.
4. The account-directory authority commits the ADC1 current-map/log successor.
   Until a current proof is obtained, new contact publication and device/group
   mutation remain paused; local reads and already-safe sends may continue.
5. Receive/update capabilities known to the revoked device rotate; successors
   are delivered only to remaining devices/contacts.
6. Required remove-device group proposals/commits are queued and reconciled.
   A group cannot send its next application event while its removal is pending.

Every step is monotonic and idempotent; `OutcomeUnknown` retries the same
operation ID. Failure cannot roll back the local security floor or re-enable
the device. Completion means all mandatory acknowledgements are durable, not
that every offline peer has observed revocation. New 1:1 events exclude the
revoked device from `LocalFloorCommitted` onward.

Offline peers may continue using a stale directory until they receive a valid
successor. The UI states `peer device state may be stale`; it does not claim
instant global revocation.

## 12. Delivery, receipts and deduplication

The durable logical outbox state is:

```text
Queued -> FanoutPrepared -> Sending
  -> PartiallyAccepted -> Accepted
  -> RecipientMaterialized
  -> Expired/Cancelled

Sending/PartiallyAccepted -> OutcomeUnknown -> Reconcile
```

Per-device states are `Pending`, `Accepted`, `Materialized`, `Expired`,
`RevokedTarget` and `TerminalRejected`. Logical `Accepted` means at least one
current recipient device accepted and all known target outcomes are durably
tracked; it does not mean read.

| From | Trigger | Atomic writes before/with side effect | Retry/reconcile | To |
|---|---|---|---|---|
| Queued | scheduler snapshots current targets | exact plaintext hash, target directory head, fanout IDs and expiry | no network yet | FanoutPrepared |
| FanoutPrepared | dispatch lease acquired | attempt ID/request hash and sealed ratchet transition plan | same attempt only | Sending |
| Sending | authenticated definitive receipt | receipt plus ratchet/outbox transition in one DB transaction | unresolved targets keep their IDs | PartiallyAccepted/Accepted |
| Sending | timeout/reset after bytes may have left | outcome-unknown marker without advancing plaintext/logical ID | query/retry exact operation | OutcomeUnknown |
| OutcomeUnknown | reconciliation result | exact remote receipt, retry proof or signed expiry | bounded backoff; never new plaintext/ID | Sending/PartiallyAccepted/Accepted/Expired/Cancelled |
| PartiallyAccepted | remaining target receipt/refresh | per-target terminal state and current directory proof | at most two directory repairs | Accepted/Expired/Cancelled |
| Accepted | recipient materialization receipt | receipt dedup and materialization evidence | exact duplicate only | RecipientMaterialized |
| any nonterminal | signed effective expiry/user cancel | delete payload/message key; retain only canonical audit tombstone | remote accepted copies are not recalled | Expired/Cancelled |

`TerminalRejected` is terminal only for its target. A logical operation becomes
terminal rejected only when every current target is terminal rejected and none
accepted; this closed result is stored separately from `Expired` and
`Cancelled`. Reconciliation cannot move any terminal state backward.

Receive order is:

```text
outer size/capability checks
-> DPH2/DPE2 canonical checks
-> ratchet open with transactional state
-> DMC2 sender/conversation/kind validation
-> logical dedup
-> materialize event and enqueue receipt atomically
```

Duplicate exact envelopes do not advance ratchets twice. A logical duplicate
from another sender device/fanout copy may update per-device evidence but does
not duplicate UI content.

## 13. `DeepSmallGroupV1`

### 13.1 Choice and boundary

The first release uses owner-sequenced membership and pairwise Triple-Ratchet
fanout. It deliberately reuses the reviewed 1:1 engine, matches the release
parity bound of 100 accounts/500 active devices and avoids inventing a shared
group key schedule. All target envelopes are submitted as one bounded durable
logical batch; implementations MUST NOT perform 500 sequential network
round-trips or block the UI while the batch drains.

It is not MLS and MUST NOT be marketed as MLS. Its transport and application
interfaces are group-engine-neutral so an MLS successor can replace it later.

### 13.2 Group identifiers and roles

`groupId32` is random. Roles are closed:

- `1=Owner` — exactly one account;
- `2=Admin` — may author proposals;
- `3=Member` — may send group application events.

One active owner device is the sequencer. Other admins cannot commit directly.
This sacrifices concurrent membership availability to eliminate benign forks
and keep disconnected/mesh behavior deterministic.

### 13.3 Pending invitation and consent: `GIV1` / `GIA1`

A group invitation never changes membership. `GIV1`, version 1, suite `0x0201`,
is a pending offer:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | group ID | 32 |
| 3 | random invitation ID | 32 |
| 4 | base epoch | 8 |
| 5 | exact base DGC1 hash | 32 |
| 6 | inviter account hash | 32 |
| 7 | inviter device ID | 32 |
| 8 | inviter DPD1 ArtifactRef | 38 |
| 9 | invitee account hash | 32 |
| 10 | requested role (`2=Admin`, `3=Member`) | 1 |
| 11 | invitee ADC1 ArtifactRef | 38 |
| 12 | invitee ADH1CoreRef38 | 38 |
| 13 | invitee ADP1 hash | 32 |
| 14 | invitee DMD1 hash | 32 |
| 15 | invitee DRS1 ArtifactRef | 38 |
| 16 | issued-at Unix seconds | 8 |
| 17 | expires-at Unix seconds | 8 |
| 18 | inviter device signature | 64 |

The inviter is Owner/Admin in the exact base commit. The signature domain is
`Deep/Group/V1/invitation`. GIV1 expires within seven days and is delivered in
ratcheted `GroupInvite` DMC2; fetching it emits no presence and creates no group
member state.

User acceptance creates `GIA1`, version 1, suite `0x0201`:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | group ID | 32 |
| 3 | invitation ID | 32 |
| 4 | exact GIV1 ArtifactRef | 38 |
| 5 | invitee account hash | 32 |
| 6 | accepting device ID | 32 |
| 7 | accepting DPD1 ArtifactRef | 38 |
| 8 | current invitee ADC1 ArtifactRef | 38 |
| 9 | current invitee ADH1CoreRef38 | 38 |
| 10 | current invitee ADP1 hash | 32 |
| 11 | current invitee DMD1 hash | 32 |
| 12 | current invitee DRS1 ArtifactRef | 38 |
| 13 | accepted-at Unix seconds | 8 |
| 14 | expires-at Unix seconds | 8 |
| 15 | invitee device signature | 64 |

The signature domain is `Deep/Group/V1/invitation-acceptance`. The accepting
device must be active in the referenced current directory closure; GIA1 matches
the exact invitation, invitee and requested role and cannot outlive GIV1. It is
sent to inviter/owner through the pairwise ratchet. Only a later owner-signed
DGC1 may activate the member. A declined/expired invitation remains absent from
membership; optional decline notification is a DMC2 event, not a governance
record.

### 13.4 Proposal: `DGP1`

`DGP1`, version 1, suite `0x0201`, has:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | group ID | 32 |
| 3 | base epoch | 8 |
| 4 | base DGC1 hash | 32 |
| 5 | proposal ID | 32 |
| 6 | proposer account hash | 32 |
| 7 | proposer device ID | 32 |
| 8 | proposer DPD1 ArtifactRef | 38 |
| 9 | action | 2 |
| 10 | canonical action payload | `1..8192` |
| 11 | issued-at Unix seconds | 8 |
| 12 | expires-at Unix seconds | 8 |
| 13 | proposer device signature | 64 |

Actions are `1=ActivateAcceptedInvite`, `2=RemoveAccount`, `3=ChangeRole`,
`4=AddDevice`, `5=RemoveDevice`, `6=ChangeProfile`,
`7=TransferOwnerDevice`, `8=LeaveAccount`.
The signature domain is `Deep/Group/V1/proposal`. The proposer must have the
required role in the exact base commit. A proposal never changes state by
itself and expires within seven days.

`ActivateAcceptedInvite` and device-changing actions include exact ADC1/ADH1 and DMD1/DRS1
references plus the verified account-directory proof hash. A display name or
DCB1 alone cannot choose member device state.

Canonical action payloads are closed:

| Action | Exact payload |
|---|---|
| ActivateAcceptedInvite | GIV1Ref38, GIA1Ref38, account32, requestedRole:u8, ADC1Ref38, ADH1Ref38, ADP1Hash32, DMD1Hash32, DRS1Ref38 |
| RemoveAccount | account32, expectedMemberEntryHash32, reason:u16 |
| ChangeRole | account32, expectedRole:u8, newRole:u8, expectedMemberEntryHash32 |
| AddDevice | account32, device32, DPD1Ref38, DMD1Hash32, DRS1Ref38, ADP1Hash32 |
| RemoveDevice | account32, device32, expectedDPD1Ref38, DMD1Hash32, DRS1Ref38 |
| ChangeProfile | UTF8 name LP16 (1..128), historyPolicy:u8, ordinaryExpiry:u32 |
| TransferOwnerDevice | oldDevice32, newDevice32, DPD1Ref38, DMD1Hash32, DRS1Ref38 |
| LeaveAccount | account32, expectedMemberEntryHash32, reason:u16 |

Owner may propose every action except leaving without first transferring
ownership. Admin may propose ActivateAcceptedInvite, RemoveAccount,
ChangeRole between Admin/Member, AddDevice, RemoveDevice and ChangeProfile, but
cannot create another Owner or transfer owner device. Admin/Member may author
`LeaveAccount` only for their own account; this is the only membership proposal
a Member may author. While the owner is offline, leave remains pending: the
leaving client stops new sends/materialization locally, but other members do not
remove it until the owner commit. Only the current owner sequencer commits any proposal;
authorization is checked both at proposal base epoch and commit epoch.

### 13.5 Commit: `DGC1`

`DGC1`, version 1, suite `0x0201`, has:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | group ID | 32 |
| 3 | group profile (`1=DeepSmallGroupV1`) | 2 |
| 4 | epoch | 8 |
| 5 | predecessor DGC1 hash; zero at epoch 0 | 32 |
| 6 | owner account hash | 32 |
| 7 | sequencer device ID | 32 |
| 8 | sequencer DPD1 ArtifactRef | 38 |
| 9 | proposal count | 2 |
| 10 | sorted proposal hashes | `32 * count` |
| 11 | member count | 2 |
| 12 | canonical sorted member entries | `1..60000` |
| 13 | UTF-8 group name | `1..128` |
| 14 | history policy | 1 |
| 15 | ordinary-event expiry seconds | 4 |
| 16 | issued-at Unix seconds | 8 |
| 17 | sequencer device signature | 64 |

Member entries are LP16 records:

```text
accountHash32
role:u8
exactADC1Ref38
exactADH1Ref38
exactADP1Hash32
deviceDirectoryGeneration:u64be
exactDMD1Hash32
exactDRS1Ref38
deviceCount:u8
sorted(deviceId32 || DPD1Ref38)[deviceCount]
```

Entries sort by account hash; devices sort by device ID. Exactly one Owner entry
matches tag 6. Counts obey section 2. Every device is active in the exact DMD1
generation/hash and unrevoked in exact DRS1. `historyPolicy` is `0=none` or
`1=explicit-user-selected-transfer`.

The signature domain is `Deep/Group/V1/commit`. Epoch zero is locally created
with exactly the Owner account/current devices; it is referenced by pending
GIV1 invitations but does not pre-add invitees. Every successor advances
exactly by one and binds the exact predecessor. The commit hash includes the
signature.

### 13.6 Commit rules and forks

- Only the exact active sequencer device signs the next commit.
- Proposal records are sorted by exact proposal hash. Authorization is checked
  against the immutable base-commit role snapshot; state preconditions and
  expected-entry hashes are then checked sequentially against the result of
  earlier sorted proposals.
- Reduction is all-or-nothing. Duplicate proposal hashes, two proposals that
  target the same account/device/profile transition, a precondition invalidated
  by an earlier proposal, an unauthorized action or a result that violates any
  count/role invariant invalidates the whole DGC1. The sequencer cannot silently
  skip or reorder a listed proposal.
- A verifier independently applies the same reducer and requires byte-identical
  tag 12 member entries, group profile fields and owner/sequencer result.
- The sequencer revalidates current DMD1/DRS1 for every affected account.
- Removal of an account removes all its devices.
- Device revocation removes that leaf before future group events.
- Owner transfer names one active device of the Owner account and must be in a
  commit signed by the prior sequencer.
- If the sequencer is lost, an emergency transfer is authorized by exact DGT1
  recovery ceremony and DPA1 account signature in a separate recovery domain;
  it is displayed to all members as a safety event.
- Two distinct valid successors for the same `(groupId, epoch,
  predecessorHash)` permanently fork-latch the group. Clients stop group sends,
  retain both exact commits as evidence and require creation of a new group ID.
  They do not choose the lexicographically smaller attacker-controlled fork.

Application events may merge after a network partition while every sender
remained on the same commit. Membership mutation during an unresolved partition
is unavailable by design. This rule is compatible with later mesh transport.

`DGT1`, version 1, suite `0x0201`, is:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | group ID | 32 |
| 3 | exact current DGC1 ArtifactRef | 38 |
| 4 | current epoch | 8 |
| 5 | lost sequencer device ID | 32 |
| 6 | new active owner device ID | 32 |
| 7 | new device DPD1 ArtifactRef | 38 |
| 8 | current owner-account DMD1 hash | 32 |
| 9 | current owner-account DRS1 ArtifactRef | 38 |
| 10 | random ceremony ID | 32 |
| 11 | issued-at | 8 |
| 12 | expires-at | 8 |
| 13 | exact owner DPA1 ArtifactRef | 38 |
| 14 | DPA1 account-role signature | 64 |

The signature domain is `Deep/Group/V1/emergency-sequencer-transfer`. Ceremony
ID is single-use and its expiry is bounded by `RET-GROUP-CONTROL-V1`. If the owner
account cannot authorize it, V1 creates a new
group.

Every commit is delivered as canonical `GCP1`, version 1, suite `0x0201`. Its
8 MiB per-record maximum is an explicit exception to the default canonical
record limit:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | group ID | 32 |
| 3 | epoch | 8 |
| 4 | exact DGC1 | `LP32`, `1..65535` |
| 5 | DGP1 count | 2 |
| 6 | sorted exact DGP1 records | repeated `LP32` |
| 7 | support-object count | 4 |
| 8 | sorted support entries | repeated `kind:u16 || ArtifactRef38 || LP32(exactBytes)` |
| 9 | accepted-invitation pair count | 2 |
| 10 | sorted `GIV1Ref38 || LP32(GIV1) || GIA1Ref38 || LP32(GIA1)` | bounded by proposal count |
| 11 | optional exact DGT1 | empty or `LP32` |

Support kinds are `1=ADC1`, `2=ADH1`, `3=ADP1`, `4=DMD1`, `5=DRS1`,
`6=DPD1`; all other values reject. Entries sort by `(kind, ArtifactRef)` and
contain every object referenced by DGC1/member entries/proposals exactly once,
with no extras. GIV1/GIA1 pairs sort by invitation ID and exist exactly for
`ActivateAcceptedInvite` proposals. Maximum canonical size is 8 MiB because
worst-case cumulative closures are bounded but not constant-size; larger
packages reject.

Transport chunking uses canonical `GCF1`, version 1, suite `0x0201`:

| Tag | Value | Size |
|---:|---|---:|
| 1 | SHA-256 of exact GCP1 | 32 |
| 2 | total GCP1 bytes | 4 |
| 3 | fixed non-final chunk size (`24576`) | 4 |
| 4 | chunk index | 4 |
| 5 | chunk count | 4 |
| 6 | SHA-256 of chunk bytes | 32 |
| 7 | chunk bytes | `LP32`, `1..24576` |

Chunk count is `ceil(total/24576)` and at most 342; all non-final chunks are
exactly 24,576 bytes and the final length follows from total. This bound keeps
one LP32(GCF1) inside the DMC2 payload maximum. Duplicate exact
chunks are idempotent; changed bytes/hash/total/count at one package/index
fork-latch the transfer. No group state changes before all chunks, exact GCP1
hash and complete closure verify.

Recipients gossip `(groupId, epoch, DGC1Hash)` in pairwise ratcheted control
events. Two hashes for one epoch produce portable fork evidence and stop sends.
A newly enrolled device receives group traffic only after the owner sequencer
commits AddDevice; while the owner is offline this is explicitly pending.

### 13.7 Group event: `DGM1`

`DGM1`, version 1, suite `0x0201`, has:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | group ID | 32 |
| 3 | epoch | 8 |
| 4 | exact DGC1 hash | 32 |
| 5 | logical group event ID | 32 |
| 6 | sender account hash | 32 |
| 7 | sender device ID | 32 |
| 8 | sender group sequence | 8 |
| 9 | created-at Unix milliseconds | 8 |
| 10 | expires-at Unix milliseconds | 8 |
| 11 | event kind | 2 |
| 12 | canonical event payload | `0..24576` |

Kinds are `1=Text`, `2=Edit`, `3=Delete`, `4=Reaction`,
`5=Receipt`, `6=Attachment`, `7=ProfileNotice`. Group calls are not V1.

DGM1 has no long-term signature. It is carried as identical DMC2
`GroupApplicationMessage` plaintext independently encrypted through the sender's
active DPE2 session to every device in exact DGC1, including the sender's other
devices. The receiver checks that authenticated sender account/device is a
member of the exact epoch before materializing.

One partial target failure does not roll back copies already accepted. The
logical group outbox tracks all target devices and can finish after restart.
No XNode receives a member list or plaintext group ID; it sees independent
contact-scoped mailbox capabilities and padded ciphertexts.

The “logical batch” is a local `GroupFanoutPlan`, never a network member-list
record. It snapshots exact GCP1, one semantic event ID and up to 500 independent
target attempts. Each target has its own ratchet ciphertext, operation ID,
binding and idempotency state. The scheduler uses at most 32 concurrent target
operations (lower under battery/metered policy), batching only frames sharing a
route within the XPoint 25 ms/64 KiB bound. State is persisted before dispatch;
partial acceptance and restart reconcile per target without duplicating UI.
After a verified epoch/directory change, accepted copies remain evidence,
revoked pending targets terminate, and new targets use the successor snapshot.

Scale gates are cumulative: 3-member correctness, 20-member/100-device
integration, then final 100-member/500-device release load. Intermediate gates
do not reduce the product maximum.

### 13.8 Group invitations

An Owner/Admin sends GIV1 using the invitee's verified DCB1 and pairwise DPE2.
The user explicitly accepts by authoring GIA1. Only then may an authorized
proposer author `ActivateAcceptedInvite`, and only the owner may commit it.
After that commit, every required exact GCP1 closure from the invitation base is
sent to each newly active device. The new member materializes membership only
after verifying GIV1/GIA1, every required predecessor and its exact current
account/device entry. Fetch, accept and active membership are three distinct
states. Decline is local unless the user elects to send a coarse ratcheted
notification.

### 13.9 Rekey property

DeepSmallGroupV1 has no shared group content key. Removing an account/device
changes the epoch and future fanout target set; every remaining target copy uses
its independent Triple-Ratchet session. Removed devices cannot decrypt copies
not addressed to them. As with every group system, a malicious remaining member
can intentionally disclose plaintext and is outside this guarantee.

Known removal/revocation blocks subsequent group application send until the
new commit is durable. Delayed old-epoch events remain visibly associated with
their old epoch and policy; they never mutate new membership state.

## 14. Group history and recovery

Long-offline group control does not rely on an online member or
`RET-MAILBOX-CIPHERTEXT-V1`. For every active member account the Owner creates an
independent random
`GSR1`, version 1, suite `0x0201`, and shares it only through that member's pairwise
E2EE:

```text
networkId16, randomServiceCapability32, randomDirectionId32
serviceGeneration:u64, predecessorGSR1Hash32
exactPMT2Ref38, randomPlacementInput32
sealingKeyId32, sealingX25519Public32
ownerDeviceId32, ownerDPD1Ref38, issuedAt:u64, expiresAt:u64
ownerDeviceSignature64
```

The signature domain is `Deep/Group/V1/control-rendezvous`. Capability, direction,
placement and sealing key are independently random per `(group, recipient account,
generation)` and never contain/derive group/account/device IDs in service requests.
The XNode store therefore cannot correlate two members as one group from GSR1.

`GSW1` uses the common request tags from the resolver contract plus
`16=serviceCapability32`, `17=exactGSR1Hash32`, `18=controlSequence:u64`,
`19=predecessorControlHash32`, `20=sealedGCF1Hash32`,
`21=LP32(sealedExactGCF1[1..32768])`, `22=effectiveExpiresAt:u64`.
It is a two-replica CAS. Every exact GCP1/GCF1 chunk needed for the recipient's
current membership lineage is written; owner commit becomes publish-complete only
after every target's durable receipts are recorded in the local fanout plan.

`GSQ1` uses common request tags plus `16=serviceCapability32`,
`17=exactGSR1Hash32`, `18=afterControlSequence:u64`, `19=maxRecords:u16(1..64)`
and `20=responsePaddingClass:u16(0..4)`. Class 4 can carry at least one
maximum-size sealed GCF1. `GSS1` uses the exact XUS1 common result,
status/outcome/payload/receipt matrix with operation kinds `1=Write`, `2=Fetch`,
but its committed tuple is
`requestHash32 || controlSequence || sealedGCF1Hash32 || commitGeneration` in
signature domain `Deep/Group/V1/control-store-commit`. Mixed XUS/GSS records reject.

For GSS1, XUS1 `eventGeneration/eventHash` mean
`controlSequence/sealedGCF1Hash`; an Events record is exactly
`controlSequence:u64 || predecessorControlHash32 || sealedGCF1Hash32 ||
expiresAt:u64 || LP32(sealedExactGCF1[1..32768])`.
Pagination applies the XUS1 longest-prefix algorithm with GSQ1 tag 18 as the
exclusive lower bound and returns `nextAfterControlSequence` in Events tag 19.
It never skips a control sequence; every changed cursor or padding class uses a fresh
GSQ1 operation ID. `SizeFailure` is Write-only for a GSW1 tag-21
length outside `1..32768`; `RecordTooLarge` is Fetch-only when the next valid
record does not fit the requested class and returns the minimum required class.
Every valid V1 GCF1 fits class 4, so class-4 `RecordTooLarge` is invalid and
fork/corruption-latches the replica rather than truncating or skipping the record.

Storage, compaction and checkpointing follow only `RET-GROUP-CONTROL-V1`. A
recipient verifies/decrypts
all chunks, exact GCP closure and predecessor epochs before state mutation. Missing
or expired control returns an explicit gap; it never becomes an empty successful
sync. GSR successor/handover imports all unexpired CAS/replay state before serving.
This store recovers control state, not expired group message content.

New members receive no pre-join plaintext history by default. With history
policy 1, an existing member may explicitly select a bounded range and create a
history transfer:

- serialize immutable application events with original IDs and epochs;
- encrypt chunks under a fresh random transfer key;
- send the key/manifest separately through DPE2 to each selected new device;
- mark imported entries as shared history, not newly delivered messages;
- expire transfer objects within seven days;
- never include deleted local-only content, ratchet state or old message keys.

Recovery on a new own device follows the same mechanism or restores an explicit
encrypted backup. Copying a group/ratchet database between devices is forbidden.

Group commits/proposals use `RET-GROUP-CONTROL-V1`; ordinary DGM1 copies use
`RET-MAILBOX-CIPHERTEXT-V1`. A device offline beyond the latter
can recover current membership and continue,
but does not receive expired application history.

## 15. MLS successor profile

The scalable successor is MLS 1.0, RFC 9420/RFC 9750, evaluated through a
pinned OpenMLS release because it is maintained, MIT-licensed and supports the
required X25519/ChaCha20-Poly1305 suite. This is not on the first-release
critical path.

The future profile MUST freeze before implementation:

- profile ID `2` and a new group ID; no mixed-engine group;
- MLS cipher suite `0x0003`,
  `MLS_128_DHKEMX25519_CHACHA20POLY1305_SHA256_Ed25519`;
- per-group, per-device MLS leaf signing keys certified by current DPD1;
- PrivateMessage for application and handshake messages where RFC 9420 permits;
- no external commits or external senders in the initial Deep MLS profile;
- application-level canonical commit sequencing/fork resolution;
- KeyPackage one-time use, expiry, directory and revocation binding;
- group delivery-service capability rotation without exposing account IDs;
- a separate post-quantum claim only after a standardized/reviewed PQ MLS
  ciphersuite and mobile provider exist.

Upgrade creates a new group/profile and explicit member invitations. It does not
reinterpret DGC1/DGM1 as MLS, preserve old group secrets or run pairwise and MLS
fanout as silent fallbacks.

## 16. Attachments

An attachment event contains canonical `DAM1`, version 1, suite `0x0201`:

| Tag | Value | Size |
|---:|---|---:|
| 1 | network ID | 16 |
| 2 | random object ID | 32 |
| 3 | random blob capability | 32 |
| 4 | random object key | 32 |
| 5 | total plaintext bytes | 8; `1..26,214,400` |
| 6 | fixed non-final plaintext chunk size | 4; exactly `262144` |
| 7 | chunk count | 4; `1..100` |
| 8 | final chunk plaintext bytes | 4; `1..262144` |
| 9 | chunk-entry count | 4; equals tag 7 |
| 10 | sorted chunk entries | `count * 40` |
| 11 | size-bucket ID | 2 |
| 12 | expires-at Unix seconds | 8 |
| 13 | canonical UTF-8 filename | `0..255` |
| 14 | canonical ASCII media type | `0..128` |

Each tag 10 entry is exactly
`index:u32be || ciphertextLength:u32be || SHA256(ciphertext)32`; indexes are
strictly `0..count-1`. `count = ceil(totalPlaintext/262144)`, final plaintext
length is `total - 262144*(count-1)`, and each ciphertext length is its
plaintext length plus the 16-byte XChaCha20-Poly1305 tag. Size-bucket mapping is
registry-owned and MUST be at least the exact total ciphertext size. Unknown
fields/buckets, duplicate/missing indexes, inconsistent totals and max+1 reject
before allocation or blob access. The manifest identity is
`SHA256-D("Deep/Attachment/V1/manifest", exactDAM1)`.

The sender generates random object key32 and derives for every index:

```text
chunkKey = HKDF-Expand-512(HKDF-Extract-512(objectId32, objectKey32),
  "Deep/Attachment/V1/chunk-key" || 0x00 || index:u32be, 32)
nonce24 = first24(SHA512-D("Deep/Attachment/V1/chunk-nonce",
  objectId32 || index:u32be))
aad = networkId16 || objectId32 || index:u32be ||
  plaintextLength:u32be || totalPlaintextLength:u64be
```

Each chunk is XChaCha20-Poly1305 ciphertext. DAM1, including object key, exists
only inside DMC2/DGM1 E2EE and MUST NOT be uploaded as blob metadata. A repeated index is idempotent only
when length/hash/exact bytes match; changed bytes fork-latch the object. DAM1 and
object key are inside DMC2/DGM1 E2EE. Preview/thumbnail is a separate bounded
encrypted object and is never uploaded in plaintext.

Blob transports receive
only opaque capabilities, ciphertext size classes, chunk hashes and retention.
P2P/mesh may transfer identical encrypted chunks. A transport change never
decrypts or reencrypts content.

## 17. Call signaling boundary

This document owns only the registered DMC2 call-event IDs in section 8.1.
Their exact payloads, state/order, multi-device answer CAS, call-binding KDF,
DTLS fingerprint checks, allocation and expiry are defined once in
[`CALL-SESSION-V1.md`](CALL-SESSION-V1.md). Group calls remain outside V1 by
[`V1-RELEASE-SCOPE.md`](V1-RELEASE-SCOPE.md).

## 18. Offline and revocation matrix

The complete scenario matrix, all day/generation bounds and the three recovery
guarantees are defined once in
[`RETENTION-AND-RECOVERY-V1.md`](RETENTION-AND-RECOVERY-V1.md). This protocol's
only local consequence is that DMD1/DRS1/DAB1/group predecessor checks remain
mandatory after catch-up; a transport retention gap is never interpreted as an
empty account or proof that no unseen revocation exists.

## 19. Metadata boundaries

### 19.1 Outer transport may see

- random deposit/update/blob/call capability;
- padded size class, time and retry pattern;
- selected transport profile and adjacent network hop;
- retention and quota class.

### 19.2 Only E2EE peers may see

- account and device identities;
- contact relationship and profile;
- DMD1/DPK2 lineage;
- group ID, membership, roles, epoch and proposals;
- application content, attachment keys and call fingerprints.

### 19.3 Explicit non-claims

Padding and onion routing do not hide timing/volume from a global observer.
Permanent Deep IDs reveal public reachability to a holder. Group pairwise fanout
can reveal a burst size to a sufficiently capable observer. Device compromise
reveals local contacts and plaintext. No log, telemetry or release evidence may
contain stable hashes of the sensitive inner identifiers.

## 20. Abuse and resource policy

- Unsolicited contact capabilities have independent quotas and lower priority
  than accepted contacts.
- Size, canonical framing, capability, replay and cheap policy checks precede
  signature, KEM and storage allocation where safe.
- Reusable public IDs support signed proof-of-work or unlinkable rate tokens;
  one-time invites normally do not require proof-of-work.
- A blocked contact cannot use route-update or call allocation channels.
- Group owner/admin operations are bounded separately from application sends.
- A sender cannot force more than the local group/device maxima, skipped-key
  window or two device-directory retry loops.
- Push is an optional wake hint and cannot be required for message correctness.

## 21. Implementation work packages

Agent-sized packages, ownership, dependency edges, removals and evidence are
defined only in [`IMPLEMENTATION-PLAN-V1.md`](IMPLEMENTATION-PLAN-V1.md).
This protocol document supplies its canonical inputs and transition rules; it
does not maintain a parallel execution order.

## 22. Mandatory test matrix

### 22.1 Canonical and adversarial

- unknown/duplicate/out-of-order tags, versions, suites, flags and roles;
- zero/maximum/max+1 counts and lengths before allocations/callbacks;
- cross-network/account/device/group type confusion;
- changed same-ID records, predecessor forks and rollback;
- malformed UTF-8, non-canonical normalization and trailing bytes;
- signature/KEM/ratchet failure with zero state mutation and coarse errors.

### 22.2 Contacts and devices

- full file, permanent DID1 and one-time QR bootstrap;
- recipient offline during request, accept and route rotation;
- simultaneous first messages and duplicate invitation redemption;
- prekey exhaustion/last-resort use and bundle rotation;
- device add/revoke while sender offline, mid-fanout and after outcome unknown;
- recovery creates a new device and never decrypts without backup/history
  transfer;
- 30/180/365-day metadata fixtures preserve identity and report retention gaps.

### 22.3 Groups

- genesis, add/remove/change-role/device and owner-device transfer;
- two concurrent proposals with one canonical owner commit;
- two conflicting valid commits trigger permanent fork latch;
- member/device removal blocks next app send until commit;
- delayed old-epoch event cannot mutate new membership;
- 3-member and 100-member/500-device cold-restart batched fanout;
- partial target failure, duplicate delivery and retry after crash;
- new member no-history default and explicit bounded history transfer;
- network partition permits same-epoch messages but not membership mutation.

### 22.4 Physical and metadata

- two Android devices and Windows exchange arbitrary-contact messages with
  packet capture proving no direct Registry/managed-ingress bypass;
- background/push-disabled operation;
- attachment resume across transport switch;
- call invite/accept/fingerprint/replay/timeout;
- logs and artifacts contain no plaintext or stable account/contact/group/
  route/prekey/call identifiers.

## 23. Release acceptance

Release feature, platform, SLO, physical and independent-review gates are owned
by [`V1-RELEASE-SCOPE.md`](V1-RELEASE-SCOPE.md). Protocol-specific negative
and interoperability evidence from section 22 is an input to those gates, not
a second release checklist.

## 24. Primary references

- Signal PQXDH: <https://signal.org/docs/specifications/pqxdh/>
- Signal Double/Triple Ratchet:
  <https://signal.org/docs/specifications/doubleratchet/>
- Signal Sesame:
  <https://signal.org/docs/specifications/sesame/>
- MLS protocol, RFC 9420: <https://www.rfc-editor.org/rfc/rfc9420.html>
- MLS architecture, RFC 9750: <https://www.rfc-editor.org/rfc/rfc9750.html>
- OpenMLS: <https://github.com/openmls/openmls>
- SimpleX one-time and reusable invitation model:
  <https://simplex.chat/docs/guide/making-connections.html>
- SimpleX agent protocol and queue rotation:
  <https://github.com/simplex-chat/simplexmq/blob/stable/protocol/agent-protocol.md>
