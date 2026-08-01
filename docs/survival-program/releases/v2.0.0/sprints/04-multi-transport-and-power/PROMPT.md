# Base prompt — Sprint 04: multi-transport and power

Implement Sprint 04 after the bundle and signed bridge contracts exist.

Read the program README, Sprints 01/03 outputs, `deep-client-shared/AGENTS.md`, `deep-client-maui/AGENTS.md`, current `RoutedSessionTransport.cs`, `RealityTransportConfiguration.cs`, app lifecycle/background code, and push-server integration.

Goal: make network transport adaptive under blocking while imposing an explicit battery and data budget. HTTPS/H2 is a first-party transport, REALITY remains optional, and the operating-system proxy is honored where safe.

Repositories: [deep-client-shared](https://github.com/XPointLabs/deep-client-shared), [deep-client-maui](https://github.com/XPointLabs/deep-client-maui), [deep-push-notification-server](https://github.com/XPointLabs/deep-push-notification-server).

Implement the tasks, add device instrumentation, and publish measured battery/network results. Do not claim background behavior on iOS that the OS does not permit.

