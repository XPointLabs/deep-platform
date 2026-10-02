# DR-0077 — bounded predecessor-aware DID2 route coordination

Status: accepted clean-break connected increment; physical activation gated
Date: 2026-10-03
Decision owner: Mr. X (delegated architecture authority)

Connect DR72/74/75 route renewal to private coordination. No new crypto suite,
record domain, public resolver, direct client fallback or legacy reader.
The `/api/v2/contact-route-authority` terminal and XCA2/XCS2 wrapper stay; the
enclosed route request is **V3 only**, media
`application/vnd.deep.contact-route-authority-request.v3+octet-stream`.
Response V3 with the actual signed issuance ADH1 remains unchanged.

Request V3 retains the previous 1151-byte prefix layout, with header version3
and total length of the complete envelope. Append two `u32be length || bytes`
fields in order: exact prior XIR1 V2 and exact prior six-record route closure.
Genesis XRA generation0 requires both lengths zero: total1159. Nonzero XRA
requires exact611-byte prior XIR and a closure in4143..23295: total5913..25065.
Unknown versions, one-sided/missing predecessor, wrong bounds, cross-network
records, noncanonical graphs and trailing bytes reject. Parsed predecessor
bytes never grant currentness or signing permission. Defensive ownership occurs
before async callbacks; the DR48 node signature hashes the complete V3 request.

Registry independently verifies current DID2 proof/device/DCA, root/network/PMT
and time. For nonzero requests it authenticates the exact prior route through
DR72 `VerifyPredecessorAsync`, then uses only `AuthorThresholdSuccessorAsync`.
The separately frozen read-only `VerifyAdvertisementSuccessorAsync` checks
closed predecessor, exact candidate and current authority before reservation;
it returns no signing, mutation or dispatch capability.
No caller-supplied historical time or currentness flag. Exact generation+1,
predecessor core, stable capabilities/placement, original signatures, current
authority and final source checks stay mandatory. Genesis author is not a
successor fallback. The DR72 permanent per-generation reservation happens
before witness callbacks; another nonce/body for that generation conflicts.

Retained issuance verification also independently authenticates predecessor
bytes from the original request and checks the returned threshold's exact
successor lineage. Completion with a retained successor must use that exact
predecessor, never another independently valid history. Fresh independent
proof/head/floors remain required on retries; the saved request is immutable.

The operator-only request-provisioning transaction preserves all exact old
audit requests/responses, reservations/counters/capacity and independent floors.
Storage may retain1151-byte old requests, but runtime accepts only V3 in
1159..25065 and rejects retired winners without a V2 request reader. Mandatory
request_envelope_version3 must be provisioned before signing. Runtime does no
DDL/backfill/cleanup. Generation index prefix projections remain unchanged.
Conflicting history is not silently repaired or discarded.

Protected route journal is **version7 only**, with the same14 bounded LP slots,
slot12 maximum25065, maximum entry461123, full pending reservation and existing
1MiB slot bound. Incompatible disposable QA state requires explicit reset;
node identity/registered keys, network genesis and floors are not reset. This
does not yet implement current/pending publication replacement or phase1
abandonment, and does not authorize replaying an expired request/winner.

Update machine target bounds, Registry/Shared/XNode consumers and hostile/native
tests together. Matched provisioning, builds/repins, protected successor adoption,
publication fencing, real replicas and physical contacts/text/assets/groups
remain release requirements; local TestServer/native tests are not device E2E.
