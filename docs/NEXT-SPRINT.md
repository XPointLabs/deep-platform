# Текущая очередь Deep / XPoint

Обновлено: **2026-10-11**. Branch: `release-candidate/prod-20260909`.
Единственный DAG и критерии приёмки —
[IMPLEMENTATION-PLAN-V1](architecture/IMPLEMENTATION-PLAN-V1.md).
Основание: [аудит](architecture/ARCHITECTURE-AUDIT-2026-10-03.md),
[DR-0082](survival-program/decisions/DR-0082-integration-first-delivery-baseline.md)
и [DR-0095](survival-program/decisions/DR-0095-baseline-and-shipping-gate-separation.md).
Здесь только текущая очередь. Подробные команды, commits, manifests и сохранённые
FAIL — в связанных repo-checkpoints и Git, не второй backlog.

## Единственная текущая подзадача

**S04 — client grant/send/route lifecycle.**

S01 принят как contract/API stage после
[сверки всех блоков](S01-CONTRACT-REVIEW-2026-10-10.md), не как runtime/release.
S02 принят как current-only native/configured node source/composition stage после
[сверки критериев](S02-CURRENT-NODE-REVIEW-2026-10-10.md), не как production activation,
shipping или physical delivery. S03 принят как grant-bound peer node
source/composition stage после [сверки критериев](S03-CURRENT-PEER-REVIEW-2026-10-11.md):
matching full04 **1479/0/0**, exact1479 cases,2142 unchanged inputs,
build/preflight/test/qualification0 и свежие external/no-mock transport gates.
Все35 обязательных групп/83 случая присутствуют в matching full.
Node `ddcf4b6` закоммичен и запушен; remote SHA подтверждён, дерево Node чистое.
Store/read/ACK, lost response/cold exact retry, sole writer/prefix и независимая
peer custody подтверждены локально; это не installed Windows/Android delivery.

Точная история S02/S03, hashes и исходные FAIL находятся только в
[S02 checkpoint](../xnode/docs/testing/s02-current-consumer-2026-10-10.md) и
[S03 checkpoint](../xnode/docs/testing/s03-peer-cycle-2026-10-10.md).
Два исправленных S03 build-graph дефекта не скрыты новым PASS. Intermittent
native MoveFileEx denial прежнего пакета остаётся с неустановленной причиной;
новые PASS не объявляют его исправленным и не меняют retries/ACL.

S04 — единственный текущий этап после принятого и запушенного S03:

- проверить actual Shared owner и принятые S01 settlement/renewal/retirement
  contracts; выбрать один связный lifecycle package, не новый journal/wire;
- сохранить exact ciphertext/request для Pending/unknown, protected replay floors
  и original namespace; не remint, evict или увеличивать lifetime старого send;
- реализовать нужные transitions/compaction целиком, затем целевые crash/cold/
  backpressure проверки, исправления и matching обязательный full;
- закрыть review, commit/push и только затем переходить к S05.

Не открывать scheduler, production provisioning или device E2E параллельно S04.
Физические contacts/messages/files/groups: **0/4 подтверждены**; релиз не готов.
Production, GitHub Releases и main этим S03 пакетом не изменялись.

## Завершённый S01 source пакет и его evidence

Текущий
проверенный source пакет закрывает joint archived-path disposition через exact
dependency index, irreversible original namespace exclusion, held account lease,
protected roots/native SQL fence и complete application SQL readback.
Native consent/history, dedup, receipt work и последний current read/ACK path
не удаляются ради освобождения slots.

Текущая проверенная реализация и границы evidence:

- Shared: archived-path matrix23/0/0/native0 проверяет empty/nonempty disposition,
  все cold handovers, отмену/phase1-only abandon и hostile SQL/staging refusals
  за actual object horizon с genuine signed XNA1/DTS1/head/view successors.
  Это compiled inputs до последующего clock correction, не current full.
- Shared: исправлена зависимость fresh dispatch от expired preparation clock.
  Captured conservative upper floor теперь также растёт с elapsed; новая
  matching regression15/0/0/native0 включает13 arithmetic cases и2 actual native
  scenarios: exact Store retry/durable receipt и publication promotion/lost ACK.
  Build0/zero warnings. Format, original expiry и replay/deletion rules не ослаблены.
- Shared: actual new contact/Hello/Accept/text/lost-ACK проходит после original
  PMA expiry на genuine same-key XNA/DTS renewal/current operational closure:
  focused1/0/0/native0, build0/zero warnings. Genesis/history/advanced PMT epoch
  сохранены; in-process signed services не являются device/production evidence.
  Independent root/witness/issuer key rotation и DCA/XUR rollover ещё открыты.
