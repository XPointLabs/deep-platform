# DR-0027 — DID2 initial-to-mutable messaging ownership

Status: **accepted ownership/lifetime contract; runtime activation gated**
Date: 2026-10-01
Decision owner: **Mr. X** (delegated architecture authority)

## One DID2 path

Mutable message sessions consume only the closed stable sender/receiver
custody from [DR-0020](DR-0020-did2-atomic-device-initial-session.md) and
[DR-0026](DR-0026-did2-atomic-responder-custody.md), under the process-independent
account lease. Do not manufacture a V1 contact scope, prekey handoff, old
account identity or caller-selected ratchet state to enter a retired facade.
Reuse Protocol's existing exact DPE2 transition producer, not a second ratchet,
wire grammar or crypto provider. Exact local codecs/schema must be specified
in this decision before their implementation; this first contract freezes
the internal owned initial-session seed and its lifetime requirements.

An internal non-exportable initial seed derives local/remote account/device
generations, directional DMD1 heads, relationship and conversation only from
closed custody plus independently current own/peer DID2 proofs. The protected
account/database instance is supplied by the account owner, not UI. Sender
events must match DR-0020's retained event hash; receiver events come only from
DR-0026's authenticated custody. Both require SessionInit and DID2 ContactHello,
the normative relationship/account-derived conversation and exact current
directory/device scope before copying TRS1. A changed directory before this
bounded initial import rejects; later current-head updates are a separate
verified device/session transition, not reinterpretation of the initial seed.
Opaque owned buffers stay inside Shared and are wiped on disposal or failed
capture. A parsed record or a seed is not an ACK, contact acceptance or network
dispatch capability.

## Durable transfer and deletion

The initial TRS1 cannot remain a recoverable secret in an immutable handshake
ledger after mutable ratchet ownership begins. First commit and independently
verify the exact mutable session's scope/initial basis and protected floor;
then durably retire its old initial-state copies with recoverable exact
deletion. Until retirement is complete, prohibit ordinary send/receive and
dispatch. An interrupted transfer resumes that same session/state, not a new
claim, DH/KEM operation or handshake. Lost mutable state cannot be repaired by
re-importing an older initial TRS1.

Retain bounded public initiation/replay and authenticated-event commitments
needed for exact DPH2 retry and contact/MSG materialization, not old ratchet
secrets. Retirement authorization must be closed and minted by the verified
mutable store; arbitrary IDs or a caller boolean cannot authorize deletion.
Protected retirement and mutable floors remain account/instance/network/session
scoped. Their local formats must explicitly authenticate the remaining
metadata, fail closed on rollback/missing history and recover deletion without
requiring an already erased secret. No compatibility reader or secret recovery
fallback is permitted.

Sender retirement covers DR-0019's sealed preclaim copies as well as the
initial TRS1: those retain the initiator ephemeral and initial-ratchet private
keys. A completed intent keeps a key-free tombstone bound to its exact initial
custody/mutable transfer, not a missing entry that can generate a new claim.
Exact DPH2 retry must consult completed custody before any preclaim restoration.
The current insert-only preclaim journal has no retirement representation;
its replacement/tombstone format and both source-ledger replacements must be
frozen and implemented as one clean break before ordinary messaging activation.

Mutable sends/receives persist Protocol's exact sealed transition, replay/PQ/
deletion evidence and outbound ciphertext or authenticated inbound DMC2 in
one SQLCipher transaction, with an independently protected pending/stable
floor and exact crash recovery. Same operation with changed bytes or reused
authenticated counters latches the session. Exact replay never advances it.
Old mutable chain/message keys cannot survive in retained journal snapshots.
Public release remains blocked on safe rollover, semantic inbox/contact state,
durable logical outbox, correct transport authority, and full Windows/Android
physical contacts/messages/files/images/groups E2E. Local ratchet custody alone
grants none of those claims.

