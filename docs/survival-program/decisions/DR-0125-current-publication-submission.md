# DR-0125 — one current submission over immutable publication intent

Status: accepted clean-break target; implementation/activation open
Date: 2026-10-15
Decision owner: Mr. X (delegated architecture authority)

## Observed defect and scope

The retained Android phase5 reached DR-0124 READ and the private issuer reported
`Winner/winner-missing`; the device still returned unknown completion. The
serial observation is not an identity-correlated noncommit certificate. It does
show that recovering only completed winners is not a complete publication
lifecycle. An initial request can expire without reaching the issuer, or after
reservation but before a response. Neither an unsigned failure nor a local
timeout authorizes abandoning its exact intent or permanent fence.

Use one independently current publisher-signed submission for every reusable
phase5/phase6 issuance/retry. It carries the exact signed original V4 intent.
Fresh submission authority is not persisted as a replacement for that intent.
The issuer's existing permanent GetOrIssue transaction handles missing,
reserved-pending and completed requests under the SAME original nonce and
generation key. No noncommit certificate, fence deletion, backdated approval,
account reset, journal generation, compatibility reader or new secret is added.

XPL1 remains the only current reusable replica-mutation envelope. Its record,
witness purpose, original-XPU effect identity and two-store/XPO semantics are
unchanged. Separate target3 lease requests and target4 completed-only READ are
retired/reject after the matched cutover; the associated encoders, endpoints,
positive vectors and public authoring APIs are removed, not kept as fallbacks.
Target2 V4 is then strictly one-time kind2/genesis only. Route target1 is unchanged.

## Exact current wire

Allocate XCA2/XCS2 target5 `PublicationCurrent`, ONION ContactResolve4,
placement kind8/class1. Do not reuse retired IDs3/4.

Request version1/reserved0/header8, followed in exact order by network16,
freshNonce32, directoryLeaf32, minimumCurrentADHGeneration8,
minimumCurrentADHHash32, currentViewHash32, issued8, expires8,
LP32(exactOriginalSignedV4Intent), currentPublisherSignature64.
Fixed overhead244; original V4 length23322..171614; total23566..171858.
The unsigned transcript removes the final64 bytes and rewrites the header total
to that unsigned length. Use existing SIGINPUT framing, suite0x0301, domain
`Deep/ContactResolver/V2/publication-current-request`.
Derive gateway shard with SHA256-D(
`Deep/ContactResolver/V2/publication-current-gateway`, network16||freshNonce32).
Fresh nonce is owned CSPRNG output, never a replacement for the original nonce.

Network/leaf must equal the enclosed original. The original must be reusable
kind1 with a canonical publisher signature, exact owned route/object/locator,
generation/predecessor and resource bounds; its original short window is an
immutable authorship fact, not current issuance/dispatch permission. Its issue
cannot be future. V2/V3 and one-time original intents reject in target5.
The current envelope covers at most120s and the complete conservative protected
interval, clipped to current proof/head/root/DCA/device/network, gateway and
PublishInvite placement plus every original object/route resource ceiling.
Expired original resources still reject; their handover remains separately gated.

Response version1/reserved0/header8, network16, freshNonce32,
LP32(exactXPL1). Overhead60; XPL1 length15107..96397; total15167..96457.
Bind fresh nonce/network/window/view to the lease, and bind its embedded original
XPU to every exact original V4 body field before independent verification.
Response parsing is never owner, witness, commitment or dispatch authority.

Private HTTPS endpoint `/api/v2/contact-publication-current`, media
`application/vnd.deep.contact-publication-current-{request|response}.v1+octet-stream`.
Existing node peer authentication binds target5 and the exact complete request.
No client Registry URL/fallback is introduced. XCA2 wrapper maxima become the
exact derived171870 request /96469 response bytes; the existing131072 global
ContactResolve success ceiling is unchanged. No other operation bound changes.

## Original intent versus actual approval time

Keep the original V4 request, its nonce/operation/generation, ciphertext, owned
Retrieve capability and original short time facts byte-identical. XPU body
tags5/6 continue to bind those exact original time facts through the authorized
body hash; they are NOT renewed permission to dispatch a reusable XPU alone.

