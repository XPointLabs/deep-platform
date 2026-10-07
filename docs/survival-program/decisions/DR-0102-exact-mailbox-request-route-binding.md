# DR-0102 — exact mailbox acquisition route binding

Status: accepted pre-production request clean break; runtime activation gated
Date: 2026-10-07
Decision owner: Mr. X (delegated architecture authority)

XMG1 signs PMT2 and PMS2 but not the exact six-record closure. Legal publication
and route successors can retain both the owner Retrieve capability and exact
PMS2. Therefore those fields cannot uniquely name the route whose accepted
objects are being read. Latest-wins selection is forbidden by DR-0101, and a
local unsigned route hash would not bind the holder's intent.

Replace the current acquisition request with XMG2. Keep the twelve-tag,
435-byte CONTACT-CODEC framing, version1/suite0201, and tags1..10/12 widths.
Tag11 is now mandatory nonzero SHA256(exact six-record route closure), not a
random nonce. The independently random operation ID in tag2 retains request
uniqueness. Holder tag12 signs tags1..11 under the new purpose
`Deep/ContactResolver/V2/XMG2`. Reject XMG1 before verification callbacks;
no legacy reader, conversion, alias, regenerated pending request or dual path.

The sole field/transition owner is CONTACT-RESOLVER §3.7. XMC2 and MCG3 framing,
PMA2 profile2, primitives, role separation and trusted-time limits are unchanged.
Success XMC2 tag7 must equal request tag11 as well as the independently verified
exact route hash. Current author/restore, issuer, node current route check,
retained private lookup and client result verification all enforce this same
binding. The retained lookup uses the signed hash to disambiguate exact original
routes, never the newest publication. Identical exact closures can still share
the greatest independently admitted read horizon.

Update machine contract, generated allocation, current structural vectors,
positive/negative signed tests and all connected source consumers together.
Negative coverage must include copied old-domain signatures, retired magic,
wrong/zero route hashes, result substitution, restore mismatch, exact replay
and two legal distinct closures sharing selection/capability scope. Do not
retain XMG1 positive vectors in the current contact package.

Old protected pending/winner requests reject through their current reader;
no journal migration or automatic account reset. Existing SQL/native custody
and genesis, registered keys and independent floors are not reset by this
source change. Explicit reprovisioning/rebuild/repin remains an activation gate.

This closes exact request/route intent only. It does not authenticate retained
historical availability, protect the Node table against rollback, reinterpret
Current replica evidence as retained evidence, mint renewed Retrieve grants,
activate transport ACK or raise TTL. These remain one coupled S01 closure.
