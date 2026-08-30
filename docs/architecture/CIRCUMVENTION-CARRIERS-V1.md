# XPoint Circumvention Carriers V1

Status: normative implementation target for XPoint Network V1.

This specification separates censorship circumvention from three-hop onion routing.
An onion route protects network metadata after a client reaches an entry XNode; a
carrier and bridge-distribution system makes that entry reachable under blocking.
Neither layer is described as sufficient on its own.

The key words **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** follow
RFC 2119 and RFC 8174.

This target supersedes lower-level pre-production text that treats public DNS/TLS,
three embedded Reality origins, or DNS-only TURN/TLS as sufficient censorship
resistance. Existing deployment files remain implementation evidence only until they
conform to the signed artifacts and gates below.

## 1. Goals

The carrier subsystem MUST:

- make all release-critical XPoint classes reachable under the same policy: network
  view, recipient reachability, messages/config, attachments, push registration,
  call signaling, and call media;
- support multiple independently implemented and independently hosted carriers;
- treat Reality as the first carrier, not as the definition of censorship resistance;
- survive extraction of every byte shipped in the public APK/installer;
- rotate bridge addresses and credentials without an application update;
- allow a fresh supported application to bootstrap at any time;
- preserve an existing account and durable operations while every carrier is down;
- forbid silent downgrade to direct HTTPS, direct XNode IP, direct TURN, direct ICE,
  or a weaker transport profile;
- avoid linking bridge acquisition or credentials to a Deep account/device identity;
- provide fast automatic selection without active scanning of arbitrary Internet hosts.

It cannot guarantee reachability against an adversary able to block all Internet
access, all candidate providers, or all traffic not explicitly allow-listed. Product
claims are always bounded by the tested censor capabilities in section 16.

## 2. Terminology and components

| Term | Meaning |
| --- | --- |
| Carrier | client-to-entry byte-stream or datagram mechanism with a recognizable implementation/profile |
| Bridge | a client-reachable ingress not exhaustively listed in the public node roster |
| Public ingress | enumerable XNode endpoint; useful for open networks but assumed blockable |
| Bridge distributor | service that returns a small signed cohort-specific bundle |
| Cohort | unlinkable distribution bucket; never a Deep account, device, contact, or IP identity |
| Binding | signed association between a carrier endpoint and an entry XNode or call relay/key epoch |
| Carrier policy | signed allowed carriers, ordering constraints, downgrade floor, and kill switches |
| Supervisor | client state machine that validates, probes, selects, races, cools down, and rotates carriers |

A bridge may forward to an XNode entry or call relay without being eligible for
mailbox, onion-relay, storage, or call-relay trust roles. Conversely, a public XNode or
call relay does not have to expose every carrier itself. This separation allows public
decentralized routing/storage membership while keeping client ingress addresses
harder to enumerate.

## 3. V1 carrier families

### 3.1 Required carriers

V1 requires two independent TCP-capable implementations:

1. `reality-xhttp-v1` (`0x0001`): Xray VLESS with REALITY and exact XHTTP mode
   from the pinned runtime version. RAW/Vision requires a future carrier ID.
2. `https-stream-v1` (`0x0002`): an independently implemented, WebTunnel-inspired HTTPS
   HTTP/2 streaming endpoint on a real web origin, sharing the origin with plausible
   content and forwarding opaque XPoint frames after authenticated upgrade. The name
   does not claim Tor WebTunnel wire compatibility.

They MUST NOT share all of endpoint IP range, DNS provider, CDN/hosting provider,
certificate authority/account, deployment automation, or bridge distributor.
Using two configurations of the same Xray process on the same IP is one failure
family, not two independent carriers.

### 3.2 Required real-time transports

- `masque-h3-v1` (`0x0003`): exact RFC 9298 CONNECT-UDP over HTTP/3 datagrams; this
  is the preferred call-media carrier where UDP works.
- `masked-tcp-capsule-v1` (`0x0004`): bounded datagrams over an already authenticated
  Reality or HTTPS-stream carrier; mandatory audio fallback where UDP is blocked.

`masque-h3-v1` is not a replacement for TCP carriers because networks can block UDP
wholesale. `masked-tcp-capsule-v1` is not expected to preserve full video
quality under loss because head-of-line blocking is inherent.

### 3.3 Optional future carriers

Snowflake/WebRTC-style ephemeral proxies, obfs4-style proof-resistant bridges,
CONNECT-IP, platform VPN adapters, and partner/CDN carriers MAY be added only with a
new registered carrier ID, signed policy, independent fingerprint review, and the
same no-downgrade rules. Domain fronting MUST NOT be assumed unless the relevant
provider explicitly supports it.

## 4. Carrier interface

Every carrier implementation conforms to one narrow runtime contract:

```text
Probe(binding, deadline) -> ProbeResult
ConnectStream(binding, purpose, deadline) -> authenticated duplex stream
ConnectDatagram(binding, purpose, deadline) -> authenticated datagram session
ClassifyFailure(error, phase) -> stable failure class
Close(reason)
```

`purpose` is one of `CONTROL`, `MAILBOX`, `BLOB`, or `REALTIME`; it changes quotas and
traffic shaping but does not expose account or conversation destination. For the
first three purposes, the carrier sees only an opaque XPoint layer addressed to the
entry node. For `REALTIME`, it sees opaque WebRTC/TURN media addressed to the signed
call-relay binding. It MUST NOT parse MAU2, mailbox, application, contact, group,
attachment, signaling, DTLS-SRTP, or RTCP plaintext.

Carrier processes run with bounded memory/CPU/file descriptors, lifecycle-owned
cancellation, sanitized logs, pinned executable hashes, and no access to recovery,
account, ratchet, SQLCipher, mailbox-holder, or application keys.

## 5. Signed artifacts

Exact encodings follow canonical bounded binary-record rules and use SHA-256 over
exact bytes. Unknown versions, fields, carrier IDs, suites, reserved values, sizes, or
policy bits fail closed before network callbacks or protected-state mutation.

### 5.1 `XCB1` — carrier binding

The target entry XNode or call relay signs the semantic record:

```text
networkId16
bindingId32, bindingGeneration:u64, predecessorBindingHash32
targetKind: ENTRY_NODE or CALL_RELAY
targetId32, targetDescriptorHash32
carrierId:u16, transportMode
endpointHostOrIp, port
serverNames[1..8]
publicAuthenticationMaterial
pathOrServiceName
current/next TLS SPKI pins where applicable
onionTrafficKeyEpochRange or callRelayKeyEpochRange according to targetKind
credentialClass and cohortIdHash32
capabilities: STREAM, DATAGRAM, CONTROL, BLOB, REALTIME
maxFrame, maxStreams, maxDatagram, rateClass
notBefore, expiresAt
targetIdentitySignature
```

For `masque-h3-v1`, the generic endpoint is the MASQUE proxy endpoint only and
the signed conditional block is mandatory and closed in this exact order:

