# XPoint Network V1

Status: normative implementation target for the first public Deep release.

Current ONION-01 state is narrower than this product target: the exact frozen
XRF1/XRL1/XRE1/XPR1/XRS1 codec and conformance seam are implemented, while the
production public API and every runtime consumer remain inactive. No three-hop
runtime or release-readiness claim follows from codec implementation alone.

This document defines the clean-break XPoint Network architecture. There are no
production users and no compatibility requirement with Session-derived identities,
the current DPE1 envelope, static bootstrap JSON, or an earlier XPoint deployment.
Implementations MUST NOT add legacy readers, dual-write paths, or silent fallback to
an older protocol. Exact machine bytes are frozen in the release specs before
runtime activation; implemented codecs and vectors do not authorize public API or
runtime composition without their package-specific activation gates.

The key words **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** are to
be interpreted as described by RFC 2119 and RFC 8174.

Within the network-transport scope, this target supersedes lower-level pre-production
runbooks or sprint text that requires a disjoint fallback from only three nodes,
static APK endpoints as the complete network, account-derived mailbox routing, direct
Registry call signaling, unmasked direct TURN, long-lived onion decryption keys, or
network-level exactly-once delivery. It does not supersede the approved Deep account,
device, ratchet, group, or application-event specifications.

## 1. Product contract

XPoint V1 provides one Internet transport profile for Deep:

- local offline account creation with no network dependency;
- arbitrary-contact bootstrap from a Deep ID, QR code, or invite;
- asynchronous 1:1 and closed-group messages (up to 100 members and five
  authorized devices per account in V1), configuration, reactions, receipts,
  and call signaling;
- encrypted attachments;
- one-to-one audio and video calls;
- exactly three independently encrypted XNode hops for every official XPoint
  application request, including call signaling and relay allocation;
- pluggable anti-censorship carriers between a client and its entry XNode;
- decentralized mailbox storage selected from a signed public node roster;
- no mandatory Google, Apple, Microsoft, DNS, Registry, push-provider, or single
  Deep-operated origin on the steady-state data path.

V1 starts with three production XNodes. Therefore it provides one three-hop route,
with alternate role permutations and alternate bridges, but **does not claim a fully
disjoint fallback route**. A disjoint primary/fallback claim requires at least six
eligible nodes in distinct failure domains and a later signed policy activation.

Direct P2P mesh and user-managed/on-premise deployments are later transport
profiles. The application crypto, message, group, attachment, outbox, deduplication,
and call-session contracts MUST remain transport-neutral so those profiles can be
added without changing account identity or application plaintext formats.

## 2. Security and availability claims

### 2.1 V1 claims

Subject to the threat boundaries below, XPoint V1 claims:

1. One hop does not receive both source and destination from the same onion
   transcript. The entry sees source/next hop and the exit sees a random blinded
   destination. Because launch nodes may also hold Mailbox/CallRelay roles,
   cross-role timing/volume correlation remains possible.
2. A mailbox/storage role does not receive sender source IP from the onion
   transcript; cross-role or global timing correlation is a non-claim.
3. A call peer does not learn the other peer's source IP in the default XPoint call
   profile; WebRTC uses relay-only candidates. The media relay still observes client
   network endpoints, time, and volume.
4. Application payloads remain end-to-end encrypted. XNodes, bridges, storage
   replicas, call relays, Registry, and push providers cannot decrypt them.
5. DNS blocking, SNI filtering, path blocking, UDP blocking, and blocking of known
   public XNode origins are handled by the carrier and bridge-distribution policy,
   within the tested censorship matrix in section 19.
6. Network metadata cannot silently roll back to an older verified generation or a
   weaker carrier/crypto policy.
7. If at least one signed acquisition channel remains reachable, a fresh supported
   client can obtain a current signed network view and usable bridge without a
   previous checkpoint. A returning client preserves
   its account, contacts, local history, and durable outbox across metadata rotation.

### 2.2 Non-claims

V1 does not claim protection against a global passive observer, traffic confirmation
by a sufficiently capable censor, compromise or collusion of all three launch nodes,
endpoint/device compromise, denial of service, or indefinite storage of messages.
Three initial nodes also do not justify a marketing claim of complete operational
decentralization. Claims MUST use the maturity levels in section 5.4.

The seven-day legacy DPE1 lifetime is removed by the clean break. Network retention
and user-selected disappearing-message lifetime are separate. Exact V1 mailbox
retention comes only from `RETENTION-AND-RECOVERY-V1.md`; an offline user can
reconnect after a supported metadata horizon but receives only messages whose
retention has not expired.

## 3. Lessons adopted from Session

XPoint deliberately adopts several proven Session patterns:

- a three-node onion route for client requests;
- deterministic assignment of recipient storage replicas from a common node view;
- replication inside a small recipient mailbox set, analogous to a Session swarm;
- durable client jobs, polling when push is absent, batching, connection reuse, and
  bounded retry;
- a small persistent entry-guard set rather than selecting a new entry for every
  request.

XPoint deliberately differs where Session's current design does not meet the product
goal:

- a carrier and bridge layer is separate from onion routing, because an enumerable
  onion network is still IP-blockable;
- all bootstrap and control operations needed for messaging use the same masked
  reachability policy;
- calls use a rotating masked relay catalog instead of exposing peers through direct
  ICE; real-time media is not sent through the three-hop request onion because that
  would violate the latency and bandwidth targets;
- account/device crypto follows the approved Deep clean-break ratchet specification,
  not a static long-term-key envelope;
- clients select routes locally from a signed global roster; no authority assigns a
  targeted per-user path.

Session's official documentation describes three-hop onion requests and recipient
swarms, and also notes that its TCP request protocol is unsuitable for responsive
voice/video. XPoint therefore keeps the simple request path for messaging and adds a
separate datagram-capable real-time plane.

## 4. Layering and transport seams

```text
Deep application objects
  -> device-scoped 1:1 ratchet / group epoch encryption
  -> durable logical operation and content-addressed attachment chunks
  -> transport profile
       official-xpoint-v1
         -> mailbox/blob/signaling request
         -> three encrypted XNode layers
         -> selected circumvention carrier to entry
         -> relay-only real-time media through a selected masked call carrier
       direct-mesh-v1 (future)
       user-managed-v1 (future)
```

The shared client layer MUST expose equivalent boundaries to:

```text
ITransportBindingProvider
IMessageDeliveryTransport
IAttachmentBlobTransport
ICallMediaPathProvider
IPushHintTransport
ITransportPathObserver
```

No interface accepts a Deep-operated hostname, PMA/Registry object, XNode type, or
carrier-specific credential. Profile-specific providers own those details. Logical
operation IDs, application message IDs, group epochs, attachment hashes, and call IDs
are stable across transport retries and transport-profile changes. Attempt IDs,
onion replay IDs, circuits, bridge credentials, and carrier sessions are not.

Push is an optional wake hint. Delivery MUST converge by authenticated polling after
foreground/resume or a bounded background opportunity when push is absent, blocked,
delayed, duplicated, or forged.

## 5. Roles and decentralization

### 5.1 Logical roles

An XNode can advertise one or more independently authorized roles:

| Role | Function |
| --- | --- |
| `Entry` | accepts client carrier sessions and opens onion layer 1 |
| `Relay` | forwards an opaque layer to another XNode |
| `Mailbox` | stores, retrieves, acknowledges, and replicates opaque mailbox objects |
| `Blob` | stores content-addressed encrypted attachment chunks |
| `CallRelay` | forwards opaque real-time packets and provides the WebRTC relay endpoint |
| `Bridge` | unlisted or cohort-listed client ingress; not inherently an XNode trust role |
| `DirectoryWitness` | signs/re-publishes deterministic network views and consistency proofs |

Roles use separate keys and quotas. A node identity key MUST NOT be used for onion
traffic encryption, carrier authentication, mailbox authorization, or TLS.

### 5.2 Data ownership

- Node eligibility and operator identity derive from finalized XPoint staking state.
- The Registry is an indexer, publisher, and liveness collector, not the sole source of
  truth. A client can obtain identical signed artifacts from any witness, XNode,
  bundled cache, or mirror.
- Each user mailbox is assigned a replica set by deterministic rendezvous hashing over
  a verified network view. The publisher cannot target a user with a chosen replica.
- V1 uses two mailbox replicas because only three nodes exist. At six eligible nodes,
  policy SHOULD move to three replicas after storage and migration evidence passes.
- Replicas accept only opaque, recipient-authorized objects and reconcile by immutable
  object ID plus tombstone/ack state. They never perform application decryption.

### 5.3 Failure-domain labels

Every active node descriptor MUST contain signed, operator-attested labels:

```text
operatorId, physicalHostId, providerId, asn, ipv4Prefix24, ipv6Prefix48,
countryCode, regionCode
```

The directory pipeline verifies objective labels where possible and records the
evidence source. False labels are slashable/administratively revocable. Route
selection MUST avoid the same `physicalHostId`; it SHOULD avoid the same operator,
provider, ASN, IP prefix, and country in that order when the roster permits.

