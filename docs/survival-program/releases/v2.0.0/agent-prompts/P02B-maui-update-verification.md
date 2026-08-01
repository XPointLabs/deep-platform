# P02B — MAUI update metadata and offline Android verification

## Role/repository

Work only in `deep-client-maui` after P02 production-like metadata contract/pipeline is pinned.

## Objective

Verify signed update metadata and an offline-transferred Android APK without weakening platform package signing.

## In scope

- consume root/targets/snapshot/timestamp metadata and fail on rollback/freeze/mix-and-match;
- verify artifact hash/length and Android package signer before install handoff;
- show version/source/expiry and explicit manual confirmation;
- store last trusted versions atomically;
- rotation/revoke fixtures and compromised-mirror behavior;
- document iOS limitation; no unsupported sideload claim.

## Out of scope

Production root custody, downloading around network policy, silent install, iOS bypass and signing APKs.

## Acceptance

Valid offline package passes; wrong signer/hash/stale metadata fails; current signing key is never bundled; rollback state survives app restart; UI communicates failure without offering unsafe override.

