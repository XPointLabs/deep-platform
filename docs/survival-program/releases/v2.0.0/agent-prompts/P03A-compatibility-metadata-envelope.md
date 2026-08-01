# P03A — Compatibility metadata envelope

## Role/repository

Work only in `deep-protocol` after P03 opaque container vectors and P01 observer requirements are pinned.

## Objective

Design and implement a reviewed outer encryption contract that carries legacy DPE1 bytes without exposing them to managed storage. This task does not claim forward secrecy or replace the legacy inner protocol.

## Required design decisions

- recipient-encrypted header/payload construction using an approved existing crypto adapter/primitive;
- sender authentication data visible only after recipient decryption;
- outer fields limited to version, padding/size class, expiry/replay material and opaque mailbox capability presentation;
- attempt-local hop wrapping so a stable cross-transport ID is not exposed;
- nonce/key separation, malformed-input behavior, maximum sizes and downgrade rules;
- explicit observer/collusion claims and compatibility-mode limitations.

## Sequence

1. Produce ADR and external focused-review packet; no production default before approval.
2. Add golden/negative/fuzz/downgrade vectors.
3. Implement codec behind feature/version negotiation.
4. Pack locally with SHA256 and update unsupported/compatibility docs.

## Out of scope

Double Ratchet/MLS, mailbox lifecycle, client storage, billing and inventing a primitive.

## Acceptance

Managed payload fixtures contain no inner DPE1 sender/recipient bytes; recipient recovers exact legacy bytes; tamper/replay/wrong-recipient/downgrade fail; review has no unresolved Critical/High for closed Beta scope.

## Verification

Run all `deep-protocol/AGENTS.md` restore/build/test/fuzz requirements and standard artifacts.

