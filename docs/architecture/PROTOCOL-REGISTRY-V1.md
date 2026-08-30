# Deep/XPoint Protocol Registry V1

Status: **canonical implementation-planning registry for the clean-break V1**
Date: 2026-08-30
Owner: `deep-protocol`

## 1. Purpose and authority

This document is the single human-readable registry for names that cross a
repository boundary in the first public Deep/XPoint generation. It prevents two
agents from independently assigning the same magic, suite, carrier, deployment
profile, call profile, or public interface name.

It records both the current implementation and the target state. A row marked
`TARGET_UNFROZEN` or `DECISION_REQUIRED` is not permission to emit bytes. Exact
bytes become releasable only after the named normative source, machine-readable
registry, generated codec and positive/negative vectors are frozen together in
`deep-protocol`.

Authority order for a value is:

1. accepted decision records under `docs/survival-program/decisions`;
2. a frozen machine registry and its schema/vectors;
3. the normative source named in the tables below;
4. this planning registry;
5. runtime code, runbooks and public documentation.

If levels 1–3 conflict with this file, implementation stops and the registry is
corrected before consumers proceed. Runtime code never becomes authority merely
because it already emits a value.

## 2. Lifecycle states

| State | Meaning | May a release encoder emit it? |
| --- | --- | --- |
| `FROZEN_TARGET_NOT_ACTIVE` | Exact machine registry and vectors exist, but the new release composition does not activate the path yet. | Only after its activation package passes. |
| `CURRENT_PRE_CUTOVER` | Implemented by the old/pre-clean-break composition. | No, unless an explicit row also marks it target. |
| `TARGET_UNFROZEN` | Target semantics are accepted, but exact schema/codec/vectors are still missing. | No. |
| `TARGET_RENAME_REQUIRED` | Clean-break target name is chosen, while current code still emits a colliding/retired name. | Only after destructive rename and negative legacy vectors. |
| `DECISION_REQUIRED` | Competing designs remain. No consumer may guess. | No. |
| `RESERVED` | Name/number is held against collision but has no active decoder. | No. |
| `RETIRED_REJECT` | Historical/dark-path value. New production readers reject it before callbacks or mutation. | No. |
| `RELEASE_ACTIVE` | Frozen target plus implementation, composition and evidence gates are complete. | Yes. |

No value in this document is `RELEASE_ACTIVE` on 2026-08-30.

## 3. Global collision and allocation rules

1. A four-byte ASCII magic is globally unique across every public, protected,
   local-durable and transport record that may enter the same process generation.
   Dispatch by context to two meanings of the same magic is forbidden.
2. A magic is never reused after retirement. A clean break allocates a new magic
   and adds a negative vector proving rejection of the old bytes.
3. Record version is part of the record grammar, not a namespace escape from a
   magic collision. A different semantic record receives a different magic.
4. Suite registries are scoped by the field width and protocol family stated
   below. The numeric value `1` in an onion `u8` suite is not the DNP1 `u16`
   authentication suite `0x0001`.
5. Carrier and deployment-profile IDs are unsigned `u16be`. Zero is invalid.
   Values `0x8000..0xffff` are test/private-use and are rejected by release
   policy even if a test harness recognizes them.
6. A new allocation requires one focused `deep-protocol` change containing the
   registry row, exact source specification, machine schema, generated constants,
   golden vectors, unknown/max+1/cross-feed vectors and downstream impact list.
7. Aliases are documentation-only migration aids and never accepted strings,
   enum values, magic values or reflection names in the clean-break runtime.
8. Collision CI imports the DNP1 machine registry and the V1 machine registries,
   then fails on duplicate magic, numeric ID, canonical name or case-insensitive
   string. Hand-maintained source constants alone cannot satisfy this gate.

### 3.1 Mandatory privacy-routing clean-break

The frozen DNP1 registry owns:

- `DRS1`: DNP1 account revocation snapshot;
- `DPR1`: DNP1 native peer request.

The pre-cutover privacy-routing implementation also emits `DPR1` as a terminal
result and `DRS1` as response plaintext. That reuse is forbidden by rule 1.
The clean-break privacy-routing specification therefore owns:

- `XRF1/XRL1/XRE1`: network/role/epoch-bound frame and request plaintexts;
- `XPR1`: privacy-routing terminal result;
- `XRS1`: sealed privacy-routing response plaintext.

