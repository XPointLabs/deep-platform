# Deep Survival Program — пересмотренная программа

Версия: 2.0, 15 июля 2026 года. Основание: два прохода ролевого ревью CEO, CTO и ведущего разработчика. Этот документ является главным программным решением внутри `resilient-network-program`; старые sprint-файлы сохраняются как backlog, но не должны передаваться исполнителям без атомарного prompt из `agent-prompts/`.

**Accountable owner всех внутренних человеческих ролей и решений: Mr. X.** Codex и субагенты выполняют инженерные work packages локально. Исключения: независимый внешний crypto/security reviewer и специализированное юридическое заключение должны оставаться внешними по отношению к автору/реализатору; Mr. X является их заказчиком и владельцем решения по результатам.

## 1. Исправленный продуктовый фокус

Четырёхмесячный результат — не «замена всем мессенджерам» и не коммерческий GA.

> **Survival Beta:** Android-first мессенджер для доверенных групп и сообществ, который доставляет короткие E2EE-сообщения через управляемую сеть при частичных блокировках, через self-hosted профиль без Deep и локально между устройствами при отсутствии IP.

Что одинаково во всех режимах: шифрование содержимого, ключи пользователя, бесплатный доступ к P2P/self-hosted, обновления безопасности. Что различается: защита сетевых метаданных, доступность и SLA.

| Режим | Обещание | Остаточный риск |
|---|---|---|
| Private routed | Инфраструктура не должна видеть одновременно сетевой источник, отправителя и адресата | timing/volume correlation, collusion слоёв, глобальный наблюдатель |
| Direct IP | Бесплатная прямая доставка | peer и сеть могут видеть IP/время |
| Nearby/off-grid | Нет зависимости от IP; E2EE остаётся | радио можно наблюдать и локализовать |
| Self-hosted | Бесплатная связь через выбранную сеть | метаданные и доступность зависят от её операторов |

До прохождения metadata gates нельзя безусловно называть Deep «анонимным». Корректное обещание: содержимое скрыто от инфраструктуры, а каждый режим явно показывает границы защиты метаданных.

## 2. Три горизонта

### Horizon A — Survival Beta, недели 0–20 от утверждения программы

В критическом пути:

- observer/collusion matrix и failing metadata tests текущего DPE1/storage/push;
- ключевая и update trust hierarchy, rollback/freeze protection;
- public bridge control plane отдельно от node-only membership;
- opaque rotating deposit/retrieve mailbox capabilities;
- исправление различия onion hops и storage replicas;
- small-message mailbox `N=3/W=2/R=2`, repair и mixed-version rollback;
- stateless ingress, HTTPS/H2, REALITY как option, system proxy, bounded racing;
- persistent outbox и единая семантика `accepted/durable/delivered`;
- self-hosted network profiles;
- Android foreground/emergency nearby; Android background — best effort по измерениям;
- iOS foreground technical spike без обещания background mesh;
- подписанные воспроизводимые Android-сборки и offline verification;
- carrier/device/chaos lab с первой недели;
- onboarding pilot communities и outage drills.

Не блокируют Beta: production billing, новый reward contract, Teams, 100 GB Pro, calls, production LoRa, iOS background mesh, массовое public-node enrollment.

### Horizon B — Public Resilient Release, месяцы 5–9 от утверждения программы

- внешний crypto/security review и remediation;
- bundle/key lifecycle v2 с forward secrecy/post-compromise recovery согласно отдельному ADR;
- production P2P на поддержанных платформах с честными SLA;
- приватные cloud entitlement после design review;
- измеренная unit economics и ограниченный Plus/supporter launch;
- blob/attachment storage отдельно от essential mailbox;
- production SRE, support, staged rollout, distribution diversity.

### Horizon C — Decentralized Network, месяцы 9–18 от утверждения программы

