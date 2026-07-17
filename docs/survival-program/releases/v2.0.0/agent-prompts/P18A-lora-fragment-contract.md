# P18A — LoRa compact fragment contract (Horizon C pilot)

## Role/repository

Work only in `deep-protocol` after opaque bundle/nearby contracts stabilize.

## Objective

Define compact authenticated fragmentation/reassembly for small text/control bundles without changing core E2EE.

## In scope

Fragment version, message-local ID, index/count, TTL/hop, authenticated transcript, maximums, replay/dedup and loss/reorder rules; golden/negative vectors and airtime input schema.

## Out of scope

Radio driver, simulator, region settings, calls/presence/attachments and production SLA.

## Acceptance

Tamper/replay/mixed-message fragments fail; bounded reassembly cannot exhaust memory; exact payload round-trip vectors unblock P18B/P18C.

