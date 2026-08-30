# Текущий спринт: XPoint transport до первого production-релиза

В этом файле перечислено только то, что ещё не выполнено или не подтверждено. Завершённая работа и результаты аудита находятся в [SPRINT-HISTORY.md](SPRINT-HISTORY.md).

## Приоритет продукта

До первого production-релиза обязателен один transport scope: сообщения через
XPoint с маскированным anti-blocking carrier и трёхузловой
privacy-маршрутизацией.

Direct P2P перенесён в следующий спринт после первого production deployment и
не блокирует этот релиз. On-prem выполняется ещё позднее. Текущие изменения не
должны связывать общие transport/domain contracts только с
`official-managed` инфраструктурой или удалять зарезервированные P2P/on-prem
seams.

## P0 — XPoint anti-blocking message path

- Подключить `PrivacyRoutedMailboxBinaryIngress` к реально аттестованному клиентскому Xray/VLESS Reality carrier. Сейчас exact MAU2 получает три криптографических privacy-слоя, но первый frame отправляется отдельным прямым HTTPS `HttpClient`; `IRealityTransportRuntime` остаётся диагностическим соседним контуром.
- Зафиксировать один production composition path: `E2EE -> durable MAU2 -> three-hop privacy frame -> local/embedded Reality transport -> public XNode Reality ingress`. Запретить direct HTTPS fallback после выбора masked режима.
- Связать signed route/contact с exact Reality endpoint, RouterId и транспортными параметрами. Rotation/fallback не должны допускать подмену origin, SNI, Reality key/short-id или переход на немаскированный путь.
- Добавить UAT с real Xray/Reality на клиенте и XNode: прямой HTTPS к managed ingress заблокирован, а Store/Retrieve/Ack через masked carrier работают; primary и полностью непересекающийся fallback доказаны отдельно.
- Завершить production bootstrap/discovery без локальных DEV secrets: public DNS/TLS, signed authority/routes, secure holder enrollment и обновление route contacts.
- На одной production-bound commit matrix подтвердить Android ↔ Windows: добавление произвольного контакта, direct text в обе стороны, exactly-once, cold restart и отсутствие direct MAU2 endpoint.
- Подтвердить группы через тот же XPoint path: создание группы с произвольным участником, state/message/reply/reaction в обе стороны, exactly-once и cold restart обоих клиентов. Отдельная ранняя `GroupText` physical-фаза уже существует, но успешного device evidence ещё нет.

## Следующий post-production спринт — Direct P2P

Эта секция не входит в Definition of Done первого production-релиза. До её
реализации Direct P2P остаётся скрытым/fail-closed и не рекламируется как
доступный режим.

- Принять отдельный protocol/crypto/privacy ADR для peer authentication, session establishment, replay protection, address/metadata exposure, key continuity и transport downgrade. Immutable Session-reference и Nearby scaffolding не являются production protocol.
- Реализовать настоящий `IDirectP2pSessionMessageTransport`; текущий Release composition намеренно fail-closed, потому что такого адаптера нет.
- Реализовать как минимум два discovery/connectivity пути:
  - полностью локальный offline rendezvous между устройствами без Registry/Internet;
  - Internet P2P с authenticated rendezvous и ICE/STUN, где это возможно, с явным состоянием direct/relay. TURN relay не должен называться Direct P2P.
- Подключить P2P к существующим E2EE envelopes, durable logical outbox, receive/dedup/ACK и cold-restart recovery. Нельзя отправлять P2P-сообщение в official mailbox как скрытый fallback без явной пользовательской политики.
- Добавить UI выбора/состояния транспорта и безопасное переключение. Account и recovery phrase создаются локально и не должны зависеть от сети или выбранного транспорта.
- Получить второй Android API 28+ и подтвердить на двух физических устройствах: offline account creation, arbitrary contact pairing, text в обе стороны, reconnect, exactly-once и cold restart. Подключённый Galaxy A5 API 26 ниже `minSdk 28` и не закрывает gate.
- Явно определить post-production scope P2P для групп, attachments и calls. До реализации соответствующая функция должна быть скрыта или показывать точное `unavailable`, а не использовать другой transport неявно.

## P0 — production liveness и широкий круг пользователей

- Исправить два finding независимого review для reactive mailbox refresh:
  - сравнивать полный проверенный authority/revocation/topology trust tuple, а не требовать безусловного увеличения topology generation;
  - добавить lifecycle-owned bounded cancellation для refresh, чтобы `StopAsync`/`Dispose` не могли зависнуть на Registry/HTTP/storage.
