# DR-0116 — offline root continuity after operational expiry

Status: accepted pre-production semantic clean break; source/runtime qualification pending
Date: 2026-10-14
Decision owner: Mr. X (delegated architecture authority)

## Boundary and rationale

[XPOINT-NETWORK §7.1](../../architecture/XPOINT-NETWORK-V1.md) is the sole
normative owner. Offline root transition authority and current operational
authority are distinct. Missing a scheduled policy renewal must not require
backdating a new signature, replacing genesis, resetting protected floors or
inventing fresh node identities. Retained authenticated root keys may authorize
their exact next successor after the predecessor's operational expiry.

This follows the separation in [TUF1.0.36 §5.2–5.3](https://theupdateframework.github.io/specification/v1.0.36/):
authenticate the root update chain first, then require the terminal root to be
current before ordinary operations. It does not import TUF formats or tooling.

## Closed transition rule

XNA1 retains its exact grammar, signature domain and predecessor threshold.
A transition must have the same network, exact generation+1 and predecessor
core, and signatures from the retained predecessor root set meeting that
predecessor threshold. Successor issued-at must be at least predecessor
issued-at and not-before; successor not-before must be at least predecessor
not-before. The successor's own issued-at <= not-before < expires-at and
existing400-day bound remain mandatory. Intersecting effective windows are
not required for this offline transition. New root keys cannot self-authorize.
DTS1 still verifies against the exact paired successor authority and the full
original-genesis chain. Fork/rollback, missing history, altered pins, unknown
keys, insufficient thresholds and malformed/bounded bytes still reject.

`AuthorSameKeyRenewalAsync` remains the sole routine producer, with no fallback
overload or caller-approved recovery flag. It requires non-regressing issued-at/
not-before, unchanged-or-later authority expiry, non-regressing DTS not-before,
strictly later DTS expiry, complete paired predecessor authentication, exact
retained signer custody and unchanged existing400-day/30-day bounds. It preserves
keys/thresholds/failure domains and returns authored bytes only. Offline tooling
must use actual independently acquired observation time, never a clamped/backdated
time chosen to fit the expired predecessor. This supersedes DR-0108's overlap
requirement only; the rest of its signing/history separation is unchanged.

## Root policy versus operational horizon

The existing sole `XPointNetworkOperationalSuccessorRequest` constructor appends
`ulong rootPolicyExpiresAtUnixSeconds = 0` and exposes
`ulong RootPolicyExpiresAtUnixSeconds`. Zero chooses the operational expiry.
An explicit expiry must cover the operational interval, be within terminal
authority and at most30days from not-before. Only offline `AuthorAsync` applies
it to the new root-signed XVP1/PMA2. XND1/XNV1/XNH1/PMT2 retain the short
operational expiry and existing24-hour bound. `AuthorDelegatedAsync` rejects
an explicit different horizon before signer callbacks; it keeps exact already
authorized policy/PMA bytes. This matches the existing genesis producer's
root-policy/operational separation, without a new wire field or dual reader.
It prevents a root renewal from accidentally delegating only the first short
view's lifetime. Constructor/API/package consumers require coordinated repin.

## No operational grace or custody repair

The expired predecessor is historical root-continuity evidence, never current
DTT1/ADH1, grant/issuer, mailbox admission, trusted time or transport authority.
No operation is authorized in the availability gap. Current consumers require
the terminal policy and their own nonce-fresh/time/role/protected-floor checks.
Old XVP1/PMA2 cannot be borrowed under the new authority: an offline signed
operational successor must reauthorize policy/PMA and preserve exact retained
view/head/PMT history before delegated renewal resumes. Origin certificates and
installed traffic keys must separately cover the new signed interval.

Unavailable/lost/compromised root threshold remains a different recovery problem;
this rule supplies no administrator override, key reconstruction or new pin.
No root mounts online, volume reset, secret replacement or activation by health200.

## Required evidence and repin impact

Actual root-signed renewal at/after predecessor expiry, mixed complete chain,
unchanged genesis/keys/thresholds and exact generations; predecessor still expired
and old policy/issuer still rejected. Backward signed time, corrupted/missing/
forked predecessor, insufficient/unknown signer, forged successor receipt,
oversized intervals and canceled flights reject before mutation/signing as
applicable. Supported CLI/current operational completion, atomic distribution,
retained process/volume restart and independently verified node/client catch-up
remain mandatory. Frozen registry/schema/vector obligations and all Protocol
consumers must be repinned together. No source gate qualifies installed/dev/
production activation or physical messaging; S05 remains open.