- Rewards V3 после 8–12 недель shadow evidence;
- публичная программа community nodes;
- contract migration после аудита/управленческого решения;
- LoRa gateway ecosystem после simulator/hardware pilot;
- коммерческая поддержка self-hosted; Teams только после отдельного threat/product model.

## 3. P0-исправления к исходному плану

### 3.1 Metadata privacy раньше транспорта

Сейчас `E2eeEnvelopeCodec.cs`, `RoutedSessionTransport.cs` и push subscription раскрывают стабильные Session-идентификаторы соответствующим managed-компонентам. Первым техническим шагом становятся red tests и data-flow inventory, затем:

- sender authentication внутри recipient-encrypted header;
- contact-scoped rotating deposit capability;
- отдельная retrieve capability;
- placement key, не равный raw Session ID;
- hop-local correlation IDs вместо стабильного cross-transport `bundleId`;
- padding buckets и документированные timing/size leaks;
- rotating opaque push wake handles;
- version negotiation и downgrade resistance.

Новая криптографическая схема не становится production default без review. До закрытой Survival Beta проводится независимый focused design review envelope/capabilities, membership/bridge hierarchy, update trust и storage receipt semantics. Закрытый pilot не делает заявлений об анонимности, forward secrecy или production-security до устранения Critical/High findings; принятые Medium имеют владельца, срок и явное ограничение claims.

### 3.2 Forward secrecy — отдельная программа, не фраза в тарифе

Текущий long-term-key sealed-box подход не доказывает forward secrecy. До Public Release нужен ADR с upstream-compatible ratchet/Session semantics, multi-device lifecycle, revoke, recovery/backup separation и group rekey. Нельзя импровизировать Double Ratchet/MLS внутри транспортного спринта.

### 3.3 Два control plane

- **Public bridge snapshot:** короткоживущие ingress descriptors, которые можно предварительно кэшировать, передавать в E2EE-сессии, QR/файлом и получать из нескольких независимых источников.
- **Node-only membership:** core/storage endpoints доступны только участникам overlay; клиент получает необходимые commitments/proofs, но не полную топологию.

Recommended Beta trust policy: embedded `networkId/genesisHash`; 3-of-5 offline roots delegate a time-bounded 2-of-3 online signer set; every snapshot needs 2 online signatures plus a publishable fork-witness record. Policy changes require an approved ADR. Monotonic sequence/previous hash, transparency, last-known-good, stale grace and emergency rotation are mandatory. Keys for updates, membership, bridge, billing and rewards are separated.

### 3.4 Репликация не равна трём onion-hop

Текущие три узла route — privacy path, а хранит последний exit. До реализации выбирается и фиксируется ADR о replication coordinator. Для Beta рекомендуется: core/storage coordinator подтверждает запись только после двух независимых storage receipts; replica nodes не совпадают по смыслу с route hops.

Mailbox адресация:

```text
contact handshake -> rotating deposit capability + opaque placement key
recipient device  -> separate retrieve capability
placement         -> rendezvous(placementKey, storageMembershipEpoch)
durability        -> N=3, W=2, R=2; append-only union + repair
```

Sender не получает master recipient secret. Logical quota списывается один раз; replication cost учитывается отдельно. Нужны E/E+1 overlap, dual-read, tombstone dominance, idempotent receipts и rollback на legacy path.

### 3.5 Обновления — часть сетевой устойчивости

В Wave 0 внедряется TUF-подобная модель ролей root/targets/snapshot/timestamp, threshold/offline keys, anti-rollback/freeze, SBOM, reproducible artifact comparison и compromised-CI drill. Android APK можно передавать offline только при том же package signer. Ограничения iOS distribution фиксируются как residual risk, а не обходятся обещанием.

## 4. Исправленная экономика

### Бесплатно

- весь P2P/local/off-grid/self-hosted plane;
- E2EE, ключи, security updates;
- essential managed mailbox как ограниченный best-effort public service;
- на Beta — короткие envelopes, а не бесплатный cloud drive.

### Платно после Horizon A

