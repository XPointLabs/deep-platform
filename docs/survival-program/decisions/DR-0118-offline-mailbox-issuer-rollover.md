# DR-0118 — offline mailbox issuer-key rollover

Status: accepted pre-production producer API; runtime/package activation pending
Date: 2026-10-14
Owner: Mr. X (delegated engineering authority)

[XPOINT-NETWORK](../../architecture/XPOINT-NETWORK-V1.md) owns operational
succession; exact PMA2 fields remain owned by
[CONTACT-RESOLVER §3.6](../../architecture/CONTACT-RESOLVER-V1.md#36-exact-route-and-mailbox-closure).
This adds no magic, wire version, suite, signature domain or protected-state
generation. Lost mailbox role keys do not require a new network genesis or
registered node identities, nor can unrelated seeds replace signed public keys.

Add the immutable public input `XPointNetworkMailboxIssuerRollover` with one
constructor taking `ReadOnlySpan<byte> depositIssuerPublicKey`,
`ReadOnlySpan<byte> retrieveIssuerPublicKey`, `ulong minimumGrantGeneration`.
Its three read-only properties are `ReadOnlyMemory<byte>`
`DepositIssuerPublicKey`/`RetrieveIssuerPublicKey` and `ulong
MinimumGrantGeneration`. Both keys are nonzero32-byte and distinct; the floor
is nonzero. The sole existing `XPointNetworkOperationalSuccessorRequest`
constructor appends optional `XPointNetworkMailboxIssuerRollover?
mailboxIssuerRollover = null` and exposes the same read-only property.

Only offline root-threshold `AuthorAsync` may use it. Before any signer callback,
authenticate the exact predecessor and full protected prefix as before, reject
either new key equal to either old role key or a current root/witness/node
identity signing key, and require a strictly greater minimum grant generation.
Both role keys rotate together in this closed producer input. Null preserves
existing keys/floor. `AuthorDelegatedAsync` rejects a nonnull rollover before
callbacks; no online role mutation, trust flag or fallback is authorized.
Before callbacks, the coupled offline policy producer also applies PMA2's
existing14-day wire bound. The request's broader30-day policy ceiling does not
override this record-specific limit; oversized PMA must not fail only after
other records have already been signed. No signed lifetime bound is enlarged.

Offline custody tooling uses `XPointNetworkOperationalSuccessorAuthor.
ComputeNextMailboxGrantFloor(VerifiedXPointNetworkAuthority authority,
ReadOnlySpan<byte> exactPma2)`, returning `ulong`: authenticate the exact PMA
under its original paired ancestor/window, then checked-increment its signed
minimum. This scalar is not current issuer/grant authority, prefix acceptance
or permission to publish. The actual author still checks the full protected
predecessor and rejects a mismatched floor before callbacks. No public parser,
record, trusted-time override or history-to-current conversion is exposed.

The existing signed PMA2 successor changes only tags5/6/7 additionally to its
normal successor fields. It retains the original network, mailbox-authority ID,
exact predecessor, existing grant lifetime and placement epoch. Current PMT2
binds the new PMA2 core. Old grants and revocation floors remain historical
custody; they do not become current grants under the new keys. External signer
custody, journal provisioning, retained network distribution and independent
node/client verification are separate mandatory activation steps.

Required evidence: exact signed successor/current role resolution, unchanged
original bytes/namespace/epoch, warm and cold verification, delegated append
preserving new role policy, and zero-callback rejection of stale/equal/cross-role/
identity-key/floor/delegated inputs. Actual API/package and consumer repin gates
remain required; local source tests do not activate production or devices.
