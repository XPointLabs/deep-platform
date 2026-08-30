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

1. `reality-xhttp-v1` (`0x0001`): Xray VLESS with REALITY and XHTTP or RAW/Vision as approved by
   the pinned runtime version. It provides the first masked TCP/443 carrier.
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

Carrier-specific `publicAuthenticationMaterial` is strictly typed. For
`reality-xhttp-v1` it contains the exact Reality public key, short ID, fingerprint,
flow, XHTTP/RAW mode, spider/path parameters, and pinned Xray compatibility range.
For HTTPS-stream/MASQUE it contains ALPN, path template, TLS policy, and gateway
public key where an inner authenticated upgrade is used.

`XCB1` lifetime is at most seven days. Endpoint changes, Reality key/short ID changes,
server-name changes, transport-mode changes, and SPKI changes require a successor
binding. An entry binding can use an onion key only within its signed epoch range; a
call-relay binding can issue or accept media allocations only within its relay-key
epoch. Target-kind substitution is a new binding and never an in-place update.

### 5.2 `XCC1` — public carrier policy

`XCC1` is referenced by hash from `XNV1` and contains:

```text
networkId16, policyGeneration:u64, predecessorHash32
minimumCarrierSecurityGeneration:u64
allowedCarrierIds and purposes
preference tiers, independentFailureFamily labels
parallelAttemptBudget and staggerMs
connect/probe/deadline/backoff parameters
traffic-shaping profile IDs
directFallbackPolicy = FORBIDDEN for MaskedRequired
emergency disabled binding/carrier hashes
bridgeDistributorKeySet and threshold
notBefore, expiresAt, authority/witness signatures
```

Policy validity is at most 30 days. A kill switch can disable a compromised carrier or
runtime, but cannot enable direct fallback or lower the minimum security generation.
A lower generation is rollback even if freshly signed by an ordinary witness; only a
new root-authority generation can authorize a clean-break reset.

### 5.3 `XBB1` — bridge bundle

A distributor returns a small cohort-specific bundle:

```text
networkId16
bundleId32, bundleGeneration:u64
distributionChannelId, cohortIdHash32
carrierPolicyHash32, minimumClientGeneration:u64
bindings[1..16] as canonical XCB1 or exact hashes plus objects
bundleNotBefore, bundleExpiresAt
previousBundleHash32 or zero for an independently anchored bundle
distributorSignatures[]
```

Bundle size is at most 128 KiB. Normal lifetime is 24 hours to seven days. It contains
enough bridges for at least two independent failure families but intentionally does
not reveal the complete pool. The cohort ID is random distribution state; it MUST NOT
be derived from an account key, device key, Deep ID, phone properties, advertising ID,
push token, IP address, or stable hardware identifier.

### 5.4 `XBA1` — bridge access token

Where scraping resistance is necessary, a binding references a one-use or bounded-use
bearer token:

```text
tokenType, issuerKeyId, carrierPolicyHash, bindingClass
notBefore, expiresAt, redemptionNonce, publicTokenBytes
```

Tokens are obtained before they are needed, cached encrypted, redeemed independently
of issuance, and cannot be linked to a Deep identity. Privacy Pass-compatible tokens
are preferred once an audited library is available. A plain random cohort token is
permitted in V1 but is assumed shareable/extractable and therefore short-lived.
Authentication failure produces plausible carrier-native behavior and no XPoint-
specific error oracle.

V1 token issuance is an exact RFC 9458 Oblivious HTTP request through the signed
relay/gateway pair. Plaintext request contains carrier-policy hash, binding class,
random cohort nonce and requested count `1..16`; it contains no Deep/account/device
identifier. Response contains canonical XBA1 tokens and expiry. A token is redeemed
only inside encrypted REALITY transport auth or XHC1, where the bridge atomically
stores `SHA256(tokenBytes)` until expiry. Lost-response retry reuses issuance
operation ID; redeemed token exact-replays only the same channel-hello hash. Privacy
Pass is a future token type and is not claimed by the random-bearer V1 profile.

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

The first binary WebSocket message is canonical `XHC1`:

```text
version, exactXCB1Hash32, accessTokenType:u16, LP16(accessToken)
clientNonce32, clientEphemeralX25519Public32, requestedPurpose:u16
requestedMaxFrame:u32, issuedAt:u64, zeroPadding
```

The server verifies cheap bounds/token first and responds with canonical `XHA1`:

```text
version, exactXCB1Hash32, clientNonce32, serverNonce32
gatewayEphemeralX25519Public32, acceptedPurpose:u16, maxFrame:u32
bindingGeneration:u64, expiresAt:u64, gatewayEd25519Signature64, zeroPadding
```

Both derive a channel key from ephemeral X25519, both nonces and exact XCB1 hash.
The signature domain is `Deep/Carrier/V1/https-stream-accept`; the gateway key is
in XCB1. Subsequent WebSocket binary messages each contain one complete XPoint
frame or one closed control record (`Ping`, `Pong`, `HalfClose`, `Close`), prefixed
by `streamId:u32 || sequence:u64 || kind:u16 || length:u32` and authenticated by
XChaCha20-Poly1305 under per-direction sequence keys. Maximum 32 streams, 1 MiB
frame, 8 MiB connection buffer and 64 outstanding frames. Sequence gap/reuse,
text frames, compression/extensions and unknown control kinds close with ordinary
WebSocket policy violation after bounded delay.

Unauthenticated paths render the maintained cover site; malformed/auth failures do
not return XPoint magic or stable timing oracle. This profile remains an experimental
anti-censorship carrier until active-probe/classifier review; successful transport
does not claim indistinguishability from generic web traffic.

## 9. MASQUE/real-time profile

`masque-h3-v1` is the exact RFC 9298 CONNECT-UDP profile over HTTP/3 with RFC 9297
Capsule Protocol negotiation and HTTP Datagrams. URI template, target host/port,
ALPN `h3`, max datagram and gateway authentication are exact XCB1 fields; arbitrary
targets and generic proxy use reject. The target is always the signed XPoint call
relay from `XCD1/XCB1`, never arbitrary Internet UDP. The bridge enforces exact target,
packet, bandwidth, amplification, allocation, and lifetime limits. Mailbox/control
traffic continues to use an entry-node binding and three onion layers; MASQUE call
media does not remove or replace that request path.

QUIC 0-RTT MUST be disabled for bridge-token redemption, call allocation, mailbox
mutation, and any non-idempotent control operation. Connection migration MAY preserve
a call across mobile network changes after path validation. The carrier exposes no
general VPN or open proxy API.

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

- golden/negative vectors for `XCB1/XCC1/XBB1/XBA1`;
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
| `deep-protocol` | carrier IDs, `XCB1/XCC1/XBB1/XBA1` codecs, bounds, signatures, lineage and vectors |
| `deep-registry-api` | byte-identical policy/bundle publication and distributor/witness APIs; no client route choice |
| `xnode` | authenticated bridge-to-entry and call-relay targets, quotas, target-key epochs and coarse errors |
| `deep-client-shared` | policy/LKG verification, supervisor state and transport-neutral failure/result types |
| `deep-client-maui` | pinned Xray and HTTPS/MASQUE adapters, protected subprocess lifecycle, network-change integration |
| `deep-devops` | independent carrier hosting lanes, bridge pools, OHTTP acquisition, rotation and capture harness |
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
