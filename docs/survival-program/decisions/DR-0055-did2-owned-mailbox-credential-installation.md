# DR-0055 — DID2 owned mailbox credential installation

Status: accepted local custody/installation contract; dispatch/device gates remain
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Keep neutral XMG1/XMC1/MCG2 and the current SQL generation. After DR53's
protected winner read-back, the actual account owner installs that exact grant
into its own application SQL under the same held lease. Never install callback
bytes directly, accept a caller-selected repository/issuer/holder, fabricate a
next grant, export a signer, or obtain authority from a retired identity owner.

Derive the local selector from the retained holder and exact route context.
Derive both replica identity keys from the first two independently verified
PMS2 mailbox nodes in current NETCODEC, not from ResolveInvite store receipts.
The role must be Self/Retrieve or Peer/Deposit. The runtime issuer policy is
constructed only from the independently root-verified current PMA2 bound to
the route's PMT2; minimum generation and the full grant interval remain enforced.
The local policy admits only the exact retained grant's issuer, serial, role,
generation, epoch and membership. This is not a global serial-revocation feed:
current PMA2 minimum generation/issuer policy and current recipient/network
closure are mandatory; any additional signed revocation surface must be frozen
and connected before a product claim relies on it.

Synchronous SQL validation uses the upper bound of the authenticated route
interval, conservatively extended by process monotonic elapsed time from before
the sample. It never uses OS UTC as authority. This internal installation scope
expires after 30 seconds, on lease disposal, or at any grant/PMA/network/route
bound; it cannot escape to the application or be reused for later dispatch.
Recheck the current protected own/peer floors and exact winner before installation
and after independent SQL route/grant read-back. Interrupted installation is
resumed idempotently from that same protected winner, without another issuer
callback or a new holder. Same-epoch changed SQL material rejects, not replaces.

Installation alone is not signing, dispatch, receipt, consent or ACK. The next
connected consumer must retain an owner-only holder loan through exact owned
message read-back, transactional MAU2 preparation and selected-entry dispatch.
Retrieve materialization and semantic acceptance precede acknowledgement.
The owner-only held mailbox transport context retains the actual account lease,
verified local account, current own proof/NET context, exact recipient route and
read-back grant. Path preparation uses readonly existing directory/network floors
under that lease, independently verifies the original grant/route again, and
requires the exact placement commitment. It never calls a fetch/refresh method
which recursively acquires the same account lease. This loan expires on disposal
or after 30 seconds; before/after-forward checks do not mint a new proof. A
post-forward rejection remains outcome-unknown, not proof of non-delivery.
Full machine/API/package closure, matched live activation and physical
Windows/USB Android messages/files/images/groups remain release gates.
