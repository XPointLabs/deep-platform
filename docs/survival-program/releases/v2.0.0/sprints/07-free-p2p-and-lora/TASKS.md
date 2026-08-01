# Sprint 07 — free P2P, self-hosting and LoRa pilot

Duration: 2 weeks. Exit outcome: two supported phones exchange a small encrypted message without Internet or Deep infrastructure; a self-hosted profile is importable.

## P2P-01: nearby discovery and session

Implement platform-capability discovery behind adapters:

- BLE advertisements carry rotating rendezvous hints only;
- data transfer upgrades to higher-bandwidth local Wi-Fi when supported;
- authenticated Noise-style handshake binds the existing Deep identity/session keys without broadcasting a stable identity;
- encrypted bundles retain ID, expiry, replay and duplicate suppression across hops.

References: [Noise Protocol](https://noiseprotocol.org/noise.html), [Briar](https://code.briarproject.org/briar/briar), [Nearby Connections overview](https://developers.google.com/nearby/connections/overview). Avoid a hard dependency on proprietary Nearby for the open protocol.

## P2P-02: energy policy

Default background behavior does not continuously scan. Provide modes:

- normal: opportunistic OS-supported discovery windows;
- nearby emergency: explicit, time-boxed higher duty cycle with visible battery estimate;
- charger/hub: extended relay when charging and opted in.

Batch advertisements and transfers, back off empty scans, stop on thermal/low-battery conditions, and measure radio-on time. iOS limitations must be documented honestly.

## P2P-03: store-and-forward policy

Relay only bounded small bundles by default. Enforce TTL, hop budget, deduplication and per-peer storage caps locally. Forwarders cannot decrypt content and receive no XPNT reward. Add user controls for relay storage and deletion.

## NET-01: self-hosted profiles

A signed/QR-importable profile contains trust anchors, membership sources, optional bridges, storage policy and human-readable network label. Selecting it disables official discovery/billing unless the user explicitly combines profiles. Export/backup is supported.

Acceptance: a test profile with only local nodes sends/stores/receives with DNS and all Deep endpoints blocked.

## LORA-01: external adapter pilot

Integrate through a documented serial/BLE gateway protocol compatible in spirit with [Meshtastic](https://github.com/meshtastic/firmware). Use compact fragments for small text/control bundles, authenticated reassembly, TTL and strict size/duty-cycle limits. Calls, presence and normal attachments are out of scope.

Comply with local frequency, power and duty-cycle regulation; provide region configuration and prevent unsafe defaults. An ordinary user gateway is free/unrewarded. A separately enrolled public gateway may later receive operations funding under Sprint 06 rules.

## Tests

- airplane mode, two-device encrypted send/receive;
- duplicate/malicious fragment and replay rejection;
- three-hop store-and-forward with one delayed peer;
- 8/24-hour power measurement by mode;
- no billing/wallet assembly loaded in P2P tests;
- LoRa loss/reorder/fragment budget simulation before hardware acceptance.

