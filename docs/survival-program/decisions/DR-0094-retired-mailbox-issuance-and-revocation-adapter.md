# DR-0094 — retire pre-cutover mailbox issuance and grant-revocation APIs

Status: accepted, frozen source/API retirement authorization; implementation gated
Date: 2026-10-05
Decision owner: Mr. X (delegated pre-user clean-break authority)

## Exact source/API boundary

Remove the PHP1 producer/verifier in
`Deep.Protocol.DeepExtension.MailboxAuthority.ProductionMailboxHolderProof.cs`
and its eight public types: ProductionMailboxIssuanceIntent,
ProductionMailboxClientPlatform, ProductionMailboxHolderProofError,
ProductionMailboxHolderProofException, ProductionMailboxHolderProofInput,
IProductionMailboxHolderProofSignatureVerifier,
SodiumProductionMailboxHolderProofSignatureVerifier and ProductionMailboxHolderProof.
Remove its wholly owned positive corpus, not independent current MCP3 coverage.
Input Protocol is `624850f27ac12a4a85a0dd5dc6bcadd6696d8107`;
input root is `9e276476facfbd1e12d209e3cac6e8f215eebe2f`.
PHP1 remains permanently allocated but becomes RETIRED_REJECT once the source
is absent; no generated production encoding constant remains.

The retained native PMR1 observation must not double as a current grant
revocation source. Remove IMailboxCapabilityRevocationSource implementation
and the IsRevoked/IsRevokedSerial query APIs from
VerifiedProductionMailboxRevocationSnapshot. Remove their unused issuer-key
and serial-search copies. Preserve the immutable snapshot, canonical hash,
serial count and all encoded PMR1 fields. The internal constructor may drop
only its unused issuer argument, with the two existing verifier/recovery call
sites updated; all signature, provenance, time and binding predicates remain.
No replacement authority factory or raw-to-verified conversion is authorized.

## Current-owner mapping and preserved native boundary

Current holder/request authentication belongs to MCG3/MCP3 under DR-0081,
not PHP1's release-certificate/entitlement issuance transcript. Current grant
revocation belongs to signed MGR1 and its consumer-protected floor under
DR-0083, not a PMR1 observation or caller-supplied empty source. These existing
owners remain mandatory; this decision does not mint either authority.

Native DNP1 still consumes exact verified PMA1/PMR1 provenance in DNR1,
membership, protected genesis and recovery. Those bytes, reference domains,
record bounds and signature/time/floor/ancestry checks are unchanged here.
Removing the current-grant adapter is not permission to replace native PMR1
with MGR1 or PMA1 with PMA2. PMA2 authorizes grant issuers, not node identity.
The remaining native current-owner join is still the S00 blocker recorded
under DR-0093. Independent DNP1 account/device verification and all ReleaseRoot,
reset/recovery/product guarantees remain in scope.

## Consumer and acceptance boundary

Current Shared.Production and MAUI compile lists exclude the old ControlPlane
and CredentialAcquirer callers. Those pre-cutover sources/corpora remain
removal inputs, never an excuse to restore PHP1 or add compatibility helpers.
No UI, device account, protected state, deployed image or registered key is
changed by this source retirement.

Verify the actual assembly lacks all eight PHP1 types and both encoding APIs,
and that a verified PMR1 handle cannot implement the current grant-query
interface. Retain PMR1 malformed/boundary/signature/provenance/callback-copy
and defensive-copy coverage; remove only obsolete query assertions. Confirm
the deleted PHP1 cases had no unexplained failures in the preceding full.
Review the precise public API and source-inventory delta before mechanical
registry generation. Do not repin strict package snapshots or approved native
blobs while the remaining production graph is open. Focused compiler/test
receipts qualify only this removal; full S00, connected transport and physical
Windows/Android release acceptance remain required. No publication or
production activation is authorized by this decision.
