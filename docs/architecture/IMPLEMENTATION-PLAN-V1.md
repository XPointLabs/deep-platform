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
- По умолчанию активен один Sxx: следующий этап начинается после приёмки,
  review и фиксации текущего. Внутри этапа сначала собрать связный бизнес-сценарий
  producer/consumer/recovery, затем проверять его, а не открывать независимые
  незавершённые сценарии. Разрешённая DAG-параллельность не обязательна.
- Новая криптография/wire требует отдельного принятого DR, machine schema/vector
  freeze и проверки всех consumers. DR-0081 — текущий mailbox target.
- Нельзя ослаблять expiry, replay, quorum, TLS, revocation или protected floors,
  возвращать PMA1/P04/MAU2 как fallback, подменять signed authority fixture.
- Тест, остановившийся на неверном fixture до нужной ветки, не проверяет эту
  ветку. Исправить fixture, сохранив исходный timeout/tamper/crash invariant.
- Новый или исправленный slice проверять focused tests, затем обязательными
  gates repo и connected path. Не удалять остальные failures ради green report.
  Во время реализации использовать короткую сборку и целевые проверки опасных
  границ; найденные дефекты исправлять пакетом. Дорогой full запускать на
  согласованном пакете, а не после каждого файла. Повторять проверки по
  изменённым входам/риску; прежний PASS не квалифицирует новые входы.
- Коммиты локальные и раздельные, submodule pointers — после child commits.
  Production/reset/push/publish не следуют из этого плана автоматически.
- Решение Mr. X от 2026-10-17: первым реализовать CLI-first путь ниже.
  Бизнес-E2E сначала проверяется двумя headless клиентами, затем на физических
  Windows/Android. Сборка MAUI не prerequisite каждой бизнес-итерации.

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

Граница baseline и shipping уточнена в
[DR-0095](../survival-program/decisions/DR-0095-baseline-and-shipping-gate-separation.md).
Классифицированный Protocol actual-package/source defect сохраняет исходный
FAIL и блокирует S08/релиз; он не расширяет S00 до замены всего native-графа.
Source-cutover проверки текущего frozen пути не являются package/activation
evidence. Неисправленные runtime/crypto/time/fixture failures остаются у своего
этапа, а не скрываются переносом final package gate.

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

**Обязательный вход admission:** текущий подписанный источник и восстановленный
protected floor, без пустого revocation source или PMR1 adapter. Узкий контракт
принят в
[DR-0083](../survival-program/decisions/DR-0083-current-mailbox-grant-revocation.md):
его sole wire owner — CONTACT-RESOLVER §3.8. Signed Protocol producer не заменяет
native protected floor, node/peer admission или S05 issuer renewal. Статус этого
slice и остальных S01 переходов находится только в NEXT-SPRINT.
Compaction нельзя проектировать простым удалением журнала или увеличением
512/128; сначала доказать отсутствие повторного применения/replay после очистки.
Client semantic transitions приняты в
[DR-0084](../survival-program/decisions/DR-0084-owned-delivery-settlement-and-retirement.md);
sole tables — TRANSPORT-NEUTRAL-MESSAGING §8.4. Local format/API freeze и runtime
ещё открыты. Object retention нельзя привязать к короткому grant: matching
codec/node retention и retained-route Retrieve/ACK — единый activation fence.

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

В этом же этапе закрыть already-exhausted PQ recovery; отдельно разрешённый
parser-only Protocol target и оставшиеся authentication/native/transport условия
принадлежат [DR-0111](../survival-program/decisions/DR-0111-bounded-braid-recovery-control.md).
Это подзадача S04, не открытие следующего этапа и не увеличение data bound.

**Выход:** длительно работающие bounded journals без account reset.
**Gate:** пересечение прежних 512 send entries и 128 grant scopes; исчерпание
ресурсов с backpressure; successful, pending и rejected операции; expiry в
unknown outcome; cold reopen и crash на каждом compaction/handover шаге;
один semantic effect, без потери replay floor или повторного ratchet encryption.

### S05 — current issuer и автоматический lifecycle управляющего контура

