# DR-0096 — mailbox selection-epoch continuity

Status: accepted S01 verification prerequisite; retirement API/activation remain open
Date: 2026-10-06
Decision owner: Mr. X (delegated architecture authority)

## Verified defect

The complete network verifier authenticated exact append-only PMT2 generations
and predecessor hashes, but did not reject a decreasing tag6 selection epoch.
Four newly signed successor fixtures reproduced acceptance of `7 -> 6 -> 9`
and `7 -> 8 -> 7`, both with a process-local predecessor and with actual exported
DNH2 restored against the complete signed history. These are source fixtures,
not evidence that production signers have issued such a chain.

An increasing record generation is not an irreversible replay-epoch floor.
MCG3 current admission compares its epoch to the current PMT2 selection epoch;
the replay namespace includes that epoch. S01 cannot rely on an epoch advance
as permanent exclusion while a later accepted PMT2 may lower it.

## Decision and sole owners

The selection epoch is nondecreasing at **every** authenticated PMT2 step.
Equality permits ordinary projection renewal inside the same selection epoch;
an advance need not be exactly one. This adds no field, magic, suite, algorithm,
signature input, wire version, local reader or public API. The normative network
rule is owned once by
[XPOINT-NETWORK section9](../../architecture/XPOINT-NETWORK-V1.md#9-mailbox-placement-and-storage-swarms).
Existing canonical DNH2/DNF2 and complete protected-predecessor binding remain
DR-0012-owned. No old floor is deleted, migrated or regenerated.

Verification authenticates the candidate signatures before applying the epoch
rule and rejects any lower epoch before minting a current network capability.
Full-history restoration checks every step, not only the terminal epoch. A newer
terminal epoch cannot conceal an intermediate decrease. Unchanged tips and
unchanged epochs remain valid under all existing lineage/time checks.

This does **not** turn XNF1/NFP1 into mailbox-epoch retirement authority. The
tuple-only forward-checkpoint path lacks an authenticated exact DNH2 predecessor
binding and cannot replace an existing client/node DNH2 floor under DR-0012.
Authority rollover, restore/reset and beyond-horizon joins must preserve the
actual epoch floor before that lane can authorize retirement; absence of the
join is unavailable, not a permission to initialize an empty floor.

## Retirement boundary

The client retirement semantics remain solely
[TRANSPORT-NEUTRAL-MESSAGING section8.4](../../architecture/TRANSPORT-NEUTRAL-MESSAGING.md#84-owned-attempt-settlement-renewal-and-retirement).
Epoch continuity is necessary but not a complete retirement capability: the
future closed producer/consumer still needs independently current signed
policy, exact native protected floor/read-back and dependency closure. Known
grant scopes use the actual protected grant's epoch. An unresolved acquisition
uses its original protected PMT2 epoch, not an invented grant serial/generation
or a new route's epoch. No assertion of non-issuance or non-delivery follows.

No cleanup, holder deletion, floor removal, renewal scheduler, deployment,
device reset or release activation is authorized by this decision. S01 remains
open until the complete bounded contract/API and crash fixtures are qualified.

## Required checks

Signed positive unchanged/advanced epochs and negatives at the first and last
successor, each in process-local and cold protected-history paths; rejection
without changing the original protected tip; complete Protocol gate and strict
registry/API/package checks. Existing unrelated shipping failures remain
reported, not waived. Consumer repin and native host/client acceptance remain
separate from source fixture results.
