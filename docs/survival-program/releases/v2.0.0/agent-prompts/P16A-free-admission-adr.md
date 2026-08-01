# P16A — Anonymous Free essential-mailbox admission

## Role/repository

Design task in the governance-approved protocol/service repository. Do not implement production issuer until ownership and review are approved.

## Objective

Prevent unlimited anonymous identity/object creation from exhausting the essential mailbox without requiring phone/email/payment or affecting P2P.

## Required design

- communicating-MAU bucket and preliminary 1,000-envelope/8 MiB logical byte-day/200-undelivered limits;
- opaque short-lived free admission capability and storage presentation;
- issuance/replay/double-spend/refresh/outage behavior;
- abuse-spike proof-of-work or alternative limiter as an adaptive emergency mechanism, not permanent surveillance;
- protected small-envelope queue, attachment-first rejection and degraded admission;
- issuer availability/failure and no stable cross-domain identifier;
- cost simulation at 2k/20k/100k users including replication/repair/failed requests/fleet allocation.

## Out of scope

Paid billing, phone verification, content inspection, P2P limits and custom cryptography.

## Acceptance

Threat/cost model covers Sybil/object flood; issuer outage has explicit bounded behavior; quota cannot be bypassed by simple replay; storage sees capability class, not payer/Session ID; external privacy/abuse review has no unresolved Critical/High before public Beta.

