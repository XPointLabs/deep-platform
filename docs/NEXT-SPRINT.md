# Текущий спринт: Deep clean break и XPoint public v1

В этом файле находится только незавершённая работа. Принятые архитектурные
решения находятся в [`architecture/`](architecture/README.md), завершённая
работа и доказательства — в [`SPRINT-HISTORY.md`](SPRINT-HISTORY.md).

## Итог спринта

Подготовить и физически подтвердить первый Android/Windows public release:

- новый несовместимый Deep account/device/database/wire generation;
- 24-word recovery и device-scoped ratcheted E2EE с PFS/PCS;
- arbitrary contacts без циклической зависимости от существующего PRA;
- 1:1 text/media, малые закрытые группы и WebRTC calls;
- XPoint exact three-hop routing через rotating masked access bridges;
- безопасный fresh install и reconnect после длительного offline;
- отсутствие Session runtime, DEV secrets, direct-MAU2 downgrade и
  неподтверждённых security claims.

Apple-клиенты не входят в этот спринт. macOS, iOS и Mac Catalyst CI/build
остаются отключёнными до отдельной явной команды Mr. X.

Первый production profile использует ровно три XNode, все три внутри одного маршрута.
Он не заявляет полностью disjoint fallback, независимых операторов или защиту
от общего ASN/provider failure. Direct P2P mesh и on-prem runtime выполняются
после первого релиза, но transport-neutral contracts ниже обязательны сейчас.
Рост до шести XNode отложен до готовности приглашать реальных пользователей;
сейчас он не является условием запуска и не маскируется логическими replicas.

## Нормативные входы

- [`architecture/README.md`](architecture/README.md)
- [`architecture/THREAT-MODEL.md`](architecture/THREAT-MODEL.md)
- `architecture/XPOINT-NETWORK-V1.md`
- `architecture/CIRCUMVENTION-CARRIERS-V1.md`
- `architecture/TRANSPORT-NEUTRAL-MESSAGING.md`
- `architecture/DEPLOYMENT-PROFILES.md`
- `architecture/V1-RELEASE-SCOPE.md`
- [`architecture/release-scope.v1.json`](architecture/release-scope.v1.json)
- [`architecture/release-scope.v1.schema.json`](architecture/release-scope.v1.schema.json)
- [`architecture/SESSION-PARITY-AND-SOURCES.md`](architecture/SESSION-PARITY-AND-SOURCES.md)
- `architecture/CONTACT-AND-GROUP-PROTOCOL-V1.md`
- `architecture/CONTACT-RESOLVER-V1.md`
- `architecture/ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md`
- `architecture/RETENTION-AND-RECOVERY-V1.md`
- `architecture/CALL-SESSION-V1.md`
- `architecture/PROTOCOL-REGISTRY-V1.md`
- `architecture/IMPLEMENTATION-PLAN-V1.md`
- [`survival-program/releases/v3.0.0/specs/DEEP-CRYPTO-V1-DRAFT.md`](survival-program/releases/v3.0.0/specs/DEEP-CRYPTO-V1-DRAFT.md)
- [`survival-program/decisions/DR-0006-pq-root-deep-id-clean-break.md`](survival-program/decisions/DR-0006-pq-root-deep-id-clean-break.md)
- [`survival-program/decisions/DR-0007-did2-resolver-read-capability-separation.md`](survival-program/decisions/DR-0007-did2-resolver-read-capability-separation.md)

Любая не определённая этими документами cryptographic transcript, state
transition, downgrade или trust source является блокером спецификации, а не
локальным выбором разработчика.

WP0–WP9 ниже задают milestone scope. Конкретная параллельная работа выдаётся
только по agent-sized package из `IMPLEMENTATION-PLAN-V1.md`; один агент не
получает целый multi-repository WP.

## Обязательный порядок исполнения

### Ритм вертикальных проверок

P0 выполняется по законченным пользовательским сценариям, а не по числу
изменённых файлов. Первый инкремент — DID2 contact/bootstrap и текстовое
сообщение Android↔Windows: публикация pre-key, атомарный claim, DPH2,
зашифрованная отправка, приём, durable inbox commit до ACK и повтор после
перезапуска. После него — тот же транспорт для изображения/файла с проверкой
целостности и возобновления; затем создание группы, доставка и смена состава.
Это порядок выполнения, не сокращение release scope.

Текущий исполняемый разрыв первого инкремента проверен по call path, а не
по готовности отдельных codec (2026-09-27):

1. Обычный `MauiProgram.Clean` всё ещё создаёт `DeepAccountRuntimeAccessor`
   и `DeepContactResolveRuntimeAccessor` старого поколения; DID2 account и
   nonce-bound contact proof существуют только в изолированном probe. Нужно
   заменить composition на DID2 owner и перевести сохранившийся визуальный
   chat/contact shell на его capabilities без V1 fallback.
2. XNode `ContactServiceRuntime.Decode` и `ContactServiceOpaqueFacade.ClaimAsync`
   читают `XPK1` через V1 `Xpk1Codec`; durable pre-key store принимает V1
   `XPI1/DPK2` и пишет `contact-service-v1`. Заменить один связанный
   publication/claim путь на DID2 `XPP1/XIC1/XPK1/XPC1`, новый несовместимый
   state generation и exact replay/CAS. Перед приёмом XPP1 нужен DID2-only
   DCR1/XPU1 publication и проверенный lookup service capability → exact
   recipient closure: `DeepIdV2PreKeyInventoryVerifier` не может принять
   XPI1/DPK2 без текущих DCR1 и nonce-bound DID2 directory authority.
   Не считать существующий V1 runtime E2E-доказательством DID2.
   DID2-only permanent resolver locator/read-key derivation и DCR1 V2 object
   protection теперь имеют внутренний fail-closed crypto candidate и локальные
   позитивные/негативные тесты. Внутренний XPU1/XPA1 V2 parser проверяет
   точный wire, hash/body binding и отказывает на V1; отдельный внутренний
   verifier проверяет XNA1 threshold signatures и failure domains. Следующий
   внутренний gate привязывает их к live DID2 ADH1/DTT1, XNA1 policy, view и
   полному доверенному интервалу времени; это ещё не проверка current account
   value/DCA1. Проверка route authority, placement, publisher signature и durable runtime
   остаётся открытой. Ни один из этих кандидатов не является device E2E.
3. Большой exact V2 `XPP1` нельзя просто отправить через ограниченный
   ContactResolve/replica RPC. Использовать уже существующий bounded
   authenticated replica transport как механизм доставки частей; authority
   возникает только после полной проверки собранного exact V2 `XPP1`,
   устойчивой фиксации обеих реплик и двух проверенных `XIC1`. Новый
   самостоятельный транспорт или прямой Registry pre-key endpoint не вводить.
   Закрытый V2 12-tag fragment codec/авторинг и негативный round-trip тест
   готовы; XNode operation-scoped durable reassembly/replay journal теперь
   структурно собирает exact aggregate, переживает restart, держит fork latch
   и карантин повреждённого состояния; operation scope теперь включает exact
   view/placement/service capability до первой записи. Его подключение к
   authenticated replica transport, DID2-only nonce-bound directory proof
   source (текущий XNode authority snapshot всё ещё ADP1 V1), проверка
   current authorization/lineage и runtime-проверка финальных `XIC1` ещё не
   готовы. Protocol уже проверяет exact пару подписанных `XIC1` против
   текущего NETCODEC placement и XPP1, но runtime/client её не потребляют;
   staged aggregate не является публикацией или доказательством E2E.
   Manifest-фрагмент V2 теперь несёт публичный exact DID2, связанный с каждым
   фрагментом общим commitment и сохранённый рядом с кандидатом после restart.
   Это только вход для собственного nonce-bound ADP1 V2 proof выбранной
   реплики, не подтверждённая личность и не готовый XIC1. Следующий шаг —
   подключить recipient-specific DID2 proof к runtime-verifier и отказать в
   commit, пока current DAB2/ADC1 V2 не совпадут с XPI1/DPK2.
   В XNode добавлен bounded HTTPS-запрос к существующему V2 Registry proof
   endpoint для exact DID2: wire связывает lookup/nonce/boot ID, HTTP-ответ
   проверяется по endpoint, типу, размеру и `no-store`. Он пока возвращает
   только сырые артефакты и не подключён к commit.
   Кандидат XNode reader теперь повторно аутентифицирует защищённый V2 head,
   запрашивает proof с собственной nonce/monotonic window, вызывает V2
   verifier и выпускает current-value capability лишь после CAS/durable head
   commit, повторного чтения и проверки свежести. Production-реализация
   rollback-floor store и DI ещё отсутствуют, поэтому это не runtime authority.
   Кроме pre-key, прежний `ContactVerifiedAuthoritySnapshotSource` также
   питает onion receive/placement и group control: его V1 ADP1 нельзя оставить
   как скрытый источник authority при DID2 cutover; заменить нужно общий
   snapshot-consumer граф, а не только один endpoint.
   XNode CI проверяет текущие protocol sources через source cutover, а обычный
   XNode NuGet pin ещё указывает на пакет до DID2 clean-break и не компилирует
   текущий runtime. Локальный пакетный cutover проверяет совместимость, но не
   является release evidence; перед выпуском нужен единый новый production
   package/pin/lock graph для всех потребителей.
4. Структурный V2 `XPC1` и отдельный verifier теперь проверяют обе подписи
   выбранных NETCODEC/PMT2 реплик для exact V2 claim tuple, но не доказывают
   публикацию inventory или durable claim. Следующий runtime gate —
   публикация/lineage, CAS/replay, затем DPH2/DAO1
   send/receive и inbox commit до ACK. Ни один из шагов не заменяется
   старым ContactV1 verified receipt.

Физический gate текста: два DID2-аккаунта на реальных Android и Windows,
текущий подписанный каталог, один текст в обе стороны, повтор после restart,
дедупликация/ACK после durable commit и отказ на V1/подменённом claim. Эти
наблюдения фиксируются только по текущим APK/Windows build и действующей
policy; локальный TestServer, эмулятор и старые UI-тесты не засчитываются.

Внутри инкремента запускаются быстрые точечные compile/unit/integration проверки
для изменённого security boundary; fail-closed, canonical wire и негативные
crypto-векторы проверяются до подключения runtime. Полный package/API/graph
gate и физический device E2E запускаются после связанного сценария и
исправления найденных дефектов, затем повторяются перед commit/push и
production promotion. Зелёный codec/unit test сам по себе не даёт права
включить production UI или заявить доставку сообщения.

### Фактический вертикальный gate после DID2 account/device-state (2026-09-25)

Физические Android и Windows DID2 probes подтвердили создание нового аккаунта,
перезапуск с тем же ID и удаление локально сохранённой фразы с сохранением ID.
Это **не** доказательство контактов или E2E сообщений: оба probe намеренно
account-only. Следующий блокер не следует маскировать зелёными тестами старого
клиента: `Dph2InitialClaimPreview.VerifyCurrentAsync` принимает только
`VerifiedAccountDirectoryFreshness` V1 и возвращает V1 checkpoint, тогда как
новый каталог выдаёт `VerifiedDeepIdV2DirectoryFreshness`/`VerifiedAdc1V2`.
Текущий DPH2 tag 20 и transcript/session-ID включают exact DID1: их нельзя
кормить DID2 или менять один тип без полного wire/transcript re-freeze.

Порядок P0 по [DR-0008](survival-program/decisions/DR-0008-did2-dph2-wire-clean-break.md):
(1) заморозить DID2-only DPH2/DAO1/contact-publication wire,
размеры, domain-separated transcript и negative vectors; (2) перевести
инициаторский и входящий claim/current-checkpoint verifier на exact DID2,
DAB2/ADC1 V2 и свежий DMD1 без dual-read; (3) связать проверенный current
proof с защищённым одноразовым device-agreement burn и durable DPK2;
(4) завершить DAO1 mailbox receive, contact-state/inbox commit до ACK;
(5) один Android↔Windows цикл contact → text → image/attachment → group на
одном закреплённом наборе policy/бинарников. До выполнения каждого gate
production UI сообщений остаётся fail-closed. Задействованы ровно три
production XNode; расширение до шести не требуется для этих проверок.

Дополнительный локальный safety fix: account admission повторно сверяет
monotonic freshness после асинхронного перечитывания аккаунта; сохранённый
rollback floor сам по себе не продлевает право использовать proof.
Для DR-0008 общий MessagingWire framing теперь умеет выбирать exact version
на уровне одного codec, причём version 1 и 2 взаимно отвергаются в тесте.
Ранее зафиксированный baseline DPH2 ещё не был переключён на version 2/DID2.
Локально закоммиченный кандидат перевёл wire tag 20, transcript и DAO1 размеры,
а также инициаторскую и входящую проверку current DID2. Он намеренно не предоставляет
production promotion смешанного V2 DPH2 с V1 DCB1/DCR1/XPC1/ContactHello;
старый Shared путь отправки и приёма остановлен fail-closed. Следующий gate —
единый V2 contact/prekey/ContactHello closure, затем машинный registry,
vectors и physical E2E. После удаления смешанных DID1 фикстур Shared production
suite прошёл 137/137, MAUI Clean.Tests — 19/19, оставшиеся MAUI SmokeTests
после удаления source-only проверок старого shell — 118/118;
это не заменяет package/public-API witness и device E2E. Основной
`MauiProgram.Clean`/`AppShell.Clean` всё ещё компонует `DeepAccountService`
старого account-пути; DID2 доказан только в отдельных account probes. Его
нужно перевести на DID2 до сквозной проверки сообщений и релиза.

