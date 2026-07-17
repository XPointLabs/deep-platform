# Sprint 08 — field validation and Survival Beta gate

Duration: 2 weeks minimum for final evidence, while carrier, security and cost work starts in Wave 0. Extend rather than waive a release gate. This is not commercial GA.

## FLD-01: censorship and carrier matrix

Test representative Russian mobile/fixed networks and controlled impairment profiles:

- DNS unavailable/poisoned;
- original bootstrap IPs blocked;
- 50% and 90% bridge endpoints unreachable;
- TLS/SNI/HTTP anomalies and connection throttling;
- only system proxy works;
- Internet absent but LAN/BLE/LoRa available.

Record time-to-connect, delivery success, metadata exposure and battery cost. Use authorized test environments and do not interfere with third-party networks.

## FLD-02: node/storage chaos

- 1 of 3 replicas unavailable, then restored stale;
- provider/ASN outage and membership epoch transition;
- core node compromise simulation and invalid checkpoint;
- ingress fleet replacement without message loss;
- billing, chain, push and object-store partial outages;
- restore from backup and key-rotation drill.

No acknowledged small message may be lost under the documented one-replica failure model.

## FLD-03: security and privacy review

Commission focused review of bundle metadata, membership signatures, bridge/core separation, entitlement unlinkability, storage proof inputs, P2P handshake/replay, update signing and log retention. Resolve critical/high findings or explicitly stop release.

Publish precise claims and residual limitations. “Anonymous” requires a defined observer and conditions.

## FLD-04: battery and usability gate

Measure representative low/mid/high Android and supported iPhone models for idle, ordinary daily use and emergency nearby mode. Compare with Sprint 04 baseline. Validate that default mode does not maintain constant BLE scan or aggressive polling.

## BUS-01: cost and price validation

Model 100k, 1M and 10M monthly active users using measured replicated byte-days, bridge egress, TURN, probes, support and payment fees. Validate Free/Plus/Pro quotas and at least 65% target paid gross margin. Revise catalog, not privacy guarantees.

Run V3 node rewards in shadow and confirm self-traffic has no effect. Review operator/provider concentration.

## REL-01: operations and distribution

- reproducible signed builds and update-key recovery drill;
- signed membership emergency rotation;
- bridge rollout/retirement runbook;
- public status and private sensitive inventory separation;
- incident, abuse, refund and entitlement-support procedures;
- self-hosted deployment guide and profile export/import.

## Go/no-go gates

GA requires:

1. free offline P2P works with no wallet/subscription/Deep endpoint;
2. self-hosted profile passes isolation test;
3. managed storage passes durability and repair gates;
4. signed membership rejects rollback/forgery;
5. transport recovery and battery thresholds pass;
6. no unresolved critical/high security finding;
7. entitlement expiry cannot disable free plane;
8. node rewards use no user-traffic signal;
9. free quota is economically modeled at 10× launch scale;
10. rollback and incident owners are named.

The final evidence pack includes test versions, dates, environments, failures, mitigations, residual risks and an accountable decision owner.