`deep-protocol` must atomically replace all five codecs and every test/vector. New
readers reject privacy result/response bytes beginning with `DPR1` or `DRS1`;
they do not inspect length or context and reinterpret them. DNP1 `DRS1/DPR1`
keep their exact frozen meanings and bytes.

## 4. Suite registries

### 4.1 DNP1 identity/protected-state suites (`u16be`)

Normative source:
`../survival-program/releases/v3.0.0/specs/DNP1-CLASSICAL-IDENTITY-RESET-MRL2-V1.md`
and `dnp1-classical-v1.registry.json` beside it.

| ID | Canonical name | Exact scope | Status |
| ---: | --- | --- | --- |
| `0x0000` | `DnpUnsignedCommittedV1` | Only the closed unsigned DNP1 record classes named by the machine registry. It is not an authentication suite. | `FROZEN_TARGET_NOT_ACTIVE` |
| `0x0001` | `IdentityAuthV1Ed25519` | Public DNP1 identity, certificate, reset, peer and witness records named by the machine registry. | `FROZEN_TARGET_NOT_ACTIVE` |
| `0x8001` | `ProtectedStateHmacSha256V1` | Only internal protected records named by the machine registry. | `FROZEN_TARGET_NOT_ACTIVE` |
| `0x8002` | `ProtectedStateAeadV1` | Only the AEAD-protected DNP1 record classes named by the machine registry. | `FROZEN_TARGET_NOT_ACTIVE` |
| `0x0101` | retired dark-path crypto draft | Historical `deep-crypto-v1.registry.json`; never a DNP1 identity suite. | `RETIRED_REJECT` |
| `0x0102` | retired dark-path crypto draft | Historical `deep-crypto-v1.registry.json`; never a DNP1 identity suite. | `RETIRED_REJECT` |

### 4.2 Pairwise messaging/application suite (`u16be`)

Normative source:
`../survival-program/releases/v3.0.0/specs/DEEP-CRYPTO-V1-DRAFT.md`.

| ID | Canonical name | Required construction | Status |
| ---: | --- | --- | --- |
| `0x0201` | `DHM2-X25519-MLKEM768-TRIPLE-XCHACHA20` | X25519 + ML-KEM-768 hybrid AKE, Ed25519 certificate/prekey authentication, HKDF-SHA-512, XChaCha20-Poly1305-IETF and Triple Ratchet/SPQR. Classical and PQ branches are both mandatory. | `TARGET_UNFROZEN`; provider gate blocks activation |
| `0x0202` | `DHM2-FutureHybridAuthentication` | Future long-lived hybrid authentication profile. | `RESERVED` |

No classical-only, PQ-only or environment-selected fallback ID is allocated.
Provider-private serialization is never encoded inside a Deep record.

### 4.3 XPoint onion suite (`u8`)

Normative source: `../../deep-protocol/docs/deep-extension-privacy-routing-v1.md`.

| ID | Canonical name | Scope | Status |
| ---: | --- | --- | --- |
| `0x01` | `XPointFrameX25519XChaCha20V1` | XRF1 ephemeral X25519/HKDF-SHA-512/XChaCha20-Poly1305 frame bound to network, key owner, role and epoch. | `TARGET_RENAME_REQUIRED`; old XSalsa/DRF1 bytes reject |

A future onion suite requires a new numeric ID and independent vectors. Carrier
TLS/PQ settings do not change this suite or messaging suite `0x0201`.

## 5. Carrier, deployment and call registries

### 5.1 Carrier IDs (`u16be`)

Canonical source: `CIRCUMVENTION-CARRIERS-V1.md`. The numeric assignments below
must be copied into its future machine registry before any adapter is activated.

