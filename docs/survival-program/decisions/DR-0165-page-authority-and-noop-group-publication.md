# DR-0165 — page authority and no-op group publication

Date: 2026-10-22. Owner: Mr. X. Status: accepted bounded orchestration correction;
matching source, connected and release qualification remain separate.

An ordinary group send must not enter the full GSR publication/rechunking path
merely to discover that no control write remains. The account owner may read
the actual authenticated group root and return a scheduling hint: is this local
account the parsed owner, and are the required original package chunks/receipts
present for every parsed member? This is not membership, receipt verification,
freshness, Store success or cleanup authority. No new persisted hint is added.

The application-send owner still independently reopens the real root, verifies
the current group lineage/endpoints and every required original GSS receipt
before creating any message or advancing its sequence. A missing/changed root,
fork, incomplete control set or invalid nonempty receipt cannot authorize send.
Pending control work retains the existing actual publication path, current
rendezvous checks, exact original requests and unknown-outcome recovery. Explicit
publication/full control audits keep their previous contract. A non-owner never
gains publication permission from the hint. No GSR availability/retention claim
is inferred from ordinary delivery, and no expired control write is allowed.

One mailbox page may acquire a fresh independent command-read scope before
Retrieve and reuse its still-current PUBLIC own endpoint for ordinary DPE2
receive on that page. Each borrow keeps the existing actual clock, directory
and network floor, issuer and owner checks. The scope is closed at page completion;
it does not retain a private loan, ciphertext, signing key or receive outcome.
An expired proof requires genuine acquisition, and boot/rollback/fork failures
still reject. Captured requests and loans never get a renewed lifetime.

Initial and Braid retain their parent acquisition paths. ACK still opens a new
independent scope AFTER materialization, fetches its own current endpoint set
and reconstructs native semantic/page/holder custody before signing. Neither
Retrieve nor ordinary receive supplies ACK authority. DR-0164 remains in force.

No wire, schema, identity, journal generation, storage key, protocol nonce or
signed lifetime changes. No cache across commands, compatibility reader,
reset or operational authority rotation is introduced. Qualification includes
actual first-attempt three-CLI delivery and original-control cold audits,
unpublished/hostile-control refusal, independent ACK and clock/floor/recovery
negative tests. Resource diagnostics remain numeric observations only.
