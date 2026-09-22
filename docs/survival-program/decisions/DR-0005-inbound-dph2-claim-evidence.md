# DR-0005 — Carry responder-verifiable claim evidence inside DPH2

Status: **accepted target; implementation and new vectors pending**
Date: 2026-09-21
Decision owner: **Mr. X** (delegated architecture authority)

## Problem

The current DPH2 header carries a claim operation ID and XPC1 receipt hash,
but its encrypted initial payload contains only SessionInit and an optional
application event. DAO1 seals exactly one DPH2. A previously unknown recipient
therefore receives neither the exact XPK1 request nor the exact XPC1 result.
The production `IDph2VerificationCallbacks.VerifyExactClaim` cannot verify the
threshold claim from a hash alone. Treating the hash, a server assertion, or
local prekey availability as a verified claim would silently weaken E2EE-01.

## Decision

Before first-release activation, replace the DPH2 initial plaintext grammar
with one mandatory encrypted claim transcript followed by the existing DMC2
event sequence:

```text
LP32(exact canonical XPK1 request) ||
LP32(exact padded XPC1 Claimed/Replay wire result) ||
eventCount:u8 || LP32(SessionInitDMC2) ||
[LP32(firstApplicationDMC2)] || random padding || unpaddedLength:u32be
```

The XPC1 wire padding class is at most 16,384 bytes under the existing service
codec, but the claim transcript plus DMC2 events must still fit the initial
payload. Its exact wire bytes are carried because the service decoder validates
the signed canonical fields and the padded response envelope together. The
permitted DPH2 ciphertext buckets remain 4,096, 16,384 and 32,768 bytes.
An overlarge bundle fails before dispatch; no fourth bucket or alternate
carrier is introduced. XPK1/XPC1 are encrypted by the existing DPH2 initial
AEAD and are not exposed to XNode or DAO1. DAO1 continues to seal exactly one
DPH2 or DPE2, so neither its wire shape nor XNode routing changes.

The responder first prevalidates the public DPH2/DPK2 header and local
recipient scope, then opens a bounded read-only copy of the exact local DPK2
secret to derive only the initial AEAD key and open the claim transcript.
This preview does not reserve, advance or burn the durable prekey row. It
verifies XPK1/XPC1 with the exact
recipient publication, current threshold placement/network authority and
trusted time. Operation ID, receipt hash, selected prekey IDs, sender
ephemeral commitment, DPK2 hash, responder device, suite and every duplicated
DPH2 field must match. Only after that proof may the claim become a
`VerifiedDph2Initiation`; the normal bounded prekey reservation then derives
the full authenticated handshake and validates SessionInit and the optional
first event before the prekey/ratchet/inbox transaction commits.
An invalid transcript yields one coarse handshake failure, never an ACK;
reservation recovery must not make a bad claim permanently consume a prekey.
Exact replay and changed-byte fork behavior remain mandatory.

The initiator's verified XPC1 capability must retain the exact canonical XPK1
request and exact padded XPC1 wire bytes long enough to author and durably
recover the DPH2 dispatch.
These bytes remain encrypted in local storage and inside DPH2; the service
capability and claim transcript are never logged or attached to diagnostics.
No separate claim lookup protocol, mailbox side channel, compatibility parser,
or second claim authority is introduced.

An unsolicited responder also needs the initiator's permanent directory
lookup key before it can verify the sender checkpoint. DPH2 therefore adds
the exact canonical initiator DID1 as tag 20 and moves ciphertext to tag 21.
The DID1 is bound into the sender ephemeral commitment, session ID and
authenticated DPH2 header. DAO1 continues to conceal the entire DPH2 from
XNode. The three DPH2 totals become 6,001, 18,289 and 34,673 bytes; the
corresponding DAO1 totals become 6,213, 18,501 and 34,885 bytes. Previous
totals reject in this clean break.

## Consequences and activation gate

- Re-freeze DPH2 header and initial-payload vectors and the E2EE-01 verification API in
  one protocol package. Old event-only initial payloads reject; there is no
  pre-production migration or dual decoder.
- Update sender authoring, responder prekey reservation, authenticated payload
  reader, claim verification and crash/replay tests together. Positive vectors
  need malformed/truncated/oversized, claim-substitution, wrong-recipient,
  replay and fault-injection negatives.
- Compose a production responder-verifier from independently verified local
  publication and initiator directory/device closure. A raw DMD1 hash or
  caller-provided boolean is not an authority.
- Preserve existing DAO1/XNode metadata hiding and transport-neutral retry
  rules. Initial mailbox ACK requires durable semantic ContactHello state,
  not merely DPH2/TRS1 commit.
- Until the new vectors, implementation and physical two-device test pass,
  CONTACT-CODEC/initial receive remain fail-closed and no release-readiness
  claim may be made.