- longer managed retention;
- attachments/blob quota;
- multi-device recovery/backup;
- increased TURN/managed capacity;
- prepaid/gift/community-sponsored capacity.

Начальные 500 MB Free, 20/100 GB и Teams удалены из обязательств. До измерений используются конфигурационные эксперименты: 25–100 MB attachment allowance с коротким TTL, но продукт не обещает конкретный объём до cost envelope.

### Разделение денежных потоков

Схема `40/20/40` применяется только к покупкам, которые действительно проходят через `SubscriptionManager` и для которых это контрактное правило. Она не зеркалируется автоматически на всю card/App Store SaaS-выручку.

Fiat waterfall:

```text
gross receipt
- VAT/sales tax/refunds/app-store/payment fees
= net SaaS revenue
- measured managed infrastructure budget
- customer support/security/operations
- board-approved node support allocation
= contribution margin
```

XPNT emission subsidy, on-chain protocol purchases, fiat SaaS и direct operator reimbursements ведутся раздельно. Runway считается в фиатных обязательствах при сценариях падения XPNT на 50% и 80%. Gross margin 65% — цель зрелого paid tier, не свойство 40/20/40 потока.

Rewards V3 остаётся shadow research: без traffic inputs, минимум 8–12 недель наблюдений, минимум три административно независимых probe domain, restore/read tests вместе с custody, operator/effective-stake caps. Ingress оплачивается capped ops grants и не получает consensus weight.

## 5. Essential Messaging Policy для Beta

- service: small encrypted envelopes, не история и не backup;
- communicating Free MAU: capability bucket, в котором за 30 дней был хотя бы один успешный deposit или retrieve;
- лимиты: opaque bytes, object count, TTL и anonymous admission capability;
- preliminary envelope ceiling: 64 KiB после padding; TTL до 14 дней, параметры remote-configurable;
- initial admission simulation: не более 1,000 envelopes или 8 MiB logical byte-days за 30 дней; не более 200 одновременно недоставленных объектов; final values утверждаются до P09;
- при overload резервируется отдельная очередь для small envelopes; attachments отклоняются раньше;
- quota exhaustion не блокирует retrieve/delete/export и локальный/P2P plane;
- paid и free используют один crypto format; различаются retention/capacity/SLA;
- сервис best effort, но admission не дискриминирует по содержимому или контактам;
- hard target direct cost для design simulation: не более €0.05 на communicating Free MAU в месяц, включая storage replication/repair, bridge/core bandwidth, probes и push, но без customer support; fixed fleet cost показывается отдельно при 2k/20k/100k users. CEO утверждает/меняет `B_free` до storage implementation.

## 6. Числовые Beta gates

Значения являются стартовыми engineering gates и меняются только decision record, а не внутри exit report.

| Область | Gate |
|---|---|
| Managed delivery | `accepted` и `durable` — разные UI/API состояния; availability SLO под production-like load утверждается отдельно |
| Durability | 100% durable-acknowledged envelopes читаются после потери любой 1 replica; 0 потерь на ≥100,000 test writes и всех обязательных fault scenarios |
| Replica repair | P95 ≤30 минут на зафиксированных cluster size, object/byte backlog и injected bandwidth; пустой кластер не считается evidence |
| 50% bridges blocked | ≥95% клиентов с валидным cached set подключаются ≤2 минут |
| 90% bridges blocked | ≥80% подключаются ≤10 минут, если хотя бы один descriptor достижим |
| Descriptor readiness | ≥95% pilot devices имеют ≥3 неистёкших descriptors в ≥2 provider/AS failure domains |
| Descriptor refresh | после блокировки primary set ≥90% online pilot clients получают новый подписанный set независимым каналом ≤30 минут |
| Cold start | при блокировке original bootstrap работают ≥2 предусмотренных distribution channels; QR/file recovery проходит отдельный drill |
| Enumeration | за 14-дневный controlled trial median bridge lifetime ≥3× P95 replacement distribution time |
| All IP unavailable | foreground nearby delivery ≥95% ≤60 секунд на поддержанной Android matrix |
| Normal nearby battery | median дополнительный расход ≤2 pp/24h и P95 ≤4 pp/24h относительно baseline; поддерживаемая Android matrix фиксируется до W2 |
| Emergency mode | time-boxed; auto-off; отдельное измерение и предупреждение, без скрытого foreground service |
| Metadata | ни одна managed role не видит одновременно network source и sender-recipient relation; стабильный identifier не пересекает ingress/route/storage/push/billing; component/collusion matrix и запрещённые joins/retention gates проходят |
| Updates | rollback/freeze/mix-and-match tests проходят; signing key отсутствует в обычном CI |
| Security review | нет unresolved Critical/High в Beta threat model; Medium имеют owner/deadline/claim limitation |
| Reliability | ≥99.8% crash-free sessions и ≥99.5% crash-free users/day |
| Cost | modeled essential-cloud cost ≤ утверждённого `B_free` при 10× beta load |

