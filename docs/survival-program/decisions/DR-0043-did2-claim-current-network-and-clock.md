# DR-0043 — DID2 prekey claim current-network and monotonic release binding

Status: accepted security correction; shipping/device activation remains closed
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

The permanent-contact-to-initial-message path must not promote a claim using
a current recipient proof and a separately valid but different directory/network
context. The closed XPC1 receipt verifier and every subsequent operation-time
receipt check require the SAME exact current ADH/XNA/witness policy and XNV
authority between the independently verified recipient proof and placement NET.
Nonce-bound proof freshness, protected floors, endpoint/device/inventory/member,
two selected replica signatures and the conservative union of trusted time
remain mandatory. A signed historical route anchor from DR42 supplies none of
this current claim authority.

The last verifier clock sample must share the initial protected boot and cannot
move backwards. The closed receipt retains its observed boot/sample privately;
later use cannot precede that observation even if an older sample would still
fall inside the original proof lifetime. No public clock setter, caller-key
construction, trust flag, wire version, suite or storage generation is added.

Existing unsigned server time cannot mint freshness. A locally verified result
does not prove remote inventory storage, authorize semantic ACK, accept a
contact, or establish physical delivery. Existing RuntimeActivation=false
remains unchanged until the connected shipping and device gates are complete.

Acceptance requires genuine independently verified contexts, rejection of mixed
current heads/views/authority and hidden backwards/boot-changing clock reads,
as well as unchanged positive claim/member/signature and completion checks.
Do not manufacture fresh directory authority or restore a retired DID1 path to
make the test pass. Full business/API/consumer gates run at the batch end.

The account-owned exact claim transport performs only one coordinator attempt,
with a linked 30-second dispatch bound and caller cancellation observed even
if the response adapter ignores its token. Durable request custody precedes
dispatch; timeout/cancellation never remints an operation or stores a result.
Internal explicitly synthetic verifier-output seams remain binding/time unit
tests only, not producer/native/physical evidence. Genuine connected account
and proof evidence is separately required.
