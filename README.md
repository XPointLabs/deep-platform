# Deep Main Workspace

Root orchestration for local Deep development on Windows 11 ARM64.

The root `docker-compose.yml` is designed so a developer can run one project in Visual Studio and keep the rest of the stack in Docker.

## Prerequisites

- Docker Desktop with Linux containers enabled.
- Visual Studio or Rider with .NET 10 SDK if you run .NET services on the host.
- No host Node.js is required for the default Docker workflow.

## Services

Default services, started without profiles:

- `contracts-devnet`: local Hardhat JSON-RPC on `http://127.0.0.1:18545`
- `storage`: Session-compatible storage on `http://127.0.0.1:18100`
- `file`: Session-compatible file service on `http://127.0.0.1:18101`
- `push`: Session-compatible push service on `http://127.0.0.1:18102`
- `calls`: Session-style call signaling on `http://127.0.0.1:18103`

Application services, enabled through profiles or explicit service names:

- `registry`: `http://127.0.0.1:18080`
- `xnode`: `http://127.0.0.1:18081`
- `staking-backend`: `http://127.0.0.1:18082`

Optional profiles:

- `apps`: starts `registry`, `xnode`, and `staking-backend`
- `registry`, `xnode`, `staking`: start one application service
- `backend-external`: starts dedicated `storage-service`, `file-service`, and `push-service`
- `multi-node`: starts three additional XNode instances
- `e2e`: enables the test runner container

## Common Commands

Start only shared local dependencies:

```powershell
docker compose up -d --build --wait
```

Start the full backend stack in Docker:

```powershell
docker compose --profile apps up -d --build --wait
```

Run one service in Docker while another runs in Visual Studio:

```powershell
docker compose up -d --build --wait registry
docker compose up -d --build --wait staking-backend
docker compose up -d --build --wait xnode
```

Run smoke e2e against the Docker stack:

```powershell
docker compose --profile apps --profile e2e up --build --abort-on-container-exit --exit-code-from test-client test-client
```

Stop and reset local Docker state:

```powershell
docker compose down --volumes --remove-orphans
```

## Visual Studio Scenarios

When a service runs on the host, use Docker-exposed host URLs from `.env`.

If `Deep.Registry.Api` runs in Visual Studio and `staking-backend` runs in Docker, set this debug environment variable for the registry project:

```text
Registry__StakingBackendBaseUrl=http://127.0.0.1:18082
```

If `staking-backend` runs in Visual Studio and `registry` runs in Docker, point the Docker registry container back at the host process before starting it:

```powershell
$env:DEEP_REGISTRY_STAKING_BACKEND_BASE_URL_CONTAINER='http://host.docker.internal:5009'
docker compose up -d --build --wait registry
```

If `XNode` runs in Visual Studio, keep Xray mocked for local development:

```text
Vless__MockProcess=true
Vless__XrayExecutablePath=mock
Runtime__BootstrapFromStorage=false
```

The XNode app reads `Node__ApiListenUrl` from configuration. If port `8080` is busy, set for the Visual Studio profile:

```text
Node__ApiListenUrl=http://127.0.0.1:5256
```

## Secrets

The committed root `.env` contains only local devnet values and dummy addresses. Do not add real RPC provider keys, private keys, APNS/Firebase/Huawei tokens, or authorization headers to it.

Use one of these instead:

- Process environment variables in the current shell.
- A private `.env.local` file that is ignored by git.
- Your IDE user secrets/debug profile storage.