| ID | Canonical name | Purpose | Owner repository | Status/current note |
| ---: | --- | --- | --- | --- |
| `0x0001` | `reality-xhttp-v1` | Masked TCP/443 stream to an Entry or CallRelay binding through pinned Xray/REALITY/XHTTP. | `deep-client-maui` adapter; `deep-devops` hosting | `TARGET_UNFROZEN` |
| `0x0002` | `https-stream-v1` | Independent maintained HTTPS/H2 streaming carrier with exact Deep upgrade/framing spec. | `deep-client-maui` client, `xnode` or dedicated bridge runtime server | `TARGET_UNFROZEN`; `webtunnel-h2-v1` is a stale documentation alias and must reject as a canonical name |
| `0x0003` | `masque-h3-v1` | Exact RFC 9298-derived UDP/HTTP3 media path to one signed CallRelay target. | `deep-client-maui` adapter; `deep-devops` gateway | `TARGET_UNFROZEN`; “compatible where practical” must be replaced by exact profile |
| `0x0004` | `masked-tcp-capsule-v1` | Bounded datagram framing over carrier `0x0001` or `0x0002`, audio-first fallback. | `deep-client-maui` and bridge runtime | `TARGET_UNFROZEN` |
| `0x0100` | `direct-tls-admin-v1` | Explicit user-managed/admin transport only. | future on-prem provider | `RESERVED`; forbidden in `OfficialXPoint3` |
| `0x8000..0xffff` | private/test | Loopback, fault injection and harness-only adapters. | test repositories | release-rejected |

`webtunnel-h2-v1`, `Reality`, `XHTTP`, `MASQUE` and `TURN/TLS` are not additional
carrier IDs unless a separately registered wire profile is created. A display
label is not a protocol identifier.

### 5.2 Deployment profile IDs (`u16be`)

| ID | Canonical name | Release state | Normative source |
| ---: | --- | --- | --- |
| `0x0001` | `OfficialXPoint3` | first-release target | `DEPLOYMENT-PROFILES.md` |
| `0x0002` | `UserManaged` | reserved future parent profile; signed capabilities distinguish one-node and multi-node guarantees | `DEPLOYMENT-PROFILES.md` |
| `0x0003` | `DirectP2P` | reserved future | `DEPLOYMENT-PROFILES.md` |
| `0x0004` | `StoreCarryForwardMesh` | reserved future | `DEPLOYMENT-PROFILES.md` |

`OfficialXPoint6Plus`, `UserManagedSingleNode` and `UserManagedMultiNode` are
policy/capability variants, not additional V1 wire IDs. If they later need wire
semantics, new IDs are allocated explicitly.

### 5.3 Call names

Call privacy policy, media carrier and observed network condition are separate
axes. These target names supersede ambiguous aliases in current prose.

| Axis | Canonical name | Meaning | Status |
| --- | --- | --- | --- |
| privacy profile | `RelayOnly` | Official V1 exposes relay-only candidates; peers do not receive host/srflx/direct candidates. | target canonical |
| privacy profile | `DirectPeer` | Future explicit opt-in profile that may reveal peer IP. | reserved, release-rejected |
| media carrier | `MasqueUdp` | Relay-only media through carrier `masque-h3-v1`. | target canonical |
| media carrier | `MaskedTcpCapsule` | Relay-only bounded datagrams through carrier `masked-tcp-capsule-v1`. | target canonical |
| network condition | `Normal` | UDP carrier available. | target canonical |
| network condition | `Restricted` | UDP unavailable; not a privacy profile or fallback permission. | target canonical |

The stale strings `RelayPrivacy`, `DirectFast`,
`DirectIce`, `RestrictedNetwork` as a profile, and `MaskedRelay` as a profile
are `CURRENT_PRE_CUTOVER` documentation names. The implementation-alignment
package removes them rather than adding runtime aliases.

### 5.4 Canonical public interface names

Normative source: `TRANSPORT-NEUTRAL-MESSAGING.md` after the alignment package.

| Canonical interface | Owner | Boundary |
| --- | --- | --- |
| `IMessageDeliveryTransport` | `deep-client-shared` | Prepare, dispatch, reconcile, receive and acknowledge opaque message/control ciphertext. |
| `ITransportBindingProvider` | `deep-client-shared` | Resolve verified profile-specific bindings/capabilities without exposing provider internals to application code. |
| `IAttachmentBlobTransport` | `deep-client-shared` | Upload/download/resume encrypted chunks only. |
| `ICallMediaPathProvider` | `deep-client-shared` | Allocate and expose policy-verified relay-only media paths; never owns signaling semantics. |
| `IPushHintTransport` | `deep-client-shared` | Register and deliver opaque optional wake hints. |
| `ITransportPathObserver` | `deep-client-shared` | Publish sanitized effective profile/carrier/path state to UI/evidence. |
| `ICircumventionCarrier` | `deep-client-shared` abstraction; platform implementation in `deep-client-maui` | Probe/connect authenticated stream/datagram bindings and classify transport failures. |

