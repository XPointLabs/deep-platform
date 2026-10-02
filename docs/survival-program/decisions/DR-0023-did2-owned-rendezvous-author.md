# DR-0023 — DID2 owned-device inbound rendezvous author

Status: **accepted bounded API; runtime activation gated**
Date: 2026-09-30
Decision owner: **Mr. X** (delegated architecture authority)

Freeze `DeepIdV2ContactUpdateRendezvousAuthor.AuthorGenesisAsync` with current
DID2 directory freshness, current NETCODEC onion network context, protocol-owned
`OwnedGenesisDeviceSecrets`, independent metadata key ID/X25519 public key,
issued/expiry seconds, trusted-time authority and cancellation. The result is
the existing DR-0021 issuer/time capability, not a route or publication grant.

Use the unchanged XUR1 grammar/domain. Derive its PMT2 reference only from
the current verified network closure, never a caller hash. The network closure
must bind the exact directory head and DTT1 core hash of the supplied proof.
Generate independent random nonzero locator/write/read capabilities inside
Protocol. Require the local signing key and device ID to match an active exact
current DPD1. Sign only the canonical XUR1 device projection inside the owned
secret lock; no raw seed, general signing callback or V1 lineage escapes.

Own caller metadata before awaiting. Bound validity to the current verified
network lifetime and device certificate, maximum 30 days. Before signing and
at the final continuous protected clock sample require live network authority
and current proof covering the whole authenticated interval. Recheck scope,
signature and issuer/time before returning; cancellation issues no result.
Metadata sealing must use its independent key, never the device agreement key.

Freeze the key-free `VerifiedOnionNetworkContext.MaximumRecordExpiryUnixSeconds`
projection of the verified closure's hard upper bound. It checks live authority
before returning; it is neither a placement selector nor a validity extension.
Shared derives a bounded policy interval using this value rather than guessing
network lifetime or supplying a fabricated placement key.

Shared local custody uses one add-only protected snapshot at
`deep.store.v2.contact-rendezvous-journal`, initialized atomically with the
database-instance key before account publication. Local version 1 has a
92-byte header (version/reserved bytes, count u16, revision u64, network16,
account32, instance32) and up to 128 sorted entries of intent32, independent
metadata scalar32 and exact XUR1[538]. Revision is count+1. This is not wire
authority. Structural validation checks canonical XUR1 and scalar/public-key
binding; current account/device/time verification remains mandatory on release.
The account lease plus exact compare-exchange commits the complete snapshot
before any result escapes. A missing/corrupt/cross-instance journal requires
explicit reset, never recreation or a replacement intent. Lost commit responses
recover the exact winner. Same intent never silently renews expired XUR1.
Explicit account reset purges the V2 namespace including this snapshot.

Protocol owns the author and Shared owns durable custody before Hello/Accept,
including exact retry after interruption. This API alone does not satisfy that
custody, independent placement/route verification, DCR publication, two-replica
read-back, contact state, session projection, inbox or ACK. The semantic/wire
owner remains [CONTACT-RESOLVER-V1 section 3.5](../../architecture/CONTACT-RESOLVER-V1.md#35-established-contact-update-service-xur1--xuw1--xuq1--xus1).
Remove the old DAB1 `ContactUpdateRendezvousAuthor`/result and their positive
test; Git history is the audit record, not a shipping compatibility path.
No V1 author adapter is authorized. Final graph/evidence gates and physical
Windows/Android tests remain part of the coherent release batch.
