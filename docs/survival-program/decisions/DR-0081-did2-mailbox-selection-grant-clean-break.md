# DR-0081 — issuer-bound mailbox selection, without recipient identity

Status: accepted pre-production wire/API clean break; implementation and activation gated
Date: 2026-10-03
Decision owner: Mr. X (delegated architecture authority)

## Cause and selected contract

DR-0080 identified an actual connected-contract gap: XRA1 tag6/PMS2 tag3 is
the independent random selection input, while XRC1/XRR1 tag10 is the blinded
deposit placement. A valid MCG2 authenticates the latter's commitment but not
the former. A node cannot recover PMS2 ranking from MAU2. Transport authentication,
an unsigned client replica list or a new hash of the placement cannot repair it.
Sending XRA1/XRC1 to mailbox nodes would also expose prohibited device references.

Replace the grant/presentation/client envelope with **MCG3/MCP3/MAU3** and the
acquisition result with **XMC2**. Do not keep a V2 encoder, reader, alias, migration,
fallback or positive historical corpus. XMG1 remains the unchanged opaque
acquisition request: its independently verified exact current PMT2 names the
root-signed PMA2 policy selecting the new algorithm. The root identity, current
network verifier and signed PMS2 rendezvous algorithm do not change.

PMA2 tag9 now allocates algorithm profile `2=MAU3/MCG3-selection-bound` for this
generation. Profile1 never authorizes a new grant/request; it is not a fallback.
An operator must issue a properly root-signed PMA2 successor and matching PMT2
successor from retained lineage. Editing an installed signed record, resetting
genesis/floors or silently changing the meaning of profile1 is forbidden.
Historical signed PMA2 lineage may be parsed solely by its historical verifier;
it cannot mint current host, holder or dispatch authority.

## Exact grant and holder framing

MCG3 has version byte3 and exact length304. Its first208 bytes use the existing
field widths/offsets, with magic MCG3 and version3. The added mandatory nonzero
`selectionInput32` occupies offsets208..239; issuer signature64 occupies
240..303. It is the exact verified route's PMS2 tag3, never account-derived,
randomly substituted or recomputed from blinded placement. The unsigned grant
is240 bytes. Role signing tags are the exact16 bytes
`DEEP-MCG3-DEP` plus three zero bytes and `DEEP-MCG3-RET` plus three zero bytes,
followed by those unsigned grant bytes. Role separation, random independent
holder, random serial16, active lifecycle, generation and full validity checks
remain mandatory. Ed25519 and SHA-256 are unchanged primitives.

MCP3 has magic MCP3, version3, length440. Its first72 bytes retain the typed
operation/operationId/counter/requestDigest/reserved/embedded-length layout;
embedded grant length is304 and exact MCG3 occupies72..375. Holder signature64
occupies376..439, signing the exact376-byte unsigned presentation after the
operation tag. Store/Retrieve/Ack tags are respectively the exact16 bytes
`DEEP-MCP3-STR`, `DEEP-MCP3-GET`, `DEEP-MCP3-ACK`, each plus three zero bytes.
No signature on old magic/version or old signing labels transfers to V3.

MAU3 has magic MAU3, version3 and the same16-byte bounded header layout; its
presentation-length field is440. The only inner bodies remain canonical
MEO1/MBR2/MBA2 and their existing typed digest domains. This is not an optional
extension or a second parsing branch. Reject MAU2/MCP2/MCG2 before callbacks or
mutation, including cross-fed V2 magic/version and hostile nested lengths.
The entire new grant, including selector, is authenticated by the holder.

XMC2 retains the closed eight-tag CONTACT-CODEC envelope and version1/suite0201
tagged grammar. Non-success is206 bytes and empty tag8; success is510 bytes
with exactly one304-byte MCG3 in tag8. Tag5 still binds exact XMG1, tag7 still
binds exact complete route closure, and the original request expiry is retained.
No old XMC1 result is decoded or converted. Request, route and winner custody
must verify selector equals PMS2 tag3 in addition to the existing current root,
full interval, placement, membership, epoch, role, issuer and holder bindings.

These allocations are FROZEN_TARGET_NOT_ACTIVE. Machine registry/schema/vectors,
generated identifiers, actual assembly/API/resource review and consumer repins
must agree before shipping. This decision supersedes only the V2 neutral grant/
presentation/envelope/result choice in DR52–59 and the corresponding repository
ADRs; their ownership, privacy, exact retry, durability and time fences remain.

## Node and peer authority

The current closed host verifier independently verifies MCG3 under the current
PMA2 profile2 and exact PMT2, then recomputes selected node IDs with PMS2's
existing algorithm using the signed selector. An exit must be one of those
nodes. Canonical XND node ID and identity/receipt Ed25519 key remain distinct;
installed signing custody must match that actual descriptor key, never a
caller-provided key or a node-ID/key alias.

Reuse the neutral PRQ2/MRR2/MQR3/MAR1 persistence and signature framing with a
single DID2 proof profile. In each bounded MIP1 opaque proof field, require
exactly `PMT2 ArtifactRef38 || exactMCG3[304]` (342 bytes). Both proofs in one
request contain the same grant. The complete current NETCODEC roster authenticates
membership directly; no P04/MRL1/RIP1 authority or synthetic Merkle path is used.
The closed verifier checks current projection reference, full grant interval,
expected Store=Deposit or Tombstone=Retrieve role, exact body-derived placement
commitment, signed selector, selected node ID, descriptor receipt key, epoch and
membership. The proof is not trusted because a parser or TLS accepted it.

Peer operation/body/placement matching and source signature verify before replay
reservation. Authenticated proof time comes from the host's protected monotonic
authority, never a caller-supplied `verificationTime` or host UTC. Refresh and
recheck after external callbacks and before durable mutations/receipt release.
Expiry during a durable reservation leaves outcome unknown/pending; it does not
authorize dispatch, fabricate a receipt or erase the reservation. Revocation,
capacity and existing exact durable replay/read-back checks remain mandatory.

The current two-replica peer/quorum profile activates only for an exact current
PMT2 replication factor2. A different factor stays unavailable rather than
silently taking two of a larger selected set. Three production nodes still
participate in each exact-three privacy path; this is not a six-node claim.

## Connected implementation and rollout gate

Change issuer/result verification, protected client grant/request installation,
selected-entry Store/Retrieve/ACK, node admission/replay, peer proof/fanout and
receipt verification as one business batch. Existing incomplete/older custody
rejects explicitly; no repair or holder/key/nonce remint by a reader. Remove
retired PMA1/P04 production mailbox composition, not just its enabled flag.

Run actual signed positive and malformed/cross-feed/scope/expiry/replay/crash
tests for the connected slice before the final full package/API/evidence gates.
Then provision matching signed successors and current bundles through approved
operator tooling, retaining registered node keys, root genesis, external floors,
nonce/issuance journals and infrastructure configuration. An earlier denied
export must not be retried through another tool or wrapper. A source-only
implementation is not a deployed image, issuer activation or physical delivery.
No release approval until real Windows/USB Android contacts/acceptance, two-way
text, remote file/image integrity, governed groups and recovery pass E2E.