The names `IAsyncMessageTransport`, `IBlobTransport`,
`ICallSignalingTransport`, `IRealtimeDatagramTransport` and
`IReachabilityResolver` from current XPoint prose are stale target aliases.
They are removed during alignment; production code must not define both sets.

## 6. Artifact magic registry

### 6.1 Frozen DNP1 allocation set

Owner: `deep-protocol`. Normative source and exact bytes:
`dnp1-classical-v1.registry.json` and
`DNP1-CLASSICAL-IDENTITY-RESET-MRL2-V1.md`.

All of the following magics are globally allocated and unavailable for reuse:

```text
DPA1 DPD1 DPM1 DRT1 DRS1 KRT1 KRF1 DCM1 DRA1 DWD1
DCP1 DCS1 DCT1 DCN1 DCQ1 DHL1 DCL1 DWL1 DRC1 DPL1
DBG1 RIB1 XIB1 DNR1 MRL2 RIP2 DPC1 DXP1 DPR1 DPS1
MRLC DPJ1 RRM1 RRL1 DWT1 DXR1
```

The set is `FROZEN_TARGET_NOT_ACTIVE`; individual records become active only
through their release package. Protected/internal records are still collision
participants even when they never cross a network.

Key records used directly by the V1 architecture are:

| Magic | Canonical meaning | Status/current-vs-target |
| --- | --- | --- |
| `DPA1` | DNP1 account authority/certificate generation. | frozen target, dark/not production-composed |
| `DPD1` | independently generated device certificate. | frozen target, dark/not production-composed |
| `DPM1` | DNP1 role-membership certificate defined by the machine registry. | frozen target, dark/not production-composed |
| `DRT1` | committed revocation target referenced by DRS1. | frozen target, dark/not production-composed |
| `DRS1` | monotonic DNP1 account/device/role revocation snapshot. | frozen target; privacy-routing use of this magic is retired collision |
| `DRA1` | DNP1 account-reset authorization/linkage record. | frozen target, dark/not production-composed |
| `DNR1` | DNP1 native router certificate. | frozen target, dark/not production-composed |
| `MRL2` | DNP1 membership roster lineage generation 2. | frozen target, dark/not production-composed |
| `RIP2` | DNP1 router ingress/profile record generation 2. | frozen target, dark/not production-composed |
| `DPR1` | DNP1 native peer request. | frozen target; privacy-routing use of this magic is retired collision |
| `DPS1` | DNP1 native peer response/status record. | frozen target, dark/not production-composed |

### 6.2 Privacy-routing records

Owner: `deep-protocol`. Normative source:
`../../deep-protocol/docs/deep-extension-privacy-routing-v1.md`.

| Magic | Meaning | Status/current-vs-target |
| --- | --- | --- |
| `XRF1` | Authenticated encrypted frame bound to network/key owner/role/epoch. | `TARGET_RENAME_REQUIRED`; old DRF1 rejects |
| `XRL1` | Relay plaintext. | `TARGET_RENAME_REQUIRED`; old DRL1 rejects |
| `XRE1` | Exit plaintext. | `TARGET_RENAME_REQUIRED`; old DRE1 rejects |
| `XPR1` | HTTP-independent terminal result contained in the sealed exit response. | `TARGET_RENAME_REQUIRED`; current code emits colliding `DPR1` |
| `XRS1` | reply-key-sealed response plaintext carrying exact XPR1 and zero padding. | `TARGET_RENAME_REQUIRED`; current code emits colliding `DRS1` |

The implementation package must inventory every existing privacy-routing magic
from source before freeze; no unlisted magic is grandfathered by this row.

### 6.3 Pairwise/application/contact/group records

Owners: exact codecs/vectors in `deep-protocol`; portable state machines in
`deep-client-shared`. Normative sources:
`DEEP-CRYPTO-V1-DRAFT.md` and `CONTACT-AND-GROUP-PROTOCOL-V1.md`.