When no completed winner exists, author a new XPA at the ACTUAL current trusted
lower bound, with not-before at that bound and expiry clipped to the verified
current submission and all resource ceilings. XPA tags15/16/17 therefore describe
actual approval, independently of the original XPU body time facts. Its tag18
is the actual current issuing ADH; XPU carriage view/placement are actual current
issuance facts. Original-carriage containment therefore checks the actual XPA
approval interval against that carriage, not the immutable body authorship
interval against a later view. Never sign against a fabricated historical head/time. XPA must
cover current time before/after every signer callback and final durable release.
Its approved-body hash still binds ALL immutable original XPU body fields.

For reusable retained intent, require XPA issue >= original intent issue,
canonical approval interval <=120s, not-before equal approval issue, expiry <=
effective object/resource horizon, genuine original-issuance XNA/head/view and
threshold signatures. Do not require approval timestamps to equal the old body
window. One-time direct-current verification stays strict and unchanged.
A current XPL independently reauthorizes mutation under current witness/head/
placement/time; an original XPA, whether expired or not, is never that permission.

## Issuer transaction and response

Before journal/signing callbacks, defensively copy/bound both envelopes and
independently verify current DID2/DCA/device, nonce-bound proof, root/network,
complete protected interval, exact original publisher signature and route/object.
For a successor, verify exact original prior-XPO and completed predecessor
through the existing independently authenticated journal lineage.

Use the existing original-request journal transaction and permanent generation
fence. Missing creates the ordinary first reservation/count once; pending
completes that SAME reservation; completed returns the exact stored original
response without another XPA signing callback. Conflicting nonce/body, corrupt
projection/fence/predecessor, unavailable proof/signers or changed authority
reject without repair/replacement. A competing current submission cannot fork
the original winner. Commit/read back the exact original response before release.

Authenticate the returned original intent independently, then mint XPL1 with
the submission fresh nonce/window and exact original-XPU request hash. Recheck
unchanged root/head/view, winner, owner and clock around signing and release.
No new XPL replay identity or durable per-submission ledger is needed: replay
effects remain keyed by the original permanent request and original XPU hash.
Current replay and rate/size limits remain bounded.

## Owner and cutover

The actual owner holds its existing lease/custody loan. In phase5, author/sign
the fresh submission over record9 and authenticate the returned original XPU
plus current XPL. Canonically reconstruct the exact original V4 response from
that XPU and original nonce, CAS/read back record10 (phase6), preserving every
original/scalar slot. A crash before/after that CAS resumes the same intent.
Phase6 obtains the same current submission over record9 and requires byte-identical
stored XPU before dispatch; it never replaces the permanent winner. An already
current verified XPL from phase5 may be used within its unchanged deadline.
Phase7 restores the same verified two-store commitment without issuance.
The two XPO receipts must continue to bind the ORIGINAL XPU request hash.

Remove retired target3/4 wire/API/endpoint consumers together; preserve XPL1,
historical original-intent verifiers and the one-time path. Existing current
route/account/database/journal generations remain; no Session reader or slot
conversion is allowed. Frozen machine contracts, codecs, API surface, source
anchors, schemas/vectors and all consumers must cut over together. Until then
no mixed runtime/device/release activation is claimed.

The mandatory business-batch tests cover initial issuance, an original never
sent until expiry, reserved-pending expiry, completed/lost response, concurrent
submissions with one exact winner/count, encrypted cold reopen at phase5/6,
lost Store reply and exact phase7 adoption, original-slot preservation and no
phase7 callbacks. Include owner/device/body/predecessor substitution, hostile
bounds, retired targets, callback mutation, signer failure, cancelled/deadline,
clock rollback and changed proof/head/view/epoch/cohort/resource rejection.
Actual native source/package gates and same retained Windows/Android profiles
remain required. Component PASS cannot satisfy S05/S06, delivery or release.

## Exact source-qualification case retirement

The separate lease-request gateway case is replaced by the current-submission
case. Both verify genuine selected gateway, private peer authentication, exact
response pairing and wrong-view rejection; the removed target3 is not retained
as a positive path. Qualification must require the replacement to pass and keep
all unrelated cases. This declaration does not waive any failure or skip.

```text
XNode.IntegrationTests.Runtime.ContactCoordinationOnionDispatcherTests.FreshPublicationLeaseUsesCurrentViewGatewayAndAuthenticatedPairedPrivateTarget -> XNode.IntegrationTests.Runtime.ContactCoordinationOnionDispatcherTests.CurrentPublicationUsesCurrentViewGatewayAndAuthenticatedPairedPrivateTarget
```
