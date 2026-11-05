# DR-0133 — expired owned Retrieve attempt closure

Status: accepted source/API allocation; implementation and connected qualification required
Date: 2026-10-16; disjoint continuation and owned pagination restart2026-11-05
Decision owner: Mr. X (delegated architecture authority)

Semantic owner: [transport-neutral transitions](../../architecture/TRANSPORT-NEUTRAL-MESSAGING.md#842-grant-and-route-transitions).
Android36 identifies an active read restoring an expired MCG3. Renewing only
idle new-work grants cannot recover that cycle. Expired authorization must never
be treated as current, and deleting the active cycle would lose uncertainty.

## Scope and invariants

Allocate owned closure for an active Retrieve **before any page was captured**
(local phases1/2). Independently current protected lower time must reach the
exact original grant expiry. Upper-time intersection alone is insufficient.
The narrowly proved disjoint-continuation alternative below applies only to
prepared phase2; it does not make ordinary token expiry a closure permission.
Authenticate the original signed policy, request/result, holder, route, grant
and actual native SQL/protected roots under the account's real lease. Retain the
original exact body and every persisted MAU/counter, grant acquisition/holder,
route, traversal and floor as closed-unknown custody. This is not BeforeForward,
non-issuance, empty-page success, delivery or retirement authority.

Only after protected closure CAS and exact read-back may the ordinary idle-read
owner acquire independent current authorization. Existing request windows, two
replicas, placement, signatures, current directory/network/device/issuer checks
and limits remain. The old attempt is never re-signed, re-windowed, dispatched
or overwritten; a new read is not a replay of that expired authenticated frame.
No application event, consent, ratchet step or ciphertext is regenerated.

Captured page/semantic/ACK phases3–9 remain pinned. This allocation does not
discard them or pretend their recovery is complete. They require their own
dependency-closed local/result or current-authorized continuation before S05
can be accepted. The full contacts/text/files/groups objective is unchanged.

## One historical Protocol boundary

Allocate on the existing verified mailbox host:

```csharp
ValueTask RequireOriginalRetainedReadGrantAsync(
    ReadOnlyMemory<byte> exactOriginalPma2,
    ReadOnlyMemory<byte> exactOriginalRoute,
    ReadOnlyMemory<byte> exactXmg2,
    ReadOnlyMemory<byte> exactXmc2,
    CancellationToken cancellationToken = default);
```

It returns no credential/current grant/transport capability. It verifies the
original namespace through independently current protected history, exact
Retrieve request/result/route binding, holder signature, original policy's
Retrieve issuer signature/floor/interval/lifetime, original selection and
retained object-horizon ceiling. Current request/grant expiry is not an error
for this historical authentication; current host/network/proof/time remains
mandatory. It grants no Store, renewal, dispatch, absence or deletion permission.
Actual account custody and authenticated lower-time closure are separate owner
requirements. No raw signer, trusted flag, caller clock or arbitrary key enters.

## Existing private read root, one canonical reader

Use the existing protected mailbox-read slot, header marker1,750000-byte bound
and128-entry/floor bounds. Header bytes94–95 become an unsigned big-endian
closed-attempt count (0..128). Following the existing optional active cycle,
append that many records sorted by unique original grant hash. Count0 is the
canonical empty collection; existing valid empty-count bytes remain identical.
There is one current grammar/parser, no version dispatch, compatibility reader,
migration, extra slot, SQL schema, wire/magic/domain/suite or reset.

Each record contains `grant32, scope32, route32, pollGeneration:u64be,
phase:u8(1|2), grantExpiry:u64be, closedAtLower:u64be,
LP32(originalRetrieveBody<=364), counter:u64be, mauHash32,
LP32(exactOriginalMau<=8192)`. Phase1 has no prepared frame/counter/hash;
phase2 preserves and structurally verifies its exact signed MAU. Missing prepared
SQL, changed body/grant/signature/counter/hash or contradictory native roots
reject before closure. A phase1 SQL preparation already committed under the
existing native floor may complete its ordinary protected phase2 read-back
without signing before closure; SQL absence never repairs a missing floor.

Closure itself retains counters/traversals unchanged; only the separately
qualified pagination restart below may advance a traversal. Closed attempts pin original
grant/holder/route/read dependencies through the existing ReadWork fence; no
retirement/eviction producer is allocated. Capacity, including space reserved
for a complete next active cycle, rejects before a new issuer/signer callback.
Do not increase limits or reinterpret closed-unknown as a successful read.

## Permanently unusable prepared continuation

An exact prepared phase2 Retrieve may also close as unknown when its owned XCT1
expiry E is no later than the exact signed MAU grant's NotBefore, and independently
current protected lower time has reached E. The token and grant intervals then
cannot overlap: that exact request cannot be admitted at any valid grant time.
This is a denial fact, not authenticated evidence of a remote outcome. Ordinary
expiry of a token that once overlapped its grant does not establish this case.

Authenticate the original MAU/holder/grant/body and existing account, route,
native, SQL and protected roots exactly as for ordinary closure. Require canonical
XCT1 framing and purpose, nonzero cursor and expiry, high-water and item limits,
and exact epoch/cursor/mailbox/placement/membership bindings to the owned request
and grant. A token, parsed expiry, HTTP504 or caller-supplied flag never grants
transport authority or proves absence of effects. Preserve the exact request,
counter, MAU, holder, acquisition, grant expiry and pending/unknown SQL custody.

Keep the existing phase2 closed-record framing and GrantExpiry field unchanged.
Its canonical validation accepts either the ordinary grant-expiry proof, or this
self-contained disjoint predicate against the embedded exact signed MAU, with
ClosedAtLower >= E. Phase1 remains grant-expiry-only; an actual prepared SQL frame
may first complete its existing phase2 adoption without new signing. Captured
page/semantic/ACK work is excluded. No new state, version, parser, slot or capacity
is allocated. Closure still requires guarded CAS and exact read-back, and grants
no non-delivery, ACK, deletion or retirement claim.

## Expired idle pagination restart

Before authoring or acquiring authority for new work, the idle owner may replace
its authenticated expired traversal `(cursor, token, generation)` with exactly
`(0, empty, generation+1)`. Require actual idle QA custody, canonical scope-bound
continuation expiry proven by independently current protected lower time, exact
QA/grant/route/account/native joins and the actual SQL predecessor. No unexpected
prepared request, captured outcome or active page/ACK may be discarded. A closed
phase2 attempt retains its exact original frame and traversal in closed-unknown
custody; a still-live grant already named by Closed cannot be reused for new work.
Ordinary independently verified new-holder acquisition remains responsible for
the successor read. This restarts pagination, not replay counters, native state,
account data, inbox, outbox or acknowledgements; semantic dedup remains mandatory.

The owned SQL transaction changes only the exact pagination predecessor, then
the QA successor is compare-exchanged and both stores are read back. A cold
SQL-first interruption may roll forward only the exact derived successor, after
re-proving the still-protected old QA traversal, expiry and absence/Closed guards.
The SQL successor alone is never authority. Advanced QA with old SQL rejects
rollback; mismatched successor, root changes and cancellation reject. Complete
the final current-time, protected/native and actual SQL joins before any new
issuer/signer/transport callback. No arbitrary cursor reset or retry loop follows.

## Evidence before activation

Require canonical encode/decode including empty-count byte identity, malformed
count/order/length/phase/signature/grant/body/floor rejection and hard capacity.
Native SQLCipher cases must cover actual lost Retrieve response, grant expiry,
cold reopen, exact retained old bytes and independent new grant/read, one effect,
CAS/read-back faults, clock overlap/rollback/cancellation, missing/changed SQL,
and retirement refusal while closed work remains. Old signed frames must never
dispatch after expiry. Captured-page/ACK refusal remains explicit until its
separate continuation is implemented. Matched Windows/Android, source/package
and full connected acceptance remain required; no Releases/main approval.
