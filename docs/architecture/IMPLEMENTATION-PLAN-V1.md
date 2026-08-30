# Deep/XPoint V1 Implementation Plan

Status: **normative implementation DAG; no package is complete by specification alone**
Date: 2026-08-30
Scope: first public Android/Windows release using `OfficialXPoint3`

## 1. Execution contract

This plan decomposes the clean-break release into bounded packages suitable for
independent coding agents. It does not reduce the final release scope. It adds
intermediate compile, vector and integration gates so that agents do not build
against guessed APIs or temporary production fallbacks.

Rules for every package:

1. `ownerRepository` is the only repository in which the package authors
   production code. A consumer change is a separate package or a separately
   reviewed follow-up owned by that consumer.
2. An agent starts only when every `dependsOn` package has a reviewed local
   commit and its produced artifact/API is available at the exact commit hash.
3. `consumes` are immutable inputs. If an input is ambiguous or changed, the
   package stops; it does not create a compatibility adapter.
4. `produces` are the complete handoff to downstream packages. A prose-only
   result cannot satisfy a codec, provider, database or runtime dependency.
5. Wire and public APIs are closed. Unknown values and hostile sizes reject
   before cryptography, allocation, network callbacks and mutation.
6. DB changes create one new clean-break generation. There are no migrations,
   legacy readers, aliases, dual writes or downgrade paths.
7. Each package updates its own repository `AGENTS.md`, architecture/readme and
   runbook when ownership or executable behavior changes. Stale instructions
   cannot remain as the first document a later agent reads.
8. Each implementation package includes cancellation, bounded resources,
   restart/crash points, logging redaction and `git diff --check`.
9. Cross-repository integration evidence names the exact producer and consumer
   commits. Unreviewed working-tree bytes are not an API contract.
10. No package pushes, publishes or deploys production without separate user
    authorization.

## 2. Dependency overview

```text
GOV-01 ───────────────┐
CRYPTO-01 ────────────┼─> REG-01
ARCH-01 ──────────────┘

REG-01 -> ID-01 -> STORE-01
REG-01 + ID-01 + CRYPTO-01 -> E2EE-01 -> APPLICATION-CODEC-01
STORE-01 + E2EE-01 + APPLICATION-CODEC-01 -> MSG-01 -> DEVICE-01

REG-01 + ARCH-01 -> NETCODEC-01
REG-01 + NETCODEC-01 -> CARRIER-CODEC-01 -> CARRIER-CATALOG-01
GOV-01 + NETCODEC-01 + CARRIER-CATALOG-01 -> ROOT-CHECKPOINT-01 -> DIRECTORY-01
NETCODEC-01 ───────────────────────────────> DIRECTORY-01
                              \-> XNODE-01 -> ROUTE-01
REG-01 + NETCODEC-01 + XNODE-01 -> ONION-01 -> ROUTE-01

CARRIER-CODEC-01 -> SUPERVISOR-01
CARRIER-CODEC-01 + XNODE-01 -> CARRIER-GATEWAY-01
CARRIER-CATALOG-01 + CARRIER-CODEC-01 -> BRIDGE-DISTRIBUTOR-01
SUPERVISOR-01 -> REALITY-01
SUPERVISOR-01 -> HTTPS-01
DIRECTORY-01 + CARRIER-CATALOG-01 + CARRIER-GATEWAY-01 + BRIDGE-DISTRIBUTOR-01 + REALITY-01 + HTTPS-01 -> BRIDGE-01
ROUTE-01 + REALITY-01 + HTTPS-01 + BRIDGE-01 -> official XPoint path

APPLICATION-CODEC-01 + E2EE-01 + NETCODEC-01 -> CONTACT-CODEC-01
DIRECTORY-01 + CONTACT-CODEC-01 -> ACCOUNT-DIRECTORY-AUTH-01
DEVICE-01 + ROUTE-01 + ACCOUNT-DIRECTORY-AUTH-01 -> DIRECTORY-CLIENT-01
CONTACT-CODEC-01 + XNODE-01 + ACCOUNT-DIRECTORY-AUTH-01 -> CONTACT-SERVICE-01
MSG-01 + DIRECTORY-CLIENT-01 + ROUTE-01 + CONTACT-SERVICE-01 -> CONTACT-CLIENT-01

CONTACT-CODEC-01 + DEVICE-01 -> GROUP-CODEC-01
GROUP-CODEC-01 + XNODE-01 -> GROUP-CONTROL-SERVICE-01
GROUP-CODEC-01 + GROUP-CONTROL-SERVICE-01 + CONTACT-CLIENT-01 + MSG-01 -> GROUP-CLIENT-01
MSG-01 + ROUTE-01 -> BLOB-01
MSG-01 + ROUTE-01 -> PUSH-01
APPLICATION-CODEC-01 + CARRIER-CODEC-01 + NETCODEC-01 -> CALL-CODEC-01
CONTACT-CLIENT-01 + MSG-01 + CALL-CODEC-01 -> CALL-SIGNAL-01
CALL-CODEC-01 + XNODE-01 + DIRECTORY-01 -> CALL-RELAY-01
CALL-SIGNAL-01 + CALL-RELAY-01 + BRIDGE-01 -> CALL-MEDIA-01

all runtime packages -> COMPOSE-01 -> E2E-01
```

The shortest useful vertical milestone is:

```text
offline account -> loopback ratchet/outbox -> one-carrier three-hop text
-> arbitrary offline contact -> second carrier/rotation -> groups/files/push
-> relay-only calls -> full evidence
```

## 3. Package catalogue

### GOV-01 — canonical scope, names and ownership alignment

- **ownerRepository:** `XPointLabs` superproject documentation.
- **dependsOn:** none.
- **consumes:** `AGENTS.md`, `docs/architecture/*.md`, `docs/NEXT-SPRINT.md`,
  accepted DR-0003.
- **produces:** reviewed canonical-name decisions from
  `PROTOCOL-REGISTRY-V1.md`; one `release-scope.v1.json` schema/fixture; corrected
  superproject repository map; explicit target/current status policy.
- **wire/API:** no runtime wire; freezes public names and package ownership only.
- **DB impact/removals:** none. Removal list names stale interface, carrier and
  call aliases plus old iOS/disjoint/exactly-once release claims.
- **unit gate:** Markdown local-link check, registry duplicate-name check and
  JSON-schema validation for the release-scope fixture.
- **integration consumer/evidence:** every package consumes the reviewed GOV-01
  commit; evidence is a scope manifest listing required platforms, suites,
  profiles, features, scenarios and evidence schemas.

### CRYPTO-01 — production provider and ABI decision

- **ownerRepository:** `deep-protocol`.
- **dependsOn:** none.
- **consumes:** FIPS 203 KATs/errata, Signal PQXDH and Triple Ratchet/SPQR
  references, `PQ-PROVIDER-FEASIBILITY.md`, Android arm64 and Windows x64/arm64
  build environments.
- **produces:** accepted provider decision; pinned source/package/commit hashes;
  license/provenance/SBOM; narrow memory-safe managed ABI; reproducible native
  build scripts; two-provider KAT/interoperability and malformed-input results;
  CPU/memory/package/battery budgets.
- **wire/API:** provider API accepts/returns Deep-owned key/value types only;
  upstream serialization never crosses it. Suite `0x0201` is indivisible.
- **DB impact/removals:** no production private-key persistence in the spike.
  Remove/reject dark providers and suite `0x0101/0x0102` from production graph.
- **unit gate:** KAT equality, all-zero/shared-secret and malformed ciphertext
  negatives, ABI cancellation/fault/zeroization tests, reproducible hash match,
  physical Android and Windows benchmark app.
- **integration consumer/evidence:** E2EE-01; signed dependency decision,
  benchmark JSON, license decision and SBOM fragment.

