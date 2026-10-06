# DR-0030 — DID2 owned direct-text draft and counter custody

Status: accepted local contract; transport/semantic ACK still gated
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

## Protected command before SQL or crypto

The current journal generation and verified Store-completion phase are governed
by [DR-0067](DR-0067-did2-ordinary-store-completion-and-ui-retry.md), which supersedes
the original version1/two-phase grammar below. The independent current authored
floor and local reader are superseded by [DR-0098](DR-0098-owned-authored-counter-floors.md).
Original-event ownership, SQL
integrity and contiguous sequence requirements remain in force.

The account owner, under its actual lease and current DR-0027 endpoint/retirement
checks, authors each ordinary text command once. Caller operation32 identifies
one UI command, never an event or authorization; it must be generated once by
the composer and retained for retry. The owner generates logical ID32 with
CSPRNG, derives its sequence from protected custody, and retains exact pending
DMC2 before SQL insertion. No raw caller-authored MessageCreate may enter the
production DPE2 send path. Existing prototype tests must use this owner rather
than keep a raw-send bypass. This is queued text, not delivery or Active consent.
Responder text starts at4, after actual retained ContactAccept at3; initiator
starts at3. All later ordinary typed events must share this counter namespace,
not create another text/attachment/receipt counter. Only text is authored by
this increment; other consumers remain inactive until their own closed custody.
The account send boundary explicitly rejects every kind except owned
MessageCreate and owned ContactAccept before proof acquisition or crypto.
Codec support for attachment, receipt or group records is not send authority.

The required protected slot `deep.store.v2.direct-text-journal` is registered
atomically with the account SQL key. Missing/foreign/old custody requires explicit
reset. Header92: version1, reserved-zero1, count:u16be, revision:u64be,
network16/account32/instance32. At most512 entries sorted by operation32.
Revision is `1 + 2*stableCount + pendingCount`; at most one pending command.
Entry: operation32, exact scope404, logical32, sequence:u64be,
created-ms:u64be, SHA256(exactDMC2)32, phase:u8 (pending1/stable2),
reserved-zero3, pendingLength:u32be, pendingDMC2 only at phase1. Fixed prefix524;
pending text DMC2 is canonical MessageCreate285..16668, flags0/expiry0/no reply.
Each operation, logical position and conversation/device/sequence is unique;
sequences within a conversation/device are contiguous from3 (initiator) or4
(responder), never wrap or depend on a SQL-supplied next value.

## Exact SQL mirror and recovery

Reuse DR-0028 account-owned application SQL, not another database or V1 adapter.
Before mutation, verify all existing text rows against protected entries in one
SQL transaction/connection: no extra, missing stable, changed recipient,
operation, sequence, created time, event hash or exact canonical bytes. Verify
the exact next counter for every text-authored conversation/device. Other
contact-control counters are checked when their scope is first adopted; they
do not authorize a caller text sequence. An initiator's unused baseline may
be absent; a responder's baseline must already be4 from the actual retained
ContactAccept. Missing responder counter rejects rather than recreating it.
A pending command may have zero or
one exact SQL row and only its expected before/after counter. Roll forward
only this exact protected pending DMC2, then read back and CAS it stable.
Stable SQL loss/rollback/changed rows reject without recreation or reauthoring.
Only a pending row can be inserted during recovery. A crash before protected
CAS has no command; after pending CAS retries the same logical/operation/event.

Stable entries retain only metadata/hash, not another plaintext history copy.
An exact retry reads and verifies its SQL bytes and compares the requested
canonical text to the retained command. Reusing an operation with another
scope/text rejects before new mutation or crypto. DPE2 send independently
requires the stable protected command and verified SQL mirror, then uses the
existing DR-0027 exact crypto commit/replay path. Draft custody grants no
route, mailbox ACK, accepted/delivered/read status, expiry or remote deletion.
Semantic inbox rollback/dedup/receipts, dispatch attempts/reconciliation,
Active reachability, typed attachment/group custody and physical Windows/Android
evidence remain separate gates. Capacity exhaustion requires an owned verified
rollover; never prune or reset a protected counter to make space.
