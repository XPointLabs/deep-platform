# DR-0020 — atomic DID2 device agreement and initial session

Status: **accepted bounded local store contract; runtime activation gated**
Date: 2026-09-30
Decision owner: **Mr. X** (delegated architecture authority)

## Decision

Do not durably burn DPH2 initiator DH1 and then return an unpersisted preparation.
A closed account-owned operation computes the existing Protocol completion in
memory using an internal, exact-bound one-shot authorization. Neither the lease,
preparation nor completed ciphertext can escape this operation before custody.
The authorization is not returned from the store's general-purpose issuer.

Persist the device-operation burn, agreement metadata and exact completed
DPH2/TRS1 in one SQLCipher transaction. Before SQL commit, an authoritative
protected pending checkpoint retains the complete, bounded result and its
predecessor. On reopen, only this exact pending record may roll forward its
matching predecessor transaction; no DH, KEM or handshake is recomputed. Then
seal the stable protected tip. A stable tip rejects missing/rolled-back or
different SQL history and never repairs it. Dispatch is forbidden until stable.
Cancellation before pending publication abandons no durable operation. Once
pending is durable, finish/recover this bounded local commit independently of
advisory caller cancellation; never select another prekey or operation.

The closed local device schema becomes generation 4. There is no generation-3
reader/migration. Incompatible isolated QA device state needs explicit reset;
network genesis, node keys and network protected floors are unchanged.

## Bounded local custody

One protected checkpoint belongs to the exact device-store instance/account/
network. Version 1 has a 160-byte header: version/phase/reserved (1/1/2),
sequence u64, predecessor hash32, record hash32, instance32, account32,
network16 and payload-length u32, all integers big-endian. Phase 1 is stable
(no payload/predecessor); phase 2 retains one complete pending record. Empty
stable sequence/hash are zero; all other tips are nonzero. At most 128 initial
session records are retained in the SQL hash chain.

The local row payload is version/reserved (1/1), DMD1-length u16, DRS revision
u64, agreement fingerprint32, exact claim replay hash32, framed initial-event
hash32, logical intent32, DPH2-length u32, TRS1-length u32, exact agreement-peer
public key32, then exact DMD1, DPH2 and TRS1. Header length is 180. DMD1 retains
its codec bound; DPH2 is at most 64 KiB (including outer framing and the
32-KiB initial-payload bucket), and initial TRS1 at most 128 KiB. These are local initial-state
bounds, not a change to the complete ratchet's 2-MiB state bound. All bytes are
canonical and device/account/session-bound before persistence or recovery.

Record hash is SHA-256(ASCII `Deep/STORE-V2/device-initial-session-record` ||
zero || instance32 || account32 || network16 || sequence-u64 || predecessor32
|| payload-length-u32 || exact payload). Event hash is SHA-256 of the two exact
initial events, each preceded by its u32 byte length. Protected initialization
is atomic with the device install marker; an absent checkpoint is not repaired.

This is local custody, not a new wire record, signature suite, public crypto
provider or authority to ACK. Later messaging-store projection must consume
only the closed validated store result, never promote arbitrary stored bytes.
ContactHello V2, semantic inbox/ACK, two-replica read-back, shipping composition
and physical Windows/Android delivery remain separate activation gates.
