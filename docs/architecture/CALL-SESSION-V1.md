# One-to-One Call Session V1

Status: **normative implementation target for the first public release**

V1 call signaling is a closed set of ratcheted DMC2 application events. Registry
call inbox/ICE APIs are legacy and rejected after clean-break. Media is WebRTC
DTLS-SRTP with `CallPrivacyProfile=RelayOnly`; `MediaCarrier` is `MasqueUdp` or
`MaskedTcpCapsule`. Group calls and `DirectPeer` are future profiles.

## 1. Cryptographic binding

The caller creates random `callId32`, `callSecret32` and independent
`answerClaimCapability32`. CallRelay stores only
`SHA256-D("Deep/Call/V1/answer-capability", answerClaimCapability32)` when the
caller creates the claim slot through its allocation.

```text
callRoot = HKDF-Expand-512(
  HKDF-Extract-512(
    SHA512-D("Deep/Call/V1/salt", networkId || conversationId || callId),
    callSecret),
  "Deep/Call/V1/root" || 0x00 || callerDeviceId || recipientAccountHash,
  32)

eventCoreHash32 = SHA256-D(
  "Deep/Call/V1/event-core/<kind>",
  exactCanonicalPayloadWithFinalConfirmationOmitted)

phaseConfirmation32 = HMAC-SHA256(
  callRoot,
  "Deep/Call/V1/phase-confirmation" || 0x00 ||
  phase:u16 || sequence:u64 || senderDeviceId32 ||
  destinationDeviceId32 || priorEventHash32 || eventCoreHash32)
```

The event is also authenticated by DPE2. The confirmation binds every semantic
field, including disposition, allocation, fingerprint, expiry and reconnect state,
to the same call without exporting a ratchet or SRTP key. `callSecret32` and
`answerClaimCapability32` are delivered only inside E2EE DPE2 CallOffer copies:
the secret may also be sent to authorized caller-account mirrors, while the full
capability is sent only to recipient answerers. Neither value may appear in
DAO/XPoint/carrier headers, push hints, logs, telemetry or CallRelay allocation
state. The only permitted disclosure of `answerClaimCapability32` outside DPE2 is
its presentation to CallRelay inside CAC1.

DTLS fingerprint algorithm is SHA-256 only and bytes are the canonical 32-byte
certificate digest, not colon-delimited text. Caller offers DTLS `actpass`; winning
answer chooses `active`, caller becomes `passive`. Any mismatch ends before media.

## 2. Closed DMC2 call payloads

All integers below are unsigned big-endian. Every fixed byte string has the exact
stated length. `ZERO32` means exactly 32 zero bytes. Account/device/head values are
inner E2EE identifiers and are never copied to relay requests. Unknown enum values,
zero required identifiers, invalid conditional-zero fields, non-canonical lengths or
trailing bytes reject before call-state, allocation or media mutation. Each call
payload is at most 8,192 bytes inside the existing DMC2 application-payload bound.

In `eventCoreHash32`, `<kind>` is exactly one of the case-sensitive ASCII strings
`CallOffer`, `CallAnswer`, `CallReconnect` or `CallEnd`, matching the decoded phase.

Closed phases are `1=Offer`, `2=Answer`, `3=Reconnect`, `4=End`. Media profile is
exactly `1=RelayOnly`. Carrier bits are bit 0 `MasqueUdp` and bit 1
`MaskedTcpCapsule`; all other bits reject.

### 2.1 `CMD1` closed media description

