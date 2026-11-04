# DR-0178 — paged route history and independent current promotion

Date:2026-11-04. Owner: Mr. X (delegated architecture authority).
Status: accepted semantic correction and bounded Protocol allocation after
independent Astra Ultra review. Native persistence allocation is accepted below;
implementation/integration and
all source, retained-client, performance and release qualification remain open.
This decision does not activate an incomplete consumer.

## Problem and deliberate semantic change

A native-committed private route announcement can expire before delivery and
be permanently stopped by its legitimate owner. Requiring the next announcement
to name that exact private event makes it an unavailable dependency. Public
completed publications can also outpace private announcements; old intermediate
publications cannot be reauthored as current controls.

For the new count8 route-history contract, remove private announcement delivery
as a prerequisite of later route admission. This explicitly supersedes that
clause in DR-0110 and CONTACT-AND-GROUP, and the corresponding interpretation
of DR-0159's predecessor rule. It is a semantic clean break, not a claim of
unchanged private-event continuity. Every signed PUBLIC completed/proposal
predecessor remains required. No new crypto, signer, service or trust source.

The retained security properties are actual native relationship/consent,
account/device/DCA/scope authentication, full signed public lineage, protected
progress and monotonic qualified routes, current authority and expiry, native
replay/dedup and authored-position conflict evidence. DMC14 changes no consent
or revocation decision requiring delivery of every earlier announcement.
Two different announcements of the same exact public endpoint are not a route
fork merely because their private predecessor or outer event differs.

Original pending/stopped commands, old authenticated native outcomes and their
evidence retain their exact original interpretation. Do not revive them,
rewrite rejected outcomes, reencrypt uncertain commands, reset accounts or
reinterpret a recorded proposal as an ordinary completed publication.

## Independent historical progress and live route

Per relationship/direction retain independently authenticated:

- C: exact verified completed endpoint, XIR/XRR/six-record closure source.
- P: exact verified proposal XRA/XRC/PMS/XSS/issuance-ADH source; its generation
  need not equal C's generation.
- L: the last independently current-qualified announcement/route source.
- Actual consent and first proven conflict, plus durable local decision custody.

All references resolve to actual native originals or authenticated archive
facts. A remote cursor is never permission or locally adopted progress.

Seed C/P from the exact XIR and route in the original native Hello/Accept,
at that relationship's actual initial generation. Preserve existing L and old
qualified outcomes. A later count6 native head contains no exact later XIR:
a device signature plus matching XRA does not prove its missing XIR tag2/tag4
lineage. Replay from the original anchor once, in bounded durable steps. On
reaching the existing qualified head's generation, require the exact same
six-record closure. Missing adopted progress is corruption, not permission
to bootstrap again. After bootstrap each page's left XIR equals the already
authenticated C source byte for byte; a future left endpoint stages.

An announcement is historically eligible after the recipient independently
verifies its full public C/P prefix, actual relationship/consent and unchanged
account/device/DCA/scope, with no relevant signed-lineage or native-position
conflict. Earlier private announcements need not have arrived. Current promotion
requires a separate fresh qualification of account/device/revocation/network,
protected time, signed route windows and the announcement's own event windows.
An older endpoint cannot replace L. A fresh announcement of the identical
endpoint may refresh announcement evidence after the same current checks;
it cannot extend any signed route lifetime.

Expired or out-of-order evidence can advance historical facts once its original
signatures/containment and adjacent lineage are proved, but gives no current
permission. A missing prefix, current expiry, future start or local authority
failure is not proof of a malicious remote fork. Independently verified
incompatible signed artifacts at one scope/generation remain sticky, as do
the existing distinct native DMCs at one authored position. Existing native
F4 remains the only authored-position conflict index.

## Closed count8 DMC2/14 payload

Keep the existing DMC type14, empty reply field, native encryption, record and
ciphertext caps. The entire inner payload remains at most32768 bytes.
All integers are unsigned big-endian. Unknown modes/versions, reserved bits,
trailing bytes, malformed nested records and arithmetic overflow reject before
allocation, provider callbacks or durable effects.

Header is exactly1024 bytes:

| Offset | Field |
| ---: | --- |
| 0 | relationship32 |
| 32 | right completed generation u64 |
| 40 | immutable original relationship-anchor DMC SHA25632 |
| 72 | discriminator8 |
| 73 | version1 |
| 74 | mode:1 evidence,2 announcement,3 evidence+announcement,4 history request |
| 75 | atom count u8 |
| 76 | zero4 |
| 80 | left cursor112 |
| 192 | right cursor112 |
| 304 | exact left completed-anchor XIR1V2,611 bytes |
| 915 | request event SHA25632, zero for requests/unsolicited controls |
| 947 | zero77 |

