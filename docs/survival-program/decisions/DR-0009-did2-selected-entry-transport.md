# DR-0009 — DID2 selected-entry transport and local ONION custody

Status: **accepted; exact API extension frozen below, runtime activation unproven**
Date: 2026-09-28
Decision owner: **Mr. X** (explicitly delegated architecture authority)

## Decision

The agent adopts this decision under the owner's delegated clean-break authority;
this is not an external security review or a production sign-off.

1. A three-node publication needs both selected replicas. The entry can change
   when a required exit is the retained primary guard. A fixed ingress URL or a
   caller-supplied router hint cannot override that verified permutation.
2. Freeze `OnionEntryTransportFactory.Create(VerifiedOnionPathContext)` returning
   sealed `VerifiedOnionEntryTransport`, with no public constructor, the read-only
   `Peer: VerifiedOnionNextHopTransport` property and `EnsureCurrent(): void`.
   Only Protocol derives the exact selected entry's signed address/port/SPKI from
   the same path/network closure. It rejects an incomplete or expired context.
   No raw origin, key, clock, route list or verifier callback is accepted. This is
   an API extension, not a change to ONION wire, domains or frozen byte vectors.
3. A DID2 client host owns persistent entry guards and atomic durable entropy
   commitments under its verified account/database instance. It never reads V1
   identity/secure slots, accepts a recovery phrase or exports device scalars.
   Request ephemeral and reply private keys remain Protocol-generated one-use
   material. A client-only host does not hold an XNode receive-key vault.
4. The authenticated public-entry diagnostic uses the selected entry's signed
   TLS SPKI, exact address and certificate-name validation. A self-signed node
   certificate is allowed only with the exact verified pin; permissive trust,
   unsigned next pins, redirects, default proxies and direct Registry publication
   are forbidden. Registry public HTTPS continues to use platform CA trust.
5. Failure or ambiguous entropy persistence releases no frame. Missing/rolled-back
   custody fails closed. Exact staged publication retry does not replace keys or
   confer freshness. No migration or V1 fallback is added.

## Gates and non-claims

Prove selected-entry binding for both exits, immutable/non-forgeable API,
expired/incomplete context rejection, real SQLCipher duplicate/rollback/crash
behavior, wrong TLS pin/name/endpoint rejection and exact two-replica XIC1 before
claiming publication. Then perform real Android/Windows contact and message E2E.
This does not activate a masked carrier, disjoint fallback, DPH2, attachments,
groups or a release. Existing stored account wire does not change; incompatible
local custody is explicitly reset, never silently recreated.
