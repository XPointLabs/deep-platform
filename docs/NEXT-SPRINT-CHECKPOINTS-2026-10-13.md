# Историческая редакция NEXT-SPRINT — 2026-10-13

Это сохранённая редакция очереди до консолидации. Она содержит наблюдения разных
входов, промежуточные FAIL и уже устаревшие указания «следующий шаг».
Она не является планом, нормативным источником или действующим разрешением.
Актуальный статус — [NEXT-SPRINT](NEXT-SPRINT.md), порядок и критерии —
[IMPLEMENTATION-PLAN](architecture/IMPLEMENTATION-PLAN-V1.md).
Исходные receipts и repo-checkpoints не изменялись.

## Сохранённая редакция Deep / XPoint

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

S04 — единственный текущий этап после принятого и запушенного S03.

**Sustained send verification candidate:** добавлен связанный public-API
сценарий513 отправок с native peer feedback, automatic cleanup, cold reopen,
полной SQL-историей/receipt joins и exact replay первого сообщения. Текущая
сборка имеет0 warnings/errors. Старый focused7 был намеренно прерван для
исправления повторных SQL-чтений; его FAIL/interruption не переписан.
Matching send513-04 теперь прошёл7/0/0, native0/wrapper0 и1946 unchanged inputs:
513 genuine owned send/receive,128 peer feedback, automatic cleanup/cold reopen,
exact first-message replay и полная native/application history/receipt joins.
Все прерванные прогоны и ошибка второй сборки сохранены в
[Shared checkpoint](../deep-client-shared/docs/testing/s04-sustained-send-2026-10-12.md).
Это не доказательство128 distinct grants, полного S04 или device delivery.

Связанный read-path пакет собран без warnings/errors. Focused64 завершён
56 PASS/8 FAIL: новые negative fixtures требуют исправления типов ожидаемого
отказа и снимка уже повреждённого SQL до target call. Исправление внесено;
matching focused19 прошёл19/0/0, native0/wrapper0 и1946 unchanged inputs.
Это все13 новых read/cache случаев и6 prerequisite, не новый64-case PASS.
Проверка513 на той же сборке завершилась успешно; следующий связанный source
пакет — guarded stable-orphan cleanup. Runtime integrity не ослаблена.
Точные результаты и причины — в том же Shared checkpoint; S04 не принят.

Guarded stable-orphan cleanup применён через atomic exact-floor compare/delete
в обоих backends, без нового журнала/wire/key mode или verification cache.
Matching focused82 прошёл82/0/0, native0/wrapper0,1948 unchanged inputs и чистая
сборка: новые17 cases, прежние backend/checkpoint/recovery, prerequisites и genuine
old/new-route cold cleanup. Прежний81/1 fixture FAIL сохранён. Это source-пакет,
не unfiltered full, whole S04 или physical delivery; критерии retention и
distinct grants/outcomes ниже остаются открыты.

