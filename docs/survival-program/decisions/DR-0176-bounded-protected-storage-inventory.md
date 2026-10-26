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
including final post-adoption callbacks. See the
[Shared checkpoint](../../../deep-client-shared/docs/testing/dr0176-protected-inventory-2026-10-26.md).

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

## Retained enrollment and qualification

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
