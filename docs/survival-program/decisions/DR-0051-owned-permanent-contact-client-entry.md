# DR-0051 — account-owned permanent-contact client entry

Status: accepted clean-break contract; shipping/device evidence gated
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Expose the existing DID2 owned publication workflow as one client operation,
not a caller-selected threshold callback, key export, raw-wire publisher, node
list, Registry URL, trusted timestamp or legacy-ID adapter. Its sole configured
network source must belong to the exact calling account service. Local account
creation stays offline and one-click; network publication is a separate stage.

The account owner derives a local-only 32-byte logical intent under its actual
file lease from `SHA-256(label || 0 || network16 || account32 || instance32 ||
deploymentProfile:u16be || nameLength:u16be || normalizedNameUtf8)` where label
is `Deep/Client/DID2/permanent-contact-bootstrap/v1`. The protected account
instance is read from the existing SQLCipher generation binding, never supplied
by the UI. The name is the verified account's normalized display name, bounded
to 128 UTF-8 bytes. This is a retry locator, not a wire nonce or authority.
The existing protected route journal owns all random wire IDs, secret scalars,
exact pending requests, responses and final two-store receipts. Restart uses
the same local intent; reset changes the instance. Do not silently replace an
expired/conflicting intent or fabricate a renewal generation.

For this genesis profile the fixed route configuration is quota 1024, reader 2
and SHA-256 of `Deep/Client/ContactV2/anti-spam/bounded-unsolicited-v1` as the
existing bounded-unsolicited policy identifier. This hash is not a new proof,
anti-spam algorithm or membership grant. Other policies, profile changes,
route/inventory successors and expired-intent renewal remain explicit work.
[DR-0071](DR-0071-did2-reachability-advertisement-successor.md) authorizes the
first artifact-specific XRA1 successor candidate only; it does not allow this
operation to replace the protected genesis intent or claim current publication
before complete successor custody/threshold/two-store adoption exists.
[DR-0072](DR-0072-did2-route-renewal-lineage.md) supplies the subsequent
route-artifact successor phases. The owned operation must still adopt exact
pending/committed publication lineage before claiming renewed reachability.

The public operation derives its plan from protected state, constructs the
DR49 coordination and replica carriers internally, and invokes the existing
owned phases. Each phase checks the actual plan against its current protected
account instance under its existing held file lease before mutation or external
dispatch; no preflight-only check across an unlock is sufficient. Before
returning it rechecks the exact account-instance/name plan;
reset/profile replacement during suspension cannot release a completed result
for another account. The operation returns the existing immutable verified
durable two-replica commit, whose generation and hashes are safe status metadata,
not secrets or current message/grant/recipient permission. No new capability or
wire format is introduced just to expose the owned workflow.

Expose the existing owned permanent-contact resolve entry with only address and
the account-bound source; transport callbacks remain internal. Decryption alone
does not establish peer authority: retain independent current DID2 proof/floor
checks before releasing the existing verified closure. It is still a read-only
bootstrap, not contact acceptance, session creation or a delivery ACK.

The opt-in HTTPS physical diagnostic invokes owned contact publication only
after its existing verified two-replica initial prekey publication. Its peer
lookup uses the owned resolver and compares any diagnostic pasted public DID2
credential to the independently authenticated resolver result. The pasted bytes
cannot replace lookup/proof authority. The loopback admission-only diagnostic
remains explicitly diagnostic; neither graph is a shipping message runtime.

Narrow tests must cover stable protected plan/reopen, reset/account separation,
public-surface callback/key/time exclusion and existing durable phase/replay
behavior. Actual selected-entry ONION, live authority renewal, complete client
composition and physical Windows/Android flows remain business-batch gates.
