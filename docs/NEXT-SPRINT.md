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

### P0: физический contact → message путь после DR79 rollout (2026-10-03)

Registry и все три XNode уже обновлены; operator provision выполнен с сохранением
ключей, opaque audit rows, floors, counts и nonce ledger. Фактический checkpoint:
[`DID2-PRODUCTION-DEVICE-CHECKPOINT`](DID2-PRODUCTION-DEVICE-CHECKPOINT-2026-10-03.md).
Предыдущие записи ниже про ещё не выполненный rollout относятся к состоянию до
этого checkpoint; full package/evidence repin и release qualification не завершены.

Свежий Android физически завершил `verified-publication`, сохранил аккаунт/сид-фразу
после перезапуска и повторно завершил верификацию на том же аккаунте. Исправлена
потеря contact profile при image upgrade; все три ноды сохранили ключи/floors.
Windows running QA отклоняет несовместимый аккаунт; без action-time подтверждения
UI reset не выполнялся. Следующее: Windows publication, двусторонний contact/text
device сценарий и bounded recovery для expired incomplete Android route.

Отдельный P0: подключить DR54 protected PMA2 role signers/private grant issuer и
полный node PMA2/PMT2/PMS2 authority/replica graph. Mailbox activation всё ещё
требует retired PMA1 topology; включать/оборачивать её запрещено DR52/54. Все три
ноды показывают mailbox authority not ready. File/image и governed-group UI пока
явно unavailable; физические gates для них обязательны после text slice.

### P0: matched issued-head activation и route renewal (2026-10-03)

[DR-0079](survival-program/decisions/DR-0079-did2-publication-issuer-successor.md)
подключает issuer-only signed history без resolver capability, publisher-bound
prior receipts и permanent unsigned-generation fence. Registry focused **29/29**,
Protocol closed API **6/6**, XNode coordination **32/32**, Shared **39/39**; это локальные проверки,
не physical delivery. Следующее: закончить bounded recovery истёкшего incomplete
proposal/winner, выполнить обязательное operator provision и matched package/
consumer repin, затем проверить реальные контакты/messages/assets/groups на
Windows/Android. V2 publication envelope и старый protected journal не читаются;
reset допустим только явно для disposable QA, не для production node keys/floors.

[DR-0078](survival-program/decisions/DR-0078-did2-owned-publication-renewal.md)
подключает local protected current/pending successor и atomic two-replica promotion.
Shared focused **39/39**, без ошибок/пропусков; signed in-process replicas не
подтверждают реальный XNode transport или device recovery.
Server successor связан DR79, но ещё не активирован в установленных клиентах/
production. Не экспортировать resolver-read capability в Registry ради historical
object verification. Expired incomplete proposal/winner, service/PMT rollover,
matched provisioning/build/deployment и physical доставка
по-прежнему блокируют релиз. Новый retained Windows retry и повтор Android после
VPN завершились XRA1/Expiry; аккаунты/recovery сохранены, доставка не подтверждена.

[DR-0077](survival-program/decisions/DR-0077-did2-route-successor-coordination.md)
подключает predecessor-aware private request и независимую проверку successor
до server reservation. Локальные проверки: Registry 28/28, Shared 38/38
(затем 7/7 retained/wire с дополнительными hostile cases), XNode 32/32,
Protocol closed API 5/5; повторные cases не являются новыми unique tests.
matched current/pending activation, publication fencing, matched provisioning/
repin и физическое восстановление всё ещё обязательны. Новый Windows retry
на прежнем аккаунте дошёл до PreKeyPublication/SecureConnectionError, не success.
Серверный сценарий использует настоящий PQ-аккаунт, device/witness подписи,
SQLCipher/PG и TestServer: expiry → exact successor → lost-response replay →
completion; это не физическое принятие нового поколения клиентом.

[DR-0073](survival-program/decisions/DR-0073-did2-exact-route-request-custody.md)
закрывает хранение exact threshold request до dispatch.
[DR-0074](survival-program/decisions/DR-0074-did2-retained-threshold-issuance-evidence.md)
даёт закрытый signed-head retained completion/object API.
[DR-0075](survival-program/decisions/DR-0075-did2-issued-head-response-custody.md)
подключает actual issuance ADH к server winner и protected owned custody.
Связанный локальный сценарий head1 proposal/head2 winner/head3 reopen прошёл
с неизменным request/nonce, последующей публикацией и phase7 reopen без callbacks;
потеря ответа и сбой после adoption проверены отдельно. Это не physical evidence.
Следующее: matched Registry provision/XNode/client repin и activation;
затем подключить protected predecessor/pending CAS и per-generation issuer по
[DR-0076](survival-program/decisions/DR-0076-did2-contact-publication-successors.md),
проверить expiry/restart на том же новом account instance и device delivery.
Локальные object/publication successor API уже проверены с настоящими подписями;
истёкший predecessor не становится current authority. Установленные QA-клиенты
предшествуют этим API и не подтверждают физическое восстановление маршрута.
Registry route journal теперь локально блокирует competing same-generation
выдачу через другой nonce до callbacks, включая pending/restart; адресный gate
24/24. Production provision/activation не выполнены, publication journal ещё
требует аналогичного fencing. Последний Android VPN retry — XRA1/Expiry;
последний Windows proxy-aware retry — NetworkVerification/SecureConnectionError,
IOException с PlatformChainAccepted, не повторное доказательство Expiry.
Текущая journal activation требует explicit reset только incompatible disposable QA;
network genesis, registered keys и production floors сохраняются.

### P0: стабилизация и автоматическое восстановление сети (2026-09-29)

Решение Mr. X от 2026-09-30 возобновляет **физический Android↔Windows E2E
контактов, сообщений, вложений и групп** после component recovery инкремента.
Он также явно разрешил обновить production и тестировать этот сценарий там.
Длительный soak и остаток `NET-STAB-GATE` продолжают блокировать итоговые
release/stability claims, но больше не являются запретом на работу над
message/claim вертикалью. Перед каждым прогоном нужна актуальная проверенная
authority и работоспособный трёхузловой маршрут; готовые негативные проверки
и требования durable commit/ACK сохраняются.

Read-only production check от 2026-09-30 снова получил DID2 readiness 503 при
работающем staking. NTS helper теперь упаковывается в Registry candidate,
но не активирован на production. До device-прогона нужны безопасный first-time
time-floor upgrade существующего manual-anchor deployment, актуальная signed
authority и verified readiness; initialized ADA2/genesis/head floors/nonce
ledger не перепровижинировать. Component DEV recovery не закрывает этот live gate.

Повторная read-only проверка от 2026-10-02 подтвердила 503; сопоставление
только фиксированных source literals с логами выявило stale protected
trusted-time anchor. Автоматический NTS не включён в текущей composition.
Следующий live инкремент: безопасно обеспечить отдельный сохраняемый time
floor и проверяемое reacquisition, затем актуальные signed operational inputs
и readiness. Не выдавать исторический восьмицепочный re-export за fresh
authority и не сбрасывать существующие ADA2/genesis/floors/registered keys.
Операторский переход [DR-0068](survival-program/decisions/DR-0068-manual-to-nts-protected-floor-upgrade.md)
активировал отдельный защищённый floor на production; реальный NTS quorum
получен в source-bound disposable candidate, content-preserving ADH1 renewal
успешно продвинул независимый floor и ADA2. Доказательства и границы этого
инкремента находятся в `SPRINT-HISTORY.md`; operator reports не являются
переносимой freshness capability. Следующий шаг — текущие signed operational
successors и полная восьмицепочная distribution, matched Registry/XNode
композиция, публичная verified readiness и physical contact/text. Активный
публичный Registry пока остаётся на старой manual-time composition; его не
считать исправленным по успеху отдельных операторских команд. Нужны также
ongoing NTS/head/publisher renewal и restart/recovery без ручных time anchors.
Read-only protected snapshots всех трёх нод совпали с установленной
восьмицепочной history; native successor и полный public export подготовлены
локально. Host-install export остановлен политикой инструментов, без обхода
или переключения production. Завершить поддержанный export/rollout перед
device-прогоном; локальная подпись не закрывает live readiness.
Route/publication slice уже прошёл на реальных локальных PostgreSQL/PQ/
SQLCipher, но private grant issuer с настоящими external signer sockets и
последующий Android↔Windows contact/text по-прежнему требуют live evidence.
Общий адаптер внешнего подписанта теперь проверяет конец ответа под исходным
deadline; реальный Linux socket regression passed 6/6, без ключей и без
production issuance. Это не закрывает настройку настоящих role signers,
доступность private issuer или физическую доставку. Его операторские
предпосылки находятся в Registry-owned
[DID2 private mailbox guide](../deep-registry-api/docs/DID2_PRIVATE_MAILBOX_GRANTS.md).

Остановка контейнера — штатная временная недоступность, а не повод сбрасывать
authority, аккаунты или зарегистрированные ключи. После явного запуска
контейнера с сохранёнными volumes, восстановления зависимостей и получения
проверенного актуального состояния нода должна самостоятельно догнать сеть.
В профиле из трёх нод exact-three-hop доставка временно недоступна при остановке
любой из них; это не обещание доставки при двух нодах. Остальные процессы
не должны падать каскадом, терять durable state или требовать ручного repair.
Явно остановленный оператором контейнер не обязан самопроизвольно запускаться.

