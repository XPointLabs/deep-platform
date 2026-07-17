# Deep business model and subscriptions

Status: post-review commercial hypothesis. Survival Beta does not require paid billing. Privacy guarantees are product invariants, not premium features. See [the revised program](REVISED-PROGRAM-RU.md).

## Executive decision

Deep should use a **freemium managed-cloud model around a free protocol**:

- free forever: secure identity, E2EE, P2P/local/off-grid transports, self-hosting, safety updates and a small Deep-managed mailbox;
- paid: larger durable encrypted storage, longer attachment retention, more linked-device backup, costly TURN/HD call allowance, larger uploads and organization administration;
- optional support: donations and grants for users who value the public good;
- node operators: XPNT rewards for verifiable official infrastructure, never for observing or relaying individual messages.

Advertising, sale of metadata, paid encryption, paid anonymity and per-message pricing are rejected.

## Customer promise

> Deep communication belongs to the user. Payment never buys encryption, identity, P2P/self-host access or exclusive permission to communicate. It may buy managed retention, capacity and a higher managed-service SLA; essential managed messaging remains bounded best effort.

When the official cloud is unavailable or unaffordable, direct P2P, local radio and imported self-hosted networks remain usable.

## Proposed plans after cost validation

Prices and quotas are post-Beta hypotheses. Final values require Horizon B storage, bandwidth, TURN, app-store fee, demand and support validation.

| Plan | Indicative price | Managed cloud allowance | Intended user |
|---|---:|---|---|
| Local / Self-hosted | €0 forever | No official cloud guarantee; own infrastructure | communities, advanced users, outages |
| Deep Free | €0 | essential small-envelope mailbox; experimental short-lived attachment allowance set by measured cost | every user |
| Supporter / Plus experiment | €2.99–€4.99/month or annual/prepaid | longer managed retention, attachments and multi-device recovery allowance | regular personal use |
| Pro / Teams | Deferred | Requires demand, threat model and unit-economics evidence | post-Public Release |

Use purchasing-power and app-store-localized pricing. Offer prepaid gift codes so that a subscription does not require recurring billing or a wallet. Do not promise unlimited storage or publish fixed Free gigabytes before the cost envelope is measured.

### Free quota design

The free tier must be useful for ordinary text communication but bounded by real cost:

- count opaque stored bytes and expiry, not message semantics;
- expire undelivered large attachments earlier than small envelopes;
- warn locally before deletion and allow direct/self-host export;
- use abuse-resistant anonymous rate capabilities rather than phone-number verification;
- preserve emergency receive/send of small text envelopes when an attachment quota is full;
- publish quotas plainly and never silently degrade cryptography.

## Features that must never be paywalled

- end-to-end encryption and forward-secrecy improvements;
- anonymous/pseudonymous account creation;
- direct P2P and supported BLE/Wi-Fi adapters; open LoRa adapter/protocol use is not paywalled, but supported hardware and production SLA are not promised before Horizon C;
- self-hosted network import/export;
- message verification, safety numbers, block/report controls;
- security updates, vulnerability fixes and key recovery/export controlled by the user;
- a baseline route-obfuscation/privacy mode;
- data portability and account deletion.

“Priority managed capacity” may mean higher quota and more concurrent managed operations. It must not mean that free users lose all access during censorship or emergencies.

## Unit economics

Track contribution margin by resource class, not by message content:

```text
net revenue
- payment/app-store/tax costs
- encrypted GB-month storage and replication
- attachment/TURN/bridge egress
- push/probe/monitoring cost
- support and abuse operations
- XPNT node-reward allocation
= contribution margin
```

Launch target hypotheses:

- mature fiat paid-tier gross margin after direct infrastructure and payment fees: at least 65%; this is not a property of the on-chain 40/20/40 purchase flow;
- free cloud infrastructure cost: bounded per monthly active user;
- 12-month subscriber LTV/CAC above 3 after organic launch period;
- annual plan share high enough to finance storage commitments;
- no operator/provider controls more than the configured concentration threshold.

