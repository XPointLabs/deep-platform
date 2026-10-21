# DR-0164 — received scope scheduling handoff

Date: 2026-10-21. Owner: Mr. X. Status: accepted bounded ACK-path correction;
matching focused/connected/release qualification remain separate.

Ordinary DPE2 receive already resolves the exact owned catalog scope and commits
the actual authenticated native/semantic event. It may return that same key-free
scope as internal scheduling metadata. Mailbox orchestration need not reopen
and decrypt the identical catalog a second time just to identify ACK endpoints.
The persisted-event result is still disposed normally; no key/plaintext/proof,
private database snapshot, verified endpoint or authorization result is retained.

Independent ACK endpoint acquisition still reads the actual current catalog and
peer credential under an account lease, fetches current own/peer authority and
checks time/floors. The ACK owner independently reconstructs every semantic
handoff from actual ratchet/materialized rows and protected page/holder/native
custody BEFORE its signing loan. Missing/changed scope, materialization, private
floor or authority still refuses; the scheduling scope cannot confer consent or
ACK authority. Initial/Braid and ACK currentness boundaries remain unchanged.

Test-only lookup counters require exactly one catalog discovery per ordinary
receive instead of two. Existing lost-ACK, semantic commit faults, cold recovery,
deduplication and empty-mailbox assertions remain. No public API, wire/schema,
persisted journal, identity, private-key lifetime or reset/repin change.
