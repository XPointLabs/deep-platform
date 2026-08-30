# Retention and Recovery Matrix V1

Status: **normative implementation target for the first public release**

Retention is a privacy/capacity policy, not account expiry. The values below are
the only V1 product defaults/maxima. A transport may advertise a lower bound only
before send; it may not silently shorten an already accepted object's signed expiry.
Stable scenario/evidence IDs, producer owners and executable boundary assignments
are the machine contract in
[`release-scope.v1.json`](release-scope.v1.json), validated by
[`release-scope.v1.schema.json`](release-scope.v1.schema.json).

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
| ADC1/ADH1 account-directory history | 400 d and >=1,024 heads | compact only behind ADF1/AFP1 root-authorized checkpoint; checkpoint lineage indefinite | directory witnesses/caches | current-value proof remains safe; beyond-horizon forward merge is explicit |
| group proposals/commits/packages | 400 d and >=1,024 commits | retain fork evidence locally indefinitely | member delivery + bounded control store | current membership recoverable; old chat content may be absent |
| attachment ciphertext | 30 d until materialized; 7 d after authenticated materialization | immediate at shorter disappearing expiry | blob replica set / XNode | recipient sees exact expiry before upload |
| avatar/profile blob | current + predecessor 30 d; max 400 d for unchanged current | predecessor deleted after 30 d | blob replica set / XNode | avatar availability is not message history |
| durable sender outbox payload/key | `retryUntil = min(application expiry, user policy, 30 d maximum)` | delete payload and object-only key after terminal success, cancel or expiry; never extend to the audit deadline | local device only | queued sends survive restart only until the effective retry deadline; expired send is explicit |
| outbox audit tombstone | 30 d after terminal state | delete at its own signed deadline; MUST contain no payload, attachment key or plaintext-derived content | local device only | terminal outcome remains diagnosable without retaining message content |
| semantic dedup tombstone | 45 d | delete after bound | local device; coarse mailbox receipt where needed | duplicate network delivery does not duplicate UI |
| onion replay ID | traffic-key epoch + 72 h | destroy with retired epoch | relevant XNode | no exactly-once network claim |
| carrier replay ID | carrier credential epoch + 72 h | destroy with retired epoch | access bridge/media gateway | no exactly-once carrier claim |
| bridge acquisition transaction/XBA1 batch | 24 h maximum for the XOQ transaction and every returned XBA1 | delete the transaction and token commitments after their shared 24 h deadline; no separate tombstone | oblivious bridge distributor target | lost response cannot mint a second token batch |
| XVP1/XNV1/XNH1/PMT2 operational history | 400 d and >=2,048 generations | compact behind root consistency checkpoint | witnesses/caches/clients | historical policy plus 30/180/365-day trust reconnect supported |
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

## 5. Reusable evidence ownership

Every retention row has one stable scenario/evidence producer below. The producer
publishes the row-specific artifact; `E2E-01` (`deep-tests-e2e`) verifies that
same artifact on the release matrix. These IDs label existing package and release
checks; they do not require a second harness or duplicate CI job.

