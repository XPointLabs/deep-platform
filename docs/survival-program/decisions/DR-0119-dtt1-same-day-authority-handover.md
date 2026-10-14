# DR-0119 — DTT1 same-day verified authority handover

Status: accepted pre-production producer/consumer contract; activation pending
Date:2026-10-14
Owner: Mr. X (delegated engineering authority)

[ACCOUNT-DIRECTORY](../../architecture/ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md)
owns the replay rule. DTT1 bytes, UTC-day numbering, tag13 hash, signature domains
and CRL1/CRS1 protected layouts do not change. No legacy reader, reset, raw
allowlist, same-day nonce reopening or generic same-number fork waiver is added.

The protocol-minted `AccountDirectoryDtt1IssuanceEpoch` adds exactly one public
read-only property `IReadOnlyList<ReadOnlyMemory<byte>> ReplayNamespaceIds`.
Derive retains its current-authority/time checks and exact current `Id`. It
derives an ordered ancestor-to-current list from the fully verified, positionally
paired XNA1/DTS1 chain, including only pairs whose original signed authority and
time-policy intervals overlap this UTC day. Include the current ID exactly once;
reject more than64 overlapping namespaces before exposing a capability. Return
defensive copies. There is no public constructor, raw epoch factory, historical
currentness conversion or change to request/freshness authority binding.

This list is only negative anti-replay evidence. A stored same-day namespace is
acceptable only if it is in this exact current lineage. Unknown IDs, sibling
forks, descendants presented to an older authority, future-day markers and
day-number rollback still reject. Current proofs are signed and verified only
with the exact current ID; no ancestor proof becomes current.

Under the existing exclusive issuer lease, a request probes the unchanged HMAC
nonce path for every authenticated namespace in the current day before quota
reservation or signer access. Any existing marker, including a damaged/partial
marker, means consumed. Quota/revision span all these same-day namespaces;
switching authority must neither reset count nor delete their markers. A same-day
ancestor quota may advance to the current ID only in the normal durable reserve
write. Readiness performs no such write. Compaction verifies bounded markers and
retains every same-day ancestor marker; only strictly earlier days can be retired.
Cancellation, unknown/future namespaces, corrupt quota/marker and capacity failure
reject without reopening a nonce. The next UTC day uses the existing rule.

Required evidence: genuine signed paired successor, unchanged current epoch bytes,
defensive copies and bounds; warm/cold same-day handover and reused nonce rejection
despite changed boot/sample; aggregate quota, concurrent duplicate attempts,
interrupted reserve/partial marker, sibling fork, rollback and next-day cleanup.
Actual Registry/node catch-up on retained volumes must pass before activation is
claimed. Protocol/API/package and downstream qualifications remain mandatory.
