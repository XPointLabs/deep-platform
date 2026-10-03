# DR-0069 — remove retired identity producers from the DID2 source graph

Status: **accepted source/API clean break; connected release gates pending**
Date: 2026-10-02
Decision owner: **Mr. X** (delegated pre-user clean-break authority)

## Decision

Remove DID1/DAB1 authoring, parsing, verification and their dependent V1
directory/contact/group capability producers from the production source graph.
Do not retain compatibility overloads, aliases or positive historical vectors.
Git history is the historical record. DID2 hybrid root and DNP1 account/device
verification remain independent, mandatory inputs; parsing never grants authority.

The central registry marks DID1/DAB1 `RETIRED_REJECT` and excludes their
generated constants. Existing IPK2 preclaim custody and XCA2/XCS2 coordination
framing receive their allocated identifiers without changing bytes, operation
numbers, transcripts or activation status. These are `FROZEN_TARGET_NOT_ACTIVE`.

Re-freeze the existing forward-checkpoint verifier and ONION context factory
signatures to accept only `VerifiedDeepIdV2DirectoryFreshness`. Their threshold,
proof, monotonic time, predecessor and protected-floor checks remain unchanged.
No V1 freshness wrapper is permitted. Remove V1 operational genesis helpers
which cannot issue a DID2 proof; existing native DID2 ceremonies are not replaced
by structurally constructed proof fixtures.

Remove the old identity-bound DCB1/DCR1 positive cases from the contact vector
manifest and schema. Preserve exact retained neutral record bytes, signature
vectors and malformed-input checks. Current owned V2 contact-object coverage
remains in its own package; it is not proved by the neutral contact manifest.

## Consumer and evidence impact

Registry removes the ADA1 admission, V1 proof-package/current-value hosts and
their artifact snapshot source. Retired configuration sections must be absent,
not merely disabled. Keep the neutral trusted-time/witness custody and durable
one-use nonce ledger required by DID2; replay marker bytes and protected state
are not reset or migrated by a source removal.

The network catalog's freshness consumer verifies only ADP1 V2 for one exact
operator-configured public DID2 credential, under the current independently
authenticated ADA2 head and external latest-head floor. The candidate's raw
leaf key cannot mint a query or supply its own directory trust anchor. Recheck
that head and protected monotonic freshness before releasing the publication.
The existing identity-neutral write framing is unchanged; reader version two
is mandatory. This is a source consumer mapping, not a new protocol allocation
or evidence of live catalog writes.

Rebuild Protocol, Shared, MAUI, Registry, XNode and operator tooling against
one exact successor package. Re-freeze Debug/Release assembly/API/resource
snapshots and package pins after reviewed removal. Existing published packages
and running images are not this source graph. No database, registered node key,
protected floor, genesis or production data is reset by this decision.

Replace mixed test fixtures with DID2 fixtures; retain independent threshold,
signature, epoch, protected-state, malformed header and replay coverage. Tests
may construct internal network-only fixtures but must not label those as real
account issuance, live authority, durable host installation or physical delivery.

Required final gates: strict registry/schema/source coverage, exact three-package
assembly/API graph, actual-native DID2 tests and connected consumers, followed
by matching live authority and physical Windows/Android contact/text/file/image/
group E2E. Source builds and focused tests alone are not release activation.
