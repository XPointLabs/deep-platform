# DID2 production/device checkpoint — 2026-10-03

This is an incomplete physical diagnostic, not release approval. Registry and
all three seed nodes are production infrastructure; Mr. X permits testing there
before real users are announced. Private addresses and custody paths are omitted.

## Matched source rollout

- Registry source `50a093f`, Protocol `bfc1481`, DevOps `1e357b5`:
  image `sha256:8ab785d105899e6320e0133e94d6c2e60df77467a4bac4e3a8c6315bde789b37`.
- All three XNode source `48e31ec`, Protocol `bfc1481`:
  image `sha256:5b8635eba5d24126c2c45b96d4403ce3e0744d6d9d5140e4e8e94b069a8979c0`.
  The existing supported installer performed the upgrades. Registered Ed25519
  and BLS key hashes matched before/after on every node.
- The independent PostgreSQL route/publication successor journals were upgraded
  by the operator under one stopped coordination owner and a transaction with
  table/floor locks. A full private schema backup was separately copied and
  SHA-256 verified. Both old route rows and both old publication rows remain
  byte-identical audit state; reservations, counts, capacity and floor were
  preserved. No runtime DDL, legacy decoding, backfill or genesis reset.
- Registry retains its prior stopped container and protected private backup.
  Seven protected key files and 11,296 nonce markers passed preservation checks.
  The loopback listener and proxy/certbot/staking configuration were unchanged.
- Independent public Registry readiness and DID2 readiness returned 200, as did
  the staking portal. All three node readiness probes returned 200 with ONION
  and required terminals ready. These checks do not prove account POSTs,
  recipient authority, delivery or release qualification.

## Physical clients

Both clients were built from MAUI `c13ea0c`, Shared `5d91f54` and Protocol
`bfc1481`, using the supported pinned build scripts and retained genesis pins.

| Artifact | SHA-256 |
| --- | --- |
| Windows apphost | `5a8bde74a1d25a9dcebebc437c5aa334e072be7f63c784c134c73395f4bb6637` |
| Windows assembly | `efcc009a48eec5f04f0a77bfcc2176d9b65dc9fb72cdd55e96be35d1bbe7bc98` |
| Signed Android arm64 APK | `645c15743678a7d4438f41b334acc9281498e3f331cab10398e71e41616022a1` |

The Android build completed with zero warnings/errors. APK signer SHA-256:
`bf8abed56e852d0902796f9e0131789f188688784a07ad516760f127684204c2`.
These diagnostic packages are not shipping composition or portable release proof.

The dedicated Android HTTPS QA package was updated. It rejected incompatible
old protected state, which was explicitly reset through its owned confirmation
UI under the human's standing disposable-QA authorization. A fresh one-click
account was created. Its immediate post-click UI capture failed; the mutation
was not repeated. Independent subsequent inspection confirmed the account and
retained encrypted recovery phrase. All three protected Android package
snapshots matched before/after the successful phases.

One guarded network action progressed past AccountProof, NetworkVerification,
PreKeyStaging and PreKeyPublication, then independently inspected terminal state
reported `DID2 ContactPublication failed (TransportIo)`. This is **not** complete
contact publication or messaging success, and does not identify the cause of IO.
All node closed terminal-failure counts were empty in the subsequent bounded
window; the independent route/publication journal counts were still two each.
Neither observation proves that no request was forwarded.

A second guarded action on the same retained account independently reached the
same ContactPublication/TransportIo terminal result. No account reset or request
remint was used for that retry. The next focused increment preserves the existing
typed ingress rejection at the Shared boundary and distinguishes typed local
store failures in the UI; neither has yet localized this physical failure.
Four Shared mapping/no-replay tests and 32 MAUI display tests passed, zero
failures/skips. They are not additional physical coverage or full release gates.

The new Windows executable was launched after closing only the previous QA
process. Startup rejected incompatible old QA account state as expected. No
Windows account deletion, phrase reveal or account creation was performed;
the exact local reset requires a current UI confirmation before continuation.

## Open business/release gates

- Localize the physical ContactPublication IO failure and finish publication on
  both devices; preserve exact retained request custody across retry/restart.
- Complete bounded expired-incomplete route recovery and service/PMT rollover.
- Activate the matched DR54 private issuer with the existing separate PMA2 role
  keys and protected external signer sockets. It remains disabled in the current
  rollout; a configured URL or public health cannot replace grant evidence.
- Replace the node mailbox activation/authority/replica graph's remaining PMA1
  topology dependency with current independently verified PMA2/PMT2/PMS2. All
  three nodes currently report mailbox production authority not ready. Do not
  enable the retired graph or convert old authority to claim DID2 delivery.
- Physically verify peer lookup/consent, two-way text, file/image integrity,
  governed group membership/messages and restart/offline recovery. The current
  DID2 UI explicitly leaves files/images and group creation unavailable.
- Finish full package/API/vector/evidence, recovery and release gates after the
  connected business slice. Focused local crypto/HTTP tests are not device E2E.

No GitHub Release, main merge or push is claimed by this checkpoint. Publication
still requires a separate human command; normal Git authentication must be
restored without bypassing the earlier denied token-based push.
