# P16B — Managed paid-entitlement service prototype (Horizon B)

## Role/repository

Work only in the product service repository approved by governance after P16 ADR/privacy review. Never place product runtime in DevOps.

## Objective

Prototype issuance/redemption/refresh of reviewed managed-resource capabilities while separating payer, redeemer and messaging identity.

## In scope

- test-key issuer/redemption endpoints from approved contract;
- gift purchaser/redeemer separation;
- resource class/expiry/double-spend/refresh and refund/revoke test behavior;
- separate billing/resource stores, keys, logs and retention;
- capability validation fixture for managed storage boundary;
- outage/downgrade preserving P2P/self-hosted/local state.

## Out of scope

Production payment processor, Solidity deployment, novel cryptography, raw Session ID and Beta critical path.

## Acceptance

Database joins cannot map payer to Session/contact graph; replay/expiry/refund races pass; service absence does not affect P2P tests; external privacy review is required before production.

