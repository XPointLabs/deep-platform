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

Любая не определённая этими документами cryptographic transcript, state
transition, downgrade или trust source является блокером спецификации, а не
локальным выбором разработчика.

WP0–WP9 ниже задают milestone scope. Конкретная параллельная работа выдаётся
только по agent-sized package из `IMPLEMENTATION-PLAN-V1.md`; один агент не
получает целый multi-repository WP.

## Обязательный порядок исполнения

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
ADP1 V1 отвергается. Положительные successor-истории, AFP1 forward history,
service/client cutover и физический E2E ещё не готовы.
Публичный freshness API теперь принимает только типизированный ADL1 V2 query,
сверенный с independently verified DAB2: сеть аккаунта, DID2-derived leaf и
точный generation/hash floor обязательны. Сырой leaf допускается лишь во
внутреннем self-check issuer; проверены отказы при чужой сети и неверном floor.
Отдельный Windows x64 тест теперь выпускает настоящий ML-DSA-backed DID2,
строит подписанные ADH1/DTT1 и ADP1 V2 с Merkle-inclusion/consistency,
затем получает positive freshness capability; это protocol-level тест, не
device E2E и не доказательство готовности registry service.
Отдельный DID2-only proof issuer теперь берёт только проверенный V2 journal/map
material, подписывает nonce-bound DTT1 и self-verifies ADP1 V2 тем же proof
verification core через внутренний raw-leaf путь issuer. Публичный reader
дополнительно требует verified ADL1 V2/DAB2 query. Проверены positive real-PQ
выпуск и отказ при чужом head/дублированном
witness; registry durable state и HTTP publication ещё не переключены.
Registry API вместе с XNode пока имеет двойной build graph: обычный
`dotnet test Deep.Registry.Api.slnx` тянет старый protocol NuGet и не
собирается, а `-p:DeepProtocolLocalCutover=true
-p:DeepProtocolSourceCutover=true` проходит 390 тестов. Следующий
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
включение V1 admission запрещено. Endpoint пока **не включён в проде**.

Следующий обязательный пакет: независимый latest-head rollback floor против
подмены ADA2 старой корректной HMAC-копией, provisioning/runbook, V2 proof
publication и клиентский cutover. Только затем physical Android ↔ Windows
account/contact/message/media/group E2E; GitHub Releases не публиковать.

2026-09-23: изолированный `deep-protocol/eng/Deep.MlDsa.ProviderProbe`
подтвердил на Windows arm64 воспроизводимый ML-DSA-65 public key из 32-byte
seed, подпись и rejection подмены сообщения/ключа. Это **не** provider approval:
проверенный Bouncy Castle 2.7.0 не даёт deterministic disposal для объекта
private key с внутренними `byte[]`. Поэтому production-кандидатом выбран
native provider с Deep-owned ABI и вызовом без долгоживущего expanded secret.
Production issuance DID1 должна оставаться заблокированной на этапе cutover;
старый ID не является fallback.

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
  device-signed records остаются в account-owned custody, threshold records
  выпускает authority Mr. X, а XPU1 атомарно несёт exact verified route closure;
  bounded XPA1/XPU1 authority wire, Registry issuer и independently verifying
  client и account-owned device-custody caller уже собраны, но full DCB/pre-key
  orchestration и durable publication ещё не подключены;
  locator-indexed Registry/XNode route lookup и post-publication substitution
  удаляются из production composition;
- оставить `deep-protocol/reference/session-compatibility-v0` только
  immutable offline evidence: он не собирается, не пакуется и не
  загружается.

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
Это пока **не** физический device E2E: нужны
подтверждённая contact publication/authority, два реально созданных аккаунта,
доставка Android↔Windows и, после DR-0006, новый release-compatible ID.
Следующая проверка — sender DPH2, recipient self-retrieve/ContactHello,
ответный DPE2 и crash/replay на тех же двух устройствах; файлы и группы
выполняются только после зелёного текстового пути.
Входящий ContactHello сейчас сохраняется как pending request, но Contacts UI
показывает историю лишь для вручную выбранного `VerifiedConversation`;
recipient discovery/accept и отображение входящего диалога остаются частью
этого же text vertical, а не доказанным UX.

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

- Подключить production genesis/account/device authoring к новому opaque
  `AuthorGenesisDmd1`, зафиксировать verifier-minted current DMD1 в уже готовом
  account-scoped protected store и передать готовый одноразовый Protocol
  agreement lease production caller. Public-forgeable provider и raw keys
  запрещены. Готовые account-wide DPK2 prekey owner,
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

- Реализовать AppShell activation для готового account-scoped DID1/DIA1 entry
  flow: по verifier-minted relationship/conversation ID повторно проверить
  durable peer package, создать DPH2/TRS1 session и открыть новый direct chat;
  добавить physical UI/restart evidence и QR-import.
  Старый `05...` ID, display name, CMI1, route или DCR1 не являются адресом.
  Истечение DCB/XIR/XPS даёт только `TemporarilyUnavailable`, не меняет Deep ID.
- Подключить MAUI client LKG/entry-guard stores и
  fork/freshness ADC1/ADH1/ADP1/ADL1 к production authority fetch/runtime и
  запустить publication/replenishment scheduler поверх уже готовых durable
  XPK1/XPC1 journal и bounded two-replica XPP1/XIC1 transport. Atomic
  activation выполняется только после двух verified final XIC1; public DCB1
  не содержит consumable prekey bytes.
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