For the three-node launch, all three nodes MUST be on distinct physical hosts and IP
prefixes, and SHOULD span at least two providers, ASNs, and regions. Shared operator
ownership is permitted only under the explicit launch maturity level below.

### 5.4 Network maturity levels

| Level | Minimum condition | Permitted claim |
| --- | --- | --- |
| `D0 Bootstrap` | three physical XNodes; one legal operator allowed, but witness keys/processes/access credentials isolated on separately audited hosts | production bootstrap network; not operationally decentralized and no protection from compromise/coercion of the bootstrap operator |
| `D1 Diverse hosting` | three nodes across >=2 providers/ASNs/regions | provider-failure diversity |
| `D2 Independent` | >=6 nodes, >=3 unrelated operators, no operator >1/3 selection weight | decentralized XPoint Network |
| `D3 Resilient` | >=12 nodes, measured geographic/provider diversity, public witness log | decentralized network with disjoint-route capability |

Marketing and UI MUST use the current signed maturity level and MUST NOT infer a
higher level from node count alone.

Public GA at D0 still requires three independently generated witness keys, no
shared online signing secret, separate host/service credentials and an auditable
2-of-3 ceremony log. One operator may administer those boundaries, so this is
fault isolation rather than operator independence. A build that lets one process,
credential or hot key issue two witness signatures is UAT-only and cannot support
freshness/transparency claims.

### 5.5 Three-node launch availability

With exactly three active routing nodes, loss of any one node makes an exact-three-hop
route impossible. The client MUST queue operations and report `XPointUnavailable`; it
MUST NOT skip a hop or use direct managed ingress. The two remaining 2-of-3 witnesses
can publish a deterministic successor view that activates an eligible replacement.
The operational objective is replacement-view publication within 60 minutes after a
replacement has valid stake/admission, keys, descriptors, and health evidence. This
is an operational recovery target, not continuous single-node-failure tolerance.

At least one encrypted mailbox replica should remain when one of two replicas fails.
After replacement, normal placement handover/read repair restores the second replica
before the failed node can be removed from retained history.

## 6. Cryptographic key separation and epochs

Each XNode has independently generated keys:

- long-lived Ed25519 node identity key;
- long-lived BLS staking/quorum key where required by membership;
- X25519 onion traffic keys, rotated by epoch;
- carrier-specific Reality/VLESS or HTTPS authentication material;
- TLS keys/certificates;
- mailbox holder/storage authorization keys;
- call-relay credential-signing key.

Ed25519-to-X25519 conversion is forbidden. The onion traffic key epoch is at most
24 hours, with current and next public keys published in advance and a maximum
two-hour receive overlap. Retired private traffic keys MUST be securely erased after
the overlap and restart recovery window. Captured old onion frames then cannot be
opened after old epoch keys are destroyed, although no software-only deletion claim
survives host compromise before deletion.

Long-lived keys sign short-lived keys but never decrypt user traffic. Every signed
artifact binds `networkId`, semantic version, generation, issued/not-before/expires,
predecessor hash, and minimum reader version. Unknown algorithms, fields, role bits,
versions, non-canonical encodings, or nonzero reserved values fail closed.

## 7. Signed network artifacts

The first NETCODEC trust/view slice is frozen by
[`xpoint-network-v1.registry.json`](../survival-program/releases/v3.0.0/specs/xpoint-network-v1.registry.json),
its closed Draft 2020-12 schema and the adjacent deterministic vector-manifest
skeleton. It covers `XNA1/XVP1/XND1/XNV1/XNH1/XNP1/XNF1/NFP1/XCD1` only and
is `FROZEN_TARGET_NOT_ACTIVE`: it defines bytes but does not claim a runtime.

Exact encodings use the repository's canonical bounded binary-record rules. The
semantic records below are normative. All hashes are SHA-256 over exact canonical
bytes. Signatures use domain-separated inputs.

An `ArtifactRef38` is exactly `magicAscii4 || version:u16be ||
SHA256(exactCanonicalRecord)`. A `CoreRef38` is `magicAscii4 || version:u16be ||
recordSpecificDomainSeparatedCoreHash32`. Typed magic and version are verified;
the two ref classes are never interchanged. Key IDs are looked up only in the exact
authority record and key generation named by the signed object; no "current key"
lookup is allowed. Proof packages reference separately supplied verified records by
typed core ref instead of embedding arbitrarily large records; this keeps every
record below 65,535 bytes and prevents receipt-subset and hash cycles.

V1 root and directory-witness entries have no independent wall-clock validity
window. A key is temporally admissible only when its exact `(id,keyGeneration,key)`
entry belongs to the exact referenced XNA1 whose effective interval covers the
object's required issuance/effective interval. A Registry/current-key lookup,
generation substitution, or a key from an expired/future XNA1 rejects even when the
signature is otherwise valid. XND1 role and origin/onion keys are admissible only
through the exact descriptor whose interval covers the consuming XNV1 interval.

### 7.1 `XNA1` — network authority

`XNA1` is pinned in the application release and independently available from signed
out-of-band recovery packages. It is never derived from or authorized by a user's
Deep Recovery Phrase. Version 1, root suite `0x0001`, has exact tags:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | authority generation | `u64` |
| 3 | predecessor XNA authority-core hash | 32; zero only at generation 0 |
| 4 | root-key count | `u8`, `1..8` |
| 5 | sorted root-key entries | exactly `72 * tag4` bytes |
| 6 | root threshold | `u8`, `1..tag4` |
| 7 | directory-witness policy generation | `u64` |
| 8 | witness-ID derivation profile | `u16`; exactly `1=ExplicitRandomId` |
| 9 | witness count | `u8`, `3..32` |
| 10 | sorted witness entries | exactly `104 * tag9` bytes |
| 11 | witness threshold | `u8`, `2..tag9` |
| 12 | exact DTS1PolicyCoreRef38 | 38; stable unsigned policy-core reference |
| 13 | time-source policy hash | 32; exact DTS1-derived value |
| 14 | maximum witness uncertainty seconds | `u32`; `1..30` and no greater than DTS1 tag 8 |
| 15 | minimum client generation | `u64` |
| 16 | issued-at | `u64` |
| 17 | not-before | `u64` |
| 18 | expires-at | `u64`; `tag17 < tag18 <= tag17+34560000` |
| 19 | root-signature count | `u8`, wire range `1..8`; lifecycle selects the authorizing threshold/count |
| 20 | sorted root-key ID/signature entries | exactly `96 * tag19` bytes |

A root-key entry is `rootKeyId32 || keyGeneration:u64 ||
Ed25519PublicKey32`; a witness entry is `witnessId32 || keyGeneration:u64 ||
Ed25519PublicKey32 || failureDomainHash32`. Each list sorts by its ID, and IDs,
public keys and nonzero failure-domain hashes required for one threshold are
distinct. For generation 0 every key generation is zero and the release pins the
exact XNA authority core. A successor increments tag 2, names the predecessor core
in tag 3 and is signed by at least the threshold of predecessor root keys; later objects that
name this XNA1 resolve IDs only against its tag-5/tag-10 entries and exact key
generations.

Tag 19 is structurally decoded as `1..8` before any resolver or signature callback.
For genesis it must additionally satisfy current `tag6 <= tag19 <= tag4`, and tag 20
resolves only current tag-5 entries. For a successor, the signatures authorize the
transition and therefore instead satisfy the accepted predecessor's root
threshold/count and resolve only predecessor entries; successor tags 4..6 never
authorize themselves. Consequently a `1-of-1 -> 2-of-3` rotation carries one valid
predecessor receipt, while a `5-of-8 -> 1-of-1` rotation still carries at least five.
Applying the new threshold early or the old threshold after acceptance rejects.

The directory-witness policy is the canonical encoding of XNA1 tags 7..14.
`directoryWitnessPolicyHash32 = SHA256-D("Deep/XPoint/V1/directory-witness-policy",
exactXNA1Tags7Through14)`. ADH1, XNV1, XNH1 and DTT1 carry the exact XNA
authority-core ref plus this hash. Their `(witnessId,keyGeneration)` pairs must resolve
to tag 10 and meet tag 11 with distinct failure domains. DTS1 tag 13 must equal
XNA1 tag 2; XNA1 tag 13 must equal the DTS1 derivation defined by the account
directory specification.

The launch authority may use one offline root operationally, but public GA requires
at least 2-of-3 offline root keys stored under separate custody. Root keys sign only
authority succession, XVP1 network policy, emergency revocation, DTS1
authenticated-time-source policy and a fresh-install checkpoint; they do not sign per-user routes, messages, or
ordinary node heartbeats. Each tag-20 entry
signs `SIGINPUT("Deep/XPoint/V1/XNA1/root", 0x0001, unsignedXNA1 tags
1..18)`; generation 0 self-signatures are checked in addition to the release pin,
while a successor uses the predecessor key set and threshold.