No SDP, ICE candidate, codec parameter or WebRTC default may travel in an unsigned
side channel. `CMD1`, version 1, suite `0x0201`, is E2EE-carried inside the call
event that owns it and has exact tags:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | call ID | 32 |
| 3 | description kind | `u8`: `1=Offer`, `2=Answer`, `3=Reconnect` |
| 4 | media sequence | `u64`; equals owning event sequence |
| 5 | media suite | `u16`; exactly `1=CallMediaSuiteV1` |
| 6 | allocation hash | 32 |
| 7 | exact peer-verifiable CAA1 | canonical bytes, `1..4096` |
| 8 | ICE username fragment | canonical ASCII `4..32` |
| 9 | ICE password | canonical ASCII `22..64` |
| 10 | relay-candidate count | `u8`, `1..4` |
| 11 | sorted relay candidates | repeated bounded record below |
| 12 | DTLS version | `u16`; exactly DTLS 1.2 |
| 13 | certificate profile | `u16`; exactly ECDSA P-256/SHA-256 |
| 14 | DTLS certificate fingerprint | 32 |
| 15 | DTLS setup role | `u8`: `1=actpass`, `2=active`, `3=passive` |
| 16 | SRTP profile mask/selection | `u16`; bits defined below |
| 17 | media mask | `u8`; bit 0 audio mandatory, bit 1 video optional |
| 18 | audio codec profile | `u16`; exactly 1 |
| 19 | video codec mask/selection | `u16`; zero iff video absent |
| 20 | RTP/BUNDLE profile | `u16`; exactly 1 |
| 21 | allocation credential commitment | 32 |
| 22 | expires-at | `u64`; cannot exceed CAA1 expiry |

Each candidate is
`transport:u8 || component:u8(1) || priority:u32 || LP8(relayHostAscii[1..253]) ||
port:u16 || tcpType:u8`; transport is `1=UDP`, `2=TCP`, and tcpType is zero for UDP
or `1=active`, `2=passive` for TCP. Candidates sort by exact canonical bytes and
must all be relay candidates authorized by exact CAA1/XCD1; host, server-reflexive,
mDNS and arbitrary TURN candidates reject.

SRTP bits are `0=SRTP_AES128_CM_HMAC_SHA1_80` and
`1=SRTP_AEAD_AES_128_GCM`. Offer/Reconnect-Propose carries a nonempty allowed mask;
Answer/Reconnect-Confirm selects exactly one offered bit. Audio profile 1 is Opus,
48 kHz, one/two channels, payload type 111. Video bits are `0=VP8/PT96` and
`1=H264 constrained-baseline/PT102`; answer selects at most one offered bit.
RTP/BUNDLE profile 1 requires rtcp-mux, BUNDLE, MID 0 audio/MID 1 video, MID
extension 1, abs-send-time 2, transport-wide-cc 3, and closed NACK/PLI/TWCC feedback.
Unknown fmtp/header extension/payload type or platform-added media section rejects
the negotiated state before media.

```text
allocationCredentialCommitment32 = SHA256-D(
  "Deep/Call/V1/allocation-credentials",
  LP16(ASCII(ICE-ufrag)) || LP16(ASCII(ICE-password)) ||
  U8BE(candidateCount) || LP32(exactConcatenatedCandidateRecords))
```

CMD1 computes
`allocationHash32 = SHA256-D("Deep/Call/V1/allocation-result", exactCAA1)` and
requires it to equal tag 6. It verifies CAA1 quorum/current XCD1/XNV1, then requires
CAA1 candidate/credential/media/fingerprint fields to equal CMD1 tags 8..21. The
owner-only CAL1 allocation capability is never included in CMD1 or a call event.

The adapter deterministically renders its platform-local SDP from CMD1 and compares
the post-negotiation selected pair, DTLS role/fingerprint, SRTP, codecs, MIDs,
extensions and RTCP state back to CMD1. A mismatch is `SecurityFailure`; raw SDP is
never a protocol input, log or separately transmitted object.

### 2.2 `CallOffer`

| Order | Field | Type / bound |
|---:|---|---|
| 1 | schema version | `u8`, exactly 1 |
| 2 | call ID | 32 nonzero bytes |
| 3 | phase | `u16`, exactly 1 |
| 4 | sequence | `u64`, exactly 0 |
| 5 | copy role | `u8`: `1=RecipientAnswerer`, `2=CallerMirror` |
| 6 | caller account hash | 32 bytes |
| 7 | caller device ID | 32 bytes |
| 8 | recipient account hash | 32 bytes |
| 9 | destination device ID | 32 bytes |
| 10 | caller DMD1 hash | 32 bytes |
| 11 | recipient DMD1 hash | 32 bytes |
| 12 | caller ADC1 hash | 32 bytes |
| 13 | recipient ADC1 hash | 32 bytes |
| 14 | call secret | 32 nonzero random bytes |
| 15 | answer-claim capability | 32 nonzero random bytes for role 1; `ZERO32` for role 2 |
| 16 | answer-capability commitment | 32 bytes |
| 17 | per-call answer handle | 32 nonzero bytes for role 1; `ZERO32` for role 2 |
| 18 | caller allocation hash | 32 nonzero bytes |
| 19 | caller DTLS fingerprint | 32 nonzero bytes |
| 20 | media profile | `u16`, exactly 1 |
| 21 | allowed carrier mask | `u16`, `1..3` |
| 22 | offered-at Unix seconds | `u64` |
| 23 | expires-at Unix seconds | `u64`; `offeredAt < expiresAt <= offeredAt+60` |
| 24 | prior event hash | `ZERO32` |
| 25 | exact offer CMD1 | canonical bytes; kind Offer, allocation/fingerprint match fields 18/19 |
| 26 | phase confirmation | 32 bytes; final field |

