# DR-0053 — DID2 mailbox grant restart custody

Status: accepted API/local custody contract; shipping/device gates remain
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Keep the neutral XMG1/XMC1/MCG2 bytes. Freeze direct DID2 pending-request
restoration in `DeepIdV2MailboxGrantRequestAuthor.RestoreDepositAsync` and
`RestoreRetrieveAsync`: accept the independently current route, expected
locator, expected holder public key, exact retained request and (Retrieve only)
owner capability. Own bounded inputs before awaiting. Verify the exact holder
signature, network, role, capability, PMT2 reference, PMS2 hash, locator and
holder. The whole authenticated interval must still lie inside the original
request window. Restore never signs, changes a nonce/window or renews custody.

Freeze `DeepIdV2MailboxGrantResultVerifier.VerifyRetainedSuccessAsync` with
current route and exact retained XMG1/XMC1/PMA2. Recheck all request/result and
route bindings, historical envelope consistency and the independently current
root-authorized issuer/topology/grant interval. Do not treat expired historical
acquisition envelopes as present dispatch permission, or apply their 120-second
window to an already issued grant. This returns evidence only, not proof that
these bytes were previously persisted or permission to use a holder.

Shared owns one mandatory protected grant journal initialized atomically with
the SQL instance and all other roots before account publication. Missing,
foreign or malformed custody requires explicit disposable-QA reset, not repair.
The header binds network/account/SQL instance; entries are sorted, unique and
bounded to 128. Each scope is SHA-256 of a local domain label, exact route
closure hash, locator and role. Random independent Ed25519 holder seed and exact
XMG1 are committed and read back before transport. Only two phases exist:
pending request and verified exact success. A winner is immutable; retry uses
the same seed/request and revalidates the read-back winner. Failed/unknown
transport leaves pending intact. Expired pending fails closed; renewal is a
separate explicit lifecycle, never silent replacement. Entries cannot evict
active custody to bypass capacity. The journal never stores recovery/device
keys and never exports its seed or signer.

The account owner holds its actual lease through current own/peer proof and
protected floor checks, journal CAS/read-back and private selected-entry
transport, loaning that actual lease to onion guards/entropy. Deposit scope and
locator derive from a freshly reverified permanent-contact result, not UI
arguments. Root-authorized current PMA2 is independently rechecked before and
after callback and before return. Persist only a freshly verified success;
always restore/reverify the persisted winner before returning. No callback or
raw parser mints dispatch, contact acceptance, session, delivery or ACK.
Retrieve must use the protected publication's owner capability, not a caller
secret. The internal transport seam is not a public direct-Registry fallback.

Implement the connected owner and restart/fault coverage before claiming this
local increment complete. Private live issuer, matching bundle rollout,
credential installation, full machine/API bindings and physical Windows/Android
contact/message/file/image/group E2E remain required in the same business batch.
