# Competitor baselines and upstream source policy

Статус: **нормативный product comparison для XPoint v1**  
Проверено по первичным источникам: **2026-10-03**.

## 1. Цель сравнения

Deep не сохраняет Session wire/runtime compatibility. Первый публичный XPoint
profile должен реализовать утверждённый V1 scope и пройти собственные измеримые SLO.
Сравнение с конкретной сборкой Session — дополнительное наблюдение на одинаковой
device/network matrix; parity по функциям, скорости или надёжности пока не
доказана. Чужие security claims не переносятся: каждое свойство Deep требует
собственной реализации и evidence.

Выводы о текущем XPoint коде находятся в
[аудите 2026-10-03](ARCHITECTURE-AUDIT-2026-10-03.md), последовательность работ —
только в [едином плане Codex](IMPLEMENTATION-PLAN-V1.md). Этот документ задаёт
основания сравнения и upstream policy, не создаёт параллельный roadmap.

Локальный исходный код `C:\Work\DeepSession\source` используется только как
reference. Копирование выполняется лишь после license/provenance review и не
создаёт совместимость протоколов.

## 2. Архитектурные ориентиры Session

Ниже описаны опубликованные механизмы, а не независимое доказательство качества
текущего runtime. Наличие спецификации, исходника или объявленного будущего
протокола не означает, что свойство выпущено и проверено на устройствах.

