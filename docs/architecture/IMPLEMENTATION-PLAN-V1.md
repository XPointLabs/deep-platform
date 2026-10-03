# Единый план реализации Deep / XPoint для Codex

Дата: **2026-10-03**. Основание: [аудит](ARCHITECTURE-AUDIT-2026-10-03.md),
[DR-0082](../survival-program/decisions/DR-0082-integration-first-delivery-baseline.md),
[handoff](../RELEASE-STABILIZATION-HANDOFF-2026-10-03.md).
Статус этапов находится только в [NEXT-SPRINT](../NEXT-SPRINT.md).

Этот план заменяет прежние WP0–WP9, NET-STAB overlays и порядок «начать все
кодеки заново». Он использует существующий код и сохраняет полный
[V1 scope](V1-RELEASE-SCOPE.md). Старые package IDs в конце — стабильные владельцы
release evidence, а не ещё одна очередь реализации.

## 1. Контракт исполнения

- Работать от фактических HEAD и dirty state, сверяя их с handoff. Сохранить
  независимые изменения. Не выдавать наличие исходника за включение в build.
- Один этап может иметь несколько repo-owned подзадач. Каждая меняет свой repo,
  передаёт точный commit/API/tests; общий integration gate закрывается только
  на согласованной матрице всех потребителей. Сначала producer, затем consumer.
- Каждый запуск берёт одну незавершённую подзадачу, читает её normative owner,
  реальные callers/composition и тесты. Не переизобретать wire по тексту плана.
- Новая криптография/wire требует отдельного принятого DR, machine schema/vector
  freeze и проверки всех consumers. DR-0081 — текущий mailbox target.
- Нельзя ослаблять expiry, replay, quorum, TLS, revocation или protected floors,
  возвращать PMA1/P04/MAU2 как fallback, подменять signed authority fixture.
- Тест, остановившийся на неверном fixture до нужной ветки, не проверяет эту
  ветку. Исправить fixture, сохранив исходный timeout/tamper/crash invariant.
- Новый или исправленный slice проверять focused tests, затем обязательными
  gates repo и connected path. Не удалять остальные failures ради green report.
- Коммиты локальные и раздельные, submodule pointers — после child commits.
  Production/reset/push/publish не следуют из этого плана автоматически.

## 2. Зависимости и критерий первого результата

```text
S00 baseline / trustworthy fixtures
  -> S01 close admission + lifecycle contracts
     -> S02 current node admission -> S03 peer quorum
     -> S04 client durable lifecycle
     -> S05 Registry + operational renewal
S02 + S03 + S04 + S05 -> S06 two-client real transport
S04 + S06 -> S07 delivery scheduler + receipts + offline UI
S06 + S07 -> S08 shipping composition + physical text
S05 + S08 -> S09 recovery / sustained delivery
S09 -> S10 files, S11 devices/groups, S12 carriers/push/calls
S10 + S11 + S12 -> S13 full release qualification
```

Первый результат — contact/consent и двусторонний text на реальных endpoints
с durable inbox и без потери при повторе. Это ещё не feature-complete V1.
Проверенный local text slice должен появиться до расширения files/groups/calls.
Ни один этап не получает «готово» только по компиляции или health=200.

## 3. Этапы

### S00 — воспроизводимая исходная точка

**Владельцы:** XPointLabs (матрица/governance scripts), xnode, deep-registry-api (свои fixtures),
deep-devops (изолированный PostgreSQL lane). **Зависимости:** нет.

Сохранить точные исходные commits и реальные project graphs. Полный handoff
содержит 19 node и 31 Registry failures, а не release qualification. Сначала
классифицировать каждое падение: продукт, устаревший fixture/contract, среда;
оставить все непроверенные случаи открытыми. Восстановить signed current XPA/XPP
fixtures и reader 2 catalog fixture; obsolete reflection/source-string assertions
заменять проверкой действительного публичного контракта/собранной composition.
PostgreSQL tests выполняются с отдельной disposable БД, никогда с production.

Также закрыть выявленный drift root documentation/governance gates: raw machine
set digest, старый contact vector count, удалённый ContactV1 test path и ONION
ContactResolve pairing. Сверять с текущим producer/approved inputs; нельзя
просто записать текущий hash/count как новый норматив или ослабить проверку.
Отличить raw CRLF/LF checkout hashing от semantic specification drift.

**Выход:** таблица каждого failure → причина → исправление → повторный тест;
воспроизводимые команды и sanitized TRX. **Gate:** полные текущие node/Registry
suites на исправленных исходниках без unexplained failures/skips; harness error
не считать product pass. Проверки crypto/time/quorum остаются строгими.

