# P01 — Current metadata inventory and red tests

## Role

You are a privacy/security engineer. Work only in `C:\Work\DeepSession\XPointLabs\deep-client-shared`. The push-server follow-up is a separate repository task.

## Objective

Turn current sender/recipient/storage correlation leaks into explicit failing or characterization tests and produce an observer/collusion matrix. Do not design novel cryptography in this package.

## Inspect first

- `AGENTS.md`, `docs/ARCHITECTURE.md`, `docs/SESSION_PORTING.md`
- `Services/E2eeEnvelopeCodec.cs`
- `Services/RoutedSessionTransport.cs`
- `Services/PushSubscriptionTransport.cs`
- existing envelope/transport/log sanitizer tests

## In scope

- byte-level characterization of DPE1 clear fields and outer storage RPC fields;
- data-flow inventory: client, ingress, route hops, storage exit, push, crash/logging;
- observer matrix for each transport mode and collusion pairs;
- tests/fixtures that detect raw sender-recipient pairs, raw Session IDs and stable cross-transport correlation IDs in managed payloads/log fixtures;
- `metadata-expectations.v1.json` with finding ID, observer/domain, status and evidence; characterization tests remain green, while a separate strict command with `DEEP_SURVIVAL_METADATA_GATE=1` fails on every unresolved Beta-blocking finding;
- define red gates for opaque deposit/retrieve capabilities and rotating push handles;
- document residual timing/size/IP/radio leaks separately from content secrecy.

## Out of scope

Changing production envelope semantics, claiming sealed sender is implemented, editing push-server, billing, UI or network topology.

## Acceptance

- characterization tests pass against current behavior and clearly mark privacy gaps; no skipped xUnit test is treated as a release gate; the explicit strict command fails until blocking findings have resolved evidence;
- matrix answers what ingress+storage, storage+push and a global passive observer can infer;
- no test logs real keys/IDs;
- output specifies required producer contract for P03, without prescribing an unaudited primitive.

## Verification

Run `dotnet test Deep.Client.Shared.slnx` and focused service tests. Include result counts and paths to fixtures/report.

## Stop conditions

Stop if a proposed test requires changing wire behavior, another repository or production logging defaults.
