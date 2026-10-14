# DR-0115 — exact prepared Registry directory commit

Status: accepted S05 internal lifecycle; source qualified, live process/volume recovery pending
Date: 2026-10-14
Decision owner: Mr. X (delegated pre-production architecture authority)

## Boundary and sole owner

[ACCOUNT-DIRECTORY](../../architecture/ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md)
owns the atomic map/log/head and independent-floor requirements. Registry's
internal mutation owner persists a bounded, HMAC-authenticated exact ADA2
candidate at its configured state path plus `.pending`, under the same file
lease, before the existing external exact-head CAS. This is the same complete
ADA2 record, not a new magic, schema, wire field, public API or authority marker.
The primary ADA2 and independently restored external floor remain mandatory.

## Completion, not repair

Only the admission/renewal mutation owner may finish a prepared commit, under
its existing authority gate and authenticated-time budget. It authenticates
both full files and their signatures from the unchanged genesis and verifies
the exact primary prefix and one successor. If both files are byte-identical,
the external floor must already match before pending cleanup. Otherwise the
floor must equal that exact successor or the exact primary predecessor; only
the latter permits CAS to the already signed candidate. Unknown outcome is
resolved by independent exact read-back, never a locally reported trust flag.
The same candidate replaces local ADA2 atomically, then pending custody clears.
No head or admission is regenerated to complete this intent.

Missing/corrupt primary, pending HMAC/signature failure, changed prefix, fork,
missing/unavailable/unrelated external floor, unsupported bytes and lifetime
violations fail closed before replacement. Pending files are not backups from
which a lost floor or corrupt primary may be repaired. Preserve them in a
quiescent backup with their primary and independent floor restore domain.

[DR-0013](DR-0013-readonly-directory-issuance-readiness.md) remains unchanged:
readiness/history/proof reads refuse an unfinished pending commit and do not
sign, consume a nonce, complete CAS or mutate files. The bounded mutation worker
can recover and then independently renew an expired head under current authority.
Completion of historical intent alone is not current-proof permission.

## Required evidence

Pre-CAS interruption, ambiguous successful CAS, persistent local rename failure,
completed local replacement with pending cleanup interrupted, cold author restart,
exact admission retry, expiry after interruption, concurrent flights, missing
floor and corrupt/substituted candidate/primary must preserve exact history and
identity without manual edits. Source/full and retained-volume/live/device gates
remain separate. No production deployment, release publication or main promotion.
