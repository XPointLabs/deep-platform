# DR-0007 — Keep the resolver read capability out of public DID2 records

Status: **accepted clean-break architecture; local codec/vector/store gates passed, live device gates pending**

Date: 2026-09-24
Decision owner: **Mr. X** (delegated architecture authority)

## Problem

The current unfrozen DID2 candidate places the raw 16-byte resolver read
capability in field 3 of the canonical DID2 record. Both DGA1 V2 admission
and DPQ2 proof requests carry that exact record to Registry. This discloses a
bearer retrieval capability to the directory authority, contradicting the
crypto specification and the account-directory metadata boundary. TLS and
OHTTP do not hide a request body from its endpoint. There are no public users,
so no compatibility obligation justifies preserving this candidate.

## Decision

1. The immutable DID2 root credential contains the Ed25519 and ML-DSA-65
   verification keys and a 32-byte **commitment** to the separately derived
   resolver read capability, never the raw capability. The commitment is a
   domain-separated SHA-256 digest of the exact 16-byte capability. The
   complete credential, including the commitment, remains under the DID2
   record hash authenticated by DAB2. No new algorithm or runtime dependency
   is introduced.
2. The compact Deep ID retains its 49-byte payload: version, DID2 record hash
   and raw read capability. A holder verifies both the exact credential hash
   and the capability commitment before using the address. DID2 bytes alone
   cannot reconstruct the compact address or grant resolver reads.
3. DGA1/DPQ2 may carry the exact public DID2 record only after field 3 has
   changed to the commitment. Registry, its logs, public directory artifacts
   and XNode requests never receive the raw read capability. A client stores
   the capability separately in account-scoped protected state before the
   recovery phrase may be deleted; restart must verify it against the exact
   DID2 commitment and preserve the same compact address.
4. The existing 2036-byte raw-capability DID2 candidate, its text/vector
   projections and all dependent signed fixtures are retired test inputs,
   not a release reader or migration source. The replacement DID2 codec,
   machine registry, vectors, DAB2 signatures, DGA1/DPQ2 lengths, account
   store, contact/QR/safety-number consumers and negative cross-feed tests
   must be re-frozen together. No dual parser or alias is allowed.

## Release gates

- Freeze the exact commitment domain/transcript, canonical field length,
  machine registry and positive/negative vectors in `deep-protocol`; verify
  raw-capability bytes cannot be recovered from DID2 or Registry requests.
- Re-author DID2/DAB2/ADC1 V2 and all dependent UAT fixtures. Destructively
  reset the pre-production DID2 state; never reinterpret the old bytes.
- Demonstrate offline create → restart → phrase deletion → restart with the
  same compact address and verified commitment on Windows and Android.
- Demonstrate live admission/proof without exposing the raw capability to
  Registry, followed by the contact/message/media/group device E2E gates.

Until these gates pass, the current DID2 candidate remains non-production
even if its cryptographic tests are green.

## Implementation checkpoint (2026-09-24)

The 2052-byte DID2 commitment codec, independent transcript vectors, strict
machine-registry anchors, DGA1/DPQ2 lengths, re-authored public Registry
fixture, and protected capability slot are implemented. Protocol, Registry
focused and shared-client tests verify the replacement, including restart
after recovery-phrase deletion with the same compact address. This is not
release activation: UAT reset, physical Windows/Android admission/proof and
contact/message/media/group device E2E remain mandatory.
