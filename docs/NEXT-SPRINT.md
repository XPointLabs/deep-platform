# Текущая очередь Deep / XPoint

Обновлено: **2026-10-03**. Branch baseline: `release-candidate/prod-20260909`;
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
| S00 | **В работе: Shared full 546/546; Protocol full 2067 pass / 1 fail / 12 skips; XNode full 907 pass / 1 B8 fail, native replacement 6/6, connected 49/49 и шесть concurrent repeats проходят; Registry 331 pass / 0 fail + 6 Linux signer pass** | [Shared checkpoint](../deep-client-shared/docs/testing/s01-send-preflight-2026-10-03.md#s00-fixture-correction), [latest Shared/Protocol gates](../deep-client-shared/docs/testing/s01-settlement-boundaries-2026-10-03.md#commands-and-gates), [ONION checkpoint](../deep-protocol/docs/testing/s00-onion-baseline-2026-10-03.md), [contact checkpoint](../deep-protocol/docs/testing/s00-contact-baseline-2026-10-03.md), [Node baseline](../xnode/docs/testing/s00-node-baseline-2026-10-03.md), [native replacement](../xnode/docs/testing/s00-native-replacement-2026-10-03.md), [Registry classification](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md); actual error 5 связан с concurrent Unknown, bounded same-file retry проверен без ACL/source repair; процесс-источник denial не установлен; package/current authority и invite/XPP открыты |
| S01 | **В работе: DR-0083/0084; Protocol revocation/floor 49/49, settlement boundary/registry 26/26; native custody 29/29; Shared exact unknown retry при 512 occupied slots проходит; full 546/546; node admission/peer consumers отсутствуют** | [Revocation contract](survival-program/decisions/DR-0083-current-mailbox-grant-revocation.md), [client semantic contract](survival-program/decisions/DR-0084-owned-delivery-settlement-and-retirement.md), [Protocol evidence](../deep-protocol/docs/testing/s01-mailbox-revocation-2026-10-03.md), [native evidence](../xnode/docs/testing/s01-mailbox-revocation-native-2026-10-03.md), [settlement boundaries](../deep-client-shared/docs/testing/s01-settlement-boundaries-2026-10-03.md); local format/API, runtime compaction/renewal, object-horizon integration и application receipt contracts открыты |
| S02 | Заблокирован S01 | Current XNode admission вместо PMA1/P04 и host UTC |
| S03 | Заблокирован S02 | Grant-bound peer mutation, отдельные ID/key, durable quorum |
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

## Блокеры, которые нельзя потерять

- **B1:** Protocol/Shared перешли к DR-0081, node Program всё ещё подключает
  retired mailbox authority; отсутствие current verifier consumer.
- **B2:** protected-time/revocation/holder/selected-exit admission и peer proof
  mutation/quorum не замкнуты; node ID и receipt key в старом adapter слиты.
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

Продолжить **S01** от DR-0083/0084: закрыть necessary local floor/format/API
с actual consumers, object-horizon/retained-route Retrieve/ACK и оставшиеся
node/peer/application-receipt contracts. Затем выполнять current admission,
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
