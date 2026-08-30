# DR-0003 — Deep-native clean break from Session compatibility

Status: **Accepted**

Decision owner: **Mr. X**

Recorded: 2026-08-11

Reaffirmed and activated for the first public release: **2026-08-30**

Applies to program: `deep-survival` release `2.0.0` as a strategic successor
decision. Implementation requires a new SemVer program release and revision;
this record does not mutate the immutable `2.0.0` manifest.

## Decision

Deep will stop treating Session wire/runtime compatibility as a product
requirement and will move to one Deep-native protocol and runtime.

There are no production users and no compatibility obligation. The first
public release therefore uses the clean-break generation directly. Current
13-word Session-derived identity, DPE1/DMC1 messaging, Session identifiers and
current group-state bytes are disposable implementation evidence, not a
migration source or production contract.

The accepted release direction is:

- `DeepRecoveryV1` with exactly 24 words and role-separated recovery/account
  authority;
- independently generated per-device signing, agreement, prekey and local
  storage keys;
- an asynchronous reviewed hybrid AKE and ratchet providing forward secrecy
  and post-compromise recovery;
- a permanent transport-neutral recovery-derived Deep ID, separately expiring
  one-time invites and an encrypted contact-rendezvous protocol that does not
  require an existing contact channel;
- owner-sequenced small-group state with pairwise ratcheted fanout for v1;
  MLS remains the intended scalable group successor, not an implicit v1
  dependency;
- one new database/account/wire generation and deterministic rejection of all
  old state.

The implementation may reuse reviewed upstream libraries after license,
provenance, platform and API audits. It must not copy upstream wire identity,
server trust or product claims merely because a library is reused.

The target state is a complete pre-production clean break:

- no production Session protobuf, `Content`/`Envelope`, WebSocket-body,
  Session RPC, Session storage/onion, namespace or compatibility-fallback path;
- no live compatibility adapter, dual-read, dual-write or downgrade
  negotiation;
- no migration of pre-production accounts, databases, keys or Session IDs;
- a destructive pre-production reset to a new identity, database generation,
  magic/version and signing domains;
- the last compatible baseline may be retained temporarily only as an isolated
  reference-vector source with no production dependency or runtime entrypoint;
- legacy reference material is deleted after equivalent Deep-native vectors
  and tests are accepted.

This is target option C (full clean break), executed in bounded stages. It is
not authorization to rename the current DPE1 envelope and ship it as a final
secure-messaging protocol.

## Why the decision is justified

The active system is already predominantly Deep-native in membership,
mailbox authority/capacity, topology/selection, route continuity/history,
durable CAS/HMAC state and production ingress. Partial Session compatibility
therefore adds a second parser, identity and trust model without providing a
demonstrated end-to-end Session client/network interoperability path.

Removing that partial compatibility will:

- eliminate upstream protobuf and transitional `Content` versus `Envelope`
  parsing;
- remove Session-specific 33-byte ID prefixes, 160-byte padding rules, Pro
  proof, shared-config/group compatibility parsing and Session RPC/storage
  shapes from production;
- remove translation, fallback, version-confusion and downgrade surfaces;
- allow transport-specific Deep framing for managed HTTP, privacy routing,
  Nearby/BLE and LoRa;
- establish one canonical authority, key-role, replay/fork and versioning
  model across Protocol, Shared/MAUI, XNode, Registry and supporting services.

The decision intentionally gives up Session-client, Session-network,
Session-storage, community/config and account-ID interoperability. Deep must
operate and review its own network/privacy properties rather than inherit or
claim Session's properties.

## Preserve, remove and redesign

### Preserve

- libsodium-backed Ed25519, X25519, AEAD, KDF and hash primitives;
- canonical encoding, domain separation, bounded allocation, padding and
  metadata-minimization principles;
- replay, fork, idempotency, durable CAS, atomic inbox/outbox and protected
  state semantics;
- P04 membership and authenticated mailbox V2/MAU2 semantics, deterministic
  blinded placement, Profile Carrier, managed ingress and reviewed continuity/
  replay/CAS properties; DR-0004 replaces all pre-cutover PMA/PMT/PMS/PRA/PSS/
  route-authority bytes with the XNV-bound generation;
- Registry production-mailbox state and XNode native peer-mailbox paths;
- useful privacy-routing concepts such as independent hop keys, layered
  encryption, endpoint hiding and path diversity, subject to a new Deep-native
  threat model and wire contract.

### Remove from production

- `Deep.Protocol.Protobuf` upstream Session schemas and generated dependency;
- Session protocol codecs, Session padding, `Content`/`Envelope` transition,
  Session Pro, partial Session group/config and Session onion codecs;
- `/api/session/rpc`, the Session meaning of `/api/peer/onion`, `SessionRpc*`,
  Session storage backends and client Session storage/onion composition;
