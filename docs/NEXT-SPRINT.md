# Текущая очередь Deep / XPoint

Обновлено: **2026-10-04**. Branch baseline: `release-candidate/prod-20260909`;
frozen inputs: `survival-program/releases/v3.0.0`.

Единственный план: [IMPLEMENTATION-PLAN-V1](architecture/IMPLEMENTATION-PLAN-V1.md).
Основание: [аудит](architecture/ARCHITECTURE-AUDIT-2026-10-03.md) и
[DR-0082](survival-program/decisions/DR-0082-integration-first-delivery-baseline.md).
Здесь хранится статус, а не повторение спецификации или ещё один roadmap.

## Исходное состояние

[Stabilization handoff](RELEASE-STABILIZATION-HANDOFF-2026-10-03.md) фиксирует
точные HEAD и zero-error compilation основных solutions/Debug приложений.
Полные тесты: node 19 failures; Registry 31 failures/6 skips. Это предыдущий
отчёт, не новый полный прогон. Аудит воспроизвёл ограниченные выборки на ранее
собранных Release binaries и нашёл как stale fixtures, так и реальные разрывы
production composition. Все remaining failures подлежат S00, а не удалению.

Физический contact/consent → двусторонний text → receipt не квалифицирован.
Own-publication Android, compilation и local crypto/SQL integration этого не
доказывают. Историческая deployed matrix не равна текущей source matrix.
Production среда в этом аудите не проверялась и не изменялась.

## Очередь

