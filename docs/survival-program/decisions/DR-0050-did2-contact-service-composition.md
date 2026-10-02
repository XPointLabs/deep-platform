# DR-0050 — sole DID2 contact-service composition and authenticated service time

Status: accepted clean-break contract; shipping/device evidence remains gated
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Connect existing DID2 XPU/XIQ opaque publication/resolve and authenticated remote
replication without the retired V1 directory snapshot, recipient cache or group
authority composition. No identity adapter, legacy fallback, new wire/magic,
second replica endpoint or client-selected authority is introduced. The same
V2 prekey staging/claim owner remains responsible for its closed operations.

An explicit `DeepIdV2ContactResolver:Enabled` host option requires the independent
configured DID2 observer/NET source, authenticated privacy carrier and V2 stage
owner. Retired ContactService runtime activation and ContactAuthority composition
must remain disabled. The default remains fail-closed. Existing candidate
Development/UAT constraints are not relaxed by this decision; promoting the
complete root/clock/floor/recovery configuration and package graphs is separate.

The DID2 terminal handles only existing V2 prekey publication/claim and opaque
contact publication/resolve. One authenticated peer endpoint multiplexes only
V2 stage/claim operations and the neutral publish/read/resolve/receipt operations
needed by the same two selected replicas. Unknown kinds, old prekey/update/grant
operations or mismatched classes reject before an authority callback/mutation.
The receiving replica independently remints current placement; an untrusted wire
projection or valid calling-node signature alone never authorizes persistence.

Service expiry, retention and receipt admission MUST use the current authenticated
DID2 time interval advanced by the actual boot-scoped monotonic clock, not OS
epoch time. Existing synchronous opaque-store/facade `IClock` consumers may use
an internal bounded adapter that independently fetches a current configured-
observer proof and verifies NET/boot/freshness before returning its conservative
trusted upper bound. This adapter accepts no public Unix timestamp, trust flag
or caller account. Its reads have an explicit deadline and fail closed on absent,
expired, rolled-back or changed-boot authority. Do not cache an expired proof,
fabricate a new interval or change the global host IClock: OS time still serves
peer HTTP admission/signature timestamps, heartbeat and scheduling only.
Outbound replica dispatch requires the actual NETCODEC placement and its live
network lease, whose hard expiry bounds that placement; a wire-only projection
cannot be sent as authority. The HTTP timestamp clock must not be used for this
placement check.

Publication authority independently enforces the complete interval through the
existing DID2 XPA verifier. The active contact dispatcher must check the complete
request interval and current placement before dispatch and again after suspension,
before releasing success. Post-forward uncertainty cannot be reported as rejection
or delivery. No unsigned serverTime, parsed closure or stored commit becomes a
fresh authorization capability. Parent owned journals independently adopt actual
two-replica receipts as already required by DR40.

Permanent-contact preflight is a non-consuming DCR read, even when reached through
the existing claim-preflight operation. Its remote read-receipt request MUST bind
the exact current XIQ bytes (including request hash and locator), not an invite
claim tuple. The receiving replica independently rereads its durable publication
and verifies the complete receipt tuple; a remembered client-side read is not
receipt authority and cannot replace that check.

Narrow tests must join actual DID2 authorization, selected-peer replication and
durable opaque state; cover both public operations, unknown/old operation rejection,
wrong peer/placement, restart/exact retry, full time-boundary/boot/expiry failure and
no second route mapping. Full default graph/API/vector gates and actual three-host
TLS plus Windows/USB Android end-to-end remain business-batch requirements.
