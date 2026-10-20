# DR-0157 — Current tombstone over independently known absent target

Status: accepted; source/connected qualification separate
Date: 2026-10-20
Owner: Mr. X (delegated authority)

The restored ciphertext obtained verified Store, but real receive/ACK found a
partial original: first replica durably tombstoned its copy; recipient never
stored that object. A current Retrieve grant and exact source-durable PTR1 must
be able to close this negative target without resurrecting an expired Store.

Only authenticated EXISTING pending Store floors may supply an absent target's
TargetKey/StoreDigest. The original floor must have MutationCompleted=false,
empty TombstoneDigest/ResponseDigest and exact original epoch/mailbox/object
retention. Complete native/protected/blob recovery proves actual target absence.
Unknown targets, lost completed history, stray blobs and conflicting floors reject.

Protocol adds PrepareAbsentTargetTombstoneAsync on the current verified host.
It resolves the current Retrieve grant and exact selected pair/descriptor keys,
verifies original PTR1 signatures/receipt/current time and binds its exact grant
and placement COMMITMENT. It never invents a blinded placement preimage. Node
still holds actual current grant/MGR/clock leases and checks native custody.
Ordinary unaided codecs still require their original placement preimage.

The protected negative floor's TombstoneDigest is
SHA256(UTF8("deep.mailbox.peer.absent-target.v1") || 0x00 ||
rawTargetKey32 || rawStoreDigest32 || rawReplayDigest32). This existing closed
field therefore distinguishes an intentional absent target from loss of a normal
native tombstone record. Preparation precedes native replay reservation; durable
negative completion precedes MRR2. No native Store/blob/mutation row is created.
Every later check proves actual target absence. This protected negative floor
permanently refuses Store preparation for the same target until normal retirement.

An already terminal native tombstone is likewise immutable and may support an
independently CURRENT new ACK operation. Its original tombstone fields/digest
are not rewritten; new replay/floor/receipt binds the new request. A pending
tombstone still requires its exact original operation. No stale grant, raw
unaided absent-target request, unknown target or Store resurrection is allowed.

A new current client ACK may cross an older terminal tombstone floor only when
the original protected ACK batch still supplies the exact old peer request,
joined to that independent floor and actual native replay digest. Completed local
mutation and a DIFFERENT new ACK operation are required. Missing/changed original
intent never becomes permission to remint. Protocol exposes pure
GetReplayRequestDigest for this denial-only exact-byte join; it returns no
verification, reservation, historical-clock or mutation authority.
Captured but never peer-admitted items in the same old batch also remain exact:
the current owner verifies its own original signature and proves actual native
replay/floor absence before new current capture. This is not a missing-intent
repair. Any pending native tombstone still refuses replacement. Structural ACK
target identity includes epoch, mailbox, placement, membership and cursor; a
repeated current target must retain its exact digest/expiry. No unrelated scope
or old neutral item is silently merged.

No wire/schema/version/key/lifetime change or compatibility reader. Coordinated
node update is required before activating negative floors; old binaries reject
this new current semantic state. Test missing-positive-row refusal separately
from intentional absence, currentness/signature failures, write crashes, cold
replay and terminal re-ACK. Preserve the actual failed receive/ACK artifact.
