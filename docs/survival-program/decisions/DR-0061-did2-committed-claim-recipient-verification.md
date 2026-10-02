# DR-0061 — committed pre-key claim on delayed initial receipt

Status: **accepted contract; connected/device verification pending**
Date: 2026-10-02
Decision owner: **Mr. X** (delegated architecture authority)

An XPK1 request interval authorizes a new remote claim mutation, not the
delivery deadline of the already quorum-committed DPH2. Applying that interval
to first mailbox receipt incorrectly prevents delayed/offline contact delivery.
Do not renew the request, narrow trusted time, trust unsigned server time or
reuse a consumed secret to accommodate delivery.

Protocol exposes a separate closed `VerifyCommittedForRecipientAsync` factory
with the same exact typed inputs as DR-0016. It verifies both selected replica
signatures over the exact request-bound commit, inventory inclusion, service,
device, DCB and DPK binding. The signed request hash commits its issue/expiry
interval; selected replicas attest the durable claim under their request-time
admission/CAS rules. The request must not be future at the conservative current
time. Its expiry does not expire that completed allocation.

All *current* independent gates remain: exact current network/placement and
recipient/initiator directory proofs, protected boot/sample continuity, current
DCA/DCB/XPS/XPI/DPK validity over the whole conservative current interval,
revocation, last-resort limits, AEAD/header binding, durable recipient replay
and atomic prekey consumption. No historical placement or rotated/revoked
endpoint fallback is introduced. Receiving after those current artifacts
expire is still rejected; this decision does not promise arbitrary offline
retention across key or directory rotation.

The sealed result remembers its verifier-selected recipient purpose. It cannot
be consumed for initiator encryption; the existing `VerifyAsync` and initiator
final checks still require the unexpired XPK1 interval. DPH2 preview/promotion
uses only the committed-recipient factory. Recheck purpose-specific current
conditions after verification and before promotion/commit. No caller boolean,
timestamp or signing callback selects a relaxed policy.

No wire, signature tuple, codec generation, SQL generation or node identity
changes. Update public API snapshots and rebuild consumers together. Required
focused negatives include expired request accepted only for recipient commit,
future request, invalid quorum, current artifact expiry/revocation, clock
reversal, and rejection of recipient evidence in initiator use. This is not
shipping activation or physical E2E evidence.

Normative owner: [CONTACT-RESOLVER §3.4](../../architecture/CONTACT-RESOLVER-V1.md#34-atomic-pre-key-claim-xpk1--xpc1).
