# DR-0042 — Contact-route directory issuance anchors and independent current identity

Status: accepted semantic correction; network/expiry successor and device gates remain
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

The real additional-account admission regression from DR41 exposes an erroneous
coupling: every global ADH advance invalidates an unchanged, unexpired contact
route. Requiring every account to republish whenever any other account joins is
not the intended contact lifetime and is not a scalable repair. Apply the same
issuance-anchor/current-authority separation already normative for PMT2 tag14.

XRC1 tag19 and XSS1 tag12 are threshold-signed ADH issuance/audit anchors, not
pins to the latest mutable global head. They must be the same exact typed ADH1
CoreRef. All existing canonical shape/nonzero checks and current-authority
witness signatures/threshold/failure-domain checks remain mandatory. Changing
the anchor after signing invalidates the records. The anchor supplies NO
current identity, directory freshness, trusted time, non-revocation, historical
ancestry or dispatch authority. No historical-proof capability is inferred
from its hash. This does not accept a DID1 object or a prior consumer graph.

Current peer and owned network proofs still require the SAME exact current
ADH/XNA/witness policy/XNV authority, independent live nonces and protected
boot/deadline/time-union checks. Current exact DAB/DMD/DCA and active publisher
must match the signed contact and route; revocation/expiry/fork floors still
fail closed. PMT/PMS, XNV/XNH, node key epoch, exact device/delegation references,
all device/witness/replica signatures and complete route lifetimes remain
unchanged. This decision does NOT relax network view/head/key references or
permit expired routes; their successor lifecycle remains required.

Distinguish mint/completion from retained verification:
- AuthorThresholdAsync, VerifyThresholdAsync and CompleteGenesisAsync still
  require the exact CURRENT ADH issuance anchor before callbacks/adoption.
- VerifyAsync and the closed route's currentness checks may validate a retained
  threshold with an older signed audit anchor, only with the independently
  current recipient/network authority and all checks above. No new caller
  historical clock/anchor/key input or public trust flag is added.
- AuthorGenesisAsync for a NEW contact object still requires that the route
  was issued at the current head, so it cannot invent a new minimum checkpoint
  for an older route. Restore/read/historical commit retain the original bytes.

For owned contact objects and resolved reads, signed DCB1 tag21 minimum-head
core hash must equal the route's signed ADH audit-anchor core hash; DCB/ADL
already require their exact minimum fields to agree. Its minimum generation
must not exceed the current verified head. At the current generation its hash
must equal that current head's hash. Older audit/minimum metadata is NOT an
ancestry proof and is NOT used to waive independent current proof/floor checks.
No blanket acceptance of a mismatched or caller-rewritten checkpoint exists.

No wire/domain/suite/public method/store generation changes are required.
The same exact protected phase7 object/commit can reopen after an unrelated
directory admission without reminting, callbacks or changed ciphertext.
Existing pending issuance still uses its exact bounded request and fresh XPA;
this does not renew expired authorization or silently replace a pending nonce.
Consumer rebuild/API/evidence and final business gates remain required.

Acceptance requires actual signed additional DID2 admission + successor ADH +
new independent proof, unchanged stored contact read/current verification and
historical commit, plus rejection of new issuance from the old anchor, wrong
identity/anchor/signature/current authority, expired proof/route, cancellation
and final clock discontinuity. Local stores are not socket/device evidence.
