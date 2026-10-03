# DR-0085 — descriptor-bound current mailbox peer transport

Status: accepted narrow S02/S03 API increment; activation remains gated
Date: 2026-10-03
Decision owner: Mr. X (delegated architecture authority)

The current host returns selected node IDs and receipt keys, but the existing
peer HTTP client obtains endpoint authority by decoding retired P04/RIP1.
DR-0081 proofs deliberately contain no endpoint. Neither an unsigned configured
origin nor parsing a candidate descriptor may replace this missing consumer input.

Freeze the getter `VerifiedMailboxReplicaV2.Transport`, returning the existing
closed `VerifiedOnionNextHopTransport`. Mint it from the exact same admitted
NETCODEC node when the host returns replica facts; recheck the complete protected
interval before releasing them. It binds canonical node/network/origin, TLS
transport, address family, exact address/port and current SPKI. No public
constructor, raw topology, trust boolean, wire, domain or crypto suite is added.

Facts do not grant dispatch permission. Current node operations must independently
verify the exact grant/selector/role/body/source, both native revocation floors
and replay, and keep their bounded protected owner alive before/after HTTP and
persistence callbacks. The current peer client uses the exact admitted address
and pin, with no redirects, alternate DNS/configuration endpoint or legacy proof.
Missing or unsupported transport is unavailable, never a fallback.

The normative requirement owner is XPOINT-NETWORK-V1 §9. Consumer rebuild/repin,
actual TLS/HTTP/quorum, hostile pin/endpoint, callback expiry/source change,
partial commit/restart and physical device evidence remain required. This API
increment does not activate production or authorize any state reset.