`XNAAuthorityCoreHash32 = SHA256-D("Deep/XPoint/V1/XNA1/authority-core",
exact unsigned tags 1..18)` and `XNAAuthorityCoreRef38 = ASCII("XNA1") ||
U16BE(1) || XNAAuthorityCoreHash32`. Tag 3 and every authorizing-XNA field use
this stable core, never a full root-signature envelope. Valid receipt subsets may
aggregate by root-key ID; different unsigned bytes at one authority generation are
a fork.

### 7.2 `XND1` — node descriptor

`XND1`, version 1, suite `0x0201`, has 37 exact tags and total size
`1,025..3,409` bytes:

| Tags | Value | Size / rule |
|---:|---|---|
| 1..5 | network ID, node ID, generation, predecessor core hash, node-identity Ed25519 key | `16,32,u64,32,32`; IDs/keys nonzero; predecessor zero iff generation 0 |
| 6..12 | staking-identity hash, operator/host/provider IDs, ASN, jurisdiction, derived failure-domain hash | `32,32,32,32,u32,u16,32`; only ASN/jurisdiction may be zero |
| 13..18 | role mask and Entry/Relay/Mailbox/Blob/CallRelay capacities | `u16,u32,u64,u64,u64,u32`; each capacity nonzero iff its role bit is set |
| 19..20 | peer-origin count and sorted entries | `u8 1..16`; exactly `148*count` bytes |
| 21..28 | current/next onion epochs, X25519 keys and validity windows | `u64,32,u64,u64` twice; next epoch=current+1, keys differ, each lifetime <=24 h, no handover gap |
| 29..30 | minimum/maximum protocol generation | `u16,u16`; both nonzero and min<=max |
| 31..32 | role-key count and sorted role-key entries | `u8 1..5`; exactly `41*count`; one entry per enabled role |
| 33..36 | issued, not-before, expires, minimum reader | `u64,u64,u64,u16`; descriptor lifetime <=7 d |
| 37 | node-identity signature | 64 |

An origin entry is `originId32 || transport:u8 || addressFamily:u8 || address16 ||
port:u16 || currentSpkiSha25632 || currentNotBefore:u64 || currentExpires:u64 ||
nextSpkiSha25632 || nextNotBefore:u64 || nextExpires:u64`. Transport is TCP-TLS or
QUIC-TLS; family is IPv4 or IPv6, with IPv4 followed by twelve zero octets. A role
key entry is `roleId:u8 || keyGeneration:u64 || Ed25519PublicKey32`.

`failureDomainHash32 = SHA256-D("Deep/XPoint/V1/XND1/failure-domain",
networkId16 || operatorId32 || hostId32 || providerId32 || asn:u32 ||
jurisdiction:u16)`. Tag 37 signs canonical tags 1..36 under
`Deep/XPoint/V1/XND1`; the same projection defines `XNDCoreHash32` under the
`/core` domain. A successor keeps network/node/identity/staking identity fixed,
increments generation exactly and names the predecessor core. Heartbeat/liveness is
not embedded, so a missing Registry cannot rewrite identity state.

### 7.3 `XVP1` / `XNV1` — network policy and view

`XVP1`, version 1, root suite `0x0001`, is the sole policy preimage accepted by
XNV1. It has exact tags:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | policy generation | `u64` |
| 3 | predecessor XVP policy-core hash | 32; zero only at generation 0 |
| 4 | enabled role mask | `u16`; bits 0 Entry, 1 Relay, 2 Mailbox, 3 Blob, 4 CallRelay; all five required in V1 |
| 5 | required onion hop count | `u8`; exactly 3 |
| 6 | mailbox replica count | `u8`; exactly 2 at D0, `2..5` later |
| 7 | route-constraint mask | `u16`; distinct node/host/onion-key/origin bits mandatory; operator/provider/ASN bits capability-gated |
| 8 | maximum entry-guard candidates | `u8`; exactly 3 |
| 9 | minimum confirmed-guard retention seconds | `u32`; exactly 2592000 |
| 10 | maximum circuit lifetime seconds | `u16`; `60..3600` |
| 11 | mailbox-projection profile | `u16`; exactly `1=RendezvousPmt2V1` |
| 12 | required PMT2 generation | `u64` |
| 13 | exact XCCCoreRef38 | 38; stable XCC1 unsigned-core reference |
| 14 | minimum active carrier-binding count | `u16`, `1..512` |
| 15 | issued-at | `u64` |
| 16 | not-before | `u64` |
| 17 | expires-at | `u64`; `notBefore < expiresAt <= notBefore+2592000` |
| 18 | authorizing XNAAuthorityCoreRef38 | 38; stable authority-core reference |
| 19 | root-signature count | `u8`; XNA1 root threshold..root-key count |
| 20 | sorted root-key ID/signature entries | exactly `96 * tag19` bytes |

Every root entry signs `SIGINPUT("Deep/XPoint/V1/XVP1/root", 0x0001,
unsignedXVP1 tags 1..18)` and resolves only through tag 18. A successor increments
generation, names the exact predecessor and cannot silently relax a mandatory bit or
reduce a minimum without a new root-signed policy generation. ROOT-CHECKPOINT-01
authors XVP1 offline; DIRECTORY-01 publishes the exact bytes. There are no external
role/selection/circuit policy hash preimages. Product retention values are not a
mutable network-view policy: their sole source is
`RETENTION-AND-RECOVERY-V1.md`, and an XVP1/XNV1 cannot shorten an already accepted
object's signed deadline.

The exact tag-18 XNA1 must be effective when XVP1 is issued and must cover the
complete XVP1 effective interval. Receipt IDs and key generations resolve only in
that XNA1. For a successor, the accepted predecessor policy generation must be less
than `UINT64_MAX`, tag 2 is checked `predecessor+1`, and tag 3 equals the accepted
predecessor policy-core hash; overflow or any alternate nonzero predecessor rejects.

`XVPPolicyCoreHash32 = SHA256-D("Deep/XPoint/V1/XVP1/policy-core", exact
unsigned tags 1..18)` and `XVPPolicyCoreRef38 = ASCII("XVP1") || U16BE(1) ||
XVPPolicyCoreHash32`. Tag 3 and XNV linkage use this core, never the complete
signature envelope. Different valid root-receipt subsets over one core may aggregate
by key ID and do not create another policy; different unsigned bytes at one policy
generation are a fork.

`XNV1`, version 1, suite `0x0201`, is the canonical globally shared roster
candidate with exact tags. This slice freezes its bounded bytes and verification
closure, but deliberately does not claim deterministic membership completeness:
runtime activation remains blocked until an exact typed finalized-staking projection
contract and its no-omission vectors are frozen.

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | view generation | `u64` |
| 3 | predecessor XNV1 hash | 32; zero only at generation 0 |
| 4 | finalized chain ID | 32 |
| 5 | finalized block height | `u64` |
| 6 | finalized block hash | 32 |
| 7 | authorizing XNAAuthorityCoreRef38 | 38; stable authority-core reference |
| 8 | directory-witness policy hash | 32; exact XNA1 derivation |
| 9 | exact active XVPPolicyCoreRef38 | 38; stable unsigned-core reference |
| 10 | maturity level | `u16`: `1=D0`, `2=D1`, `3=D2` |
| 11 | node-descriptor count | `u16`, `3..512` |
| 12 | sorted exact XND1 ArtifactRefs | exactly `38 * tag11` bytes |
| 13 | revoked-node count | `u16`, `0..512` |
| 14 | sorted revoked node IDs | exactly `32 * tag13` bytes |
| 15 | service-descriptor count | `u16`, `0..128` |
| 16 | sorted service CoreRef38 values | exactly `38 * tag15` bytes; only XCD1/XOD1 |
| 17 | carrier-binding count | `u16`, `1..512` |
| 18 | sorted XCB1 ArtifactRef38 values | exactly `38 * tag17` bytes |
| 19 | issued-at | `u64` |
| 20 | not-before | `u64` |
| 21 | expires-at | `u64`; `notBefore < expiresAt <= notBefore+86400` |
| 22 | minimum reader | `u16` |
| 23 | witness count | `u8`; at least exact XNA1 threshold |
| 24 | sorted witness ID/signature entries | exactly `96 * tag23` bytes |

Tag 9 resolves a threshold-complete XVP1 envelope with that exact core. XVP1 tag 18
must equal XNV1 tag 7; it must be current at XNV1 tag 20 and its XCC1,
PMT2-generation rule, role mask, hop/replica/route/guard/circuit limits and minimum
carrier count are applied exactly when deriving the view. XND1 refs sort by the resolved XND1 node ID and have distinct node IDs/hashes.
Revoked IDs are distinct and sorted. Service refs sort by `(magic,coreHash)` with no
duplicate. XCB1 artifact refs sort bytewise and every binding target
resolves to an XND1/XCD1 core committed by tags 12/16. Invalid or unresolved
XVP1/XCC1 policy, unresolved reference or omitted referenced descriptor rejects the
complete view.