Cursor112 is completed generation8, XRR core hash32, proposal generation8,
XRA core hash32, XRC core hash32. The right generation equals header offset32.
The enclosing DMC supplies network, sender and conversation. Every control
joins the actual native immutable anchor; it does not install its own anchor.

Modes1/3 carry1..3 LP-u32 atoms and the exact final computed cursor. Mode2 has
zero atoms, equal left/right endpoint cursors and announces an endpoint already
available in authenticated history; absent evidence stages it. Mode4 has zero
atoms, equal left/right cursors from the requester's actual protected progress,
and exact C XIR. Its cursor is a bounded response-selection hint, never authority.

Each atom is kind1=proposal or2=completed followed by: original nonce32,
original minimum ADH generation8 and core hash32, original DCA473, original
directory lookup key32, original XRA550, response length:u32 and the exact
ordinary RouteV3 response. A completed atom additionally has exact XIR611,
XRR643, PMT length:u32 and exact PMT2.

Reconstruct the exact canonical ordinary V3 request using the selected exact
completed anchor. The producer compares it to its protected retained request
original. The recipient independently verifies the original nonce/DCA/lookup,
response/request bindings, issuer and threshold/device signatures, original
network projections/authority intervals, issuance ADH, minimum-generation/hash
and same-generation constraints. Today's DCA or ADH cannot replace originals.
Device/DCA rollover is outside this same-device transition contract.

Preserve every existing adjacent XRA/XRC/XSS/PMS predicate. A proposal advances
P without C. A completed atom advances C exactly once; its proposal either
advances P once or equals the already verified exact P of an overlapping
proposal atom. For XRR require generation+1, exact prior core hash and unchanged
DR-0072 scope. For XIR require generation+1, tag4=SHA256(exact previous XIR),
unchanged tag2 identifier, reusable policy, redemption limit, minimum reader,
publisher/DCA and placement scope, and every existing XIR/XRA PMT, capability,
sealing and signed-window binding. XIR/XRR completed generations agree; their
distinct predecessor domains are not interchangeable. Public route signatures
do not prove replica publication commitment or authorize publication.

Exact maximum proposal atom16311; completed28635; header+LP+one maximum
completed atom29663. One legal atom always fits32768. Pack fewer than three
when the aggregate would exceed the cap. Three is a per-call bound, never a
lifetime recovery cap. Reject aggregate overflow before authoring/callbacks.

Existing count6/7 records remain interpretable for retained originals and exact
pending work with their original framing. New paged production uses count8;
do not create a parallel business/transport stack or broaden raw generic
ContactRouteUpdate authoring. Typed historical results grant no current route.
Only a separately qualified closed current-route result can enter delivery.

## Bounded request/response lifecycle

The sender cannot infer recipient progress from Store success. A recipient
missing public predecessors, or unable to use its retained route, authors
mode4 from its actual durable C/P. Authenticate it through the existing native
relationship/current-account/consent owner. Use existing route reintroduction
with independently current public recipient endpoints, never expired routes.

The responder independently matches the claimed cursor and exact XIR to its
own authenticated retained originals. A mismatch rejects; never choose the
highest generation or silently fall back to genesis. Return one bounded page,
at most3 atoms and32768 bytes, correlated to SHA256 of the exact native request.
If it already reaches the responder's current completed endpoint, return a
freshly qualified endpoint announcement. The hint changes no local checkpoint,
publication, cleanup or fork permission.

After independently committing returned historical progress, the requester
can issue the next request from the new C/P. Keep one active request and one
active response per relationship/direction in existing authored work owners.
Resume exact pending operations first. A duplicate request resumes its exact
response while dispatch remains allowed. A replacement request waits until
prior uncertainty/stop obligations are closed. After expiry and proper stop,
a fresh request from unchanged C/P can receive fresh outer pages containing
the same immutable public evidence. This never revives an expired operation.

Late responses check correlation against retained original request custody;
their signed evidence may still advance history, while promotion independently
checks currentness. Store/transport ACK does not advance C/P or prove semantic
admission. Requests use current authority/time expiry, not the old route's expiry.
Mode4 names the requester's adopted peer history: its original-anchor hash is
opposite the request author's route subject. Responses and modes1/2/3 name the
author's own history. Native message direction remains unchanged in both cases.

