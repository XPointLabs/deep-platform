# DR-0148 — Whole native ACK acceptance owns original first admission

Status: accepted pre-production evidence closure; connected qualification separate
Date: 2026-10-18
Decision owner: Mr. X (delegated authority)

DR-0147 alone covers a missing second-replica reservation, not later batch items
never reached on the sender. A first-item failure can stop the ordered loop
after the entire authenticated ACK and its exact signed PRQ2 intents were
already committed to the native operation document. Those remaining intents
must not become unrecoverable merely because their first loop visit is late.

The existing protected ACK operation stores its actual AcceptedAt, exact body
digest, ordered native cursor/digest/expiry targets, placement/membership/pair,
and COMPLETE original signed peer requests before every effect. Current capture
has already verified the authenticated holder/page continuation and read the
actual native targets under the live lease. Each PRQ2 creation time equals that
native AcceptedAt; existing strict decoding enforces this equality.

## Closed evidence and owner

Only the actual current native ACK operation owner may reload/authenticate that
same operation and cursor, require byte-for-byte equality to the captured item,
and then ask the node's actual sender-key custody to sign original admission.
The scope is Sender/Tombstone only, under the same current grant/host, native
target and independently protected operation/replay floors as ordinary ACK.
Missing, rolled-back, corrupt, changed or unanchored state rejects before proof
signing, reservation or effects. A caller flag, SQL absence, signed PRQ2 alone,
or copied unprotected reservation object cannot authorize this path.

The ephemeral evidence is exactly64 Ed25519 signature bytes over
`SHA256(UTF8("deep.mailbox.peer.owned-ack-admission.v1") || 0x00 || exactPRQ2)`.
Its key must equal the original sender descriptor key. It contains no caller
timestamp: original admission is fixed to PRQ2.CreatedAt, joined to the actual
native AcceptedAt above. This artifact-specific signing/verifying purpose is
not a generic restore API and never travels on an HTTP endpoint.

Protocol verifies the complete original request against ACTUAL current policy,
signature/membership/object expiry and this exact source signature. Existing
replay history wins unchanged. Only a missing sender reservation may import
the proven original admission time. Mutation and durable MRR2 still require
actual current native guards/time AFTER this reservation. The receiver accepts
only DR-0147's fully durable PTR1, never this admission-only proof.

No reminted operation ID, nonce, ciphertext or original request; no new journal,
schema, network frame or compatibility reader. Neutral/raw peer requests without
the actual protected ACK owner still cannot acquire stale first reservations.
Node keys, native documents and existing accounts remain unchanged.

## Required evidence

Protocol: exact signing-domain/key/request binding, Store and invalid proof
rejection before reservation, existing-reservation preservation and expiry.
Node: two real targets captured once, first-item transport failure, native cold
reopen and fresh genuine authority after120s, completion of BOTH original items
including the never-reserved one, unchanged batch/quorum cold replay. Missing or
rolled-back operation custody remains a refusal, not repair. Three CLI group
qualification must resume the retained third-member ACK, not replace profiles.
