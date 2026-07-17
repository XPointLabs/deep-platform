# XPNT economics for a free communication network

Status: design proposal after review. This document supersedes any interpretation in which P2P use, local relay, or self-hosting requires payment. Rewards V3 is a post-Beta shadow track, not a 16-week production migration.

## 1. Non-negotiable rules

- P2P messaging is free. There is no fee per message, byte, hop, BLE encounter, LoRa packet, or self-hosted node.
- XPNT is an infrastructure coordination and reward asset, not a ticket required to communicate.
- Users pay Deep only when they consume Deep-managed scarce resources above a sustainable free quota.
- An independent network can implement the open protocol without registering with the official reward system.
- Official node rewards must not require collection of a social graph or per-user traffic telemetry.

This separates **protocol access** from **managed service consumption**. It also makes failure of payment providers, the chain, or Deep billing non-fatal for local communication.

## 2. What is paid and what is not

| Capability | User price | Node reward eligibility |
|---|---:|---:|
| Direct Internet/LAN P2P | Free | None by default |
| BLE/Wi-Fi local store-and-forward | Free | None |
| User LoRa adapter/gateway | Free | None by default |
| User-owned alternative node network | Free from Deep | None from official pool |
| Deep managed ingress and basic mailbox | Sustainable free quota | Official infrastructure eligible |
| Extra encrypted storage/retention/uploads | Subscription or prepaid capacity | Official storage eligible |
| TURN/large attachment egress/priority managed capacity | Subscription allowance | Reimbursed/eligible under capped rules |
| Certified public LoRa gateway enrolled by operator | No end-user packet fee | Optional managed-infra program |

“No reward” does not mean “prohibited”: a community relay can be altruistic, privately funded, or compensated by its own community. It joins official rewards only by accepting official stake, measurement and availability obligations.

## 3. Preserve the existing on-chain purchase split initially

[`SubscriptionManager.sol`](../../../../xpoint-staking-contracts/contracts/SubscriptionManager.sol) currently splits purchases routed through that contract as 40% rewards, 20% permanent treasury reserve, and 40% operations escrow, with unused operations funds flowing back to rewards. Do not change this contract split before production cost data exists, but do not treat it as an automatic allocation rule for unrelated fiat SaaS revenue.

Recommended interpretation:

- **40% reward stream:** long-term security and availability of certified official core/storage nodes;
- **40% operations escrow:** current bills for object storage, bandwidth, TURN, push, probes, emergency bridges and fiat/app-store costs;
- **20% treasury/reserve:** do not count this as runway or assign spending purposes until contract/address control, permitted use, governance and timelock have been verified and documented;
- **unused operations:** returned to the reward stream as already designed.

The user should never need to acquire XPNT to buy ordinary cloud capacity. Card/app-store revenue remains in a separate fiat ledger unless a legally and economically reviewed settlement policy intentionally purchases protocol capacity. This avoids promising both a 40/20/40 distribution and a contradictory 65% fiat gross margin.

## 4. Reward pool: availability and capacity, never traffic

The current backend method [`DistributeNetworkReward`](../../../../xpoint-staking-backend/src/XPoint.Staking.Backend/EventIndexer.cs) divides an accrual equally among eligible nodes. Keep the existing [`RewardRatePool.sol`](../../../../xpoint-staking-contracts/contracts/RewardRatePool.sol) global emission cap, but calculate the distribution root once per epoch using verified service evidence.

Research allocation to simulate, not a production commitment:

| Pool | Share | Evidence |
|---|---:|---|
| Core security/availability | 60% | signed heartbeats, quorum participation, independent probes |
| Storage service | 25% | certified capacity band, random proof-of-custody challenges, replica durability |
| Resilience/scarcity | 10% | independently established ASN/provider/region/transport diversity, capped per operator |
| Quality reserve | 5% | paid after challenge window; penalties/remainder redistributed |

For epoch `e`:

```text
base_i      = eligible_i ? corePool / eligibleCoreCount : 0
storage_i   = storagePool * cappedVerifiedStorageScore_i / sum(scores)
resilience_i= resiliencePool * cappedDiversityScore_i / sum(scores)
reward_i    = base_i + storage_i + resilience_i + releasedQuality_i
```

Scores are banded and capped rather than infinitely proportional. Buying 100 times more disk or placing 100 VMs behind one operator must not yield 100 times more control or reward.

### Explicitly forbidden reward inputs

- number of user messages, contacts, groups or sessions;
- raw ingress/egress bytes attributed to a user;
- “unique users” seen by a node;
- self-reported traffic;
- message content, recipient identifiers, stable payment-to-session mappings;
- P2P or LoRa forwarding performed by ordinary client devices.