| Order | Field | Type / bound |
|---:|---|---|
| 1 | MASQUE gateway origin | canonical HTTPS origin ASCII, `1..512` |
| 2 | gateway target-auth Ed25519 public key | 32 |
| 3 | CONNECT-UDP target host | canonical DNS ASCII, `1..253` |
| 4 | CONNECT-UDP target port | `u16`, nonzero |
| 5 | target-address count | `u8`, `1..8` |
| 6 | sorted target addresses | exactly `16 * field5` bytes |
| 7 | exact target XCD1 hash | 32 |
| 8 | canonical CONNECT-UDP URI template | canonical ASCII, `1..256` |
| 9 | allocation-token commitment-policy hash | 32 |

These fields are omitted for every other carrier. The target-auth key is generated
and held only by the exact gateway deployment named by `masqueGatewayOrigin`; sharing
it with another gateway/failure family or accepting a policy-level wildcard key
rejects. Gateway TLS/DNS authenticates
`masqueGatewayOrigin`; CONNECT-UDP is authorized only for the exact target tuple and
XCD1. Redirect, alternate authority, DNS-rebound target address, arbitrary target,
URI-template variation or target change after validation rejects before allocation.
Every target address is canonical 16-byte network order; IPv4 is encoded as the
IPv4-mapped IPv6 form. Entries are strictly sorted and unique, and private, loopback,
link-local, multicast, documentation and unspecified addresses reject. DNS may select
only an address already present in this signed set; it never adds an address. Address
rotation therefore requires a successor XCB1.

Carrier-specific `publicAuthenticationMaterial` is strictly typed. For
`reality-xhttp-v1` it contains the exact Reality public key, short ID, fingerprint,
flow, XHTTP mode, spider/path parameters, and pinned Xray compatibility range.
For HTTPS-stream/MASQUE it contains ALPN, path template, TLS policy, and gateway
public key where an inner authenticated upgrade is used.

`XCB1` lifetime is at most seven days. Endpoint changes, Reality key/short ID changes,
server-name changes, transport-mode changes, and SPKI changes require a successor
binding. An entry binding can use an onion key only within its signed epoch range; a
call-relay binding can issue or accept media allocations only within its relay-key
epoch. Target-kind substitution is a new binding and never an in-place update.

### 5.2 `XCC1` — public carrier policy

`XCC1`, version 1, suite `0x0201`, is referenced by stable core hash from XVP1
and has exact tags:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | policy generation | `u64` |
| 3 | predecessor XCC core hash | 32; zero only at generation 0 |
| 4 | minimum carrier security generation | `u64` |
| 5 | allowed carrier-ID mask | `u16`; only registered IDs |
| 6 | allowed purpose mask | `u16`; section-4 bits only |
| 7 | ordered preference count | `u8`, `1..16` |
| 8 | ordered preferred carrier IDs | exactly `2 * tag7` bytes; no duplicate |
| 9 | minimum independent failure families | `u8`, `1..8` |
| 10 | parallel-attempt budget | `u8`, `1..4` |
| 11 | stagger milliseconds | `u32`, `0..30000` |
| 12 | connect/probe/operation/backoff parameters | exactly `connectTimeoutMs:u32be || probeTimeoutMs:u32be || operationDeadlineMs:u32be || baseBackoffMs:u32be || maxBackoffMs:u32be` |
| 13 | traffic-shaping profile mask | `u32`; registered profiles only |
| 14 | direct fallback policy | `u8`; exactly `0=Forbidden` |
| 15 | disabled binding/carrier hash count | `u16`, `0..4096` |
| 16 | sorted typed disabled entries | exactly `33 * tag15` bytes |
| 17 | distributor-key generation | `u64` |
| 18 | distributor-key count | `u8`, `2..16` |
| 19 | sorted distributor entries | exactly `104 * tag18` bytes |
| 20 | distributor threshold | `u8`, `2..tag18` |
| 21 | XBB catalog root | 32; construction below |
| 22 | XBB cohort count | `u16`, `1..4096` |
| 23 | minimum cohort size | `u16`; at least 32 for V1 |
| 24 | XOD1 core catalog root | 32; construction below |
| 25 | XOD1 descriptor count | `u16`, `1..4096` |
| 26 | not-before | `u64` |
| 27 | expires-at | `u64`; `notBefore < expiresAt <= notBefore+2592000` |
| 28 | authorizing XNAAuthorityCoreRef38 | 38; stable authority-core reference |
| 29 | witness-policy hash | 32; exact XNA1 derivation |
| 30 | witness count | `u8`; at least exact XNA1 threshold |
| 31 | sorted witness ID/signature entries | exactly `96 * tag30` bytes |

A distributor entry is `keyId32 || keyGeneration:u64 || Ed25519PublicKey32 ||
failureDomainHash32`; IDs/keys are unique and one accepted threshold uses distinct
failure domains. In tag 12, connect is `1000..60000`, probe is `1000..30000`,
operation is `connectTimeout..300000`, base backoff is `250..60000`, and maximum
backoff is `baseBackoff..300000`, all milliseconds.

A disabled entry is `kind:u8 || valueHash32`, sorted by `(kind,valueHash)` with no
duplicate. Kind 1 disables one registered carrier and uses
`SHA256-D("Deep/Carrier/V1/disabled-carrier", U16BE(carrierId))`; kind 2 disables
one exact binding and uses `SHA256-D("Deep/Carrier/V1/disabled-binding",
SHA256(exactXCB1))`. Every other kind/hash derivation rejects.

XOD1CoreRef38 values sort bytewise; their catalog leaf at consecutive
index `i` is `SHA256(0x00 || U16BE(i) || exactXOD1CoreRef38)` and inner nodes
are `SHA256(0x01 || left32 || right32)`, over exactly tag-25 leaves.

Each tag-31 witness signs
`SIGINPUT("Deep/Carrier/V1/XCC1", 0x0201, unsignedXCC1 tags 1..29)` and resolves
only through tag 28. Tag 30 must be within resolved XNA1 tag-11 threshold..tag-9
witness count; every signer ID/key generation/key comes from XNA1 tag 10 and one
accepted threshold has distinct failure domains. `XCCCoreHash32 = SHA256-D("Deep/Carrier/V1/XCC1/core",
exact unsigned tags 1..29)` and `XCCCoreRef38 = ASCII("XCC1") || U16BE(1) ||
XCCCoreHash32`. Predecessor and XVP1 linkage always use the core; alternate valid
receipt subsets do not create another policy.

A kill switch can disable a compromised carrier or runtime, but cannot enable direct
fallback or lower the minimum security generation. A lower generation is rollback
even if freshly signed by an ordinary witness; only a new root-authority generation
can authorize a clean-break reset.

### 5.3 `XBB1` — bridge bundle

