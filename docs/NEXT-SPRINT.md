# Текущая очередь Deep / XPoint

Обновлено: **2026-10-06**. Branch: `release-candidate/prod-20260909`.
Единственный DAG и критерии приёмки:
[IMPLEMENTATION-PLAN-V1](architecture/IMPLEMENTATION-PLAN-V1.md).
Основание: [аудит](architecture/ARCHITECTURE-AUDIT-2026-10-03.md),
[DR-0082](survival-program/decisions/DR-0082-integration-first-delivery-baseline.md)
и [DR-0095](survival-program/decisions/DR-0095-baseline-and-shipping-gate-separation.md).
Здесь статус незавершённой работы, не хронология и не второй план.

## Единственная следующая подзадача

**S01 — оставшийся local format/API freeze для settlement/renewal/retirement.**
Следующая единственная подзадача — protected compaction-plan/floor contract для
irreversible namespace retirement fence: dependency closure, порядок protected
commit/read-back и сохранение accepted-object/retained-route obligations после
crash/reopen. Epoch-exclusion prerequisite ниже принят отдельно; он не является
полной deletion permission. Не включать cleanup/renewal/retirement
runtime до contract; expiry, fresh grant, cache miss и capacity сами по себе
не доказывают отсутствие remotely issued grant или право удалить dependencies.

Узкий held epoch-exclusion prerequisite по
[DR-0097](survival-program/decisions/DR-0097-owned-mailbox-epoch-exclusion.md)
реализован на существующих generation5 + actual DNH2/anchor, без нового reader
или marker. Producer и повторный consumer recheck удерживают actual account
lease, exact original acquisition/root/instance и independently current signed
policy/time. Known/closed-unresolved, lower-ceiling boundary, same-epoch refusal,
cold reopen, missing root/anchor, clock rollback, expired proof, cancel/dispose:
focused25/0/0 terminal0, actual Production build0 warnings/0 errors.
[Frozen inputs и receipts](../deep-client-shared/docs/testing/s01-mailbox-epoch-exclusion-2026-10-06.md).
Required full Shared gate **583/0/0 terminal0**; все25 focused + семь owned-send
и два owned-receive cases Passed, все девять frozen inputs совпали после gate.
Bounded local source slice принят: Shared `f4982e38c0848161f4b289218c62fb050e7bec5d`,
Protocol `4fa9f95989db38d1012bd65c0dd73326824b8b91` (только normative source-hash repin).
Namespace
exclusion prerequisite не заменяет dependency closure/compaction plan, retained
object read/ACK или production epoch-handover qualification. Whole S01 остаётся
частичным; другой independent slice не открывается.

Внутри этого же подпункта исправлен воспроизведённый PMT2 selection-epoch
rollback: signed generations сами по себе не запрещали `7 -> 6 -> 9` или
`7 -> 8 -> 7`. [DR-0096](survival-program/decisions/DR-0096-mailbox-selection-epoch-continuity.md)
закрепляет nondecreasing epoch; focused24/0/0, все24 Passed в полном gate,
Release Protocol/actual Shared Production builds0 warnings/0 errors.
Protocol `31a36fdbea6484331cc4ed989e6a449375f9482d`.
[Точные inputs и receipts](../deep-protocol/docs/testing/s01-selection-epoch-continuity-2026-10-06.md).
Whole solution2018/1/7 terminal1 сохраняет прежний MAU2 package blocker.
Это prerequisite того же retirement contract, не закрытие S01 и не разрешение
на cleanup; следующая задача не меняется.

