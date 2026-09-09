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
| `FROZEN_TARGET_NOT_ACTIVE` | Exact machine registry and vector obligations exist; concrete generated vectors/evidence may still be activation gates, and release composition does not activate the path. | Only after its activation package passes. |
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

ONION-01 freezes all five replacement records, its schema and hostile vectors as
`FROZEN_TARGET_NOT_ACTIVE`; `runtimeActivation=false`. A later implementation
must atomically replace every old codec and vector. New readers reject every
privacy input beginning `DRF1/DRL1/DRE1/DPR1/DRS1`; they never inspect length or
context and reinterpret it. DNP1 `DRS1/DPR1` keep their exact frozen meanings
and bytes.

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
`../survival-program/releases/v3.0.0/specs/DEEP-CRYPTO-V1-DRAFT.md` and its
machine contract `deep-crypto-v1.registry.json`.

| ID | Canonical name | Required construction | Status |
| ---: | --- | --- | --- |
| `0x0201` | `DHM2-X25519-MLKEM768-TRIPLE-XCHACHA20` | X25519 + ML-KEM-768 hybrid AKE, Ed25519 certificate/prekey authentication, SHA3-256/HMAC-SHA-256 Braid authentication, HKDF-SHA-512, XChaCha20-Poly1305-IETF and Triple Ratchet/SPQR. Classical and PQ branches are both mandatory. | `FROZEN_TARGET_NOT_ACTIVE`; provider/vector/platform gates block activation |
| `0x0202` | `DHM2-FutureHybridAuthentication` | Future long-lived hybrid authentication profile. | `RESERVED` |

No classical-only, PQ-only or environment-selected fallback ID is allocated.
Provider-private serialization is never encoded inside a Deep record.
The clean-break messaging/application registry is split between `E2EE-01`,
`APPLICATION-CORE-CODEC-01` and `ATTACHMENT-CODEC-01`; the old umbrella name
`APPLICATION-CODEC-01` is not a package-complete marker. Suites `0x0101/0x0102`, records
`DPAC/DPDC/DPKB/DPHI` and every `Deep/Handshake/V1/*` domain are
`RETIRED_REJECT`, not compatibility aliases.

### 4.3 XPoint onion suite (`u8`)

Normative source: `../../deep-protocol/docs/deep-extension-privacy-routing-v1.md`.

| ID | Canonical name | Scope | Status |
| ---: | --- | --- | --- |
| `0x01` | `XPointFrameX25519XChaCha20V1` | XRF1 ephemeral X25519/HKDF-SHA-512/XChaCha20-Poly1305 frame bound to network, key owner, role and epoch. | `FROZEN_TARGET_NOT_ACTIVE`; old XSalsa/DRF1 bytes reject; `runtimeActivation=false` |

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
| `XRF1` | Authenticated encrypted frame bound to network/key owner/role/epoch. | `FROZEN_TARGET_NOT_ACTIVE`; old DRF1 rejects |
| `XRL1` | Relay plaintext. | `FROZEN_TARGET_NOT_ACTIVE`; old DRL1 rejects |
| `XRE1` | Exit plaintext. | `FROZEN_TARGET_NOT_ACTIVE`; old DRE1 rejects |
| `XPR1` | HTTP-independent terminal result contained in the sealed exit response. | `FROZEN_TARGET_NOT_ACTIVE`; old DPR1 rejects |
| `XRS1` | reply-key-sealed response plaintext carrying exact XPR1 and zero padding. | `FROZEN_TARGET_NOT_ACTIVE`; old DRS1 rejects |

The implementation package must inventory every existing privacy-routing magic
from source before freeze; no unlisted magic is grandfathered by this row.

### 6.3 Pairwise/application/contact/group records

Owners: exact codecs/vectors in `deep-protocol`; portable state machines in
`deep-client-shared`. Normative sources:
`DEEP-CRYPTO-V1-DRAFT.md` and `CONTACT-AND-GROUP-PROTOCOL-V1.md`.

