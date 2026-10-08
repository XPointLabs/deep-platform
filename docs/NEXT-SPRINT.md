# Текущая очередь Deep / XPoint

Обновлено: **2026-10-08**. Branch: `release-candidate/prod-20260909`.
Единственный DAG и критерии приёмки —
[IMPLEMENTATION-PLAN-V1](architecture/IMPLEMENTATION-PLAN-V1.md).
Основание: [аудит](architecture/ARCHITECTURE-AUDIT-2026-10-03.md),
[DR-0082](survival-program/decisions/DR-0082-integration-first-delivery-baseline.md)
и [DR-0095](survival-program/decisions/DR-0095-baseline-and-shipping-gate-separation.md).
Здесь только текущая очередь. Подробные команды, commits, manifests и сохранённые
FAIL — в связанных repo-checkpoints и Git, не второй backlog.

## Единственная текущая подзадача

**S01 — known send/read floor retirement / dependency fences.**

Предыдущий accepted-object/retained-route batch квалифицирован на matching
Windows source matrices ниже. Следующий единый пакет — deletion permission для
known send/read floors: exact dependency index, irreversible namespace exclusion,
held account lease, все8 protected roots/native SQL fence и crash recovery.
Текущий owner намеренно pin-ит каждый known grant/catalog и каждый Retrieve;
нельзя просто убрать эти запреты без доказанного закрытия зависимостей.
Новый grant, expiry, пустой poll, отсутствие SQL rows или capacity не разрешают
удаление floor либо последнего retained read/ACK path. Безопасное освобождение
slots не remint-ит pending/unknown request и не увеличивает128/512.

