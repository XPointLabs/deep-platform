# DR-0035 — direct DID2 mailbox grant requests

Status: accepted API clean break; live acquisition/custody remain gates
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Replace the DID1 `MailboxGrantRequestAuthor` with
`DeepIdV2MailboxGrantRequestAuthor.AuthorDepositAsync(currentDid2Route,
locatorHash32, IReachabilityMailboxHolderSigner, cancellationToken)` and
`AuthorRetrieveAsync(currentDid2Route, locatorHash32, ownerRetrieveCapability32,
IReachabilityMailboxHolderSigner, cancellationToken)`. No old overload or route
adapter. Keep XMG1 version1/suite0201, its exact 435-byte tagged grammar/domain,
holder proof of possession and the neutral parsed request/result types.

Freeze the read-only `VerifiedDeepIdV2ContactRouteClosure.ReadCurrentTimeAsync`
method returning an immutable `DeepIdV2ContactRouteTimeWindow` with getter-only
lower/upper Unix seconds and no public constructor. It performs the same full
currentness/route checks as EnsureCurrentAsync, not signing or dispatch. Only
the authenticated projected union time interval may define the request window;
caller wall clock and caller timestamps do not. Request lifetime is bounded by
the existing 120-second acquisition policy, all retained route expiries and the
verified network hard expiry. Its window must cover the entire trusted interval.

Capture the bounded locator/capability/holder public key before the first await.
Recheck the route immediately before and after holder signing, then verify the
exact returned signature against the captured key. A late/cancelled/stale result
releases no authored request. A request is not an issued grant, durable retry,
stored holder, installed credential, contact consent, dispatch or semantic ACK.

Remove the unused Shared DID1 acquisition client rather than converting its
wall-clock/caller-owned flow into a DID2 compatibility adapter. Identity-neutral
verified grant/replica models remain inputs to the future account-owned direct
DID2 acquisition path. Remove the old identity/V1-storage holder owner too;
retain only the narrow signer behind an internal DID2 route-bound factory,
with no public seed/storage/create/delete API. Bind network, locator, role
capability, PMT/PMS, placement and epoch before signing. This factory does not
establish durable holder/account custody and has no shipping caller.
The replacement must retain request/holder custody
under the actual account lease before transport, independently verify current
PMA2 and exact authenticated topology membership/epoch, verify XMC1 and issuer
signatures, persist/read back the exact winner, and use ContactResolve ONION,
never a public Registry grant endpoint. Those consumers are not activated here.

The Protocol API snapshot/evidence and consumer rebuild/repin are mandatory at
the whole-business batch gate. No network grammar, SQL schema, machine IP or
platform key changes. Live issuance/publication and physical Windows/Android
delivery evidence remain required; local signatures alone do not close them.
