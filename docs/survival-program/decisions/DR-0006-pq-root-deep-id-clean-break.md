# DR-0006 — Commit a post-quantum root at Deep ID creation

Status: **accepted architecture; wire/provider freeze and implementation pending**
Date: 2026-09-23
Decision owner: **Mr. X** (delegated architecture authority)

## Problem

The current permanent `DID1` contains an Ed25519 address public key. Its
`DAB1` successors are authorized by that key. Merely replacing the public key
with a hash of an *extensible* credential does not solve quantum-safe identity:
if a future PQ key can be added using only the original Ed25519 authority, an
attacker able to forge Ed25519 can introduce an attacker-controlled PQ key while
keeping the same ID. PQXDH/ML-KEM protects a different property (session
confidentiality) and does not repair this authentication lineage.

There are no public users or compatibility obligations. Identity generation
must therefore change **before** the first public release, without migration,
dual readers or a legacy account alias.

## Decision

1. The new permanent Deep ID commits, at genesis, to one canonical immutable
   root credential containing **both** an independent classical Ed25519
   verification key and an ML-DSA verification key (initial candidate:
   ML-DSA-65), their exact algorithm/suite identifiers, roles and binding
   context. The compact human-facing ID may carry a collision-resistant hash
   commitment rather than the large PQ public key, but the complete root
   credential must be presented and verified before trust. An uncommitted
   empty PQ slot, a later Ed25519-only upgrade right, a mutable pointer or a
   Registry assertion is insufficient.
2. Creation and recovery of the same ID must reproduce or restore the *same*
   protected root credential and private signing authority. The 24-word phrase
   remains the user-facing recovery contract; an exact domain-separated seed
   derivation and deterministic ML-DSA key-generation contract must be frozen
   with vectors before claiming phrase-only restoration. If the selected
   provider cannot honor that contract, the design must explicitly specify a
   phrase-protected recoverable root secret and test restore on Android and
   Windows. Account creation fails closed until this is resolved; it never
   silently creates an Ed25519-only identity.
3. Every root-authorized account binding, key succession and recovery
   transition must validate the genesis PQ commitment and require ML-DSA
   authorization from the already trusted root or its PQ-authorized
   successor. During this first suite generation it also requires the
   independent Ed25519 authorization (hybrid AND, not either/or). Exact
   realm, predecessor, generation, anti-fork and expiry rules remain mandatory.
   A future algorithm migration needs a separately frozen transition signed
   by the *existing* PQ authority; loss/compromise without that authority
   means a new ID, not a same-ID reset.
4. Retire `DID1`/`DAB1` version 1 and their current address-key authorization
   from the release graph. A new magic/version/suite, canonical credential,
   signed projections, hash and human encoding must be allocated and frozen in
   the machine registry with positive/negative vectors **before** implementation
   or release. This decision does not declare guessed bytes, signature sizes or
   KDF output to be frozen. Old records are negative fixtures only. All exact
   consumers (contact/QR/safety number, directory, DPH2, DAO1, database and
   account UI) are re-frozen together; no adapter or dual parser is allowed.
5. Do not sign ordinary chat messages or every ratchet step with ML-DSA. The
   root authenticates account/device lineage; pairwise messages continue to
   use the authenticated ratchet. This avoids gratuitous transferable message
   signatures, larger payloads and a false deniability claim.
6. This is a **PQ-root identity** decision, not a claim that the whole system
   is post-quantum. Device certificates, network authorities, ONION-01's
   X25519 traffic keys, group/control signatures and call/media paths have
   separate suites and threat claims. A full-PQ claim stays prohibited until
   each relevant boundary is upgraded and independently verified.

## Provider and release gates

- Evaluate a single managed .NET ML-DSA provider on physical Android arm64 and
  Windows x64/arm64. The .NET platform API is not assumed available on Android;
  Bouncy Castle's managed implementation is a candidate, not an approved
  production dependency. Pin exact package/source hash and license, run FIPS
  204 known-answer and independent differential tests, malformed/signature
  negatives, key-import/export/zeroization checks, memory/battery/latency
  budgets and a side-channel review. Provider failure blocks identity creation
  and release; it does not choose a weaker suite.
- Freeze root credential, recovery derivation, ID encoding, successor
  transcripts, trust display and all affected envelope/locator sizes in one
  reviewed protocol change. Regenerate machine registry, vectors, fuzz targets
  and Android↔Windows cross-implementation recovery/verification evidence.
- Perform a destructive UAT reset. Demonstrate two-device create/restore,
  cross-device root verification, contact import, an authorized successor,
  rejected Ed25519-only forgery, rejected PQ-key substitution, stale/forked
  bindings and account deletion. No production rollout or published client
  before these gates pass.

## Delivery order

This identity clean-break is the first package of the current sprint. Keep
the shortest subsequent vertical slice narrow: one Android sender and one
Windows recipient, real contact closure, one text DPH2/DPE2, durable inbox
then ACK. Attachments and groups follow that proven spine. Non-blocking
research proposals (MLS, additional carriers, mesh, new hash/AEAD suite) do
not enter the first text path without a demonstrated release requirement.