| Magic | Meaning | Status |
| --- | --- | --- |
| `DPK2` | one atomic signed per-device hybrid prekey offering; inventories are sets of exact DPK2 records. | `FROZEN_TARGET_NOT_ACTIVE`; exact sizes 1,973/2,037 |
| `DPH2` | complete hybrid asynchronous initiation with XPC1 claim binding, actual ML-KEM ciphertext in tag 17 and separate transcript/full-replay hashes. | `FROZEN_TARGET_NOT_ACTIVE`; exact sizes 5,917/18,205/34,589 |
| `DTR2` | embedded-only canonical Double-Ratchet + SPQR/ML-KEM-Braid header carried only in DPE2 tag 6. | `FROZEN_TARGET_NOT_ACTIVE`; exact canonical record sizes 189/285/349/1,149/1,341 |
| `DPE2` | established Triple-Ratchet device envelope with exact DTR2, authenticated counters and per-envelope dedup operation ID. | `FROZEN_TARGET_NOT_ACTIVE`; twenty exact canonical record sizes 4,513..50,705 |
| `MBA1` | local managed ML-KEM-Braid profile plaintext state before protected-store sealing. | `FROZEN_TARGET_NOT_ACTIVE`; never accepted from the network |
| `MBM1` | local managed ML-KEM-Braid state-machine snapshot. | `FROZEN_TARGET_NOT_ACTIVE`; never accepted from the network |
| `TRC1` | local managed Triple-Ratchet component-provider snapshot. | `FROZEN_TARGET_NOT_ACTIVE`; never accepted from the network |
| `TRS1` | complete account-scoped durable Triple-Ratchet session state. | `FROZEN_TARGET_NOT_ACTIVE`; never accepted from the network; maximum 2 MiB |
| `DMD1` | account-authorized messaging device directory. | `FROZEN_TARGET_NOT_ACTIVE`; exact `356+70*N`, `N=1..16` |
| `DID1` | permanent transport-neutral Deep ID containing address key plus read capability; no expiry. | `FROZEN_TARGET_NOT_ACTIVE`; exact 76 bytes, canonical Bech32m projection |
| `DAB1` | dual-signed permanent-address/current-account binding lineage. | `FROZEN_TARGET_NOT_ACTIVE`; exact 394 bytes; application ArtifactRef type `0x1001` |
| `DCA1` | device authorization to publish rotating contact bundles for exact DID1/DAB1. | `FROZEN_TARGET_NOT_ACTIVE`; exact 473 bytes |
| `DCB1` | signed contact bundle. | `FROZEN_TARGET_NOT_ACTIVE`; CONTACT-CODEC-01 |
| `DCR1` | exact resolver closure around DCB1/DRS1/DPD1 support objects. | `FROZEN_TARGET_NOT_ACTIVE`; service/runtime remain inactive |
| `DIA1` | expiring one-time invitation locator; never the permanent Deep ID. | `FROZEN_TARGET_NOT_ACTIVE`; CONTACT-CODEC-01 |
| `DAO1` | metadata-sealed asynchronous deposit object containing DPH2 or DPE2. | `FROZEN_TARGET_NOT_ACTIVE`; exact inner-size-derived set |
| `DMC2` | canonical pairwise application event plaintext. | `FROZEN_TARGET_NOT_ACTIVE` for base kinds 1, 5..13, 18..19 and CONTACT-CODEC-01 kinds 2..4,14; all other allocated kinds `RESERVED_REJECT` until owner package freeze |
| `DGP1` | signed group membership proposal. | `FROZEN_TARGET_NOT_ACTIVE`; GROUP-CODEC-01 |
| `DGC1` | owner-sequenced group commit. | `FROZEN_TARGET_NOT_ACTIVE`; GROUP-CODEC-01 |
| `DGM1` | group application event nested in DMC2 per-device fanout. | `FROZEN_TARGET_NOT_ACTIVE`; GROUP-CODEC-01 |
| `DAM1` | encrypted attachment manifest carried inside DMC2/DGM1. | `FROZEN_TARGET_NOT_ACTIVE`; exact `270+40*N+F+M`, runtime blocked by BLOB-01 |
| `DGT1` | emergency owner-sequencer transfer authorization. | `FROZEN_TARGET_NOT_ACTIVE`; GROUP-CODEC-01 |
| `GCP1` | hash-closed group commit/support package. | `FROZEN_TARGET_NOT_ACTIVE`; GROUP-CODEC-01 |
| `GIV1` | pending group invitation; does not grant membership. | `FROZEN_TARGET_NOT_ACTIVE`; GROUP-CODEC-01 |
| `GIA1` | invitee-signed acceptance of one exact GIV1. | `FROZEN_TARGET_NOT_ACTIVE`; GROUP-CODEC-01 |
| `GCF1` | authenticated chunk frame for one exact GCP1 package. | `FROZEN_TARGET_NOT_ACTIVE`; GROUP-CODEC-01 |
| `GSR1` | per-recipient opaque long-offline group-control rendezvous. | `FROZEN_TARGET_NOT_ACTIVE`; GROUP-CODEC-01 |
| `GSW1` | group-control chunk CAS write. | `FROZEN_TARGET_NOT_ACTIVE`; GROUP-CODEC-01 |
| `GSQ1` | bounded group-control catch-up query. | `FROZEN_TARGET_NOT_ACTIVE`; GROUP-CODEC-01 |
| `GSS1` | closed group-control write/fetch result. | `FROZEN_TARGET_NOT_ACTIVE`; GROUP-CODEC-01 |
| `GLS1` | local restart-safe group lineage/fork-latch snapshot; never accepted from the network. | `FROZEN_TARGET_NOT_ACTIVE`; GROUP-CODEC-01 |
| `DPAC` | retired account certificate record; not an alias. | `RETIRED_REJECT` |
| `DPDC` | retired device certificate record; not an alias. | `RETIRED_REJECT` |
| `DPKB` | retired key-bundle record; not an alias. | `RETIRED_REJECT` |
| `DPHI` | retired handshake-init record; not an alias. | `RETIRED_REJECT` |
| `DPE1` | retired envelope record; not an alias. | `RETIRED_REJECT` |
| `DMC1` | retired message-cipher record; not an alias. | `RETIRED_REJECT` |