A distributor returns a small cohort-specific `XBB1`, version 1, suite `0x0201`:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | bundle ID | 32; deterministic derivation below |
| 3 | bundle generation | `u64` |
| 4 | distribution channel ID | `u16`; registered acquisition channel |
| 5 | cohort ID hash | 32 |
| 6 | carrier-policy generation | `u64` |
| 7 | rotation slot | `u64` |
| 8 | minimum client generation | `u64` |
| 9 | binding count | `u8`, `1..16` |
| 10 | sorted exact XCB1 records | repeated `LP32(record)`, total bundle <=131072 |
| 11 | bundle not-before | `u64` |
| 12 | bundle expires-at | `u64`; greater than tag 11 and no later than every binding |
| 13 | predecessor XBB catalog-core hash | 32; zero only for independently anchored generation 0 |
| 14 | XCCCoreRef38 | 38; exact policy generation from tag 6 |
| 15 | cohort catalog index | `u16`; `< XCC1 tag22` |
| 16 | catalog proof-node count | `u8`, `0..64` |
| 17 | RFC-6962 catalog proof nodes | exactly `32 * tag16` bytes |
| 18 | distributor signature count | `u8`; referenced XCC1 tag20 threshold..XCC1 tag18 key count |
| 19 | sorted distributor key-ID/signature entries | exactly `96 * tag18` bytes |

Tags 1..13 are `XBB1CatalogLeafCore`; they contain no XCC hash/ref, inclusion
proof or signature. `XBBCoreHash32 = SHA256-D("Deep/Carrier/V1/XBB1/catalog-core",
exact tags 1..13)`. For catalog index `i`, the leaf is
`SHA256(0x00 || U16BE(i) || XBBCoreHash32)` and inner nodes are
`SHA256(0x01 || left32 || right32)`. XCC1 tag 21 is the root of exactly tag-22
cores at consecutive indices `0..count-1`.

After XCC1 is threshold-signed, tag 14 names its stable core, tags 15..17 prove
this core at that exact index, and each distributor signs
`SIGINPUT("Deep/Carrier/V1/XBB1", 0x0201, exact XBB1 tags 1..17)` using the exact
XCC1 tag-17/19 generation/key. Receipt subsets may aggregate but do not alter
`XBBCoreHash32`. This order is acyclic:
`XBB cores -> catalog root -> XCC core/signatures -> XBB proofs/signatures ->
XVP1 -> XNV1`.

`bundleId32 = SHA256-D("Deep/Carrier/V1/bundle-id", networkId16 ||
policyGeneration:u64be || catalogIndex:u16be || rotationSlot:u64be ||
SHA256(exact tag10))`. The cohort ID hash is committed by the pre-generated
catalog. A distributor cannot add per-request entropy or mint a valid unique bundle.

The bundle contains
enough bridges for at least two independent failure families but intentionally does
not reveal the complete pool. Cohort bundles are finite, pre-generated and committed
by XCC1 before client acquisition. Every client receiving one index gets
byte-identical XBB1. Policy requires at least 32 expected clients per active cohort;
while population evidence is below that bound, all clients receive one common cohort.
Assignment input MUST NOT contain an account key, device key, Deep ID, phone
properties, advertising ID, push token, IP address or stable hardware identifier.

### 5.4 `XBA1` — bridge access token

Where scraping resistance is necessary, a binding references a one-use or bounded-use
bearer token:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | token type | `u16`; exactly `1=RandomBearerV1` |
| 3 | issuer key ID | 32 |
| 4 | exact carrier-policy hash | 32 |
| 5 | binding class | `u16`; closed XCC1 class |
| 6 | not-before | `u64` |
| 7 | expires-at | `u64`; `notBefore < expiresAt` and lifetime no greater than `RET-BRIDGE-ACQUISITION-V1` |
| 8 | redemption nonce | 32 nonzero random bytes |
| 9 | public token bytes | `LP16`, `32..256` random bytes |
| 10 | issuer signature | 64 |

`XBA1`, version 1, suite `0x0201`, is signed as
`SIGINPUT("Deep/Carrier/V1/XBA1", 0x0201, unsignedXBA1 tags 1..9)` by an exact
issuer key in the referenced XCC1 distributor policy. Unknown token type, duplicate
token/nonce under one policy, wrong issuer generation or changed signed bytes reject.

Tokens are obtained before they are needed, cached encrypted, redeemed independently
of issuance, and cannot be linked to a Deep identity. Privacy Pass-compatible tokens
are preferred once an audited library is available. A plain random cohort token is
permitted in V1 but is assumed shareable/extractable and therefore short-lived.
Authentication failure produces plausible carrier-native behavior and no XPoint-
specific error oracle.

V1 token issuance uses exact `XOQ1` purpose `BridgeAcquisition` and exact `XOR1`
below through the signed relay/gateway pair. It contains no Deep/account/device
identifier. A token is redeemed only inside encrypted REALITY transport auth or
XHC1, where the bridge atomically stores `SHA256(tokenBytes)` until expiry. Redeemed
token exact-replays only the same channel-hello hash. Privacy Pass is a future token
type and is not claimed by the random-bearer V1 profile.

### 5.5 `XOD1` — OHTTP acquisition/directory descriptor

`XOD1`, version 1, suite `0x0201`, is the only OHTTP trust input. Exact tags are:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | purpose | `u16`: `1=BridgeAcquisition`, `2=AccountDirectory`, `3=LiveTimeAttestation` |
| 3 | descriptor generation | `u64` |
| 4 | predecessor XOD1 core hash | 32; zero only at generation 0 |
| 5 | exact RFC 9458 HPKE key configuration bytes | `LP16`, `32..1024` |
| 6 | HPKE key-config ID | `u8`; equals decoded config |
| 7 | KEM | `u16`; exactly DHKEM(X25519, HKDF-SHA256) for V1 |
| 8 | KDF | `u16`; exactly HKDF-SHA256 |
| 9 | AEAD | `u16`; exactly AES-128-GCM or ChaCha20-Poly1305 |
| 10 | Relay HTTPS origin | canonical ASCII, `1..512` |
| 11 | Relay resource path | canonical ASCII, `1..256` |
| 12 | Gateway HTTPS origin | canonical ASCII, `1..512` |
| 13 | Gateway resource path | canonical ASCII, `1..256` |
| 14 | target resource ID/hash | 32; purpose-bound, not an arbitrary URL |
| 15 | allowed request/response padding mask | `u16`; exact signed classes |
| 16 | Relay/Gateway failure-family label hashes | 64; two ordered 32-byte hashes |
| 17 | authorizing XNAAuthorityCoreRef38 | 38 |
| 18 | not-before | `u64` |
| 19 | expires-at | `u64`; `notBefore < expiresAt <= notBefore+2592000` |
| 20 | minimum reader | `u16` |
| 21 | threshold signature count | `u8`; XNA witness threshold..witness count |
| 22 | sorted signer ID/signature entries | exactly `96 * tag21` bytes |

Signers cover identical unsigned tags 1..20 with
`SIGINPUT("Deep/Carrier/V1/XOD1", 0x0201, unsignedXOD1)`. The referenced policy
is the exact XNA witness policy and defines threshold/key generations; XOD1 does
not reference XCC1. `XOD1CoreHash32 =
SHA256-D("Deep/Carrier/V1/XOD1/core", exact unsigned tags 1..20)` and
`XOD1CoreRef38 = ASCII("XOD1") || U16BE(1) || XOD1CoreHash32`; predecessor,
XCC catalog, ADL1 and XOQ1 use this stable core. Receipt subsets may aggregate and
do not change descriptor identity. XCC1 tag 24 commits every active XOD1 core.
ADL1 or an acquisition request binds exact XOD1 core/purpose;
cross-purpose, stale, changed-same-generation, unknown algorithm/config, Relay=
Gateway administrative failure family or arbitrary target substitution fails closed.
Byte-identical Relay/Gateway resources may be reached through multiple carriers but
do not become different XOD1 identities.

