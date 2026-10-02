# DR-0032 — DID2 mailbox selected-entry composition

Status: accepted composition contract; route/grant and shipping activation gated
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Extend the actual DID2 account-owned network source to the identity-neutral
ONION Store/Retrieve/Acknowledge operations. Each route preparation obtains an
independent nonce-bound DID2 directory proof, verifies the complete signed
network history against protected custody, commits/read-checks its floor, and
rechecks freshness. A placement commitment is a bounded retrieval input, never
directory identity, a synthetic account or grant authority. No DID1 proof,
Session-derived holder, raw current-context injection or network fallback is added.

Internal composition requires the exact source's account-owned guards and
entropy custody. Mailbox requests require an explicit scoped credential route;
reject unscoped calls before network/entropy activity. Bind canonical MAU2's
operation, epoch, mailbox, placement, membership and grant expiry to that route
before requesting current network authority. The existing adapter remains
responsible for grant/holder authentication and durable receipt handling.

Select an exact-three-hop path to the requested credential replica, then derive
the TLS entry through DR-0009's closed Protocol factory from that same path.
Never use a fixed ingress URL or direct mailbox/Registry endpoint. Authenticate
the per-attempt onion reply and require the expected canonical mailbox response.
Unknown outcomes are not ACK or delivery; there is no automatic alternate
dispatch. A secondary replica is not an independent/disjoint fallback claim.

This changes Shared internal composition only, not protocol bytes, suites,
domains, public Protocol APIs or account schema. MAU2/MCP2/MCG2 remain the one
identity-neutral mailbox wire. Current DID2 XRR1 route publication/verification,
protected reachability-scoped holders and XMG1/XMC1 acquisition remain required
before shipping activation. This increment grants no contact acceptance,
semantic ACK, attachment/group capability or physical E2E claim.
