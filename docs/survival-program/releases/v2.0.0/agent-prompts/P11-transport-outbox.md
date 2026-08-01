# P11 — Managed transport umbrella (do not issue directly)

Issue P11A persistent outbox and P11B managed transport racing after P10B/P09C dependencies. Push uses P11C/P11D.

## Role

Work only in `C:\Work\DeepSession\XPointLabs\deep-client-shared`. You own `RoutedSessionTransport.cs` and outbox/coordinator files for this wave.

## Objective

Add an idempotent transport coordinator that can use ordinary HTTPS/H2, existing REALITY where supported and system proxy without duplicating bundles or continuously racing endpoints.

## Existing-contract rule

Do not replace all existing `ISessionMessageTransport`/inbox/group/attachment interfaces with one streaming abstraction. Introduce focused contracts such as opaque sender, mailbox reader, capabilities and lifecycle, then adapt existing paths.

## State model

```text
prepared -> attempted -> accepted -> durable -> delivered | expired
```

Persist transitions and attempt-local IDs. `accepted` is not `durable`; transport racing cannot create a second logical quota charge.

## In scope

- first-party H2 adapter and system HTTP/SOCKS proxy support;
- REALITY adapter behind capability/platform checks;
- cached last-success, at most two-candidate bounded race, jittered backoff and circuit breaker;
- network-change lifecycle and cancellation;
- signed bridge snapshot input from P07;
- SQLite/in-memory aligned outbox migrations and tests;
- metrics without stable user/mailbox labels.

## Out of scope

MAUI platform UI, BLE, billing, inventing domain-fronting behavior and claiming success when all IP paths are blocked.

## Acceptance

No duplicate logical delivery under simultaneous success; crash/restart resumes safely; 50/90% dead endpoint fixtures meet coordinator behavior contract; proxy path is tested; missing release configuration fails closed; legacy transport flag can roll back.

## Verification

Run `dotnet test Deep.Client.Shared.slnx`, focused persistence/service tests and migration tests. Handoff platform APIs to P12/P13.