`GCP1` is the exact package containing DGC1 and all referenced
DGP1/DMD1/DRS1/DPD1/transparency objects. DGC1 alone is not sufficient input
to materialize a commit.

`DCB1`, `DCR1` and `DIA1` have frozen target bytes under CONTACT-CODEC-01;
the machine manifest and vector set bind their XPS1/XIR1/ADL1 and resolver
closure dependencies. They are not runtime-active and no old umbrella
APPLICATION-CODEC-01 completion follows from this package freeze.

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
| `ADF1` | root-authorized beyond-horizon account-directory forward checkpoint. | `TARGET_UNFROZEN` |
| `AFP1` | exact authority/ADF/source-membership proof package for ADP1 forward mode. | `TARGET_UNFROZEN` |
| `DTS1` | root-signed closed authenticated-time-source policy committed by the directory witness policy. | `TARGET_UNFROZEN` |
| `DTT1` | nonce-bound threshold-signed live time/current ADH1/XNV1 attestation. | `TARGET_UNFROZEN` |

These records are mandatory freshness inputs to first contact and group member
directory verification. A valid old DMD1 signature without a current ADP1/ADH1
proof cannot authorize a new prekey claim or group commit.

### 6.5 XPoint network and contact reachability records

Owner: exact codecs/vectors in `deep-protocol`; publishers and runtimes as noted.
Normative source: `XPOINT-NETWORK-V1.md`.

| Magic | Meaning | Runtime owner | Status |
| --- | --- | --- | --- |
| `XNA1` | network root/authority lineage. | offline authority tooling + client verifier | `FROZEN_TARGET_NOT_ACTIVE` |
| `XVP1` | root-signed closed role/routing/mailbox/circuit/circumvention network policy. | offline authority tooling authors; witnesses consume | `FROZEN_TARGET_NOT_ACTIVE` |
| `XND1` | signed node descriptor and role/key/failure-domain projection. | node authors; witnesses publish | `FROZEN_TARGET_NOT_ACTIVE` |
| `XNV1` | threshold-signed canonical network-view candidate; deterministic staking-membership completeness is an explicit activation gate. | witness publisher; client verifies | `FROZEN_TARGET_NOT_ACTIVE` |
| `XNH1` | threshold-witnessed network-view transparency head. | witness publisher; clients gossip | `FROZEN_TARGET_NOT_ACTIVE` |
| `XNP1` | bounded XNV inclusion/consistency proof manifest using typed core refs. | mirrors publish; clients verify | `FROZEN_TARGET_NOT_ACTIVE` |
| `XNF1` | root-authorized beyond-horizon network-view forward checkpoint. | offline root tooling authors; mirrors publish; clients verify | `FROZEN_TARGET_NOT_ACTIVE` |
| `NFP1` | bounded authority/checkpoint/source-membership proof manifest for XNF1 merge. | mirrors package; clients verify | `FROZEN_TARGET_NOT_ACTIVE` |
| `XIR1` | long-lived invite rendezvous embedded in DCB1; never a current message deposit route. | contact owner authors; selected invite-store pair hosts | `FROZEN_TARGET_NOT_ACTIVE`; CONTACT-CODEC-01 |
| `XRR1` | short-lived established-contact/message deposit reachability. It is not a public Deep ID artifact. | contact owner authors; selected mailbox pair hosts | `FROZEN_TARGET_NOT_ACTIVE`; CONTACT-CODEC-01 |
| `XUR1` | established-contact update rendezvous capability/record. | contact owner authors; update-rendezvous service hosts | `FROZEN_TARGET_NOT_ACTIVE`; CONTACT-CODEC-01 |
| `XCP1` | local protected client path plan. Never uploaded. | `deep-client-shared` | `TARGET_UNFROZEN`; local DB generation only |
| `XCD1` | signed CallRelay target-auth plus replica/quorum authority descriptor with exact per-node CallRelay role-key generations and proofs of possession. | CallRelay authors; XNV1 witnesses authorize/publish the exact core ref | `FROZEN_TARGET_NOT_ACTIVE`; exact codec owner is NETCODEC-01 |
| `XRA1` | long-lived recipient reachability authorization. | recipient authors; directory threshold verifies | `FROZEN_TARGET_NOT_ACTIVE`; CONTACT-CODEC-01 |
| `XRC1` | short-lived XNV/PMT/PMS-bound live route closure. | directory threshold authors | `FROZEN_TARGET_NOT_ACTIVE`; CONTACT-CODEC-01 |
| `XSS1` | retained route successor/checkpoint closure. | route stores/witnesses | `FROZEN_TARGET_NOT_ACTIVE`; CONTACT-CODEC-01 |