The commitment is
`SHA256-D("Deep/Call/V1/answer-capability", answerClaimCapability32)`.
For every recipient device the caller derives a call-scoped pseudonym:

```text
answerHandle32 = HMAC-SHA256(
  callRoot,
  "Deep/Call/V1/answer-handle" || 0x00 ||
  callId32 || destinationDeviceId32)
```

It is valid only for this call and MUST NOT be reused or exported as a device
identifier. If derivation produces `ZERO32`, the caller discards the offer and
creates a new call ID and call secret; no alternate mapping is permitted. Each
active recipient-device copy has role 1 and carries the same call
secret/capability through its independent DPE2, with its own answer handle. A
caller-account mirror copy has role 2, carries the call secret for authenticated
state convergence, and cannot submit or poll CAC1 because its capability and handle
are zero. The offer is valid only against the exact current heads in fields 10..13.

### 2.3 `CallAnswer`

| Order | Field | Type / bound |
|---:|---|---|
| 1 | schema version | `u8`, exactly 1 |
| 2 | call ID | 32 nonzero bytes |
| 3 | phase | `u16`, exactly 2 |
| 4 | sequence | `u64`, expected next answer sequence for this author |
| 5 | sender account hash | 32 bytes |
| 6 | sender device ID | 32 bytes |
| 7 | destination caller device ID | 32 bytes |
| 8 | answer handle | 32 nonzero bytes |
| 9 | disposition | `u8`: `1=Accepted`, `2=Rejected`, `3=Busy` |
| 10 | scope | `u8`: `1=ThisDevice`, `2=AllRecipientDevices` |
| 11 | callee allocation hash | 32 nonzero bytes only for Accepted; otherwise `ZERO32` |
| 12 | callee DTLS fingerprint | 32 nonzero bytes only for Accepted; otherwise `ZERO32` |
| 13 | exact CallOffer hash | 32 nonzero bytes |
| 14 | exact CAC1 | canonical bytes for Accepted or scope 2; empty otherwise |
| 15 | exact CAO1 | canonical bytes for Accepted or scope 2; empty otherwise |
| 16 | answered-at Unix seconds | `u64` |
| 17 | expires-at Unix seconds | `u64`; `answeredAt < expiresAt <= min(offer.expiresAt, answeredAt+120)` |
| 18 | prior event hash | 32 bytes; exact accepted CallOffer hash for the first answer |
| 19 | exact answer CMD1 | canonical bytes for Accepted; empty otherwise |
| 20 | phase confirmation | 32 bytes; final field |

`Accepted` requires scope 1 and a verified CAC1 Answer winner whose intent binds
the exact offer, handle and candidate fingerprint. Scope 2 requires a verified CAC1
DeclineAll winner. A local role-1 certificate may be generated before CAC1, but the
callee MUST NOT contact CallRelay, allocate media or emit media until it wins CAC1.
After winning, its allocation MUST bind the same candidate fingerprint. Losing
devices destroy the candidate certificate and never send Accepted.

Before caller allocation/media transition, it verifies exact CAC1/CAO1: capability
hash equals the slot created by its offer allocation; call/offer/handle match the
specific recipient copy and authenticated DPE2 sender; CAO1 is committed `Claimed` or
DeclineAll with valid current XCD/XNV replica keys/quorum; request/intent/fingerprint,
operation, expiry and receipt bytes all match. For Accepted, exact CMD1 must match
the CAC intent fingerprint, fields 11/12 and CAA1. A nonzero hash without exact
records, an `AlreadyAnswered` result, stale quorum or sender/handle substitution
rejects before media.

### 2.4 `CallReconnect`