NETCODEC теперь имеет отдельный DID2 freshness-вход для проверки и точного
восстановления XNV1/PMT2 network context. Общий внутренний контракт содержит
только подписанные ADH1/DTT1, ограниченный интервал времени и monotonic boot;
он не переносит V1 account/contact/message authority. Протокольный тест
подтверждает сетевой контекст и отказы на чужой сети и просроченном времени,
но использует изолированную time fixture: это ещё не публикация V2 XPC1 и
не доказательство физического contact/message E2E.

### ID-PQ-CB — корень Deep ID до продолжения production-сценария

Первый protocol/identity package выполняет [`DR-0006`](survival-program/decisions/DR-0006-pq-root-deep-id-clean-break.md):
новый ID с immutable genesis commitment к Ed25519 **и** ML-DSA ключам,
PQ-авторизованная succession и восстановление того же корня 24 словами.
Одного хэша расширяемого credential или последующего Ed25519-only добавления
PQ-ключа недостаточно. DID1/DAB1 v1 становятся negative fixtures, не dual-read.

Gate: выбрать и проверить один provider на Android arm64 и Windows x64/arm64;
заморозить recovery/KDF, canonical root credential, новые wire/suite/QR,
binding projections и все affected DPH2/DAO1/contact/DB vectors; доказать
cross-device restore, PQ-key-substitution/Ed-only forgery rejection и
отсутствие старого ID в production graph. До freeze нельзя считать текущие
green protocol tests и созданные UAT accounts release-compatible.

P0 внутри этого же clean-break: [`DR-0007`](survival-program/decisions/DR-0007-did2-resolver-read-capability-separation.md)
запрещает сырой resolver read capability в публичном DID2. Замена field 3 на
commitment, machine registry, transcript/negative vectors, зависимые wire
sizes и защищённый STORE-V2 завершены локально и прошли тесты. Следующий
обязательный gate — сбросить прежний UAT DID2, подтвердить неизменный адрес
после удаления фразы на обоих физических устройствах и повторить live
admission/proof без выдачи capability Registry. Только затем считать
контакты, сообщения, вложения и группы device E2E релизными.

2026-09-23: кандидат `ADL1` V2 теперь получает lookup key только из exact
DID2 и отвергает V1-версию/любой неподтверждённый lookup key; проверка
требует уже verified DAB2 binding. Добавлены изолированные V2 transition/map
primitives с отдельными доменами и ADC1 V2 reference, без допуска V1.
Это не активирует каталог: `ADP1`/admission, witness head и contact bundle
по-прежнему должны быть перевыпущены как единый DID2-only путь до device E2E.
Изолированный verifier first admission уже проверяет exact DID2/DAB2 и
ML-DSA подпись. Кандидат DGA1/DGR1 V2 wire закрыт и отвергает V1, но
admission service и proof publication ещё старые; до их clean-break
регистрация release-аккаунта остаётся заблокирована.
Отдельный V2 head author теперь проверяет полный приватный V2-журнал и
весь текущий набор ADC1 V2, применяет canonical batch и выпускает
threshold-signed ADH1 с `minimumReader >= 2`; он повторно проверяет
полученный protected head. ADH1 envelope сохраняет версию 1 только как
контейнер непрозрачных V2-корней. Это пока не service cutover: старые
admission/proof/freshness consumers и физический E2E остаются блокерами.
V2 proof-material author уже строит membership/non-membership и
append-log inclusion/consistency только после полного replay и проверяет
LKG как префикс V2-журнала. Тест с двумя реальными DID2 аккаунтами
фиксирует важный clean-break: `transition.nextMapRoot` раннего аккаунта
не равен финальному корню head; current sparse proof сверяется именно
с финальным корнем. Кандидат ADP1 V2 wire теперь несёт exact DID2/DAB2,
ADC1 V2, V2 transition и bounded sparse/append proofs; старый ADP1 V1
reader его отвергает. Он также передаёт полный отсортированный список
отозванных DCA authorization IDs (до 4096) и сверяет его с хэшем ADC1.
Кандидат публичного DID2 verifier теперь проверяет signed ADH1/DTT1,
nonce/monotonic currentness, direct-successor LKG consistency и полный
PQ-backed generation-zero current closure перед выдачей freshness capability;
ADP1 V1 отвергается. Протокольный тест с реальным PQ-аккаунтом теперь
проверяет следующий signed head с тем же current checkpoint и защищённым LKG;
отдельный negative test отклоняет неверный predecessor. Следующий signed head
с новой DID2 genesis-мутацией теперь проверен на двух PQ-аккаунтах: первый
остаётся current по финальному двухлистному map root, второй разрешается из
того же защищённого floor; неполный journal отклоняется. Это protocol-level
evidence, не service/client cutover. AFP1 forward history и физический E2E
ещё не готовы.
2026-09-25 device-кандидат подтвердил границу: Android-аккаунт прошёл DGA1
admission, но genesis LKG не смог получить fresh ADP1 после истечения
промежуточного ADH1. На отдельном UAT-контуре, не меняющем публичный
Registry, с независимым PostgreSQL floor Android физически проверил подписанный
proof и повторил его после перезапуска приложения; floor остался неизменным.
Второй Windows-аккаунт прошёл внешний HTTP/proof-тест, но аудит этого catch-up
выявил критичную семантическую ошибку: Registry подписывал свежим DTT1
промежуточный ADH1, уже не являющийся последним. Такой результат нельзя
выдавать за current freshness даже если последующий proof дошёл до конца.
Оба loopback-canary остановлены с сохранением ADA2 и floor; публичный Registry
не переключался. Исправление возвращает fail-closed при пропуске поколений и
добавляет тест, что historical head не получает новый current DTT1.

До public cutover нужен P0 root-authorized AFP1/ADF1-equivalent именно для
DID2 V2: зафиксировать wire, source-LKG membership, точную authority/checkpoint
lineage, текущий target ADH1 и root-threshold signatures. Прямой ADF1 к
каждому новому ADH1 не годится для production: offline root не должен
подписывать каждый admission. Нужен ограниченный exact successor-tail от
периодического root checkpoint до последнего DTT1-bound head с отдельными
negative vectors. ADP1 V2 mode 2 / anchor-AFP1 + exact ADH1 tail уже имеет
протокольный тест защищённого floor из более позднего ADF1 через отдельный
source-checkpoint index и membership proof. Registry issuer с импортом только
подписанного ADF1 и клиентский защищённый LKG прошли локальный интеграционный
сценарий двух аккаунтов. Initial ADF1 offline author теперь покрывает весь
непрерывный подписанный ряд от пустого genesis до непосредственного
предшественника target ADH1: только genesis недостаточен для уже созданных
устройств. HMAC/PQ-проверенные export текущего ADH1 и manifest полного
covered-head ряда, а также операторский no-content successor refresh с
PostgreSQL floor CAS реализованы; локальный PostgreSQL-тест refresh и rollback
прошёл. На изолированной машинной пробе refresh до поколения 4 сверился с
независимым floor; offline-root ADF1 над полным набором поколений 0–3
импортирован только в отдельный loopback-canary. Физический Android-клиент
догнал актуальный proof и повторил проверку после перезапуска с сохранённым
protected LKG. Windows device proof, независимые machine negative vectors и
device E2E ещё нужны. Нельзя переподписывать старый head
как текущий, продлевать его срок, сбрасывать защищённый LKG или объявлять
multi-hop direct-successor заменой checkpoint. Затем повторить физический
Android/Windows E2E контактов, сообщений, вложений и групп; они пока не
подтверждены.
Публичный freshness API принимает типизированный ADL1 V2 query: для собственного
аккаунта он сверяется с independently verified DAB2, а для peer discovery — с
точным запрошенным DID2. В обоих случаях DID2-derived leaf, сеть authority,
generation/hash защищённого floor и совпадение DID2 в возвращённом current
checkpoint обязательны. Сырой leaf допускается лишь во внутреннем self-check
issuer; чужой DID2 и неверный floor отвергаются.
Клиентский peer lookup теперь также требует, чтобы компактный Deep ID
криптографически совпал с точным DID2, полученным из будущего DCB1/XIR1
closure; подмена отклоняется до сетевого запроса. Локальный интеграционный
тест двух PQ-аккаунтов прошёл, но получение exact DID2 через контактную
публикацию, сохранение контакта и доставка сообщений ещё не реализованы.
Отдельный Windows x64 тест теперь выпускает настоящий ML-DSA-backed DID2,
строит подписанные ADH1/DTT1 и ADP1 V2 с Merkle-inclusion/consistency,
затем получает positive freshness capability; это protocol-level тест, не
device E2E и не доказательство готовности registry service.
Отдельный DID2-only proof issuer теперь берёт только проверенный V2 journal/map
material, подписывает nonce-bound DTT1 и self-verifies ADP1 V2 тем же proof
verification core через внутренний raw-leaf путь issuer. Публичный reader
дополнительно требует verified ADL1 V2/DAB2 query. Проверены positive real-PQ
выпуск и отказ при чужом head/дублированном
witness; Registry durable ADA2 и HTTP publication затем добавлены как
изолированный UAT-кандидат, но production gate остаётся закрытым ниже.
Registry API вместе с XNode пока имеет двойной build graph: обычный
`dotnet test Deep.Registry.Api.slnx` тянет старый protocol NuGet и не
собирается, а `-p:DeepProtocolLocalCutover=true
-p:DeepProtocolSourceCutover=true` теперь проходит 410 тестов. Следующий
clean-break должен единообразно перевести весь transitive XNode graph на
текущий source/package pin; локальное изменение только registry defaults
недостаточно и не должно попадать в релиз. XNode ProfileGenerator содержит
отдельный замороженный P14C offline package/restore gate: пробное изменение
его default props нарушило 6 из 107 тестов этого gate, хотя 231 unit и 373
integration XNode теста прошли. Пробная правка полностью откатана; сначала
нужен отдельный review/rebaseline этой frozen evidence, затем единый default
source graph без старого пакета.
Legacy Registry authority теперь жёстко допускает только reader V1:
подстановка `SupportedReader=2` не включает DID2 и отклоняется на старте.
Следующий service cutover требует отдельного V2 bootstrap head с пустым
V2 map root, нового защищённого durable state и V2 admission/proof HTTP;
старый ADA1 state не мигрировать и не читать как V2.
Протокольный bootstrap verifier уже восстанавливает только точный
threshold-signed zero-head с V2 empty-map root и reader ≥2; V1 empty root,
reader 1 и неверный protected hash отклоняются. Подключение к новому
Registry durable state остаётся следующим шагом.
Registry имеет отдельный file bootstrap source с независимым protected core
hash pin и V2 verifier; он не подключён к HTTP/admission и не читает ADA1.
Кандидат `ADA2` payload codec отдельно хранит V2 heads, transitions и exact
DGA1 V2 requests, ограничивает размеры и отвергает ADA1/чужую сеть. Decode
остаётся shape-only: перед выдачей authority service обязан HMAC-verify state,
повторно проверить подписи всех heads и PQ admission, replay V2 journal и
связность истории; endpoint ещё не активирован.
Кандидат ADA2 restorer проверяет pinned genesis, каждую подписанную голову и
prefix журнала, duplicate operation/leaf, PQ admission и final root перед
повышением строк до authority-owned состояния. ADA2 file store требует явного
начального provisioning, HMAC до decode и lease через read/append-only write;
удаление state не превращается в молчаливый genesis. Проверка отклоняет
admission с временем в будущем относительно trusted upper bound.

2026-09-23: точный Linux x64 ML-DSA CI-бинарник добавлен в protocol NuGet с
SHA-256 pin; managed DID2/DAB2/ADP1 V2 tests прошли в GitHub CI на Linux x64,
Windows x64 и Windows ARM64. Это всё ещё candidate, не окончательный provider
approval. Registry получил отдельный verified XNA1/DTS1 source от pinned
genesis, не зависящий от ADA1/ADP1 V1, и V2-only durable admission service:
реальный PQ DGA1 V2 добавляет одну ADA2 transition и threshold-signed ADH1,
повтор после рестарта возвращает тот же receipt, подмена operation ID/leaf
отклоняется без мутации. Отдельный `/api/v2/account-directory/genesis-admissions`
имеет V2 media type и включается только явной конфигурацией; одновременное
включение V1 admission запрещено. Однократный операторский
`did2-directory provision-state` создаёт только проверенный пустой ADA2 и
отказывается перезаписывать существующий state. Endpoint пока **не включён
в проде**.

