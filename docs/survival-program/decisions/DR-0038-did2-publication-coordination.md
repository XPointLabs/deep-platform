# DR-0038 — DID2 exact publication coordination

Status: accepted clean break; durable shipping and device delivery remain gates
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Replace the publication-authority envelope, media and endpoint with version 2
only (`/api/v2/contact-publication-authority`). No version-1 reader, author,
endpoint alias or DID1 proof adapter is permitted. Keep the bounded binary
layout: header8, network16, coordination nonce32, directory leaf32, minimum
ADH generation8/hash32, exact DCA1 V2 473, LP32 DCR1 V2, LP32 neutral six-record
route closure, operation32, generation8, predecessor32, LP32 ciphertext,
issued8/expiry8/effective-expiry8, owner-Retrieve32, publisher signature64.
Request size is 23,302..155,210 bytes; response is header8/network16/nonce32/
LP32 XPU1 V2, 14,682..93,092 bytes. Ciphertext size must equal exact DCR1+40.

Publisher signing input is SIGINPUT with domain
`Deep/ContactResolver/V2/publication-publisher` and suite 0x0301 over the exact
request envelope with its last 64 signature bytes removed and total length
rewritten to that unsigned length. All request fields, including nonce,
operation, directory minimum, ciphertext, capabilities and all times, are
covered. No old 176-byte signing tuple is accepted. Author only from an owned
DR37 object, current verified DID2 route and authorized owned publisher device;
no caller clock or generic signing callback. Capture nonce, operation and
private Retrieve capability before asynchronous work. Genesis is reusable,
generation zero, zero predecessor, policy9; private Retrieve differs from the
public Deposit capability. Request lifetime is at most 120 seconds, clipped
to the current head, network, route and freshness validity. Effective expiry
equals the signed bundle expiry. Reject reversed clocks and stale contexts.

Freeze the existing version-2, suite-0x0301 XPU1/XPA1 grammar and its V2 body,
authorization-ID and witness-signature domains. Verify plaintext DCR1 support,
publisher signature, exact DCA/XIR/route, minimum head and locator against
actual current DID2 authority before witness callbacks. The server does not
receive the resolver read key/capability; it verifies the opaque ciphertext's
exact size/hash and publisher binding, not its AEAD plaintext. DR37 client
custody separately verifies that encryption. Placement uses the unchanged
neutral NETCODEC-minted service-placement algorithm, not a DID1 identity.
Witness rows must be sorted, unique, known current directory witnesses, with
valid signatures and threshold distinct failure domains. Snapshot signer IDs
before callbacks; reject substitution and invalid output.

XPA issued/not-before equal the exact publisher request issue time; XPA expiry
equals request expiry and covers the entire current trusted interval. Verify
the final response against every exact request field and DCR/DCB/XIR hash,
policy, current directory head, view and placement, not only operation/nonce.
The requested minimum head must equal this exact current head for this genesis
operation. XPA policy hash remains
`SHA256-D("Deep/ContactResolver/V2/publication-policy", exactDCA1V2)`.
Issuance and exact-winner read-back must reread current monotonic time and fence
ADA2/head/floor, XNA/DTS and the exact signed network closure, as in DR36.

Use a mandatory, independently provisioned permanent PostgreSQL publication
request/response journal in the existing restore domain, with reservation and
capacity checked before any signer, exact request replay and no remint after
expiry. No lazy schema creation, time eviction or request-body replacement.
Missing provision or authority fails closed. The client's corresponding exact
pending request must be retained before shipping callbacks; an ephemeral
author result is not durable retry. Private XPoint/OHTTP coordination remains
mandatory; the HTTP backend is not authorization for a direct shipping fallback.
No publication persistence, mailbox grants, semantic ACK or physical delivery
is inferred from a signed candidate. Manifest/vector/API repin and full gates
are required at the final connected-business boundary.

The existing account-owned route journal clean-breaks to version 3, eleven
LP32 records: DR37's nine followed by exact authority request <=155,210 and
exact response <=93,092. Phases 5/6 respectively retain the request/response;
phase 4 retains only the object. Maximum entry is 415,566 bytes, prefix170,
header92, slot limit remains 1 MiB and revision 1+sum(phases). Phases below 6
reserve a complete maximum entry before callbacks (two worst-case pending
intents fit, a third does not); phase 6 reserves actual bytes. Version 2/1
roots reject with explicit pre-production reset, no migration. Account lease,
CAS and independent exact read-back precede request dispatch and response
return. Lost responses retry exact nonce/operation/signature/ciphertext/private
Retrieve, never regenerate an expired retained request or bypass missing state.