Store alone does not authorize another request from unchanged C/P. First resume
or settle any existing unresolved authored request through its existing owner;
then use F8's latest outgoing request fact below, including after working-row
retirement. Resolve its exact payload and compare with actual adopted peer C/P.
While C/P is unchanged and the protected lower time bound precedes its expiry,
suppress a new request. Verified progress or proven expiry permits replacement
only after prior dispatch uncertainty is closed. This wait is derived from
existing authenticated originals, not a new queue or protected flag, and must
not pin an entire ordinary compaction prefix while waiting for a response.

If a response draft was completely stopped before any native commit, a fresh
response to the still-current exact request is permitted after actual F8 tag3
nonmembership and completion of that draft's uncertainty/stop obligations.
It receives a new operation, logical ID and counter; the stopped operation is
never revived. This rule is identical before and after working-row retirement.
Once a response was native-committed, F8 tag3 retains its unique exact original:
stored, stopped or expired committed responses do not authorize replacement.

## Native durable decision and archive integration boundary

Original receive outcomes remain immutable. Allocate a distinct staged evidence
outcome3 for the new controls; it grants no live permission. Later historical
progress, promotion and proven conflict require a locally authenticated native
decision via the existing pending/SQL/cleanup/stable lifecycle. No second journal,
unauthenticated SQL flag or retrospective rewrite of the original outcome.

The owner-only qualification binds exact before floor/state, selected original
sources and the actual qualification interval. Durable protected pending is
its linearization point. Exact recovery after expiry can finish that historical
decision; fresh dispatch still rechecks current permission. The ratchet/TRS,
authored counters and original operations remain unchanged by a local decision.

The following native allocation is accepted after the2026-11-04 Astra review;
implementation, signed integration and activation are not thereby qualified.
It extends DR-0027's existing native transaction and DR-0177's archive. Selected
facts and actual authority stay distinct; no additional protected journal exists.
All original decisions/sources survive prefix removal and reproduce exactly in
independent full replay. Missing prerequisites stage; only proven conflict faults.

### Closed native decision

MSP2 remains version2/672 bytes. Kind6 requires active stable predecessor,
direction0/status1 and exactly one next native ordinal. Ratchet generation,
commitment, TRS hash and retained TRS bytes are unchanged. Header8..195 is exact
predecessor188;196/204/236 copy its ratchet fields. Header268 is the decision
operation,300 is SHA256(body1024),332..587 and608..671 are zero. Body2 length is1024;
bodies0/1/3/4 are empty. No ratchet/send/deletion/AppAck evidence is manufactured.
Both metadata-only and complete-body validation enforce these equalities.

Operation = SHA256(UTF8 `Deep/STORE-V2/route-history-decision` ||00||scope32||
exact predecessor188||SHA256(exact body1024)). Pending binds the exact selected
interval and sources. Recovery never regenerates operation, interval or bodies.

| Body offset | Exact field |
| ---: | --- |
|0|version1|
|1|action1 bootstrap,2 evidence advance,3 current promotion,4 proven conflict|
|2|subject1 own route,2 peer route|
|3|zero|
|4|scope32|
|36|previous subject decision Ref88; absent only for bootstrap|
|124|selected original Ref88|
|212|selected atom index1 byte, then zero7|
|220|result C Source96|
|316|result P Source96|
|412|result L original announcement/native Ref88|
|500|retained first-conflict Ref88|
|588|actual consent Ref88|
|676|decision interval64 below|
|740|selected endpoint exact closure SHA25632|
|772|related conflicting original Source96; zero otherwise|
|868|zero156|

Source96 = original Ref88 ||atom index1||zero7. In C/P sources, index0 selects actual
original Hello/Accept;1..3 selects an exact count8 atom. The separate selected
original at124 uses index0 for a whole announcement/control. C/P sources cannot recursively
name decisions. Decision Ref88 is kind3/direction0, actual positive rowid and
ordinal, nonzero operation and metadata hash in the immutable table below.

Interval byte0 is1 only for action3,3 for actions1/2/4;1..7 zero,8..15 lower
Unix milliseconds nonzero u64be,16..23 upper u64be>=lower,24..31 protected
monotonic sample seconds u64be,32..63 nonzero SHA256(actual boot ID). Use a
separate closed action/interval validator; original receive outcome2 is forbidden
here. Incoming count8 outcome3 means staged only, not per-atom qualification.

