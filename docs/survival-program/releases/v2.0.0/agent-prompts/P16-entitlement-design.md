# P16 — Private entitlement ADR (shadow track)

This prompt is design-only. Implementation is P16B after service ownership and privacy review; do not hide product runtime in DevOps.

## Role

You are the privacy/payment architect. This is a design/prototype task only in the repository explicitly assigned by governance. If service ownership is not approved, stop after the ADR—do not hide product runtime in DevOps.

## Objective

Define a managed-resource capability for long-lived quota without linking payer to Session identity and without affecting P2P/self-hosted operation.

## Required analysis

- payer/gift purchaser/redeemer/resource-gateway observer matrix;
- Free anonymous admission vs paid quota bucket;
- unlinkability vs long-lived quota/account recovery trade-off;
- issuance, redemption, double-spend, refresh, sharing, refund/revoke and device-loss flows;
- whether Privacy Pass/RFC 9576/9578 primitives fit recurring quota; no custom crypto claim;
- separation from current repeatable `recipientAlias` and migration options;
- service ownership, key hierarchy, data retention and external review plan.

## Prototype scope

Use non-production keys and an abstract capability validator at a fake managed boundary. Prove P2P tests run with the service absent. Do not change/deploy Solidity.

## Acceptance

ADR states exactly what each party can link; gift payer and redeemer can differ; expiry/downgrade preserves keys/local history/P2P; stable quota correlation is minimized and disclosed; design has an external review gate before production.

## Stop conditions

Stop if asked to deploy a contract, invent a primitive, require a raw Session ID or add billing to a common/free transport interface.
