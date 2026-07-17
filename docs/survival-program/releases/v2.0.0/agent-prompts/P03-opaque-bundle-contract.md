# P03 — Opaque bundle and metadata contract

## Role

You are the protocol/crypto contract owner. Work only in `C:\Work\DeepSession\XPointLabs\deep-protocol`.

## Objective

Specify and implement the smallest versioned opaque bundle contract that can carry current Session-compatible payloads while enabling future sender-sealed headers, mailbox capabilities and transport-local correlation. Do not replace verified Session semantics by invention.

## Required inputs

- `AGENTS.md`, `docs/SESSION_PORTING.md`, protocol surface/compatibility/unsupported docs;
- P01 observer matrix and red-test requirements;
- pinned `BASE_SHA` and approved protocol ADR;
- exact consumer packaging decision from P00.

## Contract requirements

- canonical version/length encoding and strict maximums;
- encrypted header/payload boundary; no payer/plan/raw Session ID in outer contract;
- transport-local attempt ID distinct from end-to-end dedup ID;
- expiry bucket, padding class, replay material and unknown-version behavior;
- feature negotiation, minimum/maximum version and downgrade rules;
- legacy DPE1 may be wrapped only as an explicitly documented compatibility payload;
- deposit/retrieve capability types are opaque bytes, not recipient master secrets;
- parser is cancellation-independent, allocation-bounded and rejects malformed lengths.

## Sequence

1. Add golden vectors, malformed-input and fuzz/differential fixtures.
2. Add models/codecs behind an explicit Deep-extension namespace.
3. Export/publish the agreed package/artifact and version metadata.
4. Update compatibility and unsupported docs.

## Out of scope

Ratchet/MLS implementation, client routing, storage, billing, BLE and claims of forward secrecy.

## Acceptance and verification

Run restore/build/test commands from `AGENTS.md`, including coverage and focused fuzz/differential tests. An old reader fails safely; a new reader can carry legacy payload without changing legacy bytes; unknown critical features fail closed. Handoff includes package/version/hash and exact P11 consumer API.

