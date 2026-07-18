# DR-0002 — checkpoint authority ownership proposal

Status: **Proposed / NOT APPROVED**

Decision owner: **Mr. X**

Proposed: 2026-07-19

Applies to program: `deep-survival` release `2.0.0`, work package `DSP2-P04B`

Accepted P04 consumer pins (evidence only; this proposal does not publish or
change a dependency manifest):

| Artifact | Accepted identity |
| --- | --- |
| `deep-protocol` source | `b887fa088f486390be182cac4cbcb59b60ce8931` |
| Final GO evidence commit | `db58937d4070eb057642c00d10a64d2f738f6e41` |
| Local package version | `0.3.0-p04.b887fa0` |
| `package-manifest.json` SHA-256 | `fd3ef27bf0b9272570d6c6e680a3c99e581f6220799d13ee3afbd86ea0e99298` |
| `Deep.Protocol.0.3.0-p04.b887fa0.nupkg` SHA-256 | `8ef4e70ad0b6c1cc0087f25c0313d6ab6a5387d16246679e4c10a3c00898a442` |
| `Deep.Protocol.Abstractions.0.3.0-p04.b887fa0.nupkg` SHA-256 | `fc1212a6765f5778188fcb3866ef923023c2253c3ead299a542271f4cc4f844f` |
| `Deep.Protocol.Protobuf.0.3.0-p04.b887fa0.nupkg` SHA-256 | `755a027c58be670151456cc0bca4764731f7c493932d9eedd00c02e704baf818` |

This record is a proposal only. It does not approve a repository, a custody
design, implementation, key generation/import, deployment or publication.
P04B remains stopped until Mr. X explicitly accepts or replaces this record.

## Context

The accepted P04 contract defines canonical `BridgeSnapshot`,
`NodeMembershipCommitment`, delegation/revocation and fork-witness bytes. Its
Beta policy requires three of five offline roots to delegate three online
signers and two distinct active online signatures for each snapshot or
commitment. P04 intentionally supplies no production signature adapter,
durable state, key ceremony or runtime registration.

The [P04B prompt](../releases/v2.0.0/agent-prompts/P04B-checkpoint-signer-publisher.md)
requires an approved product owner, repository and key-custody design before
runtime work starts. None is approved. In particular, `deep-registry-api`,
`xnode` and `deep-devops` are not implicit owners merely because they produce,
consume or deploy adjacent data.

The authority must produce two disclosure classes without allowing one to
contaminate the other:

- public bridge snapshots contain only client-safe public entry contacts;
- node membership commitments contain only a commitment and are delivered to
  authorized node consumers; full member/core/storage topology never enters a
  public snapshot, mirror, witness or standard evidence.

## Options considered

### A. New dedicated product repository and service — recommended

Proposed repository name: **`deep-membership-authority`**.

The repository would own independently deployable builder, quorum coordinator,
online-signer boundary and fork-witness components, plus test-key local
harnesses and production custody interfaces. It would consume the accepted P04
contract as a pinned package rather than redefine canonical bytes.

Benefits:

- the signing trust boundary is not coupled to a public API, peer runtime or
  deployment tooling;
- builder, signer and witness permissions can be separately denied by default;
- release, audit and incident response can stop the authority without stopping
  registry reads or nodes;
- test-only keys and production adapters can have an explicit compile,
  configuration and deployment boundary.

Costs:

- one additional product repository, release train and on-call surface;
- durable monotonic state, HSM integration and disaster recovery must be built
  and operated explicitly;
- correct independence requires separate signer accounts, key handles, hosts
  and failure domains, even though Mr. X is the accountable human owner.

### B. Put the authority in `deep-registry-api` — not recommended

Registry projection is a valid candidate input and the registry may later
reconcile already-signed outputs under P06. It must not become their trust
root. Co-location would join an Internet-facing/read-heavy compromise surface
to signing authority, create circular trust between projection and approval,
and make topology minimization harder to prove. A registry process or database
credential must never be sufficient to request, approve and publish a
checkpoint.

### C. Put the authority in `xnode` — not recommended

XNode is a node-only consumer under P04D and has peer-facing data-plane attack
surface. Giving it authority would let a compromised node runtime approach
signing keys, blur the distinction between membership evidence and membership
decision, and encourage private topology to leak into public discovery.
Individual nodes may validate commitments and inclusion proofs; they must not
possess the online authority shares.

### D. Put the authority in `deep-devops/tools` — prohibited

