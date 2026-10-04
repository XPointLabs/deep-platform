# DR-0083 — current mailbox grant revocation and protected floor

Status: accepted narrow S01 contract; producer/consumer implementation and activation gated
Date: 2026-10-03
Amended: 2026-10-04 — explicit late first enrollment; no wire change
Decision owner: Mr. X (delegated architecture authority)

## Necessity and scope

DR-0081 requires revocation before replay reservation and after callbacks.
Current PMA2's minimum grant generation and role-key replacement can fence a
whole issuer generation, but cannot express an individually revoked MCG3 serial.
XNV1 revokes nodes, not identity-neutral grants. DRS1 cannot be sent to mailbox
nodes without crossing the account/device privacy boundary. The retired PMR1
uses the removed authority/floor contract; neither an adapter nor an empty
revocation callback closes this gap.

Allocate one narrow public signed record, **MGR1**, under the existing PMA2
Deposit/Retrieve issuer keys. No new cryptographic primitive, signer role,
account identifier, client grant/presentation version or node admission journal
is introduced. Exact MCG3/MCP3/MAU3/XMC2, PMA2/PMT2/PMS2 and eight-chain NCP2
remain unchanged. This record is node-control input, not a client entitlement.
The existing bounded node-control distributor transports exact signed bytes;
its URL/TLS, configuration and HTTP success cannot authorize a snapshot.

The exact record owner is CONTACT-RESOLVER-V1 §3.8; its machine companion is
`mailbox-grant-revocation-v1.registry.json`. These allocations are
bound to closed registry/vector schemas and independent signed golden bytes;
the primary Protocol registry binds all four input hashes and resolves MGR1's
exact inactive contract, without changing imported approved DNP1 blobs.
They remain
FROZEN_TARGET_NOT_ACTIVE. Every current mailbox node needs both role snapshots;
missing, expired, foreign, malformed or unavailable protected floor means
unready, never an empty set. A correctly signed empty snapshot is meaningful,
but is not inferred from absence or a parse failure.

## Floor and transition contract

Floor scope is `(network, exact PMA2 CoreRef, role, PMA2 role issuer key)`.
The host retains the exact accepted signed MGR1, its generation/core hash and
protection outside replaceable service volumes, under its existing protected
state owner. It restores that floor before refresh or admission. Candidate bytes
never manufacture the prior floor. Losing protection or an existing floor is a
recovery condition, not automatic genesis or account/node-key reset.

| Transition | Input and check | Durable effect / retry / failure |
| --- | --- | --- |
| Explicit first enrollment | Genuinely new host scope, fresh canonical issuer-signed snapshot at any generation >=1; current complete host authority/time | Reserve capacity, atomically install and read back exact snapshot as the immutable initial protected floor before use. No auto-enrollment when a previously installed floor is missing. |
| Exact replay | Same generation and exact core; signature and full current snapshot interval verify | Preserve floor, reverify read-back/currentness. Expiry never becomes replay authority. |
| Successor | Exactly prior generation+1, exact prior core, nondecreasing issuance time and cumulative serial superset | Atomically install/read back successor; no admission from a merely verified candidate. Interrupted replacement reconciles exact old/new state; unknown writes remain unready. |
| Stale/gap/fork | Lower generation, missing intermediate, same generation/different signed core, wrong predecessor or removed serial | No floor advance or mutation. Authenticated equivocation/removal latches scope; an unsigned hostile input cannot create a fork latch. Missing history needs bounded verified catch-up, not a floor reset. |
| Expired prior floor | Protected prior may be expired but its exact scope/signature still verifies; candidate must be fresh | Allows proper successor planning only. Expired predecessor never supplies admission or negative revocation authority. |
| Capacity | At most 4,096 distinct serials, no pruning within one PMA2 scope | Backpressure; no truncation/eviction. Operator may fence the whole scope with a properly signed PMA2/PMT2 successor. Existing operation outcomes and custody are retained. |
| PMA2 rollover | Verified network/root lineage accepts new PMA2 and matching PMT2 | A genuinely new scope requires explicit first enrollment under this table. Old floors remain for recovery; old grants do not gain new membership, lifetime or serial. |