Normative owners: [crypto sections 9–14](../releases/v3.0.0/specs/DEEP-CRYPTO-V1-DRAFT.md#9-mandatory-triple-ratchet),
[DPE2 inbound handoff](../releases/v3.0.0/specs/DPE2-INBOUND-DURABLE-HANDOFF-AUTHORIZATION.md),
and [MSG-01 / STORE-01](../../architecture/IMPLEMENTATION-PLAN-V1.md#msg-01--canonical-events-logical-outboxinbox-and-dedup).

## Native transition correction (existing formats/APIs)

The actual managed/native continuation must retain transferred send/receive
evidence successors; clearing a temporary alias must not clear live state.
The encapsulating Braid party may be in `Ct2Sampled` with an installed SPQR
output for that same negotiation epoch while still sending Ct2 in that epoch.
Accept only this exact pending-completion relation, not an arbitrary epoch
mismatch. Other component states retain the usual negotiation epoch equal to
installed SPQR epoch plus one. This repairs rejection of a state produced by
the pinned machine without changing TRC1/MBM1/DTR2 grammar or KDF.

Fresh PQ message-key contribution is the first derived receive key of a
positive installed SPQR epoch, never an old-epoch key that merely transported
the Braid completion. Receiving a fresh Braid output installs a link; that
alone cannot reset the message-key freshness fence for an old link. For gaps,
mark only the first key of that new link; later keys count after it. This
requires no new retained flag or wire field: exact epoch/counter and the
owned installed link already determine the one-time first-key transition.
Epoch-zero handshake-root keys are not fresh ratchet contributions.

## Mutable local codec and persistence (frozen before implementation)

All integers below are big-endian; these are Shared-only local formats,
not Protocol network magics/APIs. No old session/initial-row compatibility
reader is introduced. Initial-custody replacement/retirement is frozen below;
account catalog, shipping composition and release evidence remain gated.

Session scope is exactly 404 bytes: version1, role1 (initiator1/responder2),
reserved-zero2, network16, account database instance32, local account32,
local account generation-u64, local device32, local device generation-u64,
remote account32, remote account generation-u64, remote device32, remote
device generation-u64, session32, conversation32, relationship32, original
initial-custody SHA25632, local DMD1 hash32 and remote DMD1 hash32. IDs/hashes
and generations are nonzero; local/remote accounts and devices are distinct.
Only the owned initial seed creates this scope. Scope identity is
SHA256(ASCII `Deep/STORE-V2/messaging-session-scope` || zero || exact scope).
Restored scope is bounded metadata, not fresh endpoint or retirement authority.

Protected floor is exactly 188 bytes: version1, phase1 (stable1/pending2/
cleanup3), status1 (awaiting initial-key retirement0/active1/latched2),
reserved-zero1, scopeHash32, journal ordinal-u64, journal head32, ratchet
generation-u64, ratchet commitment32, exact ratchet SHA25632, pending payload
SHA25632, pending byte length-u32, part count-u8, reserved-zero3. Empty
pre-import floor has ordinal/generation/hashes zero and status0. Other floors
have nonzero ordinal/head/generation. A latch has no live ratchet hash or
commitment; only status2 permits that shape. Stable has no pending fields.
Pending/cleanup retain a nonzero pending commitment and exact minimal part
count. The floor slot is `deep.store.v2.messaging.floor.<scopeHashHex>`.

Pending payload has a 608-byte header: `MSP2`, version1, kind1
(import1/ratchet2/activate3/latch4), direction1 (none0/send1/receive2),
successor status1, exact stable predecessor floor188, successor ratchet
generation-u64, commitment32 and exact TRS1 SHA25632, operation32,
event commitment32, envelope replay commitment32, exact header commitment32,
deletion manifest32, message-key deletion32, replay evidence32, deduplication
mutation commitment32, PQ fence32, terminal commitment32, then five u32 lengths (next TRS1, envelope, DMC2,
SessionInit, Hello). Concatenate those five bodies in that order. Metadata
is the header only; old/next TRS1 never occurs in retained journal metadata.
No prior TRS1 copy is needed in pending: its SHA256 and protected predecessor
are sufficient for exact SQL CAS/recovery of a Protocol-sealed successor.

Import requires generation1/status0/direction0, empty predecessor, next TRS1
at most 128KiB, exact DPH2 at most64KiB and canonical SessionInit/Hello at
most32KiB each. Operation is the claim operation; event commitment is the
framed initial-event hash, envelope commitment is SHA256(exact DPH2); other
evidence fields are zero. Ratchet requires active predecessor/successor,
exactly generation+1, next TRS1 at most2MiB, a canonical legal-sized DPE2,
closed nonzero header/deletion/message-key/replay commitments, nonzero receive
deduplication commitment (zero for send), optional-zero PQ/terminal commitments,
no initial events, and authenticated canonical DMC2
only for receive. Event commitment is SHA256(exact canonical DMC2), also for
send, where the owned producer caller supplies that hash before preparation.
Activation changes status0 to1 without changing ratchet fields; its operation
and event commitments bind the closed source-retirement receipt. Latch changes
status to2 and erases ratchet hash/commitment, with no body. Both control kinds
have direction0 and no crypto evidence fields or envelope; a latch's operation
and event commitment bind the conflicting operation/content. No control kind
is caller-authorized by these parsed bytes.

Journal ordinal increments once per mutation, including import/activation/
latch. Journal head is SHA256(ASCII `Deep/STORE-V2/messaging-journal` || zero ||
scopeHash32 || ordinal-u64 || predecessorHead32 || SHA256(exact608-byte header)).
Pending payload is bounded by 608+2097152+65536+33082+65536 bytes; exact kind
limits are stricter. Protected payload parts are at most128KiB each, at most18,
with only the last part shorter; slots append `.pending.<index>` to the floor
slot. Stage parts atomically before pending-floor CAS. After SQL commit CAS
to cleanup, atomically erase every scoped pending-part slot, then CAS to stable.
Before releasing any result or preparing another mutation, finish exact
recovery/cleanup; stable orphan parts are erased under the account lease.
Missing pending parts reject; missing cleanup parts are allowed after matching
SQL successor verification. Thus no per-value1MiB limit is weakened and no
historical private-key snapshot remains recoverable after a released mutation.

SQLCipher uses a dedicated current DID2 message-session schema, full synchronous
commits, secure deletion and no plaintext/WAL compatibility mode. Its journal
retains only ordinal/predecessor/head and the exact608-byte header; one row
holds the latest TRS1, pending outbox/inbox hold ciphertext or authenticated
DMC2 with their journal binding, and a separate initial-event row holds the
two authenticated events for semantic handoff. Public send/receive activation
is prohibited until the independent source-retirement gate is complete.

Before the first mutation-codec implementation, the header includes both
Protocol replay evidence and the independently named deduplication mutation
commitment. Neither may be silently dropped or substituted for the other.
Ratchet mutations require nonzero replay evidence and, for receive, nonzero
deduplication evidence. Protocol send has no receive-dedup mutation: encode its
absent value as zero, not invented evidence. Import/control kinds keep both zero.
Optional Protocol commitments are either absent or nonzero32; absent values
map to the exact local zero32 field. No raw plan or parsed bytes authorize mutation.

The scope's initial conversation/relationship binds the authenticated contact
bootstrap. Ordinary DMC2 crypto custody checks network and directional sender
account/device, not an assumption that every later event is in that direct
conversation. Group events use their separately verified group conversation.
MSG/contact/group authority must verify semantic conversation/membership before
materialization or ACK; crypto custody grants no such authority.

### Dedicated SQL journal schema

The per-session SQLCipher database uses application ID `0x444D5332` (`DMS2`),
schema version2, and exactly five tables, without migrations or old readers:

- `scope`: singleton integer1 primary key, exact404-byte scope;
- `journal`: ordinal integer primary key1..4096, predecessor32, head32,
  exact608-byte metadata header;
- `ratchet`: singleton integer1 primary key, exact TRS1 blob1..2097152;
- `initial_events`: singleton integer1 primary key, initial DPH2 blob1..65536,
  SessionInit blob1..32768, Hello blob1..32768; only the import inserts it;
- `events`: operation32 primary key, journal ordinal unique foreign key,
  direction integer1(send)/2(receive), exact DPE2 blob1..65536, plaintext
  NULL for send or canonical DMC2 blob1..33082 for receive.

Journal headers authenticate each event's operation, event/envelope commitments,
scope-bound predecessor and successor. No other row or schema object is allowed.
The live ratchet singleton is replaced, never appended, and deleted for a latch.
All append/replace/event mutations share one full-synchronous secure-delete
transaction. Empty SQL has only its exact scope. Verification recomputes the
bounded complete metadata chain, validates canonical events/envelopes and exact
latest TRS1 against the independently protected floor before release. Signed
SQLite ordinal bounds are checked before protected staging; capacity requires
verified rollover, not old-key snapshot retention or unbounded growth.
Safe journal rollover, account-owned protected catalog/key registration and
source-retirement receipt remain separate activation gates. SQL journal/cipher
custody alone must not activate public messaging or mint a Protocol receipt.

### Source-custody clean break and retirement (frozen before implementation)

Both source records have local version2 only. Sender metadata retains the
DR-0020 fields/offsets0..179 (including the original TRS length), appends the
exact initial-TRS SHA25632 at180, and then contains DMD1/DPH2 only. Its header
is212, maximum metadata67224. Receiver metadata retains DR-0026 fields/offsets
0..135 (including the original TRS length), appends exact initial-TRS SHA25632
at136, then DMD1/DPH2/SessionInit/Hello, with no TRS body. Its header is168,
maximum metadata132716. Live owned custody has a separate wipeable TRS buffer
checked against that hash/length and all original bindings. Metadata-only
historical custody cannot export or seed initial state. It preserves exact
ciphertext/replay and reservation facts, not a compatibility reader.

Source pending serialization is exact metadata followed by its live TRS.
Source protected checkpoints are version2/header192: previous160 fields keep
their offsets, append pending-payload SHA25632 at160, and start the pending
body at192. Stable has no body/pending digest. Pending retains the complete
bounded metadata+TRS for exact recovery, validates that serialization's shape
and TRS digest, and authenticates the raw full pending payload. The source
record hash authenticates key-free metadata only, using respectively ASCII
`Deep/STORE-V2/device-initial-metadata` or
`Deep/STORE-V2/responder-initial-metadata`, then zero, source instance32,
account32, network16, ordinal-u64, predecessor32, metadata length-u32 and
exact metadata. Stable rows never contain TRS or an old TRS snapshot.

DVS1 schema generation5 adds `device_initial_state`: sequence integer primary
key referring to `device_initial_sessions(sequence)`, exact TRS blob1..131072.
The existing initial-session payload bound becomes212..67224. PKV2 schema4
adds `receiver_initial_state`: ordinal primary key referring to
`receiver_sessions(ordinal)`, exact TRS blob1..131072; receiver metadata becomes
168..132716. Initial append inserts metadata and live state atomically with
the original burn. Source rollback/missing/live-state mismatch rejects unless
the exact protected retirement entry permits a deletion already in progress.
A stable retirement with resurrected live state always rejects before release.

The account-owned retirement journal slot is
`deep.store.v2.initial-key-retirements`, initialized atomically with the account
SQL key before publication. Header92 is version1, reserved-zero1, count-u16,
revision-u64, network16/account32/account-database-instance32. It holds at most
256 sorted unique236-byte entries: role1 (sender1/receiver2), phase1
(pending1/stable2), reserved-zero2, source instance32, source ordinal-u64,
source record hash32, mutable scope hash32, initial basis hash32, TRS hash32,
logical intent32(sender)/claim operation32(receiver), preclaim blob hash32
(nonzero sender/zero receiver). Sort by role, source instance, source ordinal;
duplicate source coordinates, mutable scopes or initial bases reject.
Revision equals1+entry count+stable count; pending insert and stable completion
each increment once. It authenticates deletion without carrying secret bytes.

A closed transfer capability is minted only after independently verifying
the mutable SQL/protected stable import (ordinal1, ratchet generation1,
awaiting-retirement status0), exact initial basis/scope/TRS hash and initial
cipher/event commitments. Source owner checks actual account/database instance
and the exact authenticated source row before staging retirement. Protected
pending retirement -> sender preclaim tombstone CAS -> source live-TRS DELETE
transaction -> protected stable retirement. Receiver skips preclaim tombstone.
Pending resumes exact deletion; stable never repairs a resurrected key. Only
then may a closed source-retirement receipt authorize mutable activation.

Preclaim journal version2/header92 replaces insert-only version1. Sorted
entries have header136: intent32, status1(live1/retired2), reserved-zero3,
sealed-blob SHA25632, source basis32, mutable scope32, blob length-u32, then
blob bytes only for live status (exact Protocol canonical byte count). Live
basis/scope are zero, retired basis/scope nonzero and blob length0. All blob
hashes nonzero. Revision is1+entry count+retired count. A tombstone keeps the
original sealed-blob digest and exact source/mutable binding; no retirement
deletes an intent or lets it generate a new claim. Completed retry reads
authenticated source custody before restoring any preclaim. Existing QA
source/persistence generations require explicit reset, never migration.
This local format has no previously activated reader or persisted production
generation to retain.

Both source connections use full synchronous secure deletion and DELETE
journaling on every open. An encrypted WAL is still recoverable with its
retained account key; encryption alone does not justify retaining old TRS.
Source open verifies foreign-key integrity, complete metadata-chain coverage
and every matching retirement entry before releasing initial state. Account
open cross-checks preclaim tombstones with that independent journal; a stable
deletion cannot silently erase a resurrected blob as a purported repair.

### Account-owned session registration (frozen before implementation)

The required protected slot `deep.store.v2.messaging-session-catalog` is
initialized atomically with the account SQL key before account publication.
Header92 is version1, reserved-zero1, count-u16, revision-u64, then network16,
account32 and account database instance32. At most512 sorted unique entries
have440 bytes: phase1 (registered1/SQL initialized2), reserved-zero3, exact
scope404, independently generated SQLCipher key32. Sort by scope hash; duplicate
scope, session, initial basis or SQL key rejects. Every scope's local account,
network and database instance must equal its catalog owner. Revision is
1+entry count+initialized count. Decoding requires protected owner scope and
does not grant fresh identity, mutation, route or ACK authority.

Under the process-independent account lease, first verify closed source/current
own-peer authority and mint the owned seed. Register its exact scope plus random
key and empty floor atomically in protected storage, before SQL creation. SQL
path derives solely from the scope hash under the account's private directory,
never from a persisted/caller path. Existing registration never overwrites a
floor or creates a second key; same session/basis with different scope rejects.
Only registered phase1 with exact empty floor permits initial SQL creation.
After exact SQL scope/schema/empty-tip readback, CAS catalog entry to phase2.
Interrupted initial creation resumes the same key/floor; initialized missing
SQL rejects, never silently recreates. A phase1 file with invalid or nonempty
SQL rejects rather than repairing an unverified file.

Only phase2 may import, reconcile mutable pending/cleanup and release a session
handle. Its independently protected floor must match full SQL verification.
Exact empty import uses the closed seed; nonempty state is never overwritten
or repaired from a retained initial seed. Complete source retirement before
ordinary messaging activation, and verify the source history/retirement at
account-owned reopen. Lost catalog, floor, source history or SQL requires an
explicit reset; no V1 session catalog reader, raw-state import or missing-key
fallback exists. The account owner, not UI, supplies all catalog/SQL paths,
keys, account instance and the process-independent lease.

The existing DSS1 aggregate has a u16 entry count. Its current bound becomes
1024 slots to accommodate512 independent session floors plus account roots and
the single lease-serialized18-part pending payload. Per-value1MiB and aggregate
8MiB bounds stay unchanged, with hostile-size checks before allocation. This
is an internal capacity policy, not another aggregate reader/version. Slot
capacity alone is not a500-device release claim: source/preclaim/retirement
capacity and verified journal rollover must also close that release gate.

`IDeepSecureStorage.CompareExchangeAndInsertAsync` is the required atomic
registration primitive: exact existing slot/expected value/replacement plus
a nonempty bounded insert-only batch. Snapshot caller buffers before awaiting.
Missing/mismatched predecessor or any already-existing insertion slot returns
false without any mutation. Duplicate insertion slots, inclusion of the CAS
slot, empty/oversized values, malformed slots or exceeded capacity reject before
commit. Successful replacement and all insertions cross one authenticated
aggregate commit; cancellation/protection failure before rename leaves the
old authoritative inventory. It is not an upsert, repair, callback or fallback
to separate writes. Both in-memory and platform-journaled implementations
enforce the same1024-slot/512-byte-name/1MiB-value/8MiB aggregate limits.

The derived SQL path is `<account SQL path>.messaging/<scopeHashHex>.dms2`.
An interrupted phase1 SQL schema transaction may leave an encrypted blank
database (application ID0/version0/no schema objects); only that exact blank
shape may complete creation using the already registered key/empty floor.
Otherwise phase1 requires the exact initialized empty DMS2 schema. No invalid
schema, nonempty history, orphan sidecar or phase2 missing file is recreated.
Explicit account reset removes only exact runtime-shaped filenames in that
validated account-private directory (64 lowercase hash hex plus `.dms2` and
its exact SQLite sidecars), without depending on decoding corrupt catalog;
symlink/reparse-point targets reject. Unknown
files in the private messaging directory are not implicitly erased.

Read-only operation lookup requires an exact active stable protected floor and
full matching SQL verification. It returns an owned bounded retained event:
operation/direction, exact DPE2 and authenticated receive DMC2 (no send plaintext),
plus its journal-bound event commitment. Exact retry uses these persisted bytes;
changed operation content rejects, never consumes a second ratchet step.
An in-memory replay map is not restart evidence. This read-back does not grant
semantic materialization, transport dispatch/receipt, contact acceptance or ACK.

### Freshness under the actual account lease

Initial seed capture requires a closed live held-account-lease object, minted
only by acquiring the exact process-independent file lock. The object retains
that lock during its bounded read borrows; wrong account path or disposed owner
rejects. No raw stream, caller boolean, ambient/reentrant lease or callback
authorizes a read. The account's directory/network stores expose internal
read-only held-lease methods: same SQL key/instance/schema, protected marker
and full signed head/history authentication as their ordinary readers. They
MUST NOT initialize absent floors, advance trust or fall back to normal readers
that reacquire the lease. Before and after each bounded operation, require the
same live held owner. Missing/mismatched roots reject.

Under the held account lease, freshness rechecks must not acquire the source
gate or proof fetch gate: ordinary acquisition can already hold those gates
while waiting for the account lease. Read-only source checks instead use the
immutable source-owned stores, exact current protected heads/history and the
same verified proof/authority/monotonic expiry checks. Network fetching and
trust advancement happen outside the account lease; final protected checks and
seed import happen within it. Unsupported/custom store readers fail closed,
not via cached proofs or skipped final checks. This local lifetime API changes
no protocol/network bytes and grants no freshness by lease possession alone.

### Account-owned import orchestration

The account owner accepts only a bounded sender logical intent plus exact
initial events, or a canonical received DPH2. It reopens and authenticates the
actual source ledger under its own lease; caller-held source/TRS copies cannot
authorize import. Own/peer proofs and protected network/directory freshness
are rechecked under that same lease, including exact current endpoint heads.
Lookup an existing catalog entry by authenticated source session and initial
basis before attempting seed capture. Existing imported/active sessions resume
their same SQL/protected floor without requiring erased initial TRS. Only an
exact empty registered session can capture a fresh seed and import once.

The owner composes registration, owned SQL reopen, stable import verification,
source retirement and activation without releasing the account lease or
returning a raw SQL/ratchet handle. All locally owned seed and source-state
copies are disposed before activation. Crash retry uses the retained key-free
source metadata and same catalog registration; it never performs a fresh
handshake or recreates initialized missing SQL. The result is key-free scope
metadata, not dispatch, semantic contact acceptance, receipt or ACK authority.
Final source/SQL/protected verification and freshness rechecks precede return.

### Random DMS2 SQLCipher key encoding

The dedicated DMS2 schema generation2 uses its independently generated
256-bit catalog key through SQLCipher4's supported raw-key encoding: exactly
67 ASCII bytes `x'` + 64 lowercase hexadecimal digits + `'`, passed to
`sqlite3_key` with explicit byte length. Construct only owned wipeable byte
buffers; do not create secret SQL statements, managed hex strings, command-line
arguments or logs. The native provider still generates/authenticates its salt
and encrypted pages; FULL synchronization, secure-delete, DELETE journaling
and all protected scope/history verification remain mandatory.
Connection/key PRAGMA success alone is not proof that a key opened the file.
Force an encrypted-page/schema read before returning the connection; full
authenticated scope/journal verification still follows and is not replaced.

This avoids treating an already high-entropy secret as a human password and
performing the password KDF on every reopen. It does not lower password-KDF
iterations or introduce an unencrypted/custom cipher. See the provider's
[random-key guidance](https://www.zetetic.net/blog/2019/06/07/technical-guidance-using-random-values-as-sqlcipher-keys/).
Generation1/password-keyed DMS2 is an unpublished diagnostic generation and
is not opened, rekeyed or migrated; incompatible key/schema requires explicit
local reset. This change touches only new DMS2 session files. The later
[DR-0060](DR-0060-did2-account-random-sqlcipher-key.md) separately replaces the
DSV2 account key interpretation/generation; other source databases retain theirs.
The isolated native probe must demonstrate encrypted bytes, same-mode reopen
and rejection of the other key mode before adopting the factory change.

### Ordinary account-owned DPE2 operations (frozen before implementation)

Only the account owner can compose the ordinary Protocol transaction authority.
Under its actual held lease it verifies current account, own/peer protected
directory/network freshness, registered scope, source retirement and the full
mutable SQL/protected floor. The authority stays private inside this owner;
no caller-supplied TRS, retention digest, replay boolean or SQL handle enters
the operation. The existing exact Protocol producer remains the crypto owner.

Replay retention policy1 retains every ratchet event in the bounded journal.
Its commitment is SHA256 of ASCII `Deep/STORE-V2/messaging-replay-retention`,
zero, policy-u64(1), scopeHash32, exact stable floor188, retained-event-count-u64,
then for each ratchet journal entry in ascending ordinal: ordinal-u64 and
exact metadata608. All integers are big-endian. Compute it only after full
SQL event/body verification against the protected floor. The context derives
generation/commitment/ordinal/head from that same verified floor; exact replay
requires the actual retained receive row with byte-identical envelope.

Send retries require an actual retained send row with the same operation and
canonical DMC2 digest and return that original ciphertext, without preparing
another transition. Fresh commits persist sealed Protocol state/evidence and
ciphertext or authenticated DMC2 through protected pending -> SQL -> cleanup
-> stable; independently verified event readback precedes the Protocol receipt.
Exact receive replay recovers the retained authenticated DMC2, never a new
plaintext produced from old keys. Final endpoint/clock and held-lease checks
precede release of any owned result. These operations grant no MSG semantic
acceptance, transport delivery or ACK. Ordinary fresh mutations stop before
journal ordinal4096, reserving the last slot for a closed terminal transition;
safe rollover remains a release gate.

Changed bytes in an unauthenticated remote packet reject before mutation;
they cannot authorize destructive fork latching merely by copying a known
operation/header. Changed owned local send intent and authenticated semantic
counter conflicts require their separate closed durable latch authority.
The owned-send latch is minted only from a fully verified active SQL send row,
an exact operation match and a different canonical local DMC2 digest after
network/local account/device checks. Its event commitment is SHA256 of ASCII
`Deep/STORE-V2/messaging-owned-send-conflict`, zero, scopeHash32, predecessor
journalHead32, operation32, incumbent event digest32 and conflicting event
digest32. Its closed evidence retains only that scope/predecessor/operation/
commitment. The account owner stages kind4 through the same durable recovery
sequence, erases the live TRS and then reports failure; further ordinary use
rejects. A parsed control header cannot authorize this latch. Authenticated
semantic-counter latch composition remains gated; neither rejection nor
staged DMC2 grants ACK.