#### CLI-first — первый приоритет внутри S05

**Владельцы:** `deep-cli` — console adapter, профили, команды и black-box driver;
Shared — единственный portable business/runtime owner; Protocol — существующие
codecs/crypto; DevOps — локальный настоящий Registry/три XNode. Это способ
исполнения S05, не новый параллельный этап и не отмена зависимостей S06–S13.

1. **Headless основа.** .NET CLI без MAUI/workloads/emulator; отдельные persistent
   профили Alice/Bob с разными аккаунтами, protected storage и SQLCipher.
   Первая host-платформа — Windows с существующим native стеком и OS protection.
   Account create/status/address, явный выбор network/profile, строгие аргументы,
   cancellation, ненулевые failure exits и machine-readable результаты.
   Не выводить recovery/ключи, не трогать MAUI/prod namespaces.
2. **Общий runtime и contact/text.** Использовать публичные owned операции Shared;
   переносимый composition вынести в один общий owner, если он сейчас в MAUI.
   Не копировать orchestration, wire, proof/grant/time checks или retries в CLI.
   Network verify → contact publish/resolve/request/consent → send/sync/receive
   в обе стороны, затем restart/offline/exact retry/dedup/unknown-outcome recovery
   на тех же профилях. Исправить текущие S05 дефекты на этом пути.
3. **Вложения и группы.** После рабочего contact/text подключить Shared APIs и
   недостающие реальные consumers. Файл/картинку проверять по байтам/hash,
   возобновление/повреждение; группы — создание, приглашение/принятие, сообщения
   и membership/revocation в пределах нормативного V1 scope.
4. **Квалификация.** Воспроизводимый noninteractive CLI↔CLI сценарий с bounded
   ожиданием и редактированными receipts точных source/runtime inputs. Сначала
   законченный slice → focused tests → исправления → повторные focused;
   обязательные full/frozen/package gates на согласованном пакете. Только после
   CLI PASS — matching Windows/Android build/deploy и физическая проверка того
   же поведения. Platform-specific дефекты проверяются отдельно на устройстве.

**Выход:** работающий клиент, не оболочка над fixtures/raw RPC. Команды не
принимают caller-authored authority и не имитируют доставку. Expired grant не
разрешает remint/перезапись неизвестной операции; TLS/currentness/replay/quorum
не ослабляются. CLI PASS не заменяет device acceptance, signed release/package
evidence или разрешение на GitHub Release.

#### Lifecycle управляющего контура

Native directory-floor amplification исправляется bounded anchored-prefix
lifecycle по [DR-0170](../survival-program/decisions/DR-0170-anchored-directory-floor-prefix-retirement.md),
без сброса global revision и с actual native/anchor/index проверками. Original
Store после ротации использует два строгих historical namespace joins по
[DR-0171](../survival-program/decisions/DR-0171-original-store-namespace-joins.md).
Текущий original54 recovery, native/source результаты и latency остаются в
[едином checkpoint](../../deep-cli/docs/testing/cli-anchored-floor-lifecycle-2026-10-23.md);
Windows/Android не возобновлять до проверенного CLI пути. Focused не закрывает
full/package/sustained/S05 acceptance и не доказывает1–2s delivery.