2026-09-24: внутренний Registry DID2 proof issuer теперь под lease читает
полностью PQ-перепроверенный ADA2 journal/map и выпускает живой DTT1/ADP1 V2
из trusted time, signed XNV1, durable one-use nonce и threshold custody.
Реальный PQ admission → ADA2 restore → current-value proof пройден в тесте;
replay nonce, V1 floor и повреждённый XNV1 отвергаются. Все 403 локальных
Registry/XNode теста прошли. Это **не** публичная proof publication:
самостоятельно защищённый latest-head floor, query binding с verified DAB2 и
клиентский reader остаются release gates.

2026-09-24: protocol candidate `DPQ2`/`DPP2` ограничивает exact ADL1 V2 +
DID2 request и ADH1/DTT1/ADP1 V2 response; неверный DID2-derived lookup,
V1 wire, replay echo и подмена proof отвергаются. Registry issuer принимает
этот wire, разрешает floor только из собственного ADA2 head lineage и
возвращает exact V2 response. Production-маршрут остаётся заблокированным:
нужны rollback floor вне ADA2 и независимая клиентская верификация.
Development/UAT `POST /api/v2/account-directory/proofs` теперь можно отдельно
включить после provisioning exact XNV1 и собственного one-use nonce ledger;
реальный PQ HTTP roundtrip и replay-rejection проверены локально. Это не
production path: сервер по умолчанию закрыт, а production opt-in требует
явного cutover attestation, proof endpoint, удалённого PostgreSQL floor с
VerifyFull TLS и успешного startup-read ADA2 против этого floor.
Изолированный клиентский DPQ2/DPP2 fetcher теперь требует verified DAB2-bound
ADL1 V2, XPoint authority и восстановленный из защищённого V2 store LKG,
затем проверяет nonce, boot-stable monotonic window и полный PQ-backed proof.
Freshness capability не возвращается до успешного durable CAS следующего LKG.
У DID2 account owner теперь есть реальное account-scoped SQLCipher-хранилище
этого LKG: оно начинает только с отдельно закреплённого signed empty V2 head,
восстанавливает его после restart, проверяет подписи/сеть и атомарно делает
CAS следующей головы под общим lease аккаунта. Отдельный add-only защищённый
маркер для каждой ревизии закрепляет exact hash подписанной головы и SQL
revision; следующий маркер пишется до SQL commit, поэтому потеря или откат
SQL-строки закрывается, а crash между двумя записями требует явного
восстановления/сброса вместо
молчаливого принятия старого floor. Тесты подтверждают signed bootstrap,
reopen, exact replay, stale-writer rejection и отказ при откате на старую
корректно подписанную голову, повреждении или удалении строки. DPQ2/DPP2
клиент также заново проверяет boot и TTL после durable CAS,
прежде чем вернуть freshness capability. Полный положительный HTTP proof →
SQLCipher CAS → Contact consumer всё ещё не проверен; клиент не подключён к
MAUI, а Registry production proof endpoint закрыт. Это обязательный client
cutover, а не повод считать E2E пройденным. Маркеры защищают только от
SQL-only rollback при сохранённом secure storage: совместный rollback обоих
хранилищ требует независимого floor, а текущий journaled secure storage
ограничен 128 слотами. Масштабируемый независимый якорь и восстановление
после crash между маркером и SQL commit остаются release gates.
У ADA2 store добавлена точка интеграции независимого latest-head floor:
чтение сверяет полностью восстановленный signed head, запись продвигает
внешний floor **до** замены ADA2 и при несогласованности закрывается. Тесты
подтверждают отказ при откате и отсутствие записи при ошибке floor. Пути
admission и proof issuer теперь передают одну DI-зависимость floor в ADA2
store; интеграционный тест отвергает старую корректную HMAC-копию на обоих
путях. Реализован opt-in PostgreSQL provider с точным network-bound CAS,
явным однократным provision genesis и fail-closed при отсутствии строки/БД.
Тест с отдельным локальным PostgreSQL проверил повторный provision, stale head
и restart. 2026-09-24 floor отдельно развернут на production seed2 с
single-source firewall, частным VerifyFull TLS, раздельными ролями и точной
genesis-строкой. Согласованный дамп восстановил exact signed head в отдельном
временном PostgreSQL. Это ещё не Registry cutover: outage/old-ADA2 startup
drill, полное восстановление ролей и device E2E остаются gate; opt-in provider
не является разрешением релиза.

2026-09-24: положительный локальный Registry↔client-shared тест впервые
замкнул create DID2 → DGA1 V2 admission → nonce-bound DTT1/ADP1 V2 proof →
durable SQLCipher latest-head CAS. Он выявил нулевой после ответа TTL DTT1:
Registry ставил `expires-at` равным верхней границе uncertainty, из-за чего
следующая монотонная секунда клиента всегда отклонялась. Issuer теперь
выдаёт bounded срок до 30 секунд от authenticated observation, обрезанный
epoch/XNA1/DTS1/ADH1; тест проверяет положительный путь и истечение. Это не
заменяет UAT/physical E2E и не открывает production endpoint.

Следующий обязательный пакет: startup-read текущего ADA2 против production
floor только с runtime-ролью; проверка отказа при outage и откате старого
ADA2 после первой реальной admission; полное восстановление ролей, затем V2
admission/proof на реальном контуре и клиентский cutover. Поскольку пустой
genesis ADH1 имеет ограниченный срок, до релиза нужен проверенный механизм
продления подписанного head даже без новых аккаунтов — иначе после истечения
срока Registry обязан закрыться. Клиентский cutover
не является заменой одного поля ID или экрана: текущие `DeepAccount` и
`IDeepAccountStore` хранят `DeepPermanentIdV1`, а genesis activation выпускает
DAB1/DCA1/ADC1 V1. Нужны новая несовместимая account/store generation,
атомарно сохраняемая и восстанавливаемая точная DID2/DAB2/DMD1/DCA1 V2/ADC1 V2
closure, V2-only admission/proof reader с independently verified DAB2 и
отдельный reset прежнего UAT state; старый V1 reader нельзя оставлять как
fallback. Сначала подтвердить offline create/restore и живой UAT admission с
отрицательными replay/rollback тестами, затем physical Android ↔ Windows
account/contact/message/media/group E2E. GitHub Releases не публиковать.

Аудит клиентского кода подтвердил, что замена только `PermanentId` невозможна:
`deep.store.v1` namespace и generation, защищённый genesis contact slot,
`DeepGenesisDeviceActivation`, V1 admission и MAUI Contact/Group composition
связаны одной старой цепочкой. Порядок их несовместимой замены и проверка
сохранённого exact DAB2 после удаления фразы закреплены в `ID-PQ-CB`
implementation package; до этого старый UI account-create не release evidence.

2026-09-24: в `deep-client-shared` добавлен изолированный кандидат V2-only
защищённого genesis-contact слота. Он принимает только уже проверенные
DAB2/DCA1 V2/ADC1 V2, сохраняет exact DPA1/DRS1/DPD1/DMD1/DID2/DAB2/
DCA1 V2/ADC1 V2 публичную closure одной add-only записью. Raw-чтение
возвращает лишь непроверенные байты; отдельное verified-чтение восстанавливает
DPA1/DRS1/DPD1 через protocol admission verifier с прикреплённым ML-DSA
verifier и повторно проверяет всю V2-цепочку.
Повторная запись того же набора допустима, иной hedged DAB2 — конфликт.
Это ещё не account cutover: атомарный V2 bootstrap/reset, MAUI composition
и физический E2E остаются обязательными.
Отдельный V2-only add-only слот теперь хранит четыре секрета genesis-устройства:
запись/восстановление возможны только при совпадении с проверенным DPD1
(ключи, device ID, revocation handle и account scope). Двухслотовый bootstrap
теперь fail-closed при любой частичной записи, а точный retry завершает её;
локальная authority выдаётся только после полного verified read-back.
Изолированный V2 owner уже владеет reset/purge; связывание с новым account
service/MAUI без чтения V1 namespace остаётся открытым.
V2 protected phrase slot теперь сверяет 24 слова с exact account ID;
удаление требует повторного verified bootstrap и оставляет add-only tombstone,
чтобы старый writer не вернул фразу. При сбое после tombstone чтение очищает
оставшиеся байты. Интерфейс secure storage и оба production adapter теперь
поддерживают идемпотентный purge только точного префикса `deep.store.v2.`;
V1 и соседние слоты сохраняются. Открытие фразы в настройках и MAUI
account/reset composition ещё не готовы; изолированный V2 owner уже вызывает
purge при явном локальном reset.
DXP1 issuance persistence получил явный выбор store generation: текущий V1
client остаётся на V1, а DID2 fixture выдаёт устройство только в V2 namespace
и проверяет отсутствие V1 profile slot. Полный новый account owner должен
выбирать этот V2 режим без fallback.
Изолированный offline DID2 issuer теперь создаёт один реальный PQ-backed
genesis-аккаунт целиком в V2 protected namespace: DPA1/DRS1/DPD1, exact
DID2/DAB2, DMD1/DCA1 V2/ADC1 V2, фраза, DXP1 и verified bootstrap. Тест
открывает тот же DID2/DAB2 новым экземпляром bootstrap и после удаления
фразы. Отдельный add-only V2 current-account index теперь публикует
нормализованное имя, network и account ID только после полного verified
bootstrap; чтение повторно проверяет всю closure, partial state и замена
winner отвергаются. Изолированный V2 protected-state owner теперь держит
межпроцессный файловый lease и атомарно ставит creation-intent с именем и
candidate account ID до записи секретов. Если exact public closure уже durable,
но index не записан, новый owner проверяет полный bootstrap и публикует тот же
DID2/DAB2; reset до восстановления winner запрещён. Без public closure
прерванное создание допускает только явный V2 reset. Journaled-store тесты
проверяют оба повторных открытия. Чтение и удаление фразы проходят через
lease владельца; deletion marker переживает повторное открытие без смены
DID2/DAB2. Если public closure durable, но device secrets incomplete, reset
также запрещён; exact repair этого состояния остаётся открытым перед UI.
Изолированный V2 owner теперь создаёт до публикации index отдельную SQLCipher
`DSV2` generation: защищённый V2 ключ и instance ID, атомарные account/device/
profile rows и пустые LKG/outbox/inbox/security-event roots. После публикации
каждое чтение сверяет exact DID2/DAB2/device projection и схему; потерянная
база не создаётся заново. Pre-index pending SQL восстанавливается из той же
verified closure, явный reset удаляет только V2 database family и namespace.
Фокусные проверки покрывают зашифрованный файл, journaled-key restart,
wrong scope/generation, повреждённый pending и отсутствие базы/ключа.
Полный mutable STORE-01 с in-memory parity и restore-as-new-device, MAUI
composition, contact transport и physical device E2E остаются открыты — это
ещё не завершённый клиентский clean-break.
Публичный network-free `DeepIdV2AccountService` поверх этого owner предоставляет
создание по имени, проверенное повторное открытие exact DID2, доступ к
удержанной recovery-фразе, её необратимое удаление и только явный V2 reset.
Он ещё не является MAUI production composition: старый V1 account runtime
нельзя частично подключать к новой DID2 учётной записи. Выбор ML-DSA
verifier lease обязан быть явным в composition; CI candidate provider не
считается автоматически одобренным production provider.

2026-09-24: отдельный Debug/UAT MAUI DID2 account-only probe теперь создаёт
аккаунт одной кнопкой без V1 runtime. На физическом Android проверены создание,
неизменный DID2 после перезапуска, показ и скрытие 24 слов, удаление сохранённой
фразы через UI и сохранность ID после повторного запуска; секретный текст не
попал в evidence. Результат и границы проверки — в
[`deep-client-maui/docs/DID2-ANDROID-ACCOUNT-GATE-2026-09-24.md`](../deep-client-maui/docs/DID2-ANDROID-ACCOUNT-GATE-2026-09-24.md).
После DR-0007 тот же изолированный Android probe отверг старый DID2,
сбросил его через подтверждение в приложении и подтвердил неизменный новый
Deep ID после перезапуска и после удаления фразы с ещё одним перезапуском.
На первом просмотре Windows ARM64 probe показал существующий тестовый аккаунт
и элементы управления recovery-фразой в отдельном окне; тогда создание и
сохранность после перезапуска не проверялись. См.
[`deep-client-maui/docs/DID2-WINDOWS-PROBE-2026-09-24.md`](../deep-client-maui/docs/DID2-WINDOWS-PROBE-2026-09-24.md).
После явного сброса несовместимого изолированного probe оператором новый
Windows DID2 сохранил тот же 90-символьный идентификатор при перезапуске и
после пересборки текущего исходного commit; фраза осталась скрытой.
Наблюдатель не видел само создание аккаунта, поэтому проверка Windows
creation UI остаётся открытой, а подтверждена только restart continuity.
Оба результата не активируют production DID2 composition и не доказывают
контакты, сообщения, вложения или группы. Следующий сквозной gate — exact
DID2/DAB2 public closure, contact/QR/XPK consumers и Android→Windows text
delivery с durable inbox/ACK; legacy V1 runtime к DID2 probe не подключать.

