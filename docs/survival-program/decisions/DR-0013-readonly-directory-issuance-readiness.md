# DR-0013 — read-only directory issuance readiness

Status: **accepted API extension; runtime/soak release gates remain open**
Date: 2026-09-29
Decision owner: **Mr. X** (delegated pre-production clean-break authority)

## Verified gap

Registry could report DID2 readiness with an invalid or expired current XNV1,
then reject actual proof issuance. An issuance request is not a health probe:
it durably consumes a one-use nonce and invokes witness custody. Duplicating
the signed-view/time verifier in Registry would create two security boundaries.

## Frozen API

`AccountDirectoryProofAuthor.RequireIssuanceReady(
VerifiedXPointNetworkAuthority, AccountDirectoryProtectedLkg,
AccountDirectoryProofAuthoringRequest): void` shares the existing authoring
head/time/reader/authority/signed-XNV1 checks. It null-checks inputs and rejects
the same issuance-context failures. It does not check query-specific history,
prove signer availability, sign, consume a nonce, write state or return a
freshness/mutation capability. Passing readiness never authorizes a request.

This is a separately frozen additive producer API. The Protocol positive
public-API snapshots must replace the predecessor snapshots with the reviewed
Debug and normalized Release identities; package graph and negative gates stay
enforced. Existing wire bytes, cryptographic domains, suites, identities and
stored generations do not change. Consumers need a source/package repin to use
the method; no account, node-key, genesis, database or rollback-floor reset is
required or authorized. No package publication is implied.

## Service consequence

Configuration/custody validation remains eager. Temporary dependency loss must
not prevent the host and its bounded renewal worker from starting. Liveness
and issuance readiness are separate; operations perform independent fail-closed
verification. A returning dependency can restore readiness with retained state.
Corruption/forks/rollback are not repaired by this behavior.

Canonical time and history semantics remain owned by
[ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md](../../architecture/ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md).
This change does not implement NTS acquisition, reboot time re-attestation,
automatic view/traffic-key rotation or catch-up beyond the existing head tail.
Host/DI unit tests are not real Docker, PostgreSQL/TLS or device evidence.
