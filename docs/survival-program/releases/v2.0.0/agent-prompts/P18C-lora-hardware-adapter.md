# P18C — External LoRa gateway hardware pilot

## Role/repository

Work only in the approved adapter repository after P18A/P18B and legal region profile are accepted. Requires named hardware/device lab.

## Objective

Connect an external BLE/USB radio gateway and exchange a small E2EE text bundle on two authorized devices.

## In scope

- serial/BLE framing around P18A fragments;
- explicit region/frequency/power configuration with transmit disabled until valid;
- gateway lifecycle, reconnect, queue and battery measurements;
- two-radio test, packet capture metadata disclosure and triangulation/jamming caveats;
- ordinary user gateway has no XPNT/billing dependency.

## Out of scope

Built-in phone LoRa claims, attachments/calls/presence, autonomous high-duty-cycle relay, public reward and GA.

## Acceptance

Authorized two-device text exchange matches simulator budget; invalid region cannot transmit; energy/airtime/range conditions are reported; failure does not block Survival Beta.

