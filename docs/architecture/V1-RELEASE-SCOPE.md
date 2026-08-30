# V1 public release scope and measurable gates

Статус: **нормативный product/release scope**

Актуально: 2026-08-30

## 1. Release decision

V1 — первый публичный production-релиз нового Deep-native поколения. Так как
пользователей production ещё нет, выполняется clean break:

- новый network/genesis и protocol generation;
- 24-word Deep Recovery Phrase и новые `DeepAccountId`/`DeepDeviceId`;
- новый DB schema без migrations/legacy reader;
- удаление Session wire, `SessionId`, DPE1 static sealed-CEK и compatibility
  fallback из production composition;
- отдельные device keys, ratcheted 1:1 E2EE и owner-sequenced small-group
  state с pairwise ratcheted fan-out;
- никакого импорта старых pre-production accounts/history/keys.

V1 использует только профиль `OfficialXPoint3` из
[`DEPLOYMENT-PROFILES.md`](DEPLOYMENT-PROFILES.md). P2P mesh и on-prem остаются
архитектурными requirements, но не доступны пользователю и не блокируют V1.

Этот файл является source of truth для набора функций и release gates. Старые
списки, требующие iOS или fully disjoint 3+3 fallback от трёх узлов, не
применяются к V1. Они должны быть приведены в соответствие при следующем
разрешённом documentation sweep.

Стабильные reusable scenario/evidence IDs, package/repository owners, blocking
status, measurement profiles и machine pass predicates находятся в
[`release-scope.v1.json`](release-scope.v1.json), проверяемом
[`release-scope.v1.schema.json`](release-scope.v1.schema.json). JSON является
machine contract этого документа: Markdown определяет product claim и
обязательную матрицу, а automation и evidence manifest используют только IDs и
точные predicates из JSON. Новый test/harness не создаётся только из-за нового
ID: один owner публикует evidence, `E2E-01` повторно проверяет его на RC matrix.
Schema проверяет record shape и закрытые profile/boundary references. Перед
исполнением `E2E-01` дополнительно выполняет обязательные semantic invariants из
JSON: все scenario/evidence/profile/boundary IDs уникальны, каждая ссылка
разрешается, catalog в точности покрывает перечисленные Markdown gates/retention
rows, owner совпадает с `IMPLEMENTATION-PLAN-V1.md`, а неизвестный
scenario-specific predicate key отклоняет весь catalog. Эти проверки являются
одним preflight verifier, а не отдельными prose snapshots или CI harness.

Retention limits не копируются в JSON: `retentionNormativeSource` указывает на
единственную таблицу `RETENTION-AND-RECOVERY-V1.md`; machine cases называют её
data class и boundary rule, а exact signed deadlines берутся из canonical row.

## 2. Supported platforms

| Platform | V1 status |
| --- | --- |
| Android arm64, поддерживаемые physical phones | supported, blocking evidence |
| Windows x64 и arm64 | supported, blocking evidence |
| iOS/iPadOS/macOS | compiled/unverified MAY exist, не supported и не blocking |
| Linux | не входит в V1 GUI scope |

Каждая supported platform проходит один и тот же protocol/vector suite.
Feature нельзя помечать supported только по Windows unit test или Android
compile.

## 3. Included functionality

### 3.1 Account and devices

- offline account creation без DNS/Registry/XNode;
- 24-word recovery phrase из 256-bit OS CSPRNG;
- account/recovery keys изолированы от routine messaging;
- до 5 одновременно авторизованных devices на account;
- QR/file device enrollment, видимый список devices и authenticated revoke;
- recovery создаёт новое device, а не клонирует старый private key;
- protected local DB, atomic key/ratchet/outbox state и explicit destructive
  reset только при подтверждённой несовместимости/corruption.

### 3.2 Contacts and 1:1 messaging

