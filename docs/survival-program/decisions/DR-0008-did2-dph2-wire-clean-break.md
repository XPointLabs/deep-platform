# DR-0008 — DID2-only DPH2 initiation cutover

Status: **accepted architecture; wire remains TARGET_UNFROZEN until the machine registry, vectors and consumers agree**
Date: 2026-09-25
Decision owner: **Mr. X** (delegated architecture authority)

## Problem

DR-0006/DR-0007 created a PQ-root `DID2` of exactly 2,052 bytes, but the
current `DPH2` record still requires a 76-byte `DID1` at tag 20. The current
session-ID and XPK1 sender-ephemeral commitment include those DID1 bytes, and
the inbound initial-claim verifier accepts only an ADP1 V1 current checkpoint.
Replacing tag 20 alone would authenticate the wrong identity lineage; using
the old path for a DID2 account is not a release option.

## Decision

1. The release has **one** DPH2 reader and author: DPH2 record version 2,
   suite `0x0201`, with exact canonical DID2 at tag 20. Version 1 DPH2 is a
   negative fixture, not a compatibility parser or migration input. DPK2,
   DTR2 and DPE2 keep their own existing frame versions and primitive suite;
   the DPH2 frame-version change must be per-record, not a global change to
   unrelated codecs.
2. DPH2 tags 1–19 and 21 retain their reviewed types and order. Tag 20 is
   exactly `DeepIdV2Codec.Did2Length == 2052`, validated as canonical DID2
   before authoring, claim, KEM, DH or durable mutation. The resulting
   canonical DPH2 sizes are **7,977 / 20,265 / 36,649 bytes**, and the
   tags-1–20 handshake header is **3,857 bytes**. The three encrypted initial
   plaintext buckets and XChaCha20 tag stay unchanged. The enclosing DAO1
   sizes for DPH2 are **8,189 / 20,477 / 36,861 bytes**; old DPH2-derived
   sizes must be removed, while DPE2-derived sizes remain separately valid.
3. The exact DID2 bytes replace DID1 in both the non-circular session-ID
   preimage and the XPK1 sender-ephemeral commitment preimage. The existing
   domain labels may stay: the input lengths differ and the canonical DPH2
   header includes record version 2. No alternate hash, KDF, AEAD, KEM or
   signature suite is introduced. The exact tags-1–20 header, full-record
   replay hash, claim binding and initial-payload AAD are recomputed from
   the new canonical record, never copied from old fixtures.
4. The initiator author must obtain current DID2/DAB2/ADC1 V2 and exact
   DMD1/DPD1 evidence. The responder's encrypted XPK1/XPC1 preview promotes
   only against nonce-fresh `VerifiedDeepIdV2DirectoryFreshness` with the
   exact initiator DID2, DAB2, ADC1 V2 and current DMD1. Its verified contact
   publication and XPC1 placement must be DID2-bound too. A V1 freshness,
   contact or checkpoint capability cannot satisfy this verifier.
5. The account-owned protected current-DMD1 ledger must burn one purpose- and
   operation-bound agreement lease before using the local X25519 private key.
   Fetching a signed proof, installing genesis DMD1 or opening a local key
   authority alone grants no DPH2 operation. The proof is rechecked at the
   authoring instant; expiry, boot change, lineage change, replay and fork
   fail closed.
6. The durable initial-session outbox/inbox and DAO1 envelope accept only
   these new exact sizes. This is a pre-user clean break: reset incompatible
   UAT state explicitly, do not migrate or dual-read old sessions. ACK still
   requires authenticated initial payload, exact XPC1 receipt, ratchet and
   semantic contact/inbox commit in one durable sequence.

## Freeze and evidence gate

- Update the single normative crypto specification, machine registry/schema,
  application DAO1 size table and positive/negative vectors together. The
  old registry generation is historical evidence until the replacement is
  internally consistent; changing this decision alone does **not** activate
  DPH2 V2.
- Positive vectors cover all three buckets and both prekey kinds on Android
  arm64 and Windows x64/arm64. Negative vectors cover V1 version, DID1 in tag
  20, malformed/cross-network DID2, session/commitment mismatch, stale or
  forked V2 proof, V1 checkpoint, changed exact XPC1, duplicate/forked DPH2,
  old DAO1 size and wrong protected-device operation.
- Compile and test the complete production graph after removal of the old
  caller API and SQL size checks. A green old-path test is not V2 evidence.
  Then prove one physical Android↔Windows contact → text DPH2/DPE2 → durable
  recipient inbox → authenticated ACK before advancing to images,
  attachments and groups. No GitHub Release follows automatically.

This decision adds no XNode requirement: the first production topology stays
at three nodes; six nodes are deferred until invitation of real users.
