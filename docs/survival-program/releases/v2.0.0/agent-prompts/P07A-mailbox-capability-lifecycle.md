# P07A — Client mailbox capability lifecycle

## Role/repository

Work only in `deep-client-shared` against pinned P03A/P03B packages.

## Objective

Implement contact bootstrap/exchange, storage and rotation of deposit/retrieve capabilities without exposing recipient master secrets or billing dependencies.

## In scope

- generate/store recipient retrieve material via approved adapter;
- issue contact-scoped rotating deposit capability and placement key;
- exchange only through authenticated E2EE contact/session path;
- overlap/rotate/revoke/recovery and device migration state machine;
- mixed legacy/v2 contacts, downgrade resistance and feature flag;
- SQLite/in-memory aligned migration, corruption and backup boundaries;
- APIs for P09C mailbox adapter; no raw IDs in diagnostics.

## Out of scope

Storage validation, cryptographic primitive invention, UI, payment and public free-admission issuance.

## Acceptance

Sender never gets retrieve capability/master secret; revoked contact cannot use new generation; overlap prevents expected in-flight loss; legacy contact remains explicit compatibility mode; persistence migration/rollback preserves existing contacts.

## Verification

Run shared solution/persistence/service tests and standard artifacts. Lock SQLite migration files against P11A/P14.

