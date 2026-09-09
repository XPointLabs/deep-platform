# История спринтов

## 2026-09-09 — official Windows ML-KEM/Braid runtime acceptance

- Official GitHub Actions artifact `10106322624` из run `34356754852`, attempt
  1, зафиксировал воспроизводимые `/Brepro` Braid DLL/import libraries из двух
  чистых изолированных target roots. Whole ML-KEM сохранил ранее принятые exact
  hashes; Braid получил новые deterministic hashes для Windows x64 и ARM64.
- Exact Braid binaries прошли managed state-machine и wrapper probes на
  физическом Windows ARM64 host: ARM64 нативно, x64 через Windows x64 emulation.
  Проверены standard-ML-KEM interop в обе стороны, pinned digest/approval
  fail-closed и single-consumer contention. Оба RID добавлены в закрытый
  production allowlist и NuGet package payload; полный Protocol gate прошёл
  `1650/1650`, 11 explicit native-harness skips, package witness прошёл.
- Apple client lane по решению Mr. X перенесён в следующий спринт. macOS, iOS и
  Mac Catalyst jobs удалены из текущей CI matrix и не возвращаются без его
  явной команды; текущий release scope — только Android и Windows.
- После исчерпания GitHub-hosted Actions лимита новые jobs завершаются до
  выдачи runner (`steps=0`). Workflow для повторной official сборки и managed
  x64 probes сохранён; следующий обязательный CI запуск будет выполнен на
  on-premise runners после их подключения оператором.

## 2026-09-09 — authority-bound DTT1 issuance epoch clean-break

- DTT1 получил подписанный authority-bound UTC-day issuance epoch, связанный с
  exact XNA1 authority core и DTS1 policy core. Старый 14-field DTT1 отклоняется
  без dual reader; signing/core projections теперь включают tag 13.
- Registry production issuer активируется только при полном наборе verified
  snapshot/proof/custody/trusted-time/ledger dependencies. Durable ledger v2
  связывает nonce с номером и ID эпохи, допускает только монотонный переход
  вперёд, а старые маркеры удаляет лишь после полной authenticated bounded scan;
  rollback, fork и tampering fail closed.
- Protocol AccountDirectory gate прошёл `95/95`, package witness `3/3`;
  Registry local-cutover gate прошёл `276/276`, Release builds — без warnings.
  Documentation gates прошли `172/172` и `176/176`.
  Прямой client-to-Registry lookup по-прежнему запрещён; production deployment
  всё ещё требует настоящие root/genesis/contact/group/release authorities.
- Native policy переведена на consumption готовых signed/attested official Deep
  ABI binaries без локальной пересборки. Существующий Windows x64 runtime уже
  hash-allowlisted; Windows ARM64 остаётся pending, потому что upstream
  `mlkem-native` публикует source provider, а не совместимый Deep wrapper DLL.
- В `deep-protocol` добавлен ручной GitHub Actions workflow официальной сборки
  Windows x64/ARM64 Whole ML-KEM и Braid ABI с pinned toolchains, clean-checkout
  gate, SHA-256 manifest, artifact attestation и закрытым binary bundle. ARM64
  Braid тесты cross-compile без попытки исполнять ARM64 PE на x64 runner;
  production acceptance всё ещё требует получить и проверить сам attested
  artifact на зафиксированном commit.
- Mr. X назначен единственным временным владельцем всех production authority до
  явного изменения перед появлением пользователей. Существующий Play upload
  credential скопирован без изменения в отдельный `secrets/prod/android`;
  private bytes и passwords не выводились.
- Legacy inline VLESS/REALITY credentials first-release topology fail-closed
  перенесены в шесть ACL-защищённых per-node files; private env теперь содержит
  только `_FILE` bindings. `Config` и focused contracts проходят, survival stack
  не изменён. `Up` честно остановлен до production root signer custody и
  отсутствующих `ADH1/ADC1/XVP1/XNV1/XNH1/XND1/PMT2` genesis authors.

## 2026-09-09 — final security hardening и fail-closed release composition

- XNode quorum signing теперь доступен только на exact peer-RPC listener и из
  разрешённой coordinator network; public API listener не может стать signing
  oracle. REALITY private key и VLESS UUID читаются только из bounded read-only
  secret files, не попадают в environment/options serialization, а generated
  Xray config фиксируется атомарно с закрытыми правами. Полный XNode Release
  regression после hardening прошёл `696/696`.
- Registry проверяет, что verified XIR1 подписывает именно запрошенный locator,
  до любого LKG/fork-state mutation. Публичные lookup paths получили общий
  bounded admission с короткоживущими per-source buckets; production
  ContactResolve HTTP issuance на этом этапе оставался намеренно `503`, потому
  что CDQ1/DTT1 ещё не содержал authority-bound replay epoch для безопасной
  compaction exact one-use nonce ledger. Прямой MAUI-to-Registry lookup удалён;
  production client принимает только verified privacy-routed host capability.
- Release `InternalsVisibleTo` между Shared и MAUI удалён из фактического build
  graph. Account-scoped SQLCipher/pre-key/session owner перенесён за opaque
  `DeepDirectMessagingStorageFacade`; raw store/secret типы остались internal.
  Actual dependency-shape hostile gate, Windows app/ViewModels builds и
  direct-storage lifecycle/restart/cleanup `11/11` прошли.
- First-release readiness теперь требует Contact и Group terminals и остаётся
  `503 required-unavailable` до настоящих Registry genesis/leaf и GSR1/DCR1
  authority inputs. Group creation с участниками также fail closed до real
  invitation/fanout/acceptance, не создавая ложный owner-only success.
- Docker, публикация, deploy и physical install не выполнялись. Оставшиеся
  production authority/composition и Windows ARM64 native prerequisites ведутся
  только в `NEXT-SPRINT.md`.

## 2026-09-08 — bounded DPK2 publication/claim и opaque client custody

- Protocol заменил monolithic XPP1 на bounded manifest/chunk/commit до 65 945
  байт на request, проверяет две независимые final XIC1 и выдаёт sealed atomic
  installation plan с restart-safe replica lineage. XPK1/XPC1 получил durable
  exact-retry journal; cross-operation, rollback, fork, phase/status и legacy
  wire fail closed.
- Private DPK2 material больше не пересекает public assembly boundary и не
  хранится в raw SQL columns/callbacks. Versioned XChaCha20-Poly1305 blob
  привязан к network/account/device generations, DPD1, exact DPK2, kind и
  pre-key IDs; Shared schema generation 4 хранит только exact DPK2 и canonical
  opaque blob, восстанавливая single-use capability только внутри atomic
  responder/TRS1 saga.
- Production `InternalsVisibleTo` из Protocol удалён. Public genesis composition
  выдаёт verifier-minted device и opaque `AuthorGenesisDmd1`, не экспортируя
  issuer seed/signature/provider. Full Protocol Release: `1883 passed`, 11
  platform-native skips; package witness, immutable corpus и zero-friend gates
  прошли. Full Shared win-x64: `1680/1680`, без skips; approved native asset
  SHA-256 `D682595F4F88D18A1A3039319D22CC06AAAA706C851EC717B06B6E45D42B2F45`.
- Shared ContactResolve теперь отправляет XPK1 через durable journal, а каждый
  bounded XPP1 stream — отдельно двум placement replicas; activation возможна
  только после двух verified XIC1. XNode сохраняет journal и inventory одной
  транзакцией до подписи single-replica XIC1; full gates: XNode `218/218`,
  integration `362/362`, profile generator `107/107`; Registry core `265/265`.
- Дополнительно устранены SQLite self-deadlock revocation read без TOCTOU,
  cancelled queued stale send и late physical failure после уже сохранённого
  terminal state. MAUI account owner смонтировал отдельные SQLCipher XPK1,
  current-DMD1, Group invitation activation stores и удалил legacy
  GroupV1 `SessionId` alias.
- First-release Docker не запускался: отсутствуют offline root signer/current
  authority artifact inventory и TLS PEM. Survival stack остался healthy.
  Physical delivery не заявлен: current DMD1/account-authority producer ещё не
  подключён к AppShell activation, а Windows ARM64 C++ target/native ML-KEM
  prerequisite на машине отсутствует.

## 2026-09-08 — публичная документация синхронизирована с release readiness

- Пользовательские и операторские страницы теперь честно отделяют готовый
  offline account/постоянный Deep ID от ещё не активированных direct messaging,
  групп и first-release XPoint stack. Зафиксированы Android API 28, будущие
  P2P mesh/on-prem профили и текущий Registry authority blocker.
