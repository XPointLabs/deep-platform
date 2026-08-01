# P12 — Android power, wake and nearby emergency mode

## Role

You are the Android/MAUI platform owner. Work only in `C:\Work\DeepSession\XPointLabs\deep-client-maui`. Do not edit shared transport semantics.

## Objective

Implement and measure Android foreground/emergency nearby exchange against the pinned P03/P11 contracts, with explicit permissions and no wallet/billing dependency.

## In scope

- required Android BLE/local-network permissions and denial UX;
- rotating rendezvous advertisements containing no stable Session ID;
- foreground discovery/session and local high-bandwidth transfer upgrade where supported;
- authenticated handshake adapter approved by protocol/security owner; do not invent crypto;
- bundle dedup/TTL/hop/storage caps through shared APIs;
- normal, time-boxed emergency and opt-in charging-hub modes;
- push/adaptive polling platform lifecycle hooks;
- thermal/low-battery auto-stop and visible energy warning;
- physical-device evidence on low/mid/high Android classes.

## Out of scope

Background delivery SLA, permanent foreground service, XPNT reward for relaying, iOS, LoRa, attachments/calls and changes to shared wire format.

## Acceptance

Two supported devices with airplane mode enabled and BLE/Wi-Fi explicitly re-enabled according to the recorded OEM/OS test profile exchange a small E2EE bundle in foreground; no billing/wallet assembly is required; normal mode adds median ≤2 and P95 ≤4 battery percentage points/24h vs baseline; emergency mode auto-disables; permissions/replay/duplicate/low-power tests pass.

## Verification

Run MAUI ViewModel/smoke/UI checks from `AGENTS.md`, Android build and physical device test plan. Unit CI cannot substitute for battery evidence; report device/OS/build and raw measurements.
