# DR-0122 — logical mailbox assignment and current carriage

Status: accepted semantic clean break; matched source/runtime/device gates open
Date: 2026-10-15
Decision owner: Mr. X (delegated architecture authority)

## Evidence and decision

The retained owned Windows client committed a contact and read its mailbox on
view57, then failed the exact-PMT predecessor check on view58. Routine operational
publication changes the PMT artifact even with the same selection epoch and
eligible nodes. PMS ranking includes that exact artifact; silently replacing it
can change the selected mailbox pair. Additionally, archived original read paths
are pinned through the original admission ceiling plus object retention, not
released by an empty page. Re-publishing every contact for every global view is
therefore not an adequate lifecycle design.

Separate logical assignment, signed resource lifetime, current operational
carriage and short mutation/grant authority. This applies the ownership boundary
already used for immutable prekey publication; it does not reuse a prekey proof
as contact or mailbox authority. The single normative semantics owner remains
[CONTACT-RESOLVER](../../architecture/CONTACT-RESOLVER-V1.md#36-exact-route-and-mailbox-closure).

No magic, wire layout, suite, signature domain, ranking algorithm, private journal
generation or compatibility reader is added. Existing exact PMT/PMS bytes remain
bound to their signatures and hashes. This decision supersedes terminal-PMT/view/
traffic-key equality as the lifetime of a logical contact route; it does not
remove independent current authority, time, identity or revocation checks.

## Closed current-assignment verification

A logical assignment is the exact originally adopted PMT2 plus the existing
random placement input, selection epoch, replication factor and deterministic
PMS2 ranking. Its reference is not rewritten when a transport view changes.
The existing rendezvous input/domain and exact selection hash remain unchanged.
New genesis authoring selects the actual current projection, never an arbitrary
historical snapshot. A successor preserves its authenticated original assignment.

Before any current route/grant/Store permission, the current NETCODEC authority
must independently establish all of the following:

1. Original assignment is present exactly once in the authenticated complete
   retained network lineage. A terminal-only forward checkpoint or an unsigned
   cache cannot supply missing history.
2. Original network, epoch, replication factor and complete eligible mailbox
   node-ID set match the current admitted projection. No local-health rerank,
   omitted node, cross-epoch reuse or changed candidate cohort is permitted.
3. The recipient/account/device/DCA and the route's OWN signed validity intervals
   remain current under protected time. Original signatures, graph, generation
   lineage and holder/capability bindings are verified independently.
4. Current network/root/policy, current node roles and admitted descriptors,
   current grant issuer, role floors and MGR revocation remain live. Historical
   signature keys never become a current grant issuer.

The original projection's window authenticates the assignment's creation, not
an everlasting operation lease. Genesis issue must be inside that window.
Subsequent same-assignment authoring requires authenticated predecessor custody
and independently current eligibility; expiry of a snapshot alone neither
renews an expired route nor requires changing an unexpired logical route.
No public historical/currentness flag or caller-constructed authority is allowed.

Origin, SPKI and onion traffic-key changes are resolved from the CURRENT admitted
descriptor. Old snapshot transport metadata is never dial authority. Changed
epoch, cohort, replica count, device or delegation requires its separate
authorized rollover/handover; this decision does not invent one.

## Issuance, validity and receipts

XRA/XIR retain their exact assignment reference. XRC/XSS view/head/key-epoch
fields describe authenticated ISSUANCE, not the network frame used by every
later operation. A newly authored threshold binds the actual current issuance
view/head and conservative time. A reader authenticates those issuance facts
through exact verified retained history, not by substituting today's frame.

PMS/XRC/XSS signatures must resolve to the actual issuance authority in the
verified XNA lineage. Original signed intervals stay inside that authority's
scope. PMS reuse must not mix signature authorities across a witness/root
handover; re-sign the selection under current custody when necessary.

Logical XRA/PMS/XRC/XRR/XIR/object expiry is bounded by its canonical limit,
subject/device/DCA and authorizing witness scope, NOT by a short operational
view/head/nonce-proof deadline. Each creation, publication, grant and dispatch
still acquires/rechecks a fresh independent current lease. A future record
expiry never extends that lease. No backdated issue time or changed saved
pending request is permitted.

Current XPU writes and XIQ/service requests retain their exact CURRENT carriage
commitment. Restoring an already committed XPO authenticates its ORIGINAL
publication view/placement, owner request and both immutable node-identity
receipts. It releases read-only commit facts, not permission to redispatch an
expired XPU. Logical route/object currentness is checked separately; historical
predecessor facts cannot be cast into a live route. Unknown outcomes still need
their explicit reconciliation owner.

## Current mailbox operations versus retained reads

MCG3/MCP3/MAU3 remain the only current profile. Membership commitment names the
exact logical-assignment PMT2; current eligible-assignment verification above is
mandatory independently of the grant's own current issuer/time/serial/floors.
Selection is recomputed from that exact snapshot and grant selector, never from
an unrelated newer salt. Both peer proofs carry the same exact grant/snapshot.
The selected transport facts come only from current admitted descriptors.

Current Store additionally requires its live owned route at issuance. The
existing retained-read lane remains distinct: it can settle previously accepted
objects after route expiry, but cannot authorize a new Store. Fresh Retrieve/
ACK, holder proof, replay, peer and mutation checks are not relaxed. No expired
grant or historical issuer/profile becomes current permission in either lane.

All old pending bytes, committed publications, counters, serials, protected
floors, private scalars and outstanding original read/ACK dependencies survive.
No automatic reset, evict, remint or bound increase is authorized. Retained-path
retirement still requires its dependency-closed owner; no empty-page shortcut.

## Implementation and activation gate

Complete one coherent Protocol/Shared/Registry/XNode slice before a final full:
current-assignment verifier, issuance-fact verification, authoring lifetime,
read-only committed-publication restore, fresh issuer/client/node/peer selection
and existing protected owner orchestration. Update frozen machine semantics and
reviewed source anchors together; bytes and limits remain unchanged.

Use real signed accounts, histories, witnesses, node receipts and protected
cold reopen. Cover unchanged logical bytes over multiple views and transport-key/
TLS renewal; original snapshot expiry with an unexpired route; actual own-route
expiry and same-assignment successor; fresh grants/Store/read/ACK on both peers;
changed epoch/cohort/count, missing history, wrong issuance view/key/receipt,
expired lease/grant/route, current revocation/floor, callback mutation/cancellation
and interrupted exact pending custody. Demonstrate no per-view contact generation
or archive accumulation, without deleting prior paths to satisfy a bound.

Then qualify the SAME retained Windows owner on real current-dev across ordinary
publisher renewal and retained restart, with unchanged keys/genesis/floors and
prekey receipt pair. Source fixtures/empty pages do not qualify physical contact
consent, two-client text, attachments or groups. S05, S06/device, package closure,
production activation and GitHub Releases remain independently gated.
