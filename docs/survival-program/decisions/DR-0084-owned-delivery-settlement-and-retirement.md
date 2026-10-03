# DR-0084 — owned delivery settlement and retirement

Status: accepted S01 semantic contract; local format/API and connected gates remain
Date: 2026-10-03
Decision owner: Mr. X (delegated architecture authority)

## Decision and sole owners

Freeze the client state/error/crash obligations in
[TRANSPORT-NEUTRAL-MESSAGING §8.4](../../architecture/TRANSPORT-NEUTRAL-MESSAGING.md#84-owned-attempt-settlement-renewal-and-retirement).
That section is the sole owner of the transition tables. Retention deadlines
remain owned by
[RETENTION-AND-RECOVERY](../../architecture/RETENTION-AND-RECOVERY-V1.md),
and grant/admission bytes remain DR-0081/0083 and CONTACT-RESOLVER-owned.
No new wire, magic, algorithm, crypto suite or compatibility path is allocated.

The logical event, its ratchet-committed ciphertext and one transport attempt
are different custody objects. Closing an expired attempt with an unknown
outcome does not prove non-delivery. Reconciliation precedes a permitted new
attempt, which retains the same authenticated event and already committed
ciphertext, with a distinct attempt identity; it never ratchet-encrypts again.
An operation caller cannot select a replacement grant/route or mint a settlement
marker. Only the account owner under its actual lease performs the transition.

Active grant renewal must not overwrite an older grant referenced by pending
Store/Retrieve/ACK work. Each acquisition has independent exact request/winner
custody. The reachability-direction holder remains independent of device/root
identity. Expired acquisition requests cannot be re-signed or re-windowed and
their expiry does not prove that no grant was issued remotely.

Bounded journals are working sets, not lifetime sequence/replay history. Before
retiring entries, preserve independent protected authored-sequence and
grant/operation counter floors, plus outstanding exact work and the required
terminal evidence. Removing payload is separate from retiring these floors.
Expiry, a successful Store, a capacity limit or a fresh grant by itself cannot
prove that an old replay namespace is permanently inadmissible. Missing or
rolled-back mandatory custody fails closed, without initialization by a reader.

## Lifetime mismatch and affected lane

Source inspection found `MailboxClientLimits.MaximumTtlSeconds = 7 days` and
the owned sender choosing `min(grant expiry, created + maximum TTL)`. This does
not implement the normative mailbox retention policy, and cannot be solved by
lengthening a short-lived authorization grant. Admission/request/retry windows
and accepted-object expiry must be separate. This supersedes only DR-0056's
statement that first Store object expiry is bounded by grant expiry; exact
prepared body/lifetime retry and all current admission checks remain mandatory.

No runtime behavior is changed merely by this decision. Before using a longer
object lifetime, the matching codec, client outbox deadline, node retention,
replay/tombstone retention and retained-route retrieval/ACK must be implemented
and tested together. A current-epoch-only grant or live XRR1 is not permission
to use an expired route or claim historical mailbox availability. If a retained
closure cannot be safely served/migrated under the current contract, that lane
stays unavailable and requires a closed producer/consumer contract; do not
invent an unsigned historical-reader switch.

## Implementation boundary

S01 still requires the complete node/peer admission and application-receipt
contracts and any necessary local format/API freeze. This decision does not
close S01 or authorize skipping to shipping/device qualification. S04 implements
the client transition/compaction batch using the existing account lease,
protected storage, SQLCipher and exact ciphertext paths. A necessary local
generation change rejects prior state; it does not add a migration or another
runtime reader. Package consumers and normative hashes are reviewed/repinned
before activation, with no operator key/genesis/floor reset.

Each transition requires the input, durable effect, retry/expiry/cancel rule and
fault/reopen proof listed by its sole owner. Source tests, generated registry
integrity and this accepted decision are not remote durability, production
activation, physical E2E or release approval.
