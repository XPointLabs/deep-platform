# DR-0049 — DID2 coordination on the existing exact-three XPoint carrier

Status: accepted clean-break contract; shipping/device activation remains gated
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Choose the existing XPoint three-hop profile permitted by Account Directory
section 2 metadata rules. Do not pretend RFC9458/OHTTP exists or introduce a
second crypto/HTTP stack. XPoint ingress sees source IP, not publisher body;
exit/coordinator sees publisher body, not source IP. Existing collusion/timing
non-claims remain. No client URL, Registry fallback, new root secret or key
conversion is allowed. The private exit-to-Registry leg obeys DR48.

Allocate `XCA2` request and `XCS2` response in ContactResolve operation4, not a
new outer ONION operation. Each wrapper is `magic4 || version:u16be(2) ||
target:u8(route1/publication2) || reserved:u8(0) || total:u32be || exactBody`.
No other fields, flags, padding, target or trailing bytes exist. Body is the
exact DR36 route or DR38 publication envelope. Request bounds are route1,163
or publication23,314..155,222. Success bounds are route2,163..11,091 or
publication14,694..93,104. Before allocation, enforce target-specific bounds;
decode the entire canonical enclosed envelope. Response target, network and
coordination nonce must match the exact request before ONION sealing/opening.
Witness/publisher/placement/freshness verification remains independent after
structural parsing. These parsed wrappers grant no signing or dispatch authority.

Increase the ContactResolve request ceiling to155,222, preserving each other
sub-operation's own closed limits and the existing131,072 success ceiling.
Outer ONION1..5 wire, keys, domains, entropy, replay and three-hop roles do not
change. Allocate ContactServiceRequestKind.CoordinateContact=8 mapped to the
existing InviteResolver service class1. Derive the random gateway shard from
the enclosed XRA1 tag6, PMT2 reference from its tag5 and expiry from route XRA1
tag13 or publication envelope expiry. Gateway placement is NOT the selected
mailbox route and grants no invite-storage authority. Client and exit derive
it independently from current verified NETCODEC, require the exact PMT2 and
current full validity interval, and select an exit inside its ranked replica
set. The exit cannot trust a requester node list, URL, view hash or clock.

Protocol owns `ContactCoordinationOnionCodec` and sealed parsed wrappers with
internal constructors, defensive copies, exact target/body/header validation
and request-paired EncodeResponse/DecodeResponse. Shared derives canonical
gateway facts from these wrappers, obtains one Protocol-minted placement and
uses the existing guards/selected-entry factory and mandatory entropy ledger.
XNode dispatches only an actual VerifiedCanonicalOnionRequest under operation4;
after independent current gateway placement verification, it calls the fixed
private DR48 backend once and seals the paired XCS2. Disabled composition
rejects before forwarding; post-forward failure is outcome-unknown.

Owned route/publication orchestration already holds the actual account lease.
Its transport MUST NOT reacquire it via fresh account proofs or ordinary
guards/entropy stores. Borrow that exact internal HeldDeepIdV2AccountLease,
verify expected owner/instance, retain its lock across asynchronous custody
transactions, and recheck active ownership before releasing results. Reuse
the already independently verified held-operation NET context, not a stored
proof or raw caller metadata. No public skip-lock/reentrant flag, ambient
ownership, migration, lazy repair, synthetic trusted context or bool seam.
Default ordinary stores still acquire their own lease; borrowed stores reject
after owner disposal. The parent retains its existing before/after proof,
clock/floor/custody and exact journal read-back checks.

Freeze machine inputs before codec implementation. Narrow connected tests
must cover canonical two-target wrappers, unknown/version/reserved/size/network/
nonce/target/trailing substitution, cross-operation rejection before replay,
real guarded entropy/held-owner disposal and no recursive lease acquisition.
Full default API/package/vector/recovery gates, actual socket TLS/three-host
transport and complete Windows/USB Android contacts/messages/assets/groups
remain the business-batch endpoint, not inferred from local transport tests.