| Этап | Текущий статус | Что закрывает |
| --- | --- | --- |
| S00 | **В работе: последний Shared full 547/547; свежий Protocol full 2079 pass / 1 fail / 12 skips; свежий XNode full 1117 pass / 1 B8 fail / 0 skips, current mailbox/MGR 198/198, owned one-time object 24/24; последний Protocol registry/parity 11/11; ingress 17/17, native replacement 6/6, claim connected 49/49 и шесть concurrent repeats проходят; Registry 331 pass / 0 fail + 6 Linux signer pass** | [Latest Shared gate](../deep-client-shared/docs/testing/s03-mailbox-writer-2026-10-04.md), [latest Node/Protocol full gates](../xnode/docs/testing/s00-one-time-object-2026-10-04.md), [Protocol parity](../deep-protocol/docs/testing/s03-descriptor-keys-2026-10-04.md), [ONION](../deep-protocol/docs/testing/s00-onion-baseline-2026-10-03.md), [contact](../deep-protocol/docs/testing/s00-contact-baseline-2026-10-03.md), [Node baseline](../xnode/docs/testing/s00-node-baseline-2026-10-03.md), [native replacement](../xnode/docs/testing/s00-native-replacement-2026-10-03.md), [ingress binding](../xnode/docs/testing/s00-mailbox-ingress-binding-2026-10-03.md), [Registry classification](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md); assertions сохранены; package graph и invite/XPP открыты |
| S01 | **В работе: DR-0083/0084/0086/0087; native operation format/host-only recovery реализованы; current mailbox/MGR 198/198, 13 новых receiver custody cases проходят; предыдущий focused custody 30/30; Protocol revocation/floor 49/49, settlement boundary/registry 26/26; native MGR custody 29/29; Shared exact unknown retry при 512 occupied slots проходит, последний full 547/547; shipping consumers не активированы** | [Revocation contract](survival-program/decisions/DR-0083-current-mailbox-grant-revocation.md), [client semantic contract](survival-program/decisions/DR-0084-owned-delivery-settlement-and-retirement.md), [operation custody](../xnode/docs/testing/s03-operation-custody-2026-10-04.md), [receiver custody](../xnode/docs/testing/s03-host-custody-2026-10-04.md), [writer checkpoint](../xnode/docs/testing/s03-mailbox-writer-2026-10-04.md), [recovery checkpoint](../xnode/docs/testing/s03-store-recovery-2026-10-04.md), [Protocol evidence](../deep-protocol/docs/testing/s01-mailbox-revocation-2026-10-03.md), [native evidence](../xnode/docs/testing/s01-mailbox-revocation-native-2026-10-03.md), [settlement boundaries](../deep-client-shared/docs/testing/s01-settlement-boundaries-2026-10-03.md); whole-host startup/health/DI, client retirement formats/API, compaction/renewal, object horizon и application receipt contracts открыты |
| S02 | **Native admission соединён с internal Store producer/peer и Retrieve/ACK обеих реплик; matching writer, separate descriptor-key candidate и signing custody до replay проверены, активация заблокирована S01** | [Admission checkpoint](../xnode/docs/testing/s02-current-mailbox-admission-2026-10-03.md), [receiver custody](../xnode/docs/testing/s03-host-custody-2026-10-04.md), [writer checkpoint](../xnode/docs/testing/s03-mailbox-writer-2026-10-04.md), [descriptor keys](../xnode/docs/testing/s03-descriptor-keys-2026-10-04.md), [current Retrieve](../xnode/docs/testing/s03-current-retrieve-2026-10-04.md), [current ACK](../xnode/docs/testing/s03-current-ack-2026-10-04.md): оба protected role floor, current source/time, holder/body и реальные replay/outcome/mutation/blob owners. Store только у ranked writer; Retrieve/ACK обеих реплик сохранены. Same-owner scope исключает повторный захват native floor locks. Program/DI и retained-route порядок остаются открыты |
| S03 | **Internal Store/current peer HTTP/quorum, Retrieve/ACK, authenticated prefix/writer, descriptor keys и independent operation custody проверены; Program/DI заблокирован S02** | [Receiver custody](../xnode/docs/testing/s03-host-custody-2026-10-04.md), [operation custody](../xnode/docs/testing/s03-operation-custody-2026-10-04.md), [writer checkpoint](../xnode/docs/testing/s03-mailbox-writer-2026-10-04.md), [matching client](../deep-client-shared/docs/testing/s03-mailbox-writer-2026-10-04.md), [Store-prefix checkpoint](../xnode/docs/testing/s03-store-prefix-2026-10-04.md), [descriptor keys](../xnode/docs/testing/s03-descriptor-keys-2026-10-04.md), [current ACK](../xnode/docs/testing/s03-current-ack-2026-10-04.md): missing/rollback operations до первой mutation не допускают allocation; Store/Retrieve/ACK и peer требуют protected operation custody до replay и после callbacks, включая cached receipt. Authenticated pending replacement восстанавливает только exact PRQ2/nonce, без remint. Schema 6 и bounded independent root, не второй журнал. Current connected 198/198; свежие full/build и final-source real-Xray smoke/3-node результаты — в S00 checkpoint. Whole-host startup/health/DI, deployed provisioning, retained-route/retirement/object horizon открыты; не physical E2E |
| S04 | Заблокирован S01 | Expiry/renewal, unknown outcome, bounded journals |
| S05 | Частичные producer/lifecycle компоненты; gate открыт | Current issuer→node и автоматические signed renewal/time/catch-up |
| S06 | Не пройден | Два настоящих клиента через real selected-entry/replica endpoints |
| S07 | Отсутствуют полные runtime paths | Scheduler, offline history/queue, AppAck/read; затем полный 1:1 event/UI scope |
| S08 | **Release composition отсутствует** | Shipping graph без diagnostic-only flag и physical text/receipts |
| S09 | Не квалифицирован | Sustained delivery, restart/rotation/offline recovery на той же identity |
| S10 | Local attachment custody есть; remote flow не закрыт | Remote files/images/video/voice/avatar, integrity/resume/UI |
| S11 | Кодеки/старые harness не закрывают current DID2 app path | Multi-device/history и governed groups |
| S12 | Отдельные компоненты; полный scope не квалифицирован | Carriers/bootstrap/push и relay-only calls |
| S13 | Заблокирован release requirements | Одна artifact matrix, полный evidence catalog и reviews |

Текущий S00/B8 owned one-time object batch: Protocol `010b94a16d65e46af91a88ba9787ee92b39e513b`,
Shared `485c381280ca9b59d27eba12be43a7eb7d5f782f`,
XNode `bf24f288d3a37f5e9f9568f54e5bfd0bf3958b08`; consumer проверен через
source-cutover, не через опубликованный package или установленный client.
Protocol/XNode полные gates повторены; package graph и B8 всё ещё failing.
Shared/Registry в этом batch не менялись; их полные gates не повторялись.
S02/S03 receiver-custody checkpoint сохраняет свою исходную матрицу/evidence;
новый batch не активирует Program/DI, публикацию one-time или physical E2E.

## Блокеры, которые нельзя потерять

- **B1:** Protocol/Shared перешли к DR-0081, node Program всё ещё подключает
  retired mailbox authority; current native admission/peer consumers не подключены
  к активным Store/Retrieve/ACK и peer endpoints.