Bootstrap is permitted per subject only when authenticated archive reducer plus
complete bounded working-suffix replay proves absent subject decision and no
prior subject kind6. Missing referenced sources/decisions or inconsistent suffix
reject; they never permit reseeding. Preserve actual consent, sticky fault and
old qualified L. When C reaches old L's generation, require byte-identical closure
before promoting beyond L. No extra bootstrap flag or private-event chain exists.

Evidence advance applies exactly one independently verified adjacent public
atom; C/P changes only as that transition permits. L/consent/fault stay exact.
Promotion leaves C/P unchanged, binds a proved endpoint at or beyond L, and
requires fresh current qualification. Same-endpoint fresh announcements are
allowed; signed route expiry is never extended by announcement expiry. Conflict
preserves C/P/L and records both fully verified incompatible sources with exact
atom indices. It does not arise from gap, expiry, malformed or merely staged data.

For action4, field500 retains the previous fault. If absent, effective first fault
is this decision's actual Ref88 after SQL insertion; no predicted self-rowid is
encoded. Later snapshots retain that first conflict decision. An old outcome2
fault keeps its original meaning. New promotions cannot bypass a sticky fault.

### Immutable source and archive facts

The current, not-yet-activated schema6 consists of byte-identical schema5
OriginalSchema plus this immutable table and the three archive staging tables:

```sql
CREATE TABLE route_decisions (operation BLOB PRIMARY KEY NOT NULL CHECK(typeof(operation)='blob' AND length(operation)=32), ordinal INTEGER NOT NULL UNIQUE CHECK(typeof(ordinal)='integer' AND ordinal BETWEEN 1 AND 9223372036854775807), decision BLOB NOT NULL CHECK(typeof(decision)='blob' AND length(decision)=1024), metadata BLOB NOT NULL CHECK(typeof(metadata)='blob' AND length(metadata)=672));
```

Keep original schema5 validation unchanged. Enrollment source framing enumerates
original tables and route_decisions in ordinal name order with DR-0177's existing
schema/typed-row transcript. For absent schema5 route_decisions use its canonical
schema frame plus table-end0/u64zero row count; after staging require the actual
empty table to produce exactly that frame. It stays empty throughout enrollment.
Current-source audits include actual rowid, operation, ordinal, decision and
metadata. route_decisions is never disposable staging or removed with a prefix.
Merge events and decisions by native ordinal; reject duplicate operation/ordinal
across both. Count original kinds2/5/6, excluding imports/activation/latches.

Reducer is1136 bytes: preserve offsets0..903, own decision Ref88 at904, peer
decision Ref88 at992,zero56 at1080. Update codec/DDL/profile/selected-read/full
audit and tests together, without a960-byte fallback. Root608 still binds the
reducer hash. F1(operation)/F3(ordinal) admit kind3; F2/F4/F6 retain original event
semantics. F5 may reference only a qualified peer action3 decision and must resolve
its actual immutable row and L original. Generic event readers reject kind6.
Kind6 does not rewrite legacy route-head/private-previous fields inside0..903:
their original ordinal ordering continues to describe retained count6/7 work.
Effective current L comes from the actual latest subject decision once present;
only absence of any decision permits the legacy head. Missing referenced
decisions reject instead of falling back. This allows an earlier-arrived final
announcement to become current after later prefix delivery, without falsifying
original arrival order. F5's predecessor binding then uses the prior decision's
actual L, including the bootstrap-preserved legacy L.
That decision L may name an actual retained count6/7 original; qualify those
exact bytes and their original predecessor without substituting a reducer head.

F7 key = direction1||class1(C)/2(P)||generation:u64be. Value224 = first verified
decision Ref88||verified identity32||latest candidate Source96||sender sequence8.
Only kind6 bootstrap/evidence installs the first verified entry. Raw outcome3
updates only the greatest authenticated sender sequence candidate; exact-event
duplicates select earliest native ordinal/atom index. Different events at equal
authored position retain F4 conflict semantics. Absent halves are all-zero; a fact
must have at least one half. A fresh valid page can replace an earlier unusable
candidate. Raw candidates never establish a public fork or overwrite verified
history. A newly fully verified distinct identity requires action4 against the
first verified decision; keep that decision for bounded before-state resolution.

Verified identities use SHA256 over the following concatenations:

- UTF8 `Deep/STORE-V2/route-history-C`||00||scope32||direction1||XIR.ObjectHash32||XRR.CoreHash32.
- UTF8 `Deep/STORE-V2/route-history-P`||00||scope32||direction1||XRA.CoreHash32||XRC.CoreHash32||XSS.CoreHash32.