Текущий fanout/ACK slice — [DR-0165](../survival-program/decisions/DR-0165-page-authority-and-noop-group-publication.md):
убрать no-op control publication и повторное acquisition PUBLIC own endpoint
в пределах одной mailbox page, сохраняя actual send/receipt/native checks и
отдельный independently current ACK после materialization. Matching expanded focused
Shared93/93 и CLI70/70 PASS; не unfiltered full/package acceptance.
Diagnostic42 на прежних3 CLI —40/40 delivery-only PASS,129 сообщений /43 local
commands каждый. Full43/original recovery выявили отдельный отказ: non-current
resolver result пересылается в success-only private issuer с horizon0. Unknown
Store сохранён; supported same-peer maintenance и original recovery не являются
новым first-attempt benchmark. Точный текущий cursor, исходные FAIL и итоговые
замеры — в [едином repo-checkpoint](../../deep-cli/docs/testing/cli-page-control-latency-2026-10-22.md).
Fresh nonce-bound DTT1, currentness, quorum и Store fences не ослабляются.
S05, sustained availability,1–2s, full/package/device/release остаются открыты.
Recovery43 —49/49 PASS. После отказа44 выполнен [DR-0166](../survival-program/decisions/DR-0166-replica-assignment-and-local-admission.md):
private CRQ2/CRS2 отделяет exact assignment от independently current local
admission lifetime. No legacy reader/route. Node262/262 focused и local smoke
PASS; три локальные ноды обновлены одним образом. Recovery44 —52/52 PASS с
одним owned mailbox resume/lease wait. Delivery45 —40/40 PASS без resumes/waits/
network failures,138 сообщений /46 local commands у каждого. Mean fanout58.911s,
receive+ACK22.135s: общего ускорения относительно diagnostic42 нет.
По [DR-0167](../survival-program/decisions/DR-0167-bounded-history-read-availability.md)
исправлено bounded read-only Directory503 recovery с обязательным independent
fresh nonce-bound proof после valid empty catchup; Shared26/CLI70 focused PASS.
Original46 capacity deadlock устранён [DR-0168](../survival-program/decisions/DR-0168-sealed-acquisition-working-set.md):
complete inactive originals atomically tier в sealed protected custody, не
удаляя replay floors, native/SQL или unknown/captured dependencies и не повышая
caps. [DR-0169](../survival-program/decisions/DR-0169-original-retrieve-namespace-joins.md)
исправляет оба original Retrieve historical joins без current-ACK waiver.
Recovery46 —53/53 PASS/native0,141/47 history/commands каждый; delivery47 —40/40
first driver attempt PASS,144/48, zero resumes/waits/network failures. Mean
fanout64.839s / receive+ACK22.114s не доказывают ускорения против45.
Bounded acquisition batching (до8 originals в одной atomic inventory mutation)
проверен Shared72/72 и финальным focused69/69, включая source128/129 grants и
сохранение floors/before-issuer backpressure. Это не unfiltered full.
Delivery48 functional PASS40/40 содержит один owned mailbox resume/non-success.
49 на той же сборке PASS40/40 без resumes/waits/network failures:150/50 каждого.
Fanout47.750s (-18.9% к45), receive/ACK24.125s (+9.0%); grant/idle work отличается,
не causal A/B. ACK/local native/persistence latency остаётся открытой; следующий
на этом checkpoint retained cursor50. Источник статуса и exact receipts —
[matching report](../../deep-cli/docs/testing/cli-acquisition-lifecycle-2026-10-22.md).
Последующий [DR-0162](../survival-program/decisions/DR-0162-exact-public-signature-arithmetic.md)
slice: bounded exact-public signature memo использует O(1) random replacement,
без изменения caps/authority/currentness/replay. Protocol319/CLI70 и реальный
Linux ARM64 Node218/Protocol218 focused PASS. Supported LOCAL Build/Up/Verify
обновили Registry/publisher/3 nodes;9 healthy,28 existing volumes, zero new.
Отдельный auxiliary whole-mount JSON equality FAIL не квалифицирован как PASS.
Original50 recovery51/51 PASS,153/51 каждый, один mailbox resume/lease wait;
новый51 delivery40/40 PASS,156/52 каждый, zero resumes/waits/network failures.
ACK24.125→22.151s и CPU176.349→146.997s, но fanout47.750→52.055s и active
331.734→337.379s: общего ускорения нет, work differs, не causal A/B. Next52;
original50/51 не переавторить. ONION/authority/native waiting, automatic idle
peer-route/NotBefore scheduling и1–2s цель остаются открытыми. Exact ledger и
таблица всех операций — в
[matching report](../../deep-cli/docs/testing/cli-signed-history-memo-2026-10-23.md).
Следующий native-floor slice: Node66 Windows/108 Linux focused PASS, native
Build/Up/Verify9 healthy/unchanged native-volume bindings. At16+ head files,
bounded4-worker acquisition сохраняет actual file/Unprotect/chain/anchor/index
checks. Обычный RPC выполняет132–299 lease checks на фоне249 floor tips EACH;
это структурный O(history) bottleneck, batching его не устраняет. DR-0153 разрешает
один uncaptured-authority discard/re-entry после точного GrantRouteExpiry,
без waiver/нового authoring/captured-byte changes; финальные Shared21/CLI70 PASS.
Original52 recovery49/49 PASS (один mailbox resume/wait),159/53 каждый; новый53
delivery40/40 PASS без resumes/waits/network failures,162/54 каждый. К51 fanout
52.055→51.299s, ACK22.151→24.541s, active337.379→350.329s: общего ускорения нет.
Live ceiling-refresh branch не наблюдалась: scheduling unit evidence отдельно.
Next54;52/53 не переавторить. Приоритет — bounded current-floor/public-closure
validation с review invariants/crash/rollback proof, не permission TTL cache.
Точный scope/FAIL/native ledger/полная таблица —
[matching report](../../deep-cli/docs/testing/cli-node-floor-read-batching-2026-10-23.md).
Production ingress lab остаётся FAIL на Compose Up, не закрыт другими PASS.
Windows/Android/production и quotas не затронуты.

