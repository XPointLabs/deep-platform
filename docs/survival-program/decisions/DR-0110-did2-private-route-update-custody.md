# DR-0110 — DID2 private route-update custody

Status: accepted bounded S04 contract; connected source/API/package gates open
Date: 2026-10-11
Decision owner: Mr. X (delegated architecture authority)

## Sole owners and unchanged bytes

CONTACT-AND-GROUP owns authenticated ContactRouteUpdate semantics;
TRANSPORT-NEUTRAL-MESSAGING section8.4 owns linked send attempts and their
settlement. This decision changes no DMC2/14 grammar, record, magic, suite,
signature domain, native wire or route/grant bound. DR-0072's exact same-scope
XRA/XRC/XRR successor rules remain mandatory. Cross-device/delegation/selection
rollover requires its own verified transition; it is not inferred here.

The original native-committed peer Hello/Accept is the relationship's initial
route head. Its exact DMC2 SHA256 is the first successor's predecessor event
hash; subsequent updates name the exact preceding native-committed DMC2/14 hash.
Each update advances the actual prior XRR generation exactly once. Generation0
announcement framing does not permit replacing that authenticated initial head.
Shared obtains these facts only from its actual native floor/history under the
account lease, never a caller route, cache row or resolver hint.

## Closed independent verification boundary

Freeze `VerifiedDeepIdV2MailboxRouteClosure`, an abstract current-delivery boundary
with an internal constructor and no external implementation path. It exposes
only the independently verified six-record route, current recipient/network/XNA,
exact closure, public network/DID2-derived locator and current time checks. The
locator reveals no resolver read capability/key and is computed inside Protocol
from its independently verified recipient, not a Shared hash implementation.
The existing sealed
`VerifiedDeepIdV2ContactRouteClosure` derives from it and retains every original
invite/current-publication verification; no existing check is weakened.

Freeze a separately sealed `VerifiedDeepIdV2UpdatedMailboxRoute` produced only
by `DeepIdV2ContactRouteUpdateVerifier.VerifyCurrentSuccessorAsync`. Inputs are
the immutable original private mailbox package, independently current peer
freshness/network/XNA/protected time, exact prior closure, prior event hash,
actual relationship/conversation selectors and exact DMC2/14. Bounds and copied
selectors precede awaits. Independently verify current DCA/device/subject, original
route facts, every prior signature/retained projection, exact successor lineage,
inner device/threshold signatures, current route windows, event creation/expiry
and final continuous protected time. Parsed event/previous hash is not evidence
of ratchet authentication, consent, publication or native ownership.

The updated delivery result does not expose an invitation or authorize contact
publication, prekey issuance, renewal signing or new consent. DMC2/14 carries no
successor XIR1; never synthesize/re-sign one or let the original expired XIR1
become current. Delivery ports consume the single closed delivery boundary;
publication/authoring ports retain the more restrictive existing invitation
type. This is role separation, not a compatibility adapter or alternate reader.

Freeze `RequireRetainedSuccessorFactsAsync` with the same bounded inputs for
historical independently native-committed updates. It authenticates original
signatures, scope, creation-time containment and lineage but returns no current
route, grant, dispatch or deletion capability. It permits past expiry only for
those historical facts. Current delivery checks remain strict and independent.

## Connected business obligations

Freeze `AuthoredVerifiedContactRouteUpdate` and the key-free
`ApplicationCoreCodec.AuthorVerifiedContactRouteUpdateAsync` boundary. It accepts
the closed current own invitation/publication route, original own private package
and exact comparison selectors for its advertised predecessor. It copies bounded
selectors before asynchronous work, derives creation/expiry from continuous
protected time and all signed closure windows, frames unchanged DMC2/14 and
independently verifies its current successor. It exports no signer and does not
prove caller selectors came from native history, consent, an adopted publication,
an authored floor or a committed command. Shared owns those joins. Generic raw
ContactRouteUpdate emission remains disabled.

The existing common authored slot has one local generation6 reader. The bounded
layout, kind discriminator, durable stop time and working-payload disposition
are specified only by the exact private producer and obligations in
[authored custody](../../../deep-client-shared/docs/architecture/owned-authored-counter-custody.md).
S04 implements DR-0084's independent stopped-work semantics and the actual
dependency-closed plan; a parsed disposition grants no Store, non-delivery or
cleanup authority. The payload bound is the already frozen DMC2/14 maximum. A control
requires nonzero canonical expiry and its actual scope relationship; existing
ordinary content still requires expiry0. This is space for the already allocated
kind, not a raised operation/ratchet/grant bound. The current SQL application schema matches
this payload bound and the exact original-route evidence below; prior application
schemas and authored generations1/2/3/4/5 reject even when empty.
Account registration initializes only current roots; old state needs explicit
whole-account reset, never reader repair/migration.

Sender obtains a new update only from its actual own adopted publication and
retains one exact command in the existing common authored namespace/counter.
No new journal or second sequence floor is created. A necessary local generation
cutover rejects prior state; no migration, alias or compatibility reader.
Receiver derives peer route history from actual native authenticated events,
including independently protected compacted history. Exact duplicates are
idempotent. A changed same generation/predecessor, gap, forbidden policy or
invalid authenticated closure preserves conflict evidence and fences new sends
across cold reopen; it is not repaired by taking the highest generation.

The receiver's first processing outcome belongs to the actual native receive
commit, including its independently protected time interval. Retain it through
the existing pending/SQL/cleanup/stable transaction and protected history prefix,
not an unprotected application timestamp, latest-route scan, caller Boolean or a
second journal. Exact native replay uses that original outcome without a second
ratchet operation or retrospective reclassification after expiry. A crash before
application materialization must preserve the same qualified outcome. Exact local
metadata/schema changes must be frozen with DR-0027 before their implementation;
this requirement allocates no new public wire kind or crypto suite.

