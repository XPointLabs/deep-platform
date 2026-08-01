# P17 — Rewards V3 shadow calculator

## Role

Work only in `C:\Work\DeepSession\XPointLabs\xpoint-staking-backend`. Do not edit or deploy contracts.

## Objective

Build deterministic, replay-safe shadow accounting for service evidence without changing current production payouts.

## In scope

- versioned evidence schema for minimum SLO, core participation, audited storage band, custody plus restore/read success and capped diversity;
- pure epoch calculator and Merkle output with deterministic rounding;
- explicit exclusion of messages/users/bytes attributed to users/P2P activity;
- minimum three administratively independent probe operators (not merely DNS domains) in the threshold fixture/model;
- operator/effective-stake/provider caps and 50/80% XPNT-price scenario report;
- shadow API/stats clearly marked non-authoritative;
- replay/idempotency and adversarial Sybil/self-traffic tests.

## Out of scope

Changing `RewardRatePool`, production distribution, slashing, ingress consensus reward, invoices as consensus proof and claims of trustless storage proof.

## Acceptance

Same canonical evidence yields same root; ordering/duplicate replay changes nothing; self-traffic produces exactly zero reward delta; total never exceeds shadow accrual; current production projection remains unchanged; observation plan lasts 8–12 weeks before any contract proposal.

## Verification

Run `dotnet test XPoint.Staking.Backend.slnx`, recovery/replay tests and relevant DevOps projection gates. Report exact feature flag and removal path.
