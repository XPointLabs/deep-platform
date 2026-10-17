# DR-0139 — recover the gap before the first current Store intent

Status: accepted semantic correction; source/connected/full qualification pending
Date: 2026-10-18
Decision owner: Mr. X (delegated architecture authority)

Real CLI text retry reached `ReserveStoreCoreAsync` and failed with “Known
current Store replay has lost its exact peer intent.” That guard alone did not
identify its cause. A separate genuine native fixture reproduced client MAU
replay reservation/floor -> cancellation -> no first Store intent: the old
guard treated every pending MAU replay as proof of a previous PRQ2. This
decision fixes that source gap, not an inferred absence of real CLI effects.
Later connected diagnosis found native Store custody for the CLI ciphertext;
[DR-0140](DR-0140-attempt-scoped-mailbox-object-key.md) addresses that distinct
producer collision. No pre-intent noncommit claim is made for those CLI runs.

The sole normative owner is [XPOINT-NETWORK §9.1](../../architecture/XPOINT-NETWORK-V1.md).
For an independently current exact `NewReserved` or `InFlight` request with no
recovered canonical outcome and no native Store mutation, the existing native
ledger may allocate its first intent after authenticating its complete current
protected snapshot. The existing ledger lock, scope/prefix rules, anchored
Prepare/Commit and actual snapshot hash enforce exactly one cursor/PRQ2.
An already present intent is returned unchanged. This is not a cache miss or
SQL absence assertion: missing files, rollback, corrupt/missing anchored stages
and replay/outcome/native-effect joins still fail closed. Actual original intent
loss cannot be repaired, a completed request cannot allocate again, and no
original nonce/counter/ciphertext is rewritten. Existing Store prefix settlement
or expiry-exclusion requirements remain unchanged.

No wire, public API, schema/journal generation, slot, lifetime extension,
compatibility reader, operator key change or account/node reset is allocated.
The new fixture first persists the real client replay/floor without ever
authoring an intent, cold-reopens the genuine native owners, then requires one
first intent, one remote write and exact cached replay. Missing/rollback tests
before/after mutation remain mandatory, as do real retained CLI text and full
source/package qualification. This decision is not release approval.

## Exact source-case replacements

The former two positive refusals encoded the wrong inference despite asserting
that zero intents had ever been authored. Preserve their original failed or
baseline TRX; current replacements must actually pass. No other missing case
is waived. Capture this decision in the canonical full gate.

```text
XNode.IntegrationTests.Runtime.CurrentMailboxPeerHttpTests.CurrentReplayFloorWriteFailureCannotDispatchOrRemintMissingExactIntent(beforeReplace: False) -> XNode.IntegrationTests.Runtime.CurrentMailboxPeerHttpTests.CurrentReplayFloorWriteFailureColdJoinsBeforeFirstIntentAndResumesExactlyOnce(beforeReplace: False)
XNode.IntegrationTests.Runtime.CurrentMailboxPeerHttpTests.CurrentReplayFloorWriteFailureCannotDispatchOrRemintMissingExactIntent(beforeReplace: True) -> XNode.IntegrationTests.Runtime.CurrentMailboxPeerHttpTests.CurrentReplayFloorWriteFailureColdJoinsBeforeFirstIntentAndResumesExactlyOnce(beforeReplace: True)
```
