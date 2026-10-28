# DR-0177 — authenticated native archive index

Date: 2026-10-28. Owner: Mr. X (delegated architecture authority).
Status: accepted isolated codec allocation; runtime/schema/catalog/enrollment
adoption NOT allocated by this revision. No connected or latency qualification.

This is the P1.2 corrective direction from the
[requirements audit](../../architecture/REQUIREMENTS-AUDIT-2026-10-28.md).
The codec is private local state using existing SHA-256/SQLCipher/protected roots,
not a new public protocol, service, crypto suite or trusted remote certificate.
A source-only unused codec does not change ordinary runtime behavior.

## Detection timing and activation boundary

The completed indexed runtime will authenticate selected archive facts against
an independently protected root, verify the entire bounded working suffix and
retain actual current floor/key/registration/authority/time joins. It will detect
unselected archive corruption on access or explicit cold/full audit instead of
at every ordinary operation. This is an explicit detection-timing change from
DR-0175, not an equivalent full-page scan. No new route, replay, signing or ACK
permission follows from a root, SQL mirror, caller hash or prior successful read.

This timing change may activate only after the exact runtime/adoption contract,
all native consumers, guarded lossless enrollment and negative actual-provider
tests are complete. Until then DR-0175 remains the active ordinary verifier.
The retained three CLI profiles must not be reset or implicitly repaired.
## Exact isolated codec allocation

All integers are unsigned big-endian. Unknown versions/families, nonzero reserved
fields, overflow, noncanonical absence and trailing bytes reject before use.
Domains are the exact UTF-8 strings below, followed by one zero byte. Every hash
is SHA-256 using existing .NET crypto; no new dependency or wire generation.

Protected root, 608 bytes, slot `<floor-slot>.archive`:

| Offset | Field |
| ---: | --- |
| 0 | version 1, zero reserved 3 |
| 4 | positive revision u64 |
| 12 | scope hash 32 |
| 44 | immutable enrollment-source history checkpoint 304 |
| 348 | moving stable active basis 188 |
| 536 | archived event count u64 |
| 544 | Patricia root hash 32 |
| 576 | reducer hash 32 |

`.history` stays immutable after enrollment and must equal the embedded source.
Current floor is joined through all journal transitions from moving basis, at
most 64. Archive count excludes import/activation/latch, includes directions
1–4, and is bounded by basis ordinal minus two. An empty basis requires the
canonical empty trie/reducer. Count0 with active basis2 may already contain the
initial Hello route in family5; count0 alone does not imply an empty trie.
A positive archive count forbids an empty trie. A nonempty basis is active
stable with ordinal≥2.

Event reference, 88 bytes: `kind:u8 || direction:u8 || zero6 || ordinal:u64 ||
rowid:u64 || operation32 || metadataHash32`. Allzero is the only absent encoding.
Kind1 identifies the singleton initial-events table (direction0,ordinal1,rowid1,
operation zero, nonzero metadata hash); its zero operation is a reference tag,
NOT a statement about the initial metadata's actual claim operation. The real
initial table has `singleton INTEGER PRIMARY KEY CHECK(singleton=1)` and import
metadata is journal ordinal1. Kind2 identifies events, directions1–4, positive
ordinal/rowid≤Int64.MaxValue, nonzero operation/hash. Selected refs carry their
rowid directly; SQL index lookup is unnecessary and cannot establish absence.

Typed key: `H("Deep/STORE-V2/archive-key" || 00 || scope32 || family:u8 ||
selectorLength:u16 || selector)`. Empty hash:
`H("Deep/STORE-V2/archive-empty" || 00 || scope32)`.
Node hash: `H("Deep/STORE-V2/archive-node" || 00 || scope32 || exactNode)`.

Leaf: `version1 || kind1 || family || zero || key32 || selectorLength:u16 ||
valueLength:u16 || fullTypedSelector || value`, max320 bytes. Key is recomputed
when decoding; matching hashed key with differing typed selector rejects.
Branch104: `version1 || kind2 || zero2 || bit:u16 || zero2 || prefix32 ||
leftHash32 || rightHash32`. Bit0 is the most significant bit; bits0–255 only.
Prefix bits at/after bit are zero. Child hashes nonzero, distinct, and not the
scoped empty hash. Branch bits strictly increase; every traversed child prefix
or leaf key agrees with all parent prefix bits and the chosen edge bit. One
proof visits≤256 branches+one leaf. Authenticated prefix or leaf divergence
proves absence; missing node/hash mismatch/truncated proof never does.

