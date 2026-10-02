# DR-0044 — Independent prekey-service and current contact-object lifetimes

Status: accepted semantic correction; connected/device evidence remains gated
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

The connected owned publication → permanent read → retained claim regression
fails because the existing inventory was issued before the subsequently authored
contact DCB. Recreating inventory or backdating the contact is not a repair.
A short network-dependent contact route is also not the lifetime authority for
all independently pre-signed epochs of its exact signed XPS1 service.

The DID2 manifest interval must be wholly inside the exact current signed XPS1
service interval. Its device, service capability/generation/hash, DPD1, current
DMD1 and DRS1, minimum inventory, signature, lineage and DPK2 inclusion remain
mandatory. The manifest need not be wholly inside the later contact publication
interval. At operation time the ENTIRE authenticated recipient/network time
union must be inside BOTH the current DCR/DCB/DCA/route closure AND the selected
inventory/member/service lifetime. No expired contact, inventory, device or
proof is accepted. Current directory/non-revocation and both selected replica
signatures remain independent requirements under DR41–43.

Only the two inappropriate whole-manifest-versus-DCB inequalities are removed
from DID2 manifest binding. No wire/domain/suite/public method/storage generation
change, prior-generation reader, generic caller clock, resigning or key reminting
is authorized. DR42 route audit anchors do not supply current claim authority.

Acceptance requires the real owned prekey inventory created first, followed by
owned contact publication/read, exact durable claim and first-message completion;
service/inventory/member/contact/proof expiry and substitution must still reject.
Synthetic unit binding coverage and actual account/native/SQLCipher evidence
are labelled separately. Local adapters do not establish physical delivery.