Sole semantics —
[delivery transitions §8.4.1](architecture/TRANSPORT-NEUTRAL-MESSAGING.md#841-delivery-transitions),
[boundedness §8.4.3](architecture/TRANSPORT-NEUTRAL-MESSAGING.md#843-compaction-and-boundedness)
и [retained issuance §3.7.3](architecture/CONTACT-RESOLVER-V1.md#373-current-retained-retrieve-issuance).
Связанные решения — DR-0099–0104; exact route request —
[DR-0102](survival-program/decisions/DR-0102-exact-mailbox-request-route-binding.md),
protected native read-back —
[DR-0103](survival-program/decisions/DR-0103-protected-retained-route-document.md),
closed issuer/result —
[DR-0104](survival-program/decisions/DR-0104-current-retained-retrieve-issuance.md).

Принятый bounded coupled source batch связывает public Retrieve с двумя независимыми
protected native stores/private issuer и actual Shared account/publication/
holder custody. Typed native Retrieve/ACK использует original selected pair,
current protected MGR1 и current authority/time; Store остаётся current-only.
Sender, codecs, SQL inbox и native blob/tombstone retention согласованы с
normative object horizon. Store остаётся current-only; expired grant не разрешает
новое admission. Это ещё не runtime activation или закрытие S01.

| Проверка текущего batch | Наблюдаемое evidence / оставшаяся часть |
| --- | --- |
| Shared | Functional batch `a5c6d7d` ранее квалифицирован736/0/0 и запушен. Test-throughput follow-up `f45e4b8` локальный, без push: full751/0/0 за37m53s, actual build/test/qualification0, exact prior736+new15 и1794 inputs unchanged. Два isolated methods, scoped crash hooks; assertions/crypto/deadlines сохранены. Не release acceptance. [Functional receipt](../deep-client-shared/docs/testing/s01-retained-owner-2026-10-07.md#current-full-source-qualification--2026-10-08), [test execution](../deep-client-shared/docs/ARCHITECTURE.md#production-test-execution) |
| Node | Matching full1363/0/0, build/test/qualification0, exact required mappings/2191 inputs unchanged;9 new path-security cases included. Uncached Windows path-check оптимизация не убирает guards/deadlines. [Current terminal](../xnode/docs/testing/s01-native-store-path-safety-2026-10-08.md#matching-full-and-docker-terminal) |
| Protocol | Current full2132/1/7, actual test1; exact source qualification0/all2140 prior/all50 focused/3030 inputs unchanged. Initial TRX-counter qualifier FAIL сохранён; independent post-terminal correction подтверждает исходные receipts, не переписывает их. Actual graph1 MAU2, evidence mapping0; package/release FAIL остаётся. [Producer](../deep-protocol/docs/testing/s01-retained-retrieve-issuance-2026-10-07.md#matching-accepted-object-horizon-source-matrix--2026-10-08), [package boundary](../deep-protocol/docs/testing/s01-retained-route-contract-repin-2026-10-07.md) |
| Registry | Matching build0/full364/0/7/test0/qualification0: exact371 cases/3718 inputs unchanged. Первый Store завершился за11s при прежнем15s budget; actual quorum/exact retry/Retrieve/ACK/cold reopen Passed. Current Windows source matrix принята вместе с Node/Docker evidence. Все прежние FAIL сохранены, exclusive historical cause и nonce-ledger causal fix не объявлены. [Private issuer](../deep-registry-api/docs/testing/s01-retained-private-issuer-2026-10-07.md#native-store-path-optimization-and-matching-full--2026-10-08), [nonce replay](../deep-registry-api/docs/testing/s01-exact-request-binding-2026-10-07.md) |
| Docker | Fresh required isolated external/no-mock smoke0 и multi-node0 после matching Node terminal/independent qualification0;6 исходных dev containers сохранены. Disposable project resources удалены штатными scripts. Infrastructure PASS не доказывает retained delivery/readiness |
| CI | Shared missing ContactAccept input исправлен pinned root checkout в source; bounded graph checks0, GitHub execution не проверен. Linux native ML-KEM provider gap и Protocol actual package/API/resource FAIL открыты |

Этот qualified source пакет закоммичен и запушен: Node `f3477d1`, Registry
`7587fa5`. Source-cutover receipts не являются qualification опубликованных
shipping packages или разрешением Release/main merge.

Рабочий цикл: законченный функциональный пакет → build/targeted tests →
пакет исправлений → mandatory full/connected gate → раздельные child commits
и разрешённый push → root pointers. Не запускать full после каждой правки файла.
Известный failed run допускает остановку с сохранением ошибки, входов и aborted
terminal; это не full PASS. Независимые heavy gates не совмещать.

### Локальный test-harness follow-up — 2026-10-08, без push

До full теперь выполняется реальный `FixturePreflight=true`: signed windows,
successor overlap, lease после setup/encrypted reopen, frozen vectors и
необходимые native/DB providers. Root `scripts/TestGate.psm1` — единственный
runner/input/TRX implementation; обязательный порядок и команды закреплены в
[AGENTS](../AGENTS.md#canonical-local-test-invocation). Windows interpreter —
PowerShell5.1; Protocol witnesses отдельно требуют7.5.4. Named skips/known
FAIL классифицируются явно, interrupted/empty/missing evidence не становятся PASS.

Новый Shared full **756/0/0 за36m03s**, preflight10.39s, весь runner37m37s.
Относительно предыдущей оптимизации это ещё **1m50s (4.8%)** для full либо
**1m30s (3.8%)** для полного runner. Основная польза preflight — предотвращение
позднего повторного full, а не уменьшение криптографической работы; величина
наблюдаемая, не SLO. [Exact observation](../deep-client-shared/docs/ARCHITECTURE.md#fixture-preflight-and-unified-runner-observation--2026-10-08).
Node follow-up прошёл1364/0/0; Protocol сохранил2132/1/7 и actual native1/
`FullAccepted=false` из-за известного MAU2 package boundary.

Registry provider/preflight проходят. `registry-full-03` дал365/0/7/test0,
но его qualifier1 сохранён: manifest захватил изменяемый generated
`bin/.../artifacts/registry-state.json`. Это правило capture исправлено без
исключения executable inputs. Последующие `registry-full-04`/`05` дали364/1/7:
`ActualTlsProofAcquisitionAndSignedControlReachNodeConsumers` faulted MGR1 при
проверке rollback clock в configured Program. Эти full не приняты; serial
override не помог и не оставлен. Причина не объявлена доказанной и custody
guards не ослаблены. Final `registry-full-06` прошёл365/0/7/all phase exits0,
exact372 mappings/2637 inputs unchanged; это matching full финального runner.
Прежние MGR1 FAIL сохранены: intermittent failure не объявлен исправленным
из-за одного последующего PASS. Прежняя functional matrix выше не переписана.
Оригинальные receipts/terminals сохраняются под `artifacts/test-gate-20261008/`
в соответствующих repos; helper snapshots у разных запусков различаются.
Финальные common contracts30/0 проверены в PowerShell5.1 и7.5.4; provider
wrapper guards12/0 в обоих interpreter. Current Shared/Node/Protocol preflight
прошли отдельно, а финальный reader независимо прочитал сохранённые full matrices.
Это не переобозначение старых input snapshots как новой source qualification.
CI preflight wiring изменено, удалённое выполнение не проверено. Этот follow-up
не закрывает S01, shipping/package/platform или physical blockers.
Локальные child commits: Shared `aab0aa4`, Node `c000dc1`, Protocol `2c8f1a5`,
Registry `0f4b06f`, DevOps `1aaa835`; root содержит общий механизм и matching
pointers. Push/publish/deploy/Release/main merge не выполнялись.

Теперь — **known send/read floor retirement/dependency fences**, не S02 или
параллельный feature batch. Sole retained read path нельзя удалять без закрытого
receive/ACK или authenticated migration. Expiry, новый grant, cache miss и capacity
не являются deletion permission. Runtime renewal/cleanup остаётся S04.
Scheduler/AppAck/UI S07 и independent files/groups/calls сейчас не открывать.

## Уже принятые prerequisites — не реализовывать повторно

- [Grant acquisition/pointer, original ceiling, closed-unresolved и late-result custody](../deep-client-shared/docs/testing/s01-grant-acquisition-contract-2026-10-05.md).
- [Store counter floors](survival-program/decisions/DR-0092-did2-owned-mailbox-counter-floors.md)
  и [PMT2 epoch continuity](../deep-protocol/docs/testing/s01-selection-epoch-continuity-2026-10-06.md).
- [Held epoch-exclusion](../deep-client-shared/docs/testing/s01-mailbox-epoch-exclusion-2026-10-06.md):
  prerequisite, не полная deletion permission.
- [Independent authored floors](../deep-client-shared/docs/testing/s01-authored-counter-floors-2026-10-06.md):
  не runtime cleanup.
- [Held prefix API](../deep-client-shared/docs/testing/s01-compaction-plan-model-2026-10-06.md#current-coupled-full-gate--accepted-prefix-slice):
  full678; SQL effects/recovery/abort, не scheduler cleanup.
- [Outbox-only disposition](../deep-client-shared/docs/testing/s01-ordinary-outbox-disposition-2026-10-06.md#current-coupled-full-gate--accepted-outbox-only-slice):
  full687; history/native custody/floors/asset keys сохранены.
- [Closed unused Deposit retirement](../deep-client-shared/docs/testing/s01-closed-deposit-retirement-2026-10-06.md):
  full706; не known/unresolved Retrieve deletion.
- [Recipient receipt obligation](../deep-client-shared/docs/testing/s01-application-receipt-obligations-2026-10-06.md):
  full726; atomic inbox/receipt work, не AppAck/scheduler.
- Bounded retained producer/lookup/request/native custody slices qualified на
  собственных inputs: [Protocol request](../deep-protocol/docs/testing/s01-retained-read-request-2026-10-07.md),
  [Node lookup](../xnode/docs/testing/s01-retained-lookup-2026-10-07.md),
  [route custody](../xnode/docs/testing/s01-retained-route-custody-2026-10-07.md),
  [protected document](../xnode/docs/testing/s01-protected-retained-route-2026-10-07.md),
  [two-store peer](../xnode/docs/testing/s01-retained-native-peer-2026-10-07.md).
  Их PASS не переквалифицируют current coupled batch, shipping или devices.

## Общая приёмка

Полностью принятых этапов **1/14 (около7%)** — доля закрытых этапов, не измеренный
процент написанного кода. Physical E2E **0/4**, релиз не готов.
S00 принят как source baseline на своих frozen inputs:
[Node](../xnode/docs/testing/s00-node-baseline-2026-10-03.md#current-peer-https-setup-investigation--2026-10-05),
[Registry](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md#current-source-baseline--2026-10-05).
Source-cutover, uniformly Release shipping package graph, installed artifacts
и физический сценарий — разные evidence boundaries.
Matching functional source commits ранее запушены в release-candidate: Shared
`a5c6d7d`, Protocol `e48484c`, Node `f3477d1`, Registry `7587fa5`.
Shared test-throughput follow-up `f45e4b8` и новый test-harness batch выше с
соответствующими root pointers остаются локальными, без push; child trees чистые.
Никакой Release/main merge этим не
выполнен. Следующий функциональный шаг — known send/read floor retirement
и dependency fences, не повтор уже принятой Registry Windows qualification,
не переход к S02 и не повтор неизменённых Shared/Node full gates.
Raw artifact scan ранее fail-closed на двух Android PNGs; selected source scan
не квалифицирует их или полный release upload. FAIL receipts не удалять.

Original dev-контур имеет retained expired offline XNA1 (наблюдавшийся
expiry2026-10-06), readiness authority unavailable. Engine availability не
обновляет подписанную authority. Signed renewal с сохранением genesis/keys/floors —
S05, без нового genesis/reset/bypass. Isolated infrastructure smoke не доказывает
readiness этого retained stack. macOS не собирать без явной команды пользователя.
Seed-машины — production, не UAT; владелец разрешил тестировать production до
появления пользователей. Секреты/production IP в public docs не включать.
В текущем source batch production deploy/reset, Release и main merge не выполнялись.

## Этапы

| Этап | Статус | Оставшаяся приёмка / evidence owner |
| --- | --- | --- |
| S00 | Принят: source baseline, не shipping qualification | [Node classification](../xnode/docs/testing/s00-node-baseline-2026-10-03.md), [Registry classification](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md). Node1220/0/0; Registry348/0/7 + exact Linux7/0/0; original19/31 mappings, required smoke и root governance проходят |
| S01 | Частично принят; единственный текущий этап | Semantics и prerequisites выше приняты. Prefix/outbox-only/unused Deposit/recipient obligation slices qualified на своих matrices. Accepted-object/retained-route matching Windows source batch квалифицирован выше; Protocol shipping FAIL сохранён по DR-0095. Следующий блок — known send/read floor retirement/dependency fences. Runtime renewal/cleanup — S04, не объявлять реализованными по contract |
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
  Новый source increment согласует codec/node с product horizon и убирает
  sender cap by original grant; current Shared/Node source matrices приняты,
  matching Protocol matrix квалифицирована с сохранённым shipping FAIL;
  Registry connected Windows source qualification закрыта; shipping/owned
  clients и known-floor/dependency closure остаются открыты.
  Предыдущие29-case Shared и429/1 native receipts его не покрывают.
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