- бессрочный transport-neutral `DID1` (UI: Deep ID), восстанавливаемый из
  recovery phrase; его current DCB1 publication может временно быть недоступна,
  но ID не истекает и не меняется при смене transport;
- добавление произвольного contact через DID1 text/QR или one-time DIA1 QR/file;
- асинхронный первый message при offline recipient в пределах canonical
  prepublished resolver/pre-key horizon из `RETENTION-AND-RECOVERY-V1.md` и
  signed admission/quota; exhaustion или
  beyond-horizon состояние показывается явно и не включает crypto fallback;
- text, emoji, reply, reaction, edit и delete-for-everyone event;
- delivered/read receipts с возможностью отключить read receipts;
- durable retry после restart/crash;
- 1:1 PFS/PCS через approved ratchet engine;
- device-list change/revocation и automatic session repair без смены account ID;
- disappearing messages как application expiry, не как обещание secure erase у
  получателя.

### 3.3 Groups

- closed E2EE groups до **100 members** и до 5 devices/member;
- create, invite, accept, leave, remove, promote/demote;
- text/reply/reaction/edit/delete и attachment manifests;
- owner-sequenced monotonic epoch и exact predecessor commit hash;
- admins создают proposals, а только owner device выпускает commit;
- competing successor является fork error, не last-arrival-wins;
- pairwise ratcheted ciphertext для каждого current target device;
- remove/revoke атомарно исключает device из всех будущих fan-outs;
- history policy: новый member не получает историю до join epoch по умолчанию;
- group calls, public communities/channels и anonymous open groups не входят в
  V1.

Лимит 100 обеспечивает функциональный паритет с обычными private Session
groups и не закрепляет старый compile-time лимит 2048 как обещание продукта.
До 500 target-device envelopes отправляются одной bounded durable logical
batch, а не последовательными сетевыми запросами. MLS-compatible engine
остаётся будущей оптимизацией и путём масштабирования сверх 100 участников.

### 3.4 Attachments and media messages

- image, document, short video и voice note;
- максимум 25 MiB plaintext на объект в V1;
- client-side chunk encryption, resumable upload/download и integrity before
  plaintext exposure;
- masked access к blob plane; блокировка прямого file hostname не ломает flow;
- preview/filename/MIME находятся внутри E2EE manifest;
- avatars используют те же confidentiality/integrity principles, но имеют
  отдельную retention/cache policy.

### 3.5 Calls

- one-to-one voice и video WebRTC calls;
- offer/answer/ICE/end/reconnect signals идут как E2EE application events через
  XPoint message plane;
- `RelayOnly` — единственный official V1 `CallPrivacyProfile`: relay-only без
  peer candidates;
- `DirectPeer`/direct ICE зарезервирован для будущей отдельной opt-in policy с
  предупреждением о раскрытии peer IP и не входит в V1;
- `NetworkCondition=Restricted` сохраняет relay privacy через
  `MediaCarrier=MaskedTcpCapsule`, когда UDP
  заблокирован;
- DTLS-SRTP media, short-lived TURN credentials;
- signed rotating relay catalog с UDP/443 и TCP/TLS 443 paths;
- group calls, call recording и PSTN gateways не входят в V1.

### 3.6 Push and offline

- encrypted opaque push hint без sender/conversation/message metadata;
- messenger корректно работает без FCM/WNS через resume/polling;
- XPoint message/disappearing retention следует только canonical mailbox row из
  `RETENTION-AND-RECOVERY-V1.md` и показывает effective value пользователю;
- outbox retry payload/key и metadata-only audit tombstone имеют разные
  deadlines из [`RETENTION-AND-RECOVERY-V1.md`](RETENTION-AND-RECOVERY-V1.md):
  retryUntil следует canonical outbox-payload row и может быть уменьшен
  application/user policy, а tombstone не продлевает хранение payload/key;
- trust/control-plane history поддерживает безопасное long-offline возвращение
  по exact fixtures machine contract;
