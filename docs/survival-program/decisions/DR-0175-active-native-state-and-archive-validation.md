# DR-0175 — active native state and archived payload validation

Date: 2026-10-26. Owner: Mr. X. Status: accepted correctness contract;
focused source evidence exists, full qualification and connected latency remain
unqualified. The active-map candidate is **rejected as a demonstrated performance
improvement**: isolated measurements are slower than the prior full verifier.
See [NEXT-SPRINT](../../NEXT-SPRINT.md) for the bounded-state/index redesign and
the separately declared unused-archive detection-timing change it would require.
This decision does not authorize production rollout as a latency fix.

## Decision and scope

Use the existing native SQL schema, protected history checkpoint and cryptography.
Separate ordinary active-state verification from decoding all unrelated archived
message payloads. This is a pre-production behavior change, not a new wire/state
generation, compatibility reader, migration or positive authority cache.
It applies only after all consumers and the tests below are implemented together.

The independent checkpoint already commits the complete ordered archived metadata
map through the existing HistoryDigest/HistoryCount, including scope, exact basis,
initial metadata, ordinal and the canonical 672-byte metadata for every entry.
The existing digest domain, field layout, producer and count are unchanged.
The producer and full archive audit continue validating every payload.

## Ordinary verification

1. Fresh actual protected key/registration/floor/history, account/device, boot,
   time, authority, revocation and file-family checks remain mandatory. No
   successful provider read, source check or private loan is cached.
2. Authenticate the COMPLETE actual archived metadata map against its independent
   digest/count in one closed SQL snapshot. Verify canonical types/lengths,
   ordinal order/bounds, operation/kind/direction column bindings, metadata
   transition rules and payload type/length bindings. Missing/inserted/changed
   unrelated metadata still rejects before any effect or successful result.
3. Verify the entire current TRS, working suffix, pending/cleanup transitions and
   initial/source-history requirements as before. Archive placement does not
   make replay IDs, route faults, pending Store or ACK obligations disposable.
4. Retain full physical native-page authentication at every boundary whose old
   full prefix verification fetched all payload pages. Native currently lacks
   a full cipher-integrity scan at some of those boundaries: the new path MUST
   add the actual provider's complete `cipher_integrity_check` and prove it
   detects corruption in unselected overflow pages, including reused-connection
   and callback cases. Application integrity checks do not establish this.
   If that proof fails, retain full native payload reads; do not activate the
   cheaper path. Whole-file I/O is not claimed to have become constant cost.

## Selection and absence proof

All selected content is authenticated against metadata captured from the SAME
complete map whose independent digest succeeded. Capture requested selector
tuples or validate selected content while hashing its exact buffered tuple;
release no result before the complete digest/count is established. A later row
read must exactly match that captured operation/ordinal/direction/metadata.
Self-consistency of a newly fetched row is insufficient, even in a SQL transaction.
Before/after pathname hashes, file identity or a cached SQLite page are not an
ABA-resistant source-authentication argument.

Fresh/absent classification derives from the authenticated map, never just a
negative SQL lookup. An expected row missing from a lookup/list rejects, not
null/fresh/empty success. Each selected envelope, plaintext/event, header and
commitment is checked by the existing full historical-event rules before replay,
materialization, route authority, ACK, Store recovery, history display or other use.
Preserve exact retry bytes and all lifetime operation-ID collision semantics.

Authenticate the complete map before applying route filters. Retain route fault,
consent/head/predecessor ordering and the expected selected set/count. Incoming
route markers can select only the classes actually committed by that metadata.
Initial Hello/Init remain full; ContactAccept uses its verified exact selector.
Metadata does not classify arbitrary outbound DMC content: outgoing route-head
enumeration and Braid peer-epoch consumers retain full reads in this slice.

No live iterator/private loan crosses external callbacks. Capture the required
closed inputs, close SQL, verify external authority, then perform fresh required
record/root readback before effects. Independent source-history checks remain.
Pending original operations are not reauthored after lookup or proof failure.

## Cold, audit and lifecycle

The runtime must first use the existing authenticated prefix compaction owner:
current source has only test callers, so an archived prefix in the retained CLI
cohort cannot be assumed. Wire bounded, amortized maintenance into the actual
per-session account lifecycle. Prepare/stage/resume the same protected plan;
respect all pinned original operations and preserve counts/ordinals. Do not
compact on every message, remove obligations to meet a threshold, or hide a
maintenance pause from warm latency samples. Record working/archive counts.

Before the first native messaging admission can use the active verifier, the
real account-runtime owner performs full native catalog/session archive validation.
This boundary belongs to its private native opener under the existing account
lease, not to unrelated account metadata reads. Those reads retain their current
checks and do not enable active verification. Lower source/bootstrap/compaction
openers and unmapped consumers retain full verification by default; no caller
can supply an unchecked skip-audit flag. Existing persistent CLI profiles retain that owner;
network-context invalidation does not create a new account. A genuinely new
owner, account-instance change or restart starts unaudited. Failure/cancellation
never records successful audit. Completion is scheduling state only: subsequent
ordinary checks still perform all actual proofs above. A helper opening a SQL
connection is not itself a new account runtime or permission to skip checks.
No private buffer, key, transaction or authority is retained by the audit marker.
Standalone per-command CLI invocations that enter native messaging remain cold;
measure them separately.

Explicit full audit, checkpoint production and recovery of an interrupted
checkpoint/compaction continue authenticating all required original payloads.
Use the existing exact intent/SQL/root adoption protocol; no root is reconstructed
from incomplete state and no reset changes ordinals, ratchet state or custody.
Finish the existing exact pending-plan recovery before cold full-audit admission;
a legitimate interrupted before/after prefix is not silently discarded or
classified as unrecoverable merely because the audit ran out of order.

## Explicit guarantee change

An unrelated archived payload that is validly reencrypted with the database key,
retains canonical shape/length, but differs from its independently committed
metadata no longer has to stop every ordinary send. It MUST fail on selected
access and on full audit. That is a deliberate change to detection timing, not
a claim of equivalent whole-archive semantic checking on every operation.

No changed payload may be displayed, replayed or used as authority. Metadata,
active state, current roots and selected content remain immediately checked;
raw encrypted-page corruption remains covered by the proven native-page scan.
No confidentiality, authenticated-message, antirollback, replay, currentness,
two-replica durability or exact unknown-outcome recovery rule is removed.

## Required evidence before activation

Cover the complete consumer map, not only the happy-path selector. Tests must
include hidden/deleted/changed metadata and route faults, false negative indexes,
captured-tuple substitution/ABA, selected and unselected same-shape semantic
corruption, raw overflow-page corruption, fresh/exact/changed operation reuse,
initial/source/Braid/route exclusions, callback floor/key/provider/time/revoke
changes, cold restart and every existing interrupted-compaction handover.
Keep original failed receipts and original operations. Full ordinary-versus-audit
outcome differences are explicit tests, not weakened existing assertions.

Measure full metadata scans, payload reads/decodes, cipher scans, opens and CPU
on 100/1,000/10,000-row isolated fixtures. O(N) compact metadata and full-page I/O
remain; p95 one second and history-independent cost are not established.
The first integrated CLI engineering run follows source/security acceptance;
do not launch another latency round merely because this decision exists.

Normative owners: TRANSPORT-NEUTRAL for execution/selection and
RETENTION-AND-RECOVERY for archive integrity timing. The current authenticated
archive/index and adoption contract is
[DR-0177](DR-0177-authenticated-native-archive-index.md); established-source
admission is amended by [DR-0179](DR-0179-established-native-session-provenance.md).
