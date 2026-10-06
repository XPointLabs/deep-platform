# Текущая очередь Deep / XPoint

Обновлено: **2026-10-06**. Branch: `release-candidate/prod-20260909`.
Единственный DAG и критерии приёмки:
[IMPLEMENTATION-PLAN-V1](architecture/IMPLEMENTATION-PLAN-V1.md).
Основание: [аудит](architecture/ARCHITECTURE-AUDIT-2026-10-03.md),
[DR-0082](survival-program/decisions/DR-0082-integration-first-delivery-baseline.md)
и [DR-0095](survival-program/decisions/DR-0095-baseline-and-shipping-gate-separation.md).
Здесь незавершённая работа, не хронология и не второй план.

## Единственная следующая подзадача

**S01 — bounded outbox-only disposition/API и dependency closure.**

Следующий единственный переход: завершить affected-reader и fault/cold/full
qualification bounded outbox-only API из actual settlement custody, сохраняя
независимые history/receipt obligations и floors.
Признак Stored, SQL row count или parser metadata не разрешают удаление.
Matching SQL reader и protected roots должны иметь один recoverable batch;
runtime lifecycle/scheduler cleanup остаются S04. В working source реализованы
held selection/staging, complete application SQL effects/writer и stored recovery,
Store и exact E2EE replay после удаления working copy. Native recovery fixture
33/0/0 terminal0, structural71/0/0 terminal0;19 frozen inputs matched. Это
receipt до последнего E2EE reader join. Cached encryption104/0/0 terminal0
проверил этот join; final structural103/0/0 terminal0 даёт unique fixture case IDs.
Final production и isolated host builds0 warnings/errors, discovery687 unique.
Source checkpoint Shared `574d934347fb21f48453def7541a0a7a7a86d06d`
закоммичен и запушен; working tree Shared чистое. Required coupled full запущен
на isolated final host:687 unique discovery, all678 prior и161 current required,
55 frozen inputs. Manifest `artifacts/s01-outbox-owner-final-full/expected-qualification.json`
(Shared-relative), SHA256 `4095F2C250FF4361BA62BD4A2C5C4C17EB347F4680464051E8B4FF85105D5336`.
Итогового receipt ещё нет; source checkpoint не закрывает блок.
Runtime time/lease checks не ослаблены.
[Точный checkpoint и сохранённые FAIL](../deep-client-shared/docs/testing/s01-ordinary-outbox-disposition-2026-10-06.md).
Блок не принят до reader closure и required coupled full gate.
Ниже — уже принятая prefix
подзадача, prerequisite этого перехода, а не задание реализовать её снова.

