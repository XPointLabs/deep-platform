# DR-0060 — DID2 account database random-key interpretation

Status: accepted local storage clean break; focused/connected/device verification pending
Date: 2026-10-02
Decision owner: Mr. X (delegated architecture authority)

The DSV2 account database uses its protected independently random 256-bit key
with SQLCipher4's supported raw-key syntax, already used for DMS2 by DR27.
Construct exactly 67 ASCII bytes (`x'`, 64 lowercase hex digits, `'`) in a
wipeable buffer, pass the explicit length through `sqlite3_key`, and wipe it
after native key installation. No secret SQL, immutable hex string, argument,
log or custom cipher. Do not lower password-KDF iterations or apply this mode to
human passwords. Encryption, salt/page authentication, FULL synchronization,
secure-delete, DELETE journal, actual encrypted-page read and complete account/
device/instance/schema/history verification remain unchanged.

This is an incompatible pre-production local generation: retain the DSV2
application ID and DSK2 closed 120-byte record shape, but require DSK2 version3,
DSV2 SQL user_version3 and store_identity cipher_generation3. Generation2
password-keyed account records/databases are rejected before adoption. Explicit
isolated client-account reset is required; no dual key attempt, rekey, migration,
fallback, automatic repair or retained compatibility path. Registered node keys,
network genesis and server floors are unaffected. DMS2 remains generation2 raw
key; separate application/device/prekey databases retain their key interpretation.
This replaces DR27's earlier account-only non-change statement, not its other
contracts or the network crypto/identity suite.

The isolated same-provider measurement on the current Windows machine found
five authenticated reopens: password-key mode3429.3ms, raw-key mode12.3ms; the
opposite key interpretation rejected in both directions. This measures only
connection cost on that machine, not end-to-end delivery or a universal SLO.
See the provider's
[random-key guidance](https://www.zetetic.net/blog/2019/06/07/technical-guidance-using-random-values-as-sqlcipher-keys/).

Focused gates must prove encrypted bytes, same-mode reopen, wrong/zero/short
key refusal, old record/schema refusal without mutation and preserved durable
connection policy. Then rerun the connected contact/Store/Retrieve/semantic/ACK
checkpoint and physical Windows/USB Android scenario. No gate bypass or longer
proof/dispatch lifetime is authorized by this performance change.
