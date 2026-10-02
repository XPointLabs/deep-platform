# DR-0026 — atomic DID2 initial contact receiver custody

Status: **accepted bounded local store contract; runtime activation gated**
Date: 2026-09-30
Decision owner: **Mr. X** (delegated architecture authority)

The account-owned receiver closes DR-0024/0025 inside one process-independent
account lease. Before restoring a private prekey, check durable exact replay
and prekey/operation/session collisions. New completion requires current
recipient and initiator proofs and the verifier-minted exact initial claim;
arbitrary plaintext, ratchet bytes or reservation facts are not inputs.
This first-contact operation requires an authenticated DR-0022 ContactHello.
Expose the existing immutable typed `ParsedDmc2.ParsedPayload` getter to the
Shared consumer, with no new parser or wire meaning. It is unverified parsed
plaintext, not authenticated origin, current endpoint, session or ACK evidence.
Callers must retain the independent authenticated custody/current-proof gates.
Expose key-free `ParsedDpk2V2.SignedX25519PrekeyId`, `MlKemPrekeyId` and `ReuseLimit` getters
from its existing exact V2 parser for public-inventory/session correspondence;
neither getter grants offering, current proof, claim or secret authority.

PKV2 schema becomes generation 3, with one receiver session ledger alongside
the complete public inventory and private prekeys. In one SQLCipher transaction,
append exact authenticated TRS1/SessionInit/Hello and its replay/reservation
facts and delete the consumed one-time secret. For last-resort prekeys, retain
the secret only while fewer than its exact signed DPK2 reuse limit (1..64)
distinct verified counters have completed; counter arrival need not be ordered.
An exhausted secret is deleted in the transaction completing that limit.
The wire maximum 64 must not override a smaller signed limit. Exact replay is read from
the session ledger, never by re-opening a spent secret.

A mandatory protected account/database-instance/network-scoped checkpoint is
initialized atomically with the account SQL key before account publication.
Its stable/pending phases use a 160-byte header as in DR-0020, but a separate
slot `deep.store.v2.responder-initial-session-checkpoint` and the domain
`Deep/STORE-V2/responder-initial-session-record`. At most 128 initial contact
sessions are retained. A pending checkpoint contains one complete bounded
receiver record and its exact predecessor; publish it before the SQL
transaction, then stabilize only after matching SQL commit and secret deletion.
After publication, advisory cancellation cannot abandon the exact pending
record. Reopen permits only exact roll-forward; stable rollback/missing or
conflicting history rejects. Reconcile before any inventory/key release.
No fresh key, claim, encryption or authenticated event is recomputed in recovery.

The local receiver record has a 136-byte header: version1, prekey kind1/2,
counter-u16, DMD1-length-u16, reserved-zero-u16, DPH2/TRS1/SessionInit/Hello
lengths (four u32), exact claim replay hash32, account/device generations
(two u64), one-time X25519 ID-or-zero32 and ML-KEM prekey ID32; then exact
recipient DMD1, DPH2, TRS1, SessionInit and ContactHello. Bounds are DMD1 codec
bound, 64 KiB DPH2, 128 KiB initial TRS1 and 32 KiB per initial event. Require
exact network/account/device/session, directional directories and canonical
common event stream plus normative relationship-derived conversation on
capture and protected recovery. Integers are big-endian.

The ledger is a contiguous sequence/hash chain of those complete records.
Repeated operation/session/one-time X25519/ML-KEM or last-resort counter with
different replay facts rejects before secret use. A collision does not create
another session. Missing private members are permitted only when explained by
the authenticated completed ledger; public inventory remains byte-identical.
Prekey-store reopen verifies that correspondence and the protected checkpoint.
Generation 2 PKV2 rejects without migration; isolated QA requires explicit
reset. Node identity/genesis/network floors are unaffected.

Only a closed validated stable store result is returned, with public session,
conversation and relationship IDs; ratchet state and exact events remain inside
Shared for later message/contact projection. This is durable pending contact
custody, not contact acceptance, route publication, transport ACK, shipping
composition or physical delivery. Those downstream owners remain mandatory.

Normative dependencies: [DR-0020](DR-0020-did2-atomic-device-initial-session.md),
[DR-0022](DR-0022-did2-contact-control-events.md),
[DR-0025](DR-0025-did2-owned-responder-preparation.md), and
[CONTACT-RESOLVER section 3.4](../../architecture/CONTACT-RESOLVER-V1.md#34-atomic-pre-key-claim-xpk1--xpc1).
