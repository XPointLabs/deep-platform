# DR-0147 — Exact tombstone forwarding from a durable first replica

Status: accepted pre-production peer-carriage clean break; qualification separate
Date: 2026-10-18
Decision owner: Mr. X (delegated authority)

## Defect and evidence ownership

A captured ACK batch can outlive its dispatch loan before all original PRQ2
tombstones reach the second replica. That replica correctly rejects a first
reservation older than 120 seconds. Repeating the same unaided request cannot
complete it. Do not remint operation IDs/nonces, change original bytes, extend
freshness/object expiry, backdate current authority, or treat local tombstoning
as a two-replica ACK.

The actual sender replica already persists each original replay claim and native
mutation before signing its durable MRR2. It may forward that receipt together
with an additional signature binding the EXACT original PRQ2 and MRR2. This is
historical first-replica evidence, not a claim that the recipient was admitted
at that historical time. Current recipient host/MGR/grant/placement/key/time,
native target, quotas and floor leases are independently required around effects.
No generic restore adapter or caller-supplied admission time is authorized.

## Closed carriage

Peer Store remains raw PRQ2. The existing peer tombstone HTTP route now accepts
only content type `application/vnd.deep.mailbox.ptr1`, frame PTR1:

`ASCII("PTR1") || U32BE(prq2Length) || exactPRQ2 || exactSenderMRR2 || signature64`.

The PRQ2 must be a canonical Tombstone within its existing min/max lengths;
MRR2 has the existing exact Ed25519 replica-response length. No trailing bytes,
optional fields, alternative content types or old raw tombstone HTTP reader.
Signature is Ed25519 by the PRQ2 sender descriptor key over
`SHA256(UTF8("deep.mailbox.peer.tombstone-forwarding.v1") || 0x00 ||
PTR1 bytes excluding signature64)`. The sender checks its actual key custody and
local durable receipt before signing. The receipt must bind the exact semantic
tuple, sender role, Tombstone disposition, valid signature, original admission
within 120 seconds of PRQ2 creation, and durable time between admission and the
current authenticated upper time, strictly before original object expiry.
The outer signature additionally binds nonce, proofs and every original byte.

After all current request and forwarding checks, an existing recipient replay
reservation wins and is checked using actual current time. Only a missing
reservation may import the proven original sender admission time into the
existing replay claim. Its digest/scope/op/expiry/retention remain those of the
exact original request. The native row denotes proven original admission;
local mutation and receipt durability still use actual current lease time.
No new journal format, replacement of an existing claim, Store recovery, or
expired-object admission. Replays still require exact native floors and target.

## Qualification

Sender items not yet visited after a whole native ACK capture use the separately
owned original-admission closure in [DR-0148](DR-0148-original-native-ack-admission.md).
They do not invent a durable source receipt before the actual mutation.

Protocol owns canonical framing, exact signature/receipt/request binding and
no-reservation-on-invalid-evidence cases. Node owns real protected first-replica
custody, current admission, pinned TLS peer forwarding, delayed second-replica
admission, durable quorum and cold replay. Three CLI group evidence must then
complete the original blocked ACK and continue invite/accept/GSR/fanout; source
tests alone do not establish that connected result. All nodes require a
coordinated pre-production update. Clients and node keys do not reset.