### 5.6 `XOQ1` / `XOR1` — closed OHTTP application exchange

RFC 9458 owns encapsulation only. `XOQ1`, version 1, suite `0x0201`, is the sole
decrypted application request accepted by an XOD1 target:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | exact XOD1 core hash | 32 |
| 3 | purpose | `u16`; exact XOD1 purpose |
| 4 | operation ID | 32 nonzero random bytes; stable for exact retry |
| 5 | client nonce | 32 nonzero random bytes; stable for exact retry |
| 6 | issued-at | `u64`; `ZERO64` exactly for LiveTimeAttestation |
| 7 | expires-at | `u64`; `ZERO64` exactly for LiveTimeAttestation, otherwise `issuedAt < expiresAt <= issuedAt+30` |
| 8 | selected padding class | `u16`; exactly one allowed class bit |
| 9 | purpose payload | `LP32`, exact union below, maximum 4,096 bytes |

Purpose payloads are fixed and closed:

```text
BridgeAcquisition =
  exactCarrierPolicyHash32 || bindingClass:u16 || cohortNonce32 ||
  requestedCount:u8                         # 1..16

AccountDirectory =
  exactADL1Hash32 || directoryLeafKey32 || hasLkg:u8 ||
  lkgTreeSize:u64 || lkgADH1Hash32 || minimumADHGeneration:u64 ||
  minimumADH1Hash32 || historyProofMode:u8 # mode 0/1 from ADP1

LiveTimeAttestation =
  clientNonce32 || minimumADHGeneration:u64 || minimumADH1Hash32 ||
  minimumXNVGeneration:u64 || minimumXNV1Hash32
```

For no LKG/floor, the corresponding generation/hash tuple is all zero; otherwise
both are nonzero and exact. LiveTime payload nonce MUST equal tag 5. Any other
length, inconsistent zero tuple, unknown binding/history class or cross-purpose
payload rejects before target callback. LiveTimeAttestation is the sole clockless
request: tags 6/7 MUST both be zero, the target starts a protected monotonic 30-second
operation deadline on first receipt, and witnesses apply the nonce ceremony in the
account-directory specification. Every other purpose requires nonzero tags 6/7 and
target secure time wholly inside that interval. Client wall time is never accepted as
an alternative for LiveTime bootstrap.

`XOR1`, version 1, suite `0x0201`, is the sole decrypted response:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | exact XOD1 core hash; equals XOQ1 tag 2 | 32 |
| 3 | purpose | exact XOQ1 tag 3 |
| 4 | operation ID | exact XOQ1 tag 4 |
| 5 | exact XOQ1 hash | 32 |
| 6 | status | `u16`: `1=Success`, `2=NotFound`, `3=Expired`, `4=RateLimited`, `5=Unavailable`, `6=Conflict` |
| 7 | response kind | `u16`: `0=None`, `1=BridgeTokenBatch`, `2=ADP1`, `3=DTT1` |
| 8 | response payload | `LP32`, `0..262144` |
| 9 | issued-at | `u64`; for DTT1 success equals inner DTT1 issued-at |
| 10 | expires-at | `u64`; for DTT1 success equals inner DTT1 expiry, otherwise cannot exceed request or inner-object expiry |
| 11 | retry-after seconds | `u32`; nonzero only for RateLimited/Unavailable |

Success requires the one response kind matching the request purpose.
`BridgeTokenBatch` is `count:u8(1..16) || LP16(exactXBA1)` repeated in ascending
`SHA256(exactXBA1)` order; other kinds contain exactly one canonical ADP1 or DTT1.
The client verifies every inner signature/proof and its exact request nonce/floors.
All non-success statuses use kind zero and empty payload. Exact retry under one
operation ID returns byte-identical XOR1; changed XOQ1 under that ID returns Conflict.
Before releasing any response, the target atomically commits `(XOD1CoreHash32,
operationId, exactXOQ1Hash, exactXOR1)` with any token mint/query result and retains
that replay row through the later of XOR1 expiry and every returned inner-object
expiry. A crash can resume or replay that transaction but cannot mint a second token
batch, consume the DTT nonce twice, change proof bytes or return a newly timed success.
Unavailable is permitted only before an application callback/side effect is committed.
For clockless LiveTime, the client accepts XOR1 only within its local monotonic
`nonceCreatedAt+30s` deadline and derives time solely from the exact DTT1; outer
tags 9/10 are equality checks against DTT1, not independent time evidence. A
non-success clockless response sets tags 9/10 to `ZERO64` and is usable only as a
coarse failure. No target may mint or query application state before the complete
XOQ1 is validated.

Target ownership is exclusive by purpose: `BRIDGE-DISTRIBUTOR-01` owns
BridgeAcquisition token minting and its `RET-BRIDGE-ACQUISITION-V1` ledger;
`DIRECTORY-01` owns AccountDirectory and LiveTimeAttestation proof/time business
transactions under their directory retention classes. An RFC 9458 Relay or OHTTP
Gateway validates/forwards transport bytes but never commits an application XOR1
ledger or retries an application callback on its own.

Padding-class bits 0..6 mean exact decrypted-body sizes
`256, 1024, 4096, 16384, 65536, 131072, 262144`. The decrypted OHTTP body is
`canonicalLength:u32 || exactXOQ1-or-XOR1 || zeroPadding` to the selected size.
Canonical length must end before the class boundary; nonzero padding, wrong class,
trailing encapsulated bytes or a class not allowed by XOD1 rejects. Padding is inside
OHTTP HPKE and therefore creates no unauthenticated padding oracle. XOQ1 is at most
8,192 bytes and XOR1 at most 262,144 bytes including its canonical framing.

## 6. Bridge pools and distribution channels

### 6.1 Pool classes

| Pool | Visibility | Purpose |
| --- | --- | --- |
| `embedded-seed` | extractable from release | first attempt and recovery hint; never sole pool |
| `public` | listed or discoverable | open networks, testing, capacity relief |
| `cohort` | small bundle per acquisition | normal censored-network operation |
| `reserved` | manual/trusted distribution | severe regional blocking and incident recovery |

Every public release assumes its embedded set is known to a censor on publication
day. Embedded endpoints MUST be replaceable without an app update and MUST NOT carry
unique long-lived client credentials.

### 6.2 Mandatory acquisition channels

At least three channels with two independent hosting/control families are required:

1. `in-app-oblivious`: exact RFC 9458 OHTTP through a normal HTTPS/ECH
   relay/gateway split; the relay sees client IP but not requested cohort, and the
   gateway sees the request but not client IP.
2. `multi-origin-https`: equivalent signed bundles on unrelated ordinary web origins,
   with ECH when the provider offers a real anonymity set. ECH hides SNI, not IP.
3. `user-import`: signed QR, file, or copied text bundle obtained from a trusted person,
   website mirror, email/bot, or another installed device.

