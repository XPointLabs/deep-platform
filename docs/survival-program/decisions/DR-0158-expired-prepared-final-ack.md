# DR-0158 — Expired prepared final ACK continuation

Status: accepted; source/connected qualification separate
Date: 2026-10-20
Owner: Mr. X (delegated authority)

Actual retained receive exposed a prepared ACK whose original Retrieve grant
expired while its partial replica outcome remained unknown. Never extend that
grant, reset the account, discard the original request or call expiry non-delivery.

The existing protected read journal gains closed-attempt kind3 for exact signed
ACK and active phase9 for closed ACK awaiting current successor acquisition.
No new journal, key, version reader, wire, public API or lifetime is introduced.
Kind3 retains original grant/scope/route/Retrieve body, exact ACK MAU/hash/counter,
grant expiry and authenticated lower closure time. Original SQL stays unchanged.
Actual historical namespace/holder acquisition, reserved intent, exact SQL/body/
dedup/signature/counter and current native fence are joined before protected close.
Missing/corrupt or already durable original outcome refuses closure. Lower time
must reach original grant expiry; upper time alone is insufficient.

Only a final captured page with no known ACK reply may continue. Protect the
complete original closure BEFORE any successor issuer callback. Phase9 survives
callback failure/cold reopen. A current independently verified grant derives a
new ACK operation for the SAME page/items, preserving original Retrieve/page and
all counter floors. Every later read reauthenticates all closed native requests.
No closure eviction or fabricated receipt. Resource capacity is reserved first.

DR-0157's terminal/known-absent tombstones make the new current ACK idempotent;
they do not establish that the old ACK failed. Unknown pagination, stale current
authority, original SQL loss/changes, time rollback and missing holder reservation
remain fail-closed. A separately current endpoint set may be reacquired once
before ACK capture when its independently fetched head changes; never splice sets
or retry effects under that scheduling exception.

Require crash-before/after closure, cold exact SQL joins, immutable page/counters,
hostile/missing native requests, cancellation and real retained CLI ACK evidence.