The nine frozen rows above are machine-owned by
[`xpoint-network-v1.registry.json`](../survival-program/releases/v3.0.0/specs/xpoint-network-v1.registry.json)
plus its closed schema and vector-manifest skeleton. Their frozen status defines
bytes only; all activation booleans remain false. Other records in this section stay
unfrozen. Records whose normative field/signature owner is `XPOINT-NETWORK-V1.md` use the exact
canonical tagged grammar in `DEEP-CRYPTO-V1-DRAFT.md` section 3.2, with version
1. Ordinary network records use suite `0x0201`; root-authority XNA1/XVP1/XNF1
records use suite `0x0001` and the exact `/root` signature domains in their
normative tables. An ordinary network signature covers
`SIGINPUT("Deep/XPoint/V1/" || magicASCII, 0x0201, unsignedCanonicalRecord)`;
multi-witness records sort `(witnessId32, signature64)` by witness ID and every
witness signs the identical unsigned bytes. A separately inferred network
grammar, omitted suite, context-dependent magic or alternate signature input
rejects. This is a frozen architecture choice; NETCODEC-01 supplies machine
  schemas/vectors, not a new decision. Typed `ArtifactRef38` and `CoreRef38` are
  distinct; proof manifests carry refs and separately supplied exact closures rather
  than nesting records that could exceed the 65,535-byte canonical limit.

### 6.6 Contact resolver and prekey service records

Owner: exact codecs/vectors in `deep-protocol`; service runtime in `xnode`;
client author/verification/orchestration in `deep-client-shared`.
Normative source: `CONTACT-RESOLVER-V1.md`.

| Magic | Meaning | Status |
| --- | --- | --- |
| `XPU1` | compare-and-swap publication of encrypted DCR1 at an opaque invite locator. | `TARGET_UNFROZEN` |
| `XPO1` | closed publication outcome for one XPU1 operation. | `TARGET_UNFROZEN` |
| `XPA1` | short-lived directory-threshold authorization for one opaque XPU1 publication; exposes no Deep ID/account/device. | `TARGET_UNFROZEN` |
| `XIQ1` | idempotent permanent-address resolve or one-time invite claim request. | `TARGET_UNFROZEN` |
| `XIS1` | closed invite resolve result with exact-replay semantics. | `TARGET_UNFROZEN` |
| `XPS1` | signed per-device prekey service descriptor carried by DCB1. | `TARGET_UNFROZEN` |
| `XPI1` | device-signed complete DPK2 inventory manifest with ordered Merkle commitment. | `TARGET_UNFROZEN` |
| `XPP1` | bounded atomic publication of one exact XPI1 and its complete DPK2 inventory to both placement replicas. | `TARGET_UNFROZEN` |
| `XIC1` | replica-signed durable XPI1 inventory commit receipt. | `TARGET_UNFROZEN` |
| `XPK1` | atomic one-time/last-resort prekey claim request. | `TARGET_UNFROZEN` |
| `XPC1` | witnessed prekey claim/replay/failure result bound into DPH2. | `TARGET_UNFROZEN` |
| `XUW1` | established-contact encrypted successor/update publication. | `TARGET_UNFROZEN` |
| `XUQ1` | established-contact successor/update query. | `TARGET_UNFROZEN` |
| `XUS1` | closed established-contact update result. | `TARGET_UNFROZEN` |

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
| `XBA1` | signed, purpose/binding/time-bounded random bearer bridge-access token. | `TARGET_UNFROZEN` |
| `XOD1` | signed purpose-bound RFC 9458 Relay/Gateway/HPKE resource descriptor. | `TARGET_UNFROZEN` |
| `XOQ1` | closed purpose-discriminated decrypted OHTTP application request. | `TARGET_UNFROZEN` |
| `XOR1` | closed operation-bound decrypted OHTTP application result. | `TARGET_UNFROZEN` |
| `XHC1` | HTTPS-stream authenticated client hello. | `TARGET_UNFROZEN` |
| `XHA1` | HTTPS-stream gateway acceptance/challenge. | `TARGET_UNFROZEN` |
| `MPC1` | MASQUE gateway challenge bound to one signed CallRelay destination. | `TARGET_UNFROZEN` |
| `MPA1` | CallRelay target-auth response for one exact MPC1 and socket destination. | `TARGET_UNFROZEN` |