Следующий связанный S04 candidate —129 distinct signed Retrieve grants через
public synchronization, genuine installation/read/maintenance и cold recovery
committed page. grant129-05 получил6/1: short grant expiry не закрывает original
possible-issuance ceiling. Runtime-дефект этим не доказан. Candidate теперь
разделяет128 actual grants/backpressure без mutation и129 grants через genuine
signed authority rollover с сохранённым completed replacement read при закрытии
старого policy window. Синтетического заполнения protected entries нет;
grant129-06 завершён8/1: genuine backpressure и прежний contact rollover прошли,
но positive129 выявил ошибочный Shared join captured Retrieve issuance PMA2
с более старой route PMT2. Consumer исправлен: два exact historical joins через
неизменённый strict Protocol API, bounded public lookup metadata не authority.
Добавлены substitution/missing/wrong-role/cancel/no-mutation checks. Сборка
grant129-08 чистая; matching focused10 завершён9/1. Namespace positive/negative,
actual128 backpressure и прежний contact rollover прошли. Positive129 дошёл до
replacement credential interval guard при holder retirement и пока не прошёл;
diagnostic7 тоже6/1: selected replacement не прошёл current grant verification
перед normal renewal. Candidate теперь defers only: неподходящий interval/issuer
пинит cleanup до renewal, без floor/holder effect; один namespace pair на business
call вместо32 transitions на одном коротком proof. Добавлена three-grant cold
проверка сохранения original holder/floor. grant129-10 build0/zero warnings/errors;
matching connected focused36 завершён34/2. Expired-replacement preservation и
renewal прошли. Same-namespace IdleReader требовал лишнюю lookup policy; теперь
его captured exact pair проверяется напрямую тем же strict API. Positive129
требовал retry room до proportional margin; new-work selector учитывает штатный
timeout+5 window, без изменения TTL/active request. Добавлены8 boundary cases;
grant129-11 build0/zero warnings/errors. Исправленные focused16 прошли16/0/0,
native0/wrapper0,1950 unchanged inputs: genuine129 request/grant, cold reopen,
committed page recovery и automatic bounded cleanup; IdleReader и8 boundary
cases тоже прошли. Это не новый36-case PASS; connected44 на той же сборке
прошли44/0/0, native0/wrapper0,1950 unchanged inputs: весь связанный grant/read
regression scope закрыт. Полная outcomes/retention матрица S04 не закрыта.
Следующая единственная business-подзадача — Initial/ContactAccept retirement
без утраты consent/history authority. Это не physical delivery
Stored ContactAccept source transition теперь реализован: существующий slot,
generation3 без migration; consent-only commitment вместо working payload,
closed ten-root plan с send+consent adoption/recovery. Все consent/history readers
связаны с native/semantic event; первая encryption без original native operation
после retirement отвергается. Сборка contact-retention-03 чистая; connected79
завершён77/2/0, native1/wrapper1,1951 unchanged inputs. Оба FAIL показали конфликт
Root12 guard с изменяемым ContactAccept. Candidate разделяет complete Root12 и
закрытый Root16 guard всех прочих источников с отдельным successor Root15;
добавлены negative profile/consent-mutation checks. Matching corrected04 прошёл
89/0/0, exact89, native0/wrapper0,1951 unchanged inputs; сборка0 warnings/errors.
Следующая связанная часть этого же S04 — pre-commit abandon нового joint profile
и fresh user send после retirement — реализована как candidate; три cold abandon
case и один real native text/receive/dedup case добавлены. Build05 чистый,
focused93 завершён92/1/0, native1/wrapper1,1952 unchanged inputs: abandon прошёл,
acceptance replay нашёл ещё один full-payload reader в authenticated handoff.
Он переведён на common exact-consent + actual native join; fresh text scenario
также включает owned Store. Matching corrected06 прошёл93/0/0, exact93,
native0/wrapper0,1952 unchanged inputs; build0/zero warnings/errors.
Подтверждены cold abandon/recovery, post-commit refusal, consent-only acceptance
replay без новой encryption и fresh owned text → Store → receive/dedup/receipt.
Это in-process source qualification, не installed-device/production delivery.
Следующая business-подзадача того же S04 — Initial working-payload retirement.
Initial source candidate теперь реализован в том же held owner: единственный
contact-start generation2, marker без payload, source/native/Store joins,
ordered Send+draft adoption и abandon без потери исходной истории. DR-0064
согласован; добавлены Initial crash/marker/cached-replay/fresh Store/text cases.
Build01 завершён четырьмя missing-argument ошибками (восемь across targets),
исправлен explicit guard-profile selection для остальных retirement owners.
Matching build02 чистый; connected107 прошёл107/0/0, native0/wrapper0,
1952 unchanged inputs. Подтверждён Initial marker → cached retry без claim →
acceptance → fresh native text/Store/receive/dedup/receipt, без потери source/history.
Связанная regression13 на той же сборке прошла13/0/0, exact13,
native0/wrapper0,1952 unchanged inputs: used-Deposit после payload retirement,
missing-SQL refusal/live objects, superseded/unused-Retrieve и Braid retirement.
Stored control payload retirement квалифицирован в этих source scopes; следующий
тот же S04 business slice — control terminal cancel/expiry. Object-only keys,
independent content-free audit и финальная stage/full/device приёмка остаются открыты.
Control terminal fence candidate внесён в те же control-корни: Initial generation3,
Accept generation4, точный stop CAS с actual native/source/semantic либо проверенным
unencrypted-draft absence. Lower time доказывает expiry; unknown requests/holders/
outcomes не удаляются и не переименовываются в успех.
Build control-stop-01 чистый; focused37 прошёл37/0/0, native0/wrapper0,
1956 unchanged inputs: actual unknown/cold/lost-stop-reply, unencrypted acceptance
и expiry preflight. Connected Stored+stop135 на той же сборке прошёл135/0/0,
exact135, native0/wrapper0,1956 unchanged inputs: Stored/recovery/cached retry и
fresh text/Store/receive/dedup не регрессировали. Следующий шаг этого же lifecycle —
stopped control payload + independent metadata-only audit в атомарном SQL/CAS,
без fake ordinary command или нового сервиса/журнала.
Audit custody/effect foundation candidate внесён: actual stopped controls bind
под registered factory lease; HMAC-derived opaque ID без scope/content hash,
совместная completeness и deterministic read-only SQL effects. Две genuine
control capture и hostile ordinary-audit early-refusal проверки добавлены;
build0/zero warnings/errors, matching focused53 прошёл53/0/0, exact53,
native0/wrapper0,1957 unchanged inputs. Ordinary audit crash/cancel/expiry и
hostile SQL, control stop/expiry и prerequisites тоже прошли в этом scope.
Реальный joint payload/audit producer/recovery внесён как source candidate:
existing Application plan/SQL table, один payload successor, guarded original
send/native/source, pre-commit abandon и post-commit completion. Сборка
control-audit-02 прошла0/zero warnings/errors; focused02 прошёл65/0/0,
exact65, native0/wrapper0,1958 unchanged inputs. Joint cleanup/expiry cold
handover, hostile audit/no-repair и connected stop/ordinary-audit scope закрыты
в этом source scope. Deadline edges и hostile successor parts прошли focused04
10/0/0, exact10, native0/wrapper0,1958 unchanged inputs; fixture-only FAIL03
сохранён в checkpoint. Это отдельный scope, не общий75/full receipt. Expiry/
cleanup pre-commit abandon и все три abort/cold handover проверены focused05
16/0/0, exact16, native0/wrapper0,1958 unchanged inputs. Broader connected
Stored/control regression ещё открыт; прежние53 — другие inputs.
Эта foundation/candidate не объявляется завершённым cancel/expiry.
Это не завершённый весь cancel/expiry: preclaim Initial без admitted native scope,
independent key retention и broader regression остаются открытыми;
предыдущие107/13 — другие inputs.
См. [contact checkpoint](../deep-client-shared/docs/testing/s04-contact-retention-2026-10-12.md).
Следующий единый implementation package — отмена owned Initial intent до native
сессии: (1) только draft; (2) sealed preclaim и reserved/unknown XPK request;
(3) completed sender source до import. Partial import сначала требует exact local
settlement, после доказанного native commit используется уже существующая stop
ветка. Проверять отсутствие по actual source/catalog/native custody, не по UI
флагу или исключению missing-row. Сохранить claim replay и device-DH burn facts,
уничтожить object-only secrets без fake transfer receipt. Только после связанного
producer/consumer/recovery пакета — targeted matrix и исправления; не открывать
следующий этап и не запускать full для промежуточного codec.
Pre-session implementation candidate внесён: draft4/preclaim3/key-retirement2,
distinct cancellation owner без fake transfer, stop/claim/import denial, local
key recovery и existing Application plan с opaque account-derived selector.
Сборка03 прошла0/zero warnings/errors; focused03 завершён17/13/0, exact30,
native1/wrapper1,1963 unchanged inputs. Все новые FAIL имеют одну product-причину:
Application ещё не initialized до первой native message. Owned initialization
перенесена перед stop CAS; existing-only recovery не ослаблен. Второй product
FAIL04: audit до inbox owner; исправлена owned binding перед stop CAS, без repair
в recovery. После исправления stop-priority перед completed shortcut сборка07
прошла0/zero warnings/errors; focused07 прошёл20/0/0, exact20,
native0/wrapper0,1963 unchanged inputs. Все три actual pre-session setup,
четыре key и шесть payload/audit handover без fresh proof прошли; active completed
source/native seed/retry также прошёл. Test-only extension08 собран0/zero warnings/errors;
matching focused08 прошёл45/0/0, exact45, native0/wrapper0,1964 unchanged inputs.
Закрыты lost stop-CAS reply/token cancellation, оба actual reserved-empty варианта,
native-import intent selection, три cold abort handover, signed audit lower
deadline и пять missing-custody случаев;10 codec negatives тоже прошли.
Stable hostile-custody extension10 получил22/3/0: все9 новых rollback/resurrection/
source/audit случаев прошли; три FAIL — неверный точный exception type в codec fixture.
Исправленный codec/prerequisite focused11 прошёл16/0/0, native0/wrapper0,
1964 unchanged inputs; runtime не менялся. Это отдельные receipts, не combined54 PASS.
Broader current Stored/control/negative source regression остаётся открытой.
Это не whole-S04, full или physical qualification.
После11 исправлена early-expiry граница: подтверждение lower UTC теперь округляет
millisecond expiry вверх, admission upper-time остаётся консервативным. Build12
чистый; matching metadata/codec/contact retry-expiry focused12 прошёл45/0/0,
exact45, native0/wrapper0,1964 unchanged inputs. Это квалификация округления,
не combined pre-session/full/S04 PASS; earlier receipts — prior inputs.
Pre-session expiry source package13 теперь реализован: отдельный internal expiry
command в том же owner, lower deadline до Application provisioning, сохранение
первой terminal reason/time и полный audit-expiry/abort handover candidate.
Build13 чистый; focused13 получил68/6/0, native1/wrapper1,1965 unchanged inputs.
Audit-expiry/abort9 и выбранная prior regression прошли. Все6 FAIL — fixture setup:
audit helper выбрал ещё не действующую future authority для короткого Initial
deadline. Исправлен Initial-only signed-window helper; runtime/assertions не
менялись. Corrected build14 чистый; focused14 прошёл12/0/0, exact12,
native0/wrapper0,1965 unchanged inputs. Draft/unknown/completed × normal/lost reply
подтвердили exact signed lower deadline, no mutation до него, local recovery,
RetryExpired и сохранение первой reason/time после user cancellation.
Pre-session cancel/expiry source package реализован с указанной boundary evidence;
это не combined74/full/S04 PASS. Следующий связный source scope — broader current
Stored/control/negative regression и остающиеся object-key/successful-audit predicates.
Current ordinary successful-audit candidate теперь внесён связным пакетом:
first terminal upper time, content-free metadata после working compaction,
independent audit expiry/recovery/abort в том же plan. Local clean-break root7/
Application SQL16 ещё не квалифицирован; prior receipts относятся к другим inputs.
Build02 чистый после explicit-file/Span compile fix; focused02 получил74/7/0,
native1/wrapper1,1969 unchanged inputs. Все6 новых payload handover прошли.
Все7 FAIL — harness: повторный successor в audit fixture и abandon-only enum
в старом normal-recovery loop. Исправлены вместе, runtime не менялся;
matching corrected matrix ещё требуется, full81 PASS не заявлен.
Corrected focused03 получил75/6/0: old normal recovery исправлен; все6 expiry
handover завершили cleanup/recovery и упали позже на cached Store после root renewal.
Выявлен product defect в общем Protocol verifier: original view сравнивался с
latest authority. Внесён exact verified PMT-ancestor lookup, без ослабления
current lineage/signature checks или нового API/wire. Matching source/negative/
Protocol gates и frozen/package repin ещё требуются; full81 PASS пока нет.
Focused04 также terminal75/6/0: исправленный original-view verifier пройден,
но cached Store остановился на втором current-only вызове — original PMA в Shared.
Общий historical Store verifier теперь использует существующий current host /
`RequireOriginalNamespaceAsync`, затем проверяет issuer/generation/interval старого
grant; current admission не ослаблен. Добавлены signed audit deadline−1/exact/+1,
cold reopen и hostile retained public evidence после root renewal. Matching
build/focused ещё требуется; исходные FAIL сохранены в checkpoint.
Matching focused05 завершён84/0/0, native0/wrapper0,1969 unchanged inputs:
12 payload/expiry handover,3 deadline edges и selected regression/preflight.
Historical-view/PMA defects исправлены в этом scope; это не whole-S04/full/device.
Следующий связанный increment: cancellation после successful working compaction
проверяет actual original Store, не marker. Добавлены no-op до/после audit expiry,
3 abort handover, hostile successful SQL rows и separate audit capacity;
matching supplemental build/tests ещё требуются.
Supplemental06 завершён58/1/0: no-op cancellation deadline/cold reopen, capacity,
structural/preflight прошли; hostile fixture остановился на SQL CHECK ещё до MAC.
Исправлен только setup: interval меняется целиком с неверным MAC, отдельные CHECK
rejections сохранены как assertions. Build07 чистый, corrected focused07=7/0/0,
native0/wrapper0,1969 unchanged inputs:6 hostile mutations,2 SQL CHECK,3 interrupted
abort/cold-resume и actual expiry/cached Store. Это не combined current full/S04;
06 FAIL сохранён. Далее в этом же этапе: successful Initial/ContactAccept audits,
independent object-key closure и final sustained/full/package qualification.
Initial/ContactAccept successful audit и полная retention/stage приёмка открыты.
Initial/ContactAccept successful audit теперь внесён одним source package:
sole local journal5 (старые1–4 reject), отдельная first-success upper отметка,
immutable first stop/success, existing reason3/opaque audit ID/ten-root SQL plan,
signed independent expiry и cold local recovery. Сначала actual successful
payload/audit cleanup, затем separate original-send/floor cleanup; уже retired
consent successor меняет только revision, без восстановления audit/payload.
Build01/02/03 чистые; matching connected matrix включает4 actual-owner rows
Initial/Accept × payload/expiry,6 fault handover в каждой,2 separate send-cleanup
regressions, structural/mixed-time/current-reader и6 preflight. Terminal result
ещё требуется; это не whole S04/full/physical. Owner/evidence — тот же
[successful audit checkpoint](../deep-client-shared/docs/testing/s04-successful-audit-2026-10-12.md).
Connected control03 terminal59/1/0:4 successful control rows/24 handovers и2
separate send-cleanup recovery прошли; empty-start malformed revision выявил
product decoder defect. Оба current control decoder теперь требуют empty
revision1 (retention не удаляет winners); explicit accept empty/prior-generation
negatives добавлены. Также добавлены Initial/Accept signed deadline−1/exact/+1,
6 hostile SQL mutations before expiry/cold reopen/no-new-transport. Build04 чистый,
matching focused04 ещё требует terminal. Existing FAIL сохранён; whole-S04/full,
successful-control abort/guard и stopped cross-family regressions остаются открыты.
Control04 terminal59/0/0, native0/wrapper0,1969 unchanged inputs: оба successful
control signed deadline−1/exact/+1/hostile rows/cold exact replay, fixed empty-root
negatives и actual stopped-custody regressions passed. Добавлены2 abort rows:
Initial/Accept × payload cleanup + expiry ×3 interrupted abandon boundaries,
без нового proof/изменения first success. Build05 чистый, focused abort/hostile
staging/preflight требует terminal. История/hash — только в Shared checkpoint;
это не combined whole-S04/current full, anchor review или physical evidence.
Control05 terminal10/0/0, native0/wrapper0,1969 unchanged inputs: successful
Initial/Accept payload+expiry ×3 interrupted abandon/cold resumes (12 boundaries),
unchanged complete SQL/root/first success без fresh proof, actual cleanup/expiry/
cached Store без new transport/grant/native floor change; hostile staging и6
preflight passed. First-success/control audit source implementation проверена в
этих named scopes. Wider current cross-family/full/anchor/package, independent
object-key dependencies, sustained outcomes и device E2E по-прежнему открыты;
никакого whole-S04/release acceptance, commit/push или production activation.
Attachment outbox-only key/dependency batch теперь в source: working DAM1 key
copies остаются только в ordinary/SQL outbox до terminal cleanup; independent
registered local asset/history по DR-0031 guarded и не являются outbox-only keys.
Исправлен concrete read-only-selection defect: dependency read больше не может
discard unadopted asset candidate до outbox plan; explicit asset-owner recovery
сохраняет своё отдельное разрешённое reconciliation. Added4 actual outcomes
Stored/native cancel/expiry/unencrypted draft с AfterSql cold recovery, key-free
working/audit state и actual cold local materialization; registered-key mutation и
inert-candidate negatives проверяют отсутствие unintended SQL/root mutation.
Build attachment-keys01 чистый; matching matrix требует terminal. Remote BLOB,
upload/download/resume/local-cache expiry и полный asset-key lifecycle — S10,
не закрываются outbox cleanup. Exact source/evidence — Shared successful-audit
checkpoint; whole-S04, managed secret-copy review и physical остаются открыты.
Attachment-keys01 terminal29/0/0, native0/wrapper0,1970 unchanged inputs:4
terminal outcomes/key-bearing working-copy deletion/cold actual local asset,
registered DAM1-key substitution и actual inert candidate no-mutation negatives
passed. Scope не закрывает whole BLOB/local-asset expiry или physical.
Обнаружены codec-owned secret copies после DAM1 Dispose; linked internal
cleanup теперь стирает AttachmentOffer и parent DMC2 buffers и rejects their
secret getters, синхронизирует late registration/Dispose, erases authoring/failed
decode copies. New pure ownership/race tests; wire/public API неизменны. Matching
Protocol/Shared qualification ещё требуется, prior29 — прежние inputs.
Protocol attachment-memory02 terminal39/0/0, native0/wrapper0,2262 unchanged
inputs: linked owned key-buffer disposal/late+racing registration, independent
decoded-record/non-attachment ownership и DAM1/DMC2/chunk negatives passed.
Protocol build02 и Shared attachment-keys02 build чистые; matching current Shared
29-case attachment regression ещё требует terminal. Wire/public API shapes
не изменены; full/API/package/frozen/consumer review и S04 sustained/device
приёмка не выводятся из scoped codec/key receipts.
Current Shared attachment-keys02 terminal29/0/0, native0/wrapper0,1970 unchanged
inputs подтвердил actual attachment outbox key-copy/dependency/cold local asset
scope на исправленном Protocol memory lifetime. Дальше — current sustained send/
distinct grants/all outcomes и wider cross-family/full/API/package/frozen review.
Remote BLOB/local asset expiry/cache и caller-exported copies не закрыты этим
receipt. Whole-S04/release/device acceptance, commit/push/production activation нет.
Two comparison-owned DAM1 canonical exports now erase in finally rather than GC;
attachment-keys03 build0/zero warnings/errors and matching29/0/0,
native0/wrapper0/1970 unchanged inputs подтвердили current attachment consumers.
Exact receipts/history — Shared checkpoint. Current-sustained01 запущен на этой
же сборке: public send >512, distinct Retrieve grant128/129, signed ceiling/
backpressure/cold replay и6 preflight. Run намеренно остановлен для исправления
подтверждённого mixed stopped/successful lifecycle: native1/wrapper1,
aborted TRX9/0/0 из10 declared,1970 unchanged inputs. Все3 Retrieve cases и6
prerequisites завершены;513-send case не завершён, весь scope НЕ qualified. Current
whole-stage/full/API/package/frozen и S10/device acceptance не заявлены.
Read-only review выявил отдельный remaining criterion: stopped ordinary entries
после payload/audit expiry остаются в `Entries` и входят в512 bound. Successful
send stress не доказывает sustained cancelled/expired lifecycle. Нужен actual
boundary test и корректное сохранение no-reauthoring/replay fences; не поднимать
лимит и не удалять fences только ради PASS. Во время live run source/norm inputs
не менялись. Также stopped prefix блокирует очистку последующих successful rows;
после terminal run исправляется этот связный пакет без увеличения bounds и потери
защиты never-encrypted cancelled drafts. Наблюдение и receipt — в Shared checkpoint.
Mixed-terminal01 теперь воспроизвёл оба product defects: Release build0/zero
warnings/errors; focused6/2/0 из8, native1/wrapper1,1971 unchanged inputs. Actual
public send с cancelled draft +33 successful messages сохраняет33 send entries;
canonical512 expired stops по-прежнему отказывают в новой работе. Prerequisites
passed; assertions/bounds не ослаблены. Далее — единый owner creation/retry и
terminal working-set cleanup package, без бессрочного random-ID deny-list.
Creation/retry source cutover начат: account owner выбирает новые operation IDs
под lease; отсутствующий supplied operation больше не создаёт команду.
Public QueueText/RetryText и MAUI runtime/composer заменили combined SendText;
text composer больше не генерирует operation IDs. Matching build/test пока нет.
Далее — genuine owner-generated fixture/typed-event callers и terminal codec/SQL
cleanup/recovery в одном пакете; не запускать sustained/full до его завершения.
Terminal source package теперь внесён: ordinary reader8 only, no retired working
flags; единый48-byte reason1/2/3 audit в прежнем8192 budget, без увеличения512/128
или904389-byte bound. Stop cleanup удаляет actual working entry; expiry14 общий,
старый entry-based7 rejected. SQL16/key domain и independent unknown/native/
history/asset/receipt/replay custody сохраняются. Recovery/dispatch и codec/mirror
tests retargeted; matching build/test ещё нет. Следующий implementation шаг —
genuine owner-created fixture/typed-event operations, отсутствие aliases/fallback,
hostile/sparse/expired retry cases; затем один связный compile/focused batch.
Exact receipt/status — [successful audit checkpoint](../deep-client-shared/docs/testing/s04-successful-audit-2026-10-12.md).
Connected creation/retry fixtures теперь retargeted; terminal-creation01 build0,
zero warnings/errors, focused175/13/0 из188 exact cases, native1/wrapper1,
1971 unchanged inputs. Это FAIL, не S04 acceptance. Две причины исправляются
одним пакетом: expired stopped unknown ошибочно считается lost successful Store;
automatic success fixture включает rejection-only AfterAbandonRecorded.
Matching focused rerun, MAUI consumer и sustained/full/review всё ещё обязательны.
Порядок работы: законченный connected business package → compile/focused batch →
пакет исправлений → matching rerun → обязательная stage/full qualification.
Новые S-пункты параллельно не открываются; historical receipts не доказывают
текущие inputs. Подробная классификация и exact receipt — в Shared checkpoint.
terminal-creation02 теперь terminal43/0/0, native0/wrapper0,1971 unchanged inputs;
matching Release build0/zero warnings/errors. Все13 прежних failures прошли,
включая actual automatic66-send/unknown-prefix и stopped expiry/cold recovery.
Также прошли current successful-audit и hostile Store-attempt linkage cases.
Это scoped PASS; прежние175 остальных cases требуют current wider/full receipt.
Далее MAUI consumer build/test в том же S04 package, затем sustained/full/review.
S04, physical E2E и release не закрыты. Exact timestamps/hash — Shared checkpoint.
MAUI current consumer Release build0 и95 Clean cases passed (native0/wrapper0,
2505 unchanged inputs); Windows Debug app build0/zero warnings/errors. Это
compile/UI-contract evidence, не physical messaging или packaged RC. Android
build и wider/full/sustained Shared/Protocol qualification ещё требуются.
Android Debug build теперь также0/zero warnings/errors. Обе platform consumers
компилируются; install/run, release package и physical evidence этим не заявлены.
Текущий следующий шаг — current Shared case matrix и wider/full/sustained
qualification, затем review/commit; S05 пока не открыт.
Current full discovery —1411 cases, включая67 linked current opaque persistence
tests в namespace Shared.Tests. Prefix-only1344 inventory не был полным.
Prior full содержит3 больше не актуальных theory parameter/display cases;
historical TRX не переписываются и old cases не возвращаются для удобства gate.
Matching scoped reference union покрывает1155 current cases; далее отдельный
batch оставшихся256 case methods +6 prerequisites, потом exact unfiltered full.
Ни один current case не исключается. Detailed receipt/matrix — Shared checkpoint.
matrix-gap01 terminal261/9/0 из270, native1/wrapper1,1971 unchanged inputs.
Причины: duplicate intent в positive metadata fixture;6 fixture rows выбирают
protected-only abandon вместо actual SQL control-audit owner;2 product paths
используют idle plan до automatic audit maintenance. Пакет исправлений сохраняет
CAS/unknown/custody guards, обновляет actual idle после maintenance и добавляет
same-business-owner cold recovery через обе фазы. Matching build/focused ещё
требуются. Новых generations/wire/compatibility paths нет; S04 остаётся открыт.
control-retirement01 build0/zero warnings/errors; focused22/2/0 из24 exact,
native1/wrapper1,1971 unchanged inputs. Все9 прежних failures и2 новых owner cold
recovery cases прошли. Две late-parent/unknown-child rows выявили mutation idle
plan при преждевременном audit maintenance, хотя send root сохраняется.
Complete send-chain verification теперь перед maintenance; затем exact send/
grant roots, actual idle и guards перечитываются. Matching whole scenario rerun
обязателен; assertions/no-delete/no-overwrite сохранены. Exact receipt — checkpoint.
control-retirement02 теперь24/0/0 exact cases, native0/wrapper0,1971 unchanged
inputs; matching build0/zero warnings/errors. Whole completed-contact scenario
и обе late-parent/unknown-child rows passed без изменения assertions. Далее
complete current case matrix и canonical Shared unfiltered full; S04/physical/
release acceptance из этого scoped PASS не выводятся. Exact receipt — checkpoint.
Current native discovery1413 cases; matching definition/reference union из86
scoped receipts покрывает все1413 без пропусков и без изменения historical TRX.
Следующий canonical Shared gate — unfiltered, без allowed failures/skips.
Full PASS ещё отсутствует; previous scoped receipts не являются current full
или physical/release evidence. Protocol/API/review и вся release scope остаются.
Canonical full02 завершился1397/16/0 (1413 cases), build/preflight0,
native/qualification1; все2057 inputs отдельно сверены неизменными до правок.
Это FAIL, не приёмка S04. Один дефект порядка проверки integrity в history и
несоответствия fixtures текущим creation/terminal/maintenance contracts исправлены
одним пакетом; далее одна сборка и matching connected scope, затем fresh full.
Exact причины, timestamps/hash и residual scope — в
[Shared checkpoint](../deep-client-shared/docs/testing/s04-successful-audit-2026-10-12.md#current-full-02-failure-and-connected-remediation-2026-10-13).
Matching connected01 завершился76/1/0 из77 cases, native/wrapper1,
1971 unchanged inputs; build0/zero warnings/errors. Остался fixture с живым
ordinary draft, который правильно блокирует grant retirement. Проверка теперь
сохраняет эту защиту и отменяет реальные unsent commands через владельца перед
повторным maintenance; fresh build/connected02 и mandatory full ещё требуются.
Connected02 теперь квалифицирован77/0/0, native/wrapper0,1971 unchanged inputs;
build0/zero warnings/errors. Remediation scope закрыт, не whole S04/full.
До final full текущий связный source candidate дополняет genuine513-send путь
pending/BeforeDispatch, lost Store и cold exact retry на512→513. Та же логика
с33 sends даёт быстрый diagnostic без ложной512-boundary claim; отдельный
remote rejection не подменяется local changed-command refusal. Evidence/status
принадлежит [sustained checkpoint](../deep-client-shared/docs/testing/s04-sustained-send-2026-10-12.md#connected-outcome-boundary-candidate-2026-10-13).
Matching short connected outcome scope прошёл12/0/0, native/wrapper0,
1971 unchanged inputs и zero-warning/error build; changed513/full ещё не пройден.
Текущая сверка всего этапа находится в
[S04 review](S04-CLIENT-LIFECYCLE-REVIEW-2026-10-13.md); stage acceptance отсутствует.
Strict producer review исправил отсутствующую global DBR2 registration по
существующему DR-0111 и два hand-authored magic; wire/activation не менялись.
Registry source/anchor check теперь проходит; общий gate дополнен registry input
capture и прошёл37 contracts. Producer focused/downstream/final full ещё требуются.
Producer matching focused76 и canonical full2286/1/7 теперь проверены:
2294 exact cases, native1/qualification0,1579 unchanged inputs, build/preflight0.
Только прежний package FAIL и прежние7 named skips; FullAccepted=false,
S08/release blocker сохранён. Source evidence — Protocol checkpoint выше;
Shared changed1414-case full и MAUI consumer/review/commit ещё требуются.
Все FAIL сохранены; прежние receipts — другие inputs; exact history — в Shared checkpoint.
Initial/cancel/expiry/
object-only keys/metadata-only audit и whole S04 остаются открытыми.

**Реализовано в source candidate:** ранний transport backpressure до нового
authored/ratchet work; proactive contact/grant renewal для новой работы с exact
сохранением старой; current-only send generation4/application schema14 и linked
attempts; original Store cold recovery; whole-chain cleanup с отказом при unknown;
same-recipient ordinary/Initial successor без второго encryption; native
application expiry как retry ceiling; monotonic historical Store при SQL
Durable → Delivered. Высший SQL статус сам по себе не доказывает Store/AppAck.
Поздний signed Store-ответ теперь сохраняется обычным dispatch под той же lease;
coordinator и SQL transitions атомарны, без expired signing/replay. Новый Store
SQL item хранит signed object horizon отдельно от grant admission. All-known
cleanup проверяет original recipient evidence каждого Initial sibling.
Used-Deposit retirement теперь различает native operation и каждый original
attempt: все сохранённые попытки независимо проверяются до exact-grant
membership, в том числе после working-chain cleanup. Подтверждены cold handovers
с сохранением исходных Store/object/native facts. Private namespace maintenance
подключён под actual lease перед новой authoring/draft/read работой: used Deposit
и superseded Retrieve проходят отдельные floor/holder producers; exact retries,
unknown и последний retained path сохраняются. Первый replacement read допускается
до удаления прежнего holder; новая запись credential сама по себе недостаточна.
Known Deposit winner без original transport work теперь проходит отдельный
actual native-forward/SQL-reverse consumer: отсутствие SQL не является permission.
Used producer сохраняет positive Store requirement; unused producer требует
отсутствия selected native work и согласованную обратную coverage. Ordinary read
maintenance подключён, без удаления counter перед negative proof. Matching
focused14/0/0/exact14/native0/wrapper0,1901 unchanged inputs, complete build0/zero
warnings/errors проверяет genuine winner/cold handovers/normal read, другой holder
с actual native Store и отказ при удалённой used transport-row. Archived-path
consumer теперь вызывается обычным new-work maintenance через существующий joint
producer: matching focused19/0/0/exact19/native0/wrapper0,1901 unchanged inputs,
complete build0/zero warnings/errors. Подтверждены original object horizon,
normal next-path read, native contact/ACK и все8 cold handovers; исходный
focused18/1/0 сохранён и исправлен actual elapsed-time расчёт fixture, без
продления authority. Known unused superseded Retrieve теперь имеет actual owned
consumer: grant generation6 сохраняет reservation начала чтения до первого MAU
подписания, независимо от отдельного floor retirement. Missing used SQL не
превращает grant в never-used; replacement требует actual completed read/ACK.
Matching affected focused23/0/0/exact23/native0/wrapper0,1902 unchanged inputs,
complete build0/zero warnings/errors проверяет unused/cold recovery, lost SQL,
crash/cancel reservation, ранний missing-reservation refusal и оба used baseline.
Предыдущий connected43 сохранил41/2; результаты разных inputs не складываются
в full PASS. Complete stage full остаётся отдельной приёмкой; receipts — в checkpoint.
Device SQLCipher random-key/schema6 следует DR-0109, без старого reader/migration.

**Route/continuity source candidate, не весь S04:** выявленная
граница закрыта контрактом
[DR-0110](survival-program/decisions/DR-0110-did2-private-route-update-custody.md):
DMC2/14 не несёт новый XIR1, поэтому delivery отделён от invite/publication.
Delivery ports переведены на закрытую Protocol boundary, publication сохраняет
исходный invitation-bound тип. Current dispatch теперь восстанавливает peer head
из actual native incoming history, включая protected prefix: ordered exact
successors, native Hello/Accept policy и acceptance ordinal, independent historical
и final current verification; exact duplicates не выбирают highest generation.
Dispatch recheck сравнивает head/route/native floor, а не неизменный initial package.
Owned command теперь получает payload только из adopted own publication и actual
native advertised head, используя общий authored generation6/counter и pending →
SQL → stable CAS. MessageCreate5/AttachmentOffer18/ContactRouteUpdate14 закрыты
в существующей записи, текущая schema14 без migration.
Fresh control admission подключён перед encryption и actual native commit:
stable protected/SQL command, actual consent/predecessor, independent current
successor и exact adopted publication; generic send14 всё ещё отключён.
Own control history подключена отдельным closed handoff к существующему semantic
inbox (SQL и in-memory): actual native commit/command/floor/consent/history, без
latest peer mailbox currentness, user text или AppAck. Native-only peer control
не может продвинуть delivery head без atomically committed receive-time outcome.
DR-0027 фиксирует существующий native header672/version2, DMS2 schema4 и тот же
protected history root generation2; прежние поколения отвергаются без миграции.
Actual sealed receive сохраняет first processing/time outcome через общий
pending/SQL/cleanup/stable путь; native replay не пересчитывает его. Peer head
читает native outcome, не SQL qualification flag. Historical positive handoff
подключён к SQLite/in-memory inbox; rejected head fences только новые sends по
этому route, не стирает live TRS. Dedicated internal owned send14 получает payload
только из actual common command/adopted publication; generic raw send14 закрыт.
Complete Production build0/zero warnings/errors. Matching focused100/0/0/exact100/
native0,1896 unchanged inputs включает actual two-owned-account control send/receive,
semantic return, cold exact replay, обычные native text/history и structural rejects.
После расширения только этого теста: affected7/0/0/exact7/native0,1896 unchanged
inputs, genuine interruption after native SQL before materialization; first64-byte
outcome сохранён после clock advance/reopen и один ratchet/native increment.
Разные test binary scopes, не один107/full PASS. Теперь control receive → transport
ACK подключён через независимый actual native/history read-back: accepted control
материализуется, rejected control сохраняет fault/live TRS без positive projection.
Matching affected12/0/0/exact12/native0,1896 unchanged inputs подтверждает accepted
и expired-before-first-receive outcomes, lost ACK/cold exact retry после expiry,
route-fault send fence, все6 prerequisites и прежние3 contact/text/ACK cases.
Complete Production build0/zero warnings/errors. Ранее выявленные FAIL сохранены;
исправлены test retry timing и fixture-node clock, не ослаблены runtime guards.
Точные receipts — в
[native processing checkpoint](../deep-client-shared/docs/testing/s04-route-processing-2026-10-11.md).
Это source candidate, не приёмка всего сценария. Исходный route package schema13:
обязательный original route каждой попытки, выбор exact маршрута
из native Hello/Accept/qualified receive14 для Store, closure, settlement,
compaction и used-Deposit retirement. Schema12 отвергается без миграции.
Matching foundation21/0/0/exact21/native0 квалифицирует old/new-route Store и cold
cleanup, evidence/schema rejects и все6 prerequisites. После этого ordinary
changed-route linked successor подключён: original attempts независимо проверены,
new route независимо current; open exact request и Initial guard не ослаблены.
Matching affected10/0/0/exact10/native0 проверяет actual native-prefix control,
cold old/new Store, три сбоя successor (before root/after root/after SQL), прежний
ciphertext/deadline и unknown-parent cleanup fence. Matching affected8/0/0/exact8/
native0 проверяет accepted/rejected control ACK/replay после actual native-prefix
compaction и encrypted cold reopen. В каждом1898 unchanged inputs, wrapper0,
complete Production build0/zero warnings/errors; разные binary scopes, не общий
full PASS. Между ними diagnostic33/native0 имеет wrapper1 из-за ошибочного
expected30 при фильтре33; результат сохранён и не назван qualified full.
Расширенный matching focused09 **11/1/0/exact12/native1/wrapper1** сохранил
реальный дефект: после working-send cleanup другой genuine native-known маршрут
принимался вместо original route. Два mixed-route late Store/settlement crash и
оба used-Deposit retirement сценария прошли, но общий пакет не принят.
По DR-0110 реализован связный source candidate schema14 с обязательным локальным
commitment исходных records от actual protected registration. Проверки подключены
к cached Store, late settlement, каждому sibling cleanup и used-Deposit retirement;
это не новый wire/journal и не замена независимой signed/native authority.
Старый schema13 отвергается даже пустой. Matching focused10 **27/0/0/exact27/
native0/wrapper0**,1899 unchanged inputs; complete Production build0/zero warnings/
errors. Прежний route-substitution FAIL теперь проходит до/после working cleanup;
два genuine mixed-route late-Store crash/cold/all-known/used-Deposit сценария
проверяют также route/MAC substitution после удаления обоих acquisitions.
Включены evidence/schema rejects и все6 prerequisites. Это один связный focused
receipt, не matching stage full или device delivery.
Native receive crash/cancel покрыты на pending/SQL/stable границах. Genuine
same-generation fork обнаружил дефект: отказ нового send происходил после
ratchet/native mutation. Actual native-history fault fence теперь стоит перед
новой authoring/encryption работой; exact replay/read/ACK остаются независимыми.
Fork прошёл, но его matching пакет14 сохранил gap setup FAIL. Исправленный
gap-only пакет17 **7/0/0/exact7/native0/wrapper0**,1900 unchanged inputs, проверяет
ещё действующий поздний predecessor, protected prefix/cold replay и no-mutation
new-send fence. Две публикации принимаются actual owned owner; первая resumes
genuine short signed pending proposal, не доказывает default repeated renewal
при исчерпанной base authority. Более короткие signed PMS/XRC/XSS/XRR окна теперь
учитываются proactive trigger. Единый matching route-regression пакет18 принят
как focused37/0/0/exact37/native0/wrapper0,1900 unchanged inputs: все10 native
processing/ACK/fork/gap/crash/cancel cases,6 historical joins,3 original-evidence,
12 SQL-key/schema и6 prerequisites. Это не stage full или physical delivery.
FAIL13/14/15 и compile FAIL11/12/16 сохранены в Shared checkpoint.
Точный следующий блок: stopped-work/cancel/expiry retention с сохранением
исходных Store/Delivered facts, затем PQ exhaustion/recovery, остальные незакрытые
lifecycle predicates, sustained128/512 и приёмка этапа. Deposit/no-original,
unused superseded Retrieve и automatic archived-path подблоки имеют focused local
native source evidence, не whole-S04. Retrieve reservation теперь сохраняется
до удаления grant; отсутствие SQL/counter не является доказательством never-used.
Эти consumer joins остаются частью S04, не новым параллельным этапом.
[Protocol checkpoint](../deep-protocol/docs/testing/s04-private-route-update-2026-10-11.md).

**Предыдущий automatic-namespace пакет:** complete Production build0/zero warnings/errors;
automatic namespace focused26/1/0/exact27/native1, затем test-only correction
и selective9/0/0/exact9/native0 (original-grant rejection, два affected baselines
и все6 prerequisites). Shared и Protocol DLL hashes неизменны; успешные случаи
покрывают все исходные27 и два baseline, но это **не один27/0 receipt**,
FAIL сохранён. Все13 новых new-authoring/crash/unknown/last-reader случаев прошли.
Исправленная проверка отвергает именно original expired grant через actual
current host, а не запрещает любую новую разрешённую acquisition. Предыдущие
all-attempt/late Store/whole-known и successor/deadline пакеты сохраняют свои
input scope в checkpoint, не заменяют
matching full. Это не полный S04 и не sustained/physical evidence. Команды, hashes и
сохранённые FAIL/прерывания — только в
[repo checkpoint](../deep-client-shared/docs/testing/s04-lifecycle-2026-10-11.md).
Diagnostic20 имеет зелёный TRX, но утраченный native terminal остаётся
unqualified; matching25 не переписывает этот исторический результат.

**Открыто до приёмки S04:**

**Stopped-work source increment (2026-10-11):** actual stable/native-committed
ordinary work now has an independent stop disposition in the existing authored
root (initial stopped-bit candidate was generation5; current retention candidate
is generation6, no extra journal). Explicit user cancel is
idempotent across cold reopen; dispatch and pending-text projection exclude it,
without erasing original requests/counters/grants/history or downgrading Store.
Original retry expiry closes unknown attempt custody and stops ordinary work
before peer refresh only after actual source-deadline and protected-lower-time
checks. Original policy joins use the existing closed historical namespace API;
latest XNA1 is not substituted for the exact signing ancestor.

Evidence is scoped: first focused56/0/native0 had wrapper1 from UTF-8 name-list
reading, then exact56-name qualification separately succeeded; this remains a
historical wrapper failure. Next32 cases had30/2/native1 (real original-PMA2/XNA1
join defect). Corrected source27 had26/1/native1 (negative fixture failed its
grammar before the owner). The fixture-only correction plus affected cancellation/
pending/stop cases now has matching22/0/0/native0/wrapper0, all1905 inputs unchanged,
build0/zero warnings/errors. The two genuine30-day expiry/root-renewal handovers,
late cancelled Store, issuer rotation and old expiry consumers passed in the27
scope; not rerun in22. These receipts are **not** one combined full PASS.
Details/hashes and preserved FAILs are in the
[Shared checkpoint](../deep-client-shared/docs/testing/s04-lifecycle-2026-10-11.md).
Current retention source candidate adds authenticated upper stop-time,
protected-plan deletion of the redundant working SQL payload and a durable
no-rehydration marker. Original unknown attempts and independent history stay
pinned. The exact local producer owns the layout, not this backlog. Source
qualification is scoped:126 had125/1 (real late-completion SQL dependency),
after the runtime correction133 had131/2 (two new fixture setup/expectation
failures), then fixture-only correction and affected connected paths had exact
10/0/0/native0/wrapper0 with1905 unchanged inputs and zero build warnings/errors.
Do not combine these scopes into a full PASS. Late/cached original Store and
actual next route/attachment author consume retained history without restoring
deleted working data. No whole-S04 or physical qualification is claimed.
The next connected source increment adds minimal separately authenticated stopped-work
audit in current Application SQL and protected-plan expiry, without erasing
original unknown attempts/native/history. Its producer, recovery and fault
fixtures are implemented. First matching build was zero warnings/errors;
focused161 had140/21/0/native1/wrapper1 with1907 unchanged inputs. All16 new audit
cases passed; the21 old SQL-effect fixtures predicted a fake fixed stop time.
The exact-time fixture correction and pending-author maintenance guard now have
matching zero-warning/error build and focused162/0/0, exact162,
native0/wrapper0 with1907 unchanged inputs; this includes all17 new audit cases
and all prior stopped-work regressions. The original161-scope FAIL is preserved.
This qualifies the stopped-native-ordinary package, not whole S04 or the entire
retention matrix. Exact private schema/layout belongs to
the [Shared owner](../deep-client-shared/docs/architecture/owned-authored-counter-custody.md#s04-independent-stopped-work-audit--source-candidate).
The next connected source candidate adds cancellation of exact pending/stable
ordinary drafts before native encryption, using their existing reservation,
SQL mirror, authored counter and stopped-payload plan. It forbids first encryption
of stopped drafts and preserves the next authored sequence. Qualification is
recorded separately in the Shared checkpoint: corrected fixture/build and exact
22/0/0, native0/wrapper0 with1908 unchanged inputs; original57-scope42/15 FAIL is
preserved (invalid short signed fixture, before cancellation). No whole-S04
claim follows.
Complete independent object-only-key retirement, successful/compacted Stored audit
and Initial/ContactAccept consumers remain open; the stop bit never supplies
deletion or non-delivery authority.

- independently authenticated changed-recipient route/continuity;
- grant/path/dependency и irreversible namespace retirement через actual
  current policy/time/DNH2/floors, с сохранением outstanding object/read/ACK work;
- stopped-work/cancel/expiry retention с сохранением Store/Delivered facts;
- восстановление уже исчерпанного offline PQ sender-а; cadence66-send/16-reply
  не закрывает bound32 exhaustion/recovery и не разрешает увеличить bound;
- genuine sustained128 grants/512 sends с success/pending/reject/unknown,
  backpressure и всеми cold/crash/cancel handovers без reset/eviction;
- final согласованный source package → required unfiltered full/frozen/preflight/
  exact prior-full/new-focused union/unchanged inputs → review → commit/push.

Порядок: закрыть один связный lifecycle package по actual Shared owner и принятым
S01 contracts, затем целевые проверки и пакет исправлений. Full/review/commit/push
принимают завершённый этап. Exact Pending/unknown ciphertext/request, replay
floors и original namespace сохраняются; новый journal/wire, remint, eviction
или продление старого send не заменяют transitions.

Единственное отдельно обоснованное выделение control wire для exhaustion —
[DR-0111](survival-program/decisions/DR-0111-bounded-braid-recovery-control.md).
Первым был реализован parser-only target Protocol с независимыми структурными
векторами/негативами: zero-warning/error build, exact40/0/0, native0/wrapper0,
1550 unchanged inputs. Это не работающая recovery, send/ACK authority или повышение
PQ bound. Durable native custody/transport activation остаются закрыты до
согласованного контракта и доказанного полного production цикла.
Внутренний native component contract теперь отдельно заморожен в
[DR-0112](survival-program/decisions/DR-0112-owned-braid-control-component.md);
его source candidate реализован: zero-warning/error build, exact68/0/0,
native0/wrapper0,1559 unchanged inputs. Actual approved native exchange восстановил
обе стороны после32 sends, затем fresh bidirectional data и все64 старых pending
ciphertexts прошли через cold TRS1 handovers. Это in-memory component evidence,
не production SQL/floor/transport/device qualification.
Durable SQL/floor custody, unknown/crash/cancel settlement, dependency retirement
и transport/ACK activation остаются открыты; это всё ещё подзадача S04.
Closed Protocol durable API и local control mapping теперь принадлежат
[DR-0113](survival-program/decisions/DR-0113-owned-braid-durable-boundary.md).
Source join actual account owner → SQLCipher/protected floor реализован;
в44-case run прошли exhausted-peer recovery, fresh bidirectional data, все63
original pending envelopes и шесть commit-crash handovers. Сам run сохраняет
43PASS/1FAIL: negative ожидал более поздний отказ при operation collision.
Исправлена только эта проверка, затем exact7/0/0 с prerequisites и1932 unchanged
inputs; это не matching44/full acceptance. Точные FAIL/PASS receipts и оставшиеся
unknown-control/dependency/key-retirement/transport условия — в
[Shared checkpoint](../deep-client-shared/docs/testing/s04-braid-durable-2026-10-11.md).
Следующий связный control/history source package теперь имеет matching47/0/0,
native0/wrapper0,1933 unchanged inputs и zero-warning/error build. Actual owner
прошёл все шесть compaction handovers/cold resume, exact control replay после
реального удаления link0, protected-history rollback и SQL-frame substitution
negatives. Matching Protocol85/0/0 подтвердил pinned-frontier backpressure,
правильный порядок ordinary receive до link retirement и сохранность старых
skipped data. Это не whole-S04: actual control cancellation, unknown-control
settlement/dependency retirement, transport/admission/ACK и final gates остаются.
Actual control cancellation теперь отдельно проверена одним связным exchange:
cancel до commit на обеих сторонах и все шесть send/receive AfterPending/Sql/Stable
handover, encrypted cold reopen, точные staged bytes и один native increment,
затем fresh bidirectional data. Matching20/0/0,native0/wrapper0,1934 unchanged
inputs, zero-warning/error build включает прежние crash, route-control и ordinary
send/receive consumers изменённого test-only async hook. Это не сумма47+20 или
full acceptance. Следующее незакрытое соединение — original unknown-control
settlement/dependencies вместе с closed mailbox Store/Retrieve/control-before-ACK;
parser-only или silently ignored stale frame не дают такой authority.
Connected mailbox target теперь отдельно закреплён в
[DR-0114](survival-program/decisions/DR-0114-owned-braid-mailbox-lifecycle.md) и
единственном semantic owner §8.4.5. Connected source candidate реализован: closed readonly
installed-output/original-MAC disposal proof, actual protected peer-data progress,
catalog-bound DBR receive и rederived control-before-tombstone ACK. Нет fake
direction4/DMC2, extra journal/root/schema, trusted caller flags или AppAck.
Отдельный control Store использует существующие exact attempts/MAU/grant/counters,
не ordinary DMC2/deadline/stop marker. Historical Store проверяется по исходному
подписанному quorum; authenticated peer-data progress запрещает новый dispatch,
но не удаляет unknown Store или его exact custody. Actual exhausted peers прошли
Store/Retrieve/ACK, lost Store/ACK replies, cold retry и pending-data recovery:
отдельный matching50/0/0,1940 unchanged inputs. После test-only дополнений отдельный
matching7/0/0,1940 inputs подтвердил first obsolete control, original-root retirement,
cold exact ACK и неизменность unknown Store. Protocol matching91/0/0,1565 inputs
включает closed API surface и real-native readonly negative cases. Все builds0,
zero warnings/errors; native/wrapper0. Это отдельные source snapshots, не сумма
50+7 или matching full. SQL/crypto production source после первого50 не менялся.
Full/package/downstream, полный unknown/crash/cancel/retirement scope и остальные
S04 lifecycle/sustained requirements остаются открыты; activation/physical нет.
Точная локальная qualification — в
[Protocol checkpoint](../deep-protocol/docs/testing/s04-braid-recovery-2026-10-11.md)
и [Shared checkpoint](../deep-client-shared/docs/testing/s04-braid-durable-2026-10-11.md).

Original control Store/retirement теперь соединены через существующий protected-only
Audit plan: every original attempt проверяется независимо, redundant send entries
удаляются без удаления exact SQL/native/request/evidence/dependency/floor custody.
Actual encrypted cold/crash/cancel package имеет matching16/0/0,1942 inputs.
После добавления transport admission до native entropy пакет18 сохранил16PASS/2FAIL:
оба новых negatives отвергались при подготовке слишком короткого fixture ciphertext,
до owner. Исправлен только размер fixture; отдельный matching8/0/0,1942 inputs
подтвердил оба negatives и шесть prerequisites. Все builds0/zero warnings/errors;
это не aggregate18/full или sustained128/512. Точные intervals/hashes и исходный
FAIL сохранены в Shared checkpoint. Initial/ContactAccept stopped retention,
independent object-only-key closure, sustained и final S04 gates остаются открыты.

Initial/ContactAccept original retry preflight теперь выполняется до fresh recipient
contact/directory lookup, после independently verified historical Stored. Actual
native/draft/recipient или protected acceptance join задаёт deadline; upper time
запрещает отправку, lower time разрешает existing original-attempt closure без
нового grant/ciphertext/request. Matching17/0/0,native0/wrapper0,1943 unchanged inputs
и build0/zero warnings/errors подтвердили unavailable recipient на обоих путях,
оба closure handovers/cold reopen и прежние Initial retry/successor negatives.
Это не complete contact payload/key/audit retention или whole-S04; ни новый journal,
ни wire/generation не добавлены. Exact evidence — в
[Shared lifecycle checkpoint](../deep-client-shared/docs/testing/s04-lifecycle-2026-10-11.md#initial--contactaccept-original-retry-expiry-before-recipient-refresh).

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
  Isolated native evidence также выявило незакрытое offline PQ saturation:
  после32 unanswered sends один old-epoch reply не позволяет завершить новый
  Braid exchange. Нужно безопасное admission/recovery с actual owner evidence;
  bidirectional compaction fixture, повышение cap или fake freshness это не закрывают.
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
