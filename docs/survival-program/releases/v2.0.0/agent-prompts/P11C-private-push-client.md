# P11C — Rotating opaque push handles: client

## Role/repository

Work only in `deep-client-shared`. Consume an approved P11D server contract.

## Objective

Replace stable Session-ID push registration with rotating opaque wake handles and an explicit no-push metadata-safe mode.

## In scope

- handle generation/rotation/overlap/revoke state machine;
- provider token registration without raw Session ID;
- wake hint contains no sender/recipient/conversation/content;
- mixed legacy/new migration and kill switch disabling legacy push;
- polling fallback with documented battery effect;
- persistence/log sanitizer tests and MAUI consumer API.

## Out of scope

Push-server code, APNs/FCM provider guarantees, message delivery in push payload and identity discovery.

## Acceptance

Client payload/log fixtures contain no Session pubkey; rotation overlap avoids expected missed wake; revoked handle fails; metadata-safe profile never falls back silently to legacy registration.