- Shared: новый actual-owner refusal scenario1/0/0/native0 доказывает отсутствие
  разрешения на удаление при потере protected traversal/read replay floor/current
  permanent path; SQL, damaged roots и idle plan сохраняются при повторном отказе.
  Shared full01 намеренно остановлен перед необходимым согласованием входов:
  build0/zero warnings, prerequisite6/0/0, partial711/1/0, actual test1 и
  qualification1,712 из895 cases. До остановки найден устаревший отрицательный
  assertion чтения retained IncomingRequest; он исправлен с сохранением native
  floor и отдельного запрета нового dispatch. Focused повтор7/0/0/native0,
  build0/zero warnings;
  full PASS или приёмки S01 нет, исходный FAIL сохранён.
  Свежий Shared full02 завершился native0:892/0/0, build0/zero warnings,
  prerequisite6/0/0. Qualification1/FullAccepted=false: в заранее объявленной
  union895 отсутствуют три ранее переименованных/расширенных cases. Отдельная
  post-terminal проверка подтверждает1919 unchanged inputs; она не исправляет
  missing-case FAIL. Добавлены самостоятельные current-only ContactAccept
  expiry и initial/Accept used-Deposit guard fixtures под обязательными именами;
  matching build0/zero warnings. Focused повтор3/0/0/native0 восстанавливает
  все три exact original case IDs; отдельный compiled discovery0 содержит
  ровно895 обязательных имён без missing/extra. Fresh matching full03 завершён:
  895/0/0, build/preflight/test/qualification0, exact895 cases и1922 unchanged
  inputs; FullAccepted=true. Это qualification текущего Shared source batch,
  не автоматическое закрытие всего S01 или physical/release acceptance.
- Protocol: verified-ancestor history и current-authority operational author по
  DR-0107/0108 сохраняют полный protected history/journal и original namespace;
  matching producer171/0/0/native0 сохраняет прежние125 cases и включает25 новых
  operational cases. Новый full2196/1/7/native1 выполнен, но qualification1:
  требуется восстановленный original witness-policy case,2204 из2205 cases.
  Он проверяет сохранённые trust settings и rejects старый DTS, не legacy alias;
  focused повтор11/0/0/native0 и build0/zero warnings. Свежий full02 завершён:
  2197/1/7/native1, exact2205 cases, qualification0 и unchanged inputs;
  build0/zero warnings. Единственный FAIL — прежний actual-package witness,
  семь skips — шесть native-provider cases и operator-only predecessor capture.
  FullAccepted=false сохранён: source matrix не является shipping/activation.
- DevOps: обе caller сборки и5 synthetic FileSigner scenarios проходят.
  Точный PowerShell7.5.4 witness подготовлен как проверенный официальный
  portable binary; системный PATH не менялся. Это только prerequisite.
- Root: status-reader теперь сравнивает exact UTC ticks вместо string/DateTime;
  live start, mismatch на1 tick и malformed start проходят в общей matrix33/0
  под PowerShell5.1 и7.5.4. Normative epoch-exclusion prose согласована с DR-0108;
  только transport-neutral source hash repinned,176 anchors без изменений,
  strict registry проходит. Эти проверки не заменяют финальные Shared/Protocol gates.

Подробные команды, hashes, предыдущие commits и сохранённые FAIL:
[Shared checkpoint](../deep-client-shared/docs/testing/s01-idle-mailbox-floors-2026-10-09.md),
[Protocol checkpoint](../deep-protocol/docs/testing/s01-authority-horizon-2026-10-09.md).
Пакет зафиксирован отдельными commits от zhigubigule/no-reply:
Shared `5057069`, Protocol `9700e76`, DevOps `2a43ba3`.
Более ранние target-only наблюдения относятся к своим inputs, не являются
текущей приёмкой и не образуют отдельную очередь.

Сверка contract/API/layout/fault obligations за пределами archived-path матрицы
завершена: node/peer admission, grant/send/route custody, compaction, recipient
receipt work и identity-neutral successor distribution сопоставлены с sole owners,
реальным кодом и exact TRX membership. Результат и явные runtime exclusions —
в [S01 review](S01-CONTRACT-REVIEW-2026-10-10.md). Pending/Prepared send commitment
не ошибочно принят за ClosedUnresolved grant acquisition или completed AppAck.

Matching Shared full03 принят; Protocol full02 имеет exact source qualification0
с сохранённым native1 / FullAccepted=false из-за прежнего actual-package witness
(S08, DR-0095). Final diff и changed-source secret review пройдены:61 files,
0 findings, четыре diff checks0. Не повторять эти неизменённые source gates и не
объявлять shipping PASS; contract acceptance не подменяет следующие runtime gates.

