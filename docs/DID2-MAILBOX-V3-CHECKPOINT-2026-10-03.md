# DID2 mailbox authorization — Protocol source checkpoint

Date: 2026-10-03. Status: local source/test milestone, not runtime activation.
Owner: Mr. X. `deviceDeliveryVerified=false`; no release qualification claimed.

## Exact producer and normative inputs

- Architecture/DR81: `456bf70f835c4668d46fa9558d7fe64c7737fd80`.
- Protocol codecs/issuer/host facts: `54c4c19ace2776cb897d46188df9d789306e3ba8`.
- Protocol contact fixture generator/hash assertions:
  `116eb88cc6d5f07b235422d5a33c2077a6b7559e`.
- Contract: [DR-0081](survival-program/decisions/DR-0081-did2-mailbox-selection-grant-clean-break.md)
  and [machine framing](survival-program/releases/v3.0.0/specs/mailbox-authorization-v3.registry.json).

MCG3 requires the exact verified PMS2 selector and signs it; MCP3 signs the
entire grant; MAU3 and XMC2 have one current reader. Current PMA2 verification
requires profile2. Historical profile1 can be parsed but cannot mint current
mailbox authority. Route/result verification rejects even an issuer-signed
selector substitution. Host grant ranking returns actual selected node IDs and
descriptor receipt keys after current issuer and full monotonic interval checks.
Those facts are not holder, revocation, replay, local-exit or mutation authority.

Removed the MCG2/MCP2/MAU2 positive golden corpus and the positive XMC1 result;
old bytes survive only as negative inputs. Existing independent peer framing
fixtures are separate: their remaining retired identity/authority composition
still requires removal in the connected peer batch. It was not silently redefined
to authorize V3. No new legacy adapter or fallback was added.

## Addressed local evidence

- Protocol authorization/route/routing/registry/peer-framing slice: **142/142**.
- Separate contact canonical manifest execution: **13/13**.
- Affected MembershipRoutes slice: **65/65**.
- Affected ProfileCarrier slice: **14/14**.
- Three production source projects build Release with zero warnings/errors.
- Strict generated registry check, canonical contact manifest/schema check and
  diff whitespace check pass. Approved DNP1 Git blobs were not changed.

These are focused source checks, not the final package/API/resource/evidence
gate. Signed roster/issuer unit fixtures use the existing trusted freshness seam;
they are not physical device proofs or deployed authority. Earlier intermediate
failures were corrected; no failed assertion was skipped or removed to obtain
this result.

## Connected work still required

1. Replace protected client acquisition/winner/request consumers and repin the
   exact producer; discard incompatible custody explicitly, never convert it.
2. Connect current node holder/revocation/replay/local-exit admission and exact
   MIP1 grant-bound peer proof/quorum; remove the retired PMA1/P04 runtime graph.
3. Provision signed PMA2 profile2 and matching PMT2 successors through approved
   operator tooling while retaining keys, genesis, floors and nonce journals.
   No denied export or authentication operation may be bypassed.
4. Qualify actual packages/resources/APIs, matched deployed services and retained
   state; then physical contacts/consent, two-way text, remote file/image integrity,
   governed groups and recovery on Windows and USB Android.

No production deployment, Windows UI mutation, Android reset, push or publication
was performed for this Protocol increment. The earlier Android own-publication
and restart/reverification milestone remains distinct from peer delivery.