- Повторяющиеся нормативные детали заменены ссылками на master technical docs;
  `verify-render` прошёл `241/241`, `npm audit` не нашёл уязвимостей,
  `git diff --check` чистый. Публикация не выполнялась.

## 2026-09-08 — Registry production ContactResolve authority prerequisites

- Registry получил production trusted-time source, durable one-use request
  ledger и DTT1 witness custody. Trusted UTC задаётся оператором, защищается
  HMAC и продвигается monotonic clock; rollback/reset/tampering/expiry и nonce
  replay после restart закрывают issuer fail-closed.
- Операторские команды `provision-time` и `author-package` проверяют полную
  Protocol-signed closure и выпускают свежие request-bound DTT1/ADP1 и
  canonical CDR1. Witness seed не выходит из custody, а неполная включённая
  конфигурация останавливает startup до файловой мутации; default остаётся
  dormant/503.
- Hostile/restart gate прошёл `10/10`, Directory/ContactResolve — `69/69`,
  Registry Release — `265/265`, build с warnings-as-errors чистый. Выпуск и
  монтирование внешнего root/topology/contact proof package в first-release
  compose остаются DevOps-композицией.

## 2026-09-08 — fail-closed DPK2 privacy transport boundary

- Shared разделяет pre-key publication и claim и возвращает вызывающему коду
  только Protocol-verified capabilities; direct HTTP, raw XIC1/XPC1/DCB1,
  caller trust и fallback отсутствуют. Для обоих путей доступны отдельные
  machine-readable blocker states.
- XPK1/XPC1 уже поддержан Protocol ContactResolve, но требует durable XPK1
  journal и расширения production path authority с XIQ1 на exact XPK1.
- XPP1 publication намеренно остаётся закрыт: максимальный XPP1 (`8 362 607`
  bytes) не помещается в bounded onion request (`1 048 576` bytes), а повышать
  общий предел нельзя. Нужен canonical chunk/manifest/commit protocol без
  частичной активации. Focused gate прошёл `7/7`, ContactV1 — `129/129`,
  Shared Release build чистый.

## 2026-09-08 — durable GroupV1 invitation/acceptance orchestration

- Invitation activation теперь сначала фиксируется в durable store и только
  затем отправляется через готовый privacy-routed GroupControl. Exact
  predecessor, known sibling/fork и out-of-order проверяются до первого
  network write; generic transition API не может обойти invitation semantics и
  фиктивно сделать участника active.
- Exact-operation retry/restart, verified GSS1, idempotent commit и permanent
  conflict latch сохранены; per-device message handoff допускает только узкий
  DPE2 dispatch context без legacy payload/`SessionId`.
- GroupV1 Release gate прошёл `74/74`, solution build чистый. Account-scoped
  MAUI store/transport composition и реальный DPE2 dispatcher остаются
  незавершённым consumer.

## 2026-09-08 — owned bounded HTTP service boundary

- Публичные `CreateBoundHttpHandler`, `HttpClient`, network-hook/delegate seams
  удалены. Registry и Contact Directory используют factory-owned disposable
  POST transport с exact path allowlist, request/response bounds и строгой
  endpoint/media-type проверкой; Contact directory constructor стал internal.
- Internal attested-carrier hooks сохранены через first-party friend boundary.
  Redirect, cookies, decompression и system proxy выключены; TLS certificate
  revocation остаётся `Online`.
- Исходный public-surface regression прошёл `1/1`, Shared HTTP — `64/64`, MAUI
  Registry/Contact — `32/32`, smoke — `24/24`; затронутые Release builds чистые.
  Это намеренный clean-break для внешних потребителей.

## 2026-09-08 — atomic initiator DPH2/TRS1 Shared adapter

- Protocol initial-session capability потребляется ровно один раз и фиксирует
  exact DPH2 вместе с canonical TRS1 одной SQLCipher-транзакцией, связанной с
  operation/session/contact, обеими account/device и directory generations.
- Exact replay идемпотентен; wrong scope/generation запрещает dispatch, а
  changed bytes ставят durable fork latch. После restart pending DPH2 доступен
  из защищённого outbox; UI cancellation после consume не разрывает короткий
  atomic commit. MessagingCrypto schema clean-break поднята до generation 5.
- Новые тесты прошли `10/10`, расширенная regression — `45/45`, Shared Release
  build чистый. Session остаётся pending до verified privacy-routed DPH2
  delivery receipt; established DPE2 заранее не выдаётся.

## 2026-09-08 — MAUI GroupV1 composer clean break

- Group composer больше не использует `SessionId`, legacy `ClientRuntime`,
  `IContactMailboxOnboarding` или scaffold API. Он принимает canonical
  `deep1…`/DIA1, повторно проверяет сохранённый ContactV1 package и создаёт
  GroupV1 через account-scoped runtime и custody текущего устройства.
- Missing account/custody/verifier/owner authority показывается как точный
  fail-closed state. Legacy GroupChat для нового group ID не открывается;
  verified members остаются draft до настоящего invitation/fanout/acceptance,
  а не объявляются активными фиктивно.
- Focused Release gate прошёл `9/9`, XAML/Windows compile и source guard чистые.
  Durable GroupControl invitation/acceptance и GroupChat DPE2 handoff остаются.

## 2026-09-08 — first-release ONION config wiring

- DevOps provisioning создаёт для каждого из трёх XNode отдельный 32-byte
  state-protection key и передаёт bounded replay/entropy/key-vault paths;
  позиции закреплены как Ingress/Core/Exit. Значения ключей не выводятся,
  повторное provisioning идемпотентно.
- Compose `Config`, `11/11` Node contracts, PowerShell guards, locked helper
  build и private-material scan прошли. `Up/Verify` fail closed до image build:
  Registry ещё не предоставляет production trusted-time source, durable
  one-use ledger, DTT witness custody и полный current
  ADH1/DTT1/ADP1/XVP1/XNV1/XNH1/XND1/PMT2 authority package.
- First-release containers остались остановленными, volumes сохранены, survival
  stack не изменён и остаётся healthy.

## 2026-09-08 — durable DPK2 publication/claim owner

- Shared атомарно сохраняет authored one-time/last-resort secret capabilities
  вместе с exact XPI1/XPP1 в account/device/generation/DPD1/DMD1-bound
  SQLCipher inventory. Private material проходит только через одноразовую
  `Dpk2PreKeySecretCapability`; raw-key/provider/trust-flag API отсутствует.
- Verified XPC1 связывается с exact DPK2 hash и prekey IDs. One-time secret
  удаляется после finalization, last-resort zeroize-ится после bounded use;
  replay возвращает exact XPP1, а rollback/conflict/predecessor mismatch ставит
  durable fork latch.
- Shared PreKey/coordinator gate прошёл `35/35`, Protocol DPK2/DPH2 — `5/5` и
  `11/11`; обе Release сборки чистые. MAUI lifetime/publication scheduler и
  privacy-routed XPP1/XPK1/XPC1 wiring остаются незавершёнными.

## 2026-09-08 — canonical arbitrary-contact MAUI entry flow

- New-conversation UI принимает только canonical permanent `deep1…` DID1 или
  поддерживаемый DIA1 и запускает durable ContactV1 resolver state machine.
  Retryable offline/unavailable сохраняет pending address и исходный ввод с
  точным повтором; local account startup от сети не зависит.
- Verified outcome выдаёт только verifier-minted opaque relationship и
  conversation IDs. Pending/terminal/fail-closed не открывают чат; `SessionId`,
  старый `05…` parser и legacy Chat route в этом entry-flow отсутствуют.
- Unit gate прошёл `8/8`, source smoke — `2/2`, Core Release и Windows
  MAUI/XAML Debug — без warnings/errors. AppShell activation нового DPH2/TRS1
  runtime остаётся незавершённым consumer.

## 2026-09-08 — XNode production ONION runtime closure

- `ProductionCapabilityAvailable` больше не является заглушкой или отражением
  одного config-флага. Capability появляется только из актуальной Protocol-
  minted XNV/XND/network authority, exact local owner/role, durable replay и
  entropy stores, opaque X25519 key-vault binding и codec, переданных атомарно.
- Stale/mismatch/wrong role/missing authority/partial DI fail closed; импорт
  X25519 не перезаписывает несовпадающий существующий vault slot. Health и
  advertised capabilities используют ту же проверенную instance capability.
- Privacy runtime gate прошёл `11/11`, durable ONION/key-vault — `16/16`, полный
  XNode Release build — без warnings/errors. First-release compose ещё должен
  передать отдельный state-protection secret, state paths/position и current
  topology/contact authority package.