| Magic | Meaning | Status |
| --- | --- | --- |
| `DPK2` | signed per-device hybrid prekey bundle. | `TARGET_UNFROZEN` |
| `DPH2` | hybrid asynchronous initial/prekey message header. | `TARGET_UNFROZEN` |
| `DPE2` | established Triple-Ratchet device envelope. | `TARGET_UNFROZEN` |
| `DMD1` | account-authorized messaging device directory. | `TARGET_UNFROZEN` |
| `DID1` | permanent transport-neutral Deep ID containing the recovery-derived public address key; no expiry. | `TARGET_UNFROZEN` |
| `DAB1` | dual-signed permanent-address/current-account binding lineage. | `TARGET_UNFROZEN` |
| `DCA1` | device authorization to publish rotating contact bundles for exact DID1/DAB1. | `TARGET_UNFROZEN` |
| `DCB1` | signed contact bundle. | `TARGET_UNFROZEN` |
| `DCR1` | exact resolver closure around DCB1/DRS1/DPD1 support objects. | `TARGET_UNFROZEN`; XPU/XIQ/XIS/XPK/XPC service semantics are specified |
| `DIA1` | expiring one-time invitation locator; never the permanent Deep ID. | `TARGET_UNFROZEN` |
| `DAO1` | metadata-sealed asynchronous deposit object containing DPH2 or DPE2. | `TARGET_UNFROZEN` |
| `DMC2` | canonical pairwise application event plaintext. | `TARGET_UNFROZEN` |
| `DGP1` | signed group membership proposal. | `TARGET_UNFROZEN` |
| `DGC1` | owner-sequenced group commit. | `TARGET_UNFROZEN`; exact dependency closure/package still required |
| `DGM1` | group application event nested in DMC2 per-device fanout. | `TARGET_UNFROZEN` |
| `DAM1` | encrypted attachment manifest carried inside DMC2/DGM1. | `TARGET_UNFROZEN` |
| `DGT1` | emergency owner-sequencer transfer authorization. | `TARGET_UNFROZEN` |
| `GCP1` | hash-closed group commit/support package. | `TARGET_UNFROZEN` |

`DPAC`, `DPDC`, `DPKB`, `DPHI`, `DPE1` and `DMC1` are
`RETIRED_REJECT`. They are not aliases for the rows above.

`GCP1` is the exact package containing DGC1 and all referenced
DGP1/DMD1/DRS1/DPD1/transparency objects. DGC1 alone is not sufficient input
to materialize a commit.

### 6.4 Account-directory transparency records

Owner: exact codecs/vectors in `deep-protocol`; log publication in
`deep-registry-api`; client verification/LKG in `deep-client-shared`.
Normative source: `ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md`.

| Magic | Meaning | Status |
| --- | --- | --- |
| `ADC1` | account-scoped current DPA1/DRS1/DMD1 checkpoint under an opaque directory leaf. | `TARGET_UNFROZEN` |
| `ADH1` | threshold-witnessed append-only directory log head. | `TARGET_UNFROZEN` |
| `ADP1` | exact lookup/inclusion/consistency proof and signed identity/device closure. | `TARGET_UNFROZEN` |
| `ADL1` | opaque lookup capability shared only by Deep address/E2EE peers. | `TARGET_UNFROZEN` |

These records are mandatory freshness inputs to first contact and group member
directory verification. A valid old DMD1 signature without a current ADP1/ADH1
proof cannot authorize a new prekey claim or group commit.

### 6.5 XPoint network and contact reachability records

Owner: exact codecs/vectors in `deep-protocol`; publishers and runtimes as noted.
Normative source: `XPOINT-NETWORK-V1.md`.

| Magic | Meaning | Runtime owner | Status |
| --- | --- | --- | --- |
| `XNA1` | network root/authority lineage. | offline authority tooling + client verifier | `TARGET_UNFROZEN` |
| `XND1` | signed node descriptor and role/key/failure-domain projection. | node authors; witnesses publish | `TARGET_UNFROZEN` |
| `XNV1` | threshold-signed deterministic global network view. | witness publisher; client verifies | `TARGET_UNFROZEN` |
| `XNH1` | threshold-witnessed network-view transparency head. | witness publisher; clients gossip | `TARGET_UNFROZEN` |
| `XNP1` | bounded XNV inclusion/consistency proof. | mirrors publish; clients verify | `TARGET_UNFROZEN` |
| `XIR1` | long-lived invite rendezvous embedded in DCB1; never a current message deposit route. | contact owner authors; selected invite-store pair hosts | `TARGET_UNFROZEN`; source `CONTACT-RESOLVER-V1.md` |
| `XRR1` | short-lived established-contact/message deposit reachability. It is not a public Deep ID artifact. | contact owner authors; selected mailbox pair hosts | `TARGET_UNFROZEN` |
| `XUR1` | established-contact update rendezvous capability/record. | contact owner authors; update-rendezvous service hosts | `TARGET_UNFROZEN`; exact semantics/fields fixed, machine codec pending M0 |
| `XCP1` | local protected client path plan. Never uploaded. | `deep-client-shared` | `TARGET_UNFROZEN`; local DB generation only |
| `XCD1` | signed CallRelay descriptor. | CallRelay authors; witnesses publish | `TARGET_UNFROZEN` |
| `XRA1` | long-lived recipient reachability authorization. | recipient authors; directory threshold verifies | `TARGET_UNFROZEN` |
| `XRC1` | short-lived XNV/PMT/PMS-bound live route closure. | directory threshold authors | `TARGET_UNFROZEN` |
| `XSS1` | retained route successor/checkpoint closure. | route stores/witnesses | `TARGET_UNFROZEN` |