| Order | Field | Type / bound |
|---:|---|---|
| 1 | schema version | `u8`, exactly 1 |
| 2 | call ID | 32 nonzero bytes |
| 3 | phase | `u16`, exactly 3 |
| 4 | sequence | `u64`, expected next reconnect sequence for this author |
| 5 | step | `u8`: `1=Propose`, `2=Confirm` |
| 6 | sender device ID | 32 bytes |
| 7 | destination device ID | 32 bytes |
| 8 | reconnect ID | 32 nonzero random bytes; identical in proposal/confirmation |
| 9 | proposed allocation hash | 32 nonzero bytes |
| 10 | proposed DTLS fingerprint | 32 nonzero bytes |
| 11 | replaced allocation hash | 32 nonzero bytes |
| 12 | replaced DTLS fingerprint | 32 nonzero bytes |
| 13 | proposal hash | `ZERO32` for Propose; exact proposal hash for Confirm |
| 14 | selected carrier | `u16`: `1=MasqueUdp`, `2=MaskedTcpCapsule` |
| 15 | authored-at Unix seconds | `u64` |
| 16 | expires-at Unix seconds | `u64`; `authoredAt < expiresAt <= authoredAt+120` |
| 17 | prior event hash | 32 nonzero bytes |
| 18 | exact reconnect CMD1 | canonical bytes; kind Reconnect and matches proposed allocation/fingerprint |
| 19 | phase confirmation | 32 bytes; final field |

Every proposal and confirmation uses a newly generated allocation and a newly
generated DTLS certificate for that participant leg. A Confirm is valid only after
the peer accepts the exact proposal and binds its hash in field 13. Neither endpoint
may switch media to the candidate path until both authenticated events commit and
both new fingerprints/allocations are verified. Exact lost events retransmit
byte-for-byte.

Before commit, failure destroys the candidate keys/credentials and may retain the old
path only while its signed allocation remains valid. At commit, both endpoints
atomically select the new pair; after the old DTLS association closes they destroy old
credentials and private certificate keys. They MUST NOT fall back to the old or an
unconfirmed path. A later recovery starts a new reconnect ID with fresh certificates.

### 2.5 `CallEnd`

| Order | Field | Type / bound |
|---:|---|---|
| 1 | schema version | `u8`, exactly 1 |
| 2 | call ID | 32 nonzero bytes |
| 3 | phase | `u16`, exactly 4 |
| 4 | sequence | `u64`, expected next end sequence for this author |
| 5 | sender device ID | 32 bytes |
| 6 | destination device ID | 32 bytes |
| 7 | end scope | `u8`: `1=ThisLeg`, `2=WholeCall` |
| 8 | reason | `u16`: `1=Hangup`, `2=Declined`, `3=Busy`, `4=Missed`, `5=Failed`, `6=AnsweredElsewhere`, `7=GlareResolved`, `8=SecurityFailure`, `9=Expired`, `10=Revoked` |
| 9 | final allocation hash | current 32-byte hash, or `ZERO32` if none existed |
| 10 | ended-at Unix seconds | `u64` |
| 11 | prior event hash | 32 nonzero bytes |
| 12 | phase confirmation | 32 bytes; final field |

End is terminal for its declared scope. A changed reason/scope under one author
sequence is a fork. No reason authorizes direct media fallback or reuse of an ended
allocation.

## 3. State machine and ordering

```text
Idle -> Offering -> RemoteRinging -> Connecting -> Connected
                    |                 |              |
                    v                 v              v
                 Declined          Failed       Reconnecting
                    \_________________|______________/
                                      -> Ended
```

Call sequence starts at zero and advances exactly by one per author/phase. Events
bind the prior accepted event hash. Duplicate exact events are idempotent; changed
bytes at one `(callId, phase, sequence, authorDevice)` reject and latch the call.
Offer expires after 60 seconds, allocation after at most 10 minutes, reconnect after
120 seconds, and call-ID replay tombstone after 24 hours.

OfficialXPoint3 ringing, CAC, allocation and reconnect require a current protected
secure-time interval ultimately refreshed by nonce-bound DTT1. For Offer, Answer and
Reconnect, let `authoredAt` be the corresponding offered/answered/authored field.
The receiver requires its complete `[L,U]` interval to fit inside
`[authoredAt-30, expiresAt]` using saturating subtraction, then records the
conservative monotonic deadline `M + (expiresAt-U)`. Expiry never consults wall time
and cannot be extended by reboot or replay. An authenticated CallEnd remains
terminal by sequence/prior hash even after its timestamp; losing time availability
must not prevent hangup.

