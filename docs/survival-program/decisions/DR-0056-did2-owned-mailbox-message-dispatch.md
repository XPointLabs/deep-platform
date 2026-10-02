# DR-0056 — DID2 owned mailbox message dispatch

Status: accepted connected local API/custody contract; live/device gates remain
Date: 2026-10-02
Decision owner: Mr. X (delegated architecture authority)

Keep DPE2 and the existing neutral Store body/MAU2/MCP2/MCG2 wires. The internal account business
entry takes only owned session metadata, operation32, verified permanent-contact
candidate and source. It independently refreshes that contact outside the account
lease, then verifies actual own/peer floors, exact session endpoints and stable
active ratchet custody under the actual held lease. Read the committed send row
and its exact DPE2 from SQL plus protected messaging floor; never accept caller
ciphertext or a signer. No old Session transport facade or free marker adapter.

Refreshing means an actual new non-consuming permanent read from the retained
verified address, followed by independent own/peer verification, not merely
reverifying an old nonce-bound XIQ1/XIS1 candidate. Its existing short read
interval cannot be extended with a newer directory proof. The internal test seam
may supply only the exact read transport, never the resulting trusted authority.
The retained Store still keeps its original route/grant/body/MAU2/counter and
lifetime; a changed destination rejects rather than rerouting an unknown send.

The grant comes from DR53's same protected holder/winner and DR55's independently
verified installed current-only credential. The owner-private disposable loan
may carry SQL, selector, issuer policy and holder only inside this account
operation. MCP signing additionally requires the exact retained MCG2, current
complete interval, held lease and protected replay-counter lower bound. No
signer/authority escapes to UI, transport factory or callback.

Initialize one mandatory bounded protected send journal atomically with the
SQL/account instance before account publication. Missing/foreign/malformed state
requires explicit disposable-QA reset, never lazy repair. Bind network/account/
instance, session hash, owned operation, exact DPE2 hash, route and grant hashes,
deterministic operation16, original creation/expiry and exact Store body hash.
Creation comes from authenticated time on first preparation only; expiry is
bounded by the grant and neutral mailbox TTL limits. Persist/read back pending
descriptor before SQL preparation. Retry reconstructs those exact bytes and
never extends expiry, replaces a holder or silently reroutes an old operation.

SQL prepares exact MAU2 and replay counter transactionally with its outbox. Read
back and verify original Store body, exact retained grant, holder signature and
monotonic counter. Commit/read back a protected prepared phase binding MAU2 hash
and counter before dispatch. Once prepared, missing/changed SQL request or a
counter rollback rejects before signing/callback; there is no regeneration.
One pending operation per grant and unique prepared counters enforce the local
lower bound. Capacity rejects; no live eviction. A crash between SQL preparation
and protected preparation resumes the exact existing request without another
signature. Prepared custody is not a remote receipt or semantic delivery.

The owner dispatches through the neutral ClientMailboxAdapter, account-owned
SQL, current issuer/time policy, exact two-replica receipt verifier and DR55's
held readonly-floor ONION context. The default transport selects an actual
current three-hop entry with ordinary TLS validation; the internal test seam
receives only a request/context, never holder or issuer keys. Recheck unchanged
protected journals, session and own/peer/grant/route bounds before callback and
after result. Lost response stays unknown with the same request and bounded
retry lease, without an automatic second path attempt. A cached durable receipt
is verified again and labelled non-dispatched. It is not recipient acceptance.

Preparation and dispatch are separate bounded local scopes, not a renewable
grant or signing loan. After protected prepared read-back, sample and verify
current route/PMA/time again and construct a new owner-private dispatch-only
issuer policy. Retain the same owned SQL and exact request; export no signer and
perform no further signature. Dispatch's 30-second bound starts at this fresh
sample, not before credential installation/SQL preparation. The original holder
signing policy remains expired when its own bound ends. All signed grant/route/
network expiry and current protected floors still apply before/after dispatch.
This prevents cold SQL preparation from consuming the separate network budget;
it never extends authenticated request lifetime or converts unknown to delivery.

This closes sender preparation/Store only when connected tests prove it. Initial
DPH2 delivery, owned Retrieve, semantic materialization before ACK, attachments'
remote chunks, groups, matched production activation and physical Windows/USB
Android remain required; do not substitute local or fixture evidence for them.
