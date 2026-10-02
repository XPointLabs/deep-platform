# DR-0046 — Owned attachment offers in the common authored namespace

Status: accepted local composition; BLOB/socket/device delivery remains gated
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Extend DR30's one protected ordinary-event journal/SQL mirror to AttachmentOffer,
using the same operation, random logical ID, contiguous sequence, pending/stable
recovery and exact DPE2 send checks as MessageCreate. Do not create an attachment
counter or another outbox. This supersedes DR30's temporary text-only kind guard;
it does not authorize any other codec-supported event. Existing local storage
identifiers are identifiers of this same current owned namespace, not legacy
readers. Wire/domain/suite, journal shape and SQL generation do not change.

The internal account service accepts an asset-operation ID, never caller DAM1,
object key or authored event bytes. Under the same actual account lease as draft
adoption it opens the mandatory DR31 protected asset journal, requires the
selected asset to be stable, and verifies every registered SQL manifest/chunk
against protected metadata before creating the exact encrypted-message payload.
DAM1/object key travel only inside encrypted DPE2, never blob metadata or logs.

Reusing a draft operation with another scope, text/offer kind or exact manifest
rejects before new mutation/crypto. The selected stable asset must cover the
entire current own/peer trusted interval and authored creation time. Sending an
offer independently checks stable ordinary-event custody AND stable exact asset
custody and current expiry. Raw caller-authored offers remain rejected, even
though the send kind guard can now route an owned offer to those checks.

Receiver materialization uses the existing authenticated direct-event reducer;
An internal bounded key-free history projection may return logical/device/object
selection IDs, filename, media type, size, author and times from exact non-forked
canonical inbox rows, behind the same account/session/floor checks as text.
Reject hostile BLOB size/type before allocation. Dispose parsed DAM1; never
return its key/read capability through this UI projection. These are historical
offer entries, not current offer/cancel state or download authority. A later
download consumer must independently reconcile those authorities.
codec support or a retained local offer grants no upload/download/remote receipt
permission or semantic ACK. AttachmentCancel, authenticated BLOB-01 upload,
download/resume, receiver key lifecycle and actual file/image integrity on
Windows/Android remain unfinished. A local copied-ciphertext test is not a
transport or device result.

Acceptance: text → offer → text uses one sequence without gap/reuse; exact
pending SQL recovery/restart preserves manifest/operation/logical bytes; changed
manifest, raw offer, foreign/missing/pending asset, changed protected SQL mirror,
expired asset and unsupported kinds fail closed. Narrow structural/SQL evidence
is labelled separately from connected native and physical delivery evidence.
