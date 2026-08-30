# Целевая архитектура Deep и XPoint

Статус: **нормативный индекс целевой production-архитектуры**  
Решение: полный pre-production clean break, 30 августа 2026 года.

## Назначение

Этот каталог является единой точкой входа для реализации первого публичного
релиза. Он описывает целевое поведение, а не подтверждает готовность текущего
кода. Фактические незавершённые работы перечисляются только в
[`../NEXT-SPRINT.md`](../NEXT-SPRINT.md), а реализованное — в
[`../SPRINT-HISTORY.md`](../SPRINT-HISTORY.md).

Это единый нормативный раздел **технической документации master-репозитория**.
Он намеренно не перенесён в `xpoint-docs`: тот репозиторий публикуется для
пользователей и операторов и не должен становиться вторым владельцем wire,
crypto или security semantics.

При конфликте документов применяется следующий порядок:

1. принятые decision records в `docs/survival-program/decisions`;
2. frozen machine registry/schema/vectors в `deep-protocol`;
3. нормативные protocol/crypto и architecture specifications из списка ниже;
4. `PROTOCOL-REGISTRY-V1.md` и `IMPLEMENTATION-PLAN-V1.md`;
5. repository architecture/operator runbooks;
6. публичная документация `xpoint-docs`.

Несогласованный нижестоящий документ не меняет требования более высокого
уровня и должен быть исправлен вместе с реализацией.

## Единственный владелец каждого вида требований

| Предмет | Единственный normative source |
|---|---|
| threat model, privacy/security claims и non-claims | `THREAT-MODEL.md` |
| recovery, identity, AKE, ratchet и primitive suites | `DEEP-CRYPTO-V1-DRAFT.md` плюс frozen machine registry/vectors |
| глобальные имена magic/suite/profile/interface и lifecycle | `PROTOCOL-REGISTRY-V1.md` |
| DID/contact/message/multi-device/group application semantics | `CONTACT-AND-GROUP-PROTOCOL-V1.md` |
| contact publication/resolve/prekey service operations | `CONTACT-RESOLVER-V1.md` |
| account freshness/transparency/trusted time | `ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md` |
| retention и recovery guarantees | `RETENTION-AND-RECOVERY-V1.md` |
| transport-neutral interfaces/outbox/dedup | `TRANSPORT-NEUTRAL-MESSAGING.md` |
| XPoint membership/roles/onion/mailbox/placement | `XPOINT-NETWORK-V1.md` |
| carrier wires/bootstrap/bridge distribution | `CIRCUMVENTION-CARRIERS-V1.md` |
| call signaling/allocation/media state | `CALL-SESSION-V1.md` |
| deployment guarantees | `DEPLOYMENT-PROFILES.md` |
| release features/SLO/evidence | `V1-RELEASE-SCOPE.md` |
| незавершённый milestone/release scope | `NEXT-SPRINT.md` |
| agent-sized dependency DAG и ownership | `IMPLEMENTATION-PLAN-V1.md` |

Нижестоящие документы MUST ссылаться на владельца и могут описывать только:

- фактическое состояние/конфигурацию собственного репозитория;
- user/operator workflow на уровне наблюдаемого поведения;
- локальный API mapping и команды проверки.

Они MUST NOT копировать canonical field tables, KDF/transcript, retention
numbers, topology guarantees, SLO или release status. Нужный фрагмент даётся
ссылкой на source of truth и коротким repo-specific consequence. При изменении
normative source выполняется link/consumer audit; текст не синхронизируется
ручным copy-paste.

### Documentation CI policy

Для нового clean-break generation допускается один быстрый path-filtered docs
job. Он проверяет только UTF-8, navigation/local links, public render, отсутствие
секретов/приватных путей и machine registry/schema/vector consistency. Он
запускается при изменении документации, registry/schema или docs tooling.

CI MUST NOT фиксировать prose через snapshot/regex, требовать присутствия
каждой исторической фразы или дублировать protocol/e2e tests. Старый
`Test-Rc6DocumentationContracts.ps1` остаётся evidence-контрактом конкретного
pre-cutover RC-6 recovery drill и не является шаблоном/default gate для V1.

## Принятые решения

