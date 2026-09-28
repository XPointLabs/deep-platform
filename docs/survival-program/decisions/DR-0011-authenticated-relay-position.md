# DR-0011 — authenticated relay-position disambiguation

Status: **accepted; codec gates passed, host/TLS/device integration pending**
Date: 2026-09-28
Decision owner: **Mr. X** (explicitly delegated architecture authority)

This decision authorizes the implementation change below, not a release sign-off
or independent security review. It changes no wire bytes, crypto domains, public
method signatures or deterministic vectors.

## Verified gap

Ingress and Core both use an XRF1 Relay header for the same local key. The
existing header selector can legitimately mint both position-bound contexts.
Only the authenticated XRL1's inner header distinguishes Relay-inside-Relay
(Ingress) from Exit-inside-Relay (Core). Unique header selection in DR-0010
was therefore incorrect.

## Frozen contract

1. Protocol may emit `OnionBoundaryException.Code = receive-position-mismatch`
   only after authenticating the outer AEAD and validating the complete XRL1
   grammar, identifiers, lengths and zero padding. The canonical inner header
   must bind the same network and exact signed next-node owner/key/epoch.
2. The position implied by that authenticated inner header must itself be
   allowed by the exact signed local descriptor. Protocol also validates the
   required next-node role, identity/key/host/origin separation and next-hop
   transport facts. An unsigned hint cannot mint or add a local role.
3. This error occurs strictly before replay commit and releases no plaintext,
   forward/dispatch capability or suggested destination. The consumed lease is
   disposed; disposal failure replaces the mismatch error and forbids retry.
4. A host may try the other already-authorized relay position at most once,
   on the same immutable frame and current network/key binding, with a fresh
   position-bound replay lease, and only for that exact code. Header validation
   can filter incompatible Relay/Exit contexts without key-vault or replay I/O.
5. Authentication/grammar/key/role/expiry failures, cancellation, replay rejection,
   saturation, ambiguous or failed commit, and lease/disposal failures never
   permit position retry. The two positions cannot both succeed for one frame.
   Successful replay commit still precedes forwarding or terminal dispatch.

The production replay store's Begin/dispose-without-commit is side-effect free.
The adapter contract remains mandatory for other stores; a speculative open
cannot perform service callbacks. No protocol parser is moved into XNode and
there is no fixed-position configuration, legacy adapter or route fallback.

## Evidence and residual work

Require all six three-node permutations from a verified signed network closure,
canonical DID2 terminal bytes, opposite-position mismatch with zero replay
commits, and authentication/grammar/role/key/expiry/commit negatives. Then prove
the host loop with durable replay and actual TLS before device E2E.
Local codec tests do not establish publication, DID2 directory proof acquisition,
physical delivery, masked carrier operation or release readiness.

Local checkpoint: all six codec permutations and twelve fail-closed checks pass
in the signed NETCODEC fixture. Full Protocol tests: 1842 passed / 11 native
skipped, MembershipRoutes 131 and ProfileCarrier 105 passed. Debug/Release
builds have zero warnings/errors; both actual assembly/resource/public-API
graphs and complete package evidence ownership pass. No API snapshot was repinned
and no frozen wire vector changed. The fixture supplies candidate directory
freshness; it is not a live DID2 proof acquisition or durable host adapter test.
