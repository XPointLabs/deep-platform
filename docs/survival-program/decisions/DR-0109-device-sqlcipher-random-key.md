# DR-0109 — current device SQLCipher random-key interpretation

Status: accepted pre-production local clean break; matching focused verified, full/device pending
Date: 2026-10-11
Decision owner: Mr. X (delegated architecture authority)

The device-state database uses its existing nonzero 256-bit, account/instance
domain-separated key as SQLCipher4 random key material, not a password. Install
exactly67 ASCII bytes (`x'`,64 lowercase hex digits,`'`) via `sqlite3_key`, then
wipe the owned buffer. No secret SQL/string/log, reduced KDF iterations, custom
cipher, human-password use or changed network/PQ primitive is introduced.
The constructor keeps the same authenticated connection for subsequent work;
it no longer opens a second keyed connection after validating the first.

This supersedes only DR-0060's device-key interpretation non-change statement.
Device application ID remains DVS1 and `user_version` becomes6. Generation5
password-keyed databases and raw-keyed files with any noncurrent schema reject
before adoption. Both writable owner and read-only compaction-source projection
must use the new interpretation and retain actual encrypted-page/schema/scope,
protected marker/checkpoint, native source and independent floor verification.
FULL synchronization, secure-delete, DELETE journal, foreign keys, no pooling,
integrity checks and disposal/key wiping remain mandatory.

Explicit isolated **whole client-account reset** is required for old local state;
deleting only the device file would lose burns/floors and remains forbidden.
No fallback, second key attempt, rekey, migration, auto-reset or empty replacement
is permitted. Account/message/prekey key modes, protected slot formats, node keys,
server state, network identity and authority windows remain unchanged.

An isolated same-provider measurement on this Windows host found3 authenticated
device reopens7344.9ms; separate identical native probe reopens in password mode
4566.0ms versus raw-key mode5.0ms. Opposite interpretations rejected without file
mutation. These are local opening costs, not dispatch/device E2E or a universal
SLO. The actual Initial failures remain unqualified until matching original
30-second scenarios pass; timeout/authority/assertions must not be relaxed.
Provider guidance: [SQLCipher random keys](https://www.zetetic.net/blog/2019/06/07/technical-guidance-using-random-values-as-sqlcipher-keys/).

Qualification requires encrypted same-mode reopen and durable connection policy;
wrong/zero/short key and old mode/schema refusal without mutation; cold custody,
tamper/crash and read-only projection tests; matching Initial/contact historical
outcome scenarios and final repository full. Physical Android/Windows/release
activation remains a separate requirement, not implied by this local change.