## 2026-09-08 — production DPH2 initiator и initial TRS1

- Protocol реализует двухфазный `PrepareClaim → Complete` только из
  `VerifiedDpk2Offering`, exact XPC1 claim receipt и локального device agreement
  lease. Ephemeral и initial-ratchet X25519 создаются внутри boundary.
- Результат содержит self-verified canonical DPH2, первый DMC2 с одним из
  допустимых padding buckets, durable canonical TRS1 и single-use zeroizing
  capability для их атомарной фиксации. Recovery seam существует только в
  test build; неподтверждённые ML-KEM/Braid assets fail closed.
- Focused initiator gate прошёл `11/11`, расширенный crypto/integration —
  `68/68`, native provider suites — 16 passed/6 environment skips; полная
  Protocol Release сборка завершилась без warnings/errors. Shared atomic-store
  adapter и network dispatch остаются незавершёнными потребителями.

## 2026-09-08 — MAUI direct-message storage owner и session catalog

- Локальный Deep account теперь владеет одним account-wide SQLCipher DPK2
  prekey store и отдельным SQLCipher DPE2 store для каждого verified
  contact/device/DPH2 tuple. Durable DSC1 catalog связывает network, обе пары
  account/device с поколениями, `ContactConversationId32` и exact DPH2 ID.
- Boundary не использует `SessionId`, recovery phrase или synthetic aliases;
  protected keys разделены, pending→active recovery, wrong generation/network,
  reset и zeroization fail closed. Focused SQLCipher gate прошёл `9/9`.
- Owner теперь также владеет `ProductionPreKeyV1InventoryOwner`, сохраняет
  exact XPI1/XPP1, готовит verified-DPK2 initiator DPH2, атомарно фиксирует
  TRS1 и принимает responder commit через `ContactInitialSessionCoordinator`.
  Canonical DPD1 reference, scope/generation/restart/reset и zeroization
  подтверждены обновлённым gate `11/11`.
- MAUI Windows ARM64 Release собран без warnings/errors; проверенный DLL имел
  SHA-256 `FE016207F34B0014FC5589AE35C1F67F0F078CE990E811F8B4CC4C3FE2952091`.
  Сетевая DPK2 publication/claim, DPH2 dispatch и production bridge от
  protected device authorization к одноразовой agreement lease остаются
  незавершённой композицией.

## 2026-09-08 — incremental ML-KEM Braid supply-chain evidence

- Для неизменённых Windows x64 и Android arm64 candidate bytes добавлены
  machine-readable manifest и CycloneDX SBOM (22/21 компонентов), точные
  hashes Rust 1.89.0, `Cargo.lock`, `libcrux-ml-kem 0.0.10` и всех crate
  checksums.
- Rebuild gate повторно подтвердил exact 17 exports, Windows CFG/ASLR/High
  Entropy VA/NX, Android RELRO/NOW/non-executable stack/no TEXTREL и физический
  USB roundtrip. Hostile drift gate отклонил `6/6` мутаций manifest/artifacts.
- Production approval не включён: Windows ARM64 candidate, независимый oracle
  и crypto/dependency review остаются обязательными. Исходники native candidate
  и evidence должны войти в будущий коммит атомарно.

## 2026-09-08 — locator-keyed MSG01 recipient authority

- XNode получил production source, который по opaque locator повторно связывает
  Protocol-verified DPD1/DCA1/XIR1 с PMS2 из того же replica-authenticated
  route closure и текущими XNV1/PMT2. Permanent resolve и one-time invite claim
  поддерживаются без caller trust flags, raw keys или локального DPE1 minting.
- Проверяются monotonic freshness, network/locator, exact references, сроки и
  active-device status; повтор идемпотентен и использует один immutable evidence
  snapshot. Focused integration прошла `42/42`, XNode Release build — без
  warnings/errors.
- Добавлен durable bounded permanent/one-time resolve evidence cache с двойной
  authenticated encryption, restart recovery, zeroization и постоянной fork-
  защёлкой. Перед записью и чтением заново проверяются DID1/DIA1, XIQ1/XIS1,
  DCR1, DCB1/DMD1/DPD1 и route closure; plaintext identity/locator material в
  cache не хранится. Полный XNode gate прошёл `675/675` и Release build чистый.
- Production issuer/client flow ещё должен передать этому owner independently
  verified evidence через privacy-routed authenticated ingestion; до этого
  неизвестный locator остаётся fail-closed unavailable, без Registry/raw
  fallback.

## 2026-09-08 — безопасный first-release local bootstrap

- DevOps создаёт три свежих независимых XNode identity и защищённый ignored
  `first-release.env` в `C:\Work\DeepSession\secrets\first-release-local`.
  Ed25519 создаётся штатным Node crypto, Reality — offline Xray, а BLS
  public/proof — production XNode verifier через Prague/EIP-2537 RPC; VLESS,
  X25519 и BLS scalars используют криптографический RNG.
- Десять contract/keygen тестов, locked .NET restore/build, реальная BLS
  integration, ACL/inventory, secret scan и повторный bootstrap прошли.
  Повторный запуск не заменяет существующие identity и не печатает private
  material.
- `Config` проходит. `Up/Verify` остаётся fail-closed до подключения настоящей
  production ONION runtime closure в XNode; guard не отключён. Неуспешная
  first-release topology остановлена, survival stack остался healthy.

## 2026-09-08 — privacy-routed GroupControl client transport

- Shared client выбирает exact-three GroupControl route только из защищённых
  entry guards и проверенного `VerifiedGroupControlPlacement`; request всегда
  использует типизированную операцию `GroupControl`, а не общий или caller-
  controlled ingress.
- Exact GSW1/GSQ1 проходит через managed privacy ingress, а GSS1 проверяется
  production Protocol client до изменения client state. Fallback разрешён
  только после подтверждённого pre-forward reject; wrong route/network/
  operation, replay, hostile bounds, redirect и неверный media type закрыты.
- Focused GroupV1/managed-ingress regression прошёл `68/68`, Shared Release
  build — 0 warnings/errors. Это закрывает control transport, но не заменяет
  ещё незавершённый per-device DPE2 fanout и physical group-message gate.

## 2026-09-08 — physical Android gate incremental ML-KEM Braid

- Whole-KEM `mlkem-native` v2.0.0 production wrapper также прошёл отдельный
  managed Android probe на API 26: packaged identity/digest, drift rejection,
  roundtrip, dispose/reload и production-runtime owner. Probe-only asset:
  325216 байт, SHA-256
  `7799b36b8c522905f655af518124cdd74b97224c4ee42beb2f8142065392cd87`.
- Pinned `libcrux-ml-kem 0.0.10` incremental provider повторно собран для
  `android-arm64` с NDK `28.2.13676358`; export allowlist содержит ровно 17
  Deep ABI symbols, зависимости ограничены `libc.so` и `libdl.so`, проверки
  RELRO/NOW прошли.
- На физическом `arm64-v8a` Android устройстве изолированный native probe
  выполнил два keygen/Encaps1/Encaps2/decapsulation roundtrip, unload/reload и
  подтвердил отклонение replay/double-dispose без вывода secret bytes.
- Отдельный .NET 10 Android probe APK на том же API 26 устройстве подтвердил
  managed-wrapper staging/digest, закрытый production allowlist, ABI load,
  exact shared-secret interop, single-use и concurrent single-consumer,
  disposed-provider fail-closed. Десять полных roundtrip заняли 26,752 мс.
- Воспроизводимый текущий candidate: 612344 байта, SHA-256
  `fa287d90ffff2c6e5b199c7f8ec487e16d989f75e39c2620b07c26e1dccbdf0d`.
  Это закрывает Android compatibility evidence, но не включает production
  approval: Windows ARM64 asset и независимый crypto/dependency review ещё
  остаются gate.

## 2026-09-08 — XNode Contact route authority producer

- XNode атомарно получает current verified Contact/XPoint snapshot и mint'ит
  `VerifiedContactNetworkAuthority` только через Protocol verifier с exact
  XNV1/XNH1/ADH1/PMT2, network/locator/generation/freshness checks до запроса
  Registry. Stale/fork/rollback и malformed durable state дают одинаковый
  coarse unavailable.
- Typed DI остаётся default-dormant и fail-closed до появления locator-keyed
  источника уже проверенных recipient DPD1/DCA1/XIR1 и независимо полученного
  PMS2; Registry bytes не повышаются до trust authority.
