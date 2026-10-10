# DR-0108 — current authority operational successor and original namespace

Status: accepted S01 clean-break producer API; connected/runtime activation pending
Date: 2026-10-09
Decision owner: Mr. X (explicitly delegated architecture authority)

## Exact API change and sole owner

`XPointNetworkOperationalSuccessorRequest` replaces its constructor's
`VerifiedXPointNetworkBootstrap bootstrap` argument and `Bootstrap` property
with `VerifiedXPointNetworkAuthority authority` and `Authority`. The complete
XNA1/DTS1 chain must already have passed the existing genesis-pinned verifier.
No bootstrap overload, conversion, alternate reader, caller trust flag or raw
ancestor permission is retained. Actual current callers are repinned together.
Sole operational semantics remain in
[XPOINT-NETWORK §7.3](../../architecture/XPOINT-NETWORK-V1.md).
`VerifiedMailboxHostAuthorityV2.RequireOriginalNamespaceAsync(
ReadOnlyMemory<byte> exactPma2, ReadOnlyMemory<byte> exactPmt2,
CancellationToken cancellationToken = default)` is the accompanying closed
metadata-only API. It returns `ValueTask`, not a capability or a deletion decision.
No record, field, signature domain, suite or local-state generation changes.

The routine offline producer is
`XPointNetworkBootstrapAuthor.AuthorSameKeyRenewalAsync(ReadOnlyMemory<byte>
ceremonyId, VerifiedXPointNetworkAuthority predecessor,
IReadOnlyList<ReadOnlyMemory<byte>> exactDts1PolicyChain, ulong
authorityIssuedAtUnixSeconds, ulong authorityNotBeforeUnixSeconds, ulong
authorityExpiresAtUnixSeconds, ulong timePolicyNotBeforeUnixSeconds, ulong
timePolicyExpiresAtUnixSeconds, IReadOnlyList<IXPointNetworkBootstrapRootSigner>
rootSigners, CancellationToken cancellationToken = default)`, returning
`ValueTask<AuthoredXPointNetworkAuthorityRenewal>`. The result has only
`ReadOnlyMemory<byte> ExactXna1` and `ExactDts1`, no verified capability.
The managed signer-purpose enum adds `AuthorityRenewal=5`; existing XNA1/DTS1
signature transcripts/domains are unchanged. Routine renewal preserves all
keys, thresholds, failure domains, time-source policy and client floors. This
is not a root/witness-key rotation API.

Before callbacks it reauthenticates the complete paired predecessor chain,
requires exact bounded signer/custody metadata, overlapping authority/DTS
windows, unchanged-or-later root expiry and strictly extended DTS expiry within
the existing400-day/30-day bounds. XNA/DTS generations and predecessor hashes
advance exactly. Signature buffers/requests are cleared and metadata is captured
before callbacks; every returned receipt verifies under the captured original key.
The complete output chain must pass the existing verifier before return. Callers
still must append and verify the unchanged-genesis complete chain before current
use. No authority/history slot is reset to replace a missing predecessor.

## Authentication and signing separation

The exact protected policy/view/head/PMA/PMT predecessor is authenticated under
its own authority in that verified chain. Every supplied historical view keeps
its original key set, policy hash, signed window, exact predecessor and
nondecreasing authority generation. The entire ordered view prefix must
reconstruct the protected head's tree size and Merkle root before any signer
callback. The head must name the prefix's actual terminal view and authority.

Root-authorized `AuthorAsync` signs each new policy/PMA and operational artifact
under terminal current authority only. Root and witness signers must match that
authority's exact keys/generations, thresholds and failure domains. New records
explicitly replace their authority references and witness-policy hashes; copying
old fields and re-signing with new keys is forbidden. Network/node identities,
exact policy/view/head/PMA/PMT predecessors and the placement epoch remain;
operational freshness is not placement-epoch rotation.

`AuthorDelegatedAsync` cannot cross authority by borrowing old live policy/PMA.
Both delegations must already name terminal current authority, remain live for
the complete requested interval and retain their exact bytes. Node traffic-key
activation stays restricted to announced keys. After offline root renewal, a
subsequent delegated append may include the full mixed-authority signed prefix.

Historical PMA verification remains internal, returns no current issuer or host
capability, and uses its exact ancestor keys/window. The public current PMA
verifier remains terminal-current-only. DR-0107 history facts do not become
signing, epoch exclusion, retained issuance or deletion permission.

## Original namespace and owned exclusion

The network verifier retains an in-memory exact PMT-artifact/own-authority join
only after verifying that PMT's actual signed view and authority. Warm successors
carry these verified joins; cold successors reconstruct them from the complete
signed chain. A terminal-only reset does not reconstruct old facts. These are
not new persisted framing, unsigned cache entries or a current-key fallback.

The metadata API requires exact retained PMT bytes, their own verified ancestor,
the exact PMA core named by that PMT, profile2, the same network, the same ancestor
reference and original root/witness signatures and policy bounds. Current host
authority and authenticated monotonic time are rechecked before and after. It
does not admit an expired grant, renew an old issuer, change an epoch or establish
non-issuance. Historical committed contact route facts likewise use the exact
retained PMT's own authority, never terminal witness keys.

Shared's existing held exclusion consumes this fact under the same live account
lease, exact original acquisition/journal root and independently anchored current
DNH2 floor. The current selection epoch must be strictly greater than the original
epoch and the authenticated lower time must pass the original possible issuance
ceiling. Rechecks after suspension and before mutation remain mandatory. Actual
object horizon, dependency closure, completed original read/ACK, SQL/protected
compaction plan and cold recovery remain separately required for deletion.

## Required evidence and activation

Actual changed-root/witness XNA1/DTS1 renewal, offline operational successor,
then delegated successor over that mixed prefix; exact old/new signatures,
policy/PMA/current-role verification, retained PMT epoch and transparency root.
Wrong ancestor bindings, old records re-signed by new keys, bad protected hashes,
missing/forked prefix, old signers used for new records, and a delegated cross-root
attempt reject before signer callbacks.
Original-namespace substitution, a re-signed old PMT/PMA, absent retained join,
missing native history and changed original issuance ceiling must reject before
any owned compaction mutation. Actual object-horizon joint SQL/protected/native
handover evidence is required separately. Matching consumer builds, canonical
full/API/package and real owned-client/native/device checks remain required.
No production rollout, state reset, Release publication or main merge is implied.
