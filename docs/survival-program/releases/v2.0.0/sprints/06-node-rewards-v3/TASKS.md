# Sprint 06 — verifiable node rewards v3

Duration: 2 weeks. Exit outcome: deterministic shadow epoch roots and a migration-ready reward distribution design.

## RWD-01: versioned role manifest and evidence

Membership roles: core, storage, ingress, cost gateway. Evidence records are signed, time-bounded and privacy-safe:

- core: quorum participation and multi-vantage reachability;
- storage: capacity band and random custody challenge results;
- ingress: regional multi-vantage availability for bonus/ops funding only;
- cost gateway: aggregate capped invoice/proof for operations reimbursement.

No evidence field may contain a user/session identifier, contact, message count or attributed traffic.

## RWD-02: epoch calculator

Implement a pure deterministic calculator matching [the proposed 60/25/10/5 allocation](../../tokenomics-and-node-economics.md). Inputs and output are canonical; output includes policy version, evidence hash and Merkle root of node rewards. Cap storage, operator and provider concentration contributions.

Acceptance: identical inputs produce the same root across process restarts; ordering is irrelevant; total never exceeds epoch accrual; rounding remainder follows a documented deterministic rule.

## RWD-03: storage custody challenges

Challenge random opaque ciphertext chunks after commitment. Use delayed unpredictable challenge selection and bounded proof size. Do not reveal mailbox ownership. Include false-positive/temporary outage handling; missing a few probes reduces bonus, while cryptographic forgery is separately punishable.

Reference: [Proofs of data possession](https://eprint.iacr.org/2007/202). Use a reviewed construction or a deliberately limited custody check with documented security; do not invent claims of trustless proof.

## RWD-04: independent probes and diversity

At least two independently operated probes sign observations. Determine ASN/provider/region from multiple sources and cap bonuses; do not assume different IPs imply different operators. Regional blocking reduces regional availability bonus but does not automatically slash stake.

## RWD-05: shadow and migration path

- run current equal distribution and V3 shadow distribution together for at least four epochs;
- publish aggregate deltas and concentration simulations;
- add a challenge/replay tool and signed policy artifact;
- design contract claim/root changes with upgrade and rollback tests;
- require explicit governance/deployment approval after shadow results.

## Adversarial tests

- one operator launches 100 same-provider nodes;
- nodes generate arbitrary self-traffic;
- probe collusion/minority outage;
- storage reports capacity but fails delayed custody;
- evidence arrives twice/out of order;
- epoch reorg/replay and rounding boundaries.

Self-traffic and P2P activity must produce exactly zero reward change.