- Focused Contact/GroupControl regression прошёл `95/95`, полный XNode Release
  gate — `651/651`, build — 0 warnings/errors.

## 2026-09-08 — durable verified peer package

- Contact relationship теперь атомарно сохраняется вместе с полным exact
  verified package: XIQ1/XIS1/DCR1/DCB1/DMD1/DPD1, route closure, версии,
  hashes и scope/correlation identifiers. CLR capability objects в БД не
  сериализуются.
- Публичное чтение возвращает defensive-copy evidence, а `ReverifyAsync`
  повторно декодирует и криптографически проверяет durable bytes перед выдачей
  свежего authority для DPK2/DPH2. In-memory и SQLCipher semantics совпадают;
  restart/replay/fork/rollback/corruption закрыты тестами.
- ContactV1 schema clean-break поднята до generation 4; старую локальную
  ContactV1 БД нужно пересоздать. Focused gate — `55/55`, production
  capability gate — `113/113`, Release build — 0 warnings/errors.

## 2026-09-08 — production DPK2 authoring

- Protocol device-secret owner теперь создаёт production DPK2 authority только
  для exact active/unforked DPD1/DMD1. Boundary сама генерирует bundle/prekey
  IDs, X25519 и ML-KEM-768 keypairs, формирует canonical one-time/last-resort
  DPK2 и подписывает три exact projection текущим device signing key.
- Private prekeys выдаются единственной opaque single-use capability и
  zeroize-ятся; public raw-key/provider/delegate seams и Session aliases
  отсутствуют. DPK2 интегрируется с XPI1/XPP1 publication boundary.
- Debug regression прошёл `120/120`, Release focused gate с настоящим
  `deep_mlkem.dll` — `87/87`, Protocol Release build — 0 warnings/errors.

## 2026-09-08 — targeted current directory и безопасный offline Debug

- Registry получил default-dormant `POST /api/v1/directory/current-values`:
  exact ADL1 lookup request выбирает только один current-value package и не
  принимает DID/account/device или caller-authored trust. Wrong network,
  missing/nonmembership и stale/forked floor неразличимы как пустой `404`;
  отсутствие verified source/custody/time/one-use ledger даёт пустой `503`.
  File publication повторно проверяет immutable inventory, generation,
  hashes, traversal/reparse/TOCTOU, rollback и same-generation fork. Registry
  Release gate прошёл `255/255`, build — без warnings/errors.
- Shared HTTP-клиент выбирает этот endpoint только для targeted current-value
  контекста, отправляет exact 286-byte request и принимает компактный пакет из
  восьми exact-артефактов. Обычный contact-resolve endpoint сохранён отдельно;
  `404` и `503` отображаются в неэнумеруемые typed outcomes, а HTTP bytes не
  повышаются до authority. Focused HTTP gate — `37/37`, затронутый XPoint gate
  — `98/98`, Release build — без warnings/errors.
- Обычная Debug-композиция после локального создания account больше не падает
  только потому, что сборка не является physical UAT: legacy transport
  открывается dormant и fail-closed до первой сетевой операции. Локальный
  account/store startup не требует Registry или соединения.
- Legacy HTTP call signaling, который повторно загружал recovery phrase для
  подписи, удалён из MAUI composition. До подключения typed ratcheted call
  signaling ветка с настроенным call origin возвращает явный `NotSupported`,
  а не читает recovery secret и не выполняет silent downgrade.

## 2026-09-08 — Group v1 authoring и GroupControl client boundary

- Protocol production author теперь создаёт exact remove-account,
  leave-account и role-change transitions, проверяя base state, current
  directory closure, custody signer, member-entry hash и роли. Удаление или
  выход owner и фиктивная смена роли отклоняются.
- GSW1/GSQ1/GSS1 получили закрытую production client boundary: operation,
  group, GSR1, placement и две Ed25519 receipt выбранных XNode связываются до
  выдачи capability. `SessionId`, `05...` aliases и caller-authored trust на
  этой границе отсутствуют. Focused Group/GroupControl gate прошёл `29/29`,
  Protocol Release build — без warnings/errors.
- Shared получил typed `IDeepGroupV1Runtime`: local create/invite/accept,
  membership proposal/commit/apply/read работают через production author,
  `GroupClientStateService` и account-scoped SQLCipher store. Public/runtime
  boundary использует реальные Group/Account/Device IDs, проверяет custody и
  exact GSS1 до CAS-мутирования; `SessionId`, `ConversationId`, `05...` и
  caller trust flags запрещены source guard. GroupV1 gate — `44/44`, Shared
  Release build — без warnings/errors.

## 2026-09-08 — permanent Deep ID verifier и clean-break client surfaces

- Protocol теперь mint'ит sealed `VerifiedPermanentContactResolveClosure` только
  после exact DID1/XIQ1/XIS1 correlation, current directory freshness,
  permanent DCR1 open, полного identity/device closure и двух подписей выбранных
  resolver replicas из разных failure domains. Unsigned permanent success и
  one-time receipt substitution отклоняются; ContactV1 gate — 118/118.
- MAUI default-dormant ContactResolve bootstrap не создаёт network/runtime до
  локального account success и verified host capabilities. Entropy ledger и
  X25519 vault account/device/store-bound, restart/rollback/corruption fail
  closed; focused bootstrap/runtime checks — 17/17.
- Settings показывает постоянный `deep1...` из offline Deep account, а не
  legacy Session ID. Повторное чтение recovery phrase из Settings удалено:
  фраза раскрывается только один раз до подтверждения создания account. Logout
  очищает authoritative Deep local state. ViewModel/smoke checks — 5/5,
  Windows ARM64 Debug build — 0 warnings/errors.

## 2026-09-08 — XNode GroupControl production authority composition

- GroupControl host получает authority только из current verified XPoint and
  Contact closure, повторно проверяет exact GSR1/DCR1/DCA1/DMD1, две replicas,
  local Exit role, network, generation и expiry. Durable lineage обнаруживает
  restart rollback/fork/corruption.
- Полная explicit configuration активирует runtime, partial configuration
  останавливает startup, default остаётся dormant; fallback и caller-provided
  trust отсутствуют. Focused unit/integration gate — 28/28, Release build —
  0 warnings/errors.

## 2026-09-08 — transport-only Contact route-closure distribution

- Registry получил default-dormant `POST /api/v1/contact-route-closures` с
  exact 50-byte network/locator request и bounded exact-six
  `XRR1/XRA1/XRC1/XSS1/PMT2/PMS2` response. Endpoint не принимает и не выдаёт
  Deep ID, account/device, DCR1 plaintext или resolver capability и не имеет
  enumerable list API.
- File-backed source проверяет canonical immutable generation inventory,
  hashes, XIR/route graph, path/reparse/TOCTOU, per-locator rollback и
  same-generation fork. HTTP bytes остаются только transport input и не mint'ят
  verified authority.
- Подтверждено 14/14 focused hostile tests и 243/243 Registry tests на local
  Protocol cutover; Release build завершился без warnings/errors.

## 2026-09-07 — clean-break messaging protocol foundations

Статус: завершены только перечисленные локальные protocol/authority packages;
произвольный контакт в product runtime, доставка сообщений, physical E2E и
production deployment пока не заявляются.

- Production MAUI startup/account graph отделён от сетевого bootstrap: создание
  и cold restart локального Deep account не разрешают Registry/HTTP callback.
  Старые raw privacy-hop/key artifacts удалены из UI composition; при отсутствии
  нового host adapter сетевой путь возвращает типизированный fail-closed, а не
  подменяет локальную ошибку сообщением о подключении. ViewModels gate прошёл
  `613/613`, focused offline smoke — `22/22`.
- NETCODEC runtime принимает bounded ordered XVP1/XNV1/XNH1/PMT2 chains,
  проверяет authority, threshold, lineage, fork, freshness, DTT и exact
  Contact-service placement; максимумы — 4096 поколений и 64 MiB. Protocol
  suite: `1464 passed`, `6 skipped`; два внешних package/snapshot gate не входят
  в этот результат. Дополнительно реализован bounded XNF1/NFP1 reset-path:
  exact NFP/XNF и непрерывная XNA authority chain, RFC 6962 source-membership,
  root/witness thresholds, target XNV/XNH и live DTT проверяются с лимитами
  64 XNA, 64 XNF и 560 KiB. Компактированный current snapshot можно проверить
  без generation-zero operational history; новый XNF сохраняется в следующем
  protected LKG. XPoint focused gate прошёл `86/86`. Клиентский XLK1-кодек
  фиксирует exact 265-byte protected LKG, а account/device/network-scoped
  SQLCipher store выполняет atomic CAS, restart recovery, idempotent replay и
  persistent fork latch; verified current/successor/reset capabilities
  проецируются в него без caller-authored snapshot. Дополнительный регрессионный
  slice `7/7` подтвердил, что
  обычная operational rotation сохраняет прежний forward-checkpoint floor и не
  требует нового root checkpoint на каждом XNV1 поколении.
