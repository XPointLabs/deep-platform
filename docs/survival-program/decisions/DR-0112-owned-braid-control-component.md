# DR-0112 — owned native Braid control candidate

Status: **accepted internal native-component target; durable/transport activation gated**
Date: 2026-10-11
Decision owner: **Mr. X** (delegated architecture authority)

## Authorization and boundary

This separately freezes DR-0111's missing control KDF and bounded private native
state in [the machine owner](../releases/v3.0.0/specs/braid-recovery-v2.native.registry.json),
before their implementation. It does not change the public DBR2 grammar, normal
DPE2/DTR2, root signing authority, message-key derivation or the data32 fence.

Only the existing internal managed Triple-Ratchet owner may prepare controls
from its verified current state and binding. It derives purpose-separated
control authentication from each actual SPQR root at link creation. An arbitrary
public root/key, caller Boolean, parsed frame or new device/root signature is not
authority. No key or provider-state export is added to the public API.

The candidate is cloned and wipeable. Authenticating/advancing it is **not**
committing it: neither a candidate nor its unverified public record grants
dispatch, transport ACK, message history, AppAck or a durable receipt. The owned
SQL/floor transaction and transport composition remain an explicit subsequent
closure; production DBR2 activation remains false.

## Native transition

Fixed slots correspond to progress flights, not retry counts. Re-authoring an
occupied local slot rejects before committed mutation; the durable owner must
retry its original saved frame. A received exact frame replays without generation,
entropy, keys or counters advancing. A changed frame in an occupied slot or an
operation reused in another retained slot rejects. Authentication and current
session/network/device direction checks precede Braid mutation. Existing Header
and Ct2 Braid authenticators remain mandatory; full Ct1/EK is authenticated by
the purpose-separated outer control MAC before native processing.

Normal data may have already carried Header or Ct1. Their repeated control
flight must match the existing exact public Braid material; it cannot replace it.
First controls in an incompatible Braid state reject rather than being silently
ACKed. In particular a first stale control is not an exact committed replay.
The original link's control authenticator survives genuine next-link installation
so Ct2 can be sent and verified while its producer has already advanced its root.
Only the existing two retained links may carry control custody.

A control successor preserves every outer EC/PQ data frontier, evidence chain,
skipped key and messages-since-PQ counter. It advances only the storage generation
and native control/Braid state. Genuine Braid output installs the normal next
SPQR link. Only a subsequent ordinary data step with that link's fresh-key proof
resets the corresponding data freshness counter; no control resets it itself.

The two-link bound does not authorize retiring a link still named by either
current data frontier. A fresh output that would do so rejects as a transition,
before link KDF/replacement; its cloned candidate never commits. For an ordinary
receive carrying a Braid completion, derive the message and old skipped data
keys and advance the receive frontier from the preceding installed links before
installing that output. A still-pinned send frontier continues to reject. This
ordering preserves the existing key derivation, wire bytes and two-link bound;
it does not settle unknown control operations or authorize their retirement.

## Clean break and acceptance

Private managed-component TRC1 generation2 is required. No generation1 reader,
migration or dual writer is added. This is an internal secret layout sealed inside
the existing TRS1 owner, not another journal or network record. Current source
consumer tests must repin the changed private offsets; public TRS1 is unchanged.
Do not reset/deploy clients or approve public graph snapshots from this decision.

Required native evidence: real both-sided32 saturation (including lost prior
headers), authenticated complete public exchange and subsequent bidirectional
fresh-data resumption with preserved old pending ciphertext; cold encode/decode
between every candidate; forged/reflected/changed-scope/replayed/conflicting or
incompatible controls rejected without committed mutation; fixed slots and actual
native Header/Ct2 validation. Synthetic KDF vectors are independent algorithm
witnesses only, not native recovery evidence. Whole-S04 acceptance still includes
durable SQL/floor crash/cancel/unknown settlement, consumer/API/package gates,
Shared/Node transport and physical E2E.