### ARCH-01 — immutable architecture consistency and feasibility gate

- **ownerRepository:** `XPointLabs` superproject documentation.
- **dependsOn:** GOV-01.
- **consumes:** immutable DR-0004 and accepted call/carrier/account-directory
  contracts from `PROTOCOL-REGISTRY-V1.md`,
  `ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md`, `CONTACT-RESOLVER-V1.md`,
  `RETENTION-AND-RECOVERY-V1.md`, current route-continuity specs and capacity
  estimates.
- **produces:** consistency manifest proving one owner/source for D0 inputs,
  PMT2/PMS2 clean break, XNode services, CallRelay authority and carrier wires;
  capacity feasibility report for the accepted retention matrix. It cannot
  select alternate wire/security semantics.
- **wire/API:** authors no protocol bytes or new architecture choice.
- **DB impact/removals:** verifies DR-0004 destructive reset/removal list; no
  migration may be introduced.
- **unit gate:** cross-reference checker proves every accepted record is closed,
  owner-resolved, cycle-free and capacity-feasible with no contradictory claim.
- **integration consumer/evidence:** REG-01, NETCODEC-01, CONTACT-CODEC-01,
  CARRIER-CODEC-01 and CALL-CODEC-01 consume exact manifest/source hashes.

### REG-01 — machine-readable V1 registry and code generation

- **ownerRepository:** `deep-protocol`.
- **dependsOn:** GOV-01, CRYPTO-01, ARCH-01.
- **consumes:** `PROTOCOL-REGISTRY-V1.md`, frozen DNP1 registry and every accepted
  normative source.
- **produces:** `deep-protocol-v1.registry.json` plus schema; generated magic,
  suite, carrier, deployment, call-name and interface constants; collision and
  source-coverage tests; retired-value manifest.
- **wire/API:** generated values are the sole source constants; no hand-authored
  duplicate enum or string table.
- **DB impact/removals:** none. Retired values become negative fixtures.
- **unit gate:** registry schema, global magic collision, scoped numeric
  collision, implementation-constant coverage, stale-alias and max+1 tests.
- **integration consumer/evidence:** all codec/runtime packages; generated
  registry hash and test report become release evidence.

### ID-01 — promote frozen DNP1 identity/recovery records

- **ownerRepository:** `deep-protocol`.
- **dependsOn:** REG-01, CRYPTO-01.
- **consumes:** frozen DNP1 registry/vectors and DeepRecoveryV1 requirements.
- **produces:** release-referenced DPA1/DPD1/DRS1/DRA1 verification and authoring
  surface; 24-word recovery/KDF vectors; independent device-key generation;
  sealed recovery/account/device capabilities.
- **wire/API:** exact frozen DNP1 bytes only. Ed25519/X25519 conversion and raw
  recovery-root accessors are absent.
- **DB impact/removals:** defines new secure-storage slot identifiers and
  clean-break key roles; no consumer DB mutation yet. Remove Session/13-word
  and dark DPAC/DPDC production package edges.
- **unit gate:** complete DNP1 focused suite, recovery golden/negative vectors,
  key-role substitution and production package graph scans.
- **integration consumer/evidence:** STORE-01 and E2EE-01; exact package hashes,
  public API inventory and vector manifest.

### STORE-01 — offline account/device store and destructive DB generation

- **ownerRepository:** `deep-client-shared`.
- **dependsOn:** ID-01.
- **consumes:** sealed identity/device capabilities, secure-storage abstraction
  and canonical account/device IDs.
- **produces:** new SQLCipher schema generation; atomic account/device/local
  profile transaction; restore-as-new-device pending state; in-memory parity;
  network-free account service.
- **wire/API:** portable account APIs perform no DNS, Registry, XPoint,
  certificate or bootstrap callback before local commit.
- **DB impact/removals:** destructive new DB magic/version; new identity,
  device, protected LKG, outbox/inbox and security-event roots. Old schema,
  Session rows and JSON import readers reject; no migration table exists.
- **unit gate:** SQLite/in-memory parity, airplane-mode create/restore,
  crash-before/after transaction, wrong-generation rejection and corruption
  quarantine.
- **integration consumer/evidence:** E2EE-01, MSG-01, DEVICE-01 and COMPOSE-01;
  DB schema fingerprint and airplane-mode test artifact.

### E2EE-01 — hybrid asynchronous AKE and Triple Ratchet engine

- **ownerRepository:** `deep-protocol`.
- **dependsOn:** CRYPTO-01, REG-01, ID-01.
- **consumes:** suite `0x0201` provider, DPA1/DPD1 verification and messaging
  crypto specification.
- **produces:** DPK2/DPH2/DPE2 schemas/codecs/vectors; signed-prekey and
  one-time-prekey state primitives; hybrid transcript; Triple Ratchet with
  bounded skipped keys, periodic PQ injection, replay rejection and sealed
  transactional transition plans.
- **wire/API:** Deep canonical records only; ordinary messages have no
  transferable long-term signature; no classical/PQ fallback.
- **DB impact/removals:** returns sealed state deltas and deletion obligations,
  never opens client DB. Remove DPE1 sealed-CEK and Ed25519-to-X25519 paths.
- **unit gate:** two independent vector implementations, out-of-order/skipped
  bounds, message-key deletion, simultaneous initiation, tamper/replay,
  compromise/PCS drill and hostile parser corpus.
- **integration consumer/evidence:** MSG-01, DEVICE-01 and CONTACT-CODEC-01;
  vector package and independent crypto review input.

### APPLICATION-CODEC-01 — identity-facing application and event codecs

- **ownerRepository:** `deep-protocol`.
- **dependsOn:** REG-01, ID-01, E2EE-01.
- **consumes:** DID1/DAB1/DMD1/DCA1/DCB1/DCR1/DIA1/DAO1/DMC2/DAM1
  normative tables, exact DPK2/DPH2/DPE2 refs and the canonical tagged grammar.
- **produces:** exact schemas/codecs/vectors for every consumed magic; closed
  numeric DMC2 kind registry and byte grammar for every kind payload; DAB1
  realm-lineage checks; DAM1 chunk arithmetic; retired address/event negative
  vectors.
- **wire/API:** no kind exposes an untyped blob to application code. Unknown
  kind/field/enum, mismatched authenticated sender/context and max+1 reject
  before callback or mutation.
- **DB impact/removals:** pure immutable values/sealed transition inputs. No
  persistence or network callback.
- **unit gate:** positive/cross-kind/substitution/hostile-size vectors, exact
  payload-length arithmetic, DID text round-trip and retired-format rejection.
- **integration consumer/evidence:** MSG-01, DEVICE-01, CONTACT-CODEC-01,
  GROUP-CODEC-01, BLOB-01 and CALL-SIGNAL-01; generated codec/vector manifest.

### MSG-01 — canonical events, logical outbox/inbox and dedup

- **ownerRepository:** `deep-client-shared`.
- **dependsOn:** STORE-01, E2EE-01, APPLICATION-CODEC-01, REG-01.
- **consumes:** DMC2 codec, sealed ratchet transitions, canonical semantic IDs
  and transport-neutral interface names.
- **produces:** application-event registry service; durable logical
  outbox/inbox; per-attempt state; `OutcomeUnknown` reconciliation; semantic
  dedup/fork latch; receipts and retention/tombstones.
- **wire/API:** implements `IMessageDeliveryTransport` orchestration without an
  XPoint type. Stable semantic event ID is distinct from attempt/dedup tokens.
- **DB impact/removals:** new event/outbox/attempt/inbox/dedup/tombstone tables
  with atomic ratchet+materialization commits. Remove current Session-derived
  message rows and network-level exactly-once assumptions.