A route-head fork fences that peer route's new sends; it does not, by itself,
authorize the destructive whole-session owned-send latch or erase its live TRS.
Retain the authenticated event and rejected outcome. Local history, receive,
object/read/ACK dependencies and unrelated relationships are not discarded.
Positive control materialization requires the qualified native outcome plus
independent historical route/consent checks. It creates no user text or AppAck
obligation. Transport ACK remains its separately qualified existing boundary.

For a captured mailbox page, the ACK owner independently reopens the registered
session and verifies the exact authenticated receive/envelope, nonzero original
processing outcome and complete protected native history under the actual lease.
It rechecks current account/endpoint/network/time and retained original contact
facts. Accepted controls require the positive historical semantic handoff;
rejected controls require the actual retained rejected native outcome and create
no semantic projection. Neither case reclassifies an old event using current
route expiry. Unknown/absent processing, missing or changed custody and expired
base authority cannot authorize ACK. A durable rejected receive can return to
page orchestration without promoting the route or erasing its conflict fence;
only the existing independently qualified read/holder/tombstone boundary deletes
the transport item. No Boolean supplied by a caller is ACK authority.

New dispatch uses only the final independently current delivery route. Outstanding
original attempts retain their exact route/request/holder; only a permitted linked
successor may use the new route with the same committed native ciphertext and
logical deadline. Every historical Store/settlement/cleanup/holder retirement
authenticates its own original route through actual native event custody, not
the latest head. Incomplete updates cannot replace current or delete old read/
object/ACK dependencies. Expired or missing authority remains fail closed.

### Exact original-attempt route selection

The existing nine-record `mailbox_store_public_evidence` row retains its full
canonical original six-record route for every attempt, not only Initial Store.
Its existing `original_route` field is mandatory and remains bounded by the
frozen ContactRouteClosure limits. `original_dcr` and `original_peer_adp` are
either both empty (ordinary/control) or both nonempty (Initial). Initial status
still derives from DCR presence, never route presence. Only the integrity column
specified below is added; no table, journal or journal-entry capacity increase.
The current application schema is the sole reader (its exact generation and
stopped-work retention layout belong to the Shared local format owner);
prior schemas reject even empty, without migration or filling in the latest route.

Historical selection compares that exact retained route with native Hello/Accept
or an actual accepted native receive14, under the registered account lease and
full SQL/protected floor/history verification. The original positive outcome
authenticates the exact independently signature-verified control; a parsed DMC,
application flag or caller timestamp does not replace it. Reconstruct ordered
event-hash/generation predecessors, endpoint/relationship scope, consent and
native authored positions; absent/rejected/gapped/forked updates cannot supply a
route. A later retained fault cannot erase an earlier qualified historical route.
This selector returns historical parsed metadata only; current delivery still
uses the independently current Protocol verifier. Every Store/quorum consumer
also rechecks the original signed projection/replica keys, request/holder/grant
and receipt intervals. No fresh peer lookup or latest head is required just to
authenticate an old attempt. Validate each attempt's own route before linked
successor, settlement, compaction or holder retirement; exact pending requests
never acquire a replacement route. Connected tests precede removing the existing
changed-route successor denial.

### Immutable original-evidence commitment

The connected schema13 mutation test demonstrated that native membership alone
cannot identify which of two otherwise valid same-contact routes was captured
for an original attempt after its working commitment is removed. It must not be
treated as immutable provenance. Preserve the nine existing bounded public
records and append one mandatory local `evidence_commitment`32 column to the
same row; no new table, journal, wire, public signature domain or capacity is
allocated. Schema14 rejects13 even empty. Do not retain raw XMG2 capabilities
or infer an outer issuer signature on XMC2.

Derive the local integrity key with HMAC-SHA-256 from the existing actual
protected application registration secret32 (bytes88..119), using UTF-8
`Deep/STORE-V2/original-store-evidence-key`, zero separator and registration
bytes8..87 (network/account/instance80). The key never leaves the held owner.
The commitment is HMAC-SHA-256 over UTF-8
`Deep/STORE-V2/original-store-evidence`, zero separator, exact registered scope404,
native operation32, attempt32, byte9, followed by the nine records in their
existing order, each prefixed by its unsigned big-endian length32. MAC itself
is excluded. Bounds precede key access/materialization; keys and temporary
buffers are cleared. This is a local integrity transcript, not a public signer.

Only the actual held owner may produce this commitment, after independent
native/prepared-attempt/route-hash qualification and before ingress. Existing
evidence must compare exactly; no reader signs, repairs or fills missing rows.
Every selected historical Store, late settlement, each compacted sibling and
used-Deposit original attempt independently verifies the MAC using its actual
protected registration and selectors. Rebinding route/native/attempt/records,
foreign instance, absent/changed commitment and protected-registration loss
reject without issuer/transport callbacks or custody mutation, including after
working/floor/acquisition retirement. The MAC grants no route, admission,
success, currentness or deletion authority: actual native/semantic history,
original holder-signed MAU/grant/policy/replicas/coordinator and current own
context remain independently mandatory. It is not a serialized trust flag.

Whole-path current/negative/fork/cold/crash/cancellation cases, public API/graph
qualification, frozen repins and downstream compilation precede acceptance.
Scheduler, XUR distribution, deployment, physical delivery and release remain
their existing later-stage gates. This contract is not their activation.