CallRelay derives claim-slot/allocation expiry from its own DTT1-backed monotonic
clock and the shorter signed offer/policy limit. Client `expiresAt` can only shorten,
never create or extend, server expiry. Without current trusted time it returns a
closed unavailable/expired result and allocates nothing. A future DirectP2P profile
must define a separate peer-authenticated freshness ceremony; it cannot silently
reuse cached XPoint windows or weaken this release profile.

Simultaneous authenticated offers for one conversation use lexicographically lower
`callId32` as the surviving call; the losing side sends End=`GlareResolved` and joins
the winner as callee. This deterministic rule applies only to the same two verified
accounts and cannot select an unauthenticated call.

## 4. Multi-device fanout and answer winner

One logical CallOffer is independently ratcheted to every active recipient device and
the caller's other active devices using the closed role rules above. The full
answer-claim capability is present only in role-1 recipient copies. CallRelay never
receives an account ID, DPD1 device ID or a value reusable as either.

Accept is user action on one device. Before contacting a media allocation endpoint or
emitting media, that device submits canonical tagged `CAC1`, version 1, suite
`0x0201`, through XPoint to the random answer-claim capability:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | operation ID | 32 random bytes, stable across exact retry |
| 3 | call-ID hash | 32 |
| 4 | answer-claim capability | 32 random bytes |
| 5 | answer handle | 32 nonzero bytes |
| 6 | claim kind | `u8`: `1=Answer`, `2=DeclineAll` |
| 7 | answer-intent hash | 32 |
| 8 | issued-at | `u64` |
| 9 | expires-at | `u64`; no later than the CallOffer expiry |
| 10 | claim confirmation | 32 |

`claimKind` is `1=Answer` or `2=DeclineAll`; other values reject. For Answer,
`answerIntentHash32` binds exact CallOffer hash, answer handle, candidate DTLS
fingerprint and disposition Accepted. For DeclineAll it binds the same fields with
disposition Rejected/scope AllRecipientDevices and a zero fingerprint.

```text
callIdHash32 = SHA256-D("Deep/Call/V1/call-id", callId32)

answerIntentHash32 = SHA256-D(
  "Deep/Call/V1/answer-intent",
  exactCallOfferHash32 || answerHandle32 ||
  disposition:u8 || scope:u8 || candidateDtlsFingerprint32)
```

For Answer, disposition/scope are exactly `1/1` and the candidate fingerprint is
nonzero. For DeclineAll, they are exactly `2/2` and the fingerprint is `ZERO32`.

```text
claimConfirmation32 = HMAC-SHA256(
  callRoot,
  "Deep/Call/V1/answer-claim" || 0x00 ||
  SHA256-D("Deep/Call/V1/answer-claim-core", exactCAC1Tags1Through9))
```

Tag 10 is the final field and is omitted, not zeroed, in
`exactCAC1Tags1Through9`. Thus network, operation, call, bearer capability, handle,
kind, intent, issued-at and expiry are all peer-authenticated. CallRelay treats the
confirmation as opaque and cannot rewrite any CAC1 field while preserving a result
acceptable to caller or callee.

CallRelay verifies capability equality by hashing the presented random bearer; it
does not know callRoot or the device behind `answerHandle32`. First quorum-durable
claim wins; exact retry replays. `CAO1`, version 1, suite `0x0201`, is the only
result and has exact tags:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | operation ID | exact CAC1 tag 2 |
| 3 | exact CAC1 request hash | 32 |
| 4 | status | `u16`: `1=Claimed`, `2=AlreadyAnswered`, `3=DeclinedAll`, `4=Expired`, `5=Conflict`, `6=OutcomeUnknown` |
| 5 | winning answer handle | 32; `ZERO32` for Expired/Conflict/OutcomeUnknown |
| 6 | winning answer-intent hash | 32; same zero rule as tag 5 |
| 7 | claim generation | `u64`; zero only when tags 5/6 are zero |
| 8 | committed-at | `u64`; zero only when tags 5/6 are zero |
| 9 | expires-at | `u64` |
| 10 | exact XCD1 hash | 32; nonzero for every result |
| 11 | replica-key generation | `u64`; exact XCD1 tag 6 |
| 12 | exact XNV1 hash | 32; contains exact XCD1/XND1 closure |
| 13 | receipt count | `u8`; exact XCD1 quorum for claimed/already/declined, zero otherwise |
| 14 | sorted replica receipts | exactly `96 * tag13` bytes |

