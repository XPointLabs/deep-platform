# DNP1-SPEC-crypto — recovery and hybrid-PQ specification

Status: **active design draft after DNP1-INV machine-gate GO; production
activation remains blocked**

## Objective

Freeze an independently reviewable DeepRecoveryV1 and hybrid post-quantum
messaging profile before implementation.

## Recovery scope

- 256-bit OS-CSPRNG entropy;
- 24-word English BIP-39 encoding/checksum/NFKD validation;
- explicit DeepRecoveryV1 label and no wallet-interoperability claim;
- versioned domain-separated KDF tree for account, device, agreement and
  recovery authorization;
- optional passphrase and SLIP-39 policy only after recovery UX/threat review;
- deterministic cross-platform vectors and malformed/mix/reuse negatives;
- secure display, clipboard, screenshot, logging, crash-dump and backup policy.

## Hybrid-PQ scope

- exact transcript for X25519 + candidate ML-KEM parameter set;
- both-required no-downgrade KDF and algorithm identifiers;
- asynchronous prekeys, one-time/last-resort lifecycle and replay handling;
- PQ secret reinjection in an accepted ratchet construction;
- long-lived authentication strategy, including ML-DSA size and lifecycle
  assessment;
- multi-device, group, attachment and backup interaction;
- mobile, server, Nearby and LoRa size/CPU/memory/battery budgets;
- maintained provider/library, self-test, errata and supply-chain policy.

## Out of scope

- inventing a PQ primitive;
- production activation;
- replacing all symmetric cryptography;
- classical-only fallback;
- claiming quantum-safe authentication from PQXDH alone;
- deriving every role directly from one mnemonic seed.

## Acceptance

- canonical byte-level spec and domains;
- reference and negative vectors from at least two independent implementations
  or providers where practicable;
- formal threat analysis for passive and active quantum adversaries;
- destructive recovery, device revoke and rollback tests;
- measured wire/resource impact by transport;
- focused independent crypto/privacy verdict P0=0/P1=0.

## Canonical draft artifacts

- byte-level design draft:
  [`../specs/DEEP-CRYPTO-V1-DRAFT.md`](../specs/DEEP-CRYPTO-V1-DRAFT.md);
- suite/domain/size registry:
  [`../specs/deep-crypto-v1.registry.json`](../specs/deep-crypto-v1.registry.json).

The draft is implementation input, not production authority. Provider
selection, vectors, cross-platform measurements and independent review remain
open gates.
