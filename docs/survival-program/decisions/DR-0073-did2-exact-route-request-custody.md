# DR-0073 — exact pending route request custody

Status: accepted local clean-break increment; connected renewal/device gate open
Date: 2026-10-02
Decision owner: Mr. X (delegated architecture authority)

DR36 permanently binds a coordination nonce to the complete request, including
its original directory minimum. Retaining nonce/XRA alone and rebuilding that
minimum after a lost response can produce a conflicting request. Freeze complete
request custody before the first external callback. A later independently fresh
directory proof authorizes the retry; it must not rewrite the original request
or replace its current protected floor with the saved minimum.

The mandatory protected route journal becomes version 5 only. Header, prefix,
phase numbers and revision rule remain unchanged. Append thirteenth LP32 record
for the exact canonical 1,151-byte DR36 request, required in every phase. Maximum
entry becomes 433,109 bytes; aggregate remains the secure-store 1 MiB bound.
Pending entries reserve complete terminal capacity before any callback. Bind
request network, nonce, account-derived directory lookup, DCA and XRA to the
same owned proposal. Decode it before callbacks; unknown version, missing,
changed, oversized or corrupt custody rejects without regeneration. All
successive phases retain the exact request. Protected CAS and independent
readback precede dispatch. No migration, dual reader or lazy reconstruction.
Version-4 disposable QA instances need explicit reset when consumers activate
this clean break; no device reset is performed by this implementation itself.
SQL account/application shapes, network genesis and registered node keys stay.

Change internal IDid2ContactRouteThresholdSource to receive the complete retained
ContactRouteAuthorityWireRequest rather than separate nonce/XRA inputs. The
private three-hop source encodes those exact owned bytes; it never derives a
replacement minimum. Independently verify active lease, current network, current
account/DCA, queried leaf and a nonfuture request minimum before dispatch.
Equal generation requires exact core equality; a lower saved minimum is only
a replay floor, not freshness. Current route/device/witness/time validation
remains mandatory after response and before adoption/release.

Use real signed directory-head advancement with unchanged account/network to
exercise lost threshold response and reopen. The complete request must remain
byte-identical while independently current proof/floor advances. Cover failure
after proposal commit, response loss before adoption, corrupt request bindings,
old journal rejection, capacity and unchanged phase-7 exact recovery. Server
nonce journals/schema and coordination wire remain unchanged in this increment;
production deployment, successor envelopes/per-generation reservation and
DCB/DCR/publication renewal under DR72 are separate connected gates. DR42 still
requires a current issuance anchor at threshold adoption/device completion/new
object authoring: an old-head signed winner must remain exact and pending, not
be silently adopted or reminted. A separately accepted retained-issuance
completion contract is required to close this second lost-response seam. Tests
must distinguish exact request replay from successful current route completion.
This alone
is neither retained-account expiry recovery nor physical message delivery.