Each tag-24 entry is `witnessId32 || signature64` and signs
`SIGINPUT("Deep/XPoint/V1/XNV1", 0x0201, unsignedXNV1 tags 1..22)`.
Tag 7 resolves the sole witness ID/key-generation/failure-domain set; tag 8 must
equal its exact XNA1 tags-7..14 policy hash, and the distinct valid receipts must
meet XNA1 tag 11. No Registry-selected/current key lookup is valid.

`XNVCoreHash32 = SHA256-D("Deep/XPoint/V1/XNV1/core", exact unsigned tags
1..22)`. XNV1 tag 3 and every field named `XNV1 hash` in this specification use
this core hash; an `XNV1 ArtifactRef` alone hashes one complete threshold envelope.
`XNVCoreRef38` is exactly `ASCII("XNV1") || U16BE(1) || XNVCoreHash32`; it is
explicitly a stable core reference, not an ArtifactRef to a receipt envelope.
Different valid receipt subsets over the identical core are receipt aggregation,
not a successor or fork. They may be unioned by witness ID, while a threshold-complete
envelope remains valid. Different unsigned bytes at one view generation are a fork.

The view is valid for at most 24 hours and SHOULD be republished every six hours.
Before activation, validators check only the exact bounded structural closure in the
machine registry and MUST NOT infer that every staking-eligible node was included.
After `deterministicMembershipProjectionFrozen=true`, its content must be derived by
that exact typed contract from finalized membership, valid descriptors, revocations,
and the previous view; omission/eligibility claims require the independent activation
corpus. Witness threshold is 2-of-3 at D0 so one failed
witness cannot freeze publication; after six independent nodes it becomes
`ceil(2N/3)` with an authority-signed policy. Same-generation equivocation by any
witness is public slash/revocation evidence.
An emergency root checkpoint can recover liveness but increments the authority and
view generations and is publicly distinguishable.

Clients accept only genesis anchored by `XNA1`, the exact next generation and parent
hash, or exact XNF1/NFP1 forward proof from their last-known-good view.
Same-generation different-hash is a fork and blocks network mutation until resolved
by a newer XNF1/NFP1 checkpoint. An expired view
MAY be used for read-only recovery for 72 hours, but MUST NOT authorize new nodes,
keys, routes, bridge credentials, or mailbox mutations.

### 7.3.1 `XNH1` / `XNP1` — network transparency

Every exact XNV1 hash is appended as
`SHA256(0x00 || U64BE(viewGeneration) || previousViewHash32 || XNV1Hash32)` to
an RFC-6962 binary Merkle log whose inner nodes are
`SHA256(0x01 || left32 || right32)`. `XNH1`, version 1, suite `0x0201`, has exact
tags:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | log generation | `u64` |
| 3 | predecessor XNH1 hash | 32; zero only at generation 0 |
| 4 | tree size | `u64` |
| 5 | RFC-6962 root | 32 |
| 6 | latest XNVCoreRef38 | 38; stable unsigned-core reference defined above |
| 7 | latest XNV1 generation | `u64`; exact resolved tag 2 |
| 8 | authorizing XNAAuthorityCoreRef38 | 38; exactly resolved XNV1 tag 7 |
| 9 | directory-witness policy hash | 32; exactly resolved XNV1 tag 8 |
| 10 | valid-from | `u64` |
| 11 | valid-until | `u64`; `validFrom < validUntil <= validFrom+86400` |
| 12 | minimum reader | `u16` |
| 13 | predecessor consistency-node count | `u8`, `0..64` |
| 14 | RFC-6962 consistency nodes | exactly `32 * tag13` bytes |
| 15 | witness count | `u8`; at least exact XNA1 threshold |
| 16 | sorted witness ID/signature entries | exactly `96 * tag15` bytes |

Each tag-16 entry signs
`SIGINPUT("Deep/XPoint/V1/XNH1", 0x0201, unsignedXNH1 tags 1..14)`.
Witness IDs, key generations, keys, threshold and failure domains resolve only
through tag 8 XNA1; tag 9 must equal that authority's exact policy hash. Tag 6
resolves any threshold-complete XNV1 envelope with that exact core; receipt-subset
changes cannot change XNH core. The latest XNV1 leaf must be present at index
`tag4-1` in tag-5 root; tree size zero rejects.

`XNHCoreHash32 = SHA256-D("Deep/XPoint/V1/XNH1/core", exact unsigned tags
1..14)` and `XNHCoreRef38 = ASCII("XNH1") || U16BE(1) || XNHCoreHash32`.
XNH1 tag 3 and every field named `XNH1 hash` use this core hash; receipt
aggregation over one core follows the same rule as XNV1 and does not create another
head generation.

Genesis has XNV1/XNH1 generation zero, XNH1 tag 3 `ZERO32`, tree size exactly one,
latest XNV generation zero and zero consistency nodes. Every successor increments
XNH1 generation and tree size by exactly one, tag 3 equals predecessor XNH core,
latest XNV generation increments by one, and that XNV tag 3 equals the predecessor
latest-XNV core. Its one new leaf is at index `tag4-1`; tags 13/14 verify the
mandatory RFC-6962 consistency proof from predecessor `(treeSize,root)` to tags
4/5. A same-size publication, generation/view gap, changed predecessor root,
absent/extra proof, a second appended leaf or latest-XNV leaf outside that one-item
suffix rejects before witness signing. Re-signing the same core may add valid
receipts but never changes generation, tree size, root or predecessor.

XNH1 commits XNV1 one-way. XNV1 never contains an XNH1 hash or log position;
XNP1 supplies later inclusion/consistency. A candidate pair with either reciprocal
hash is non-canonical and rejects, preventing an uncomputable hash cycle.

`XNP1`, version 1, suite `0x0201`, has exact tags:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16, nonzero |
| 2..6 | source XNHCoreRef38, tree size/root, latest XNVCoreRef38/generation | `38,u64,32,38,u64` |
| 7..11 | target XNHCoreRef38, tree size/root, XNVCoreRef38/generation | `38,u64,32,38,u64` |
| 12 | proof algorithm | `u16`, exactly 1=RFC6962-SHA256-V1 |
| 13 | target leaf index | `u64`, exactly target tree size minus one |
| 14..15 | inclusion count/nodes | `u8 0..64`, exactly `32*count` |
| 16..17 | consistency count/nodes | `u8 0..64`, exactly `32*count` |

The source tuple exactly equals protected LKG. Typed refs resolve separately supplied
threshold-complete records; XNP1 never embeds XNV/XNH bytes. Proof lists are minimal
and ordered; identical source/target requires both lists empty. No pagination or
source-supplied alternate algorithm is valid. Fresh install
verifies inclusion from the release-manifest-pinned XNA1/XNV1/XNH1 checkpoint and the nonce-bound DTT1 current
head/time attestation; XNH/XNV validity windows never prove their own freshness.
Returning clients require
consistency from protected LKG. Clients gossip `(treeSize, root, latestViewHash)`;
two roots for one size produce portable split-view evidence and block mutation.

### 7.3.2 `XNF1` / `NFP1` — beyond-horizon network forward checkpoint

`XNF1`, version 1, root suite `0x0001`, is the only way to cross a compacted
network-view history gap:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | checkpoint generation | `u64` |
| 3 | predecessor XNF1 core hash | 32; zero only at generation 0 |
| 4 | covered first/last XNV generation | `u64 || u64` |
| 5 | covered-head count | `u64`, `1..65536`; equals the inclusive tag-4 range |
| 6 | covered-head Merkle root | 32 |
| 7 | exact target XNVCoreRef38 | 38 |
| 8 | target XNV1 generation/hash | `u64 || 32` |
| 9 | exact target XNHCoreRef38 | 38 |
| 10 | target XNH tree size/root | `u64 || 32` |
| 11 | exact authority XNAAuthorityCoreRef38 | 38 |
| 12 | issued-at | `u64` |
| 13 | minimum reader | `u16` |
| 14 | root-signature count | `u8`; XNA root threshold..root-key count |
| 15 | sorted root-key ID/signature entries | exactly `96 * tag14` bytes |

The covered tree uses RFC-6962 leaves
`SHA256(0x00 || XNVGeneration:u64be || XNVHash32 || XNHTreeSize:u64be ||
XNHRoot32)`. It contains exactly one accepted canonical `(XNV,XNH)` tuple for every
generation in the inclusive tag-4 range, ordered by strictly consecutive XNV
generation; alternate same-generation heads are fork evidence, not additional
leaves. Checked arithmetic requires
`tag5 = lastGeneration - firstGeneration + 1` without underflow or overflow. Root keys resolve only through
tag 11 authority lineage and sign identical unsigned tags 1..13 with
`SIGINPUT("Deep/XPoint/V1/XNF1/root", 0x0001, unsignedXNF1)`.
`XNF1CoreHash32 = SHA256-D("Deep/XPoint/V1/XNF1/core", exact unsigned tags
1..13)`; tag 3 and NFP predecessor verification use this core. Root receipts may
aggregate without changing checkpoint identity.
For every XNF1, tag 11 MUST equal the authorizing XNA authority-core ref in its exact
target XNV1 tag 7 and target XNH1 tag 8; all three policy hashes must agree. Thus
the last checkpoint authority also authenticates the target heads.