Preserve all exact artifact references embedded in signed cores. XIR's object hash
includes its signature, as required by its existing predecessor domain. Candidate
identity does not replace exact original request/response equality for P overlap.
Failed overlap alone is not a proven fork. Rehydrating a retained historical
facts object must join actual independently authenticated decision/source refs;
caller-supplied cursor or remote checkpoint is never adopted-state authority.

Protocol's closed `VerifyRetainedHistoryCheckpointFactsAsync` restores only the
existing historical-facts type from exact original Hello/Accept, exact C XIR/route
and nullable exact retained P original pair, with current peer/network/authority/
time. Null P is allowed only for byte-identical original C/P seed. It copies and
parses bounded inputs before awaits, rechecks intrinsic signed bindings, original
relationship/scope/DCA, issuance ADH and response/request binding. P's original
completed anchor may be older than C; same-generation anchor must be byte-exact,
future anchor rejects. P cannot precede C's proposal; equal generation requires
exact XRA/PMS/XRC/XSS. Existing independently authenticated native kind6/C/P/F7
source qualifications prove past adjacency and C issuance; restoration does not
establish new progress or replay lifetime history. Shared must validate actual
decision/source/root/floor before this call, compare derived facts to those exact
sources and rejoin after callbacks. Staged candidates never enter this path.
Every new adjacent step retains its full original predicate; current promotion
retains separate fresh qualification. No new public constructor or skip flag.
The parsed atom's defensive `ExactXrc1`/`ExactXss1` getters expose only its
already parsed original response records, so F7 identity derivation needs no
duplicate wire offsets or invented request data. They grant no authority.

Ordinary current-L requalification resolves the endpoint named by that actual
announcement, not automatically the latest C/P, which may already be ahead.
For count8 mode2 this requires its exact C and P first-verified F7 witnesses,
their selected original sources and the original completed anchor needed to
reconstruct P's request. Resolve only those fixed dependencies; do not traverse
decision predecessors recursively or load staged candidates/history pages for
ordinary delivery. Keep the existing closed current-announcement verifier and
the final paired source checks. A source-count bound must include the actual
working-suffix authored joins as well as selected archived originals; omitting
either set to fit a former bound is not permitted. Catch-up selection and its
candidate sources remain a separate bounded purpose.

The authored-source ceiling remains71 for ordinary current/custody reads:
at most64 working event/decision originals plus two archived-basis C/P
sources, two endpoint C/P sources, one P-request completed anchor, one L and
one actual local Accept/consent source. A working evidence decision introduces
at most one distinct outgoing original for its C/P transition. Deduplicate
exact references; peer history sources are incoming. Explicit catch-up alone
may select up to95 outgoing originals:64 working +2 basis C/P +24 dependencies
for at most12 selected facts +1 L +1 anchor/consent +1 selected control +2 fault
witnesses. A first-verified P fact needs at most its P original and before-C
original; C/F8 facts need at most one, and raw F7 candidates are incoming.
This is a conservative dependency bound, not permission to expand every read
or recursively follow earlier decisions. Test both the maximum-role closure
and rejection before effects when a selection exceeds its purpose's bound.
Signed-conflict selection verifies one C or P conflict class per attempt. It
may select at most8 facts, resolving each first-verified original plus that
decision's immediate before-C and before-P:71+8*3=95 remains the ceiling.
At most three bounded source-capture stages may derive the before-P selector
from its actual qualified payload and obtain its exact request anchor. They
do not recursively traverse predecessor history or accept caller-supplied refs.
Ordinary and generic catch-up limits remain unchanged.

`VerifyHistoryAtomAsync` returns one verified step for an exact count8 native
original and a1-based atom index1..3 matching Source96. It validates bounded page
framing/message scope before callbacks. Index1 joins exact page left to the actual
independently qualified before-state. Later indices derive the bounded preceding
prefix and require exact before cursor/XIR, last preceding completed closure when
present, and last preceding P records plus original request/response bindings;
P uses its own carried older C anchor. Parsed preceding atoms do not establish new
facts. The selected atom runs the unchanged complete adjacent-step predicates in
both fresh contexts; the last atom also checks computed page-right cursor. Shared
binds the selected original/index and before/after native fences. This enables
restart after atom1 without replaying lifetime history and never declares an
unverified entire page adopted.

F8 has four closed selector/value forms in the same archive:

| Selector | Value and merge |
| --- | --- |
|tag1, direction1, completed generation8, XRR core32|announcement Ref88 plus authenticated sender sequence8; greatest sequence, exact duplicates earliest ordinal|
|tag2, exact outgoing mode4 DMC hash32|outgoing request Ref88; unique/idempotent exact original|
|tag3, exact received mode4 DMC hash32|outgoing response Ref88; unique/idempotent exact original|
|tag4, direction1; exact selector bytes `04 01`|latest outgoing mode4 request Ref88 plus authenticated sender sequence8; greatest sequence, exact duplicates earliest ordinal|

Selector fields concatenate in the listed order; tags are single bytes. Endpoint
candidates grant no current permission. Preserve
the existing one-active authored request/response and exact uncertainty/stop
obligations; F8 is not a queue or authoring authority. Late correlation resolves
actual original custody even after that command has stopped.
Tag4 rejects every other direction or selector length and requires the actual
outgoing mode4 payload, scope, native metadata and authored-sequence join. It
adds one fact only to an outgoing request; the12-fact bound remains unchanged.

Retain count8 outgoing request/response payload and exact columns in existing
application authenticated_dmc2_inbox. Resolve F8→native outgoing original→metadata
EventHash→ReadArchiveAuthoredOriginal, checking exact DMC/hash/scope/author/sequence
and protected/application counters. Working outbox/protected entry may retire only
after this permanent authored-original custody is present and verified. Referenced
inbox originals survive retirement. No separate payload table is introduced.

At most12 typed facts per original; a32-original batch bounds each independent
Patricia proof pass by12*32*257 nodes. Account for separate before/after passes;
this is not an aggregate latency claim. Full replay reconstructs staged originals,
candidate selectors and later kind6 decisions in ordinal order, independently
matching incremental roots/reducers and retaining all original source dependencies.
No verifier/provider callback executes inside the pure builder.

## Qualification and activation

Two previous private-chain tests are replaced because their old expectations
contradict this accepted public-history contract. A missing intermediate page
stages until its prefix arrives; a fresh announcement of the same public endpoint
is not a fork merely because another private announcement was withheld. Exact
test-name bindings for the canonical gate are:

- Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualAuthenticatedGapStaysRejectedAfterLatePredecessorAndColdPrefix -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteHistoryPaged_ActualGapStagesThenLatePredecessorAndRetainedContinuationPromote
- Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualAuthenticatedSameGenerationForkPreservesLiveTrsAndColdFence -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteHistoryPaged_FreshAnnouncementOfSamePublicEndpointDoesNotCreatePrivateChainFault
- Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteProcessing_ActualAuthenticatedSameGenerationForkPreservesLiveTrsAndColdFence -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2RouteHistoryPaged_ActualAuthoredPositionForkCommitsExactWholeControlFaultAndColdFence

Original receipts remain unchanged. Replacements must actually pass; real
authored-position and incompatible signed public-history conflicts still fence
the peer while preserving TRS. Renaming cannot waive those checks.

Required cases include original0→3 bootstrap preserving L3; expired4/5 then
current6; stopped undelivered private6 followed by current7 without reading or
redispatching6; missing/conflicting public6; final-before-prefix; reverse pages;
overlap and repeated identical-endpoint announcements; original XIR tag2/tag4
substitution; mixed proposal/completed offsets; maximum atoms and overflow before
effects; forged higher requests; Store-success then lost/expired page and resume;
all pending/SQL/readback/cleanup/cold-replay cutpoints; actual selected-source
corruption; unchanged TRS/counters; retained original Store/ACK dependencies;
independent full rebuild versus incremental archive; bounded ordinary work.
Native cases additionally cover missing adopted decision forbidding rebootstrap,
C-at-old-L closure substitution, cross-table operation/ordinal collision, actual
rowid/body/metadata substitution at recovery cuts, conflict atom-index changes,
kind6 preserving TRS and counters, unusable candidate replaced by a later valid
page without losing first verified facts, and late response correlation after
working request retirement with retained permanent authored original.
Also qualify unchanged-C/P request suppression after Store and retirement,
verified-progress/proven-expiry replacement, unresolved-dispatch refusal, and
tag4 direction, payload, sequence and candidate-order substitution.

Use DR-0177's corrected sequence: combined qualification and independent source
audit, same-three-profile guarded maintenance-only enrollment, catch-up, retained
round60, then warm delivery/ACK measurement. No resets, original-intent rewrites
or Windows/Android operations. This recipient contract alone does not close
independent owner/Registry/XPS long-history progress and retirement findings.