An application SHOULD also ship several embedded seed bundles from independent
release generations. DNS records are hints only; signatures, predecessor/checkpoint,
SPKI/carrier authentication, and policy determine trust.

No channel is authoritative. An attacker controlling one channel can withhold or
serve stale objects but cannot forge a valid current bundle. Clients fetch at most
one cohort from a channel per refresh window and do not enumerate the pool.

The OHTTP channel is used only for independent request/response transactions.
Its HPKE key configuration, purpose and Relay/Gateway/target resource identifiers
come only from exact XOD1. Client, relay and gateway MUST NOT add cookies,
account authentication, stable request headers or cross-request application
state; the relay MUST remove transport-derived identifying headers. Requests and
responses use signed padding classes. Release evidence must prove that relay and
gateway are separately administered/failure-domain-labelled; otherwise the UI
and evidence classify the channel as ordinary HTTPS acquisition and make no
source-IP/request unlinkability claim.

### 6.3 Fresh installation

A fresh application contains:

- current and next offline root authority keys/checkpoints;
- current carrier policy hash and minimum security generation;
- several independently signed embedded seed bundles;
- distributor public keys and channel descriptors;
- no private bridge, VLESS, account, or node key.

It races embedded attempts with acquisition channels using the supervisor policy.
If all are blocked, the UI offers user-import without requiring account creation or
reset. Imported bundles are verified before any endpoint is contacted.

## 7. REALITY profile

`reality-xhttp-v1` uses a pinned, reproducibly built Xray-core version. The build,
configuration schema, binary hash, and provenance are release evidence. Automatic
runtime download or an unpinned system Xray is forbidden.

The binding specifies all client parameters; no defaults are guessed. Server and
client validation MUST include:

- exact endpoint, port, `serverName`, Reality public key, short ID, fingerprint,
  transport mode, flow, path, ALPN, and time window;
- current entry-node descriptor and onion-key epoch;
- unique randomized key/short-ID material per bridge deployment;
- plausible target chosen by operator testing for that network and deployment;
- bounded fallback upload/download and handshake/resource limits;
- rejection of mismatched or expired binding before launching the runtime.

The VLESS/Reality client identifier is a cohort credential, not an account/device
identifier. It rotates with the bundle and MUST NOT be reused across unrelated bridge
pools. Publication in an APK is treated as disclosure, not secret provisioning.

REALITY changes TLS appearance but does not hide destination IP. It therefore MUST be
combined with unlisted/rotating bridge addresses and alternate carrier families.
Post-quantum TLS support at a camouflage target protects only the carrier handshake;
it does not provide post-quantum application E2EE or onion-layer security.

## 8. HTTPS-stream profile

`https-stream-v1` shares TCP/443 and a valid public certificate with a maintained,
plausible website. Unauthenticated requests receive normal site content or an
ordinary bounded HTTP error. XPoint upgrade requires the bridge token and an inner
binding challenge before opaque traffic is accepted.

The endpoint MUST use common HTTP semantics and production browser-like TLS behavior
without claiming indistinguishability. It MUST NOT use a unique hostname, certificate
subject, path constant, header order, user agent, or error body across all bridges.
Variation comes only from signed templates and reviewed implementations, not random
protocol deviations that break interoperability.

The exact wire is RFC 8441 WebSocket over HTTP/2. The client sends extended
`CONNECT` with `:protocol=websocket`, the signed per-binding path, ordinary
browser-compatible headers from the binding template and no Deep-specific
subprotocol header. HTTP/1.1 WebSocket is not an automatic fallback; it requires a
separate signed transport mode. Redirects are followed only to an exact successor
origin authorized by XCB1. Cookies, browser storage, analytics, third-party scripts
and account authentication are forbidden.

The first binary WebSocket message is canonical tagged `XHC1`, version 1, suite
`0x0201`: `1=networkId16`, `2=exactXCB1Hash32`, `3=operationId32`,
`4=accessTokenType:u16`, `5=LP16(accessToken[1..4096])`, `6=clientNonce32`,
`7=clientEphemeralX25519Public32`, `8=requestedPurpose:u16`,
`9=requestedMaxFrame:u32`, `10=issuedAt:u64`, `11=expiresAt:u64`,
`12=paddingClass:u16`. Purpose is one section-4 purpose, expiry is at most 30
seconds after issue, and padding class is one of 256/1024/4096/16384 outer bytes.
Padding is authenticated zeros after canonical bytes; unknown/duplicate tags reject.

The server verifies size/token/expiry before X25519 and responds with canonical
tagged `XHA1`, version 1, suite `0x0201`: `1=networkId16`,
`2=exactXCB1Hash32`, `3=operationId32`, `4=exactXHC1Hash32`,
`5=status:u16`, `6=clientNonce32`, `7=serverNonce32`,
`8=gatewayEphemeralX25519Public32`, `9=acceptedPurpose:u16`,
`10=acceptedMaxFrame:u32`, `11=bindingGeneration:u64`, `12=issuedAt:u64`,
`13=expiresAt:u64`, `14=paddingClass:u16`, `15=gatewayEd25519Signature64`.
Statuses are `1=Accepted`, `2=Expired`, `3=Unauthorized`, `4=RateLimited`,
`5=Conflict`; only Accepted has nonzero tags 7..13. Exact XHC retry returns the
byte-identical XHA; changed bytes under operation ID return Conflict. Signature is
`SIGINPUT("Deep/Carrier/V1/https-stream-accept", 0x0201,
unsignedXHA1 tags 1..14)` under the exact gateway key in XCB1.

Token redemption, operation ID, request hash, XHA bytes and server ephemeral private
key are committed atomically. The private key is sealed in memory only until the
30-second handshake expiry so an exact lost-response retry can derive the same
channel; it is destroyed on expiry or first successfully authenticated frame. Crash
before commit consumes nothing, crash after commit exact-replays, and no operation
can redeem the token for changed XHC bytes.

For Accepted:

```text
transcriptHash32 = SHA256-D(
  "Deep/Carrier/V1/https-stream-transcript", exactXHC1 || exactXHA1)
shared32 = X25519(clientEphemeralPrivate, gatewayEphemeralPublic)
prk = HKDF-Extract-SHA256(transcriptHash32, shared32)
c2sKey32 = HKDF-Expand-SHA256(prk, "c2s-key" || 0x00 || transcriptHash32, 32)
s2cKey32 = HKDF-Expand-SHA256(prk, "s2c-key" || 0x00 || transcriptHash32, 32)
c2sNoncePrefix16 = HKDF-Expand-SHA256(prk, "c2s-nonce" || 0x00 || transcriptHash32, 16)
s2cNoncePrefix16 = HKDF-Expand-SHA256(prk, "s2c-nonce" || 0x00 || transcriptHash32, 16)
```

Ephemeral private/shared/PRK are destroyed after derivation. Each direction has one
global `sequence:u64` starting at zero. An encrypted binary frame is
`sequence:u64be || bucket:u32be || ciphertext[bucket]`; every integer in this
outer frame and its inner control/data plaintext is unsigned big-endian. Direction
is exactly `1=ClientToGateway`, `2=GatewayToClient`; any other value rejects. Nonce is
`directionNoncePrefix16 || sequence:u64be`, AAD is
`transcriptHash32 || direction:u8 || sequence:u64be || bucket:u32be`, and plaintext
inside XChaCha20-Poly1305 is
`streamId:u32be || kind:u16be || flags:u16be || payloadLength:u32be || payload || zeroPadding`.
Buckets are 256/1024/4096/16384/65536/1048576/2097152 bytes; plaintext plus the
16-byte AEAD tag fills the selected ciphertext bucket.