`NFP1`, version 1, suite `0x0201`, is the bounded typed-ref proof manifest. Exact
records are supplied separately and keyed by these refs; NFP1 never nests arbitrary
canonical records:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | source XNV generation | `u64` |
| 3 | source XNVCoreRef38 | 38 |
| 4 | source XNH tree size | `u64` |
| 5 | source XNH root | 32 |
| 6 | source leaf index | `u64` |
| 7 | target XNVCoreRef38 | 38 |
| 8 | target XNHCoreRef38 | 38 |
| 9 | XNA1 authority-chain count | `u8`, `1..64` |
| 10 | ordered XNA1 authority CoreRef38 chain | exactly `38 * tag9` |
| 11 | XNF1 count | `u8`, `1..64` |
| 12 | ordered predecessor-linked XNF1 CoreRef38 chain | exactly `38 * tag11` |
| 13 | source-membership node count | `u8`, `0..64` |
| 14 | RFC-6962 membership nodes | exactly `32 * tag13` bytes |
| 15 | exact live DTT1CoreRef38 | 38; freshness-authenticates target tag 7; target tag 8 is closed separately through that XNV1 |
| 16 | proof algorithm | `u16`, exactly 1=RFC6962-SHA256-V1 |

The source tuple `(tag2,tag3,tag4,tag5)` exactly equals protected LKG and its
canonical leaf is the leaf formula above. For the first applicable XNF1, checked
arithmetic must establish
`firstGeneration <= tag2 <= lastGeneration` and
`tag6 = tag2 - firstGeneration < coveredHeadCount`; underflow, overflow or any other
in-range index rejects. Tags 13/14 are verified with both that exact index and count
against the XNF1 tag-6 root. The target records equal the last XNF1 tags 7..10. The
authority chain begins at protected XNA1 and continues through the authority
referenced by the last XNF1; it contains, in successor order, every XNA authority
core referenced by tag 11 of any XNF1 carried in NFP1 tag 12, including the
target-head authority equality above, and no
unused authority record. Each checkpoint signature
resolves against its own tag-11 XNA1 key IDs/generations. Every list is
count-prefixed, bounded as above and hash-closed. Same-generation changed XNF1, two
successors, omitted source tuple, wrong leaf index/count, target mismatch or
authority gap, missing checkpoint authority or extra authority record fork-latches
recovery.

The target XNV generation must be strictly greater than source tag 2. Tag 15
resolves a fresh nonce-bound DTT1 whose authenticated current XNV core/generation
equals target tag 7. Target tag 8 resolves an XNH1 whose latest XNV is that same
target, and the authenticated DTT1 time interval intersects that XNH1
`[validFrom,validUntil]`. DTT1 does not directly name XNH1, so all three equality and
interval checks are mandatory; a fresh attestation for another valid XNV/XNH pair
rejects.

After complete validation the client atomically retains its old LKG as evidence,
advances to the strictly newer target XNV/XNH and resumes ordinary XNP1 successor
verification. XNF/NFP restores current network trust only; it does not recreate
expired mailbox/content. Root-authority tooling authors XNF1 offline, DIRECTORY-01
publishes byte-identical checkpoint/proof material, and ROUTE-01 verifies/merges it.

### 7.4 `XRR1` — contact-scoped reachability record

Permanent transport-neutral `DID1` and expiring one-time `DIA1`, defined by the
contact/group specification, are the only V1 human-facing bootstrap inputs.
They resolve canonical DCR1/DCB1 closure carrying account/device certificates,
prekey-service descriptors and exact XPoint reachability. A stable
`DeepAccountId` and DID1 bytes are never used directly as an XPoint mailbox key;
the adapter uses the domain-separated opaque locator.

