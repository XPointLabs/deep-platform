# DR-0111 — bounded public Braid recovery control

Status: **accepted codec target; authenticated state/transport activation gated**
Date: 2026-10-11
Decision owner: **Mr. X** (delegated architecture authority)

## Why the existing envelope cannot recover saturation

S04's actual native boundary refuses a33rd stale-PQ DPE2 without mutation. After
an unanswered sender's32 headers the peer's Ct1 reply does not complete Braid:
the sender must still transmit EK+Ct1Ack, then receive Ct2. Repeated old-epoch
replies cannot supply that missing sender flight. The independently qualified
boundary and cadence cases live in Protocol's `s04-pq-boundary-20261011` receipts;
cadence66/16 is not already-exhausted recovery.

The source of this dependency is the pinned eleven-state/thirteen-edge
`ManagedMlKemBraidStateMachine`, not Docker or a faulty native binary. Signal's
[ML-KEM Braid specification](https://signal.org/docs/specifications/mlkembraid/)
separates public exchange messages from its shared-secret output;
[Triple Ratchet §8.8–8.9](https://signal.org/docs/specifications/doubleratchet/)
also distinguishes SCKA progress from application message delivery. These sources
do not authorize treating Ct1 as a completed fresh key.

## Selected target, not an application bypass

Use a separate, bounded, session-authenticated channel for **public Braid bytes
only**, retaining the same approved incremental ML-KEM implementation. `DBR2`
is not DMC2, DPE2, an application message, receipt, contact acceptance or a
classical-only encryption fallback. It carries no plaintext, application key,
shared KEM output, EC/PQ message key, private vector or provider serialization.

The normal32-PQ fence and all original ciphertext/request/replay state remain
unchanged. Recovery never changes a data counter, resets a session or increases
the normal data bound. Only actual authenticated completion of the existing
Braid exchange may install a new SPQR link. The following data send/receive
must still pass the normal fresh-key proof and consumed-key fence.

Two distinct control sends per device/Braid epoch suffice for the identity
encoder: Header then EK+Ct1Ack on one side, Ct1 then Ct2 on the other. A lost
response retries the same durably committed frame/operation/counter; it never
samples new entropy or spends another slot. No payload fragmentation, standalone
EK/Ack, `None`, speculative next epoch, user-data API or extra control journal.

## Separately frozen codec authorization

The new allocation is justified by the demonstrated liveness gap. The exact
public framing, parser-only API and structural vectors are authorized before
source implementation by this decision and
[`braid-recovery-v2.registry.json`](../releases/v3.0.0/specs/braid-recovery-v2.registry.json).
They do not modify DPE2/DTR2 bytes or public ratchet APIs. One fixed4112-byte
canonical TLV frame uses the existing version1/suite0x0201 framing. Its public
Braid payload, zero padding and authentication projection are specified only
in that machine owner, not duplicated here. A parsed `UnverifiedDbr2Record`
is explicitly not authority; no MAC verifier, raw-key author or send/ACK API
is granted by the codec.

## Authentication/state requirements still to freeze and implement

Account-root ML-DSA signing is **not** assumed available during steady-state:
the current independent device owner retains Ed25519/X25519 secrets, not an
online permanent-root signing capability. Recovery must not require recovery
phrase storage, reintroduce root secrets, or use Ed25519 alone as PQ authority.

The selected authentication direction is a purpose-separated symmetric control
key derived from each actual verified SPQR root, retained with its bounded native
link, not an application message key. It must evolve with genuine KEM output,
bind network/session/direction/operation/epoch/control counter and the entire
canonical public frame, and authenticate before committed Braid mutation. Ct2
uses the original control epoch's retained authenticator even though its producer
already installed the next link. Its native BraidHdr/Ct2 checks remain mandatory.
Exact KDF/secret layout and internal component producer/consumer are separately
frozen by [DR-0112](DR-0112-owned-braid-control-component.md). Durable ownership/
recovery and transport closure remain gated; this paragraph is not a raw-key
capability or a license to infer their missing contracts.

Before activation, complete the same existing native custody/SQL floor and
owned send/receive machinery: monotonic bounded control slots, exact unknown
retry, all commit/cold handovers, replay/conflict rejection, current peer/device
scope, transport retention and authenticated control-before-ACK. Controls must
not materialize message history or satisfy application receipts. No extra
journal, signing authority, key export, unbounded worker or limit increase.

Acceptance requires actual32-outstanding saturation (including both peers
exhausted and lost prior headers), authenticated four-flight recovery, unchanged
original pending ciphertext/counters, subsequent genuine data-key epoch advance,
replay/forgery/reflection/changed-scope negatives, cold/crash/token handovers,
exact public API/package/frozen gates, Shared/Node transport and device E2E.
Until then DBR2 is `FROZEN_TARGET_NOT_ACTIVE`; existing runtime continues to
reject unsupported control input and must not ACK it as an application message.
