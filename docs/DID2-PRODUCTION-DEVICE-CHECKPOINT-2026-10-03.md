# DID2 production/device checkpoint — 2026-10-03

This is an incomplete physical diagnostic, not release approval. Registry and
all three seed nodes are production infrastructure; Mr. X permits testing there
before real users are announced. Private addresses and custody paths are omitted.

## Matched source rollout

- Registry source `50a093f`, Protocol `bfc1481`, DevOps `1e357b5`:
  image `sha256:8ab785d105899e6320e0133e94d6c2e60df77467a4bac4e3a8c6315bde789b37`.
- Initial matched three-node XNode rollout: source `48e31ec`, Protocol `bfc1481`:
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

The first diagnostic clients were built from MAUI `c13ea0c`, Shared `5d91f54` and Protocol
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
store failures in the UI.
Four Shared mapping/no-replay tests and 32 MAUI display tests passed, zero
failures/skips. They are not additional physical coverage or full release gates.

The matched diagnostic increment MAUI `41bc075`, Shared `920f994` and Protocol
`bfc1481` was then built through the same supported scripts:

| Artifact | SHA-256 |
| --- | --- |
| Windows apphost | `23b936835631267a7048af25dff32e14e3da04e40300313fd918d7fa8d01e1ad` |
| Windows assembly | `f955f95a0ed1ea613ce9413ae9759f1ae6e52931eda6f0c7c4e41c395facf603` |
| Signed Android arm64 APK | `f699f091e4878ee67d82687a3b8682d53228f31ebce76784ab6c10b9b23fad56` |

Android build: zero warnings/errors, same signer. Updating only the isolated QA
package retained its account/recovery and matched all three protected package
snapshots. A guarded retained-account network action independently ended at
`ContactPublication / OnionDependencyRejected`. This proves a typed ingress
rejection, not a local custody rejection; it does not alone identify the failing
hop or give retry authority. Windows's new diagnostic executable is built but
has not been launched; the previous isolated QA remains untouched.

Bounded read-only checks across all three nodes counted canonical peer
`503 / RejectedBeforeForward` responses on two nodes, without peer transport or
media/version rejection matches. The Registry access-log tail contained no
coordination POST matches in that window. Absence from a bounded log is not proof
of absence of forwarding. XNode `b4c1673` adds closed phase/currentness-check
diagnostics without exception objects/messages or request material. Its 32
focused in-process contact tests passed, zero failures/skips; this is not a
physical delivery result. The diagnostic image was then upgraded sequentially
on all three production nodes through the same pinned supported installer:
source `b4c1673`, Protocol `bfc1481`, actual image
`sha256:f2790d4298a20cc8a12781708cd4a61642276e6f3b75821ad115c8a04e0b767a`.
All installer exits were zero; registered Ed25519/BLS key hashes matched on
every node. Independent node probes returned readiness 200, ONION ready and
required terminals ready. Mailbox authority remains not ready. No Registry,
proxy, certbot, portal, genesis or floor reset was performed for this increment.

The next retained Android action still ended at `OnionDependencyRejected`.
Canonical before-forward 503s were observed again, with no coordination-phase
warning. A read-only mounted-config/environment audit then found the concrete
deployment regression: every node's active configuration omitted the entire
contact profile, so the XCA2 terminal was disabled. The image upgrade wrappers
had selected an older prekey-only prepared bundle, not the previously reviewed
contact-enabled bundle. Health had not detected this optional-terminal omission.

The canonical DevOps stager (`c8c59e2`) and its byte-identical standalone installer
copy (`7ade635`) now reject installed contact-to-prekey-only downgrade before
creating/selecting another bundle. Nineteen focused preparation/staging Node
tests and the full Bash installer tests passed. Independent read-only checks
verified the existing contact-enabled bundles against their original archive
hashes on all three hosts: all 39 input files verified, staged public records
and transport custody matched the currently active bundles. Re-enabling this
profile does not require changing signed records, genesis, keys or state volumes.

The supported `7ade635` installer restored the reviewed contact profile on all
three production nodes with the unchanged diagnostic image. All exits were zero;
Ed25519/BLS key hashes and named state volumes matched. Independent mounted
configuration checks observed coordination enabled with its fixed backend;
readiness remained 200/ONION ready/required terminals ready. Mailbox authority
remains not ready. The subsequent retained-account Android action independently
ended at `XRA1 / Expiry`: its incomplete route expired during the diagnostic
interval. This does not close publication or retained-account recovery. The
expired exact request was not silently reminted. A fresh isolated Android QA
account is the next device probe; the shipping Android package and Windows
account remain untouched.

