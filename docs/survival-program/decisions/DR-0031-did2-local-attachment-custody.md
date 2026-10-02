# DR-0031 — DID2 local attachment ciphertext custody

Status: accepted local contract; BLOB-01 and typed offer remain gated
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

The actual account owner adopts exact DAM1/ciphertext under its current-account
lease into the existing account-owned application SQLCipher, not a file URL,
another database or a caller-owned key store. This is offline local asset
custody only: no contact consent, authored event sequence, upload permission,
masked padding, route, remote receipt or delivery is granted. A later typed
AttachmentOffer must use the common DR-0030 authored namespace, never a
parallel attachment counter. DAM1/object key never become public blob metadata.

Application schema6 replaces5 without migration. Two local tables retain one
candidate per operation32 and exact indexed ciphertext chunks. Preparation
always generates a fresh object scope. Commit the complete candidate SQL
transaction before protected adoption; no partially written object is emitted.
Unregistered candidates after interruption are inert and may be discarded by
the actual owner before a new preparation, without using or reencrypting their
keys. Registered candidate loss or substitution rejects; never regenerate it.

The required protected slot `deep.store.v2.attachment-journal` is initialized
atomically with the account SQL root. Missing/foreign/older custody requires
explicit reset. Header92: version1/reserved-zero1/count:u16be/revision:u64be/
network16/account32/instance32. Entries144, sorted by operation32:
operation32/object32/SHA256(exactDAM1)32/SHA256(exactPlaintext)32/
phase:u8(pending1,stable2)/reserved-zero3/manifestLength:u32be/
plaintextLength:u64be. Max128 entries, max one pending; revision
`1 + 2*stableCount + pendingCount`; operation/object unique and nonzero.
Manifest length310..4653, plaintext1..26214400, retained ciphertext aggregate
at most512 MiB. The local plaintext digest stays protected and is never
included in DAM1, blob metadata or evidence.

After complete candidate commit, CAS the protected pending entry, verify
actual SQL manifest/chunk count/index/length/hash against it, then CAS stable.
Pending recovery uses the existing exact SQL bytes only. Stable retry with
the same operation checks requested filename/media type/length/expiry and
the exact-length input digest before returning the previous manifest/chunks;
changed input rejects without replacement. No encryption is repeated for an
adopted object-ID/key/index. A crash before pending adoption has no command and
may prepare a fresh random scope after discarding the inert candidate.

Before mutation/readback, verify every registered object's metadata and chunk
geometry against protected custody; missing/extra registered bytes reject.
Selected ciphertext is hash-checked before release; sizes/counts/types are
checked before managed BLOB allocation. SQL owns immutable ciphertext; keys
are retained inside SQLCipher DAM1. Returned copies have explicit disposal
and grant no transport authority. The same actual owner remains required
after restart, account reset and scope changes; local capacity exhaustion
requires a verified lifecycle, not journal pruning or silent reset.

Local whole-file materialization first performs that actual-owner protected/SQL
readback. Decode the closed manifest and check complete chunk geometry before
allocating bounded output. Verify every ciphertext commitment and actual AEAD,
then the complete protected plaintext digest before releasing any content. Failed
or cancelled assembly releases no prefix; wipe temporary plaintext/chunk copies.
The resulting content has independent disposable ownership, not a public key or
transport capability. This does not authorize incoming-offer downloads or change
the wire, journal, database generation or public blob interface.

This does not activate BLOB-01. Opaque transport padding, masked authenticated
upload/download/resume, current offer/cancel projection, MAUI picker/images,
group fanout and physical Windows/Android evidence remain required.
