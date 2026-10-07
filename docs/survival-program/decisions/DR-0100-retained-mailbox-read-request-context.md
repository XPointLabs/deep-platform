# DR-0100 — current request context before retained mailbox lookup

Status: accepted S01 request/time API prerequisite; lookup/issuance activation gated
Date: 2026-10-07
Decision owner: Mr. X (delegated architecture authority)

The current request author/issuer verifies a live complete recipient route. That
does not provide the current authenticated request/time input needed to query
independent retained-read custody after route expiry. Raw host UTC, a historical
route, a cached grant, or a caller's `historical=true` must not fill this gap.

Freeze the additive
`VerifiedMailboxHostAuthorityV2.VerifyRetainedReadRequestAsync(exactXmg1, ct)`
returning closed `VerifiedMailboxRetainedReadRequestV2`. The host is the existing
complete current network/root/PMA2/protected monotonic-clock authority. Decode
and capture bounded exact XMG1 before any callback, verify holder proof, require
Retrieve and exact network, and require exactly one matching PMT2 ArtifactRef
already authenticated in the host's retained protected network lineage.

Verify the original request window, at most120 seconds, against the full current
authenticated interval twice. Its deadline cannot exceed current PMA2/NET bounds.
Later use rechecks the same actual host and original request; clock rollback,
foreign boot, expired proof/request, cancellation or changed current authority
fails closed. An old PMT2 may identify a selection; its past time is never used
as current time. The current Store/grant/route APIs are unchanged.

The sole semantics and error table live in
[CONTACT-RESOLVER §3.7.1](../../architecture/CONTACT-RESOLVER-V1.md#371-current-request-context-for-retained-read-lookup).
The returned request/PMT/PMS hash copies and `ReadCurrentTimeAsync` facts do not
prove capability ownership, original publication/route provenance, issuer
authorization, holder custody, replay, availability, mutation or deletion.
Only both actual current selected stores' authenticated retained custody may
provide the next producer; missing custody is unavailable, never empty catch-up.

This adds no magic, wire field, suite, signature domain, algorithm profile or
local-state generation. XMG1/XMC2/MCG3 and the current two-store transcript do
not change. No old-version reader, request refresh, account-derived holder or
public issuer endpoint is introduced. Shared owned request author/restoration,
actual bounded node custody, issuer/owner/node consumers and object horizon
remain the same unfinished S01 closure, not S02/S04 runtime activation.

Qualification must cover actual complete signed lineage and cold DNH2 reminting,
missing/foreign projection, signed Deposit/foreign-network requests, malformed
and hostile sizes, invalid holder proof, original window/full-interval boundary,
caller-buffer mutation, cancellation and recheck-time rollback/boot/expiry. Check
the actual public API, registry source/hash mapping and required Protocol gates;
retain unrelated package failures as failures. Consumer rebuild/repin is required
before activation, with no production reset or key change.
