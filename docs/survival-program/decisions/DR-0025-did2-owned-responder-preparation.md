# DR-0025 — DID2 owned responder preparation and atomic-store handoff

Status: **accepted bounded API; durable/runtime activation gated**
Date: 2026-09-30
Decision owner: **Mr. X** (delegated architecture authority)

Freeze `OwnedGenesisDeviceSecrets.PrepareInitialSessionAsync` taking the
DR-0017 verifier-minted `VerifiedDph2InitialClaim`, independently current DID2
recipient/initiator proofs, an exact restored opaque DPK2 capability, protected
trusted time, bounded PQ-injection policy and cancellation. No raw device
scalar, generic callback or responder factory may escape. Require exact
current owned recipient keys, exact current initiator DID2/device/directory,
current DPK2 selection and the original receipt's complete current interval
before and after cryptographic work at continuous protected samples. Reverify
the receipt's exact DCA1 against the independent current recipient proof too:
an unexpired older receipt/proof cannot hide a newly revoked authorization.
If the authenticated first event is ContactHello, also require DR-0022 current
endpoint metadata before minting the preparation. This is still not contact
acceptance, route validity or durable inbox authority.

Bind the two independent claim lanes once inside this boundary. Return only
closed disposable `ResponderInitialSessionCommitCapability`, exposing public
session/operation identifiers. `ConsumeForAtomicStore()` transfers once a
disposable `ResponderInitialSessionAtomicStorePayload`: authenticated exact
TRS1, SessionInit and optional first DMC2 plus the matching verifier-minted
device-prekey reservation facts. No public constructors or independently
supplied plaintext/state/reservation are accepted. Rejection/cancellation
disposes all untransferred material; capability and payload disposal erase
secret state. This is preparation, not an inventory burn, durable session,
contact acceptance, semantic inbox or ACK.

Shared must call this only inside the account lease with protected-tip-verified
opaque inventory custody and transfer directly to an authenticated atomic
responder store. Before storage, current ContactHello metadata (DR-0022),
reservation/replay rules, durable rollback protection and semantic inbox
binding remain mandatory. There is no public Shared prepare-to-UI API.
No wire/crypto domain or schema is changed by this preparation API. Atomic
responder custody, live publication/route, shipping composition and physical
delivery remain gates. Rebuild/repin Protocol and Shared together; no old
device/account adapter or migration is introduced.

Normative owners: [DR-0017](DR-0017-did2-initial-claim-promotion.md),
[DR-0024](DR-0024-did2-owned-initial-claim-preview.md), and
[CONTACT-RESOLVER section 3.4](../../architecture/CONTACT-RESOLVER-V1.md#34-atomic-pre-key-claim-xpk1--xpc1).
