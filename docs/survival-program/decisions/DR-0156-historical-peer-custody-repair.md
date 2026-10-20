# DR-0156 — Historical peer custody repair is not expired Store admission

Status: accepted narrowly scoped operator recovery; qualification separate
Date: 2026-10-20
Owner: Mr. X (delegated authority)

The real orphan's MCG3 expired before this iteration's continuation. CLI retained
the exact E2EE ciphertext and correctly captured a transport successor under
the existing expiry-closure rules; it did not replace the message. That current
successor cannot pass the unrelated old unpaired native inventory. DR-0155 live
grant recovery must NOT be changed to accept the expired grant.

Allocate two local, listener-free XNode commands: current-mailbox-export-store-recovery
and current-mailbox-reconcile-store. They use the ordinary configured native
owners exclusively, with independently CURRENT host/network, both protected MGR
owners, actual clock/floors and full native/protected joins. No enrollment,
reset, key creation, document import or authority/time backdating.

Source export accepts one exact signed original PRQ2. A real independent floor
must bind its native replay, completed non-tombstoned Store mutation and actual
blob. Source signs PSR1 only after those joins. Its current durable-time statement
attests retained custody, not an expired-grant effect or quorum. Export is a new
private bounded file, never stdout or a replacement of the original request.

Receiver reconciliation accepts exact PSR1 and requires the SINGLE existing
pre-effect Pending, no native target/blob, authenticated selected-floor absence
(or its exact interrupted Pending preparation), and complete joins for all other
history. It records only the protected DR-0154 pre-intent and reconciles that
native Pending timestamp to the proven source admission. It performs ZERO Store,
blob, tombstone, ACK, client-counter or receipt effects. No MRR2/quorum is returned.
Readiness cannot run this exceptional transition, and no HTTP repair endpoint is
allocated. Stop the specific native owner before running the same-volume command.

Historical grant authentication is a separate Protocol owner, never calling a
current-grant verifier with a historical current clock. It verifies exact PMT2
membership/ranking and continuous cohort in current retained history, the SAME
current PMA2 namespace, original issuer signature/lifecycle/generation/lifetime,
and source-proven admission within the original signed grant interval. Current
host authority/time checks surround it. Different PMA2 namespace or missing
history rejects rather than enabling a generic cross-policy restore adapter.

Protocol adds PrepareHistoricalStoreSourceAsync and
PrepareHistoricalStoreRecoveryAsync on VerifiedMailboxHostAuthorityV2. Returned
closed preparation carries historical custody only, never a current grant.
No new wire/schema/domain/version, timeout or lifetime is allocated. The exact
old PRQ2 remains immutable; a successful current transport successor must be
reported separately from the expired original's unqualified quorum.

Require actual expired-grant refusal on the live path, source floor/effect joins,
metadata-only cold repair, invalid source/extra orphan/native effect refusals,
and interrupted protected preparation recovery before applying locally.