Границы этапов сверены с [единым планом](architecture/IMPLEMENTATION-PLAN-V1.md#s01--закрыть-недостающие-контракты-без-нового-wire-по-умолчанию)
и [DR-0084](survival-program/decisions/DR-0084-owned-delivery-settlement-and-retirement.md#implementation-boundary).
Следующие требования **не выполнены и не отменены**, но не расширяют S01 до
runtime/release qualification следующих этапов:

- **S04:** activation client transition/compaction, sustained128/512 с distinct
  scopes и pending/unknown/rejected/expired/cancelled work, backpressure,
  сохранение replay protection после cleanup/cold restart и всех handovers;
- **S04/S05:** полный current DCA/XUR/PMT/issuer/root rollover для actual new
  routing/authoring, verified catch-up и воспроизводимый operational lifecycle.
  Same-key source scenario выше не квалифицирует независимую key rotation;
- **S09:** sustained delivery/recovery через реальные endpoints и сохранённые
  identities; source fixtures не заменяют connected/physical evidence.

Runtime scheduler/rotation/stress batches остаются у своих последующих этапов;
приёмка S01/S02 не активирует их автоматически.
Готовность runtime, физического E2E и релиза остаётся отдельной незакрытой целью.

Focused матрицы и source build сами по себе не заменяют contract review или
device E2E и не дают разрешения включить runtime cleanup. Physical contacts/messages/files/groups,
production activation и release остаются последующими незакрытыми requirements
единого DAG; GitHub Releases/main этим пакетом не изменялись.

## Evidence и исторические наблюдения

Подробные S01 команды, source increments и исходные FAIL сохранены в
[Shared checkpoint](../deep-client-shared/docs/testing/s01-idle-mailbox-floors-2026-10-09.md),
[Protocol checkpoint](../deep-protocol/docs/testing/s01-authority-horizon-2026-10-09.md),
[Node checkpoint](../xnode/docs/testing/s01-native-store-path-safety-2026-10-08.md)
и [Registry checkpoint](../deep-registry-api/docs/testing/s01-retained-private-issuer-2026-10-07.md).
Предыдущая полная редакция этой очереди доступна в Git на root `3975ee7`.
Удаление повторного changelog из текущей очереди не меняет исходные receipts,
не скрывает FAIL и не отменяет требования последующих этапов.

## Этапы

| Этап | Статус | Оставшаяся приёмка / evidence owner |
| --- | --- | --- |
| S00 | Принят: source baseline, не shipping qualification | [Node classification](../xnode/docs/testing/s00-node-baseline-2026-10-03.md), [Registry classification](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md). Node1220/0/0; Registry348/0/7 + exact Linux7/0/0; original19/31 mappings, required smoke и root governance проходят |
| S01 | Принят: contract/API stage, не runtime/release | [Requirement-to-evidence review](S01-CONTRACT-REVIEW-2026-10-10.md). Shared full03 принят; Protocol exact source qualification сохраняет actual package FAIL по DR-0095. Runtime renewal/cleanup — S04, receipt orchestration — S07; не объявлять реализованными по contract |
| S02 | Принят: current-only native/configured node source/composition, не production/shipping/physical | [Requirement review](S02-CURRENT-NODE-REVIEW-2026-10-10.md), [current source checkpoint](../xnode/docs/testing/s02-current-consumer-2026-10-10.md). Node5c96043, full1441/0/0/exact1441/2136 unchanged inputs и свежие transport gates |
| S03 | Принят: grant-bound peer node source/composition, не production/shipping/physical | [Requirement review](S03-CURRENT-PEER-REVIEW-2026-10-11.md), [checkpoint](../xnode/docs/testing/s03-peer-cycle-2026-10-10.md). Matching full1479/0/0/exact1479/2142 unchanged inputs,35 groups/83 cases и свежие transport gates |
| S04 | Единственный текущий этап; следующий связный implementation package | Grant/send renewal, exact unknown settlement, safe retirement/compaction, bounded journals; не увеличивать128/512 вместо lifecycle |
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
  composition и configured selected-entry/ONION source stage приняты в S02.
  Peer-wide native recovery принят в S03; deployed authority/provisioning и owned client
  join не доказываются local Kestrel/fixture clocks или health200.
- **B2/S03–S09:** distinct node ID/receipt key, sole signed Store writer/prefix,
  independent peer facts, retained route/horizon и either-replica ACK проверены
  в S03 source stage. Owned retirement/compaction, sustained lifecycle и
  connected/physical recovery по-прежнему обязательны; local PASS их не заменяет.
- **B3/S04:** send512/grant128 не имеют полного sustained lifecycle.
  Новый source increment согласует codec/node с product horizon и убирает
  sender cap by original grant; current Shared/Node source matrices приняты,
  matching Protocol matrix квалифицирована с сохранённым shipping FAIL;
  Registry connected Windows source qualification закрыта; known-floor/dependency
  source closure подтверждена S01 review. Runtime activation, shipping/owned
  clients и sustained lifecycle остаются открыты.
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
