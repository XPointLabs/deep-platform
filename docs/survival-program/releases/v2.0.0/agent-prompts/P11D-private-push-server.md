# P11D — Rotating opaque push handles: server

## Role/repository

Work only in `deep-push-notification-server` against the approved client/server contract.

## Objective

Store provider tokens under rotating opaque wake handles without Session pubkeys and deliver content-free wake hints.

## In scope

- versioned register/rotate/revoke/wake API;
- atomic overlap window and replay/rate limits;
- migration endpoint isolated from new storage; no stable join after migration;
- retention/deletion, logs/metrics labels and provider-error handling;
- abuse controls at handle/capability level;
- mixed-client and provider fixture tests.

## Out of scope

Contact graph, message content, billing, client code and claims that FCM/APNs cannot observe device/timing.

## Acceptance

Database/log dump has no raw Session pubkey; opaque handle rotation/revoke works; push payload is content-free; synthetic IDs never enter traces; legacy path can be disabled as Beta gate.

