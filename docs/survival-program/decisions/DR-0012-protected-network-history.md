# DR-0012 — restart-safe DID2 network history

Status: **accepted; local codec/host gates passed, live activation pending**
Date: 2026-09-28
Decision owner: **Mr. X** (explicitly delegated architecture authority)

This decision extends DR-0010 under the owner's clean-break delegation. It is
not an independent security review or runtime/release activation. ONION wire,
crypto domains and network record vectors do not change.

## Verified gap

The existing predecessor API accepts a process-local verified network capability.
Restart rehydration requires that retained view's fresh DTT1, which cannot be
borrowed from the new terminal view and may already be expired. A protected view
tuple alone also omits policy and PMT lineage. Repeated null-predecessor creation
must not replace durable monotonic verification after restart.

## Frozen API and semantics

- `OnionNetworkProtectedHistoryCodec.Encode(VerifiedOnionNetworkContext): byte[]`
  exports only a complete verified network's non-secret LKG plus exact terminal
  signed XVP1 and PMT2. No raw key, time, nonce or directory capability is exported.
- `OnionNetworkProtectedHistoryCodec.BindsPredecessor(VerifiedOnionNetworkContext,
  ReadOnlyMemory<byte> exactProtectedHistory): bool` compares the entire protected
  predecessor against a digest owned by the verified result. Host CAS requires
  this binding, not only the LKG tuple: two signed PMT forks could otherwise share
  a view/head tuple. No public digest getter, setter or trust callback is added.
- `OnionNetworkContextVerifier.VerifyFromProtectedHistoryAsync` has the same
  DID2 authority/freshness/five complete ordered chain inputs as DID2 `VerifyAsync`,
  replacing the process-local predecessor parameter with
  `ReadOnlyMemory<byte> exactProtectedHistory`; time authority and cancellation
  remain mandatory. No V1 freshness overload is added.
- `OnionLocalNodeKeyFactory.EnsureInstalledPublicKey(VerifiedOnionNetworkContext,
  ReadOnlyMemory<byte> localNodeId, ReadOnlyMemory<byte> installedOnionPublicKey): void`
  rejects unless the complete current verifier-selected traffic public key
  equals the operator-installed key. It exports no raw key and mints no
  receive capability; the host cannot duplicate internal current/next selection.
- The caller must authenticate and protect the exported local bytes before
  restoring them. They are not a network record or independent authority.
  Protocol fully verifies the current bounded genesis-to-terminal signed chains,
  then proves the protected prior network/head/view/root/authority, exact prior
  policy and PMT canonical signed bytes occur in those verified chains. Equal tips
  are idempotent; rollback, omitted prior history, fork and cross-network tuples
  reject. Prior expiry is not a reason to erase this history, nor does the history
  grant permission to open expired traffic keys.
- This initial full-history boundary requires an unchanged XNA1 authority
  core reference. An authority rollover rejects rather than resetting the floor;
  verified authority-ancestor inclusion is a separate future extension.
- Only the terminal view uses the caller's newly acquired nonce-bound DID2/DTT1
  proof and monotonic deadline. Prior views are historical linkage evidence,
  never separately revived receive capabilities. A successful result carries
  the actual protected prior LKG; an existing XNF checkpoint marker is preserved.
- Local capsule DNH2 is canonical: 16-byte header (`DNH2`, u16 version 2,
  u16 reserved zero, u32 XVP length, u32 PMT length), 225-byte LKG body in order
  network16/head-reference38/tree-size8/root32/view-reference38/view-generation8/
  authority-reference38/checkpoint-presence1/XNF-reference38/checkpoint-generation8,
  then the exact signed XVP1 and PMT2. Integers are big-endian; absent checkpoint
  fields are zero; each signed record is bounded by 65,535 bytes. No trailing
  bytes, alternate generation or reader/migration is accepted.

## Host custody

The DID2-only host serializes fresh verification and floor CAS in one writer
lease. The floor is bound to immutable network/node scope and a random instance
ID, protected with a separate Data Protection purpose. An independent protected
anchor is persisted before the state replacement. Any split/crash/rollback or
missing half fails closed; no silent empty regeneration or repair is allowed.
The capability is released only after durable write and exact floor recheck.
Coordinated rollback/deletion of both state and anchor remains outside this
local store's guarantee and must be documented, not claimed detectable.

Local DNF2 plaintext has a 68-byte header: `DNF2`, u16 version 2, u16 kind
(0 floor / 1 anchor), u64 revision, random instance16, SHA-256(history)32,
u32 history length. Both kinds retain the same nonzero history length and
digest; the floor appends exact DNH2 and the anchor appends nothing. The length
is the authenticated history length, not the envelope's appended payload size.
The caller authenticates both with the separately scoped Data Protection purpose.

