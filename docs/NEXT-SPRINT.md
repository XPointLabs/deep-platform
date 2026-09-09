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

Первый production profile использует три разных XNode внутри одного маршрута.
Он не заявляет полностью disjoint fallback, независимых операторов или защиту
от общего ASN/provider failure. Direct P2P mesh и on-prem runtime выполняются
после первого релиза, но transport-neutral contracts ниже обязательны сейчас.

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

Любая не определённая этими документами cryptographic transcript, state
transition, downgrade или trust source является блокером спецификации, а не
локальным выбором разработчика.

WP0–WP9 ниже задают milestone scope. Конкретная параллельная работа выдаётся
только по agent-sized package из `IMPLEMENTATION-PLAN-V1.md`; один агент не
получает целый multi-repository WP.

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
  production `DeepClientRuntime`, затем выполнить один destructive reset:
  удалить старые Session identity/database/secure-storage slots и production
  registrations без migration, dual reader или legacy fallback.
- Закрыть airplane-mode create/restore и crash-safe reset на итоговой MAUI
  composition; до локального account success ни один network/bootstrap callback
  не должен создаваться или вызываться.
- Завершить production dependency/runtime scan: ноль Session identity,
  Ed25519↔X25519 conversion и routine recovery-phrase loading.

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
  в APK/MSIX. Не использовать один camouflage target/fingerprint для всей сети.
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

- Заменить current Shared/MAUI Session-derived path новым generation и удалить
  старые parsers, IDs, stores, endpoints, feature flags и reference runtime.
- Release UI показывает фактический transport/carrier/privacy profile и точные
  degraded/unavailable states. Локальное создание account не зависит от сети.
- Выполнить Android↔Windows physical matrix на одной signed commit matrix:
  account, restore/new device, contacts, 1:1, small groups, files/images/voice,
  push/no-push, calls, carrier blocking/rotation, restart и offline recovery.
- Проверить переписанный DNP package witness на новом hermetic closure:
  выполнить полный execution gate и обновить approved normative binding после
  фиксации commit; подтвердить успешный GitHub run path-filtered documentation
  CI на зафиксированной commit matrix.
- Выпустить reproducible APK/MSIX, dependency lock, SBOM, signatures,
  sanitized evidence, backup/restore и rollback rehearsal.
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
