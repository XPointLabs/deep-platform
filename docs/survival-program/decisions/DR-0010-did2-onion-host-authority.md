# DR-0010 — DID2-only ONION host authority and signed multi-role receive

Status: **accepted architecture; implementation and live activation pending**
Date: 2026-09-28
Decision owner: **Mr. X** (explicitly delegated architecture authority)

The agent adopts this decision under the owner's delegated clean-break authority.
It is not an external security review or a release sign-off. No Protocol wire,
domain or reviewed public API change is authorized by this decision.

## Verified gap

`PrivacyRoutingProductionRuntime` currently requires a V1 Contact authority
snapshot and fixes one receive position per process. DID2 proof activation
rejects that V1 authority. The three-node network requires different role
permutations to reach both selected replicas; a fixed-role host cannot satisfy
the existing six-permutation requirement in `XPOINT-NETWORK-V1`.

## Decision

1. The receive host uses a separate DID2-only, identity-neutral network authority.
   It must not wrap a V1 snapshot, restore retired directory evidence, or borrow
   a client's nonce/clock/freshness capability.
2. A bounded, operator-configured public DID2 observation credential may supply
   the directory lookup needed for the node's own nonce-bound proof. It is not
   the registered node identity and grants no signing, messaging or publication
   authority. Each node independently obtains and fully verifies its current
   checkpoint with its own monotonic request window. No device/recovery private
   keys are deployed for this observation role; no request header chooses it.
3. Fresh directory proof, independently pinned authority and the complete signed
   network closure mint the receive network context. The node durably advances
   and rechecks an instance/network-bound NETCODEC LKG before releasing it.
   Restart re-verifies the retained signed closure and floor; missing, corrupt,
   stale, forked or rolled-back state fails closed. A repeated null predecessor
   is forbidden after initial verified creation. Directory and network floors
   remain distinct, with their local joint-rollback limitations documented.
4. The exact current signed XND1 role mask supplies the allowed local receive
   positions. Remove the fixed `ReceivePosition` configuration cleanly, including
   installer/topology inputs and obsolete assertions. Do not add an old-field
   reader or translate it into the new policy.
5. Use Protocol local-node-key factories for the signed allowed positions.
   The header selector distinguishes Relay from Exit, not Ingress from Core:
   both relay positions share the same outer header/key. Resolve that ambiguity
   only through the authenticated-position contract in
   [DR-0011](DR-0011-authenticated-relay-position.md). A unique header match is
   not required and must not be invented. Each open still requires its own
   position-bound durable replay lease; only complete validation and replay
   commit release a forward/dispatch capability. The node never selects or
   rewrites the client's route.
6. Preflight and live probes must match installed independent traffic/TLS keys
   to signed descriptors. Preserve registered Ed25519/BLS identities, state
   protection, node data, Reality configuration and certbot. Do not replace them
   with generated test identities or disable authentication to activate a host.

## Required evidence

Real signed DID2/NETCODEC fixture; restart and monotonic floor advancement;
rollback/fork/crash/missing-proof/expired-key negatives; role removal and unknown
frame rejection before side effects; all six three-node permutations; signed
two-replica XIC1 publication over actual TLS; then physical Windows/Android
contact and direct-message E2E, followed by attachments/images/groups.

Mock composition, local sealing, a healthy container or an HTTP staging ACK
does not prove publication, messaging, masked carrier operation or readiness.
Starting topology remains three nodes; six independent nodes are a later
operator expansion, not a workaround for this receive-host defect.