The P04B prompt explicitly prohibits this placement. Delivery tooling has broad
repository, artifact and deployment access and is an unsuitable product trust
boundary. DevOps may provision narrowly scoped infrastructure and verify
public evidence, but may not build authoritative candidates, hold signer key
handles, approve signatures or assemble quorum.

## Proposed ownership

These are recommended assignments and remain unapproved:

| Responsibility | Proposed owner |
| --- | --- |
| Product/accountable decision owner | Mr. X |
| `deep-membership-authority` product and architecture owner | Mr. X |
| P04 contract/package pin and compatibility owner | Mr. X |
| Online signer policy and custody owner | Mr. X |
| Offline-root ceremony and recovery owner | Mr. X |
| Operations, incident and rollback owner | Mr. X |
| Security/privacy acceptance owner for internal gates | Mr. X |

Mr. X holding all internal human roles does not make two processes
independent. Independence here is a technical and operational property:
different non-exportable key handles, service identities, authorization
policies, hosts/accounts, audit streams and failure domains. An internal review
also does not replace the program's required external crypto/security review.

## Proposed bounded responsibilities

`deep-membership-authority` would own only:

1. **Deterministic checkpoint builder.** It validates a versioned, signed and
   pinned node/registry projection; sorts and canonicalizes input
   deterministically; derives the next exact sequence and previous hash from
   durable last-known-good state; produces P04 canonical candidate bytes; and
   emits a reproducible input/output receipt without secrets or topology.
2. **Pre-sign policy gate and atomic reservation.** It rejects wrong network,
   domain, policy version, delegation, validity, sequence, previous hash,
   duplicate request or mixed input generation. Before contacting any signer,
   it performs an atomic compare-and-append reservation of the candidate hash
   against durable last-known-good state. The reservation key binds network,
   P04 domain, policy/delegation, sequence and previous hash. A different
   candidate for the same key is recorded as a conflict and rejected before a
   signature request exists.
3. **Independent online signer boundaries.** Three signer instances are
   addressable, while any published artifact requires two valid, distinct
   shares. Each signer receives the full exact canonical P04 statement bytes
   and the verified pre-sign reservation, never a coordinator-supplied digest
   as signing authority. It decodes with the pinned P04 codec, validates and
   re-encodes the statement, requires byte-for-byte equality, and constructs
   the fixed P04 domain-framed signing preimage itself. Each signer also
   atomically persists an independent sign-once record for the reservation key
   and candidate hash before using its non-exportable key. A conflicting hash,
   missing/invalid reservation or uncertain local write fails closed across
   retries and restarts.
4. **Quorum assembly.** The coordinator has no private key. It verifies the
   public signer descriptor, algorithm/profile attestation and returned
   signature against the active root-authorized delegation and exact P04
   signing bytes; orders P04 signatures canonically; and emits a signed
   snapshot/commitment only after valid 2-of-3 quorum.
5. **Append-only transparency/fork record.** The pre-sign reservation is
   append-only and is independently checked by each signer. After quorum, an
   atomic finalization record links that reservation to the signer IDs and
   exact signed-artifact hash before release. A crash leaves a resumable,
   sign-once reservation: the identical candidate may resume and collect
   missing shares, but it may not be replaced or skipped. A conflicting
   candidate is witnessed and publication fails closed; no component silently
   selects a winning fork.
6. **Public, secret-free evidence.** Health and audit evidence may expose
   software version, public key ID, policy/delegation hash, sequence, artifact
   hash and generic result codes. It must not expose a private share, signing
   request payload containing node topology, full input projection, contact
   history, operator identity, HSM credential or raw exception.
7. **Test-key local harness, later.** A future package may use deterministic
   disposable keys only under a fail-closed local-test profile. Test adapters
   must be absent from production images and impossible to enable through an
   ambient environment-variable typo.

It would not own registry mutation, node enrollment policy, reward/billing,
client fetch, public mirror availability, node runtime, production key
ceremony, or automatic fork resolution.

## Proposed data and deployment boundaries

The intended one-way flow is:

```text
signed/pinned projections
          |
          v
deterministic builder -> candidate + secret-free receipt
          |
          v
atomic pre-sign reservation / conflict witness
          |
          v
quorum coordinator -> signer A + durable sign-once state
                   -> signer B + durable sign-once state  (2 of 3 required)
                   -> signer C + durable sign-once state
          |
          v
append-only finalization -> content-addressed signed output
                         |                    |
                         | node-only          | public bridge only
                         v                    v
                    P04D consumer       P04C mirror publisher
```