- **unit gate:** 10,000 deterministic crash/fault windows, duplicate/reorder,
  changed-bytes same-ID fork, expiry/cancellation and SQLite/in-memory parity.
- **integration consumer/evidence:** CONTACT-CLIENT-01, GROUP-CLIENT-01,
  BLOB-01, PUSH-01 and CALL-SIGNAL-01; state-machine trace artifact.

### DEVICE-01 — multi-device enrollment, revocation and convergence

- **ownerRepository:** `deep-client-shared`.
- **dependsOn:** STORE-01, E2EE-01, APPLICATION-CODEC-01, MSG-01.
- **consumes:** DMD1/DPD1/DRS1 codecs, per-device ratchet sessions and accepted
  retention/recovery decision.
- **produces:** device directory store; phrase/QR/file enrollment orchestration;
  self-device fanout; bounded directory repair; eventual revoke/rekey; explicit
  encrypted history-transfer/backup policy.
- **wire/API:** recovery creates a new device; it never clones private keys or
  ratchet DB. Returning-device and phrase-on-new-device outcomes are distinct.
- **DB impact/removals:** device-directory lineage, session-per-device and
  security-event tables. Remove shared account-private messaging key and
  implicit history cloning.
- **unit gate:** add/revoke while offline and mid-fanout, stale directory,
  at-most-two repair loops, backup/no-backup recovery and revoked-target tests.
- **integration consumer/evidence:** CONTACT-CLIENT-01, GROUP-CODEC-01 and
  CALL-SIGNAL-01; multi-device convergence traces.

### NETCODEC-01 — XPoint authority, node, view, reachability and call codecs

- **ownerRepository:** `deep-protocol`.
- **dependsOn:** REG-01, ARCH-01.
- **consumes:** accepted membership/call decisions, XPOINT-NETWORK-V1,
  `ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md`, `CONTACT-RESOLVER-V1.md` and DR-0004.
- **produces:** exact XNA1/XVP1/XND1/XNV1/XNH1/XNP1/XNF1/NFP1,
  ADC1/ADH1/ADP1/ADL1/ADF1/AFP1/DTS1/DTT1, XRA1/XRC1/XRR1/XSS1/XCD1 and
  PMA2/PMT2/PMS2 schemas, codecs, bounds, signatures, predecessor rules,
  selection/proof primitives and vectors.
- **wire/API:** pure author/verify/selection functions; no fetch, signer key,
  endpoint connection, database or callback authority.
- **DB impact/removals:** none. Legacy static bootstrap JSON becomes a negative
  fixture, not an input.
- **unit gate:** deterministic agreement in two implementations; wrong-network,
  rollback/fork, time, failure-domain, selection and hostile-size vectors.
- **integration consumer/evidence:** ROOT-CHECKPOINT-01, DIRECTORY-01, XNODE-01, ROUTE-01,
  CONTACT-CODEC-01 and CARRIER-CODEC-01; vector manifest.

### ROOT-CHECKPOINT-01 — offline root forward-checkpoint authoring

- **ownerRepository:** `deep-devops`.
- **dependsOn:** GOV-01, NETCODEC-01, CARRIER-CATALOG-01.
- **consumes:** offline XNA1 root custody policy, exact retained-source sets,
  accepted closed network-policy input plus exact current XCCCoreRef38 from
  CARRIER-CATALOG-01, resolved fork evidence and canonical
  XVP1/XNF1/ADF1 codecs.
- **produces:** offline threshold-signed XVP1, XNF1 and ADF1 bytes; reproducible NFP1/
  AFP1 source-membership fixtures; signer ceremony/evidence with no online root key.
- **wire/API:** tooling signs only complete deterministic covered-head sets and
  strictly newer targets. It cannot sign messages, routes or account/device state.
- **DB impact/removals:** offline ceremony manifests and public checkpoint bytes;
  no client identity/contact/content database.
- **unit gate:** omitted source, changed ordering, wrong authority lineage,
  same-generation fork, two successors, threshold partial failure and deterministic
  re-run equality.
- **integration consumer/evidence:** DIRECTORY-01 publishes; ROUTE-01 and
  DIRECTORY-CLIENT-01 verify/merge; root-custody audit artifact.

### DIRECTORY-01 — deterministic view/witness publication

- **ownerRepository:** `deep-registry-api`.
- **dependsOn:** NETCODEC-01, ROOT-CHECKPOINT-01, CARRIER-CODEC-01.
- **consumes:** finalized membership/admission input selected by ARCH-01,
  exact current XVP1, signed XND1/ADC1 objects, previous XNV1/XNH1/ADH1 and exact
  DTS1/witness policies and exact current XCC/XBB catalog from
  CARRIER-CATALOG-01.
- **produces:** byte-identical XNV1 and account-directory ADH1 derivation/
  publication; atomic append-log/current-value-map transition; ADP1 current
  value/non-membership plus inclusion/consistency proof service; witness
  coordination; exact XOQ1/XOR1 AccountDirectory and LiveTimeAttestation target
  exchanges, including the target-owned atomic operation/request/result ledger;
  nonce-bound live DTT1 current-head/time attestations; XNF1/ADF1
  checkpoint and NFP1/AFP1 proof publication; append-only histories; mirror
  endpoints; fork evidence; health
  input kept separate from identity facts.
- **wire/API:** Registry never selects a per-client route and never rewrites a
  signed node descriptor. It does not host a call signaling inbox.
- **DB impact/removals:** new network-view, opaque account-directory leaf/head,
  proof-history, witness and fork-latch tables; remove per-user route assignment
  and legacy call signal state from the target generation.
- **unit gate:** deterministic publisher replicas, 2-of-3 witness, withholding,
  same-generation fork, rollback, restart/corruption and 400-day fixtures.
- **integration consumer/evidence:** ROUTE-01, BRIDGE-DISTRIBUTOR-01 and BRIDGE-01; byte-identical
  three-mirror artifact and consistency proof.

### ACCOUNT-DIRECTORY-AUTH-01 — account checkpoint and publication authority

- **ownerRepository:** `deep-registry-api`.
- **dependsOn:** DIRECTORY-01, CONTACT-CODEC-01, NETCODEC-01,
  CARRIER-CODEC-01.
- **consumes:** exact identity/device/revocation/address closures, directory
  map/log head, DID locator rules, XPA1/XPU1 request schemas and exact
  XOQ1/XOR1 AccountDirectory exchange.
- **produces:** validation/admission of account-authored ADC1, atomic directory
  map/log CAS, threshold XPA1 one-operation issuance/consume/exact-replay,
  signer custody/process separation, durable authorization/fork state and
  sanitized proof APIs.
- **wire/API:** the service never authors or substitutes ADC1: it verifies the
  exact DPA1 device-issuer signature and admits those bytes atomically into the
  current map plus append log. XPA1 binds one operation ID and exact XPU request
  hash; no threshold member receives resolver read capability.
- **DB impact/removals:** checkpoint predecessor/CAS, map-log transaction,
  authorization issue/consume/replay and fork-latch tables. No invite ciphertext
  or requester IP is retained.
- **unit gate:** stale-current inclusion attack, threshold partial failure,
  same-generation fork, crash at map/log and XPA consume boundaries, wrong
  account/realm/locator and changed-request replay.
- **integration consumer/evidence:** DIRECTORY-CLIENT-01 and
  CONTACT-SERVICE-01; byte-identical multi-authority ADC/XPA artifacts.

### DIRECTORY-CLIENT-01 — account freshness and revocation publication client

- **ownerRepository:** `deep-client-shared`.
- **dependsOn:** DEVICE-01, ROUTE-01, ACCOUNT-DIRECTORY-AUTH-01,
  APPLICATION-CODEC-01, CARRIER-CODEC-01.