- Реализовать initial forward bootstrap для клиента без protected checkpoint: свежий APK с floor `N` должен безопасно догонять `N+K` с проверкой rollback/fork/wrong-network.
- Отличать recoverable `BehindBuildFloor` от corruption: старый защищённый state сначала исторически проверяется, затем обновляется без потери identity, истории и durable outbox.
- Registry должен хранить точную predecessor/closure history на поддерживаемый offline horizon, а запрос клиента — криптографически связывать нужного predecessor. Не заменять историю одним latest bundle.
- Добавить proactive authority/revocation refresh на resume/foreground и перед сетевой операцией, с expiry margin, jitter/backoff и продолжением durable outbox.
- Проверить reconnect после 30/180/365 дней offline и безопасный re-enrollment за пределами поддерживаемого окна.
- Убрать release-заглушку `production-credentials-unavailable`: clean install должен получать production trust/runtime через публичный control plane. Ошибка сети не должна блокировать локальное создание account; P2P остаётся отдельной post-production работой.

## Release evidence после закрытия P0

- Исправить оставшийся PowerShell smoke failure `AndroidRunnerExecutesAndEvidenceRejectsTamperingAndStaleness`; текущий полный результат — `179/180`, а не прежние `162/165`.
- Заменить или изолировать HonKit `6.2.2`: его build-time dependency `immutable <4.3.9` имеет две high-severity DoS advisory, а совместимого автоматического обновления сейчас нет. До замены сборка документации не должна обрабатывать недоверенный внешний контент.
- Перевыпустить Mr. X-signed Android lab policy на exact MAUI commit, APK, runner и dependency pins.
- Повторить full Android ↔ Windows payload matrix только для функций, входящих в v1 scope. Добавить безопасный Gallery fixture; устранить или надежно изолировать Windows native file-picker foreground barrier, не блокируя ранние contact/group/text gates.
- Повторить HTTPS manual resend, automatic retry и durable ACK crash-window suite на exact production-bound commit matrix; выпустить актуальный sanitized evidence envelope.
- Если calls входят в v1, подтвердить physical ringing/accept, selected ICE pair, двусторонний RTP, mute/restore и hangup; отдельно маркировать direct ICE и TURN relay.
- Выпустить exact signed Android/Windows artifacts, SBOM, dependency inspection и sanitized evidence manifest на одной commit matrix.
- После реализации провести независимые lead developer и security reviews и закрыть их release-blocking findings.

## P1 — ранее найденный release/security hardening

- Расширить recovery drill с byte-exact Docker volume snapshot/restore до проверки XNode identity, privacy routing, TURN/call state и полного восстановления пользовательского контура; отдельно проверить production rollback.
- Подтвердить production DNS, public TLS issuance/renewal и expiry alerting до подписи релиза.
- Сузить UAT runtime secret mounts: HAProxy и coturn получают только нужные leaf certificate/private key и public CA/CRL; `ca.key` и посторонние authority-файлы не монтируются в runtime-контейнеры.
- Удалить из Android evidence стабильные несолёные SHA-256 низкоэнтропийных model/product/hardware properties либо заменить их run-scoped keyed HMAC без межзапусковой корреляции.
- Сделать RC commit-matrix scripts воспроизводимыми в новом PowerShell process без явного `-RepositoryRoot`; добавить контракт на документированную default-команду.
- Устранить межтестовый SQLite pool race вокруг глобального `SqliteConnection.ClearAllPools()` и подтвердить стабильность несколькими полными shared-suite прогонами.
- Проверить production-only DNP1 genesis/cutover/reset seams и выполнить безопасный rollback/recovery rehearsal.
- Не заявлять iOS/iPadOS/macOS проверенными до появления реальной signing authority и device evidence.

## On-prem — ограничения, которые сохраняем сейчас

Сам on-prem deployment выполняется позднее. До него обязательны архитектурные guards:

- сохранять отдельный `authenticated-mau2/user-managed` ownership и accepted dormant self-hosted activation contract; не трактовать `official-managed` Registry, PMA1, billing или Mr. X как универсальную authority;
- generic message/group/outbox contracts не должны знать, кто эксплуатирует xnode; official и user-managed acquisition/providers остаются разными композициями;
- сохранять consent-bound network/genesis switch, atomic protected LKG, mandatory TLS/SPKI validation и поддержку private/loopback origins только для явно выбранного user-managed профиля;
- не ослаблять official public-address policy ради on-prem и не расширять official-only PeerDeposit importer: для user-managed нужен отдельный issuer/provider path;
- XNode должен оставаться запускаемым как один узел или несколько узлов с внешними state/secrets, без скрытой зависимости от Deep-operated DNS, Registry, billing или signer;
- добавить architecture contract tests, которые не позволяют удалить `UserManaged`/SHR1 seams при работах над первым релизом.

## Definition of Done первого релиза

- На чистой установке account создаётся без сети; после появления сети arbitrary contacts и группы работают без DEV secrets.
- При заблокированном direct managed-ingress HTTPS сообщения проходят через реальный masked XPoint carrier и exact three-hop privacy route; немаскированного fallback нет.
- Authority/revocation rotation и длительный offline не требуют сброса identity, истории или queued messages.
- Все заявленные v1 функции имеют physical evidence на одной signed commit matrix; compile/unit tests не выдаются за e2e.
- On-prem ещё не заявлен готовым, но перечисленные architecture guards проходят.
