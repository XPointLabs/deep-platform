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
| S00 | **В работе: Shared full 547/547; Protocol full 2079 pass / 1 fail / 12 skips; XNode full 1059 pass / 1 B8 fail, current mailbox 164/164; ingress 17/17, native replacement 6/6, claim connected 49/49 и шесть concurrent repeats проходят; Registry 331 pass / 0 fail + 6 Linux signer pass** | [Latest Shared gate](../deep-client-shared/docs/testing/s03-mailbox-writer-2026-10-04.md), [latest Node gate](../xnode/docs/testing/s03-descriptor-keys-2026-10-04.md), [Protocol gates](../deep-protocol/docs/testing/s03-descriptor-keys-2026-10-04.md), [ONION](../deep-protocol/docs/testing/s00-onion-baseline-2026-10-03.md), [contact](../deep-protocol/docs/testing/s00-contact-baseline-2026-10-03.md), [Node baseline](../xnode/docs/testing/s00-node-baseline-2026-10-03.md), [native replacement](../xnode/docs/testing/s00-native-replacement-2026-10-03.md), [ingress binding](../xnode/docs/testing/s00-mailbox-ingress-binding-2026-10-03.md), [Registry classification](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md); assertions сохранены; package graph и invite/XPP открыты |
| S01 | **В работе: DR-0083/0084/0086; Protocol revocation/floor 49/49, settlement boundary/registry 26/26; native custody 29/29; matching writer/prefix/client и scoped recovery candidate проверены, current mailbox 164/164; Shared exact unknown retry при 512 occupied slots проходит, full 547/547; shipping consumers не активированы** | [Revocation contract](survival-program/decisions/DR-0083-current-mailbox-grant-revocation.md), [client semantic contract](survival-program/decisions/DR-0084-owned-delivery-settlement-and-retirement.md), [writer checkpoint](../xnode/docs/testing/s03-mailbox-writer-2026-10-04.md), [recovery checkpoint](../xnode/docs/testing/s03-store-recovery-2026-10-04.md), [Protocol evidence](../deep-protocol/docs/testing/s01-mailbox-revocation-2026-10-03.md), [native evidence](../xnode/docs/testing/s01-mailbox-revocation-native-2026-10-03.md), [settlement boundaries](../deep-client-shared/docs/testing/s01-settlement-boundaries-2026-10-03.md); global startup/local format/API, compaction/renewal, object horizon и application receipt contracts открыты |
| S02 | **Native admission соединён с internal Store producer/peer и Retrieve/ACK обеих реплик; matching writer и separate descriptor-key candidate проверены, активация заблокирована S01** | [Admission checkpoint](../xnode/docs/testing/s02-current-mailbox-admission-2026-10-03.md), [writer checkpoint](../xnode/docs/testing/s03-mailbox-writer-2026-10-04.md), [descriptor keys](../xnode/docs/testing/s03-descriptor-keys-2026-10-04.md), [current Retrieve](../xnode/docs/testing/s03-current-retrieve-2026-10-04.md), [current ACK](../xnode/docs/testing/s03-current-ack-2026-10-04.md): оба protected role floor, current source/time, holder/body и реальные replay/outcome/mutation/blob owners. Store только у ranked writer; Retrieve/ACK обеих реплик сохранены. Same-owner scope исключает повторный захват native floor locks. Program/DI и retained-route порядок остаются открыты |
| S03 | **Internal Store/current peer HTTP/quorum, Retrieve/ACK, canonical outcomes, authenticated prefix, matching writer, scoped recovery и distinct descriptor keys проверены; Program/DI заблокирован S02** | [Writer checkpoint](../xnode/docs/testing/s03-mailbox-writer-2026-10-04.md), [matching client](../deep-client-shared/docs/testing/s03-mailbox-writer-2026-10-04.md), [Store-prefix checkpoint](../xnode/docs/testing/s03-store-prefix-2026-10-04.md), [recovery checkpoint](../xnode/docs/testing/s03-store-recovery-2026-10-04.md), [descriptor keys](../xnode/docs/testing/s03-descriptor-keys-2026-10-04.md), [current ACK](../xnode/docs/testing/s03-current-ack-2026-10-04.md): actual MAU3, exact PRQ2 до effects, saved MQR3 в existing operation ledger; same-scope Store не проходит Pending другого grant, включая сохранённый intent до mutation. Store client exit сохраняет authenticated PMS2 rank; non-writer client/peer Store reject до replay/mutation. Потеря intent при retained native mutation блокирует новую allocation, но exact original retry может reconciliate. Schema 6 без миграции/нового журнала. Current connected 164/164, full XNode 1059 pass / 1 B8 fail, Release build 0 warnings/errors, real-Xray smoke/3-node rehearsal pass. Global startup/rollback, retained-route/object horizon и Program/DI открыты; не physical E2E |
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

Текущий S02/S03 client/peer batch: Protocol `ac20a82fabb4d83ac9e5623155e4abc0fcdbb00b`,
Shared `485c381280ca9b59d27eba12be43a7eb7d5f782f`,
XNode `74b22f743ae62a5147c76f9eccc6b6e3c2a37297`; consumer проверен через
source-cutover, не через опубликованный package или установленный client.

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
  новой операции/grant переиспользовать cursor. Exact original retry не выделяет
  новый cursor и может завершиться при повреждении посторонней записи. Current-only initialization не
  читает host UTC; current ACK исключён из neutral expiry collection. Это не
  global startup/rollback qualification: потеря intent до native mutation и
  независимые protected retirement/floors по-прежнему требуют закрытия.
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
- **B8:** current publication author/verifier поддерживает reusable genesis,
  но не подписанную DID2 one-time invitation; positive claim/replay сценарий
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
