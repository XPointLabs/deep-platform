# История спринтов

## 2026-08-30 — итоговая clean-break/XPoint specification

Статус: завершена документация целевой архитектуры; runtime, physical evidence
и production deployment не выполнялись.

- Подтверждён destructive clean break: 24-word `DeepRecoveryV1`, DNP1
  account/device roles, device-scoped hybrid AKE/Triple Ratchet и отсутствие
  legacy migration/fallback.
- Специфицирован permanent transport-neutral DID1/DAB1, initial contact через XIR1, oblivious account transparency,
  atomic fresh pre-key claim и offline route delegation без циклического PRA lookup, multi-device,
  owner-sequenced groups до 100 участников/500 active devices и будущий MLS
  profile.
- Специфицирован transport-neutral application/outbox contract для XPoint,
  будущих P2P mesh и on-prem profiles.
- XPoint разделён на threshold-signed public roster, clean-break PMA2/PMT2/PMS2
  mailbox projection, three-hop routes, access bridges и pluggable carriers.
- Для initial three-node profile снято утверждение о disjoint fallback; оно
  возможно только при 6+ узлах и проверенном failure-domain diversity.
- Reality принят как первый carrier вместе с независимым HTTPS-like carrier,
  rotating bridge distribution и masked call-relay paths.
- Calls включены в v1: signaling идёт через E2EE message plane, media использует
  relay-only WebRTC; direct ICE и отдельный Registry signaling inbox исключены
  из release target.
- Разделены safe reconnect и message retention: trust возвращается после
  длительного offline, обычные server messages хранятся 30 дней; phrase-only
  recovery не обещает contacts/history без backup/device transfer.
- Добавлены единый protocol registry/collision policy и DAG из agent-sized
  implementation packages; старые AGENTS/runbooks помечены как pre-cutover.
- Техническая документация централизована в `docs/architecture`: для каждого
  предмета назначен один normative owner, повторные call/SLO/recovery/task
  definitions заменены ссылками; public `xpoint-docs` оставлен user/operator слоем.
- Добавлены threat model, Session parity baseline, performance/censorship gates,
  deployment profile matrix и детальные implementation work packages.

Все незавершённые реализации и проверки перенесены в
[`NEXT-SPRINT.md`](NEXT-SPRINT.md); выполненные старые DPE1/contact/group paths
сохраняются ниже только как историческое evidence и не являются release target.

## 2026-08-30 — аудит release transport целей

Статус: завершён документарный и code-path аудит без production deployment и без новых physical claims.

Последующее product-scope решение: первый production-релиз включает только
маскированный XPoint transport. Direct P2P больше не является gate этого
релиза и, как и on-prem, остаётся более поздним архитектурным требованием.
Целевой P2P должен поддерживать direct links и multi-hop mesh без обязательного
official mailbox/control plane. Отсутствие P2P реализации ниже сохранено как
результат аудита, а не как release blocker текущего спринта.

### Подтверждено

- Exact MAU2, durable outbox/inbox, authenticated receipts и трёхузловая бинарная privacy-маршрутизация с полностью непересекающимся fallback реализованы и покрыты автоматическими тестами.
- XNode реализует managed HTTP/2 ingress и серверный Xray/VLESS Reality ingress; production profile fail-closed запрещает mock Xray.
- Arbitrary-contact PeerDeposit, group fanout/state/message и отдельная ранняя physical-фаза `GroupText` реализованы в коде/тестовом harness.
- Account/recovery phrase создаются локально без сетевого вызова; startup больше не обязан синхронизировать inbox до показа onboarding.
- Portable contracts различают `DirectP2p`, `UserManaged` и `OfficialManaged`; self-hosted SHR1 activation принят как dormant protocol capability.

### Не выдано за готовность

- Клиентский mailbox path пока создаёт прямой HTTPS transport к signed `entryOrigin`; локальный Reality/Xray runtime не включён в отправку message frame. Поэтому anti-blocking XPoint carrier ещё не реализован end-to-end.
- Direct P2P имеет policy/interface и platform scaffolding, но не имеет production peer transport, discovery/handshake/NAT path или release composition.
- Последний физический сценарий на телефоне не подтвердил arbitrary-contact delivery, а новый APK с mailbox fixes не устанавливался. Предыдущие частичные прогоны не считаются актуальным release evidence.
- Group `GroupText` harness отделён от file picker, но успешного Android ↔ Windows physical roundtrip/cold-restart evidence ещё нет.
- Долгий offline/rotation, production clean-install control plane и два finding reactive refresh остаются release blockers.

## 2026-08-28 — authenticated contacts and groups

Статус: код и локальные автоматические тесты реализованы. Актуальный physical e2e для произвольных контактов, direct text и групп не закрыт; push и production deployment не выполнялись.

### Реализовано

- Произвольные контакты переведены на authenticated mailbox invitations и peer-deposit routes: `fa3a130`, `a27fa8c`, `0082721`, `8bac84d`, `7e1cea6`.
- Добавление контакта сначала завершает cryptographic onboarding и только затем изменяет локальную книгу контактов; peer selector сохраняется и восстанавливается после restart/offline.
- Группы используют проверенные `GroupState`/`GroupMessage` selectors; участники проходят onboarding до изменения group state: `83e8eca`, `7e1cea6`.
- Исправлена first-use/lifecycle композиция production coordinator, account release/rebind и production privacy route bootstrap.
- Добавлен Mr. X-signed DEV/UAT pair rebind на том же epoch только для `android-windows-pair/UserManaged`; production anti-rollback не ослаблен: `ade6a37`.
- Mailbox persisted-scope conflict в physical Debug преобразуется в типизированный app-owned clean-break reset: `eeb5b29`.
- Android lab policy проверяет точную версию runner: `ded889e`.

