# DR-0131 — owned prekey maintenance author

Status: accepted source/API allocation; connected qualification required
Date: 2026-10-16
Decision owner: Mr. X (delegated architecture authority)

Semantic owner: [CONTACT-RESOLVER section3.3](../../architecture/CONTACT-RESOLVER-V1.md).
This completes the producer boundary for [DR-0129](DR-0129-owned-prekey-service-succession.md)
and [DR-0130](DR-0130-owned-prekey-inventory-custody.md). It allocates no wire,
suite, domain, persistence generation, reset, compatibility reader or higher limit.

## Exact service restoration, not signing or currentness

Allocate one Protocol method on the existing device-owned DPK2 author:

```csharp
AuthoredDeepIdV2PreKeyService RestorePreKeyServiceV2(
    Dpk2AuthoringContext context, VerifiedDab2 did2Binding,
    ReadOnlySpan<byte> exactXps1);
```

Use the existing opaque result type, never a public constructor or generic signer.
Before returning, require the author's actual active directory/device and exact
verified account, canonical DID2 XPS1, its device signature, network/device/DPD1,
service generation and signed interval covering the proposed inventory context.
The context issue time cannot precede the service issue time. The existing
inventory author independently enforces the same checks plus exact service
capability/reference and signed inventory/reuse limits before generating keys.
Return byte-identical XPS1/reference/capability. No re-signing, new randomness,
key generation, storage write, network callback, clock override or dispatch
permission is involved. Fresh complete DID2 evidence, protected owner history,
full inventory verification and actual publication remain separate requirements.

The existing service successor author also enforces DR-0129's unchanged signed
policy, immediate nonoverflowing generation/hash, nondecreasing issue and strictly
increased expiry before signing. An expired predecessor is historical evidence,
not current authorization. Invalid predecessors cannot consume a signing callback.

Also allocate the read-only
`DeepIdV2PreKeyLineageVerifier.VerifyServiceTransition(ParsedXps1V2 candidate,
ParsedXps1V2 durablePredecessor, ReadOnlySpan<byte> deviceSigningPublicKey)`.
It accepts byte-identical signed descriptors or DR-0129's exact immediate
successor; both signatures and unchanged scope/policy are mandatory. Move the
existing owner/issuer predicate here and use it in local inventory custody and
contact renewal, rather than duplicating that semantic predicate in Shared.
The expected key still comes from the caller's independently verified current
device/owner scope. This void verifier returns no fresh authority or capability.

## One publication command

Replace Shared's public `PublishOwnStagedPreKeyInventoryAsync` with
`PublishOwnPreKeyInventoryAsync`, retaining its exact source/custody/cancellation
parameters and commit-snapshot result. It performs owned preparation/maintenance
and publication as one command using the same freshly verified authority.
Remove public `EnsureOwnInitialPreKeyInventoryAsync`; an internal
`EnsureOwnPreKeyInventoryAsync` serves other owned phases. No aliases or dual
shipping paths. Explicit phase-specific initial staging remains a valid low-level
owner operation, not a legacy reader. MAUI calls the one publication command,
not a preliminary producer followed by another network-authority acquisition.

The actual account file lease encloses reading the current tip, pair and receiver
history, selecting a successor, device-owned authoring and durable staging.
Recheck fresh proof/network/time and cancellation before authoring and staging.
Do not hold a network dispatch across that lease or turn restored custody into a
cached live capability. A missing current pair retains the exact candidate and
operation: timeout/expiry does not authorize replacement or new key selection.

For this one publication command, all bounded fragments use the same freshly
verified network/proof as preparation, not another full network acquisition per
fragment. The existing source rechecks the exact protected directory and network
floors, fork state, monotonic boot/time and live proof before path preparation,
again after asynchronous frame construction immediately before forwarding, and
after authenticating each returned result. Each request still binds its exact
network/view/placement, service capability, operation and selected exit; both
independent XIC1 signatures are verified as before. Any changed/expired authority
rejects without adopting a receipt pair or replacing the durable candidate.
The next command independently acquires fresh complete authority. This is a
call-local verified context, not a cached capability, implicit held-lease loan,
retry/fallback transport or extension of the existing caller/signed budgets.

