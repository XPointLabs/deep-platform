# DR-0091 — account-owned one-time contact custody

Status: accepted connected local target; shipping and installed evidence gated
Date: 2026-10-04
Decision owner: Mr. X (delegated architecture authority)

Complete B8 through the existing account-owned route/publication orchestration,
not a second journal or a raw invitation import/export API. This supersedes only
DR88's prohibition on retained one-time genesis completion and DR89/90's
reusable-only local journal restriction. No public wire, magic, suite, domain,
coordination envelope, threshold field or crypto library changes.

Add the closed artifact-specific `CompleteRetainedOneTimeGenesisAsync` and
`AuthorRetainedOneTimeGenesisAsync`. Require independently authenticated retained
issuance, exact request/route/network/directory bounds, genesis generation and
zero predecessor, current authorized device and the DCA one-time policy bit.
Retained issuance is never current authority or a one-time successor. Reusable
methods stay kind-1 only; no public kind/currentness switch is introduced.

The single protected route journal clean-breaks to version10, header92/prefix170,
fifteen LP32 records and maximum entry477756. Prefix byte33 is the closed kind
1 or2; bytes34/35 remain zero. Existing fourteen records retain their meaning.
Record14 is empty for kind1 and before kind2 phase4; from kind2 phase4 it is
exact secret DIA1 of225 bytes. Kind2 requires XIR kind2/usage1, DCB policy10,
genesis/no predecessor and exact AEAD opening matching retained plaintext,
network, bundle hash, expiry and public locator. Kind1 requires policy9 and an
empty secret slot. Unknown kinds/versions, mixed entries, changed intent axes,
hostile sizes and retired version9 reject; no migration or dual reader.

Before the first route threshold callback reserve the full bounded final entry
under the existing per-slot capacity. Before publication authoring/threshold or
replica dispatch, atomically retain and independently read back exact signed
DCR, ciphertext and DIA1. Before every resumed operation restore exact AEAD
and current proof/time; never remint key, invitation, ciphertext or request.
Adopt exact threshold and replica winners before subsequent callbacks. Cached
commit verification does not renew expired request/XPA dispatch permission.
Cancellation/read-back failure cannot export a secret or invoke the next hop.

Use typed internal one-time service entry points sharing private phase machinery
with the reusable path. Public UI/QR export remains gated until the complete
owned commit path and installed client scenario are verified. Logical intents
are bounded non-secret operation IDs, account-instance scoped by protected
custody; they cannot select keys or storage slots. No secret bytes go to Registry,
logs, test artifacts or threshold witnesses.

Verify connected crash/reopen at every phase, exact retries after response loss,
head advancement with authenticated retained issuance, malicious/mixed storage,
capacity before callbacks, cancellation, tampered AEAD and both-node commit
signatures. Update Protocol/Shared consumers and local-format tests together.
Existing local version9 account data needs an explicit pre-production reset or
exact recovery under the current format; this decision does not perform or
authorize a production reset, deploy, package publication or release.