### S01 — закрыть недостающие контракты без нового wire по умолчанию

**Владельцы:** XPointLabs (нормативные изменения), deep-protocol (закрытая
verification API), deep-client-shared (local-state transitions).
**Зависимости:** S00; fixtures могут чиниться параллельно с анализом.

Составить и принять в существующих normative owners таблицу переходов:

- node current authority: trusted time, PMA2 profile 2 / PMT2 / signed selector,
  holder, revocation, replay, selected local exit, separate node ID/receipt key;
- peer mutation: exact grant/body/role/source/member binding, recheck после
  внешнего callback и перед mutation/receipt;
- client grant/send/route: active → expiry/renewal, pending/unknown → exact
  reconciliation → settled/retired; changed bytes не становятся exact replay;
- retire/compact: что остаётся для replay protection, когда освобождаются slots,
  какие tombstones/floors нужны после crash, что происходит при capacity;
- application receipt: stored, recipient materialized, delivered, read — разные
  события и durable обязательства.

**Обязательное открытое решение:** какой текущий подписанный источник и какой
проверенный floor подтверждают revocation в node admission. Не оставить пустой
revocation source, PMR1 adapter или локально придуманную семантику. Если текущий
frozen набор не выражает требование, оформить узкий DR/registry change до S02.
Аналогично не проектировать compaction простым удалением журнала или увеличением
512/128; сначала доказать отсутствие повторного применения/replay после очистки.

**Выход:** полные state/error tables у владельцев и bounded APIs/fixtures;
wire change только при доказанной необходимости. **Gate:** каждый переход имеет
вход, durable effect, retry rule, expiry/cancel outcome и crash test; нет
циклического bootstrap «свежая authority нужна для получения её successor».

### S02 — current XNode client admission

**Владелец:** xnode; Protocol API producer — отдельная подзадача deep-protocol.
**Зависимости:** S00, S01.

Подключить current host authority к реальному Program/DI и Store/Retrieve/ACK.
Провести MCG3 selector, MCP3 holder/request proof, current source, revocation,
protected monotonic interval и local selected-exit до допуска операции. Удалить
старую production PMA1/P04 composition, сохранив нейтральные durable primitives.
Не доверять host UTC, конфигурационному списку реплик или caller time как authority.
Receipt verification использует ключ XND descriptor, а не байты node ID.

**Выход:** одна current-only node composition. **Gate:** real distinct ID/key
positive case; profile 1/MAU2, wrong selector/holder/role/body/member, expiry at
boundary, rollback и revocation отклоняются до replay/mutation; callback crossing
expiry не выдаёт успешный receipt. Unready честно виден и не разрушает custody.

### S03 — grant-bound peer replication и quorum

**Владелец:** xnode. **Зависимости:** S02 и S01 peer API.

Подключить DR-0081 proof к реальному HTTP peer receiver/coordinator. Два proof
проверяют один exact grant и current projection; выбранные реплики и descriptor
keys вычисляются verifier. Проверить операцию, placement и source до reservation;
снова проверить authority после peer/storage callbacks. Сохранить durable
pending/unknown и exact replay при частичном commit. Не выпускать quorum receipt
по единственной реплике и не подменять physical replica логическим дубликатом.

**Выход:** Store/read/ACK через два отдельных durable stores и реальные peer
HTTP endpoints. **Gate:** lost response, tampered peer signature, wrong grant in
second proof, partial commit, crash reserve→mutate→receipt, restart/read-back,
concurrent exact retry, ACK replay и отсутствие resurrection. Проверить distinct
node IDs и ключи, current authority change во время HTTP callback.

### S04 — завершить client grant/send/route lifecycle

**Владелец:** deep-client-shared; требуемая Protocol API — отдельная подзадача.
**Зависимости:** S01. Можно параллельно S02/S03.

Использовать существующие protected custody, SQLCipher и exact ciphertext retry.
Добавить принятые S01 settlement/renewal/retirement/compaction; сохранить original
request для unknown outcome, не увеличивать ему lifetime и не переименовывать
его в новый send. Новый разрешённый attempt после смены route/grant относится
к тому же logical message и допускается только по принятому transition contract.
Route renewal должен начинаться с нормативным запасом до expiry и отдельно
обрабатывать incomplete successor и profile/service rollover.