The real signed three-host gate also exposed a replay adapter width mismatch:
NETCODEC network IDs are 16 bytes, not the 32-byte digest type used by the old
adapter tests. Local replay custody is clean-broken to `XONRPL02` and the
`Deep/XPoint/V2/xnode-replay-scope\0` / `xnode-replay-entry\0` domains. The scope
is exact network16/owner32/key32/handle32/expanded-boot32/u64 epoch/u8 position/
frame-hash32, followed by the separate replay-entry hash. Old local state
rejects without rewrite, reader or migration. Operator reset is restricted to
disposable pre-activation UAT replay state, never registered node identities,
account data or directory/network rollback floors. ONION network wire is unchanged.

No node identity, registered BLS key, certbot, carrier configuration, account
identity or application database is migrated or reset. Observer DID2 is public
and independently configured; it is never selected from an incoming request.

## Client account custody extension (2026-09-29)

Accepted under the same delegated Mr. X authority; not release activation.
The existing DID2 SQLCipher account writer lease owns the complete DNH2 and
its LKG projection in one transaction. Root kind 3 retains the current NLK2
projection; root kind 7 contains the unchanged canonical DNF2 kind-0 envelope
and exact DNH2. Both SQL revisions must agree. The DNF2 instance is the first
16 bytes of the already protected random database instance. Its kind-1 anchor
is stored in account-scoped SecureStorage, separately from SQL, with a purpose
bound to account/network/genesis. Both this anchor and the existing exact
projection marker are written before either SQL row commits. Split, missing,
corrupt or rolled-back halves fail closed. Coordinated rollback/deletion of
SQL and protected storage remains outside this local guarantee.

Only an internal account-owned store accepting a complete
`VerifiedOnionNetworkContext` can initialize or advance history. Under the
writer lease it compares the exact protected predecessor, including
`BindsPredecessor`, before CAS; current capability and cancellation are
rechecked before markers and after durable re-read. Generic raw LKG CAS may
only preserve the same floor/history and monotonically latch a fork; it
cannot initialize or advance a DID2 account's network authority.

Every current-proof mint, including after restart, uses the durably retained
DNH2 through `VerifyFromProtectedHistoryAsync`; a process-local cache or
tuple-only rehydration is not a fallback. The verified prior tuple must match
the retained projection. Expired historical view/policy/PMT records remain
lineage evidence, never fresh traffic permission. The signed terminal proof
and verifier time windows are unchanged. An initialized projection without
its full-history row is incompatible and rejected without migration, silent
bootstrap, repair or deletion. Disposable pre-activation clients may use
their explicit application-owned reset; production network/directory floors
and registered node identities are not reset by this client change.

## Required evidence

Signed DID2 proof/network closure, idempotence and restart; monotonic successor
with expired historical traffic keys; omitted/forked policy/view/head/PMT,
cross-network, hostile capsule and forged signature negatives; anchor/state crash
and rollback; live TLS publication to both replicas and physical device E2E.

## Current evidence and non-claims

Protocol: Debug/Release builds without warnings, actual exact-three assembly/
resource/public-API graphs, 1,856 Protocol tests (11 explicit native-harness skips),
131 MembershipRoutes and 105 ProfileCarrier tests; DNP1 evidence mapping covers
219 package vectors with no missing mapping, and manifest integrity passes.
The current API snapshot replaces the previous snapshot; there is no dual acceptance.

XNode: signed DID2 file source, floor and independent-anchor restart/CAS/crash/
corruption/installed-key/proof-expiry gates, signed multi-role three-host receive
for all six permutations, encrypted key slots and real durable replay/entropy.
Replay after restart rejects before forwarding. Readiness also checks the actual
live capability rather than a retained boolean. The host test deliberately seals
unavailable for a canonical V2 commit carriage; it does not claim staged inventory,
two final receipts, a live claim, a message or a device run.
The full solution passed 431 Integration / 107 ProfileGenerator / 262 Core tests;
the final readiness change passed the complete 432-test Integration assembly,
and the final full-predecessor binding passed all 38 affected host/source gates.
Release solution builds without warnings. The unaffected suites are not presented
as an additional physical run.

Installer syntax/behavior tests pass; fixed-role CLI/config inputs are removed.
DevOps first-release configuration tests pass 9/9 and production-ingress contracts
pass 32 checks. The isolated multi-node rehearsal confirms three real non-mocked
Xray processes and Registry membership, while privacy authority deliberately
remains unavailable. It is process/build/fail-closed evidence, not DID2 TLS delivery.
Release contract fixtures pass; actual production-readiness remains blocked on
missing release/device/ops/security/GA evidence. Fixture reports are not activation.

Pending: supported DID2 proof/observer/complete-history rollout, exact final
publication to both selected replicas, live TLS and physical Android/Windows
contact/DPH2/message/attachment/group evidence. No production node or registered
identity was changed by this local batch.