- **B2:** protected-time/revocation/holder/selected-exit admission и peer proof
  mutation/quorum не замкнуты; node ID и receipt key в старом adapter слиты.
  Internal Store имеет exact durable producer; matching Shared path и native
  admission теперь допускают Store только через authenticated PMS2 writer.
  Это связывает текущий cursor owner с подписанным выбором, но не квалифицирует
  startup/retained-route порядок или shipping activation.
  [Descriptor-key integration](../xnode/docs/testing/s03-descriptor-keys-2026-10-04.md)
  теперь проходит с genuine independent node IDs/keys. Исправлен лишний equality
  запрет operational genesis author, отсутствующий в frozen XND1 contract;
  signer generation/signature и successor immutability сохранены. Proof с ключом-ID
  отвергается до peer reservation; чужие подписи не создают quorum. Это local consumer
  evidence, не переиздание production identity или qualification старого adapter.
  [Scoped recovery fence](../xnode/docs/testing/s03-store-recovery-2026-10-04.md)
  сверяет saved exact intents с каждым retained native Store в authenticated
  mailbox scope до нового client replay; потеря записи или откат журнала не позволяют
  новой операции/grant переиспользовать cursor. Новый
  [operation custody owner](../xnode/docs/testing/s03-operation-custody-2026-10-04.md)
  по [DR-0087](survival-program/decisions/DR-0087-current-mailbox-operation-custody.md)
  теперь закрывает потерю/rollback документа до первой native mutation: host-only
  startup удерживает обе role leases без client grant; readers не enroll.
  Коррупция любой части документа отклоняется до нового client replay, включая
  original retry, пока exact consistent custody не восстановлено. Только защищённый
  pending plan разрешает закончить exact replacement; nonce/cursor не remint.
  Current initialization/collection не используют host UTC.
  [Receiver custody fence](../xnode/docs/testing/s03-host-custody-2026-10-04.md)
  теперь обязателен для Store/Retrieve/ACK и peer, включая completed replay:
  actual signing custody проверяется до client replay, full peer candidate — до
  recovery/replay, protected operation root — также после callbacks до выдачи
  результата. Это не активирует whole-host startup/health, Program/DI или deployed
  provisioning; protected retirement/floors остаются открыты.
  Retrieve/ACK используют actual custody обеих реплик; exact ACK batch/quorum
  recovery проверен. Общий порядок/late completion и cross-coordinator ownership
  по-прежнему нужны до активации.
  [DR-0086](survival-program/decisions/DR-0086-current-mailbox-store-order.md)
  фиксирует single-writer/path и closed Store-settlement API. Его
  [local prefix consumer](../xnode/docs/testing/s03-store-prefix-2026-10-04.md)
  уже проверяет signed past commitments до нового replay/cursor, но matching
  client writer exit и native writer rejection реализованы в internal candidate;
  [matching writer checkpoint](../xnode/docs/testing/s03-mailbox-writer-2026-10-04.md)
  отделяет локальные проверки от activation и device evidence. B2 остаётся открыт.
  [Pending-prefix guard](../xnode/docs/testing/s03-pending-prefix-2026-10-04.md)
  теперь отклоняет live native Pending ниже continuation cursor до успешного
  outcome. Он не обнаруживает ещё не материализованный remote intent и не
  возвращает late lower-cursor запись в старую snapshot: это не закрытие B2.
- **B3:** send journal 512 и grant journal 128 не имеют завершённого sustained
  lifecycle; exact retry не заменяет renewal/settlement/retirement.
  [DR-0084](survival-program/decisions/DR-0084-owned-delivery-settlement-and-retirement.md)
  закрепляет client semantic tables, не implementation. Source codec/node default
  остаются 7-day, sender caps object expiry by grant; matching retention,
  replay и retained-route Retrieve/ACK ещё не реализуют normative object horizon.
- **B4:** network reconnect не draining outbox/inbox; fresh proofs блокируют
  local history; AppAck/read события не включены в текущий DID2 consumer.
- **B5:** messaging DI зависит от diagnostic flag, запрещённого для Release;
  исходники исключённых services не доказывают shipping functionality.
- **B6:** signed PMA2/PMT2 successor provisioning, current issuer readiness,
  package/API/resource/evidence repin и actual installed matrix требуют проверки.
- **B7:** files/groups/calls/multi-device/carriers/full release evidence остаются
  обязательными согласно [V1 scope](architecture/V1-RELEASE-SCOPE.md).
