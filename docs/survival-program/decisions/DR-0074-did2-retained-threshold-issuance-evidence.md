# DR-0074 — retained threshold issuance evidence

Status: accepted protocol increment; owned coordination/device integration open
Date: 2026-10-03
Decision owner: Mr. X (delegated architecture authority)

DR73 reproduces a lost already-signed route response followed by directory
advancement. Exact retry must not remint that winner. Extend DR42 with a closed
retained-issuance verification/completion boundary, not a public trust flag or
an old clock. Existing current-head threshold mint/verify/completion APIs keep
their strict semantics.

The verifier owns the complete original DR36 request, three threshold records
and bounded (at most 4096 bytes, directory reader 2) canonical signed issuance ADH1 before any clock
callback. Authenticate the actual ADH witness signatures under the current
verified XNA authority and directory witness policy. Its core hash must equal
both threshold ADH CoreRefs. Its signed generation must lie between the saved
request minimum and the independently current protected head; equal generation
requires exact core equality at either bound. XRC issuance and XSS issuance
must lie within this ADH validity window. Historical expiry does not erase this
audit fact; it supplies neither freshness, ancestry nor rollback-floor mutation.

Independently verify current account/DCA/queried leaf/device, current network
view/head/PMT/node key epoch, protected time and every route lifetime and witness
signature before and after asynchronous reads. Bind the closed evidence to the
exact saved request and current DCA/XNA. It is not a route, signing capability,
publication, consent, grant, dispatch or delivery. Completion requires owned
device secrets and either genesis lineage or the DR72 closed predecessor.

The new retained-genesis object author additionally matches the exact completed
route to that evidence. Derive ADL/DCB minimum generation AND hash from the
authenticated issuance ADH, never from a caller number or a newer head paired
with an old hash. Actual new DCB timestamps still use current protected time.
Publication request authoring uses the exact signed DCB minimum; independent
current authorization and all publication deadlines stay mandatory.

This supersedes DR38's equality between the publisher's minimum checkpoint
and the current XPA issuance head: they are different authenticated facts.
The whole publisher signature still covers the exact DCB minimum, which must
match the bundle and route audit anchor and not exceed the current floor.
New XPA tag18 and its authorization-ID head component use the independently
current ADH, not the publisher's older minimum. The pure untrusted wire body
binding no longer equates these heads; the closed current-directory witness
verifier MUST independently require exact XPA/current ADH equality. No XPA
currentness waiver, new wire version/domain or changed field layout is added.

Unknown/intermediate issuance heads cannot be reconstructed from hashes or
assumed to be the proposal head. Connected coordination must return and durably
retain the winner's exact signed issuance ADH alongside the exact winner before
completion/object adoption. This increment changes no coordination wire or
protected journal generation and does not activate that connected path; DR73's
old-head runtime rejection remains until that custody and server replay change
is frozen, implemented and verified. No automatic reset, migration or nonce
replacement is authorized by this protocol increment.

Acceptance uses genuine signed head advancement, including a non-adjacent
issuance head, actual device/witness signing, completion, encrypted contact
object and fresh publication request. Reject missing/oversized/forged/mismatched
ADH, future or below-request generation, changed DCA/proposal/threshold,
expired current proof/route, cancellation and clock discontinuity. Local tests
are not retained-account or physical contacts/messages/assets/groups evidence.
