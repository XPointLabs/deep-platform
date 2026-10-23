# DR-0173 — Idle public authority scheduling is not a borrow

Date: 2026-10-23. Status: accepted. Owner: Mr. X.

## Evidence

The serial CLI host polls idle maintenance every ten seconds. Its due check
called the complete working-authority borrow before reading the deadline. This
reopened protected state and validated directory/network/issuer custody even
when no refresh was due, and acquired unused authority after independent ACK
had discarded the memo. Three idle hosts could therefore compete with delivery.
Delivery-recovery54 records cumulative maintenance of77–203s on some sessions;
these observations establish unnecessary work, not its entire latency cost.

## Decision

Idle maintenance may read the retained PUBLIC context's original deadline as a
denial-only scheduling hint. An absent memo does no work: the next business
operation acquires authority on demand. A context farther than thirty monotonic
seconds from its original deadline does no protected/network validation merely
to decide whether to refresh. Actual same-boot nondecreasing clock, active scope
and cancellation remain checked, including across memo discard.

A due refresh uses the existing complete acquisition/verification producer.
Every actual business borrow retains its independent protected directory,
account/device, network history/fork, issuer and freshness validation. A skipped
poll returns no authority, successful read, permission or availability assertion.
It never updates a proof deadline, captured loan/request, nonce or replay floor.
Fresh ACK remains independent. Explicit refresh remains unchanged.

No wire, schema, algorithm, journal lifecycle or native/SQL protection changes.
No accounts, acquisitions or retained custody are reset or removed.

## Verification

Focused tests cover missing/current memo without protected reads or proof
requests, on-demand acquisition, due refresh, changed fork floor rejected on
business borrow, cancellation and monotonic rollback after discard. The same
three retained CLI profiles must recover original55 before any new round.
Recovery and ordinary delivery timings are reported separately; focused tests
and a scheduling reduction are not full/release or end-to-end speed claims.
