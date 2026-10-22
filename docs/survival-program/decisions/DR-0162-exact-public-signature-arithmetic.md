# DR-0162 — exact public Ed25519 arithmetic reuse

Date: 2026-10-21; eviction correction2026-10-23. Owner: Mr. X. Status: accepted bounded implementation;
connected latency and full release qualification remain separate.

Repeated XNA1/DTS1/network/ONION/PMA2 verification may reuse only the mathematical
Ed25519 validity of the identical public key, message and signature. All three
inputs are copied before lookup/native verification. A SHA-256 index is not a
positive decision: hits compare every exact byte. Only native-verified positives
enter the memo, bounded to4096 entries and8MiB of public payload; input above64KiB
uses uncached native verification. Negative and malformed signatures never enter.
Concurrent misses may repeat native work, not grant speculative success.

Eviction uses uniform random replacement with O(1) swap removal, not sequential
FIFO. A repeated complete signed-history scan larger than the memo makes FIFO
evict every upcoming tuple and miss on every pass. Replacement changes only
which public arithmetic tuple is retained; it is NOT a cryptographic random
choice, trust source or permission. Entry/byte/64KiB bounds do not increase.
Fixed-seed source tests reproduce oversized sequential scans deterministically
and require fewer native verifications while retaining every exact-byte,
negative, mutation, concurrency and capacity assertion. Connected improvement
must still be measured independently; synthetic hit counts are not latency.

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

The internal container change renumbers metadata TypeRef/signature-blob indices.
The raw production snapshot remains12989 rows. A read-only semantic comparison
against the previously accepted production assembly requires15093 identical
decoded API/resource/reference rows (no public API or resource change). After
that review the exact Debug/Release metadata hashes are rebound; predecessor
hashes are removed, not added as compatibility allowances. The implementation-
bound executable manifest is regenerated with the same case/mapping inputs;
strict graph and manifest integrity must pass again. This is not executable-case
discovery, canonical full source or package/release qualification.