Kinds are `1=Data`, `2=Ping`, `3=Pong`, `4=HalfClose`, `5=Close`. Stream 0 is
control-only; Data uses streams 1..32. Flags are zero in V1. Ping/Pong payload is one
random 32-byte challenge; HalfClose is empty; Close is `reason:u16` with
`1=Normal`, `2=Policy`, `3=Protocol`, `4=Resource`, `5=Timeout`. Data contains one
complete XPoint frame. Maximum 8 MiB connection buffer and 64 outstanding frames.
Sequence gap/reuse, wrong bucket/padding, invalid stream/kind/payload, text frames,
compression/extensions or AEAD failure closes with ordinary WebSocket policy
violation after bounded delay.

Unauthenticated paths render the maintained cover site; malformed/auth failures do
not return XPoint magic or stable timing oracle. This profile remains an experimental
anti-censorship carrier until active-probe/classifier review; successful transport
does not claim indistinguishability from generic web traffic.

## 9. MASQUE/real-time profile

`masque-h3-v1` is the exact RFC 9298 CONNECT-UDP profile over HTTP/3 with RFC 9297
Capsule Protocol negotiation and HTTP Datagrams. Proxy origin, URI template,
separate target host/port, exact XCD1, ALPN `h3`, max datagram and gateway
authentication are exact XCB1 fields; arbitrary
targets and generic proxy use reject. The target is always the signed XPoint call
relay from `XCD1/XCB1`, never arbitrary Internet UDP. The bridge enforces exact target,
packet, bandwidth, amplification, allocation, and lifetime limits. Mailbox/control
traffic continues to use an entry-node binding and three onion layers; MASQUE call
media does not remove or replace that request path.

QUIC 0-RTT MUST be disabled for bridge-token redemption, call allocation, mailbox
mutation, and any non-idempotent control operation. Connection migration MAY preserve
a call across mobile network changes after path validation. The carrier exposes no
general VPN or open proxy API.

The Extended CONNECT request uses `:method=CONNECT`,
`:protocol=connect-udp`, the exact signed scheme/authority/path, and requires a
2xx response plus negotiated Capsule Protocol before the client releases media.
UDP payloads use Context ID zero; unknown contexts reject for V1. Optimistic
datagrams before the successful response are forbidden. The bridge drops rather
than fragments payloads above the signed path limit and applies per-stream and
per-connection buffering bounds before allocation.

Before returning 2xx or forwarding any client datagram, the MASQUE gateway performs
one target-auth ceremony for the selected signed address. `MPC1`, version 1, suite
`0x0201`, has exact tags:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | exact XCB1 hash | 32 |
| 3 | exact XCD1 hash | 32; equals XCB1 target |
| 4 | target address | 16; member of signed XCB1 set |
| 5 | target port | `u16`; exact XCB1 target port |
| 6 | gateway nonce | 32 nonzero CSPRNG bytes, new per CONNECT attempt |
| 7 | issued-at | `u64` |
| 8 | expires-at | `u64`; `issuedAt < expiresAt <= issuedAt+10` |
| 9 | gateway target-auth signature | 64 |

The gateway signs
`SIGINPUT("Deep/Carrier/V1/MASQUE-gateway-auth", 0x0201,
unsignedMPC1 tags 1..8)` with the exact XCB1
`masqueGatewayTargetAuthEd25519PublicKey32` key before sending MPC1. The target
silently drops unsigned, stale, replayed, wrong-key or wrong-XCB1 challenges and
does not emit a distinguishable XPoint error. Only after that verification does the
target reply with `MPA1`, version 1, suite `0x0201`:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | exact MPC1 |
| 2 | exact MPC1 hash | 32 |
| 3 | gateway nonce | exact MPC1 tag 6 |
| 4 | exact XCD1 hash | exact MPC1 tag 3 |
| 5 | target address | exact MPC1 tag 4 |
| 6 | target port | exact MPC1 tag 5 |
| 7 | XCD1 descriptor generation | `u64` |
| 8 | issued-at | `u64` |
| 9 | expires-at | `u64`; no later than MPC1/XCD1/XCB1 expiry |
| 10 | relay target-auth signature | 64 |

The CallRelay receives MPC1 on the exact local destination address/port and rejects
unless its gateway signature is valid and tags 4/5 equal that socket destination and
its current XCB1/XCD1 closure. It durably consumes `(XCB1Hash, gatewayNonce)` until
tag 8 before signing, and an exact retry returns the byte-identical MPA1. It
signs `SIGINPUT("Deep/Carrier/V1/MASQUE-target-auth", 0x0201,
unsignedMPA1 tags 1..9)` only with XCD1 tag-5 target-auth key. This local-destination
check prevents a poisoned endpoint from forwarding the challenge to a genuine relay.
The gateway requires MPA1 tag 7 to equal exact XCD1 generation, requires
`MPC1.issuedAt <= MPA1.issuedAt < MPA1.expiresAt`, verifies every echoed field,
signature, nonce and current XCB1/XCD1 closure, pins the authenticated address for the
CONNECT lifetime, and only then returns 2xx. Timeout, changed replay, DNS change, address migration
or signature mismatch closes without forwarding and cannot fall back to an unsigned
target. A deployment unable to bind/observe the exact signed public destination
address is ineligible for this V1 profile; NAT/proxy address inference is forbidden.
MPC1/MPA1 contain no client/account/call identifier or allocation bearer.

When UDP is unavailable, the supervisor selects `masked-tcp-capsule-v1` through a
verified Reality/HTTPS-stream channel. Its canonical record is
`channelId:u32 || mediaClass:u8 || flags:u8 || sequence:u64 || deadlineDeltaMs:u16 ||
payloadLength:u16 || payload`, with payload `0..1200`, deadline `0..2000 ms`, and
classes `Audio`, `RTCP`, `Video`. Unknown flags/classes, reused sequence or oversized
payload reject. Per-channel queued payload is <=256 KiB; expired video drops first,
then expired RTCP, while audio has strict priority but no unbounded retry. This is a
datagram-preserving media shim, not a reliable tunnel or open proxy.

## 10. Carrier-supervisor state machine

The supervisor owns one state per binding and one aggregate state per purpose:

```text
Unknown -> Eligible -> Probing -> Connecting -> Ready
              |          |           |          |
              v          v           v          v
           Expired    CoolingDown  CoolingDown  Degraded
                                                 |
                                                 v
                                      Ready/CoolingDown/Retired

Any state -> Revoked/Retired on signed policy or binding succession
```

Rules:

1. `Eligible` requires a live verified policy, bundle, binding, node descriptor, key
   epoch, capability, minimum client generation, and unused/valid access token.
2. `Probe` performs only the carrier-native handshake plus an authenticated fixed-size
   entry challenge. It never sends mailbox or account data.
