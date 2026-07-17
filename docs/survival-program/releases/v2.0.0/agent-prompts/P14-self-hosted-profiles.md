# P14 — Self-hosted network profiles

## Role

Work only in `C:\Work\DeepSession\XPointLabs\deep-client-shared`. A later MAUI task owns QR/file UX.

## Objective

Implement portable import/export/validation and profile selection for an independent self-hosted network with no Deep billing/discovery dependency.

## Contract

Profile includes version, independent network genesis, trust roots/delegations, membership/bridge source locations, storage policy, display label, expiry/rotation metadata and signature. A source is transport only, never authority: every accepted update chains to the profile genesis/delegation. It never contains private signing keys or a Deep subscription requirement.

## In scope

- canonical profile parser/validator and strict limits;
- encrypted local persistence, backup/export representation and corruption handling;
- isolated profile selection; combining official/self-hosted networks requires explicit policy;
- recovery/root rotation information and multi-admin threshold compatibility;
- tests with DNS and every official Deep endpoint disabled;
- clear metadata-guarantee model exposed to the UI consumer.

## Out of scope

One-command server deployment, QR camera UI, creating operator keys, billing and silently trusting an unsigned file.

## Acceptance

Imported valid profile enables send/store/read without any official endpoint; invalid/rollback/unknown genesis fails; selecting self-hosted does not instantiate billing; export/import round-trip preserves canonical identity and no private key leaks.

## Verification

Run all shared-client tests plus persistence migration and isolated-network E2E fixture. Handoff UI and operator-deployment requirements separately.