Required controls:

- the builder may read only the approved projection and last-known-good state;
  it cannot call an HSM or publish externally;
- each signer has its own service identity and exactly one non-exportable
  online key handle; no signer can read another signer's state or audit stream;
- the quorum coordinator can request signatures but has no key-management,
  key-export, projection-write or mirror credentials;
- an atomic compare-and-append reservation and verified read-after-write must
  complete before the coordinator contacts a signer. Each signer independently
  validates the reservation through a separately authenticated read or a
  verifiable store receipt and then commits its own durable sign-once record
  before signing;
- the transparency store permits append/finalize operations but denies update,
  delete and sequence reuse to authority identities. It has a separately
  protected continuity checkpoint; a release fails if reservation,
  finalization or read-after-write verification is uncertain;
- recovery may resume only the exact reserved candidate and exact input
  receipt. Abandonment is an append-only terminal event and never frees the
  sequence for another candidate. Restoring coordinator, signer or store state
  cannot reset sequence or a signer-local sign-once decision;
- bridge and membership output queues/stores are separate. Only the bridge
  output is eligible for public mirroring;
- production signer endpoints are private, mutually authenticated and
  allow-listed by service identity. They are never exposed through the
  registry, node, public ingress or mirror;
- logs default to hashes, bounded result codes and coarse health. Raw
  projections, endpoint sets and operator/node identifiers are prohibited;
- backup and recovery preserve monotonic sequence, previous hash, delegation
  and witness continuity atomically. Restore never authorizes sequence reset;
- deployment credentials can roll a service but cannot use, export, create or
  destroy a signing key.

## Proposed custody interfaces

The product code should depend on narrow interfaces, not a chosen cloud or HSM
SDK:

- `IOnlineSignatureBoundary.Sign(request)` accepts the full exact canonical P04
  statement bytes, its declared P04 domain, network/policy/delegation context
  and a verifiable pre-sign reservation receipt. The boundary parses, validates
  and canonicalizes the statement again, requires byte equality and constructs
  the fixed P04 domain-framed preimage internally. A digest supplied by the
  coordinator is never sufficient. If the approved signature algorithm
  requires prehashing, that step exists only inside its pinned algorithm
  adapter over the signer-constructed framed bytes. The response contains only
  public/non-secret signer descriptor data, approved algorithm/profile ID,
  public key/attestation reference and signature; it never returns private
  material.
- `IOfflineAuthorityCeremony` imports only a signed delegation/revocation or
  genesis ceremony bundle and public descriptors. Offline-root private keys
  never enter the online service, CI, repository, container, artifact store or
  operational backup.
- `IKeyAttestationReader` returns public key, immutable key-handle identity,
  allowed algorithm/profile, exportability=false and attestation/health
  evidence suitable for verification. It cannot sign.
- `IMonotonicAuthorityState` reads the accepted P04 last-known-good authority
  and content chains and rejects rollback, overwrite or ambiguous recovery.
- `IForkWitnessLog.Reserve/Finalize` atomically compare-and-appends the
  reservation key/candidate hash and later the exact signed-artifact hash.
  Neither operation can update, delete or reuse a prior reservation.
- `ISignerSignOnceState.Reserve` atomically binds one signer to one candidate
  hash per reservation key before key use and returns the existing decision on
  retry. A different hash or unavailable durable state is a hard rejection.

Production adapters may target HSM, managed HSM/KMS or offline hardware only
after algorithm/profile, provider, attestation, access policy, backup and
recovery are approved. File/PEM keys are test-only and prohibited in
production. A private share must never leave its signer/HSM boundary, including
in crash dumps, telemetry, support bundles and backups.

The five offline roots require five distinct non-exportable custody objects and
the approved 3-of-5 ceremony. The three online signers require three distinct
non-exportable objects and service/failure domains. A single provider,
administrator or deployment credential must not be able to replace all roots,
all online keys, monotonic state and witness history.

## Separate mirror publisher proposal

Proposed repository name: **`deep-bridge-mirror`**, owned by Mr. X under the
P04C product role but operated with a deployment identity and data path
separate from `deep-membership-authority`.

