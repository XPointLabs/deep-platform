# Base prompt — Sprint 03: membership and bridges

Implement Sprint 03 in `C:\Work\DeepSession\XPointLabs`.

Read the program README, Sprint 01 artifacts, `xnode/AGENTS.md`, `deep-registry-api/AGENTS.md`, `deep-client-maui/AGENTS.md`, the embedded `deep.bootstrap.json`, `RealityTransportConfiguration.cs`, and current node database/path selection code.

Goal: clients trust a signed, rotating network membership rather than a permanent list of three endpoints, and disposable ingress bridges can change without exposing core/storage topology.

Repositories: [xnode](https://github.com/XPointLabs/xnode), [deep-registry-api](https://github.com/XPointLabs/deep-registry-api), [deep-client-maui](https://github.com/XPointLabs/deep-client-maui), [deep-devops](https://github.com/XPointLabs/deep-devops).

Do not weaken signature verification, silently accept unsigned discovery, or make DNS a root of trust. Deliver rollback, key-rotation and stale-checkpoint tests with the tasks below.

