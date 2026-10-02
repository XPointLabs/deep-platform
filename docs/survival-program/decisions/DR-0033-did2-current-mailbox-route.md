# DR-0033 — DID2 current mailbox route authority

Status: accepted API extension; durable publication/grant/shipping gates remain
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

The route is verified directly against nonce-bound current DID2 DAB2/DMD1/DCA1
authority. Never wrap it in DID1 VerifiedContactNetworkAuthority or create a
synthetic DID1 identity. XRA1/XRR1/XRC1/XSS1/PMT2/PMS2 retain their separately
versioned identity-neutral bytes/domains under DR-0004. Only the already frozen
611-byte XIR1 V2, with exact DCA1 V2 reference, is accepted as the invite.
The six-record route framing remains unchanged; it does not contain XIR1.
This genesis increment retains the currently frozen 550-byte XRA1 and its
30-day wire bound, with XRC1 capped at 24 hours and the current signed network/
traffic-key intersection. It does not implement DR-0004's future 400-day
offline-refresh/successor retention target; that target must receive its own
exact authority/grammar freeze rather than silently extending these bytes.

Freeze the public closed `VerifiedDeepIdV2ContactRouteClosure` and
`DeepIdV2ContactRouteVerifier.VerifyAsync(DeepIdV2CurrentContactAuthorization,
VerifiedOnionNetworkContext, VerifiedXPointNetworkAuthority, exactXir1V2,
exactSixRecordClosure, OnionTrustedTimeAuthority, cancellationToken)`.
The result exposes immutable exact invite/route records and verified network/
recipient authorities. Its asynchronous currentness check rechecks protected
monotonic time, complete validity and both proof/network freshness. Raw bytes,
keys, clock readings, parsed identity or witness callbacks alone cannot mint it.

Require exact common current ADH1, XNA1/witness policy and XNV1 authority,
not identical own/recipient proof nonces or DTT1 hashes. Both proofs must be
live on the same protected boot. Conservatively cover the union of their
projected trusted-time intervals, all route artifacts, root/network/directory,
device and DCA1 validity. Verify exact PMT2 against the network capability,
deterministic PMS2 selection, XRC1/XSS1 current references and every threshold
signature with current XNA1 witnesses and distinct failure domains. Independently
verify current device signatures for XIR1 V2/XRA1/XRR1. Bind deposit capability,
quota, anti-spam, sealing key and exact device/delegation references throughout.

Freeze `DeepIdV2ContactRouteAuthor` three phases: owned-device genesis XRA1
advertisement, current-directory threshold PMS2/XRC1/XSS1 authoring, owned-device
XRR1/XIR1 V2 completion. Inputs require the same closed DID2/network authority;
owned device secrets never expose a generic signing operation or raw scalar.
An advertised sealing public key is independent from device agreement and
must pass X25519 low-order rejection. Validate threshold signer identities,
unique failure domains and exact returned signatures before releasing records;
recheck continuous protected time after asynchronous signing. A parsed/authored
advertisement or threshold response is not a complete route capability.

Exact author API surface (all async methods accept a final cancellation token):
`AuthorAdvertisementAsync(currentAuthorization, network, networkAuthority,
OwnedGenesisDeviceSecrets, maximumAcceptedHellos, antiSpamPolicyHash32,
metadataKeyId32, metadataX25519Public32, issuedAt, expiresAt, trustedTime)`
returns `ContactRecord` (XRA1 candidate).
`AuthorThresholdAsync(currentAuthorization, network, networkAuthority,
exactXra1, IReadOnlyList<IContactRouteAuthorityWitnessSigner>, issuedAt,
expiresAt, trustedTime)` returns `ParsedDeepIdV2RouteThreshold`.
`CompleteGenesisAsync(currentAuthorization, network, networkAuthority,
OwnedGenesisDeviceSecrets, exactXra1, ParsedDeepIdV2RouteThreshold,
minimumReader, trustedTime)` returns `VerifiedDeepIdV2ContactRouteClosure`.
`ParsedDeepIdV2RouteThreshold` accepts only bounded exact PMS2/XRC1/XSS1;
its public constructor grants parsing, never verification or threshold authority.

The private directory-witness coordination boundary verifies exact authorized
device evidence already owned by the directory. Public routers/storage nodes
receive only encrypted frames/random service capabilities, never device/DCA
evidence or sealing private keys. The former ambiguous prohibition on sending
XRA1 device fields to a "route service" refers to the public storage/routing
plane, not the private directory-witness authoring boundary. No direct public
Registry mailbox issuance or steady-state message routing is introduced.

This adds Protocol APIs and corresponding consumer rebuild/repin requirements,
not account-schema migration or wire compatibility. Existing V2 stores do not
reset for this API increment. Genesis authoring is not durable exact retry,
successor custody, publication or XMG1/XMC1 issuance. Shared must adopt exact
metadata/records before network publication and recheck account/protected floor
under its lease before dispatch. No parsed route grants semantic ACK, accepted
contact, attachments/groups, or physical Windows/Android delivery.
