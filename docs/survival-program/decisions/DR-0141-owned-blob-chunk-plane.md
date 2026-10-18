# DR-0141 — DID2-owned encrypted blob chunk plane

Status: accepted allocation; implementation and connected qualification separate
Date: 2026-10-18
Decision owner: Mr. X (delegated architecture authority)

CLI-first remote attachment work found no BLOB-01 terminal operation: DAM1,
protected local adoption and AttachmentOffer exist, but a local copied-chunk
test is not remote delivery. Allocate ONION operation6 (`Blob`) and the closed
XBQ1/XBS1 framing below, using the existing three-hop carrier, native chunk
store and signed XND1 Blob role/capacity. No direct file URL, sidecar, new crypto
suite, legacy reader, client-authored currentness or fake storage receipt.

The normative network consequence is XPOINT-NETWORK §12.2; the exact machine
owner is `blob-chunk-v1.registry.json`. A descriptor contains only network,
random object ID, SHA256 of the unlinkable DAM1 capability, original expiry,
plaintext length and ordered ciphertext length/hash commitments. Never send
DAM1 itself, the object key, filename, media type, account or conversation to
the blob service. Capability possession permits reading or filling the SAME
immutable committed object, not replacing its descriptor/chunks. The DPE2
authenticated offer remains the independent authority for decryption/exposure.

Upload is retry-idempotent at each of two distinct currently verified Blob
nodes. Requests still take three diverse routing hops; client selects paths.
Downloads discover an existing object only among bounded current signed Blob
nodes, through the same carrier, and advance only on authenticated Missing.
An invalid response, hash, capability or AEAD tag is not a fallback condition.
This supports addition of nodes while original storage nodes remain admitted;
removal of all original storage copies is not a promised recovery mechanism.
Operator handover/retention qualification remains mandatory before release.

Each node permanently binds an admitted object to its exact descriptor while
retained, validates actual trusted current time before/after storage, enforces
object/chunk/global quotas, and returns an exact request-hash-bound result only
after durable readback. Lost responses remain unknown; retry sends identical
object/chunk bytes with fresh ONION entropy, never a replacement file/key.
Remote ciphertext is authenticated completely before exposing any plaintext.
Cold resume reuses protected local manifest/chunks and rechecks downloaded
chunks; a partial prefix is never a successful download.

This allocation does not waive attachment cancellation/materialization-retention,
churn/handover, sustained recovery, package/full source or device gates. CLI
file/image PASS must record complete plaintext hash equality on the OTHER
account and distinguish source fixtures from real carrier evidence. Groups
are a subsequent DID2-owned slice, not simulated by text or SessionId adapters.