- Итоговый MAUI offline account owner теперь лениво открывает эти XPoint LKG и
  entry-guard SQLCipher stores только после явного запроса сетевого consumer.
  Они используют разные ненулевые generation-scoped SecureStorage keys,
  переживают cold restart, закрываются вместе с owner и полностью удаляются
  вместе с key slots при account reset. Registry/bootstrap/transport не
  создаются при локальном startup/account creation; объединённый offline
  XPoint+Contact gate независимо прошёл `7/7`.
- ROUTE-01 для ContactResolve локально выбирает exact-three path из immutable
  verified candidate snapshot: exit берётся только из NETCODEC placement,
  entry guard сохраняется между запросами/перезапусками и меняется при revoke
  или новой view; node/owner/host/failure-domain/origin/key не совпадают.
  Entry/Relay/Mailbox capacity берётся из своего XND1 role field, поэтому
  корректные single-role узлы не исключаются. Канонический XGS1 state,
  SQLCipher-4 integrity и sealed DDL отвергают tamper/wrong key/schema;
  persistent fork latch нельзя очистить следующим CAS. Общий shared XPoint
  Release gate (LKG + guards + Contact path) прошёл `46/46`.
  Публикация/fetch authority-пакетов и расширение provider на остальные классы
  операций остаются интеграционной работой.
- Contact resolver coordinator больше не принимает caller-authored placement:
  context создаётся только из `VerifiedContactServicePlacement`, связан с
  `ResolveInvite`, exact locator/network/account/pending address, а XIQ expiry
  ограничен request/invite/placement. Ошибка или expiry отсекаются до journal и
  network; ContactV1 focused gate прошёл `80/80`.
- Production trusted-verifier клиента теперь получает bundle/route/placement
  только из capability source, проверяет current placement и exact XIS1, а для
  DIA1 требует cryptographically verified two-replica claim receipt; permanent
  DID1, напротив, отклоняет consuming receipt. Caller keys/trust flags и старый
  bundle+route-only `Accept` отсутствуют; новый hostile slice прошёл `8/8`, весь
  shared ContactV1 gate — `88/88`.
- Protocol теперь публично mint-ит `VerifiedContactNetworkAuthority` только из
  одной current closure: verified XPoint authority/network/directory freshness,
  recipient DPD1/current DCA1 и exact XNV1/XNH1/ADH1/PMT2/PMS2. Подмена
  network/ref/time/threshold/recipient или incomplete placement отклоняется;
  capability не имеет public constructor и не принимает caller key/boolean
  trust. Focused Release gate проходит `11/11`, build — без warnings/errors.
- Triple Ratchet получил канонический локальный `TRS1` state codec с лимитом
  2 MiB: directional bindings/counters, PQ frontier/commitments/provider state,
  skipped EC/PQ keys и terminal latch переживают restart. Hostile lengths,
  ordering, checksum/semantic tampering и unknown version/flags отклоняются,
  ошибочные временные секреты очищаются. Production component provider владеет
  X25519, EC/SPQR chains, skipped keys и incremental PQ Braid injection;
  restart во время Encaps1 сохраняет полный provider state, а capability
  создаётся только из verified hybrid-handshake seed. На этом промежуточном
  checkpoint MessagingCrypto gate прошёл `115`, ещё `11` platform-native
  тестов корректно skipped на ARM64 host; последующий durable DPE2 adapter
  описан ниже в той же записи. Полная runtime composition пока не активирована.
- Incremental ML-KEM Braid Windows x64 candidate повторно собран из pinned
  `libcrux-ml-kem 0.0.10` Rust toolchain: native unit `7/7`, export/hardening
  allowlist и отдельный C ABI probe прошли. Полученный DLL имеет размер 526336
  байт и SHA-256 `41ba8b15429bfc55b6a66cdadbb1ad3372dfc98a9f2bd1bce75a86d54426cd25`,
  совпадающий с candidate manifest. Self-contained win-x64 managed wrapper на
  ARM64-хосте через Windows emulation прошёл все `3/3`: digest/approval
  fail-closed, interop с standard ML-KEM в обе стороны и single-consumer
  contention. Таблица незавершённых `Encaps1` ограничена 1024 состояниями и
  fail-closed отклоняет дальнейшее накопление, поэтому брошенные handles не
  образуют неограниченное удержание secret state. Production approval намеренно
  не выставлен до release review и закрытия Android/Windows asset matrix.
- XNode получил durable restart-safe ONION replay/entropy stores и encrypted
  file key-agreement vault с bounds, atomic replacement, AES-GCM и zeroization;
  focused `15/15`, полный unit `191/191`. Host clean-break переведён с внутренних
  `PrivacyRoutingOperation/Hop` на публичные verified capabilities; XNode
  Release build — 0 warnings/errors, integration `201/201`. Protocol-owned
  receive boundary теперь выбирает локальный key capability по exact frame,
  выдаёт только network-verified next-hop transport capability и привязывает
  replay scope к boot ID; focused PrivacyRouting gate прошёл `50/50`.
  XNode runtime вызывает эту boundary и пересылает только sealed next-hop без
  DNS/manual peer lookup. Активация намеренно остаётся выключенной до producer
  свежей подписанной network closure, peer-ingress admission и полного DI.
- Shared runtime storage E2E переведён со старого DPE1/MAU2 wrapper на отдельные
  per-client MSG01 authoritative endpoints: direct messages, reply/reaction,
  attachment/voice metadata и small-group flow прошли `5/5`; raw direct/group
  dispatch в harness запрещён.
- Для one-time Contact Resolver redemption заморожен и реализован точный
  160-байтный replica-receipt transcript, связанный с request/locator,
  publication generation/expiry/ciphertext, exact route closure, commit
  generation и server time. Обе Ed25519-квитанции проверяются focused XNode
  тестом; Contact facade gate прошёл `4/4`.
- Клиентская protocol boundary для той же XIS1 claim теперь выпускает sealed
  capability только после проверки exact ResolveInvite placement, XND1 identity
  keys, двух разных failure domains, обеих подписей над 160-байтным transcript,
  object/route hashes и live trusted-time lease. Hostile gate прошёл `10/10`,
  объединённый XPoint/claim gate — `96/96`; permanent DID не может выдать
  one-time claim capability.
- XNode Contact receipts больше не требуют приватных ключей обеих реплик в
  одном процессе: per-replica typed authority подписывает только свой exact
  statement, ID жёстко связан с resolver/pre-key replica, а канонический
  193-байтный контейнер появляется лишь после двух валидных подписей. Hostile
  focused gate прошёл `10/10`, полный XNode unit — `197/197`; production host
  остаётся выключен до remote replica transport и XPA consume saga.
- `XPA1` получил production non-forgeable publication capability: exact XPU1,
  XNA/ADH/DTT authority, PublishInvite placement, monotonic boot/time window,
  sorted current witnesses и независимые failure domains проверяются до любой
  reservation/mutation. Hostile gate прошёл `10/10`, весь ContactV1 — `59/59`.
  XNode consumer сохраняет AES-GCM-защищённую однонаправленную saga
  `authorizationId -> Reserved -> Committed`, permanent conflict latch и
  выпускает receipt только после durable quorum `2/2`; restart/crash/replay/
  concurrency gate прошёл `15/15`.
- `CONTACT-SERVICE-01` получил authenticated HTTPS/HTTP2 transport между двумя
  NETCODEC-selected replicas и fail-closed host/DI boundary. Ed25519 transcript
  связывает sender/recipient, route, timestamp, nonce, correlation и exact body
  hash; receiver заново получает current placement до мутации, а receipt
  выпускается только после exact durable reread (для publication также после
  committed XPA saga). Закрыты wrong peer/network/placement/signer, replay,
  timeout, lost response и dormant endpoint; повторены `17/17` core и `24/24`
  integration tests. Дополнительно replay admission сделан строго bounded при
  concurrency (`12/12` transport tests). Runtime/endpoint остаются выключены
  до production XNV/PMT placement, route-closure и XPA authority sources.
