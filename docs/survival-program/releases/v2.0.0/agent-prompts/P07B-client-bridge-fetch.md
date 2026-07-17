# P07B — Client bridge-source fetch and reconciliation

## Role/repository

Work only in `deep-client-shared`, after P04C fetch contracts and P07 validator/LKG state are pinned.

## Objective

Fetch signed current/future bridge snapshots from multiple replaceable sources, reconcile them by signature/sequence and expose a verified candidate set to the transport coordinator.

## In scope

- online mirror, in-band file and preloaded/offline source adapters behind one source interface;
- parallel bounded source fetch, content hash cache and anti-rollback;
- future-set pre-cache and descriptor expiry/readiness status;
- no source/DNS/TLS trust beyond transport security;
- cold/warm, stale, conflicting and all-source-offline fixtures;
- portable APIs for later MAUI QR/file wiring.

## Out of scope

Signing, bridge deployment, transport racing, QR camera UI and endpoint censorship evasion.

## Acceptance

One malicious source cannot replace LKG; two independent channels pass cold-start fixtures; cached-set coverage is measurable; original bootstrap failure does not block valid offline/in-band import.