- **consumes:** verified ADH1/ADP1/DTT1/ADF1/AFP1, exact XOQ1/XOR1
  AccountDirectory/LiveTime exchanges, ADC authoring API, protected
  secure-time/LKG and the revocation-freshness policy.
- **produces:** account-authored ADC1 bytes signed by the exact DPA1
  device-issuer; durable ADC publication/reconcile saga; current-map proof/LKG;
  fresh/partition-expired/forked account state; beyond-horizon checkpoint flow;
  mutation fence exposed to contact/group/device orchestration.
- **wire/API:** stale inclusion is never “current”. After freshness TTL expiry,
  new device fanout and security-sensitive mutation pause until verified repair.
- **DB impact/removals:** protected directory floors, publication operations,
  forward checkpoints and fork evidence.
- **unit gate:** offline revoke saga, stale map proof, outcome-unknown publish,
  trusted-time intersection, 30/180/365/>horizon recovery and restart.
- **integration consumer/evidence:** CONTACT-CLIENT-01, GROUP-CLIENT-01 and
  COMPOSE-01; cross-device monotonic freshness trace.

### XNODE-01 — XNode roles, traffic-key epochs and durable planes

- **ownerRepository:** `xnode`.
- **dependsOn:** NETCODEC-01, ARCH-01.
- **consumes:** XND1 role descriptors, mailbox placement decision, short-lived
  onion key policy and exact common service-host APIs.
- **produces:** Entry/Relay/Mailbox/Blob common role host and durable replicated
  service substrate; epoch-key rotation and secure retirement; two-replica
  mailbox/blob storage, read repair, join/drain/handover,
  InviteStore/pre-key-claim quorum and common quota/resource enforcement.
  Call answer CAS, media allocation, call credentials and call replay semantics
  are exclusively owned by CALL-RELAY-01, which may run on this substrate.
- **wire/API:** XNode does not select client paths, open application E2EE or
  emit carrier policy. Coarse errors preserve outcome-unknown semantics.
- **DB impact/removals:** new node generation for common role state, epoch keys,
  immutable objects, ACK/tombstones and repair. Remove node
  client-path selector and long-lived onion-decryption-key assumptions.
- **unit gate:** key rollover/erase, restart/disk-full/clock skew, common replay
  flood, mailbox handover/read repair and role isolation. Call-specific
  allocation and replay gates belong only to CALL-RELAY-01.
- **integration consumer/evidence:** ONION-01, ROUTE-01, BLOB-01 and CALL-MEDIA-01;
  three-host no-mock role/chaos artifacts.

### ROUTE-01 — protected LKG, client selection and XPoint binding provider

- **ownerRepository:** `deep-client-shared`.
- **dependsOn:** NETCODEC-01, DIRECTORY-01, XNODE-01, STORE-01.
- **consumes:** verified XNA/XND/XNV, PMT2/PMS2 mailbox projection,
  bridge-independent entry candidates and deployment policy.
- **produces:** protected network LKG; successor/checkpoint/fork state machine;
  persistent guards; local exact-three-hop/path/placement selection; XCP1 local
  state; `ITransportBindingProvider` for `OfficialXPoint3`.
- **wire/API:** no publisher-provided route accepted; no direct managed-ingress
  fallback; fewer than three eligible distinct nodes returns unavailable.
- **DB impact/removals:** network/view/guard/path/placement protected tables.
  Remove pinned complete static route list and router-disjoint claim.
- **unit gate:** 30/180/365-day time travel, malicious view/fork/rollback,
  failure-domain selection, guard persistence and exactly-three invariant.
- **integration consumer/evidence:** SUPERVISOR-01, CONTACT-CLIENT-01 and
  COMPOSE-01; deterministic selector vectors and LKG crash trace.

### ONION-01 — clean-break XPoint frame generation and epoch repin

- **ownerRepository:** `deep-protocol`.
- **dependsOn:** REG-01, NETCODEC-01, XNODE-01.
- **consumes:** existing privacy-routing spec/code, XND1 current/next traffic
  keys and global magic registry.
- **produces:** XRF1/XRL1/XRE1/XPR1/XRS1 codecs and negative legacy
  DRF1/DRL1/DRE1/DPR1/DRS1 vectors;
  exact-three onion layers bound to network view, attempt, target and short-lived
  key epoch; reply context and terminal result APIs.
- **wire/API:** DNP1 DPR1/DRS1 retain their meanings. No context-dependent
  alias reader. Retired private traffic keys cannot open old frames.
- **DB impact/removals:** none in Protocol. Remove colliding privacy magic
  constants and long-lived router-key assumptions.
- **unit gate:** global collision gate, all layer substitutions, epoch overlap/
  expiry, reply mismatch, old-magic rejection and captured-frame-after-retire.
- **integration consumer/evidence:** ROUTE-01 and SUPERVISOR-01; exact vector
  package and production graph scan.

### CARRIER-CODEC-01 — exact carrier and acquisition wire specifications

- **ownerRepository:** `deep-protocol`.
- **dependsOn:** REG-01, NETCODEC-01, ARCH-01.
- **consumes:** carrier IDs, XCB1/XCC1/XBB1/XBA1/XOD1/XOQ1/XOR1/XHC1/XHA1/
  MPC1/MPA1 semantics and immutable call/token/acquisition contracts.
- **produces:** canonical carrier artifact codecs/vectors; exact XHC1/XHA1
  transcript/KDF/directional AEAD/framing; exact HTTPS-stream
  upgrade/framing; exact RFC 9298 MASQUE profile and MPC1/MPA1 target-auth;
  TCP capsule framing and queue bounds; bridge-token issuance/redemption and
  exact XOQ1/XOR1 OHTTP records.
- **wire/API:** replaces “where practical”, “WebTunnel-like” and “OHTTP-style”
  with byte-exact transcripts and failure classes.
- **DB impact/removals:** none. `webtunnel-h2-v1` and direct-fallback config are
  negative fixtures.
- **unit gate:** golden/cross-feed/hostile-size vectors, replay/token clone,
  half-close/backpressure, stream/datagram bounds, wrong target/purpose and
  standard interop where an RFC profile is claimed.
- **integration consumer/evidence:** SUPERVISOR-01, REALITY-01, HTTPS-01,
  CARRIER-CATALOG-01, CARRIER-GATEWAY-01, BRIDGE-DISTRIBUTOR-01, BRIDGE-01 and CALL-MEDIA-01;
  machine registry hash and protocol vectors.

### CARRIER-CATALOG-01 — signed carrier policy and finite cohort catalog

- **ownerRepository:** `deep-registry-api`.
- **dependsOn:** CARRIER-CODEC-01, NETCODEC-01, GOV-01.
- **consumes:** exact XNA witness policy, signed XCB1/XOD1 cores, accepted finite
  cohort/binding input and canonical XCC1/XBB1 catalog algorithms.
- **produces:** deterministic XBB1 catalog cores; acyclic Merkle roots; threshold-
  witnessed XCC1 core/envelope; distributor-signed XBB1 proof envelopes; protected
  XCC/XBB generation floors and byte-identical mirror publication. This package is
  the sole producer of signed distributor/cohort policy consumed by XVP1 and
  BRIDGE-DISTRIBUTOR-01.
- **wire/API:** construction order is exactly XOD/XBB cores, XCC root/core/envelope,
  XBB proof/envelope. It never chooses a per-client cohort, mints XBA1 or receives a
  requester identity.
- **DB impact/removals:** carrier-policy/core lineage, immutable cohort cores/proofs,
  witness receipts and fork evidence; no token, operation, contact or route state.
- **unit gate:** deterministic rebuild in two implementations, wrong index/count,
  XCC/XBB/XOD cycle attempt, signature-subset core equality, same-generation fork,
  omitted binding/descriptor, 128 KiB/max+1 and restart before/after threshold.
