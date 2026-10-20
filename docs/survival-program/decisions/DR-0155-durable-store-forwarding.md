# DR-0155 — Exact durable Store forwarding and unpaired pre-effect recovery

Status: accepted pre-production peer Store carriage clean break; qualification separate
Date: 2026-10-20
Owner: Mr. X (delegated authority)

The original CLI Store has an exact signed PRQ2 and independently protected
completed mutation at its first replica. The recipient has one unpaired native
Pending, no matching mutation/blob, and no independent floor. That native row
does not prove admission. No account, ciphertext, operation, nonce or expiry
may be replaced to recover this operation.

Peer Store now requires PSR1, content type application/vnd.deep.mailbox.psr1:
ASCII("PSR1") || U32BE(prq2Length) || exactStorePRQ2 || exactSenderMRR2 || signature64.
The signature is Ed25519 by the original sender descriptor key over
SHA256(UTF8("deep.mailbox.peer.store-forwarding.v1") || 0x00 || all preceding bytes).
Lengths use the existing Store PRQ2 bounds plus 8 + exact Ed25519 MRR2 length + 64.
Unknown operations, extra bytes, raw PRQ2 HTTP Store and mismatched media reject.
PTR1 remains Tombstone-only; client and inner PRQ2/MRR2 bytes do not change.

The source signs only after its actual complete native/protected mutation join.
The recipient verifies exact outer signature, inner signature, payload/envelope,
sender-only durable MRR2, complete semantic tuple, original accepted time within
120 seconds of creation, accepted <= durable <= actual current upper time and
durable < original expiry. Full independently current grant/MGR/host/placement,
keys, time and quotas remain required; historical proof never extends expiry.

Authenticated existing independent floors always win. With authenticated absence
of the selected floor, a source-proven original may prepare its sender admission
time. A SINGLE unpaired Pending may be reconciled only if every immutable field
matches that exact request, it has no response, and its native mutation target
and blob are absent. All other native files and independent facts must join.
The new independently protected pre-intent precedes native reconciliation. Only
the unauthenticated reservation timestamp may be corrected to the proven source
admission; it is not a claim of historical recipient admission. No file deletion,
adoption of unpaired history, completed-row repair or bulk restore is authorized.

Crash after protected preparation but before timestamp reconciliation is an
ordinary DR-0154 prefix: bounded matching against the protected original digest
allows only the same Pending claim. Completed/mutated floors, conflicting request,
missing protected history or changed source proof fail closed. Readiness cannot
invent proof or carry out this exceptional source-authorized transition.

Protocol APIs: CreateDurableStoreForwarding, DecodeForwardedStoreRequest,
PrepareForwardedStoreReservation and PrepareForwardedStoreRecovery. The latter
is a closed non-mutating preparation, NOT permission to omit native recovery.
MailboxWireFrame.Psr1=12. All three nodes must update together. No new keys,
schema generation, compatibility reader, lifetime extension or client reset.
Require malformed/signature/role/expiry negatives, both crash prefixes, cold
replay, refusal with any native effect, and recovery of the real original CLI
Store before running a new strict three-CLI round.