### Локальные проверки

- Shared после mailbox-liveness изменений: `1040/1040`.
- MAUI ViewModels после reactive-refresh patch: `622/622`.
- MAUI UI: `83 passed` и три opt-in physical skip; `GroupText` contract: `32/32`.
- Последний полный Smoke: `179/180`; остаётся один PowerShell 7 harness failure.
- Release DI composition: `69` app-owned descriptors.
- Android и Windows physical Debug builds: `0 warnings / 0 errors`; E2E APK установлен без изменения production package.
- Подписанная physical фаза `Attach` прошла без skipped tests после смены Android holder и перевыпуска credential pair.
- Предыдущие physical прогоны дали частичное evidence до Windows file-picker barrier, но последующая ошибка доставки на телефоне и отсутствие установки нового APK не позволяют считать contacts/direct text закрытым release gate.

### Найдено и перенесено дальше

- Windows UIA foreground limitation перед owned file picker; диагностические foreground-эксперименты откатаны и не оставлены в runtime/test policy.
- Android startup после forced cold-stop может встретить живой durable retrieve lease и показать generic retryable startup error; штатный Retry после `NotBefore` восстановил Conversations без reset.
- Один оставшийся PowerShell 7 smoke incompatibility, production offline/rotation/clean-install и Android ↔ Android на втором поддерживаемом устройстве.
- Client-to-entry Reality/VLESS не подключён к MAU2 message path; Direct P2P transport отсутствует.
- Reactive refresh commit `d488cd8` требует исправить independent trust-tuple transition и bounded lifecycle cancellation до установки на устройства.

## 2026-08-26 — release-candidate closure

Статус: завершён локально. Push, публикация и первый production deployment в этот спринт не входили. Отложенные production-bound проверки и замечания финального независимого review перенесены в [NEXT-SPRINT.md](NEXT-SPRINT.md).

### Цель

Получить воспроизводимый release candidate Deep для Android и Windows с production-grade транспортом, закрытым DNP1 package/runtime контуром, актуальными user/admin docs и локальным evidence bundle.

### Реализовано

- Завершён clean-break Deep-native privacy route: exact binary MAU2 проходит через три послойно зашифрованных XNode; primary и fallback не пересекаются; direct MAU2, Session RPC и прежний JSON-onion удалены.
- Survival authority публикует независимые X25519 keys и `privacy-routes.v1.json`; authority связана с activation и Mr. X policy, fallback разрешён только при доказанном отказе до пересылки.
- Реализован exact epoch-overlap recovery `7/8 → 8/9 → 9/10` с исторической проверкой истёкшего bridge proof и сохранением byte-identical overlap.
- Клиентский mailbox checkpoint ограничен монотонным шагом `+1`; отказ при gap сохраняет credentials, revocation checkpoint и active route атомарно.
- Physical Windows UAT storage отделён от обычного клиента; production package/data не входят в UAT reset.
- Authenticated calls path перенесён в `deep-registry-api`; UAT topology использует coturn и закрытые TURN credentials.
- Закрыты исполняемые DNP1 evidence mapping, exact package graph и связанные protocol/registry/e2e pins.
- Исправлены Android physical build RID propagation и race генерации compiled Mr. X trust root между Android RIDs.
- Добавлены RC-6 recovery tooling, documentation contracts и двухшаговая commit-matrix binding без циклической self-reference.
- HAProxy исключён из обычного dev-контура и используется только в UAT TLS/mTLS/chaos topology.

### Локальные проверки

- XNode: ProfileGenerator `107/107`, unit `134/134`, integration `197/197`.
- Shared: основной полный прогон `971/971`; обнаруженный независимым review межтестовый SQLite pool flake перенесён в следующий спринт.
- MAUI: ViewModels `537/537`, Smoke `164/164`, UI `78 passed / 2 physical skipped`; Android DeviceTests Release build завершён без ошибок.
- Mailbox/UAT integration evidence: `11/11` фаз, `passed=true`; registry, TURN, шесть XNode и UAT ingress были healthy.
- Android и Windows physical Debug builds завершены; E2E APK установлен без изменения production package.
- Runtime authority `9/10` опубликована на Android и Windows; Android подтвердил 11 файлов и `exactReplay=true`.
- Android cold-start/import window завершён без fatal, mailbox, rotation или checkpoint ошибок.
- Documentation contracts: `173` проверки; commit-matrix disposable contracts: `28` проверок; disposable volume snapshot/restore self-test пройден.
- Независимые lead developer и security reviews выполнены; незакрытые findings явно перенесены в следующий спринт.

### Точки фиксации

- Release child commit binding: superproject commit `99224e184b05c7f27725ba9df30616351ba7f420`.
- Manifest SHA-256: `6c97fa83575a1e7b55741fadec27279d1ec4d43e88dc04baaa9c960f9f587d83`.
- Финальный документирующий commit спринта до реорганизации истории: `38fe8d22954b1c0f6627a79fdd1fcd3e91e335b2`.
