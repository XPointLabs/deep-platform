# DR-0045 — Account-owned resolved-contact claim preparation

Status: accepted internal orchestration; shipping/device evidence remains gated
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

The connected local scenario must stop constructing XPK1 from a test-selected
inventory, device, operation and clock. The account runtime prepares the exact
request from its protected preclaim intent and an independently reverified
permanent-contact candidate. It exposes only parsed request bytes, not secret
agreement material or a caller-mintable session/signature/clock capability.

Before authoring, reverify both endpoint proofs, current protected directory and
network floors, the original resolve query/receipts and current route time. Under
one account lease, reject completed or retired initial intents, restore or create
the protected preclaim and get-or-reserve the claim request. Choose the publisher
device's exact signed XPS1 from the verified DCB list, never a caller-selected
inventory projection. Bind operation, ephemeral commitment, service, device,
DCB/XPS hashes, network view and ranked placement. The whole current endpoint/
network time union must fit request, contact and service validity. Request expiry
is at most 120 seconds after its issue time and never exceeds those authorities.

Get-or-reserve is atomic under the account file lease: first inspect retained
bytes and only author on absence. A concurrent preparation or explicit retry
retains the original timestamps and all other bytes. An expired or incompatible
reservation rejects; it is not refreshed, reminted, forked by a newly constructed
request, or repaired. Existing explicit conflicting raw reservation semantics
remain irreversible fork-latching. Successful result storage is separate and
still does not grant current recipient authority, ContactAccept, a session or ACK.

The existing two-slot protected floor precedes SQL commit/readback. Cancellation
or a crash may leave protected preclaim/reservation custody but must never emit
an uncommitted request. Recheck both endpoint/floor authorities and the original
boot/monotonic observation after storage, before release. Network dispatch stays
outside this account lease and uses the exact retained request with its existing
30-second bound. No automatic retry or expiry extension is introduced.

No wire/domain/suite/public API/schema generation changes. Only an internal held-
lease split of the existing custody CAS is authorized; no public arbitrary author
callback or nested acquisition. Completed-session retry/recovery remains the
existing exact initial/mutable-session custody path, never a fresh preclaim.

Acceptance: replace manual XPK construction in the real account/native/SQLCipher
connected regression; repeated preparation returns identical bytes; cancellation,
conflict, expired query/request, foreign owner and changed placement/floors reject.
Local adapters are labelled separately from authenticated socket and physical
Windows/Android delivery, which remain mandatory release work.
