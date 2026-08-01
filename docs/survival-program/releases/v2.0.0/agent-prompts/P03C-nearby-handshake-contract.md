# P03C — Nearby rendezvous and authenticated handshake contract

## Role/repository

Work only in `deep-protocol`. This is a design/vector task before P12/P13.

## Objective

Specify privacy-scoped nearby discovery and identity binding without letting Android/iOS agents invent cryptography.

## Required decisions

- Beta mode is contact-scoped discovery by default; open first-contact discovery is separate/deferred unless explicitly approved;
- rotating rendezvous hint derivation/period/overlap and what an unknown scanner learns;
- transcript-bound authenticated key exchange using an approved existing primitive/adapter;
- identity disclosure timing, replay, resumption, clock skew and simultaneous-open behavior;
- hop-local wrapping/dedup relation to opaque bundle;
- foreground/nearby metadata claims; no global anonymity or background SLA.

## Deliverables

ADR, state machine, canonical messages, golden/negative/replay vectors, platform-neutral interface and external focused-review packet.

## Out of scope

BLE advertisements, permissions, Wi-Fi transfer, UI and production code outside protocol. Do not promise forward secrecy unless the approved primitive and review demonstrate it.

## Acceptance

Untrusted scanner cannot recover stable Session ID from advertisements; wrong contact/replay/tamper fail; transcript binds identities and negotiated bundle version; P12/P13 get a pinned package/hash and exact lifecycle API.

