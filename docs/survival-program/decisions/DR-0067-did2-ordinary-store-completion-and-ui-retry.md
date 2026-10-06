# DR-0067 — durable ordinary Store completion and original UI retry

Status: accepted local clean break; connected/device activation gated
Date: 2026-10-02
Decision owner: Mr. X (delegated architecture authority)

Current private reader/counter layout is superseded by
[DR-0098](DR-0098-owned-authored-counter-floors.md); the prior generation2 and
count-derived revision below are not another supported reader. Store adoption,
original retry and no-delivery-claim obligations remain unchanged.

Extend the existing DR30/46 protected ordinary-command journal, not a second
outbox or UI Preferences marker. Header version2 only; entry phase1 is pending
SQL authoring, phase2 is stable authored, phase3 is stable with verified mailbox
Store completion. Prefix, scope, operation, event commitment and sequence stay
unchanged. Phases2/3 have no embedded DMC2; reserved bytes stay zero. Revision
is `1 + pendingCount + 2*stableCount + storedCount`. Application registration
requires version3, created atomically with the account. Old registrations1/2
and journal1 reject; no migration, implicit reset or dual reader. DMB1 remains7.

Only the account-held dispatch owner can advance an existing phase2 command to
phase3 after the real authenticated mailbox adapter returns Stored/Duplicate
with its durable cursor and final current-source/route/root guards pass. It
rechecks exact scope, operation and SQL DMC2 against protected custody, CASes
and reads back the root before reporting success. Initial Hello and Accept
are not ordinary journal entries. No public completion flag or receipt input.
Failure before completion preserves original pending/phase2 operation. Phase3
means historically verified network storage only, never remote consent,
semantic receipt, current route availability or peer read/delivery.

Expose bounded key-free local retry snapshots only from actual mandatory
ordinary custody plus verified SQL mirror/current initialized catalog under
the account lease. Return original operation32, conversation ID, canonical
MessageCreate text and sequence; never raw events, routes, keys or callbacks.
Check actual account/instance, catalog scope and protected root readback.
Pending SQL may roll forward only from its existing exact protected event;
stable SQL loss or substitution rejects. AttachmentOffer custody is preserved
in the shared namespace but does not export DAM1 or keys through a text UI.

The UI checks unsettled text operations before allocating any new operation,
including after restart. Restore original text/ID for its conversation, block
replacement text or another conversation until explicit exact reconciliation,
and repeat through the existing owned send/Store command. No automatic send
on selection/restart, no text matching used as an idempotency key, no new ID
to bypass expired lifetime or unknown outcome. A completed operation stays
completed even if later UI history refresh fails. Connected crash/reopen and
physical Windows/Android evidence remain separate gates.
