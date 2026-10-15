# Текущая очередь Deep / XPoint

Обновлено: **2026-10-15**. Branch: release-candidate/prod-20260909.
Владелец, если не указан иной: **Mr. X**.

Единственный порядок, зависимости и критерии приёмки —
[IMPLEMENTATION-PLAN-V1](architecture/IMPLEMENTATION-PLAN-V1.md).
Основание — [аудит](architecture/ARCHITECTURE-AUDIT-2026-10-03.md),
[DR-0082](survival-program/decisions/DR-0082-integration-first-delivery-baseline.md)
и [DR-0095](survival-program/decisions/DR-0095-baseline-and-shipping-gate-separation.md).
Это очередь незавершённого, не второй specification или хронологический changelog.
Предыдущие наблюдения, исходные FAIL и exact receipts сохраняются в Git,
[исторической редакции](NEXT-SPRINT-CHECKPOINTS-2026-10-13.md) и repo-checkpoints.

## Единственный активный этап: S05

**S00–S04 приняты в своих source scopes; S05 не принят. S06/device ещё не открыты.**
Не повторять принятые gates без изменения входов или конкретной verification цели.

Предыдущая source-база: Protocol `1b5afe6`, Shared `64477cb`, Node `7bd9b68`
(source `3c4252f`), DevOps `04389f2`. Commits фиксируют транспортные исправления и открытые границы,
не S05/release acceptance; Node full02 принят, новый Shared full не квалифицирован.

DR-0122 candidate checkpoint: Protocol `1588361`, Shared `70b2830`,
Registry `ba61334`, Node `4bc720d`, DevOps `bffa6a1`. Source builds без warnings/errors,
focused Shared50/0/0, Protocol114/0/0, Node19/0/0; более ранние Node287/0/0 и
Registry7/0/0 покрывают свой срез. Это сохранённый coherent candidate, не final
full qualification, S05 acceptance или физический E2E. GitHub Releases/main не менялись.

Текущий checkpoint — [contact transport](../deep-devops/docs/S05-CONTACT-TRANSPORT-2026-10-15.md).
На отдельном локальном current-dev с тремя сохранёнными нодами настоящий Windows
production-code owner завершил prekey publication, contact commit, owned grant и
authenticated empty mailbox read, native0. Это не installed MAUI или доставка
между устройствами. Production этим пакетом не изменялся.

Изолированный MAUI HTTPS diagnostic `020496d` / Shared `c2adc50` собран для
Windows ARM64 и Android ARM64. Явный public dev-CA с DER pin, exact-host CRL
policy и network-scoped custody не включают TLS bypass или Release opt-in.
Android обновлён без reset, три protected packages не изменились; сохранённые
аккаунт и recovery повторно наблюдались без copy/reveal фразы. Новый Windows
QA-аккаунт создан через UI после подтверждения, рабочий экран и stored recovery
наблюдались. Оба клиента прошли первоначальную TLS/ADH1-history границу и
остановились на `ContactPublication / OnionCompletionUnknown`. В закрытых логах
current-dev видны backend `http-rate-limited`/`http-unavailable` и peer504;
точное соответствие отдельному клиентскому запросу не установлено. Не считать
неизвестный исход отсутствием commit; сохранять original intent, аккаунты и floors.
Clean133/0/0 прошёл. Smoke118/1/0: runner-binding scenario упал; отдельный повтор
того же теста на стабильном HEAD прошёл1/0/0. Причина первого FAIL не доказана,
полный повтор ещё не квалифицирован. Receipts: MAUI
`artifacts/s05-local-device-20261015/{android-build-05,android-install-05,android-network-prep-04,android-inspect-10,windows-build-02,authority-bootstrap-tests-01,authority-bootstrap-smoke-01,runner-binding-focused-01}`.
Shared focused7/0/0 покрывает closed TLS errors и fail-closed name/root rejection.
Отдельный same-owner CLI прошёл Registry/prekey/contact stages, но итоговый
OwnedGrantNodeRead получил remote-outcome-unknown/native1. Это не полный runtime
или S05/S06 acceptance: physical contacts/text/files/groups остаются0/4.
[Конфигурация](../deep-client-maui/docs/ARCHITECTURE.md).