The existing public `EnsureOwnPermanentContactPublishedAsync(source, ct)` is the
complete owned workflow: independently acquire one fresh context, maintain and
publish both prekey replicas, then restore/renew or author/commit the permanent
contact under that same context. Its private owner phases keep separate actual
leases and all callback/currentness checks; the final return rechecks current
protected authority after the account-plan read. Internal explicit phase APIs
remain phase operations, not another shipping orchestration or legacy path.
MAUI calls this workflow once, rather than first repeating complete network
verification, then a prekey command, then another contact acquisition. Initial
account admission is still independently verified. No new public API or source-
supplied time/custody bypass is allocated; the caller's whole-operation budget
and every independently signed freshness/resource ceiling remain unchanged.

For completed custody, reauthenticate its exact replica pair before deciding to
renew. Replenishment may use a same-service next XPI epoch within its existing
fourteen-epoch bound, only while that exact service covers the new interval and
its LR counter is not exhausted. On-demand replacement may overlap the prior
inventory for already-issued claims; it is not another future pre-signed epoch
served concurrently. Existing current/overlap service admission limits remain.
Service expiry, epoch-budget exhaustion or authenticated LR exhaustion requires
DR-0129's signed service successor and epoch1. Never increment the service merely
to evade restoration of its existing signed descriptor.

Shared's local authoring policy keeps32 new one-time members, a conservative
low-water mark of16 locally unconsumed members and its existing one-day target
validity. Local receive counts are only a replenishment trigger, not a statement
of remotely available/reserved keys. A changed current DMD1/DRS1 binding or an
inventory not covering authenticated upper time also triggers maintenance.
Bound new intervals by the current DCA/device certificate and the existing
thirty-day DPK2 ceiling. For a required service successor, choose at least the
old expiry+1 within those bounds; inability to extend rejects before signing.
Do not extend old bytes, backdate a new issue time, increase bounds or reset any
counter, claim, Initial, replay fence or native floor.
The dependent reachability successor likewise requires at least its old expiry+1
within independently current authority/delegation/device bounds; inability to
advance rejects before proposal signing, never by extending its predecessor.

Both exact authenticated XIC1 receipts must be durably recorded before changed
contact support is adopted. The permanent locator, account/device identities,
owner Retrieve capability and prior pending Hello/secret custody remain intact.
Unresolved expired publication and current-authority unavailability remain
fail-closed; this decision does not invent noncommit evidence or a reset remedy.

## Required evidence

Cover byte-identical service restoration after owner reopen, invalid signature/
foreign owner/device/generation/interval/policy and disposed author rejection,
same-service replenishment versus genuine service succession, expired completed
inventory recovery, exact pending retry, concurrent owner calls, cancellation/
clock change before stage, lost publication response, old pending Hello and one
effect after restart. Native source tests are not deployed TLS/device evidence.
Canonical source/package qualification, matched replicas/issuer/clients and
retained-account Windows/Android E2E still gate activation. No Releases/main.

The old public-command expiry case is semantically retired, not waived:
`Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.CompletedPublication_ExpiredInventoryRemainsExpiredDespiteValidStoredSignatures`
is replaced by
`Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.CompletedPublication_ExpiredInventoryMaintainsBeforeDispatchAndPreservesOriginalCustody`.
The new command must renew completed expired custody before dispatch; the
replacement injects a lost stage response and verifies valid new support, no
ONION reservation and unchanged original replica custody. The existing pending-
expiry test still requires rejection without replacement or dispatch. Exact
canonical reference retirement mapping must name this decision and replacement.

Exact source-case replacement declaration for the canonical reader:

```text
Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.CompletedPublication_ExpiredInventoryRemainsExpiredDespiteValidStoredSignatures -> Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.CompletedPublication_ExpiredInventoryMaintainsBeforeDispatchAndPreservesOriginalCustody
```

This is the same replacement already accepted above, not another retirement,
allowed failure/skip or changed assertion. Original reference TRX stay unchanged;
the replacement must actually pass in the current full run.
