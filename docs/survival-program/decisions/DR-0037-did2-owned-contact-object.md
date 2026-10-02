# DR-0037 — Owned DID2 genesis contact object

Status: accepted clean break; network publication and device delivery remain gates
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Freeze the existing DID2-only DCB1/DCR1 version-2, suite-0x0301 candidate
grammar implemented by DeepIdV2ContactBundleCodec and
DeepIdV2ResolverClosureCodec for owned reusable genesis authoring. The 24-field
DCB1 is 9,094..15,612 bytes, with exact DID2/DAB2/DCA1 V2/ADL1 V2, one
611-byte XIR1 V2 in its existing 651-byte descriptor, and one 352-byte signed
XPS1 V2 per active device. Its signing domain remains
`Deep/Application/V2/contact-bundle`. DCR1 is its existing four-field record
with exactly one verified DRS1 and every verified active DPD1, ordered by
support kind and canonical hash. No DID1/DAB1 reader or adapter is authorized.
Frozen machine manifest/vector replacement and public API repin are mandatory
at the final business-batch gate, not evidence supplied by this decision.

Add a closed AuthoredDeepIdV2ContactObject and artifact-specific
DeepIdV2ContactObjectAuthor.AuthorGenesisAsync/RestoreAsync. Creation requires
the actual current VerifiedDeepIdV2ContactRouteClosure, an owned authorized
device, exact current signed prekey descriptors and the separately retained
resolver read capability. No caller-selected clock, arbitrary signature
callback, generic device signing API, raw identity capability factory or
caller-authored DCB1 is accepted. Reusable genesis has generation zero, zero
predecessor and policy bits 0 and 3 only (public reusable requests with manual
approval). It derives ADL1 profile 1 and the minimum
directory checkpoint from the verified route authority. Profile UTF-8 is
bounded by 128 bytes. Validate all prekey descriptors before signing. Bundle
validity covers the conservative route time union, starts no earlier than any
descriptor, and ends no later than the exact delegation, invite and prekey
descriptors. Recheck route/current monotonic time across asynchronous boundaries.

The encrypted object remains the existing XChaCha20-Poly1305 framing:
24-byte random nonce followed by ciphertext/tag, with network16 || DID2hash32
as AAD and the existing capability-bound HKDF-SHA-512 derivation. The raw
resolver capability/key is not sent to witness coordination or storage.
Restore independently verifies exact identity/support/signatures, route/XIR1
binding and currentness, decrypts, and compares exact plaintext. Authored
objects are local candidates, not XPA1, publication, grant or ACK capabilities.

Extend the existing protected account-owned route journal to version 2 only,
with phase 4 retaining exact DCR1 and exact encrypted object after phase 3.
There are nine LP32 records: the existing seven followed by DCR1 <=65,535 and
ciphertext <=65,575 bytes. Prefix remains 170 bytes, header 92, maximum entry
167,256 bytes, maximum intents 128, aggregate slot bound 1 MiB (the existing
production journaled secure-store value limit). Pending phases reserve the
maximum complete entry size before a threshold callback; completed phase 4
reserves its actual immutable size. Reject new intent admission when total
reservations would exceed the byte limit; do not strand a pending route because
its later ciphertext cannot be stored. Revision remains 1+sum(phases). Phases
1/2/3 have empty final two records; phase 4 requires all nine. Older journal
version 1 rejects and requires explicit pre-production account reset, never
lazy upgrade or empty-root repair. Account SQL shape 2/application schema 6
does not change. One logical route intent fixes its profile and exact object;
changed profile, route, descriptor or delegation under that intent rejects.

The account lease protects create/adopt/read-back. Persist phase 4 with CAS
and independently read its exact winner before returning the candidate. Lost
response/restart must reuse bundle ID, signature, nonce and ciphertext; an
uncommitted candidate may be regenerated but cannot escape to a callback or
transport. No new public raw protected-slot or signing surface is exposed.
XPA1 server issuance, private coordination transport, replica publication,
mailbox membership/grants and physical Windows/Android remain separate work.
