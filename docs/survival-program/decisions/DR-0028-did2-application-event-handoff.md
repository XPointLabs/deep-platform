# DR-0028 — DID2 application-event custody and initial inbox handoff

Status: **accepted local contract; dispatch/ACK activation gated**
Date: 2026-10-01
Decision owner: **Mr. X** (delegated architecture authority)

## One account-owned application store

Reuse the existing portable SQLCipher mailbox/application implementation, not
a Session account/scope adapter or another database technology. A DID2 owner
derives its independent application key as HMAC-SHA256 of the account SQL
master key and ASCII `Deep/STORE-V2/application-state-key`, zero, network16,
account32 and account database instance32. Own/wipe derived key buffers.
The path is `<account SQL path>.application.dmb1`, supplied only by the owner.
No V1 account key/path/catalog or identity conversion is permitted.

The required protected slot `deep.store.v2.application-state` is initialized
atomically with the account SQL key before account publication. Its 116 bytes
are one-byte version1, one-byte phase (registered1/SQL initialized2), reserved-zero2, network16,
account32, account database instance32, SHA256(derived application key)32.
Missing/foreign/unknown records reject, without regeneration. Under the actual
account lease, phase1 permits only absent or exactly initialized-empty SQL;
then exact schema/empty readback precedes CAS to phase2. Phase2 opens existing
SQL only: missing/blank/old schema cannot be recreated. Linked artifacts reject;
orphan sidecars reject on open. Explicit reset removes only this owner's exact
file family, including its orphan sidecars, without following links.

The current application schema becomes DMB1 generation5, without a generation4
reader or migration. Retain the existing transaction implementation and tables;
add canonical big-endian sender-sequence8 to each authenticated inbox row and
an index on conversation/author account/device/sequence. Ordinary application
events start at sequence3. A different event occupying an authenticated authored
position durably forks that position, never materializes both events. Exact
replay retains one row. SQL and in-memory behavior must agree. Unknown schema
objects or changed DDL reject; secure-delete must apply on every reopen.

## Closed DID2 handoffs

The initial batch comes only from the account-owned, retired, active DR-0027
session's verified SQL/protected floor and exact retained initial events.
Capture bounded owned SessionInit/Hello after verifying their journal binding;
recheck current DID2 endpoint bindings through DR-0022. Bind network, local
account generation, directional author account/device, relationship and the
normative conversation. Sender-owned events remain local-author events;
receiver-owned events remain peer-author events. No caller bytes, parsed Hello
or restored scope alone can manufacture authenticated application custody.

The account owner applies the two initial events atomically to its application
inbox after source-key retirement, under the same account lease, and rechecks
current endpoints/clock before returning. Crash retry uses the same retained
initial batch; it does not perform another claim/import or reopen erased keys.
Ordinary receive handoff likewise reads the actual committed DPE2/DMC2 row,
checks the direct semantic conversation/kind/sequence and independently current
scope before materialization. Group/control events require their separate
membership/contact-state consumers; they cannot be treated as direct text.

Initial retention is **not** contact consent, active reachability, delivery or
ACK authority. Application SQL is not a ratchet-key store. Protected semantic
rollback/outbox-counter checkpoints, ContactAccept state/consent, current routes,
semantic receipts and staged-row retirement must close before dispatch/ACK.
Do not silently elevate this intermediate inbox projection to those claims.
The remaining requirements stay owned by MSG-01, CONTACT-CLIENT-01 and GROUP-
CLIENT-01; full Windows/Android device evidence remains mandatory.
