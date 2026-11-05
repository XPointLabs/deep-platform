# DR-0176 — bounded protected storage inventory

Date:2026-10-26. Owner: Mr. X (delegated architecture authority).
Status: accepted implementation contract; conversion, activation, performance
and release remain unqualified. This implements P1.1 of S05 in
[NEXT-SPRINT](../../NEXT-SPRINT.md), not a parallel execution sequence.

The first implementation is **rejected as a performance improvement**. Matched
actual-provider measurements were slower for every single/batch read and atomic
write cycle at16/256/1024 slots; the atomic cycle expanded native Unprotect calls
from2 to43. Correctness evidence does not authorize retained conversion or
activation of that candidate. Keep its measurements and fix the measured work
amplification before proceeding; see the
[CLI comparison](../../../deep-cli/docs/testing/cli-storage-manifest-adapter.md).
Source review also found incomplete named retirement: later provider callbacks
can restore an already retired object before the operation finishes, while the
cleanup-free root loses that obligation. This remains unqualified independently
of performance; the closed-operation implementation must close every such edge,
including final post-adoption callbacks.

## Decision and boundary

Replace the full value aggregate inside `JournaledDeepSecureStorage` with one
protected complete manifest and separately authenticated immutable value objects.
Keep `IDeepSecureStorage`, existing process ownership/CAS semantics, platform
protector and existing .NET AES-GCM. No new library, database, messaging wire,
E2EE suite, account identity or business counter. The implementation belongs to
GPT-6.1 Sol / High; the coordinating owner reviews evidence.

Retained CLI inventories occupy about2–3MB; retained59 measured1,993–2,450 loads
per sender operation. Those are counts, not measured byte traffic. The new path
reduces full-value read/decrypt/copy work, not all native/history/network work.

Every admission actually reads and Unprotects the manifest. Its complete
canonical map proves selected membership/absence. Read/hash/AEAD-verify selected
object bytes against that inventory; missing/invalid selected data rejects,
never becomes null/fresh. One atomic batch has one manifest/Unprotect; local
object decryption invokes no external protector callback. No plaintext, key or
permission cache crosses callbacks. Clear private buffers before diagnostics.

Explicit timing change: unused object-content corruption is detected on access
or full audit, not every unrelated read. Cold owner opening and explicit audit
check all referenced objects. A cold-audit marker schedules work only; every
later admission still authenticates actual manifest and selected bytes. Current
permissions, semantic recovery, native SQL floors, account/instance/key joins
and replay checks remain independent and real. Manifest revision/store ID are
not antirollback authority; coordinated rollback limitations remain unchanged.

## Lifecycle

The existing constructor is **OpenExisting**: missing committed state rejects.
Add explicit asynchronous CreateNew and EnrollAggregate entry points. CreateNew
requires exclusive ownership and absence of current/pending/backup/object state;
it durably creates the empty manifest before returning an ordinary owner. A
fresh publication uses an atomic no-replace operation and rechecks absence
after provider callbacks; it cannot overwrite a root that appeared meanwhile. A
missing path/random ID/loose object never authorizes repair of an enrolled store.
Normal reads cannot decode DSS1 or call enrollment. The backend exists before
account creation, so do not invent account/network scope fields; higher records
retain their existing identity binding.

CLI selects lifecycle under its current private directory/profile command lock.
Keep Windows/Android composition and devices outside this slice. The constructor
signature may remain source compatible; persisted DSS1 is not an ordinary
fallback. Existing CLI profiles stay untouched until conversion gates pass.

## Closed private framing

Integers are unsigned big-endian; reserved fields zero. Unknown values, duplicate
IDs/names, noncanonical UTF-8/order, overflow and trailing bytes reject before
mutation. These are private storage names, not messaging protocol generations.

Manifest plaintext header,96 bytes:

| Field | Bytes |
| --- | ---: |
| `DSS2`, version2, flags0 | 4+2+2 |
| Nonzero random store ID | 32 |
| Revision, starting1 with checked increment | 8 |
| Exact predecessor protected-file SHA-256; zero for fresh creation | 32 |
| Active count, cleanup count | 4+4 |
| Logical original-inventory byte count | 8 |