- **integration consumer/evidence:** ROOT-CHECKPOINT-01, DIRECTORY-01,
  BRIDGE-DISTRIBUTOR-01 and BRIDGE-01; byte-identical catalog/core/root manifest.

### CARRIER-GATEWAY-01 — XPoint carrier gateway and oblivious acquisition runtime

- **ownerRepository:** `xnode`.
- **dependsOn:** CARRIER-CODEC-01, XNODE-01, NETCODEC-01.
- **consumes:** exact XCB1/XOD1/XOQ1/XOR1/XHC1/XHA1/MPC1/MPA1 codecs,
  verified Entry/CallRelay targets, opaque bridge tokens and canonical carrier
  retention classes.
- **produces:** bounded HTTPS/WebSocket XHC/XHA gateway; atomic XHC access-token
  redemption and exact XHC/XHA transport replay; RFC 9458 Relay/Gateway validation
  and application dispatch; MASQUE and
  masked TCP capsule target gateway with MPC/MPA relay-key authentication; common
  resource, rate and sanitized failure enforcement.
- **wire/API:** accepts only a signed binding's exact purpose/target. XOQ validation
  and dispatch are transport functions: the gateway never owns or commits an
  application `(XOD1CoreHash32, operationId, requestHash, exactXOR)` row. It is not a
  general proxy, does not parse application E2EE and cannot mint policy, targets or
  credentials outside the admitted descriptor. Cross-purpose bytes reject before
  application callback.
- **DB impact/removals:** XHC access-token commitments, exact XHC/XHA transport
  request/result replay, short-lived handshake secrets and bounded gateway quota state. No account,
  contact, group, call ID, media plaintext or stable source-target mapping.
- **unit gate:** exact/lost-response retry, changed-request conflict, token clone,
  crash at consume/commit, XHC sequence/AEAD/flow-control failures, OHTTP
  cross-purpose replay, MASQUE DNS rebinding/private-target attempts and
  relay-key-auth failure.
- **integration consumer/evidence:** BRIDGE-01 and E2E-01; server/client interop,
  restart, resource-flood, target-auth and decrypt-negative artifacts.

### BRIDGE-DISTRIBUTOR-01 — oblivious bridge-acquisition application target

- **ownerRepository:** `deep-registry-api`.
- **dependsOn:** CARRIER-CATALOG-01, CARRIER-CODEC-01.
- **consumes:** exact XCC1/XBB1/XBA1/XOD1/XOQ1/XOR1 codecs, current signed
  distributor/cohort policy and `RET-BRIDGE-ACQUISITION-V1`.
- **produces:** the sole `BridgeAcquisition` XOQ target; deterministic cohort-bound
  XBA1 token batches; atomic `(XOD1CoreHash32, operationId, exactXOQ1Hash, exactXOR1)`
  ledger committed with token minting; exact retry/conflict and bounded quota state.
- **wire/API:** receives only an OHTTP-decapsulated validated XOQ1 and transport
  metadata stripped of source identity. It never serves AccountDirectory or
  LiveTimeAttestation, chooses a client route, or returns an unsigned/full bridge
  pool.
- **DB impact/removals:** cohort policy reference, token commitments and the exact
  BridgeAcquisition business/replay transaction through its canonical retention
  deadline. No IP, account, device, DID, contact or stable client identifier.
- **unit gate:** exact lost-response replay, changed-request conflict, crash before/
  after mint commit, duplicate token/nonce, cohort minimum, quota and expiry
  boundary, plus OHTTP Relay/Gateway source-separation fixture.
- **integration consumer/evidence:** BRIDGE-01 and E2E-01; independent distributor
  outage/withholding, no-source-identity and N-1 acquisition artifacts.

### SUPERVISOR-01 — carrier supervisor and official XPoint message adapter

- **ownerRepository:** `deep-client-shared`.
- **dependsOn:** CARRIER-CODEC-01, ROUTE-01, ONION-01, MSG-01.
- **consumes:** verified bindings/policy, canonical `ICircumventionCarrier`,
  XPoint path plans and logical delivery attempts.
- **produces:** protected carrier LKG; candidate state/cooldown/racing policy;
  stable failure classification; sanitized path observer; official XPoint
  `IMessageDeliveryTransport`, blob and call-media binding orchestration.
- **wire/API:** supervisor never parses app plaintext and cannot select direct
  or another deployment profile. Losing raced mutations cannot commit.
- **DB impact/removals:** carrier policy/bundle/binding/token/health state and
  attempt evidence. Remove old direct HTTPS adapter from official composition.
- **unit gate:** offline/captive/blocked distinction, cancellation/network
  change, race loser, rollback/fork, expiry, backoff and outcome-unknown tests.
- **integration consumer/evidence:** REALITY-01, HTTPS-01, CONTACT-CLIENT-01,
  BLOB-01 and CALL-MEDIA-01; supervisor transition trace.

### REALITY-01 — pinned Reality/XHTTP platform adapter

- **ownerRepository:** `deep-client-maui`.
- **dependsOn:** SUPERVISOR-01, CARRIER-CODEC-01.
- **consumes:** one verified XCB1 binding at a time and pinned reproducible Xray
  runtime bundle.
- **produces:** `ICircumventionCarrier` implementation for carrier `0x0001`;
  protected process/files/pipes lifecycle; Android/Windows packaging; network
  change and cancellation integration.
- **wire/API:** every Xray parameter comes from typed verified binding. Secrets
  never enter argv, logs or world-readable environment.
- **DB impact/removals:** platform protected runtime cache only. Remove embedded
  complete endpoint/VLESS credential pool and guessed defaults.
- **unit gate:** binary/bundle hash, config rejection, crash/hang/cancel,
  endpoint/key/short-id/epoch mismatch, APK extraction and no-secret capture.
- **integration consumer/evidence:** BRIDGE-01 and COMPOSE-01; physical
  Android/Windows handshake, packet capture and reproducible-bundle manifest.

### HTTPS-01 — independent HTTPS-stream and MASQUE/capsule adapters

- **ownerRepository:** `deep-client-maui`.
- **dependsOn:** SUPERVISOR-01, CARRIER-CODEC-01.
- **consumes:** verified carrier bindings, exact stream/datagram transcripts and
  MPC1/MPA1 target-auth records.
- **produces:** independent `https-stream-v1`, `masque-h3-v1` and
  `masked-tcp-capsule-v1` client adapters with bounded flow control,
  datagram drop policy and platform lifecycle.
- **wire/API:** no Xray code/dependency for HTTPS-stream; no general VPN/open
  proxy target; QUIC 0-RTT disabled for mutations/allocation/token redemption.
- **DB impact/removals:** connection/session cache only; no application state.
  Remove stale `webtunnel-h2-v1` alias and unmasked TURN client path.
- **unit gate:** exact server fixture interop, redirects/ALPN/path/auth,
  backpressure/half-close, UDP block, stale datagram drop and TCP audio priority.
- **integration consumer/evidence:** BRIDGE-01 and CALL-MEDIA-01; physical packet
  captures on Android and Windows.

### BRIDGE-01 — independent bridge/distributor/media deployment and release gates

- **ownerRepository:** `deep-devops`.
- **dependsOn:** DIRECTORY-01, CARRIER-CODEC-01, CARRIER-CATALOG-01, CARRIER-GATEWAY-01,
  BRIDGE-DISTRIBUTOR-01,
  REALITY-01, HTTPS-01, XNODE-01.
- **consumes:** signed policies/bindings/bundles, BRIDGE-DISTRIBUTOR-01 exact XOQ1/XOR1 bridge
  acquisition wire, MPC1/MPA1 target-auth and XNode Entry/CallRelay targets.
