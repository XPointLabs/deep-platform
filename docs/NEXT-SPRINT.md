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
| S00 | **В работе: account-owned one-time custody5/5, полный Shared552/552 без skips и Node downstream94/94; Protocol full2080/1 package fail/12 skips. Предыдущая private-hop matrix: Node1187/1187, Registry331/0/6 Windows skips** | [Owned custody](../deep-client-shared/docs/testing/s00-one-time-custody-2026-10-04.md), [contact descriptor matrix](../xnode/docs/testing/s00-contact-descriptor-2026-10-04.md), [private HTTP authority-hop](../xnode/docs/testing/s00-private-authority-2026-10-04.md), [Registry baseline](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md). Старые full/build/restore scopes не переносятся на новую source/installed matrix. Root CONTACT/crypto/ONION, governance ClassificationOnly и documentation174 проходят; Protocol package/source graph, public one-time export, installed matrix и activation открыты |
| S01 | **В работе: DR-0083/0084/0086/0087; native operation format/host-only recovery реализованы; current mailbox/MGR 198/198, 13 новых receiver custody cases проходят; предыдущий focused custody 30/30; Protocol revocation/floor 49/49, settlement boundary/registry 26/26; native MGR custody 29/29; Shared exact unknown retry при 512 occupied slots проходит, последний full 547/547; shipping consumers не активированы** | [Revocation contract](survival-program/decisions/DR-0083-current-mailbox-grant-revocation.md), [client semantic contract](survival-program/decisions/DR-0084-owned-delivery-settlement-and-retirement.md), [operation custody](../xnode/docs/testing/s03-operation-custody-2026-10-04.md), [receiver custody](../xnode/docs/testing/s03-host-custody-2026-10-04.md), [writer checkpoint](../xnode/docs/testing/s03-mailbox-writer-2026-10-04.md), [recovery checkpoint](../xnode/docs/testing/s03-store-recovery-2026-10-04.md), [Protocol evidence](../deep-protocol/docs/testing/s01-mailbox-revocation-2026-10-03.md), [native evidence](../xnode/docs/testing/s01-mailbox-revocation-native-2026-10-03.md), [settlement boundaries](../deep-client-shared/docs/testing/s01-settlement-boundaries-2026-10-03.md); whole-host startup/health/DI, client retirement formats/API, compaction/renewal, object horizon и application receipt contracts открыты |
| S02 | **Native terminal вызывает current Store/Retrieve/ACK с actual protected owner; focused ingress/sealed three-hop 30/30; активация заблокирована S01** | [Native terminal](../xnode/docs/testing/s02-native-terminal-2026-10-04.md), [admission](../xnode/docs/testing/s02-current-mailbox-admission-2026-10-03.md), [receiver custody](../xnode/docs/testing/s03-host-custody-2026-10-04.md), [writer](../xnode/docs/testing/s03-mailbox-writer-2026-10-04.md), [descriptor keys](../xnode/docs/testing/s03-descriptor-keys-2026-10-04.md), [Retrieve](../xnode/docs/testing/s03-current-retrieve-2026-10-04.md), [ACK](../xnode/docs/testing/s03-current-ack-2026-10-04.md): оба protected role floor, current source/time, holder/body и реальные replay/outcome/mutation/blob owners. Store только у ranked writer; Retrieve/ACK обеих реплик сохранены. Same-owner scope исключает повторный захват native floor locks; missing/split DI не допускает старый fallback. Sealed three-hop calls локальные, mailbox peer использует реальный TLS/H2. Program/DI, retained-route/lifecycle и physical endpoints остаются открыты |
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
  Program/health, lifecycle и installed/physical endpoints не закрыты.
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

Продолжить **S00**: terminal полного Shared552 на текущей custody source matrix
получен. Public account-owned invitation operation/export B8 и package/evidence
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

Следующий connected runtime slice — **S01** от DR-0083/0084/0086/0087:
соединить existing host-only recovery с actual startup/readiness, сохраняя обе
role leases, independent operation custody и запрет auto-enrollment. Whole-host
checks не дают activation до закрытия lifecycle/retained-route/horizon fences.
Matching canonical writer client exit и native Store/peer rejection уже проверены;
далее закрыть necessary local floor/format/API
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