Повтор того же владельца на view58 сохранил byte-identical prekey receipt pair,
но contact renewal отклонён exact-PMT predicate в `RequirePredecessorBindings`.
View57/contact generation0 native0 не доказывает changed-view renewal. Не сбрасывать
аккаунт, не убирать guard и не превращать retained-event facts в current authority.

### Оставшаяся работа S05 — по порядку

1. **Logical assignment / current carriage по DR-0122.** Один согласованный срез
   Protocol → owned client → issuer → node/peer: сохранять exact original PMT/PMS
   assignment и проверять его current eligibility отдельно от короткого view.
   Не менять ranking или перепубликовывать контакт на каждый view: это копит
   архивные read paths, которые pinned до original expiry + object TTL. Не удалять
   их и не повышать bounds ради зелёного теста. Resource lifetime, issuance facts,
   committed-XPO restore и live grant/Store проверяются независимо. Новых wire/
   journal versions нет; epoch/cohort/device/delegation handover остаётся отдельным.
   [Контракт](survival-program/decisions/DR-0122-logical-mailbox-assignment-carriage.md)
   принят. Current-only implementation candidate подключён к Protocol, owned
   client, Registry и node/peer; четыре source-cutover solution builds прошли
   без warnings/errors. Focused Shared50/0/0 включает неизменный committed journal
   после cold reopen/смены view, original-XPO restore, свежие grants и route expiry;
   Protocol114/0/0 сохраняет changed-epoch/expired-grant rejection и запрещает
   отсутствующий original snapshot после forward checkpoint. Node targeted287/0/0
   и Registry7/0/0 с disposable PostgreSQL прошли; scoped cleanup выполнен.
   Actual opaque-consumer regression19/0/0 дополнительно проверяет reusable
   successor → два durable store → reopen/exact replay → resolve generation1;
   one-time остаётся genesis-only, подмена generation/receipt отвергается.
   Убраны два оставшихся genesis-only ограничения в XPA consumer/resolve.
   Final full qualification и same-owner current-dev/device activation ещё не
   завершены. Это не приёмка S05 или release.
