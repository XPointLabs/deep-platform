# Deep / XPoint: актуальная архитектура

Актуализировано: **2026-10-03**. Статус: нормативный индекс; реализация и выпуск
проверяются отдельно. Исходная точка — зафиксированный
[stabilization handoff](../RELEASE-STABILIZATION-HANDOFF-2026-10-03.md), а не
план создания системы с нуля.

## Как читать и продолжать работу

1. [Аудит архитектуры и сравнение конкурентов](ARCHITECTURE-AUDIT-2026-10-03.md):
   выводы, исходный код, ограничения доказательств.
2. [Текущая очередь](../NEXT-SPRINT.md): только незавершённые этапы и blockers.
3. [Единый план Codex](IMPLEMENTATION-PLAN-V1.md): зависимости, владельцы,
   результаты и проверки каждого этапа.
4. Тематическая спецификация из таблицы ниже и её принятые decision records.
5. `AGENTS.md`, реальный composition root, код и тесты соответствующего repo.

[DR-0082](../survival-program/decisions/DR-0082-integration-first-delivery-baseline.md)
закрепляет интеграционный порядок этого аудита. Старые WP0–WP9, CB0/DEV0 и
NET-STAB execution overlays больше не являются параллельными очередями.
Предыдущие редакции доступны в Git до этой консолидации (baseline `3a3afbd`).
[SPRINT-HISTORY](../SPRINT-HISTORY.md) и датированные checkpoints — журнал
прошлых наблюдений; команды и разрешения из него не переносятся в новый запуск.

## Архитектурная база

Сохраняются transport-neutral application/E2EE, durable outbox/inbox,
идемпотентная обработка, onion transport и replicated mailbox. Сеть имеет
at-least-once delivery и неопределённый исход после обрыва. Единственный эффект
в локальной истории достигается durable dedup; успешная запись на сервере ещё
не означает, что получатель принял сообщение.

Текущая цель — связать уже созданные компоненты одним работающим путём:

```text
Account + verified current network/time
  -> contact publication / resolve / consent / session
  -> durable ciphertext + exact retry intent
  -> selected three-hop path -> authorized mailbox replica pair
  -> recipient durable receive + materialization
  -> transport tombstone and separate authenticated application receipt
```

Первый поддерживаемый профиль — `OfficialXPoint3`, Android и Windows. Три
обязательных routing nodes дают восстановление после возврата узла, но не
доступность маршрута во время его отсутствия. Storage replication не создаёт
дополнительные маршрутизаторы. Полные guarantees принадлежат
[DEPLOYMENT-PROFILES](DEPLOYMENT-PROFILES.md).

Root/custody, криптографические suite, privacy policy, retention и финальный
product scope этим аудитом не упрощаются. Groups, files, calls и второй carrier
остаются release requirements, но выполняются после проверенного text/recovery
пути. P2P/on-prem/Apple и six-node profile этим планом не активируются.

## Какое поколение реализовывать

| Граница | Текущий target и обязательный источник |
| --- | --- |
| Identity/account | DID2/DAB2 с PQ-root; DR-0006–0008, DR-0069 и текущие Protocol registry/codecs |
| Directory / network | DID2 freshness, protected history/time и signed NETCODEC; DR-0010–0013, DR-0070 |
| Contact / route | DID2-only owned contact/session и exact successor custody; DR-0016–0079 по затронутой операции |
| Mailbox | PMA2 profile 2, PMT2/PMS2, MCG3/MCP3/MAU3 и XMC2; **DR-0080/0081**. Signed serial revocation/floor: [DR-0083](../survival-program/decisions/DR-0083-current-mailbox-grant-revocation.md), без изменения client wire; node activation ещё закрыта |
| Peer replication | Neutral persistence framing с DID2 grant-bound proof; контракт DR-0081, текущая node composition ещё не готова |
| Local state | Текущие account/database/journal generations producer; clean break без compatibility reader |

Это карта версий, не второй wire specification. Точные widths, domains,
signatures и identifiers берутся из [PROTOCOL-REGISTRY](PROTOCOL-REGISTRY-V1.md)
и machine sources. Frozen target, скомпилированный consumer, активный runtime и
квалифицированный release — разные состояния; первое не доказывает следующее.

