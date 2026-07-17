# P01B — Infrastructure log/data privacy remediation

## Role/repository

Work only in `deep-devops`. Consume P01 synthetic identifiers/expectations; do not edit product runtime.

## Objective

Prevent reverse proxy, Xray, compose, metrics and evidence tooling from retaining identifiers that join ingress with mailbox/push domains.

## In scope

- data inventory and retention by component;
- proxy/Xray access-log minimization or disabling in metadata-safe profile;
- metric-label lint for Session/mailbox/push/capability patterns;
- evidence-artifact scanner using only synthetic values;
- break-glass access/deletion verification and log-key separation;
- strict metadata gate integration.

## Out of scope

Product logger changes, provider guarantees, deleting unrelated user data and hiding operational failures.

## Acceptance

Synthetic source IP/path/Session/mailbox/push values cannot be joined across archived artifacts; strict scanner fails deliberately seeded leaks; retention and residual provider visibility are documented.

