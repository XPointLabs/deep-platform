# DR-0123 — retained publication intent and fresh mutation lease

Status: accepted connected clean-break target; runtime/reconciliation activation open
Superseded request/API scope: [DR-0125](DR-0125-current-publication-submission.md)
removes the separate lease-request protocol. XPL1 and authenticated-intent
separation remain; the following describes the original decision, not a fallback.
Date: 2026-10-15
Decision owner: Mr. X (delegated architecture authority)

## Observed boundary

The same retained Windows owner passes current network, strict TLS and exact
prekey-pair restoration after DR-0122, but its phase-6 publication request has
expired. Its current route/object remain verifiable. Replacing the original
request, operation, nonce, ciphertext, generation or XPA would change replay
identity and contradict the permanent issuer fence. An unsigned None outcome
does not prove durable absence on both replicas.

Separate authenticated original intent from a fresh mutation lease. The original
intent alone never grants permission to replay an expired request. The normative owner is
[CONTACT-RESOLVER](../../architecture/CONTACT-RESOLVER-V1.md).

## Closed original-intent facts

Freeze two nonconstructible, nonserializable read-only results:
`VerifiedDeepIdV2OwnedPublicationIntent` and
`VerifiedDeepIdV2IssuerPublicationIntent`. Neither exposes dispatch, current
mutation, signing, commit or generation-reservation authority. The owner result
requires its authenticated signed/decrypted contact object. The issuer result
verifies signed public object/support and exact ciphertext hashes, but cannot
claim decryption and receives no resolver capability.

`DeepIdV2PublicationCommitVerifier.VerifyOwnedRetainedIntentAsync` takes the
current verified reusable route, owned object, exact original publisher request
and XPU. `VerifyIssuerRetainedIntentAsync` takes the current verified reusable
route, exact original publisher request and XPU without client decryption
evidence. Both use the route's protected clock; no caller time, raw key,
historical/currentness switch, fake XPO or saved verified object is accepted.

Before callbacks, bound and defensively own all candidate bytes. Verify exact
request/body/object/route/generation/locator/owner and publisher signature,
original XPA witness signatures under their actual authenticated issuance XNA,
original carriage placement and selected pair, canonical original request/XPA
windows and signed inner containment. Original issue cannot be future. The
original request/XPA may be expired, but the current DID2/DCA/device, current
logical assignment, live route/object/service, network, policy and protected
time must independently remain current at entry and final release. Recheck
boot/sample and trusted interval continuity across callbacks. Wrong issuer,
missing history, changed epoch/cohort, mutated inputs or cancellation reject.

The result identifies the original exact request and generation only. It does
not prove zero/one/two replicas committed, release a permanent issuer fence,
retire a pending record, renew the object or adopt a successor. Both-node XPO
verification remains separate and mandatory for commitment.

The private Registry journal may read a completed original winner by exact
network-scoped nonce, expected directory leaf and exact original XPU request
hash. Copy/bound lookup inputs before awaits, acquire the existing network
transaction lock, authenticate canonical row projections/response pairing and
require its permanent generation fence and completed predecessor. Missing,
pending, substituted, ambiguous or corrupt state rejects without signer calls,
reservation, count change, deletion, repair or DDL. Returned bytes are not
Protocol authority and must pass the independent current intent verifier.

## Fresh lease and one current publication path

Allocate `XPL1` as the current REUSABLE publication mutation envelope. XPU1 remains the
exact immutable signed intent INSIDE it, not a second standalone mutation path.
Matched client/node/peer cutover rejects standalone REUSABLE XPU publication before
reservation, storage or receipt callbacks. No legacy reader or fallback is added.
Existing protected route journal, original XPU/XPA bytes and permanent issuer
rows remain unchanged: this is not a journal generation or state migration.
The distinct one-time policy10/usage1 genesis operation keeps its existing
strict current XPU/XPA window; this increment neither renews a one-time target
nor routes it through reusable recovery. That is a separate current operation,
not a legacy reusable fallback.