2. **Незавершённые original intents.** Primary/diagnostic/replication owners
   сохранены; их PMT/expiry/unknown-outcome reconciliation не закрывается новым
   успешным acceptance-owner. Не remint, не менять exact pending bytes и не
   повторять мутацию с неизвестным завершением как новую.
   На том же acceptance-owner current-dev view71 повторно подтвердил strict TLS,
   byte-identical prekey pair и current network. Contact renewal теперь доходит
   до сохранённого запроса и отказывает с закрытым `request-window`: его исходное
   короткое окно истекло. Нужен отдельный bounded reconciliation contract, а не
   ослабление XPA/currentness или освобождение permanent generation fence.
   [DR-0123](survival-program/decisions/DR-0123-retained-publication-intent.md)
   отделяет owner/issuer read-only original intent от commit и mutation lease.
   Candidate скомпилирован в consumer solutions без warnings/errors; focused
   intent/successor11/0/0 и PostgreSQL journal2/0/0 прошли. Read-only winner lookup
   сохраняет permanent fence/count и не вызывает signer; неверный scope, pending,
   повреждение и отмена отвергаются. Это API prerequisite, не разрешение повторной
   записи. Connected candidate теперь проводит свежий XPL1 lease через owned
   client → private target3 issuer → node/peer; standalone reusable XPU отвергается.
   Исходные XPU/request/op/hash и journal slots не меняются. Focused Shared26/0/0,
   Node124/0/0 и Registry24/0/0 (с реальной временной PostgreSQL) прошли; Registry
   включает истёкший phase6, потерю ответа и exact adoption без новой reservation.
   Protocol focused138/0/0 и operator static26/0/0 прошли. Реальный same-owner
   current-dev runtime05 завершился native0: byte-identical prekey pair,
   committed contact generation1, current owned grant и authenticated empty page.
   Runtime04 сохранил первоначальный unknown grant outcome; runtime05 восстановил
   тот же phase7 без новой публикации. Внешний DID2 dispatcher также переведён на
   XPL; прежний raw-XPU parser давал MalformedRequest до мутации. Node124 включает
   полную композицию двух stores и authenticated peer HTTP/TLS, не только facade.
   Это не S05/full qualification, S06 или физическая доставка. Reserved-without-winner и expired inner
   resources остаются отдельными settlement/handover, не «решены» новым lease.
   Connected candidate: Protocol `e822814`, Shared `92648b3`, Registry `8a6a95c`,
   Node `eaa0278`, DevOps `4550ea4`. Final focused Shared26/0/0 повторён после
   диагностического изменения; полный qualification не заявлен.
   Физический Android `020496d` после первого unknown получил при повторном
   открытии `Publication request is not exact current owned DID2 lineage`.
   Read-only SQL current-dev: publication6/completed6/pending0 и
   route7/completed7/pending0; эти агрегаты не устанавливают принадлежность
   конкретному клиенту. Нужно закрыть phase5 lost-response read-back completed
   original winner: текущий XPL-путь начинается с уже сохранённого XPU/phase6 и
   не восстанавливает отсутствующий ответ. Read-back не должен выдавать новую
   публикацию, освобождать fence, изменять nonce/request или принимать expired
   request как current mutation. Registry `160d56a` добавляет только bounded
   payload-free route-issuer phase diagnostics; focused HTTP24/0/0, не исправление
   восстановления. Сохранённые аккаунты не сбрасывать ради успешного прогона.
   [DR-0124](survival-program/decisions/DR-0124-publication-winner-readback.md)
   фиксирует отдельный current owner-authenticated target4 READ completed winner.
   Связанный source-срез Protocol/Shared/Registry/gateway реализован без journal
   generation или смены исходных bytes. Focused Shared5/0/0 включает encrypted
   cold reopen, nonce/response tampering, lost read reply, исходные scalars и
   phase5→6→7. Registry3/0/0 с disposable PostgreSQL включает настоящий private
   HTTP read-back, unchanged permanent count/signers и pending/corrupt scope
   rejection. Node23/0/0 и Protocol19/0/0 прошли; registry/schema и документация
   прошли проверки. Сохранены ранние FAIL: fixture re-entered held account lease,
   затем два несовпадения точных типов rejection и xUnit expected/actual analyzer.
   Они исправлены в тестовой композиции/ожиданиях без ослабления guards.
   Runtime rebuild и повтор сохранённых физических профилей ещё обязательны;
   focused PASS не означает S05/S06/full source qualification или delivery.
   Candidate: Protocol `f244168`, Shared `317a323`, Registry `2613605`, Node
   `8360744`, MAUI `95ef514`, DevOps `efcebd5`. Production этим срезом не изменён.
3. **Operational ceremony после активации roles.** Root/witness/role/traffic/TLS
   rotation, автоматический head/view/key lifecycle и предупреждение offline-policy
   expiry. Pre-mailbox Prepare/Apply отказывают на enabled contour: нужен supported
   coordinated role-volume/journal update, не обход fence или ручная правка.
4. **Оставшаяся runtime matrix.** Restart каждого автора/ноды с retained volumes,
   interruption/rollback, signer/time outage, expired observation/head, clock
   rollback, конкурирующие поколения и несколько ротаций; тот же client после
   renewal и bounded verified catch-up. Уже пройденные 129-head catch-up и
   retained restart scopes не заменяют всю эту матрицу.
