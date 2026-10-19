# DR-0150 — Conservative DTT1 transport-time envelope

Status: accepted verification correction; connected/full/release gates separate
Date: 2026-10-19
Decision owner: Mr. X (delegated architecture authority)

DTT1 signs a nonce-bound observation, not the receiver's response-receipt time.
The issuer can perform durable/PQ work after sampling, and transport takes time.
Mapping the signed interval to receipt without accounting for that delay creates
a falsely narrow upper bound. Independent clients/nodes with different RTTs can
then reject valid carriage as future-issued. More importantly, latency can hide
signed DTT expiry. A real signed-proof RED test reproduces both defects.

Keep the exact signed observation interval `[O-U, O+U]` (saturating lower), the
existing same-boot ordered monotonic samples `S <= R <= C`, and the unchanged
`R-S <= 30` nonce deadline. At current sample C, map it conservatively to:

```text
lower = saturatingSubtract(O, U) + (C - R)
upper = O + U + (C - S)
```

Arithmetic overflow and an upper beyond signed DTT expiry reject. The entire
resulting interval must still satisfy the actual ADH/XNV/PMT/PMA/grant/device
windows. A wider uncertainty envelope makes expiry admission more conservative;
it does not extend an authority window, backdate a request, alter signed source
uncertainty or use OS time. Issuance epoch/policy checks still apply to the exact
signed observation, before receiver transport mapping. Protected interval merges
retain their existing intersection/rollback rules; this allocates no upper reset.
This corrects intake at sample C, not the established anchor's existing
monotonic advancement or the independent revocation-freshness/head deadlines.
Matched client/node runtime qualification is required; mixed old/new clock
implementations are not accepted release evidence.

No wire bytes, domains, suites, schema/journal generations or new providers.
All existing original requests and deadlines remain immutable. Old unqualified
expired GSR writes stay preserved, not reminted or relabelled recovered. Current
proof objects are reacquired normally after process restart; no serialized proof
becomes current merely because this verifier changed.
