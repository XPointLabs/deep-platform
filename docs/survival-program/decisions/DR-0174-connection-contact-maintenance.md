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

A current public route interval does not make the peer's native announcement
current. For selected outgoing control work, the owner may establish that the
peer announcement alone has expired after checking its authenticated endpoint,
creation inside the signed route interval, current authority, fault state and
trusted time. Only then may connected maintenance select the existing
known-address reintroduction path. It independently resolves that descriptor
and verifies the same peer, device, session and consent before dispatch. Missing
address means deferral; other invalidity still rejects. Keep the original
operation and ciphertext, including after a partial native send. Neither an
expired outgoing control nor an unconfirmed Store gains authority by this rule.

This allocates no wire, crypto, journal/schema generation, counter or lifetime.
It neither infers resolver-read capability from a DID2 hash nor promotes a
resolved publication as an ordinary private peer route. DR-0159 re-introduction
still requires its actual supplied address/capability and native control joins.
Old failed commands and retained custody remain intact.

For the same endpoint, explicit maintenance may renew a settled, still-current
announcement during the final 20% of its authenticated lifetime. The prospective
expiry uses the author's existing signed time bounds. If those bounds cannot
extend the current announcement, maintenance does no work. Before reserving an
elective replacement, the author independently rechecks the actual settled head,
native floor and new expiry; the new expiry must be strictly later. An unfinished
original keeps priority. This rule neither extends an original's lifetime nor
changes how an expired or otherwise inadmissible announcement is verified.

## Qualification boundaries

Run scheduler unit negatives and unchanged real publication/route-control
owner tests, then the real cycle on the SAME three retained CLI accounts and
existing group; no manual per-contact repair may substitute for that consumer.
Test the actual persisted/native owners in connected runs; scheduling delegates
in unit tests are explicitly not proofs or E2E evidence.

The connected test may explicitly read the SAME three owners' public descriptors
through `account address`, keeping them in RAM/private session input only.
`network connect` seeds the protected book without foreground publication or
per-contact repair. The maintenance consumer visits ALL retained accepted
scopes, with three known-address turns followed by one unknown-address turn. Older
offline contacts remain explicit deferrals; qualification requires actual native
route health for all six running-cohort directions, not zero global deferrals.
No per-contact refresh/re-introduction command in the driver may replace this
Shared consumer. Test passes are planned convergence opportunities, not retries
of failed commands or re-authoring pending work.

The foreground connection cycle visits the accepted contacts in its bounded
address book. An idle CLI session schedules one accepted contact per turn and
yields to foreground work. Actual known descriptors are stored under the
account and instance binding and are checked against the existing relationship
before use. The session can seed these descriptors through its private command
stream. An interrupted control retains its original intent. The enclosing
scheduler budget preserves each signed deadline and each transport deadline.

Actual processed-page, stored-control or reintroduction progress permits the
next idle opportunity after10s. No progress, cancellation or failure keeps60s.
Detailed own-chain diagnostics are an explicit diagnostic read, excluded from
the scheduler's ordinary health call. Ordinary delivery's independently current
DMC2/14 authority remains distinct from the current-XUR lifecycle criterion;
measuring one never qualifies the other.

For established delivery, strict Store admission checks the current private
DMC2/14 route announcement. The independent XUR1 accepted during the native
handshake describes the contact's update rendezvous. Its successor is carried
by the count9 private announcement and verified against the original device
and accepted direction. Readiness evidence distinguishes a current delivery
route from a current, durably adopted rendezvous. [XUR1 carriage](../../architecture/CONTACT-RESOLVER-V1.md#35-established-contact-update-service-xur1--xuw1--xuq1--xus1)

An idle cycle may ACK a nonempty page containing only authenticated, durably
consumed DMC2/14 controls. The ordinary ACK owner independently reconstructs
the exact page and current authority. Mixed/application pages remain pending;
classification failure never grants ACK authority. The retained experiment
uses private `network connect` to seed known addresses and start the scheduler,
without foreground publication or per-contact repair.
