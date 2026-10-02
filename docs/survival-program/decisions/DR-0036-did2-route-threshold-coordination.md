# DR-0036 — DID2 route threshold coordination and exact durable replay

Status: accepted clean break; publication and physical delivery remain gates
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Replace the route-authority envelope version/media type 1 with version/media
type 2 and DCA1 V2 only. Preserve the exact 1,151-byte request layout and bounded
response layout in CONTACT-RESOLVER 3.1; neutral XRA1/PMS2/XRC1/XSS1 bytes,
domains and suites do not change. The internal HTTPS authority terminal becomes
`/api/v2/contact-route-authority`; remove the old endpoint, not an alias.
Retire the unused Shared DID1 `ContactRouteAuthorityClient` and its options-only
positive tests; do not retain a direct HTTP facade that can only author old
DCA1 requests. Remove the DID1 proposal's `CreateThresholdRequest` helper too;
current requests must derive from the actual account-owned DID2 route proposal.
This is witness coordination, not a public contact resolver or mailbox grant
endpoint. The client transport requirement remains XPoint/OHTTP: no shipping
direct-Registry fallback is authorized by this decision.

Freeze a getter-only `AuthoredDeepIdV2DirectoryProofPackage.Freshness` returning
the actual closed `VerifiedDeepIdV2DirectoryFreshness` produced by the author's
existing full self-verification. Its constructor remains internal. Do not add a
public raw-leaf capability factory or wrap DID1 evidence as DID2 evidence.

The issuer obtains a new nonce-bound proof from authenticated ADA2 with the
independent PostgreSQL latest-head floor, honors the caller's exact minimum
head, verifies current DID2/DAB2/DMD1/DCA1 V2 and XRA1, independently verifies
the signed current network closure, and uses existing configured witness key
custody. A fresh proof challenge is distinct from the stable coordination
nonce. Replays therefore do not consume that coordination nonce as a DTT1
challenge. Trusted monotonic time is read again across callbacks; a frozen
clock cannot authorize a delayed response.

Use the existing PostgreSQL restore-authority domain for a permanent bounded
route journal, not a process cache or expiring nonce ledger. The operator
explicitly provisions its schema and per-network capacity row; missing rows,
schema, capacity or database fail closed. Runtime has no DDL/DELETE/TRUNCATE
authority. Persist the exact request reservation before any route signature.
Serialize concurrent writers; changed bytes under the same network/nonce
conflict permanently. Commit the exact response and independently read it back
before returning any bytes. A lost response/restart returns the exact winner;
an uncommitted signing candidate may be regenerated but must never escape.
Capacity cannot be reclaimed by time-based deletion. Backups/restores must
preserve this journal together with the independently restored head floor;
restoring an older journal is not an authorized empty-genesis reset.

Every winner, including replay, is verified against freshly checked current
head, account/device authorization, network, witness set and trusted interval
before release. Recheck ADA2/external floor and exact network bundle after
signing/readback. Stale or expired winners reject; never silently remint under
the same nonce. Successor/renewal issuance remains a separate explicit task.

The endpoint requires HTTPS, exact path/no query, exact media type, exact bounded
body/no trailing bytes, admission and a maximum 30-second operation deadline.
Errors are empty/no-store; never return payload/key/identifier diagnostics.
Focused codec, pipeline, concurrency, lost-response and restart checks come
first; full Protocol API/evidence repin, Registry gate and recovery lane remain
mandatory at the whole-business batch boundary. No physical E2E claim follows
from a local threshold response.
