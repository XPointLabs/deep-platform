# P14B — MAUI self-hosted profile import and mode UX

## Role/repository

Work only in `deep-client-maui` after P14 shared APIs are pinned.

## Objective

Implement QR/file import, validation result, profile selection and mode/privacy disclosure without exposing keys or silently contacting Deep.

## In scope

- QR/file picker adapters and size/format validation;
- explicit genesis/network label/fingerprint confirmation;
- official vs self-hosted mode selection and metadata guarantee display;
- stale/invalid/rollback/recovery states;
- automation IDs/ViewModel/smoke tests;
- no billing service registration in isolated profile mode.

## Out of scope

Profile cryptography/parser changes, operator deployment, camera library invention and combining networks implicitly.

## Acceptance

Valid import/select works; unsigned/unknown/rollback fails; sensitive profile/private data is absent from logs; isolated mode starts with official discovery/billing disabled.

