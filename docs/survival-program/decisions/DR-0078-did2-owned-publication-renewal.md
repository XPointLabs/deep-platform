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
