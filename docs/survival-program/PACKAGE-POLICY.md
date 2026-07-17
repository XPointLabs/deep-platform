# Survival contract and artifact package policy

Owner: Mr. X. Status: approved for local-only execution.

## Package split

Cross-repository contracts are packaged by compatibility boundary, not by implementation repository:

| PackageId | Boundary |
|---|---|
| `Deep.Survival.Protocol.Bundle` | opaque envelope, compatibility metadata and version negotiation |
| `Deep.Survival.Protocol.ControlPlane` | bridge snapshots, node membership checkpoints and trust metadata |
| `Deep.Survival.Protocol.Mailbox` | deposit/retrieve capabilities, placement inputs and receipts |
| `Deep.Survival.Protocol.Nearby` | nearby handshake, fragmentation and replay contract |
| `Deep.Survival.Evidence` | work-package reports, compatibility, migration, security and handoff schemas |

Runtime implementations, secrets, environment configuration and mutable network membership must not be embedded in contract packages.

## Version rules

- Use SemVer.
- During Survival Beta packages remain `0.y.z`.
- Increment `z` for backward-compatible clarification/addition.
- Increment `y` for a breaking wire/schema/semantic change.
- Do not publish `1.0.0` until the applicable independent design review is closed and mixed-version migration evidence is accepted.
- Package version and SHA256 are both mandatory; a version alone is not an immutable identity.
- Never overwrite bytes for an existing PackageId/version/hash tuple.

## Local immutable store

Default root:

```text
C:\W\deep-survival\artifacts\packages
```

Layout:

```text
<PackageId>\<SemVer>\<sha256>\<artifact files>
```

Each directory includes `manifest.json`, the artifact, its `.sha256` file, producer repository/result SHA, program revision, compatibility range and creation timestamp. Consumers copy or restore only a hash pinned by the dependency manifest.

An alternate root requires `DEEP_SURVIVAL_PACKAGE_ROOT` and must still be outside repository build-output directories. External NuGet, npm, container-registry or GitHub artifact publication requires separate explicit authority from Mr. X.

## Acceptance and rollback

A package is consumable only when:

1. producer tests and compatibility fixtures pass;
2. the exact artifact SHA256 is recorded;
3. migration and mixed-version behavior are documented;
4. the previous accepted artifact remains available for rollback;
5. the dependency manifest pins producer repository SHA, PackageId, SemVer and SHA256;
6. no secret-bearing file is included.

P00B implements fail-closed schema validation and exact-SHA checkout in `deep-devops`.