| Data class | Scenario / evidence | Producer owner | Boundary rules |
|---|---|---|---|
| mailbox text/control ciphertext | `RET-MAILBOX-CIPHERTEXT-V1` / `EVD-RET-MAILBOX-CIPHERTEXT-V1` | `XNODE-01` (`xnode`) | `TIME-BOUNDARY-V1` |
| permanent DID1 address | `RET-PERMANENT-DID-V1` / `EVD-RET-PERMANENT-DID-V1` | `CONTACT-CLIENT-01` (`deep-client-shared`) | `INDEFINITE-CHECKPOINT-V1` |
| unsolicited contact request | `RET-CONTACT-REQUEST-V1` / `EVD-RET-CONTACT-REQUEST-V1` | `CONTACT-SERVICE-01` (`xnode`) | `TIME-BOUNDARY-V1`, `SUPERSESSION-GRACE-V1` |
| encrypted DCR1 publication | `RET-DCR-PUBLICATION-V1` / `EVD-RET-DCR-PUBLICATION-V1` | `CONTACT-SERVICE-01` (`xnode`) | `TIME-BOUNDARY-V1`, `SUPERSESSION-GRACE-V1` |
| DPK2 claim/replay record | `RET-DPK-CLAIM-V1` / `EVD-RET-DPK-CLAIM-V1` | `CONTACT-SERVICE-01` (`xnode`) | `TIME-BOUNDARY-V1`, `SUPERSESSION-GRACE-V1` |
| XRR1 deposit reachability | `RET-XRR-DEPOSIT-V1` / `EVD-RET-XRR-DEPOSIT-V1` | `XNODE-01` (`xnode`) | `TIME-BOUNDARY-V1`, `SUPERSESSION-GRACE-V1` |
| XUR1 encrypted update events | `RET-XUR-UPDATES-V1` / `EVD-RET-XUR-UPDATES-V1` | `CONTACT-SERVICE-01` (`xnode`) | `TIME-BOUNDARY-V1`, `GENERATION-BOUNDARY-V1` |
| DMD1/DRS1/device-control history | `RET-DEVICE-CONTROL-V1` / `EVD-RET-DEVICE-CONTROL-V1` | `DIRECTORY-01` (`deep-registry-api`) | `TIME-BOUNDARY-V1`, `GENERATION-BOUNDARY-V1`, `INDEFINITE-CHECKPOINT-V1` |
| ADC1/ADH1 account-directory history | `RET-ACCOUNT-DIRECTORY-V1` / `EVD-RET-ACCOUNT-DIRECTORY-V1` | `DIRECTORY-01` (`deep-registry-api`) | `TIME-BOUNDARY-V1`, `GENERATION-BOUNDARY-V1`, `INDEFINITE-CHECKPOINT-V1` |
| group proposals/commits/packages | `RET-GROUP-CONTROL-V1` / `EVD-RET-GROUP-CONTROL-V1` | `GROUP-CONTROL-SERVICE-01` (`xnode`) | `TIME-BOUNDARY-V1`, `GENERATION-BOUNDARY-V1` |
| attachment ciphertext | `RET-ATTACHMENT-V1` / `EVD-RET-ATTACHMENT-V1` | `XNODE-01` (`xnode`) | `TIME-BOUNDARY-V1` |
| avatar/profile blob | `RET-PROFILE-BLOB-V1` / `EVD-RET-PROFILE-BLOB-V1` | `XNODE-01` (`xnode`) | `TIME-BOUNDARY-V1`, `SUPERSESSION-GRACE-V1` |
| durable sender outbox payload/key | `RET-OUTBOX-PAYLOAD-V1` / `EVD-RET-OUTBOX-PAYLOAD-V1` | `MSG-01` (`deep-client-shared`) | `TIME-BOUNDARY-V1`, `TERMINAL-TOMBSTONE-V1` |
| outbox audit tombstone | `RET-OUTBOX-TOMBSTONE-V1` / `EVD-RET-OUTBOX-TOMBSTONE-V1` | `MSG-01` (`deep-client-shared`) | `TIME-BOUNDARY-V1`, `TERMINAL-TOMBSTONE-V1` |
| semantic dedup tombstone | `RET-SEMANTIC-DEDUP-V1` / `EVD-RET-SEMANTIC-DEDUP-V1` | `MSG-01` (`deep-client-shared`) | `TIME-BOUNDARY-V1` |
| onion replay ID | `RET-ONION-REPLAY-V1` / `EVD-RET-ONION-REPLAY-V1` | `XNODE-01` (`xnode`) | `TIME-BOUNDARY-V1` |
| carrier replay ID | `RET-CARRIER-REPLAY-V1` / `EVD-RET-CARRIER-REPLAY-V1` | `CARRIER-GATEWAY-01` (`xnode`) | `TIME-BOUNDARY-V1` |
| bridge acquisition transaction/XBA1 batch | `RET-BRIDGE-ACQUISITION-V1` / `EVD-RET-BRIDGE-ACQUISITION-V1` | `BRIDGE-DISTRIBUTOR-01` (`deep-registry-api`) | `TIME-BOUNDARY-V1` |
| XVP1/XNV1/XNH1/PMT2 operational history | `RET-NETWORK-HISTORY-V1` / `EVD-RET-NETWORK-HISTORY-V1` | `DIRECTORY-01` (`deep-registry-api`) | `TIME-BOUNDARY-V1`, `GENERATION-BOUNDARY-V1`, `INDEFINITE-CHECKPOINT-V1` |
| root lineage/transparency checkpoint | `RET-ROOT-CHECKPOINT-V1` / `EVD-RET-ROOT-CHECKPOINT-V1` | `DIRECTORY-01` (`deep-registry-api`) | `INDEFINITE-CHECKPOINT-V1` |
| call signaling/dedup | `RET-CALL-SIGNAL-V1` / `EVD-RET-CALL-SIGNAL-V1` | `CALL-SIGNAL-01` (`deep-client-shared`) | `TIME-BOUNDARY-V1`, `TERMINAL-TOMBSTONE-V1` |
| media allocation/replay | `RET-MEDIA-ALLOCATION-V1` / `EVD-RET-MEDIA-ALLOCATION-V1` | `CALL-RELAY-01` (`xnode`) | `TIME-BOUNDARY-V1`, `TERMINAL-TOMBSTONE-V1` |

Boundary rule semantics are shared by all mapped rows:

- `TIME-BOUNDARY-V1`: evaluate signed deadline minus one second, exactly at the
  deadline and plus one second; local wall clock cannot extend validity.
- `GENERATION-BOUNDARY-V1`: evaluate floor minus one, exactly the floor and plus
  one generation/commit, including restart during compaction. Where the policy
  says time **and** minimum generations, neither condition alone authorizes
  deletion.
- `SUPERSESSION-GRACE-V1`: evaluate predecessor/current/successor visibility
  immediately before, at and after the grace deadline, including stale-replica
  repair and cold restart.
- `TERMINAL-TOMBSTONE-V1`: independently prove deletion of payload/key at the
  effective terminal deadline and survival, metadata-only shape, then deletion
  of the tombstone at its own deadline.
- `INDEFINITE-CHECKPOINT-V1`: beyond the finite horizon, prove root-authorized
  checkpoint/re-enrollment and explicit retention-gap behavior; missing expired
  content cannot be reported as successful empty synchronization.

The reusable scenarios combine simulated signed time with physical
Android/Windows recovery fixtures where required by the machine contract. Exact
row cases, including long-offline horizons, replica repair and compaction, are
listed once in `release-scope.v1.json`.
