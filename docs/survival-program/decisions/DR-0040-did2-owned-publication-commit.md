# DR-0040 — DID2 owned publication commit and exact result custody

Status: accepted clean break; shipping transport and devices remain gates
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Close the owned publication business path after DR38 authorization and DR39
opaque-node consumption. A threshold authorization is not publication. Only
the exact independently verified two-selected-replica XPO commit/replay proof
may be returned as a publication commit, and the account owner must durably
CAS/read back its exact result before releasing it.

Add closed Protocol `VerifiedDeepIdV2PublicationCommit`, constructible only by
`DeepIdV2PublicationCommitVerifier.VerifyCommittedAsync`: inputs are the current
verified DID2 route, owned signed/encrypted contact object, exact publisher-signed
coordination request, exact V2 XPU and bounded XPO, plus cancellation. Reject
before callbacks on hostile sizes/downgrade/framing. Bind every owned request,
object/locator/ciphertext/DCA/XIR/route/body field, publisher signature and witness
threshold to the current independent DID2 identity/network closure. Verify XPO
request hash, committed/exact-replay status, durable outcome, object/generation
and both distinct current NETCODEC-selected Ed25519 node receipts with the
unchanged neutral publish-commit transcript. No caller trust set, signer, clock,
serialized verified capability or old identity adapter.

This is historical durable-commit evidence, not permission to dispatch a stale
XPU. A retained valid signed commit may outlive the short XPA dispatch lifetime;
it cannot renew that authorization or issue mailbox grants/ACK/consent. Current
owned object/route/directory validity and exact current placement are still
required at release. The unsigned XPO server clock is never a time authority.
Network/route lineage renewal is a separate gate, not a static fallback.
Recheck current route/monotonic continuity after verification and expose only
defensive result bytes/hashes and read-only generation, not private keys.

The existing mandatory protected route journal becomes version 4 only with a
twelfth LP32 field for exact XPO (at most 16,384 bytes) and terminal phase 7.
Its header/prefix remain 92/170 bytes; max entry is 431,954 bytes, max intents
128 and aggregate remains the existing 1 MiB secure-store limit. Phases 1..6
reserve complete phase-7 capacity before callbacks; phase 7 accounts for actual
bytes. Revision remains one plus sum of phases. Old versions require explicit
isolated QA reset, never migration or silent recreation; SQL2/application6 and
registered node keys do not change.

Internal account-owned orchestration dispatches the exact already retained
phase-6 XPU through a typed bounded replica transport only after fresh DR38
authorization verification. Capture/verify the bounded response, recheck the
account lease, fresh proof and protected floors, then CAS/read back phase 7.
An interrupted request keeps phase 6 and retries exactly; a reopened phase 7
re-verifies the retained commit and uses no threshold/publication/replica
callback. Changed profile/configuration/body/response and corrupt/missing
custody fail closed. No generic slot or persistence API is public.

No shipping direct public Registry fallback is permitted. Private coordination,
authenticated remote replicas, actual PMA2 membership/grants, contact resolve,
messages/assets/groups and physical Windows/Android E2E remain connected gates.
Package APIs/machine evidence/consumer repins and full gates/commits occur at
the requested whole-business boundary, not on the strength of this local slice.
