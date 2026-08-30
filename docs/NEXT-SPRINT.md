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

- Подтвердить выбранную provider strategy: existing libsodium для
  X25519/Ed25519/XChaCha20-Poly1305, narrow Rust ABI вокруг RustCrypto `ml-kem`
  для ML-KEM-768, Deep-owned/pinned Triple Ratchet codec/state; зафиксировать
  Android arm64 и Windows x64/arm64 commit/package hashes, license,
  provenance, reproducible native builds, SBOM и two-provider vectors.
- Отдельно оценить `signalapp/libsignal`, OpenMLS и Rust FFI. AGPL/GPL код не
  включать до принятого legal/distribution decision; upstream protocol ideas
  не означают wire compatibility.
- Зафиксировать release crypto suite и resource budgets после реальных
  Android/Windows benchmarks. Classical-only/PQ-only silent fallback запрещён.
Gate: подписанный dependency decision, воспроизводимая minimal native test app
на обеих платформах, KAT/vector agreement и отсутствие unresolved license P0.

## WP1 — destructive identity/database clean break

- Заменить 13-word/Session-derived identity на `DeepRecoveryV1`: 24 слова,
  256-bit OS CSPRNG entropy, canonical BIP-39 checksum/NFKD и Deep-domain HKDF.
- Разделить account/recovery authority и independently generated device
  signing/agreement/prekey/database/push keys. Удалить Ed25519↔X25519
  conversion и загрузку recovery phrase при routine messaging.
- Ввести новые `DeepAccountId`, `DeviceId`, certificates, magic/version,
  database schema generation и secure-storage slots.
- Выполнить один destructive reset: старые account/database/wire bytes
  детерминированно отклоняются; migration, dual reader и legacy fallback нет.
- Реализовать offline create-account: до локального success ни один network,
  Registry, XPoint, DNS, certificate или bootstrap callback не вызывается.

Gate: golden/negative recovery vectors, airplane-mode create/restore,
wrong-generation rejection, key-role tests, crash-safe reset и zero Session
production dependency/runtime scan.

## WP2 — asynchronous 1:1 E2EE и multi-device

Gate каждого WP создаёт переиспользуемый black-box evidence set для своего
контракта. WP9 повторно запускает эти же scenario/evidence IDs на одной RC
commit matrix и проверяет композицию; отдельные копии harness/tests для WP9 не
создаются.

- Реализовать exact hybrid asynchronous AKE, signed prekey bundles, atomic
  one-time-key claim и transcript binding по crypto spec.
- Реализовать reviewed ratchet со skipped-key bounds, out-of-order delivery,
  replay rejection, message-key deletion, periodic PQ secret injection и
  crash-atomic state transition.
- Ввести account-authorized device list, enrollment, device fanout,
  revocation/rekey и explicit history-sharing policy. Restore создаёт новое
  устройство, а не копирует ключи старого.
- Сохранить logical message/operation ID независимо от transport attempt.
  Delivery: at-least-once retry; local materialization и receipts идемпотентны.
- Связать attachments, reactions, replies, edits, deletes и call signaling с
  exact conversation/device/ratchet context.

Gate: two-device и multi-device vectors, compromise/PCS drill, revoke while
offline, crash before/after ratchet commit/send, duplicate/out-of-order flood,
Android↔Windows interoperability и независимый crypto review P0/P1=0.

## WP3 — arbitrary contact bootstrap

- Реализовать бессрочный transport-neutral `DID1`/Deep ID, восстанавливаемый из
  recovery phrase, dual-signed `DAB1` account binding и детерминированные
  domain-separated locator/read-key для каждого transport. Истечение DCB/XIR/
  XPS означает только `TemporarilyUnavailable`, но не истечение или смену ID.
- Реализовать отдельный expiring one-time `DIA1`/QR. Один старый `05...` ID,
  display name или текущий mailbox route не является допустимым Deep ID.
- Заморозить `DCR1` resolver closure: exact DCB1, ровно один referenced DRS1 и
  все referenced DPD1, sorted/hash-closed, без unauthenticated pagination.
- Реализовать oblivious ADC1/ADH1/ADP1/ADL1 account-directory freshness и
  XPS1→XPK1/XPC1 atomic fresh DPK2 claim; public-address DCB1 не содержит
  consumable prekey bytes.
- Реализовать directory-threshold `XPA1`: XNode invite store проверяет право
  одной opaque publication, не получая DID1/account/device или DCR plaintext.
- Реализовать отдельный distributed encrypted contact-request mailbox,
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

- Заменить текущий revision-only group state на owner-sequenced signed
  membership hash-chain с predecessor hash, group epoch и exact policy.
- Один owner сериализует add/remove/promote. Concurrent multi-admin membership
  mutation и membership change во время disconnected mesh partition в v1
  запрещены.
- Message payload доставляется каждому активному device участника через его
  pairwise ratcheted session. Удалённый member/device не получает новый epoch.
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
- Реализовать persistent entry guards, distinct routers внутри exact 3-hop,
  subnet/ASN/provider constraints там, где roster позволяет, health scoring и
  bounded route churn.
- Первые три XNode дают один privacy route; fallback может переиспользовать
  узлы и называется best-effort. Capability `DisjointFallback` запрещён до
  6+ nodes и отдельного diversity/evidence gate.
- Разделить long-lived node identity и short-lived router traffic keys;
  безопасно уничтожать retired traffic keys после bounded overlap.
- Зафиксировать mailbox swarm/replication, consistency, retention, quotas,
  repair и node join/drain/exit без привязки mailbox к account ID.
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
- Исправить оставшийся PowerShell smoke failure; заменить/изолировать HonKit
  dependency с high-severity advisory и реализовать единственную
  [documentation CI policy](architecture/README.md#documentation-ci-policy).
  Устранить SQLite pool race и сузить UAT secret mounts.
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

## Definition of Done

- Все WP0–WP9 gates закрыты на одном release candidate.
- `NEXT-SPRINT.md` не содержит скрытых исключений «если calls входят» или
  неподтверждённого `exactly-once`/`unblockable`/`disjoint` claim.
- Публичные docs описывают только фактически подтверждённые функции и точные
  ограничения initial three-node profile.
- Независимые reviews имеют P0=0/P1=0; residual P2/P3 приняты отдельным
  decision record.
- Ничего не отправляется в GitHub и production без отдельного разрешения.