Предыдущий NTS/ACK slice: DR-0161 расширяет обычную offline operational renewal
явной retained mailbox ceremony. Действующая signed policy теперь4 sources /
4 independent families, прежний кворум2/2, sample age10s/width30s, прежние
радиусы/TLS/pin/floors. Prepare/Apply/Up/Verify native0,9 сервисов healthy.
Зарегистрированные node identities, genesis, CA key, accounts, native journals,
старые role floors/SQL scopes сохранены; TLS/traffic/role issuer keys ротированы
обычной подписанной succession. Старый pre-mailbox guard не обойдён.
DR-0162–0164: exact public-signature arithmetic, purpose-separated historical
Store issuer facts и key-free receive→ACK scheduling scope без повторного
catalog lookup; actual ACK signer authority перепроверяется независимо.
Protocol318, Shared5+21, Node47 Windows /218 Linux, Protocol215 Linux,
CLI67/scope9/DevOps36 PASS в named focused scopes; actual API graph Release/Debug
и frozen manifest integrity PASS, не full/package qualification.
Те же3 CLI без reset: исходный strict36 FAIL на XRA1 expiry сохранён,
реальная route maintenance выявила и исправила past Store issuer rotation bug;
NotBefore не ослаблялся. Original36 recovery49 PASS/native0,111/37 у каждого,
Active3/epoch2, без automatic resumes/waits/retries/non-success.
Новый strict37 —46/46 PASS/native0 с первой попытки без resumes/waits/retries/
non-success;114/38 у каждого, recovery не выдаётся за first attempt.
Реальный Linux observer:4/4 authenticated observations/families за1.417s;
поочерёдное исключение каждого исходного источника оставляет3/3 и кворум
за1.298/1.404s. Но fanout32.610→38.480s, ACK19.807→20.881s,
cold batch32.211→44.252s mean относительно strict35: ускорение НЕ подтверждено,
разные authority/history, не causal A/B. Тогда следующий cursor38 на тех же профилях;
устранять historical/native/ONION work и ACK latency, не переходить в UI/device.
Sustained availability,1–2s delivery, full/package/device и S05 acceptance
остаются открытыми; UI/production не затронуты.
[Matching evidence](../../deep-cli/docs/testing/cli-nts-activation-ack-2026-10-21.md).