Entry: `slotLength:u16 || slotUtf8 || objectId32 || birthRevision:u64 ||
plaintextLength:u32 || fileLength:u32 || SHA256(exactObjectFile):32 || key32`.
Use existing ordinal name ordering/validation. Each changed object gets a fresh
random nonzero ID and independent AES-256 key; IDs are never reused. Positive
birth revision cannot exceed current revision. Cleanup contains sorted unique
retired IDs only, disjoint from active IDs, with NO retired keys.

Preserve1,024 slots,512-byte names,1MiB ordinary/4MiB group values, batch reads1–32,
and `8 + sum(6 + slotUtf8.Length + value.Length) ≤8MiB`. Header accounting must
exactly match descriptors. Cleanup count≤1,024. Maximum canonical manifest is
673,888 bytes; cap plaintext at704KiB and protected input/output at2MiB. A smaller
manifest cannot increase logical value capacity.

Object header,96 bytes: `DVO2 || version:u16(2) || flags:u16(0) || storeId32 ||
objectId32 || birthRevision:u64 || plaintextLength:u32 || nonce12`, followed by
exact ciphertext and tag16. File length=plaintextLength+112. AES-GCM uses fresh
random nonce12, entry key and tag16. AAD is UTF-8 `Deep/LocalStorage/DSS2/object`,
one zero byte, exact96-byte header, then `slotLength:u16 || slotUtf8`. Hash the
entire file; check bounds/exact EOF before allocating payloads. Names are closed
hex encodings of object IDs in the owned directory, never supplied paths/slots.
Reject reparse/link redirection and escapes; never relax private ACLs for I/O.

## Atomic mutation and recovery

1. Hold existing gate/process lease. Authenticate current manifest and selected
   guard values. Preserve exact CAS, complete-map insertion absence, capacity
   and no-op deletion semantics. Failed guards have no effects.
2. Prepare only changed objects and a successor manifest binding their bytes,
   predecessor file hash and retired IDs. Flush the protected pending manifest
   BEFORE object effects so interrupted staging has a bounded authenticated
   new-ID list. Never retain an old-key backup.
3. Stage/flush objects and durably establish their same-volume names. Verify all
   newly referenced bytes before publish. Protect is an external callback:
   afterwards freshly read/Unprotect and rejoin actual predecessor and guards.
   Sharing-retry waits/callbacks require fresh admission again. File-byte
   equality alone does not prove unchanged key policy.
4. One durable atomic pending→current replacement commits every slot together.
   No destination-delete/copy fallback, cross-volume move or ACL changes. A
   subsequent failure is committed/incomplete with retained obligations, never
   false CAS/noncommit.
5. Finish retired-object cleanup, then adopt a cleanup-free manifest through the
   same guarded mechanism. This second metadata-only commit may increment the
   private revision; logical values and business counters are unchanged. It
   prevents repeated cleanup I/O on ordinary reads. Interrupted cleanup remains
   in the authoritative manifest; retirement/delete cannot report success early.

Retire each authorized non-active object by durably replacing its named file
with an empty tombstone using existing flush/atomic-replacement guarantees, then
unlink the empty file. An outstanding cleanup ID is processed even if absent or
empty: observation alone is not durable completion. A crash can restore an empty
tombstone, not the old named value. This is named-file retirement, not forensic
media/backups/attacker-copy erasure. Windows uses same-volume write-through
replacement; Unix requires directory durability and does not silently accept
unsupported fsync. See [MoveFileEx](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-movefileexw)
and [DeleteFile](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-deletefilew).

Recovery authenticates CURRENT first and never promotes pending/backup or derives
state from SQL/objects. Interrupted precommit pending may authorize cleanup only
of its bounded newly staged IDs under exact store/predecessor joins, excluding
EVERY current active/cleanup reference. Ambiguity rejects. No ordinary directory
GC. After adoption resume only current cleanup and existing semantic owners.

## Closed operation admissions — 2026-10-27

Accepted for the next implementation; the measured candidates do not implement
this section. Keep the format, limits, durability and current dependency checks.
Replace manufactured per-object provider callbacks with private, bounded operation
segments under the existing gate/process lease. This is no process-lifetime cache,
TTL, unchecked skip flag or caller-supplied permission. The protector API has no
atomic global policy transaction; permission must be freshly admitted at actual
provider/callback/wait edges, not inferred from unchanged file bytes across them.

