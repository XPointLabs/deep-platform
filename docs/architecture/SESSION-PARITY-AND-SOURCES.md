# Session parity baseline and upstream source policy

Статус: **нормативный product comparison для XPoint v1**  
Проверено: 30 августа 2026 года.

## 1. Цель сравнения

Deep не сохраняет Session wire/runtime compatibility, но первый публичный
XPoint profile не должен быть функционально или заметно по скорости хуже
актуального Session для обычной личной переписки. Сравнение не переносит
чужие security claims: каждое свойство Deep подтверждается собственной
реализацией и evidence.

Локальный исходный код `C:\Work\DeepSession\source` используется только как
reference. Копирование выполняется лишь после license/provenance review и не
создаёт совместимость протоколов.

## 2. Подтверждённые свойства Session

| Свойство Session | Источник | Требование Deep v1 |
| --- | --- | --- |
| Три onion-hop для network requests | [Session routing](https://docs.getsession.org/session-network/session-protocol/onion-requests-and-message-routing) | Ровно три разных RouterId/traffic keys; собственный XPoint wire |
| Recipient swarms и offline storage | тот же источник и [Session Desktop architecture](https://github.com/session-foundation/session-desktop/blob/dev/ARCHITECTURE.md) | Blinded mailbox swarms, replication/repair и 30-day retention |
| Persistent entry guards и subnet isolation | [Session Desktop architecture](https://github.com/session-foundation/session-desktop/blob/dev/ARCHITECTURE.md) | Persistent guards; ASN/provider constraints при достаточном roster |
| Private closed groups до 100 участников | [Session FAQ](https://getsession.org/faq) | Deep v1: 100 members/500 active devices, owner-sequenced batched fanout |
| Text, images, files и voice messages | [Session product](https://getsession.org/) | Text/reply/reaction/edit/delete, image/file/voice, encrypted resumable chunks до 25 MiB |
| One-to-one voice/video calls; media не onion-routed | [Session Desktop architecture](https://github.com/session-foundation/session-desktop/blob/dev/ARCHITECTURE.md) | 1:1 audio/video, E2EE signaling over XPoint; relay-only low-latency media |
| Call signaling идёт как обычные messages | тот же источник | Typed ratcheted call events через общий outbox/message plane |
| Текущий Session V2 направлен на PFS, PQ и device management | [Session Protocol V2](https://getsession.org/session-protocol-v2) | Deep не выпускает static-LTK generation: hybrid AKE + Triple Ratchet и device keys обязательны сразу |

Session documentation отмечает ограничения TCP onion requests для больших
передач и realtime. Deep поэтому не отправляет RTP через mailbox onion path:
это не повысило бы E2EE, но ухудшило latency и bandwidth. Privacy обеспечивается
relay-only ICE и masked rotating relay access; relay видит metadata, но не SRTP
plaintext.

## 3. Deep v1 parity matrix

| Область | Deep v1 minimum |
| --- | --- |
| Account | полностью offline create; 24-word recovery; new device restore |
| Contacts | постоянный восстанавливаемый Deep ID/QR, отдельный one-time invite; first message без существующего route/channel |
| 1:1 | text, reply, reaction, edit/delete, receipts, disappearing policy |
| Groups | 100 members, до 5 active devices/member, add/remove/roles/history policy |
| Attachments | image/file/voice and resumable encrypted transfer up to the V1 object limit in [`release-scope.v1.json`](release-scope.v1.json) |
| Calls | 1:1 audio/video, ring/accept/mute/camera/hangup/reconnect; group calls не требуются для parity, поскольку Session их пока не поддерживает |
| Offline | canonical mailbox retention; safe long-offline trust reconnect/re-enrollment по `RETENTION-AND-RECOVERY-V1.md` |
| Privacy | three-hop source/destination separation; no global-observer claim |
| Blocking | rotating bridges и не менее двух независимых masked carrier families |
| Platforms | Android и Windows physical support; Apple не рекламируется без evidence |

## 4. Performance acceptance

Числовые SLO, pass predicates и воспроизводимые measurement profiles имеют
единственный нормативный источник —
[`release-scope.v1.json`](release-scope.v1.json), проверяемый
[`release-scope.v1.schema.json`](release-scope.v1.schema.json). Этот документ
описывает только parity intent и не переопределяет значения, percentile method,
sample count, network shaping либо failure/outlier policy.

| Parity claim | Reusable scenario / evidence | Producer owner |
| --- | --- | --- |
| Warm 1:1 text materialization | `PERF-TEXT-WARM-V1` / `EVD-PERF-TEXT-WARM-V1` | `E2E-01` (`deep-tests-e2e`) |
| Cold app to usable inbox | `PERF-START-COLD-V1` / `EVD-PERF-START-COLD-V1` | `COMPOSE-01` (`deep-client-maui`) |
| Fresh signed bootstrap to first poll | `PERF-BOOTSTRAP-FRESH-V1` / `EVD-PERF-BOOTSTRAP-FRESH-V1` | `BRIDGE-01` (`deep-devops`) |
| Supported group fan-out | `REL-GROUP-100-V1` / `EVD-GROUP-100-V1` | `GROUP-CLIENT-01` (`deep-client-shared`) |
| Masked attachment transfer | `PERF-ATTACHMENT-10M-V1` / `EVD-PERF-ATTACHMENT-10M-V1` | `BLOB-01` (`deep-client-shared`) |
| Call ringing and connected media | `PERF-CALL-SETUP-V1` / `EVD-PERF-CALL-SETUP-V1` | `CALL-MEDIA-01` (`deep-client-maui`) |
| Relay media and restricted-network recovery | `PERF-CALL-MEDIA-V1` / `EVD-PERF-CALL-MEDIA-V1` | `CALL-MEDIA-01` (`deep-client-maui`) |

Перед GA `E2E-01` (`deep-tests-e2e`) публикует observational
`SESSION-COMPARATIVE-SMOKE-V1` / `EVD-SESSION-COMPARATIVE-SMOKE-V1` на той же
RC/device/access-network matrix. Он использует `SESSION-COMPARISON-V1`, является
release-decision input, а не криптографическим oracle, и никогда не ослабляет
blocking absolute gates. Exact comparison trigger и обязательная provenance
Session build находятся только в machine contract.

## 5. Разрешённое заимствование

Разрешено переиспользовать после review:

- архитектурные идеи: guards, swarms, durable jobs, call signaling events;
- стандартные алгоритмы и официальные specs;
- maintained libraries с подходящей лицензией и reproducible build.

Запрещено без отдельного decision:

- копировать Session IDs, protobuf/wire, network trust или compatibility code;
- считать GPL/AGPL/MIT названием достаточным legal review;
- привязывать Deep protocol к unstable private API стороннего клиента;
- заявлять свойства Session как доказанные свойства XPoint.

Кандидаты для spike, не автоматический выбор:

- [signalapp/libsignal](https://github.com/signalapp/libsignal) — актуальный
  Rust implementation, но upstream не обещает external API stability и
  использует AGPL-3.0; нужны legal, ABI и distribution решения;
- [OpenMLS](https://github.com/openmls/openmls) — MIT-licensed MLS candidate
  для будущего scalable group profile;
- [SimpleX protocols](https://simplex.chat/docs/protocol/simplex-chat.html) —
  reference для per-contact queues, route replacement и call event model;
- [Tor Pluggable Transports](https://spec.torproject.org/pt-spec/) — reference
  для carrier separation и bridge distribution, не XPoint wire dependency.