Предыдущий fanout slice: исходные12 против6 ONION в full30 объяснены шестью
необходимыми Deposit acquisitions после expiry; duplicate Store не найден.
Shared suppresses только бесполезное live renewal с тем же current fixed
ceiling и всё ещё совместимой current PMA policy. Changed issuer/floor/window/
lifetime, pending exact successor, expired acquisition и Retrieve не пропускаются.
Focused42 Shared,67 CLI и scope6 PASS/native0, build0 warnings/errors — scoped
evidence, не full/package/device/S05 acceptance. Delivery31 PASS40; strict32/33
остановились на реальном NTS observation-quorum loss до ONION. Оба original
batch завершены recovery; final33 —49/49/native0,102/34 каждый, Active3/epoch2,
без reset/rekey. Latest fanout mean39.407s при6 вместо12 ONION, ACK21.889s
против21.671s full30: fresh first-attempt acceptance и global latency gain
не доказаны, authority/history conditions различаются. NTS availability и
оставшаяся native/ONION latency сохраняют S05 открытым; UI/device не затронуты.
[Matching source, receipts и замеры](../../deep-cli/docs/testing/cli-fanout-grant-attribution-2026-10-21.md).

Предыдущий bounded native-grammar audit: memo только после полного чтения и hash
actual bytes, invocation-local identity/ACK indexes; нет кеша authority/floor
или пропуска lease/file/currentness. Native historical-route selectors разделяют
одну полную SQL-проверку внутри синхронной read-транзакции, без await/callback;
outer fresh roots/Reconcile и Store rereads сохранены. Focused48 Windows,
107 Linux ARM64,31 DevOps,31 historical Shared +18 group-refresh Shared,
67 CLI PASS/native0. Fresh recipient private completion сокращает Store и
one-target ACK19→18 full joins каждый, не трогая cached replay/post-callback.
Три локальных узла
обновлены без reset. Cursor24/25 остановлены unavailable NTS authority Registry;
исходные batch завершены retained recovery, без подмены time policy/floor.
Новый26 —46/46 PASS,81/27 каждый, Active3/epoch2, без resumes/waits/retries.
ABBA на ТОЙ ЖЕ native истории: replay mean40.259→35.928s, CPU39.961→36.016s.
Full29 FAIL на final GSR control при EndpointPairDirectoryFloorAdvanced;
тот же batch завершён recovery52 PASS,90/30 каждый. Pre-control-effect
directory reacquisition теперь допускает один restart в independent scope
только после exact network history, обоих clocks и строго большего native
directory floor; прежние GSR/GSW не reauthor. Остальные/повторные отказы terminal.
Full30 на новом runtime —46/46 PASS/native0 без resumes/waits/retries/non-success
HTTP,93/31 каждый. Mean receive/ACK25.044→21.671s относительно28, но mean fanout
40.648→54.749s при6→12 ONION calls. Overall latency gain не доказан; native
history и холодные/authority условия различаются. S05 по этим данным не закрыт.
Это scoped constant-factor gain, не message latency, sustained acceptance
или доказательство1–2s. NTS redundancy требует supported signed source-list
update и mailbox-enabled activation, не ручной правки подписанных файлов;
[полные результаты и latency comparison](../../deep-cli/docs/testing/cli-retained-native-grammar-audit-2026-10-21.md).

Предыдущий node/CLI checkpoint2026-10-21: critical-path attribution отделил
native dispatch от ONION crypto/forwarding. Исправлены Registry IPv6-loopback
cold-connect penalty, exact lease-scoped ledger grammar reuse и per-chunk
WriteThrough только неопубликованного scratch; mandatory complete Flush(true)
до protected pending и все MAC/floor/lease/commit/file/dir fences сохранены.
Final focused34 Windows +67 Linux ARM64 +31 DevOps PASS/native0. Same3 CLI,
cursors20/21/22 —46/46 каждый;20 содержит1 owned ACK resume/wait и63.327s tail,
21/22 без recovery/waits/non-success/retries. Final69/23 каждый, Active3/epoch2,
без reset/rekey. Round19→22: fanout mean49.686→35.257s, ACK33.143→20.127s,
active cycle499.376→344.884s; ONION request counts8→6/14→12, поэтому это
successive retained workload, не controlled same-snapshot или UI latency.
**1–2s, sustained lifecycle и S05 acceptance остаются открыты.** Следующий slice —
измеренное сокращение O(history) native processing/repeated joins без whole-
authority cache и ослабления crash/security fences, не device/UI.
[Все операции, промежуточные FAIL/ограничения](../../deep-cli/docs/testing/cli-critical-path-latency-2026-10-21.md).