These signals are privacy-invasive and easily manufactured by Sybil traffic.

## 5. Node roles

### Core service node

Staked, registered, participates in authenticated overlay/quorum work. Receives base availability reward. Eligibility should combine registry freshness with independent reachability and protocol participation, extending the current checks in [`ServiceNodeObligationService.cs`](../../../../xpoint-staking-backend/src/XPoint.Staking.Backend/ServiceNodeObligationService.cs).

### Storage node

Advertises a signed capacity band and keeps encrypted shards assigned by deterministic rendezvous hashing. Receives storage pool share only after random challenges and durability checks. Proofs operate on opaque ciphertext and reveal no user identity.

### Disposable ingress bridge

Should be stateless or hold only short-lived buffers. Because reachability differs by carrier and region, it is funded primarily from operations escrow. A limited bonus can use multi-vantage probes, but not claimed user traffic. Blocking in one region must reduce a bonus, not slash core stake.

### Cost gateway

TURN, attachment/object gateways, push and probe operators have variable external costs. Reimburse them from operations escrow against capped, auditable aggregate invoices. Do not turn bandwidth receipts into consensus weight.

### Community/self-hosted node

Requires no registration, stake or token. It gets no official XPNT reward until its operator deliberately enrolls it and accepts measurement rules. Private networks choose their own economics.

## 6. Anti-fraud and decentralization

- Stake remains a Sybil cost, but is not proof of useful service.
- Capacity is accepted in bands only after delayed random custody challenges.
- Multiple independent probe operators sign availability observations; no single Deep server decides rewards.
- Scores are finalized by epoch with a public Merkle root, challenge window and reproducible calculation.
- Operator, ASN and hosting-provider concentration caps reduce reward amplification from cloned VMs.
- Storage failures lose the service bonus first. Slashing is reserved for unambiguous cryptographic fraud or sustained obligation breach.
- Censorship-induced regional unreachability is not automatically malicious behavior.
- All reward inputs are aggregate node facts, not user facts.

## 7. Privacy-preserving subscriptions

The current stable `recipientAlias` in `SubscriptionManager` avoids placing a raw Session ID on-chain, but repeated purchases can still create a linkable payment history. The target flow is:

```text
payment identity -> billing service -> blind/giftable entitlement token
                                      (short-lived, resource class only)
anonymous Deep client -> quota gateway -> spend/refresh capability
```

Requirements:

- billing never needs the Session private key or contact graph;
- a payer may buy a gift code for another user;
- capabilities rotate and disclose only plan/resource class and expiry;
- storage nodes see a quota capability, not card identity or wallet address;
- token refresh failure cannot disable P2P or self-hosted messaging;
- entitlement checks exist only at Deep-managed resource boundaries.

Do not deploy a contract change until this flow has a privacy review. An off-chain capability service backed by auditable settlement is safer for the first release than publishing stable storage identifiers on-chain.

## 8. Governance and calibration

The 60/25/10/5 epoch allocation is only a shadow-simulation hypothesis. Run at least 8–12 weeks of evidence and model XPNT price falls of 50% and 80% before proposing production activation. Base reward is paid only after a minimum service obligation; storage scoring also needs restore/read success, not custody alone. Ingress receives capped operations grants and no consensus weight. Any production change requires a versioned policy, public simulation, audit, notice period and replay of historical epochs. The on-chain 40/20/40 purchase split remains unchanged through the first cost-validation period.

Monthly dashboards may publish aggregate values: active certified nodes, provider concentration, proven capacity bands, reward pool outflow, cloud storage cost, TURN cost, paying conversion and free-quota cost. They must not publish per-user activity.

## 9. Acceptance criteria

1. Tests prove that P2P adapters compile and operate without importing billing, wallet or XPNT components.
2. Reward replay produces identical epoch roots from the same signed evidence.
3. Artificial self-traffic changes no node reward.
4. A storage node that fails custody challenges loses only the configured bonus unless fraud is proven.
5. A self-hosted profile can disable every official endpoint and remain functional.
6. Chain or billing outage does not affect local/P2P send and receive.

## References

- Existing Deep spec: [`xpnt-rewards-tokenomics-spec.md`](../../../xpnt-rewards-tokenomics-spec.md)
- Current emission model: [`REWARD_EMISSION_V2.md`](../../../../xpoint-staking-contracts/docs/REWARD_EMISSION_V2.md)
- [Session tokenomics](https://docs.getsession.org/tokenomics)
- [Proofs of data possession (Ateniese et al.)](https://eprint.iacr.org/2007/202)
- [IPFS provider and routing concepts](https://docs.ipfs.tech/concepts/dht/)