`requestHash32 = SHA256-D("Deep/Call/V1/answer-claim-request", exactCAC1)`.
Each receipt is `replicaId32 || signature64`, sorted by replica ID, and signs
`SIGINPUT("Deep/Call/V1/answer-claim-result", 0x0201, unsignedCAO1 tags 1..12)`.
Committed results therefore bind status, exact request, winning handle/intent,
generation, commit time, expiry and exact replica authority. Receipt verification is
the exact XCD1 procedure in `XPOINT-NETWORK-V1.md`; there is no inferred key set or
fixed quorum outside that descriptor. Expired/Conflict/OutcomeUnknown contain no
receipts; changed bytes under one operation return Conflict, while the exact request
replays the byte-identical committed CAO1. The CallAnswer claim-receipt hash is
`SHA256-D("Deep/Call/V1/answer-claim-receipt", exactCAO1)`. Caller/callee verify
the stored claim confirmation after ratcheted delivery; Relay cannot use it as an
authentication oracle.

Other devices stop before media allocation. The Answer winner allocates a leg bound
to its candidate certificate and sends ratcheted CallAnswer. Caller then fans out
CallEnd=`AnsweredElsewhere` to other recipient devices and its own devices; polling
CAC1 also stops ringing if that event is delayed. Decline on one device does not end
ringing elsewhere unless the user selects “decline on all,” which is another CAS.

## 5. Relay allocation

CallRelay, not Registry, owns short-lived allocation. `CAR1`, version 1, suite
`0x0201`, travels through three-hop XPoint and has exact tags:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | operation ID | 32, stable across exact retry |
| 3 | random call handle | 32; not call/account/device ID |
| 4 | participant commitment | 32 random call-scoped bytes |
| 5 | exact XCD1 hash | 32 |
| 6 | leg role | `u8`: `1=Caller`, `2=AnswerWinner`, `3=Reconnect` |
| 7 | media suite | `u16`; exactly CallMediaSuiteV1 |
| 8 | DTLS fingerprint | 32 |
| 9 | SRTP allowed/selected mask | `u16`; CMD1 semantics |
| 10 | media/video codec masks | `u8 || u16`; CMD1 semantics |
| 11 | requested carrier mask | `u16`, `1..3` |
| 12 | new allocation capability | 32 nonzero CSPRNG bytes for every role; stable only across exact retry |
| 13 | answer-claim capability commitment | 32 for Caller; zero otherwise |
| 14 | exact committed CAO1 | canonical bytes for AnswerWinner; empty otherwise |
| 15 | prior allocation capability + reconnect authorization hash | 64 for Reconnect; empty otherwise |
| 16 | unlinkable admission-token commitment | 32 |
| 17 | issued-at | `u64` |
| 18 | expires-at | `u64`; may only shorten policy expiry |
| 19 | exact current XNV1 hash | 32; contains exact XCD1/XND1 closure |

Role-conditional authorization fields are exact: Caller requires nonzero tag 13 and
empty tags 14/15; AnswerWinner requires zero tag 13, exact tag 14 and empty tag 15;
Reconnect requires zero tag 13, empty tag 14 and exact tag 15. Tag 12 is mandatory
and independent of every authorization class; supplying any other presence set
rejects. Caller creation atomically creates the answer slot and stores only the
hashes of tags 12/13. AnswerWinner authorization resolves exact CAO1 Claim and binds
its fingerprint/intent, then stores only the tag-12 hash. Reconnect authorization
verifies the raw prior allocation capability and binds an acyclic prospective intent.
The new tag-12 commitment belongs only to the new allocation; the prior commitment
remains scoped to the old allocation until expiry or an owner-authorized retirement
after E2EE reconnect confirmation and can never authorize the new allocation:

