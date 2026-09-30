# DR-0019 — sealed DID2 pre-XPK1 secret persistence

Status: **accepted bounded local API; runtime activation remains gated**
Date: 2026-09-30
Decision owner: **Mr. X** (delegated architecture authority)

## Decision

Protocol adds exactly three public types in MessagingCrypto:

- `InitiatorDph2PreKeyClaimPersistenceScope(databaseInstanceId32, logicalIntentId32)`;
- `InitiatorDph2PreKeyClaimPersistenceBlob`, with bounded structural `Decode`
  and defensive ciphertext-byte access, no public constructor;
- `InitiatorDph2PreKeyClaimPersistenceProtector(atRestKey32)`, a disposable
  zeroizing owner with `SealAndConsume(startedClaim, scope)` and
  `RestoreCurrentAsync(blob, scope, localAuthority, exactCurrentDirectory,
  currentAccount, trustedTimeAuthority, cancellationToken)`.

The blob is local ciphertext, not a wire record or authority. The protector
consumes the started claim and never exposes its private scalars. Restore
authenticates the exact scope/header, verifies both private/public X25519 pairs
and the sender commitment, and checks the exact DID2/DMD1/device at initial
and final protected-clock readings. Cancellation, changed boot, stale proof,
wrong scope/key, tamper or concurrent protector disposal must not release a
restored claim. No device agreement lease is minted or spent by persistence.

## Closed local format

The sole version has a 2,472-byte AAD header and a 64-byte plaintext (ephemeral
scalar then initial-ratchet scalar), followed by the 16-byte XChaCha20-Poly1305
tag; exact total size is 2,552 bytes. Header fields, in order:

| Offset | Value | Bytes |
|---:|---|---:|
| 0 | ASCII `IPK2` | 4 |
| 4 | version `1`, algorithm `1`, reserved zero | 1 + 1 + 2 |
| 8 | exact total length, u32 big-endian | 4 |
| 12 | database instance, logical intent | 32 + 32 |
| 76 | network, account, device | 16 + 32 + 32 |
| 156 | device generation u64, exact DPD1 hash | 8 + 32 |
| 196 | directory generation u64, exact DMD1 hash | 8 + 32 |
| 236 | exact DID2 | 2052 |
| 2288 | device agreement public key, claim operation, sender commitment | 32 + 32 + 32 |
| 2384 | ephemeral public key, initial-ratchet public key | 32 + 32 |
| 2448 | independently random nonce | 24 |

All identifiers/keys/hashes and both generations are nonzero; DID2 is decoded
by its exact current codec. Unknown versions/algorithms/reserved bits, sizes
or noncanonical fields reject before secret restoration. Derive the AEAD key
as HMAC-SHA-256(atRestKey32, ASCII
`Deep/Messaging/V2/dph2-preclaim-persistence-key` || zero byte || exact header).
The exact header is also AEAD AAD. This domain is local at-rest protection,
not a change to the handshake KDF, signature inputs, suite or remote record.

## Remaining gates

Shared must durably bind the sealed state to its protected account/database
instance and logical intent before XPK1 dispatch. The public claim pair from
the preceding increment is insufficient without those secrets. This API does
not close the later device-DH burn/prepared-secret commit boundary: completion
must not replay a spent lease or silently select a different prekey. After
durable DPH2/TRS1 commit dispatch remains byte-identical. Current-recipient
proof, independent replica storage read-back, ContactHello/inbox/ACK and
physical device delivery remain required.

No migration, legacy reader or raw private-key/provider callback is added.
Rebuild the three-assembly graph and downstream consumers, review actual
Debug/Release API snapshots, and retain scope/tamper/replay/ownership tests.
Preserve node keys, network genesis and protected network floors.
