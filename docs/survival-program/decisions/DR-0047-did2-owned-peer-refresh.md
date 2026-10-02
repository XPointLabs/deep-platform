# DR-0047 — Owned peer bootstrap and independently refreshed endpoints

Status: accepted local composition; live transport/device evidence pending
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

DR27's key-free scope is not a complete peer lookup: account/device/DMD hashes
cannot reconstruct the original DID2 credential. Persist the exact public DID2
from the independently verified current peer binding used by the owned initial
seed. Do not persist a resolver response or a freshness capability as perpetual
authority. This credential carries public keys/commitment, not the private
resolver capability, root keys, DAM key or ratchet state.

At first session registration atomically insert a mandatory immutable protected
peer-bootstrap value beside the catalog CAS and empty floor. Its slot is
`deep.store.v2.messaging.peer.<scopeHashHex>`. Its exact 2120-byte local shape is
version1, reserved-zero3, scopeHash32, SHA256(exact DID2)32, exact DID2 (2052).
The scope binds network/account/database instance and exact original endpoint
heads. Only an owned verified seed authors the value. Restore validates exact
shape, canonical DID2 and both commitments, and requires an exact registered
scope. Missing/foreign/conflicting values reject; an already registered session
never recreates them from a caller or retained expired proof. Explicit account
reset purges the same STORE-V2 namespace. No migration or alternate reader.

Ordinary contact state/accept, text/offer preparation, send/receive and history
entry points no longer accept a caller's retained peer freshness object. The
account-owned source reads the protected credential, obtains current own/NET
authority and independently calls the DID2 directory proof client for that
credential, with a single 30-second acquisition budget and cancellation even
when an adapter ignores it. Verify protected directory/network floors and
current own/peer proofs again before returning the pair. All network acquisition
is outside the account lease; actual operation reopens current owner, session,
retirement and mutable floors and rechecks the pair under its real lease.

The returned proof must bind the exact credential AND original scope endpoint
account/generation/device/DMD. Expired/nonmembership/revoked/forked/changed heads
fail closed before mutation. Refreshing the same current head after TTL is not
endpoint rollover; verified directory/device successors and ratchet rollover
remain separate unfinished lifecycle gates. No cached proof or frozen clock
can stand in for live freshness. Initial import still requires independently
current peer evidence from the authenticated bootstrap; it is not ordinary
session proof refresh.

Acceptance: exact credential survives restart; missing/corrupt/foreign/bootstrap
values reject without repair; owned registration inserts floor and bootstrap
atomically; steady-state callers cannot inject peer authority; a fresh proof for
the same endpoint after TTL works while old/changed/expired evidence rejects.
Structural tests do not establish signatures, live TTL, sockets or device E2E.
