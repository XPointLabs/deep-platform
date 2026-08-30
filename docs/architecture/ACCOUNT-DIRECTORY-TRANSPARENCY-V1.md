# Account Directory Transparency V1

Status: **normative implementation target for the first public release**

Signed account artifacts alone do not prove freshness to a sender with no local
history. This contract prevents a revoked contact publisher from serving an old but
cryptographically valid DMD1/DRS1 branch. It is a transparency and freshness layer,
not a public account search service.

## 1. Privacy boundary and roles

- Each permanent DID1 derives a network-scoped `directoryLookupKey32` using
  `SHA256-D("Deep/AccountDirectory/V1/lookup", networkId16 || exactDID1)`.
  It is not derived from DeepAccountId, survives device recovery and is shared
  only by holders of the Deep ID/established E2EE state.
- The public log stores `directoryLeafKey32 = SHA256-D(domain,
  directoryLookupKey32)`, not an account ID.
- Lookup is sent through two-relay OHTTP or the XPoint three-hop path. The log sees
  a stable opaque leaf key but not client IP; the relay sees client IP but not key.
- A directory response contains signed DPA1/DRS1/DMD1 closure and therefore reveals
  the contacted account to the holder of its Deep ID. It reveals no contact graph.
- Directory authorities necessarily validate the DID1 hash/address-key-to-account binding when
  authoring ADC1/XPA1 and can observe that stable pseudonymous mapping. OHTTP/
  XPoint hides the requesting/publishing source IP; padding and batching limit
  timing, but a malicious threshold or global observer remains a metadata
  non-claim. Invite stores receive only XPA1 and do not receive that mapping.
- `deep-registry-api` may distribute byte-identical heads/proofs but cannot author
  them. Directory witnesses and clients gossip heads.

Initial D0 uses three independently keyed witness roles and threshold 2-of-3. This
does not claim independent operators until deployment evidence proves them. At D2+
the signed policy requires `ceil(2N/3)` witnesses and bounded operator/provider
diversity.

## 2. Canonical artifacts

### 2.1 `ADC1` account directory checkpoint

```text
networkId16, directoryLeafKey32, accountGeneration:u64
checkpointGeneration:u64, predecessorCheckpointHash32
exactDPA1Ref38, exactDRS1Ref38, exactDMD1Hash32, exactDAB1Hash32
revokedDCAAuthorizationIdsHash32
issuedAt:u64, minimumReader:u16
account-directory-authority signature
```

An enrollment, revocation, DMD1 change or DCA1 revoke MUST produce the next ADC1
before a new contact bundle or pre-key claim is accepted. Same-generation changed
bytes permanently fork-latch that account leaf.

### 2.2 `ADH1` witnessed log head

```text
networkId16, logGeneration:u64, predecessorHeadHash32
treeSize:u64, RFC6962StyleMerkleRoot32
validFrom:u64, validUntil:u64, minimumReader:u16
sorted witnessId32/signature64 entries
```

ADH1 is valid for at most 24 hours and is normally issued every six hours. The
signed policy defines exact witness set/threshold. A head below a protected local
floor, a second root for one `(generation, treeSize)`, or a non-successor without a
root-authorized consistency checkpoint blocks account mutation and first contact.

### 2.3 `ADP1` lookup proof and `ADL1` capability

ADL1 is shared in DCB1:

```text
networkId16, directoryLookupKey32, minimumAdhGeneration:u64
minimumAdhHash32, OHTTP/XPoint service profile:u16
```

ADP1 returns exact ADC1, exact DID1 hash/address public key plus
DAB1/DPA1/DRS1/DMD1/DPD1 closure, exact ADH1, an
inclusion proof for `SHA256(directoryLeafKey || ADC1Hash)`, and a consistency proof
from the caller's optional LKG ADH1. Proof nodes are exactly 32 bytes, ordered by
the RFC-6962 binary Merkle algorithm, count-prefixed and bounded to 64 nodes each.
No unauthenticated pagination or “latest” pointer is accepted. ADL1 has no
wall-clock expiry; its generation/hash is a rollback floor. A current ADH1 is
still mandatory and cannot be replaced by the floor.

## 3. Validation and freshness

For first contact the client obtains ADH1 from at least two acquisition paths when
available, verifies threshold signatures, requires `validUntil` to be current under
the secure-time rules below, then validates ADP1 and exact artifact closure. DCB1's
DPA/DRS/DMD/DAB and DCA publisher MUST match the current ADC1 exactly. A revoked DCA ID
or stale device fails before ML-KEM, storage or UI mutation.

An established contact verifies monotonic ADC1/ADH1 against protected LKG. Gossip
piggybacks `(generation, treeSize, headHash)` in ratcheted control events; a mismatch
requests complete fork evidence and pauses sending. Group commit packages include
each member's exact ADC1/ADH1 reference so an owner cannot select an unseen stale
device branch.

## 4. Trusted time

The client stores a protected `secureTimeFloor = (unixSeconds, monotonicSample,
sourceHeadHash)` after every verified ADH1/XNV1. Runtime deadlines use monotonic time.
Artifact validation allows at most +/-10 minutes skew but never accepts a time below
the protected floor minus two minutes.

A fresh install with a clock outside all signed ADH1/XNV1 windows enters
`ClockCorrectionRequired`; it may compare at least two authenticated time hints from
different signed heads/carriers, display the OS-clock problem and perform read-only
bootstrap, but MUST NOT authorize account-directory, node, pre-key or mailbox
mutation. A network time hint cannot move the floor backward or extend an artifact's
signed expiry. Account creation remains fully offline and independent of secure time.

## 5. Retention and recovery

Witnesses retain exact heads, consistency proofs and ADC1 leaves for at least 400
days and 1,024 generations; root lineage/checkpoints are indefinite. Beyond the
horizon, recovery authority publishes a new ADC1 and clients use a root-bound
forward checkpoint. This restores account/control trust, not old contacts or content.

## 6. Required gates

1. Fresh sender rejects a stale DMD1/DCB1 signed by a later-revoked publisher.
2. Same-generation fork, split-view witness and selective proof omission fail closed.
3. OHTTP/XPoint captures show no single directory component sees source IP and leaf
   key; this is a non-collusion property, not global anonymity.
4. 30/180/365-day consistency fixtures and beyond-horizon root recovery.
5. Clock rollback, wrong clock, conflicting time hints and protected-floor restore.
6. 10,000-contact lookup/load and proof-size bounds on the weakest Android target.