The cumulative serial set is retained for the complete PMA2 scope, not only
while one particular MGR1 freshness interval lasts. Same-serial reissuance
within the scope is forbidden. A fresh snapshot covers no more than 300 seconds
and remains wholly inside PMA2's interval. Full protected lower/upper time,
not host UTC or response server time, controls acceptance. Renewal increments
generation even when the set is unchanged; it does not re-sign changed bytes
at the same generation. Missing a newer snapshot is bounded uncertainty until
the observed snapshot's signed expiry, not instant global revocation.

The issuer chain is shared by nodes, not recreated when each host joins. Its
generation 1 expires within five minutes; requiring that generation for every
new host would prevent later enrollment or encourage signed forks. Explicit
first enrollment therefore pins a fresh issuer-authenticated snapshot without
requiring the expired global genesis. Its canonical predecessor remains ZERO32
iff generation 1; later generations retain their nonzero predecessor. This is
an initial trust pin only for a genuinely new protected host scope, never a
catch-up shortcut for an existing floor. The host retains those exact initial
bytes independently: restored floors below that initial generation, or changed
bytes at that generation, reject. Every subsequent advance still requires the
exact predecessor, generation+1, nondecreasing issuance and cumulative serials.
No reset, missing-history acceptance, new snapshot lifetime or activation is
authorized by this amendment.

## Closed verification and host integration

Protocol plans initial enrollment/successor from a complete current
`VerifiedMailboxHostAuthorityV2`, exact candidate and, for advance, the exact
restored protected predecessor. The immutable plan has no dispatch authority.
It verifies canonical bounds/scope, actual role signature, full protected time,
generation, predecessor and serial-set retention before any host write.
Issuance cannot predate the signed role key's valid-from time. Grant currentness
is checked on both sides of floor I/O, even when its expiry is earlier than
the snapshot's; current revocation evidence cannot extend a grant lifetime.

Only exact durable read-back plus a scoped protected-floor reader can produce
the closed revocation capability. The reader returns the actual current core
hash, not a trust boolean. Its scope must be bound to the protected store; a
candidate cache or unsigned default cannot implement it. Capability use checks
that hash again and rechecks complete host/snapshot time after the callback.
If a newer floor is installed, the old capability is stale even before expiry.
Grant checking additionally revalidates exact MCG3 issuer/network/membership/
epoch/generation/lifecycle and rejects listed serials. This still is not holder,
body, local selected-exit, replay, storage or receipt authority.

S02/S03 must obtain/recheck this capability before replay reservation and after
peer/storage callbacks, before mutation and receipt release. Floor replacement
and these checks use the same scoped concurrency owner; no stale capability
may slip through a concurrently committed successor. Expiry/revocation after
a reservation preserves pending/unknown and original custody; it releases no
receipt and deletes no reservation. A revoked grant cannot authorize a new
mutation or fresh receipt through a cached successful result.

S05 owns actual role-signer authoring, exact cumulative serial ledger, retained
successor distribution, renewal and readiness/backpressure. Revocation's
eventual device/route propagation still follows CONTACT-AND-GROUP-PROTOCOL and
RETENTION-AND-RECOVERY; nodes never receive those identities. This decision does
not create a public JSON revocation endpoint or activate a private control API.

Required tests: both actual role signatures; valid empty and revoked serial;
wrong network/PMA/key/domain; malformed count/order/size; unknown version/suite;
initial enrollment at genesis and a fresh later generation; exact replay;
late enrollment after global genesis expiry; rollback below the initial pin;
stale/gap/fork/deletion; expired predecessor vs expired
candidate; protected-clock rollback/foreign boot/full-interval boundary;
callback crossing expiry or changing floor; cancellation and owned input bytes;
native atomic install/read-back/reopen with missing/corrupt protection;
revocation before reservation and after partial commit on current client/peer
paths. Connected issuer/node/client, operational renewal and physical E2E are
still mandatory. No release/production activation is granted by this freeze.

Grant/send/route retirement, compaction and application receipts remain separate
open S01 contracts; accepting this decision does not close the whole stage.
