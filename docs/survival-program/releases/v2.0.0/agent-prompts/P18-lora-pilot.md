# P18 — LoRa umbrella (do not issue directly)

Issue P18A protocol, P18B simulator and only then P18C hardware. This umbrella is the combined pilot acceptance reference.

## Role

You are an embedded/radio integration engineer. Work only in the repository assigned after P03/P12 contracts are stable. If ownership or hardware/regulatory profile is missing, do simulator/design only.

## Objective

Evaluate an external BLE/USB LoRa gateway for short encrypted text/control bundles. LoRa is not a smartphone transport, attachment channel or mass-delivery SLA.

## In scope

- compact fragment/reassembly protocol carrying approved opaque bundle chunks;
- authenticated fragment ordering, replay/dedup, TTL/hop and strict size limits;
- loss/reorder/duplicate/jamming simulator and airtime/duty-cycle calculator;
- region-configurable frequency/power profile with safe defaults disabled until selected;
- two-device hardware pilot after simulator gates;
- radio-observability/triangulation and battery disclosures;
- ordinary user gateway remains free/unrewarded.

## Out of scope

Calls, presence, attachments, covert frequency behavior, regulatory evasion, production reward, broad mesh claims and changing core crypto.

## Acceptance

Simulator passes approved loss/reorder budget; invalid/replayed fragments fail; hardware exchanges a small E2EE text bundle on an authorized configuration; report states airtime, range conditions, energy and regulatory dependency. Failure cannot block Survival Beta.