The system needs a cost ledger for aggregate encrypted byte-days, replicated byte-days, object egress, TURN minutes/bytes and bridge/probe uptime. It must not attach these records to a long-lived Session identity when a short-lived quota capability is sufficient.

## Revenue allocation

For purchases actually settled through `SubscriptionManager`, retain the current 40/20/40 contract split described in [tokenomics and node economics](tokenomics-and-node-economics.md). Do **not** automatically mirror it onto all card and app-store SaaS revenue: that would contradict the stated 65% mature paid-tier margin. Fiat SaaS, on-chain protocol purchases, XPNT emission subsidy and direct operator reimbursements are separate ledgers. The board sets a node-support budget after taxes, refunds, platform fees and measured infrastructure costs.

Recommended revenue mix:

1. Supporter/Plus and paid self-hosted support initially; Pro/Teams only after demand and threat-model validation.
2. Prepaid capacity and gift codes: privacy-friendly access without recurring identity.
3. Donations and grants: public-good funding, never the sole operating model.
4. Enterprise/community support for self-hosted networks: deployment and support contracts; protocol remains free.
5. Optional certified gateway grants: fund strategically valuable bridges/LoRa gateways from operations escrow.

Do not rely on token price appreciation to cover recurring cloud invoices.

## Payment and identity separation

The billing system may know a payer; the messaging network must not learn that payer identity. Use a two-step issuance model:

1. Card, app store, crypto or gift-code service receives payment.
2. It issues a blind or unlinkable entitlement credential for a plan and period.
3. The client redeems/refreshes a short-lived capability at the managed quota boundary.
4. Storage nodes validate the capability without receiving the payer, wallet, email or stable Session ID.

Support cash-like gift codes and third-party purchase. Keep receipts in the billing domain, quota consumption in the resource domain, and message routing in the protocol domain. Logs have separate keys, access and retention.

## Abuse and fair use without surveillance

- anonymous issuance may use privacy-preserving rate tokens and proof-of-work only during abuse spikes;
- quotas apply to ciphertext bytes, object count, TTL and expensive concurrent operations;
- never inspect message content to decide billing;
- do not require a phone number merely to receive a free quota;
- rate-limit at disposable capability or bridge-connection level;
- publish an appeal path for paid entitlement errors without asking for chat history.

## Market references and lessons

- [Session Pro](https://docs.getsession.org/readme/advanced-features/session-pro) keeps existing privacy/security features free and charges for resource-intensive higher limits. This is the closest positioning reference.
- [Proton Drive](https://proton.me/drive/pricing) applies the same encryption promise to free and paid plans while charging for capacity and features.
- [Telegram Premium](https://telegram.org/faq_premium/) makes the base messenger free and sells larger limits, faster resource access and larger uploads. Deep should copy the clarity of limits, not Telegram's trust model.
- [Signal donations](https://support.signal.org/hc/en-us/articles/360031949872-Donor-FAQs) show a credible optional support channel, but donation-only funding is too volatile for guaranteed storage and TURN capacity.
- Session's 2026 [funding appeal](https://getsession.org/donate) is a warning that a large free user base does not automatically finance infrastructure. This supports subscriptions as the primary model and donations as supplemental.

## Validation experiments before locking prices

1. Measure P50/P95 replicated byte-days, egress and TURN cost for anonymous cohorts.
2. Run quota simulations at 100k, 1M and 10M monthly active users.
3. Offer Plus at two localized price points without changing privacy or protocol access.
4. Simulate and test 25/50/100 MB short-lived attachment cells, including abuse stress, before publishing a Free allowance.
5. Measure gift-code adoption and entitlement-support burden.
6. Publish a cost and decentralization report before changing reward or plan parameters.

## Business acceptance criteria

- A free user can communicate P2P indefinitely without a billing object.
- A paid subscription can expire without deleting identity, keys, local history or self-host access.
- A billing database breach does not expose contact graph or message routing history.
- A network observer cannot distinguish Plus from Free by the cryptographic message format.
- The free quota has a modeled sustainable cost at 10× launch scale.
- Prices are changeable by catalog/version without an app release; cryptographic guarantees are not.