- XNode ClaimPreKey bridge формирует canonical XPC1 из exact XPK1 и durable
  inventory: suite `0x0201`, DPK2 generation/counter/time, domain-separated
  DPK2 hash и две replica signatures детерминированы, поэтому replay после
  restart байт-в-байт совпадает. Malformed DPK2, selector/replica identity
  substitution закрываются без выдачи pre-key. Focused gates:
  ContactPreKey `23/23`, facade `15/15`, replica transport `13/13`; Release
  build — без warnings/errors. Endpoint остаётся dormant до Protocol-owned
  двухрепличной publication capability для exact XPS1/DPK2 inventory.
- DNP1 subprocess gate больше не зависит от несовместимого `PSModulePath`
  PowerShell 7/Windows PowerShell 5.1: file digests вычисляются streaming .NET
  SHA-256/SHA-512 с прежними exact hashes. Полный XNode ProfileGenerator gate
  восстановлен с `102/107` до `107/107` без ослабления closure-проверок.

- Account Directory authority реализует canonical ADC1/ADH1/ADP1/ADF1/AFP1,
  threshold/freshness/consistency и fail-closed rollback/fork/revocation
  semantics. Production LKG теперь безопасно восстанавливается после restart:
  сохранённый ADH1 повторно проходит canonical/network/authority/witness-policy
  проверку и остаётся rollback floor даже после operational expiry. Protocol
  Release-набор прошёл `88/88`, shared restart/state-store набор — `21/21`.
- `CONTACT-CODEC-01` замораживает DCB1/DCR1 closure, exact DRS1/DPD1 support,
  XIR1/XPS1 pre-key references, ADL1 freshness floor и полный XPU1/XPO1/XIQ1/
  XIS1/XPK1/XPC1/XUW1/XUQ1/XUS1 service wire. Вложенный ADL1 декодируется
  канонически и связан с network/minimum ADH tuple; размеры DCR/XIS, canonical
  claim/event hashes, event chain и retry semantics проверяются fail-closed.
- Frozen Contact manifest и anchor синхронизированы; Contact Release-набор
  прошёл `49/49`, отдельный specification checker — успешно. Локальный client import
  принимает только canonical бессрочный DID1 или отдельный expiring DIA1 и
  сохраняет pending state в account-scoped SQLCipher SQLite без `SessionId`;
  restart/concurrency/wrong-key/corruption gate прошёл `25/25`. Network
  resolution и runtime activation пока не заявляются.
- `CONTACT-CLIENT-01C` добавляет durable transport-neutral relationship state
  machine поверх того же SQLCipher store: нормативные CAS/revision transitions,
  атомарный operation journal, exact/conflicting replay, restart/concurrency,
  account-scope и corruption rejection. Verified identity/artifact evidence
  нельзя создать до trusted verifier boundary. Focused ContactV1 Release gate
  прошёл `39/39`. Итоговая MAUI composition создаёт/восстанавливает постоянный
  Deep ID и сохраняет canonical DID1/DIA1 pending contact полностью offline;
  restart/reset/secure-slot gate прошёл `5/5`. Network resolver и message
  activation остаются незавершёнными.
- `GROUP-CODEC-01` реализует 12 canonical group/control records,
  owner-sequenced transition verification, account-directory closure,
  durable successor/fork latch и DMC2 kinds 15–17/26–29. Сфокусированный
  Release-набор прошёл `17/17`, checker исполнил `14` hostile cases. Verified
  transition теперь выдаёт immutable exact GCP1 SHA-256 capability. Client
  package хранит account/generation-scoped SQLCipher head, proposals, invites,
  per-recipient cursors, CAS/replay и persistent fork latch; focused gate
  прошёл `8/8`, включая exact-byte binding до транзакции и после restart.
  `GROUP-CLIENT-01` теперь атомарно фиксирует один canonical DGM1 как один
  MSG-01 logical outbox и полный stable per-device fanout под database-wide
  read lease текущего DGC1: исключает author device, сохраняет directory/DPD1
  bindings и стабильные operation IDs, fail-closed обрабатывает stale/fork/
  replay и держит границы `100 members / 500 devices` (`499` remote targets).
  Независимо повторённый Release gate `GroupV1|Msg01` прошёл `71/71`.
  Product dispatch остаётся выключенным до per-device DPE2/ratchet composition
  и повторной проверки current group head непосредственно перед первым send.
- MSG-01 durable boundary реализует logical envelope/fanout, per-target
  attempts, reconcile/ACK intents, idempotency и crash-safe transaction store;
  legacy transport outbox не может работать параллельно в release composition.
  Shared Release-набор прошёл `48/48`, hostile friend/reflection boundary и
  MAUI composer `2/2` — успешно. До подключения production DPE2/Triple Ratchet
  transport намеренно возвращает `MessagingV1CryptoUnavailableException`.
- Exact DPE2 receive и send transaction pipelines реализуют DTR2 binding,
  header hash/nonce/AAD, combined key, AEAD-before-commit, replay fence,
  message-key deletion и crash-atomic state release. Дополнительно реализован
  managed профиль ML-KEM Braid для уже определённых частей transcript:
  HKDF-SHA-512, SHA3-256 public-key hash, HMAC, exact DTR2 header/Ct2 auth,
  transactional auth update, epoch/replay и защищённый export/import состояния.
  Этот ранний slice был доведён до полного managed component provider и
  MessagingCrypto gate `115 passed`/`11` platform-native skipped.
  Client persistence authority теперь хранит exact TRS1 в отдельном
  account/device/conversation/session-scoped SQLCipher v4 store и атомарно
  фиксирует state, replay/deletion/PQ evidence и hash-chained journal; закрыты
  cross-process CAS, exact replay, durable fork/rollback latches, wrong-key/
  scope/corruption rejection, zeroization и restart во всех пяти commit
  failpoints. Независимо повторены focused tests `11/11` и Release build
  `0 warnings / 0 errors`. Остались Protocol-owned sealed producer/durable
  receipt capability, runtime composition и безопасный rollover/compaction до
  bounded journal capacity. Application-specific Double/SPQR/Triple Ratchet
  KDF domains заморожены в crypto specification.
- Отдельный permissive `libcrux-ml-kem 0.0.10` spike подтвердил недостающий
  incremental ML-KEM-768 ABI без Signal/SPQR/AGPL-кода: deterministic/CSPRNG
  keygen, single-use `Encaps1` state, `Encaps2`, standard `ct1||ct2` decapsulation,
  overlap/replay/concurrency rejection и zeroization. Rust/native Release gate
  прошёл `6/6`, independent C consumer и whole-ML-KEM differential interop —
  успешно. Production graph пока не активирован; Android/Windows ARM64 assets,
  packaging allowlist и независимый security review остаются WP0 gate.
- Публичная документация больше не зависит от HonKit/Immutable.js 3.x:
  repository-owned `marked 18.0.11` renderer генерирует 20 статических страниц
  без client JavaScript, экранирует raw HTML и добавляет CSP. Полный npm graph
  сокращён с `238` до `2` packages и проходит audit с `0 vulnerabilities`.
  Новый единый docs gate проверяет UTF-8, SUMMARY/local links, private-path/key
  markers, pinned lockfile и render (`237 checks`); path-filtered GitHub job
  дополнительно запускает нормативные registry/schema/vector checkers.
- XNode получил внутренний opaque contact-resolver store с CAS/replay/fork
  latch, corruption quarantine, quota и XUR retention `400 дней + минимум
  1024 поколения`, а также two-replica application coordinator с
  outcome-unknown reconciliation. Opaque group-control service добавляет
  per-recipient streams, bounded catch-up/retention/compaction и durable fork
  latch. Совместный Contact Resolver + Group Control Release gate прошёл
  `21/21`. Отдельный opaque pre-key service реализует exact-one-time DPK2
  claim, deterministic selection, exact replay, bounded last-resort reuse,
  inventory rotation/overlap, two-replica reconciliation, fork latch и
  crash-safe retention/GC; его focused Release gate прошёл `14/14`.
  Wire/runtime activation и подписанные service receipts в эти результаты не
  входят.
- ONION-01 codec теперь отклоняет cross-network splice каждого вложенного XRF1
  до replay-state mutation; focused Release gate прошёл `23/23`. Production
  public Build/Open/Seal остаются намеренно fail-closed до закрытия verified
  path/time, durable replay lease, reply context, exact hop-count и payload
  verifier boundaries.
- PowerShell-совместимость локального DEV authority lifecycle подтверждена в
  Windows PowerShell 5.1 и PowerShell 7.6: устранены конфликт с автоматической
  `$Matches` при membership rotation и instance-only ACL API. Repeat fixture,
  private-secret ACL и compose contracts проходят; старый expired dev authority
  сохранён как clean-break backup. Новый v2 authority publication ожидает
  единый protocol package cutover и поэтому не заявлен готовым.
