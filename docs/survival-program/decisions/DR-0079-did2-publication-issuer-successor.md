# DR-0079 — private publication successor history and generation fence

Status: accepted clean-break connected target; activation gated
Date: 2026-10-03
Decision owner: Mr. X (delegated architecture authority)

Connect DR76/78 to the private Registry publication issuer. Registry MUST NOT
receive resolver-read capability or claim that it decrypted an old object.
Freeze a separate closed `VerifiedDeepIdV2PublicationIssuerPredecessor`, without
public construction, client plaintext/object capabilities, signing or dispatch
methods. Verification takes independently current DID2/network/time, exact prior
publisher request, prior XPU and both-node committed/exact-replay XPO. Own bounded
inputs before callbacks. Authenticate the historical six-record route, signed
DCR identity/support, whole publisher signature, exact XPA/body/issuance scope,
current placement and two selected-node receipts. Signed issue cannot be future;
historical expiry is not current permission. Client DR76 decryption verification
remains separately mandatory and is NOT replaced by this issuer fact.

Issuer-only successor request/threshold/response APIs use that closed fact.
Share the exact route/object/publication lineage rules with client verification:
generation+1, stable IDs/profile/services/policy/owner, old signed-bundle hash
versus old ciphertext hash, advancing expiry and current authority at every
callback/final release. They grant no generic historical-currentness switch.
Genesis APIs remain genesis-only. Forged or substituted history rejects before
reservation/custody; another nonce/body for the same generation cannot sign.

Publication coordination is V3 ONLY (request and response/media). Keep existing
fields through owner Retrieve; append `u32be length || exact prior XPO` BEFORE
the final 64-byte publisher signature. Genesis requires zero length. Nonzero
generation requires 256..16384 bytes, structurally committed/exact-replay XPO
with durable outcome. Closed verification binds these bytes to the exact prior
XPU; parsing alone is not evidence. The entire unsigned V3 envelope, including
prior XPO, is publisher-signed under the existing publication signature domain.
Response body and XPU/XPA/node receipt domains remain unchanged. Reject V2,
trailing/one-sided/bad lengths, incompatible generation or noncanonical records.
Request minimum 23306, maximum 171598; outer XCA2 maximum 171610. Preserve original
request/nonce/whole-body node signature on retry. No public Registry fallback.

Registry reads prior exact request/response from its permanent publication journal
by network, directory lookup key and exact unsigned generation-1. Require a
completed winner and ciphertext hash equal to the new request predecessor hash.
Independently authenticate that history plus the publisher-bound prior XPO before
new reservation. Persist exact generation projections and permanent unique fence
on (network16, lookup32, generation8); use unsigned big-endian bytes, not signed
SQL bigint. Serialize reservation and signing under the existing network lock,
including failed/pending signing and restart. Never free a reserved generation.
Stored projections are checked against canonical requests on read/replay.

Mandatory request_envelope_version=3 and generation_fence_version=1 provision
precedes callbacks. Explicit operator-only SQL preserves old opaque audit bytes,
responses/counts/capacity/floors; old V2 rows are not parsed, backfilled, migrated
or usable as runtime lineage. Existing conflicting current projections abort
provision. Runtime performs no DDL, reset or cleanup.

Protected route journal is version 8 ONLY, same 14 LP slots, publication request
slot 9 maximum 171598 and entry maximum 477511; unchanged 1 MiB full pending reservation.
Incompatible disposable QA state requires explicit UI reset, not a legacy reader;
registered node keys/BLS, network genesis and production floors stay unchanged.
Machine bounds, codecs, Registry/Shared/XNode consumers and native/PG/HTTP hostile
tests change together. Matched provisioning/repin and actual two-replica/device
contacts/messages/assets/groups remain activation gates. Incomplete expired
proposal/winner and service/PMT rollover are still separate bounded contracts.