It would receive only already-quorate, P04-verifiable public bridge artifacts
from a content-addressed release channel. It would verify bytes, signatures,
delegation and sequence/previous hash. It also verifies two distinct records:
the `ForkWitnessRecord` embedded in the canonical P04 `BridgeSnapshot`, and an
external append-only transparency receipt that binds the pre-sign reservation
to the exact signed-artifact hash. The external receipt is a sidecar
association; it is not a reference field inside P04 and does not alter or get
inserted into canonical P04 bytes. Only then may the mirror publish
byte-identical P04 content and its separately identified receipt. It would
have:

- no signing or HSM interface;
- no access to builder inputs, node-only commitments, membership proofs or full
  topology;
- no write path back to authority state or witness history;
- no ability to transform or re-sign content;
- separate release, credentials, storage, network policy and audit stream.

Registry API may reconcile signed bridge data, but it is neither the authority
nor the sole mirror. Mirror implementation and repository creation remain a
separate P04C decision and work package.

## Delivery estimate after approval

The estimates below are planning ranges, not authorization or a deadline. They
assume one senior backend engineer, part-time platform/security support and the
already accepted P04 package:

| Increment | Engineering estimate |
| --- | ---: |
| Repository bootstrap, threat model, package pins and red harness | 3–5 days |
| Deterministic builder, projection validation and topology-redaction tests | 5–8 days |
| Three isolated test signer boundaries and quorum coordinator | 6–10 days |
| Durable monotonic state, append-only witness and conflict/recovery drills | 6–10 days |
| Production-like HSM/offline interfaces and test-key local E2E | 5–8 days |
| Hardening, impairment, backup/restore and evidence packaging | 5–8 days |
| **P04B implementation subtotal** | **30–49 engineer-days** |
| Separate P04C bridge-mirror implementation | 8–15 engineer-days |

Provider selection/procurement, production ceremony, external crypto/security
review and multi-failure-domain infrastructure are additional elapsed-time
gates and cannot be estimated honestly until the questions below are answered.
No production-ready claim follows from completing the local test-key subtotal.

## Decision questions for Mr. X

Mr. X must explicitly answer these before implementation scope is opened:

1. Approve, rename or reject the dedicated
   `deep-membership-authority` repository and the bounded responsibilities
   above?
2. Approve that `deep-registry-api`, `xnode` and `deep-devops/tools` are
   prohibited signer/runtime locations, including temporary production
   shortcuts?
3. Approve the separate `deep-bridge-mirror` repository/ownership boundary for
   P04C, or name another separate product repository?
4. Which exact signed projection is authoritative for bridge candidates and
   membership leaves, who may submit it, and what schema/version/SHA pins are
   required?
5. Approve three independently isolated online signer deployments and five
   independently protected offline-root custody objects; which provider,
   accounts/locations and recovery domains are allowed?
6. Which signature algorithm/profile and HSM attestation requirements may be
   evaluated? Final selection remains blocked on focused external
   crypto/security review.
7. Which durable monotonic-state and immutable-witness technologies, retention
   period and recovery-point objectives are acceptable?
8. Approve the engineering ranges and assign capacity, device/infrastructure
   budget and an external review window?
9. What explicit ceremony authority will later permit generation/import of
   test-like staging keys and, separately, production roots? Accepting this ADR
   alone must not grant either authority.

## Blockers and consequences

Until this record is explicitly accepted:

- no signer-service or mirror repository is created or initialized;
- P04B/P04C runtime implementation does not start;
- no key, seed, mnemonic, HSM object, signer identity or delegation is
  generated, imported, inspected or rotated;
- no production manifest, registry, XNode, Docker/network deployment or public
  endpoint changes;
- P06/P07/P04D may consume only the already accepted P04 contract within their
  own approved scopes; they must not invent a signer;
- no local implementation result may be described as production-ready.

Even after internal approval, production activation remains blocked by a
focused independent crypto/security review, approved signature
algorithm/provider, custody and recovery design, authorized key ceremony,
cross-language verification vectors, durable-state/fork drills and integrated
P04B/P04C/P04D/P06/P07 evidence.

## Proposed decision

Recommend Option A and the two-repository split:
`deep-membership-authority` owns building, threshold signing, quorum assembly
and append-only witnessing; `deep-bridge-mirror` owns public byte-identical
distribution only. Mr. X owns all internal human decisions, while technical
signer independence and external review remain mandatory.

**No decision has been made.** Replace this section and change status to
`Accepted` only after Mr. X provides an explicit answer to the decision
questions and the exact approved boundaries are recorded.