После DR-0007 account owner теперь формирует из проверенной сохранённой
closure точный DGA1 V2 с фиксированным для genesis operation ID. Побайтная
идемпотентность после удаления фразы и отсутствие сырого resolver capability
в публичном запросе проверены тестом. Отдельный DID2-only HTTPS-клиент теперь
отправляет только `/api/v2/account-directory/genesis-admissions`, ограничивает
размер и время ответа и сверяет operation/leaf/network в DGR1. DGR1 остаётся
недоверенной квитанцией: живой admission, независимо аутентифицированный
ADH1/DTT1/ADP1 proof и их связка с отдельной DID2 MAUI composition ещё не
проверены; V1 fallback запрещён.
Клиентская account-owned последовательность теперь принимает DGR1 только как
недоверенную квитанцию, авторит ADL1 V2 из защищённого V2 floor и проверенного
DID2, требует независимо верифицированный current-value ADH1/DTT1/ADP1 V2,
сверяет exact DID2/DAB2/ADC1 с локальным genesis и повторно проверяет локальный
аккаунт после сети. Тест с HTTP 200 DGR1 и недоступным proof остаётся
fail-closed. Это локальный API gate, а не живой UAT admission или device E2E:
в текущем dev Registry DID2 admission/proof не включены, а MAUI probe ещё не
композирует сетевой путь.
Registry operator теперь может из точной проверенной XNA1/DTS1 и существующего
threshold witness custody один раз выпустить пустой подписанный V2 ADH1,
проверить его и вывести только core-hash для независимого pin перед ADA2
provisioning. Это устраняет ручную тестовую подпись головы, но не заменяет
отдельный UAT deployment, rollback floor или device E2E.
2026-09-24: production custody Mr. X локально выпустила отдельный подписанный
пустой DID2 ADH1 при сохранённом genesis XNA1 pin. Core hash независимо
перепроверен и закреплён; из него создан HMAC-защищённый пустой ADA2.
Защищённые файлы staged на Registry-хосте, а exact ADH1 единожды записан в
отдельный production floor через provisioning-роль. Повторная запись закрыта.
Новый Registry image собран CI и проверил head; публичный Registry ещё не
заменён. Отдельная loopback-only UAT-канарейка 2026-09-24 приняла реальный
PQ-backed DID2 genesis и выдала независимо проверенный current proof;
защищённый клиентский LKG и внешний PostgreSQL floor перешли к tree size 1.
Актуальные ADA2 и floor dump сохранены локально с проверкой хэшей. Отдельный
непубликуемый Production-mode процесс отверг старый ADA2 при старте из-за
несовпадения с floor, тогда как контрольный процесс с текущим ADA2 стартовал.
Изолированный Production-mode процесс без сети также не стартовал из-за
недоступного PostgreSQL floor. Это не physical device E2E и не production
cutover: полный role-recovery drill, подключение Windows/Android и транспорт
сообщений остаются обязательными.
Изолированный трёхузловой first-release local image build прошёл после
обновления локального Protocol package graph/pins; XNode unit gate 231/231 и
runtime build без предупреждений. `Up` пока fail-closed на отсутствующем
независимом genesis XNA1 pin/полном подписанном artifact inventory у Registry.
После диагностики launcher стал отвергать отсутствующий pin до Docker build.
Неисправный изолированный контур остановлен с сохранением volumes; работающий
survival dev и production не тронуты. Это не DID2 admission и не device E2E.
Production custody Mr. X одноразово дополнена отдельными mailbox deposit и
retrieve issuer-ключами; существующие десять ролей и offline root не
ротировались, старый публичный manifest сохранён для аудита. Локальный
bootstrap/deployment и device E2E этим ещё не подтверждены.

2026-09-23: изолированный `deep-protocol/eng/Deep.MlDsa.ProviderProbe`
подтвердил на Windows arm64 воспроизводимый ML-DSA-65 public key из 32-byte
seed, подпись и rejection подмены сообщения/ключа. Это **не** provider approval:
проверенный Bouncy Castle 2.7.0 не даёт deterministic disposal для объекта
private key с внутренними `byte[]`. Поэтому production-кандидатом выбран
native provider с Deep-owned ABI и вызовом без долгоживущего expanded secret.
Production issuance DID2 должна оставаться заблокированной до provider
acceptance и полного cutover; старый DID1 не является fallback.