Провал gate не маскируется снижением теста. Он создаёт go/no-go или scope reduction.

## 7. Waves и зависимости

| Wave | Недели | Результат | Параллельность |
|---|---:|---|---|
| W0 Governance/red tests | 1–2 | source-of-truth, DRI, pinned integration manifest, claims, metadata tests, update trust ADR, legal matrix, carrier baseline | 3 tracks |
| W1 Contracts/control plane | 3–5 | bundle/metadata contract, key hierarchy, public bridge + node membership schemas, storage ADR | protocol/control/storage design parallel |
| W2 Core implementation | 6–9 | membership projection/client LKG, placement, replication MVP, ingress split, Android P2P spike | after pinned contracts |
| W3 Delivery | 10–13 | H2/proxy/racing/outbox, self-hosted profile, Android emergency nearby, iOS foreground spike, impairment CI | platform and backend parallel |
| W4 Hardening/Beta | 14–16+ | chaos, device/carrier field, update drills, remediation, pilot groups, cost decision | no novel features |
| Shadow | concurrent/post-Beta | entitlement design, rewards calculator, LoRa simulator | never blocks Beta |

Storage implementation starts only after membership schema and mailbox capability contract freeze. Consumer agents work against pinned SHA/package version.

## 8. Staffing assumption

Minimum credible parallel team. Columns `Available`, `Gap`, date and cash cost must be completed by the CEO/DRI before committing to 20 weeks; they cannot be inferred from the repository.

| Role | Required FTE | Available | Gap/date | 20-week cash cost | Critical deliverable |
|---|---:|---:|---|---:|---|
| Program/release DRI | 1.0 | Mr. X + Codex coordination | active at W0 | TBD | scope, manifest, go/no-go |
| Protocol/crypto + external reviewer | 1.0 + external | Mr. X accountable; Codex agents; external reviewer not appointed | book external reviewer in W0 | TBD | envelope/trust design review |
| Node/distributed systems | 2.0 | Mr. X accountable; Codex agents | capacity validated per wave | TBD | placement, replication, ingress |
| Shared client + Android/MAUI | 2.0 | Mr. X accountable; Codex agents | physical device access required | TBD | outbox, Android nearby |
| iOS specialist | 0.5–1.0 | Mr. X accountable; specialist/device environment TBD | before W2 | TBD | foreground feasibility |
| DevOps/SRE | 1.0 | Mr. X accountable; Codex agents | local Docker capacity to verify | TBD | pinned CI, impairment, updates |
| QA/device/carrier lab | 1.0 | Mr. X accountable; Codex agents | hardware/carrier access before W2 | TBD | gates/evidence |
| Security/privacy | 1.0 | Mr. X accountable; Codex red-team agents; independent reviewer TBD | reviewer before Beta activation | TBD | red gates/remediation |
| Product/onboarding | 1.0 | Mr. X | pilot starts W0 | TBD | groups/drills/support |
| Legal/operations | external | Mr. X accountable; external specialist TBD | preliminary memo by end W0 | TBD | jurisdiction approvals |

