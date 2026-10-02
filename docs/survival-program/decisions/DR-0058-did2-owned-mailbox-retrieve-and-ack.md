# DR-0058 — DID2 owned mailbox Retrieve, retained page and semantic-before-ACK

Status: accepted connected local custody/API contract; implementation/live/device gates remain
Date: 2026-10-02
Decision owner: Mr. X (delegated architecture authority)

Keep existing neutral MBR2/MBA2/MAU2/MRP1 and signed tombstone quorum wires.
The recipient entry takes only its actual account source. It obtains
current own network/directory evidence outside the account lease, then derives
Retrieve capability solely from the verified protected phase-7 own permanent
publication (DR53). No caller mailbox, capability, signer, SQL handle, trusted
boolean, ACK list or successful receive callback may authorize an operation.

Initialize mandatory `deep.store.v2.mailbox-read-journal` atomically with the
account instance. Missing/foreign/malformed custody requires explicit local QA
reset, not lazy repair. One active read cycle per account; at most 128 retained
grant replay-counter floors and 128 mailbox-scope traversal floors, no eviction.
The owned request asks for at most eight items. Bound captured page by the exact
neutral page header/token plus eight maximum envelope/item frames, and the whole
local root below the existing secure-storage single-value bound. This limits a
single processing batch, not the neutral protocol's global page allocation.

After the connected owner/custody checkpoint, expose the production default
`DeepIdV2AccountService.SynchronizeOwnMailboxAsync(source, cancellationToken)`
for platform composition. Its public `DeepIdV2MailboxSynchronizationResult`
has read-only processed-envelope, durable-tombstone counts and `HasMore`, and
no public constructor or plaintext/selector/authority surface. Processed counts
include idempotent replays, not only newly inserted user messages. The overload
accepting grant/terminal fixtures remains internal; this does not activate MAUI
or bypass matching live authority/configuration. One invocation processes one
bounded page; the platform owns scheduling rather than an implicit retry loop.

The canonical protected root binds network/account/instance/revision and sorted
unique grant counter and mailbox traversal floors. Its closed active phases are
pending Retrieve, prepared Retrieve, captured page, committed page, pending ACK,
prepared ACK; empty has no active cycle. Bind exact route/grant/mailbox scope,
original traversal generation, exact MBR2, MAU2 hash/counter, captured MRP1 and
its authenticated capture time, exact MBA2, its MAU2 hash/counter and retained
exact verified tombstone-quorum response. SQL's MCO1 is only a response digest,
not recoverable quorum evidence: persist/read back the actual bounded response
before SQL outcome mutation and independently reverify it on cached completion. Reject
inconsistent phases, unknown/trailing bytes, duplicate/zero bindings and hostile
sizes before adoption. Floors are never inferred from mutable SQL after a cycle
has established them. A first new mailbox scope requires empty actual traversal.

Separate owned SQL preparation from adapter dispatch. Persist/read back pending
body before SQL/signing, verify the actual exact MAU2/holder/current grant and
counter, then persist/read back prepared custody before callback. Once prepared,
missing or changed SQL request cannot be regenerated. Retrieve and ACK share the
same protected replay-counter floor for the retained Retrieve holder. They never
borrow a Deposit holder or refresh an unknown request's grant/path/lifetime.

The route-bound interceptor copies a bounded reply before asynchronous fences,
verifies it against the exact request/current route, and persists/read backs the
captured page before the adapter can mutate SQL inbox/traversal. After a crash it
may feed that exact protected captured page back to the same prepared adapter
operation without fetching a replacement. Committed SQL outcome summary must bind
the captured response digest and page; independently read actual SQL traversal
before updating its protected floor. Cached local response is not current route
or physical recipient evidence. Lost response remains unknown with bounded exact
retry and no automatic second selected path.

Release the owner lease before fetching independent peer proofs. Ordinary DPE2
uses DR57's actual initialized protected-catalog selection and owned receive
materialization. Before ACK, reacquire the actual owner lease, reread the exact
protected page and its SQL state, verify current endpoint proofs and stable
native ratchet/journal rows, and materialize/read back each supported semantic
event from those retained rows. Only the exact ordered captured cursor/digest
list may then author ACK. Unsupported, unknown, forked, expired or unmaterialized
events remain retained without ACK; never convert them into success or a drop.
DPH2 initial contact and group-control events require their own actual consumers,
not an ordinary-DPE fallback or a caller assertion.

The DPH2 consumer independently fetches a nonce-bound current initiator proof
from its parsed public DID2 before opening any private prekey. Under the actual
recipient lease, require the verified own permanent publication, derive claim
placement from the AEAD-opened XPK1 and verify XPC1 against that actual published
recipient closure. Compose DR26's atomic source commit and DR27's owned import,
retirement and initial semantic handoff; exact historical replay precedes spent
key lookup. The owned consumer's local PQ-injection bound is 32 messages, within
the existing factory contract; it grants no new wire or downgrade path. Before
ACK independently reread the actual source record, phase-2 catalog and active
mutable floor, and rematerialize the authenticated initial event batch. Group
input remains unsupported until its corresponding consumer is connected.

Use independently fresh dispatch-only policy after preparation (DR56), the held
readonly-floor three-hop ONION context and normal TLS. Verify exact two-replica
tombstone quorums with independently derived node identity keys. Recheck actual
protected roots/current floors and semantic read-back before/after callback.
Only verified durable completion clears the active cycle; retain counter and
traversal floors. Empty captured pages need no invented zero-item ACK but must
still commit/read back their actual Retrieve outcome and traversal.

Connected interruption/restart/rollback tests must cover actual owners and
SQLCipher; simulated transport/time is labelled local. Initial delivery, remote
attachment chunks, group consumers, matching live authority bundles and physical
Windows/USB Android remain mandatory release gates.