**Выход:** длительно работающие bounded journals без account reset.
**Gate:** пересечение прежних 512 send entries и 128 grant scopes; исчерпание
ресурсов с backpressure; successful, pending и rejected операции; expiry в
unknown outcome; cold reopen и crash на каждом compaction/handover шаге;
один semantic effect, без потери replay floor или повторного ratchet encryption.

### S05 — current issuer и автоматический lifecycle управляющего контура

**Подзадачи и владельцы:** deep-registry-api — current issuance/readiness/CAS;
deep-devops — lifecycle и наблюдаемость; xpoint-node-installer — retained-volume
restart/upgrade; deep-client-shared — bounded verified catch-up.
**Зависимости:** S01; connected gate требует S02/S03.

Использовать имеющийся private XMC2 issuer и permanent winner journal. Проверить
role signers, current proof/time и revocation; отдельно выполнить positive
issuance→client verify→node acceptance. Подготовить поддерживаемое authoring и
атомарное согласование signed PMA2 profile 2 / PMT2 successors с установленными
ключами. Без копирования root online, правки signed records, genesis/floor reset.

Развязать health/readiness и nonce-consuming issuance; refresh single-flight,
с backoff/jitter и ресурсным бюджетом. Автоматизировать operational head/view/key
rotation и предупредить об expiry policy, требующем offline ceremony. Проверить
retained predecessors, time recovery и catch-up за пределами обычного head tail.
Не объявлять Registry «не нужен»: при исчерпании проверенного freshness horizon
клиент обязан ждать current authority. Оценить и измерить этот budget.

**Выход:** воспроизводимый isolated production-like lifecycle и runbook; для
production только reviewable provisioning bundle до отдельного разрешения.
**Gate:** restart каждого автора/узла, signer outage, expired observation/head,
clock rollback, две конкурирующие генерации, более 64 successors, несколько
ротаций и retained volumes; восстановление без ручных правок и новых identities.

### S06 — первый connected two-client text slice

**Владельцы:** deep-tests-e2e (black-box), deep-devops (TLS topology),
deep-client-shared/xnode/Registry (дефекты своей границы).
**Зависимости:** S02–S05.

Два изолированных настоящих account/database instances и реальные endpoints:
publication → resolve → claim → Hello → explicit Accept → A↔B text → local
materialization → mailbox tombstone. Использовать native crypto, signed current
inputs, реальный masked selected-entry path и две физически отдельные replica
stores. Ни synthetic transport, ни direct mailbox URL не закрывают этот gate.

**Выход:** повторяемый сценарий без ручной подстановки result/grant и точная
source/artifact matrix. **Gate:** offline recipient в пределах retention,
duplicate/reorder, lost Store/ACK responses, restart обоих клиентов и реплик;
recipient history содержит один эффект и получает тот же plaintext. Store
receipt в этом этапе ещё не доказывает готовность AppAck/Delivered UI.

### S07 — автоматическая доставка, offline UI и application receipts

**Владельцы:** deep-client-shared (scheduler/event/durable state),
deep-client-maui (wakeups/UI). **Зависимости:** S04, S06.

Account-scoped scheduler обслуживает due outbox, bounded inbox pages/HasMore и
ACK work; reconnect/admission лишь будит его. Single-flight по операции,
cancellation/account change, backoff/jitter, deadline/backpressure и fairness;
восстановление не требует нажатия Refresh/Retry. Убрать fresh network proof из
чтения уже аутентифицированной local history. Offline compose сохраняет logical
intent локально; fresh authority проверяется при сетевой отправке, не выдумывается
из старого proof. Revoked/suspicious local state сохраняет отдельные ограничения.

Подключить canonical AppAck/read события к текущему DID2 allowlist, durable
outbox/inbox и UI. Mailbox ACK — удаление серверной записи после local commit;
AppAck — E2EE свидетельство получателя. UI не показывает Delivered по одному
Store receipt. Read receipt учитывает настройку пользователя.

После text/receipt подэтапа завершить текущий DID2 путь для обязательных
reply/reaction/edit/delete-for-everyone/disappearing events и соответствующего
UI. Проверить authorization, target/predecessor binding, duplicate/reorder,
restart и application expiry; disappearing не обещает erase у другого участника.
Это отдельная подзадача MSG-01/COMPOSE-01, которую можно завершать после первого
S08 text device gate, но обязательно до S13. Первый S08/S09 зависит только от
scheduler/offline/receipt части S07, чтобы не задерживать раннюю vertical проверку.

**Выход:** автономная доставка и корректные состояния без ручного polling.
**Gate:** offline history/queue, process kill, lost receipt, duplicate AppAck,
unknown outcome, cancellation, многопоточность, drain нескольких страниц;
без push догоняет при следующем разрешённом OS выполнении. Suspended Android
не получает обещания секундной доставки; Doze/foreground проверяются отдельно.

