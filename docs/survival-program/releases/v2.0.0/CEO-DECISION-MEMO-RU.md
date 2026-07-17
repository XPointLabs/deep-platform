# CEO Decision Memo — Deep Survival Beta

Дата: 15 июля 2026 года. **Accountable owner и финальный decision maker: Mr. X.** Решение требуется до старта W0. Поля `TBD` нельзя интерпретировать как одобрение или доступный ресурс. Независимый security reviewer и специализированный legal advisor остаются внешними исполнителями; Mr. X заказывает их работу и принимает решение по результатам.

## Решение, которое предлагается утвердить

Утвердить закрытую Android-first Survival Beta сроком 16–20 недель от даты approval для доверенных групп/сообществ. Цель: короткий E2EE-текст через управляемую сеть при частичных блокировках, self-hosted профиль без Deep и foreground nearby при отсутствии IP.

Не обещать в этот срок массовую замену мессенджеров, анонимность против глобального наблюдателя, forward secrecy новой схемы, production iOS background mesh, billing, Rewards V3, calls, Teams или production LoRa.

## Требуемые решения CEO

| Decision | Recommended default | Alternative/rejected | Owner/deadline | Approval |
|---|---|---|---|---|
| 20-week scope | Closed Survival Beta | Commercial GA rejected as unrealistic | Mr. X, before W0 | Pending Mr. X |
| Beachhead | families/trusted communities/field teams | broad consumer launch deferred | Mr. X, W0 day 5 | Pending Mr. X |
| Platform | Android-first; iOS foreground spike | simultaneous background parity rejected | Mr. X, W0 | Pending Mr. X |
| Essential cloud | bounded best effort, `B_free` target €0.05 direct cost | fixed free GB rejected | Mr. X, before P09 | Pending Mr. X |
| Revenue | fiat SaaS separate from on-chain 40/20/40 | automatic fiat 40/20/40 rejected | Mr. X + external legal input, Horizon B | Pending Mr. X |
| Security claim | closed pilot until focused external review; no unresolved Critical/High | self-attestation rejected | Mr. X after independent review | Pending review |
| Russia topology | ingress only after written approval; core/storage/signing separate go/no-go | all-Russia topology rejected | Mr. X after external legal/security input | Pending review |
| Rewards | shadow 8–12 weeks; no contract activation | production V3 in Beta rejected | Mr. X, Horizon C | Deferred |

## Resource approval

The schedule is conditional on filling this table with named people and cash cost.

| Role | Required | Named/available | Gap and start date | 20-week cash cost |
|---|---:|---|---|---:|
| Program/release DRI | 1.0 FTE | Mr. X + Codex coordination | active W0 | TBD |
| Protocol/crypto lead | 1.0 FTE | Mr. X accountable + Codex agents | validate capacity W0 | TBD |
| Independent design reviewer | external | not appointed | book during W0 | TBD |
| Node/distributed systems | 2.0 FTE | Mr. X accountable + Codex agents | validate per wave | TBD |
| Shared client + Android/MAUI | 2.0 FTE | Mr. X accountable + Codex agents | physical devices required | TBD |
| iOS specialist | 0.5–1.0 FTE | Mr. X accountable; specialist/environment TBD | before W2 | TBD |
| DevOps/SRE | 1.0 FTE | Mr. X accountable + Codex agents | local Docker verification | TBD |
| QA/device/carrier lab | 1.0 FTE | Mr. X accountable + Codex agents | hardware before W2 | TBD |
| Security/privacy | 1.0 FTE | Mr. X + Codex red-team; independent review external | before Beta | TBD |
| Product/onboarding/support | 1.0 FTE | Mr. X | pilot starts W0 | TBD |
| Legal/operations | external | Mr. X accountable; specialist not appointed | preliminary memo end W0 | TBD |

Requested 20-week cash envelope: **TBD**. Current fiat runway under base/stress XPNT scenarios: **TBD**. Without these values, 16–20 weeks remains an engineering estimate, not a company commitment.

## Stop gates and dates

- End of W0: source of truth/DRI, staffing/budget, jurisdiction/data-role matrix, supported Android device matrix, approved storage/control-plane ADRs.
- Before any Russian ingress: written legal, operator-safety and seizure-risk approval.
- Before any Russian durable storage/core/signing: separate legal/security sign-off.
- Before enabling new envelope/capability path for pilot: independent focused design review of envelope/capabilities, membership/bridge hierarchy, update trust and storage receipts.
- Before public paid launch: cost validation, VAT/refunds/app-store/consumer/payment assessment and entitlement privacy review.
- Before public XPNT enrollment/Rewards V3: 8–12 weeks shadow data, operator/sanctions/crypto review and contract audit.

## Beta cohort and GTM approval

Target: 100 pilot groups and 2,000 communicating users; stretch 10,000 prepared users.

Acceptance funnel:

- ≥70% enrolled groups activate at least 3 members;
- ≥60% complete a controlled outage drill;
- ≥50% remain weekly active after 30 days;
- ≤50 support tickets per 1,000 activated users/month;
- every prepared device has update/profile recovery instructions.

Current base, acquisition channels, named funnel owner and pilot budget: **TBD before W0 exit**.

## Top risks

| Risk | Trigger/gate | Owner | Response |
|---|---|---|---|
| Bridges enumerated faster than replacement | median lifetime <3× P95 replacement distribution | Mr. X | reduce claims; invest in pre-cache/offline/self-host rather than endless bridge spend |
| Metadata path fails review | any unresolved Critical/High | Mr. X after independent review | no-go or compatibility pilot with reduced claims |
| Team/resource gap | critical role unavailable by W1/W2 | Mr. X | cut nearby/iOS/deferred tracks; do not compress review |
| Free cloud abuse/cost | direct cost > approved `B_free` | Mr. X | lower byte-days/object limits; protect essential queue; never charge P2P |
| Platform/distribution failure | Android update drill or iOS channel assumption fails | Mr. X | offline signed Android path; publish iOS residual limitation |
| Legal/operator exposure | jurisdiction sign-off fails | Mr. X after external legal input | exclude affected role/jurisdiction from topology |

## Approval requested

Approve or reject:

1. recommended scope and claims;
2. named DRI and team allocation;
3. 20-week cash envelope/runway;
4. external security/legal/device-lab spend;
5. pilot cohort and onboarding budget;
6. explicit deferred list.

Detailed execution: [Revised Program](REVISED-PROGRAM-RU.md). Atomic tasks: [Agent prompts](agent-prompts/README.md).