Исходная signed-policy ceiling, lower-bound expiry proof и запрещённые substitute
outcomes уточнены у [semantic owner](architecture/TRANSPORT-NEUTRAL-MESSAGING.md#842-grant-and-route-transitions).
Предыдущий принятый Shared slice с local reader generation4 хранит original
policy/route ceiling и closed-unresolved outcome; internal owner entry закрывает
expired request по independently current own proof/time без старого route или
issuer callback. Final focused custody12/0/0 проверяет uncertainty boundary,
normal closure, faults до/после записи и cold reopen/no-reissue. Required full
production gate **570/0/0 terminal0**, все15 selected custody/original-Store/
receive cases Passed; actual Production build **0 warnings, 0 errors terminal0**.
Shared `840d27d6746eed85eace456d5c78b9eb916b9642`;
[receipt, inputs и границы](../deep-client-shared/docs/testing/s01-grant-acquisition-contract-2026-10-05.md#original-issuance-ceiling-and-closed-unresolved-custody--2026-10-06-accepted-slice).
Runtime renewal и irreversible fence producer/consumer ещё не приняты.
Принятый late-result slice использует единственный current local reader generation5 с раздельными
received/adopted late states; сетевой wire не меняется. Actual Deposit/Retrieve,
шесть handover faults, cold resume без повторного issuer callback, сохранение
newer winner/pending и callback-window crossing проходят focused17/0/0 terminal0.
Его собственный required full current-source gate **575/0/0 terminal0**, все20
selected custody/original-Store/owned-receive cases Passed, семь frozen inputs
совпали после завершения; actual Production build **0 warnings, 0 errors**.
Shared `ce31023e6629c29d00702a7dc6e09ae683479a87`;
[late-result receipt и границы](../deep-client-shared/docs/testing/s01-grant-acquisition-contract-2026-10-05.md#authenticated-late-result-adoption--2026-10-06-accepted-slice).
Generation4 receipt выше — evidence своего исходника, не substitute текущего
gate. Весь S01 не закрыт; новый independent slice до retirement contract не открывается.

Первый bounded slice принят локально: independent acquisitions, pending/current
pointers, predecessor linkage и exact original winner lookup во всех Store/read/ACK
consumers. Shared `dbb3baee7a0e8a05bce78d715057740d03c85417`; required full
production gate **567/0/0 terminal0**, все12 selected custody/original-Store/
receive cases Passed, включая selectedSuccessor=true.
[Точные inputs, receipt и границы](../deep-client-shared/docs/testing/s01-grant-acquisition-contract-2026-10-05.md#final-source-acceptance--2026-10-06).
Это local clean-break, не renewal, historic read authority или physical E2E.
Согласованный object-horizon/retained-route Retrieve/ACK contract
остаётся обязательной связанной границей S01, не разрешением включать новый
wire или историческую authority. Уже реализованные Store floors, operation
custody, startup/readiness hooks не реализовывать повторно. Затем идти по DAG к
contact/consent → двустороннему text → durable receive/receipt → restart.
Новые независимые slices files/groups/calls до text milestone не открываются.

Полностью принятых этапов **1/14 (около 7%)**, физические сценарии **0/4**.
Это приёмка, не процент написанного кода. В текущем запуске нет production
deployment, device install/reset, публикации Release или main merge.

## Точная текущая граница evidence

S00 source baseline принят: Node **1220/0/0**, Registry **348/0/7** и точное
альтернативное Linux покрытие этих семи skips **7/0/0**, все terminal0.
Все 19 исходных Node scenario groups и 31 Registry cases независимо сопоставлены
с Passed в свежих полных receipts. Node/Registry source builds zero-warning;
required isolated real-Xray smoke и root governance проходят. Это не uniformly
Release package matrix, deployed mailbox или physical delivery evidence.
[Node scope/receipts](../xnode/docs/testing/s00-node-baseline-2026-10-03.md#current-peer-https-setup-investigation--2026-10-05),
[Registry scope/receipts](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md#current-source-baseline--2026-10-05).

Protocol `ed7153e12cc0749e875a047705566bf0a99338b9` удаляет PHP1 и PMR1
current-grant query adapter по DR-0094. Protocol/Shared Production builds
zero-warning; focused31/0/0 и retained native23/0/0 terminal0.
Whole Protocol до epoch correction **2010/1/7, terminal1**; текущий полный
source gate **2018/1/7, terminal1**: actual-package/assembly rejects MAU2.
Оставшаяся native PMA1/PMR1 routing/genesis/recovery dependency и строгие
source/package/API gates **не закрыты и блокируют S08/релиз**. Их выполнение
отнесено к shipping closure по DR-0095, не отменено и не заменено green status.
[Scope и receipts](../deep-protocol/docs/testing/s00-contact-baseline-2026-10-03.md#mailbox-issuance-and-current-grant-adapter-retirement-2026-10-05).

Последние independently tested consumer source inputs (каждый receipt относится
только к своим frozen dependencies): Node `4ec06aedf5a65d29e00f4aa9945f2a4014179bb0`,
Registry `0f0a0dfc39dd496da47ecb6100ce950ea1aa9ff3`,
Shared `f4982e38c0848161f4b289218c62fb050e7bec5d`,
MAUI `56065e0bf311f6b61aa22bf693792d6256951c03`.
Node final assembly: input162ae plus the exact test-only fixture repair now in
4ec06ae; production source не менялся. Registry final receipts use source f47ca75;
0f0a0df добавляет только документацию этих результатов. Shareddbb3bae реализует
первый S01 acquisition/pointer slice; full567/0/0 проверяет input4cf9349 plus
exact committed patch. Shared840d27d добавляет original issuance ceiling и
closed-unresolved custody; full570/0/0 проверяет inputb82c584 plus exact committed
patch. Sharedce31023 добавляет authenticated late-result/cold-resume slice;
full575/0/0 проверяет input840d27d plus exact committed patch. Все Shared matrices
здесь — source/test-internals, не signed shipping artifacts.
Protocol31a36fd исправляет epoch continuity; actual Shared Production с ним
компилируется zero-warning. Shared575 receipt использовал Protocoled7153e и
не становится новым full Shared/installed evidence после этого repin.
Sharedf4982e3 квалифицирует epoch-exclusion prerequisite: full583/0/0 использует
Protocol4fa9f95 и точные frozen inputs из связанного checkpoint. Это не пересборка
Node/Registry/MAUI или installed evidence их текущих gitlinks.
Product root input
`79e84cd01dd95244bf68b0c20fb53a947e36e48f`; execution/status docs не меняют его
frozen inputs. Точные compiled inputs и hashes находятся в repo checkpoints.
Предыдущий Node1216/0/0 и Registry348/0/7 принадлежат предыдущим Protocol
dependencies. Registry Release solution также строит внешние dependencies в
Debug: это source baseline, не uniformly Release artifact matrix.
Windows/Android Debug compilation и MAUI Clean95/Smoke119 — предыдущая матрица,
не installed/shipping evidence текущего Protocol.

## Этапы

| Этап | Статус | Оставшаяся приёмка / evidence owner |
| --- | --- | --- |
| S00 | Принят: source baseline, не shipping qualification | [Node classification](../xnode/docs/testing/s00-node-baseline-2026-10-03.md), [Registry classification](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md). Node1220/0/0; Registry348/0/7 + exact Linux7/0/0; original19/31 mappings, required smoke и root governance проходят |
| S01 | Частично реализован; единственный следующий этап | Acquisition/pointer, original ceiling/closed-unresolved и [authenticated late-result slices приняты локально](../deep-client-shared/docs/testing/s01-grant-acquisition-contract-2026-10-05.md#authenticated-late-result-adoption--2026-10-06-accepted-slice), [client semantics](survival-program/decisions/DR-0084-owned-delivery-settlement-and-retirement.md), [Store floors](survival-program/decisions/DR-0092-did2-owned-mailbox-counter-floors.md). Irreversible fence, остальные local format/API, renewal/retirement, object horizon и retained-route contract открыты |
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