- long-offline возвращение сохраняет account, contacts и локальную историю,
  но не обещает получение server messages старше effective retention;
- за пределами trust horizon выполняется authenticated re-enrollment без
  потери account identity; новое device session state создаётся заново.

## 4. Explicitly excluded from V1

- direct P2P, Internet P2P и BLE/Wi-Fi store-carry-forward mesh;
- user-managed/on-prem deployment UI/runtime;
- fully disjoint primary/fallback route;
- public communities/channels/bots;
- group calls;
- traffic-analysis/global-observer resistance;
- гарантированная доставка при бессрочном offline;
- абсолютная unblockability или «невозможно обнаружить»;
- iOS/macOS production support;
- legacy account/history import;
- silent transport/profile downgrade.

Исключённые возможности MUST быть скрыты или показывать точное `unavailable`.
Stub/mock/direct fallback в release binary запрещён.

## 5. Security baseline

Release блокируют:

1. independent device keys и отсутствие recovery phrase/root в routine send,
   receive, push, call и mailbox code path;
2. approved asynchronous AKE + ratchet с PFS/PCS, out-of-order bounds,
   one-time-prekey atomicity и secure key deletion;
3. `DeepSmallGroupV1` owner/epoch/predecessor/fork/remove vectors и bounded
   pairwise device fan-out;
4. contact/device verification, device-list continuity и revocation;
5. canonical closed parsers, domain separation, hostile-size rejection и
   downgrade protection;
6. transport-independent semantic dedup and durable outbox;
7. independent crypto/privacy/security review без открытых critical/high;
8. SBOM, pinned native sources, reproducible builds и license approval для
   borrowed GitHub code.

Post-quantum minimum suite следует утверждённому crypto profile. Если
production-quality cross-platform ML-KEM/Triple-Ratchet provider не прошёл
Android/Windows audit и vectors, релиз не может тихо объявить PQ protection.
Изменение suite floor — отдельное signed security decision, а не runtime
fallback.

## 6. XPoint topology and anti-censorship baseline

V1 развёртывается на трёх routing nodes и двух durable mailbox replicas согласно
signed placement. Требования:

- каждый message/control operation использует exact-three onion path;
- fallback MAY пересекаться с primary; disjointness не заявляется;
- persistent guard и client-verified signed roster;
- route и blinded two-replica mailbox placement выбираются client-side из
  roster; Registry не выдаёт per-user route;
- staking/admission и roster publication находятся вне hot message path;
- один canonical roster epoch доступен минимум через три mirrors/carriers и
  проверяется относительно protected LKG;
- `reality-xhttp-v1` плюс независимо реализованный `https-stream-v1`;
- `masque-h3-v1` для preferred call media и обязательный
  `masked-tcp-capsule-v1` при блокировке UDP;
- embedded seeds — cache, а не полный bridge pool;
- три обязательных bridge-acquisition channels: `in-app-oblivious`,
  `multi-origin-https` и `user-import`; embedded signed cache является
  дополнительным bootstrap hint, а не заменой channel;
- direct public MAU2/file/signaling fallback отсутствует;
- attachments используют masked carrier;
- call signaling использует message plane; call relay имеет rotating catalog.