**Selected reads.** After one actual manifest Unprotect, a dedicated private read
owner may decode the complete inventory, verify selected objects and perform a
required cold audit without another external callback or effect. One final actual
source-byte/path rejoin and cancellation check must precede EVERY result, including
null/all-absent. No intermediate inventory/result escapes before that fence; failed
admission clears all private buffers and must not consume the cold-audit marker.
This does not remove the immediate source joins used by other recovery/mutation
paths through a generic boolean or delegate.

### Atomic guarded reads — 2026-11-04

Accepted after Astra Ultra source review. Source retirement/cancellation can have
more than32 dependency owners while needing only a small set of secret values.
Keep the public `ReadOwnedBatchAsync` limit. Add a Shared-internal capability,
implemented by both existing engines, that returns `OwnedDeepSecretBatch`:
`ReadOwnedGuardedBatchAsync(returnedSlots, guards, cancellationToken)`.

- Return0–32 distinct ordered canonical slot names, preserving missing values as
  null. Zero returned slots permits a guard-only proof.
- Require1–1,024 distinct canonical guards. Null requires authenticated absence;
  otherwise the expected value is exactly32 bytes, SHA256 of the COMPLETE exact
  plaintext slot value, never the object-file or manifest-descriptor hash.
- Reject duplicates within either list, including equal duplicates. Cross-list
  overlap is allowed and reads the object once. The bounds are independent:
  at most1,056 selector names, with the existing1,024 present-object limit intact.
- Capture caller counts once and copy validated selectors/hash bytes before the
  first await/provider call. Malformed/empty hashes reject; zero bytes do not mean
  absence. Guard mismatch throws `CryptographicException`; no partial batch escapes.

The internal helper fails closed for unsupported providers. No sequential public
batch fallback or concrete-provider unwrapping may bypass a decorator. Journaled
storage uses its existing gate/process lease and admitted inventory. Every actual
guarded/returned object still passes bounded file/path/identity/EOF, descriptor,
ciphertext-hash and AEAD checks. Guard-only plaintext is hashed and immediately
zeroed; it is not retained as an aggregate. Overlapping returned values receive
the same guard check. In-memory storage performs equivalent checks and ownership
copying under its existing gate.

Preserve recovery and cold-audit obligations. Final actual protected-source byte
and path rejoin plus cancellation precede EVERY success, including guard-only and
all-absent results. Failed admission preserves the audit-required marker. This
adds no logical mutation, cached authority or caller callback. Existing read
recovery behavior is unchanged.

Required consumers: retirement snapshot final owner proof; pending source recovery
returning registration/checkpoint; explicit source-audited messaging segments; and
cancellation under [DR-0179](DR-0179-established-native-session-provenance.md).
All other cancelled scopes' actual floor/history dependencies remain guards.
Do not replace them with the retirement head hash. Empty retirement retains its
existing optional missing draft/catalog owner semantics.

Qualification includes valid11-other-cancelled-scope capacity, mutation of any
other scope's guarded roots, malformed/duplicate/oversized inputs before provider
access, caller mutation during await, overlap, zero-return/all-absent final
fencing, failed-audit-marker preservation, and actual missing/corrupt guarded
objects under an unchanged manifest. Capability forwarding in test decorators
must retain actual provider-edge observations.

**Staging/publication.** Prepare exact new objects and candidate bytes from actual
current state. Protect and candidate verification are external edges; dispose
admitted loans and freshly Unprotect/rejoin the actual predecessor, guard and file
family afterwards. A closed synchronous segment may stage multiple immutable,
unreferenced objects without per-object Unprotect. Before EACH filesystem effect,
retain actual source/guard/pending-byte joins, exact file identity/hash/length/EOF,
newness/nonactive checks and durable ordering. Staging grants no live authority;
only the guarded atomic manifest adoption commits. Any sharing wait or real hook
ends the segment; re-admit actual policy/source before another effect. Source/guard
mismatch or policy refusal fails; it never retries against a different predecessor.

