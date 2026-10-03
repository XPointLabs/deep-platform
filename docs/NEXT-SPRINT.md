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

| Этап | Статус на момент аудита | Что закрывает |
| --- | --- | --- |
| S00 | **В работе: XNode 853 pass / 1 fail; Registry 331 pass / 0 fail + 6 Linux signer pass** | [Node checkpoints](../xnode/docs/testing/s00-node-baseline-2026-10-03.md), [Registry classification](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md); reader/isolated DB закрыты, current invite prerequisite, XPP fixtures и root governance drift открыты |
| S01 | **Открыт; анализ параллельно S00** | Revocation/admission, grant/send/route settlement и compaction contracts |
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

`OfficialXPoint3` не передаёт данные при отсутствии одного обязательного узла;
S09 проверяет сохранность и автоматическое восстановление после возврата.
Расширение topology — отдельное решение, а не скрытый fallback.

## Следующий запуск Codex

Продолжить **S00**: current XPP fixture migration и root governance drift.
Registry reader/DB закрыты полным source прогоном; 6 Windows skips отдельно
прошли в actual Linux socket lane. Это не package/physical qualification.
XPP audit подтвердил unsafe construction sealed authority через
`GetUninitializedObject` в `PreKeyInventoryTestCapability`: положительные
opaque-store/XPC cases нельзя считать current signed prekey evidence.
Перенести их scenario semantics на actual DID2 inventory/claim path;
не удалять rotation/quota/replay/recovery coverage и не ослаблять verifier.
Synthetic XPA fixture удалён; facade-сценарии перенесены на signed DID2 inputs.
Свежий XNode checkpoint — 853 pass / 1 fail, без skips; оставшийся positive
one-time invite требует current producer/consumer contract (B8), а не обхода
verifier. Подробная классификация и границы evidence — по ссылке в строке S00.
Параллельно исследовать **S01**,
но не писать node admission до закрытого revocation/time contract.
Подробные owners, gates и шаблон задания находятся только в едином плане.

Аудит разрешил documentation/architecture consolidation, а не возобновление
production deployment или physical reset. Предыдущие разрешения в historical
memory/checkpoints не трактуются как разрешение нового действия автоматически.
Новый implementation запуск работает в границах явной команды пользователя.

## Как обновлять этот файл

При закрытии этапа указать commit matrix, команды/gate и ссылку на sanitized
сценарное evidence; изменить одну строку статуса. Не добавлять длинные
хронологические повторы. Завершённые наблюдения записывать в
[SPRINT-HISTORY](SPRINT-HISTORY.md). Handoff от 2026-10-03 и DID2 checkpoints
остаются неизменяемой исходной историей, не текущими очередями работ.
