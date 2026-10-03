# DR-0086 — one current mailbox writer and authenticated Store prefix

Status: accepted S01 semantic/API increment; implementation/activation gated
Date: 2026-10-04
Decision owner: Mr. X (delegated architecture authority)

The existing per-coordinator counter permits equal cursors and late completion
below a snapshot. Rejecting equal cursors or checking local Pending records does
not solve the missing shared ownership. The sole normative requirement owner is
XPOINT-NETWORK-V1 section 9.1, with the matching client path rule in section 10.2.

Select the first node in the exact authenticated PMS2 ranking as the sole Store
writer. The client chooses its three-hop path to that writer; no XNode reroutes
a sealed request or chooses a client path. Both selected nodes remain necessary
for durable quorum. Retrieve and ACK remain available on either replica. There
is no election, writer failover, third-node fallback or new wire/profile ID.

The writer's existing operation ledger retains the complete signed intent and
authenticated MQR3. A new cursor cannot pass an unsettled earlier intent in the
same exact mailbox scope, including an intent not yet materialized as a mutation.
Only the original exact retry reconciles Pending; a new grant/counter/body is
not its replacement. No unsigned durable flag authorizes prefix advancement.

Freeze the bounded API on the already closed `VerifiedMailboxHostAuthorityV2`:

`ValueTask VerifyStoreSettlementAsync(ReadOnlyMemory<byte> exactPrq2,
ReadOnlyMemory<byte> exactMqr3, CancellationToken cancellationToken = default)`.

It verifies a past two-node Store commitment against the exact signed PRQ2 and
descriptor identity keys obtained from the independently current verified network.
It authenticates the sender, both distinct exact MRR2 tuples and coordinator
signature/sequence; proof/grant/body/network/epoch/placement/member bindings and
signed acceptance intervals are mandatory. All bytes are captured and bounded
before callbacks, and current host/time is checked before and after verification.
Missing descriptor history fails closed. XND identity keys are immutable within
their lineage; no node-ID/key alias or fabricated identity-key rotation is used.

The initial bounded verifier covers only the exact independently current PMT2
projection and its authenticated selected pair/issuer. Former grant expiry is
not current grant authority. Retained predecessor projections or changed issuer
keys require separate signed history and are not accepted through this API.

Successful completion returns no authority object, key, current grant or peer
request. Expiry/revocation of a former grant cannot undo a cryptographically
proven past commit, but this method never permits another mutation, replay
reservation or dispatch under that expired/revoked grant. Receipt timestamps
are checked only as signed commitment facts, never installed as current time.
There are no raw key, clock, crypto callback, trust flag or historical-currentness
switch arguments. Original admission remains independently current-only.

Local operation grammar changes must reject incompatible generations without
migration/reset and retain exact crash recovery. An unproven prefix remains
backpressure, not success or a discarded send. Signed retirement/expiry fencing,
retained descriptor/route history, object horizon and sustained renewal remain
required before Program activation; absence of their implementation is not a
permission to abandon an unsettled intent.

Gate: matching client path and native admission/peer writer checks before replay;
two independent stores; different grants/concurrent sends cannot pass Pending;
crash before mutation and before/after quorum persistence; original retry/reopen;
hostile or missing saved quorum cannot advance; former grant expiry does not
turn settlement into current authority. Matching API/package/consumer repins,
issuer/runtime activation and physical Windows/Android E2E remain required.