### 6.8 Call records

Owner: codecs in `CALL-CODEC-01` (`deep-protocol`), server
capability/CAS/allocation runtime in `CALL-RELAY-01` (`xnode`), client state
machine in `deep-client-shared` and deployment/evidence in `BRIDGE-01`.
Source: `CALL-SESSION-V1.md`.

| Magic | Meaning | Status |
|---|---|---|
| `CAC1` | capability-based multi-device answer-winner CAS. | `TARGET_UNFROZEN` |
| `CAO1` | quorum-bound closed outcome for one CAC1 request. | `TARGET_UNFROZEN` |
| `CMD1` | E2EE-carried closed WebRTC media suite/ICE/DTLS/SRTP/codec description. | `TARGET_UNFROZEN` |
| `CAR1` | participant-specific CallRelay allocation request. | `TARGET_UNFROZEN` |
| `CAA1` | peer-verifiable quorum-signed public allocation response; contains no raw allocation capability. | `TARGET_UNFROZEN` |
| `CAL1` | owner-only sealed allocation result carrying exact CAA1 plus its raw allocation capability. | `TARGET_UNFROZEN` |

### 6.9 Mailbox/continuity records

Owner: `deep-protocol`. Current sources are the production-mailbox extension
documents under `../../deep-protocol/docs/`.

| Magic/set | Current meaning | Target status |
| --- | --- | --- |
| `PMA1`, `PMT1`, `PMS1` | Existing mailbox authority, topology and deterministic selection. | `CURRENT_PRE_CUTOVER`; not accepted as the target XNV-bound placement generation. |
| `PRA1`, `PSS1` | Pre-continuity advertisement/successor. | `RETIRED_REJECT` in new contacts/runtime. |
| `RCD1`, `RDA1`, `RCR1`, `RHC1`, `RTC1`, `RCA1`, `PRA2`, `PSS2` | Existing owner/delegated route-continuity V2 closure. | `CURRENT_PRE_CUTOVER` and `RETIRED_REJECT` after reset; DR-0004 ports semantics to XRA1/XRC1/XSS1. |
| `PMA2`, `PMT2`, `PMS2` | DR-0004 clean-break threshold authority, XNV1-bound projection and deterministic blinded selection. | `PMT2/PMS2` are `FROZEN_TARGET_NOT_ACTIVE` under CONTACT-CODEC-01; PMA2 remains NETCODEC dependency. |
| `XRA1`, `XRC1`, `XRR1`, `XSS1` | DR-0004 owner authorization, live route, shared reachability and retained successor closure. | `FROZEN_TARGET_NOT_ACTIVE`; pre-cutover continuity records reject. |

DR-0004 is immutable for this generation. `XRR1` alone is not a routable deposit
closure; the exact XRA1/XRC1/XRR1/XSS1 plus PMT2/PMS2 closure in the contact/XPoint
specifications is mandatory. Implementations may not reopen or replace that choice.

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
| `CRYPTO-01` selected provider evidence | pinned `mlkem-native` v2.0.0/libsodium source, license and narrow C ABI; reproducible Android/Windows builds and NIST/libcrux/Bouncy vector agreement for suite `0x0201` | pairwise crypto, contacts, groups |

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
