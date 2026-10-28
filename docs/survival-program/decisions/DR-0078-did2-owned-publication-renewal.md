# DR-0078 — owned current/pending permanent-contact renewal

Status: accepted local ownership increment; private issuer/device activation gated
Date: 2026-10-03
Decision owner: Mr. X (delegated architecture authority)

Wire/journal bounds are superseded by [DR79](DR-0079-did2-publication-issuer-successor.md).
This decision still owns client current/pending custody and atomic promotion.

Connect DR72/74/76/77 under the actual protected account lease. No public retry
ID, currentness flag, new wire, historical dispatch or genesis fallback.
Only a fully committed phase7 predecessor can start automatic renewal.
Authenticate its route, capability-bound object and signed two-replica result
with independently current identity/network/time before deciding from its
signed expiry. Pending renewal resumes even when the prior object is current.
An incomplete expired proposal/winner is NOT abandoned by this increment.
PMT/device/service rollover and capacity exhaustion still fail closed.

Keep the committed original entry unchanged while phases1..6 of its successor
are adopted in the same current-only version7 route journal. Derive the internal
pending locator as SHA256 of ASCII `Deep/Client/DID2/contact-renewal/v1`, one
zero byte, network16, account32, instance32, original intent32 and SHA256 of the
complete exact committed entry. It is not an external operation identifier or
authority. Verify full predecessor bytes in the saved V3 request against that
committed entry before any callback; every resumed phase authenticates history
again. Reserve full pending capacity before dispatch. Preserve exact metadata
custody, request/nonces, issuance head, object, response and result after loss.

Object and publication generations match the exact successor XIR. Use only
closed predecessor successor APIs; preserve permanent address, resolver and
owner capabilities, service/profile/policy and stable route identifiers.
The original entry plus bounded pending entry holds all predecessor evidence;
no caller can supply substitute history through a public service API.

