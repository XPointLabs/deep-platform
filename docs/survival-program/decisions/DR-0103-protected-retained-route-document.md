# DR-0103 — protected retained-route document checkpoint

Status: accepted S01 native custody contract; coupled issuance activation gated
Date: 2026-10-07
Decision owner: Mr. X (delegated architecture authority)

DR-0101's generation5 retained table remains inside the existing opaque store.
Protect the exact document, not a second table, against replacement or rollback
of node data alone. A separate native owner binds node/network and the fixed
relative resolver path. Its independently persisted Data Protection enrollment
and checkpoint contain only exact document hash/length, local generation and
at most one pending hash/length/temporary basename. Their purpose chains differ
from mailbox-operation custody and from each other. No wire/domain allocation,
protocol suite, local opaque schema bump or account/node key change follows.

The sole transition owner is
[CONTACT-RESOLVER §3.7.2](../../architecture/CONTACT-RESOLVER-V1.md#372-independent-retained-read-custody).
Enrollment is an explicit fresh-store operation: both the document and any
previous enrollment/checkpoint must be absent before the canonical empty
document is created. Existing unprotected rows, even structurally valid ones,
must never be blessed or imported. Normal reopen requires the original keys
and enrollment/checkpoint; missing, tampered, foreign or split state fails
closed. The production key ring remains explicitly provisioned, outside node
data and checkpoint directories; no ephemeral provider or automatic key remint.

Before replacing the document, validate and flush its exact candidate, verify
the committed predecessor, persist the one pending transition and read it back.
Then replace/flush the document, independently verify its exact hash and commit
the checkpoint. Failure faults the open store. An authenticated pending
temporary survives failure; an unanchored temporary never authorizes recovery.
Cold recovery accepts only the protected predecessor plus exact prepared file,
or the exact prepared file already installed. Validate the complete generation5
document before completion; preserve pending evidence on failure. Rechecking
the protected snapshot before and after current authority callbacks is required
for any retained evidence producer.
Metadata-write temporaries are never substitutes for missing enrollment or
checkpoint records. After authenticated committed document read-back only,
remove exact owner-formatted orphans; unknown custody entries fail closed and
are preserved. Failure to secure the writer lock releases it without enrollment.

Data protection detects data-only rollback, root-only split, corruption and
foreign node/network/purpose substitution. Joint rollback of the matching
document and its independent root, or a worker/key-ring compromise, is outside
this local floor's guarantee. Key-ring revocation/deletion can make retained
custody unavailable and must never trigger reenrollment or an empty substitute.
This native contract is not a signed storage attestation, historical signature
verification, a grant issuer, object deletion authority or a transport ACK.
Both current stores, renewed issuance/owned holder and typed node Retrieve–ACK
remain one coupled S01 implementation/qualification batch.
