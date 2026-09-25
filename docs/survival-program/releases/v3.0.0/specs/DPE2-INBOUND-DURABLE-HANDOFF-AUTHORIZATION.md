# DPE2 inbound durable handoff authorization

Status: frozen for the preproduction clean break, 2026-09-21.

Decision authority: Mr. X, sole production owner, through delegated CTO and
architecture authority for this release. No deployed user state is supported.

## Authorized surface

The trusted `IExactDpe2DurableTransactionAuthority` may read a defensive copy
of canonical authenticated DMC2 from a fresh receive
`ExactDpe2DurablePersistencePlan.AuthenticatedDmc2`. Send and exact replay plans
expose an empty value. This is the sole new public `Deep.Protocol` member in
this authorization; it does not alter any DPE2/DMC2 bytes, domain separators,
registry, vectors, or wire grammar. The exact-three production graph's
positive API snapshot must include this member and no assembly friendship to
`Deep.Client.Shared` is authorized.

The authority already receives secret ratchet state and therefore remains a
trusted, local, device-bound component. It MUST place authenticated DMC2 in
protected recoverable storage in the same durable transaction as the ratchet
receive commit. It MUST NOT publish plaintext to transport, logs, callbacks,
or UI before commit. Mutable buffers owned by the authority MUST be zeroed
after use; managed parse objects remain confined to the trusted process. A replay
may recover the staged exact DMC2 but MUST NOT advance the ratchet again.

Transport ACK remains forbidden until a separate durable semantic inbox
materialization and deduplication succeeds. Staging alone is not ACK authority.
Retention, recovery, and deletion of the staged record require a separately
verified application-inbox handoff; this authorization does not imply that the
current client is release-ready.

## Downstream reset and repin impact

`Deep.Client.Shared` and MAUI production consumers must be rebuilt against the
reviewed exact-three package closure. DPE2 staging entered the local SQLCipher
ratchet schema in clean-break generation 6; later schema generations must retain
the same atomicity and recovery invariant. Earlier local state is not migrated
or silently accepted. No production reset or publication is authorized by this
document alone. Package publication, production cutover, and user-visible
release require their own gates and the user's explicit release instruction.