- **produces:** deployment/configuration of separate Reality and HTTPS-stream
  hosting families using the CARRIER-GATEWAY-01 runtime; rotating
  bridge pools; embedded seed generation; multi-origin HTTPS/ECH, OHTTP and
  user-import channels; MASQUE/TCP gateway rollout; rotation/rollback scripts;
  censorship and packet-capture harness; release gate integration.
- **wire/API:** pools do not share all IP/provider/DNS/deployment/distributor
  failure domains. No distributor learns Deep identity or returns full pool.
- **DB impact/removals:** external bridge/token/distributor operational state
  with bounded retention. Remove static three-origin bootstrap and DNS-only TURN
  as release evidence.
- **unit gate:** compose/schema tests, rotation, credential clone, active probe,
  APK extraction, DNS/SNI/IP/UDP blocks, carrier-family failover and no-secret
  artifact scan.
- **integration consumer/evidence:** CONTACT-CLIENT-01, CALL-MEDIA-01 and E2E-01;
  signed bridge catalog, censor-matrix and supply-chain artifacts.

### CONTACT-CODEC-01 — invite, prekey claim and contact/update protocol closure

- **ownerRepository:** `deep-protocol`.
- **dependsOn:** APPLICATION-CODEC-01, E2EE-01, NETCODEC-01, REG-01, ARCH-01.
- **consumes:** application identity/event codecs, ADC1/ADH1/ADP1/ADL1,
  XIR1/XRR1/XUR1 semantics, `CONTACT-RESOLVER-V1.md` and the accepted retention
  matrix.
- **produces:** exact codecs/vectors for XIR1/XPU1/XPO1/XPA1/XIQ1/XIS1/
  XPS1/XPK1/XPC1/XUR1/XUW1/XUQ1/XUS1; effective-expiry rule; exact routable XRR
  closure; signed hash-closed support packages.
- **wire/API:** permanent DID1 resolves rotating DCB/prekeys atomically without
  expiring or redirecting the ID; one-time redemption
  exact-replays only for the same operation; DCB cannot outlive mandatory
  reachability. Missing prekeys have one canonical result.
- **DB impact/removals:** pure sealed transition plans only. Remove bare account
  hash/`05...` address and PRA-as-initial-discovery semantics.
- **unit gate:** closure completeness, concurrent claim, prekey exhaustion,
  replay/lost response, expiry boundaries, stale successor, spam bounds and no
  account-indexed lookup vectors.
- **integration consumer/evidence:** CONTACT-SERVICE-01 and CONTACT-CLIENT-01;
  two-implementation vector agreement.

### CONTACT-SERVICE-01 — encrypted invite/prekey/update services

- **ownerRepository:** `xnode`.
- **dependsOn:** CONTACT-CODEC-01, XNODE-01, ACCOUNT-DIRECTORY-AUTH-01.
- **consumes:** opaque resolver locator/capability, signed contact packages,
  PMT2/PMS2 placement, prekey claim records and XUR retention policy.
- **produces:** durable encrypted DCR publication/resolution; atomic one-time
  redemption and prekey claim/exact replay; unsolicited admission/quota;
  400-day XUR successor storage; replication/restart/corruption behavior.
- **wire/API:** service never indexes by DeepAccountId, parses DCR1/DMC2 or
  learns contact graph. Registry is not the resolver. Error detail is
  closed/coarse.
- **DB impact/removals:** new resolver, claim/replay, capability quota and XUR
  generation stores with authenticated GC. No reuse of Registry call state.
- **unit gate:** concurrent claim, crash on every CAS, duplicate/fork, retention
  time travel, quota flood, repair and corrupted-state quarantine.
- **integration consumer/evidence:** CONTACT-CLIENT-01; black-box offline
  recipient and service-restart fixture.

### CONTACT-CLIENT-01 — arbitrary contact and long-offline contact runtime

- **ownerRepository:** `deep-client-shared`.
- **dependsOn:** MSG-01, DEVICE-01, DIRECTORY-CLIENT-01, ROUTE-01,
  SUPERVISOR-01, CONTACT-CODEC-01, CONTACT-SERVICE-01.
- **consumes:** canonical Deep address/bundle, ADP1/ADH1 freshness proofs,
  prekey claim service, XPoint transport, pairwise sessions and XUR successor
  records.
- **produces:** verify/import/request/accept/reject/block state machine; safety
  fingerprint; per-device first-message fanout; route/update convergence;
  explicit expired/unavailable/conflict outcomes; returning-device versus
  phrase-recovery behavior.
- **wire/API:** success requires end-to-end mailbox acceptance by at least one
  valid recipient device, not local socket write. No live PRA prerequisite.
- **DB impact/removals:** relationships, verified identity generations,
  invitation evidence, per-contact XUR/current+next reachability and request
  state. Remove Session ID contact rows and silent route reset.
- **unit gate:** Android/Windows fixture, recipient offline, simultaneous hello,
  stale/rotated route, every machine-contract long-offline/beyond-horizon state,
  no-backup recovery and block.
- **integration consumer/evidence:** GROUP-CODEC-01, CALL-SIGNAL-01 and E2E-01;
  arbitrary-contact cold-restart evidence.

### GROUP-CODEC-01 — small-group closure and governance protocol

- **ownerRepository:** `deep-protocol`.
- **dependsOn:** CONTACT-CODEC-01, DEVICE-01, REG-01.
- **consumes:** DGP1/DGC1/DGM1 semantics, exact
  ADC1/ADH1/DMD1/DRS1/DPD1 references and accepted 100-member/500-device limits.
- **produces:** canonical GIV1/GIA1/DGP1/DGC1/DGM1/DGT1/GCP1/GCF1 and
  GSR1/GSW1/GSQ1/GSS1 records plus exact group-commit closure
  containing every referenced proposal/directory/revocation/device/transparency
  object; ADC1/ADH1 and DMD1 hash/ref in member entries; emergency owner-device
  transfer record; fork and predecessor verification plans.
- **wire/API:** one sequencer emits commits; application events have no
  long-term signature; governance signatures use separate domains.
- **DB impact/removals:** pure sealed plans. Remove revision-only state and
  arrival-order conflict resolution.
- **unit gate:** pending invite/consent/activation, genesis/successor,
  missing/extra closure object, two valid successors, role/device substitution,
  owner transfer, chunk max/max+1 sizes and delayed old-epoch event.
- **integration consumer/evidence:** GROUP-CLIENT-01; vector package and
  independent protocol-review input.

### GROUP-CONTROL-SERVICE-01 — per-recipient retained group-control store

- **ownerRepository:** `xnode`.
- **dependsOn:** GROUP-CODEC-01, XNODE-01, NETCODEC-01.
- **consumes:** opaque GSR1 capability/placement, GSW1/GSQ1 requests, sealed GCF1
  chunks and canonical group-control retention policy.
- **produces:** two-replica sequence/predecessor CAS, exact GSS1 replay/results,
  bounded catch-up, checkpoint compaction and state-root handover.
- **wire/API:** no group/member/account/device ID; each recipient uses an
  independent random capability. The service never decrypts GCF/GCP or infers a
  member list.
- **DB impact/removals:** opaque per-capability control sequence, ciphertext,
  replay receipts, compaction checkpoint and handover root.
- **unit gate:** missing/duplicate/reordered chunks, changed sequence, replica
  crash/handover, long-offline boundary, compaction restart and explicit gap.
- **integration consumer/evidence:** GROUP-CLIENT-01 and E2E-01; server-side
  retention/deletion plus offline-current-membership recovery artifact.

### GROUP-CLIENT-01 — group state, durable fanout and scale gates

- **ownerRepository:** `deep-client-shared`.
- **dependsOn:** GROUP-CODEC-01, GROUP-CONTROL-SERVICE-01, MSG-01, DEVICE-01,
  CONTACT-CLIENT-01, SUPERVISOR-01.
