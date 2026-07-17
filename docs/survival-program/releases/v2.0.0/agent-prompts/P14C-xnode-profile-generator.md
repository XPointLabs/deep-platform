# P14C — Self-hosted operator profile generator

## Role/repository

Work only in `xnode`. Do not edit DevOps deployment.

## Objective

Generate a signed public self-hosted profile from an independently initialized network genesis without exporting private roots.

## In scope

- operator command/config validation for genesis/delegations/public sources/policy;
- deterministic canonical profile and QR/file payload output;
- threshold/multi-admin signing interface, rotation/revoke and backup/recovery runbook;
- public fingerprint/display information;
- compatibility version/support window.

## Out of scope

Client UI, storing private keys in profile, creating production roots without ceremony and compose deployment.

## Acceptance

Profile verifies through P14 fixtures; private material never enters artifact/log; rotation/recovery drill works with test keys; single unauthorized admin cannot change threshold network policy.

