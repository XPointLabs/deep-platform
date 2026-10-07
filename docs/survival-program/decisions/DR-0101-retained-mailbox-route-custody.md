# DR-0101 — bounded independent retained mailbox route custody

Status: accepted S01 storage/lookup contract; issuance and runtime activation gated
Date: 2026-10-07
Decision owner: Mr. X (delegated architecture authority)

The actual opaque store currently deletes a DCR predecessor's route and role
digests with its public ciphertext. That public-payload policy must not erase
the independent read path for previously admitted mailbox objects. Keep the
current-only Resolve/Deposit API unchanged; do not lengthen its deadline.

Freeze the separate private custody and typed lookup in
[CONTACT-RESOLVER §3.7.2](../../architecture/CONTACT-RESOLVER-V1.md#372-independent-retained-read-custody).
Only exact publication admission through a current closed XPA1 authorization
may create this custody. Raw opaque persistence fixtures and parsed routes
cannot create it. Publication and custody are one atomic durable state change.

Original last-possible admission is conservatively bounded by the signed
publication deadline and all six original route validity ends. Independent read
horizon adds the existing normative maximum mailbox object horizon, not a new
TTL. Neither the original XPU/XPA request window nor a short grant truncates it.
No ciphertext, owner Retrieve capability or private key is copied into the new
table. Bound entry/route-byte counts; capacity rejects admission without deleting
live custody. Retirement/GC of this table is deliberately not activated here.

Lookup accepts only DR-0100's actual closed current request/time capability and
matches exact network, locator, role-specific owner capability digest, PMT2
ArtifactRef and PMS2 artifact hash. Read current authenticated time before and
after snapshotting, reject changed durable state, cancellation, discontinuity
or exhausted horizon. Missing custody is unavailable, never empty catch-up.

The owner Retrieve capability and a PMS2 can legally be reused across successor
publications. Distinct exact route closures matching the same lookup scope are
an explicit conflict, not authority to choose the latest. Identical closures
may use the greatest independently admitted horizon. Issuance must not bypass
this ambiguity; a usable disambiguation/closure remains an S01 activation gate.

Node private opaque state becomes generation5, rejecting generation4 and missing
custody tables with quarantine; no migration, recovery-by-public-resolve or
automatic production reset. Existing file SHA/ACL/lease/durability are integrity
and ownership mechanisms, **not a cryptographic rollback floor**. Lookup facts
are not a closed grant/issuer authority and cannot be serialized as a Current
route response. Both actual current selected stores' authenticated evidence,
protected rollback/provenance closure, renewed issuer, owned holder and node
Retrieve/ACK consumers are still required. This allocates no magic, wire field,
signature domain, profile or suite and does not change current route evidence.

Qualification covers actual signed DID2/XPA publication, current signed host and
holder request; cold reopen; defensive copies; wrong locator/capability; capacity
and exact replay; before/after durable replacement failure; generation/missing
table/malformed route/horizon rejection; DCR predecessor GC independence;
clock callback mutation, cancellation, boot/rollback/expiry loss. A storage GC
clock drill is not proof of elapsed signed network-history recovery. Required
Node solution and isolated real-transport Docker smoke remain mandatory; no
physical, package, renewed issuance or whole-S01 acceptance follows from them.
