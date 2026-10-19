# DR-0153 — bounded automatic owned mailbox continuation

Status: accepted for connected client orchestration; live qualification is separate
Date: 2026-10-19
Owner: Mr. X (delegated architecture authority)

The normative owner is
[Transport-neutral messaging, retry/failover](../../architecture/TRANSPORT-NEUTRAL-MESSAGING.md#82-retry-and-failover).
This amends DR-0056's return-to-caller-on-first-unknown behavior at the owned
business boundary, not the single-attempt adapter or any wire/crypto rule.

A changed control-plane source must still deny an old in-effect capability. That
denial may follow durable work, so it cannot imply absence of effects. The business
owner may close the old loan and resume the original protected Store or mailbox
page/ACK once, with new independent current-authority checks. It never reruns
queue/create/group action. Reconciliation and exact prepared request/grant/route/
counter/semantic custody remain in the existing owners. Live original attempts
remain byte-identical; separately authenticated owner-only retirement/succession
rules are unchanged, with original audit tails and semantic dedup preserved.
The helper authors neither replacement ciphertext nor a transport successor. Unsupported original
binding, expiry, rollback or revocation rejects; no silent destination/profile
fallback or relaxed guard policy is introduced. Fresh outer ONION framing is not
a replacement semantic message or permission to change captured inner bytes.

An existing protected retry lease may cause one bounded35s scheduling wait before
the owner checks it again. The wait does not authorize replay or change any
deadline. Another unknown or denied authority remains pending/unknown. Cancellation
stops without resetting custody. Driver-attempt1 is reported separately from owned
automatic resumes and waits, never advertised as wire-attempt1.

Focused evidence includes real encrypted account/SQLCipher/native lost-Store and
lost-ACK recovery: original exact request/counter, one native semantic event,
single durable tombstone and cold retained-state checks. Scheduling unit tests
are not socket/device evidence. Three-CLI receipts and retained first-attempt
failures are recorded in the [current checkpoint](../../../deep-cli/docs/testing/cli-dtt-send-2026-10-19.md).
