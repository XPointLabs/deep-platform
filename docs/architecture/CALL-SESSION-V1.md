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

phaseConfirmation = HMAC-SHA256(callRoot,
  phase:u16 || sequence:u64 || senderDeviceId || recipientDeviceId-or-zero ||
  dtlsFingerprint32 || allocationHash32 || priorEventHash32)
```

Every CallOffer/Answer/Reconnect/End payload carries these exact fields and its
confirmation. The event is also authenticated by DPE2; the confirmation binds all
device fanout copies to one call without exporting a ratchet or SRTP key.

DTLS fingerprint algorithm is SHA-256 only and bytes are the canonical 32-byte
certificate digest, not colon-delimited text. Caller offers DTLS `actpass`; winning
answer chooses `active`, caller becomes `passive`. Any mismatch ends before media.

## 2. State machine and ordering

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

Simultaneous authenticated offers for one conversation use lexicographically lower
`callId32` as the surviving call; the losing side sends End=`GlareResolved` and joins
the winner as callee. This deterministic rule applies only to the same two verified
accounts and cannot select an unauthenticated call.

## 3. Multi-device fanout and answer winner

One logical CallOffer is independently ratcheted to every active recipient device and
the caller's other active devices. It includes current DMD1/ADC1 heads, caller relay
allocation hash, answer-capability commitment and expected caller DTLS fingerprint.

Accept is user action on one device. Before allocating or emitting media, that device
submits `CAC1` through XPoint to the random answer-claim capability:

```text
callIdHash32, answerClaimCapability32, answerDeviceId32
answerEventHash32, operationId32, expiresAt:u64
peerConfirmation32
```

CallRelay verifies capability equality by hashing the presented random bearer; it
does not know callRoot. `peerConfirmation32` is the phaseConfirmation and is
verified only by caller/callee after ratcheted delivery. First quorum-durable claim
wins; exact retry replays. Other devices receive `AlreadyAnswered` and stop before
media allocation. The winner sends ratcheted CallAnswer. Caller then fans out
CallEnd=`AnsweredElsewhere` to other recipient devices and its own devices; polling
CAC1 also stops ringing if that event is delayed. Decline on one device does not end
ringing elsewhere unless the user selects “decline on all,” which is another CAS.

## 4. Relay allocation

CallRelay, not Registry, owns short-lived allocation. `CAR1` request travels through
three-hop XPoint and binds random call handle, participant device commitment,
CallRelay descriptor hash, requested `RelayOnly`/carrier, DTLS fingerprint,
operation ID and expiry. It proves possession of the per-call capability without a
stable account credential.

`CAA1` is CallRelay-signed and binds allocation ID, exact request hash, relay
descriptor/key generation, masked endpoint class, credential commitment, bandwidth
limit, issued/expiry and replay policy. Credentials are returned only inside the
onion response. They are participant-specific, rotate on reconnect and cannot be
used for a different call/device/fingerprint.

The Registry publishes byte-identical signed relay catalogs and policy only. It does
not authorize an allocation and never sees call IDs, SDP, fingerprints or peers.

## 5. Media and privacy checks

- Official V1 exposes only relay candidates to WebRTC: no host, mDNS,
  server-reflexive, direct TURN origin or public STUN candidate.
- Caller may pre-allocate for latency but sends no microphone/camera media before
  remote authenticated answer. Callee performs no allocation before explicit accept.
- CallRelay forwards encrypted DTLS/SRTP and cannot substitute a certificate because
  both E2EE peers verify the bound SHA-256 fingerprint.
- `MasqueUdp` failure may switch to `MaskedTcpCapsule` with a higher call sequence and
  new CAA1; it never enables direct ICE.
- Carrier/relay switch preserves call ID but rotates allocation and ICE credentials.
  Media resumes only after authenticated CallReconnect confirmation.

## 6. Required gates

1. Android↔Windows offer/answer/end, both directions, with five target devices.
2. Concurrent answers prove one winner across crash/retry and stop other media legs.
3. Glare, stale answer, sequence fork, replay, wrong DTLS role/fingerprint and
   malicious-relay substitution fail before media.
4. Packet capture proves no host/srflx/direct candidate and no unmasked relay origin.
5. UDP block switches to MaskedTcpCapsule; relay rotation/reconnect meets SLO.
6. Registry unavailable after signed catalog bootstrap does not break signaling or
   allocation; loss of all CallRelay paths fails closed without direct fallback.
