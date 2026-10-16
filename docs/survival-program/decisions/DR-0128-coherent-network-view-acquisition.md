# DR-0128 — coherent network view acquisition

Status: accepted source/API allocation; implementation and physical qualification remain
Date: 2026-10-16
Decision owner: Mr. X (delegated architecture authority)

The physical diagnostic reaches the existing `dtt-binding-invalid` guard. Its
specific failed field is not established. A separate signed source regression
reproduces a legitimate operational successor published after a closure response
is captured but before the independent nonce-bound DTT proof is issued. The
client must not accept the mismatched pair or treat it as a verified fork.

The sole acquisition-policy owner is [XPOINT-NETWORK](../../architecture/XPOINT-NETWORK-V1.md).
Freeze the additive Protocol observation API:

```csharp
bool OnionNetworkContextVerifier.ProofNamesStrictlyNewerView(
    VerifiedXPointNetworkAuthority authority,
    VerifiedDeepIdV2DirectoryFreshness proof,
    ReadOnlyMemory<byte> exactTerminalXnv1);
```

The result is an acquisition hint, never a current network, trusted time,
placement, fork/noncommit conclusion or permission to mutate. Parse the view
with the existing bounded canonical codec. True requires exact network/current
authority/witness-policy agreement, canonical exact DTT binding, allowed witness
uncertainty and authenticated DTT threshold, a strictly greater DTT view
generation and a different view core hash. It does not authenticate the entire
candidate closure or renew the proof. Malformed records still reject. Equal or
lower generation, equal hash, foreign scope or other inconsistent binding never
qualifies for this hint. No caller clock, callback or override flag is accepted.

After the ordinary complete verifier rejects `dtt-binding-invalid`, the owned
client may use this exact observation to reacquire public closure and independent
own proof once, under the same operation gate and original cancellation/deadline.
It rechecks the actual old proof's freshness before reacquisition. It must fully
verify the new pair and retain all original protected-history/CAS, currentness,
mailbox, floor and response-release checks. No command or original intent is
reissued by this read-only acquisition. A repeated mismatch fails normally.
No blanket retry of signature, authority, equal-generation hash, fork, expiry,
rollback or malformed-input failures is authorized.

This allocates one read-only source method, not wire bytes, suite/domain, error
code, mutable state, journal generation, compatibility path or reset. Existing
Protocol failure codes and frozen vectors keep their meaning. Rebuild the client
against the matching Protocol helper; old clients continue to fail closed.
No server wire cutover, registered-node-key change or production activation is
authorized or required by this observation API alone.

Qualification requires the original signed race failure, successful successor
acquisition with a single extra closure/proof read and one actual floor advance,
bounded repeated-mismatch refusal without a floor change, malformed/foreign/
same-generation/signature/expiry/cancellation negatives, source/API graph gates
and retained physical retest. A source reproduction does not prove that every
physical DTT refusal has that cause or satisfy release acceptance.
