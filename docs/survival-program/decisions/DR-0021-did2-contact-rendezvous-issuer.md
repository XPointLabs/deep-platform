# DR-0021 — DID2 current contact-rendezvous issuer

Status: **accepted bounded verification API; runtime activation gated**
Date: 2026-09-30
Decision owner: **Mr. X** (delegated architecture authority)

## Decision

The inbound contact update rendezvous is verified against a nonce-fresh current
DID2 directory checkpoint, not DAB1 or a caller-supplied device key. Freeze the
closed API `DeepIdV2ContactUpdateRendezvousVerifier.VerifyAsync(exactXur1,
VerifiedDeepIdV2DirectoryFreshness, OnionTrustedTimeAuthority,
CancellationToken)` and its non-publicly-constructible result
`VerifiedDeepIdV2ContactUpdateRendezvous`.

This is an issuer/time capability only. It grants no verified placement, route,
contact acceptance, session, publication, delivery or ACK. The exact PMT2 route
closure and its independent freshness remain mandatory before transport use.

## Existing wire, new identity binding

The identity-neutral XUR1 wire, version 1/suite 0x0201, existing device signature
domain and exact bounds remain owned by
[CONTACT-RESOLVER-V1 section 3.5](../../architecture/CONTACT-RESOLVER-V1.md#35-established-contact-update-service-xur1--xuw1--xuq1--xus1).
Its device/transport fields contain no DID1, DAB1 or SessionId. Keeping this
wire is not a legacy-identity reader, conversion or protocol fallback.

The first-contact result requires generation zero, zero predecessor and all
three contact-control event bits. Its network, issuer device and exact DPD1
reference must match an active device in the exact DID2 current DMD1. Verify
the signature only with that checkpoint's independently verified device key.
Its validity must contain the entire authenticated time interval; expiry is
half-open. Recheck a protected monotonic sample after verification, rejecting
boot change, backward sample, proof expiry or interval overflow. Own the exact
input before the first await. Cancellation returns no result.

## Consumer consequences

Protocol owns this verifier and negative issuer/time/scope tests. Shared will
use it for DID2 ContactHello/Accept only after their DAB2 payload boundary is
separately frozen and implemented; no V1 relationship adapter is authorized.
MAUI shipping contact composition and physical Windows/Android contact,
message, attachment and group tests remain open. Do not publish a release or
claim the complete user flow from this bounded verifier.
