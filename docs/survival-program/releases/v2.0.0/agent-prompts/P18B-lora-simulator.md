# P18B — LoRa loss/airtime simulator

## Role/repository

Work only in the governance-approved simulator repository. Consume pinned P18A vectors.

## Objective

Measure feasibility under loss, reorder, duplication, collision/duty-cycle and jamming assumptions before hardware integration.

## In scope

- deterministic seeded channel model;
- fragment loss/reorder/duplicate/collision tests;
- airtime/duty-cycle/energy calculator by region profile input;
- queue/TTL/hop behavior and bounded storage;
- machine-readable feasibility report and hardware acceptance budget.

## Out of scope

Regulatory approval, radio transmission, MAUI, rewards and optimistic range claims.

## Acceptance

Reproducible scenario matrix identifies a pass/no-go envelope for short text; unsafe region/power configuration cannot be marked supported; output pins P18A hash.