- **consumes:** verified group closures, per-device ratchets and logical outbox.
- **produces:** proposal/commit/invite/accept/leave/remove/role state; fork
  latch; per-target durable group batch; bounded concurrency/bytes/chunking;
  partial acceptance/reconcile; optional explicit history transfer.
- **wire/API:** “logical batch” is local durability, not a member-list disclosure
  to XNode. Every target receives an independent envelope/attempt.
- **DB impact/removals:** group heads/proposals/targets/attempts/fork evidence,
  retained commits and history-transfer manifests. Remove 2048-member and
  revision-only rows.
- **unit gate:** correctness at 3 members; intermediate 20-member gate; final
  100-member/500-device p95 gate; owned non-blocking 200-member future-profile
  baseline; restart/partial failure, revoke-before-send, battery/data budget and
  no sequential 500-round-trip behavior.
- **integration consumer/evidence:** COMPOSE-01 and E2E-01; sanitized fanout
  latency/bytes/battery artifact.

### BLOB-01 — encrypted attachment plane

- **ownerRepository:** `deep-client-shared`.
- **dependsOn:** MSG-01, SUPERVISOR-01, XNODE-01, ARCH-01.
- **consumes:** canonical attachment manifest/event, 256 KiB chunk policy,
  masked blob capability and `IAttachmentBlobTransport`.
- **produces:** client encryption/manifest, resumable upload/download,
  per-chunk integrity, concurrency policy and transport-switch-safe progress.
- **wire/API:** plaintext filename/MIME/preview/key remain inside E2EE; storage
  receives opaque capability and ciphertext hashes only.
- **DB impact/removals:** attachment object/chunk/progress/capability/expiry
  tables. Remove direct `/file` URL and DEEPATT2/legacy locator production path.
- **unit gate:** 25 MiB, restart at 25%, corrupt/missing/duplicate chunk,
  retention boundary, blocked blob service and no direct-host fallback.
- **integration consumer/evidence:** COMPOSE-01 and E2E-01; packet capture and
  resume/hash evidence.

### PUSH-01 — opaque optional push

- **ownerRepository:** `deep-push-notification-server`.
- **dependsOn:** MSG-01, SUPERVISOR-01, ARCH-01.
- **consumes:** random rotating wake handles and encrypted opaque hint contract.
- **produces:** provider registration/delivery/revoke path, bounded retry and
  sanitized provider evidence; no-push correctness contract consumed by client.
- **wire/API:** no Deep ID, sender, conversation, message/call type or preview;
  push never acknowledges message delivery.
- **DB impact/removals:** random handle/provider-token ciphertext, expiry and
  provider-attempt state. Remove Session-style stable subscription mapping.
- **unit gate:** duplicate/delay/forgery/provider outage, restart, token rotation,
  no-secret logs and client convergence with push disabled.
- **integration consumer/evidence:** COMPOSE-01 and E2E-01; provider canary plus
  no-push polling artifact.

### CALL-CODEC-01 — call signaling, answer-CAS and allocation codecs

- **ownerRepository:** `deep-protocol`.
- **dependsOn:** APPLICATION-CODEC-01, CARRIER-CODEC-01, NETCODEC-01, REG-01.
- **consumes:** closed call payload tables and CMD1/CAC1/CAO1/CAR1/CAA1/CAL1
  contracts plus XCD1/XCB1 references.
- **produces:** exact codecs/vectors for all call events and service records;
  CallMediaSuiteV1 constants; request/result hashes, conditional fields, bounds
  and hostile SDP/media-suite substitution vectors.
- **wire/API:** pure immutable author/verify functions; no WebRTC, network,
  signer key, capability store or clock callback.
- **DB impact/removals:** none.
- **unit gate:** max/max+1, unknown suite/codec/field, changed request, wrong
  quorum generation, SDP injection, candidate/fingerprint/credential substitution.
- **integration consumer/evidence:** CALL-SIGNAL-01, CALL-RELAY-01 and
  CALL-MEDIA-01; cross-repository byte-identical call vector manifest.

### CALL-SIGNAL-01 — ratcheted one-to-one call signaling

- **ownerRepository:** `deep-client-shared`.
- **dependsOn:** MSG-01, DEVICE-01, CONTACT-CLIENT-01, CALL-CODEC-01, REG-01.
- **consumes:** `CALL-SESSION-V1.md`, DMC2 call events, exact CMD1/CAC1/CAO1,
  authenticated conversation/device heads, protected DTT1-backed time and
  canonical `RelayOnly` call names.
- **produces:** offer/answer/candidate/reconnect/end state machine; fresh call
  binding; DTLS fingerprint/allocation binding; stale/replay suppression;
  multi-device CAC1 answer-winner CAS, glare, missed/busy/decline and durable outcome semantics.
- **wire/API:** signaling is ordinary high-priority ratcheted messaging. It does
  not call a Registry signaling inbox or export ratchet keys to SRTP.
- **DB impact/removals:** call session/event/replay tombstone state. Remove
  `HttpCallSignalingTransport`, `/api/calls/signal` and Session-ID call records
  from the target client generation.
- **unit gate:** duplicate/reorder/replay, trusted-time/expiry boundaries, no
  network before callee accept, device revoke, restart, unsigned SDP injection
  and fingerprint/media-suite substitution.
- **integration consumer/evidence:** CALL-MEDIA-01 and COMPOSE-01; signaling
  trace through loopback and official XPoint message transport.

### CALL-RELAY-01 — replicated answer CAS and masked media allocation service

- **ownerRepository:** `xnode`.
- **dependsOn:** CALL-CODEC-01, XNODE-01, DIRECTORY-01, NETCODEC-01.
- **consumes:** exact CAC1/CAO1/CAR1/CAA1/CAL1/CMD1 and XCD1 contracts, signed relay
  catalogs, random bearer capabilities, DTLS fingerprint commitments and
  canonical media-allocation retention policy.
- **produces:** two-replica answer-claim CAS; participant-specific allocation,
  credential, allocation-capability commitment and replay state; exact owner-only CAL1;
  relay service runtime; durable quorum receipts,
  handover and sanitized decrypt-negative evidence. BRIDGE-01 owns deployment.
- **wire/API:** receives no account/device/conversation ID and never receives an
  endpoint DTLS private key or SRTP secret. Same operation/exact request replays;
  changed bytes conflict; no single Registry/relay process decides a winner.
- **DB impact/removals:** capability commitments, claim/allocation operation
  hashes, bounded replay tombstones and replica handover roots. No signaling
  inbox, SDP archive, media plaintext or stable participant mapping.
- **unit gate:** 100-way answer race, replica crash/handover, changed-request
  replay, allocation expiry/revoke, malicious certificate substitution and
  relay decrypt-negative corpus.
- **integration consumer/evidence:** CALL-MEDIA-01 and E2E-01; quorum/expiry,
  UDP-blocked carrier and no-plaintext artifacts.

### CALL-MEDIA-01 — relay-only WebRTC client adapters

- **ownerRepository:** `deep-client-maui`.
- **dependsOn:** CALL-SIGNAL-01, CALL-RELAY-01, BRIDGE-01, CARRIER-CODEC-01,
  SUPERVISOR-01, REALITY-01, HTTPS-01.
- **consumes:** verified XCD1/XCB1, short-lived allocation API selected by
  ARCH-01, `ICallMediaPathProvider`, call binding and DTLS fingerprints.
- **produces:** Android/Windows WebRTC adapter exposing relay-only candidates;
  `MasqueUdp` and `MaskedTcpCapsule` media carriers; audio-first degradation,
  reconnect/network handover and privacy/status UI model.
- **wire/API:** no host/srflx/mDNS/direct candidate, public STUN, direct TURN or
  silent `DirectPeer` fallback. CallRelay allocation does not prove peer identity.
