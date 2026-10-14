# Текущая очередь Deep / XPoint

Обновлено: **2026-10-14**. Branch: release-candidate/prod-20260909.
Владелец, если не указан иной: **Mr. X**.

Единственный порядок, зависимости и критерии приёмки —
[IMPLEMENTATION-PLAN-V1](architecture/IMPLEMENTATION-PLAN-V1.md).
Основание — [аудит](architecture/ARCHITECTURE-AUDIT-2026-10-03.md),
[DR-0082](survival-program/decisions/DR-0082-integration-first-delivery-baseline.md)
и [DR-0095](survival-program/decisions/DR-0095-baseline-and-shipping-gate-separation.md).
Этот файл содержит текущий статус, не второй protocol specification.
[Предыдущая редакция целиком](NEXT-SPRINT-CHECKPOINTS-2026-10-13.md) сохранена
как история; её промежуточные статусы не являются заданиями на повторную реализацию.

## Единственный текущий этап: S05

**S04 принят на source уровне и запушен; S05 — current issuer и operational lifecycle.**
Следующая работа ограничена критериями
[S05](architecture/IMPLEMENTATION-PLAN-V1.md#s05--current-issuer-и-автоматический-lifecycle-управляющего-контура):
current issuance/readiness/CAS, signed successor provisioning, автоматическое renewal,
retained-volume restart и bounded verified catch-up. S06 и device qualification
ещё не открыты; принятый S04 не повторять без изменения его входов.

Текущий пакет и evidence:

- Registry canonical full07 принят: **395/0/7**,402 exact mappings, все native
  stages0 и2834 unchanged inputs. Source реализует bounded renewal, immediate
  authority handover и exact prepared ADA2/CAS recovery по
  [DR-0115](survival-program/decisions/DR-0115-did2-prepared-directory-commit.md).
  Actual HTTP client/node catch-up прошёл69 signed heads через64+5 с обрывом
  и cold reopen. Readiness остаётся read-only. Scope, hashes и сохранённые FAIL —
  [Registry checkpoint](../deep-registry-api/docs/testing/s05-head-renewal-budget-2026-10-14.md).
- Node matching пакет: **139/0/0**, native0; Program/current/retained TLS-native
  scope: **3/0/0**. Исправлены no-write replay fault, повторные Windows link
  queries и bounded same-file replacement. Authority/floor/revocation fences и
  peer/ingress deadlines не расширены. **Node full принят1499/0/0**, все native
  stages0,1499 exact mappings и2180 unchanged inputs;
  [node checkpoint](../xnode/docs/testing/s05-observation-context-reuse-2026-10-14.md)
  содержит исходные failures и точные текущие scopes.
- Operator CLI сохраняет полные signed chains и три node identities, готовит
  same-key authority renewal и complete immutable bundle/NCP2. Matching69-view
  executable и wrapper contracts14/0 прошли. Это offline candidate, не fresh
  runtime: [operator checkpoint](../deep-devops/docs/S05-AUTHORITY-HISTORY-2026-10-14.md).

Пакет reviewed/committed/pushed: Registry `2df4474`, Node `2de436d`, DevOps
`c92a544` (source package `9789123` + read-only expiry diagnosis); remote SHA
всех трёх сверены. Повторный managed-external no-mock
smoke и three-node rehearsal завершились native0 и scoped cleanup; первый
Docker-engine EOF/exit1 сохранён отдельно. Это инфраструктурные, не DID2
delivery/device проверки; существующий dev health остаётся unhealthy: retained
DTS1 истёк2026-10-06T14:07:38Z, Registry сообщает `policy-interval`. State/keys
не сбрасывались; canonical decode не заменяет signature/current-authority check.
[Точный scope](../deep-devops/docs/S05-AUTHORITY-HISTORY-2026-10-14.md#infrastructure-rehearsal-attempt).

Оставшаяся приёмка S05, в порядке выполнения:

1. DR-0116 matching source qualification выполнена с сохранённым S08 package FAIL.
   Завершить current provisioning clean-break и supported signed policy renewal:
   сохранённый dev содержит pre-cutover seven-chain NCP2, а не current eight-chain.
   Не обходить отказ legacy-reader, Init/Provision/reset или ручной правкой signed
   records/floors. Закрыть supported changed-root/witness/role
   ceremony и автоматический
   head/view/key lifecycle с предупреждением offline-policy expiry. Реальная
   key rotation в source fixture не доказывает operational ceremony.
2. Проверить process/retained-volume restart, interruption/rollback, signer/time
   outage, competing generations и несколько ротаций на воспроизводимом контуре
   без ручной правки signed bytes, floors, genesis или registered identities.
3. Проверить связный issuer/node/client renewal и bounded verified catch-up;
   offline CLI, fixture clocks и cold object reopen не заменяют runtime evidence.

DR-0116 source candidate устраняет overlap-only dead end после root expiry и
разделяет offline XVP1/PMA2 horizon с коротким operational view. Protocol matching
**61/0/0**, operator executable native0 (69-view scope сохранён), publisher
Release build0/zero warnings/errors. Current matching scope **107/0/0**; common
gate contracts **46/0**. Canonical Protocol full03 завершён **2297/1/7**,2305
exact mappings,1581 unchanged inputs и explicit retirement двух superseded
`root-gap`/`dts-gap` identities без правки старых TRX. **FullAccepted=false**:
настоящий package graph отвергает retired MAU2 в старом PMA1 producer. Это S08
blocker, не разрешение переименовать его или выключить guard. Witness contract
согласован с SDK10.0.301 по DR-0117:7.6.5/.NET10/compatible architecture,
проверка MSBuild types до full. Точный текущий scope
и исходные failures —
[Protocol checkpoint](../deep-protocol/docs/testing/s05-root-continuity-2026-10-14.md).
Пакет не развёрнут; expiry сохранённого dev ещё не устранено. S04/S05 прежние
full receipts относятся к своим прежним inputs, не к этому Protocol изменению.

Dev offline `PrepareAuthority` реализован: real-signature/file fixture **20 checks**,
native0 и build0/zero warnings/errors; source topology **7/0**. Это public-only
paired-authority candidate, не online operational activation. Actual retained-dev
attempt отверг pre-cutover seven-chain NCP2 до observation/signing (native2);
610 retained views/heads/topologies не удалены, journal/floors/keys сохранены.
Ранее указанное expiry — не единственная причина unhealthy. Точные scopes и
сохранённые failures — [DevOps checkpoint](../deep-devops/docs/S05-AUTHORITY-HISTORY-2026-10-14.md#development-offline-paired-authority-preparation).
Protocol `3b94c54` и root `266393d` запушены с exact remote SHA; dev offline
source package зафиксирован в DevOps `0e3b074`. Root pointer/checkpoint обновляются
после child commit; main/GitHub Releases не менялись.

Отдельный current-only `deep-dev-current` создан без изменения старого контура.
После исправления retired config и штатной admission сохранённого observer:
current Registry proof + три verified ONION capabilities; scoped restart20s
offline →14s recovery →30s stable с прежними ключами/IDs/mounts. Real130
admissions при offline nodes и catch-up через129 signed heads прошли native0,
recovery10s без reset. Source22 checks и topology/observer10/0; это не выдача
mailbox grants или physical delivery. Offline root pair prepared, не activated.
Первый Init потерял mailbox issuer seeds; новый generator сохраняет их, но
уже созданному контуру нужен signed role/PMA successor, не подмена ключа.
Root/witness/role/traffic/TLS rotation и publisher CAS-import остаются S05.
Scope/hashes — [runtime checkpoint](../deep-devops/docs/S05-AUTHORITY-HISTORY-2026-10-14.md#separate-current-only-runtime-qualification).

DR-0118 offline issuer rollover source completed: matching119/0/0; canonical
Protocol full2309/1/7,2317 exact mappings/1583 unchanged inputs, original package
FAIL preserved. DevOps candidate30 checks and topology11/0; actual NTS preparation
emitted a signed full-history policy/PMA/traffic/TLS successor with staged private
role keys. Latest candidate matches its predecessor; only current dev publisher
is stopped pending coordinated activation. No actual import/private/config install
or issuer acceptance yet. Continue that single S05 activation, then protected
external signers and grant/MGR journals; do not claim readiness as messaging.
[Protocol scope](../deep-protocol/docs/testing/s05-mailbox-issuer-rollover-2026-10-14.md),
[operational scope](../deep-devops/docs/S05-AUTHORITY-HISTORY-2026-10-14.md#offline-operational-roletraffictls-candidate).

Первый Store в полном Registry scope занял14930ms при deadline15s: nominal
margin70ms остаётся риском. Seven native issuer cases имеют0 foreign TRX overlaps
после explicit xUnit collection isolation; внутренние concurrent operations
сохранены. Это source qualification, **не stable-performance или S09 load PASS**.
Семь Unix-socket skips требуют Linux lane. Shipping/provider/device gates,
S06 и остальные критерии S05 не закрыты; новый full не повторять без изменения
его входов или конкретной verification цели.

## Принятый source checkpoint S04

**Client grant/send/route lifecycle — source принят; пять веток сверены с origin.**
Нормативные критерии и dependency boundaries принадлежат
[этапу S04](architecture/IMPLEMENTATION-PLAN-V1.md#s04--завершить-client-grantsendroute-lifecycle)
и [transport-neutral owner](architecture/TRANSPORT-NEUTRAL-MESSAGING.md#843-compaction-and-boundedness).
Сопоставление всех критериев с реальным кодом и границами доказательств —
[S04 review](S04-CLIENT-LIFECYCLE-REVIEW-2026-10-13.md).

Текущий source package включает creation/retry cutover, original unknown Store
settlement и linked attempts, grant/path retirement, ordinary/control terminal
cleanup и metadata-only audits, private route custody и exhausted-PQ Braid recovery.
Это реализация-кандидат, не stage acceptance, deployed activation или device PASS.
Local layouts/generations определяет producer Shared, не эта очередь.

Последние проверенные свидетельства:

- Shared canonical full-02: **1397/16/0**, native/qualification1 — FAIL.
  Исправленный matching remediation: **77/0/0**, native/wrapper0.
  Последующий connected outcome diagnostic: **12/0/0**, native/wrapper0.
  Каждый scoped PASS относится к своим inputs, не заменяет новый full.
- Shared canonical **full-03 завершён FAIL:1412/2/0**,1414 exact case keys;
  build/preflight0, native/qualification1. Оба mixed-route случая упали при
  последующем directory-proof issuance: исходный XNV1 fixture не покрывал
  весь issued interval. После terminal отдельно подтверждены1981 unchanged inputs;
  это не исправляет FAIL и не заменяет отсутствующий canonical final input check.
  Точный receipt и cause — Shared terminal-audit checkpoint ниже.
- Связный source package внёс genuine signed epoch/view successor перед длинной
  late-settlement частью и очистку временных owned DAM1/DMC2 exports/records в
  текущем DID2 outbox/inbox/projection. Старые ciphertext/grant ceilings,
  validation и independent history/object keys не изменены.
  Release build0/zero warnings/errors; matching **141/0/0**, native/wrapper0,
  1981 unchanged inputs. Этот исторический scope закрыт; актуальные follow-up
  и canonical full указаны ниже. Review, commits и push текущего пакета завершены.
- Shared current canonical **full-05:1424/0/0**,1424 exact case keys,
  build/preflight/native/qualification0 и1984 unchanged inputs,
  **FullAccepted=true**. Обязательные513-send,129-grant,128-grant backpressure,
  оба exhausted-PQ recovery и оба previously failed mixed-route случая прошли.
  Это current source qualification, не installed/physical или release PASS.
  После full только убрана лишняя пустая EOF-строка нового page-cache теста;
  его отдельные Release build0 и focused1/0/0 прошли. Исходный full receipt
  и его input snapshot сохранены без подмены; подробности в Shared checkpoint.
- Protocol current canonical full-04: **2286/1/7**, **2294** exact case keys,
  native1/qualification0,1579 unchanged inputs, build/preflight0.
  MatrixQualified=true, **FullAccepted=false**: original S08 package FAIL
  и семь original named skips сохранены. Это не shipping/provider acceptance.
- Актуальный MAUI Clean consumer: **95/0/0**, native0/exact qualification,
  2517 unchanged inputs; MAUI smoke: **119/0/0**, native0/exact qualification,
  2517 unchanged inputs. Оба Release builds — zero warnings/errors.
  Windows ARM64 Debug текущего follow-up пакета прошёл0/zero warnings/errors;
  Android follow-up Debug также прошёл0/zero warnings/errors.
  Эти builds не являются installed/physical delivery evidence.

Закрытие S04:

1. Matching141-case scope, MAUI consumer и Windows/Android compiler checks
   предыдущего пакета прошли. Full-04 прерван после подтверждённого пропуска
   очистки временных DMC2/DAM1 в cancellation/retry-deadline consumers;
   native/qualification1, FullAccepted=false. Дополнение исправлено без изменения
   durable keys/deadlines; matching connected-02 прошёл201/0/0, native/wrapper0
   и1982 unchanged inputs. MAUI95/smoke119 и Windows/Android compiler checks
   текущего пакета прошли; canonical full-05 завершён1424/0/0 с exact matrix
   по completed full-03 и connected-02, без allowed FAIL/skip.
2. Source review пакета завершён. Final source qualification подтвердила
   exact case/method/execution matrix, native exit0 и неизменность1984 входов.
   Не путать scratch cleanup с удалением independent asset/history keys;
   scoped PASS и предыдущий full FAIL не являются приёмкой S04.
3. Сохранить downstream evidence актуального пакета. Повторять consumer/compiler
   проверки только если новый full потребует изменений их входов.
4. Requirement-to-evidence, source/API/frozen consistency и source/secret/diff review
   завершены в пределах S04; original shipping/provider gates остаются открыты.
   Не превращать partial evidence или известный package FAIL в общий PASS.
5. Локальные repo commits созданы: Protocol f6cd57f, Shared599edf2,
   MAUI02a1ea1, DevOps ee55b90; все четыре child trees чистые.
   Root pointers/checkpoint:659bb9d. Все пять release-candidate веток запушены;
   точные remote SHA совпали с локальными HEAD. S04 source принят по его критериям;
   следующий и единственный активный этап — S05.

Для отладки использовать короткий connected outcome scenario; genuine513-send
и128/129-grant crossing остаются обязательной итоговой проверкой.
Одна цельная функциональная часть → build/focused → связный пакет исправлений →
matching rerun → required final gates/review/commit. Не запускать full после каждой
промежуточной правки и не открывать следующие этапы параллельно текущему.

Attachment outbox-only key cleanup не доказывает independent asset-key retirement:
live DAM1/history/object/upload/download/resume obligations нельзя удалять ради
capacity. Independent object-key closure остаётся непроверенным требованием;
remote BLOB/local cache expiry и installed media flow — S10. Границу приёмки
проверять по normative owner и S04 review, не по сумме исторических PASS.

## Следующие этапы и принятая source база

| Этап | Текущий статус и оставшаяся приёмка |
| --- | --- |
| S00 | Принят source baseline, не shipping. [Node](../xnode/docs/testing/s00-node-baseline-2026-10-03.md), [Registry](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md). |
| S01 | Принят contract/API stage, не runtime/release. [Review](S01-CONTRACT-REVIEW-2026-10-10.md); original Protocol package FAIL остаётся S08 по DR-0095. |
| S02 | Принят current-only native/configured node source/composition, не deployed/physical. [Review](S02-CURRENT-NODE-REVIEW-2026-10-10.md), [checkpoint](../xnode/docs/testing/s02-current-consumer-2026-10-10.md). |
| S03 | Принят grant-bound peer node source/composition, не deployed/physical. [Review](S03-CURRENT-PEER-REVIEW-2026-10-11.md), [checkpoint](../xnode/docs/testing/s03-peer-cycle-2026-10-10.md); full1479/0/0, Node ddcf4b6 pushed. Intermittent native MoveFileEx denial не объявлен исправленным. |
| S04 | Принят source lifecycle: matching201, MAUI95/smoke119, Windows/Android compiler checks и canonical full-05:1424/0/0; review/commits/push завершены. Не installed/release acceptance. |
| S05 | Единственный активный этап: current issuer, signed successor provisioning и автоматический operational lifecycle. [Локальный issuer scope](../deep-registry-api/docs/testing/s05-mgr1-signer-bound-2026-10-04.md#connected-private-grant-exchange-2026-10-05) не квалифицирует полный Program/ONION, proxy/deployed443 или independent key rotation. |
| S06 | Не пройден: два настоящих owned clients, publication/resolve/claim/consent/text через selected-entry и separate replica endpoints; offline/duplicate/lost-response/restart. |
| S07 | [Local history](../deep-client-shared/docs/testing/s07-local-history-2026-10-04.md) реализована; offline logical queue, autonomous scheduler/drain, AppAck/read и полный1:1 event/UI scope не закрыты. |
| S08 | Shipping composition отсутствует; actual package graph FAIL. Supported native owner/clean-break, package/API/resource closure, composition без diagnostic flag, installed Android/Windows text/receipt. |
| S09 | Не квалифицирован: sustained connected delivery, retained identities/floors, rotation/offline/restart/recovery и полный catalog. |
| S10 | Local attachment custody есть; encrypted remote files/images/video/voice/avatar, integrity/resume/expiry/cache/UI не закрыты. |
| S11 | Current DID2 app path не замкнут: governed groups, multi-device/history transfer; retired GroupV1 harness не evidence. |
| S12 | Отдельные компоненты; carriers/bootstrap/push и relay-only calls не квалифицированы полностью. |
| S13 | Зависит от предыдущих требований: одна signed/installed artifact matrix, полный evidence catalog и reviews. GitHub Releases/main — только по отдельной команде. |

## Релизные блокеры, которые нельзя потерять

- **B1/S02–S06:** current node source принят; deployed authorities/provisioning,
  owned client join и selected-entry/ONION delivery не доказываются health200,
  local Kestrel или fixture clocks. Old PMA1 adapters не возвращать.
- **B2/S03–S09:** distinct node/receipt identities, sole signed Store writer/prefix,
  independent peer facts и either-replica ACK приняты на source уровне.
  Connected/physical retained-route/horizon/retirement/recovery ещё обязательны.
- **B3/S04:** current source full подтвердил sustained512/128 и exhausted-PQ
  recovery; source review, commits и push завершены;
  installed acceptance отсутствует.
  Original pending/unknown requests/ciphertexts/floors сохраняются;
  не повышать bounds, не remint/evict и не подменять recovery fake freshness.
  Source Braid package не является shipping или физическим доказательством.
- **B4/S07:** reconnect ещё не квалифицирует autonomous draining или AppAck/read;
  прежний local-history full564 не относится к новой installed composition.
- **B5/S08:** conversation DI diagnostic-only и запрещена в Release.
  Просто снять запрет нельзя: нужны supported shipping owner и настоящий artifact.
- **B6/S04/S05/S08:** independent DCA/XUR/PMT/issuer/root rollover,
  verified catch-up, current signed PMA2/PMT2 readiness и retained volumes
  остаются требованиями. Same-key source scenario не доказывает key rotation.
  MAU2/MCG2 в native provenance нельзя спрятать переименованием;
  изменения mapping/grammar требуют frozen authorization.
  Root/custody/account/device guards не исключаются из release scope.
- **B7/S10–S13:** files/groups/calls/multi-device/carriers и весь
  [V1 release scope](architecture/V1-RELEASE-SCOPE.md) остаются обязательными.
- **B8/S06/S08:** [one-time publication](../xnode/docs/testing/s00-one-time-publication-2026-10-04.md),
  [descriptor](../xnode/docs/testing/s00-contact-descriptor-2026-10-04.md) и
  [owned custody](../deep-client-shared/docs/testing/s00-one-time-custody-2026-10-04.md)
  проверены локально. Public account-owned operation/QR export,
  request-expiry reconciliation и installed evidence ещё открыты.
  Первый permanent-contact text milestone не отменяет one-time UX.

Физические contacts/messages/files/groups: **0/4 подтверждены**. Релиз не готов.
Поддерживаемые клиенты этого спринта — Windows и Android; macOS не собирать
до явной команды владельца.

OfficialXPoint3: **три production nodes**. Outage обязательного hop останавливает
data route; S09 доказывает сохранность/восстановление после возврата, не outage
availability. Расширение до шести перед приглашением пользователей — отдельное
решение владельца, без скрытого topology fallback.

## Evidence и обновление очереди

Команды, hashes, exact scopes и сохранённые FAIL находятся в repo-checkpoints:
[Shared lifecycle](../deep-client-shared/docs/testing/s04-lifecycle-2026-10-11.md),
[Shared retention](../deep-client-shared/docs/testing/s04-contact-retention-2026-10-12.md),
[Shared terminal audit](../deep-client-shared/docs/testing/s04-successful-audit-2026-10-12.md),
[Shared sustained](../deep-client-shared/docs/testing/s04-sustained-send-2026-10-12.md),
[Shared routes](../deep-client-shared/docs/testing/s04-route-processing-2026-10-11.md),
[Shared Braid](../deep-client-shared/docs/testing/s04-braid-durable-2026-10-11.md),
[Protocol routes](../deep-protocol/docs/testing/s04-private-route-update-2026-10-11.md),
[Protocol Braid](../deep-protocol/docs/testing/s04-braid-recovery-2026-10-11.md).
[SPRINT-HISTORY](SPRINT-HISTORY.md) и сохранённая редакция — исторические наблюдения,
не новая очередь и не разрешение production/reset/publish.
После terminal обновлять только текущую строку статуса и linked checkpoint;
не добавлять сюда очередной хронологический changelog.
