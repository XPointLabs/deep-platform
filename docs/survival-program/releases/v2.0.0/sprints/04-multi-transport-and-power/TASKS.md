# Sprint 04 — adaptive transports and battery budget

Duration: 2 weeks. Exit outcome: clients recover across transport failures without continuous radio/network churn.

## TRN-01: managed transport adapters

Implement adapters behind the Sprint 01 interface:

- ordinary first-party HTTPS/2 (or HTTP/3 only after carrier evidence);
- existing REALITY/VLESS transport as optional;
- operating-system HTTP/SOCKS proxy support;
- current routed RPC compatibility during migration.

All carry identical opaque bundle bytes. TLS/REALITY credentials come from signed short-lived bridge descriptors, not a new hardcoded endpoint list.

## TRN-02: health scoring and bounded racing

Use cached last-success, exponential backoff with jitter and a small race window (for example, at most two simultaneous candidates). Avoid trying every bridge on every send.

```text
score = recentSuccess - failurePenalty - energyCost - handshakeCost
try cached winner; after deadline race one diverse fallback; persist bounded history
```

Network change invalidates only relevant failure state. Apply circuit breakers to blocked endpoints.

## PWR-01: background policy

- prefer push/wake notification containing no message content;
- adaptive polling only when push is absent/untrusted, with foreground/background/offline intervals;
- batch receipts, uploads and mailbox fetches;
- no permanent BLE scan or foreground service merely to appear online;
- expose explicit “nearby emergency mode” with time limit and visible battery cost.

## PWR-02: privacy-safe push

Push payload is a wake hint with rotating opaque handle; it contains no sender, recipient, conversation or message text. Polling fallback and self-hosted mode remain functional without FCM/APNs.

## Test matrix and gates

- carriers/Wi-Fi with DNS failure, IP block, TLS interception failure, proxy on/off and 50% dead bridges;
- no duplicated bundle despite transport race;
- cold/warm start and network switch;
- 24-hour Android/iOS idle and active-message battery tests on representative devices;
- aggregate connection-attempt and wake metrics without stable social identifiers.

Set numeric battery gates after baseline measurement in the first two days; Sprint exit requires regression thresholds in CI/device tests.

## Out of scope

BLE/Wi-Fi Direct message exchange (Sprint 07), subscription UI and traffic-based rewards.