- Изолированная Android Debug `.e2e` APK собрана из текущего дерева, отдельно
  подписана ожидаемым upload-сертификатом и обновлена поверх только
  `network.xpoint.deep.e2e`; production package/data не изменялись. На Galaxy
  S10e/API 31 с выключенными Wi-Fi и mobile data чистый клиент сгенерировал
  ровно 24 слова, подтвердил и сохранил новый account, а cold restart без сети
  повторно открыл сохранённый account. Состояние сети восстановлено. Это
  закрывает Android physical create/restart slice, но не physical restore и не
  Android↔Windows messaging gate.
- Устранён найденный при этой сборке release-signing defect: однострочный
  PKCS#12 password source передавался одновременно как store/key password и
  второй consumer получал EOF. Play, ACT1 preparation и standalone UAT scripts
  теперь используют единственный PKCS#12 store-password source; security smoke
  gate прошёл `17/17`. Android Activity дополнительно очищает native input focus
  до `base.OnPause()`, закрывая наблюдавшийся disposed-MAUI-context crash; узкий
  lifecycle contract прошёл, повторная физическая сборка входит в следующий
  общий APK checkpoint.
- Добавлен local-only воспроизводимый NuGet cutover текущего Deep.Protocol для
  XNode без ослабления production `0.5.0-production.e75bfed` pins: package-graph
  gate прошёл `169/169`, повторный pack дал идентичные hashes. XNode также
  получил exact bounded HTTP validation boundary для XPU/XIQ/XPK/XUW/XUQ и
  matching result codecs (`5/5`). Реальный opaque dispatcher, ONION runtime
  activation и новый v2 authority всё ещё не заявлены готовыми.
- UAT secret mounts сужены до отдельных read-only файлов и минимального
  публичного CRL-каталога; приватный CA key и полный каталог секретов в runtime
  не монтируются. `survival-uat-tls-contracts` и
  `production-mailbox-uat-contracts` проходят локально.
- Protocol-owned exact DPE2 durable producer реализован: immutable prior/next
  TRS1 plan, CAS/journal/deletion/dedup/PQ commitments и attempt-bound receipt
  разрешают send/receive capability только после durable commit. Focused
  MessagingCrypto gate: `124 passed / 11 platform skips`, Release build без
  warnings/errors. Shared adapter теперь отображает все поля sealed plan в
  основной hash-chained journal и дополнительный exact-DPE2 journal одной
  SQLCipher-транзакцией; restart/lost callback, receive replay, CAS race,
  fork, cancellation, capacity и zeroization проходят focused gate `18/18`.
  Store-owned single-use preparation lease атомарно читает TRS1, CAS/protected
  commitment, journal head, exact receive replay и детерминированный retention
  commitment; caller не может подменить эти факты. Его focused Release gate
  проходит `22/22`, concurrency slice — `5/5`. Initial-session foundation
  теперь одной SQLCipher schema-v3 транзакцией сохраняет exact TRS1/replay
  journal, удаляет X25519 и ML-KEM one-time prekeys и связывает claim operation,
  full XPC1/full DPH2 replay hashes; lost callback exact-replay, cross-session
  prekey reuse/fork, crash и restart проходят focused gate `35/35`.
  Verified handshake producer/runtime composition, account/device-wide prekey
  owner и безопасный rollover ещё не входят в этот результат.
- Verified DPK2/DPH2 теперь mint-ят только внутреннюю одноразовую directional
  transcript capability: session/transcript/device direction/generation,
  responder directory head, ML-KEM ciphertext/prekey IDs и full-DPH2 replay hash
  связаны до derivation; подмена и повторное consumption отклоняются. Focused
  handshake/surface gate проходит `30/30`, Release build — без warnings/errors.
  Public XPK1/XPC1 verifier дополнительно проверяет exact request/result,
  ClaimPreKey placement, DCB1/XPS1/DPD1/DMD1/DRS1, trusted-time interval,
  DPK2 signatures и две replica identity signatures с разными failure domains.
  Его sealed receipt одноразово переходит во внутреннюю pre-key capability,
  связанную с full XPC1/DPH2 replay; соответствующий readiness blocker снят.
  Объединённый focused gate проходит `21/21`, Release build — без
  warnings/errors; raw-key/provider shortcut отсутствует.
- Identity-owned X25519 agreement authority хранит private scalar внутри
  non-exportable owner и выдаёт внутренний одноразовый lease, связанный с exact
  issued DPD1/verified active DMD1, network/account/device generations,
  purpose/operation и peer key. Replay, substitution, wrong owner и low-order
  result отклоняются; exception/Dispose paths очищают scalar, bindings и shared
  secret. Authority поддерживает verifier-issued genesis, enrolled и successor
  devices; revoked, superseded, omitted, wrong-generation и fork-latched
  состояния отклоняются. Focused gate проходит `35/35`, Release build — без
  warnings/errors. Store-side protected current-DMD1 LKG теперь хранит exact
  canonical head/active DPD1 closure в SQLCipher schema v3, выполняет CAS,
  restart-safe fork latch, durable operation burn и одноразовый handoff;
  stale/revoked/superseded/wrong-generation и concurrent replay paths проходят
  общий DeviceV1 gate `35/35`. Осталась assembly-композиция handoff с настоящим
  Protocol agreement lease: публичный подделываемый provider или production
  friend assembly не считаются решением.
- `GROUP-CLIENT-01` first-dispatch safety повторно проверяет exact DGM1,
  current DGC1/GCP1 и member/device/DPD/directory binding только для первого
  уже durable active attempt после `StartSending`; actual-send callback
  выполняется под DB-wide lease. Stale/fork/removed, completed и
  outcome-unknown цели не dispatch-ятся, ciphertext/request/ratchet hashes
  сверяются до callback. Boundary встроен в `Msg01AuthoritativeTransport`, а
  dispatch сериализован с recovery. Локальный block теперь является
  store-bound non-forgeable mutation: он атомарно очищает active/unresolved
  attempt и ciphertext, сохраняет `RevokedTarget`/terminal semantics и после
  crash/restart не допускает dispatch или reconcile. Общий focused gate
  `MessagingV1|GroupV1` проходит `98/98`, Release build — без warnings/errors.
  Production composition теперь лениво открывает отдельный account-scoped
  SQLCipher GroupV1 store только после локального Deep account, связывает его
  с exact account generation/message-store instance и передаёт safety authority
  в `Msg01AuthoritativeTransport`; wrong key/scope, missing protected key,
  reset/restart и no-account paths fail closed. Focused gates: Shared identity/
  first-dispatch `13/13`, MAUI runtime `6/6`, composer `8/8`; `MauiProgram`
  переключён на account-bound async composer. Незавершённым остаётся только
  per-device DPE2/ratchet evidence source вместо legacy transport payload.
- Реализован bounded сегментированный directory publication catalog: immutable
  generation segments, hash-bound manifest/head, fixed pending journal,
  crash recovery, persistent fork latch/quarantine и межпроцессный file lease.
  Абсолютный лимит одного артефакта — 65 535 bytes, retention — 2 048–4 096
  поколений; два экземпляра видят новую публикацию без restart. Focused gate
  проходит `21/21`, включая 2 049 последовательных commit. Production verifier
  также проверяет exact XNA1/DTS1, nonce-bound ADH1/DTT1/ADP1,
  XVP1/XNV1/XNH1/XND1/PMT2 и optional XNF1/NFP1 только против независимого
  protected LKG; NFP1 использует canonical domain-separated core hash.
  Local-cutover verifier проходит `21/21`, default production fail-closed —
  `1/1`, Release API build — без warnings/errors. Production DI и mirror HTTP
  теперь отдают byte-identical manifest/generation/XNH1 head с strong ETag;
  bounded publication envelope проходит verifier до commit, mTLS publisher,
  durable one-time challenge ledger и protected LKG имеют restart/replay/tamper
  protection. Focused HTTP/catalog/verifier gate проходит `30/30`; write surface
  configuration-disabled без актуального Protocol package/custody. Осталась
  checkpoint-authorized compaction до достижения hard cap.
