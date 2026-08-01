# P00B — Pinned multi-repository manifest and CI

## Role/repository

Work only in `C:\Work\DeepSession\XPointLabs\deep-devops` after P00A is accepted.

## Objective

Implement manifest validation and integration checkout using exact child-repository SHAs and local immutable contract artifacts.

## Manifest contract

Each entry contains repository URL/name, branch for information, exact 40-hex SHA, contract artifact name/version/SHA256, program revision and evidence status. Floating refs are invalid for integration evidence.

## In scope

- schema and validator;
- example manifest using current verified SHAs;
- CI checkout into isolated directories at exact SHAs;
- dependency compatibility assertions and artifact hash verification;
- fail-closed dirty/missing/incompatible cases;
- standard artifact/handoff schema validation;
- offline/local package feed location; no external publication.

## Out of scope

Editing child repos, choosing product contract semantics, merging, deploying or publishing packages externally.

## Acceptance

Tests reject branch-only refs, unavailable/dirty SHAs, wrong program revision and artifact hash; positive CI evidence reports actual checked-out SHA for every repo; current release gates remain fail-closed.

## Verification

Run `node .\scripts\release-gate-contracts.mjs`, `node .\scripts\production-readiness-status.mjs` and focused tests from `AGENTS.md`.

