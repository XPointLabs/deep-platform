# DR-0062 — private DID2 contact mailbox route

Status: **accepted bounded route-package contract; event/runtime activation gated**
Date: 2026-10-02
Decision owner: **Mr. X** (delegated architecture authority)

The connected initial-message test does not yet prove reverse delivery: it
hands authenticated ContactAccept to the initiator locally. A recipient knows
the sender's public DID2 but not its separately held resolver-read capability.
Do not invent a public resolver bypass, disclose that capability, reuse XUR1
as an ordinary mailbox, or repeat permanent resolution for steady-state sends.

Freeze a bounded private route substructure, not a new public service record:
`u16be(2) || u16be(0) || exactDCA1V2[473] || exactXIR1V2[611] ||
u32be(routeClosureLength) || exactSixRecordRouteClosure`.
The fixed prefix is 1,092 bytes and total bounds are 5,235..24,387 bytes.
The six-record closure retains DR-0033's exact grammar and signatures. Version,
reserved bytes, inner versions, exact length and closure graph must reject
noncanonically before asynchronous work. No legacy reader or optional empty
route is authorized. The package contains neither a resolver-read capability,
owner-retrieve capability, private metadata scalar nor holder key.

The permanent locator is derived from the independently verified sender DID2
and network using the existing permanent-locator domain; it is not a new
caller-supplied field or a new resolver key. Extract that common derivation
into one internal helper. A parsed package is immutable untrusted data.

Freeze public `DeepIdV2ContactMailboxRouteCodec.Encode(verifiedRoute)` and
`Decode(exactPackage)`, plus sealed `ParsedDeepIdV2ContactMailboxRoute` with
read-only exact bytes, parsed DCA1 V2, parsed XIR1 V2 and parsed route closure.
Encode grants structural framing only, not authenticated origin or durability.
Freeze `DeepIdV2ContactMailboxRouteVerifier.VerifyAsync(parsedPackage,
currentPeerFreshness, verifiedNetwork, verifiedXna, trustedTime, ct)` and its
closed `VerifiedDeepIdV2ContactMailboxRoute` result exposing the package,
verified route and derived locator. Verify DCA against the exact independent
current peer checkpoint; then delegate full route/time/signature verification
to DR-0033, including final protected-clock checks. Parsed bytes, historical
directory records or caller keys cannot mint that result.

This verification still does not authenticate a message, prove publication,
grant consent, mint XMG/XMC, authorize dispatch or ACK. Shared must take an
outbound package only from its actual phase-7 own publication and retain an
inbound package only from an authenticated initial/ordinary event bound to
the actual session peer. Dispatch independently rechecks current identity,
network, retained exact route and protected grant/holder custody. A parsed
server hint is never a route successor.

The event embedding and durable route-head/accept-journal cutover are a
separate connected increment: this decision does **not** change DR-0022's
678-byte Hello/Accept or enable an optional second path. Freeze their exact
replacement grammar, capacity and reset impact before changing those bytes.
Until that joined consumer is implemented, reverse physical contact delivery
and ordinary sending without repeated permanent resolve remain release gates.
Rebuild and review/repin actual public APIs in the final business batch. No
node identity, registered keys, network genesis or production floors change.

Normative semantic owner:
[CONTACT-AND-GROUP-PROTOCOL §9.2](../../architecture/CONTACT-AND-GROUP-PROTOCOL-V1.md#92-recipient-algorithm).
