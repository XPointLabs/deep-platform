# DR-0180 — Bounded exact permanent-contact publication custody

Decision date: 2026-11-05. Local protected-storage contract; no wire-format change.

The permanent-contact publication owner keeps one current V11 working root in
`deep.store.v2.contact-route-journal`. The current permanent intent and every
unfinished phase remain working. Each unfinished intent reserves its complete
477,756-byte phase7 entry plus its four-byte framing before any threshold or
publication callback. The working root, including archive references, remains
at most 1,048,576 bytes. Working plus archived intents remain at most 128.

Completed permanent predecessors may move to immutable per-instance, per-intent
protected slots. Each archive preserves the complete original entry, including
private custody, exact requests/responses, issuance head, route, object and
publication commit. The working root binds its exact SHA-256, length and route
hash. Archived exact entry bytes total at most 4,194,304 bytes. These are subset
limits under the unchanged secure inventory limits: 1024 slots, 8 MiB total
plaintext and 1 MiB per ordinary slot. Exhaustion refuses before an effect; no
quota is raised, and no time-based expiry grants compaction permission.

`DeepIdV2AccountService.EnrollPublicationArchiveAsync` is the explicit local
entry point. It authenticates the existing account/device, resolver capability,
SQL instance, all current registrations and idle compaction ownership. Its
V10 parser is reachable only through explicit enrollment. Ordinary admission
accepts V11 exclusively. The conversion preserves the account, address,
independent send/read/replay floors, messaging history and pending operations.
It adopts the current working root and all newly archived exact originals in
one protected CAS-and-insert transaction, then independently reads back the
root and archive commitments. A conflict, existing target, quota refusal or
cancellation before commit leaves the predecessor authoritative. A committed
transaction followed by cancellation/crash is recovered by authenticating its
actual complete V11 winner; enrollment is idempotent and never reconstructs a
missing or damaged original. An active messaging enrollment or compaction
plan prevents this enrollment.

Ordinary permanent-contact renewal makes space on demand through the same
atomic working-root plus exact-original insertion, before publishing a new
reserved proposal. Pending and current entries are never selected. Archived
entries cannot be replaced or dropped by ordinary publication adoption.
Unknown versions, invalid scope/count/length/order/reservation, duplicate or
overlapping names, missing originals and changed exact commitments refuse.
There is one current authority root; the V10 source is not an ordinary reader
or fallback.

Exact retained Store, Retrieve and ACK use the original publication via its
route-hash index. Retained polling and route-history authoring enumerate the
bounded authenticated originals; their callback/adoption guards include the
original archive slots and recorded-renewal dependencies. Named publication
replay reads only the selected intent. Account admission currently checks all
referenced archive commitments through the existing guarded provider read;
this preserves cold corruption rejection but still reads the bounded archived
ciphertexts. This change makes no claim of eliminating that I/O cost.

Legitimate retirement uses the existing retained-path owner and its original
accepted-object horizon, signed epoch exclusion, holder-set, settled SQL,
traversal, counter, idle-work and native-fence predicates. Any sealed acquisition
still naming the path pins publication erasure independently. Its exact archived
publication is hydrated before selection and every stored-plan recovery check.
The joint plan adopts SQL and the original ordered grant/read/publication roots.
The publication successor replaces its archive reference with an erasure-pending
tombstone (reference flag3; ordinary retained references use flag0). The tombstone
keeps the exact original locator, route hash, byte length and commitment. It is
not a retained-read or route-history candidate and still consumes archive quota.

After the complete plan is independently adopted, staging disposed and the plan
is idle, the held owner rechecks remaining path dependencies and atomically
deletes the exact archive slot guarded by the complete tombstone root. It then
independently verifies absence and CAS-removes the tombstone, with exact root
readback. The operation reports retirement only after this erasure completes.
A changed guard refuses deletion. Missing original custody is accepted only for
a durable erasure-pending tombstone, so a crash between deletion and reference
cleanup resumes the same irreversible result. A crash before deletion preserves
the original. Normal cold account opening and automatic maintenance drain this
owned cleanup before new work. Ordinary publication adoption cannot manufacture,
change or discard an existing erasure tombstone. Current publication, unrelated
originals and native/application replay boundaries retain their original rules.

Qualification must cover genuine signed renewal beyond the old reservation
limit, exact originals after cold reopen, retained continuations, CAS refusal,
commit-before-stop recovery, archive corruption/missing originals, version and
reference grammar, and unchanged aggregate quotas. Simulated fixture results
are not evidence of a resumed three-client live delivery round.