After verifying the current successor object, request, signed winner and BOTH
replica receipts, recheck fresh authority and the held account lease. In ONE
protected journal CAS, rebind the completed phase7 entry to the original intent,
retire its pending role and retain the exact old completed entry under that
already reserved local pending locator. Only its local intent prefix changes;
signed records, private route material and owner capability remain exact.
Verify independent readback before returning. Never delete current custody first.
This **2026-10-09 S01 clarification** closes the former destructive-promotion
wording under the accepted dependency rule in
[DR-0084](DR-0084-owned-delivery-settlement-and-retirement.md) and
[TRANSPORT-NEUTRAL-MESSAGING §8.4.3](../../architecture/TRANSPORT-NEUTRAL-MESSAGING.md#843-compaction-and-boundedness):
promotion/expiry is not permission to delete the last retained read/ACK path.
The private bounded reader resumes active exact work on its original path;
new one-page polls must not silently abandon retained publications. Current
host/issuer/holder/time/replay checks remain required for each selected path.
Path deletion needs its separate dependency-closed retirement proof, not an
empty page, new publication or expired grant. No format, wire or public selector
is added by this clarification; the current private implementation and source
qualification belong to
[Shared custody](../../../deep-client-shared/docs/architecture/owned-mailbox-grant-custody.md#owned-transitions-and-consumers).
Journal revision is canonical phase-count framing, not a generation rollback
floor; promotion may reduce it. Authenticated generation+1 lineage and whole-slot
CAS are mandatory. Interrupted promotion must reopen its actual persisted winner.

Native tests cover preserved current bytes at each phase, bad/lost response,
exact resumed requests, no duplicate signing after adoption, receipt rejection,
atomic promotion and callback-free reopen on the same account/address. In-process
signed replicas are explicitly not physical or server durability evidence.
Registry publication predecessor transport/generation reservation, matched
provision/builds and same-account Windows/Android delivery remain release gates.

## 2026-10-26 — bounded admission of an exact future-start threshold

A freshly signed threshold can start after the recipient's conservative lower
time bound while remaining inside its independently verified uncertainty window.
Server issuance and client admission use different authenticated time anchors;
rereading the same live clock does not make those bounds identical. This is not
permission to accept a threshold before its signed start.

After fetching the exact phase1 response, the owner MAY schedule bounded natural
convergence under the ORIGINAL linked acquisition deadline, including time
already spent fetching. It MUST retain the same request, nonce and response;
no refetch, new issuance, backdating, local UTC, skew allowance or deadline reset.
The scheduling condition is a closed Protocol-produced result, never exception
message matching or a generic cryptographic-error retry. Before producing it,
Protocol MUST authenticate all exact request/response, scope, predecessor,
issuance-head and threshold signatures and check every other time constraint.
Every future start MUST lie at/below the current trusted upper bound; invalid
intervals, expiry, changed authority, bad signatures and unrelated failures
still reject immediately. A future start must not hide another record's expiry
or invalid signature. The result carries only a bounded scheduling duration,
never authority or a reusable verified context.

Each wait is cancellable and bounded by the remaining original deadline and a
finite attempt limit. Following a wait, the owner reacquires actual protected
custody/floor, current key/authority/revocation and same-boot trusted time before
repeating full verification of the SAME response. Actual success still requires
`start <= trustedLower && trustedUpper < expiry` for every required record,
followed by the existing guarded adoption and independent readback. No positive
permission or private key loan crosses the wait. Exhaustion, cancellation or
any changed guard preserves the exact pending proposal and fails closed; a later
explicit resume remains subject to the original winner and normal custody rules.

This changes scheduling only. Wire bytes, private journal versions, signed
lifetimes, replay protection and threshold quorum remain unchanged. Tests must
cover genuine future-start convergence, mixed expiry/invalid-signature rejection,
deadline exhaustion, cancellation, boot/revoke/root changes after the wait and
one exact fetch/adoption. Connected qualification is separate; this lifecycle
wait is never subtracted from an observed maintenance/command duration.

## 2026-10-28 — recorded positive winner after interrupted renewal

Accepted by Mr. X's delegated architecture authority. This narrowly supersedes
the prohibition on closing an expired incomplete proposal when its exact
positive threshold winner is durably recorded and independently authenticated.
Unknown/NULL outcomes, absent evidence and conflicting reservations still fail
closed. Ordinary Route V3, publication bytes, protected journal version10 with
15 records, global carrier caps and permanent generation fences stay unchanged.
No expired XRR/XIR, fictitious intermediate publication or negative evidence is
created. Original requests, private route material and signatures are retained.

### Closed recovery carrier

Allocate XCA2/XCS2 target6 `RouteRecovery`; retired targets3/4 remain retired.
`DeepIdV2ContactRouteRecoveryWireCodec` uses request/response version1 and two
closed modes:1 `ReadRecordedWinner`,2 `IssueAfterRecordedHistory`. Reuse the
existing authenticated private coordination transport, current network/view,
placement and subject-device authentication. No direct client-to-Registry API
shortcut, unauthenticated journal oracle or new primitive is allocated.

All integers are big-endian. Request offsets are:

| Offset | Value |
| --- | --- |
| 0 | version:u16=1, mode:u8=1/2, reserved:u8=0, total:u32 |
| 8 | network16 |
| 24 | fresh outer nonce32 |
| 56 | directory lookup32 |
| 88 | minimum ADH generation:u64 |
| 96 | minimum ADH core hash32 |
| 128 | current view hash32 |
| 160 | outer issued:u64, outer expiry:u64 |
| 176 | ordinary V3 request length:u32, exact request |
| following request | history count:u8, three reserved zero bytes |
| following count | flat pairs: request length:u32/request, response length:u32/response |
| final64 | current subject-device signature |

Sign the entire unsigned envelope including its final total-length value using
the existing device-signature construction and domain
`Deep/ContactResolver/V2/route-recovery-request`. Derive the fresh gateway from
network16||outerNonce32 with existing gateway construction and domain
`Deep/ContactResolver/V2/route-recovery-gateway`. The outer signed interval is at
most120 seconds, within independently current authority/placement. It, not the
expired inner XRA, controls target6 carrier admission. Every inner request is
the unchanged canonical successor V3 form with an exact completed predecessor.

Mode1 carries zero..2 prior pairs and reads the exact base request's positive
winner. Mode2 carries1..3 pairs and issues a fresh base request after that history.
Pairs are flat, never recursive wrappers. Maximum pair is40,252 bytes; fixed
request overhead248; maximum mode1 request105,817 and mode2 request146,069.
With XCA2 header the maximum is146,081, below the existing171,870 global cap.
Response is version:u16/mode:u8/reserved:u8/total:u32, network16, outerNonce32,
SHA256(exact base request)32, responseLength:u32, exact ordinary V3 response;
maximum15,271 bytes. Unknown mode/version, reserved bits, noncanonical encoding,
oversize, trailing data and binding mismatches reject before effects.
Media types are `application/vnd.deep.contact-route-recovery-request.v1+octet-stream`
and `application/vnd.deep.contact-route-recovery-response.v1+octet-stream`.

Mode1 is callback-free journal reading under the existing lock: exact request
match and non-NULL response are required; it never reserves, signs or calls
GetOrIssue. Mode2 authenticates and matches EVERY history pair against Registry's
own permanent rows before reservation and on replay. Registry persists only
the exact base V3 request/response, never the fresh recovery wrapper. A new outer
nonce cannot change an already reserved generation/body or excuse a SQL gap.

### Historical fact and two independent chains

Allocate one closed `VerifiedDeepIdV2ContactRouteRecordedHistory`, produced only
by Protocol verification of fresh current authorization/network/time, the actual
authenticated completed predecessor, and bounded exact request/response pairs.
It has no current-route, dispatch, grant or generic-signing capability.

All pairs name the SAME completed predecessor XIR/closure. The first proposal
immediately succeeds it; every later proposal immediately succeeds the previous
recorded proposal. Validate all original signatures, nonce/scope/DCA/lookup,
XRA/PMS/XRC/XSS graph, immediate generation/hash links, original signed windows
and issuance ADH. Resolve the original XNA through independently authenticated
retained network authority; verify the ADH under that original policy, with
original minimum-floor and current same-generation hash checks. Old ADH is not
current freshness. Current context/boot/floor/revocation must be rechecked after
callbacks. No caller clock, ignore-expiry switch or ordinary live issuance fact
may stand in for historical verification.

After complete authentication, closure requires current trusted lower time
at/after min(XRA.tag13,PMS.tag9,XRC.tag18,XSS.tag11). Issuance-ADH expiry is NOT
included. The initial owner entry point is explicit authenticated XRA expiry
in retained phase1; current-XRA work retains its existing live path. Exceptions
from that live path do not authorize a recovery fallback. Recovery of a still
current XRA with an expired threshold requires its own typed history admission
and is outside this increment.

Fresh authoring/verification/completion and publication lineage accept the
closed history through explicit APIs. In the observed case recorded proposal6
is followed by fresh XRA/XRC7, while actual completed XRR/XIR/DCB/publication5
is followed once by6. Preserve completed predecessors and all ordinary checks;
do not merely permit a generation gap. Subsequent normal proposal and publication
chains each increment once, retaining their independent offsets.

### Atomic protected closure without a journal migration

Keep the entire original phase1 entry byte-identical in immutable protected
custody. Allocate keys `deep.store.v2.contact-renewal-closed/<oldIntentHex>` and
`deep.store.v2.contact-renewal-origin/<SHA256(exactNextBaseV3Request)>`.
The closure has an8-byte header(version:u8=1,state:u8=1,reserved:u16=0,total:u32),
then network16,account32,instance32,permanentIntent32,completedBaseEntryHash32,
oldIntent32,nextIntent32,nextBaseRequestHash32, then length:u32/exactOldPhase1,
length:u32/exactRecordedResponse. Maximum41,753 bytes. The origin index has an
8-byte version1 header, network16,account32,instance32,nextRequestHash32,
oldIntent32,closureRecordHash32; exact184 bytes. Neither contains exportable
authority; original private scalar never enters the recovery wire or artifacts.

Next intent is SHA256 of ASCII
`Deep/Client/DID2/contact-renewal-recorded-successor/v1`, zero byte, network,
account, instance, permanentIntent, completedBaseEntryHash,
SHA256(exactOldPhase1), SHA256(exactRecordedResponse), in that order.
Use the existing CompareExchangeAndInsertAsync: guard exact entire old journal;
replace its old pending with one new ordinary phase1 under nextIntent; atomically
insert BOTH sidecars. New nonce/scalar/request are persisted once before external
issuance. Independently read back all three keys atomically. Conflict/uncertain
completion reopens actual custody and never signs an alternative candidate.
The last committed publication remains unchanged until two genuine new receipts.

Forward resolution starts at the existing derived renewal intent, following
closed/<intent>.nextIntent only if the active entry is absent, at most3 links.
After a link, missing next entry AND next closure is corruption, not genesis.
Restore finds origin by exact request hash and follows archived originals
backwards; this remains valid after ordinary completed-intent promotion.
When that promotion has rebound the retained completed entry's local intent,
compare its base hash after restoring ONLY that authorized prefix to the stored
permanent intent; all other exact bytes must match. A sidecar's claimed base
hash alone is not proof of an actual retained completed entry.
Every retained issuance restoration caller must use this custody, not only
renewal. Three consecutive recorded winners are bounded; a fourth rejects with
custody intact. Moving the old entry frees its active maximum reservation only
in the atomic closure transaction. No terminal journal phase or deletion of
retained evidence is allocated.

### Independent issuer and qualification

Publication bytes remain unchanged. Registry first authenticates the actual
previous publication/route anchor, then walks from the candidate XRA predecessor
through at most3 positive exact journal pairs. Stop only at that authenticated
anchor, never at a missing SQL row. Protocol builds the same history fact used
by the owner's protected sidecars. A database record supplies candidate evidence,
not authority. Ordinary adjacent publication needs no recovery lookup.

Freeze matching machine bounds/vectors and producer/consumer changes together.
Required tests cover recorded6/completed5→live7/completed6, original retained
authority/ADH and foreign authority rejection, all bindings/order/omissions,
NULL/missing/conflicting rows, no issuance on read, unchanged permanent fences,
callback cancellation/expiry/boot/revoke changes, atomic closure crash/readback,
restart after promotion, three chained recoveries and closed fourth-capacity
failure, and matching owner/independent-issuer acceptance. Existing phase2..6
recovery is unchanged. Same3 CLI without resets and fresh latency measurements
remain required; source tests do not establish delivery or release acceptance.