Выбранная библиотека (ещё **не** production-accepted provider) —
[`mldsa-native` v2.0.0](https://github.com/pq-code-package/mldsa-native/releases/tag/v2.0.0):
это тот же PQ Code Package family, что уже выбранный `mlkem-native`, с
портативным C backend, seed-driven keygen и upstream ACVP/Wycheproof gates.
Pin исходника: `834a90d5e846ffa1e1611bd24e160bb2e9b86d35`;
это не approved binary/asset pin для релиза.
Использовать одну узкую Deep-owned native ABI/asset discipline, как для
ML-KEM; не добавлять параллельный runtime provider или алгоритмический suite.
Перед допуском нужны pin/source hash, license/SBOM, zeroization review,
cross-provider KAT и физические Android arm64/Windows x64/arm64 прогоны.
Локальный Windows ARM64 SDK здесь не содержит полного MSVC C include/lib
toolchain. Изолированная Linux/ARM64 Docker-сборка того же pinned source
прошла upstream `run_func_65` и `run_kat_65` (`META.yml ... kat-sha256: OK`).
BC 2.7.0 и `mldsa-native` v2.0.0 дали один SHA-256 public-key fixture
`d666806e11cee19a7c989f7445f90dd419cf4d2d51db8c0fdb4c0f0a542238c9`
для публичного seed `00..1f`. Это первый cross-provider keygen check; более
поздние физические Android/KAT/signature результаты приведены ниже.

2026-09-23: vendored source snapshot и узкий Deep-owned C ABI добавлены в
`deep-protocol/native/Deep.MlDsa` вне production package graph. На Linux
ARM64 прошли CMake/CTest; на физическом Android API 31 arm64 прошли те же
native ABI tests. Тестовый бинарник удалён с устройства. В CI добавлена
матрица Linux/Windows x64/arm64, но она ещё не запускалась из GitHub.
Отдельно на физическом Android загружена `libdeep_mldsa.so` с ровно восьмью
Deep-owned экспортами; тесты прошли и библиотека удалена с устройства.
На публичном фиксированном seed детерминированная подпись native Android и
Bouncy Castle Windows ARM64 дала одинаковый SHA-256 (fixture в
`eng/Deep.MlDsa.ProviderProbe`); это один cross-provider transcript. Pinned
upstream ML-DSA-65 KAT (`META.yml` SHA-256) дополнительно прошёл в CMake/CTest
Linux ARM64 и на физическом Android ARM64. Deep-owned ABI также прошёл 70
применимых официальных ACVP `v1.1.0.43` cases на Linux ARM64: 25 keygen,
30 seed-format pure signing и 15 verification (3 positive/12 negative).
Те же 70 ACVP cases прошли в `net10.0-android` Release/AOT APK на физическом
Android ARM64 с exact candidate `.so`; APK удалён. Остаются Windows ACVP gates,
расширенный независимый signing differential,
zeroization/side-channel review и wire cutover DID2/DAB2 перед клиентским E2E.
Изолированный probe также прошёл ABI, public/signature fixture, verify/tamper
и native zeroization. Это ещё не production asset/MAUI integration, и Windows
platform gate остаётся открытым.

Локальный Windows ARM64-хост собрал Windows x64 candidate с MSVC 19.44;
оба CTest (Deep ABI и upstream KAT) прошли под x64-эмуляцией. Это не
физический x64/ARM64 acceptance и не ACVP Windows: доступный Python ARM64
не загружает x64 DLL. Sanitized evidence — в
`deep-protocol/native/Deep.MlDsa/evidence/windows-x64-emulated.v1.json`.

2026-09-23: отдельная V2 PQ-root деривация из той же проверенной 24-словной
фразы зафиксирована в нормативном crypto profile и реализована как внутренний,
пока не активируемый production API. Независимый Python digest-вектор
проверяется .NET-тестом для Ed25519 seed, ML-DSA-65 seed и resolver capability;
V1 public-address capability отделена. Это закрывает только recovery-KDF,
не genesis commitment и не DID2/DAB2. Создание нового release-аккаунта,
проверка сообщений/вложений/групп device E2E и выпуск клиентов остаются
заблокированы до атомарного wire/consumer clean-break и platform gates.

### CB0 — production clean-break до новой feature-работы

После ID-PQ-CB следующий production-graph package закрывает destructive
clean-break. Не создаётся `LegacyV1`, migration-only runtime, feature
flag, dual reader или автоматический fallback. Нужно:

- удалить из production project/package/runtime graph Session-derived
  identity, `05...`/`SessionId`, 13-word recovery, DPE1/DMC1 sealed-box,
  revision-only group state, plaintext Registry call signaling и старые
  contact/mailbox paths;
- удалить production-использование Ed25519↔X25519 conversion;
  signing, agreement, onion traffic и session keys имеют разные
  независимые lifecycles;
- заменять каждый удалённый caller только закрытым Deep-native
  contract из соответствующего package; временный adapter, mock
  authority или публично forgeable capability запрещены;
- до активации E2EE-01 выполнить
  [`DR-0005`](survival-program/decisions/DR-0005-inbound-dph2-claim-evidence.md):
  заменить event-only initial DPH2 payload на encrypted exact XPK1/XPC1
  claim transcript плюс DMC2, обновить векторы и production verifier.
  Старый initial payload отвергается, без dual decoder или fallback;
- перевести mailbox holder/authentication boundary без compatibility-слоя:
  `MAU2/MCP2/MCG2` сохраняются только как transport authorization wire, но
  production holder является новым случайным reachability-scoped Ed25519 key
  из account-owned protected storage. `SessionId`, session public key,
  synthetic `05...` alias, recovery phrase и device signing key не являются
  mailbox holder identity. Краткоживущий current-epoch MCG2 grant выдаётся
  только через privacy-routed `XMG1/XMC1` по exact verified XRR1 capability;
  старый direct Registry enrollment/JSON invitation path удаляется;
- активировать clean-break Contact publication chain
  `XRA1 -> PMS2/XRC1/XSS1 -> XRR1/XIR1 -> DCB1/DCR1 -> XPA1/XPU1`:
  до runtime activation атомарно re-freeze DCB1/DCR1 вместе с XIR1→DCA1
  ArtifactRef/version/signature input, ADL1 V2 и exact DID2/DAB2; простая
  замена DID1-полей DCB1 создаёт недопустимый смешанный V1/V2 closure;
  изолированный XIR1 V2 codec уже отклоняет старые version/suite/reference,
  проверяет exact DCA1 V2 hash и подпись активного issuer device. Он не
  авторитативен для публикации без XRA1/PMT2, DCB1/DCR1 и V2 resolver
  closure; физический E2E этим тестом не закрыт;
  изолированный DCB1 V2 candidate теперь проверяет exact DID2/DAB2/DCA1 V2,
  DID2-derived ADL1 V2, XIR1 V2 descriptor, bundle issuer и подпись, а также
  current device-signed XPS1 descriptor для каждого active DMD1 device.
  XPI1/DPK2 inventory, route/placement, DCR1 freshness и publication
  authority остаются отдельными обязательными gates; старый DCB1 V1 не
  является fallback reader;
  изолированный DCR1 V2 codec проверяет exact DCB1 V2 и закрытый, строго
  упорядоченный набор DRS1/DPD1 для всех DMD1 devices, а promotion требует
  byte-identical verified custody. Это ещё не ADH1/ADP1 freshness, XPI1/DPK2 inventory,
  ContactResolve publication или physical E2E;
  изолированный DID2 XPI1 manifest binding теперь принимает только version 2,
  suite 0x0301 и отдельные V2 signing/hash domains, отклоняя прежние V1
  байты и подписи; он сверяет exact DCR1 V2/XPS1/DMD1/DRS1 и подпись
  responder DPD1;
  изолированный DPK2 V2 decoder/member binding отвергает старые version/suite
  и подписи, сверяет DID2 account, DPD1/agreement, DMD1 head, XPS1 generation,
  XPI1 epoch/window и три device signatures; отдельная проверка полного
  inventory сверяет порядок, exact DPK2 hashes, V2 Merkle root, last-resort
  hash и XPS1 reuse bound. Durable publication этим не доказана;
  DID2 account-owned pre-key author теперь выпускает one-time и last-resort
  DPK2 version 2/suite 0x0301 с тремя V2 device signatures. Exact V2 offering
  можно зашифровать в локальном pre-key secret blob и восстановить после
  restart только с совпадающими exact bytes, hash и scope. Локальный
  authoring/seal не заменяет XPP1/XIC1, XPC1, DID2 DPH2 или device E2E;
  DID2 DPH2 pre-claim теперь проверяет V2 offering только относительно
  nonce-fresh current DID2 directory proof адресата, сохраняет exact V2
  DPK2 bytes в verified capability и использует их для DPH2 selection,
  transcript и initial-payload AAD. Двухаккаунтный Registry/Shared тест
  отвергает старый DPK2 envelope. V2 XPP1/XPC1 и durable message transport
  остаются открытыми gates; pre-claim не является отправленным сообщением;
  bounded V2 XPP1/XIC1 structural codecs теперь закрывают exact envelope,
  complete body lengths и V2 receipt signing input. Они пока не выдают
  publication authority: нужны authenticated placement, два final receipt,
  durable replica commit/replay и live XPC1;
  DID2-only XPK1 V2 request codec фиксирует exact 438-byte wire,
  suite `0x0301` и V2 request-hash domain. Внутренний XPC1 V2 codec
  проверяет padded status/result matrix, exact DPK2/XPI1 selection,
  Merkle inclusion и V2 receipt tuple, но не выдаёт claim authority:
  PMT2-bound подписи двух реплик, durable replica CAS и защищённая отправка
  DPH2 ещё не активированы;
  публичная проверка принимает только заново проверенную current DCA1 V2
  capability и весь nonce-bound trusted-time interval, а не caller-supplied
  timestamp. Это ещё не XPK1/XPC1 claim и не runtime activation.
  DID2 ADH1/DTT1/ADP1 V2 reader теперь отдаёт аутентифицированный временной
  интервал; отдельная DCA1 V2 capability связывает его с exact current
  DID2/DAB2/DMD1/ADC1, проверяет отзыв authorization ID и продвигает обе
  границы только по тому же boot-specific monotonic clock. Это не contact
  publication authority и не разрешение включить runtime;
  Полные XPP1 inventory bytes, claim inclusion proof, two-replica receipts, durable
  inventory lineage и live claim ещё не подтверждены для DID2 пути;
  device-signed records остаются в account-owned custody, threshold records
  выпускает authority Mr. X, а XPU1 атомарно несёт exact verified route closure;
  bounded XPA1/XPU1 authority wire, Registry issuer и independently verifying
  client и account-owned device-custody caller уже собраны, но full DCB/pre-key
  orchestration и durable publication ещё не подключены;
  locator-indexed Registry/XNode route lookup и post-publication substitution
  удаляются из production composition;
- удалить исторический `session-compatibility-v0` корпус и его отдельный gate
  из release checkout; при необходимости аудита он доступен в Git history,
  но не собирается, не пакуется и не загружается.

Gate: source/API/assembly/package/resource/dependency scans доказывают
нулевой legacy production graph; retired bytes есть только в negative
fixtures; чистая установка/сброс создаёт только новое поколение; два независимо
проверенных XNode receipt подтверждают publication-bound permanent resolve и
XRR1-bound mailbox grant acquisition без Registry locator/grant oracle.

### DEV0 — локальный dev-контур и честный E2E baseline

Сразу после CB0 поднимается текущий Docker dev-контур и
выполняется один диагностический Android↔Windows run для account,
contact, text, attachment и group. Отсутствующий Deep-native service,
authority, client adapter или activation marker записывается как
blocking failure с точным владельцем; legacy или mock path не может
сделать baseline зелёным.

Диагностический снимок 2026-09-12 (не acceptance): 12/12 контейнеров
healthy; физический Android↔Windows `ProvisionIdentity` проходит на сохранённых
раздельных account state: one-button account, canonical Deep ID и явный
24-word reveal/hide проверены в изолированном E2E package. Production Android
package не изменялся. Предыдущий WinUI `0xc000027b` устранён без ослабления ACL:
унаследованный app-data root сохраняет уже проверенного current owner, а exact
private ACL канонизируется отдельно. `Attach` честно остаётся красным до
интерактивной message surface: production runtime fail-closed отвергает transport
без owned `IMsg01AuthenticatedEvidenceSource`/E2EE-01 authority. `GroupText` и
`PayloadMatrix` проходят конфигурационный preflight, но не запускаются как якобы
независимое E2E-доказательство, пока этот общий upstream blocker не закрыт.
Подробный журнал находится в `deep-devops/docs/SURVIVAL_DEV_STACK.md`.

Диагностический снимок 2026-09-27 (не acceptance): физический Android SM-G970F
доступен по USB/ADB, на нём установлен изолированный DID2-probe с сохранённым
локальным аккаунтом. Экран probe прямо сообщает, что контакты, сообщения,
вложения и группы в нём не включены; canary network-admission controls в этой
установленной сборке отсутствуют. Windows E2E-пакет запускается, но показывает
старую поверхность `deep1…/DIA1`. Эти наблюдения не подтверждают DID2 device
E2E; следующий тест требует собранного DID2 transport/runtime на обеих
платформах, а не переименования существующего пакета.

Снимок 2026-09-20: clean-break MAUI composition собирается для Android, а
изолированный физический Samsung проверил создание аккаунта одной кнопкой,
сохранение после перезапуска, reveal/hide и удаление 24-word фразы. Старый
Session runtime исключён из production graph, но это ещё не release gate:
текущий UI умеет проверять контакт; DPH2 подготовлен только как нижележащий
storage primitive, а group state доступен лишь частично. Production-доставка
и получение 1:1 сообщений, вложений и групп в новой
composition не подключены. Полное device E2E остаётся красным; успешная
сборка и локальная подготовка не считаются подтверждением обмена. После
clean-break старые тесты, зависящие от удалённого `ClientRuntime`, требуют
замены тестами новой production-сборки, а не возврата compatibility-кода.

Проверка message path 2026-09-21: импорт контакта больше не расходует
одноразовый XPK1 prekey и не фиксирует DPH2 до фактической отправки.
`deep-client-shared` теперь запускает MSG-01 transport tests на clean
production project с test-only internal hooks: подтверждённые тесты, включая exact DPH2 → DAO1 → recipient open,
durable DPH2 replay после restart/crash, account-owned pending-DPH2 recovery
и побайтно стабильный DAO1 при повторной отправке восстановленного DPH2,
со строгой привязкой к peer/session, responder prekey/session saga,
DPE2 receive replay/fork, запрет ACK до предъявления inner commit receipt и
привязку ACK к тому же self-mailbox scope, из которого получена пачка.
Обнаружен более строгий release blocker: прежняя внутренняя фабрика ACK
принимала один лишь durable DPH2/DPE2 ratchet commit, хотя MSG-01 inbox event
не был материализован; после crash replay DPE2 уже не возвращает DMC2. Обе
production-фабрики такого преждевременного ACK удалены. Пока staged DMC2 не
материализован в MSG-01 inbox, ACK в production не выдаётся, а устройство не
может честно заявить получение сообщения.
SQLCipher schema generation 7 (DPE2 staging введён в generation 6) атомарно stages аутентифицированный
DMC2 вместе с fresh DPE2 ratchet commit; тест падения сразу после коммита
подтверждает восстановление exact DMC2 после restart без повторной расшифровки;
парный тест падения до commit подтверждает откат и ratchet state, и staged DMC2.
Узкий public durable-authority handoff отдельно утверждён в
[`DPE2-INBOUND-DURABLE-HANDOFF-AUTHORIZATION.md`](survival-program/releases/v3.0.0/specs/DPE2-INBOUND-DURABLE-HANDOFF-AUTHORIZATION.md).
Чистый account-wide DMB1 schema generation 2 теперь может семантически
материализовать direct DMC2 из проверенного session-owner handoff: exact
cross-session replay идемпотентен, changed bytes при том же semantic ID
защёлкивают durable fork, событие читается после restart. MAUI account owner
теперь открывает этот DMB1 store с отдельным защищённым SQLCipher-ключом и
удаляет его при локальном reset. Это ещё не
полный MSG-01 receive: handoff не подключён к mailbox retrieve runtime,
pending stage не retired. Для established direct DPE2 единая production-фабрика
сначала фиксирует ratchet receive (или восстанавливает exact replay), затем
материализует inbox и лишь после этого создаёт ACK receipt; initial DPH2 и group
ещё не имеют этого пути. Group DMC2 требует
отдельного group-authenticated пути.
Из них portable CI-фильтр проходит 52 теста; Windows-only approved ML-KEM
проверки остаются в полном Windows gate.
В transport-тесте используются fake
mailbox и тестовый commit receipt; это не доказательство двухустройственного
E2E. Android Debug build и Windows ARM64 Debug build проходят без
предупреждений, но UI отправки/получения ещё не подключён. Физический E2E gate требует итогового чистого commit,
подписанной policy и привязанных к нему APK/Windows executable; текущий dirty
worktree не может служить release evidence.
CI shared больше не создаёт старый неподписанный `Deep.Client.Shared.csproj`
package с `SIGNING-PLACEHOLDER`: release-кандидат использует только clean
production assembly через MAUI project reference.
Локальный Windows Release composition preflight без production trust-floor
закрывается ожидаемым `RequireProductionMailboxTrustFloor`; это не успешный
Release gate и не основание подставлять фиктивные authority properties.

Проверка production wiring: XRA1 authoring и его metadata-sealing key ID/public
существуют в `deep-protocol`. В Shared добавлен защищённый владелец X25519
private key, который переживает restart и открывается только при совпадении
с exact current XRA1. MAUI уже связывает verified proposal, этот key owner и
текущий device custody signer для локального авторства XRA1, но точная
публикация и receive composition ещё не подключены. Bounded HTTPS-клиент
Registry route-authority теперь формирует запрос только из одной verified
proposal: nonce, directory lookup rollback floor, current DCA1 и exact XRA1
не могут быть cross-sourced. Ответ привязывается к запросу и проходит полную
PMS2/XRC1/XSS1 threshold-проверку; account-owned MAUI author завершает
XRR1/XIR1 тем же current-device signer. Этот путь пока не вызывается startup/UI
и не сохраняет/публикует DCB1/DCR1, поэтому self-retrieve authority ещё нет.
Поэтому получающий клиент
пока не получает DAO1 из сети. Shared теперь также принимает exact MEO1,
курсор и внешний digest из clean mailbox adapter, сверяет current mailbox
route, canonical DAO1, operation ID и hash, затем открывает DAO1 через
защищённый ключ только для локального DPH2/DPE2-адресата. Это не ratchet/
application commit и не ACK. До device E2E нужно связать завершённый route с
durable DCB1/DCR1 publication, mailbox retrieve, responder/ratchet commit и
ACK после commit.
MAUI account runtime экспонирует этот clean inbound MEO1→DAO1 open, но ещё
не вызывает его из mailbox receive loop.
Responder pre-key owner теперь читает точный публичный DPK2 по hash из
входящего DPH2 из локального SQLCipher inventory, проверяет local device scope
и весь selected-prekey tuple без резервации или выдачи private key. Перед
pre-claim preview Shared также требует, чтобы предоставленный verified DPK2
совпал с этой текущей локальной записью; отсутствующий/исчерпанный pre-key
остаётся fail-closed. Для end-to-end receive всё ещё нужно связать эту
проверку с актуальным DMD1/XPC1 authority и mailbox loop.
Responder уже может аутентифицированно открыть SessionInit и первое DMC2
из exact DPH2 вместе с TRS1; проверены настоящий initiator→responder
round-trip и отказ при повреждении ciphertext. Clean SQLCipher schema 7
атомарно сохраняет эти exact события с initial TRS1; crash до commit
откатывает оба, а restart и exact replay сохраняют исходные байты.
Initial SessionInit и первое DMC2 теперь материализуются одной транзакцией
в account-wide inbox; тесты покрывают exact replay и crash до/после commit.
MAUI responder после успешного initial saga вызывает этот handoff, но это ещё
не ContactHello relationship state и не право на ACK. Protocol теперь вычисляет
safety number из двух verified non-forked DAB1 и отдельно проверяет exact
DAB1/DMD1 поля ContactHello, автора, время и подпись XUR1 по verified DPD1.
Verified DPH2/XPC1 preview теперь сохраняет current initiator checkpoint и
recipient bundle; Shared unsolicited responder применяет endpoint-проверку
до открытия conversation store. MAUI receive пока не вызывает этот путь,
а XUR1 ещё не замкнут на PMT2 placement. Осталось применить полный proof,
связать mailbox receive loop и его безопасный ACK, а также
retire staged handoff после подтверждённой материализации.
Проверка входящего ContactHello теперь дополнительно требует, чтобы
conversation ID совпал с производным от relationship ID и обоих account ID;
подмена отклоняется до inbox. Однако unsolicited bootstrap всё ещё не может
дойти до неё: responder требует заранее проверенный relationship и открывает
conversation-scoped store до расшифровки DPH2, хотя relationship ID есть только
внутри ContactHello. В Shared уже добавлены deferred resolver для prekey saga,
вывод scope из аутентифицированных SessionInit/ContactHello и восстановление
scope финального повтора по protected catalog. Проверки подтверждают повторное
использование reserved claim и exact final replay без повторного открытия
prekey-секрета. Shared account-owned responder теперь выбирает store после
аутентифицированного ContactHello и при exact final replay находит только
существующий matching store в защищённом каталоге. MAUI account runtime уже
экспонирует этот staged commit, но mailbox receive loop его пока не вызывает.
Ещё нужно подключить этот путь к inbox без предварительного контакта, сохранить
crash-семантику и запретить ACK до
полной проверки и durable contact-state commit.
Production-клиент уже может получить `VerifiedDph2Initiation` через
account-owned DPH2 preview с exact XPK1/XPC1 и текущим DMD1; отдельный
`IDph2VerificationCallbacks` для этого пути не требуется. Но полученный из
сети DAO1 ещё не доведён до этой проверки: нет receive composition, которая
подаст verified local offering, initiator freshness и placement. До неё
factory/SQLCipher-тесты не являются физическим входящим E2E.
Аудит wire выявил причину: прежний DPH2/DAO1 передавал получателю только
хэш XPC1, а не exact XPK1/XPC1; подтвердить threshold claim по хэшу
невозможно. Принято clean-break решение
[`DR-0005`](survival-program/decisions/DR-0005-inbound-dph2-claim-evidence.md):
вложить transcript внутрь существующего encrypted DPH2 initial payload,
не добавляя новый транспорт или XNode protocol. Production sender теперь
сохраняет exact XPK1/XPC1 wire и авторит зашифрованный prefix; payload reader
структурно его требует в production assembly. Protocol также различает
pre-claim header (без права на commit/ACK) и повышение только через verified
XPC1 capability. В Protocol добавлены одноразовая, exact-DPK2-bound копия
секрета для preview, вывод только initial AEAD key без ratchet roots и строгий
разбор зашифрованного claim transcript; это проверено на обоих видах prekey,
подмене ciphertext и event-only body. Добавлены read-only выборка секрета из
SQLCipher и responder preview, привязанный к verified non-forked DMD1;
повышение preview требует отдельно проверенный exact XPC1 wire. Preview
теперь вызывает production two-replica XPC1 verifier с verified placement,
recipient bundle/network authority и trusted time; account owner выполняет
этот путь до открытия session store или резервирования prekey. Для выдачи
verified DPH2 теперь обязателен current initiator DMD1 checkpoint, проверенный
на текущем monotonic sample. Production Shared facade и MAUI account owner/
accessor теперь проводят этот pre-claim шаг без выдачи ACK; он ещё не вызван
из mailbox retrieve. Ещё отсутствуют подключение к mailbox retrieve,
durable ContactHello/MSG-01 commit и ACK, поэтому device E2E не доказан.
Shared production assembly собирается с исключённым Session-derived runtime,
но полный старый `Deep.Client.Shared.Tests` пока не компилируется: часть тестов
всё ещё импортирует удалённые legacy-типы. Для PreKeyV1 есть отдельный
диагностический cohort, теперь включённый в основной clean
`Deep.Client.Shared.Production.slnx` вместе с перенесёнными runtime/mailbox
тестами. Локальный Windows Release-прогон 2026-09-21 прошёл 142/142;
он проверяет код и SQLCipher-переходы, но не физический обмен между устройствами.
Старый `Deep.Client.Maui.ViewModels.Tests` также остаётся вне clean gate:
он импортирует удалённые Session/`Deep.Client.Shared.State` типы; фильтрация
тестов не помогает, потому что весь legacy project не компилируется. Новый
`Deep.Client.Maui.Clean.Tests` проверяется отдельно, без возврата этих типов.
Этот набор должен расширяться до
всех новых production функций и пройти вместе с физическим device E2E.
Реализация и re-freeze векторов обязательны до включения receive и device E2E.

Снимок 2026-09-23: DPH2 теперь несёт exact DID1 отправителя, а initial
payload — зашифрованный XPK1/XPC1 transcript; получатель может независимо
разрешить current initiator directory, выполнить pre-claim preview и
проверить threshold claim до durable responder commit. Согласованы новые
DPH2/DAO1 размеры в Protocol, SQLCipher и machine registry; прежние DAO1
размеры отклоняются. Полный Protocol Debug gate прошёл 1 719 тестов
(11 платформенных skipped), Shared production Release gate — 149/149.
Чистый MAUI AppShell ещё не вызывает `TryEstablishAndDispatchDirectMessagingSessionAsync`
и `PrivacyRoutedMessagingReceiver.ProcessInitialAsync` из пользовательского
диалога или mailbox receive loop. Это остаётся release blocker для физического
Android↔Windows E2E; сборка клиента и нижележащие storage tests не заменяют
проверку отправки и получения на устройствах.

Актуализация после аудита 2026-09-23: текущая clean MAUI surface уже имеет
явные `StartSecureChannel`, `SendText` и `CheckInbox` вызовы; предыдущий
снимок выше описывает более ранний commit и не является текущим статусом UI.
`PrivacyRoutedMessagingReceiver.PollOnceAsync` проходит путь initial/established
до durable materialization и ACK только после commit. Локальный MAUI clean
Release test gate прошёл 6/6, Shared production Release gate — 159/159.
Повторная проверка 2026-09-24: Windows ARM64 и Android Debug MAUI собираются
с 0 предупреждений; это не Release и не физический E2E. Старый compiled
Release composition guard проверял уже исключённый Session-era entrypoint;
guard перепривязан к скомпилированному clean `MauiProgram`, а Android CI
переведён на `setup-android@v4` после отказа удалённого SDK `tools`.
Итоговый CI этих правок остаётся обязательным gate. Физический Android
доступен, но локальная signed lab policy привязана к предыдущему коммиту;
она не может служить доказательством для нового APK/Windows build.
Это пока **не** физический device E2E: нужны
подтверждённая contact publication/authority, два реально созданных аккаунта,
доставка Android↔Windows и, после DR-0006, новый release-compatible ID.
После DID2 clean-break account service открывает проверенные, неэкспортируемые
DPH2 X25519 и DPK2 prekey-authoring capabilities из STORE-V2; повторное
открытие после удаления локальной сид-фразы покрыто тестом. Эти capabilities
не выдают право на отправку или публикацию сами по себе: операции требуют
exact current unforked DMD1 и одноразовый binding.
MAUI transport composition, доступный DID2 Registry endpoint и физическая
доставка Android↔Windows всё ещё остаются обязательными gate. STORE-V1/
`SessionId` fallback не добавлять.
Физическая проверка 2026-09-24: изолированный Android DID2 probe
`network.xpoint.deep.did2probe` установлен поверх прежней версии без удаления
данных; после restart и обновления открыт экран управления сохранённой фразой,
а не создание аккаунта. Debug Android и Windows probe собираются; полный
Shared production gate 182/182, Protocol 1758 passed/11 skipped,
MAUI clean 15/15. DPK2 one-time authoring положительно проверен на Windows;
Linux CI обязан отвергать его без release-approved ML-KEM asset, без fallback.
Это доказывает только
локальную непрерывность аккаунта, не network admission и не message E2E.
Локальный ASP.NET Registry TestServer дополнительно проверяет цепочку
`DGA1 V2 admission → ADH1/DTT1/ADP1 current proof → STORE-V2 LKG → DPK2`
для того же DID2-аккаунта. На Windows создаётся реальный one-time prekey;
на Linux отсутствие release-approved ML-KEM обязано завершиться fail-closed.
Source-cutover Registry suite локально прошёл 413/413; GitHub CI и image
candidate должны checkout того же branch `deep-client-shared` для тестов.
Этот тест не является физическим Android↔Windows transport evidence.
Read-only production check 2026-09-24: `registry.xpoint.network` отвечает
`GET /health/live` 200, а HEAD к обоим `/api/v2/account-directory/*`
маршрутам даёт 404; production DID2 availability не доказана. Кодовая
группа endpoint теперь допускает только явный production opt-in после
аттестации удалённого VerifyFull PostgreSQL floor, proof issuer и startup
сверки полной ADA2-журнальной головы с внешним floor; эти условия в
действующем production не настроены. Текущий
локальный public bootstrap manifest для
production network `edc5dc1516a847a65fc8ba0e690d000d` истекает
2026-09-25 10:25:43 UTC. До выката необходимо проверить refresh подписанного
authority, независимый PostgreSQL latest-head floor, rollback и сохранность
co-located staking; локальный TestServer не подменяет этот gate.
Windows probe после созданного оператором нового аккаунта снова наблюдался
через UI: отображаются имя, DID2-адрес и скрытая фраза; её содержимое не
раскрывалось. Это не подтверждает сетевую регистрацию или доставку.
Shared production suite теперь прошёл 183/183; DID2 proof client создаётся
через owned HTTPS transport factory, которая ограничивает origin, endpoint,
размеры и timeout. Полный Registry suite после добавления production gate
прошёл 413/413. Ничего из этого не заменяет физический device E2E.
Следующая проверка — sender DPH2, recipient self-retrieve/ContactHello,
ответный DPE2 и crash/replay на тех же двух устройствах; файлы и группы
выполняются только после зелёного текстового пути.
Аудит текущей композиции 2026-09-25 уточнил обязательный предшествующий gate:
обычный MAUI `CreateMauiApp` всё ещё монтирует `DeepAccountRuntimeAccessor`
и ContactV1 message runtime, который намеренно отвергает DID2 DPH2, тогда
как изолированный DID2 probe не монтирует message runtime. Поэтому старые
`StartSecureChannel`/`SendText`/`CheckInbox` не являются DID2 E2E. Сначала
нужно подключить account-owned DID2 contact/prekey/DPH2/receive composition
в основной клиент без V1 fallback, затем запускать вышеуказанный физический
сценарий. DID2 peer lookup теперь повторно проверяет локальный admission
перед каждым запросом; UI-флаг прошлой успешной проверки не является
долгоживущим authority. Это ещё не acceptance и не доставка.
Clean-break входа 2026-09-27: default MAUI Windows/Android composition теперь
монтирует DID2 account owner и DID2 shell вместо V1 account/message graph;
отдельный минимальный DID2 UI-core заменяет V1 ViewModel assembly в клиенте,
а старые MAUI ContactV1/Session services исключены из компиляции;
V1 startup и shell удалены из исходного release graph;
V1 welcome/group signer тесты удалены из clean gate и заменены проверкой
актуального DID2 startup graph;
изолированный debug probe сохраняет отдельный package/data root. Локальные
создание и recovery подключены в основной клиент и прошли сборку, но их
физический прогон в новом package ещё не выполнен. Verified production
authority, contact acceptance, prekey publication/claim, DPH2 dispatch,
receive и группы пока не подключены. Поэтому ни обычный клиент, ни probe
ещё не дают DID2 device E2E; старые V1 UI-тесты не считаются доказательством.
Нормальный non-Release `.e2e` package получает отдельный opt-in для
подписанного DID2 admission/peer-proof по DNS HTTPS без loopback и без V1
fallback. Он использует те же точные public XNA1/DTS1/genesis ADH1 assets и
compiled pins; Release без утверждённой crypto/runtime authority остаётся
закрытым. Это только подготовка account/peer proof, не contact acceptance,
DPK2 publication или физический message E2E.
Для DID2 добавлен отдельный `GET /health/did2/ready`: он повторно проверяет
protected trusted time, полную ADA2 lineage, независимый latest-head floor и
срок текущей подписанной головы до возможности выпустить новый proof.
Общий `/health/ready` отражает иные сервисы и не доказывает готовность DID2;
проверять новый маршрут отдельным canary, не использовать его как
автоматическое разрешение публичного cutover. Локальные focused-тесты
проверили зелёный и fail-closed пути; физический message E2E остаётся открыт.
Canary 2026-09-25: без сброса ADA2 и нод подписана бессодержательная голова
generation 5/tree 3; независимый floor подтвердил exact core hash. Сохранённый
Android-аккаунт проверил successor proof до и после force-stop/relaunch.
Новый CI-образ Registry показал `GET /health/did2/ready` 200 в отдельном
loopback-only контейнере, публичный staking остался 200. Важный release gate:
подписанная голова живёт один час; до публичной активации нужен управляемый
renewal по защищённому trusted time и проверка деградации/восстановления,
а не ручное продление canary.
Registry candidate теперь имеет opt-in content-preserving ADH1 renewal с
protected trusted-time и независимым latest-head floor, включая startup
renewal перед DID2 readiness и периодический worker. Локальный focused gate
18/18 проверил no-op до lead, один successor у expiry, точное сохранение
tree/map/log и отказ invalid-time/floor; полный source-cutover Registry gate
прошёл 423/423 при повторе. Первый полный прогон дал один невоспроизведённый
отказ в старом one-use-ledger тесте; это ещё требуется отследить в CI.
Renewal не ротирует protected time anchor.
Публичный Registry ещё не обслуживает DID2, а отдельный prod-host probe
2026-09-27 отвечает 503 из-за stale protected-time anchor. Не заменять его
OS clock и не считать общий `/health/ready` DID2 evidence.
Read-only container audit также нашёл три конфликтующих повторения DID2
environment keys (state path, proof ledger root, PostgreSQL floor DSN) в
probe. Перед следующим canary-rollout нужно устранить дубли в deployment
composition и проверить единственность каждого effective key; новый Registry
startup guard отвергает повторённые raw DID2 environment names даже с
одинаковым значением, но Docker нормализует `Config.Env` до запуска процесса,
поэтому он не ловит найденные дубли. Host-side preflight в `deep-devops`
проверяет исходный Docker inspect без вывода значений и сейчас отвергает
probe; его нужно запускать до promotion каждого Registry-контейнера.
Операторская команда `refresh-current-head` больше не доверяет системному UTC:
она читает protected monotonic trusted-time anchor, проверяет uncertainty
window и закрывается при отсутствующем/просроченном состоянии. Положительный
PostgreSQL/ADA2 CAS и отрицательный missing-anchor тесты пройдены локально;
автоматический renewal остаётся отдельным gate.
Дополнительная проверка через изолированный canary: Windows .NET-процесс
создал отдельный PQ-backed DID2-аккаунт и проверил свой signed proof через
offline-root forward chain; независимый floor продвинулся. Физический Android
со старым protected floor после этого принял текущий signed proof. Это
межплатформенная совместимость каталога (Windows headless + Android UI), не
физический Windows↔Android message E2E.
Входящий ContactHello сейчас сохраняется как pending request, но Contacts UI
показывает историю лишь для вручную выбранного `VerifiedConversation`;
recipient discovery/accept и отображение входящего диалога остаются частью
этого же text vertical, а не доказанным UX.

Физический аудит 2026-09-27: подключённый Android содержит отдельные `.e2e`
и `did2probe` пакеты, а запущенное на Windows установленное `.e2e` приложение
показывает старый экран контактов с адресом `deep1…`/`D1A1` и кнопками
отправки. Это не текущая clean DID2-композиция: в исходниках MAUI она
компилирует `MauiProgram.Did2`/`AppShell.Did2`, где пока доступны только
локальный аккаунт и диагностические DID2 proof-запросы. Старое установленное
окно нельзя использовать как доказательство V2 message E2E. Перед физическим
text vertical требуется собрать и установить current-source DID2-клиенты на
обеих платформах, подключить V2 contact/prekey/DPH2/receive runtime без
SessionId fallback, затем сверить идентичность установленных сборок и
проверить доставку в обе стороны. ContactV2 codec/verification classes с
`RuntimeActivation=false` не означают активированный клиентский путь.
Protocol теперь имеет локального автора полного DID2 V2 DPK2→XPI1→XPP1
инвентаря с verified DAB2/DMD1 binding и подписью текущего устройства.
Он возвращает opaque prekey capabilities для последующей передачи в
SQLCipher, но не делает публикацию. Shared теперь имеет отдельный DID2-only
SQLCipher primitive для атомарного initial XPP1 inventory + sealed DPK2
capabilities: crash до commit не оставляет частичных rows, reopen сверяет
exact scope/member bytes и восстанавливает sealed secrets. Primitive пока не
подключён к account-owned STORE-V2 protected install marker/rollback floor и
не выдаёт XPP1 в сеть. Следующий обязательный шаг text vertical — связать
initial staging с защищённым floor (потеря/rollback SQL должны fail-closed),
затем verified двухрепличный XIC1 commit и клиентский DPH2 claim/receive.
V1 inventory store/codec не использовать как обходной путь.

Физическая диагностическая проверка Windows UAT 2026-09-23: новое локальное
name-only account создалось и открыло clean Contacts UI, но фоновая genesis
contact publication отказала fail-closed с
`ContactPeerReverificationUnavailableException: AuthoritySource`. Это
конкретный upstream blocker для обмена с Android в установленной UAT-сборке;
никакой fake authority или Registry-only shortcut не разрешён. Нужно сверить
exact installed package/runtime config с текущей verified host capability,
восстановить production-bound authority и повторить публикацию, затем
sender/recipient текстовый прогон. Созданный DID1-аккаунт диагностический и
после DR-0006 не является release-compatible.
`ProductionContactVerifiedAuthoritySnapshotSource` уже существует в XNode;
отказ Windows-клиента сам по себе не доказывает отсутствие этого сервиса.
Старый accessor маскировал конкретный `UnavailableReason` как
`AuthoritySource`; диагностический fix в MAUI сохраняет исходную причину,
но не подменяет authority и не делает установленный старый пакет зелёным.

Выводы security review, не нужные для CB0, не прерывают
DEV0. Они выполняются после фиксации baseline в dependency order:
Deep-native 1:1 vertical, contact, groups/files, routing/carriers, release
hardening. Mesh, MLS, **ML-DSA вне корня permanent identity** и on-prem
runtime остаются за пределами V1. Корневой ML-DSA из ID-PQ-CB обязателен.

Остальной аудит разбит по уже существующим владельцам, без новых protocol
families в text vertical: Signal PQXDH/Triple Ratchet остаётся проверяемым
криптографическим benchmark, SimpleX — benchmark минимизации глобальных
идентификаторов и self-host, Session — roster/placement, Briar — будущего
offline mesh, Matrix — on-prem операционной зрелости. В V1 перенимаем не
новый стек, а gates: Registry не является steady-state trust oracle;
crypto/onion/call claims разделены; два независимых censorship carriers и
реальные hostile-network tests закрываются перед публичным выпуском;
release BOM привязывает exact commits, protocol registry, native binaries,
service images, APK/Windows ZIP и policy к физическому E2E. Hybrid/PQ onion,
MLS, on-prem и mesh — отдельные последующие профили, не блокирующие первые
текстовые Android↔Windows тесты. Начальные три XNode не дают disjoint route.

`DEV-AUTH0` также отложен до отдельной команды после текущего release. Его
изолированный контракт сохранён в
[`architecture/LOCAL-DEV-E2EE-AUTHORITY.md`](architecture/LOCAL-DEV-E2EE-AUTHORITY.md),
но он не является зависимостью production composition, тестирования или
публикации этого релиза.

## WP0 — dependency и implementation decision gate

- Завершить production gate отдельного минимального incremental ML-KEM-768
  provider для Android Braid. Windows x64/ARM64 Whole ML-KEM и Braid уже
  приняты из immutable official CI artifact, hash-allowlisted, физически
  проверены и упакованы; повторять их без изменения approved bytes не нужно.
  Android arm64 native compatibility, hardening и physical probe закрыты, но
  Android production package/allowlist ещё должны быть привязаны к итоговому
  release artifact и signing evidence.
  Текущий `mlkem-native` умеет только монолитный Encapsulate и не предоставляет
  требуемые `Encaps1(ct1,state)`/`Encaps2(state,ct2,secret)` primitives. Не
  переносить внутреннюю полиномиальную арифметику вручную. Предпочтительный
  gate — pinned dual-licensed `libcrux-ml-kem` через узкий panic-safe C ABI,
  interop с обычным ML-KEM ciphertext, zeroization и Android/Windows evidence;
  AGPL Signal SPQR crate не добавляется в production dependency graph.
- Зафиксировать Windows/Android resource budgets и итоговый release suite `0x0201`.
  Classical-only/PQ-only silent fallback запрещён. Отсутствие локального VS C++
  ARM64 toolchain не является release prerequisite: release потребляет только
  exact approved binaries.
Gate: подписанный dependency decision, воспроизводимая minimal native test app
на обеих платформах, KAT/vector agreement и отсутствие unresolved license P0.

## WP1 — destructive identity/database clean break

- Подключить `DeepRecoveryV1`/account/device/store primitives к новому
  production `DeepClientRuntime` на уже очищенном CB0 production graph,
  затем выполнить один destructive reset всех pre-production
  registrations и хранилищ.
- Закрыть airplane-mode create/restore и crash-safe reset на итоговой MAUI
  composition; до локального account success ни один network/bootstrap callback
  не должен создаваться или вызываться.
- Повторить CB0 production graph scan на итоговой MAUI composition
  и доказать отсутствие routine recovery-phrase loading.

Gate: golden/negative recovery vectors, airplane-mode create/restore,
wrong-generation rejection, key-role tests, crash-safe reset и zero Session
production dependency/runtime scan.

## WP2 — asynchronous 1:1 E2EE и multi-device

Gate каждого WP создаёт переиспользуемый black-box evidence set для своего
контракта. WP9 повторно запускает эти же scenario/evidence IDs на одной RC
commit matrix и проверяет композицию; отдельные копии harness/tests для WP9 не
создаются.

- DID2 genesis уже авторует `AuthorGenesisDmd1`; Shared account owner теперь
  передаёт заново проверенный genesis DMD1 в durable current-device store
  идемпотентной account-bound операцией. Конкретный SQLCipher device-state
  store теперь монтируется с V2-изолированными ключом и путём при создании
  аккаунта и запуске MAUI; защищённый маркер запрещает незаметное пересоздание
  утраченного agreement ledger. Shared DID2 account service теперь начинает
  DPH2 claim только по свежему точному DAB2/DMD1 proof, проверяет exact DPK2
  по свежему DID2/DMD1 proof адресата без caller-provided callback и завершает
  его через отдельную одноразовую store-авторизацию; оба proof сверяются с
  защищённой текущей головой каталога перед операцией. HTTP-интеграционный
  Windows HTTP-интеграционный тест с двумя аккаунтами подтверждает отказ старому/чужому proof, подменённому DPK2 и replay
  device-DH1. Перед расходованием одноразовой device-lease claim также
  повторно связывается с точным текущим DID2/DMD1 initiator; stale proof,
  смена boot и уже использованный claim отвергаются без расходования lease.
  Это не публикация XPK1/XPC1 и не отправленный DPH2:
  MAUI production caller/current-DMD1 композиция ещё не подключена.
  DID2 STORE-V2 выдаёт только verifier-bound локальную X25519 capability;
  public-forgeable provider и raw keys запрещены. Готовые account-wide DPK2 prekey owner,
  per-session DPE2 stores, durable session catalog, Protocol one-shot DPH2/TRS1
  capability и atomic initial-session transaction уже связаны внутри MAUI
  runtime owner; осталось подключить production caller после current-DMD1,
  отправить
  durable pending DPH2 через verified privacy path и активировать DPE2 только
  после exact delivery receipt. Raw keys, caller-provided providers и частичная
  фиксация запрещены.
- Реализовать handshake initialization/runtime composition и безопасный session
  rollover до лимита журнала, чтобы не оставлять пользовательский диалог в
  `CapacityExceeded`.
- Ввести account-authorized device list, enrollment, device fanout,
  revocation/rekey и explicit history-sharing policy. Restore создаёт новое
  устройство, а не копирует ключи старого.
- Подключить MSG-01 logical outbox/inbox к DPE2 и реальному transport:
  один logical message/operation ID переживает attempts, at-least-once retry,
  restart; materialization и receipts остаются идемпотентными.
- Связать attachments, reactions, replies, edits, deletes и call signaling с
  exact conversation/device/ratchet context.

Gate: two-device и multi-device vectors, compromise/PCS drill, revoke while
offline, crash before/after ratchet commit/send, duplicate/out-of-order flood,
Android↔Windows interoperability и независимый crypto review P0/P1=0.

## WP3 — arbitrary contact bootstrap

- Реализовать AppShell activation для DID2-only account-scoped entry
  flow: по verifier-minted relationship/conversation ID повторно проверить
  durable peer package, создать DPH2/TRS1 session и открыть новый direct chat;
  добавить physical UI/restart evidence и QR-import.
  Старый `05...` ID, display name, CMI1, route или DCR1 не являются адресом.
  Истечение DCB/XIR/XPS даёт только `TemporarilyUnavailable`, не меняет Deep ID.
- Вернуть полноценный интерфейс без возврата legacy runtime: использовать
  существующие визуальные шаблоны `ConversationsPage`, `ChatPage`,
  `GroupsPage`, `GroupChatPage`, `SettingsPage` и двухпанельный
  `DesktopWorkspacePage` как основу новых DID2-only экранов. Сохранить
  палитру и стабильные `AutomationId`, но не включать старые XAML вместе с
  `SessionId` ViewModel/code-behind. Активные действия и статусы доставки
  показывать только после появления соответствующих проверенных runtime
  capabilities; Android и Windows проверять отдельным физическим UI lane.
- Подключить MAUI client LKG/entry-guard stores и
  fork/freshness ADC1/ADH1/ADP1/ADL1 к production authority fetch/runtime и
  запустить publication/replenishment scheduler поверх уже готовых durable
  XPK1/XPC1 journal и bounded two-replica XPP1/XIC1 transport. Atomic
  activation выполняется только после двух verified final XIC1; public DCB1
  не содержит consumable prekey bytes.
- DID2-only peer discovery: protocol/client теперь авторуют ADL1 по точному
  DID2 без заранее доверенного DAB2 и принимают только nonce-bound current
  proof с тем же DID2 и защищённым LKG. Двухаккаунтный Registry integration
  test подтверждает Alice→Bob lookup через подписанный forward checkpoint.
  Изолированный non-Release Android probe дополнительно подтвердил по
  текущему подписанному каталогу точный публичный DID2 аккаунта, созданного
  Windows-host клиентом. Это физический proof lookup, но ещё не принятие
  контакта и не device-to-device сообщения: DID2-only MAUI UI, durable
  acceptance и transport activation остаются gate Android↔Windows.
- Выпустить и смонтировать через готовые Registry production trusted-time,
  one-use-ledger, DTT1 custody и operator authoring полный подписанный authority
  package; готовый durable verified permanent/one-time resolve evidence owner
  подключить к production issuer/
  client flow и locator-keyed XNode recipient-authority source через
  privacy-routed authenticated ingestion. Затем активировать durable consume
  saga, authenticated two-replica transport и endpoint; unknown locator до
  независимо проверенного evidence остаётся unavailable. Invite store не
  получает DID1/account/device или DCR plaintext.
- Подключить exact XPU/XIQ/XPK/XUW wire к production two-replica Contact
  Resolver runtime и реализовать
  отдельный distributed encrypted contact-request mailbox,
  доступный без существующего E2EE channel или live PRA.
- После acceptance создать pairwise session и обменяться короткоживущими
  deposit routes внутри E2EE. Initial discovery получает XRA1/XRC1/XRR1/XSS1
  closure через XIR1; все PRA1/PRA2 bytes являются pre-cutover reject.
- Добавить signed successor/refresh path для rendezvous, spam admission до
  дорогой криптографии, block/report и без account enumeration.
- Поддержать fresh install и sender/receiver offline в пределах явного
  retention SLA; expired contact request показывает точный результат.

Gate: новый Android contact → Windows contact и обратно без DEV secret,
offline recipient, stale/rotated rendezvous, replay/spam/fork negatives,
cold restart обоих клиентов и отсутствие публичной mailbox correlation.

## WP4 — малые закрытые группы v1

- Подключить `GROUP-CODEC-01` membership chain и durable per-recipient opaque
  group-control service к новому client runtime;
  добавить GSS wire/client state и удалить старый revision-only state из
  production composition.
- Подключить готовый clean-break MAUI GroupV1 composer и уже смонтированный
  account-scoped activation store к production acceptance dispatcher: verified
  contact drafts проходят exact GCF1/GSW1 plan и privacy-routed GroupControl;
  только verified GSS1 commit делает участника active.
- Один owner сериализует add/remove/promote. Concurrent multi-admin membership
  mutation и membership change во время disconnected mesh partition в v1
  запрещены.
- Подключить готовую account-scoped GROUP-CLIENT-01 first-dispatch/terminal
  composition и узкий `GroupMessageFirstDispatchContext` к реальному per-device
  DPE2/ratchet dispatcher; legacy transport payload
  не является допустимым evidence source.
- Зафиксировать history policy, invitation/acceptance, owner recovery/transfer,
  tombstones, fork detection и cold-restart state.
- Поддержать до 100 members и 500 active target devices одной bounded durable
  batch; подтвердить fanout latency, battery, storage и traffic burst. Старое
  неподтверждённое значение 2048 удалить.
- MLS RFC 9420 зарезервировать как новый scalable group profile с отдельным
  wire/capability gate; не добавлять частичную MLS-семантику в v1.

Gate: create/add/remove/rejoin, concurrent-state fork rejection, messages/
reply/reaction, removed-device exclusion, restart/out-of-order/duplicate и
load test на принятом максимуме.

## WP5 — XPoint directory, routing и storage

- Отделить публичную verifiable router/storage membership от неэнумеруемых
  access bridges. Registry является cache/distribution service, а не
  единственным источником truth или клиентским path selector.
- Публиковать threshold-signed topology/checkpoints с append-only consistency
  proofs. Клиент локально выбирает route из полной проверенной roster.
- Расширить exact-three ContactResolve provider/persistent entry guards
  на mailbox/blob/control paths; подключить liveness/health scoring и применять
  subnet/ASN/provider constraints там, где verified roster это позволяет.
- Подключить first-release topology к готовой XNode production ONION runtime
  closure: готовые отдельные state-protection secrets, replay/entropy/vault
  paths и exact Ingress/Core/Exit positions дополнить current verified
  XNA1/XVP1/XNV1/XNH1/XND1/PMT2/DTT1 authority package для каждого узла.
- Первые три XNode дают один privacy route; fallback может переиспользовать
  узлы и называется best-effort. Capability `DisjointFallback` запрещён до
  6+ nodes и отдельного diversity/evidence gate.
- Разделить long-lived node identity и short-lived router traffic keys;
  безопасно уничтожать retired traffic keys после bounded overlap.
- Зафиксировать mailbox swarm/replication, consistency, retention, quotas,
  repair и node join/drain/exit без привязки mailbox к account ID.
- Реализовать checkpoint-authorized compaction готового production directory
  HTTP/DI catalog. Compaction разрешается только когда
  одновременно истекли 400 дней и сохранены не менее 2 048 поколений, а
  root-signed XNF1 плюс source-specific NFP1 позволяют каждому допустимому
  protected LKG перейти к оставленному target; локальный возраст файла или
  один общий proof права удаления не дают. До compaction каталог должен
  продолжать fail-closed на hard cap 4 096, а не удалять историю самовольно.
- Реализовать DR-0004 clean-break `PMA2/PMT2/PMS2` и
  `XRA1/XRC1/XRR1/XSS1`; все pre-cutover PMA1/PMT1/PMS1/PRA/PSS/RCD/RCA bytes
  отклоняются без dual reader.

Gate: three-host production-like topology, node restart/drain/rotation,
malicious directory/fork/rollback, storage repair и route latency/load. Gate
доказывает разделение source/destination внутри одного onion transcript, но не
заявляет защиту от cross-role timing correlation.

## WP6 — anti-censorship carriers и bootstrap

- Реализовать единый stream/datagram carrier boundary. XPoint onion frame не
  знает Reality/VLESS, WebTunnel-like HTTPS или будущий MASQUE carrier.
- Подключить MAU2 к attested client Reality carrier; direct managed-ingress
  HTTPS после masked-policy selection отсутствует и не может быть fallback.
- Ввести canonical threshold-signed `AccessBridgeDescriptor` и
  `MediaRelayDescriptor`: endpoint, transport, server name, public key,
  short/cohort credential, validity, predecessor, limits и policy generation.
- Embedded endpoints являются только начальными seeds. Клиент получает
  rotating bridge catalog через три канонических channel:
  `in-app-oblivious` RFC 9458 OHTTP, `multi-origin-https` и signed
  `user-import`; embedded cache не заменяет ни один из них.
- Не встраивать полный bridge pool или account/device-linked VLESS credential
  в APK/Windows ZIP. Не использовать один camouflage target/fingerprint для всей сети.
- Реализовать независимый TCP/HTTPS-compatible carrier; UDP/QUIC/MASQUE может
  быть дополнительным, но не единственным path.
- Добавить padding buckets, polling jitter/batching и packet-capture baseline
  без обещания global-observer resistance.

Gate: direct endpoint blocked; DNS/SNI/path/IP/UDP blocking; active probe;
seed/APK extraction; bridge rotation/withholding; carrier downgrade; external
network tests. Text/control продолжает работать хотя бы через один заявленный
carrier без ручной переустановки приложения.

## WP7 — offline trust, retention и fresh install

- Хранить root lineage и transparency checkpoints бессрочно. Fresh install с
  embedded ReleaseRoot проверяет sequential root history и current signed
  checkpoint без DEV credentials.
- Старое устройство проверяет consistency proof от protected LKG к current;
  rollback/equivocation/wrong-network fail closed. За пределами retained
  operational history выполняется recovery-authorized re-enrollment без смены
  AccountId и без доверия к неподписанному latest state.
- Реализовать без локальных переопределений все class-specific limits,
  compaction rules и recovery guarantees из единственной нормативной таблицы
  [`RETENTION-AND-RECOVERY-V1.md`](architecture/RETENTION-AND-RECOVERY-V1.md).
- Proactive refresh выполняется на foreground/resume и перед operation с
  expiry margin, jitter/backoff, lifecycle cancellation и durable outbox.
- Определить eventual revocation и максимальный stale-trust window для
  offline partitions; никогда не обещать мгновенный revoke без связи.

Gate: fresh APK, все machine-contract long-offline fixtures, beyond-horizon recovery,
expired-message semantics, retained root chain, selective withholding/fork,
restart во время refresh и сохранение identity/history/durable outbox.

## WP8 — files, push и calls через общую policy

- Вложения шифруются до upload, используют opaque capability, size buckets,
  resumable chunks, hash verification и независимый rotating service catalog.
  Блокировка file service не должна ломать text/control.
- Push является необязательным opaque wake-up. Без FCM/WNS клиент получает
  сообщения foreground/background catch-up в пределах OS возможностей.
- Call invite/offer/answer/ICE/end идут как typed ratcheted E2EE messages; stale
  offers/replay reject до UI. Отдельный plaintext Registry signaling path
  удаляется из нового generation.
- `RelayOnly` является единственным official v1 `CallPrivacyProfile`: relay-only
  ICE и отсутствие host/srflx/direct candidate. `DirectPeer` зарезервирован для
  будущей explicit opt-in policy и не входит в первый релиз.
- `NetworkCondition=Restricted` использует `MaskedTcpCapsule` через rotating
  independently hosted relay/TLS 443 и
  HTTPS-compatible media relay descriptors. DNS-only TURN не считается
  censorship-resistant. Media остаётся DTLS-SRTP E2EE и не идёт через 3-hop
  mailbox route из-за latency.

Gate: files under service blocking/retry/restart; no-push polling; Android↔
Windows ringing/accept/hangup, bidirectional audio, `RelayOnly`,
restricted-network relay, relay rotation и no silent downgrade.

## WP9 — release composition и physical E2E

- Собрать итоговую Shared/MAUI composition только из прошедших
  CB0 Deep-native packages; reference corpus не входит в build/runtime.
- Release UI показывает фактический transport/carrier/privacy profile и точные
  degraded/unavailable states. Локальное создание account не зависит от сети.
- Выполнить Android↔Windows physical matrix на одной signed commit matrix:
  account, restore/new device, contacts, 1:1, small groups, files/images/voice,
  push/no-push, calls, carrier blocking/rotation, restart и offline recovery.
  Physical/device execution выполняется только локально на операторской машине
  Mr. X; CI собирает клиенты и проверяет non-physical contracts, но не управляет
  устройством или interactive Windows desktop. В release gate передаётся
  sanitized signed commit-bound evidence локального прогона.
- Проверить переписанный DNP package witness на новом hermetic closure:
  выполнить полный execution gate и обновить approved normative binding после
  фиксации commit; подтвердить успешный GitHub run path-filtered documentation
  CI на зафиксированной commit matrix.
- Выпустить reproducible Android APK и Windows self-contained ZIP (portable
  executable с только необходимыми runtime-файлами), dependency lock, SBOM,
  signatures,
  sanitized evidence, backup/restore и rollback rehearsal. Каждое обновление
  и node-installer bundle имеют signed manifest, exact artifact digests,
  monotonic version/security floor и verify-before-install; подменённый,
  неполный или rollback manifest отклоняется до запуска бинарного
  файла или мутации текущей установки.
- После завершения провести независимые lead-developer, protocol/crypto,
  privacy/censorship и security reviews. Release требует P0=0/P1=0.

## Будущие профили — не блокируют первый релиз

### Direct P2P mesh

- authenticated one-hop и multi-hop links, rotating contact-scoped discovery,
  TTL/hop/copy budgets, store-carry-forward, relay consent/quotas,
  Sybil/eclipse/flood defense и partition merge;
- общий logical operation ID/dedup/outbox с XPoint без implicit fallback;
- порядок реализации: one-hop 1:1 → multi-hop text → small attachments →
  existing-epoch groups → membership changes после отдельной merge spec;
- background availability ограничивается возможностями конкретной mobile OS и не
  обещается как always-on universal mesh.

### User-managed/on-prem

- один XNode: E2EE mailbox без path-anonymity claim;
- три XNode: один exact three-hop route;
- шесть+ с независимыми failure domains: disjoint fallback capability;
- собственные authority/directory/file/push/call services без обязательной
  зависимости от Deep-operated Registry, DNS, billing или signer;
- strict zero-public-egress system test: при заблокированных
  public Deep/XPoint DNS и IP новый локальный account публикует
  prekeys, находит другой local account и обменивается сообщением;
- explicit consent-bound profile switch; official public-address policy не
  ослабляется ради private/loopback on-prem endpoints.

### Android 8 compatibility

- Первый public profile пока честно требует Android 9 / API 28: обязательная
  production signer-lineage attestation использует `SigningInfo`, signer
  history и `longVersionCode`. Зависимости и local offline account совместимы
  с API 26, но простая замена на deprecated `PackageInfo.Signatures` не
  доказывает proof-of-rotation и split-APK lineage.
- После первого релиза отдельно спроектировать и проверить API 26 signer
  attestation либо оставить Android 9 публичным минимальным требованием. До
  этого Galaxy A5/API 26 используется только для изолированных crypto probes,
  не как evidence production transport.

## Definition of Done

- Все WP0–WP9 gates закрыты на одном release candidate.
- `NEXT-SPRINT.md` не содержит скрытых исключений «если calls входят» или
  неподтверждённого `exactly-once`/`unblockable`/`disjoint` claim.
- Публичные docs описывают только фактически подтверждённые функции и точные
  ограничения initial three-node profile.
- Независимые reviews имеют P0=0/P1=0; residual P2/P3 приняты отдельным
  decision record.
- Ничего не отправляется в GitHub и production без отдельного разрешения.