3. At most two independent failure families race. The preferred attempt starts first;
   the second starts after 250 ms for interactive control/call traffic or 750 ms for
   background traffic.
4. The first end-to-end authenticated entry response wins. Losing attempts close and
   cannot mutate application state.
5. Three failures in ten minutes cool a binding for decorrelated-jitter backoff from
   30 seconds to six hours. Auth/policy/revocation failure retires it immediately.
6. Internet loss, captive portal, device sleep, or cancellation does not penalize a
   binding.
7. A network change revalidates the active path without discarding all confirmed
   bindings.
8. Successful bindings are retained to reduce fingerprint churn, but bundle refresh
   maintains at least two unused alternatives.

Aggregate purpose state is `Available`, `Degraded`, `Blocked`, or `Offline`. `Offline`
means the device has no usable Internet; `Blocked` means Internet works but all
eligible carriers failed. UI and retry policy distinguish them.

## 11. Carrier selection

Candidates are first filtered by hard policy and purpose. They are ranked by:

1. previously confirmed and currently healthy;
2. independent failure family from the most recent failure;
3. purpose suitability (`DATAGRAM` for real time, streaming for blobs);
4. local exponentially decayed handshake/RTT/loss score;
5. bundle-provided coarse capacity class;
6. client-local CSPRNG tie-break.

The distributor cannot provide a per-client priority. A binding's signed order is not
a command to use it. Local scores contain no stable network or endpoint identifiers
when exported. Carrier choice does not change a three-hop request route unless an
entry binding changes to another guard. Real-time carrier choice changes only the
masked path to the same authorized call allocation and never enables a direct peer
candidate.

Default preference on an open network is:

```text
CONTROL/MAILBOX: confirmed Reality or HTTPS-stream, whichever is lower-latency
BLOB: confirmed streaming carrier with measured goodput
REALTIME: MASQUE/UDP -> masked TCP capsule fallback
```

`MaskedRequired` is the production default. There is no automatic `DirectAllowed`
transition. A developer-only direct mode is compile-time excluded from release
artifacts and cannot generate release evidence.

## 12. Rotation and protected state

The client atomically stores:

```text
carrierPolicyGeneration/hash
bundleGeneration/hash/channel/cohort
binding generation/hash and predecessor
minimum security generation
confirmed/cooldown timestamps in monotonic-safe form
encrypted unused bridge tokens
last successful failure-family and coarse performance buckets
```

Current and next bundles overlap by at least six hours. A client refreshes at 50% of
bundle lifetime plus +/-10% jitter and immediately on signed policy push, resume near
expiry, or repeated independent failures. It keeps the prior bundle until the new one
has at least one confirmed binding or the old one hard-expires.

Rollback, same-generation fork, wrong network, lower minimum client/security
generation, unknown carrier, expired node/key binding, or changed same-ID content is
terminal for that candidate. It does not erase the protected last-known-good state.

Returning clients outside bundle validity use any retained root/distributor
checkpoint and acquisition channel, or import a signed bundle. Account identity and
application state are never reset to fix bridge state.

## 13. Active probing and anti-enumeration

- Unauthenticated traffic receives behavior consistent with the selected carrier's
  cover service and never an XPoint banner, certificate, timing code, or stable body.
- Bridge authorization is verified before expensive onion/call allocation.
- Authentication errors are indistinguishable across invalid token, short ID, binding,
  time, and entry-key cases to the remote peer.
- Rate limiting happens before expensive cryptography where safe, with bounded per-IP
  and global budgets. It must not build a long-lived cross-bridge user profile.
- Distributors return a small cohort, not a searchable list; pagination and wildcard
  queries do not exist.
- Clients never scan address ranges, scrape certificates, or probe endpoints not in a
  verified bundle.
- A bridge compromise does not authorize XNode identity, network views, routes,
  mailbox mutation, or application plaintext.

Anti-enumeration raises cost; it cannot keep an endpoint secret from a censor that
legitimately obtains and redistributes a client bundle. Operational rotation and pool
diversity remain mandatory.

The unauthenticated active-probe release gate is preregistered per carrier/profile.
It captures at least 10,000 randomized invalid/auth-missing probes and 10,000 matched
cover-service controls across two external networks, with a held-out test set and
fixed features before evaluation. The upper 95% bootstrap confidence bound for a
binary classifier AUC MUST be <=0.60; no stable body/header/TLS alert identifies
XPoint, and malformed-class timing/resource buckets remain within the signed cover
profile. Failure blocks that carrier claim; it does not authorize cosmetic runtime
randomization or the statement “indistinguishable from all web traffic.”

## 14. Traffic shape and fingerprint discipline

Carrier-native handshake and framing are kept as close as practical to their cover
protocol. XPoint adds application padding only inside the authenticated carrier, so
unauthenticated probes cannot request arbitrary expensive sizes.

The release pipeline records packet captures for:

- handshake bytes and TLS/QUIC fingerprints;
- packet-size and inter-arrival distributions for idle, message, polling, blob, and
  call workloads;
- error, timeout, cancellation, and expired-credential paths;
- Android, Windows, and each supported network stack.

One global `serverName`, short ID pattern, path, ALPN set, TLS fingerprint, polling
interval, or exact packet-size sequence across all bridges is forbidden. Variation is
bounded by signed profiles and tested for plausibility. Random cosmetic changes with
no measured censorship value are rejected because they increase bugs and uniqueness.

Polling jitter and XPoint inner size buckets are defined by the network spec. Optional
cover traffic requires a separate battery/data/privacy evaluation and remains off by
default in V1.

## 15. Privacy-preserving operations

Metrics use only aggregate carrier ID, coarse country/network class supplied by the
operator environment, success/failure class, and latency/byte buckets. Reports have
no Deep ID, account/device key, endpoint, bridge/bundle/token ID, IP, ASN observed from
the client, route, contact, call ID, stable installation ID, or unsalted hash thereof.

Crash dumps exclude carrier configuration and command lines. Runtime subprocesses
receive credentials through protected files/pipes, not argv or world-readable env.
Logs redact endpoints and use run-scoped keyed aliases that cannot be correlated
between runs.

Export uses UTC-day time buckets and suppresses every bucket with fewer than 20
contributing runs. Raw per-run metrics remain local for at most 24 hours; exported
aggregate buckets are retained at most 30 days and cannot be joined with support,
account, bridge-distribution or crash-report data. At launch populations below the
cardinality floor, no country/network split is exported. Differential privacy is not
claimed in V1.

Bridge pool health is measured by independent probes and aggregate distributor
redemptions. A distributor does not receive application success telemetry. An XNode
does not receive the bridge acquisition channel or cohort except the minimum token
class needed for admission.

## 16. Mandatory censorship test matrix

Every release carrier policy is tested from at least two external providers and a
production-equivalent restrictive gateway. The test harness MUST support:

