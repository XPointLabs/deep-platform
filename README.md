# XPointLabs / Deep workspace

Windows ARM64 superproject for the Deep pre-production release candidate. Child repositories are Git submodules and are committed independently.

## Start here

- Agent rules: [`AGENTS.md`](AGENTS.md)
- Target architecture and normative index:
  [`docs/architecture/README.md`](docs/architecture/README.md)
- Only active backlog: [`docs/NEXT-SPRINT.md`](docs/NEXT-SPRINT.md)
- Frozen protocol/governance inputs: [`docs/survival-program/README.md`](docs/survival-program/README.md)
- User and administrator documentation: [`xpoint-docs`](xpoint-docs)

The project has not been released to production. Current state uses clean-break semantics: no old local-state migration, Session compatibility, downgrade or release fallback is promised. Historical material is available through Git history, not the working-tree instructions.

## Repository groups

- Client: `deep-client-shared`, `deep-client-maui`.
- Protocol: `deep-protocol`.
- Network/services: `xnode`, `deep-registry-api`, `deep-push-notification-server`.
- Operations/evidence: `deep-devops`, `deep-tests-e2e`, `xpoint-node-installer`.
- Economics/UI: `xpoint-staking-contracts`, `xpoint-staking-backend`, `xpoint-staking-portal`.
- Published documentation: `xpoint-docs`.

Each child repository has its own concise `AGENTS.md` with exact ownership and verification commands.

## Development topology

The root `docker-compose.yml` is a developer-only scaffold. It is not release or UAT authority and must not be used as production evidence. The pinned TLS/UAT, chaos and release topology is owned by `deep-devops`.

Root scaffold services can be inspected with:

```powershell
docker compose config --services
```

Release-path local stack and gates are run from `deep-devops` using its documented scripts. Never replace CA/hostname/revocation validation with a permissive TLS callback.

## Common verification

Validate governance and frozen DNP1 inputs:

```powershell
powershell -NoProfile -File .\scripts\check-survival-program.ps1 -RequiredEvidenceClaim ClassificationOnly
```

Inspect all child states before a cross-repository commit:

```powershell
git submodule foreach --recursive 'git status --short'
git status --short
```

Commit changes in each child first. The final superproject commit records the exact child revisions. No push, package publication or production deployment is authorized by this repository.

## Secrets and UAT state

Private keys, certificates, signed UAT inputs and device authority live outside Git under `C:\Work\DeepSession\secrets`. Scripts may consume exact approved inputs but must not print or copy them into tracked artifacts.

UAT data may be reset through the supported provisioning path. Production package/data must never be modified by a UAT or physical test lane.