В этой же подзадаче закрыт найденный same-scope replay defect: absent ordinary
entry больше не позволяет reserve новый Pending для retained native operation.
Focused source checkpoint Shared `132871df56b749ee569a6439f9800bff10932dd8`.
[Focused prerequisite receipt](../deep-client-shared/docs/testing/s01-authored-counter-floors-2026-10-06.md#outbox-replay-prerequisite--focused-only):
26/0/0 terminal0, actual native case и25 unit cases mapped Passed, non-test build
0 warnings/errors. Это не accepted disposition/API batch: его selection,
dependency/recovery closure и required coupled full gate ещё впереди.

Dependency/recovery semantics приняты у
[sole owner §8.4.3](architecture/TRANSPORT-NEUTRAL-MESSAGING.md#843-compaction-and-boundedness):
одна SQLCipher database/transaction на batch, exact predecessor/successor SQL,
guarded dependency closure и deterministic prefix protected-root adoption.
Отдельны outbox-only cleanup, local history, crypto checkpoint и receipt work.
Cancel после SQL не очищает plan и не восстанавливает удалённый payload.
[Current consumer/API mapping](../deep-client-shared/docs/architecture/owned-authored-counter-custody.md#compaction-dependencyapi-target-not-runtime-activation)
указывает реальные затронутые readers и обязательные crash/reopen границы.

Source checkpoint Shared `9b5ca981449666576e1560e847e79cfbfea378cb`:
mandatory plan/history registration, schema3 readers, exact staging,
held prefix selection, complete SQL effects, checkpoint CAS/adoption,
stored recovery и durable pre-SQL abort реализованы.
Startup recovery предшествует ordinary opens; другие пути требуют idle-plan.
Это narrow local prefix API, не включённый scheduler cleanup и не remote
settlement. ContactAccept/history/exact replay и следующий ratchet сохранены.

Приёмка prefix API: [repo checkpoint](../deep-client-shared/docs/testing/s01-compaction-plan-model-2026-10-06.md#current-coupled-full-gate--accepted-prefix-slice).
Pre-sanitization focused/native131/0/0 terminal0 проверил шесть handover,
обе cancel boundaries, missing staging/peer-state, same-shape payload
substitution и SQL rollback после commit marker. Final structural130/0/0
terminal0 и non-test Production build0 warnings/errors. First full677/1/0
terminal1: все678 discovery names и131 required cases mapped, но один manual
catalog fixture не зарегистрировал mandatory history root. Setup исправлен;
hostile-SQL fixture также доведён до actual schema rejection, missing-history
rejection проверяет unchanged state. Corrected focused149/0/0 terminal0.
Corrected fixture input Shared `23988df2204202374c6c0edb8b709495aaf6e1e8`:
full678/0/0 terminal0 с explicit shell marker; all678 discovery names,
all150 unique required cases и627 prior cases mapped Passed, без missing/extra,
duplicates или skips.40/40 frozen inputs rechecked exact; runtime source
не изменён. Narrow prefix block принят на этой matrix, весь S01 ещё не закрыт.
История отдельных candidates и старого model full627 с неизвестным exit
хранится только в repo checkpoint; она не квалифицирует этот source.

После принятой prefix подзадачи — оставшиеся S01 bounded APIs/dispositions,
durable retirement/dependency fences и receipt/object closure.
Independent files/groups/calls до этих prerequisites не открываются.
Object-horizon/retained-route Retrieve/ACK contract остаётся связанным activation
fence; текущий sole read path нельзя удалять без закрытого receive/ACK или
authenticated migration. Runtime cleanup/renewal/retirement не активированы.
Expiry, свежий grant, cache miss и capacity не являются deletion permission.

## Уже принятые prerequisites — не реализовывать повторно

- [Grant acquisition/pointer, original ceiling/closed-unresolved и late-result custody](../deep-client-shared/docs/testing/s01-grant-acquisition-contract-2026-10-05.md).
- [Store counter floors](survival-program/decisions/DR-0092-did2-owned-mailbox-counter-floors.md)
  и [PMT2 epoch continuity](../deep-protocol/docs/testing/s01-selection-epoch-continuity-2026-10-06.md).
- [Held epoch-exclusion prerequisite](../deep-client-shared/docs/testing/s01-mailbox-epoch-exclusion-2026-10-06.md):
  Shared `f4982e38c0848161f4b289218c62fb050e7bec5d`, full583/0/0 terminal0,
  все25 focused +7 send +2 receive cases Passed, 9/9 frozen inputs matched.
  Это не dependency closure или полная deletion permission.
- [Independent authored floors](../deep-client-shared/docs/testing/s01-authored-counter-floors-2026-10-06.md):
  Shared `e451c075ebd898ba83adb72ce6b93553b1001fc3`, full591/0/0 terminal0,
  все25 final unit +11 connected results Passed, 14/14 frozen inputs matched.
  Actual Production build0 warnings/errors; cleanup не реализован.
  Этот receipt использует Protocol `4fa9f95989db38d1012bd65c0dd73326824b8b91`,
  не будущие пересборки или установленный клиент.

Contract-only commits: Shared `0b38a6dc895b38b833377355b9d80f41c8b6604b`
(mapping), Protocol `90dbe5135c43be7977389ee148f5c92e0fee94f4`
(только normative source-hash repin и derived registry identities).
Strict registry/generator и все175 anchors проходят; allocations/inventory
не менялись. Focused registry/parity12/0/0 terminal0, Protocol Release build0
warnings/errors, root documentation174 и governance helper22/0/0.
Эти contract-only receipts не доказывают реализованную owner API,
fresh full Shared/package/device evidence или
закрытие S01. Точные inputs/receipts остаются в связанных repo checkpoints.

## Точная граница общей приёмки

Полностью принятых этапов **1/14 (около 7%)**, physical E2E **0/4**, релиз не готов.
S00 source baseline принят на своих frozen inputs: Node1220/0/0,
Registry348/0/7 + exact Linux7/0/0, original19 Node/31 Registry mappings,
required isolated real-Xray smoke и root governance.
[Node receipt](../xnode/docs/testing/s00-node-baseline-2026-10-03.md#current-peer-https-setup-investigation--2026-10-05),
[Registry receipt](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md#current-source-baseline--2026-10-05).
Node input `4ec06aedf5a65d29e00f4aa9945f2a4014179bb0`;
Registry input `0f0a0dfc39dd496da47ecb6100ce950ea1aa9ff3` (runtimef47ca75).
Registry Release solution строила внешние dependencies в Debug; это source
baseline, не uniformly Release package matrix.

Последний full Protocol receipt2018/1/7 terminal1 сохраняет реальный MAU2
actual-package/assembly blocker; native PMA1/PMR1 routing/genesis/recovery
closure остаётся S08/релизом по DR-0095. Assertions и required gates не отменены.
[Protocol scope/receipt](../deep-protocol/docs/testing/s00-contact-baseline-2026-10-03.md#mailbox-issuance-and-current-grant-adapter-retirement-2026-10-05).
Normative repin не переквалифицирует Node/Registry/MAUI, signed shipping artifacts
или physical delivery. MAUI `56065e0bf311f6b61aa22bf693792d6256951c03`,
Windows/Android Debug и Clean95/Smoke119 относятся к прежней matrix,
не installed/shipping evidence текущих dependencies.
В текущей работе нет production deploy/reset, публикации Release или main merge.
Completed chronology — в repo checkpoints, Git и [SPRINT-HISTORY](SPRINT-HISTORY.md).
## Этапы

| Этап | Статус | Оставшаяся приёмка / evidence owner |
| --- | --- | --- |
| S00 | Принят: source baseline, не shipping qualification | [Node classification](../xnode/docs/testing/s00-node-baseline-2026-10-03.md), [Registry classification](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md). Node1220/0/0; Registry348/0/7 + exact Linux7/0/0; original19/31 mappings, required smoke и root governance проходят |
| S01 | Частично принят; единственный текущий этап | Semantics и prerequisites выше приняты. Narrow held prefix SQL/adoption/recovery owner qualified: current full678/0/0 terminal0, all150 required +627 prior cases Passed,40/40 inputs exact. First full FAIL preserved; old model receipt не подменяет current matrix. Следующий bounded outbox-only disposition/API; remaining durable retirement fence и object-horizon/retained-route contract. Runtime renewal/cleanup — S04, не объявлять реализованными по contract |
| S02 | Current receiver/coordinator и guarded Program wiring реализованы; не принят | [Current Program](../xnode/docs/testing/s02-current-program-2026-10-04.md), [lifecycle](../xnode/docs/testing/s05-mgr1-lifecycle-2026-10-04.md). Current observer/provisioning, whole-host recovery, retained-route и real selected-entry boundaries |
| S03 | Native grant-bound peer/quorum/custody реализованы локально; не принят | [Operation custody](../xnode/docs/testing/s03-operation-custody-2026-10-04.md), [current ACK](../xnode/docs/testing/s03-current-ack-2026-10-04.md). Late completion, cross-coordinator ownership, retained-route/horizon и connected shipping activation |
| S04 | Заблокирован оставшимися S01 contracts | Grant/send renewal, exact unknown settlement, safe retirement/compaction, bounded journals; не увеличивать128/512 вместо lifecycle |
| S05 | Actual HTTPS issuer → configured native Store/Retrieve/ACK/cold reopen проверены локально; не принят | [Registry scope](../deep-registry-api/docs/testing/s05-mgr1-signer-bound-2026-10-04.md#connected-private-grant-exchange-2026-10-05). Resolver/owned-client/complete Program/ONION, deployed shared443/proxy и signed successor provisioning |
| S06 | Не пройден | Два independent current clients с actual authorization/owned E2EE через selected-entry и replica endpoints |
| S07 | Read-only local history реализована; scheduler/receipts не закрыты | [History scope](../deep-client-shared/docs/testing/s07-local-history-2026-10-04.md). Offline logical queue, autonomous drain, AppAck/read и полный1:1 event/UI scope |
| S08 | Shipping composition отсутствует; package graph FAIL | Native current-owner join/clean-break и strict actual package/API/resource closure; production composition без diagnostic flag; installed Android/Windows text/receipt |
| S09 | Не квалифицирован | Sustained delivery, rotation/offline/restart/recovery, retained identity/floors и полный catalog scope |
| S10 | Local attachment custody есть; remote flow открыт | Files/images/video/voice/avatar, encrypted remote integrity/resume/expiry/UI |
| S11 | Current DID2 app path не замкнут | Multi-device/history transfer и governed groups, не старый GroupV1 harness |
| S12 | Отдельные компоненты; полный scope не квалифицирован | Carriers/bootstrap/push и relay-only calls |
| S13 | Заблокирован предыдущими release requirements | Одна signed/installed artifact matrix, весь evidence catalog и reviews; Release/main только по отдельной команде |

## Блокеры, которые нельзя потерять

- **B1/S02–S06:** old Node PMA1 providers/adapters удалены; current guarded
  composition уже реализована. Remaining whole-host/historical recovery,
  actual authority/provisioning, selected-entry/ONION и owned client join
  не доказываются local Kestrel/fixture clocks или health200.
- **B2/S01–S03:** distinct node ID/receipt key, signed writer, protected operation
  root и native Store/Retrieve/ACK custody проверены локально. Полный retained
  ordering/late lower-cursor completion, cross-coordinator ownership, protected
  retirement и object horizon всё ещё обязательны.
- **B3/S01/S04:** send512/grant128 не имеют полного sustained lifecycle.
  Current codec/node default остаётся7-day, sender caps expiry by original grant.
  Normative horizon закрывается вместе с replay/retained-route read/ACK; старый
  pending/unknown intent нельзя remint или evict для освобождения места.
- **B4/S07:** network reconnect не draining outbox/inbox; offline logical queue
  и AppAck/read не включены в текущий DID2 consumer. Local history уже отделена
  от fresh network proofs; [full Shared564 terminal0](../deep-client-shared/docs/testing/s07-local-history-2026-10-04.md)
  относится к своей matrix, не к новой package/installed composition.
- **B5/S08:** conversation DI остаётся diagnostic-only и запрещена в Release.
  Нельзя просто снять запрет; нужны supported shipping owner и реальный artifact.
- **B6/S05/S08:** matching signed PMA2/PMT2 successors/current issuer readiness,
  package/API/resource/evidence pins и installed matrix ещё не квалифицированы.
  MAU2/MCG2 внутри retained native provenance нельзя спрятать переименованием.
  Новая mapping/grammar требует frozen authorization; ни один reset/recovery,
  Root/custody или account/device guard не исключён из release scope.
- **B7/S10–S13:** files/groups/calls/multi-device/carriers и полный
  [V1 scope](architecture/V1-RELEASE-SCOPE.md) остаются обязательными.
- **B8/S06/S08:** signed one-time publish/claim/replay, independent descriptor
  keys, client commit verifier и owned secret custody уже реализованы локально:
  [publication](../xnode/docs/testing/s00-one-time-publication-2026-10-04.md),
  [descriptor](../xnode/docs/testing/s00-contact-descriptor-2026-10-04.md),
  [owned custody](../deep-client-shared/docs/testing/s00-one-time-custody-2026-10-04.md).
  Public account-owned operation/QR export, request-expiry reconciliation и
  installed/device evidence остаются открыты. Первый text milestone использует
  постоянный контакт; это не исключает one-time UX из полного релиза.

`OfficialXPoint3`: три production nodes. Outage одного обязательного routing
hop останавливает data route; S09 проверяет сохранность и восстановление после
возврата, не обещает outage availability. До приглашения пользователей остаётся
отдельное расширение до6 по решению владельца; скрытого topology fallback нет.

## Как продолжать и обновлять

Один запуск — одна незавершённая подзадача единого плана. Закрытие фиксирует
точные commits, terminal commands, negative/crash checks и sanitized receipts.
Затем изменяется соответствующая строка статуса. Completed observations и
старые matrices — в repo checkpoints, Git и [SPRINT-HISTORY](SPRINT-HISTORY.md),
не задания на повторную реализацию и не разрешения production/reset/publish.
