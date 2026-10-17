# DR-0136 — committed claim across ordinary carriage renewal

Status: accepted bounded semantic correction; source/connected/device gates open
Date: 2026-10-17
Decision owner: Mr. X (delegated architecture authority)

Normative owner: [CONTACT-RESOLVER §3.4](../../architecture/CONTACT-RESOLVER-V1.md#34-atomic-pre-key-claim-xpk1--xpc1).

## Evidence and decision

The retained Android client received an Initial envelope but failed claim
promotion after ordinary operational publication. The owned two-account source
scenario reproduces `XPC1 V2 claim is outside the current selected placement`.
DR-0061 separates claim mutation expiry from delivery, but its exact-current-view
requirement still incorrectly expires an immutable allocation on every renewal.

Keep new claim authoring/issuance and initiator encryption current-only. Only
the existing committed-recipient verifier may authenticate the exact original
allocation through independently current NETCODEC retained history:

- Find the exact original view-bound PMT in verified complete history; authenticate
  its retained issuance authority and threshold signatures. Missing, foreign,
  ambiguous or omitted original history rejects.
- Require continuous unchanged network, selection epoch, replica count and node-ID
  cohort through the actual current projection. No endpoint/epoch/cohort handover
  or rotated/revoked-key fallback is allocated here.
- Recompute the original request's existing placement hash and ordered pair using
  the unchanged domain/ranking algorithm and original PMT/view. Its whole mutation
  interval must fit that original signed carriage interval.
- That ordered pair must equal the independently current claim placement for the
  same service. Verify both original request-bound signatures with the current
  admitted node identity keys. Never substitute current bytes into the saved pair.

All current recipient/initiator, DCA/DCB/XPS/XPI/DPK, protected time, revocation,
AEAD/header, durable replay and atomic prekey-consumption checks remain. Original
allocation facts do not mint a current placement, authorize a new claim, renew an
expired inventory or permit initiator encryption. Purpose/final checks remain in
the existing sealed receipt. No caller flag, scalar time or supplied key selects
this policy.

This supersedes only DR-0061's exact-current carriage equality for receiving an
already committed allocation under the unchanged current cohort. No public API,
wire bytes, suite, domain, journal/schema generation, compatibility reader, reset,
authority extension or peer replay freshness change is allocated.

Require real signed ordinary-view renewal/cold reopen, exact original bytes,
both replica signatures, unknown/missing original view, substituted placement,
wrong service, changed epoch/cohort, out-of-original-window request, current
expiry/revocation and recipient-purpose rejection by initiator use. Physical
contact/accept/text, full/package qualification and release remain separate.