| Censor action | Required result |
| --- | --- |
| extract and block every endpoint/string shipped in APK/installer | if at least one signed acquisition/import channel remains reachable, fresh install obtains another bridge; otherwise UI reports blocked |
| poison/NXDOMAIN all `*.xpoint.network` DNS | user-import and at least one non-XPoint acquisition/carrier family works |
| block known public XNode and Registry IPs | cohort/reserved bridge reaches a valid entry |
| block all extracted/known Deep SNI, Host, path and endpoint IP values | a non-blocked independently hosted Reality or HTTPS-stream cohort succeeds without direct fallback |
| block all UDP | messages/blobs work; calls retain audio over masked TCP and may disable video |
| block measured Reality fingerprint/profile | independently hosted HTTPS-stream succeeds; this does not prove generic-web indistinguishability |
| block HTTPS-stream origins/profile | independent Reality pool succeeds |
| active probe every extracted endpoint | no XPoint-specific unauthenticated oracle; rotated cohort remains usable |
| replay/clone bridge token | bounded rejection; no identity leak; other cached token/binding works |
| serve stale/forked bundles | protected LKG rejects rollback/fork and keeps valid current bindings |
| distributor unavailable/lying | signatures prevent forgery; other channel or import works |
| captive portal and intermittent Internet | classified as offline/captive, not mass bridge revocation |
| carrier drops after entry accepted mutation | operation becomes outcome-unknown and reconciles idempotently |
| carrier changes during a call | audio recovers within SLO or ends without exposing direct ICE or unmasked TURN |

Each row assumes at least one stated alternative path remains reachable. No result
claims survival when the censor blocks all Internet/all acquisition families.
Passing only the test “direct HTTPS blocked, Reality succeeds” is insufficient.

## 17. Conformance and security tests

### 17.1 Artifact tests

- golden/negative vectors for `XCB1/XCC1/XBB1/XBA1/XOD1/XOQ1/XOR1/XHC1/XHA1/MPC1/MPA1`;
- all hostile lengths, duplicate/unknown fields, reserved values, wrong network,
  predecessor, generation, signatures, key epochs, time windows, and capability/purpose
  mismatches reject before runtime launch;
- same-ID different-content and same-generation forks preserve LKG and fail closed;
- current/next overlap and hard-expiry time-travel tests at 30/180/365 days.

### 17.2 Runtime tests

- subprocess crash, hang, cancellation, host sleep, resume, network handover, IPv4/
  IPv6, TLS rotation, key rotation, and bounded shutdown;
- memory/CPU/file-descriptor/connection/rate limits under malformed floods;
- no secrets in argv, environment capture, logs, crash dumps, metrics, or evidence;
- reproducible build and pinned hash/license/SBOM for Xray and every carrier runtime;
- packet capture proves all application classes use the selected carrier and entry;
- losing raced attempts cannot send a logical mutation after winner commit.

### 17.3 Physical tests

- two Android devices and Windows on unrelated networks;
- mobile Wi-Fi/cellular handover during message upload, attachment, and call;
- foreground/background, push disabled, cold process restart, and device reboot;
- audio/video quality under latency, loss, reordering, UDP block, and TCP-only fallback;
- no peer IP, public STUN, unmasked/direct-to-origin TURN, public XNode, Registry, blob, or signaling
  connection in `MaskedRequired` packet captures.

### 17.4 Independent review

Public activation requires an independent censorship-resistance review in addition to
the protocol/crypto and application security reviews. A new carrier or substantial
Xray profile change repeats fingerprint, active-probe, downgrade, supply-chain, and
resource-exhaustion review.

## 18. Implementation work packages

1. Freeze carrier IDs, semantic artifacts, canonical codecs, vectors, and policy
   verification in `deep-protocol`.
2. Implement protected LKG and the supervisor without launching any runtime.
3. Implement `reality-xhttp-v1` adapter with exact signed binding and reproducible
   pinned Xray.
4. Implement the independent `https-stream-v1` adapter and separate hosting lane.
5. Implement distributors, embedded bundles, multi-origin HTTPS, user import, and
   OHTTP relay/gateway acquisition.
6. Connect all control/mailbox/blob paths and remove direct release composition.
7. Implement MASQUE/UDP and bounded masked-TCP datagrams for XPoint calls.
8. Automate the full censorship, packet-capture, physical, supply-chain, and SLO gates.

Each package must include cancellation, restart, rollback/fork, malformed input,
resource limits, logging redaction, and exact failure classification. No implementation
may wait for P2P mesh or on-prem, but no shared interface may encode an official XPoint
hostname, carrier, or authority.

### 18.1 Repository ownership

| Repository | Exclusive implementation ownership for this specification |
| --- | --- |
| `deep-protocol` | carrier IDs, `XCB1/XCC1/XBB1/XBA1/XOD1/XOQ1/XOR1/XHC1/XHA1/MPC1/MPA1` codecs, bounds, signatures, lineage and vectors |
| `deep-registry-api` | CARRIER-CATALOG-01 byte-identical XCC/XBB construction/publication, DIRECTORY-01 AccountDirectory/LiveTime XOQ targets and BRIDGE-DISTRIBUTOR-01 BridgeAcquisition business/replay transaction; no client route choice |
| `xnode` | CARRIER-GATEWAY-01 XHC/OHTTP/MASQUE transport runtime, authenticated bridge-to-entry/call-relay targets, quotas, target-key epochs and coarse errors; no application XOQ ledger |
| `deep-client-shared` | policy/LKG verification, supervisor state and transport-neutral failure/result types |
| `deep-client-maui` | pinned Xray and HTTPS/MASQUE adapters, protected subprocess lifecycle, network-change integration |
| `deep-devops` | deployment of independent carrier/gateway/distributor lanes, bridge pools, rotation and capture harness; no runtime business-state ownership |
| `deep-tests-e2e` | active-probe, APK extraction, censor matrix, rollback/fork and physical cross-client scenarios |

No carrier adapter verifies application E2EE or changes durable message state. No
distributor learns a Deep identity. No runtime process receives more than one binding
and its short-lived token/key material.

## 19. Primary references

- Project X REALITY configuration and parameter model:
  <https://xtls.github.io/en/config/transports/reality.html>
- Tor pluggable-transport architecture:
  <https://spec.torproject.org/pt-spec/>
- Tor WebTunnel deployment model:
  <https://community.torproject.org/relay/setup/webtunnel/>
- Tor Snowflake deployment model:
  <https://community.torproject.org/relay/setup/snowflake/>
- Tor bridge distribution buckets:
  <https://community.torproject.org/relay/setup/bridge/post-install/>
- TLS Encrypted ClientHello:
  <https://www.rfc-editor.org/rfc/rfc9849.html>
- Oblivious HTTP:
  <https://www.rfc-editor.org/rfc/rfc9458.html>
- Discovery of Oblivious Services:
  <https://www.rfc-editor.org/rfc/rfc9540.html>
- Privacy Pass architecture and unlinkable authorization:
  <https://www.rfc-editor.org/rfc/rfc9576.html>
- QUIC transport:
  <https://www.rfc-editor.org/rfc/rfc9000.html>
- Proxying UDP in HTTP (MASQUE CONNECT-UDP):
  <https://www.rfc-editor.org/rfc/rfc9298.html>
- WebRTC security architecture and relay-only privacy:
  <https://www.rfc-editor.org/rfc/rfc8827.html>
