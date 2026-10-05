# Текущая очередь Deep / XPoint

Обновлено: **2026-10-05**. Branch baseline: `release-candidate/prod-20260909`;
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

Цель ближайшего результата — contact → двусторонний text → restart.
**Единственная активная подзадача сейчас — S00: remaining Protocol production
source/package failure и его реальные зависимости.** Повторный source gate
2026-10-05 завершился exit1 на MAU2 в ProductionMailboxAuthorityCodec;
это retained consumer, а не основание переименовать строку или ослабить gate.
Последующие этапы содержат уже реализованные части, но не являются параллельными
активными задачами. Частичная реализация в таблице не означает активную задачу
или приёмку. Следующий этап берётся после проверки его зависимостей по
единому DAG; connected probes сами по себе этап не закрывают. Новые независимые
slices (включая вложения/группы) до text сценария не открываются. Полностью
принятых этапов0/14, physical matrix0/4; это конечная приёмка, не процент
написанного кода. Частичные проценты этапов без фиксированного знаменателя
не назначаются; завершение локального slice не означает завершение этапа.

В S00 удалён разрешённый DR-0093 route-control leaf и неактивный Node adapter,
не заменяющий текущую MCG3 authority. Registry consistency и сборки Protocol,
Shared, Node/Registry проходят без warnings/errors; focused Protocol routes14/0/0,
registry10/0/0 и Node94/0/0. Новый Protocol full2005/1/7 terminal1 всё ещё
останавливается на MAU2 actual-package/source. Первый Node full1213/3/0 завершён
terminal1; три отказа на начальной setup/budget границе не повторились в
изолированных9/0/0 на тех же бинарниках и без изменения ограничений.
Последовательный unfiltered full без concurrent build завершён terminal0:
1216/0/0 (862 integration,107 profile,247 unit), на тех же бинарниках и без
изменения runtime/budgets/assertions. MAUI Core Release, Windows ARM64 Debug
и Android Debug сборки zero-warning; Clean95/0/0 и Smoke119/0/0 terminal0.
Это source consumer checks, не Release composition или physical E2E.
[Точный scope и receipts](../deep-protocol/docs/testing/s00-contact-baseline-2026-10-03.md#authorized-route-control-leaf-retirement-2026-10-05).
S00, shipping/physical и релиз этим leaf не закрыты.
Leaf зафиксирован и branch remote refs проверены: Protocol `2ae11346af2d1c691627e395702ac78fc1210ef8`,
Node `6e0095fa4fcef89bbc527bc3fbc5018cc72f7900`; повторный full Node1216/0/0.
Root `ae17380b71c12aa8b759132886fa1d45499a8dc0` также проверен по remote ref.
Upload не означает приёмку S00, deployment или готовность релиза.

Завершённая Node подзадача того же S00 удаляет13 неиспользуемых development-composition
типов. Два live admission limiter и четыре нейтральных теста перенесены дословно;
нейтральные transport assertions сохранены. Current-host reject проверен и для
disabled старой environment-конфигурации. Focused67/0/0 и real-Xray smoke terminal0;
новый обязательный unfiltered full завершён terminal0:1240/0/0
(861 integration,107 profile,272 unit). Commit XNode
`65fdf1fa7163b3ae0013af0710c797590675c990`; прежний1233 эти правки не квалифицирует.
Последовательные Registry build zero-warning
и connected grant/native cycle1/0/0 завершены; это не новый Registry full.
[Scope и receipt](../xnode/docs/testing/s02-retired-forwarding-2026-10-04.md#s00-continuation-retired-development-composition-removal-2026-10-05).

Protocol documentation-only `739cc5325117e8afc249912086d85d9c9f53cdce`
фиксирует focused native-проверки на свежей source-сборке: на Windows ARM64
и x64 process по6 state-machine и3+3 wrapper cases, без C++/Rust rebuild.
x64 выполнялся под эмуляцией на том же ARM64 хосте. Это не новый Protocol full,
Android или physical E2E. Operator capture и source/package blockers открыты.
[Граница и receipts](../deep-protocol/docs/testing/s00-contact-baseline-2026-10-03.md#explicit-windows-native-execution-2026-10-05).

Default Windows native discovery исправлен в Protocol
`83a0f32656d1cc5315b548c3488111cc6fa05886`: пять state-machine cases
выполняются без локальной Rust-сборки/explicit input, через approved loader.
ARM64 и x64 focused6/0/0; missing explicit input fail-closed, не fallback/skip.
Новый whole-solution Protocol full2121/1/7 (main1885/1/7, routes131/0/0,
carrier105/0/0), terminal1: actual-package MCG2 остаётся единственным failure.
Это закрытие omission harness, не source/package GO или приёмка S00.
[Scope и receipts](../deep-protocol/docs/testing/s00-contact-baseline-2026-10-03.md#default-windows-native-discovery-correction-2026-10-05).

Точечный actual-package recheck Protocol на той же source matrix:0/1/0,
terminal exit1, MCG2 в compiled assembly. [Команда и TRX/hash](../deep-protocol/docs/testing/s00-contact-baseline-2026-10-03.md#focused-recheck-2026-10-05).
Оба воспроизведённых отказа относятся к remaining legacy graph; runtime и gates
в этом recheck не менялись. Полные suites повторно не запускались.

Текущая S00 очистка XNode удаляет29 compiled PMA1/PMR1
provider/cache/fanout типов и их отдельный retired-runtime corpus. Whole solution
source-cutover build: exit0,0 warnings/errors. Три capacity codec cases сохранены,
добавлены29 actual-assembly absence cases. Focused current host/admission/peer
проверка завершена terminal0:287/0/0,28m53s. Новый unfiltered full завершён
terminal0:1233/0/0 (854 integration,107 profile,272 unit). Downstream Registry
build zero-warning и connected grant/native cycle1/0/0 также завершены;
это не новый Registry full. Real-Xray Docker smoke и трёхнодовый rehearsal на этих исходниках
завершены exit0; contact503 без authority не квалифицирует доставку. Предыдущий
full1301 относится к Node `f2ef177`, не к этой изменённой source matrix.
[Точный scope](../xnode/docs/testing/s02-retired-forwarding-2026-10-04.md#s00-continuation-compiled-pma1-providercache-removal-2026-10-05).
Protocol governance/membership consumers и его source/package gate failures
этой node-only очисткой не исправлены; S00 остаётся открыт.

Removal batch зафиксирован локально: XNode
`b565337603434ca2df08cd9abd91ff28c8e289d6`, Protocol documentation-only
`981ab767a61c5b364eea7472fe623d12bc24750d` (runtime по-прежнему `d1ccb573`),
Registry unchanged `f47ca7510dcf04ff59235387ccce66662c19f620`.
Нейтральные capacity cases сохранены; superseded node ADR больше не содержит
старой инструкции активации. Root pointers обновляются после этих child commits.
Local commit не доказывает upload: точный branch HEAD проверяется отдельно
через remote ref. Package publication, deployment и Release этим batch не выполнены.

Последний завершённый локальный batch исправил cold explicit enrollment: bounded input
capture/reject → protected head restore → explicit observer acquisition →
native enrollment. Readiness не получает nonce и не enroll-ит host. Actual
Registry HTTPS producer → configured compiled node DI/native custody →
signed successor → cold reopen/stop проверены; Node focused76/0/0 terminal0.
Полный Node новых command/runtime bodies1301/0/0 завершён terminal0;
предыдущий1297 к ним не переносится.

Тот же Registry TLS ceremony теперь запускает actual Program с сохранённой
custody и настоящими hosted services, а не подставленным native endpoint.
Configured ONION receive acquisition восстанавливает readiness; rollback
monotonic clock возвращает503 и сохраняет signed floors. Connected focused1/0/0
и новый unfiltered Registry347/0/7 terminal0. Xray/heartbeat здесь отключены;
тестовые clock/TLS trust и synthetic signed inputs не квалифицируют carrier,
shared443/proxy, peer data cycle или устройства. Smoke/rehearsal terminal0
проверяют real Xray отдельно; contact503 в них не является доставкой.

Точные source scopes, TRX/hashes, прежние failures и результаты —
в [существующем lifecycle checkpoint](../xnode/docs/testing/s05-mgr1-lifecycle-2026-10-04.md).
Unexplained Registry HTTP503/native Windows denial не объявлены исправленными.
S01/S04 lifecycle, configured peer/client edges и shipping composition остаются
открыты. Исправление регрессии и локальные control/startup проверки завершены;
connected data/client граница относится к text вертикали после её prerequisites.
Локальный commit не равен push/deployment/Release.

В этой же границе actual private Registry issuer → real HTTPS → compiled XNode
forwarder → independent client verifier → configured native Store/Retrieve/ACK
и cold reopen проверены. Оба issuer role winners проходят actual configured
proof/network/native owners; peer replication использует signed actual origins и
real pinned TLS/H2. Exact Store/ACK retry не вызывает новых peer RPC и не
воскрешает объект. Registry focused1/0/0 и final unfiltered348/0/7 terminal0;
whole Release build zero-warning.
[Scope/receipts](../deep-registry-api/docs/testing/s05-mgr1-signer-bound-2026-10-04.md#connected-private-grant-exchange-2026-10-05).
Synthetic resolver attestations/holder/ciphertext и TestServer route proof не
квалифицируют actual resolver authorization, protected Shared installation/E2EE,
полный Program/selected ONION или devices. После prerequisites нужно связать native
data cycle с owned client и masked selected-entry той же вертикали; S05 не закрыт.

Локальная source matrix этого batch: Protocol
`d1ccb573d552960f0c1cb21a655483f4065e74d5`, Registry
`f47ca7510dcf04ff59235387ccce66662c19f620`, XNode
`f2ef177754369bc0da589c5f5db3e2f14c95fd9b`. Остальные child HEAD не изменены.
Batch зафиксирован локально; его source gates не доказывают upload или deployment.
Connected data/client граница остаётся
открытой, но enrollment fix завершён и повторно не реализуется.

| Этап | Текущий статус | Что закрывает |
| --- | --- | --- |
| S00 | **Единственный активный этап: current route-control removal Node focused94/0/0; первый full1213/3/0 terminal1, изолированный повтор9/0/0 и последовательный full1216/0/0 terminal0 без изменения бинарников/ограничений. Protocol full2005/1/7 и source gate сохраняют MAU2 blocker. Downstream builds zero-warning; прежние HTTP503/native Windows denial не квалифицированы** | [Текущая removal matrix и receipts](../xnode/docs/testing/s02-retired-forwarding-2026-10-04.md#s00-route-control-consumer-removal-2026-10-05), [Protocol removal и remaining graph](../deep-protocol/docs/testing/s00-contact-baseline-2026-10-03.md#authorized-route-control-leaf-retirement-2026-10-05), [Owned custody](../deep-client-shared/docs/testing/s00-one-time-custody-2026-10-04.md). Legacy authority/package/recovery graph, native/capture omissions, public one-time export, installed matrix и activation открыты |
| S01 | **Частично реализован, не активен: DR-0083/0084/0086/0087/0092; native operation custody и startup/readiness hook реализованы; host15/15, Program HTTP3/3, connected239/239. Node reproduction1205/0/0 завершён по TRX; исходный setup PartialFailure1204/1/0 не классифицирован. Независимые Store floors: Shared focused32/32, signed Protocol22/22; full Shared564/0/0 завершён, full Protocol2087/1/12. Shipping consumers не активированы** | [Store floors](../deep-client-shared/docs/testing/s01-owned-counter-floors-2026-10-04.md), [host recovery](../xnode/docs/testing/s01-host-recovery-2026-10-04.md), [revocation contract](survival-program/decisions/DR-0083-current-mailbox-grant-revocation.md), [client semantic contract](survival-program/decisions/DR-0084-owned-delivery-settlement-and-retirement.md), [operation custody](../xnode/docs/testing/s03-operation-custody-2026-10-04.md), [receiver custody](../xnode/docs/testing/s03-host-custody-2026-10-04.md), [Protocol evidence](../deep-protocol/docs/testing/s01-mailbox-revocation-2026-10-03.md), [native evidence](../xnode/docs/testing/s01-mailbox-revocation-native-2026-10-03.md), [settlement boundaries](../deep-client-shared/docs/testing/s01-settlement-boundaries-2026-10-03.md); complete current Program/DI, global recovery, остальные client retirement formats/API, compaction/renewal, object horizon и application receipt contracts открыты |
| S02 | **Current DI и actual Program peer pipeline: focused24/24; после enrollment batch full1238/0/0 terminal0. Store/Retrieve/ACK, pinned TLS/H2, cold replay и HTTP guards проверены. Активация заблокирована S01** | [Current Program и exact evidence](../xnode/docs/testing/s02-current-program-2026-10-04.md), [current full](../xnode/docs/testing/s05-explicit-mailbox-enrollment-2026-10-04.md), [admission](../xnode/docs/testing/s02-current-mailbox-admission-2026-10-03.md). Реальный Program pipeline получает fixture-owned native endpoint; это не configured network observer или ONION/device qualification. Production source/provisioning, global recovery, retained-route/lifecycle и physical endpoints остаются открыты |
| S03 | **Current native peer/quorum, protected custody и Program HTTP cycle проверены; focused24/24, current full1238/0/0 terminal0. Activation открыта** | [Current Program](../xnode/docs/testing/s02-current-program-2026-10-04.md), [current full](../xnode/docs/testing/s05-explicit-mailbox-enrollment-2026-10-04.md), [receiver custody](../xnode/docs/testing/s03-host-custody-2026-10-04.md), [operation custody](../xnode/docs/testing/s03-operation-custody-2026-10-04.md), [writer checkpoint](../xnode/docs/testing/s03-mailbox-writer-2026-10-04.md), [matching client](../deep-client-shared/docs/testing/s03-mailbox-writer-2026-10-04.md), [current ACK](../xnode/docs/testing/s03-current-ack-2026-10-04.md). Previous full1222/1/0 исправлен без удаления actual pin/lock assertions. ACK setup timeout не повторился, но причина не установлена. Whole-host recovery, deployed provisioning, retained-route/retirement/object horizon открыты; не physical E2E |
| S04 | Заблокирован S01 | Expiry/renewal, unknown outcome, bounded journals |
| S05 | **Actual HTTPS producer → configured proof/network/native enrollment → signed successor → cold reopen/stop → actual Program startup/readiness проверены на synthetic inputs. Private grant issuer→HTTPS forwarder→client verifier→configured native Store/Retrieve/ACK/cold reopen проверен; Registry full348/0/7, Node full1301/0/0 в исходной matrix slice; текущая Node cleanup full1233/0/0 terminal0. >64 successors и observational authority проверены. Этап открыт** | [Текущий lifecycle](../xnode/docs/testing/s05-mgr1-lifecycle-2026-10-04.md), [предыдущее enrollment](../xnode/docs/testing/s05-explicit-mailbox-enrollment-2026-10-04.md), [signer/grant boundary](../deep-registry-api/docs/testing/s05-mgr1-signer-bound-2026-10-04.md). Полный Program/selected-entry/owned client cycle, deployed provisioning/shared443/proxy и bounded deployed acquisition остаются открыты. Это не production activation или physical qualification |
| S06 | Не пройден | Два настоящих клиента через real selected-entry/replica endpoints |
| S07 | **Не активен; read-only local history реализована: Shared focused3/3 и full564/0/0 terminal0, MAUI Clean95/95, smoke119/119. Этап не закрыт** | [Scope/evidence](../deep-client-shared/docs/testing/s07-local-history-2026-10-04.md). Fresh authority остаётся обязательной для mutations; scheduler, offline queue, AppAck/read и полный 1:1 event/UI scope открыты. Default Windows zero-warning build не квалифицирует HTTPS/Release/device composition |
| S08 | **Release composition отсутствует** | Shipping graph без diagnostic-only flag и physical text/receipts |
| S09 | Не квалифицирован | Sustained delivery, restart/rotation/offline recovery на той же identity |
| S10 | Local attachment custody есть; remote flow не закрыт | Remote files/images/video/voice/avatar, integrity/resume/UI |
| S11 | Кодеки/старые harness не закрывают current DID2 app path | Multi-device/history и governed groups |
| S12 | Отдельные компоненты; полный scope не квалифицирован | Carriers/bootstrap/push и relay-only calls |
| S13 | Заблокирован release requirements | Одна artifact matrix, полный evidence catalog и reviews |

Зафиксированный S00/B8 signed publication batch: Protocol `73f045491c7ca59dfcfdab21d161703e9df21238`,
Registry `1f20f973a57378b78b536a84711a85a39a6341e6`,
Shared `59eba8b7ddfd9090a99df51021c72e02b5da394c`,
XNode `80b605e074a4125a27fff1cf2f47965ecc8b5494`.
Full Shared 547/547, Node 1129/1129 / 0 skips. Connected selection 53/53;
Registry full 331 pass / 0 fail / 6 skips, Protocol full 2079 pass / 1 fail /
12 skips. Consumer проверяется через source-cutover, не через опубликованный
package или установленный client. Signed one-time publication/node claim теперь
имеют actual producer/consumer; package graph и весь shipping B8 не закрыты.
Evidence: [publication checkpoint](../xnode/docs/testing/s00-one-time-publication-2026-10-04.md).
S02/S03 checkpoints сохраняют свои исходные matrix/evidence; новый batch не
активирует Program/DI, production provisioning, QR или physical E2E.

Последующий **Node-only native terminal batch**: XNode
`3ce981bb750b3465377a418c0d5ddf363343a19f`, остальные child HEAD неизменны.
Полный XNode 1142/1142 / 0 skips, focused30/30, warnings-as-errors build
без warnings/errors; real-Xray smoke и three-node rehearsal завершились exit0.
Полный integration763 занял30m45s. Старые17 ingress fixture cases заменены29
current cases плюс sealed three-hop1; default full graph не сокращён.
[Exact scope/receipt hashes](../xnode/docs/testing/s02-native-terminal-2026-10-04.md).
Onion peer calls в этом scenario in-process; mailbox peer использует actual TLS/H2.
Docker health/transport не доказывает current contact/mailbox или installed matrix:
contact503 остаётся fail-closed. Program/DI, lifecycle и physical E2E открыты.

Текущая DR90 source matrix: Protocol
`b98698b8b12a5fafefd822d3ee33b4d0d176d9df`, XNode
`b7c34e693b6508853bd5c5deff80ee3b54e2a744`; остальные child HEAD неизменны.
Node code gate выполнен на `a7488b968223b1f23e280467938f5c8d8375a10b`,
последующий Node commit меняет только checkpoint после terminal0.
Полные результаты старых matrix не переносятся на этот slice; свежие focused,
Protocol/downstream/smoke receipts и full Node1161 — в его checkpoint.

## Блокеры, которые нельзя потерять

Последующий connected contact source batch: Protocol
`de091f1c87088636f5548fc21e219d28ef0732e6`, XNode
`66f3f426e51ba86bd7881fd42b39fcc3ffa1e54e`; остальные child HEAD неизменны.
Final reviewed contact assertions7/7, real TLS/H2/lost-response/reopen/resolve,
wrong pin/descriptor signatures и current Registry route evidence проверены
локально. Node default full1173/1173 и Shared production full547/547 завершены,
terminal0 без skips; результаты относятся к этой матрице, не subsequent source.
Protocol full2079/1/12 сохраняет прежний package fail MCG2, source gate MAU2.
Новый real-Xray smoke/three-node rehearsal terminal0 не квалифицирует current
contact в Docker: там missing-authority contact503. Это checkpoint прогресса,
не готовый installed release или отмена B1–B8.

Предыдущий private authority-hop source: XNode
`16a2c4c474daa55f33a7dd55140f9769fd5f86bb` (code gate на
`9f9be67cc87a5a3bdc590fc914dde65ab81b1278`, subsequent checkpoint-only commit), DevOps
`54fc3ab6911b8dc2f8cfa97dd7b767c2172cdc44`; Protocol/Shared/Registry из предыдущей
матрицы неизменны. Final focused61, approved vendor-package profile107, locked
ProfileGenerator restore и full solution zero-warning Release build проходят.
Root documentation174 / CONTACT / crypto / ONION / governance ClassificationOnly,
final scoped source/docs/TRX scan22 и real-Xray smoke/three-node rehearsal проходят.
Новый default full Node1187/1187 завершён terminal0 без skips:
unit272/profile107/integration808. DevOps harness16/16 и release-gate contracts51/51
проходят; actual production-readiness exits1 с10 missing-evidence blockers, не
release pass. Предыдущий full1173 не evidence нового Node source.

Текущая account-owned one-time custody matrix: Protocol
`6afceb2fc457b2df9ea207f542204de945cbb746`, Shared
`13c9b3da35bb94c8690b15d7c320c21885960da3` (code gate на
`975190365838d63359ce91a6ada899a48b2a7e95`, subsequent checkpoint-only commit);
XNode/Registry/DevOps неизменны.
По [DR-0091](survival-program/decisions/DR-0091-did2-owned-one-time-custody.md)
connected internal owner сохраняет exact DIA1/ciphertext до publication,
восстанавливает AEAD/current authority и завершает retained genesis без remint.
Final Shared focused5 и downstream Node94 проходят terminal0 без skips;
full Shared552/552 завершён terminal0 без skips,39m39s; старые547 не evidence
новой матрицы. Final scoped source/docs/TRX scan28 включает полный Shared receipt.
Protocol full2080/1/12 сохраняет package failure MCG2 и source gate MAU2.
[Exact scope/evidence](../deep-client-shared/docs/testing/s00-one-time-custody-2026-10-04.md).
Это local source integration, не shipping export, deployed/physical E2E или
закрытие всего B8; full Node1187 принадлежит предыдущей source matrix.

- **B1:** Protocol/Shared перешли к DR-0081, node Program всё ещё подключает
  retired mailbox authority и не регистрирует current receiver/coordinator.
  `NativeMailboxExitDispatcher` уже вызывает только current Store/Retrieve/ACK
  с required protected operation owner, без retired adapter/ready-DTO fallback;
  missing/split composition не включает runtime. Sealed three-hop local scenario
  и два independent TLS/H2 mailbox stores проходят отдельный 1/1 check,
  [final native-terminal gates](../xnode/docs/testing/s02-native-terminal-2026-10-04.md)
  прошли: focused30/full1142, zero-warning build и real-Xray transport rehearsals;
  [Actual startup/readiness hook](../xnode/docs/testing/s01-host-recovery-2026-10-04.md)
  теперь соединён с non-enrolling operation recovery; complete current Program/DI,
  global historical recovery, lifecycle и installed/physical endpoints не закрыты.
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
- **B4:** network reconnect не draining outbox/inbox; read-only local history
  отделена от fresh proofs в Shared и diagnostic UI, focused/full UI проходят,
  новый full Shared ещё выполняется. Offline queue и AppAck/read события не
  включены в текущий DID2 consumer.
- **B5:** messaging DI зависит от diagnostic flag, запрещённого для Release;
  исходники исключённых services не доказывают shipping functionality.
- **B6:** signed PMA2/PMT2 successor provisioning, current issuer readiness,
  package/API/resource/evidence repin и actual installed matrix требуют проверки.
- **B7:** files/groups/calls/multi-device/carriers/full release evidence остаются
  обязательными согласно [V1 scope](architecture/V1-RELEASE-SCOPE.md).
- **B8:** owned kind-2 route/object/AEAD restore по DR-0088 и matched signed
  publication по [DR-0089](survival-program/decisions/DR-0089-did2-one-time-publication-coordination.md)
  реализованы в local connected path. Registry scope теперь различает независимые
  приглашения, а actual signed node publication/claim/replay/AlreadyClaimed
  проходит в [53-case selection](../xnode/docs/testing/s00-one-time-publication-2026-10-04.md).
  Client one-time commit verification по
  [DR-0090](survival-program/decisions/DR-0090-did2-one-time-publication-commit-verification.md)
  реализован: [focused27/27](../xnode/docs/testing/s00-one-time-commit-2026-10-04.md),
  actual two-store commit/claim и отдельные distinct descriptor ID/key positives.
  Исправлены проверки всех protected clock observations; old ID-as-key подписи
  отклоняются. Full Node1161 прошёл; Protocol сохраняет единственный package
  failure MCG2 и production source gate MAU2. Реальный
  contact receipt producer/facade, authenticated peer HTTP и permanent-contact read
  verifier теперь используют independently signed descriptor keys в
  [connected contact batch](../xnode/docs/testing/s00-contact-descriptor-2026-10-04.md).
  Publish/lost-response/reopen/resolve проходят через actual TLS/H2 loopback;
  wrong pin/foreign signatures отвергаются. Final reviewed assertions7/7,
  этот full Node1173 и Shared production547 завершены terminal0 без skips.
  Последующий [private authority-hop batch](../xnode/docs/testing/s00-private-authority-2026-10-04.md)
  убрал оба node-ID/key alias guard в grant и route/publication HTTP clients:
  actual verified descriptor/selected placement перед HTTP и currentness после,
  unchanged DR48 public-key headers и grant node-ID transcript. Connected61/61 и
  host Release zero-warning build и новый full Node1187/1187 проходят без skips.
  Fresh isolated restore выявил другой global-cache content hash; vendor archive
  соответствует lock; fresh solution restore/build и отдельный locked
  ProfileGenerator restore/profile107 с task-owned package cache проходят без
  repin или ослабления проверки. Endpoint provisioning и installed matrix не закрыты.
  Account-owned one-time secret pending/winner custody, retained genesis
  completion и exact restore теперь соединены с internal service/commit path
  по [DR-0091](survival-program/decisions/DR-0091-did2-owned-one-time-custody.md):
  один current journal10 без старого reader. Connected5/5 проверяют crash/reopen,
  read-back faults, hostile storage и capacity до callbacks; новый full Shared
  552/552 завершён terminal0 без skips. Public account-owned invitation operation/QR export и installed
  artifacts остаются gated; нельзя объявлять внутренний producer shipping API.
  Incomplete intent после expiry короткого request/XPA
  требует явного lifecycle/reconciliation по S01/S04, а не нового nonce или
  увеличения срока старой подписи. Matched provision/installed artifacts и physical contact
  E2E ещё не проверены; usage-limit toggle и DIA1/key в threshold запрещены.

`OfficialXPoint3` не передаёт данные при отсутствии одного обязательного узла;
S09 проверяет сохранность и автоматическое восстановление после возврата.
Расширение topology — отдельное решение, а не скрытый fallback.

## Следующий запуск Codex

Текущий узкий фокус указан перед таблицей этапов; следующие checkpoints —
контекст уже сделанных изменений, не задания на новый параллельный фронт.
Terminal полного Shared552 на прежней custody source matrix получен.
Public account-owned invitation operation/export B8 и package/evidence
closure остаются обязательными, сохраняя
quota/replay/rotation/recovery assertions. DR-0089 уже соединяет public locator,
signed request, invitation-specific Registry reservation и actual node claim.
Нельзя выдавать этот local connected path за shipping export/device evidence:
Client two-replica commit verifier реализован по DR90; connected contact descriptor
matrix имеет full Node1173/Shared547. Receipt-key composition исправлена локально,
private HTTP-hop distinct ID/key consumer имеет focused61 и full Node1187;
не повторять эти исправления по старому статусу. Package graph и deployed
provisioning открыты. Bounded protected secret custody с retained genesis
completion и exact AEAD restore реализована по DR91 и проверена focused5;
не повторять её по старому статусу. Public owned operation требует отсутствия
raw-key import/remint; matched install/QR/device gate выполняется после рабочего
S06/S08 path по единому DAG, а не становится prerequisite реализации S01.
Первый text-сценарий использует существующий постоянный контакт; одноразовый
export не исключён из release scope, но не должен задерживать этот сценарий.
Package legacy удаляется вместе с заменой реальных consumers, не косметическим
удалением MCG2/MAU2 строк или ослаблением gate.
Не добавлять old-envelope readers и не передавать DIA1/key свидетелям.
[Node baseline](../xnode/docs/testing/s00-node-baseline-2026-10-03.md)
содержит исходную классификацию. Новый
[native replacement checkpoint](../xnode/docs/testing/s00-native-replacement-2026-10-03.md)
связал concurrent non-success с actual Windows error 5, проверил bounded retry
на native locks и сохраняет постоянный отказ как uncertainty. Это не определяет
процесс, вызывающий denial, и не обещает успех при любой storage failure.

Текущий **S01** startup/readiness slice от DR-0083/0084/0086/0087 соединён
с actual Program на XNode `77c946eefbd117ece248c7909aa8f6782b1aa4e3`:
обе role leases, independent operation custody и запрет auto-enrollment сохранены.
Focused host recovery15 и actual Program HTTP3 проходят; zero-warning Release
build и final-source real-Xray smoke/three-node rehearsal проходят. Connected
terminal239/0/0; full1204/1/0 сохраняет один необъяснённый setup PartialFailure
до ACK/revocation branch. Изолированный ACK1 и startup selection20 проходят,
но не определяют причину. Diagnostic-only checkpoint XNode
`5d4c5d545b62ed0c98e99ddaf9b09dcd405b7d4f` сохраняет строгие assertions,
runtime и deadlines; полный reproduction завершён1205/0/0 по трём terminal TRX.
Original test-process exit handle утрачен, watcher exit0 не подменяет его.
Причина исходного setup PartialFailure остаётся неизвестной; это не доказательство
исправленного runtime bug. Reproduction использует прежние dependency binaries,
а не последующий Store-floor source.
Node1187 предыдущей матрицы не подменяет новый gate.
[Scope/evidence](../xnode/docs/testing/s01-host-recovery-2026-10-04.md).
Hook не регистрирует complete current receiver/coordinator graph и не проверяет
все historical blobs/mutations. Не повторять hook вместо продолжения **S01**:
Независимые protected Store floors по
[DR-0092](survival-program/decisions/DR-0092-did2-owned-mailbox-counter-floors.md)
реализованы в существующем root без второго журнала/legacy reader. Shared focused32
проверяет actual owner rollback/signing и exact retry при полной capacity;
Protocol signed namespace22 проходит. Full Shared564/0/0 завершён terminal0 на
финальных пересобранных зависимостях; full Protocol2087/1/12 сохраняет MCG2 package failure,
source graph MAU2 и отдельные evidence skips. Не повторять floor implementation
вместо продолжения интеграции. Остальные settlement/retirement formats/API,
compaction/renewal и единый object-horizon/retained-route Retrieve/ACK activation
fence остаются следующими открытыми требованиями.

Зафиксированная Store-floor source matrix: Protocol
`8989ad6a787cdc8194106a5130fcfa832608e252`, Shared
`f60e03406790564b037fdeab3e89faca41dfb46b`, Node
`d07f930720e049233698548a634b05c46a04b942` (только terminal reproduction checkpoint).
Финальные Protocol/Shared и downstream XNode host Release builds — zero-warning,
terminal0; strict registry и dry repins согласованы. Root documentation174 и
precommit scoped secret scan23 проходят. Новая source matrix не активирует
Program/DI, release packages, production provisioning или physical endpoints.
Matching canonical writer client exit и native Store/peer rejection уже проверены;

Предыдущая late-initial-pin source matrix: XNode `5c1509fb42225fd1d0a3141b587522252aef0278`
(terminal checkpoint; product source `200313a4f2c1c0c99d6770dc685fa95b7e157e89`;
late MGR1 initial pin; selected286/0/0 terminal0;
[checkpoint](../xnode/docs/testing/s05-mgr1-lifecycle-2026-10-04.md)),
Shared `b238fb4f9bc750185e4fc431b1bf4ae6f33c2b1f`
(terminal checkpoint; product source `42aee0d8358d552f43bee256e0fb52cc1ab45e3b`),
MAUI `56065e0bf311f6b61aa22bf693792d6256951c03`,
Protocol `d0c3f9d2dd053f9bb04411c41766e4e8b7098261` (selected62/0/0 terminal0).
Registry `75aba0c19eb9e6fabd061da2febe38207715df52`
(checkpoint; product source `dac2c5fd180ac03400a381ccfa7c320d326065c6`).
DevOps `e484335e5615d017c0579d9c5277f9f486a0f81f` и installer
`df5fa6127cbd46d8212335adf645326484e922db` не менялись.
Предыдущий unfiltered Node1224/0/0 завершён terminal0 на product source
`d821f8cc2cb7f85458dbce651f638b236901641b`; actual Program peer cycle и scope —
в [checkpoint](../xnode/docs/testing/s02-current-program-2026-10-04.md).
Предыдущий explicit enrollment source `b3d37807993b83f705149d319622fc7da0923dd6`
проходит focused32/32, unfiltered full1238/0/0
terminal0 и последовательные real-Xray Docker smoke/rehearsal.
Предыдущие1224 не подменяют enrollment receipt;1238 не квалифицируют последующее
удаление forwarding или новый late-initial-pin source. Предыдущий forwarding
checkpoint `3d8ace0741fe0615a7d9c87e9f82c7b1b0f0c639` на product
`8298161fb0a1afadf7eefff38ecffbfadd14a178` имеет focused74/0/0, smoke/rehearsal0
и unfiltered full1243/0/0; они не переносятся на текущую source matrix.
Existing key ring и fresh signed initial snapshots по DR-0083 обязательны;
normal startup не enroll/repair. Issuer production
authoring/distribution/renewal и actual source socket qualification открыты:
[enrollment evidence](../xnode/docs/testing/s05-explicit-mailbox-enrollment-2026-10-04.md).
Максимальный canonical MGR1 signing input теперь проходит actual Unix socket;
полный Registry source с isolated PostgreSQL —331/0/7, Linux7/0/0 закрывает эти
семь platform skips отдельно. Статические bounds/EOF/deadline/signature checks
не ослаблены. Старый fixture literal9 заменён current owner version без старого
reader; все crash/retry/exact-winner проверки сохранены. Source-cutover full
build —zero-warning. Это не shipping packages или physical transport:
[Registry evidence](../deep-registry-api/docs/testing/s05-mgr1-signer-bound-2026-10-04.md).
Новый local-history slice проходит Shared focused3, MAUI Clean95/smoke119 и
default Windows zero-warning compilation; новый полный Shared564/0/0 завершается
terminal0,33m21s на неизменённом source. Предыдущий Shared564 не подменяет этот receipt.
[Read-only evidence](../deep-client-shared/docs/testing/s07-local-history-2026-10-04.md)
не закрывает scheduler/queue/AppAck, S06/S08 или physical0/4.

Далее закрыть necessary local floor/format/API
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