XNode `58a4f0e` locally bounds the new warning traffic by closed phase/check
buckets, with cancellation/repeated-rejection assertions and 32 focused tests
passed. It has not replaced production `b4c1673`; those test repeats are not
additional unique scenario/device coverage.

The previous `c13ea0c` Windows executable remains the observed running QA.
Startup rejected incompatible old QA account state. The `41bc075` executable
is built but has not been launched or physically tested. No
Windows account deletion, phrase reveal or account creation was performed;
the exact local reset requires a current UI confirmation before continuation.

## Android publication and restart milestone

After restoring the contact profile, the expired incomplete isolated Android
QA account was reset through the owned confirmation UI. A fresh account was
created once. The immediate post-create hierarchy capture failed; creation
was not repeated. Independent inspection confirmed account/recovery custody.
One guarded network action then independently completed `verified-publication`:
AccountProof, network verification, prekey staging/publication and contact
publication no longer ended at the previous typed ingress failure.

The same dedicated Android process was restarted without reset. Independent
Settings inspection confirmed the saved account and encrypted recovery copy,
with no incompatible-state error. One subsequent guarded network action again
ended at `verified-publication`. All three protected Android package snapshots
matched during these successful phases. Aggregate read-only PostgreSQL probes
observed three route rows and three publication rows both before and after this
restart/reverification, compared with two each before fresh publication.
Counts corroborate issuance activity but do not prove exact bytes or delivery.

This is own-account publication/restart evidence on a physical Android device,
not Windows publication, peer lookup/consent, two-way text, file/image or group
delivery. The existing probe's `deviceDeliveryVerified` remains false. Bounded
expired-incomplete route recovery still needs implementation and coverage.

The next local source increment retains the node's previously discarded PMA2
chain and requires explicit issuer paths for file-based configuration. It
independently verifies the current PMT2 reference/root/full proof interval before
floor advancement and rechecks the exact inputs and time before capability
release. The exporter/preparer/stager/installer are updated together. This is
not mailbox activation, a newly deployed image, or completion of release gates.
The connected local node/coordination slice passed 48 tests, zero failures/skips;
preparer/stager structural checks passed 19 tests. Actual signed file/atomic
inputs, invalid issuer signature, duplicate current issuer, changed issuer
during floor commit and monotonic rollback are covered. Bash syntax and the
full Bash installer tests passed. These are not additional
physical scenario passes or full release qualification.
The local source commits are XNode `1728619`, DevOps `a60b6e0` and Installer
`3818932`. The public-export tool compiled with zero warnings/errors, but was
not executed. A separate development-tool build still fails at its existing
retired `AuthorAsync` call; this increment did not repair that unrelated dev
genesis path or claim a working newly provisioned local environment.

## Open business/release gates

The next local Protocol increment implements the additive
[DR-0080](survival-program/decisions/DR-0080-did2-current-mailbox-host-authority.md)
current host policy. It checks root/current PMT2/full projected proof interval,
retains monotonic continuity across calls, independently validates active grant
issuer/generation/lifetime/signature and exposes copied node/ranking facts.
It has no request replay, holder, revocation, peer quorum or dispatch surface.
Twenty-five new unit cases passed; the connected authority/network slice passed
78 tests and the neutral-authenticated-mailbox/private-route slice passed 55,
with overlapping cases, zero failures/skips. The ordinary Release Protocol
assembly built with zero warnings/errors. Fixture parameter/identity-label
mistakes in the initial test attempts were corrected without changing the
production codec or weakening the negative assertions. This is local code,
not a deployed image or physical delivery result.

The audit also identified a connected-contract gap: the current XRA1/PMS2
selector and XRC1/XRR1 blinded deposit placement are independent random values.
The neutral MAU2/MCG2 carries the latter's placement commitment, not the former.
Deriving the selected replicas from MAU2 placement would therefore not necessarily
reproduce PMS2. The node consumer must close authenticated selection/placement
binding before activation without sending identity-bearing route objects or
exposing the deposit capability through an earlier public selector.

A fresh read-only Windows UI observation still found the previous isolated
executable rejecting incompatible old QA state. The user's latest confirmation
only made the window available; it was not confirmation of account deletion.
No reset, account creation, phrase reveal, message or production mutation was
performed in this increment. Windows publication is still unproven.

- Finish Windows publication and both-device peer lookup/consent after the Android
  publication/restart milestone; preserve exact retained request custody on retries.
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