- **B8:** по [DR-0088](survival-program/decisions/DR-0088-did2-owned-one-time-contact-object.md)
  добавлен local owned DID2 kind-2 route/object author и exact AEAD restore;
  [24 signed local cases](../xnode/docs/testing/s00-one-time-object-2026-10-04.md)
  проходят. Threshold publication envelope V3 по-прежнему permanent-only:
  отсутствуют key-free signed invitation commitment и protected client custody.
  Positive node claim/replay сценарий
  остаётся failing prerequisite. Сверить current contract и закрыть producer/
  consumer; способность codec разобрать kind 2 не означает runtime support.
  [B8 investigation](../xnode/docs/testing/s00-node-baseline-2026-10-03.md#b8-investigation-real-missing-one-time-producer-contract)
  подтверждает отсутствующий signed public locator/object/expiry commitment;
  usage-limit toggle и передача secret DIA1 threshold не допустимы.

`OfficialXPoint3` не передаёт данные при отсутствии одного обязательного узла;
S09 проверяет сохранность и автоматическое восстановление после возврата.
Расширение topology — отдельное решение, а не скрытый fallback.

## Следующий запуск Codex

Продолжить **S00**: закрыть current one-time publication prerequisite B8 и
оставшиеся unsafe XPP/claim fixtures, перенося их сценарии на actual signed DID2
producer/consumer без удаления quota/replay/rotation/recovery assertions.
Owned kind-2 object уже реализован по DR-0088; следующий B8 batch должен
согласованно закрыть key-free signed invitation commitment, независимый
invitation scope в Registry generation fence и protected exact client intent.
Текущий fence по directory leaf/generation не допускает несколько независимых
genesis invitations. Не менять frozen V3 bytes на месте, не передавать DIA1/key
свидетелям и не включать QR/UI до matched publication/custody consumers.
[Node baseline](../xnode/docs/testing/s00-node-baseline-2026-10-03.md)
содержит исходную классификацию. Новый
[native replacement checkpoint](../xnode/docs/testing/s00-native-replacement-2026-10-03.md)
связал concurrent non-success с actual Windows error 5, проверил bounded retry
на native locks и сохраняет постоянный отказ как uncertainty. Это не определяет
процесс, вызывающий denial, и не обещает успех при любой storage failure.

Продолжить **S01** от DR-0083/0084/0086: после matching canonical writer client exit
и native Store/peer rejection закрыть necessary local floor/format/API
с actual consumers, object-horizon/retained-route Retrieve/ACK и оставшиеся
node/peer/application-receipt contracts. Current native admission и peer consumers
уже соединяют protected MGR1 с реальными replay/outcome/mutation/blob owners;
их checkpoints не заменяют активацию Program/DI и client Store/Retrieve/ACK.
Два независимых native stores через pinned peer TLS/HTTP2 и coordinator quorum
теперь связаны с actual MAU3 admission и durable final Store outcome в локальном
connected gate. Серверный producer сохраняет exact signed intent до peer effects;
Retrieve теперь читает actual mutation/blob custody обеих реплик и сохраняет
canonical MRP1. Client ACK сохраняет whole-batch exact tombstone intent до peer
effects, per-item MQR3 и final MAR1; lost-response/crash/reopen и pagination-expiry
recovery проверены без remint. Текущий writer/prefix не заменяет guarded startup,
retained-route/late-completion порядок, object horizon и shipping composition
ещё не замкнуты. Native distinct ID/key gate теперь проверен с matching producer.
Затем выполнять current admission,
peer quorum и issuer→node→client gate в порядке единого плана. Не включать
retired PMA1/P04 composition и не удалять working entries без независимых floors.
Последние полные результаты и их ограничения находятся в строках S00/S01;
датированные прогоны — в checkpoints и [SPRINT-HISTORY](SPRINT-HISTORY.md),
а не в параллельной очереди здесь.

Новый запуск действует в рамках явной команды пользователя. Historical
checkpoints не разрешают production deployment/reset/publication автоматически.
Подробные owners, gates и шаблон задания находятся только в едином плане.

## Как обновлять этот файл

При закрытии этапа указать commit matrix, команды/gate и ссылку на sanitized
сценарное evidence; изменить одну строку статуса. Не добавлять длинные
хронологические повторы. Завершённые наблюдения записывать в
[SPRINT-HISTORY](SPRINT-HISTORY.md). Handoff от 2026-10-03 и DID2 checkpoints
остаются неизменяемой исходной историей, не текущими очередями работ.