Role mix matters; backend capacity cannot substitute for mobile/security/SRE. Expected functions include:

- program/release DRI;
- protocol/crypto lead plus external reviewer;
- 2 distributed backend/node engineers;
- 2 client engineers (shared + Android/MAUI);
- iOS specialist;
- DevOps/SRE;
- QA/device/carrier lab owner;
- security/privacy engineer;
- product/onboarding owner;
- legal/operations advisor.

При менее чем 8 сильных engineering FTE Survival Beta уменьшается до managed text + signed control plane + self-host profile; nearby становится отдельным prototype.

## 9. GTM и готовность пользователей

Первый сегмент: семьи, малые доверенные сообщества и полевые/волонтёрские команды, которым важна заранее настроенная резервная связь. Ценность — не гигабайты, а проверенная готовность группы.

До Beta:

- QR/invite onboarding связанной группы;
- admin migration/readiness kit без доступа администратора к ключам участников;
- предварительная загрузка self-host/bridge profiles;
- monthly outage drill и понятные delivery states;
- минимум 100 pilot groups и 2,000 реально общающихся пользователей; stretch — 10,000 prepared users;
- ≥70% pilot groups activate at least 3 members; ≥60% complete controlled outage drill; ≥50% remain weekly active after 30 days;
- support burden target ≤50 tickets per 1,000 activated users/month;
- acquisition/onboarding owner, current baseline, funnel channels and pilot budget are named in the CEO memo;
- метрика — weekly active communicating groups и доля групп, прошедших drill, а не downloads/MAU.

## 10. Legal/operational workstream с первой недели

Нужна внешняя профессиональная оценка по юрисдикциям; этот документ не заменяет её. До российских core/storage:

- matrix ingress/core/storage/billing/signing locations;
- data-controller/operator roles и data inventory;
- seizure/compromise playbook;
- sanctions, crypto/payment and data-localization assessment;
- защита независимых operators и связь staking identity с ними;
- LoRa frequency/power rules;
- App Store/sideload/offline update plan.

Российский ingress технически рассматривается только как один failure domain и может быть развёрнут после явного legal, operator-safety и seizure-risk approval. К концу W0 требуется preliminary jurisdiction/data-role matrix; до первого российского ingress — письменное разрешение; до российского durable storage/core — отдельный legal/security sign-off; до public XPNT enrollment — sanctions/crypto/operator assessment; до paid launch — VAT/refund/app-store/consumer/payment review.

## 11. Kill/pivot criteria

- active enumeration сжигает descriptor sets быстрее, чем достигается recovery gate;
- `B_free` превышен даже после small-envelope scope;
- metadata design не проходит review;
- Android nearby не проходит delivery/energy gate;
- iOS spike не подтверждает заявленный foreground flow — feature исключается из Beta claims;
- operator/provider concentration превышает утверждённый предел;
- legal assessment запрещает выбранную role/jurisdiction topology;
- team capacity ниже критического пути — deferred tracks закрываются первыми.

## 12. Правила работы субагентов

1. Один агент — один repository — один атомарный work package.
2. Contract PR предшествует consumer PR; dependency фиксируется SHA/package version.
3. Один owner на hot file в wave.
4. DevOps не становится местом product runtime.
5. Android и iOS — разные задачи и разные claims.
6. Каждый формат имеет migration, mixed-version, feature flag и rollback.
7. В конце wave integration CI использует manifest согласованных SHA.
8. Агент не merge/deploy и не меняет соседний repo без нового задания.
9. Handoff содержит tests, artifacts, compatibility impact и следующий consumer task.
10. Security reviewer имеет stop-the-line право.

Исполняемые задания находятся в [`agent-prompts`](agent-prompts/README.md).