Предыдущий CLI checkpoint2026-10-21: same-format PKV2 KDF computation reuse
уменьшил повторный local open cost, без rekey/reset и без кеша verification.
Те же3 CLI: cursors17/18 —46/46 каждый,57 сообщений /19 local commands на
каждом, Active3/epoch2, без resumes/lease waits/non-success/retries.
Round16→18: fanout mean62.166→54.735s, полный active run579.018→494.601s;
ACK wall-time30.676→30.690s не улучшился, хотя CPU снизился. Следующая работа
в этом же S05 — измеренные ONION/authority stages и ACK latency, не device/UI.
[Все замеры и workload caveats](../../deep-cli/docs/testing/cli-prekey-open-latency-2026-10-21.md).

Предыдущий CLI checkpoint2026-10-21: DR-0159 same-peer route re-introduction
восстановил взаимно истёкшие XRA1/XUR1 без нового аккаунта/ratchet и без допуска
expired authority. Исходный retained cursor14 —49/49 PASS; последующие15/16 —
46/46 каждый на тех же трёх CLI. Cursor16 без owned recovery, cursor15 с одним
ACK resume/lease wait. Исходные batch/ciphertext, все шесть receive/ACK,
cold replay/dedup и пустые mailbox/GSR проверены. Это закрывает конкретный
retained mutual-expiry отказ, не весь offline/XUR service и не S05 acceptance.
Следующий срез — ONION/ACK latency, bounded uncertain-prefix lifecycle и
proactive renewal; signed/currentness/native guards не ослаблять.
Замеры и ограничения — [CLI checkpoint](../../deep-cli/docs/testing/cli-retained-route-reintroduction-2026-10-21.md).

**Подзадачи и владельцы:** deep-registry-api — current issuance/readiness/CAS;
deep-devops — lifecycle и наблюдаемость; xpoint-node-installer — retained-volume
restart/upgrade; deep-client-shared — bounded verified catch-up.
**Зависимости:** S01; connected gate требует S02/S03.

Подтверждённое физическое истечение первоначального XPI1 — блокер S05, не
повод создавать новый аккаунт. Перед connected contact/text завершить штатный
owned prekey lifecycle по [CONTACT-RESOLVER](CONTACT-RESOLVER-V1.md), §3.3:
пополнение инвентаря, signed predecessor/service succession при исчерпании
его срока и атомарная публикация обновлённого contact closure. Shared владеет
сохранением точных pending/committed поколений, старых секретов для уже выданных
claim/Initial и protected tip; Protocol — закрытым проверенным rollover boundary;
Registry/XNode — current-only admission и durable lineage. Любое недостающее
API/выделение сначала отдельно заморозить. Gate включает offline expiry,
cold reopen, lost publication response, competing successor, прежний pending
Hello и один эффект после восстановления. Таймауты и сроки старых подписанных
ресурсов не продлевать; reset/remint не заменяет этот lifecycle.

Использовать имеющийся private XMC2 issuer и permanent winner journal. Проверить
role signers, current proof/time и revocation; отдельно выполнить positive
issuance→client verify→node acceptance. Подготовить поддерживаемое authoring и
атомарное согласование signed PMA2 profile 2 / PMT2 successors с установленными
ключами. Без копирования root online, правки signed records, genesis/floor reset.

По [DR-0122](../survival-program/decisions/DR-0122-logical-mailbox-assignment-carriage.md)
разделить logical mailbox assignment/resource lifetime и короткий operational
carriage. Routine view/TLS/traffic-key renewal не должен перевыпускать каждый
контакт и накапливать retained read paths. Все текущие issuer/time/revocation/
holder/node checks сохраняются; changed epoch/cohort требует отдельного handover.

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

До приёмки этого этапа закрыть retained native PMA1/PMR1 source/package
dependency по reviewed current-owner mapping, без косметического переименования
MAU2/MCG2, пустых verified facts или потери account/device/reset/recovery guards.
Это обязательная dependency shipping graph по DR-0095, не parallel roadmap.

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