XPL1 uses the canonical ApplicationRecord header12, version1, suite0x0301,
reserved0 and exactly tags1..11 in increasing order. Fields are network16,
original-XPU-requestHash32, current-viewHash32, current-PublishInvite-placementHash32,
issued8, expires8, current-ADH-coreHash32, fresh-lease-request-nonce32,
EXACT-original-XPU14622..93032, witness-count1 and strictly ID-sorted distinct
`witnessId32 || signature64` rows96N, N=2..32. No padding or trailing fields.
Length is exactly293 + originalXpuBytes +96N: min15107, max96397. Witness signing
input is existing SIGINPUT framing under `Deep/ContactResolver/V2/publication-lease`,
suite0x0301, canonical unsigned tags1..10. Reuse current authorized witness keys;
no root-online copy, new secret, key conversion, AEAD or crypto library is needed.

All fields and sizes are bound before allocation/callbacks. New lease intervals
are at most120s, derived from the complete current conservative interval and
clipped to current network/head/root/DCA/device/inner-resource bounds. They do
not borrow the old XPA deadline. Fresh current XNA/witness threshold, distinct
failure domains, exact current ADH/view/placement and protected boot/sample/time
continuity are independently checked at entry, around signing and final release.
The original XPA/placement signatures remain historical evidence only. The old
and current selected resolver node-ID pairs must coincide under independently
verified current eligibility; current admitted descriptors supply all transport
and role facts. Changed cohort/epoch/device/delegation requires its own handover.

Extend existing XCA2/XCS2 coordination with target3 PublicationLease, still ONION
ContactResolve4 and placement kind8/class1. Its request is exactly304 bytes:
header8 (`version:u16be=1, reserved:u16be=0, total:u32be=304`), network16,
freshNonce32, originalCoordinationNonce32, directoryLeaf32, minimumADHGeneration8,
minimumADHHash32, originalXPURequestHash32, currentViewHash32, issued8, expires8,
publisherSignature64. Signing input uses existing SIGINPUT under
`Deep/ContactResolver/V2/publication-lease-request`, suite0x0301, the unsigned
240-byte canonical request with header total rewritten to240. Fresh nonce is
owned CSPRNG output, never a replacement for the original request nonce. Derive
gateway shard as SHA256-D(`Deep/ContactResolver/V2/publication-lease-gateway`,
network16 || freshNonce32). Current view/network/time gate the gateway; the issuer
independently verifies original logical assignment from its journal.

Response is header8(version1/reserved0/total), network16, freshNonce32,
LP32 exactXPL1: exactly60 + leaseBytes, min15167/max96457. Pair target/network/
nonce, original request hash, view and window before release. Existing global
ContactResolve bounds suffice; other operations' bounds are not enlarged.
The private endpoint is `/api/v2/contact-publication-lease`, with request/response
media `application/vnd.deep.contact-publication-lease-{request|response}.v1+octet-stream`.
Existing closed peer authentication binds target3 and the exact whole body;
no public Registry resolver or direct-client fallback is introduced.

The issuer fetches the completed permanent original winner, independently
verifies current owner/DCA/device proof and the fresh publisher signature, then
rechecks that same winner around every witness/release callback. It never
reserves another generation, changes old rows/counts or backdates original XPA.
The fresh request/lease is permission for one existing idempotent effect, not a
new effect identity. Repeated fresh leases may differ without forking that intent.
At both stores, saga/request/op/ciphertext/CAS and node receipt tuples continue
to name the ORIGINAL XPU hash and original generation. Never key replay on XPL
or a fresh lease nonce. Peer writes and receipt issuance each reverify the full
current lease. Expiry, cancellation or response loss preserves exact pending
custody; the next current lease can reconcile only that same original effect.

The account holds its existing lease/loan, keeps phase-6 request/XPU and scalars
byte-identical, obtains a fresh typed lease and verifies both original-hash XPO
receipts before atomic phase-7 adoption/readback. XPL need not replace any journal
slot: it is an ephemeral current mutation lease, not a new encrypted intent.
Reserved-without-winner and expired inner resources still require separate
closed settlement/handover; none of these facts can free a fence or make them live.

Use genuine account/device/witness signatures, current proof renewal and exact
old bytes after request expiry. Cover owner versus issuer decryption claims,
substituted publisher/ciphertext/threshold/route, future issue, hostile lengths,
callback mutation, cancellation and clock discontinuity. Ordinary expired-XPU
verification must still reject. Source/API/package, permanent-winner/peer/client
recovery, real retained owner and Windows/Android E2E remain activation gates.