| Свойство Session | Источник | Требование Deep v1 |
| --- | --- | --- |
| Onion requests разделяют знание source и destination между узлами; клиент отправляет запрос узлу swarm получателя | [Session routing](https://github.com/session-foundation/session-docs/blob/main/session-network/session-protocol/onion-requests-and-message-routing.md), [Desktop architecture](https://github.com/session-foundation/session-desktop/blob/dev/ARCHITECTURE.md) | Собственный exact-three XPoint wire; границы metadata из `THREAT-MODEL.md` |
| Сообщения размножаются внутри recipient swarm; при изменении состава записи передаются новым участникам | [Session swarms](https://docs.getsession.org/session-network/session-nodes/swarms) | Blinded mailbox replicas, repair и transfer; сроки только из `RETENTION-AND-RECOVERY-V1.md` |
| Persistent jobs сохраняются в БД, восстанавливаются при запуске и повторяются с backoff | [Desktop architecture, Job Runner System](https://github.com/session-foundation/session-desktop/blob/dev/ARCHITECTURE.md#10-job-runner-system) | Durable outbox и восстановление прогресса после restart; соединение не владеет сообщением |
| Зашифрованный файл хранится отдельно; сообщение несёт ссылку, ключ и digest | [Desktop architecture, Attachment Handling](https://github.com/session-foundation/session-desktop/blob/dev/ARCHITECTURE.md#13-attachment-handling) | Отдельная encrypted chunk plane; лимиты и resume gates принадлежат V1 scope |

Session documentation отмечает ограничения TCP onion requests для больших
передач и realtime. Это поддерживает выбранное Deep разделение message plane
и media plane, но не доказывает производительность Deep. Его собственный
call target — relay-only ICE и masked rotating relay access; relay видит
сетевые metadata, но не SRTP plaintext. Реализация и разрешённые claims
проверяются по `CALL-SESSION-V1.md` и `THREAT-MODEL.md`.

## 3. Deep v1 comparison scope

Это требования к Deep, а не утверждение о достигнутом равенстве с конкурентом.
Их нормативный владелец — [V1-RELEASE-SCOPE](V1-RELEASE-SCOPE.md).

| Область | Deep v1 minimum |
| --- | --- |
| Account | полностью offline create; 24-word recovery; new device restore |
| Contacts | постоянный восстанавливаемый Deep ID/QR, отдельный one-time invite; first message без существующего route/channel |
| 1:1 | text, reply, reaction, edit/delete, receipts, disappearing policy |
| Groups | 100 members, до 5 active devices/member, add/remove/roles/history policy |
| Attachments | image/file/voice and resumable encrypted transfer up to the V1 object limit in [`release-scope.v1.json`](release-scope.v1.json) |
| Calls | 1:1 audio/video, ring/accept/mute/camera/hangup/reconnect; group calls не входят в утверждённый V1 scope |
| Offline | canonical mailbox retention; safe long-offline trust reconnect/re-enrollment по `RETENTION-AND-RECOVERY-V1.md` |
| Privacy | three-hop source/destination separation; no global-observer claim |
| Blocking | rotating bridges и не менее двух независимых masked carrier families |
| Platforms | Android и Windows physical support; Apple не рекламируется без evidence |

## 4. Performance acceptance

Числовые SLO, pass predicates и воспроизводимые measurement profiles имеют
единственный нормативный источник —
[`release-scope.v1.json`](release-scope.v1.json), проверяемый
[`release-scope.v1.schema.json`](release-scope.v1.schema.json). Этот документ
описывает только comparison intent и не переопределяет значения, percentile method,
sample count, network shaping либо failure/outlier policy.

| Проверяемый Deep сценарий | Reusable scenario / evidence | Producer owner |
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

## 6. Первичные источники других систем

Эти системы являются design references, а не dependency list. Здесь разделены
опубликованный механизм и инженерный вывод для XPoint. Чужой runtime, wire,
identifier или trust root не становится частью Deep.

| Система и источник | Что подтверждено источником | Вывод для XPoint |
| --- | --- | --- |
| [SimpleX SMP](https://github.com/simplex-chat/simplexmq/blob/stable/protocol/simplex-messaging.md#acknowledge-message-delivery) | Receiver отправляет ACK с конкретным message ID после локального сохранения; затем router удаляет запись. ID предотвращает ошибочное повторное подтверждение после timeout. | Mailbox ACK следует за durable local commit; crash/retry не должен терять или повторно материализовать сообщение. |
| [SimpleX agent](https://github.com/simplex-chat/simplexmq/blob/stable/protocol/agent-protocol.md) | Асинхронный `SENT` означает приём хотя бы одним router и может прийти в следующей client session; `RCVD` отдельно сообщает приём другой стороной. Есть возобновление подписок и согласованная ротация queues. | Разделять отправку в storage, получение адресатом и восстановление соединения; не выполнять бесконечный resend из-за offline получателя. |
| [Signal offline device queues](https://support.signal.org/hc/en-us/articles/5532268300186-Disappearing-Messages-with-a-Linked-Device) и [Sesame](https://signal.org/docs/specifications/sesame/) | Устройства имеют отдельные временные очереди. Модель Sesame допускает задержку, потерю, перестановку, дублирование и частичную доставку, а также несинхронные часы. | Durable per-device progress и authenticated dedup обязательны; общий fan-out не считается атомарной сетевой транзакцией. |
| [Signal ratchet specification](https://signal.org/docs/specifications/doubleratchet/) | Описаны Double Ratchet, Sparse Post-Quantum Ratchet и их сочетание Triple Ratchet, включая ограничения state/key handling. | Сохранять выбранный Deep crypto contract и vectors; наличие внешней спецификации не доказывает корректность собственной реализации. |
| [Briar architecture](https://briarproject.org/how-it-works/) и [Briar Mailbox](https://briarproject.org/download-briar-mailbox/) | Прямая синхронизация через Tor/Wi-Fi/Bluetooth дополнена Mailbox для контактов, которые бывают онлайн в разное время. | Замена mailbox на чистый P2P не устраняет offline delivery problem; mesh остаётся отдельным post-V1 profile. |
| [Tor guards](https://spec.torproject.org/guard-spec/guard-selection/index.html), [bridges/transports](https://support.torproject.org/tor-browser/circumvention/unblocking-tor/) и [directory client](https://spec.torproject.org/dir-spec/client-operation.html) | Guards имеют собственный lifecycle; bridges/transports решают отдельную задачу доступа. Directory metadata кэшируются, обновляются заранее и скачиваются из нескольких источников с backoff. | Разделять route, carrier и control plane; переиспользовать только допускаемую XPoint текущую authority, не пересоздавать весь bootstrap на каждый send. |
| [Android Doze](https://developer.android.com/training/monitoring-device-state/doze-standby) | ОС приостанавливает network access и обычные jobs; выполнение возобновляется в разрешённые окна или при выходе из Doze. | Без push гарантировать сохранение очереди и convergence при разрешённом исполнении/resume; постоянный сокет не даёт гарантии немедленной фоновой доставки. |

## 7. Выводы для принятой архитектуры

Общий путь onion routing + store-and-forward mailbox + durable outbox не
тупиковый. Это вывод из совпадающих механизмов выше, а не подтверждение
готовности XPoint. Сначала требуется замкнуть и проверить имеющийся
message lifecycle по [единому плану](IMPLEMENTATION-PLAN-V1.md).

- **Сокет и доставка:** connection reuse уменьшает накладные расходы;
  correctness обеспечивают durable state, bounded retry и authenticated dedup.
  `NetworkReady` не означает работоспособность contact/prekey/mailbox path.
- **Stored и Delivered:** Store receipt подтверждает storage/dispatch согласно
  выбранному quorum. Приём и материализацию адресатом подтверждает отдельный
  authenticated application receipt. Read receipt — ещё одно событие. ACK,
  ratchet state и локальная история требуют согласованных crash boundaries у
  владельца [transport-neutral semantics](TRANSPORT-NEUTRAL-MESSAGING.md).
- **Три router:** exact-three при ровно трёх доступных router использует все
  три. Отказ одного прерывает маршрутизацию; mailbox replicas сохраняют данные,
  но не создают запасной маршрут. Нормативное обещание текущего профиля —
  очередь и восстановление после возврата допустимого пути, не доступность
  во время отказа. Политика остаётся в [DEPLOYMENT-PROFILES](DEPLOYMENT-PROFILES.md);
  дополнительный узел или six-node profile этим сравнением не активируется.
- **Freshness:** обновлять network/time authority заранее и отдельно от
  обычного send, пока текущая authority действительна по собственной политике.
  Tor допускает свой ограниченный режим недавно истёкшего consensus; переносить
  его в XPoint запрещено без принятого изменения threat model и контрактов.
  Сравнение не разрешает stale trust, продление lease или direct fallback.
- **Mobile resume:** foreground, разрешённый background opportunity и fully
  suspended state измеряются отдельно. Отсутствие push не должно терять
  сообщения; latency при запрете исполнения ОС не выдаётся за обычный online SLO.

V1 сохраняет один crypto suite, один application wire,
один durable outbox и один onion frame. Reality и HTTPS-stream —
плагины одного узкого carrier contract, а не две сетевые
архитектуры. Новая dependency допускается только если она
заменяет custom security-critical code и проходит license, provenance,
ABI, update-owner и cross-platform gates.
