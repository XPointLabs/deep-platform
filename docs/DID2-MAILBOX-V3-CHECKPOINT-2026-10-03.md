# DID2 mailbox authorization — connected source checkpoint

Date: 2026-10-03. Status: Protocol/client/issuer-consumer source/test milestones, not runtime activation.
Owner: Mr. X. `deviceDeliveryVerified=false`; no release qualification claimed.

Compilation update after the operator froze feature work:
[stabilization handoff](RELEASE-STABILIZATION-HANDOFF-2026-10-03.md).
The 69 Registry test compilation errors described below are superseded by
complete zero-error solution builds. Full server tests still fail; no runtime
activation or physical delivery is claimed.

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

1. Rebuild/repin MAUI against the committed owned-client consumer described below;
   discard incompatible custody explicitly, never convert it.
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

## Owned-client and policy-producer increment

- Protocol policy producer: `c037aee6af66e1f88a36f91d2fffba041a26b246`.
- Shared consumer: `9835bd4d36e541ea504c5fd981c80f3bfbc5867d`.
- New genesis and root-signed successors author PMA2 profile2. An internal
  predecessor-only verifier checks historical root signatures/intervals without
  returning current authority; delegated renewal cannot activate profile1.
- The actual Shared production Compile inventory has no retired grant/result/
  presentation/envelope names or reader aliases. The current APIs expose
  `ExactXmc2` and `GetCanonicalMau3Copy`, without old aliases.
- Owned holder signing verifies the signed PMS2 selector, full exact grant and
  durable counter. Acquisition bounds, protected winner retention, installation
  and Store/Retrieve/ACK use the new framing. Installation requires an exact
  replica pair, not the first two of a larger selection.
- DMB1 schema8 and protected grant/send journal version2 reject incompatible
  older state, including empty journals. Grant expiry is exclusive in current
  SQL installation/resolution/preparation/resume; failed expiry checks retain
  the original durable request. No migration, nonce/key remint or floor reset.

Final focused Shared run: **65/65**, plus a disjoint signed-successor/reopen
case **1/1**. Includes real owned accounts, cryptography and SQLCipher grant
custody, lost-response/exact retry, native send, retained receive, semantic
handoff, lost ACK and restart checks. Issuer/terminal/time fixtures are
in-process, not socket/device delivery. An intermediate stale negative-test
version was corrected; the final run has no skipped or failed cases.
Protocol policy/host slice: **30/30**. Shared production Release build has zero
warnings/errors; strict generated Protocol registry and diff checks pass.
No full package/API/evidence gate or matched production rollout is claimed.

Android USB enumeration reports one authorized device, zero unauthorized/offline
devices. No application/UI mutation occurred in this increment. The next runtime
batch must replace XNode's retired policy composition and UTC-based synchronous
admission with the current protected monotonic grant/holder/replay/local-exit
boundary and grant-bound peer quorum. XNode was inspected only, not edited or
deployed. Physical contacts, messages, remote attachments/images and governed
groups remain unqualified; the release is not ready for publication.

## Registry retirement and private grant HTTP increment

- XNode consumer: `b2daecc81e4284b81e297f21b6ffc5061c62d394`.
- Registry issuer/journal composition: `5fe3ae3ef39e28d727ce9685239e6cc12aeb1a37`.
- The node private grant HTTP client and contact dispatcher decode only XMC2,
  enforce exact current response bounds and original XMG1 binding, and redact
  malformed-format failures. Old magic/size, foreign operation, compressed,
  wrong-type/status, unknown-length, truncated and trailing responses reject.
- The connected two-store publication/resolve/grant/retry test also runs through
  the actual HTTP client into the signed in-process issuer. A lost reply remains
  completion-unknown; exact retry retains one issued winner and signed selector.
  This is not socket/TLS/device delivery evidence.
- The Registry PMA1 coordinator/endpoints/owner-control/state/software-signer
  composition and its positive test corpus were deleted. No current grant was
  synthesized for the retired producer. The production assembly absence and
  rejection of disabled/unknown retired configuration are tested. The protected
  Unix socket signer was moved to the current issuer namespace without an alias
  or framing change. Source removal does not delete production state.
- The current permanent PostgreSQL winner journal retains only exact XMC2.
  Explicit operator constraint cutover preserves current winners, immutable
  scope/request hashes, reservations and counts; incompatible retained winners
  stop it before a schema change. No conversion, cleanup or reissuance occurs.

Final focused evidence: XNode **60/60**; Registry **15/15**, including two actual
isolated PostgreSQL cases; external signer **6/6** against real Linux Unix
sockets via the existing pinned Docker target. No skips. Registry production
source Release build has zero warnings/errors; affected node source compiles.
One added DB test initially used a parameterized multi-command statement not
accepted by Npgsql; split its setup statements and reran the final 15/15.
An intermediate HTTP fixture assertion was aligned with the existing outer
completion-unknown contract while still checking its exact inner cause.

The full Registry test assembly still has **69** compile errors in seven
directory-era test files referencing removed APIs; none refer to the removed
mailbox composition or retained signer. It has not passed the final full gate.
The final package/API/resource/consumer repin remains open. All newly owned
Registry/node changes are locally committed; no push, deployment, release or
production DB/keys/floor/config mutation was performed.

Physical observations in this increment: the retained Android diagnostic
account initially showed verified publication; a fresh UI-triggered network
retry after VPN ended at `ContactPublication / OnionCompletionUnknown`.
Recovery remains stored and the protected packages are unchanged. The Windows
isolated QA window reports an incompatible pre-cutover account; it was read
only, not reset. Neither observation qualifies physical messages or attachments.

Next connected runtime work is still current protected-time node request
admission, revocation/replay/local selected exit, grant-bound MIP1 peer mutation
and quorum. Retired PMA1/P04 **node** composition is not removed by this Registry
increment. Matched signed successors, current builds and physical contacts,
two-way text, remote files/images and governed groups remain release blockers.