5. **Final source qualification/review/commit/push coherent slice.** Не запускать
   full после каждой строки. Node full01 выполнил1513/0/0/native0, но final
   qualification1: DR-0121 не содержал exact arrow binding. Декларация исправлена;
   общий gate проверяет её до build и в конце (49 contracts/native0). Fresh Node
   full02 принят1513/0/0,1513 exact mappings/2191 unchanged inputs, все native
   stages0, FullAccepted=true. Это source checkpoint до следующего lifecycle-среза;
   новый Shared full не квалифицирован.
   Новый DR-0123 `publication-lease-full-01` завершён1516/1/0, native test1 и
   FullAccepted=false: closed-metadata witness отверг schema с двумя required
   полями через `allOf` вместо единого closed списка. Schema приведена к
   эквивалентному единому `required`, без изменения wire/const fields или теста;
   повтор всех11 OneTimePublication tests прошёл. Исходный FAIL сохранён;
   новый full на исправленной schema пока не выполнен.
   Текущий Protocol canonical2330/1/7:2338 exact mappings,1587 unchanged inputs;
   build/preflight/qualification0, native test1/FullAccepted=false. Сохранены
   один настоящий S08 MAU2 package FAIL и семь explicit skips.
   Последние focused: Shared27/0/0, Node11/0/0; operator88 checks и26 static
   contracts native0. Это не общий source/full/release PASS.

### Подтверждённая база S05 и ссылки

- [Registry source/runtime](../deep-registry-api/docs/testing/s05-protected-role-signer-2026-10-14.md):
  current issuer/readiness, separate protected role signers и permanent journals.
  Последний квалифицированный Registry full409/0/10 относится к своим inputs;
  Unix-socket skips требуют Linux lane. Первый Store14930ms/deadline15s остаётся
  performance risk, не S09 PASS.
- [Authority history и custody](../deep-devops/docs/S05-AUTHORITY-HISTORY-2026-10-14.md):
  same-day authority recovery, 129-head catch-up и retained restarts; original
  identities/keys/genesis/floors сохранены. Старый pre-cutover deep-dev не заменён
  current-only reader и не сброшен.
- [Signed reachable ingress](../deep-devops/docs/S05-PHYSICAL-INGRESS-2026-10-15.md):
  LAN origins, строгие TLS/H2, same-key PKI/CRL и retained publisher CAS.
  Это infrastructure evidence, не physical device delivery.
- [Prekey lifecycle](../deep-devops/docs/S05-PREKEY-LIFECYCLE-2026-10-15.md):
  DR-0121 stable publication assignment и exact cold-reopened XIC1 pair.
- [Текущий contact slice](../deep-devops/docs/S05-CONTACT-TRANSPORT-2026-10-15.md):
  исправлены duplicate peer endpoint, bounded public-read contention и repeated-Up
  ingress preflight. Все исходные неуспешные попытки сохранены.
- [Node prior full/smoke](../xnode/docs/testing/s05-control-read-backoff-2026-10-15.md):
  prior1508/0/0 и no-mock smoke/rehearsal, не квалификация новых inputs.
- Current-source no-mock smoke и three-node infrastructure rehearsal прошли
  native0; scoped cleanup завершён. Это не DID2 device delivery; точные receipts
  в текущем contact checkpoint, не замена final source qualification.

## Принятая база и следующие этапы