```text
reconnectAuthorizationHash32 = SHA256-D(
  "Deep/Call/V1/reconnect-allocation-intent",
  callId32 || reconnectId32 || step:u8 || sequence:u64 ||
  newDtlsFingerprint32 || replacedAllocationHash32 ||
  selectedCarrier:u16 || authoredAt:u64 || expiresAt:u64 ||
  proposalHashOrZero32)
```

The intent contains no CAR1, CAA1, CMD1 or new allocation hash. It is placed after
the prior capability in tag 15; the later authenticated CallReconnect must recompute
the same intent from its fields and its proposal relation before accepting exact CAA1
inside CMD1. This direction is intent -> CAR1 -> CAA1 -> CMD1 -> CallReconnect and
has no hash cycle. CAR1 request hash is
`SHA256-D("Deep/Call/V1/allocation-request", exactCAR1)`.

`CAA1`, version 1, suite `0x0201`, is the only result:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16 |
| 2 | operation ID | exact CAR1 tag 2 |
| 3 | exact CAR1 request hash | 32 |
| 4 | status | `u16`: `1=Allocated`, `2=Expired`, `3=Unauthorized`, `4=RateLimited`, `5=Conflict`, `6=OutcomeUnknown` |
| 5 | retry-after seconds | `u32`; positive only for RateLimited/OutcomeUnknown |
| 6 | allocation ID | 32; success only |
| 7 | exact XCD1 hash | 32; nonzero for every status |
| 8 | replica-key generation | `u64`; exact XCD1 tag 6 |
| 9 | exact XNV1 hash | 32; contains exact XCD1/XND1 closure |
| 10 | selected carrier | `u16`; success only |
| 11 | sorted relay candidate set | `LP32`, CMD1 candidate grammar, success only |
| 12 | ICE username fragment | canonical ASCII `4..32`, success only |
| 13 | ICE password | canonical ASCII `22..64`, success only |
| 14 | media suite | `u16`; exactly CallMediaSuiteV1 on success |
| 15 | DTLS fingerprint | 32; success only |
| 16 | SRTP allowed/selected mask | `u16`; exact CAR1 tag 9 on success |
| 17 | media/video codec masks | `u8 || u16`; exact CAR1 tag 10 on success |
| 18 | allocation-capability commitment | 32; success only |
| 19 | credential commitment | 32; success only |
| 20 | bandwidth limit | `u32`, success only |
| 21 | maximum datagram | `u16`, success only and within XCD1 |
| 22 | issued-at | `u64`, success only |
| 23 | expires-at | `u64`, success only |
| 24 | replay generation | `u64`, success only |
| 25 | receipt count | `u8`; present on success and exactly the XCD1 quorum |
| 26 | sorted replica receipts | present on success; exactly `96 * tag25` bytes |

The complete canonical CAA1 is `1..4096` bytes. Tag 11 contains exactly `1..4`
canonical CMD1 candidate records and no separate/trailing bytes; its record count is
derived by complete bounded parsing and is the same count used by the credential
commitment.

Tags 1..5 and 7..9 are always present. `Allocated` additionally requires
tag 6 and every tag 10..26. Every other status omits tag 6 and every tag 10..26;
tag 5 is zero unless the status is RateLimited or OutcomeUnknown. No other presence
set is canonical. Each success receipt
signs `SIGINPUT("Deep/Call/V1/allocation-result", 0x0201, unsignedCAA1 tags
1..24)` under the exact XCD1/XNV1 replica generation. Exact retry returns the same
allocation/credential/replay tuple; changed bytes conflict.

Before signing, replicas copy tags 14..17 from exact CAR1 tags 7..10, require tag 15
to equal CAR1 fingerprint, require CAA1 tag 9 to equal CAR1 tag 19, and fix tag 18 to
`SHA256-D("Deep/Call/V1/allocation-capability", CAR1.tag12)`. Every replica durably
stores the same operation hash, capability commitment and unsigned CAA1 tags 1..24
before signing; raw tag 12 is fixed-time compared and discarded after request
processing. A replica rejects a second capability/commitment or changed unsigned
bytes for that operation. Tag 19 is computed with the length-framed CMD1 formula.
Exact retry presents the same CAR1 tag 12, verifies against the stored commitment and
returns the byte-identical result; a response is not `Allocated` until quorum
durability and signatures are complete.
The peer receives exact CAA1 inside CMD1 and verifies signatures, XCD/XNV, candidates,
credentials, suite, fingerprint, masks and expiry without receiving an allocation
bearer. No SDP side channel may alter them.

