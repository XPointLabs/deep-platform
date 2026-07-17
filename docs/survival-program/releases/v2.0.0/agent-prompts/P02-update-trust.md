# P02 — Update trust, offline distribution and rollback ADR

## Role

You own release security design in `C:\Work\DeepSession\XPointLabs\deep-devops`. Do not modify application runtime.

## Objective

Define and prototype a TUF-like update evidence model that remains verifiable when stores or Deep domains are unavailable.

## Inputs

Read `AGENTS.md`, release workflows/runbooks, MAUI packaging/signing configuration, current artifact gates and [The Update Framework specification](https://theupdateframework.github.io/specification/latest/).

## In scope

- ADR for offline root, delegated targets, snapshot/timestamp roles, thresholds, expiry and key separation;
- anti-rollback, freeze and mix-and-match test fixtures;
- reproducible build/SBOM evidence contract;
- compromised-CI and lost-key recovery runbooks;
- Android offline APK verification using the existing package signer;
- exact residual limitations for iOS distribution;
- CI prototype that validates signed test metadata with non-production keys.

## Out of scope

Production key generation/import, publishing an APK, store submission, auto-update UI, bypassing platform signing or weakening current gates.

## Acceptance

- signing root is not stored in ordinary CI;
- test verifier rejects rollback/freeze/mix-and-match/unknown signer;
- root rotation and lost-online-key drill are reproducible;
- offline Android artifact verification checks both metadata and package signer;
- iOS limitations are explicit, not papered over.

## Verification

Run affected DevOps contract/readiness checks and focused tests. Archive only public test metadata—never secrets.

