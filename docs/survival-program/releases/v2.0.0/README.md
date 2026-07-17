# Deep Resilient Network Program

Status: revised after CEO/CTO/Lead Engineer review, 2026-07-15. The original eight sprints are retained as a backlog. The authoritative execution plan is [Deep Survival Program v2](REVISED-PROGRAM-RU.md): a 16–20 week Survival Beta followed by 6–9 and 9–18 month horizons.

## Product invariant

Deep has two independent planes:

1. **Target free communication plane.** Pseudonymous cryptographic identities, E2EE, direct P2P, supported local BLE/Wi-Fi adapters and user-owned node networks require no XPNT, wallet or subscription. LoRa is a Horizon C open-adapter pilot. Metadata anonymity is a scoped, mode-specific claim and is not asserted until its gates pass.
2. **Managed cloud plane.** Deep-operated nodes, durable multi-node storage, attachment retention, backup, TURN, managed bridges and service guarantees consume real infrastructure. A sustainable free quota is available; higher quotas and guarantees are paid.

No entitlement check may exist in the protocol path required for local/P2P delivery. Paid status must not weaken or strengthen message encryption, anonymity, identity safety, or access to security updates.

```text
Encrypted message bundle
        |
        +-- direct / BLE / Wi-Fi / LoRa / own nodes --> free, no account billing
        |
        +-- Deep managed ingress --> core overlay --> replicated storage
                                            |
                                  metered resource quota
                                  (not message surveillance)
```

## Why the current three-node system is not enough

The repository is a credible launch skeleton, but it contains scaling assumptions that become failures when the network grows:

- the MAUI bootstrap embeds three REALITY endpoints and trust anchors in [`deep.bootstrap.json`](../../../../deep-client-maui/src/Deep.Client.Maui/deep.bootstrap.json);
- [`RoutedSessionTransport.cs`](../../../../deep-client-shared/src/Deep.Client.Shared/Services/RoutedSessionTransport.cs) creates a fresh `routeNonce` for storage requests, while [`RouterRuntime.cs`](../../../../xnode/src/XNode.Core/Runtime/RouterRuntime.cs) derives the storage route from request entropy. With more nodes, writes and reads can select different exits;
- storage, ingress and routing responsibilities are too tightly coupled for rapid bridge rotation;
- reward accrual in [`EventIndexer.cs`](../../../../xpoint-staking-backend/src/XPoint.Staking.Backend/EventIndexer.cs) divides rewards equally among eligible active nodes; it does not yet prove storage capacity, durability, bridge reachability, or operator diversity;
- [`SubscriptionManager.sol`](../../../../xpoint-staking-contracts/contracts/SubscriptionManager.sol) represents time-based access by a repeatable recipient alias; it does not yet express private resource quotas.

## Target architecture

| Layer | Responsibility | Economic rule |
|---|---|---|
| Message bundle | Transport-independent encrypted envelope, replay protection, expiry | Always free |
| Local/P2P transports | Direct LAN, BLE, Wi-Fi Direct/Aware, optional LoRa store-and-forward | Always free; no token code dependency |
| Self-hosted network | Imported membership profile and user-operated relays/storage | Free; operator pays own hardware |
| Managed ingress | Disposable HTTPS/H2 and optional REALITY bridges | Included in cloud quota; never paid per packet |
| Core overlay | Authenticated routing and quorum services | Official nodes receive epoch rewards |
| Managed storage | Deterministic replicated mailbox/blob shards, repair and retention | Base quota free; higher quota paid |
| Costly auxiliaries | TURN, object egress, push gateway, probes | Fair-use free; higher allowance paid |

Ingress must be replaceable and nearly stateless. Core/storage identities must not be published as the only bootstrap endpoints. The client should race a small number of transports, cache success, back off failures, use OS push/wake facilities when safe, and avoid permanent P2P radio scanning.

## Economic documents

- [Пересмотренная программа, gates, команда и зависимости](REVISED-PROGRAM-RU.md)
- [CEO decision memo](CEO-DECISION-MEMO-RU.md)
- [Журнал двух итераций ролевого ревью](REVIEW-LOG-RU.md)
- [Ограничения интернета в России и стратегия Deep](russia-restrictions-and-strategy-ru.md)
- [Tokenomics and node economics](tokenomics-and-node-economics.md)
- [Business model and subscriptions](business-model-and-subscriptions.md)
- [Исполняемые промпты для субагентов](agent-prompts/README.md)

## Original sprint backlog

> Do not give these broad sprint prompts directly to implementation agents. Use the atomic, repository-scoped prompts under `agent-prompts/` and the wave dependencies in the revised program.

| Sprint | Outcome | Depends on |
|---|---|---|
| [01 Foundations](sprints/01-foundations/TASKS.md) | Free/cloud boundary, threat model, bundle contract, test invariants | — |
| [02 Storage swarm](sprints/02-storage-swarm/TASKS.md) | Deterministic replicated storage and cloud quota boundary | 01 plus frozen membership/mailbox contracts |
| [03 Membership & bridges](sprints/03-membership-and-bridges/TASKS.md) | Signed membership, dynamic trust, disposable ingress | 01 |
| [04 Multi-transport & power](sprints/04-multi-transport-and-power/TASKS.md) | HTTPS/REALITY/proxy racing and battery budget | 01, 03 |
| [05 Private entitlements](sprints/05-private-entitlements/TASKS.md) | Privacy-preserving cloud quota capabilities and billing | 01, 02 |
| [06 Node rewards v3](sprints/06-node-rewards-v3/TASKS.md) | Verifiable epoch rewards without traffic accounting | 02, 03 |
| [07 Free P2P & LoRa](sprints/07-free-p2p-and-lora/TASKS.md) | Android nearby starts in parallel after foundations; LoRa remains a later pilot | 01; not billing/rewards |
| [08 Field & Beta gate](sprints/08-field-ga/TASKS.md) | Continuous carrier/chaos evidence and Survival Beta go/no-go | critical Beta scope only |

Each sprint has a reusable `PROMPT.md` for an implementation task and a detailed `TASKS.md`. Parallel work is allowed only where the dependency graph and repository ownership make it safe.

## Survival Beta gates

The authoritative numeric gates are in [section 6 of the revised program](REVISED-PROGRAM-RU.md#6-числовые-beta-gates). In short: zero durable-message loss in the deterministic chaos suite; cold/warm bridge recovery and offline descriptor drills; metadata-domain separation; Android foreground nearby and measured Android battery behavior; iOS foreground feasibility only; signed update rollback protection; self-host isolation from Deep/billing; no unresolved Critical/High finding in the scoped external design review. Rewards V3, production LoRa, paid subscriptions and iOS background mesh have separate Horizon B/C decisions and do not block Survival Beta.

## External references

- [Session protocol and advanced features](https://docs.getsession.org/readme/advanced-features/session-pro)
- [libp2p specifications](https://github.com/libp2p/specs)
- [Briar mailbox design](https://code.briarproject.org/briar/briar-mailbox)
- [Meshtastic firmware](https://github.com/meshtastic/firmware)
- [Noise Protocol Framework](https://noiseprotocol.org/noise.html)
- [MLS, RFC 9420](https://www.rfc-editor.org/rfc/rfc9420)
