# Retention and Recovery Matrix V1

Status: **normative implementation target for the first public release**

Retention is a privacy/capacity policy, not account expiry. The values below are
the only V1 product defaults/maxima. A transport may advertise a lower bound only
before send; it may not silently shorten an already accepted object's signed expiry.

## 1. Service and protocol retention

| Data class | Default / maximum | After delivery or supersession | Replication / owner | User-visible claim |
|---|---|---|---|---|
| mailbox text/control ciphertext | 30 d / 30 d | delete at signed expiry | PMT2-selected mailbox pair / XNode | offline delivery up to 30 d, not guaranteed after expiry |
| permanent DID1 address | no expiry | never automatically deleted or redirected; current publication may be absent | recovery root + deterministic per-transport resolver slot | same Deep ID after device loss, long offline and transport change |
| unsolicited contact request | 30 d / effective invite expiry | delete after accept/reject + 24 h replay grace | invite-store pair / XNode | pending request may expire |
| encrypted DCR1 publication | current closure <=400 d; one-time <=30 d | predecessor 48 h after successor quorum | invite-store pair / XNode | DID1 remains permanent; current first-contact availability may pause |
| DPK2 claim/replay record | DPK2 expiry, <=30 d | later of expiry or 30 d after claim | pre-key claim pair / XNode | exact retries are safe; consumed pre-key cannot be reused |
| XRR1 deposit reachability | <=24 h | overlap current/next for object horizon | mailbox pair / XNode | internal short-lived route, not Deep ID lifetime |
| XUR1 encrypted update events | 400 d and >=1,024 generations | compact only behind verified checkpoint | contact update pair / XNode | established contacts can refresh after long offline within horizon |
| DMD1/DRS1/device-control history | 400 d and >=1,024 generations | checkpoint + root re-enrollment beyond horizon | directory witnesses/caches | old device can verify 365-day reconnect fixture |
| group proposals/commits/packages | 400 d and >=1,024 commits | retain fork evidence locally indefinitely | member delivery + bounded control store | current membership recoverable; old chat content may be absent |
| attachment ciphertext | 30 d until materialized; 7 d after authenticated materialization | immediate at shorter disappearing expiry | blob replica set / XNode | recipient sees exact expiry before upload |
| avatar/profile blob | current + predecessor 30 d; max 400 d for unchanged current | predecessor deleted after 30 d | blob replica set / XNode | avatar availability is not message history |
| durable sender outbox | until terminal expiry/cancel + 30 d audit tombstone | ciphertext/key deleted at terminal policy | local device only | queued sends survive restart; expired send is explicit |
| semantic dedup tombstone | 45 d | delete after bound | local device; coarse mailbox receipt where needed | duplicate network delivery does not duplicate UI |
| onion/carrier replay ID | traffic-key epoch + 72 h | destroy with retired epoch | relevant XNode/bridge | no exactly-once network claim |
| XNV1/XNH1/PMT2 operational history | 400 d and >=2,048 generations | compact behind root consistency checkpoint | witnesses/caches/clients | 30/180/365-day trust reconnect supported |
| root lineage/transparency checkpoint | indefinite | never silently delete | app + witnesses + local LKG | fresh install and beyond-horizon root validation |
| call signaling/dedup | offer 60 s; call ID tombstone 24 h | delete payload on end + 24 h max | ordinary mailbox/local state | missed call is not retained as a live offer |
| media allocation/replay | credential <=10 min; replay 24 h | revoke on call end where possible | CallRelay | no stable user credential at relay |

`d` means consecutive 24-hour periods measured against signed server time policy;
local wall clock alone cannot extend validity. Capacity planning MUST prove these
bounds at the release group/contact/message limits. A lower deployment-specific
retention creates a different signed capability and is unavailable to conversations
whose policy requires V1.

## 2. Three different recovery guarantees

| Recovery mode | Guaranteed | Not guaranteed without another source |
|---|---|---|
| existing device after offline period | local account, contacts, local history, XUR1, group state and durable outbox; verified network/control catch-up | service-expired remote ciphertext/blob |
| new device + 24-word recovery phrase | same DeepAccountId/account authority, permanent DID1 and a new independently keyed device | contacts, message/group history, XUR1, old one-time invites, ratchets or outbox |
| new device + authenticated encrypted backup/device transfer | exact item classes named by the backup manifest, re-encrypted to the new device | undeclared or service-expired objects; old private device keys |

Product UI and recovery documentation MUST name the mode. “Restore account” cannot
be presented as “restore all chats.” Apart from the explicitly domain-separated
permanent DID1 address key, the recovery phrase never derives relationship-scoped
contact capabilities, one-time invitations, ratchets, mailbox routes or historical
message keys.

## 3. Beyond-horizon behavior

After 400 days offline, a protected local device or recovery-authorized new device
uses the indefinite root lineage and a root consistency checkpoint, enrolls a new
device/control head and publishes fresh contact/reachability records under the same DID1. Existing local
contacts/history remain local, but an expired XUR1 may require a new verified contact
exchange. Account ID does not change; unavailable old messages are shown as a
retention gap, never as successful empty synchronization.

Revocation is eventual. An offline peer may use its last valid device directory until
it obtains a successor or reaches a signed expiry/checkpoint gate. The UI states this
bounded uncertainty; it never claims instantaneous global revocation.

## 4. Deletion and evidence

Expiry deletes service ciphertext, capability indexes, plaintext-derived metadata and
keys needed only for that object. Aggregate capacity metrics and sanitized fork/abuse
evidence may remain under a separate policy but MUST NOT contain stable account,
device, locator, mailbox, conversation or IP identifiers. Legal hold is not a hidden
V1 feature and would require a separate deployment profile and user claim.

Required tests use simulated signed time plus physical 30/180/365-day fixtures,
boundary seconds, restart during compaction, stale replica repair and explicit
expired-gap UI on Android and Windows.
