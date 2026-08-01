# Sprint 05 — private entitlements and cloud quotas

Duration: 2 weeks. Exit outcome: free and paid managed quotas can be enforced with short-lived capabilities that do not identify a Session account to billing.

## ENT-01: plan and resource catalog

Create a versioned catalog for Free/Plus/Pro/Teams with resource classes, not feature flags for privacy:

```text
storedCiphertextBytes, attachmentBytes, maxObjectTtl,
linkedBackupDevices, turnAllowance, concurrentManagedOperations
```

Never include `encryptionEnabled`, `p2pEnabled`, `anonymousIdentity`, security updates or self-host access. Catalog changes have effective dates and client-readable receipts.

## ENT-02: unlinkable issuance design

Prototype and threat-model a two-domain flow:

```text
Billing domain: payment/refund -> blind issuance or one-time gift code
Resource domain: anonymous redemption -> rotating quota capability
```

A capability discloses resource class, issuer, expiry and anti-double-spend material, but not payer, email, wallet or raw/stable Session ID. Prefer established blind-signature/Privacy Pass constructions over custom cryptography; see [RFC 9578](https://www.rfc-editor.org/rfc/rfc9578) and [Privacy Pass architecture, RFC 9576](https://www.rfc-editor.org/rfc/rfc9576).

Security review must decide online double-spend handling, backup/recovery, device sharing and refund revocation.

## ENT-03: capability enforcement

Wire validation only at official managed storage/TURN/upload boundaries. Free P2P and self-hosted test builds must not register the authorizer service. Quota counters operate on opaque bytes/TTL and rotate their correlation handle.

Expiration behavior:

- never delete identity keys or local history;
- downgrade new managed writes to Free policy after grace;
- preserve retrieve/export/delete access;
- never block P2P/local receive/send.

## ENT-04: settlement and existing contract

Add an adapter for on-chain purchase, card/app-store settlement and gift-code issuance. Keep net protocol revenue accounting compatible with `SubscriptionManager` 40% rewards / 20% reserve / 40% operations. Document refunds, taxes, platform fees and reconciliation.

Before altering `recipientAlias`, write a migration/privacy ADR. A repeatable blinded alias is better than raw Session ID but is still linkable across purchases. No production deployment is part of acceptance unless explicitly approved.

## ENT-05: tests

- billing service cannot query recipient/contact graph from an entitlement;
- gift purchaser and redeemer can be different people;
- replay/double-spend and expired capability tests;
- chain/billing outage leaves P2P and self-hosted E2E green;
- downgrade/upgrade/refund race tests;
- catalog compatibility across old/new clients.

## Out of scope

Traffic-based accounting, per-message fees, final production price commitment and novel cryptography without audit.

