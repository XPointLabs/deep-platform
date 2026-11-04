# DR-0179 — established native session provenance

Date:2026-11-04. Owner: Mr. X (delegated architecture authority).
Status: accepted after independent Astra Ultra source review; implementation,
source qualification and retained CLI measurements remain open.

## Observed problem

P1 build17 compiled with zero warnings/errors. The stopped route02 diagnostic
retains43 passed,2 failed and18 without completed results of63; it is not accepted.
One genuine count8 receive exceeded its existing three-minute operation deadline.
A30-second sampled-thread trace attributes approximately97% of the active send
stack to repeated receiver source open/validation, chiefly SQLite preparation.
Idle threads are excluded from that comparison. This is not a CPU benchmark or
a delivery-latency claim. No timeout is extended.

Each ordinary native SQL segment reopens original Device/PreKey sources; route
reads multiply those segments and repeat receiver SQLCipher password derivation.
Neither another crypto stack nor an encrypted RAM key cache is the correction.

## Authority and detection timing

The existing durable transition transfers authority: verified original Initial
-> exact native import -> protected stable source retirement -> native activation
-> authenticated current native floor/archive ancestry. Original sources cannot
seed or repair an activated native ratchet.

This amends source-corruption detection timing in
[DR-0027](DR-0027-did2-messaging-session-ownership.md) and clarifies the fresh
segment requirements in [DR-0177](DR-0177-authenticated-native-archive-index.md).
Corruption or resurrected keys in an original source reject when that source is
opened, audited or used. Established native work need not rediscover unrelated
source corruption every operation. This permits no source repair, reimport,
secret resurrection, retained-original deletion or loss of replay protection.

## Closed opener purposes

Use private purpose-specific paths, never a caller skip-verification Boolean:

- Established native operation: current floor, route, send, receive and ACK.
- Initial transfer/recovery: import, awaiting retirement, kind1/kind3 pending.
- Source/full audit: explicit cold integrity audit and retained enrollment.

Constructing a managed owner or physically reopening native SQL does not itself
turn an established operation into an original-source audit. Cold/full audit is
an explicit owner operation retaining complete source checks. No cached success
bit substitutes for fresh admission.

Established admission freshly joins the actual protected retirement entry:
correct sender/receiver role; stable phase2; exact scope hash and Initial basis;
sender source store ID or receiver account instance; original TRS hash from
actual native import metadata. Receiver intent must equal native claim operation;
sender intent is logical intent and must not be equated with claim operation.

Verify actual native initial_events/import metadata, protected initial-header
commitment, active floor/archive basis and complete bounded suffix. Preserve
fresh key/registration/catalog/history/archive/progress joins, selected-original
verification, paired application state, preclaim tombstones at their owning
boundary, and the callback-free final application-to-native SQL sequence.
No key or SQL handle survives provider calls.

### Automatic native audit remains

Account-owner admission still fully audits established native histories, including
terminal latches and established pending kinds2/4/5/6. Keep exact floor/tip and full
archive-semantic verification, catalog/instance readback and the existing scheduling
marker; that marker never replaces fresh per-segment provenance. A new managed
owner repeats this native audit, not original-source auditing.

Every initialized catalog entry must have authenticated floor/history/archive
joins and an existing registered SQL file/path. Defer only positively canonical
Initial-owned shapes, with DR-0177's canonical empty archive basis/count:

| Actual protected floor | Deferred owner |
| --- | --- |
| Canonical empty ordinal0/status0 | Initial initialization |
| Ordinal1/status0, stable or import pending/cleanup | Initial transfer |
| Ordinal2/status1, pending/cleanup | Initial activation |
| Ordinal2/status2, stable or pending/cleanup | Initial cancellation |

Pending metadata must have its exact kind/predecessor (import1, activation3,
Initial cancellation4). Inconsistent combinations or missing/malformed required
state reject. A failed established provenance check never classifies a scope as
inactive. Deferral grants no repair, recovery or Initial-use permission; its
explicit owner/full audit detects corruption inside inactive SQL. Automatic audit
does not recover unrelated Initial work or reopen its original sources.
Test mixed established/unfinished/cancelled catalogs, unselected established archive
corruption, missing protected/native state and pending activation versus established
recovery. The account-wide V2/all-indexed/no-enrollment barrier remains mandatory.

Status0 or pending Initial activation cannot enter the established path.
Established pending kinds2/4/5/6 retain exact recovery. Missing native state
rejects; it never reconstructs itself from original Initial.

Full original-source verification remains mandatory for first import/activation,
unfinished source transfer/retirement recovery, actual DPH2/preclaim/PreKey use,
source-key deletion/cancellation, cold/full audit and retained enrollment.
Dynamic successor/commit/cancelled-scope inventories are not prerequisites for
established operations that do not use those sources.

## Implementation and qualification

Separate Generation opener purposes and remove full source-capture delegates
from established segments. Reuse existing durable evidence: no new wire, durable
receipt, permission flag, fallback or cryptographic dependency. Postreceive
scheduling may omit work proved redundant by actual adopted C/P/fault state;
ordinary maintenance still drains retained gap candidates.

Required evidence: zero original Device/PreKey SQL opens for established
send/receive/route/ACK including after callbacks; altered or missing retirement,
native initial metadata, catalog/floor/archive/selected events still reject;
initial cutpoints still verify full sources; corruption/resurrection rejects on
source use and explicit audit; pending native recovery cannot reconstruct Initial;
source history length does not increase established source-admission work.

The explicit source audit/recovery inventory may still exceed32 returned slots.
Its capacity correction remains separate: no head-only or sequential public-batch
substitute. Any guarded-read extension needs an exact bounded contract and actual
object verification. It is unnecessary for ordinary messaging admission.

Retain the same three CLI profiles and original work. Combined qualification
precedes maintenance-only enrollment, catch-up, retained round60 and persistent
warm delivery/ACK measurements. The trace does not prove p95<=1s or release readiness.