The authority/witness package must decide whether XNA/XND/XNV use the same
canonical tagged grammar as application records or a separately registered
network grammar. Agents must not infer a grammar from the semantic field lists.

### 6.6 Contact resolver and prekey service records

Owner: exact codecs/vectors in `deep-protocol`; service runtime in `xnode`;
client author/verification/orchestration in `deep-client-shared`.
Normative source: `CONTACT-RESOLVER-V1.md`.

| Magic | Meaning | Status |
| --- | --- | --- |
| `XPU1` | compare-and-swap publication of encrypted DCR1 at an opaque invite locator. | `TARGET_UNFROZEN` |
| `XPA1` | short-lived directory-threshold authorization for one opaque XPU1 publication; exposes no Deep ID/account/device. | `TARGET_UNFROZEN` |
| `XIQ1` | idempotent permanent-address resolve or one-time invite claim request. | `TARGET_UNFROZEN` |
| `XIS1` | closed invite resolve result with exact-replay semantics. | `TARGET_UNFROZEN` |
| `XPS1` | signed per-device prekey service descriptor carried by DCB1. | `TARGET_UNFROZEN` |
| `XPK1` | atomic one-time/last-resort prekey claim request. | `TARGET_UNFROZEN` |
| `XPC1` | witnessed prekey claim/replay/failure result bound into DPH2. | `TARGET_UNFROZEN` |

`DID1` plus `XIR1` and these operations replaces the earlier plan to embed
consumable DPK2 bytes or a 24-hour XRR1 in a reusable address. DID1 itself has
no expiry; current publication availability is bounded by every mandatory
nested signed object. DIA1 remains an expiring one-time invitation.

### 6.7 Carrier records

Owner: `deep-protocol`; normative source: `CIRCUMVENTION-CARRIERS-V1.md`.

| Magic | Meaning | Status |
| --- | --- | --- |
| `XCB1` | signed binding of one carrier endpoint to one Entry/CallRelay target and key epoch. | `TARGET_UNFROZEN` |
| `XCC1` | signed allowed-carrier/downgrade/backoff/distributor policy. | `TARGET_UNFROZEN` |
| `XBB1` | small cohort-specific signed bridge bundle. | `TARGET_UNFROZEN` |
| `XBA1` | RFC 9458-issued bounded-use bridge access token container. | `TARGET_UNFROZEN`; exact codec/vectors pending M0 |
| `XHC1` | HTTPS-stream authenticated client hello. | `TARGET_UNFROZEN` |
| `XHA1` | HTTPS-stream gateway acceptance/challenge. | `TARGET_UNFROZEN` |

### 6.8 Call records

Owner: codecs in `deep-protocol`, capability stores/allocations in `xnode`,
state machine in `deep-client-shared`. Source: `CALL-SESSION-V1.md`.

| Magic | Meaning | Status |
|---|---|---|
| `CAC1` | capability-based multi-device answer-winner CAS. | `TARGET_UNFROZEN` |
| `CAR1` | participant-specific CallRelay allocation request. | `TARGET_UNFROZEN` |
| `CAA1` | CallRelay-signed allocation response. | `TARGET_UNFROZEN` |

### 6.9 Mailbox/continuity records

Owner: `deep-protocol`. Current sources are the production-mailbox extension
documents under `../../deep-protocol/docs/`.