| Family | Selector | Value |
| --- | --- | --- |
| 1 operation | operation32 | Ref88, any direction1–4 |
| 2 first incoming event | eventHash32 | earliest direction2 Ref88 |
| 3 ordinal | ordinal:u64 | Ref88 matching ordinal |
| 4 peer authored position | conversation32, senderSequence:u64 | firstRef88,firstEventHash32,secondDistinctRef88,secondDistinctEventHash32 (240) |
| 5 qualified historical peer route | SHA256(exact closure)32 | firstQualifiedRef88,consentOrdinal:u64,predecessorEventHash32,senderSequence:u64 (136) |
| 6 incoming attachment selector | logicalId32,authorDevice32 | firstRef88,secondRowRef88 (176) |

Family4 indexes ALL direction2 DMC kinds, scoped to peer sender by the session;
the earliest second distinct exact event is sticky. Family6 indexes ALL matching
incoming kinds; a second row is sticky even for the identical event. Nonoffer
or duplicate classification still rejects when selected. Optional witnesses
are allzero; present second ordinal is strictly later than first.
Family5 allows initial Hello or an incoming event. Its source fact verifies
consent/predecessor/sequence and existing historical qualification rules.
An allzero predecessor is valid for the initial Hello and the original incoming
ContactAccept; only full semantic source replay determines which case applies.
Initial route heads have authored sequence2, as required by the existing
SessionInit1/ContactHello2 producer. A terminal changed-send latch stays in the
working suffix; it does not become an active archive basis.

Reducer960:
`version1 || zero3 || scope32 || basis188 || initialMetadataHash32 ||
consentRef88 || ownHeadRef88 || ownPreviousRef88 || peerHeadRef88 ||
peerPreviousRef88 || firstFaultRef88 || maxPeerEpochRef88 || maxPeerEpoch:u64 ||
ownHeadSequence:u64 || peerHeadSequence:u64 || helloPolicy:u32 ||
acceptPolicy:u32 || zero56`.
Hash: `H("Deep/STORE-V2/archive-reducer" || 00 || scope32 || exact960)`.
Only current ContactPolicy bits0–1 are allocated. Reducer facts are derived by
full authenticated source replay, never caller assertions or raw SQL flags.
Outgoing native DPE2 has no DMC plaintext: reduction MUST join current journal
or existing authored application archive and verify exact event hash/scope and
independent authored counters. Selected head/previous/consent/epoch originals
remain verified on use. First route fault is sticky; postfault promotions reject;
max epoch uses authenticated incoming DPE2 and retains a selected source ref.
Cold/final full audit reproduces every leaf and reducer, not merely hashes.

## Remaining allocation before runtime integration

The bounded prefix-plan delta, mandatory independent enrollment catalog marker,
exact progress record, SQL schema/adoption crash ordering and post-callback actual
provider-read strategy require an accepted addition before runtime code. None
may infer enrollment from an optional slot or reconstruct a lost adopted root
from SQL. Existing pending Store/ACK, private keys, accounts, instances, native
originals and lifetime collision/fork evidence remain unchanged.

Every route/consent/fault/epoch/attachment consumer must use the corresponding
authenticated selector/reducer plus full bounded suffix. Outgoing classification
must join independently authenticated authored application custody; DPE2 metadata
alone lacks the DMC payload. Selected tuples use actual table cells and existing
full payload verification. No ordinary scan proportional to lifetime history.

Required isolated qualification: independent reference construction for every
family; exact membership and divergence absence; wrong scope/key/prefix/edge,
missing/changed nodes, malformed lengths/reserved fields, collision and sticky
second-witness cases. Runtime qualification additionally covers selected raw-page
freshness after callbacks, all pending/enrollment/prefix crash phases, missing
root/catalog, source/index/reducer full-audit equality, unchanged retained accounts
and 100/1000/10000-row timing. None of these claims follows from compilation.

Future public lifecycle-evidence indexing must allocate a separate purpose,
scope and independently protected root. Messaging archive facts do not authorize
publication, historical-prefix adoption, secret retirement or remote trust.
