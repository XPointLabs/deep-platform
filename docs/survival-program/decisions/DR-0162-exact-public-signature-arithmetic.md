# DR-0162 — exact public Ed25519 arithmetic reuse

Date: 2026-10-21. Owner: Mr. X. Status: accepted bounded implementation;
connected latency and full release qualification remain separate.

Repeated XNA1/DTS1/network/ONION/PMA2 verification may reuse only the mathematical
Ed25519 validity of the identical public key, message and signature. All three
inputs are copied before lookup/native verification. A SHA-256 index is not a
positive decision: hits compare every exact byte. Only native-verified positives
enter the FIFO, bounded to4096 entries and8MiB of public payload; input above64KiB
uses uncached native verification. Negative and malformed signatures never enter.
Concurrent misses may repeat native work, not grant speculative success.

The memo cannot contain a parsed/verified authority, proof, clock reading, root
membership/threshold decision, protected floor or revocation result. Every caller
still parses its actual input and performs its existing currentness, chain,
network, policy, scope, issuer, threshold, replay and durable-custody checks.
Changing any signed byte/key/signature requires new native verification. Native
failure is never inserted; eviction has no security meaning. Public byte copies
contain no private keys or plaintext user messages: this helper is integrated
only at the existing public network/ONION/mailbox-policy signature boundaries.

No wire/domain/suite/public API change, consumer reset or authority repin.
Source-cutover consumers must rebuild the changed Protocol assembly. Tests cover
exact mutable-input ownership, changed key/message/signature, repeated negatives,
malformed lengths, entry/byte eviction, large-input bypass and concurrent hits;
existing hostile authority/currentness suites must still pass.
