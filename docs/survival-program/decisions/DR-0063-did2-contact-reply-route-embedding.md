# DR-0063 — mandatory private reply route in contact control

Status: **accepted exact clean-break; connected/device activation gated**
Date: 2026-10-02
Decision owner: **Mr. X** (delegated architecture authority)

Choose one path: Hello and Accept each carry their sender's exact DR-0062
private mailbox package inside authenticated application plaintext. No second
bootstrap RouteUpdate, optional route, legacy reader, resolver bypass or secret
disclosure is authorized.

## Event boundary

Replace DR-0022's fixed payload with the same first678 bytes followed by
`LP32(exactPrivateMailboxPackage)`. Length is at offset678, package at682.
Payload bounds become5,917..25,069; empty-reply DMC2 bounds6,199..25,351.
DMC2 version/suite, sequences, XUR1, safety number, flags and expiry rules
stay unchanged. Old678-byte payload/960-byte record rejects. Existing inner
signatures/domains and cryptographic primitives do not change.

Add mandatory `ParsedDeepIdV2ContactMailboxRoute` immediately after the
inbound rendezvous to both capability-based authors. Raw/test-only payload
factories take an additional mandatory exact package; no old overload remains.
Parsed Hello/Accept expose readonly `MailboxRoute`. The package is immutable
untrusted framing, not publication/route authority. Author and endpoint checks
bind its network/account/device/current DAB2/DMD1 metadata to the sender;
they continue to grant only DR-0022's endpoint-metadata claim. Independently
verify full current DCA signature/revocation, network and route/threshold via
DR-0062 before Shared semantic handoff or transport use.

**2026-10-09 S01 clarification — retained event versus live route.** For an
actual native-committed Hello/Accept, semantic reconstruction authenticates its
exact original route as historical facts under independently current account/
device/network authority. Use the closed DR-0072 predecessor verification; it
returns no live route or dispatch permission. The original native/protected
scope, initial event hashes, exact committed Accept and explicit local acceptance
winner (when applicable) remain mandatory and are rechecked before handoff.
Expiry of that old return publication does not erase already authenticated
contact history or require repeating an initial exchange. Parsed/raw caller
packages are never such retained custody. PMT/device/delegation rollover not
supported by that verifier still rejects; do not invent a historical bypass.
DR-0062's current verifier remains unchanged for new transport use. Current
grant/holder/route admission and retained-route Retrieve/ACK checks are separate
from reconstructing semantic history. No wire, format, public authority flag or
legacy reader is introduced.

Outbound Shared authors use only actual phase-7 own publication under the
held account lease with final exact custody readback. Inbound routes come
only from actual retained authenticated Hello/Accept bound to the current
session peer, never caller/UI bytes. Origin custody, current verification,
grant/holder acquisition, original MAU2 retry and ACK remain independent.
Do not persist verified capabilities or silently change a prepared route.

Existing DPH2 buckets stay unchanged. The shipping initial command must
preflight actual owned Init/Hello plus the bounded16,384-byte claim result,
438-byte request, transcript LP32s and event framing against32,764 unpadded
bytes **before** claiming. Unsupported combinations reject without consuming
a prekey; never drop the route or implicitly extend a bucket. The current
exact-three profile must pass this joined gate. Wider topology/bucket changes
require their own freeze; this makes no larger-topology first-contact claim.

## Protected acceptance clean break

**2026-10-12 S04 local retention clean break.** The existing protected accept
slot accepts **generation5 only**, including empty state. This is private local
framing, not a new DMC2/network protocol or cryptographic suite. Keep92-byte
scope header, count and lexicographic operation ordering; revision is at least
count+1 and advances on payload retirement; an empty root has revision1 exactly
(winners are not removed by retention). Each `LP32(entry)` has operation32,
responder scope404, SHA256(exact Hello)32, SHA256(exact Accept)32, payload phase:u8
at500, stop reason:u8 at501, audit disposition:u8 at502, native stop mode:u8 at503
and stoppedAtUpper:u64be at504, firstSuccessfulStoreUpper:u64be at512:520 bytes before any payload. Phase1 appends the exact
canonical variable Accept (entry bounds6,719..25,871); phase2 is exactly520 bytes
and contains no working payload. Both preserve the same independent explicit
consent commitment and uniqueness constraints. Phase, hash or parsed metadata
alone is never consent, native-event, route or deletion authority. Cardinality
stays128, total encoded root remains bounded at the existing1MiB secure-storage
limit. Check actual bytes before allocation/CAS; never silently evict a winner.