| Magic/set | Current meaning | Target status |
| --- | --- | --- |
| `PMA1`, `PMT1`, `PMS1` | Existing mailbox authority, topology and deterministic selection. | `CURRENT_PRE_CUTOVER`; not accepted as the target XNV-bound placement generation. |
| `PRA1`, `PSS1` | Pre-continuity advertisement/successor. | `RETIRED_REJECT` in new contacts/runtime. |
| `RCD1`, `RDA1`, `RCR1`, `RHC1`, `RTC1`, `RCA1`, `PRA2`, `PSS2` | Existing owner/delegated route-continuity V2 closure. | `CURRENT_PRE_CUTOVER` and `RETIRED_REJECT` after reset; DR-0004 ports semantics to XRA1/XRC1/XSS1. |
| `PMA2`, `PMT2`, `PMS2` | DR-0004 clean-break threshold authority, XNV1-bound projection and deterministic blinded selection. | `TARGET_UNFROZEN`; decision resolved, exact grammar/vectors require NETCODEC-01. |
| `XRA1`, `XRC1`, `XRR1`, `XSS1` | DR-0004 owner authorization, live route, shared reachability and retained successor closure. | `TARGET_UNFROZEN`; pre-cutover continuity records reject. |

The mailbox decision is release-blocking. `XRR1` commitments do not by
themselves provide a routable deposit closure; the selected design must define
the exact objects a first-contact sender verifies and presents.

## 7. Status and collision manifest required from deep-protocol

Before the first consumer package starts, `deep-protocol` must generate one
machine-readable V1 registry containing at least:

```text
schemaVersion
registryGeneration
records[{magic, version, grammar, suiteNamespace, allowedSuites,
         minBytes, maxBytes, visibility, normativeSource, ownerPackage, status}]
suites[{namespace, width, id, canonicalName, status}]
carriers[{id, canonicalName, purposes, status}]
deploymentProfiles[{id, canonicalName, status}]
callNames[{axis, canonicalName, status}]
publicInterfaces[{canonicalName, ownerAssembly, status}]
retiredValues[]
```

The collision gate imports this registry, the frozen DNP1 registry and all
generated source constants. It proves:

- no duplicate four-byte magic;
- no duplicate numeric value inside one namespace;
- every implementation constant has exactly one registry row;
- every target row has a schema and positive/negative vector owner;
- every retired value rejects before crypto, network, allocation or mutation;
- `XPR1/XRS1` are emitted and old privacy `DPR1/DRS1` are rejected;
- no stale interface/carrier/call alias appears in production public APIs,
  configuration schema, resources or release dependency graph.

## 8. Resolved decisions and remaining implementation evidence

No architecture decision remains open. The following empirical gate still
blocks activation but cannot be resolved by prose:

| Gate | Required output | Blocking packages |
| --- | --- | --- |
| `CRYPTO-01` selected provider evidence | pinned RustCrypto/libsodium source/license/ABI, reproducible Android/Windows builds and NIST/libcrux vector agreement for suite `0x0201` | pairwise crypto, contacts, groups |

Resolved planning inputs, still requiring machine schemas/codecs, are:

| Input | Accepted source | Consequence |
| --- | --- | --- |
| mailbox clean-break | `CONTACT-RESOLVER-V1.md` and `RETENTION-AND-RECOVERY-V1.md` | target uses PMT2/PMS2; PMT1/PMS1 remain pre-cutover only |
| invite/prekey service | `CONTACT-RESOLVER-V1.md` | XNode owns two-replica invite/prekey stores; Registry is distribution cache only |
| account freshness | `ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md` | ADC1/ADH1/ADP1/ADL1 are mandatory inputs to new contact/device selection |
| retention/recovery | `RETENTION-AND-RECOVERY-V1.md` | all runtime GC, capacity, recovery UX and time-travel gates consume one matrix |
| route authority | DR-0004 | PMA2/PMT2/PMS2 and XRA1/XRC1/XRR1/XSS1 are the only target graph |
| call allocation | `CALL-SESSION-V1.md` | CallRelay owns capability CAS/allocation; Registry publishes catalog only |
| carrier wires | `CIRCUMVENTION-CARRIERS-V1.md` | RFC 8441 WebSocket/H2, RFC 9298 MASQUE, exact TCP capsule and RFC 9458 OHTTP profiles |
| launch membership | `XPOINT-NETWORK-V1.md` / DR-0004 | XNA1 pins the three founding nodes/witnesses; every post-genesis admission/removal derives from finalized staking and threshold-witnessed XNV1 |

No downstream agent resolves these decisions in implementation code.
