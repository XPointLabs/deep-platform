# DR-0163 — historical Store issuer facts after operational succession

Date: 2026-10-21. Owner: Mr. X. Status: accepted bounded correction;
matching source/connected/release qualification remain separate.

An existing completed native Store must be authenticated against its original
root-authorized issuer, not the current issuer after key rotation. A bounded
owned ordered PMA chain may accompany the current terminal policy. Each exact
entry independently verifies against its actual XNA1 ancestor; adjacent entries
must have exact generation/predecessor links. The terminal still passes the
ordinary current authority/time verification and exact current PMT binding.
Missing history is not reconstructed, and terminal-only inputs cannot invent
older issuer facts. The existing current-policy-only factory remains useful for
operations that do not have historical facts, not as a permissive fallback.

Historical Deposit facts additionally require exact current protected retained
PMT history naming that PMA, the matching ancestor and epoch, signed original
grant, original role/lifecycle/generation/lifetime bounds and current host/time
before and after. Settlement still verifies both selected nodes' exact signed
durable receipts and original PRQ2. Permanent expiry still requires actual
current LOWER time beyond the original authenticated expiry. Metadata-only PSR1
repair still joins actual private completed Store/replay/blob and independent
floors; it never gains an expired effect or quorum authority.

No historical policy authorizes a fresh Store/ACK/grant: those paths keep the
current issuer, minimum generation, revocation, holder, replay and durable-state
checks. Public raw history is not a cache of authority. This changes no wire,
signature domain, suite, persisted journal or identity; consumers rebuild the
added closed verifier APIs. No reset/repin or legacy migration is introduced.