The held owner may retire working payload only after actual directional native
and semantic acceptance, every original send attempt's authenticated Store/
holder/public-policy/quorum/coordinator and dependency closure. The existing
protected plan owns ordered exact send/consent successors and independent
guards; crash recovery verifies deterministic successors and exact readback.
Before commit, abandonment requires all exact predecessors and complete staged
successors. After commit, only completion is allowed. Unknown work stays pinned.
Readers join the consent commitment to the actual native hash and canonical
semantic event. Cached replay may return a temporary verified history copy,
never restore working custody or first-encrypt a missing operation. These
plaintext-derived consent/history commitments MUST NOT enter the metadata-only
outbox audit. Initial, cancel/expiry, object-only-key and independent audit
retention remain separate obligations under the sole retention owner.
Generations1/2/3/4, missing/corrupt journal or incompatible contacts require explicit isolated
QA reset, not regeneration, migration or dual parsing.

Control stop reason is0 Active,1 UserCancelled or2 RetryExpired. Unfinished active
work has zero terminal times/audit. Verified successful Store retains the first
authenticated upper time separately, with stop reason/native stop mode/stoppedAt
all zero. A stopped working entry retains authenticated final upper
time and audit disposition0; it cannot dispatch, claim, reauthor or encrypt.
Stopped payload-retired state requires separate audit disposition1 retained
(same time) or2 expired (time cleared). These are private structural metadata,
not serialized permission. Only actual owned native/semantic custody or explicit
unencrypted-draft absence checks and current authenticated time may produce a
stop. Only authenticated lower time proves expiry; upper crossing merely denies
work. Unknown original request/holder/ciphertext and outcomes stay independently
pinned; cancel is not recall or proof of BeforeForward. Audit/payload deletion
requires its own qualified joint transition, not just this fence.

Successful and stopped terminal states are mutually exclusive and monotonic:
late Store after a stop does not rewrite that first stop; late cancel/expiry after
verified success only reauthenticates the original Store. Success payload cleanup
uses the existing ten-root Application control-audit plan, leaves original
send/holder/replay/native/history guarded, and atomically installs a content-free
reason3 SQL audit under the existing opaque control audit ID. Independent send
cleanup follows its own exact original-Store/dependency plan.
Its already-retired consent successor advances only the protected revision:
the existing non-guard adoption remains a genuine ordered transition, without
recreating an expired audit or working payload. Successful working
state has audit0 and a positive firstSuccessfulStoreUpper; payload-retired state
has audit1 with the same time or audit2 with that time zero. At audit1, signed own
lower time must prove first upper plus the retention owner's audit duration.
Audit expiry and local crash/abort recovery use the same closed control-audit
profile and complete SQL/root guards; no new slot, table, wire or public API.
Audit rows contain no consent/history hash, scope, event or key. The retained
consent/history commitments remain independent and are not recreated by retry.

Native stop mode is0 for active work,1 for a native-committed stop and2 for a
stop proven before first encryption. Modes1/2 remain pinned after working-payload
and audit retirement. They are not native authority: actual tip, original event,
semantic history, send custody and audit completeness still require independent
readback. Mode1 cannot excuse native loss; mode2 rejects a subsequently present
native operation. Missing payload must never be regenerated to infer either mode.

Update handoff/native bounds, parity tests, machine payload bounds/vectors and
anchor together. Reverse Accept Store/Retrieve, retry/fork/clock negatives,
private-route ordinary send, MAUI and physical Windows/Android remain gates.
Review actual API snapshots and repin in the connected business batch.
Node keys, registered identities, genesis and production floors stay intact.

Normative owner: [CONTACT-AND-GROUP-PROTOCOL §8–9](../../architecture/CONTACT-AND-GROUP-PROTOCOL-V1.md#8-dmc2-canonical-application-event).
