# P04 — Membership, bridge and key-hierarchy contracts

## Role

You own protocol contracts in `C:\Work\DeepSession\XPointLabs\deep-protocol`. Do not implement registry or client state.

## Objective

Define separate signed contracts for public bridge discovery and node-only membership, with an offline-root/online-signer hierarchy and self-hosted genesis.

## Inputs

Read `AGENTS.md`, P02 update-key ADR, current XNode bootstrap/registry DTOs and the revised program. `CONTRACT_VERSION_OR_SHA` must identify any common signing/canonicalization dependency.

## In scope

- canonical `NetworkGenesis`, signer delegation/revocation, `BridgeSnapshot`, `NodeMembershipCommitment` and optional inclusion proof;
- `networkId`, monotonic sequence, previous hash, issued/valid bounds, min/max protocol and policy version;
- approved Beta policy: 3-of-5 offline roots delegate a time-bounded 2-of-3 online signer set; every snapshot requires 2 online signatures plus a fork-witness record; thresholds remain versioned policy data, never hardcoded private keys;
- domain separation between update, membership, bridge, reward and billing signatures;
- fork/equivocation witness record and last-known-good rules;
- independent genesis/import for self-hosted networks;
- golden vectors, malformed/cross-domain signature tests and clock-skew fixtures.

## Out of scope

Endpoint crawling resistance, live key ceremony, registry persistence, client UI, core endpoint publication and production keys.

## Acceptance

One online signer cannot authorize a snapshot under the approved 2-of-3 policy; a bridge key cannot sign membership; rollback/fork/expired delegation are detectable; clients need not receive full core/storage topology; canonical bytes have cross-platform vectors.

## Verification

Run all protocol verification from `AGENTS.md`; hand off package/version/hash and consumer fixtures to P06/P07.