The owner-facing onion response for every CAA1 status is `CAL1`, version 1, suite
`0x0201`:

| Tag | Value | Size / rule |
|---:|---|---|
| 1 | network ID | 16; exact CAA1 |
| 2 | operation ID | exact CAA1 tag 2 |
| 3 | exact CAA1 | canonical bytes, `1..4096` |
| 4 | raw allocation capability | 32; nonzero exactly for Allocated, `ZERO32` otherwise |

For Allocated,
`CAA1.allocationCapabilityCommitment =
SHA256-D("Deep/Call/V1/allocation-capability", CAL1.tag4)` and CAL1 tag 4 is exact
CAR1 tag 12. For every other status
CAA1 omits the commitment and CAL1 tag 4 is exactly `ZERO32`. The client accepts a
successful CAL1 only after exact CAA1 quorum verification and fixed-time commitment
comparison; a mismatch destroys tag 4 and fails closed as `SecurityFailure`.
Every non-Allocated result destroys the locally generated CAR1 tag 12 after the
operation is reconciled; it never becomes an authorization for a later request.
CAL1 is returned only inside the participant's sealed onion response; outside its
originating sealed CAR1 request it is never put in CMD1/DMC2/logs, and is protected
local state for exact retry/reconnect. This split is
one-way (`CAR1 -> CAA1 -> CAL1/CMD1`) and creates no CAA/CMD hash cycle.

The Registry publishes byte-identical signed relay catalogs and policy only. It does
not authorize an allocation and never sees call IDs, SDP, fingerprints or peers.

## 6. Media and privacy checks

- Official V1 exposes only relay candidates to WebRTC: no host, mDNS,
  server-reflexive, direct TURN origin or public STUN candidate.
- Caller creates its offer-bound allocation and fresh certificate before CallOffer
  but sends no microphone/camera media before the authenticated winning answer.
  Callee performs no relay allocation before explicit accept and CAC1 victory.
- Every participant leg uses a fresh non-exportable DTLS private key and certificate
  generated inside the platform/WebRTC provider for that call. A certificate or
  fingerprint MUST NOT be reused across call IDs, accounts or devices. Failure to
  obtain a non-exportable key fails the call closed. Private keys are destroyed on
  losing CAC1, terminal end or confirmed reconnect retirement and are never logged,
  backed up or supplied to CallRelay.
- CallRelay forwards encrypted DTLS/SRTP and cannot substitute a certificate because
  both E2EE peers verify the bound SHA-256 fingerprint.
- `MasqueUdp` failure may switch to `MaskedTcpCapsule` with a higher call sequence and
  new CAA1; it never enables direct ICE.
- Carrier/relay switch preserves call ID but rotates allocation and ICE credentials.
  Media resumes only after authenticated CallReconnect confirmation.

## 7. Required gates

1. Android↔Windows offer/answer/end, both directions, with five target devices.
2. Concurrent answers prove one winner across crash/retry and stop other media legs.
3. Glare, stale answer, sequence fork, replay, wrong DTLS role/fingerprint and
   malicious-relay substitution fail before media.
4. Packet capture proves no host/srflx/direct candidate and no unmasked relay origin.
5. UDP block switches to MaskedTcpCapsule; relay rotation/reconnect meets SLO.
6. Registry unavailable after signed catalog bootstrap does not break signaling or
   allocation; loss of all CallRelay paths fails closed without direct fallback.
7. Relay decrypt-negative evidence gives the test CallRelay all server-side carrier,
   TLS, TURN, allocation, signing and access-token keys plus full packet captures and
   known RTP plaintext markers. It MUST still be unable to derive/export a DTLS
   exporter, SRTP master/session key, RTP/RTCP plaintext, codec frame or media marker.
   The relay process and crash dump contain no endpoint DTLS private key or SRTP key.
8. An instrumented malicious relay that terminates/injects DTLS, substitutes either
   certificate/fingerprint, rewrites allocation state, replays a retired reconnect or
   forwards before confirmation causes `SecurityFailure` before either endpoint emits
   media on that path. The gate records a negative decrypt result, endpoint abort and
   zero decoded frames; transport success alone is not evidence.
