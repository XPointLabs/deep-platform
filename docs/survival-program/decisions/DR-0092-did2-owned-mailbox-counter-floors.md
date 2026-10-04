# DR-0092 — owned mailbox Store counter floors

Status: accepted S01 local format/API contract; activation and lifecycle gates remain
Date: 2026-10-04
Decision owner: Mr. X (delegated architecture authority)

## Decision and sole owners

Implement the independent counter obligation already accepted in
[DR-0084](DR-0084-owned-delivery-settlement-and-retirement.md) and
[TRANSPORT-NEUTRAL-MESSAGING §8.4.3](../../architecture/TRANSPORT-NEUTRAL-MESSAGING.md#843-compaction-and-boundedness).
Freeze the account-owned Store commitment format/API in
[Shared architecture](../../../deep-client-shared/docs/ARCHITECTURE.md#owned-store-counter-floor-format).
The existing Protocol replay namespace remains the only namespace definition;
there is no new wire, magic, cryptographic domain, replay rule or trust flag.

`MailboxCapabilityReplayStateMachine.ComputeScopeKey(grant, operation)` is a
structural overload of the existing claim-based calculation. It validates
canonical grant shape and operation/role before returning exactly the existing
namespace bytes. It does not verify signatures, grant freshness or revocation,
reserve counters, mint a replay claim or authorize a callback. The actual account
owner independently verifies its retained winner before using this calculation.

Keep the floor independent of working-entry count and of SQL. Bind it to both
the Protocol namespace and the exact grant digest. A namespace cannot adopt
changed signed claims, and a grant cannot be enrolled into another namespace.
Enroll a new floor with the pending commitment under the actual account lease,
before SQL/signing. Adopt a prepared request and its higher floor in one protected
CAS/read-back; recovery of already committed SQL adopts the original exact MAU,
not a second signature. A reader never derives a missing floor from retained rows.

Floor capacity is bounded. Before issuer acquisition, saturated floor custody
permits only an already enrolled exact protected winner; the usual independent
verification still follows. Capacity does not evict a floor, pending work or
unknown attempt, and does not silently increase the working-set or grant limits.

## Clean break and activation boundary

Replace the previous Store commitment reader rather than retaining a dual path.
The normal account-generation opener requires the new shape, including empty
custody. An older isolated QA account requires explicit local reset; this decision
does not perform a device/account reset or change production operator state.
Publish matching Protocol/Shared source and consumer pins only after verification.

This is not permission to remove an entry or retire a namespace. Actual protected
compaction plans, terminal evidence, authored-sequence preservation, grant renewal,
Retrieve/ACK floors, object horizon and retained-route closure remain S01/S04
requirements. Removing a working commitment in a corruption test proves only
that the retained floor cannot be recomputed downward. It is not a successful
production compaction, sustained delivery or device qualification.

Mandatory evidence: parity with actual signed claim namespaces; malformed/foreign
and old-format rejection; floor loss, lower/exhausted/duplicate bindings;
before/after prepared-root interruption with exact SQL recovery; full-capacity
backpressure before issuer callback; and the actual reopened account owner
rejecting a rolled-back SQL counter even after its working commitment is absent.
