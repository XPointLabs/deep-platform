# DR-0063 — mandatory private reply route in contact control

Status: **accepted exact clean-break; connected/device activation gated**
Date: 2026-10-02
Decision owner: **Mr. X** (delegated architecture authority)

Choose one path: Hello and Accept each carry their sender's exact DR-0062
private mailbox package inside authenticated application plaintext. No second
bootstrap RouteUpdate, optional route, legacy reader, resolver bypass or secret
disclosure is authorized.

## Event boundary

Replace DR-0022's fixed payload with the same first678 bytes followed by
`LP32(exactPrivateMailboxPackage)`. Length is at offset678, package at682.
Payload bounds become5,917..25,069; empty-reply DMC2 bounds6,199..25,351.
DMC2 version/suite, sequences, XUR1, safety number, flags and expiry rules
stay unchanged. Old678-byte payload/960-byte record rejects. Existing inner
signatures/domains and cryptographic primitives do not change.

Add mandatory `ParsedDeepIdV2ContactMailboxRoute` immediately after the
inbound rendezvous to both capability-based authors. Raw/test-only payload
factories take an additional mandatory exact package; no old overload remains.
Parsed Hello/Accept expose readonly `MailboxRoute`. The package is immutable
untrusted framing, not publication/route authority. Author and endpoint checks
bind its network/account/device/current DAB2/DMD1 metadata to the sender;
they continue to grant only DR-0022's endpoint-metadata claim. Independently
verify full current DCA signature/revocation, network and route/threshold via
DR-0062 before Shared semantic handoff or transport use.

**2026-10-09 S01 clarification — retained event versus live route.** For an
actual native-committed Hello/Accept, semantic reconstruction authenticates its
exact original route as historical facts under independently current account/
device/network authority. Use the closed DR-0072 predecessor verification; it
returns no live route or dispatch permission. The original native/protected
scope, initial event hashes, exact committed Accept and explicit local acceptance
winner (when applicable) remain mandatory and are rechecked before handoff.
Expiry of that old return publication does not erase already authenticated
contact history or require repeating an initial exchange. Parsed/raw caller
packages are never such retained custody. PMT/device/delegation rollover not
supported by that verifier still rejects; do not invent a historical bypass.
DR-0062's current verifier remains unchanged for new transport use. Current
grant/holder/route admission and retained-route Retrieve/ACK checks are separate
from reconstructing semantic history. No wire, format, public authority flag or
legacy reader is introduced.

Outbound Shared authors use only actual phase-7 own publication under the
held account lease with final exact custody readback. Inbound routes come
only from actual retained authenticated Hello/Accept bound to the current
session peer, never caller/UI bytes. Origin custody, current verification,
grant/holder acquisition, original MAU2 retry and ACK remain independent.
Do not persist verified capabilities or silently change a prepared route.

Existing DPH2 buckets stay unchanged. The shipping initial command must
preflight actual owned Init/Hello plus the bounded16,384-byte claim result,
438-byte request, transcript LP32s and event framing against32,764 unpadded
bytes **before** claiming. Unsupported combinations reject without consuming
a prekey; never drop the route or implicitly extend a bucket. The current
exact-three profile must pass this joined gate. Wider topology/bucket changes
require their own freeze; this makes no larger-topology first-contact claim.

## Protected acceptance clean break

The existing protected accept slot accepts **version2 only**. Keep92-byte
scope header, count/revision and lexicographic ordering. Entries become
`LP32(entry)` with the existing468-byte operation/scope/Hello-hash prefix
and exact variable Accept; bounds6,667..25,819. Cardinality stays128, total
encoded root is bounded at the existing1MiB secure-storage limit. Check
actual bytes before allocation/CAS; never silently evict an exact winner.
Old/missing/corrupt journal or incompatible contacts require explicit isolated
QA reset, not regeneration, migration or dual parsing.

Update handoff/native bounds, parity tests, machine payload bounds/vectors and
anchor together. Reverse Accept Store/Retrieve, retry/fork/clock negatives,
private-route ordinary send, MAUI and physical Windows/Android remain gates.
Review actual API snapshots and repin in the connected business batch.
Node keys, registered identities, genesis and production floors stay intact.

Normative owner: [CONTACT-AND-GROUP-PROTOCOL §8–9](../../architecture/CONTACT-AND-GROUP-PROTOCOL-V1.md#8-dmc2-canonical-application-event).
