# DR-0024 — DID2 account-owned read-only initial claim preview

Status: **accepted bounded API; runtime activation gated**
Date: 2026-09-30
Decision owner: **Mr. X** (delegated architecture authority)

Freeze `OwnedGenesisDeviceSecrets.PreviewInitialClaimAsync` with exact decoded
DPH2, current DID2 recipient/initiator proofs, a current verified exact DPK2
offering, restored opaque DPK2 secret capability, protected trusted time,
bounded PQ-injection policy and cancellation. Own the current device's key
inside Protocol; never export its scalar or return a responder factory. Require
both current proofs, exact DPH2 initiator DID2/device/directory and exact owned
recipient account/device/signing/agreement key. Reverify DPK2 selection/time
before and after preview at continuous protected samples. Boot change,
backwards time, expiry, mismatch or cancellation returns no preview.

The result is the existing AEAD-opened but unverified `Dph2InitialClaimPreview`:
only XPK1/XPC1 prefix evidence, no application plaintext, handshake/session
authority, inventory reservation/burn, TRS1, inbox or ACK. Current V2 promotion
and atomic responder custody remain mandatory separate boundaries. Wire and
crypto domains do not change; no V1 current-proof adapter is accepted.

Shared `DeepIdV2AccountService.PreviewOwnDph2InitialClaimAsync` owns bounded
DPH2 bytes before awaiting, derives fresh recipient authority from its exact
account-bound path source, independently rechecks the initiator proof, and
holds the process-independent account lease through local secret use. The V2
inventory owner opens only the protected-tip-verified current SQLCipher store,
selects the byte-identical DPK2 by the header's exact hash, rechecks current
recipient authorization, and restores one opaque preview-only copy through
Protocol's authenticated persistence protector. No raw secret is returned.
No schema migration, mutation of inventory or repair of missing custody is
authorized. Exact retry may read the same retained key without spending it;
only later verified reservation/atomic completion may consume inventory.

This is the bounded receiver prerequisite for the coherent contacts/messages/
attachments/groups batch, not device E2E or release readiness. The normative
semantics remain [CONTACT-RESOLVER-V1 section 3.4](../../architecture/CONTACT-RESOLVER-V1.md#34-atomic-pre-key-claim-xpk1--xpc1)
and the durable completion owner in DR-0017/DR-0020.
