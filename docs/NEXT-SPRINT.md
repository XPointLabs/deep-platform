# Текущая очередь Deep / XPoint

Обновлено: **2026-10-05**. Branch: `release-candidate/prod-20260909`.
Единственный DAG и критерии приёмки:
[IMPLEMENTATION-PLAN-V1](architecture/IMPLEMENTATION-PLAN-V1.md).
Основание: [аудит](architecture/ARCHITECTURE-AUDIT-2026-10-03.md),
[DR-0082](survival-program/decisions/DR-0082-integration-first-delivery-baseline.md)
и [DR-0095](survival-program/decisions/DR-0095-baseline-and-shipping-gate-separation.md).
Здесь статус незавершённой работы, не хронология и не второй план.

## Единственная активная подзадача

**S00 — финальная проверка серверного source baseline на текущем Protocol.**
Root ClassificationOnly, CONTACT, crypto и ONION проходят. Registry solution
source-cutover build завершён с0 warnings/errors. Первый provider run не запустил
тесты: локальный Docker engine отсутствовал. После запуска локального Desktop и
проверки Linux engine новый полный Registry run с disposable tmpfs PostgreSQL
завершён terminal0:348/0/7. Linux signer7/0/0 terminal0 покрывает ровно семь
Windows skips, не превращая их в Windows passes. Оба owned containers удалены.
Node final-source build завершён: 0 warnings/errors. Полный прогон ещё
выполняется; terminal receipt не получен. Уже наблюдалось падение
`CurrentClientAckRevokedRoleCannotReleaseCachedAggregate`: подготовительный
Store получил PartialFailure/1 replica, peer TaskCanceledException, HTTP request
дошёл до host, но complete response не наблюдался. Основная ACK/revocation
проверка ещё не достигнута. Внешних конкурентных builds не было; прежняя
гипотеза о build load не объясняет этот повтор. Причина остаётся открытой;
следующая работа — точная HTTP/native phase диагностика без изменения deadline,
assertions, crypto/time/floors или blanket отключения test parallelism.
Старые full результаты не подменяют эти новые проверки.

После S00 брать одну незавершённую S01 подзадачу: оставшийся local format/API
freeze для settlement/renewal/retirement и единый object-horizon/retained-route
Retrieve/ACK contract. Уже реализованные Store floors, operation custody,
startup/readiness hooks не реализовывать повторно. Затем идти по DAG к
contact/consent → двустороннему text → durable receive/receipt → restart.
Новые независимые slices files/groups/calls до text milestone не открываются.

Полностью принятых этапов **0/14**, физические сценарии **0/4**.
Это приёмка, не процент написанного кода. В текущем запуске нет production
deployment, device install/reset, публикации Release или main merge.

## Точная текущая граница evidence

Protocol `ed7153e12cc0749e875a047705566bf0a99338b9` удаляет PHP1 и PMR1
current-grant query adapter по DR-0094. Protocol/Shared Production builds
zero-warning; focused31/0/0 и retained native23/0/0 terminal0.
Whole Protocol **2010/1/7, terminal1**: actual-package/assembly rejects MAU2.
Оставшаяся native PMA1/PMR1 routing/genesis/recovery dependency и строгие
source/package/API gates **не закрыты и блокируют S08/релиз**. Их выполнение
отнесено к shipping closure по DR-0095, не отменено и не заменено green status.
[Scope и receipts](../deep-protocol/docs/testing/s00-contact-baseline-2026-10-03.md#mailbox-issuance-and-current-grant-adapter-retirement-2026-10-05).

Current consumer HEAD: Node `162ae3e10c8ca02faa2200302d1dc0e5befdb5cb`,
Registry `f47ca7510dcf04ff59235387ccce66662c19f620`,
Shared `b238fb4f9bc750185e4fc431b1bf4ae6f33c2b1f`,
MAUI `56065e0bf311f6b61aa22bf693792d6256951c03`.
Root input `79e84cd01dd95244bf68b0c20fb53a947e36e48f`; текущий doc batch
меняет только очередь/порядок, не эту product source matrix.
Предыдущий Node1216/0/0 и Registry348/0/7 принадлежат предыдущим Protocol
dependencies. Registry Release solution также строит внешние dependencies в
Debug: это source baseline, не uniformly Release artifact matrix.
Windows/Android Debug compilation и MAUI Clean95/Smoke119 — предыдущая матрица,
не installed/shipping evidence текущего Protocol.

## Этапы

| Этап | Статус | Оставшаяся приёмка / evidence owner |
| --- | --- | --- |
| S00 | Активен; Registry/platform проверки завершены, Node full идёт с воспроизведённым setup failure | [Node classification](../xnode/docs/testing/s00-node-baseline-2026-10-03.md), [Registry classification](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md). Свежая согласованная source matrix, без unexplained failures/skips; root governance уже проходит |
| S01 | Частично реализован; сейчас не активен | [Client semantics](survival-program/decisions/DR-0084-owned-delivery-settlement-and-retirement.md), [Store floors](survival-program/decisions/DR-0092-did2-owned-mailbox-counter-floors.md). Local format/API, settlement/renewal/retirement, object horizon и retained-route contract остаются открыты |
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