The exact tagged grammar, field bounds, signature/core projections and binary
closure order for `XRR1`, `XRA1`, `XRC1`, `XSS1`, `PMT2` and `PMS2` are owned
once by [CONTACT-RESOLVER-V1 §3.6](CONTACT-RESOLVER-V1.md#36-exact-route-and-mailbox-closure).
This document imports those exact canonical bytes; prose in this section does
not define a second route codec.

`randomRendezvousId32`, blinded placement value, and deposit capabilities are generated by a
CSPRNG and are not derived from account, device, recovery, conversation, or mailbox
keys. XNodes route and store the opaque rendezvous record without receiving the Deep
account ID. A single-use or bounded-use record is preferred; public-address records
have lower quotas and stronger abuse controls.

XRA1 authorizes the directory threshold to refresh only the named
network-dependent XRC1 fields while the recipient is offline; it cannot change
recipient-device closure, operation class, quota, random placement scope or
the XRA1 core. Resolution returns exactly ordered
`XRR1,XRA1,XRC1,XSS1,PMT2,PMS2` canonical bytes and rejects every pre-cutover
PRA/PSS/RCD/RCA record before routing. The deposit service receives only random
capabilities selected from that closure, never DID1/account/device/DCR plaintext.

After contact acceptance, XPoint hosts the opaque established-contact update
service defined exclusively in
[`CONTACT-RESOLVER-V1.md`](CONTACT-RESOLVER-V1.md#35-established-contact-update-service-xur1--xuw1--xuq1--xus1).
Its application/contact state machine remains owned by
[`CONTACT-AND-GROUP-PROTOCOL-V1.md`](CONTACT-AND-GROUP-PROTOCOL-V1.md#7-contact-state-and-identifiers).
The XPoint-specific consequence is only that XUR placement is PMT2/PMS2-bound,
uses the same two-replica CAS/repair plane and never creates a globally
enumerable account-to-mailbox mapping. This document does not define a second
XUR codec, retention value or contact state machine.

### 7.5 `XCP1` — client path plan

`XCP1` is local protected state, not a publisher-selected route. It binds:

```text
networkViewHash, PMT2Hash, PMS2Hash, recipientReachabilityHash, operationClass
entryNodeId, middleNodeId, exitNodeId
selectedBridgeDescriptorHash, carrierId
onionTrafficKeyEpochs, createdAt, softExpiresAt, hardExpiresAt
```

It is never uploaded. Diagnostic export includes only run-scoped keyed hashes, role
counts, and coarse latency buckets.

## 8. Bootstrap and network-view state machine

```text
NoView
  -> BundledCheckpoint       release-manifest-pinned XNA1/XNV1/XNH1 is valid
  -> FetchingCurrent         fetch through any usable bridge/source
  -> Current                 exact verified live successor committed atomically
  -> RefreshDue              refresh margin or resume/network change
  -> Current                 verified successor or identical live view
  -> StaleReadOnly           view expired, <=72h grace; no mutation authorization
  -> RecoveryRequired        grace exceeded or history gap
  -> Current                 root checkpoint + consistency proof + live view

Any state -> ForkBlocked      same generation/different hash or invalid predecessor
ForkBlocked -> Current        only newer root-authorized resolution
```

Account creation never enters this state machine and never waits for network I/O.
Network initialization runs after local account commit. Failures expose a precise
offline/network status and keep local UI/history usable.

Fresh-install sources are attempted concurrently with bounded stagger:

1. unexpired embedded bridge bundles;
2. current carrier-distribution channels;
3. user-imported QR/file bundle;
4. direct public witness HTTPS only when the signed policy permits it and the user is
   not in `MaskedRequired` mode.

A first successful object is not trusted by source. It is trusted only after complete
signature, predecessor/checkpoint, network and minimum-reader verification plus a
fresh nonce-bound DTT1 linking the current ADH1/XNV1. Cached artifact windows are
validity bounds, not a current-time source.

The V1 control-plane partition horizon is exactly the 72-hour `StaleReadOnly`
grace after the last verified XNV1 expires. During that horizon, the client may use
its protected LKG only to reach previously authenticated entry/witness/acquisition
targets and fetch a live successor; it cannot authorize mailbox/contact/group/call
mutation from stale state. After the horizon it enters `RecoveryRequired` and needs a
reachable signed acquisition/import path. Therefore V1 claims bounded bootstrap
recovery under update-channel blocking, not continued messaging when every current
control-plane path is withheld.

## 9. Mailbox placement and storage swarms

Production generation 1 uses clean-break `PMA2/PMT2/PMS2` records. It ports the
reviewed deterministic `Rendezvous-SHA256-v2` placement algorithm but rejects
pre-cutover `PMA1/PMT1/PMS1` bytes. `XNV1` is the global threshold-signed roster;
`PMT2` is its exact mailbox-role projection and cryptographically binds the
current `XNV1` hash. XNV1 commits only the projection policy/eligibility inputs
and required PMT generation rule; it never contains current/next PMT2 hashes.
PMT2 contains its own predecessor and next-PMT2 commitment. This one-way
`XNV1 -> PMT2` construction follows DR-0004 and has no hash cycle.

`PMA2` authorizes one directory-threshold key set, network ID, minimum reader,
mailbox algorithm and bounded validity interval. The exact `PMT2`/`PMS2` binary
records, selection input, ranking hash and threshold projections are frozen in
[CONTACT-RESOLVER-V1 §3.6](CONTACT-RESOLVER-V1.md#36-exact-route-and-mailbox-closure).
No field may be resolved from an unsigned Registry response.

Verification requires all of the following:

1. every PMT2 node exists as an unrevoked `Mailbox`-capable XND1 in exact XNV1;
2. node ID, public origin and current/next SPKI in PMT2 exactly match the XND1
   projection; XND1 additionally supplies failure-domain and traffic-key data;
3. no eligible PMT2 mailbox node is omitted unless the signed XNV1 policy records
   its bounded drain/quarantine reason;
4. XRR1 supplies the exact random blinded placement value and commitments needed
   by the ported PMT2/PMS2 verifier, never an account-derived selector;
5. PMS2 names exactly the replicas recomputed by
   `Rendezvous-SHA256-v2`; a Registry signature cannot override that ranking.

Resolver-service placement is a separate domain-separated rendezvous ranking.
XPU1/XIQ1 must be locatable by a client that has only DID1, so their
InviteResolver shard is derived from the opaque permanent/one-time locator plus
the exact current XNV1/PMT2 context; it never uses the XIR1/XRA1 random placement
input that is learned only after resolution. XPK1 and XUW1/XUQ1 use their random
service capabilities as shard keys. The sole exact class/key/hash derivation,
authority checks, stale-view behavior and privacy consequences are in
[CONTACT-RESOLVER-V1 §3.0](CONTACT-RESOLVER-V1.md#30-exact-current-view-and-service-shard-derivation).
No per-locator PMS2 object or server-selected placement is valid. PMS2 remains
the mandatory signed selection proof inside a recipient's returned message-route
closure. Service ranking omits the changing XNV/PMT artifact refs so an unchanged
candidate set remains stable within a seven-day selection epoch; its request
commitment still binds the exact current XNV/PMT and selected replicas.
Every V1 PMT2 node hosts InviteResolver, PreKeyClaim and ContactUpdate; reachability
or load never authorizes an unsigned rerank beyond the selected replica set.

If XNV1 and PMT2 differ, both are rejected and mutation stops; neither is a
fallback source of truth. This prevents a Registry/directory issuer from presenting
one user a targeted private roster while preserving the reviewed ranking logic,
current/next epoch handover and owner-authorized route-continuity semantics without
preserving conflicting old wire authority. PMT2 selection epochs last seven days
with a two-epoch handover and do not rotate on
every six-hour XNV publication.

During handover, old replicas transfer immutable encrypted objects to new replicas
and retain them until the later of message expiry or 48 hours after a verified quorum
acknowledges transfer. Clients retrieve from both sets and deduplicate by application
message ID. Storage is at-least-once; user-visible materialization is idempotent.

`RET-MAILBOX-CIPHERTEXT-V1` in `RETENTION-AND-RECOVERY-V1.md` is the only V1
mailbox text/control retention source, and disappearing messages MAY request a shorter
lifetime. Retention expiration is not account or trust
expiration. Quotas are enforced per blinded mailbox capability before storage, and
proof-of-work or Privacy Pass-style unlinkable tokens MAY be required for unsolicited
message requests.

## 10. Route selection

### 10.1 Entry guards

Clients persist a sampled set of up to three eligible entry guards. One confirmed
primary guard is preferred for the guard-retention policy period plus uniform
configured jitter. A guard is replaced immediately only after signed revocation or
descriptor/key expiry without successor. Failure-driven replacement requires failures
through two carrier families plus observations from two administratively distinct
access networks, or one local failure set plus threshold-signed remote node-health
evidence. Repeated probes through one ISP/censor, SSID, VPN exit or captive portal are
one observation regardless of time or carrier. At most one failure-driven primary
replacement is permitted per seven days; the old guard remains `Suspect` in protected
state for 30 days and is not resampled. Ordinary Internet loss is not evidence that a
guard is bad.

Persistent guards reduce the probability that repeated random selection eventually
exposes a client to every malicious entry. Bridge rotation is independent: multiple
bridges can lead to the same guard without changing the onion path.

### 10.2 Three-hop algorithm

1. Resolve the operation's required exit role and, for mailbox operations, the
   deterministic recipient replica set.
2. Select an exit from that set by weighted rendezvous over operation ID, excluding
   the active guard when possible.
3. Select the confirmed guard as entry, excluding the exit.
4. Select a middle from eligible `Relay` nodes distinct from entry and exit.
5. Reject if there are not exactly three distinct node IDs, physical hosts, onion
   keys, and peer origins.
6. Prefer candidates maximizing operator/provider/ASN/region diversity, then apply
   load weight. A client-local CSPRNG salt prevents the authority from predicting the
   exact path from public inputs.

With exactly three nodes, every valid path is a permutation of all three. A retry MAY
change bridge, carrier, connection, or role permutation after a definitely-before-
forward failure. It is not described as a disjoint fallback.

At six or more eligible nodes, a later policy MAY enable a second path only when all
six node IDs, physical hosts, onion keys, origins, operators, providers, and ASNs are
distinct where the signed roster permits. This capability is disabled in V1 policy.

### 10.3 Weighting and load

Selection weight is the minimum of signed capacity and independently measured
delivered capacity, multiplied by a bounded reliability factor in `[0.5, 1.5]`.
No operator receives more than one-third of aggregate weight at D2+. Client
measurements are local and use coarse exponentially decayed buckets. A publisher
cannot inject a per-client weight or route hint.

### 10.4 ONION-01 production capability boundary

The exact .NET API contract is owned by
[`deep-extension-privacy-routing-v1.md`](../../deep-protocol/docs/deep-extension-privacy-routing-v1.md#7-minimal-production-api-and-capability-boundary).
This section owns the network semantics consumed by that API and does not duplicate
its method/type inventory.

An ONION-01 production caller never supplies raw X25519 keys, trusted booleans,
signature/key-lookup callbacks, wall time, arbitrary hop lists, entropy bytes or an
optional replay store. Protocol-owned verifiers mint immutable, non-serializable
capabilities from the exact XNA1/XVP1/XNV1/XND1 closure and protected secure time. In
this context XTT is only the in-memory trusted-time lease derived from a fresh
nonce-bound DTT1 and the protected monotonic interval; XTT is not a new wire record.

The client path capability binds one operation class and exactly three ordered hops
(`Ingress`, `Core`, `Exit`) from one XNV1. Each selected traffic key is admissible
for the whole advanced XTT interval and exact XND1 validity intersection. The receive
capability is position-specific: Ingress requires Relay inside Relay, Core requires
Exit inside Relay, and Exit accepts only XRE1. Existing layer-kind fields therefore
prove the exact `Relay -> Relay -> Exit` shape without a transport-specific field.
Every nested XRF1 also binds the same network and the exact next XND1 owner/key/epoch;
short, reordered, cross-network and fourth-hop constructions reject before replay
mutation.

Every node Open requires a pre-acquired one-use durable replay transaction/key lease
bound to the exact frame hash, network, owner, key, epoch, receive position, boot and
XTT. Full AEAD/plaintext/padding/path and operation-specific canonical verification
precedes replay commit; a durable commit precedes release of any forwarding or
mailbox-dispatch capability. Process-local replay memory cannot satisfy this
contract. Disk-full, saturation, ambiguous commit, lease loss or restart recovery
failure emits no opened capability and triggers no forward/dispatch callback.

Exit Open carries a sealed response context containing the exact network,
operation/attempt, reply public key and monotonic expiry into Seal. The client owns a
separate single-use reply-private-key context. Store/Retrieve/Acknowledge exact MAU2
requests and MQR3/MRP1/MAR1 results, ContactResolve exact bounded ContactV1
request/result pairs, and the separate `GroupControl=5` operation with only
GSW1/GSQ1 requests and GSS1 results, use the closed Protocol verifier capability
set, not caller `Func<bool>` implementations. Group-control bytes must never be
smuggled under Store, Retrieve, Acknowledge or ContactResolve. Production
request/response entropy comes only from
the Protocol CSPRNG authority backed by a durable nonce/ephemeral-key/reply-key
uniqueness ledger; deterministic entropy is test-only. Protocol generates the XRE1
attempt ID and returns it for transport correlation; a Contact transport's own retry
ID is separate and cannot become ONION entropy.

These capabilities contain no origin, socket, HTTP, QUIC, Reality, XHTTP or carrier
object. Transport adapters carry the already-sealed frame and cannot influence path,
trust, time, key, replay or payload-verification decisions. ContactResolve and
GroupControl have no direct HTTP fallback: inability to obtain or use an activated
ONION capability fails closed at the transport adapter.

## 11. Request circuit and operation state machines

Connections are pooled per `(networkView, guard, bridge, carrier, keyEpoch)` and
multiplex requests. Circuit lifetime is at most ten minutes or 256 MiB, with +/-20%
jitter. A circuit is never shared across transport profiles or accounts unless a
future privacy review explicitly allows it.

```text
Absent -> Selecting -> Connecting -> Ready -> Draining -> Closed
                         |             |
                         v             v
                       Failed       Degraded -> Reconnecting
```

- `Connecting` has a 10-second total deadline and per-attempt deadlines from carrier
  policy.
- `Ready` requires verified carrier binding, all three current onion keys, and an
  end-to-end authenticated probe response.
- `Draining` accepts responses but no new operations after key/view expiry margin.
- Relay saturation, replay-table saturation, unknown next hop, or key mismatch fails
  closed with a coarse error.

The durable logical operation state is:

```text
Queued -> SealedAttempt -> Sending
  -> Accepted             verified end-to-end result; commit once
  -> DefinitelyNotSent    safe to create a fresh attempt
  -> OutcomeUnknown       retain operation ID; reconcile before retry
  -> Expired/Cancelled
```

`OutcomeUnknown` includes connection loss after the entry accepted a frame, relay
timeout after forwarding, or loss of the terminal response. It MUST NOT be converted
to `DefinitelyNotSent`. Reconciliation repeats the idempotent inner operation or
queries its status. The product claim is at-least-once dispatch plus exactly-once
local materialization, never exactly-once network delivery.

## 12. Request classes

### 12.1 Messaging, config, reachability, and signaling

Small asynchronous objects use the existing three-layer request/response model after
its clean-break repin to epoch traffic keys. Requests are batched for up to 25 ms or
64 KiB, whichever comes first. Interactive call signaling bypasses the batching delay.
Polling uses a long-poll or streaming response where the carrier supports it and a
bounded jittered poll otherwise.

### 12.2 Attachments

Attachments are limited to 25 MiB plaintext per V1 object, encrypted on the client
with an independent random object key, and split into 256 KiB content-addressed
ciphertext chunks. The signed application
message carries the manifest and object key inside E2EE. Blob nodes receive only
ciphertext chunk hashes, sizes, retention, and an unlinkable capability.

Upload and download use a reusable three-hop streaming circuit. Up to four chunks MAY
be in flight per attachment and up to eight globally on Wi-Fi/desktop, reduced by
mobile/battery policy. Resume verifies each ciphertext hash before commit. Public
direct object URLs, CDN redirects, and unmasked blob-host fallback are forbidden in
`MaskedRequired` mode.

### 12.3 Push

Push registration and wake dispatch travel through XPoint. Provider tokens are
encrypted to the push service and bound to a random rotating wake handle, not a Deep
ID or conversation. Payloads contain no sender, recipient, message type, call peer,
or plaintext. A missed push only delays polling; it never loses a message.

## 13. XPoint calls

### 13.1 Call profile

Exact call events, state, KDF, multi-device answer winner and privacy profiles
are defined only in [`CALL-SESSION-V1.md`](CALL-SESSION-V1.md). XPoint's local
network consequence is:

```text
WebRTC <-> local adapter
  <-> masked UDP/443 or TCP/443 carrier
  <-> CallRelay/TURN
  <-> peer's independent relay-only leg
```

Signaling uses the ordinary three-hop message plane; realtime media does not.
Only XCD1-authorized CallRelay targets and the carriers below are exposed to the
call adapter. Content/privacy claims and non-claims remain owned by the call and
threat-model specifications.

### 13.2 `XCD1` — call relay descriptor

`XCD1`, version 1, suite `0x0201`, is the sole call-relay and call-CAS authority
descriptor. Its exact total size is `818..2,018` bytes. The network view references
its exact `XCDCoreRef38`. Canonical tags are:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | call-relay node ID | 32 |
| 3 | descriptor generation | `u64` |
| 4 | predecessor XCD1 core hash | 32; zero only at generation 0 |
| 5 | relay target-auth Ed25519 public key | 32; exact target XND1 CallRelay role key |
| 6 | relay target-auth key generation | `u64`; exact target XND1 CallRelay role-key generation |
| 7 | replica count | `u8`, `2..8` |
| 8 | sorted replica entries | exactly `200 * tag7` bytes |
| 9 | receipt quorum | `u8`; exactly 2 for V1 and `<= tag7` |
| 10 | supported media suite | `u16`; exactly `1=CallMediaSuiteV1` |
| 11 | supported CMD1 version | `u16`; exactly 1 |
| 12 | supported DTLS version | `u16`; exactly DTLS 1.2 |
| 13 | maximum datagram | `u16`, `576..1200` |
| 14 | maximum bitrate | `u32`, `32000..20000000` bit/s |
| 15 | maximum concurrent allocations | `u32`, `1..1000000` |
| 16 | allocation lifetime seconds | `u16`, `1..600` |
| 17 | inter-node transport mask | `u16`; bit 0 QUIC_DATAGRAM, bit 1 HTTP_CAPSULE_STREAM |
| 18 | issued-at | `u64` |
| 19 | not-before | `u64` |
| 20 | expires-at | `u64`; `notBefore < expiresAt <= notBefore+604800` |
| 21 | call-relay role-key signature | 64; target proof of possession |

Each replica entry is
`replicaId32 || callRelayRoleKeyGeneration:u64 ||
callRelayRoleEd25519PublicKey32 || replicaNodeId32 || failureDomainHash32 ||
replicaProofOfPossession64`, sorted by replica ID. Replica IDs, public keys, node IDs
and failure-domain hashes are pairwise distinct; key generations may repeat across
different nodes. The target node cannot also be a replica and its tag-5 public key
cannot equal a replica role key. Every replica node is an unrevoked XNV1 member with the existing
signed `CallRelay` role. Its entry generation/key MUST equal its one exact XND1
CallRelay role-key entry, and the failure-domain hash MUST equal the exact XND1
projection. A relay-authored alternate key, generation or label is invalid. V1
defines no separate `CallRelayReplica` role bit.

Each replica proves possession with a proof bound to this exact target lineage
generation by signing `SIGINPUT("Deep/XPoint/V1/XCD1/replica-pop", 0x0201,
networkId16 || callRelayNodeId32 || descriptorGeneration:u64 ||
predecessorDescriptorCoreHash32 || replicaEntryFirst136Bytes)` with that exact
CallRelay role key. Target tags 5/6 likewise equal its exact XND1 CallRelay role-key
entry, and tag 21 signs
`SIGINPUT("Deep/XPoint/V1/XCD1", 0x0201, unsignedXCD1 tags 1..20)` with that role
key. These checks prove possession before XNV admission; they do not replace the
later per-allocation receipt authorization. The XND1 node-identity signature
authorizes each role key, and a Registry/current-key lookup is forbidden.

`XCDCoreHash32 = SHA256-D("Deep/XPoint/V1/XCD1/core", canonical tags 1..20)`;
`XCDCoreRef38 = ASCII("XCD1") || U16BE(1) || XCDCoreHash32`. Tag 4 names the
predecessor core. A successor keeps network/node identity, increments generation
exactly and fork-latches same-generation changed core or two successors.

XNV1 commits the exact XCD1 core ref and the XND1 descriptors for the target and all
replicas. A verifier accepts a CAO1/CAA1 receipt only under the exact per-entry
generation/key in tag 8, requires exactly tag-9 distinct valid receipts, and rejects stale XNV1,
cross-generation keys, repeated replica/failure domain or a replica omitted from the
exact current XCD1. XCD1 never contains an XNV1 hash, so XNV1 -> XCD1/XND1 is the
single acyclic authority direction.

The client obtains a short-lived allocation from CallRelay through the three-hop
request path according to `CALL-SESSION-V1.md`; Registry only distributes the
signed relay catalog. Credentials are random per call leg, expire no later than ten minutes, and do not
contain an account ID. Allocation and media connection use distinct credentials.

### 13.3 Real-time carrier policy

Preferred media transport is QUIC DATAGRAM or TURN-compatible UDP over a masked
UDP/443 carrier. The mandatory censorship fallback is a masked TCP/443 carrier
carrying TURN/TLS or bounded HTTP Capsule-style datagrams. Head-of-line blocking can
reduce quality, so the fallback MUST prioritize audio, reduce video bitrate, and then
disable video before dropping audio.

No silent fallback to direct ICE, public STUN, direct TURN/TLS, or an unmasked origin
is permitted in `OfficialXPoint3`. `DirectPeer` is reserved for a future separately
signed opt-in policy with a peer-IP warning; it is absent from V1, is never selected by
retry, and cannot be reported as an XPoint privacy/circumvention success.

### 13.4 Call state machine

The single normative state machine is
[`CALL-SESSION-V1.md`](CALL-SESSION-V1.md). XPoint implements its allocation and
carrier transitions and MUST NOT define an additional network-local call state.

## 14. Rotation and long-offline behavior

| Object | Normal lifetime | Refresh/overlap |
| --- | ---: | ---: |
| `XNV1` network view | <=24 h | publish 6 h; refresh with 2 h margin |
| `XND1` node descriptor | <=7 d | next descriptor >=24 h before use |
| onion traffic key | <=24 h | next key published; <=2 h receive overlap |
| `XRR1` current reachability record | <=24 h | publish successor before 6 h margin |
| `XUR1` contact update rendezvous | `RET-XUR-UPDATES-V1` | current+next capability, ratcheted successors |
| mailbox placement epoch | 7 d | two-epoch storage handover |
| call allocation | <=10 min | no reuse across calls |
| bridge bundle/credential | carrier policy, <=7 d | current+next cohort bundles |
| offline root anchor | supported app generation | never authorizes live endpoints by itself |
| root fresh-install checkpoint | <=180 d | exact history retained; current checkpoint fetched/imported |

A supported client offline for 30, 180, or 365 days follows a signed successor or
root-checkpoint consistency path, then resolves current contact-scoped `XUR1/XRR1`.
It keeps identity,
contacts, local history, and durable outbox. It does not receive already expired
mailbox objects. Beyond retained view history, root-authorized re-enrollment creates
new device keys under the same recovered account; it does not reuse old device or
ratchet keys.

Authorities and witnesses apply only `RET-NETWORK-HISTORY-V1` to XVP1/XNV1/XNH1/PMT2
operational history. Mirrors MAY retain it indefinitely. Clients gossip
coarse view hashes through XPoint and can submit fork evidence without identity.

## 15. Failure handling

Failures have four externally stable classes:

| Class | Meaning | Allowed action |
| --- | --- | --- |
| `LocalRejected` | invalid/expired local state before network send | refresh or surface error |
| `DefinitelyBeforeForward` | carrier could not authenticate/connect or entry rejected before accepting frame | new bridge/carrier/attempt allowed |
| `OutcomeUnknown` | any hop may have forwarded/mutated | reconcile same logical operation |
| `TerminalRejected` | verified end-to-end protocol/auth/quota rejection | no automatic retry unless policy changes |

Error detail exposed to an unauthenticated peer is coarse. Logs MUST NOT contain
Deep IDs, mailbox IDs, route node sequences, bridge credentials, Reality short IDs,
call peer identifiers, SDP, ICE candidates, payloads, or stable hashes of those
values.

## 16. Performance SLOs

The single release SLO table, sample/network requirements and measurement
semantics are in [`V1-RELEASE-SCOPE.md`](V1-RELEASE-SCOPE.md). XPoint evidence
must report carrier, route/circuit warmness, payload bucket, device/network
class and whether recipient offline time was excluded so that table can be
evaluated without a second set of numbers here.

Connection reuse, 25 ms request batching, parallel replica reads, hedged read-only
requests after the p95 threshold, and QUIC migration are permitted. Mutating requests
MUST NOT be blindly hedged. Performance optimization must not remove an onion hop,
reuse reply keys, disable padding, reveal a direct endpoint, or bypass carrier policy.

## 17. Traffic-analysis policy

V1 uses request size buckets of 4, 16, 64, 256, and 1024 KiB after onion wrapping.
Objects larger than 1 MiB use fixed 256 KiB ciphertext chunks. Poll intervals include
bounded +/-20% jitter. Call packets use common MTU-sized encrypted datagrams where
possible and bounded padding for small audio packets.

Optional cover traffic is disabled by default until battery and bandwidth evidence
exists. The UI and documentation MUST not convert padding/jitter into a global traffic-
analysis-resistance claim.

## 18. Capacity and abuse controls

- Admission checks sizes, canonical framing, rate tokens, replay IDs, and quotas
  before public-key opening or storage allocation where possible.
- Each role has separate concurrency, byte, CPU, replay-window, and egress budgets.
- Unsolicited message requests use a lower quota than accepted contacts.
- Call allocations require an authenticated accepted contact and explicit callee
  consent before media; this prevents reflection and call-presence probing.
- Bridge anti-scraping credentials are unlinkable to Deep account/device identity.
- A node under pressure sheds blob/video first, then new call allocations, while
  preserving bounded text/control capacity.
- All retries use exponential backoff with full jitter and a server-independent cap.

## 19. Verification and release gates

### 19.1 Protocol conformance

- golden and negative vectors for every signed artifact and onion layer;
- unknown version/field/suite, max+1, truncation, duplicate, reserved, signature,
  predecessor, time, and cross-network negatives before state mutation;
- deterministic network-view and mailbox-selection agreement in two independent
  implementations;
- onion key-epoch rollover, secure retirement, replay saturation, and restart tests;
- same-generation fork and rollback recovery tests;
- durable outbox crash windows proving at-least-once dispatch and once-only local
  materialization.

### 19.2 Three-node topology and chaos

- all six role permutations work without describing any as disjoint;
- loss, restart, slow response, disk-full, clock-skew, key rotation, and descriptor
  expiry at every role;
- mailbox replica handover and read reconciliation;
- Registry and public DNS completely unavailable after a client has a valid bridge;
- one malicious node drops, delays, duplicates, corrupts, replays, and selectively
  fails frames without learning plaintext or causing unsafe fallback.

### 19.3 Censorship matrix

The mandatory matrix is defined in `CIRCUMVENTION-CARRIERS-V1.md` and includes APK
extraction, DNS/SNI/IP blocking, UDP blocking, active probing, stale bridge catalogs,
and carrier downgrade. The release gate requires messaging, current reachability,
attachments, and audio calls to remain usable through at least one independent masked
carrier. Video may downgrade to audio under TCP-only blocking but MUST not expose a
direct path.

### 19.4 Physical E2E

- clean Android and Windows installs create accounts offline;
- arbitrary Deep IDs exchange first messages with no pre-shared DEV material;
- 1:1, small group, attachments, reactions, receipts, and cold restart;
- foreground/background and push-disabled delivery;
- audio/video call ringing, explicit accept, bidirectional RTP, mute, camera, path
  change, UDP-blocked audio fallback, and hangup;
- packet capture proves no direct managed-ingress, blob, Registry signaling, peer IP,
  public STUN, or unmasked/direct-to-origin TURN connection in `MaskedRequired` mode;
- 30/180/365-day metadata time-travel fixtures preserve account/outbox and accurately
  report expired messages as expired rather than connectivity failure.

### 19.5 Independent review

Public GA requires separate lead-developer, protocol/cryptography, privacy/metadata,
and censorship-resistance reviews with no open P0 or P1 finding. Claims and SLOs are
released only with sanitized, reproducible evidence from one signed commit matrix.

## 20. Implementation work packages

The only dependency DAG, repository ownership, package inputs/outputs, removals
and evidence gates are in
[`IMPLEMENTATION-PLAN-V1.md`](IMPLEMENTATION-PLAN-V1.md). This specification
owns XPoint semantics and canonical artifacts, not a parallel task list.

### 20.1 Repository ownership

Repository ownership is not repeated here; use the exact package entries in the
implementation plan and the documentation ownership matrix in `README.md`.

## 21. Primary references

- Session's current three-hop request and swarm model:
  <https://docs.getsession.org/session-network/session-protocol/onion-requests-and-message-routing>
- Session Protocol V2 rationale for PFS, PQ protection, and device management:
  <https://getsession.org/session-protocol-v2>
- Tor entry-guard rationale and state model:
  <https://spec.torproject.org/guard-spec/>
- WebRTC security and relay-only IP privacy requirements:
  <https://www.rfc-editor.org/rfc/rfc8827.html>
- WebRTC transport requirements:
  <https://www.rfc-editor.org/rfc/rfc8835.html>
- TURN protocol:
  <https://www.rfc-editor.org/rfc/rfc8656.html>
- QUIC transport:
  <https://www.rfc-editor.org/rfc/rfc9000.html>
- UDP proxying over HTTP/MASQUE:
  <https://www.rfc-editor.org/rfc/rfc9298.html>
- Privacy partitioning architecture:
  <https://www.rfc-editor.org/rfc/rfc9614.html>
- Oblivious HTTP:
  <https://www.rfc-editor.org/rfc/rfc9458.html>
- Privacy Pass architecture:
  <https://www.rfc-editor.org/rfc/rfc9576.html>

Local Session source used for implementation comparison is under
`C:\Work\DeepSession\source`; it is reference material, not a wire-compatibility or
copy requirement. The inspected revisions were `session-docs`
`5f773f4aa9c9abc726f9e7f3fafb50da8b9b069d`, `session-android`
`bdaeff9dfdee50d89bf6d5d4928553915b9cccab`, `session-desktop`
`7441677ad975ae4aee032b1a1b59290c84b0cbfe`, `session-ios`
`99bc193f8d619e9ed928e3d211006a0b6378585b`, and `session-storage-server`
`77a2687e1033a7fc37e46f851c5aed70bbee4c49`.
