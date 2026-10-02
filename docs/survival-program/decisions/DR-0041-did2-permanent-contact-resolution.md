# DR-0041 — DID2 descriptor bootstrap and permanent contact resolution

Status: accepted clean break; shipping/persistence/device gates remain
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Close the permanent-address read after DR40 publication, using the actual
opaque resolver's normative 144-byte resolve-read receipt transcript. The old
DID1 verifier's unrelated 152-byte/server-time transcript is not accepted.
XIQ/XIS neutral transport grammar and suite 0x0201 remain independently
versioned; identity/support/route must be DID2/DCB/DCR/XIR V2 only.

Bootstrap starts from compact DeepPermanentIdV2 (DID2 hash plus resolver
capability), not an already authenticated peer credential. Internally derive
the existing V2 locator/HKDF key from that exact descriptor, using the existing
domains/framing without exposing a key. Open bounded AEAD DCR with network ID
and descriptor hash as AAD, then require its exact DID2 to match both descriptor
hash and resolver-capability commitment. This produces only
ParsedDeepIdV2PermanentContactCandidate, never identity/freshness/grant/consent.
Use its bounded untrusted credential for an independent nonce-bound current
directory proof before promotion; no recursive requirement for an already
verified peer contact.

Freeze public ContactV2 APIs:
- DeepIdV2PermanentContactResolveRequestAuthor.AuthorAsync(descriptor, current
  requester authorization, verified network, authority, trusted time, ct)
  returns structural Xiq1Request. It derives locator/placement itself, uses a
  random operation, None anti-spam, generation zero and at most 120 seconds
  clipped to current authority/network/requester bounds; no caller hashes,
  raw keys, wall clock or operation/signature callback.
- DeepIdV2PermanentContactResolveVerifier.OpenCandidate(descriptor, exact
  XIQ, exact XIS) returns the parsed candidate only. Preflight exact XIQ312,
  XIS256..131072, successful non-consuming result and complete size/framing/
  request/body/route correlation before decryption/copies. Candidate keeps
  immutable owned wire/parsed objects; no public constructor/trust flag.
- VerifyAsync(candidate, current DID2 peer freshness, verified network,
  authority, trusted time, ct) returns closed
  VerifiedDeepIdV2PermanentContactResolveClosure. It derives exact current
  ResolveInvite placement, verifies both distinct selected-node receipts using
  unchanged SIGINPUT(V1/resolve-read,0x0201,requestHash||locator||generation||
  publicationExpiry||ciphertextHash||routeHash), all 144 bytes. Require current
  proof/query target, exact DCA/current active publisher, DCR support/XPS,
  reusable genesis XIR/route/lineage and full conservative trusted-time union
  at entry and release. Unsigned serverTime is not time authority. Bound
  publication generation/expiry to the signed bundle. Recheck boot/sample
  continuity and cancellation before releasing the closure.

The closed result exposes current route/authorization, parsed contact and exact
request/result evidence, not a read/private key or persisted trust bit. It is
not contact acceptance, mailbox grant, prekey claim, semantic ACK or delivery.
Local transport/peer-proof/account floor custody and shipping UI must consume
this result, not fabricate a bundle from structural bytes.

Shared's internal read orchestration authors the query from the protected
current local authorization under its account lease, uses one bounded exact
coordinator attempt, fetches the candidate's independent peer proof and rechecks
both endpoint proofs plus protected network custody under the account lease
before returning. Read does not create inventory, session or consent. It retains
no verified capability across restart and has no direct Registry resolver or
automatic fallback. Shipping activation still requires the remaining gates.
For held-account release, `DeepIdV2ContactRouteTimeWindow` also exposes the
verifier-observed immutable `BootId` and `MonotonicSample`. These are read-only
observations from the route's private original clock, not caller time authority
or an authoring input. The owner compares the last route observation against
its last protected-floor observation before release; a late clock reversal
cannot be hidden between independent floor and route checks. No wire/store
shape or compatibility surface changes.

Retire the old DID1 permanent verifier, positive fixtures and dependent
resolver/recipient pipeline in the connected clean-break batch. No adapter,
dual-reader fallback, historical positive-vector or permissive proof exists
in the release target. Until every dependent consumer is cut over, shipping
activation remains closed; local new-path evidence must not claim that the
old inactive pipeline has already been removed.

No persisted verified capability or migration: only exact bounded transcripts
may be retained and independently reverified after restart. Account/device/
node keys, registered identities and SQL2/application6 remain unchanged.
Private coordination/remote peers, actual PMA2 membership/grants, messages/
assets/groups and physical Windows/Android remain release requirements.