Directory ownership may be consolidated only inside that same segment using
verified, pinned directory handles. Each actual leaf access still checks its
regular-file/single-link/reparse identity, current handle-bound parent/path and
exact bytes. No cached path string establishes ownership or defeats ABA. Drop
the context and freshly join logical/physical directory identities after every
provider/callback/wait edge; do not retain handles as cross-operation permission.

**Retirement and final boundary.** Prepare/protect/authenticate the cleanup-free
candidate BEFORE retiring names, then freshly admit the ACTUAL cleanup-bearing
current root. Within one closed segment, durably tombstone/unlink ALL authorized
nonactive IDs and adopt the exact prepared cleanup-free root. Every effect still
checks actual source/guard/pending bytes, nonactive membership, owned paths and exact
empty tombstone bytes. Any intervening callback/wait invalidates completion for
the ENTIRE set: repeat durable retirement of every authorized ID, including
already absent/empty ones. A cursor or an earlier unlink is not completion proof.

No external provider/hook/await edge may follow the final retirement/adoption
before the OUTERMOST storage-operation return. Final readback is callback-free:
actual committed protected bytes/path must match the candidate authenticated
before the segment; selected objects and returned values remain fully verified.
An outer `Admit` loop must not silently add another Unprotect after this boundary.
Any internal handoff remains in this same closed owner, never cached permission
for a later operation. The next independent operation still actually Unprotects.
Failures after primary adoption remain committed/incomplete with durable cleanup
obligations; never report CAS=false or successful retirement early.

Use one caller cancellation token and one shared two-second retry/invalidation
budget, starting at the first retry/invalidating edge and never resetting per file
or full-set replay. Keep existing sharing backoff. Bound immediate test-hook
invalidations separately (maximum eight); do not shorten ordinary sharing attempts
to that count. Normal ordered Protect/Unprotect phases are not restarts. This does
not promise that a blocked filesystem syscall finishes within two seconds.
Budget exhaustion reports `IOException("Protected storage operation retry budget
exhausted.")`, including persistent native sharing contention. This replaces the
old per-file terminal `Win32Exception`; other native errors retain their existing
handling. Failure still preserves committed/incomplete obligations and never
becomes CAS=false or cleanup success.

Test hooks select an explicit point before invoking code and consume one-shot
callbacks before invocation. Even no-op callbacks invalidate admission. Final
post-adoption crash injection must be a fixed internal exception, not an arbitrary
delegate; distinguish primary publication from final cleanup publication. Retain
the existing crash/reopen assertions, creation-after-precheck witness and actual
zero-tombstone observations. Add real saved-object restoration at later-ID,
cleanup-candidate and retry boundaries; verify full-set replay, budget exhaustion,
all read return paths and failed-audit-marker preservation. Test no-retry admission
counts at different batch sizes, then remeasure all operations with unchanged
helpers. Neither a lower count nor focused PASS proves latency/release acceptance.

### Recovery followed by mutation — 2026-10-28

An outer call may recover an abandoned pending descriptor or existing cleanup
and then perform its requested mutation. It must not first discard retirement
obligations and subsequently invoke another protector callback. Returning a new
"recovery completed; retry the mutation" error is not the chosen contract.

For an ordinary cleanup-bearing predecessor, carry its old cleanup IDs into the
new successor together with newly retired IDs when their union fits1,024. The
final closed segment retires the whole set. For an overflowing union, prepare
three exact manifests before retirement: a metadata-only cleanup-free successor
of the actual predecessor, the ordinary business successor of that intermediate,
and its cleanup-free successor. Each retains the existing1,024-ID limit and exact
revision/hash joins. The in-memory old/new retirement sets together are bounded
by2,048. Do not widen `ValidatePendingSuccessor` to accept omitted obligations.

For abandoned pending/backup recovery, authenticate and retain the original
descriptor until all provider phases needed by the outer call are complete.
Prepare/authenticate the required candidates, then freshly join actual CURRENT,
guard and the exact existing file family. The final segment retires authorized
abandoned objects before clearing their descriptor, then stages/adopts any new
mutation and completes its cleanup. Current is never recovered from pending.
Prepared candidates cannot keep an extra live plaintext/key-bearing inventory
across callbacks; retain exact protected bytes and key-free facts, and freshly
admit the actual source after external edges.

