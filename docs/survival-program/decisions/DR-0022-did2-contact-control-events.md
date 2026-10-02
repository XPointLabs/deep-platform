# DR-0022 — DID2 contact-control event boundary

Status: **accepted exact boundary; runtime activation gated**
Date: 2026-09-30
Decision owner: **Mr. X** (delegated architecture authority)

Wire length and mandatory author inputs are superseded by
[DR-0063](DR-0063-did2-contact-reply-route-embedding.md). The fixed-length
format below is historical decision context, not an accepted reader or positive
release vector. All endpoint/safety/clock claims not replaced there remain.

## Freeze before implementation

ContactHello and ContactAccept accept only a contact reference encoded as
`ASCII(DAB2) || u16be(2) || exactDab2RecordHash32`. This is the contact
magic/version/hash namespace, not application ArtifactRef type/length/hash.
Their payload lengths remain exactly 678 bytes; offsets, DMC2 version 1,
messaging suite 0x0201, XUR1 bytes, flags, reply and expiry bounds do not change.
DAB1 and wrong-version DAB2 references reject. No compatibility overload,
conversion, positive legacy vector or V1 safety-number author remains.

The safety number uses the existing `DeepIdV2Verifier.ComputeContactSafetyNumber`
contract: both exact genesis-committed PQ DID2 roots and current account roots,
sorted by DPA1 hash under `Deep/Application/V2/contact-safety-number`.
The single semantic owner is
[CONTACT-AND-GROUP-PROTOCOL-V1 sections 8 and 9.3](../../architecture/CONTACT-AND-GROUP-PROTOCOL-V1.md#8-dmc2-canonical-application-event).

## Closed API

Replace the V1 author with `ApplicationCoreCodec.AuthorVerifiedContactHelloAsync`
consuming a DR-0021 verified inbound rendezvous, a current verified DID2
recipient directory proof, exact relationship/logical/conversation IDs,
creation/expiry, policy, trusted-time authority and cancellation. Own caller
bytes before awaiting; recheck both current proofs and issuer/time at final
protected clock sample; boot change/backwards time/cancellation issue no result.

Replace the V1 endpoint checker with
`ApplicationCoreVerifier.RequireContactHelloEndpointBindingsAsync` consuming
parsed Hello, current DID2 initiator/recipient proofs, trusted-time authority
and cancellation. Verify exact DAB2, DMD1, safety number, active sender device,
network, embedded XUR1 current issuer/time and validity at event creation.
The author result and endpoint check grant no DPH2 authentication, placement,
route, acceptance, session, inbox materialization or ACK authority. These remain
independent mandatory runtime gates.

The endpoint check also requires the normative conversation derivation in
section 7 from network, relationship and sorted account roots. Arbitrary
caller conversation IDs are not valid endpoint metadata. Freeze the key-free
`ApplicationCoreVerifier.ComputeContactConversationId` utility for these four
exact byte inputs, retaining the existing domain and 112-byte material; Shared
identifier types delegate to it instead of maintaining a second hash algorithm.

Freeze `ApplicationCoreCodec.AuthorVerifiedContactAcceptAsync` with parsed
Hello, current initiator proof, verified responder inbound rendezvous, exact
logical ID, sender sequence, creation/expiry, trusted-time authority, policy
and cancellation. Its closed result is `AuthoredVerifiedContactAccept`.
Freeze `ApplicationCoreVerifier.RequireContactAcceptEndpointBindingsAsync`
with parsed Accept/Hello, current initiator/responder proofs, trusted-time
authority and cancellation. Both bind relationship/conversation, exact Hello
SHA-256, current responder DAB2/DMD1/device, signed XUR1 and event time, and
recheck both current proofs at the final continuous protected clock sample.
Hello endpoint metadata must independently match the supplied current proofs;
its authenticated pending custody is the runtime's mandatory separate input.
These APIs do not promote parsed bytes to authenticated pending state or
acceptance. Runtime contact state composition remains gated.

## Consumer and evidence consequences

Update only the affected machine grammar and four Hello/Accept payload/canonical
vectors with hashes/anchor together. Protocol owns narrow positive/substitution,
wrong-version, retired-reference, clock and cancellation tests. Shared and MAUI
must consume only this DID2 boundary; the excluded old MAUI source is not a
shipping caller. Incompatible isolated QA contact state requires explicit reset,
not migration. Registered node keys, network genesis and floors remain intact.
Full graph/evidence gates and commit follow the coherent vertical batch;
physical Windows/Android contacts/messages/media/groups remain release gates.
