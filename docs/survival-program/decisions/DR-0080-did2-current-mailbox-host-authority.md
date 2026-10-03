# DR-0080 — current DID2 mailbox host authority

Status: accepted API increment; node/client activation remains gated
Date: 2026-10-03
Decision owner: Mr. X (delegated architecture authority)

Freeze `MailboxHostAuthorityV2Verifier.VerifyAsync(network, root, exactPma2,
trustedTime, ct)` returning `VerifiedMailboxHostAuthorityV2`, with no public
constructor. Capture bounded canonical PMA2 before any clock callback. Require
the complete NETCODEC-minted current network, the exact XNA1 references in its
view/head, PMT2's PMA2 core reference, root signatures and the whole nonce-proof
interval projected by the protected monotonic clock. Check again before release.
Reject foreign boot, rollback (including between later calls), expiry, overflow
and cancellation. No raw topology, UTC, issuer keys or trust booleans are inputs.

The result provides copied current network/PMT2 references, the exact PMT2
artifact hash as membership commitment, its selection epoch, and separately
identified canonical node and identity/receipt-key facts. Ranking accepts
only a nonzero 32-byte selection input and reuses the existing PMS2 algorithm;
it is data, not proof that a grant or a route authorizes that selection.
`EnsureGrantCurrentAsync(exactMcg2, ct)` independently verifies active role issuer,
minimum generation, signature, full interval, maximum lifetime, exact membership/
epoch and the network hard expiry. It does not verify a holder presentation,
revocation, reserve replay, persist state, select a local exit or authorize ACK.

In particular, XRA1/PMS2 selection input and XRC1/XRR1 tag10 blinded placement
are independent random values in the current author. MAU2/MCG2's placement
commitment cannot be treated as the missing PMS2 selection input. Do not derive
an alternate replica set from it, expose a deposit capability through an earlier
public selector, or silently reuse PMA1/P04/RIP1. The connected mailbox consumer
must close authenticated selection-to-placement binding before activation; any
additional wire/API contract needs a separately frozen decision and negative
cross-feed coverage. Full peer transport/quorum/durable runtime, issuer rollout,
public API/evidence repins and Windows/Android delivery remain release gates.

This additive API changes no bytes, signing domains or existing protected state.
Consumer rebuild/repin is required; it does not by itself require account reset.