Цель — быть не хуже Session по message functionality и online latency при
добавленной защите от распространённых блокировок. Session используется как
performance/function reference, а не wire dependency. Session применяет
трёх-hop onion paths, swarms и persistent guards, но call media у него также не
onion-routed:
[current Session architecture](https://github.com/session-foundation/session-desktop/blob/dev/ARCHITECTURE.md).

## 7. Measurable release gates

Каждый gate ниже ссылается на stable `scenarioId`/`evidenceId` из machine
contract. Там же закреплены один producer owner, `E2E-01` release verifier,
обязательные platforms, blocking status и pass predicate. WP/milestone может
запустить тот же scenario раньше, но WP9 повторяет тот же ID на одной
production-bound signed commit matrix и не создаёт второй harness.

Latency/throughput gates используют named measurement profile из machine
contract. Profile фиксирует targets, independent runs, warmups, sample count,
monotonic clock, nearest-rank percentile, network shaping, failure-as-infinity
и запрет post-hoc outlier removal. Sanitized raw samples, harness failures,
network profile, timestamps и calculation report входят в exact evidence ID.

### 7.1 Functional matrix

Blocking scenario: `REL-FUNCTIONAL-MATRIX-V1` / evidence
`EVD-FUNCTIONAL-MATRIX-V1`, owner `E2E-01` (`deep-tests-e2e`).

Обязательные пары:

- Android A ↔ Android B;
- Android A ↔ Windows x64;
- Android B ↔ Windows arm64.

Для каждой пары:

- clean offline account creation;
- arbitrary contact bootstrap в обе стороны;
- 1:1 text/reply/reaction/edit/delete;
- 25 MiB attachment interrupted at 25%, resumed after restart;
- delivered/read receipt and duplicate suppression;
- sender crash before dispatch, after possible dispatch, after durable receipt;
- recipient crash before/after local materialization and ACK;
- device enrollment/revoke and subsequent undecryptability for revoked device;
- 7/14/30-day retention boundaries with controlled clock;
- app cold restart at every durable state.

Groups проходят 3- и 100-member automated load с максимум пятью devices/member
по blocking `REL-GROUP-100-V1`, owner `GROUP-CLIENT-01`,
а physical gate — минимум Android A + Android B + Windows. Проверяются
concurrent admin proposals, single-owner sequencing, fork rejection,
stale-successor recovery, remove/revoke, offline member catch-up, duplicate и
cold restart. Отдельный `REL-GROUP-200-BASELINE-V1`, owner
`GROUP-CLIENT-01`, является non-blocking benchmark для будущего MLS profile и
не расширяет V1 support.

### 7.2 Correctness semantics

Blocking scenario `REL-OUTBOX-FAULTS-V1`, owner `MSG-01`, хранит version
генератора, полный seed set и SQLite/in-memory traces; `E2E-01` проверяет
machine result на RC.

- все accepted semantic events в зафиксированном deterministic corpus
  materialize exactly once locally under injected duplicate/reorder and allowed
  cross-adapter replay;
- changed authenticated bytes под тем же semantic ID дают fork error;
- сеть описывается как at-least-once, не exactly-once;
- после `OutcomeUnknown` новый plaintext/message ID не создаётся;
- ни один profile isolation test не вызывает запрещённый adapter;
- no-loss outbox recovery проходит 10,000 deterministic crash/fault cases.

### 7.3 Performance

Blocking performance IDs and their sole numeric predicates are:

| Scenario ID | Metric family | Measurement profile |
| --- | --- | --- |
| `PERF-TEXT-WARM-V1` | warm 1:1 materialization | `LATENCY-LAB-V1` |
| `PERF-START-COLD-V1` | cold app to usable inbox | `LATENCY-LAB-V1` |
| `PERF-BOOTSTRAP-FRESH-V1` | fresh signed bootstrap to poll | `LATENCY-LAB-V1` |
| `REL-GROUP-100-V1` | first remote and complete 500-device fanout | `GROUP-LAB-V1` |
| `PERF-ATTACHMENT-10M-V1` | masked/direct HTTPS goodput ratio | `ATTACHMENT-LAB-V1` |
| `PERF-CALL-SETUP-V1` | ring and connected media | `MEDIA-LAB-V1` |
| `PERF-CALL-MEDIA-V1` | relay RTT, recovery loss and UDP-blocked TCP recovery | `MEDIA-LAB-V1` |
| `PERF-ANDROID-IDLE-V1` | absolute 15-minute screen-off idle budgets | `ANDROID-IDLE-V1` |

`PERF-ANDROID-IDLE-V1` is the first-RC baseline: every run must satisfy the
absolute CPU, wakelock, wakeup, network-byte and battery budgets in the machine
contract. A moving “previous RC” baseline cannot pass or relax this gate.

### 7.4 Censorship scenarios

Owner `BRIDGE-01` produces, and `E2E-01` verifies, these reusable blocking
evidence groups:

- `CENS-ACQ-OHTTP-V1`, `CENS-ACQ-MULTI-ORIGIN-V1` и
  `CENS-ACQ-USER-IMPORT-V1` доказывают обязательные `in-app-oblivious`,
  `multi-origin-https` и `user-import` channels отдельно;
- `CENS-ACQ-NMINUS1-V1` отключает по очереди каждый channel и доказывает, что
  оставшиеся paths не схлопываются в один обязательный origin/credential;
- `CENS-BLOCK-MATRIX-V1` выполняет external-network blocking matrix ниже.

External-network blocking cases:

1. direct MAU2/file/Registry signaling endpoints blocked;
2. public DNS poisoned/blocked;
3. SNI/domain block;
4. все embedded seed/bridge IP заблокированы;
5. active probe с неверными credentials;
6. UDP полностью заблокирован;
7. текущий Reality carrier недоступен;
8. bridge descriptor rotated/revoked во время queued outbox;
9. APK распакован, все найденные адреса считаются известными censor.

Gate: fresh install может создать account offline; каждый из трёх channels
принимает valid signed bootstrap и отклоняет tamper/wrong-network/rollback.
Каждый N-1 case оставляет минимум один разрешённый path для contact/message/file
без direct fallback. При блокировке Reality автоматически выбирается
разрешённый независимый masked TCP/443 carrier. При UDP block call использует
TCP/TLS relay; смена path видна в evidence и не раскрывает peer IP в relay-only
mode.

Это не доказательство работы против любого национального firewall. Release
claim перечисляет только пройденные сценарии и дату/сети тестирования.

### 7.5 Offline, rotation and recovery

Blocking scenario `OFFLINE-RECOVERY-MATRIX-V1`, owner `CONTACT-CLIENT-01`,
агрегирует class-specific retention evidence IDs из canonical retention table.

- fresh APK с embedded floor `N` проверяет и принимает signed `N+K` без
  rollback/fork/wrong-network;
- machine-contract long-offline fixtures сохраняют account, contacts,
  local history и non-expired outbox;
- phrase-only restore воспроизводит byte-identical DID1 и после новой
  DAB1/DCB1 publication тот же адрес снова разрешается;
- predecessor/history запрос криптографически связан с protected LKG;
- route/carrier/device revocation fail closed;
- beyond-horizon re-enrollment создаёт новое device и не сбрасывает account;
- messages older than effective mailbox retention не обещаются и отображаются только как
  documented retention gap;
- rotation во время attachment/call/message не меняет semantic ID и либо
  resume, либо даёт точное terminal state.

### 7.6 Calls

`CALL-PHYSICAL-MATRIX-V1`, owner `CALL-MEDIA-01`, даёт physical evidence для
Android↔Windows и Android↔Android:

- ringing/accept/reject/missed-call stale suppression;
- двусторонние audio/video, mute/camera toggle/hangup;
- selected ICE pair и фактический direct/relay/masked-relay path без secrets;
- relay-only не публикует peer host candidates другой стороне;
- forced TURN, UDP block → TCP/TLS relay, relay rotation and reconnect;
- signaling duplicate/replay/stale events не поднимают повторный звонок;
- TURN/relay не получает peer DTLS private keys или exported SRTP keys.

Отдельный blocking `CALL-RELAY-DECRYPT-NEGATIVE-V1`, owner `CALL-RELAY-01`,
инвентаризирует все доступные relay process/key inputs, выполняет adversarial
decrypt attempt, связывает peer DTLS fingerprints с authenticated signaling и
подтверждает отсутствие authenticated media plaintext в relay logs/artifacts.
Один packet capture или selected ICE pair не удовлетворяет этот scenario.

### 7.7 Privacy and operational evidence

Blocking scenario `PRIVACY-OPERATIONS-EVIDENCE-V1`, owner `E2E-01`, объединяет
следующие artifacts; release consumer — reviewed `deep-devops` gate.

- packet capture подтверждает отсутствие direct MAU2/file/signaling bypass;
- logs/evidence не содержат plaintext, Deep IDs, contact/route bindings,
  capabilities, keys, tokens или recovery material;
- topology/carrier artifacts подписаны, versioned, expiring, revocable и
  atomic-LKG persisted;
- byte-identical roster epoch получен через три mirrors, а forked mirror
  обнаружен до route/storage mutation;
- restore rehearsal сохраняет XNode identity, mailbox state и user flow;
- DNS/TLS renewal/expiry alerts и rollback rehearsal пройдены;
- три nodes находятся минимум на трёх physical hosts; общая operator/ASN
  зависимость явно задокументирована и не выдаётся за diversity;
- dependency/security scan не содержит незакрытых critical/high findings;
- независимые lead-developer и security reviews завершены после freeze.

## 8. Release claim language

Разрешённая формулировка после прохождения gates:

> Deep V1 передаёт сообщения, групповые события, вложения и signaling звонков
> через проверенный трёхузловой XPoint route и маскируемые carriers. E2EE
> защищает содержимое от узлов и сервисов; один routing node не видит
> одновременно client endpoint и mailbox destination. Проверены перечисленные
> сценарии DNS/SNI/IP/UDP blocking.

Запрещённые формулировки:

- «невозможно заблокировать/обнаружить»;
- «полная анонимность»;
- «защита от глобального наблюдателя»;
- «fully decentralized» при трёх Deep-operated nodes;
- «fully disjoint fallback» для V1;
- «exactly-once network delivery»;
- «post-quantum secure», пока exact provider/suite не прошли release gate;
- «P2P/on-prem supported» до отдельных profile releases.

## 9. Development order

Порядок минимизирует повторную работу и позволяет агентам работать параллельно:

1. freeze canonical DID1/DAB1, IDs/events/contact bundle and hostile vectors;
2. выбрать/pin 1:1 crypto provider после license/platform spike;
3. реализовать account/device/prekey/revocation stores;
4. реализовать ratchet + `DeepSmallGroupV1` и crypto interoperability harness;
5. заменить текущий outbox на transport-neutral logical state machine;
6. реализовать XPoint adapter поверх existing MAU2/privacy route;
7. связать Reality и второй masked carrier, затем bridge distribution;
8. реализовать contact bootstrap/route-update rendezvous;
9. перевести attachments и call signaling на общие planes;
10. добавить media relay catalog и push hints;
11. выполнить Docker, fault, censorship и physical matrices;
12. независимые lead/security reviews, fix freeze, final rerun;
13. после V1 — OpenMLS/native ABI spike и scalable group profile свыше 100 участников.

P2P/on-prem adapters начинаются только после V1 production release, но
compile-time architecture tests из transport-neutral specification входят в V1
и не позволяют снова связать application layer с official infrastructure.

## 10. Residual risks accepted for V1

- только три routing nodes: нет route-level disjoint availability;
- initial operators могут принадлежать Deep: сеть decentralizable, но ещё не
  operator-decentralized;
- bridge distribution может быть заблокирован целевым censor и требует
  постоянной operational rotation;
- timing/volume correlation и global observer вне гарантии;
- relay-only calls раскрывают metadata relay operator и дороже по bandwidth;
- bounded retention означает потерю server-side сообщений при более долгом
  offline;
- native crypto provider увеличивает supply-chain и memory-safety integration
  risk, поэтому pinned build, fuzzing и independent audit обязательны;
- V1 group fanout ограничен 100 members/500 active devices и требует больше
  sender CPU/network metadata, чем будущий scalable MLS successor.