- P03A/DPE compatibility bridges after the successor envelope is ready;
- Session compatibility services, fixtures, parity gates and release evidence;
- legacy storage first; file/avatar and push only after their Deep-native
  replacements are accepted; call signaling becomes a typed ratcheted E2EE
  message, while Registry may distribute signed relay policy but is not a
  steady-state signaling inbox.

### Redesign rather than delete blindly

- account/contact/device/group identifiers and recovery material;
- DPE1/DMC1 envelope/content and client identity bindings;
- Shared/MAUI domain models and local stores that currently use Session-named
  types but also contain Deep-native mailbox, membership and outbox state;
- peer contact/origin discovery currently coupled to `/api/peer/onion`;
- attachment, push, call-signaling and group ownership bindings.

## Mandatory security work before release

The current long-term-key sealed-CEK DPE1 construction is not accepted as
evidence of forward secrecy or post-compromise security. The Deep-native
specification and implementation must provide, with independent review:

- versioned `DeepAccountId` and explicit account/device/agreement/mailbox/
  router/storage/push key roles;
- an audited asynchronous 1:1 AKE/ratchet with forward secrecy and
  post-compromise recovery;
- multi-device enrollment, authorization, revoke, recovery and backup
  separation;
- group epochs, member/admin authorization, sender-key or equivalent state and
  mandatory rekey;
- contact establishment and signed contact/conversation/config synchronization;
- attachment-key and call-signaling bindings;
- algorithm agility without implicit fallback or downgrade;
- new deterministic vectors, fuzzing, state-machine, traffic-analysis,
  load/chaos and cross-platform E2E evidence.

No new cryptographic primitive is invented merely to remove Session. Existing
reviewed primitives remain, while protocol composition requires focused and
external crypto/privacy review.

## Sprint boundary

The clean break should begin in the next sprint, but only after closing the
current *atomic and reusable* Deep-native checkpoint. It must not wait for the
entire old roadmap.

Before the new sprint, the allowed completion scope is:

1. finish, review and locally commit the already-started Registry 4B2A sealed
   historical-checkpoint lookup, because it is Deep-native and does not add a
   Session compatibility surface;
2. perform only defect fixes, verification and cleanup needed to leave the
   current repositories at reproducible local boundaries;
3. preserve Protocol F's reviewed local commit as input evidence, but do not
   package/repin it through the old dependency graph unless the clean-break
   program explicitly reuses it unchanged.

The following work is deferred into or after the clean-break sprint:

- Registry 4B2B journal/streaming endpoint implementation;
- further Session compatibility, parity, adapter or fallback work;
- a new Protocol package closure and broad consumer repin based on the old
  Session dependency graph;
- file/push removal before native replacements;
- any public release or security claim based only on renamed DPE1.

This boundary avoids discarding reviewed Deep-native work while preventing a
full additional sprint from being built on dependencies scheduled for removal.

## Next-sprint plan

The first clean-break sprint is a governance/specification and dependency-cut
sprint, not a wholesale rewrite:

1. publish a new SemVer program release and manifest superseding `2.0.0` for
   this scope;
2. freeze the last Session-compatible source/package identities as reference
   evidence and add production dependency/static gates;
3. complete a cross-repository `remove / redesign / retain` inventory;
4. freeze Deep-native identity, key hierarchy, wire/version/downgrade and
   destructive-reset ADRs;
5. introduce new package/API boundaries and MRL2 capability vocabulary without
   mutating signed MRL1 meanings;
6. land red tests for forbidden legacy production references and for the
   missing PFS, device, group, contact/config, push and attachment guarantees;
7. only then start the coordinated Protocol → Shared/MAUI → XNode/Registry →
   DevOps/E2E implementation sequence.

## Release and go/no-go gates

Implementation may proceed locally under DR-0001 after the new program release
exists. Public release remains blocked until:

- production dependency/runtime scans show zero Session legacy references;
- no live compatibility negotiation, parser, bridge or old state is accepted;
- destructive reset has been rehearsed across all clients and services;
- 1:1, groups, multi-device, recovery, push/file and privacy-routing evidence
  is complete;
- independent crypto/privacy and red-team reviews report P0=0/P1=0;
- product claims accurately describe Deep's own trust, anonymity and
  censorship-resistance evidence.

If those protocol/audit costs cannot be funded, the fallback decision is to
finish Session parity instead. An indefinite hybrid is explicitly rejected.

## Immediate consequences

- Session compatibility is frozen: no new compatibility feature should be
  added while the next program release is prepared.
- Current Deep-native work is not reverted merely because types or packages
  still have Session-derived names.
- No source deletion, account reset, package publication or consumer repin is
  authorized by this record alone.
- Existing no-push, no-production-deployment and independent-review gates
  remain unchanged.