## Приоритет и единственный владелец требований

При конфликте: принятый decision record → frozen machine registry/schema/vectors
→ тематическая спецификация → implementation plan → repo runbook → public docs.
Если accepted decision и machine input расходятся, affected lane останавливается
для согласованного исправления producer/consumer; нельзя выбирать удобный
вариант в runtime. Код доказывает реализацию, но не меняет требования.

| Предмет | Единственный normative owner |
| --- | --- |
| Threat model, privacy/security claims | [THREAT-MODEL](THREAT-MODEL.md) |
| Recovery, identity, AKE, ratchet, primitives | [DEEP-CRYPTO](../survival-program/releases/v3.0.0/specs/DEEP-CRYPTO-V1-DRAFT.md) и frozen registry/vectors |
| Имена magic/suite/profile/API и lifecycle | [PROTOCOL-REGISTRY](PROTOCOL-REGISTRY-V1.md) |
| Contact/message/device/group semantics | [CONTACT-AND-GROUP](CONTACT-AND-GROUP-PROTOCOL-V1.md) |
| Publication/resolve/prekey operations | [CONTACT-RESOLVER](CONTACT-RESOLVER-V1.md) |
| Freshness/transparency/trusted time | [ACCOUNT-DIRECTORY](ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md) |
| Retention/recovery guarantees | [RETENTION-AND-RECOVERY](RETENTION-AND-RECOVERY-V1.md) |
| Outbox/inbox/dedup и adapters | [TRANSPORT-NEUTRAL-MESSAGING](TRANSPORT-NEUTRAL-MESSAGING.md) |
| Membership/roles/onion/mailbox/placement | [XPOINT-NETWORK](XPOINT-NETWORK-V1.md) |
| Carriers/bootstrap/bridges | [CIRCUMVENTION-CARRIERS](CIRCUMVENTION-CARRIERS-V1.md) |
| Call signaling/allocation/media | [CALL-SESSION](CALL-SESSION-V1.md) |
| Deployment guarantees | [DEPLOYMENT-PROFILES](DEPLOYMENT-PROFILES.md) |
| Product/release requirements | [V1-RELEASE-SCOPE](V1-RELEASE-SCOPE.md) |
| Exact evidence IDs/SLO predicates | [release-scope.v1.json](release-scope.v1.json), [schema](release-scope.v1.schema.json) |
| Competitor baseline / upstream policy | [SESSION-PARITY-AND-SOURCES](SESSION-PARITY-AND-SOURCES.md) |
| Текущий статус незавершённой работы | [NEXT-SPRINT](../NEXT-SPRINT.md) |
| Исполняемый DAG и package ownership | [IMPLEMENTATION-PLAN](IMPLEMENTATION-PLAN-V1.md) |

Нижестоящие документы ссылаются на владельца, описывая лишь своё API mapping,
композицию, команды и наблюдаемое поведение. Они не копируют field tables,
retention numbers, SLO или release status. `xpoint-docs` — пользовательская и
операторская документация, не альтернативная protocol specification.

## Владельцы и правила проверки

Protocol владеет проверкой bytes/crypto и закрытой authority; Shared — durable
состоянием и orchestration; MAUI — UI/platform/composition; XNode — forwarding,
mailbox и replication; Registry — signed distribution/issuance в разрешённых
границах; DevOps — lifecycle/recovery/topology; E2E — независимыми сценариями.
Операционное custody до отдельного решения владельца остаётся у Mr. X.

Каждый slice приносит точные producer/consumer commits, наблюдаемый сценарий,
отрицательные и crash/restart проверки, sanitized evidence и residual blockers.
Local test, source-cutover build и физическая передача маркируются отдельно.
Падения тестов классифицируют и исправляют, а не удаляют ради зелёного отчёта.

Documentation CI проверяет UTF-8, ссылки, public render, отсутствие секретов и
registry/schema/vector consistency. Prose snapshots и требования сохранять
исторические фразы запрещены; старый RC-6 documentation gate относится только
к своему drill. Изменения hash-bound normative docs требуют reviewed
source/anchor repin, не изменения wire или автоматической активации.
