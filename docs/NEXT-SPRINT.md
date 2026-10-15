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
2. **Незавершённые original intents — DR-0125.**
   [Контракт](survival-program/decisions/DR-0125-current-publication-submission.md)
   принят: один current publisher-signed submission над exact original request
   для reusable phase5/6, без backdating, нового journal generation, сброса
   аккаунта, освобождения permanent fence или direct Registry fallback.
   Missing/pending/completed используют тот же permanent GetOrIssue; completed
   XPA не подписывается повторно. XPL1 остаётся единственным reusable mutation
   envelope. Targets3/4 и их API/endpoints удалены из нового source candidate;
   target2 остаётся только для strict-current one-time genesis.
   Согласованный Protocol/Shared/Registry/Node source candidate скомпилирован
   без warnings/errors. Shared focused26/0/0 проверяет encrypted cold reopen,
   исходные slots, lost response/Store, phase5/6 recovery и phase7 без callbacks,
   включая продление контакта. Registry focused36/0/0 и concurrency3/0/0
   с настоящей временной PostgreSQL проверяют missing/pending/completed,
   actual-current approval, permanent winner/count и двух независимых issuers.
   Node focused23/0/0 проверяет forwarding/authentication/pairing/gateway;
   synthetic replica receipts и TestServer не являются физической доставкой.
   Receipts: Shared `artifacts/s05-current-publication-20261015/owned-focused-02`;
   Registry `artifacts/s00/s05-current-publication-02-85680a051fa6409a83ceccab1a35f23d`
   и `s05-current-concurrency-01-47b301deb146457290eb8e14cd323edc`;
   Node `artifacts/s05-current-publication-20261015/node-focused-02`.
   Первые FAIL сохранены: неверный conservative-clock шаг/точный тип rejection
   в Shared; пустой unknown-original аргумент synthetic replica в Registry;
   предположение об одинаковом gateway в Node. Исправлены fixture composition
   и ожидания, не production guards. Первый Shared runner не сохранил native
   exit из-за PowerShell stderr handling; повтор завершился native0.
   Protocol focused/API/ONION17/0/0 и строгий machine registry gate прошли.
   Receipt: Protocol `artifacts/s05-current-publication-20261015/protocol-focused-01`.
   Source checkpoint: Protocol `f0ef288`, Shared `e8a1178`, Registry `13678dc`,
   Node `01d86d5`. Selected source security:17/24/12/9/6 файлов,0 findings;
   changed Markdown9/317 local links и public documentation174 checks прошли.
   Все пять checkpoint refs проверены на GitHub; push verification завершён.
   Первый новый Protocol full:2297/35/7, build/preflight0, test/qualification1,
   FullAccepted=false.33 случая отклонены общей retained-read fixture с исходным
   XRC issuance вне PMT window; ещё один — закрытым signer inventory, не
   включавшим новый typed current-submission signer. Production guards не
   изменены; исправленный полный набор этих двух классов прошёл94/0/0.
   Receipt: Protocol `artifacts/s05-current-publication-20261015/regression-focused-02`.
   Исходный full FAIL сохранён. Повтор Protocol full02 завершён2331/1/7:
   build/preflight/qualification0, native test1,2339 exact mappings и1611
   unchanged inputs, MatrixQualified=true, FullAccepted=false. Receipt:
   Protocol `artifacts/s05-current-publication-20261015/full-02`.
   Оставшийся package FAIL — фактический retired `MAU2` token в старом
   production mailbox-authority codec/model, не waiver или причина переименовать
   старый transport в current. Его clean-break closure остаётся S08 blocker.
   Новый Node full запущен с exact DR-0125 case replacement; до terminal и
   qualification его результат не заявляется. Не запускать второй full поверх
   живого runner в `artifacts/s05-current-publication-20261015/full-01`.
   **Осталось:** package и Shared/Registry/Node final full qualification,
   затем matched retained current-dev и Android/Windows
   activation на тех же аккаунтах. Ни новый runtime, ни physical0/4 этим кодом
   ещё не квалифицированы. Expired inner resources и epoch/cohort/device handover
   остаются отдельными lifecycle requirements.
   Последний активированный runtime — DR-0124 checkpoint:
   Protocol `f244168`, Shared `317a323`, Registry `32c390a`, Node `8360744`,
   MAUI `95ef514`, DevOps `1bba9f3`. Его Android phase5 unknown и closed
   `Winner/winner-missing` сохранены в
   [contact checkpoint](../deep-devops/docs/S05-CONTACT-TRANSPORT-2026-10-15.md).
   Агрегаты publication6/completed6/pending0 не устанавливают принадлежность
   клиенту и не доказывают noncommit. Аккаунты, recovery, floors и node keys
   сохраняются. Windows UI ранее остановлен пользователем Esc; до нового
   разрешения UI не возобновлять. Production этим source-срезом не изменён.
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