### S08 — настоящая Release composition и физический text

**Владелец:** deep-client-maui; E2E evidence — deep-tests-e2e.
**Зависимости:** S06/S07; сборку wiring можно готовить раньше на frozen APIs.

Создать supported composition без `DEEP_DID2_HTTPS_ADMISSION`, запрещённого в
Release; не разрешать diagnostic flag для обхода этого запрета. Подключить
current conversation runtime/scheduler/platform secure storage/carrier. Сверить
actual compiled assemblies, native assets, NuGet/source pins, API/resource scans
и installed artifact digests; source build не заменяет package graph gate.

**Выход:** пригодные к подписанию Android arm64 и Windows x64/arm64 artifacts.
**Gate:** release-проекты собираются; на реально установленных Android/Windows
Hello/Accept, двусторонний text и AppAck, kill/reopen/airplane→online проходят
на том же account. Не использовать старый несовместимый QA account без отдельного
явного reset разрешения. Device logs не содержат seed, capabilities или plaintext.

### S09 — sustained messaging и recovery qualification

**Владельцы:** deep-devops + deep-tests-e2e; исправления — профильные repos.
**Зависимости:** S05, S08.

Перезапустить каждый process/host с сохранёнными volumes; остановить один XNode,
проверить очередь во время отсутствия и доставку после возврата. Operator stop
сам не отменяется. Проверить Registry/signer outage, свежий install и long-offline
return, route/grant/view/key rotation, interrupted renewal/compaction, network
switch, push-off и Android lifecycle. Коррупция/fork/lost protection key —
отдельные fail-closed случаи, не повод автоматически сбрасывать account.

**Gate:** repeated sends через старые capacity boundaries и несколько lifecycle
ротаций, ноль потерянных/повторно материализованных сообщений в допустимом
retention window, точные конечные статусы, ограниченные CPU/memory/DB/retries.
SLO/soak/sample predicates брать из release catalog и профильного recovery gate;
для отсутствующего сценария сначала дополнить каталог, а не придумывать цифры
в отчёте. Показать фактические outage/recovery intervals.

### S10 — remote files/images

**Владельцы:** BLOB-01 Shared, XNode blob runtime, MAUI picker/UI; codec — Protocol.
**Зависимости:** S09, frozen attachment contract.

Соединить local manifest/chunks с remote encrypted upload/download и current
DID2 events. Если blob terminal operation ещё не allocated, сначала закрытый
Protocol contract и hostile vectors; не использовать прямой file server.
**Gate:** независимый remote client, cold download и hash полного plaintext;
resume после kill/offline, corrupt/missing/reordered chunks, expiry/quota;
integrity до exposure. Local prepare/read и inline manifest не считаются remote.

Media-message completion включает весь §3.4 V1 scope: image, document, short
video, voice note и encrypted avatar workflows, включая record/pick/preview/
playback, limits и offline resume на поддерживаемых платформах. Этот подэтап
не считается выполненным по одной успешной передаче generic file.

### S11 — devices, history и governed groups

**Владельцы:** DEVICE-01/GROUP-CLIENT-01 Shared, GROUP-CONTROL-SERVICE-01 XNode,
GROUP-CODEC-01/HISTORY-CODEC-01 Protocol, UI MAUI. **Зависимости:** S09;
attachment group gate также S10.

Связать текущую DID2 identity/revocation с enrollment/history transfer и group
semantic consumer, control quorum и durable fanout. Удалённый device не входит
в будущий fanout, fork не решается last-write-wins. Наличие старого GroupV1
harness не закрывает current path.
**Gate:** enrollment/revoke/recovery/history policy; create/invite/accept/remove/
roles/owner conflict; partial fanout/restart/long-offline, limits и physical
scenario IDs из полного release catalog.

### S12 — carriers, push и calls

**Владельцы:** см. стабильные IDs ниже. **Зависимости:** S09; независимые
подзадачи параллельны после reviewed contract producer.

Довести второй независимый masked carrier, bridges/bootstrap distribution и
censorship matrix; push передаёт только hint, доставка проверяется без него.
Call signaling использует текущие ratcheted events/outbox; answer CAS и
allocation — XNode; MAUI media relay-only, отдельно от mailbox onion path.
**Gate:** полный carrier/blocking matrix и extraction review; wake/resume,
provider outage; реальные Android/Windows audio/video, UDP-blocked path,
reconnect, no direct ICE/TURN fallback, peer IP/privacy и E2EE media evidence.

