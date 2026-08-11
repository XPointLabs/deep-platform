# DNP1-INV — cross-repository Session dependency inventory

## Objective

Produce a machine-checkable inventory before deleting or redesigning runtime
code.

## Required classification

Every discovered item is classified exactly once:

- `retain`: Deep-native or reviewed primitive/invariant;
- `remove`: Session compatibility with no final runtime consumer;
- `redesign`: useful product capability coupled to Session identity/wire;
- `reference-only`: temporary offline vector or audit evidence.

## Required repositories

- `deep-protocol`;
- `deep-client-shared` and `deep-client-maui`;
- `xnode` and `deep-registry-api`;
- `deep-push-notification-server`;
- `deep-devops` and `deep-tests-e2e`;
- staking/contracts only where Session-named identity or projection semantics
  cross a signed/public boundary.

## Required fields

Repository, exact path/symbol, classification, current consumers, replacement
or deletion prerequisite, signed/wire/database impact, tests/evidence to port,
and final owner/work package.

## Acceptance

- production graph roots and package dependencies are included;
- identity, protobuf, envelope, padding, RPC/storage/onion, file, push, calls,
  groups, multi-device, recovery and config sync are covered;
- generated/vendor/test/docs hits are distinguished from production runtime;
- the inventory produces forbidden-reference rules without false positives on
  ordinary OS/application sessions;
- deletion order and atomic consumer cutovers are explicit;
- review reports P0=0/P1=0 before Wave 1 specification begins.

