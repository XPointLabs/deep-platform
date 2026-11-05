# DR-0177 — authenticated native archive index

Date: 2026-10-28. Owner: Mr. X (delegated architecture authority).
Status: accepted codec and exact runtime/adoption allocation. Runtime activation
requires the qualification below. No connected or latency qualification.

[DR-0179](DR-0179-established-native-session-provenance.md) distinguishes fresh
established native admission from full original-source audit. It preserves this
decision's actual native/application fences and does not grant cached authority.

The2026-11-04 native-decision amendment in
[DR-0178](DR-0178-paged-route-history-and-current-promotion.md#closed-native-decision)
extends this inactive allocation to immutable kind6 sources, reducer1136 and
F7/F8. Apply that amendment as one current schema6 cutover before enrollment;
the earlier six-family/reducer960 descriptions below are its predecessor basis,
not an additional ordinary profile or compatibility reader.

The [current architecture](../../architecture/README.md) indexes this local
contract and its owning implementation boundaries.
The codec is private local state using existing SHA-256/SQLCipher/protected roots,
not a new public protocol, service, crypto suite or trusted remote certificate.
A source-only unused codec does not change ordinary runtime behavior.

## Detection timing and activation boundary

The completed indexed runtime will authenticate selected archive facts against
an independently protected root, verify the entire bounded working suffix and
retain actual current floor/key/registration/authority/time joins. It will detect
unselected archive corruption on access or explicit cold/full audit instead of
at every ordinary operation. This is an explicit detection-timing change from
DR-0175, not an equivalent full-page scan. No new route, replay, signing or ACK
permission follows from a root, SQL mirror, caller hash or prior successful read.

This timing change may activate only after the exact runtime/adoption contract,
all native consumers, guarded lossless enrollment and negative actual-provider
tests are complete. Until then DR-0175 remains the active ordinary verifier.
The retained three CLI profiles must not be reset or implicitly repaired.
## Exact isolated codec allocation

All integers are unsigned big-endian. Unknown versions/families, nonzero reserved
fields, overflow, noncanonical absence and trailing bytes reject before use.
Domains are the exact UTF-8 strings below, followed by one zero byte. Every hash
is SHA-256 using existing .NET crypto; no new dependency or wire generation.

Protected root, 608 bytes, slot `<floor-slot>.archive`:

| Offset | Field |
| ---: | --- |
| 0 | version 1, zero reserved 3 |
| 4 | positive revision u64 |
| 12 | scope hash 32 |
| 44 | immutable enrollment-source history checkpoint 304 |
| 348 | moving stable active basis 188 |
| 536 | archived event count u64 |
| 544 | Patricia root hash 32 |
| 576 | reducer hash 32 |

`.history` stays immutable after enrollment and must equal the embedded source.
Current floor is joined through all journal transitions from moving basis, at
most 64. Archive count excludes import/activation/latch, includes directions
1–4, and is bounded by basis ordinal minus two. An empty basis requires the
canonical empty trie/reducer. Count0 with active basis2 may already contain the
initial Hello route in family5; count0 alone does not imply an empty trie.
A positive archive count forbids an empty trie. A nonempty basis is active
stable with ordinal≥2.

Event reference, 88 bytes: `kind:u8 || direction:u8 || zero6 || ordinal:u64 ||
rowid:u64 || operation32 || metadataHash32`. Allzero is the only absent encoding.
Kind1 identifies the singleton initial-events table (direction0,ordinal1,rowid1,
operation zero, nonzero metadata hash); its zero operation is a reference tag,
NOT a statement about the initial metadata's actual claim operation. The real
initial table has `singleton INTEGER PRIMARY KEY CHECK(singleton=1)` and import
metadata is journal ordinal1. Kind2 identifies events, directions1–4, positive
ordinal/rowid≤Int64.MaxValue, nonzero operation/hash. Selected refs carry their
rowid directly; SQL index lookup is unnecessary and cannot establish absence.

Typed key: `H("Deep/STORE-V2/archive-key" || 00 || scope32 || family:u8 ||
selectorLength:u16 || selector)`. Empty hash:
`H("Deep/STORE-V2/archive-empty" || 00 || scope32)`.
Node hash: `H("Deep/STORE-V2/archive-node" || 00 || scope32 || exactNode)`.

Leaf: `version1 || kind1 || family || zero || key32 || selectorLength:u16 ||
valueLength:u16 || fullTypedSelector || value`, max320 bytes. Key is recomputed
when decoding; matching hashed key with differing typed selector rejects.
Branch104: `version1 || kind2 || zero2 || bit:u16 || zero2 || prefix32 ||
leftHash32 || rightHash32`. Bit0 is the most significant bit; bits0–255 only.
Prefix bits at/after bit are zero. Child hashes nonzero, distinct, and not the
scoped empty hash. Branch bits strictly increase; every traversed child prefix
or leaf key agrees with all parent prefix bits and the chosen edge bit. One
proof visits≤256 branches+one leaf. Authenticated prefix or leaf divergence
proves absence; missing node/hash mismatch/truncated proof never does.

| Family | Selector | Value |
| --- | --- | --- |
| 1 operation | operation32 | Ref88, any direction1–4 |
| 2 first incoming event | eventHash32 | earliest direction2 Ref88 |
| 3 ordinal | ordinal:u64 | Ref88 matching ordinal |
| 4 peer authored position | conversation32, senderSequence:u64 | firstRef88,firstEventHash32,secondDistinctRef88,secondDistinctEventHash32 (240) |
| 5 qualified historical peer route | SHA256(exact closure)32 | firstQualifiedRef88,consentOrdinal:u64,predecessorEventHash32,senderSequence:u64 (136) |
| 6 incoming attachment selector | logicalId32,authorDevice32 | firstRef88,secondRowRef88 (176) |

Family4 indexes ALL direction2 DMC kinds, scoped to peer sender by the session;
the earliest second distinct exact event is sticky. Family6 indexes ALL matching
incoming kinds; a second row is sticky even for the identical event. Nonoffer
or duplicate classification still rejects when selected. Optional witnesses
are allzero; present second ordinal is strictly later than first.
Family5 allows initial Hello or an incoming event. Its source fact verifies
consent/predecessor/sequence and existing historical qualification rules.
An allzero predecessor is valid for the initial Hello and the original incoming
ContactAccept; only full semantic source replay determines which case applies.
Initial route heads have authored sequence2, as required by the existing
SessionInit1/ContactHello2 producer. A terminal changed-send latch stays in the
working suffix; it does not become an active archive basis.

Reducer960:
`version1 || zero3 || scope32 || basis188 || initialMetadataHash32 ||
consentRef88 || ownHeadRef88 || ownPreviousRef88 || peerHeadRef88 ||
peerPreviousRef88 || firstFaultRef88 || maxPeerEpochRef88 || maxPeerEpoch:u64 ||
ownHeadSequence:u64 || peerHeadSequence:u64 || helloPolicy:u32 ||
acceptPolicy:u32 || zero56`.
Hash: `H("Deep/STORE-V2/archive-reducer" || 00 || scope32 || exact960)`.
Only current ContactPolicy bits0–1 are allocated. Reducer facts are derived by
full authenticated source replay, never caller assertions or raw SQL flags.
Outgoing native DPE2 has no DMC plaintext: reduction MUST join current journal
or existing authored application archive and verify exact event hash/scope and
independent authored counters. Selected head/previous/consent/epoch originals
remain verified on use. First route fault is sticky; postfault promotions reject;
max epoch uses authenticated incoming DPE2 and retains a selected source ref.
Cold/final full audit reproduces every leaf and reducer, not merely hashes.

## Runtime integration requirements

The bounded prefix-plan delta, mandatory independent enrollment catalog marker,
exact progress record, SQL schema/adoption crash ordering and post-callback actual
provider-read strategy are allocated by the accepted addition below. None
may infer enrollment from an optional slot or reconstruct a lost adopted root
from SQL. Existing pending Store/ACK, private keys, accounts, instances, native
originals and lifetime collision/fork evidence remain unchanged.

Every route/consent/fault/epoch/attachment consumer must use the corresponding
authenticated selector/reducer plus full bounded suffix. Outgoing classification
must join independently authenticated authored application custody; DPE2 metadata
alone lacks the DMC payload. Selected tuples use actual table cells and existing
full payload verification. No ordinary scan proportional to lifetime history.

Required isolated qualification: independent reference construction for every
family; exact membership and divergence absence; wrong scope/key/prefix/edge,
missing/changed nodes, malformed lengths/reserved fields, collision and sticky
second-witness cases. Runtime qualification additionally covers selected raw-page
freshness after callbacks, all pending/enrollment/prefix crash phases, missing
root/catalog, source/index/reducer full-audit equality, unchanged retained accounts
and 100/1000/10000-row timing. None of these claims follows from compilation.

Future public lifecycle-evidence indexing must allocate a separate purpose,
scope and independently protected root. Messaging archive facts do not authorize
publication, historical-prefix adoption, secret retirement or remote trust.
## Accepted runtime and adoption addition — 2026-10-28

Accepted under Mr. X's delegated authority after the independent Astra review.
The allocation below resolves the catalog barrier, exact rowid fingerprints,
progress fencing, two-boundary adoption/cleanup, fresh physical SQL segments
and every replay-retention consumer. This is a private local-state clean break;
no public wire, signer, trust source or cryptographic dependency is added.
The2026-11-04 sequencing clarification below replaces the former requirement
that the retained round precede every form of activation. Source implementation
and isolated qualification may proceed while route catch-up is completed.

### Retained maintenance-only activation — 2026-11-04

The retained private completed-route gap prevents round60, while independently
checkpointed historical catch-up depends on this archive. Requiring round60
before even guarded enrollment would therefore create a circular prerequisite.
Under Mr. X's delegated authority, permit this explicit sequence:

1. Build the combined runtime and pass the focused consumer and exact
   enrollment/prefix/callback/crash boundary checks needed for this diagnostic
   activation. Independently audit all original source facts against the
   candidate index and reducer; these runtime audits are not deferred.
2. Enroll the same three retained profiles losslessly through the explicit
   guarded owner and re-audit their source, keys, counters, original operations
   and protected state. This grants maintenance-only activation, not ordinary
   delivery, sustained-availability, performance or release acceptance.
3. Complete independently qualified historical route catch-up, then run the
   retained round60 on those same profiles without resets or re-authoring old
   uncertain commands. Measure warm delivery/ACK separately from this cold work.
4. Under Mr. X's explicit instruction to measure the goal before the full Shared
   suite, perform the required full source gate after the goal is demonstrated
   and the changes stabilize. Focused checks and diagnostic CLI measurements do
   not replace that gate or grant source/release qualification. Preserve every
   required test identity and all original failed/interrupted receipts.

No failed source audit, missing adopted root, unresolved cutpoint or incomplete
consumer permits step2. The distinct catch-up contract still requires its own
accepted allocation and tests; this sequencing decision does not allocate new
wire records or turn a historical endpoint into current delivery authority.
## 1. Ownership and invariant boundary

Keep one account/process lease throughout each owned operation. Preserve every
account/device/instance, catalog key, native operation, TRS, authored counter,
event/payload, original Store/ACK evidence and existing rowid. No VACUUM, table
rebuild, source repair, SQL-derived protected-root repair or implicit enrollment.

One private messaging archive purpose/scope/root owns families1..6 only. Future
publication/lifecycle evidence must have a different purpose/scope/protected root;
reuse of the Patricia codec does not join those authorities. Selected facts are
data, never current permission. Selected originals and all<=64 suffix transitions
receive their existing native/authored/protocol verification on every use.

## 2. Mandatory catalog V2 and account-wide entry barrier

`ProtectedDid2MessagingSessionCatalog` retains header92/entry440/max512. Header
byte0 becomes2. Entry byte0 retains registration phase1/2; byte1 is archive
state0=enrollment-only or1=indexed; bytes2..3 remain zero. The revision is exactly
`1 + entryCount + sqlInitializedCount + indexedCount`. Scopes/order/keys retain
their exact original bytes. New account empty catalog is V2; new registration
atomically inserts floor188, history304, archive608 and peer bootstrap while
publishing an indexed entry, before its existing SQL initialization phase.

Ordinary `Decode/ReadAsync`, every ordinary lower opener and new registration
require V2, **all catalog entries indexed**, and no live account enrollment
progress. Each selected indexed entry requires its actual independent archive
root, immutable source history and exact SQL mirror. Missing indexed root is
corruption even when FinalReady progress remains: ordinary and explicit
enrollment both refuse reconstruction. Pure catalog parsing may represent state0
for the enrollment owner, but that result grants no ordinary admission.

The V1 reader exists only behind the explicit enrollment entry point. Before
V1->V2, drain pending/cleanup and old prefix plans for **all** sessions with the
existing full authenticated owner; close each eligible active suffix to<=63.
Drain the global plan/parts and all protected-floor pending/cleanup owners before
the catalog CAS. Then replace the entire catalog once by V2/all-state0 without
altering registration phases, keys, scopes or order. Ordinary opens/register and
fresh authored/native work stay blocked until every entry is indexed. One live
progress at a time; complete adoption/readback/cleanup before the next session.
Choose the lowest remaining scope hash deterministically; a missing progress
permits explicit selection of that state0 entry, never an ordinary fallback.

## 3. Protected enrollment progress, exact1120 bytes

Account slot: `deep.store.v2.messaging-archive-enrollment`. There is at most one
live record per account. All integers are unsigned big-endian; reserved bytes
zero; fixed widths, unsupported states, hostile cursors and trailing data reject.

| Offset | Bytes | Meaning |
|---:|---:|---|
|0|16|version1:u8, phase1..4:u8, zero:u16, total:u32=1120, revision:u64>0|
|16|32|scope hash, resolving an EXACT actual catalog entry|
|48|188|frozen stable actual source floor (may be empty, unactivated or latched)|
|236|304|frozen immutable source history|
|540|32|whole actual V2 catalog hash for this session's selection/adoption|
|572|32|actual key/compaction registration hash (these slots are the SAME anchor)|
|604|32|actual protected peer-bootstrap hash|
|636|32|canonical full original SQL source fingerprint, including events.rowid|
|668|32|canonical full relevant authored application SQL/source fingerprint|
|700|32|actual protected authored custody root hash|
|732|32|exact schema5 descriptor hash|
|764|32|exact schema6 descriptor hash|
|796|188|fixed enrollment target basis: EXACT frozen history.Basis|
|984|8|last processed archived-event ordinal;0 before the first event|
|992|8|processed archived-event count (directions1..4 only)|
|1000|32|staging Patricia hash|
|1032|32|staging reducer hash|
|1064|32|previous progress-record hash; zero ONLY at revision1|
|1096|24|zero|

The progress chain is crash consistency, **not** antirollback authority. Actual
protected CAS, floor/catalog/registration/bootstrap/source joins are mandatory.
Source floor/history/target basis and the eight source hashes remain immutable
within a selected session. Every successful phase or batch update increments
revision once and commits the previous exact progress hash. Cursor/count move
forward only after exact staged SQL readback; missing/changed staging rows reject.
The source fingerprint excludes ONLY the three new archive tables; it does not
exclude any original journal/event/initial/TRS cell. Source rows never mutate
during enrollment. Full source/authored audit repeats before each explicit resume
and before final adoption, comparing all original cells/rowids and source guards.

Phases:1 SourceFrozen (schema5 expected or exact recorded schema6-after case),
2 SchemaStaged,3 Building,4 FinalReady. No generic error or mirror mismatch changes
phase. Only the exact stored progress permits the narrowly defined lower opener.

### Staging reducer at cursor0 and intermediate batches

The fixed target basis is history.Basis, **not the current floor**. Rebuild only
the authenticated archived prefix through that target; the original bounded
suffix remains above it. Cursor0/count0 is staging, not an adopted608-byte root:
do not serialize a root whose positive source HistoryCount contradicts count0.

For target basis0, the staging reducer/trie are canonical scoped empties. Initial
import/activation, if present above basis0, stay in the suffix and are handled by
the ordinary full suffix reducer. A basis0 root grants no initial qualified leaf.

For active target>=2, bootstrap staging from the ACTUAL authenticated initial
singleton and its exact Hello: its metadata hash, Hello policy and appropriate
own/peer initial head ref/sequence2 enter the reducer; consent/Accept policy,
fault and incoming-epoch refs remain absent until an actual relevant archived
event has been replayed. The reducer's basis field is the fixed target basis for
every staging revision; progress cursor/count independently limit which event
facts may yet be present. This framing is valid but conveys no completed replay.
Initial peer-route family5, where the existing original native/source qualifier
allows it, uses Kind1/ordinal1/rowid1 and its actual qualification/consent ordinal
(zero only where the existing original-Hello rule requires none), never invented
mutual consent. No ordinary consumer may read staging roots/reducers.

Replay events in increasing ordinal,<=32 per batch, preserving sticky duplicate,
second-row, fault and epoch facts. Outgoing payloads join the actual authored
root/application archive and independent counter/event hash; DPE metadata alone
does not classify them. References in a partially built reducer/leaf must not
name events beyond cursor, except the independently verified initial singleton.
Before each batch effect, actual progress/catalog/floor/history/registration/
bootstrap must equal the frozen guards; source batch cells are physically freshly
read and fully verified. After the SQL insert transaction, reopen SQL and compare
all exact inserted nodes/reducer and the candidate progress before its CAS.

## 4. Schema6 and canonical source/schema fingerprints

Retain the exact five existing `Did2MessagingSqlJournal.Schema` DDL strings and
all source rows. Add ONLY these tables in one explicit enrollment transaction:

```sql
CREATE TABLE archive_nodes (hash BLOB PRIMARY KEY NOT NULL CHECK(typeof(hash)='blob' AND length(hash)=32), exact BLOB NOT NULL CHECK(typeof(exact)='blob' AND length(exact) BETWEEN 104 AND 320));
CREATE TABLE archive_reducers (hash BLOB PRIMARY KEY NOT NULL CHECK(typeof(hash)='blob' AND length(hash)=32), exact BLOB NOT NULL CHECK(typeof(exact)='blob' AND length(exact)=960));
CREATE TABLE archive_state (singleton INTEGER PRIMARY KEY CHECK(singleton=1), exact BLOB NOT NULL CHECK(typeof(exact)='blob' AND length(exact)=608));
```

Set application_id unchanged0x444d5332/user_version6 in that SAME transaction.
Schema5 is never an ordinary runtime reader. Until finalization archive_state has
no row; exact progress owns staging expectations. Node/reducer insert collision
requires identical exact bytes, otherwise reject. No ordinary archive GC; old
reducers and nodes remain available through SQL-before/protected-after handover.

Reuse existing `CompleteSqlProjection` cell framing: NULL=byte0;
integer=byte1||signed big-endian i64; blob=byte2||length:u64||exact bytes;
each row=byte1||cellCount:u64||cells; end-table=byte0||rowCount:u64.
Declared integer/blob/null type and all existing length constraints are checked
before hashing. Original tables are sorted by ordinal table name; rows use their
current canonical order (journal/events by ordinal, singleton tables by singleton).
Events add actual positive `rowid` as FIRST integer cell. No locator-index result
substitutes for that cell. Include original names and exact expected DDL using
name length:u16/name UTF8, DDL length:u32/DDL UTF8 without the single trailing
semicolon, matching current ValidateSchema's sole semicolon normalization.
Unknown user objects/indexes/triggers reject through exact schema validation.

Schema descriptor hash is SHA256(domain UTF8 `Deep/STORE-V2/archive-schema`,00,
application_id:u32,user_version:u32,tableCount:u16, sorted name/DDL frames).
Schema5 has exactly five original tables; schema6 those same five plus three
above. Source fingerprint is SHA256(`Deep/STORE-V2/archive-enrollment-source`,00,
scope32,schema5Hash32,schema6Hash32,application_id:u32, canonical FIVE original
table frames). Deliberately omit the mutable actual user_version from this source
fingerprint; validate actual5/6 separately against recorded phase and BOTH bound
schema descriptors. No physical file hash: staging changes encrypted SQL pages.
Authored-source fingerprint uses the existing application cell stream under its separate
`Deep/STORE-V2/archive-enrollment-authored` domain and binds actual registered
account/scope, exact protected authored root and full relevant authored originals.

Exact authored-root framing (clarified2026-11-04): domain UTF8 followed by00,
actual account32, scope32, then the three protected slot names in ordinal order:
`deep.store.v2.contact-accept-journal`, `deep.store.v2.direct-text-journal`,
`deep.store.v2.groups`. Each name is length:u16 plus UTF8; its actual value is
typed NULL=0 or blob=2||length:u64||exact protected bytes. Follow these frames
with the existing complete canonical application schema/table/row/cell stream.
Specifically reuse `AppendApplicationCompactionCells` with no omitted rows,
retained-path omission or synthetic audits: actual validated schema objects in
their canonical order as LP-u64 UTF8, user tables in ordinal name order, columns
in declared order, rows ordered by all columns, row marker1 followed by the
schema-determined cells, and table end0||rowCount:u64. Its cell tags are NULL0,
integer1||i64, blob2||LP-u64 bytes, text3||LP-u64 UTF8 bytes. The existing
`stopped_work_audit` canonical projector is retained. Unlike the native-five-table
stream above, this established APPLICATION stream has no per-row cellCount.
The strictly validated schema fixes that arity. Do not change unrelated existing
application compaction receipts or substitute a partial table projection here.
Progress field668 binds this complete authored-source fingerprint; field700 is
SHA256 of the actual protected DirectText root bytes. Account SQL registration
already atomically inserts the empty DirectText root before session creation;
its absence therefore rejects, including new or receiver-only sessions.
ContactAccept and Group are also atomically initialized in that same account
registration batch and are mandatory. All three therefore use the blob frame;
NULL remains part of the canonical cell grammar, not an allowed substitute for
these roots. SQL contents cannot establish protected-root absence or replace
its authority. This includes an account with no accepted contacts or groups.

Read these actual roots in one owned atomic batch, parse their existing scope
grammars and discard owned private copies before acquiring the application key.
Only hash state and digests may survive that provider edge. After application
source capture, re-read the exact same protected frames and require equality
before accepting the fingerprint. No private root bytes enter SQL or evidence.

## 5. Enrollment crash graph and final adoption

1. Drain all old owners and CAS catalog to V2/all0. No new work between sessions.
2. Full audit selected state0 session; insert SourceFrozen progress under exact
   catalog CAS+insert. No SQL schema side effect before durable progress.
3. Fresh keyed schema5 open -> one SQL transaction stages schema6. On crash,
   phase1+exact schema5 resumes staging; phase1+EXACT schema6 with unchanged original
   source fingerprint acknowledges the already committed stage. Anything else
   rejects. Advance progress to SchemaStaged after physically fresh readback.
4. Replay bounded batches and CAS progress after immutable insert readback.
   Crash with SQL inserts ahead of progress replays the SAME deterministic batch
   and accepts only exact immutable bytes; it does not advance from SQL guesses.
   Unreferenced staging nodes never authorize a fact. No source row is repaired.
5. At end independently full-rebuild all leaves/reducer, including initial,
   outgoing authored joins, duplicate/fault witnesses and complete original
   payload/cipher verification. Count must equal frozen history.HistoryCount;
   target basis/source checkpoint exact; all original source hashes unchanged.
   Write the exact candidate archive_state mirror and canonical reducer, reopen
   and full verify, then CAS progress to FinalReady with their hashes.
6. Final fresh full audit and actual protected guard joins. One existing
   CompareExchangeAndInsertAsync replaces exact catalog entry0->1 and inserts
   the first independent608-byte archive root. All other catalog bytes and keys
   stay unchanged. Root revision starts1. Independent atomic batch readback must
   match catalog/root/progress; SQL mirror matches candidate root exactly.
7. FinalReady progress remains a mandatory account-wide ordinary-work fence.
   A crash after step6 recognizes only the EXACT adopted catalog successor and
   already-present expected root, repeats fresh full SQL/source/root readback,
   then clears progress by guarded CompareAndDeleteAsync, comparing that exact
   progress slot and deleting the same slot atomically. A stale/missing guard
   returns false; the provider must not substitute an unrelated root as guard.
   Re-read actual catalog,
   root and progress absence and physically fresh SQL before returning/selecting
   the next state0 scope. Do not infer success from phase4 or an SQL mirror.
   To recognize that catalog successor without storing a second catalog, make a
   PURE comparison copy of the actual catalog: change ONLY the selected entry's
   indexed byte1 back to0 and subtract exactly1 from revision, then require its
   hash equal progress[540..572]. Never publish this comparison copy. Other entry,
   phase, scope, key or revision differences reject. The adopted608-byte root is
   reproduced from FinalReady's frozen source/target/count/trie/reducer and must
   already exist byte-identically; it is never reinserted in state1.

**Accepted storage primitive boundary:** existing secure
storage cannot atomically replace catalog, insert root AND delete progress in
one call. Steps6/7 are two explicit boundaries with a mandatory progress fence;
root+catalog adoption is atomic, cleanup is guarded/idempotent. The existing
guarded-delete primitive permits its guard once among deletion targets; it still
compares the exact predecessor before commit and preserves all unrelated slots.
Duplicate targets, invalid bounds and cancellation continue to reject. A repeated
primitive call after deletion returns false; the owner recognizes completion only
from the full adopted-state readback above, not from that return value. Native
recovery authenticates the successor and never requires the deleted guard to
remain present after commit. This introduces no new record, API or journal. This is the
accepted existing-primitive contract. If literal three-key physical atomicity
is required, allocate a separately reviewed storage primitive extension first;
do not emulate it with unguarded writes. After adoption, state1/missing root NEVER
rebuilds, even from FinalReady progress. Genuine postcommit failure is existing
committed/incomplete failure, not false success, fresh candidate or source repair.

## 6. Existing prefix-plan delta, no lifetime scan

Allocate RootKind18=MessagingArchive. Messaging prefix target3 keeps<=32 rows,
the same plan phases/part mechanism and journal-prefix disposition3. Exact sorted
root profile:5 SessionCatalog guard,6 MessagingFloor guard,8 AccountRegistration
guard,10 immutable MessagingHistoryCheckpoint guard,11 PeerBootstrap guard,
18 MessagingArchive changed608. Successor storage remains608 bytes/one part;
resolve the changed root by kind/selector, never old hardcoded index3. Root18's
source must equal actual history304. Only an active stable final prefix basis can
advance archive basis; import/activation/latch do not count as archived events.

Keep `ApplySql -> RecordSqlCommit -> AdoptRoot -> ClearPlan`. SQL-after/protected-
before is explicitly resumable from the EXACT stored plan before ordinary mirror
or cold-audit admission. Lower recovery open is restricted to that stored plan
and recorded old/new schema/root fingerprints, never triggered by generic error.

Delta receipt is SHA256(`Deep/STORE-V2/archive-delta`,00,side:u8=1before/2after,
scope32,schema6Hash32,beforeArchiveRootHash32,successorArchiveRoot608,
canonical unchanged singleton cell frames, journalCount:u8 and EVERY remaining
ordered journal row, selectedCount:u8 and selected original events,
selectedProofNodeSetHash32,successorReducerHash32,actual archive_state608).
The singleton frames include actual scope, ratchet/TRS and initial cells/types/
lengths. Journal row frames include ordinal/predecessor/head/metadata and their
actual types/lengths, <=64 transitions from moving basis to actual stable floor.
Selected<=32 events include exact Ref88, actual rowid, full canonical source
cells and actual envelope/plaintext lengths and SHA256 hashes; NULL plaintext
retains canonical NULL rather than zero-length blob. Rows remain ordinal ordered.
Side1 includes all old suffix rows; side2 omits EXACTLY the selected prefix.

ProofNodeSetHash uses `Deep/STORE-V2/archive-delta-nodes`,00,scope32,nodeCount:u32,
then sorted unique hash32||exactLength:u16||exactNode for the union of canonical
membership/absence proof paths for the <=6 typed facts of every selected journal
transition (including the initial family5/bootstrap transition, when eligible),
including empty-path/scoped-empty cases. Compare full typed selectors, not just
hashed keys. Compute virtual side2 in the same fresh source snapshot as side1.
Keep only final reachable changed-path nodes for SQL insertion; transient in-RAM
Patricia versions are not written. Thus every inserted node is covered by a final
selected proof path. Maximum bound remains6*32*257=49,344 node visits/writes;
deduplicate exact nodes and reject same-hash/different-bytes. Do not pack nodes
into the protected2MB successor parts: reconstruct deterministic effects from
actual verified paths/events; the protected plan stores the608-byte root and
before/after receipts. Old nodes/reducers remain, enabling before-state replay.
After adoption, verify side2 directly from successor root/selected actual rows,
proof paths and reducer; no unavailable old608-byte root or lifetime scan needed.
Import/activation/latch headers are always in the journal transcript even when
they have no events-table Ref88. The initial singleton is already fully bound by
the unchanged singleton frames; its Kind1 reference and eligible bootstrap leaf
are derived explicitly, never added as an invented events row or archive count.

Apply only immutable node/reducer inserts, one archive_state mirror replacement
and exact selected journal-row deletes. Preserve all events/initial/TRS, original
payloads, Store/ACK evidence and keys. Missing/extra selected rows, mixed mirror,
changed singleton/suffix/proof, wrong plan receipts or root guards reject.

Every current RootKind10 consumer is audited: where it relies on indexed replay,
route, consent, fault, epoch, attachment or collision facts, add actual18 guard.
This includes OutboxCompaction/Recovery, TerminalAudit, stopped-control/audit,
retained-path/Store/ACK and initial-retirement/cancellation profiles. Existing
guard-only kind18 is allowed in those CLOSED profiles with exact scope/selector;
it is not a wildcard replacement for their other dependencies or retirement proof.

## 7. Fresh SQL segments and private replay-retention digest2

`OpenConnectionCore` already uses Private cache/Pooling=false; that alone is
insufficient. Refactor OwnedDid2MessagingStorage and readonly Custody.sql lifetime
so no SQL connection/snapshot/private-key/source loan survives ANY provider,
authority, wait or diagnostic callback. Rejoin actual protected catalog/key/
registration/floor/history/archive/progress-or-plan, borrow key just for physical
open, then dispose key loan. Run bounded proof/mutation synchronously on that new
keyed nonpooled connection and close it before the next external edge. Do not put
storage.Read callbacks inside an open SQL transaction. A postcommit callback must
be followed by another actual physical readback before root adoption/result.
Current floor/pending cleanup reconciliation remains the sole mutation owner.

Before ordinary opening, resume ONLY an actual stored progress/plan through its
restricted lower opener; drain pending/cleanup floor owner with the exact indexed
before/after states. Ordinary full audit/mirror checks then run. Cache only pure
grammar/resources allowed by existing decisions, never prior admission/permission.
Native provider tests must show a DIFFERENT live SQLite connection/handle after
an edge and rejection after actual externally written selected page/cell change,
including raw ciphertext/HMAC corruption. `NOT INDEXED`, data_version, a reopened
reader on the same connection or a cached success bit is not freshness evidence.

Private replay digest version2 uses the EXISTING
`Deep/STORE-V2/messaging-replay-retention`,00 domain, then version:u64=2,scope32,
actual archive608,moving basis188,actual stable floor188,suffixCount:u64<=64,
then EVERY ordered suffix transition as ordinal:u64||metadata672. Include import,
activation and terminal-latch headers, not only event kinds2/5. Read/verify actual
predecessor/head columns before committing these derived metadata bytes. Feed this
digest to existing closed DPE2 and DBR2 transition contexts; no wire version or
caller-provided retention hash. Version1 exists only in explicit old enrollment
drain/recovery, never an indexed ordinary fallback.

Fresh DPE2 AND DBR2 work maintains at63, reserving slot64 only for the existing
terminal changed-send latch. Exact retries/pending recovery never reauthor or
use capacity maintenance as permission. Latched sessions retain latch in suffix;
archive basis never advances to terminal status. Empty/unactivated sessions use
empty archive basis and retain initial/activation headers until an active stable
basis is available. Fresh initialized SQL6 creates exact empty mirror/reducer;
new protected registration already inserted its mandatory empty root.

## 8. Concrete edit/qualification map after acceptance

Production: catalog codec/registration; SqliteDeepIdV2AccountGeneration.Messaging
openers and OwnedDid2MessagingStorage; Did2MessagingDurableCustody; SQL schema,
ActiveRead/read-batch/history/selected lookups/native contexts; NativeMaintenance;
CompactionPlan and ProtectedCompactionPlan closed profiles; account Compaction,
OutboxCompaction/Recovery/TerminalAudit/retirement mappings. Add dedicated private
enrollment/progress owner and SQL delta/archive backend beside existing files,
using the codec agent's isolated records without changing their crypto purpose.
All six consumer families/reducer semantics remain the separately assigned
insertion/reducer owner's mandatory implementation map.

Before activation: independent full reference tree/reducer vs incremental;
two-session partially indexed catalog; new registration during conversion;
all schema/progress/prefix/CAS/readback cutpoints; state1/missing-root refusal;
outgoing authored joins/counters; every direction and sticky witnesses; actual
rowid/types/lengths/selected page corruption; unused archive corruption detected
on access/full audit at the accepted timing; source change during retirement;
SQL-after/protected-before; DPE2/DBR2/latch capacity; no lifetime ordinary scans;
query-plan and100/1000/10000 work/latency. Then exact same retained3 lossless
enrollment with original accounts/counters/roots/history preserved, full audit,
and measured warm delivery/ACK separately from enrollment/cold maintenance.

No completed codec/focused test alone authorizes runtime adoption. The exact
two-boundary cleanup above is accepted; activation still requires complete
consumer/enrollment tests and retained three-client qualification. Existing
ordinary validation remains active until that cutover. Runtime implementation
is allocated here; this decision does not claim its completion.
