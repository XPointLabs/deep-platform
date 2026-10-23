# DR-0174 — Owned connection contact-maintenance cycle

Date:2026-10-23. Status: accepted consumer increment. Owner: Mr. X.

## Evidence and ownership

Retained full CLI57 passes, but an original attachment offer subsequently
refuses expired peer XRA1. Explicit authenticated Bob→Alice route maintenance
recovers that SAME offer without reset/rekey. DR-0078's existing publication
owner already renews at its signed proactive margin; the portable connection
consumer did not compose publication, receive and all-contact advertisement.
CONTACT-RESOLVER owns publication scheduling, CONTACT-AND-GROUP owns native
route controls, and TRANSPORT-NEUTRAL-MESSAGING owns original Store/ACK recovery.

## Decision

Add one Shared connection-maintenance operation, consumed by CLI `network
maintain` and normal CLI connection activation (`network verify`):
authenticate/renew own publication ONCE through its existing saga;
process one ordinary bounded mailbox page with independent native receive/ACK;
read actual owned conversations; inspect every retained mutually accepted
device scope; advertise the adopted own publication through the existing exact
route-control author/native/Store owners. Pending requests are not consent.
Do not deduplicate distinct device scopes merely by logical conversation ID.

Network bootstrap's publish-only API remains publish-only: it may precede
installation of the messaging evidence owner. The connected host explicitly
uses `VerifyAndMaintainContactsAsync` AFTER installing that owner, reusing the
same admission verifier. This method cannot install/substitute messaging
authority. CLI profiles already compose the actual native messaging owner;
Windows/Android integration and periodic scheduling remain separate gates.

Health is a denial-only scheduling hint. A retained route fault always defers
that contact without dispatch. An expired peer advertisement also remains
deferred until an ordinary receive adopts its reply. The caller may supply an
existing known-address book, copied and bounded before admission or callbacks;
it is data, not authority. Only for an expired, non-faulted peer with that actual
descriptor may the cycle invoke DR-0159's existing strict native control owner.
Missing descriptors never trigger capability inference or a new relationship.
Sending this control does not promote the resolved publication into an ordinary
peer route. Re-introductions are counted separately within stored controls;
that same contact may still be deferred. A valid historical XUR's
elapsed interval alone does not replace the real delivery verifier. Every
selected effect still independently verifies native scope/consent/predecessor,
current endpoint/network/time and original command/ciphertext/attempt custody.
Actual owner failures propagate; no fallback, replacement control or successful
health Boolean suppresses an effect refusal. Unknown/duplicate metadata and
cancellation reject before further callbacks. Return only diagnostic counts,
including deferred contacts and ordinary mailbox HasMore, never readiness or
permission. One contact's health-based deferral does not starve other eligible
contacts; a real effect-owner failure still stops the cycle with original custody.

This allocates no wire, crypto, journal/schema generation, counter or lifetime.
It neither infers resolver-read capability from a DID2 hash nor promotes a
resolved publication as an ordinary private peer route. DR-0159 re-introduction
still requires its actual supplied address/capability and native control joins.
Old failed commands and retained custody remain intact.

## Qualification boundaries

Run scheduler unit negatives and unchanged real publication/route-control
owner tests, then the real cycle on the SAME three retained CLI accounts and
new group58; no manual per-contact repair may substitute for that consumer.
Test the actual persisted/native owners in connected runs; scheduling delegates
in unit tests are explicitly not proofs or E2E evidence.

The connected test may explicitly read the SAME three owners' public descriptors
through `account address`, keeping them in RAM/private session input only.
`network publish` performs publish-only bootstrap before convergence; it does
not receive, advertise or accept known-contact metadata. The maintenance consumer
visits ALL retained accepted scopes, not just the three running accounts. Older
offline contacts remain explicit deferrals; qualification requires actual native
route health for all six running-cohort directions, not zero global deferrals.
No per-contact refresh/re-introduction command in the driver may replace this
Shared consumer. Test passes are planned convergence opportunities, not retries
of failed commands or re-authoring pending work.

CLI's composite cycle budget does not extend any individual transport/lease
or signed deadline. A failed/partial cycle is not connection readiness. Safe
periodic/background scheduling, durable address-book/descriptor exchange,
scale, physical clients and release qualification remain required subsequent
work; this consumer increment does not claim they are complete. DR-0173 idle
authority checks remain key-free hints and are not replaced by expensive polling.
