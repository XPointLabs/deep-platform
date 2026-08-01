# Sprint 03 — signed membership and disposable bridges

Duration: 2 weeks. Exit outcome: a client can learn valid new bridges and nodes without an app release or blind trust in a directory server.

## MEM-01: signed membership checkpoint

Define a canonical, versioned checkpoint containing epoch, validity window, protocol minimum, role manifests, node public keys/capabilities, and previous checkpoint hash. Sign with a threshold/quorum policy; embed only long-lived verification anchors and emergency recovery rules in the app.

Acceptance: valid forward update succeeds; unsigned, expired, rollback and unknown-key updates fail; controlled key rotation and clock skew are tested; cache permits startup during directory outage.

## MEM-02: dynamic client trust

Replace the assumption that all allowed `RouterIds` must come from the embedded three-node file. Current pins remain bootstrap anchors during migration. The client validates checkpoint signatures before accepting router/storage identities and retains last-known-good state.

Do not accept a node solely because HTTPS or DNS succeeded.

## BRG-01: separate ingress from core/storage

Create an ingress role that terminates the outer transport and forwards authenticated opaque frames into the core overlay. It should be disposable, horizontally scalable and hold no durable mailbox state. Core and storage addresses are not returned as public bootstrap endpoints.

## BRG-02: short-lived bridge descriptors

A signed descriptor contains bridge ID, transport, endpoint, validity, server key material/camouflage configuration and capability limits. It can be delivered via multiple interchangeable channels: cached peers, official directory mirrors, QR/file import and already-established sessions.

Descriptors are not secrets; their rapid rotation and plurality are the resilience mechanism. Do not depend on domain fronting or impersonating third-party domains.

## BRG-03: operator and deployment path

Add separate deployment units/configuration for ingress and core/storage in `deep-devops`, health checks and emergency bridge issuance. A bridge compromise must not reveal storage keys or let it sign membership.

## Tests

- bootstrap with all original three endpoint IPs unreachable but a valid imported descriptor present;
- 50% descriptors stale/blocked;
- malicious directory returns a validly formatted but unsigned checkpoint;
- ingress restart loses no acknowledged stored message;
- checkpoint rollback and recovery-key drill.

## Out of scope

Automated covert distribution through third-party services, final reward scoring and LoRa.

