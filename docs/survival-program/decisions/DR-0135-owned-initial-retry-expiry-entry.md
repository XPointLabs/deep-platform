# DR-0135 — owned Initial retry expiry at the business entry

Status: accepted bounded business/API clarification; qualification gated
Date: 2026-10-17
Decision owner: Mr. X (delegated architecture authority)

Semantic owner: [CONTACT-AND-GROUP §7](../../architecture/CONTACT-AND-GROUP-PROTOCOL-V1.md).
Reuse DR-0064's actual Initial expiry/stop owner, not a historical-currentness
switch or renewal of an old Hello. The current StartContact entry can fail its
old-draft/current-contact equality before reaching the already implemented
owned expiry transition. A generic protected-state error is not its lifecycle.

First authenticate and return an actual retained durable Store, if present.
For an existing unresolved draft, inspect its exact protected root under the
account lease and independently current own proof/time before peer resolution.
Only lower time at/after the ceiling second of original event expiry permits
the existing RetryExpired stop. Upper overlap is not expiry. Keep the existing
native/pre-session discrimination, imported-source checks, staged key retirement,
audit/dependency rules and cold recovery; this decision changes none of them.
Missing/corrupt custody rejects, never means absent work. A non-expired draft
continues through every existing exact metadata, endpoint, claim and time check.

Add the informative Shared exception `DeepIdV2ContactRetryExpiredException`.
It has no request, time, identifier, proof or authority payload. Emit it only
after the real expiry stop and its actual read-back/cleanup have succeeded.
An already expired stopped attempt can finish the same owned recovery; a prior
user cancellation is not relabelled as expiry. Failed/unknown stop keeps the UI
retry choice. Existing successful Store replay wins over this expiry path.

MAUI may clear only its in-memory retry choice for that exact intent on this
typed result and explain expiry plus possible previous remote receipt. It must
not allocate another intent or dispatch in the same command. A separate explicit
Add rereads the protected operation list, selects any still-active original,
and otherwise creates independent user work through normal current admission.
The exception is not authority: a false UI hint cannot bypass that owner lookup
or the old intent's permanent fences. It proves neither noncommit nor recall.
Original possible-forwarding and replay facts remain with their existing owners;
no account reset, old-byte replacement or unconditional cleanup is introduced.

No wire, primitive, Protocol API, journal/schema generation, route, grant or
padding allocation changes. Require real SQLCipher/PQ draft/unknown-claim and
native-import cases, lower/upper boundaries, exact stopped reason, unavailable
peer without callback, cancellation/fault/cold reopen, historical durable Store
precedence and explicit-next-command UI tests. Matched Windows/Android business,
source/package and full qualification remain required; no release authorization.
