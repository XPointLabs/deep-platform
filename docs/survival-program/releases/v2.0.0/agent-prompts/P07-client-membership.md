# P07 — Client last-known-good membership and bridge cache

## Role

Work only in `C:\Work\DeepSession\XPointLabs\deep-client-shared`. Coordinate a later MAUI wiring task; do not edit MAUI here.

## Objective

Implement portable validation/cache/state transitions for P04/P06 signed control-plane data while preserving embedded bootstrap as a migration anchor.

## In scope

- consume the pinned P04 package/fixtures;
- validate genesis, delegation, threshold, sequence/hash, validity and protocol range;
- atomic last-known-good persistence with corruption recovery;
- bounded stale grace and explicit degraded state;
- future bridge-set pre-cache and multiple source reconciliation;
- imported self-hosted genesis/profile boundary;
- fail-closed release behavior and diagnostics without raw endpoints/IDs in logs.

## Out of scope

Signature primitive changes, bridge network fetch implementation, UI, storage membership use, billing and accepting DNS/TLS as trust.

## Acceptance

Valid forward update works; rollback/equivocation/unknown signer fail; one bad source cannot replace LKG; offline startup uses valid cached state; self-hosted profile has an independent genesis; legacy embedded bootstrap remains feature-flag rollback only.

## Verification

Run `dotnet test Deep.Client.Shared.slnx`, persistence migration tests and focused trust tests. Report public API impact for MAUI consumer.