- Incremental `libcrux-ml-kem` Braid spike на Windows x64 прошёл `7/7`
  adversarial/interop tests и отдельный C ABI probe, включая single-consumer,
  exact capacity и byte-identical interoperability. Android arm64 physical C
  ABI probe на Galaxy A5/API 26 также прошёл два CSPRNG round-trip,
  unload/reload, replay/double-dispose rejection и no-secret-output; `.so`
  содержит ровно 17 экспортов и только `libc/libdl` dependencies. До production
  activation остаются Windows arm64 и независимый binary/provenance review.
  Build script теперь также имеет fail-closed `windows-arm64` target и проверяет
  pinned Rust target/VS ARM64 toolchain до сборки; локальный gate ожидаемо
  остановлен из-за отсутствующего Visual Studio C++ ARM64 component и поэтому
  не считается закрытым Windows ARM64 evidence.
- Закрыта межэкземплярная SQLite pool race: admission lease регистрируется до
  schema initialization, откатывается при failed constructor, а последний
  `ClearPool` ждёт завершения instance operations. Детерминированный lifecycle
  gate проходит `4/4`, расширенный MembershipTrust/Persistence/Schema gate —
  `106/106`; pooling сохранён.

## 2026-08-31 — локальные clean-break foundations и восстановление DEV/UAT

Статус: перечисленные package-level результаты завершены локально; общий
release, physical client composition, push и production deployment не
заявляются.

- Production ML-KEM candidate переведён на vendored `mlkem-native` v2.0.0 с
  narrow Deep C ABI, воспроизводимым allowlist/manifest generator, closed
  production facade и синхронизированным dispose/finalizer barrier.
  Независимое повторное ревью не нашло P0/P1/P2; локальные native C, ABI и
  production-wrapper probes прошли. Физический Samsung S10e (`arm64`, Android
  API 31, .NET 10.0.9) дополнительно подтвердил exact asset SHA-256/ABI,
  encapsulate/decapsulate, dispose/reload и production-wrapper load/reload;
  все sanitized probe checks успешны. Windows ARM64, ACVP, release-approved
  reproducible Android asset, signed non-writable install и финальный binary
  security review остаются release activation gates.
- `NETCODEC-01` реализует canonical runtime всех девяти frozen XPoint records
  `XNA1/XVP1/XND1/XNV1/XNH1/XNP1/XNF1/NFP1/XCD1`. После corrective review
  genesis rollback отвергается до callbacks, machine parity проверяет все
  security-significant projections, а frozen JSON primitive/negative vectors
  исполняются побайтно и защищены manifest hash. Финальное независимое ревью:
  `66/66`, P0/P1/P2 отсутствуют; `runtimeActivation=false` сохранён до
  integration evidence.
- `ATTACHMENT-CODEC-01` реализует exact `DAM1` и typed DMC2 kinds 18/19:
  canonical metadata, chunk arithmetic, minimal capacity buckets, manifest
  identity и cross-network binding. Независимое ревью: `30/30`, P0/P1/P2
  отсутствуют. Blob upload/download намеренно не активирован до `BLOB-01`.
- Local Survival DEV/UAT выполнен destructive clean-break без пользовательских
  данных: старый expired mailbox authority сохранён в защищённой `.secrets`
  backup, state volumes пересозданы, новый authority выпущен. Шесть XNode,
  Registry, storage, file и push длительно отвечают healthy/`200`.
- Pinned XNode build-context export теперь материализует exact Git blob bytes,
  поэтому CRLF checkout не меняет reviewed manifest. Compose tests прошли
  `16/16`; context-export suite ранее прошёл `21/21`.
- Устранён Docker Desktop LAN defect Registry: один ASP.NET-процесс слушает
  container ports `8080/8081`, сохраняя host API `41810` и call API `41823`.
  Это не добавляет HAProxy в обычный DEV/UAT path.
- MAUI startup больше не создаёт Registry/HTTP runtime до фактического
  provisioning и не объясняет локальный account-store failure отсутствием
  сети. Offline account/onboarding остаётся независимым от Registry; повторный
  test gate запускается после завершения общей MSG/DEVICE переработки.

## 2026-08-30 — CRYPTO-01 managed ML-KEM feasibility

Статус: завершена физическая оценка Bouncy Castle; production dependency graph
не изменён.

- Создан изолированный Android arm64 Release/AOT probe с package ID
  `org.deep.protocol.pqcprobe` и exact pin
  `BouncyCastle.Cryptography` 2.7.0.
- На Galaxy S10/API 31 получены median keygen/encap/decap
  `0.213/0.238/0.280 ms`; на дополнительном Galaxy A5/API 26 —
  `1.438/1.668/2.093 ms`.
- Round-trip, exact-length, public modulus и embedded-public corruption gates
  прошли. Same-length private coefficient mutation принимается.
- Production verdict — NO-GO: upstream PQ status остаётся experimental, а
  retained seed/expanded private key не имеют deterministic disposal/
  zeroization. Provider сохранён только как KAT/interoperability oracle.
- Проверен альтернативный RustCrypto `ml-kem` 0.3.2 skeleton: narrow C ABI
  собрался, 8/8 wrapper tests и Clippy прошли, две чистые Windows x64 release
  сборки дали идентичный SHA-256. Независимый source review обнаружил
  неочищаемые provider-internal secret intermediates; unmodified crate также
  получил production NO-GO. Инвазивный fork RustCrypto/module-lattice отклонён;
  production candidate переключён на `mlkem-native` v2.0.0 с доказательной
  zeroization/constant-time базой и narrow C ABI.
- Sanitized evidence и воспроизводимый probe находятся в
  `deep-protocol/eng/Deep.PqcProviderProbe.Android`; приложение и UAT data не
  очищались и не изменялись.

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
- Заморожены закрытые wire/state contracts для current-value account directory,
  arbitrary-contact publication/resolve/pre-key/update операций, contact outbox,
  consent-based group membership, chunked group commit и revocation saga.
- CallOffer/Answer/Reconnect/End теперь доставляют call secret и answer capability
  только внутри ratcheted E2EE, используют pseudonymous answer CAS и свежий
  non-exportable DTLS certificate на каждую leg/reconnect.
- Добавлены [`architecture/release-scope.v1.json`](architecture/release-scope.v1.json)
  и schema: stable scenario/evidence IDs, единственный producer owner,
  воспроизводимые percentile profiles, absolute first-RC Android idle budget и
  boundary evidence для каждой canonical retention class. Новый дублирующий
  docs-test/CI harness для этого не создавался.
- Bridge acquisition унифицирован на трёх обязательных channel:
  RFC 9458 OHTTP Relay/Gateway, multi-origin HTTPS и signed user import;
  embedded cache остаётся только bootstrap hint.
- Устранены hash-cycle `XNV1↔PMT2` и `XNV1↔XNH1`; network/account
  beyond-horizon recovery закрыт exact `XNF1/NFP1` и `ADF1/AFP1` с отдельным
  offline-root package.
- Fresh install больше не использует validity windows как источник времени:
  текущие ADH1/XNV1 и secure interval подтверждает nonce-bound threshold-signed
  `DTT1` с bounded monotonic round trip.
- Call wire закрыт `CMD1` media suite, exact CAC/CAO/CAR/CAA и разделёнными
  `CALL-CODEC-01`/`CALL-RELAY-01`; server runtime принадлежит `xnode`, deployment
  и operational evidence — `deep-devops`.
- Для long-offline групп добавлен per-recipient opaque group-control store
  (`GSR1/GSW1/GSQ1/GSS1`), не раскрывающий XNode общий group/member list.
- Финальные implementability/security/evidence-аудиты закрыли exact XNA1
  witness/root-key policy, indexed NFP1/AFP1 membership proofs, nonce-bound
  trusted-time ceremony, peer-verifiable call allocation, closed XOQ1/XOR1
  OHTTP purpose envelopes, отдельный `CARRIER-GATEWAY-01` transport runtime и
  единственный `BRIDGE-DISTRIBUTOR-01` owner для token-mint/replay transaction.
- Все threshold-signature envelopes нормализованы через стабильные unsigned
  core references; устранён цикл публикации `XCC1/XBB1`, а `DTS1` и `XNH1`
  получили однозначные predecessor/generation/fork-latch правила.

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

- Exact MAU2, durable outbox/inbox, authenticated receipts и трёхузловая бинарная
  privacy-маршрутизация были реализованы и покрыты автоматическими тестами.
  Сделанное тогда утверждение о полностью непересекающемся fallback позднее
  отозвано: три узла не позволяют доказать два disjoint трёх-hop маршрута.
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
- Survival authority публикует независимо привязанные owner/key/epoch X25519
  records и clean-break `privacy-routes.v2.json`; authority связана с activation
  и Mr. X policy, fallback разрешён только при доказанном отказе до пересылки.
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
