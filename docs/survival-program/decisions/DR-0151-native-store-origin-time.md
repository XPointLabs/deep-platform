# DR-0151 — Native Store origin must cover its exact MEO1

Status: accepted producer correction; connected/full/release gates separate
Date: 2026-10-19
Decision owner: Mr. X (delegated architecture authority)

The native Store producer must not persist an immutable PRQ2 whose CreatedAt
precedes the exact authenticated MEO1.CreatedAt. Independent authenticated
intervals need not have identical upper bounds. A connected failure captured
an origin one second before its MEO1: its apparent object lifetime became
2592001 seconds, exceeding the unchanged30-day limit. The precise published
binary/PDB mapped the failure to VerifyRequest's original ExpiredOrStale branch.
The original role grant still had2016 seconds remaining at peer authoring;
grant expiry is not the explanation for this case. These are diagnostic
differences, not a substitute for current authority.

Before the first peer-intent author callback, read the actual native operation
lease. If its current upper is below MEO1.CreatedAt by at most4 seconds, wait
once for lead+1 seconds (at most5), then perform the same complete current
lease check again. Require actual convergence; never accept a future time
because a timer elapsed. Larger lead, nonconvergence, cancellation or failed
authority rejects before peer intent persistence/reservation/mutation/HTTP.
The outer authenticated client replay reservation may already exist, as in
DR-0139's established pre-peer-intent boundary.

The produced PRQ2.CreatedAt must be at least the exact MEO1.CreatedAt and no
later than that actual native bound. All existing canonical, signature, holder,
revocation, replay, full-interval and post-callback native checks remain. The
original object expiry, zero future-skew rule,120-second admission freshness
and transport deadlines are unchanged. No OS clock, backdating, new wire magic,
schema, provider or suite is introduced.

An already captured original PRQ2 is never rewritten or reminted. Failed older
QA intents remain retained/unqualified; a new profile/group does not recover
them. This decision prevents new impossible captures, not a migration or waiver
for old malformed/stale intent. The real native RED test reproduced the old
peer rejection; GREEN cases additionally require no peer intent/effects on a
nonconverging clock and exercise actual rechecking, cancellation and the bound.
