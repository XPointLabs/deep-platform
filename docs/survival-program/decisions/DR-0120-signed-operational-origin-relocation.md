# DR-0120 — signed operational origin relocation

Status: accepted additive producer API; runtime/device activation pending
Date: 2026-10-15
Decision owner: Mr. X (delegated architecture authority)

## Boundary and exact API

The existing XND1 successor grammar permits changed origin addresses/ports while
retaining network, node, identity and staking lineage. No record, field, domain,
suite, carrier, signature purpose or local-state generation is allocated here.
The sole semantics owner remains [XPOINT-NETWORK](../../architecture/XPOINT-NETWORK-V1.md).

`XPointNetworkOperationalOriginRelocation(ReadOnlySpan<byte> originId,
System.Net.IPAddress address, ushort port)` is a sealed untrusted intent type.
Its read-only properties are `ReadOnlyMemory<byte> OriginId`,
`byte AddressFamily`, `ReadOnlyMemory<byte> Address` and `ushort Port`.
ID/address bytes are copied; IPv4 occupies four octets plus twelve zero octets,
IPv6 occupies sixteen. ID must be nonzero32, address nonzero, port nonzero;
null/unsupported address families and nonzero IPv6 scope IDs reject. Returned
byte memories cannot mutate the captured intent.

The single `XPointNetworkOperationalNodeRollover` constructor appends
`IReadOnlyList<XPointNetworkOperationalOriginRelocation>? originRelocations = null`
and exposes its captured read-only `OriginRelocations` list. Null/empty means
retain the already authenticated predecessor origins, not a compatibility reader.
At most16 unique non-null intents are allowed. No old constructor overload,
raw record setter, endpoint callback or client translation is introduced.

Both root-authorized and delegated successor authoring authenticate the exact
protected predecessor and complete signed prefix before any signing callback.
Every intent must name one existing origin of its own identity-signed predecessor;
unknown/duplicate IDs and collisions of effective `(transport,family,address,port)`
across the complete node set reject before callbacks. Original origin IDs,
transport, count/order, node/role identities, staking lineage and all existing
key/pin activation rules remain. Address changes do not authorize new traffic
keys, mailbox policies, placement epochs, grants or floor resets.

The canonical successor is signed by the same node identity and committed in the
existing XNV1/XNH1/PMT2 closure. Authored bytes are not verified authority or
runtime readiness. Ordinary renewal with no intents retains the committed new
addresses after a relocation; there is no fallback to predecessor locators.

## Provisioning and evidence

The operator must stage matching listeners, reachable ingress, TLS SAN/chain/
revocation and peer configuration, then commit the complete signed successor
through the existing retained journal/CAS workflow. Private keys, genesis,
directory/network/role floors, registered identities and retained histories stay.
Partial installation fails closed; retry resumes the same sealed candidate.
An unreachable signed Docker endpoint is not repaired by rewriting the client's
sealed plan, relaxing TLS/pins or silently switching transport profiles.

Required source cases: actual signatures and warm/cold consumer verification for
IPv4/IPv6 relocation; subsequent no-intent renewal; retained namespace/epoch and
identity invariants; mutable caller buffers/list; bounds, duplicate/unknown IDs,
endpoint collisions and hostile predecessor rejection before signer callbacks.
Required runtime cases separately cover strict Windows/Android access, interrupted
installation, retained peer/client intent and same-volume restart. None is implied
by parser, build, source fixture or health success alone.

Downstream producers must recompile/repin the changed constructor ABI together;
consumers must qualify the signed successor with the existing canonical verifier.
No account/node/trust reset or public release is authorized by this API decision.
Current stage and remaining qualification belong to [NEXT-SPRINT](../../NEXT-SPRINT.md).