Agent-sized задачи, владельцы и зависимости находятся в
[`IMPLEMENTATION-PLAN-V1.md`, §1.1](architecture/IMPLEMENTATION-PLAN-V1.md#11-network-stability-first-execution-override-2026-09-29):

| Порядок | Задача | Что должно стать проверяемым |
| --- | --- | --- |
| P0 / 1 | `NET-STAB-SPEC` | Причины отказов воспроизведены; согласованы restart/catch-up и безопасное обновление времени/истории |
| P0 / 2 | `NET-STAB-HISTORY` | Проверенный bounded catch-up не ломается после 64 head successors и не требует регулярного ручного root repair |
| P0 / 2 | `NET-STAB-AUTH` | Registry обновляет operational heads и обслуживает proofs после expiry/restart без reset |
| P0 / 2 | `NET-STAB-OPS` | Автоматический lifecycle времени, views и traffic keys; предупреждения до исчерпания ресурса |
| P0 / 3 | `NET-STAB-NODE` | Нода переживает недоступность зависимостей и восстанавливается с прежней identity и durable state |
| P0 / 3 | `NET-STAB-CLIENT` | Клиент переживает остановку сети; reconnect не требует нового аккаунта или потери очереди |
| P0 / 4 | `NET-STAB-INSTALL` | Supported installer и Docker restart/recreate сохраняют state, права и recovery inputs |
| P0 / 5 | `NET-STAB-GATE` | Реальная Docker fault matrix, длительный soak и локальный Android/Windows reconnect подтверждены |
| Затем | DID2 claim → DPH2 → текст | Возвращение к существующему physical messaging gate на стабильной commit matrix |
| P1, отдельный инкремент | `NET-MEMBERSHIP-DESIGN` | Децентрализация membership/distribution с текущим контрактом, без изменения ABI |

Начальные проблемные наблюдения для воспроизведения: stale protected trusted-time
anchor у Registry; истёкшая DEV mailbox authority при запуске XNode; расхождение
общего health и proof/ONION readiness; proof HTTP 429 и фоновые polling budgets;
ограниченный хвост signed history при регулярном renewal. Это входы расследования,
не доказательство исправления и не новый live health snapshot.

Локальный инкремент от 2026-09-29 **не закрывает пункты 1–4 целиком**.
Причины и fault matrix записаны в
[DevOps recovery runbook](../deep-devops/docs/NETWORK_STABILITY_RECOVERY.md),
read-only API заморожен в
[DR-0013](survival-program/decisions/DR-0013-readonly-directory-issuance-readiness.md).
Завершённые component changes и проверки ведутся в `SPRINT-HISTORY.md`.
Автоматический authenticated NTS acquisition, защищённый lower time floor,
повторное получение upper interval после boot, sealed исторический catch-up,
delegated operational-view renewal и single-flight DID2 network reconnect
реализованы как проверенные component candidates. Локальная сеть теперь
находится в [едином `deep-dev`](../deep-devops/docs/DEEP_DEV.md): нативный ARM64,
Registry, независимый PostgreSQL floor, publisher и три ноды. ML-DSA включён
точным бинарником из GitHub CI, без локальной пересборки C++.

Реальная короткая Docker matrix: stop/start каждой ноды, Registry, floor,
publisher и всех контейнеров вместе прошли с сохранёнными mounts/state;
восстановление current proof/ONION capabilities заняло 3–27 секунд.
Она не является 20-cycle, Docker-engine restart, long-TTL или physical MSG gate.
Длинный admission/catch-up прогон выявил дорогой повторный replay каждого
исторического префикса: исправлены incremental sparse-map update и единая
проверка всех prefix roots/capability sets. Повторный Docker прогон на
сохранённом journal прошёл: 130 настоящих DEV admissions при трёх offline
нодах, successor span 129, все три verified ONION capabilities восстановились
за 46 секунд без reset/rekey.

Остаток P0:

Уточнение от 2026-09-30: full Docker Desktop shutdown воспроизвёл отсутствие
автозапуска при `unless-stopped`; в `deep-dev` исправлено на `always` с отдельным
persistent maintenance Stop/Start. Один полный Engine cycle прошёл, включая
60 секунд current proof/ONION readiness и неизменность custody/mounts.
Повторный цикл **BLOCKED**: Docker Desktop 4.45.0 Windows ARM64 падает на своём
`dockerInference` IPC socket ещё до старта Linux Engine. Затем оператор восстановил
Docker без перезагрузки Windows; этот blocker больше не текущий. По его указанию
routine recovery теперь только через stop/start контейнеров `deep-dev`; EngineFault
требует отдельного явного разрешения и `-ConfirmEngineShutdown`. Два StackFault
цикла прошли: 20 секунд offline, восстановление 26/16 секунд, 30 секунд stable,
custody/IDs/mounts сохранены. Scoped ExpiryFault тоже прошёл на свежей ARM64 сборке:
signed 180-second view, 200 секунд offline всех контейнеров, recovery 15 секунд,
stable current proof + 3 ONION 60 секунд, прежние Registry/node keys/IDs/mounts.
Registry retry после transient NTS/floor loss ускорен до bounded backoff 5/10/20/40
секунд с cap обычным interval; crypto/custody checks не ослаблены. Старый startup
CryptographicException burst в этих scoped прогонах не повторился; добавлены
закрытые safe reason codes для следующего recurrence. One-hour head/7-day root
outage и полный NET-STAB этим не закрыты.
Это не разрешение на reset,
продление expired authority или ослабление TLS/подписей. Полный NET-STAB gate
и messaging E2E остаются открытыми; подробности — в DevOps recovery runbook.

- `NET-STAB-SPEC/HISTORY`: multi-page crash/fork Docker evidence для DR-0014;
  обычный >64-head restart/catch-up уже проверен, negative fork/CAS — unit gates;
- `NET-STAB-AUTH/OPS`: несколько настоящих current+next traffic/TLS key
  promotions с безопасным staging следующего slot, long-TTL outage, crash
  boundaries и предупреждение до исчерпания offline delegation. Retention
  installed current/next и renewal view не заменяют бесконечную key rotation;
- `NET-STAB-NODE/CLIENT`: завершить shipping DID2 MSG inbox/outbox/session
  composition и outcome-unknown reconciliation; новый reconnect пока
  восстанавливает изолированный proof/closure/pre-key diagnostic composition.
  Physical Windows/Android очередь и доставка выполняются отдельным агентом,
  не CI и не unit scheduling delegate;
- `NET-STAB-INSTALL`: проверить supported installer/recreate на этой topology,
  сохраняя identities и protection volumes; shell/config regression уже есть;
- `NET-STAB-GATE`: расширенная fault matrix и 72 фактических часа soak пока
  **NOT-RUN**. Soak выполняет Mr. X; device E2E — отдельный агент локально.
  Legacy `deep-survival-dev` удалён из работающих stacks и не является стендом.

Дополнительной operator authority для этих задач не требуется; существующая
делегация Mr. X сохраняется. Production rollout, изменение контракта, reset
или включение macOS не выполнялись этим инкрементом.

Итоговое закрытие `NET-STAB-GATE` требует evidence для
повторяемого stop/start каждой ноды, restart Registry, полного Docker restart,
простоя дольше действующих operational TTL и нескольких key/view/head rotations.
Проверяется также возврат после более 64 head successors, отсутствие ручного
reset/re-key/перевыпуска genesis и сохранение anti-rollback/fork protection.
Точные fault cases и evidence requirements принадлежат пакету gate, не
дублируют wire или retention semantics в этом файле.

Мосты, новые carriers и anti-censorship matrix (`WP6`) отложены за пределы
текущего инкремента «стабильность → сообщения»; они не блокируют этот recovery
gate. Это не разрешает direct/plaintext downgrade и не закрывает соответствующие
будущие release gates. Финальный public-release scope автоматически не сокращён.
Расширение смарт-контракта, on-chain IP/контакты и переход на новый DID не входят
в стабилизацию. Полная замена Registry распределённым account consensus не
добавляется как prerequisite первого текстового E2E: membership и account
freshness остаются разными задачами.

### Ритм вертикальных проверок

Текущий prerequisite (2026-09-28): после ручного reset созданы новые physical
Windows/Android HTTPS QA аккаунты. Directory checkpoint продолжен до head
25/tree 10 без reset floors. XNode `6764cbf` прошёл source-cutover tests 826/826,
owner CI и rollout installer на всех трёх seed с сохранёнными ключами.
Оба physical клиента завершили verified durable XIC1 pair и restart без reset.
Один traffic HTTP 429 всё ещё наблюдался: отсутствие rate limiting не заявлено.
Штатное renewal продолжило directory до 27/tree 10. Обновлённые устройства
повторно проверили protected publication completion со свежей authority;
это не новый claim или доставка сообщения. Следующий незакрытый
инкремент — DID2 atomic claim/DPH2 и доставка текста; физическая проверка
durable client DNH2, inventory successor и автоматический operational lifecycle
остаются нужны. На 2026-09-29 свежие device proof-запросы fail-closed:
подписанный XNV1 не покрывал текущий issuance interval. Этот конкретный blocker
устранён monotonic successor: три ноды получили view generation 2 через
поддерживаемый installer, protected DNH2 revision продвинулась до 2 без reset.
Полная история распределяется через HTTPS; directory checkpoint продолжен
до target head 29. Текущие Shared DNH2 builds открыты на Windows и Android,
но physical restart/changed-tip gate ещё не закрыт. Старые projection-only
QA accounts ожидаемо отвергнуты без migration; Windows сброшен через UI по
подтверждению владельца и новый аккаунт создан им. Свежие physical попытки
сначала не завершили publication: Windows сообщает request aborted или bounded
AccountProof timeout, Android — bounded PreKeyPublication timeout. Последующий
Android candidate подтвердил protected XIC1 completion и fresh reauthentication
после process restart без reset; changed-tip restart остаётся отдельным gate.
Windows пока получает AccountProof/TransportIo; local Linux Docker control
проходит на том же host. Причина Windows-dependent path ещё не доказана. Network
authority и три healthy XNode сами по себе не доказывают XIC1 completion,
claim, handshake или delivery.
Раздельные показания Android stageFailure/networkOutcome не приравнивать к delivery.
Оставить отдельной задачей выяснение причины intermittent Windows
concurrent authority-lock rejection: isolated и полный повтор passed, причина
первого protected-storage-rejected не доказана. Актуальные service facts — в
[DevOps runbook](../deep-devops/docs/DID2_FLOOR_PRODUCTION_CANDIDATE.md),
device observations — в
[MAUI evidence note](../deep-client-maui/docs/DID2-HTTPS-DEVICE-2026-09-28.md).

После `NET-STAB-GATE` P0 выполняется по законченным пользовательским сценариям,
а не по числу изменённых файлов. Первый messaging инкремент — DID2 contact/bootstrap и текстовое
сообщение Android↔Windows: публикация pre-key, атомарный claim, DPH2,
зашифрованная отправка, приём, durable inbox commit до ACK и повтор после
перезапуска. После него — тот же транспорт для изображения/файла с проверкой
целостности и возобновления; затем создание группы, доставка и смена состава.
Это порядок выполнения, не сокращение release scope.

Первый незакрытый code boundary: заменить V1 XPK1/XPC1 encrypted prefix и
receipt consumers согласованным V2 receipt → DPH2 sender/responder путём,
затем добавить Protocol-owned durable initiator preparation и shipping
contact/MSG composition. DID2 outer header и прошедший request journal gate
не заменяют эти части. Не подключать V1 receipt adapter или synthetic test
receipt для обхода этой границы.

Локальный current-recipient verifier по
[DR-0016](survival-program/decisions/DR-0016-did2-prekey-claim-receipt.md)
уже создаёт закрытый V2 receipt только после проверки текущей DID2 identity,
точного service binding, двух выбранных подписей и полного protected-time
interval. Он не выдаёт session/ACK: следующий шаг — согласованный encrypted
prefix и sender/responder cutover, затем durable preparation и device delivery.

Результаты прежних loopback/HTTPS/ingress диагностики находятся в
[`SPRINT-HISTORY.md`](SPRINT-HISTORY.md) и repository evidence notes; они не
заменяют delivery gate. Registry и seed1–seed3 — production, не удалённый UAT;
тестирование разрешено Mr. X до явного появления пользователей. Сохранять
зарегистрированные ключи, genesis и rollback floors. Не выпускать новую
generation-zero цепочку и не продлевать подписанные интервалы в verifier.

Account-owned durable DNH2 custody по DR-0012 реализована в локальном candidate:
полный защищённый policy/PMT predecessor заменяет process-local cache и
tuple-only restart fallback. Текущие committed diagnostic device builds
собраны и открыты; ещё нужен физический restart с изменившимся signed tip.
Локальные gate results находятся
в истории, не считаются physical evidence. Старые projection-only QA accounts
несовместимы и требуют explicit application-owned reset, не migration.
Inventory successor/replenishment должен сохранять одноразовость и lineage,
а operational head/time/checkpoint lifecycle — независимые observations и
existing predecessor. Ни reset, ни silent re-key не заменяют эти задачи.
Обновить proof-aware Registry readiness: при включённом proof endpoint
проверять пригодность текущего подписанного view/issuance interval без
расходования клиентского nonce ledger. До этой проверки directory readiness
200 не подтверждает proof readiness. Завершить автоматический operational
lifecycle поверх уже выполненного successor с retained lineage и installed
traffic keys; не исправлять expiry в verifier. Снять текущий Windows physical
publication abort/timeout до подключения следующего инкремента.
Files/images и группы проверяются на том же production messaging пути.

Сохранить отдельное regression investigation для transient Windows
`Access denied` на durable replace старого ContactRouteClosure fork test:
focused и полный неизменённый повтор passed, но причина первого отказа не
доказана. Не добавлять catch/retry, который позволяет выдавать authority
раньше durable fork latch. Evidence текущего инкремента — в истории.

Незакрытые call-path задачи первого инкремента (2026-09-28):

1. Подключить DID2 contact/bootstrap и отправку/приём к
   `MauiProgram.Clean`: сейчас это account-only граф. Сохранить существующий
   chat/contact shell, но связать controls только с новыми capabilities.
   Старый Windows `.e2e` package не является DID2 evidence. Перед проверкой
   установить текущие физические сборки через supported scripts.
2. Заменить V1 `Xpk1Codec` в `ContactServiceRuntime.Decode` и
   `ContactServiceOpaqueFacade.ClaimAsync` новым DID2-only claim owner.
   Verified V2 publication уже работает в отдельном
   `DeepIdV2InventoryCommitStore`, не в V1 `contact-service-v1`.
   Нужны общий quorum prepare/commit journal, current publisher/device proof,
   две проверенные publication receipts, manifest/member binding, atomic
   one-time selection, bounded last-resort counter, operation/request exact
   replay и conflict/fork/crash/restart tests. Изменение одного parser не
   активирует claim. Удалить старый runtime из release graph, не адаптировать
   его к новому account ID.
   Локальная V2 reservation/completion custody реализована отдельно от V1:
   общий inventory lock, signed snapshot, exact proposal replay, one-time burn,
   persistent last-resort counter и completion от typed two-signature verifier.
   Opt-in Development/UAT V2 claim endpoint теперь соединяет первый ranked
   coordinator, authenticated peer prepare+complete, оба durable read-back,
   independently verified current publisher/device proof и verified XIC1 pair.
   Outer ONION request/result и Shared path authority читают XPK1/XPC1 только
   как V2. In-process HTTP endpoint tests не являются socket/TLS/device E2E.
   Ещё подтвердить реальный authenticated H2/ONION deployment, закрыть global
   admission/rollback/handover и recovery expired pending operations, затем
   соединить account-owned claim/outbox с DPH2. Production activation flag
   остаётся закрытым. Exact DCB1 closure проверяет клиент; XNode
   не должен получать plaintext DCR1/DCB1 для её замены.
   Инкремент 2026-09-30: добавлена внутренняя Shared V2 claim transport
   boundary: один exact XPK1 через выбранный ONION coordinator, повторная
   проверка current placement после ответа, обе replica signatures и
   inventory inclusion. Refusal/unknown/cancellation не выдают capability
   и не запускают автоматический второй claim. Целевой прогон: 4/4 теста,
   11 сценариев; полный Shared Release gate прошёл 213/213 (38m20s).
   Native integration cases имеют существующую runtime-dependency метку и
   остаются в полном Windows gate; portable Linux gate их не исполняет.
   Следующий инкремент соединяет этот transport с account/instance-bound
   exact-request SQLCipher journal до сетевого вызова: replay, concurrency,
   protected floor-before-SQL и substitution latch. Это только reservation;
   ещё нужны durable logical contact intent, initiator secret/preparation
   recovery, authenticated result custody, current peer/DBC closure, DPH2,
   shipping activation и physical evidence. Полный gate нового инкремента
   нельзя подменять указанным выше результатом 213/213.
3. Завершить DID2 permanent resolver publication/resolution:
   `DCR1/XPU1/XPA1` V2 candidate должен потреблять current account/DCA1,
   route authority, verified placement и publisher signature, затем durable
   two-replica commit. Локальный crypto/parser candidate не является
   contact acceptance. Public DID2 locator/read-key derivation не заменяет
   current recipient closure.
   [DR-0039](survival-program/decisions/DR-0039-did2-opaque-publication-consumer.md)
   закрывает sole V2 store reader и локальный opaque/dual-receipt/restart slice.
   Следом нужны shipping private coordination, authenticated remote replicas,
   текущий resolve/recipient path. Protected client commit-result custody
   следует [DR-0040](survival-program/decisions/DR-0040-did2-owned-publication-commit.md);
   локальный slice не является physical E2E или production activation.
   [DR-0041](survival-program/decisions/DR-0041-did2-permanent-contact-resolution.md)
   добавляет descriptor bootstrap, independent current peer proof и проверку
   настоящих permanent-read receipts. Соединены внутренний single-read owner,
   account-bound proof fetch и held-account floor recheck; shipping UI/remote
   path пока не активированы. Удалить старый DID1 resolver/recipient pipeline
   после cutover consumers. [DR-0042](survival-program/decisions/DR-0042-did2-route-directory-issuance-anchor.md)
   исправляет ошибочное смешение signed issuance anchor и independently current
   peer authority: unrelated DID2 admission больше не требует перепубликации
   неизменного контакта. Connected local regression проверяет старые ciphertext,
   route и commit после настоящего admission, двух store restart и нового proof.
   Новая выдача с прежним anchor и stale XPA dispatch отвергаются.
   Network view/head/key/expiry successor по-прежнему требует полного
   generation/lineage renewal с protected pending state и atomic two-node
   predecessor CAS; local stores не являются physical E2E.
4. Соединить verified V2 `XPC1` с DID2-only DPH2/DAO1, ContactHello и DPE2
   send/receive. Проверить обе replica signatures, exact inventory/member,
   текущий peer proof и handshake transcript. Inbox durable commit должен
   предшествовать ACK; resend/restart не создаёт второй handshake или message.
   Старые ContactV1 receipt и DPH2-пути не являются fallback.
   [DR-0043](survival-program/decisions/DR-0043-did2-claim-current-network-and-clock.md)
   закрывает current ADH/XNA/XNV pairing и protected claim clock continuity;
   single dispatch имеет cancellation/30s bound, exact request/result custody.
   Connected owned publication/read → claim → Hello/Accept/text lane обнаружил
   ошибку full-inventory-versus-later-DCB interval. Исправление следует
   [DR-0044](survival-program/decisions/DR-0044-did2-prekey-service-contact-lifetimes.md);
   connected local run passed **1/1**, **0 skipped**, **14m09s** с actual native
   DPH/SQLCipher Hello/Accept/text и exact retry/crash recovery. Сетевые adapters
   synthetic; shipping runtime/remote transport и physical evidence ещё открыты.
   [DR-0045](survival-program/decisions/DR-0045-did2-owned-resolved-contact-claim.md)
   переносит подготовку XPK в account owner: verified publisher XPS, protected
   preclaim intent и atomic get-or-reserve без новых timestamp на retry.
   Production compile — **0 warnings/errors**; connected regression
   **1/1 passed**, **0 skipped**, **17m18s**: реальный owner вместо ручного
   XPK и byte-exact повтор подготовки. Composed initial events/Hello,
   transport activation и физическая доставка остаются следующими шагами.
   [DR-0046](survival-program/decisions/DR-0046-did2-owned-attachment-offer.md)
   добавляет owned AttachmentOffer из stable DR31 asset в общий protected
   text/event counter и независимую проверку asset custody/expiry перед DPE2.
   Structural/SQL очередь text→offer→text и негативы **17/17 passed**,
   **0 skipped**, **1m42s**. Native connected extension **1/1 passed**,
   **0 skipped**, **25m52s**: stable owned file → owned offer → native DPE2 →
   authenticated receiver manifest → exact content integrity (chunks copied
   locally), exact send/receive replay, next shared text sequence, kind
   substitution and expired-asset reject. Это НЕ remote BLOB/device delivery.
   Key-free offer history/restart projection **2/2 passed**, **0 skipped**, **15s**;
   оно не выдаёт DAM key или current offer/cancel/download authority.
   Latest narrow history/bootstrap/cancellation batch **9/9 passed**, **0 skipped**,
   **34s**, artifact `did2-owned-history-bootstrap-narrow.trx`. Unicode text/reopen,
   owner/limit checks, corrupt hash and hostile SQL BLOB/type rejection covered.
   [DR-0047](survival-program/decisions/DR-0047-did2-owned-peer-refresh.md)
   сохраняет authenticated seed's public DID2 atomically beside catalog/floor;
   обычные методы аккаунта самостоятельно получают fresh peer proof, а не
   принимают retained proof от caller. Missing bootstrap не восстанавливается;
   changed endpoint heads пока отвергаются. Native owned TTL refresh **1/1 passed**,
   **0 skipped**, **7m40s**, artifact `did2-owned-peer-ttl-refresh.trx`: same peer
   credential independently refreshed after old proof expiry; ratchet floor
   unchanged; missing bootstrap rejects before a network query without repair.
   Registry/time synthetic; real-clock/shipping/device evidence остаётся gate.
   Finish shipping activation of the
   [DR-0048](survival-program/decisions/DR-0048-private-contact-coordination-peer-authentication.md)
   private backend and
   [DR-0049](survival-program/decisions/DR-0049-did2-three-hop-coordination-carrier.md)
   exact-three carrier: provision intended registered public node access keys,
   close vector/schema/API/package graphs, promote the account-owned client entry
   from [DR-0051](survival-program/decisions/DR-0051-owned-permanent-contact-client-entry.md)
   beyond its opt-in HTTPS diagnostic (publication after prekey commit and actual
   owned peer resolve), and promote the candidate node composition from
   [DR-0050](survival-program/decisions/DR-0050-did2-contact-service-composition.md).
   Complete the connected grant path under
   [DR-0052](survival-program/decisions/DR-0052-did2-mailbox-authority-distribution.md):
   provision matching complete public bundles from retained signed ceremony
   inputs (no old-bundle converter); bind current PMA2/PMT2 and the direct DID2
   result verifier to private issuance and actual credential installation/use.
   On 2026-10-02 the actual public distributor still returned a seven-chain
   header, rejected by the current client. The retained signed ceremony prefix
   has been re-exported as eight chains without changing keys/genesis/floors;
   it is historical distribution, not live freshness. Activate a matched current
   Registry distributor, fresh operational history and three-node composition
   before retrying physical publication. Installer preparation/staging now retain
   PMA2 byte-identically and reject missing/noncontiguous public roles; their
   local custody tests do not close this deployment gate.
   [DR-0053](survival-program/decisions/DR-0053-did2-mailbox-grant-restart-custody.md)
   connects owned Deposit/Retrieve holder/request/winner custody and the internal
   selected-entry carrier; Retrieve derives only from the protected verified own
   publication. [DR-0054](survival-program/decisions/DR-0054-did2-private-mailbox-grant-issuance.md)
   connects the opt-in node acquisition branch, current-NET/two-store verifier,
   private HTTP issuer and external hash-only exact-winner journal. Verify the
   composed private HTTP/signer/proof/floor path, provision its independent journal
   and matching role signers/bundles, and finish client credential use. A retained
   success does not enable a deployment or device delivery by itself.
   [DR-0055](survival-program/decisions/DR-0055-did2-owned-mailbox-credential-installation.md)
   connects protected winner read-back to owner-held current-only SQL credential
   installation; its focused interruption/restart evidence is recorded in
   `SPRINT-HISTORY.md`. Finish the connected sender under
   [DR-0056](survival-program/decisions/DR-0056-did2-owned-mailbox-message-dispatch.md):
   transactional MAU2 preparation, protected exact request/counter custody and
   selected-entry dispatch with an owner-only
   holder loan; no caller/UI signer injection. Own Retrieve must materialize
   authenticated events before semantic/transport ACK. Installation is not E2E.
   Ordinary incoming dispatch uses
   [DR-0057](survival-program/decisions/DR-0057-did2-owned-incoming-session-selection.md)
   for protected-catalog selection and independent endpoint refresh. Finish its
   connected consumer plus mailbox/initial orchestration; selection alone is not ACK.
   Owned polling and semantic-before-ACK follow
   [DR-0058](survival-program/decisions/DR-0058-did2-owned-mailbox-retrieve-and-ack.md).
   Initial sender composition follows
   [DR-0059](survival-program/decisions/DR-0059-did2-owned-initial-mailbox-dispatch.md)
   through actual retired sender custody and the same owned Store engine;
   finish connected initial Store/Retrieve/Hello/ACK evidence before activation.
   [DR-0060](survival-program/decisions/DR-0060-did2-account-random-sqlcipher-key.md)
   removes redundant password derivation for the random DSV2 account key with
   an explicit local generation3 clean break; verify storage negatives, then
   connected/device timing with unchanged authority/dispatch deadlines.
   Its connected initial/text recipient checkpoint has passed locally; the
   exact partial/composite evidence belongs to `SPRINT-HISTORY.md`, not device
   readiness. Delayed first receipt must use the committed-recipient claim
   boundary in [DR-0061](survival-program/decisions/DR-0061-did2-committed-claim-recipient-verification.md),
   not the short request's new-mutation deadline; finish its positive/negative
   Protocol gate and API snapshot repins together with the connected scenario.
   Finish sender retry verification, reverse contact-accept transport under
   [DR-0062](survival-program/decisions/DR-0062-did2-private-contact-mailbox-route.md).
   [DR-0063](survival-program/decisions/DR-0063-did2-contact-reply-route-embedding.md)
   freezes mandatory replacement Hello/Accept and bounded version2 acceptance
   custody. Its code now embeds actual own phase-7 routes, verifies received
   packages independently, and derives ordinary outbound routes only from
   authenticated retained control events, without per-message public resolution.
   Its joined native reverse Store/Retrieve/ACK and subsequent text checkpoint
   passed (exact evidence in `SPRINT-HISTORY.md`), not on sockets or devices.
   [DR-0064](survival-program/decisions/DR-0064-did2-owned-initial-contact-draft.md)
   connects exact initial-size preflight and protected account-owned Init/Hello
   custody before claiming. Its internal completion/restart checkpoint and the
   [DR-0065](survival-program/decisions/DR-0065-did2-contact-application-command-boundary.md)
   business Start/Accept/SendText/List native vertical passed locally. MAUI now
   consumes these commands in the opt-in HTTPS contact/chat UI; compile and
   UI state tests are not physical delivery.
   [DR-0067](survival-program/decisions/DR-0067-did2-ordinary-store-completion-and-ui-retry.md)
   now implements protected ordinary Store completion and original text/operation
   projection plus explicit UI retry after restart. Joined native interruption/
   lost receipt/reopen and completion-boundary crash assertions passed; actual
   physical UI restart remains to close, then matched committed-source/live authority and actual Windows/USB
   Android contact/accept/text/restart evidence. Older local accounts
   require explicit reset for current mandatory roots/registration. Finish route renewal and
   attachment/group and shipping consumers
   plus matched live/device activation. The mandatory protected read root requires
   explicit reset of older isolated QA accounts, never implicit repair.
   Application/mailbox random-key generation follows
   [DR-0066](survival-program/decisions/DR-0066-did2-application-sqlcipher-random-key.md):
   focused storage/custody and the connected unchanged semantic/ACK deadline
   checkpoint passed; qualified physical rebuild/reset/device evidence remains.
   The held mailbox path must use source-owned readonly existing floors, not a
   refresh API which would recursively reacquire the account lease. The internal
   loan/transport overload is a candidate until its connected owner preparation
   and dispatch consumer plus interruption evidence are complete.
   Machine schema/vectors/API bindings, complete gate and matched
   consumer repins remain mandatory before rollout. Registry's stale direct
   caller-supplied initial-session assertions have been removed; its own/peer
   proof/floor assertions remain. Run the current owned claim/receiver coverage
   in Shared and the complete Registry graph at the final batch gate, never
   restore removed APIs to make historical tests compile.
   Its explicitly enabled DID2 terminal now connects publication/resolve and
   authenticated remote replicas using signed service time; default remains
   closed and existing Development/UAT guards remain. Joined durable restart,
   lost-response/exact replay and verified resolve pass in-process, not on a
   socket or device. Close production root/clock/floor and package activation,
   then actual socket TLS/three-host
   transport and Windows/USB Android evidence. No direct Registry fallback.
5. Завершить inventory successor/replenishment с exact durable predecessor,
   monotonic epoch и сохранённой one-time custody; физически проверить
   successor, exhaustion и lost-response replay. Успешная initial publication
   не закрывает этот lifecycle.
6. Удалить V1 ADP1 `ContactVerifiedAuthoritySnapshotSource` из остальных
   consumers, включая group control. Согласовать единый новый production
   Protocol package/pin/lock graph для XNode, Registry и клиентов:
   source-cutover CI не доказывает готовность обычного NuGet build.

Физический gate текста: два текущих DID2-аккаунта Android/Windows, текущий
подписанный каталог, контакт/bootstrap, текст в обе стороны, restart,
дедупликация и ACK после durable commit, отказ на V1 и подменённом claim.
Следом на том же пути — image/file integrity/resume и группы с membership
change. Эмулятор, TestServer и старые UI-тесты не засчитываются. Результаты
готовых host/source/publication gates находятся в истории и owner evidence,
не повторяются здесь как незавершённые rollout задачи.

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
account-only. После clean-break DPH2 tag 20 и transcript используют exact
DID2; `Dph2InitialClaimPreview.VerifyCurrentInitiatorAsync` проверяет только
инициатора по `VerifiedDeepIdV2DirectoryFreshness`/`VerifiedAdc1V2`.
Получательская публикация, V2 XPC1 и право promotion ещё не замкнуты, поэтому
этот узкий verifier не открывает отправку или ACK и не является device E2E.

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
`MauiProgram.Clean` уже входит в DID2-only account owner. Его сетевой и
message composition остаётся закрытым до V2 contact/prekey/ContactHello
closure; установленные старые клиентские пакеты не подтверждают новый путь.

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
XNode получил отдельный opt-in UAT/development DID2 proof boundary: он
повторно проверяет точную подписанную XNA1/DTS1 lineage от независимого
genesis pin, восстанавливает подписанный DID2 genesis и защищённый head
journal, а на старте отказывает при неполной конфигурации, V1
`ContactAuthority` или production profile. Локальный XNode gate прошёл
241 unit, 396 integration и 107 profile tests. Это ещё не подключено к
XPP1/XIC1 публикации или XPK1/XPC1 claim, не включает сообщения и не
является физическим E2E. Следующий шаг — включить этот proof reader в
operation-scoped V2 publication/claim с текущей DCA1 capability, затем
проверить текст на новой Windows↔Android паре до media и групп.
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
exact scope/member bytes и восстанавливает sealed secrets. Теперь он подключён
к account-owned STORE-V2: отдельный key domain, protected install marker и
add-only exact-XPP1 tip до возврата publication eligibility. Полный SQL commit
предшествует tip, поэтому прерывание между ними восстанавливается из
проверенного staged inventory; потеря SQL после tip при сохранённом protected
state отказывает fail-closed. Marker-only сбой первого открытия без tip
восстанавливает только пустую базу, не сбрасывая аккаунт. Это пока не выдаёт
XPP1 в сеть.
Текущий DID2 closure/placement теперь имеет отдельный UAT-only peer receiver:
он после HTTP/2 peer authentication повторно проверяет signed current
NETCODEC placement и долговечно собирает XPP1 V2 на выбранной реплике.
`CandidateReady` доказывает только локальную сборку кандидата; это не XIC1,
не активация inventory и не device E2E. На UAT peer-only пути теперь есть
отдельная операция final commit: она требует exact replay долговечного Commit
fragment, повторно проверяет DID2/device authority и независимо полученный
NETCODEC placement, затем атомарно продвигает service-capability-keyed
inventory lineage и возвращает один подписанный XIC1. Потеря или повреждение
активного состояния и конфликт epoch/operation отказывают fail-closed.
Следующий обязательный шаг text vertical — двухрепличная отправка и клиентская
проверка обоих final XIC1, затем DPH2 claim/receive и сообщения
Windows↔Android на физических устройствах.
V1 inventory store/codec не использовать как обходной путь.
Shared account owner теперь умеет после проверки DID2-аккаунта и protected
inventory tip читать exact публичный пакет XPP1/DID2/DCA1/XPS1 из SQLCipher
и верифицированного genesis evidence для повторяемой
отправки; это не выдаёт sealed DPK2 secrets и само по себе не авторует
сетевую публикацию. ONION ContactResolve теперь структурно принимает только
bounded DID2 XPP1 V2, отличает staging ACK от финального XIC1 и отвергает
retired V1 carrier. XNode UAT terminal теперь принимает V2-фрагмент только
на локально выбранной реплике по заново полученному DID2/NETCODEC proof,
сохраняет его в тот же журнал и после полного Commit может вернуть один XIC1.
Shared теперь имеет отдельный, ещё не смонтированный DID2 V2 отправитель:
он проверяет текущий placement, посылает одну exact sequence к обеим выбранным
ONION exit и отдаёт результат только после проверки пары подписанных XIC1.
Обнаруженный смешанный XPS1 V1 support вынесен в clean-break: DID2 путь теперь
требует XPS1 version 2/suite `0x0301`, V2 signature domain, generation-1
genesis и version-2 ArtifactRef; локальный DPD1 signer умеет его авторовать.
V2 inventory author теперь потребляет один подписанный XPS1 object вместо
раздельных raw service capability и artifact reference; несогласованные
device/generation/policy/time отвергаются до генерации private pre-keys.
PKV2 schema generation 2 атомарно сохраняет exact XPS1 V2 с XPP1/DPK2,
сверяет его подпись, scope и XPI1-reference при записи и reopen; старую
schema generation 1 не мигрируем. Отправитель принимает только защищённый
публичный пакет владельца аккаунта. Account service теперь вызывает этот
отправитель и add-only сохраняет exact verified XIC1 pair в защищённом слоте,
привязанном к exact XPP1; запись не заменяет свежую проверку placement/claim.
Клиентский account publisher теперь принимает только отдельный DID2
`DeepIdV2ContactPathAuthoritySource`, без pre-cutover DID1 source/overload.
Каждый mint получает независимый nonce-bound proof защищённого локального
DAB2/DMD1, проверяет подписанную NETCODEC closure, фиксирует и перечитывает
network LKG; cold restart допускает только exact current-floor rehydration.
Shared production-регрессия: 146 passed, включая 6 новых source/API cases.
Это реальные native ML-DSA/account SQLCipher checks с in-memory HTTP/network
test adapters, не TLS/ONION/device evidence. Identity-neutral closure fetch
теперь реализован отдельным bounded NCQ2/NCP2 HTTP adapter. HTTPS UAT MAUI
вызывает полную проверку network context после admission; loopback probe
остаётся admission-only. Операторский full-history public bundle подготовлен;
TLS deployment и physical проверка этого пути остаются открыты.
Account-owned network floor теперь
подключён к DSV2 SQLCipher под account lease: отдельный root-kind, проверка
instance/account/genesis pin и add-only SecureStorage marker перед SQL CAS.
Новые проверки проходят через настоящий durable network floor; fork latch
не очищается, rollback/подмена/потеря SQL и сбой marker-before-SQL отказывают.
Focused source/custody gate: 8 passed; полный Shared gate — 148 passed,
включая отказ старого store после explicit account reset. Shared custody
checkpoint `ae2503f` запушен; зависимые MAUI clean — 19 passed,
Windows build — 0 warnings/errors, MAUI smoke — 118 passed.
Shared CI `36368366668` завершился success для checkpoint `ae2503f`.
Новый distribution-only NCQ2/NCP2 candidate не меняет подписанные NETCODEC
bytes, account/freshness authority или protected floor. Protocol focused codec
gate: 20 passed; полный Protocol gate: 1821 passed / 11 native skipped,
MembershipRoutes — 131 passed, ProfileCarrier — 105 passed. Actual assembly/API
graph и строгий global registry gate прошли. Реальный native ML-DSA + SQLCipher
source/custody fixture теперь проходит через тот же HTTP wire adapter: 8 passed.
Registry добавляет выключенную по умолчанию HTTPS выдачу одного public bundle
без signing keys/account input/route selection; HTTP pipeline gate — 8 passed,
полный Shared — 152 passed, Registry source-cutover — 431 passed. Новые
checkpoints: Protocol `5e548ef`, Shared `f3992cc`, Registry `31d7a14`.
Все три checkpoints запушены. Зависимые MAUI clean — 19 passed,
Windows win-arm64 build — 0 warnings/errors, smoke — 118 passed.
Protocol Debug/Release actual graph gates прошли; DNP1 evidence ownership
mapped=219/packageMissing=0. CI `36370954972` (Protocol), `36370957918`
(Shared), `36370961815` (Registry) завершились success для указанных checkpoints.
Ни adapter, ни его кодовые проверки
не являются physical messaging, masked acquisition или production evidence.
Shared checkpoint `6da623b` запушен; MAUI dependent gates: 19 clean /
118 smoke passed, Windows build — 0 warnings/errors. Shared CI
`36366966402` завершился success.
Новый HTTPS UAT account flow использует Shared `VerifyCurrentNetworkAsync`
без искусственного service capability: тот же nonce-fresh account proof,
подписанная closure, account-owned network floor CAS/reread и один monotonic
clock. Publication mint остаётся отдельным свежим запросом под тем же gate;
прошлый UI/network success не переиспользуется как authority. Shared Release
gate — 152 passed без compiler warnings; MAUI clean — 19, smoke — 118 passed.
Обычный и HTTPS-conditional Windows win-arm64 builds — 0 warnings/errors.
HTTPS-conditional build выполнен как local diagnostic compile, не deployment,
TLS или device evidence. DevOps public export теперь отдельно собирает NCP2
из genesis и последовательных operational successors, проверяя independent
genesis pin, bounded source inventory и точный XNV1 prefix; предшественники
XNH1/XVP1/PMT2 не теряются. Четыре offline operator groups прошли, включая
настоящие подписанные genesis/successor, gap/replay/подмена/pin/size negatives.
Фактический public genesis bundle — 8151 bytes, successor bundle — 11300 bytes;
они оставлены только в operator custody, не в репозитории. Это distribution,
не fresh network capability. DevOps release-gate contract harness прошёл
51 command; настоящий production readiness остаётся blocked (10 отсутствующих
evidence inputs), а его synthetic harness success не является sign-off.
Shared compose smoke не запускался: topology здесь не менялась, а его
compat/default cleanup удаляет общие dev volumes и не даёт DID2 evidence.
Проверенный checkpoint запушен: Shared `298ec46`, MAUI `06096c7`,
DevOps `f283db6`; исходные деревья этих repos чистые. Новый device E2E
и TLS deployment этими commits не заявляются.
Следующий разрыв: полный bundle теперь развёрнут по HTTPS UAT, но MAUI publisher
и удалённый claim не подключены, физический сценарий не выполнен;
положительное E2E двух terminal paths также ещё не получено.
Локально реализован account-owned `EnsureOwnInitialPreKeyInventoryAsync`: он связывает
новый nonce-bound proof, точные локальные DMD1/DRS1, текущий NETCODEC placement
и native V2 authoring с защищённым staging. Повтор возвращает тот же XPP1,
а не новые ключи. HTTPS UAT composition вызывает подготовку, но не отправку;
контакты/сообщения/вложения/группы остаются закрытыми до настоящего remote
publication/claim и device E2E. Windows Shared production gate — 155 passed;
MAUI clean — 19, smoke — 118 passed. HTTPS-conditional Windows win-arm64 и
Android ARM64 builds — 0 warnings/errors. Native/SQLCipher fixture проверяет
полный initial authoring и exact retry после restart; в clock negative
использована точная verifier-derived freshness deadline, не случайная отметка.
Android APK пока не установлен, новые device claims отсутствуют; это не sign-off.
Проверенный шаг запушен в RC: Shared `3ecfdd8`, MAUI `af74ed3`.
Следующий вертикальный шаг — DID2-only protected ONION host и live publication
на обеих выбранных репликах, затем claim/DPH2 и двусторонний device text E2E.
Старый MAUI host с V1 identity/secure slots не переносить адаптером;
entropy/entry-guard custody должна принадлежать текущему DID2 account.
Текущий candidate по [DR-0009](survival-program/decisions/DR-0009-did2-selected-entry-transport.md)
соединяет account-owned DSV2 custody и Protocol-derived selected-entry TLS:
entry выбирается после required-exit path selection, не фиксируется старым URL.
Protocol сам генерирует request ephemeral/reply keys; client не читает
device scalar или XNode receive vault. Два фиксированных защищённых floor
slots на root записываются перед SQL; rollback/crash fail closed. Entropy
commitments не удаляются и имеют закрытый capacity bound, retirement/recovery
остаётся release gate. Focused Protocol — 16 passed; Shared TLS/guard/owner
gate — 13 passed. Реальный native DID2 inventory + SQLCipher fixture отдельно
прошёл локальный BuildAsync для обеих выбранных реплик, duplicate reservation
и reopen с теми же guards/entropy. Это local sealing, не network send/XIC1/TLS
или device evidence. MAUI HTTPS UAT теперь монтирует publisher и ждёт
independently verified XIC1 pair, затем durable account-owned запись.
Live publication ещё не подтверждена; новые origin/onion ключи XNode ещё
нужно установить. Restore/build Protocol — 0 warnings/errors. Actual graph
сначала отверг новый API snapshot; выполнен reviewed DR-0009 repin
Debug/Release. Из Protocol gate удалены 144 исторических API snapshots;
принимается только текущий API, проверки целостности/negative witness не
отключены. Повторный full Protocol — 1824 passed / 11 native skipped,
MembershipRoutes — 131, ProfileCarrier — 105 passed; Debug/Release actual
graph и evidence ownership mapped=219/packageMissing=0 прошли. Full Shared
Release — 167 passed, MAUI clean — 19, smoke — 118; HTTPS UAT Windows
win-arm64 и Android ARM64 builds — 0 warnings/errors. Compile artifacts не
установлены на устройства. Проверенные commits: Protocol `876e39d`,
Shared `cb02a54`, MAUI `3062a77`.
Следующий P0 по [DR-0010](survival-program/decisions/DR-0010-did2-onion-host-authority.md):
подтверждённый разрыв в XNode — fixed ReceivePosition не
допускает required-exit перестановки в трёх-node сети. Кроме того, ONION
receive host требует V1 `IContactVerifiedAuthoritySnapshotSource`, который
не может одновременно работать с DID2 proof boundary. Заменить это на
DID2-only свежую identity-neutral receive authority и подписанный
multi-role binding, с durable network LKG, без V1 snapshot adapter,
header-derived authority или `protectedPrevious:null` в steady-state.
До этого remote rollout/publish не считать проверенными. Зарегистрированные
node identities и certbot сохранить.
Уточнение receive contract по
[DR-0011](survival-program/decisions/DR-0011-authenticated-relay-position.md):
Ingress/Core имеют одинаковый наружный Relay header, поэтому unique-header
selection из раннего DR-0010 невозможен. Protocol теперь отличает позиции
после AEAD и полной проверки XRL1/inner-header/подписанных local+next roles,
до replay commit. Только `receive-position-mismatch` разрешает bounded retry
уже подписанной другой relay position с новым lease; auth/grammar/expiry/
commit/disposal failures не разрешают retry. Ошибка disposal также очищает
lease scope. Удалён единственный transitional receive-fixture bridge; тест
использует текущий factory напрямую. Signed NETCODEC fixture проверяет шесть
перестановок с canonical DID2 XPP1 V2 commit-carriage, не заявляя staged
inventory, issuer proof или XIC1 publication. Host loop, durable NETCODEC source,
TLS и physical device сценарий ещё должны быть завершены как один следующий
server composition пакет; fixed-position/V1 host пока не развёрнут повторно.
Полный Protocol gate после изменения: 1842 passed / 11 native skipped;
MembershipRoutes 131, ProfileCarrier 105. Debug/Release builds — 0 warnings/errors;
оба actual graph gates и package evidence mapped=219/packageMissing=0 прошли.
API snapshots не изменялись. Frozen vector manifest integrity тоже проверена;
это не runtime/device authority и не release sign-off.
Protocol checkpoint: `ba0b710` (RC branch).
Отдельно подтверждён следующий claim-path gap: ONION closed payload verifier
сейчас принимает V2 XPP1, но направляет XPK1 в V1 parser и отвергает V2 XPK1.
Это нельзя обходить V1 bytes или превращать в successful claim. Подключать V2
request/result pair вместе с durable two-replica claim authority, затем DPH2;
структурный parser или local claim result не является E2EE authority.
CI DevOps `36375906887` завершился success; в unit run `36375906895`
security-gate и release-gate-contracts успешны, но общий unit job failed:
XNode ProfileGenerator fixture вызывает `git.exe` на Linux; отдельный
package-source negative также failed. Assertions не ослаблять: исправить
portable test/tool boundary и повторить настоящий Linux CI.
Read-only device/runtime audit 2026-09-28: clean Windows DID2 UI явно
показывает только локальный аккаунт и закрытые контакты/сообщения/группы;
Android DID2 probe запущен, но не является messaging client. Публичный
Registry и локальный integration Registry отвечают 404 на DID2 admission/proof
routes; в работающем локальном dev Registry DID2 authority не включён.
Staking portal отвечает 200. Это исключает трактовку старого `.e2e` V1
экрана или успешного account-probe как DID2 device E2E.
Read-only source/runtime audit 2026-09-28: targeted Registry HTTP-тест
multi-hop ADF1→текущий ADH1 прошёл с локальным Protocol source-cutover, но
сохранённый canary environment не содержит `ForwardCheckpointPaths`.
Приватные ADF1-кандидаты ещё не сопоставлены с exact ADA2/floor текущего
контура. Это отдельный обязательный gate перед возобновлением canary;
результат теста не является разрешением включать production route.
Последующая UAT-проверка уже создала отдельный loopback probe на новом
CI-образе. Шесть конфликтующих ключей окружения сведены к единственным
проверенным значениям; protected time и ADH1 обновлены через независимый
floor CAS. DID2 readiness прошёл. Android admission добавил следующий leaf
и совпал с внешним floor, но proof отвергнут из-за истёкшей operational
XNV1 closure, описанной выше. Это всё ещё не message E2E.
Для снятия этого blocker Protocol уже авторует строго монотонный operational
successor с проверкой полной подписанной closure и append-only network log;
offline DevOps tool теперь использует реальные custody signers, сохраняет
идентичности трёх нод и проверяет installable TLS certificate/key pairs.
Исправлены отдельные дефекты operator tool: отсутствовавший PMA2 в inventory
и отказ root signer подписывать разрешённый PMA2. Синтетический offline gate
проверяет genesis и successor теми же FileSigner/NodeSigner, а не заменой
signer policy. Операторский порядок — в
[`PRODUCTION_AUTHORITY_CUSTODY.md`](../deep-devops/docs/PRODUCTION_AUTHORITY_CUSTODY.md).
Новый bundle пока не опубликован: ещё нужно сопоставить независимые защищённые
network/placement pins, установить matching traffic keys на UAT ноды,
обновить trusted time и получить nonce-fresh DID2 proof на обоих устройствах.
Этот code gate не подтверждает contact publication или физические сообщения.
UAT runtime 2026-09-28: readiness вновь отказал, поскольку текущая
ADH1 не покрывала новый proof. Защищённый `refresh-current-head` сохранил
содержимое и продвинул generation/tree до 11/6 через внешний floor;
последующий DID2 readiness вернул `ok=true`. Автоматическое renewal в этом
probe не включено; восстановленный readiness не означает device E2E или
production cutover. Production Registry и staking portal не изменялись.
Физическая диагностика USB Android DID2 probe в тот же день: повторный
nonce-fresh proof прошёл, в том числе после force-stop/relaunch без нового
аккаунта. Проверялся существующий установленный probe, не новый messaging
runtime и не текущие изменения network-floor custody. Windows UAT canary
остаётся на Welcome; action-time подтверждение создания аккаунта ещё ожидается.

HTTPS UAT checkpoint 2026-09-28: новый Registry CI image `31d7a14`
развёрнут отдельным upstream по immutable digest, без замены основного
Registry/staking. Exact container environment preflight прошёл (18 unique
DID2 keys); новая public NCP2 directory смонтирована read-only вне custody.
Защищённое время ротировано штатным CAS без отката; `refresh-current-head`
продвинул ADH1 generation/tree до 12/6 через независимый floor.
В существующем Registry HTTPS server переключены только четыре exact V2
routes; certificate/certbot и staking server blocks не изменялись. Baseline
ingress сохранён и hash-checked, `nginx -t` и reload прошли. Публичный DID2
readiness — `ok=true`; cleartext closure — 403. Protocol-generated NCQ2
по публичному HTTPS получил exact exported NCP2 (11300 bytes, SHA-256
`177a94f06865f558a03c0900c67013dc2ae2af0e8d6b0255e7ba0c80b697b2fd`),
no-store и четыре negative checks (wrong network/query/media/malformed)
прошли. Это транспортная выдача public bytes, не current network capability
и не device E2E. Staking HEAD вернул 200; полная GET-передача достигла
HTTP 200, но превысила 15-second диагностический deadline, поэтому complete
portal load этим запросом не заявляется. Android USB device доступен.
MAUI publisher/remote claim и matching node rollover keys ещё не подключены.

CI checkpoint: Shared `298ec46` — success, MAUI `06096c7` — Android/Windows
build и unit lanes success, но compiled release guard failure: он проверяет
прежнюю direct composition вместо DID2 helper. Пока полного DID2 transport
graph нет, этот failure не заменяется зелёным account-only release claim.
DevOps `f283db6` integration success, unit workflow failed: отсутствовал
Shared checkout для Registry fixtures, брались frozen docs из main вместо
выбранной RC-ветки, source-role gate пропускал PMA2. Эти wiring defects
исправлены вместе с fail-fast native test execution; focused workflow tests
2/2, env tests 9/9, canonical source-role gate и 10 upload contracts прошли.
Offline operator gate (4 groups) расширен transport/shape negatives; build
0 warnings/errors. Release contract harness снова прошёл 51 command, настоящий
readiness остаётся blocked на 10 absent evidence inputs.
Security audit отдельно воспроизвёл единственный high advisory
`GHSA-7q85-xj36-vmfc` в transitive `adm-zip` контрактного tooling. Override
обновлён до 0.6.1, lockfile diff ограничен этой зависимостью; повторный audit
high=0/critical=0 (low/moderate остаются). Solidity/ABI/deployment не менялись.
Локальный Hardhat build не выполнен: Windows ARM64 analyzer отсутствует;
compile/test/export должны быть подтверждены поддерживаемым x64 CI.
Фиксации запушены в RC-ветку: DevOps `323c3d8`, contracts `f001984`.
Полный локальный security gate завершился `ok`: 67 dependency audits,
dependencyFailures=0, secretFindings=0. Он не заменяет независимый security
sign-off и device evidence. Побочные restore-изменения трёх probe lockfiles
от dependency audit возвращены к исходному содержимому; Protocol code не менялся.

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

- Завершить coherent DID2-only encrypted claim prefix и sender/responder
  promotion: заменить старый receipt во всех production consumers, связать
  current initiator/device proof с V2 recipient claim, затем подключить
  protected pending preparation, ContactHello/inbox commit и ACK. Read-only
  header/device checks из последнего инкремента не заменяют эту композицию.
  Перед device-прогоном старые несовместимые QA pending handshake requests
  явно удалить только через изолированный QA reset; не мигрировать commitment
  или persisted DPH2 после исправления identity ArtifactRef. Network authority,
  node keys, genesis и protected network floors не сбрасывать.
  [DR-0017](survival-program/decisions/DR-0017-did2-initial-claim-promotion.md)
  реализован для V2 prefix/current responder promotion и neutral claim lanes.
  [DR-0018](survival-program/decisions/DR-0018-did2-initiator-completion.md)
  переводит initiator CompleteAsync и recovery fixtures на тот же exact V2
  prefix, без event-only test seam или V1 receipt overload. Остались полный
  live durable claim completion и protected pending secret custody, ContactHello V2, shipping
  caller и physical delivery; локальный sender/responder gate не закрывает WP2.
  Shared сохраняет exact успешный XPC1 после проверки двух replica signatures
  и inclusion; после restart перечитывает ту же пару без нового claim с
  повторной проверкой current placement/signatures. Это public-byte custody,
  не current-recipient receipt, read-back с обеих нод или сохранение секретов
  подготовки. Request-only QA journal generation 2 отвергается; необходим
  изолированный QA reset, не сброс network authority/genesis/node keys.
  [DR-0019](survival-program/decisions/DR-0019-did2-preclaim-secret-persistence.md)
  добавляет Protocol-only seal/current restore секретного pre-XPK1 состояния.
  Shared candidate связывает его с protected account/database-instance/intent
  journal до возврата capability; focused restart/interruption gate прошёл,
  shipping sender ещё не подключён. Candidate
  [DR-0020](survival-program/decisions/DR-0020-did2-atomic-device-initial-session.md)
  заменяет burn-then-return на закрытую account-owned фиксацию полного
  DPH2/TRS1 и device burn с protected pending -> SQL -> stable.
  Девять структурных custody-проверок и один approved-native completion/
  restart/crash gate прошли (loopback/HTTP fixture, не device E2E). Итоговый
  Release batch gate на фиксированном SHA ещё не завершён. Schema generation 4 — явный QA reset,
  без старого reader. Не выдавать spent lease и не выбирать другой prekey. После durable
  DPH2/TRS1 фиксации допустим только exact ciphertext retry.
  Следующая граница projection теперь проверяет conversation по exact
  hash-bound initial events и связывает локальную TRS1 directory head с
  сохранённым DMD1 по DR-0020. Это не завершённый messaging-store projection:
  остаются V2 contact authority и shipping caller; чужой caller scope не
  заменяет эти проверки.
  [DR-0021](survival-program/decisions/DR-0021-did2-contact-rendezvous-issuer.md)
  замораживает DID2-only issuer/time verification inbound rendezvous без
  нового XUR1 wire. Candidate verifier и два адресных Release cases прошли
  по настоящему PQ DID2 и threshold nonce proof; это не device E2E.
  [DR-0022](survival-program/decisions/DR-0022-did2-contact-control-events.md)
  заменил V1 Hello author/checker на async DID2 Hello/Accept endpoint APIs и
  DAB2-only payload reference. Safety number включает оба genesis PQ-root.
  Четыре payload/canonical вектора, их hashes/anchor и machine grammar обновлены
  вместе; старые положительные DAB1 Hello/safety tests удалены. Шесть narrow
  Release cases passed: real two-account PQ/current-proof Hello/Accept,
  issuer/time/cancel, substitutions и exact vectors (не device E2E).
  Protocol и Shared production source builds: zero warnings/errors.
  Shared account-owned initial completion теперь применяет этот Hello endpoint
  checker до device burn и повторно до возврата durable custody; это не
  messaging-store projection, route authority, shipping UI или ACK.
  ContactHello/Accept DAB2 durable consumer composition ещё не закрыта. Полные гейты
  и следующий коммит отложены до coherent contacts/messages/media/groups batch
  по прямому указанию владельца; локальная отладка использует narrow cases.
  [DR-0023](survival-program/decisions/DR-0023-did2-owned-rendezvous-author.md)
  добавил DID2 owned-device XUR1 author и account-owned защищённую custody
  независимого metadata-ключа и exact XUR1 до Hello. Старый DAB1 author/result
  и его положительный тест удалены. Адресный real-account/network author case
  passed, включая key/head/time/boot/cancel substitutions; отдельный custody
  case passed (lost commit response, exact restart/retry, hostile snapshot,
  owner mismatch, missing-state/reset). Это локальный HTTP/SQLCipher fixture,
  не physical E2E. Нельзя автоматически перевыпускать истёкший XUR1 под тем же intent.
  Дополнительно устранён пропущенный conversation-ID binding Hello: Protocol
  проверяет нормативный вывод из relationship и двух account roots, Shared
  использует тот же hash owner. Narrow Protocol batch: 5 passed; Shared wrapper:
  1 passed. Shipping session projection/receive/media/groups остаются открыты.
  Дополнительный narrow Shared batch: 3 passed (два независимо созданных
  PQ-аккаунта, ContactHello как первый DPH2 event, exact restart sender custody,
  rendezvous custody и shared conversation wrapper). У аккаунтов отдельные
  защищённые directory/network floors. Это fixture с подписанными claims и
  native crypto, но synthetic route refs: не production publication или
  physical receive. [DR-0024](survival-program/decisions/DR-0024-did2-owned-initial-claim-preview.md)
  добавляет account-owned read-only receiver preview; source build passed без
  warnings/errors, native receive-prefix case passed (exact retry и rejection
  повреждённого ciphertext). Следующее расширение того же case проверяет
  current claim promotion и [DR-0025](survival-program/decisions/DR-0025-did2-owned-responder-preparation.md)
  owned responder preparation; актуальный native case passed (6m32s), включая
  отказ чужому recipient proof, истёкшему protected sample и отмене; current
  DCA и metadata расшифрованного Hello проверяются заново. Exact recovered
  SessionInit/Hello и reservation/session IDs совпали, повторная передача и
  чтение disposed payload отвергнуты. Narrow Protocol batch: 5 passed,
  включая закрытую поверхность preview/preparation. Preparation не является
  durable session/inbox или ACK, и новый Shared helper не доступен UI.
  [DR-0026](survival-program/decisions/DR-0026-did2-atomic-responder-custody.md)
  добавил account-owned atomic receiver custody: защищённый pending/stable
  checkpoint, SQLCipher ledger вместе с расходом prekey, exact replay до
  восстановления ключа. Первый расширенный native case passed (7m54s):
  recipient сохранил точные SessionInit/Hello и восстановил их после повторного
  открытия без новых proof/claim запросов. Это всё ещё signed fixture с
  synthetic route refs, не physical receive. Проверки one-time deletion,
  трёх границ сбоя и hostile protected checkpoint прошли изолированно: 4/4
  passed (13m10s native OneTime case), включая удаление точного секрета,
  recovery без новых proofs, replay и отказ откату SQL. Затем исправлен расход
  LastResort по точному signed reuse limit вместо постоянного wire maximum;
  адресный native LR-case и дополнительные unit bounds прошли: 20/20 passed
  (5m14s native LR), включая реальное удаление секрета при signed limit1,
  exact restart и отказ подменённому ciphertext. Это локальная проверка,
  не physical delivery; полный batch ещё не проверен. PKV2 schema
  clean-broken; установленным QA-аккаунтам потребуется явный reset.
  Следующая связная часть: DID2 session/MSG/contact projection и current route
  publication, затем bidirectional text, files/images и group fanout на devices.
  [DR-0027](survival-program/decisions/DR-0027-did2-messaging-session-ownership.md)
  выявляет обязательную передачу владения initial TRS1 и удаление старых
  секретных копий из handshake ledgers до обычных сообщений. Внутренний
  DID2 seed проверяет exact события, directional directories и current
  own/peer proofs через account-owned source; production build passed
  (0 warnings/errors). Это ещё не durable mutable owner/retirement.
  Native seed/current-proof/lifetime case passed (1/1, 5m44s). Расширение
  того же fixture на bidirectional DPE2/out-of-order/replay/tamper обнаружило
  реальную ошибку managed provider: ownership-transfer successor evidence
  очищался через оставшуюся временную ссылку. Исправлены send и receive
  (без изменения bytes/domain/API); адресная перепроверка passed (1/1,
  5m47s): bidirectional native DPE2 text/emoji, out-of-order skipped key,
  exact replay без второго plaintext/advance и changed replay rejection.
  Authority в этом crypto diagnostic —
  test-only memory, не durable store или physical/network evidence.
  Отдельный быстрый native component regression (fixed roots, без повторного
  provisioning DID2/SQL) passed 2/2, 330ms: 82 bidirectional DPE2 сообщения,
  свежая AEAD-подмена без mutation, gap/replay, больше 32 send на каждую сторону
  и реальные PQ/EC rollover. Он выявил и исправил отклонение допустимого
  Ct2Sampled pending-completion и преждевременный PQ freshness reset на старом
  message-key; old-epoch key не считается свежим, новый counter1 считается,
  посторонний same-epoch Braid state отвергается. Семантика закреплена в DR-0027;
  grammar/API/KDF не менялись. Это component evidence, не production delivery.
  DR-0027 local scope/floor/MSP2 codec, segmented protected pending и dedicated
  DMS2 SQLCipher journal теперь реализованы как внутренние компоненты: журнал
  хранит только metadata, TRS1 заменяется в одной строке, send ciphertext и
  receive DMC2 фиксируются с ratchet. Narrow SQL/crypto batch passed 34/34,
  5m51s: actual DID2 native text/gap/replay/tamper через real SQLCipher;
  isolated storage cases проверяют protected crash/lost-response boundaries,
  hostile parts, exact schema и deletion/durability policy на reopen. В crypto
  fixture protected adapter in-memory, activation synthetic: это не source
  retirement, platform custody, shipping composition или physical evidence.
  Exact recovery coordinator и отсутствие direct-conversation restriction
  в ordinary crypto custody перепроверены: 34/34 passed, 5m53s, включая import
  pending-before-SQL, ratchet pending-after-SQL и exact retry без новой mutation.
  Native crypto допускает другой semantic conversation, но это не проверка
  group membership или group materialization. Дополнительно snapshot bridge
  теперь принимает владение defensive getter copies без второго неочищаемого
  TRS/plaintext массива; narrow storage/ownership batch passed 34/34, 8s,
  включая wiping snapshot без изменения исходного Protocol plan. Production
  source build passed с 0 warnings/errors; полный batch gate ещё не запускался.
  DR-0027 теперь задаёт source-custody clean break: metadata и initial TRS
  разделены, source checkpoints аутентифицируют полный pending, preclaim
  journal сохраняет key-free tombstone вместо старого sealed blob. Closed
  mutable import разрешает account-owned удаление sender/receiver initial
  keys; только завершённый protected retirement разрешает activation.
  Узкий native/source batch passed 40/40 (6m47s): реальные DID2 аккаунты,
  SQLCipher, все sender/receiver retirement crash points, exact retry после
  удаления ключей и bidirectional DPE2 text/gap/replay/tamper. Это всё ещё
  in-memory protected adapter/signed fixture с synthetic route references,
  не platform/transport/device evidence. Дополнительные unit negatives passed
  42/42; адресная native перепроверка passed 1/1 (6m52s): старый sealed
  preclaim и восстановленный receiver TRS отвергаются после stable retirement
  без runtime repair. Standalone BeginClaim также закрыт для завершённого
  intent; его последний guard и полный business batch ещё требуют финального
  native gate после завершения композиции.
  Последний узкий structural/storage прогон passed 75/75 (1m06s), включая
  completed-intent lookup до/после crash recovery и mutable pending/SQL
  mechanics. Полный release gate и physical E2E этим не закрыты.
  Account-owned session catalog/key registration реализованы отдельным
  внутренним компонентом по DR-0027: atomic catalog+floor, независимые SQL
  keys, exact interrupted initialization, fail-closed phase2 missing SQL.
  Узкий storage/catalog batch passed 55/55 (7s). Account-level source/history
  проверки добавлены; связанный storage/source/catalog/native batch passed
  100/100 (8m29s), включая настоящий sender/receiver source reopen после
  mutable crash recovery. Безопасный rollover остаётся открытым. Следующий
  slice заменяет process-local replay map проверенным SQL operation read-back:
  exact outbound retry и recoverable inbound DMC2 без второго ratchet step;
  его отдельный native gate passed 1/1 (9m36s): exact ciphertext после
  переоткрытия SQL, no second ratchet step и rejection changed content.
  Это не semantic ACK и не
  shipping MAUI composition.
  В текущем batch добавлена account-owned операция initial import → source
  retirement → activation и read-only freshness под настоящим held lease.
  Два endpoint proof теперь сверяются с одной заново аутентифицированной
  protected head; повторный захват file/source/fetch gate исключён. Narrow
  recovery/source/catalog/lease batch passed 20/20 (14m48s); первый прогон
  остановился по слишком короткому 30s harness budget до retirement. Таймаут
  самого file-lock остаётся 30s; production cancellation policy не изменена.
  Это не physical E2E, semantic inbox или разрешение на ACK.
  DMS2 schema2 использует штатный raw-key формат для независимого random256
  catalog key без secret strings и без изменения account/source key modes.
  Native temp-only probe: binary reopen 611ms, raw reopen <1ms; encrypted bytes
  и cross-mode rejection passed. Production build 0 warnings/errors.
  DMS2/native batch: native text/reply/gap/restart/retry scenario passed; весь
  прогон имел 1 failed / 54 passed из-за выявленного lazy key-open. Factory
  теперь читает encrypted schema page до возврата; повторный structural
  DMS2/catalog/lease batch passed 56/56 (1s), включая wrong-key/mode negatives.
  Старый DMS2 diagnostic generation1
  не мигрируется и не служит compatibility reader.
  Теперь добавлена private single-use account-owned DPE2 authority: context и
  replay/retention выводятся из полностью проверенного SQL/floor, а не из
  тестового digest/boolean; sealed mutation и event readback проходят durable
  pending/SQL/cleanup/stable. Changed owned send получает закрытый durable
  latch с удалением live TRS, unauthenticated remote tamper не разрешает latch.
  Первый actual-owner native scenario passed 1/1 (14m51s): service/SQL reopen
  каждого сообщения, out-of-order, ciphertext retry, receive replay и reply.
  Дополненный targeted batch passed 24/24 (10m14s), включая interruption после
  pending/SQL, exact recovery и closed send latch с удалением live TRS.
  Production-only build 0 warnings/errors. Bound LKG read теперь
  валидирует и использует одну SQL connection, без второго KDF/open и без
  удаления integrity/schema/account/device/instance checks.
  Следующий связный batch внедряет [DR-0028](survival-program/decisions/DR-0028-did2-application-event-handoff.md):
  обязательную atomic protected application registration, отдельный derived
  account-owned SQLCipher key/path, existing-only phase2 и exact schema5 без
  миграции. Initial batch читается из проверенного retired active SQL/floor,
  проходит current DID2/Hello closure и применяется атомарно; ordinary direct
  handoff использует actual committed row. Account-owned history reads заново
  проверяют endpoints/retirement. Конфликт sender position с разными logical ID
  durably forks; SQL/in-memory parity и schema/loss/crash negatives passed 20/20.
  Расширенный actual-owner сценарий passed 1/1 (11m35s): начальные события,
  bidirectional ordinary text, out-of-order/replay/crash recovery и чтение
  одинаковой трёхсообщенческой истории с обеих сторон после пересоздания owners.
  Дополнительный focused batch passed 25/25 (1m10s): metadata corruption,
  exact schema/unknown objects, protected registration/empty crash recovery,
  initialized SQL loss/no recreation, fork/replay/SQL-memory parity.
  Production build 0 warnings/errors; test rebuild также без warnings.
  Это не consent, semantic rollback checkpoint, delivery/ACK, shipping UI или physical E2E.
  Следующий связный инкремент реализует [DR-0029](survival-program/decisions/DR-0029-did2-contact-accept-custody.md):
  отдельную явную account-owner acceptance command, exact protected winner/retry,
  actual committed DPE2 handoff и retained local/peer acceptance readback.
  Focused codec/SQL/in-memory/replay/fork/counter cases passed 27/27.
  Hello остаётся запросом, retained Accept не объявляется Active.
  Actual-owner native acceptance/send/receive/reply scenario passed 1/1 (11m19s),
  включая committed semantic response loss, exact send/receive replay и retained views;
  нового physical evidence нет. Затем protected semantic/outbox checkpoints, transport composition и physical
  Windows/Android contacts/messages/files/images/groups evidence.

  [DR-0030](survival-program/decisions/DR-0030-did2-owned-direct-text-outbox.md)
  теперь задаёт/реализует account-owned text command, protected exact
  pending/stable retry и SQL mirror/counter проверки до DPE2 send.
  Sender starts3, responder starts4 только после actual retained Accept;
  отсутствующий responder counter не пересоздаётся. Stable SQL loss,
  изменённые recipient/content/operation и rollback/advance отвергаются.
  Focused outbox/preparation/removed-transport batch passed18/18;
  дополнительный missing-counter/recovery batch passed3/3.
  Actual-owner contact/accept/owned-text retry/reply passed1/1 (13m31s),
  не physical/TLS/platform protection evidence. Остальные неподключённые
  kinds закрыты на account send boundary, а не пропускаются из codec.
  Transport/semantic inbox/ACK, typed attachment/group custody и shipping
  UI остаются обязательными. Полные гейты/коммиты — после связного batch.

- В attachment vertical реализован component candidate `AttachmentChunkCipher`
  по уже frozen §16 CONTACT-AND-GROUP: независимый transcript comparison,
  round-trip до 25 MiB, hash/AEAD/key/network/geometry/lifetime negatives и
  существующий manifest codec passed 20/20. Shared owned preparation плюс
  structural SQL/in-memory offer/cancel custody passed 6/6.
  Точные component boundaries/evidence — в [истории](SPRINT-HISTORY.md).
  Это не BLOB activation: opaque
  padding, masked upload/download/resume, authenticated offer/cancel projection,
  UI/images и physical Windows/Android transfer остаются незавершёнными.
  Старые `/file`/DEEPATT2 не подключать к новой вертикали.
  Их HTTP runtime/options/factory и положительные attachment tests теперь
  удалены, а исключённая Session UI composition больше не включает их по URL.
  По [DR-0031](survival-program/decisions/DR-0031-did2-local-attachment-custody.md)
  actual account owner теперь сохраняет exact DAM1/chunks в account-owned
  SQLCipher schema6 с protected pending/stable asset journal. Recovery не
  требует picker URI; старый объект не шифруется заново. Actual-owner local
  adoption/crash/restart плюс preparation passed5/5 (1m23s); current schema6
  focused asset/text/retired-HTTP batch passed22/22 (1m32s).
  Это закрывает локальный adoption candidate, не BLOB-01/physical transfer.
  Local whole-file assembly follows DR31: complete hash/AEAD/plaintext-digest
  checks before an independently disposable result. Focused evidence is in
  [the history](SPRINT-HISTORY.md); it is not remote download/device acceptance.
  Owned typed offers follow DR46; remote download authority/cancel and
  masked padding/upload/download/resume, group fanout и
  native UI остаются открытыми. Schema5/missing journal требуют explicit QA
  reset; migration/repair не добавлены, device данные этим batch не менялись.
  XNode now has the internal ciphertext-only storage primitive described in
  [its component guide](../xnode/docs/BLOB_STORAGE_COMPONENT.md), with native
  Windows/Linux restart and durability evidence in the history. It has no
  authenticated Blob service/dispatcher or remote receipt producer. Still
  freeze the exact masked stream/object-capability/receipt contracts, implement
  immutable object-index/fork and reference-aware lifecycle custody, then join
  client upload/download/resume and MAUI file/image commands to physical E2E.
  Do not treat the primitive as Blob role readiness or revive direct `/file`.

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
  public-forgeable provider и raw keys запрещены. Текущий DID2 MAUI owner
  подключает account/current-device custody; прежняя session-catalog/MSG
  композиция не является DID2 release evidence и не должна подключаться
  через V1 адаптер. Требуется shipping composition готового DID2 catalog/key registration,
  замкнутый initial-to-mutable transfer по DR-0027, durable MSG/contact
  materialization и отправка exact ciphertext через current privacy path.
  Source retirement не заменяет transport delivery receipt или mailbox ACK.
  Raw keys, caller-provided providers и частичная фиксация запрещены.
- Реализовать handshake initialization/runtime composition и безопасный session
  rollover до лимита журнала, чтобы не оставлять пользовательский диалог в
  `CapacityExceeded`.
- Ввести account-authorized device list, enrollment, device fanout,
  revocation/rekey и explicit history-sharing policy. Restore создаёт новое
  устройство, а не копирует ключи старого.
- Подключить MSG-01 logical outbox/inbox к DPE2 и реальному transport:
  один logical message/operation ID переживает attempts, at-least-once retry,
  restart; materialization и receipts остаются идемпотентными.
  По [DR-0032](survival-program/decisions/DR-0032-did2-mailbox-selected-entry.md)
  internal mailbox transport теперь использует actual DID2-owned fresh network,
  scoped request/route checks и TLS entry выбранного exact-three пути, без
  DID1 source adapter/static URL. Shipping caller ещё отсутствует. Следующий
  обязательный сетевой инкремент: durable adoption/publication для DID2 current
  XIR1/XRR1 route closure по
  [DR-0033](survival-program/decisions/DR-0033-did2-current-mailbox-route.md) и
  protected holder -> XMG1/XMC1 -> actual mailbox adapter. Protocol candidate
  теперь проверяет current DID2 route напрямую и выпускает genesis через
  owned-device/threshold/owned-device фазы. Local protected adoption/retry
  реализован по [DR-0034](survival-program/decisions/DR-0034-did2-owned-route-custody.md);
  новый mandatory route journal clean-break требует reset старых тестовых
  account instances. Registry V2 threshold endpoint и permanent PostgreSQL
  exact replay реализованы по
  [DR-0036](survival-program/decisions/DR-0036-did2-route-threshold-coordination.md):
  account/native/ADA2/external-floor/HTTP scenario и pipeline/journal **13/13 passed**.
  Это TestServer, не физический транспорт. Shipping XPoint/OHTTP coordination,
  publication, deployment, API gates, repins и consumer composition ещё обязательны.
  [DR-0037](survival-program/decisions/DR-0037-did2-owned-contact-object.md)
  добавляет owned genesis DCB1/DCR1 V2 и encrypted-object phase 4 в protected
  route journal. По [DR-0038](survival-program/decisions/DR-0038-did2-publication-coordination.md)
  добавлены DID2 whole-envelope publisher signature, server XPA1 issuance и
  permanent PostgreSQL journal, protected pending request/response phases 5/6.
  Connected isolated lane **13/13 passed**, **0 skipped**, **3m37s**; это
  TestServer/native/SQLCipher/PostgreSQL, не физическая доставка.
  По [DR-0040](survival-program/decisions/DR-0040-did2-owned-publication-commit.md)
  добавлены closed client two-replica commit verifier и protected phase-7 exact
  XPO custody. Journal теперь version 4 only; старые QA accounts требуют explicit reset.
  Historical commit не продлевает XPA dispatch permission. Local opaque-node
  lane **5/5 passed**, API surface **2/2**, journal bounds **8/8**; account
  exact retry/reopen/fault lane **1/1 passed**, **0 skipped**, **7m43s**.
  В account lane replica response синтетический с реальными signatures;
  actual opaque storage проверяется отдельно в XNode. Это не physical E2E.
  Следующий незамкнутый участок — shipping private coordination и две publication replicas, затем grants
  и физическая доставка. Local signed object не заменяет эти проверки.
  [DR-0035](survival-program/decisions/DR-0035-did2-mailbox-grant-request.md)
  заменяет DID1 XMG1 author прямым DID2 current-route author и удаляет старый
  caller-owned Shared acquisition client. Новый holder/request owner должен
  фиксировать exact retry до ContactResolve callback и проверять PMA2 плюс
  independently authenticated topology membership/epoch до установки XMC1.
  Эти части ещё не shipping composition. Сам network/path
  candidate не является grant acquisition, semantic ACK или device delivery.
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

- Ближайший обязательный этап — P0 стабилизация по
  [`NET-STAB-*`](architecture/IMPLEMENTATION-PLAN-V1.md#11-network-stability-first-execution-override-2026-09-29);
  кратковременный healthy snapshot или ручной successor не закрывает recovery gate.
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

Отложено за пределы текущего инкремента по решению Mr. X от 2026-09-29:
сначала автоматическое восстановление сети и E2E сообщений. Ниже сохранены
будущие требования; их выполнение не является prerequisite `NET-STAB-GATE`.

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
