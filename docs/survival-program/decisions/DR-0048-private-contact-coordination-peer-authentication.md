# DR-0048 — Private contact coordination authenticates the calling node

Status: accepted transport contract; XPoint shipping/device composition pending
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

The DR36/DR38 HTTPS backend is a private witness-coordination terminal, not a
direct client fallback. HTTPS and a publisher signature do not authenticate
the forwarding node. Require independent node proof of possession at both V2
terminals, before decoding a body or entering issuance. Do not add a shared
bearer secret, root signing key or another identity/crypto stack. Use the node's
existing independent Ed25519 registration/peer key; no conversion from BLS or
X25519 and no node re-registration/reset.

Four single-valued canonical HTTP headers are required:
`Deep-Coordination-Node` (lowercase hex32 bytes),
`Deep-Coordination-Timestamp` (positive canonical decimal i64 Unix milliseconds),
`Deep-Coordination-Nonce` (lowercase hex16 nonzero bytes), and
`Deep-Coordination-Signature` (lowercase hex64 nonzero bytes).
Unknown casing of hex, duplicate values, malformed/absent fields and a node not
in `ContactCoordinationIngress:AllowedNodePublicKeysHex` reject with empty 401.
The operator-scoped allow-list is transport access only, not authoritative NET
membership, placement, publisher, identity, time or witness evidence. It is
mandatory nonempty (1..256 distinct nonzero public keys) when either terminal
is enabled. Disabled hosting remains unavailable. Do not permit a test/prod
configuration flag to bypass node authentication.

The exact Ed25519 signing input is ASCII
`Deep/ContactResolver/V2/private-coordination-peer` then zero, u16be(2),
network16, target-u8 (route1/publication2), calling node public key32,
timestamp-i64be, nonce16 and SHA256(exact request body)32. Target corresponds
only to the fixed V2 path; no query, arbitrary URL, mutable header or routing
hint enters it. Headers from one target/network/body do not authorize another.
Wall-clock skew must be at most 30 seconds, solely for transport admission;
it never establishes protocol trusted time. Body length/type still obey each
existing frozen terminal, and publisher/DID2/route/NET/floor/witness checks
remain mandatory after authentication.

Each actual forwarding attempt creates a new transport nonce/signature, while
the client journal's exact request/coordination nonce/operation stays unchanged.
Transport retry never creates a new publisher intent or changes its signed
timestamps. The permanent DR36/38 request journals remain the authority for
exact replay/conflict and signer-side effects; a transport nonce does not replace
them or authorize mutation. Repeating an admitted request cannot remint its
durable winner. Authentication alone grants no ACK or dispatch capability.

The node-side backend client uses one operator-configured HTTPS origin and
only the two fixed paths/media types, platform TLS validation, no redirects,
bounded bodies and one 30-second attempt. It owns request bytes across awaits,
authenticates with the existing node key and independently pairs returned
envelope network/nonce. The shipping client never receives this backend origin
or node signer. Only a future verified XPoint terminal composition may call
this backend; no public direct Registry fallback is activated by the helper.

Acceptance: real node signature admitted; missing/unknown/duplicate/noncanonical,
expired or substituted network/target/body signatures reject before issuer;
both terminals fail closed without access configuration. Existing durable issuer
tests must authenticate their TestServer calls. Public API/package repin and
socket TLS/three-hop/device evidence remain final business-batch gates.
