# DR-0137 — Captured final-page completion after Retrieve authority expiry

Status: accepted narrow local custody contract; implementation and device acceptance remain
Date: 2026-10-17
Decision owner: Mr. X (delegated architecture authority)

This supplies the final-page continuation deliberately left closed by DR-0133.
It does not extend any grant, request, endpoint proof or pagination token. A
captured non-final page remains pinned: renewing its pagination authority needs
a separate dependency-closed producer. Expired already-pending/prepared ACK and
captured ACK response also remain pinned for original-outcome recovery. No version, wire, suite, slot, reset,
compatibility reader or larger storage bound is introduced.

## Local result is not dispatch authority

The held account owner may finish an already protected captured final page using
the exact original private publication, acquisition, signed grant, holder,
prepared MAU3, capture time and response. Authenticate original facts against
independently current protected network history with the existing historical
verifier. Require capture within the original grant interval, exact original
body/page/operation binding, native SQL request and original or already committed
traversal. Missing, changed or contradictory custody fails before mutation.

Only a local SQL/inbox/outcome continuation may use the authenticated historical
capture time. That time is not a current clock, installation policy or network
permission. This path creates no signer, credential installation, ingress or
transport callback. Current account, endpoint floors, history, protected roots
and cancellation are still independently fenced. Ordinary semantic consumers
must independently authenticate and materialize every event exactly once before
any ACK. An expired envelope is not revived by its old capture time.

## Independent current ACK

For an expired final-page read with no pending/prepared ACK, acquire an independent current
Retrieve grant for the same exact retained private namespace. Persist/read back
its binding before SQL preparation. Author only the exact captured ordered
cursor/digest list, with final-page framing and no continuation token. Derive a
distinct operation from the original scope, original grant, Retrieve MAU hash,
page hash and new grant hash. Do not re-sign or overwrite an original request.
Current issuer/revocation, holder, selected replicas, protected time, route and
semantic custody remain mandatory at native dispatch and result verification.

If an older ACK is pending, prepared or possibly dispatched, retain its exact
original custody and reject reauthorization. Native tombstone custody currently
belongs to the original operation; a test transport accepting another ACK is
not evidence that native original-outcome recovery exists. A captured response
cannot be replaced by a new authorization. A crash after SQL preparation but
before protected adoption must not be inferred to mean non-dispatch.

The existing protected read grammar gains only dependency-bound states7/8 for
pending/prepared independent ACK, carrying its grant hash; states1–6 retain their
exact meanings; the existing closed-attempt grammar is unchanged. One canonical parser
rejects unknown states, trailing bytes, substitutions and inconsistent counters.
Original and continuation grants, exact SQL requests and closed attempts pin
retirement. Capacity is checked before an issuer or signing callback; no eviction.

Only independently verified durable tombstone quorums for every exact item plus
SQL/read-back and semantic fences can clear the active page. Unknown prepared
ACK expiry remains unresolved, not relabeled complete. Source fixtures and matching physical clients must
be qualified separately; this decision supplies no release/device acceptance.
