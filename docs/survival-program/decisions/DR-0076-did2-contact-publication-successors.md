# DR-0076 — DID2 contact-object and publication successors

Status: accepted connected API increment; durable issuer/owner/device gates open
Date: 2026-10-03
Decision owner: Mr. X (delegated architecture authority)

Connect DR72 route successors to the signed/encrypted permanent contact object
and publication. No wire version, suite, signature domain, legacy reader or
historical-currentness switch is introduced. Independently current DID2/device,
network/PMT/witness policy and protected conservative time remain mandatory.

Freeze closed `VerifiedDeepIdV2ContactObjectPredecessor` and
`VerifiedDeepIdV2PublicationPredecessor`: no public construction, signing,
currentness, dispatch or grant methods. Historical object verification takes a
closed DR72 route predecessor, exact bounded DCR/ciphertext and resolver
capability under current authorization/network/time. Verify device signatures,
exact identity/support/service scope, issuance anchor, original signed validity
containment and ciphertext authentication. A signed original issue timestamp is
used only for historical signature/scope verification, never as current time.
Reject future issue times, changed device/PMT/support, malformed sizes, wrong
capability/ciphertext, cancellation and protected-clock discontinuity. Own all
caller memory before clock callbacks. Historical facts do not renew expiry.

Historical publication verification additionally binds the exact publisher
request, XPU/XPA and committed/exact-replay XPO, object generation/ciphertext,
owner capability, selected current placement and both node receipt signatures.
Require original request/XPA issue not in the future and exact signed historical
scope, but do not release old mutation authority. Old route/object/XPA may be
expired; current identity/network still may not. A closed publication predecessor
is not an active publication, actual client CAS or server lineage reservation.

`AuthorRetainedSuccessorAsync` takes current verified successor route, closed
DR74 issuance, closed object predecessor and owned device. Advance DCB generation
exactly once; preserve bundle ID, identity, policy, profile and exact active-device
service descriptors in this increment. Link predecessor DCB canonical SHA256 in
tag9, retain exact next XIR descriptor, derive issue time from current conservative
interval and strictly advance expiry. Derive ADL/DCB minimum from actual signed
issuance head. Independently verify the current object before and after sealing.
Current restore accepts matching nonzero route/object generations, never a stale
object or arbitrary generation-zero replacement. Genesis authors stay strict.

`AuthorSuccessorRequestAsync` requires the closed publication predecessor and
exact next object. Preserve owner Retrieve capability and permanent locator.
Request generation equals the new DCB/XIR generation; predecessor object hash
is the old ciphertext SHA256, DISTINCT from the DCB tag9 old signed-bundle hash.
Publisher signs the whole exact request. Successor request/threshold/response
APIs require this closed lineage; ordinary genesis request/threshold APIs keep
rejecting nonzero generations. XPA tags9/10 bind request generation/predecessor,
not hardcoded zeros. Signed DCB minimum and independently current XPA head remain
separate DR74 checks. Current commit verification matches exact nonzero signed
object/request generation and verifies both receipts; no predecessor permission
is inferred merely from a parsed bundle or hash. Recheck lineage/current authority
through callbacks and final release. Unknown outcomes retain exact bytes.

No shipping activation until Shared protects committed predecessor plus pending
successor/request/response, completes CAS/readback and two-replica adoption, and
Registry permanently serializes route/publication generations across DIFFERENT
nonces with exact predecessor binding. Existing nonce-only journals are not
sufficient. Expired incomplete proposals, PMT/device/view/service rollover and
retention/capacity exhaustion need separate bounded recovery contracts; never
silently reset an account, remint its old nonce, backdate or replay expired XPA.

Acceptance uses real DID2/native device/witness/node signatures: expired genesis
route/object/commit -> current successor route/object/XPA/two-replica commit ->
next successor. Default old current verification still rejects. Cover substituted
lineage, two distinct predecessor hash domains, future/gapped/overflow generation,
changed service/profile/owner, wrong signing custody/receipt/ciphertext, mutable
inputs, callback expiry, cancellation and clock discontinuity. Consumer API/
package rebuild/repin and physical same-account Windows/Android recovery remain
release gates. This API increment changes no account schema or registered keys.