### S13 — единый release gate

**Владельцы:** deep-tests-e2e, deep-devops, COMPOSE-01 и независимые reviewers.
**Зависимости:** S10–S12 и все blocking requirements release catalog.

На одной immutable matrix выполнить full builds/tests, production dependency/
API/resource/evidence checks, native supply-chain/license/crypto/privacy review,
physical/security/censorship/load/retention/recovery scenarios. Отдельно проверить
installer, signed updates, operational runbooks и публичные product claims.
**Gate:** каждый blocking scenario/evidence ID разрешён, относится к текущим
artifacts и имеет pass; P0/P1=0. Подготовить reviewable release bundle.
Публикация/production deployment требуют отдельного разрешения владельца.

## 4. Стабильные package owners для evidence

Следующие IDs сохраняют ownership existing release catalog. Реализация идёт
по S00–S13; требования codec/security/retention находятся у тематических owners,
а не в удалённом историческом каталоге задач. Completed-by-name не допускается.

| Package IDs | ownerRepository | Текущая привязка |
| --- | --- | --- |
| GOV-01, ARCH-01 | XPointLabs | S00/S01, нормативная согласованность |
| ID-PQ-CB, CRYPTO-01, ID-01, REG-01 | deep-protocol | существующая база; S01/S13 проверяют gaps и production closure |
| E2EE-01, APPLICATION-CORE-CODEC-01 | deep-protocol | S01/S06/S07, current semantics и receipt activation |
| ATTACHMENT-CODEC-01 | deep-protocol | S10 |
| HISTORY-CODEC-01, GROUP-CODEC-01 | deep-protocol | S11 |
| NETCODEC-01, ONION-01, CONTACT-CODEC-01 | deep-protocol | S01–S06, current contracts |
| CARRIER-CODEC-01, CALL-CODEC-01 | deep-protocol | S12 |
| STORE-01, MSG-01, CONTACT-CLIENT-01 | deep-client-shared | S04/S06/S07 |
| DIRECTORY-CLIENT-01, ROUTE-01, SUPERVISOR-01 | deep-client-shared | S04/S05/S07/S09 |
| DEVICE-01, GROUP-CLIENT-01 | deep-client-shared | S11 |
| BLOB-01 | deep-client-shared | S10 |
| CALL-SIGNAL-01 | deep-client-shared | S12 |
| XNODE-01, CONTACT-SERVICE-01 | xnode | S02/S03/S06/S09 |
| CARRIER-GATEWAY-01, CALL-RELAY-01 | xnode | S12 |
| GROUP-CONTROL-SERVICE-01 | xnode | S11 |
| DIRECTORY-01, ACCOUNT-DIRECTORY-AUTH-01 | deep-registry-api | S05 |
| CARRIER-CATALOG-01, BRIDGE-DISTRIBUTOR-01 | deep-registry-api | S12 |
| ROOT-CHECKPOINT-01, BRIDGE-01 | deep-devops | S05/S09/S12/S13 |
| REALITY-01, HTTPS-01, CALL-MEDIA-01 | deep-client-maui | S08/S12 |
| COMPOSE-01 | deep-client-maui | S08/S13 |
| PUSH-01 | deep-push-notification-server | S12 |
| E2E-01 | deep-tests-e2e | S06/S08–S13 |
| DEV-E2EE-01 | deep-protocol, deep-client-shared, deep-devops, deep-client-maui (отдельные repo-owned подзадачи) | deferred local-only authority; не release dependency |

Staking repos сейчас не входят в критический путь text. Их economics/admission
контракты и release integration проверяются там, где их требует текущий signed
membership/product scope; их рефакторинг не является prerequisite этого аудита.

## 5. Шаблон задания и отчёта Codex

Задание: «Выполни Sxx / repo-owned подзадачу из этого плана. Проверь actual
HEAD/dirty state, inputs/producer commits и AGENTS. Реализуй smallest complete
slice, сохрани invariants и unrelated changes. Проверь acceptance и mandatory
repo gates. Обнови normative owner/runbook при изменении контракта. Локально
закоммить только свою работу. Никаких production/reset/push действий».

Отчёт: baseline и итоговые commit IDs; changed behavior; точные commands и
pass/fail/skip; source vs real HTTP vs device evidence; remaining defects;
следующая разблокированная подзадача. Обновлять строку NEXT-SPRINT, не добавлять
ещё один общий roadmap/handoff. Готовность этапа — результат gate, не процент
написанного кода и не количество DR.
