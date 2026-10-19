# DR-0152 — Pending client ACK before first peer intent

Status: accepted recovery correction; connected/full/release gates separate
Date: 2026-10-19
Decision owner: Mr. X (delegated architecture authority)

An authenticated MAU replay reservation can survive interruption before the
first complete ACK peer-intent batch is saved. An InFlight client counter is
not evidence that this batch ever existed. Treating it as such permanently
rejects an otherwise current exact retry.

For NewReserved or InFlight only, permit first capture under the existing
authenticated operation-ledger/custody owner when the exact batch is absent,
there is no recovered outcome, and independently joined native peer replay
floors contain no tombstone fact for any requested target. Existing batches
must be reused byte-for-byte. Missing batches with a recovered outcome,
tombstone reservation/mutation or other completed replay state fail closed.
Use the native target-key implementation, not a second identity formula.

First capture still requires the original continuation signature, page digest,
expiry, current target read and every existing authority/revocation/lease and
post-callback check. Save the whole batch before peer reservation, mutation or
HTTP. A counter alone does not prove historical token validity; expired
uncaptured pages are not granted recovery admission. No timestamp is extended,
request reminted, journal/schema/wire allocated, or old state reset.

Native RED reproduced the lost-intent rejection for final and nonfinal pages.
GREEN exercises actual cold reopen, exact retry, durable quorum and subsequent
replay without additional peer HTTP. Negative cases repeat hostile continuation
requests and remove an ACK batch from a test-owned reprotected document while
retaining independent actual tombstone floors; neither may capture new intent.