- Пользователей production ещё нет: выполняется один destructive clean break
  без миграции, dual-read, legacy parser или downgrade.
- Текущие Session-derived identity, DPE1/DMC1 и group bytes не являются
  production compatibility surface и не ограничивают новый дизайн.
- Первый публичный релиз использует новое поколение account/device/database,
  ratcheted E2EE и новый contact bootstrap.
- XPoint — первый transport provider, но message identity, E2EE, groups,
  outbox, deduplication, attachments и call signaling не зависят от него.
- Direct P2P mesh и on-prem являются обязательными архитектурными профилями,
  но их runtime-реализация не входит в первый релиз.
- Первая production topology может состоять из трёх XNode и обеспечивает один
  точный трёхузловой privacy route. Она **не** заявляет полностью независимый
  fallback, operator diversity или устойчивость к отказу общего провайдера.
- После появления не менее шести узлов отдельный gate может активировать
  failure-domain-disjoint primary/fallback.
- Reality является первым pluggable carrier, а не единственным определением
  censorship resistance. Bootstrap и bridge distribution являются отдельной
  частью anti-censorship системы.
- Звонки входят в функциональный scope XPoint. Call signaling проходит как
  E2EE message; media использует отдельный низколатентный carrier с точным
  отображением privacy/reachability режима.
- Сетевая доставка имеет at-least-once retry и outcome-unknown semantics.
  Пользовательский exactly-once эффект достигается стабильным operation ID,
  идемпотентностью и durable local materialization.

## Нормативные документы

- [`THREAT-MODEL.md`](THREAT-MODEL.md) — противники, гарантии и запрещённые
  рекламные утверждения.
- `XPOINT-NETWORK-V1.md` — membership, node roles, routing, mailbox/storage,
  performance и calls.
- `CIRCUMVENTION-CARRIERS-V1.md` — carrier API, Reality, bridge distribution,
  bootstrap и censorship tests.
- `TRANSPORT-NEUTRAL-MESSAGING.md` — transport contract, outbox, dedup,
  attachments, push и calls.
- `DEPLOYMENT-PROFILES.md` — official, future six-node, on-prem и mesh
  guarantee matrix.
- `V1-RELEASE-SCOPE.md` — точный функциональный и physical release gate.
- [`SESSION-PARITY-AND-SOURCES.md`](SESSION-PARITY-AND-SOURCES.md) —
  функциональный/performance baseline Session и правила upstream reuse.
- `CONTACT-AND-GROUP-PROTOCOL-V1.md` — permanent transport-neutral DID1,
  one-time invites, initial contact, multi-device и small group semantics.
- `CONTACT-RESOLVER-V1.md` — invite publication/resolve, long-lived XIR1 и
  atomic fresh pre-key claim.
- `ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md` — fresh account/device heads,
  oblivious lookup, consistency/gossip и trusted time.
- `RETENTION-AND-RECOVERY-V1.md` — единственная retention matrix и разные
  гарантии existing-device/phrase/backup recovery.
- `CALL-SESSION-V1.md` — exact one-to-one call state, multi-device answer CAS,
  DTLS fingerprint и CallRelay allocation.
- `PROTOCOL-REGISTRY-V1.md` — глобальные magic/suite/carrier/profile/interface
  names, owners, lifecycle и collision gate.
- `IMPLEMENTATION-PLAN-V1.md` — dependency DAG из agent-sized packages,
  входы/выходы, removal lists и evidence gates.
- [`../survival-program/releases/v3.0.0/specs/DEEP-CRYPTO-V1-DRAFT.md`](../survival-program/releases/v3.0.0/specs/DEEP-CRYPTO-V1-DRAFT.md)
  — identity, recovery, AKE, ratchet и crypto suites.

## Требование к реализации

Каждый work package обязан ссылаться на конкретные разделы этих документов,
иметь closed canonical inputs/outputs, negative tests, durable crash points и
измеримый acceptance gate. Если спецификация оставляет разработчику выбор,
этот выбор должен быть локальным policy choice и не менять wire/security
semantics. Новая реализация не копирует код стороннего проекта до проверки
лицензии, provenance, поддерживаемости и собственной threat model.
