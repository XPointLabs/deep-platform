# DR-0124 — read back a completed original publication winner

Status: superseded by [DR-0125](DR-0125-current-publication-submission.md)
The completed-only reader and its endpoint are retired, not an active fallback.
The following records the original defect and decision; it does not authorize
restoring removed APIs or treating missing/pending state as noncommit.
Date: 2026-10-15
Decision owner: Mr. X (delegated architecture authority)

## Evidence and scope

Physical Windows/Android reached publication, received an unknown outcome and
retained phase5 (exact publisher request, no XPU response). A later current
attempt correctly rejected the expired original request. DR-0123 starts with a
known XPU in phase6; it cannot recover a response the owner never received.
Read-only current-dev database counts showed six completed publication rows and
no pending rows, but aggregate counts do not identify an individual owner.

Add one explicit, bounded READ operation over the existing private coordination
path. It may return only an already completed canonical permanent winner. It
cannot issue a new XPA, reserve/release a generation, repair a row, sign with a
witness, extend the old request, prove noncommit or authorize storage mutation.
Missing/pending/corrupt/conflicting winners fail closed. Reserved-without-winner
settlement and expired inner resources remain separate work.

## Closed wire and authority

Allocate XCA2/XCS2 target4 `PublicationWinnerRead`, ContactResolve4, placement
kind8/class1. The request is version1/reserved0/total304 header8 followed by
network16, freshNonce32, originalCoordinationNonce32, directoryLeaf32,
minimumADHGeneration8, minimumADHHash32, ORIGINAL-COORDINATION-REQUEST-HASH32,
currentViewHash32, issued8, expires8, currentPublisherSignature64. The original
hash is SHA256-D(`Deep/ContactResolver/V2/publication-winner-original-request`,
the exact complete signed canonical V4 publisher request), NOT the XPU hash
which phase5 does not yet know. No old request field is rewritten.

The current request window is at most120s and clipped to the complete current
directory/network/root/DCA/device/route/object interval. Its signature input is
existing SIGINPUT, suite0x0301, domain
`Deep/ContactResolver/V2/publication-winner-read-request`, unsigned240 bytes with
header total240. Derive gateway shard as SHA256-D(
`Deep/ContactResolver/V2/publication-winner-read-gateway`, network16||freshNonce32).
Peer authentication independently binds target4 and the exact request body.
No generic signing or caller-selected domain/time is exposed.

Response: header8(version1/reserved0/total), network16, freshNonce32, LP32 exact
ORIGINAL V4 publication-authority response. Overhead60, body14682..93092,
total14742..93152. Pair fresh network/nonce and embedded original network/nonce;
the owner must independently pair the original response with its exact saved
request and verify original XPA signatures/placement/issuer under DR-0123.
Parsing or an authenticated carrier alone is not original-intent authority.
Global ContactResolve success bound131072 is unchanged; wrapper maxima must
cover every target including the larger target3 lease response.

Private HTTPS endpoint `/api/v2/contact-publication-winner` uses
`application/vnd.deep.contact-publication-winner-{request|response}.v1+octet-stream`.
It is not a public contact resolver or a direct-client fallback.

## Connected ownership

Before the first callback, the owner copies/bounds its original request and
authenticated decrypted reusable object, verifies exact current owner/device,
signature, route, locator, object ciphertext/generation/support, canonical old
window and non-future issuance. Expiry of that original request is allowed only
for this read operation. Current identity, assignment, resources and protected
time remain live; clock continuity and cancellation are checked at release.

Registry acquires the existing network transaction lock, reads the exact
nonce/leaf/original-coordination-request-hash winner, validates canonical row
projections, response pairing, permanent generation fence and predecessor.
No signer callback, GetOrIssue, reservation, counter change or DDL is permitted.
It independently verifies a fresh current owner proof, current DCA/device and
the fresh publisher signature before releasing bytes; rechecks the same winner,
current root/view/history/proof/time around release. Node gateway requires the
fresh read request's current view/time/placement, never the old request's window.

The owner independently authenticates returned original intent, then atomically
CAS/readbacks the existing phase5→phase6 response slot. Request, nonce, operation,
generation, ciphertext, original response and scalar slots remain exact. This
adopts a historical issuer result, not a replica commit. Subsequent mutation
uses only the existing fresh XPL1 path and both original-hash XPO receipts before
phase7. No journal version, migration, fallback or account reset is introduced.

Activation requires executable canonical/hostile vectors, owner/publisher/time
substitution checks, real PostgreSQL completed/pending/corrupt/fence cases,
lost-response expiry plus encrypted cold reopen with unchanged originals/counts,
gateway/private peer composition and retained Windows/Android device proof.
