# DR-0140 — distinguish transport objects from semantic ciphertext

Status: accepted producer correction; source and connected qualification pending
Date: 2026-10-18
Decision owner: Mr. X (delegated architecture authority)

Semantic owner: [TRANSPORT-NEUTRAL-MESSAGING §8.4.1](../../architecture/TRANSPORT-NEUTRAL-MESSAGING.md#841-sendattempt-transitions).

## Observed defect

Retained CLI text reached the recipient's authenticated history exactly once,
but its sender remained uncertain. A later transport attempt retained the same
ciphertext and assigned a new operation ID while reusing H(ciphertext) as the
mailbox object key. Native storage correctly rejected the resulting collision:
the existing object belongs to the original operation/cursor/request context.
This is not proof of lost original intent and must not disable that guard.

## Current producer rule

For a newly authored mailbox attempt, the existing 32-byte
`DeduplicationDigest` field is:

```text
SHA-256(UTF8(MailboxDomainSeparation.EnvelopeDigest) || 0x00 ||
        canonical mailbox OperationId[16] || exact committed ciphertext)
```

The existing domain constant is `deep.mailbox.envelope-digest.v1`. This allocates
no new label, suite, field, API, wire version or local journal generation.
The mailbox operation already binds the account/session scope and durable
attempt identity. An exact attempt retry keeps the same key; an independently
authorized successor gets a distinct transport object and cursor. Its exact
E2EE event, ciphertext, ratchet transition and semantic dedup identity stay
unchanged. At-least-once transport may hold more than one copy; the recipient
must materialize the authenticated event once and ACK each actual cursor/key.

## Captured work and evidence

Never rewrite a captured body, signed MAU, protected body hash or old evidence.
Recover its canonical request from actual SQL and join its protected body/MAU
commitments, original grant/holder, scope/operation and committed native
ciphertext. Receipt validation uses the exact authenticated body's object key,
not a freshly recomputed logical ciphertext hash. A pending descriptor without
SQL is checked against the one current producer rule; missing prepared SQL,
changed bodies, missing native custody and counter rollback still reject.
There is no old-hash guessing, compatibility codec or alternative derivation
reader. Original canonical bytes remain original evidence.

Expired grant closure still needs authenticated lower-time exclusion and
retains unresolved predecessors. It does not claim noncommit or delivery. The
server's prefix, mutation, intent and independent replay-floor guards remain
unchanged. An already captured colliding attempt may only be closed by its
existing owner when independently expired, never silently replaced in place.

## Required qualification

Cover cold exact retries and successors after both interruption before ingress
and a lost committed reply; distinct object keys with identical E2EE bytes;
unchanged original requests/floors; invalid/missing original SQL refusal;
cached receipt authentication and both real TLS native replica stores. Then
repeat the retained CLI pair and check both receive histories and duplicate
polls. A diagnostic receipt with unknown Store is not full CLI acceptance.