- **DB impact/removals:** client-side ephemeral allocation/path state and
  call-signaling replay state only; server allocation/replay state belongs to
  CALL-RELAY-01. Remove `DEEP_CALL_SIGNALING_BASE_URL`, direct ICE and
  static DNS-only TURN release configuration.
- **unit gate:** Android↔Windows and Android↔Android ring/accept/audio/video,
  selected pair inspection, UDP block to TCP audio, relay rotation, reconnect,
  no peer IP and no relay plaintext.
- **integration consumer/evidence:** COMPOSE-01 and E2E-01; sanitized WebRTC
  stats, path profile and packet capture.

### COMPOSE-01 — destructive release composition and product UI

- **ownerRepository:** `deep-client-maui`.
- **dependsOn:** STORE-01, MSG-01, DEVICE-01, ROUTE-01, SUPERVISOR-01,
  REALITY-01, HTTPS-01, CONTACT-CLIENT-01, GROUP-CLIENT-01, BLOB-01, PUSH-01,
  CALL-SIGNAL-01, CALL-MEDIA-01.
- **consumes:** exact reviewed packages and `release-scope.v1.json`.
- **produces:** one fail-closed Android/Windows composition root; offline
  onboarding; actual profile/carrier/privacy/degraded UI; physical automation
  hooks; reproducible APK/MSIX inputs.
- **wire/API:** only target generation is referenced. Unsupported P2P/on-prem/
  Apple/direct paths are absent or explicitly unavailable.
- **DB impact/removals:** activates the clean-break DB once. Remove Session
  runtime/resources/IDs, DPE1/DMC1, old parsers/stores/endpoints/feature flags,
  static bootstrap, Registry calls and legacy direct file/push/call paths.
- **unit gate:** production dependency/resource/API scans, MAUI ViewModel/UI/
  smoke suites, Windows x64/arm64 and Android arm64 builds, airplane-mode account.
- **integration consumer/evidence:** E2E-01; signed composition manifest and
  zero-legacy scan.

### E2E-01 — black-box, physical, censorship and release evidence

- **ownerRepository:** `deep-tests-e2e`.
- **dependsOn:** COMPOSE-01, DIRECTORY-01, XNODE-01, BRIDGE-01.
- **consumes:** independently built service/client artifacts, release scope and
  exact evidence schemas; orchestration is supplied by reviewed `deep-devops`
  lanes from BRIDGE-01.
- **produces:** black-box functional/fault/time-travel/load suites and bounded
  machine-readable outputs for Android A↔Android B, Android↔Windows x64/arm64;
  lead/crypto/privacy/censorship/security review input bundle.
- **wire/API:** tests public target contracts only and prove the intended real
  service/runtime was contacted. Fakes cannot satisfy release evidence.
- **DB impact/removals:** fixture data only; each generation reset is explicit.
  Remove old iOS-blocking, disjoint-route and Registry-call acceptance fixtures.
- **unit gate:** fixtures schema/compat/smoke/full/load; full DNS/SNI/path/IP/UDP/
  active-probe/APK-and-MSIX-extraction matrix; crash/restart/rotation; performance SLOs;
  secret scan and local Markdown-link check.
- **integration consumer/evidence:** `deep-devops` release gate and independent
  reviewers; one signed commit matrix with P0=0/P1=0 before GA.

## 4. Parallel execution lanes

After GOV-01/CRYPTO-01/ARCH-01/REG-01 are reviewed, agents may work in these
disjoint lanes:

| Lane | Packages | First integration rendezvous |
| --- | --- | --- |
| identity/crypto | ID-01, STORE-01, E2EE-01, APPLICATION-CODEC-01, MSG-01, DEVICE-01 | loopback two-device ratcheted event with crash recovery |
| network | NETCODEC-01, ROOT-CHECKPOINT-01, DIRECTORY-01, XNODE-01, ROUTE-01, ONION-01 | exact-three-hop opaque Store/Retrieve with XPR1/XRS1 and forward-checkpoint fixtures |
| carriers | CARRIER-CODEC-01, CARRIER-CATALOG-01, CARRIER-GATEWAY-01, BRIDGE-DISTRIBUTOR-01, SUPERVISOR-01, REALITY-01, HTTPS-01, BRIDGE-01 | same opaque operation through each independent carrier |
| contacts/directory | CONTACT-CODEC-01, ACCOUNT-DIRECTORY-AUTH-01, DIRECTORY-CLIENT-01, CONTACT-SERVICE-01, CONTACT-CLIENT-01 | unrelated offline recipient accepts first contact |
| feature planes | GROUP-CODEC-01/GROUP-CONTROL-SERVICE-01/GROUP-CLIENT-01, BLOB-01, PUSH-01, CALL-CODEC-01/CALL-SIGNAL-01/CALL-RELAY-01/CALL-MEDIA-01 | each feature uses the same identity/outbox/policy seams |

An agent may prepare tests against checked-in producer fixtures while a producer
is running, but cannot merge implementation that invents missing producer bytes.

## 5. Integration milestones and stop conditions

| Milestone | Required packages | Demonstration |
| --- | --- | --- |
| `M0 Freeze` | GOV-01, CRYPTO-01, ARCH-01, REG-01 | no open registry/ownership/provider P0; generated collision gate green |
| `M1 Local secure core` | ID-01 through DEVICE-01, including APPLICATION-CODEC-01 | offline account, two-device ratchet, durable loopback outbox and revoke |
| `M2 XPoint text spine` | NETCODEC-01 through ONION-01, CARRIER-CODEC-01 through REALITY-01 | one Reality carrier, exact three hops, opaque 1:1 operation, no direct path |
| `M3 Arbitrary contacts` | CONTACT-CODEC-01, ACCOUNT-DIRECTORY-AUTH-01, DIRECTORY-CLIENT-01, CONTACT-SERVICE-01, CONTACT-CLIENT-01 | copied Deep address reaches offline unrelated user and survives rotation/restart over the M2 Reality path |
| `M4 Circumvention` | CARRIER-CATALOG-01, CARRIER-GATEWAY-01, BRIDGE-DISTRIBUTOR-01, HTTPS-01, BRIDGE-01 | Reality and independent HTTPS carrier; APK/IP/DNS/SNI/UDP scenarios |
| `M5 Product parity` | GROUP packages, BLOB-01, PUSH-01 | 100-member final gate, 25 MiB resume and no-push convergence |
| `M6 Calls` | CALL-CODEC-01, CALL-SIGNAL-01, CALL-RELAY-01, CALL-MEDIA-01 | relay-only audio/video plus UDP-blocked masked TCP audio |
| `M7 Release candidate` | COMPOSE-01, E2E-01 | one signed commit matrix, all physical/security/SLO gates, P0/P1=0 |

Stop the affected lane when any of these occur:

- provider or license decision is unresolved;
- a package needs an unallocated magic/ID or undocumented transcript;
- a producer fixture and normative source disagree;
- an implementation would add a legacy reader, alias or direct fallback;
- a package needs production secrets or deployment authority not granted;
- a current runbook instructs behavior forbidden by the target registry;
- a physical/security claim lacks reproducible evidence.

## 6. Definition of package completion

A package is complete only when:

- its `produces` list is fully present in one focused local repository commit;
- every declared unit gate passes at that commit;
- generated files are reproducible and source-owned;
- exact consumer-facing API/wire fixtures are committed;
- hostile, max+1, replay, crash and cancellation cases are covered;
- repository instructions/runbooks describe the new ownership and no stale
  first-read instruction contradicts it;
- no unrelated dirty files are included;
- residual P2/P3 findings are explicit and no P0/P1 is deferred into code;
- the integration consumer can run without private developer shortcuts.

Completing all packages still does not authorize GitHub push or production
deployment. Those actions require a separate user decision after final reviews.
