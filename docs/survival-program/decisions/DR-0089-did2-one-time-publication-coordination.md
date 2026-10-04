# DR-0089 — DID2 one-time publication coordination

Status: accepted clean-break connected target; protected one-time client custody and shipping activation gated
Date: 2026-10-04
Decision owner: Mr. X (delegated architecture authority)

Close DR88's publication gap with the smallest key-free addition to the existing
private coordination request. Publication request/response envelope and media
are V4 only. Keep the existing endpoint and all fields through owner Retrieve;
append an exact 16-byte public one-time locator, then the existing LP32 prior
XPO and final publisher signature. Reusable requests require ZERO16; one-time
requests require the exact nonzero DIA1 tag 5. Kind, expected DCB hash, network,
expiry and usage are already carried by signed DCR/XIR and exact request fields,
so do not duplicate them or send DIA1, its key or its full hash to witnesses.
The entire unsigned V4 request uses the unchanged publisher signing domain.
Reject V3/V2, wrong widths, missing/extra fields, mixed kind/locator and trailing
bytes. Minimum request 23322, maximum 171614; response widths stay unchanged.
Outer XCA2/ONION ContactResolve maximum becomes 171626, with unchanged magic,
outer version, privacy envelope, service placement and success bounds.

Add an artifact-specific owned one-time genesis request author. It accepts only
the disposable DR88 object, its current verified kind-2 route and owned device;
capture its ciphertext/public locator and caller request axes before awaits.
Require policy10, usage1, generation0/zero predecessor and no prior XPO.
Reusable genesis/successor authors remain reusable-only. Both use the same
verification, request-signing, witness and response machinery. Recheck current
proof/time before and after callbacks. Threshold XPA/XPU use existing kind2,
usage1, exact DCR/DCB/XIR hashes, ciphertext, route, policy and expiry. Compute
the locator with the existing DIA1 locator domain; never permanent derivation.
The server verifies publisher binding, not encryption. Client exact AEAD restore
remains independent and mandatory before any shipping intent/export.

Registry's permanent reservation becomes scoped by network, directory leaf,
publication kind, computed locator and unsigned generation. Different one-time
genesis locators can coexist; changed bytes/nonce for the same scope cannot
reserve or sign, including after pending failure/restart. Permanent successors
still read generation-1 within the same kind/locator and authenticate old
request/XPU/both-node XPO. No one-time successor is authorized. Preserve global
capacity, exact request/response winners, serial locking and immutable floors.
Check stored kind/locator projections against canonical request on every read.

Require explicit operator provision request_envelope_version=4 and
generation_fence_version=2 before callbacks. Preserve old opaque bytes and
counts; retain the old generation fence, add a disjoint V4 scope fence and
nullable V4 projections. No runtime DDL, old-envelope reader/backfill, reset,
eviction or deletion. Corrupt/conflicting projections fail before signing.
Retired projected permanent reservations still reject a V4 permanent request
for the same leaf/generation without decoding/adopting the old envelope;
the cutover must not free that reservation. They do not consume independent
one-time locator scopes. Node XPA admission gains only exact kind2/usage1
genesis, with unchanged witness/placement/protected-time and callback checks.

The existing reusable route journal clean-breaks to version9, unchanged fourteen
LP slots, request slot maximum171614 and complete entry maximum477527. This
only repins reusable custody/budget; it does not create a one-time secret slot
or authorize use of that journal for one-time candidates. The one-time owned
pending/winner lifecycle remains a separate unfinished client requirement.
Registered production identity/genesis/keys stay unchanged. Matched Protocol,
Registry, Shared, XNode and closed machine bounds/hostile cases change together.
Actual provision, installed packages, one-time client custody and physical
Windows/Android contact/message evidence remain activation gates.
