# DR-0149 — Stable private mailbox-grant intent scope

Status: accepted,2026-10-19. Owner: Mr. X (delegated pre-production decisions).

## Evidence and decision

Real CLI GSR candidate16 stopped on grant acquisition. The Registry first
reserved the original request, then correctly rejected release when the signed
current view changed. Its exact retry incorrectly conflicted forever because
the permanent scope incorporated the current DNH2 checkpoint. Identity and
fresh authorization must be separate; retries must not delete or rewrite the
reservation, extend a deadline or bypass current authority.

The private v2 scope is SHA-256 over
`Deep/Registry/DID2/grant-journal-intent/v2 || 0 || U16BE(evidenceKind) ||
U64BE(readUntil) || exactVerifiedEvidenceTuple`.
Current-route kind1 uses the existing139-byte tuple and zero readUntil;
retained-read kind2 uses the existing136-byte tuple with its exact positive
readUntil. The tuples already bind the exact holder-signed XMG2 request hash,
locator/capability/role, exact original route and effective/retained horizon.
Network ID and original namespace/route intent are inside those bindings.

Live root/time-policy/PMA2/observer/network checkpoints are not inputs to this
permanent identity. They are still independently authenticated by the existing
issuer context, closed Protocol issuance verifier, both replica signatures,
current forwarding membership/signature/nonce and all pre/post-signing,
pre/post-journal and release fences. No hash is an issuance capability. A
changed view during a callback still rejects release; a later actual-current
retry may complete the same immutable intent. Existing exact winners remain
immutable and must pass current Protocol verification, never sign again.

## Cutover and boundaries

This is a private hash-identity clean break, not a new XMG2/XMC2/MCP3 format,
endpoint, SQL schema or issuer key. The existing journal's conflict guard and
permanent rows/capacity remain unchanged. Old incompatible scope hashes remain
unavailable: no old hash reader, conversion, deletion, reservation rewrite or
recovery assertion. Separate QA candidates may exercise new v2 intents while
old failed candidates remain preserved. Production/state rollout is separate.

Authority-scope wording in DR-0104 means the immutable request/evidence and
original route namespace, not a transient verification checkpoint. This
clarifies that boundary without relaxing any currentness predicate.

Acceptance requires hash separation/bounds tests, actual PostgreSQL pending
reservation/concurrent exact winner/cold replay/conflict/corruption tests,
actual current and retained issuer HTTPS/Protocol/role-signing tests, then real
three-CLI contacts/groups/messages. A source PASS alone does not close S11,
first-attempt reliability, long-offline recovery, device E2E or release gates.
