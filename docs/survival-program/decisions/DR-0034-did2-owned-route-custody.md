# DR-0034 — account-owned DID2 genesis route custody

Status: accepted local custody increment; live publication/grants remain gates
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Shared composes DR-0033 under the actual account file lease, protected directory/
network floors and retained device. One nonzero logical intent owns one exact
configuration, DCA1 V2, independent metadata scalar/key ID and threshold request
nonce. Do not wrap DID2 in a DID1 route/proof capability. No network publication,
retrieval capability, holder key, grant, contact consent or ACK is minted here.

Complete pending threshold-request custody and the current local journal version
are superseded by [DR-0073](DR-0073-did2-exact-route-request-custody.md).
The retained minimum never substitutes current directory authority.

Freeze the internal account-owned `EnsureOwnContactRouteAsync(intent32,
DeepIdV2ContactPathAuthoritySource, Did2ContactRouteConfiguration,
IDid2ContactRouteThresholdSource, cancellationToken)` orchestration. Configuration
owns quota (1..65535), minimum reader (1..256) and a nonzero anti-spam hash32.
The internal threshold source receives the durable request nonce, exact XRA1
and closed current DID2/network authorities. It returns bounded parsed threshold
records, never trusted route/publication authority. A live implementation must
use the separately frozen Protocol API extension
`DeepIdV2ContactRouteVerifier.VerifyAdvertisementAsync(currentAuthorization,
network, networkAuthority, exactXra1, trustedTime, cancellationToken)` before
any threshold callback, and `DeepIdV2ContactRouteVerifier.VerifyThresholdAsync(currentAuthorization,
network, networkAuthority, exactXra1, ParsedDeepIdV2RouteThreshold, trustedTime,
cancellationToken)`. It returns only `ValueTask` validation, never route
authority, signing, mutation or dispatch. Both currentness checks and all
device/threshold bindings/signatures must pass before phase2 adoption. This
requires an API snapshot/evidence review and consumer rebuild/repin, not a new
wire grammar. A live threshold source must
provide exact nonce/XRA-bound durable retry; no endpoint/wire is allocated by
this decision. Each threshold response has a hard 30-second local wait budget
and linked cancellation; a late response cannot advance custody after the owner
releases the lease. Tests using real witness keys are local authority evidence only.

Protected slot `deep.store.v2.contact-route-journal` is mandatory and atomically
initialized with the SQL account instance before current-account publication.
Missing/old/corrupt custody fails closed and needs an explicit local QA reset;
never lazily create it for an already published account. No old-reader/migration
path. Account SQL schema2 and separate application schema6 do not change shape;
the new mandatory protected root is a local custody clean break requiring reset
of pre-increment test accounts, not restoration of previous account secrets.

Journal is bounded to 128 intents. Its exact header is version:u8=1, reserved:u8=0,
count:u16be, revision:u64be, network16, account32, instance32 (92 bytes).
Revision equals 1 + sum(entry phases). Entries are sorted by unsigned intent32,
unique, each prefixed by u32be exact entry length; total at most
92 + 128*(4+36138) bytes, with no trailing bytes or unknown phases.

Each entry starts with intent32, phase:u8 (1=proposal, 2=threshold, 3=complete),
ZERO3, quota:u32be, minimumReader:u16be, antiSpamHash32, metadataScalar32,
metadataKeyId32, requestNonce32 (170 bytes), then seven u32be-length-prefixed
records: DCA1 V2 (473), XRA1 (550), PMS2, XRC1, XSS1, XIR1 V2, six-record closure.
Phase1 has only DCA/XRA; phase2 additionally has threshold records; phase3 has
all seven. PMS/XRC/XSS are bounded by their existing canonical codecs; XIR is
611; closure is 4143..23295. Scalar must derive exact XRA sealing public key,
key ID/quota/policy must match XRA, and complete records must match the retained
advertisement and threshold byte-for-byte. Parsing is never freshness authority.

Persist phase1 before any threshold callback, phase2 before completion, phase3
before returning. Each CAS is followed by independent protected readback of the
exact winner. A committed response loss resumes the winner; changing config/DCA,
expired or stale route, missing custody and capacity exhaustion reject rather
than regenerate or overwrite. Cancellation/expiry after durable adoption leaves
recoverable exact custody. Uncommitted completion candidates are never published.
All temporary secret-bearing copies are owned/disposed/zeroed.

Before each authority callback/adoption and final release, recheck actual held
lease, current account/directory/network protected floors and continuous boot/
monotonic time. Closed Protocol route verification remains independently required;
account custody or a parsed threshold alone cannot authorize dispatch. Native
physical Windows/Android and live issuer/publication evidence remain required
before activating this owner in the shipping clients.
