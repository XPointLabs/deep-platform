# DR-0071 — DID2 reachability advertisement successor

Status: accepted API increment; complete renewal and device activation gated
Date: 2026-10-02
Decision owner: Mr. X (delegated architecture authority)

The retained physical Android account reaches the signed XRA1 expiry gate.
DR51 must not repair this by reset, replacing its genesis intent, replaying an
expired request, changing trusted time or creating another generation-zero
publication. Complete renewal must retain the predecessor and atomically adopt
a verified two-replica successor. This decision authorizes only the first
artifact-specific authoring increment; it does not activate that workflow.

Freeze `DeepIdV2ContactRouteAuthor.AuthorAdvertisementSuccessorAsync` with
current DID2 authorization, verified network and XNA authority, owned device
secrets, exact predecessor XRA1, anti-spam hash, sealing-key ID/public key,
expiry, protected trusted-time authority and final cancellation token. It
returns an XRA1 candidate, not a verified route, publication or grant.
There is no caller-issued timestamp, generic signer or historical authority
capability. Existing XRA1 bytes, version, signature/core domains and 30-day
wire bound do not change.

Own bounded input before asynchronous callbacks. Authenticate the exact
predecessor device signature and its network, PMT2, active publisher/device
certificate and current DCA validity scope. Its issue time must not be in the
future. Only this predecessor check may accept past expiry; ordinary proposal,
route, threshold, resolver, publication and dispatch checks remain strict.
The predecessor is not returned as current authority. A changed PMT2/device
requires separately specified rollover, not retargeting this lineage.

Preserve network, authorization ID, exact PMT2 reference, random placement
input, operation class, quota and recipient device/reference. Increment the
generation exactly once; tag 4 names the predecessor core hash, not its wire
hash or a caller hash. Derive issue time from the conservative current trusted
interval. Expiry must strictly advance the predecessor expiry, cover the whole
current interval and remain inside the current device/DCA limits and wire
bound. Only lifetime, anti-spam and sealing material may change. Reject overflow,
forged/malformed/future predecessors, unrelated signing custody, low-order or
device-reused agreement keys, cancellation and clock discontinuity. Independently
verify the new signed candidate again at the final clock sample.

Shared owns the next protected pending successor/CAS and exact retry increment.
Private threshold coordination needs an explicit predecessor-bound extension;
the existing genesis author must continue rejecting nonzero XRA1 generation.
XRC1/XSS1, XRR1/XIR1, DCB1/DCR1, XPA1 and two-store commit lineage must then be
closed together before replacing the retained current publication. Unknown
completion retains exact pending bytes and never remints the same nonce.
Expiry-gap recovery, PMT/view/key rollover, capacity/retention and abandoned
uncommitted intents require their own bounded accepted contracts. This narrow
API does not waive those gates or prove Android renewal/message delivery.

Consumers must rebuild/repin for the API increment. No account schema/reset,
node-key replacement, network rollout or wire downgrade is required here.
Focused real-account tests are the first gate; final package/evidence ownership,
connected restart/concurrency/recovery and retained-account physical Windows /
Android renewal remain business-batch gates.
