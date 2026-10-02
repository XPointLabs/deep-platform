# DR-0066 — application/mailbox SQLCipher random-key interpretation

Status: accepted local storage clean break; focused/connected/device gates open
Date: 2026-10-02
Decision owner: Mr. X (delegated architecture authority)

The subsequent [DR-0067](DR-0067-did2-ordinary-store-completion-and-ui-retry.md)
advances the mandatory application registration again for its ordinary-command
clean break; random-key interpretation and DMB1 generation7 below remain current.

The DMB1 application/mailbox database accepts only an independently generated
or domain-separated pseudorandom nonzero 256-bit binary key, never a password.
Use SQLCipher4's supported raw-key encoding as in DR27/DR60: exactly 67 ASCII
bytes (`x'`, 64 lowercase hex digits, `'`) through sqlite3_key with its explicit
length, in a wipeable buffer cleared immediately after installation. No secret
SQL, immutable key string, lower password KDF, custom cipher or connection cache.

This supersedes DR60's application-only non-change statement. DMB1 user_version
advances from 6 to 7 without altering its tables; mandatory account-owned
application registration remains 116 bytes but requires version2 in byte0,
with unchanged initialization state in byte1 and exact scope/key commitment.
New registration is written in the existing atomic account creation batch.
Old password-keyed SQL/schema6 and registration1 are rejected before adoption;
explicit isolated QA account reset is required. No migration, rekey, dual key
attempt or implicit recreation. DSV2/DMS2, node keys, network genesis and server
floors are unchanged. This is not a human-password performance shortcut.

Keep encrypted-page and complete schema/row/floor checks, FULL synchronization,
secure-delete, its existing WAL journal, semantic-before-ACK reconstruction and all
proof/signing/30-second dispatch deadlines. The joined application-command
test timed out during the final repeated semantic ACK fence after reverse
acceptance. DMB1 still passed a random binary key through password-key mode on
every non-pooled open; DR60's same-provider isolated measurement established
that the modes have materially different connection cost. This identifies a
concrete unnecessary cost, not proof that it alone caused the observed timeout.

Focused tests must prove encrypted bytes, correct-mode/schema7 reopen,
wrong/zero/short-key refusal, old password-mode/schema6/registration1 refusal
without mutation, and preserved connection policy. Then rerun the unchanged
connected contact/accept/text/replay/semantic-fault/lost-ACK checkpoint. A green
component or faster run is not physical Windows/USB Android delivery evidence.
Full API/graph/package/consumer review remains the final batch gate.

Provider rationale: [SQLCipher random-key guidance](https://www.zetetic.net/blog/2019/06/07/technical-guidance-using-random-values-as-sqlcipher-keys/).