Before the first descriptor-clearing or intermediate-adoption cutpoint, a retry
may freshly admit the unchanged source and repeat the whole authorized set.
After that cutpoint the exceptional suffix permits no provider, arbitrary hook,
wait or retry until the outer return; only a fixed internal crash injection may
interrupt it. Exact path/source/guard/object checks and durability remain in
force. A genuine I/O failure propagates the existing exception with the durable
current/pending state for the next independent call. It is never a synthetic
retry request, CAS=false after business adoption, or early cleanup success.
This rare path sacrifices in-call sharing retries after the cutpoint, not any
authentication or retirement check. Test intermediate/primary crash outcomes,
pending recovery with a new mutation, and callback restoration explicitly.

## Retained enrollment and qualification

### Bounded local diagnostic authorization — 2026-10-28

The owner explicitly requested testing the same three retained CLI profiles
without resets after the WIP fixes. Focused05 passed207 cases (188 storage,
19 contact), including actual access revocation, cleanup restoration and crash
recovery. CLI29 and matched baseline07/candidate04 each passed their declared
correctness rows with unchanged inputs. These receipts permit one controlled
local retained enrollment and diagnostic run under that request. Preserve every
logical slot, account/key/instance, native file and original operation; capture
before/after invariants and stop on any mismatch. No production/device action.

This is a diagnostic exception to the earlier blanket conversion hold, not
performance or release acceptance. Candidate04 materially improves the regressing
manifest candidate, but remains slower than the aggregate in the matched nine
microbenchmarks (one single-read median is nearly equal). Keep that failure
visible. The retained run measures complete delivery and remaining work; it must
not be presented as proof of subsecond latency, full qualification, or permission
to publish/deploy. Subsequent changes require their own relevant checks.

Explicit enrollment fully authenticates/decodes the actual DSS1 source under
host/process leases, preserving EVERY logical slot, identity, instance, original
Store/ACK, pending operation and native SQL file. New revision1 binds the exact
source hash. Stage bounded object batches; verify complete coverage/count/values;
rejoin actual source after callbacks and adopt once. Precommit interruption
resumes only explicitly; postcommit recovery is new-format-only. Remove old
key-bearing pending/backup material; never use it to repair a missing adopted
root. No account reset or counter rewrite. The ordinary backend has one reader.

Require real production-storage tests for framing/bounds, selected corruption
and absence, atomic cross-slot winners, callback guards, crash/cancel cutpoints,
cleanup recovery, process races, strict missing-root lifecycle, unchanged
enrollment and independent SQL joins. Reuse existing unchanged-semantic tests.
The unrelated contact-threshold test refusal remains recorded, never waived.

One obsolete implementation-specific test has an explicit replacement for the
canonical full-gate reference union:

- `Deep.Client.Shared.Production.Tests.SecureStorageCompareExchangeTests.SelectedDecodeAvoidsUnrequestedValueBuffersWhileFullMutationDecodeRetainsThem`
  is replaced by
  `Deep.Client.Shared.Production.Tests.SecureStorageCompareExchangeTests.SelectedReadLoadsBoundedManifestWithoutUnrequestedObjectPayloads`.

Exact gate binding:
`Deep.Client.Shared.Production.Tests.SecureStorageCompareExchangeTests.SelectedDecodeAvoidsUnrequestedValueBuffersWhileFullMutationDecodeRetainsThem -> Deep.Client.Shared.Production.Tests.SecureStorageCompareExchangeTests.SelectedReadLoadsBoundedManifestWithoutUnrequestedObjectPayloads`

The former measured the retired aggregate decoder's allocation strategy. The
replacement exercises actual manifest/object storage with a large unselected
value, one fresh inventory Unprotect, selected membership/absence, zeroization
and preservation across CAS. It must pass; this binding waives no failed or
skipped case. Existing malformed-unselected framing cases remain required.

Measure actual manifest/object bytes and crypto calls using closed scalar
counters outside private scopes. Compare disposable synthetic inventories with
the same platform protector/filesystem; archived prior binaries are benchmark
artifacts, not a second production backend. Separate cold audit/enrollment costs.
Then measure the SAME three retained CLI profiles without resets. Neither this
format nor focused tests prove≤1s; native indexing, owner consolidation, fanout
and receive/ACK remain parts of the full objective.