| Этап | Статус и оставшаяся приёмка |
| --- | --- |
| S00 | Source baseline принят, не shipping. [Node](../xnode/docs/testing/s00-node-baseline-2026-10-03.md), [Registry](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md). |
| S01 | Contract/API принят, не runtime/release. [Review](S01-CONTRACT-REVIEW-2026-10-10.md); original package FAIL остаётся S08 по DR-0095. |
| S02 | Current-only node source/composition принят, не deployed/physical. [Review](S02-CURRENT-NODE-REVIEW-2026-10-10.md). |
| S03 | Grant-bound peer source/composition принят. [Review](S03-CURRENT-PEER-REVIEW-2026-10-11.md); intermittent native MoveFileEx denial не объявлен исправленным. |
| S04 | Source lifecycle принят, committed/pushed: Shared full-05:1424/0/0, exact matrix и1984 unchanged inputs; matching201, MAUI95/smoke119, Windows/Android compiler checks. [Review](S04-CLIENT-LIFECYCLE-REVIEW-2026-10-13.md), [terminal audit](../deep-client-shared/docs/testing/s04-successful-audit-2026-10-12.md). Не installed/release acceptance. |
| S05 | Единственный активный: незавершённые критерии выше. |
| S06 | Не пройден: два owned clients, publication/resolve/claim/explicit consent/text через selected-entry и separate stores; offline/duplicate/lost-response/restart. |
| S07 | [Local history](../deep-client-shared/docs/testing/s07-local-history-2026-10-04.md) реализована; autonomous scheduler/drain, offline logical queue, AppAck/read и полный1:1 event/UI scope не закрыты. |
| S08 | Supported shipping composition без diagnostic flag, actual package/API/resource graph и installed Android/Windows text/receipt. MAU2 package FAIL открыт. |
| S09 | Sustained connected delivery, retained identities/floors, rotation/offline/restart/recovery и полный catalog не квалифицированы. |
| S10 | Local attachment custody есть; encrypted remote files/images/video/voice/avatar, integrity/resume/expiry/cache/UI не закрыты. |
| S11 | Current DID2 governed groups, multi-device/history transfer не замкнуты; retired GroupV1 harness не evidence. |
| S12 | Отдельные компоненты; carriers/bootstrap/push и relay-only calls не квалифицированы полностью. |
| S13 | Одна signed/installed artifact matrix, полный evidence catalog и reviews после предыдущих этапов. GitHub Releases/main — только по отдельной команде. |

## Релизные блокеры, которые нельзя потерять

- **B1/S02–S06:** health200/local Kestrel/fixture clocks не доказывают deployed
  authorities, owned client join или selected-entry/ONION delivery. PMA1 adapters
  не возвращать.
- **B2/S03–S09:** distinct identities, sole signed Store writer/prefix, independent
  peer facts и either-replica ACK приняты на source уровне; connected/physical
  retained-route/horizon/retirement/recovery всё ещё обязательны.
- **B3/S04:** source sustained512/128 и exhausted-PQ recovery приняты, installed
  acceptance отсутствует. Original pending/unknown requests, ciphertexts и floors
  сохранять; bounds не повышать, custody не evict/remint, fake freshness запрещена.
- **B4/S07:** reconnect не доказывает autonomous draining/AppAck/read. UI Delivered
  нельзя выводить из Store receipt или transport tombstone.
- **B5/S08:** conversation DI diagnostic-only и запрещена в Release. Нужен supported
  shipping owner/artifact, не снятие запрета.
- **B6/S04/S05/S08:** independent DCA/XUR/PMT/issuer/root rollover, verified catch-up,
  signed readiness и retained volumes остаются обязательными. MAU2/MCG2 нельзя
  спрятать переименованием; mapping/grammar меняются только по frozen authorization.
  Root/custody/account/device guards не исключаются.
- **B7/S10–S13:** весь [V1 release scope](architecture/V1-RELEASE-SCOPE.md), включая
  files/groups/calls/multi-device/carriers, остаётся обязательным. Outbox cleanup
  не доказывает independent DAM1/history/object-key retirement; live upload/download/
  resume obligations нельзя удалять ради capacity.
- **B8/S06/S08:** one-time source publication/descriptor/owned custody проверены
  локально; account-owned operation/QR export, request-expiry reconciliation и
  installed evidence открыты. Permanent-contact milestone не отменяет one-time UX.

Физические contacts/messages/files/groups: **0/4 подтверждены**. Релиз не готов.
Клиенты этого спринта — Windows и Android; macOS не собирать до явной команды.
OfficialXPoint3: **три production nodes**; обязательный hop outage останавливает
data route. S09 доказывает восстановление после возврата, не outage availability.
Переход к шести перед приглашением пользователей — отдельное решение владельца.

После terminal обновлять текущую строку и linked checkpoint, не наращивать
хронологический changelog. Одна функциональная часть → focused/build → связные
исправления → matching rerun → required final gates/review/commit.
