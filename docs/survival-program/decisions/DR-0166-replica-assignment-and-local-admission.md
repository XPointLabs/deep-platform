# DR-0166 — replica assignment is not a remote admission lifetime

Date: 2026-10-22. Owner: Mr. X. Status: accepted pre-production internal RPC
clean break; source, connected and release qualification remain separate.

The NETCODEC contact placement's local admission upper bound includes the
independently verified ADH1 lifetime. Two independently current observers of
the same network/view/PMT assignment can have different ADH1 bounds. Requiring
those local deadlines to be byte-identical makes unrelated directory renewal
invalidate a peer request, including retained-read grant acquisition.

The private replica protocol now accepts only CRQ2/CRS2, version2, media type
`application/vnd.deep.contact-replica-v2`, at
`/api/peer/contact-replica/v2/execute`. CRQ2's fixed header is228 bytes: existing
network/view/placement/shard/epoch fields, then two ordered32-byte replica IDs,
32-byte correlation and u32 payload length. The sender's local admission
deadline is NOT serialized. CRS2 retains its76-byte response header. All
existing payload bounds, canonical decodes and authenticated exact body/
correlation/purpose bindings remain. Old magic/version/route has no reader,
alias, fallback or migration.

The decoded projection is untrusted assignment data, with admission deadline0;
it cannot supply a VerifiedPlacement or pass local EnsureUsable. Every received
assignment still matches the independently minted current request kind/service,
network, view, placement hash, shard, selection epoch and ordered replica pair.
Only that independently verified LOCAL capability may authorize work. Its
original ADH/DTT/monotonic lease, signed intervals, native/protected floors,
replica custody, currentness and request/holder expiry checks remain unchanged
before/after actual effects. No local deadline, captured loan or request is
extended. A new directory observation is not permission to accept a changed
view, assignment, epoch, peer, payload or result.

All peers must be upgraded as one pre-production cohort; pending business
commands and exact XMG/ciphertext/Store custody are retained for normal recovery.
No account, node key, mailbox assignment, journal generation, public client
wire format or cryptographic suite is replaced. Qualification requires genuine
signed local placement plus hostile assignment/version/expiry tests, supported
local deployment/smoke and original-batch recovery followed by a new three-CLI
delivery round. CLI delivery is not device, retention or release acceptance.
