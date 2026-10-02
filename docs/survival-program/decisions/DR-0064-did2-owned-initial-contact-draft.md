# DR-0064 — owned initial contact draft before prekey consumption

Status: **accepted exact local custody contract; shipping/device gated**
Date: 2026-10-02
Decision owner: **Mr. X** (delegated architecture authority)

Complete DR-0063's preclaim size/authoring boundary with one account-owned
initial draft. No new wire record, padding bucket, cryptographic primitive,
public signer, raw-event input or legacy reader is introduced.

## Ownership and ordering

The internal account command consumes a nonzero stable intent32, an independently
current DID2 permanent-contact closure and the account-bound authority source.
UI must not choose Init/Hello, device, keys, relationships, timestamps or route.
Obtain own/peer proofs outside the lease; under the lease recheck actual account,
existing proof/network floors and exact peer closure. Require actual phase-7 own
permanent publication. Derive Init from the actual current own DMD1; Hello must
carry that publication's exact private package and the verified own rendezvous.

Before creating a rendezvous, committing a draft or dispatching XPK1, preflight
actual Init/Hello lengths against the existing worst-case XPC1 wire16,384 and
XPK1 request438. Initial unpadded size is
`8 + 438 + 16384 + 1 + 4 + InitBytes + 4 + HelloBytes`, at most32,764.
The predictive check uses exact current DMD1/package sizes, then the actual
authored records are checked again. Unsupported combinations consume no peer
prekey; no dropped route, bigger bucket or optional event fallback.

Generate fresh random relationship32, distinct logical IDs32 and handshake
nonce32 only for a new draft. Compute the conversation with the existing
normative sorted-endpoint derivation. Creation is strictly above the current
proof upper interval; expiry is bounded by one hour and the signed own XUR1
interval. Persist exact Init/Hello before they can authorize a claim dispatch.
Retry returns the exact original winner, including timestamps/nonce/route;
never regenerate expired or changed bytes. Recheck endpoint metadata, full own
publication, exact peer/DMD/DAB/contact binding, protected root, clock and
cancellation before release. This draft alone grants no claim, session,
acceptance, transport, inbox materialization or ACK.

## Protected local grammar

Mandatory `deep.store.v2.contact-start-journal`, initialized in the same
protected batch as the account instance key. Missing/foreign/old/corrupt root
requires explicit isolated QA reset, never repair or migration.

Header92: version1, reserved0, count:u16be, revision:u64be=count+1,
network16, account32, instance32. Up to128 entries, sorted by unique intent,
total encoded root at most1MiB. Each entry is `LP32(body)`:

| Body offset | Exact value |
|---:|---|
| 0 | intent32 |
| 32 | peer DID2 hash32 |
| 64 | peer account32 |
| 96 | actual peer publisher device32 |
| 128 | peer DAB2 hash32 |
| 160 | peer DMD1 hash32 |
| 192 | SHA256(exact peer DCR1 V2)32 |
| 224 | own DAB2 hash32 |
| 256 | own DMD1 hash32 |
| 288 | Init length:u32be |
| 292 | Hello length:u32be |
| 296 | exact Init then exact Hello |

Init bounds780..1830; Hello uses DR-0063 bounds6199..25351, subject to the
joined preflight. Hence supported body bounds7275..16221. Reject unknown
framing, hostile lengths/counts, zero metadata, unordered/duplicate intents,
wrong network/author/device/sequence/conversation/DMD/DAB, same logical IDs,
inconsistent creation intervals and trailing bytes before return or CAS.
Hello creation is exactly Init creation+1ms; both share the same expiry,
within one hour of Init creation. Init advertises TextCore+DeviceControl only
until the separate authenticated BLOB composition is activated.
Decoding is structural, not proof/route authority. Check actual byte capacity
before allocation/CAS, never evict a winner or silently repurpose an intent.

## Connected consequences

The connected internal completion command accepts intent, current permanent
contact and the account-bound source, never raw events, offering, signer,
service, clock or session. It first retains/reopens the exact owned draft.
Under the account lease it checks the same metadata/root and reconciles the
actual sender source. A completed winner returns the original authenticated
ciphertext/event binding before reopening preclaim secrets or dispatching any
claim, including after initial keys were transferred and retired. A missing
source follows the existing owned XPK preparation, exact retained claim
transport and independent current recipient/placement/DPK inclusion verification.
Only the source's own proof client and time can feed atomic completion. No
generic-event fallback or completed-source regeneration. Returned completion
is local custody only; existing sender import/retirement and Store are separate.
Interrupted draft/completion may resume, but an expired or substituted draft
must reject rather than allocate a new request under the old intent.

Replace the native vertical's manually composed events with this actual owner
command **before** its claim dispatch. Cover exact restart, caller mutation,
foreign peer, missing root, capacity/preflight and interrupted CAS release.
Then compose the shipping StartContact/accept/text/list commands and MAUI views
with this owner and the existing claim/commit/retire/Store/Retrieve/ACK graph.
Public API review, complete graph/consumer repins and physical Windows/USB
Android remain required. Registered node identities, genesis and floors stay.

Normative business owner: CONTACT-AND-GROUP-PROTOCOL §7–9; local custody owner:
this decision. This is not BLOB/group activation or a release readiness claim.
