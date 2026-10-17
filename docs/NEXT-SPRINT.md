# Текущая очередь Deep / XPoint

Обновлено: **2026-10-17**. Branch: release-candidate/prod-20260909.
Владелец, если не указан иной: **Mr. X**.

Единственный порядок, зависимости и критерии приёмки —
[IMPLEMENTATION-PLAN-V1](architecture/IMPLEMENTATION-PLAN-V1.md).
Основание — [аудит](architecture/ARCHITECTURE-AUDIT-2026-10-03.md),
[DR-0082](survival-program/decisions/DR-0082-integration-first-delivery-baseline.md)
и [DR-0095](survival-program/decisions/DR-0095-baseline-and-shipping-gate-separation.md).
Это очередь незавершённого, не второй specification или хронологический changelog.
Предыдущие наблюдения, исходные FAIL и exact receipts сохраняются в Git,
[исторической редакции](NEXT-SPRINT-CHECKPOINTS-2026-10-13.md) и repo-checkpoints.

## Первый приоритет: CLI-first вертикальный сценарий внутри S05

По решению Mr. X от **2026-10-17** первой задачей становится разработка
[deep-cli](../deep-cli/README.md). Следующая бизнес-итерация не начинается
со сборки/установки MAUI: сначала два независимых CLI-профиля проходят реальный
путь контактов → двустороннего текста → вложений/картинок → групп в локальном
Docker-контуре. Существующие S05 blockers воспроизводятся и исправляются здесь.
Порядок и критерии — [CLI-first в едином плане](architecture/IMPLEMENTATION-PLAN-V1.md#cli-first--первый-приоритет-внутри-s05).

Использовать текущие Shared/Protocol, native crypto, SQLCipher и настоящий
Registry/XNode transport, не mock E2E и не второй стек. Сначала local account/
profile и общий headless composition, затем законченный contact/text/recovery
slice; files/groups — после него. Slice → focused gates → исправления; дорогие
full/package gates — на согласованном пакете. Windows/Android device E2E
остаются финальной проверкой платформ и UI, не основным циклом отладки.
CLI PASS не даёт device acceptance и не снимает release blockers.

Первый CLI account slice реализован: real Shared DID2 create/status/address,
раздельные Windows DPAPI/SQLCipher профили, запрет overwrite, closed errors и
cancellation. Focused12/native0/0skip, без compiler diagnostics; два новых QA
аккаунта различны и сохраняются после reopen. Отдельные реальные процессы CLI
подтвердили6 account/reopen/overwrite/status checks/native0. Общий headless
composition и команды network/contact/consent/mailbox/text теперь реализованы
через текущие owned API Shared. CLI focused30/native0/0skip. На retained паре
подтверждены настоящий `IncomingRequest` и локальное согласие; оно истекло во
время диагностики, сроки не увеличивались. Более поздний exact request прошёл
claim до Store; Store исчерпал15s (81 lease-check,12.5s authority work).
Node source-кандидаты:75 affected IO/authority,35 claim и18 public-head
memo/native TLS Store/Retrieve/ACK/reopen tests PASS/native0. Это последовательные
source scopes, не один final full или connected acceptance. Сейчас проверяется
повторная signature-верификация98 неизменных public heads на каждом lease-check;
actual protected files/MAC/anchor/index всё ещё читаются и проверяются.
Дополнительно исправлен общий resource budget forwarded claim (35 focused PASS).
CLI затем локализовал отказ genesis threshold при обычном view renewal:
автор не привязывал frozen XRA к его exact logical assignment, а static graph
сохранял obsolete PMT/issuance-view equality. Регрессия воспроизведена до
исправления; после него Shared5 и Protocol20 focused PASS/native0/0skip.
Подписанная старая выдача как новая authority и смена epoch остаются запрещены.
[Source scope и исходные FAIL](../deep-protocol/docs/testing/s05-pending-route-assignment-2026-10-17.md).
[Точные ограничения и receipts](../xnode/docs/testing/s05-cli-contact-text-2026-10-17.md).
Исходные unknown intents/native reservations сохранены, rollback/reset/новых
wire/journal formats нет. Следующий результат — работающий CLI↔CLI contact/text;
до него к Windows/Android не возвращаться. Device/release acceptance не получена.

## Единственный активный этап: S05

**S00–S04 приняты в своих source scopes; S05 не принят. S06/device acceptance
не получена.** Diagnostic device runs внутри S05 не открывают параллельные этапы.
Не повторять принятые gates без изменения входов или конкретной verification цели.

Исходный блокер этого среза — восстановление expired active Retrieve,
наблюдённое на APK36 (`51eda49` / Shared `ca1df5f` / Protocol `d2e3d42`),
без сброса retained аккаунта. [DR-0133](survival-program/decisions/DR-0133-expired-owned-retrieve-attempt-closure.md)
выделяет closure только uncaptured phases1/2; реализация пока source candidate.
Protocol139, Shared affected44 и final40 прошли; final40 без compiler warnings.
Matching APK37 сохранил account/recovery и подтвердил Verified; первоначальный
refresh завершился onion OutcomeUnknown при retained-grant acquisition.
Исходная uncertainty сохранена, noncommit из таймаута не выводится.
Closed node metadata локализует новый отказ в private grant HTTP client;
read-only TLS/liveness/method probes проходят. Source diagnostics Node32 /
Registry33 PASS (0 warnings), без изменения authority или исходов. Matching
runtime DLL/PDB доказали immediate shared-gate busy throw в Registry. Исправление
использует существующий single private-issuer waiter в прежнем30s бюджете;
background refresh остаётся non-queuing. Admission80 и real TLS/PostgreSQL2 PASS,
без warnings. Matching local build10/Up11/smoke12 прошли native0:9 ожидаемых
images, все54 прежних mounts сохранены, readiness68s. Raw representation FAIL
и отдельное finite-equivalence proof сохранены раздельно. APK37 Refresh106 ->
независимый Inspect110 и Windows build20 завершили входящую синхронизацию без
ошибки, на прежних аккаунтах с encrypted recovery. Это empty-mailbox read, не
contact/text delivery или sustained acceptance;
[точные ограничения](../xnode/docs/testing/s05-private-grant-hop-2026-10-16.md).
Captured page/semantic/ACK phases3–6 остаются pinned и не считаются исправленными.
Следующий actual retained-contact отказ: Android Retry117 -> Inspect118/Scroll121
останавливается на exact draft-metadata equality (`PrepareInitialContactDraftAsync`,
IL4129; matching build PDB line86). Какая из привязок отличается, не установлено;
не ослаблять guard и не заменять прежний intent. DR-0064 требует сохранения exact
draft; текущая проверка нового запроса с другого устройства не закрывает этот
retained retry. [Физический checkpoint](../deep-client-maui/docs/DID2-HTTPS-DEVICE-2026-09-28.md).
Отдельно Windows contact operation наблюдалась Busy; после повторной активации
QA независимый UI подтвердил terminal protected-state failure. Closed log
локализует его в `ProtectedDid2MailboxGrantJournal.OriginalCeiling` line624 при
подготовке Deposit custody для Initial. Сверка именно build20 DLL/portable PDB
уточнила диагноз: IL758 соответствует отказу «no possible grant interval»,
а не compound binding guard line616. Shared ошибочно ограничивал logical route
коротким окном исходного PMT snapshot; исправление согласует ceiling и current
issuer joins с уже принятым DR-0122. Затронутые41 tests PASS/native0, включая
persist-before-callback, lost reply, cold exact retry и SQL install; это source,
не физическая доставка. [Receipts и ограничения](../deep-client-shared/docs/testing/s05-logical-grant-custody-2026-10-16.md).
Source audit
нашёл отсутствие foreground attempt budget; candidate добавляет отмену actual
token через2m только после очереди, сохраняя lease до drain и исходную uncertainty.
Red1/2 FAIL сохранён; reconnect/messaging49 и unfiltered MAUI Clean254 PASS,
0 warnings. Это scheduling correction, не установленная причина async wait или
device fix; [matching build/retest ещё требуются](../deep-client-maui/docs/S05-FOREGROUND-DEADLINE-2026-10-16.md).
Точные [source receipts и оставшиеся проверки](../deep-client-shared/docs/testing/s05-expired-active-retrieve-2026-10-16.md)
не заменяют matching device/full/package acceptance. Далее — retained-account
contact/text; затем по единому плану attachments/groups. Matching Windows22/APK38
установлены без сброса аккаунтов/recovery, builds native0 без compiler diagnostics.
Старый Windows intent отвергнут по expired XUR; штатная остановка подтверждена.
Отдельный новый запрос прошёл grant custody до Store, но завершился OutcomeUnknown
с inner cancellation; его точный повтор отменился до нового dispatch. Android
Retrieve также OutcomeUnknown. Следующий blocker — конкретная задержка bounded
owned/authority работы; не увеличивать сроки authority или вводить plaintext cache.
Shared использует существующий atomic inventory batch для4 network
markers и пары directory markers вместо отдельных расшифрований:47 focused
PASS/native0 без compiler diagnostics. Это сокращение чтений, не доказанное
ускорение устройства. Matching Windows23/APK39 собраны без diagnostics и
установлены без сброса. Старый XUR retry закономерно истёк; после штатного stop
свежий запрос снова завершился OutcomeUnknown с отменой при directory batch
validation. Android Retrieve также OutcomeUnknown. Actual forwarding, storage
и приём контакта не подтверждены; прежний intent сохраняется, нужен узкий
разбор latency/cancellation в настоящем пути.
QA source теперь измеряет actual business totals существующим закрытым
observer (14 focused PASS/native0), а не подменяет их background VerificationTotal.
Только elapsed/count/protectionMs, без payload/адресов/slot names или новых
таймаутов; [scope](../deep-client-maui/docs/S05-BUSINESS-WORK-2026-10-17.md).
Matching Windows24/APK40 сохранили аккаунты/recovery. Exact Windows retry
отменился через120031ms:1738 Unprotect, protection78880ms. Android Retrieve
остался OutcomeUnknown (40780ms,304 Unprotect). Это не доставка и не доказательство
noncommit. Candidate объединяет application registrations/roots6→1 и actual
held directory/network floor recheck через один SQL transaction + один atomic
marker inventory; каждый вызов заново читает ключ/markers, без plaintext cache,
новых wire/API/generation или сроков. Final affected39 PASS/native0, без
compiler diagnostics; owned claim→Store→cold exact retry и Initial/Accept
lost-reply3 PASS/native0. Это source fixtures, не device delivery;
[scope/остаток](../deep-client-shared/docs/testing/s05-owned-read-batch-2026-10-17.md).
Matching Windows25/APK41 сохранили аккаунты. После expired-XUR отказа и
штатного stop отдельно новый Windows Store снова OutcomeUnknown/peer504.
Android retained Retrieve остановился на проверке времени первого ответа;
actual DLL/PDB подтвердили guard, но не отдельное условие. Diagnostic candidate
сохраняет все8 ordered predicates и выводит только закрытую метку причины:
Protocol140 и MAUI Clean271 PASS/native0, без compiler diagnostics. Не считать
это clock fix, разрешением принять future result или device acceptance.
APK42 установлен после отдельного preflight retry; actual installed APK SHA256
совпал с локальным. На устройстве наблюдён ANR, Refresh не подтверждён.
Source-тест воспроизвёл UI-context capture фонового worker; correction запускает
worker и native conversation work вне UI, сохраняя foreground caller context,
lane/deadlines. Red1 FAIL сохранён, unfiltered Clean272 PASS/native0, без
compiler diagnostics. Bounded matching retest описан ниже; причина
retained-result time refusal остаётся неизвестной, guard не ослаблен.
Отдельный unfiltered MAUI Smoke119 PASS/native0 (без compiler diagnostics)
не заменяет matching физический ANR/receive retest.
Matching Windows26/APK43 native0 без diagnostics; installed APK hash совпал,
Settings166 сохранил account/recovery. Chats167/Refresh168/Inspect169 доступны,
ANR в этом bounded проходе не наблюдался (не sustained acceptance). Retained
result guard пройден, но Retrieve вернул OutcomeUnknown/peer504; matching PDB
подтвердил non-success response в ForwardAsync, не local cancellation.
Node `17cee31`: focused43 PASS/native0; supported local Build13/Up14/Verify15
native0,9 desired images и54 mounts сохранены (отдельный finite path-alias proof,
не raw representation PASS). APK43 Refresh173→Inspect174 снова OutcomeUnknown;
actual runtime DLL/PDB указывает ReadCurrentWindowAsync:47 — live unresolved
native Store custody. Без correlation IDs это не привязка к конкретному старому
sender intent и не причина его первоначального Store failure. Windows26 сохранил
pending request; отдельный exact Retry остановлен XurWindow до нового Store.
Следующий узкий blocker — bounded settlement/recovery исходного native pending
Store и expiry boundary. Не пропускать pending cursor, не remint peer request,
не продлевать XUR/grant, не заменять recovery новым аккаунтом. Точные результаты:
[business checkpoint](../deep-client-maui/docs/S05-BUSINESS-WORK-2026-10-17.md#retained-local-deployment-and-native-pending-store-diagnosis).
Physical acceptance по-прежнему0/4; S05 не принят.
Native source `30cd519` добавляет host-owned exact Store recovery и последующее
adoption того же saved quorum клиентом без нового peer HTTP. Initial22,
expanded164/final23, closed-observer5 и authority-reason3 focused PASS/native0 без diagnostics;
новые nonce/grant/ciphertext, expiry bypass и новый журнал не добавлены. Exact scope:
[node recovery checkpoint](../xnode/docs/testing/s05-native-store-recovery-2026-10-17.md).
Matching Build16/Up17/Verify18 прошли, но APK43 Refresh177/Inspect178 снова
OutcomeUnknown/native pending Store. Observer Build22/Up23/Verify24 прошёл на
9 desired images/54 прежних mounts; runtime подтверждает GrantExpiry в original
grant admission, не доказательство lower-time exclusion, noncommit или допустимого
retirement. [DR-0134](survival-program/decisions/DR-0134-original-store-expiry-exclusion.md)
заморозил closed original Store expiry boundary без новой wire/journal generation.
Protocol `9d6df07`:125 affected PASS/native0, без diagnostics. Node candidate
связывает prefix/read с actual protected original, authenticated lower expiry и
native serialization/recheck, сохраняя bytes/unknown/floors; invalid durable quorum
не обходит проверку через expiry. Initial fixture27/7 FAIL сохранён, corrected9
PASS; expanded52/3 и final12 PASS/native0 закрыли affected scope после исправления
двух native exception contracts и canonical TTL fixture. Без compiler diagnostics;
[точные scopes и оставшиеся full/package/business gates](../xnode/docs/testing/s05-store-expiry-exclusion-2026-10-17.md).
Никаких signed-window extension, новых nonce или пропуска live Pending по флагу.
Matching local Build25/Up26/Verify27 native0:9 desired images и54 mounts сохранены;
raw representation FAIL и отдельный finite alias proof1 не смешиваются.
APK43 Refresh180→Inspect182 завершил read sync без ошибки; Windows26 после первого
native-deadline/OutcomeUnknown прошёл один штатный UI retry без сброса. Это read
recovery, не contact delivery; прежние unknown intents и4 ожидающих диалога
сохранены. Android Add186 сначала спроецировал прежний pending; отдельный exact
Retry188 снова остановился на retained draft metadata equality в
PrepareInitialContactDraftAsync IL4129/source86, до нового Store. Actual business
69531ms,3 Protect/382 Unprotect,35200ms protection; Contacts192 подтвердил ошибку.
Следующий код — original Initial draft/current-dependency recovery; какая
привязка отличается, пока не установлено. Не ослаблять guard и не заменять intent.
Source candidate по [DR-0135](survival-program/decisions/DR-0135-owned-initial-retry-expiry-entry.md)
вводит существующий actual-owned expiry owner перед peer resolve, сохраняя
приоритет authenticated durable Store и все unexpired metadata checks.
Typed informative outcome снимает только exact UI retry choice; новый запрос
возможен лишь отдельной командой Add после повторного чтения protected roots.
Аккаунты не сбрасываются. Initial affected22/5 FAIL сохранён: пять scoped-claim
fixtures ожидали прежнее число network fetches; correction сохраняет exact
count assertion с дополнительным own proof. Final affected29 PASS/native0/0skip,
без compiler diagnostics, включая actual native stop/cold reopen и durable
Store precedence. Это не canonical full; full/package и matching device pending;
[scope](../deep-client-shared/docs/testing/s05-initial-retry-entry-2026-10-17.md).
Matching Windows27/APK44 (`8181f0a` / `f63b432` / `9d6df07`) собраны native0
без diagnostics и установлены с прежними аккаунтами/recovery, Android Verified.
Windows exact old Retry штатно закрыл proven expiry без автоматической замены
(17668ms). Отдельный новый Add и один exact Retry отказали в permanent-contact
read: ForwardOnceAsync:146 / ingress HTTP:299,46429ms и5650ms. Это before-forward
ingress refusal, не новый Store или contact delivery; точный error class ещё
не установлен. QA-only closed-label correction проверен Clean284/native0/0skip;
matching diagnostic builds/retest pending, server/authority не менялись.
Matching Windows28 (`a2a758a`, runtime Shared `f63b432`, Protocol `9d6df07`)
прошёл native0 без diagnostics и сохранил аккаунт. Add выбрал actual protected
pending, отдельный exact Retry завершился на прежнем120s foreground budget:
120050ms,9 Protect/1809 Unprotect,75840ms protection. Cancellation находится в
OpenInitialSessionCustodyAsync:28 / OpenCurrentDeviceStateStoreAsync:109 при
RequireRetainedInitialDraftAndRecipientUnderLeaseAsync:208. Independent UI уже
не busy, сохранил retry choice и показал отмену. Предыдущий ingress class не
воспроизведён и не установлен. Следующий узкий код — повторные device-source /
retirement/checkpoint inventory reads; actual native/SQL/cancellation joins
сохранить, не вводить plaintext cache, не продлевать сроки. Android44 остаётся
установлен; diagnostic-only APK заново не собирался.
Device-source candidate объединяет actual registration+marker в один fresh
inventory и registration+retirement+optional draft/catalog в другой. Штатный
cancellation owner всё ещё читает actual native floor/history; независимо
от каждого вызова нет plaintext cache или пропуска SQL/root checks. Source union
с новыми missing/foreign/cancel/cold tests прошёл53/0FAIL/0skip/native0 без
compiler diagnostics. Это affected scope, не canonical full или device speedup.
[Границы изменения](../deep-client-shared/docs/testing/s05-owned-read-batch-2026-10-17.md#device-source-and-retirement-opening).
Затем actual contact request/accept и text. Full/package и device business
acceptance пока0/4.
[Охват source-проверок](../deep-client-shared/docs/testing/s05-protected-floor-batch-2026-10-16.md).
[Физические результаты и ограничения метрик](../deep-client-maui/docs/DID2-HTTPS-DEVICE-2026-09-28.md).
Physical acceptance0/4.

Installed diagnostic source:

| Device | MAUI | Shared | Protocol | Artifact |
| --- | --- | --- | --- | --- |
| Windows | `20b16b2` | `e78290f` | `9d6df07` | build31; exact identity/recovery/Verified retained; exact Retry113584ms reached Store, native quorum-not-durable; acceptance absent |
| Android | `20b16b2` | `e78290f` | `9d6df07` | APK47/update230 without reset; account/recovery and Verified retained; Refresh235 received Initial but claim promotion rejected |

Android harness ошибочно принимал stale WindowManager IME flag за открытую
клавиатуру. Узкое исправление читает actual input-method service state после
прежнего package-owner guard; неоднозначный формат отвергается. Clean285
PASS/native0/0skip, это source, не physical acceptance. Следом — retained APK45
readback/receive и разбор native Store deadline, без reset/blind retry/новых сроков;
[matching receipts и ограничения](../deep-client-maui/docs/S05-BUSINESS-WORK-2026-10-17.md#device-source-batch-matching-builds-and-keyboard-harness).
На APK45 Settings208 и Scroll210 после harness fix подтвердили retained
account/recovery и Verified без reset. Одно Refresh212 пока Busy; завершённый
MailboxSync не наблюдён. Windows29 отдельным read загрузил локальную историю,
не сетевую доставку. Installed Node DLL/PDB локализовал наблюдённый IL163 на
ожидании network gate; это не correlation с Windows-запросом. Node `c29f5c9`
добавляет только закрытые resource timings,34 affected PASS/native0/0skip;
[точные границы](../xnode/docs/testing/s05-private-grant-hop-2026-10-16.md#2026-10-17-native-network-gate-observation).
Matching Node `c29f5c9` Build28/Up29/Verify30 прошли native0:9 exact images,
54 retained mounts, readiness62s. Raw comparison4 bind aliases отличается от
отдельного конечного normalized proof. Первые proof-acquire work1–4s /
network-verify163–358ms не воспроизводят старое30s gate wait. APK45 incoming sync
завершился без ошибки:70937ms,0 incoming/outgoing/accepted rows. Это empty read,
не contact delivery. Windows29 отдельно снова Verified; exact original Retry
штатно завершил owned expiry за29330ms: retry choice снят, no error, без
автоматической замены. Только отдельный Add00:28:03Z начал новую работу для
того же QA peer: отмена120047ms,30 Protect/1717 Unprotect,69458ms protection,
сохранён exact retry/no Busy. Closed stack локален: ReadOwnedBatchAsync101 →
retirement ReadAsync242 → native ReconcileInitialSessions308 → mailbox envelope91.
Исходных remote effects это не исключает. Следующий source candidate объединяет
idle compaction16 parts и pending floor+18 parts в fresh bounded inventory;
affected80/0FAIL/0skip/native0 без compiler diagnostics, включая encrypted
cold handovers и negative/freshness tests. Это source; matching builds теперь
установлены ниже, actual contact/device acceptance всё ещё отсутствует;
[точный scope](../deep-client-shared/docs/testing/s05-owned-read-batch-2026-10-17.md#segmented-custody-read-candidate).
Authority/cache/deadlines не менялись.
Physical business acceptance0/4.

Segmented candidate matching Windows30/APK46 native0 без compiler diagnostics;
оба retained без reset. Windows30 actual Retry после очереди114784ms дошёл до
Store transport, OutcomeUnknown. Он совпал со сборкой Android и не является
чистым performance benchmark; дальнейшие Windows attempts — без heavy builds.
Новый node2 native event IL325 установленным PDB локализован в generic mutation
rejection, не прежнем gate wait. Closed reason49 PASS; matching local
Build31/Up32/Verify33 native0,9 images/54 retained mounts. После owned expiry
старого retry отдельный fresh Add завершился OutcomeUnknown107650ms; actual
native reason `BlobTtl`. Поставляемый cap7d противоречил protocol/product30d.
Node `ea9f796` исправляет binding и запрещает shorter cap при current-host startup;
148 focused PASS/native0/0skip, без compiler diagnostics. Сроки signed objects,
authority и retry не продлевались. Matching local Build34/Up35/Verify36 native0,
readiness17s,9 desired images/54 retained mounts. Отдельный health read подтвердил
native recovery1/2; node3 unavailable/checking (`revocation-context`), поэтому
sustained recovery не заявлена. Windows retained account снова Verified;
физический приём ещё не получен, точный unresolved intent сохранён. Exact retry
30900ms остановился до dispatch на сравнении original Store evidence с новым
current view. Два native encrypted cases воспроизводят тот же guard (red0/2,
native1); candidate сохраняет оригиналы, независимо проверяет signed history
и равенство receipt keys вместо byte-equality current/old carriage. Source23
PASS/native0/0skip, без compiler diagnostics; matching client builds/retry ещё требуются;
[scope](../deep-client-shared/docs/testing/s05-logical-grant-custody-2026-10-16.md#2026-10-17-pending-initial-across-ordinary-carriage-renewal).

Matching Windows31/APK47 установлены без reset. Точный Windows retry прошёл
старый evidence guard, но Store завершился quorum-not-durable/OutcomeUnknown.
Android получил Initial до claim promotion, где отказал current-placement guard;
owned source regression воспроизводит его после обычной смены view (red0/1,
native1). [DR-0136](survival-program/decisions/DR-0136-committed-claim-original-carriage.md)
выделяет original committed allocation как read-only fact при неизменном current
cohort/epoch, сохраняя все current endpoint/inventory/revocation gates. Protocol
focused13, затем crypto witness14 PASS/native0/0skip без diagnostics. Final
encrypted owned receive/ContactAccept/reply и policy-negative2 PASS; отдельно
issuer-rotation2 PASS, без warnings. Native closed peer diagnostics118 PASS;
matching activation ещё требуется. Registry preview выявил накопленный drift
7 sources/175 anchors; blind repin не применялся, full/package остаются open.
Peer quorum cause остаётся отдельным
незакрытым отказом этого же S05 vertical; правило120s не ослаблено. Physical0/4.
[Matching scope и ограничения](../deep-client-maui/docs/S05-BUSINESS-WORK-2026-10-17.md#segmented-custody-matching-builds).

Matching Windows32/APK48 retained accounts and Verified, but Android Refresh243
stopped at the original Retrieve grant expiry before the corrected claim path.
Independent Inspect244 confirmed a terminal error. The exact captured page is
retained; no reset. [DR-0137](survival-program/decisions/DR-0137-captured-final-page-expiry-continuation.md)
separates local historical final-page completion from independently current ACK
authorization before any original ACK preparation; source qualification is in progress. Non-final
pagination, expired prepared ACK and captured ACK-response expiry stay closed. Initial encrypted
regressions0/2/native1 reproduce the original guard. Corrected source batch16/1
native1 found only a premature fixture retry; after advancing both fixture clocks
without changing the runtime lease, final focused2 PASS/native0/0skip/no compiler
diagnostics. Native review rejected a permissive intermediate re-ACK fixture;
expired prepared ACK stays pinned. Matching clients remain pending. This does not promote the
physical acceptance count or release status; [scope](../deep-client-maui/docs/S05-BUSINESS-WORK-2026-10-17.md#captured-final-page-authority-expiry).

Local native37/38/39:9 desired images/54 retained mounts, native0, subsequent
point-in-time native recovery3/3. Windows33/APK49 build native0/0 diagnostics;
Windows33 retained identity/recovery and Verified. Android245–252 were wrongly
labeled: Inspect did not install49, so their UI and expiry event belong to old48.
Actual Install253 plus independent installed-APK SHA256 check established49 only
afterward; business validation is still pending. The corrected harness rejects
that phase mix-up and requires exact installed executable bytes before/after UI;
26 focused contracts PASS/native0/0skip. Raw old receipts are unchanged and
explicitly disqualified as49 evidence. [Provenance and scope](../deep-client-maui/docs/S05-BUSINESS-WORK-2026-10-17.md#installed-apk-provenance-correction).

Actual APK49 Refresh259 and independent Inspect260 now confirm that the
captured-page continuation and committed-recipient claim verification pass;
first Initial preparation stops at its embedded expired ContactHello XUR.
Windows33's old intent reached the normal terminal-expiry UI; the separate new
intent remains outcome-unknown after120s. A fresh independent Windows observation
confirms retained retry/stop controls and an error, not successful delivery.
Do not duplicate either intent or reset either account.
[DR-0138](survival-program/decisions/DR-0138-expired-authenticated-initial-disposal.md)
defines terminal authenticated expired-Initial disposal, with no live contact,
session or transferable ratchet keys. The connected Protocol/native/ACK source
batch passed12 focused cases/native0/0skip without compiler diagnostics,
including actual native pending/SQL/stable recovery, lost-ACK exact replay,
uncertain-time refusal, two SQL proof-corruption refusals and a separate current
contact on the same retained accounts after disposal. Protocol focused surface,
current/retained endpoint and claim-crypto scope passed22/native0/0skip. Full
source/package/frozen input qualification remains. Matching Windows34/APK50
are installed without reset and retained account/recovery/Verified. Android's
first attempt now reaches ACK instead of XurWindow, but exceeds the120s whole
operation deadline; an ordinary exact retry reaches managed ACK ingress and
fails after81s. The same window has a recipient peer crypto-authorization403;
the exact predicate/correlation is not yet known. Preserve the original ACK,
grant, page and unknown outcome. Matching diagnostics and legitimate original
outcome recovery are next, not a new ACK or timeout/authority bypass.
[Physical scope](../deep-client-maui/docs/S05-BUSINESS-WORK-2026-10-17.md#matched-expired-initial-update-ack-remains-unresolved).
Peer403 diagnosis now has closed owned-method/IL and authority-check metadata;
its two focused cases pass/native0; matching local Build40/Up41/Verify42 passed
with retained mounts. The broad331-case selection was interrupted/native-1/noTRX
after two different rows failed at Store (invalid-continuation cursor setup and
lost/rolled-back-intent false recovery). Targeted6/native0/0skip now pass with
unchanged assertions/budgets; the original timing failure remains unexplained.
The broad run is unqualified, not superseded by the narrow PASS. Read-only raw
metadata also finds the recent node2 tombstone target absent in3's independently
resolved current mutation directory. This is not authenticated noncommit or
permission to copy state; [scope and remaining checks](../xnode/docs/testing/s05-private-grant-hop-2026-10-16.md#peer-ack-authorization-diagnostic-follow-up).
Peer send cancellation followed by expired/stale ingress is a separate observed
liveness blocker; no identifier-level correlation is asserted. Physical0/4,
S05 and release remain unaccepted; no timeout/lifetime rule was relaxed.

Windows build12 не запускался и не является installed evidence. Source `229c3da`
исправляет закрытый BootstrapAuthority I/O wrapper; matching Windows reached
Verified и завершил Chats sync без ошибки, Android reopened retained workspace.
Typed429/503 recovery физически не инъецировался. Historical runtime at that observation:
Registry `20be804` (local route admission update), Node `b8b7674`;
Registry NTS helper `dd36774`, publisher
`f4a77ca` (no production change).
The earlier local Registry/node images compiled Protocol `0867668` under
DR-0127. Up11 verified the exact Registry image, all three exact node images and
unchanged29 volume /25 bind identities; supported smoke12 exited0. Both retained
device profiles then reached explicit verified-publication/proof success.
Sustained readiness and physical business acceptance are still missing:
Android later became Unavailable and its Add01/02 observed no Store; a supported
owned contact scroll confirms the network-ready prerequisite refusal. The
repeated background failures are Cancelled in local account/floor/compaction
reads at the unchanged2m bound, not an established network-only cause. Windows16
actual incoming synchronization ended OutcomeUnknown at HTTP ingress. Existing
closed node logs locate a ContactResolve exit custody-or-io failure and two relay
504 responses. Diagnose its inner operation and Android's bounded recovery cost;
no reset, replacement intent or longer deadline is a remedy. Physical acceptance
remains0/4. Current exact evidence is in the linked device/contact checkpoints.
Node's bounded inner-cause diagnostic passed11 focused and133 affected
regressions. Component build13 / supported Up14 verified its exact image on all
three nodes, unchanged Registry09 and29/25 mounts; smoke15 exited0. Windows16's
single incoming refresh at05:24Z completed with an empty list, so the earlier
exit failure is not yet reproduced or explained. Android25 Verify03 still
failed with retained state. QA-only stage/protector work-cost source passed52
focused and227 unfiltered Clean-project cases. Matching APK27 retained update
measured1226 unprotect calls /66.8s protection in a120.1s cancelled verification.
Shared `f87fc97` batches twelve independent local journal reads into one actual
atomic inventory read, without cache, omitted validation or authority changes.
The encrypted source fixture reduces repeated reopen reads19 ->8; focused05
passed39, affected regression03 passed104, contact04 passed32, all native0 with
no failure/skip. Full source and physical business qualification remain open.
APK28 did pass exact packaged-code verification and
retained update:103.8s /1008 unprotect calls /53.6s protection, but registration
still failed at the existing `VerifyDtt` binding guard and UI became Rejected.
The failed subcondition is not yet proven. A separate signed source race is
reproduced and corrected under DR-0128: Protocol `cacbd67` adds only a read-only
strictly-newer-view observation; Shared `32de907` permits one bounded complete
reacquisition, preserving all original verification/history/native/CAS gates.
Protocol14/204 and Shared5/47 passed; Release solution build had0 warnings/errors.
Graph09 retains the MAU2 shipping FAIL. APK29's retained retest passed network
verification/prekey publication, then failed ContactPublication after65.2s:
closed server evidence identifies route issuer `Admission/busy` ->backend503
->relay504. Registry `20be804` reuses the existing single private issuer waiter
for route issuance within its unchanged30s budget; focused43 passed, native0,
original red1FAIL retained. Registry family now runs the qualified `20be804`
image; supported smoke03 exited0. Up02's outer mount comparison failed and
its before snapshot was not retained: do not count it as preservation proof.
Read-only audit04 confirms9 services /29 existing-volume bindings /25 scoped
binds, all volumes older than the update. APK29 Verify01 -> independent Inspect02
now completed `verified-publication/Verified`, with recovery retained. The
attempt recorded99.5s /887 unprotect calls /51.0s protection, within the original
budget; it is not sustained readiness or business delivery acceptance.
The later background refresh still timed out at120.0s with1161 unprotect calls
/73.3s protection, then another attempt rejected the existing replica-prekey
current-device-authority guard (`VerifyComplete` IL806). Exact packaged code
locates that compound guard, not its failed subcondition. Android Add01 only
loaded the retained intent choice; explicit Retry02 did not Store. A separate
owned contact scroll confirms the verified-network prerequisite refusal. Keep
the original intent and diagnose sustained refresh cost plus retained prekey
currentness; no reset, remint, backdating or longer timeout is authorized.
APK30 now isolates the physical refusal as `PreKeyInventoryExpiry` after51.4s:
the staged inventory fails authenticated upper-time coverage, not device binding.
The original exception stage/rejection and all predicates remain unchanged.
Protocol focused9 and MAUI focused108 passed; its build had0 warnings/errors,
retained install/recovery/package audits passed. The account service and SQL
store implement only initial staging; normal replenishment/service succession
is missing, not an account-corruption or network workaround task. Complete it
inside S05 under the existing CONTACT-RESOLVER owner before further contact/text.
The sixteen-slot local reopen candidate reduces actual encrypted fixture reads
8 ->4 with original decoders and independent retirement checks; focused39,
affected82 and contact47 passed, no failures/skips/native errors. Full source and
matching physical performance qualification remain open. Windows UI access was
revalidated in this turn: build17 is running with the retained profile, so its
earlier tool-budget refusal is no longer a current blocker.
The DR-0129 contact-object/service boundary now has a signed native owner and
independent target5 issuer regression:final12 passed, no failures/skips/native
error, including actual expired-service succession and publication request
expiry capped by the signed object;
Protocol9 and MAUI108 focused cases passed, Protocol solution build has0
warnings/errors. Exact scopes and original red evidence are in the
[Shared checkpoint](../deep-client-shared/docs/testing/s05-prekey-service-succession-2026-10-16.md).
This does not implement multi-generation inventory custody or recover the
installed account yet. Complete that lifecycle before another device contact
attempt; no reset or old signed interval extension. Protocol canonical full11
completed2361PASS/1FAIL/7 declared skips,2369 exact mappings and1620 unchanged
inputs: only the existing MAU2 package witness fails. Build/preflight and
qualification exited0; native test1, FullAccepted=false. Successful full/package
qualification remains open. Acceptance is still0/4;

[DR-0130](survival-program/decisions/DR-0130-owned-prekey-inventory-custody.md)
now freezes the local successor-custody allocation without changing PKV2 schema4.
Its private storage component passed63 affected regressions and9 final focused
cases (native0, no failures/skips), including actual encrypted reopen, native
authoring, concurrent CAS, lost response and missing/cyclic/changed custody.
The [Shared mapping](../deep-client-shared/docs/architecture/owned-prekey-inventory-custody.md)
now records actual SQL-key/lease integration, signed lineage, per-publication
pair custody, the one global receiver ledger, secret-destruction recovery and
compaction readback. Owner regression06 passed89, compaction07 passed27,
epoch09 passed6 and final runtime regression10 passed97, all native0 with no
failures/skips. The epoch test includes real
pending old Hello after same-service epoch succession, out-of-order LR counters
and cross-key counter-reuse rejection. Replicas are signed in-process fixtures,
not physical/deployed transport acceptance. Final11 rebuild/two exact storage
rows passed with0 compiler warnings/errors after correcting a test-style warning;
runtime source is unchanged from regression10.
[DR-0131](survival-program/decisions/DR-0131-owned-prekey-maintenance-author.md)
now freezes owned XPS restoration, one canonical service-transition verifier
and one maintenance/publication command without legacy aliases. Its source
candidate connects ordinary authoring under the actual lease, exact pending
retry and changed-contact adoption only after the new prekey pair. Initial
source02 passed10/failed2 (new fixture exception-type expectations, not accepted
qualification); source03 stopped at a test-file namespace compile error.
Source06 passed26/failed1; its remaining fixture incorrectly coupled reachability
and threshold lifetime. Matching the actual Registry issuer's existing lease
bound corrected it. Renewal08 then passed9 (native0, no failures/skips/compiler
warnings/errors), including forced changed-service contact publication after
encrypted reopen, pair-before-adoption, locator/Retrieve preservation, exact
retry and the existing recovery cases. MAUI Clean07 passed230 unfiltered cases,
native0, no failures/skips.
Protocol10 passed35 targeted cases/native0 with0 compiler warnings/errors.
Windows QA CompileOnly11 passed native0 with0 compiler warnings/errors; it
did not publish, install or launch. The remaining DevOps/Registry consumers
now use DR-0131's command/explicit fixture phases without retired API aliases;
Registry consumer14 passed3 real-PQ/PostgreSQL cases, DevOps contracts passed26.
Matching dev image15 and retained Up16 exited0. All29 volume bindings are
identical; all25 binds uniquely match their prior source/destination/mode after
accounting only for Windows/Docker Desktop source-path representation. Raw bind
hash comparison failed and is retained separately, not relabelled PASS.
Supported smoke17 exited0: current Registry proof and all3 verified ONION nodes,
recovery37s. This is readiness, not sustained/business/device acceptance.
Windows18 then opened the retained profile without reset. Its prekey dispatch
returned OutcomeUnknown; one relay recorded504, without proven inner cause.
APK31 passed build/signature verification but is not installed. Full/source/
package and physical qualification remain open. Preserve
all old claimed/Initial custody. Multiple completed inventory-service generations
while contact promotion was unavailable, and recovery of expired unresolved
publication, still need lifecycle closure: do not skip the contact's immediate
signed predecessor, infer noncommit, drop pending custody or reset an account.
Canonical full/package qualification and
retained-account device recovery remain open. This does not yet recover either
installed account; physical acceptance remains0/4 and S05 is not accepted.

[DR-0132](survival-program/decisions/DR-0132-replica-prekey-service-transition.md)
closes the independently reproduced replica false-fork at service+1/epoch1,
using existing exact historical support and current device authority, without
wire/native format changes. Node focused90 and Protocol focused36 passed/native0,
no failures/skips/compiler warnings/errors; original red and fixture failures
remain in [the checkpoint](../xnode/docs/testing/s05-service-rollover-2026-10-16.md).
This candidate has been activated only in the local dev contour, not production,
and is not accepted full/package/device evidence. One existing fork marker was
observed read-only locally; none on the other two nodes. Do not infer its cause
or replace an account to claim recovery. Mr. X explicitly authorized a local-dev
reset if the other contour's snapshot cannot be reused. The network and both
genesis anchors differ, so `deep-dev` cannot supply `deep-dev-current` custody.
Operator `reset-09` recoverably quarantined the one affected service directory
(4 files, intact marker); keys, accounts, other service and staging state were
not reset. This is not retained-native-custody recovery acceptance. Image08 and
supported Up10 exited0; all9 services run matched images and all29 volume/25
bind identities are retained. Smoke11 exited0: current Registry proof,3 verified
ONION nodes, recovery60s; no business/device delivery claim. Android31
install preflight passed without installation. A physical Escape stopped
Windows automation before profile launch; device acceptance remains0/4.

Android31 has since been installed by supported update without account reset;
recovery and protected-package audits are retained. Two complete attempts spent
120094/120070ms and913/931 unprotect calls before cancellation during prekey
publication's local account reads. This is not the former inventory-expiry
refusal or evidence of noncommit. The seventeen-slot local registration group
now reuses exact decoded retirement owners under the actual account lease,
without cached authority, new formats or relaxed native-floor/history checks.
Focused78/0/0/native0 passed; encrypted reopen measures4 ->2 unprotect calls.
APK32 retained the account but still cancelled at120071ms/897 unprotect calls/
69613ms protection; the read-group change alone does not close this blocker.
DR-0131's next call-local fragment context removes repeated full acquisition,
retaining before-dispatch/after-response proof, protected-floor and time checks,
without holding an account lease across the network. Focused11 passed/native0;
all frames were sealed for both selected exits, not sent or committed. Matching
Android retest and full qualification remain open; see
[local read groups](../deep-client-shared/docs/architecture/owned-authored-counter-custody.md#actual-atomic-local-read-groups)
and [device checkpoint](../deep-client-maui/docs/DID2-HTTPS-DEVICE-2026-09-28.md#local-replica-rollover-retest).

Matching APK33 passed build/signature verification and retained-account update.
Prekey publication completed before contact publication (65884ms); later
commands reauthenticated its durable pair in21205/24306ms with0 protection
writes. Full verification/contact publication still fails (120s cancellation
or typed ingress dependency refusal), so acceptance remains0/4. The next
candidate folds dependencies into the existing public owned-contact workflow,
using one fresh context with every owner-phase check, and fixes typed transient
dependency scheduling. No clock predicate, signed lifetime or original changed;
source and new-device checks are still required for this candidate.
The source slice passed Shared workflow18, MAUI focused79 and unfiltered Smoke
project119, all0fail/0skip/native0/no compiler diagnostics. The original MAUI
focused05 source-location assertion FAIL is retained; its replacement follows
the same full pinned verification into the owner, not a waived check. Canonical
full/package and new-workflow physical acceptance remain open. No public API,
native format, authority lifetime, original intent or replay floor changed.

Matching APK34 retained update now completed the whole owned workflow twice:
65238/62920ms,491 unprotects each,0 protected writes. Independent Inspect54
observed Verified; manual Verify55 -> Inspect56 observed
`verified-publication / Verified`. This is actual local-dev retained-account
publication readiness, not sustained/cold-restart or business acceptance (0/4).
Contacts57 has an empty editor/disabled Add; no replacement intent or Store.
Matching Windows19 built/published with0 warnings/errors but has not launched;
Windows UI remains stopped after physical Escape, pending fresh human permission.
See the exact APK/hash/phase matrix in the
[device checkpoint](../deep-client-maui/docs/DID2-HTTPS-DEVICE-2026-09-28.md#local-replica-rollover-retest).

Android34 also reopens the retained account after Restart59 and reaches Verified
in66931ms (Inspect63); later background cycles complete64838/59496ms. One actual
incoming refresh65 instead fails retained Retrieve-grant issuer/network/time
verification (Inspect66), with no successful empty page or delivery. Diagnose the
exact predicate before another business retry; original grant/intent custody
remains. A closed reason-only diagnostic candidate passed Protocol89/MAUI160,
native0/no failures/skips; APK34 does not contain it. Shared preflight05 before
these diagnostic Protocol changes passed build0/6 fixtures/terminal0, not full.
Matching APK35 retained update now proves `MailboxGrantExpiry` at that exact
issuer guard (incoming Refresh75/Inspect76), while publication remains Verified.
Keep currentness rejection and all pending originals. Next locate the owned
caller state before choosing new-read renewal versus active-read recovery;
neither old grant acceptance nor account reset is a fix. The QA-only distinct-
owner frame selection passed161 focused cases under the unchanged4-frame bound.
APK36's distinct-owner trace and matching build-output Shared PDB locate that
expiry at `RetrieveOwnMailboxAsync` lines57–59: restoration of an active cycle's
original grant, not new-read acquisition. Independent Inspect85 verifies the
retained account's publication readiness; Refresh87/Inspect88 still fails.
The precise active subphase1–6 is not observed. Next close expired-active
Retrieve/ACK recovery under the existing transition owner, retaining exact old
requests/grants/counters/pages; do not route it through the new-work selector,
accept expired authority, erase the cycle or reset the account. Any required
allocation must be frozen before code. Incomplete Settings80 and overlapping
Scroll83/84 are retained separately and are not acceptance evidence.

no exact binding, protected state or deadline was weakened. Windows16's second empty sync was slow but completed
by06:00Z; exact latency/cause was not measured. This is not delivery acceptance.
Новые source changes проходят отдельную квалификацию; старые APK не являются
доказательством новых inputs. Это не Releases/main или release acceptance.
Shared `acc65f1` carries the independently verified contact pair through one
owned command, including explicit borrowed read/claim custody; current protected
floor, time, endpoint and final native checks remain. Focused8 and the existing
eight affected regressions passed on that production source; MAUI Clean193 /
Smoke119 passed. The first new test run retained one wrong-exception assertion
FAIL, corrected without relaxing production verification. Final full remains.

**Earlier runtime failure evidence:** supported local Verify subsequently failed;
Registry readiness oscillates and all three node mailbox hosts report
`unavailable` while ONION/contact terminals are ready. Closed Registry logs show
authenticated-time acquisition denials. Earlier `interval-conflict` and
`floor-rollback` observations remain historical evidence; `a936bd8` reported
`scope-or-quorum`. The latest Registry separates policy/age/quorum labels;
after the latest restart it reports `observation-quorum` and `source-interval`.
Before helper update06 Registry returned503 and ONION also became unavailable.
Floor metadata changes
alone are not stable readiness evidence; no time-policy/floor reset is a remedy.
Publisher renewal still succeeds, so offline-policy expiry is not established.
Windows15 reached Verified after explicit registration check, then Rejected;
Android22 had no Store/contact delivery. Recover current time/host readiness
before another business retry; do not reset accounts/floors or extend windows.
Earlier local diagnostic Node `0240120` was active on all three nodes; its closed
recovery reasons include `observation-missing` and `revocation-context`.
Supported Build/Up preserved all29 volume and25
bind mount identities using saved canonical before/after snapshots. This new
upgrade check does not replace the older FAIL. Node focused27/3/0/native1 and
the subsequent interrupted run remain unaccepted; a separate hash-bound binary
diagnostic also failed the original10s Store deadline after peer response capture.
Fix/qualify source performance and current-authority recovery, not larger windows.
Post-Up diagnostics also show `check-deadline` and `revocation-context`; no floor
reset is authorized by these labels. The existing configured-Program fixture
reproduced readiness failure without external NTS, then the focused timing run
reached Store504 at15.6s. Its inclusive observations place repeated source/floor
file work ahead of network/host crypto reconstruction; exact counts and failed
receipts belong to [Node operations](../xnode/docs/operator.md). Optimize that
measured read path with the existing actual-floor/source/release fences intact,
then rerun the bounded business slice. NTS alone is not the established cause.
Current source candidates: Node `0240120` bounds actual file acquisition before
allocation, batches independent public reads and closes duplicated Windows token
handles without caching security decisions. Focused85 passed, including configured
three-hop Store/Retrieve/ACK/cold exact retry, but unchanged-binary repeat failed
three of four business cases at the original deadlines; performance is not
qualified. Registry `a936bd8` fixes a separately reproduced queued-observation
comparison at different monotonic instants. It projects both intervals to the
same actual sample and subtracts queue delay from remaining freshness; no signed
window or durable lower floor is weakened. Original-code red1 is retained;
focused37 passed, including true rollback/expiry rejection. Supported local
Build/Up completed, but Verify still exited1; source/full and stable runtime
acceptance remain open. Read-only public-file diagnostics measured30 reads across
the Windows bind mount at4002ms versus537ms for a container-local control file;
this is not an isolated .NET/business timing or proof of the sole cause. A fresh
pinned observer process obtained two authenticated observations both in Docker
and on Windows; that connectivity probe is not current authority or sustained
process recovery. See the exact source receipts in
[Registry operations](../deep-registry-api/docs/DID2_DIRECTORY_CANDIDATE.md) and
Node operations above. Do not infer that this resolves every readiness denial.
Registry `9136453` separates mailbox-only monotonic sampling
from full trusted-time acquisition, keeping actual current-source/floor, signer,
journal and release checks. Matching focused provider44 passed. Broader
unactivated clock candidate06 remains51PASS/5FAIL; source05 lacked PostgreSQL
and failed14 prerequisites. Runtime and stable physical recovery are not yet
qualified; no other issuer clock, signed window or storage generation changed.
Its component build/Up preserved the retained mounts; one Registry readiness
request returned200 in2965ms, but supported Verify still exited1 on the nodes.
Registry `2859756` further isolates the single signed-control reader from
readiness, retaining actual journal transactions and all source checks. A real
concurrent-health regression reproduced503 before the fix; focused provider44
then passed (`control-readiness-09`). The new image is active, but Up04 failed
during retained observer admission with InvalidDataException while NTS was
unavailable. Do not relabel that activation or the earlier failures as PASS.
Later Up05 with tested NTS helper `2e96265` succeeded with exact29/25 mount
identity preservation and retained observer admission. Smoke05 still exited1;
mailbox is unavailable and ONION oscillates. Windows registration and Android
Verify28/Inspect88 both now report AccountProof/AdmissionAuthorityUnavailable,
with the same accounts/recovery retained. A bounded two-CPU Registry diagnostic
did not restore authority; the same container's original one-CPU quota was restored.
Helper closed source-failure diagnostics passed8 Go tests. Component build06 /
supported Up06 completed with exact29/25 retained mount preservation and tested
helper hash equality. Smoke06 still exited1; the post-Up snapshot has ONION/
contact ready but all three mailbox hosts unavailable. Initial helper logs have
no closed failure category, not proof of sustained acquisition. Node recovery
still reports revocation-context/observation-missing/check-deadline; isolate that
path rather than treating NTS timeout as the sole cause. Later active helper
logs reproduced four query-timeout failures; renewal also lost current time.
The separate24-request
connectivity diagnostic saw five query timeouts and recovery, but failed its own
Docker shutdown budget (Terminal=false/native-1); it is not accepted evidence.
Contract rerun exited0, production readiness exited1. Recover this prerequisite
before another business retry; no physical acceptance or production update.
Node source candidate `71bcae3` fixes a reproduced MGR refresh early exit:
Deposit reaching its64-step cap no longer suppresses Retrieve's bounded batch
when the original30-second flight still has time. Incomplete catch-up still
cannot enter ordinary host admission; actual source/native checks remain.
Red13 failed both generation assertions; matching focused15 passed42/0/0/native0.
Component build07 completed without compiler warnings/errors. The first Up07
used the old image due a build/Compose tag mismatch; smoke07 exited1 and is not
new-source evidence. After retagging the identical image, Up08 verified exact
build image IDs on all three nodes and29/25 retained mounts. Smoke08 still
exited1: mailbox recovery remains unavailable. Supported signed-control capture
then fetched both roles in5.8s; public codec/host-clock diagnostics do not prove
protected currentness or native progress. Inspect the actual worker phase/floors;
no full, stable recovery or physical acceptance is claimed by this source fix.
Node `7520654` records the actual failed refresh phase,
closed reason and already-read native generations, without additional I/O or
authority effects. Matching focused17 passed46/0/0/native0; runtime evidence is
obtained: Up09 verified the exact image on all three nodes and29/25 retained
mounts; native reads show468/455 and later Retrieve456, with occasional target-
read I/O/retry failures rather than absent enrollment. At03:00Z all three nodes
reported ready/recovered, and supported smoke09 exited0. This does not prove
sustained stability or any device delivery. Android Verify29 then reached a
different failure: ProtectedState in local contact-object authoring, exact guard
not yet identified. Windows input is stopped after two geometry failures pending
operator window restoration. Preserve both profiles and diagnose that authoring
guard using QA-only closed labels; no contact/message effect is accepted yet.
APK23's installed closed authoring labels were independently confirmed in the
exact APK assembly store. Retained Verify02 still reports ProtectedState /
Unclassified in authoring, with no Store or delivery accepted. The next bounded
diagnostic covers signing, retained issuance/successor and route-time checks;
it does not weaken those checks, change crypto or reset retained custody.
APK24 then identifies `ContactSuccessorAdvance`; a signed default day-service
regression reproduces the expiry-cap conflict. [DR-0127](survival-program/decisions/DR-0127-capped-contact-object-successor-validity.md)
corrects only DCB's strict expiry increase to nondecreasing expiry, retaining
strict generation/hash lineage, complete current interval coverage and all
unchanged inner expiries. Red02/03 reproduced that guard; green04 and expanded
Shared05 passed1/6 cases respectively, native0. Matched Protocol/issuer/client
builds and retained-device retest remain required. Windows screenshot-backed
input recovery succeeded; its Verify ended ContactPublication /
OnionCompletionUnknown at ingress HTTP error handling, not publication success.
Protocol focused06 passed24/0/0/native0 and production solution build07 passed
with0 warnings/errors. Graph08 still exits1 on retired MAU2; that separate
shipping blocker remains open and is not waived by the contact fix.
Source/runtime evidence:
[contact transport](../deep-devops/docs/S05-CONTACT-TRANSPORT-2026-10-15.md),
[grant custody](../deep-client-shared/docs/architecture/owned-mailbox-grant-custody.md),
[физический checkpoint](../deep-client-maui/docs/DID2-HTTPS-DEVICE-2026-09-28.md).

Текущие испытания — только retained локальный current-dev, девять сервисов /
три ноды. Production этим срезом не изменён. Аккаунты, recovery, originals,
permanent fences, native replay floors, registered node keys и volumes сохранены.

### Оставшаяся работа S05 — по порядку

Непосредственный prerequisite к пунктам ниже — подтверждённый на APK30
prekey expiry: закончить штатное пополнение/преемственность инвентаря и contact
publication, сохранив старые claims/Initial и originals. Точный выход/gate
в [S05](architecture/IMPLEMENTATION-PLAN-V1.md#s05--current-issuer-и-автоматический-lifecycle-управляющего-контура).
Новый тестовый аккаунт не закрывает восстановление существующего.

1. **Logical assignment / current carriage — окончательная квалификация.**
   [DR-0122](survival-program/decisions/DR-0122-logical-mailbox-assignment-carriage.md)
   реализован согласованным current-only Protocol → owned client → issuer →
   node/peer candidate. Не менять ranking и не перепубликовывать контакт на каждый
   view, не удалять pinned archived paths или повышать bounds. Завершить current
   source qualification и same-owner device/recovery для новых inputs. Resource
   expiry и epoch/cohort/device/delegation handover проверяются независимо;
   historical focused/build receipts не являются S05/release acceptance.
2. **Retained original intents и первый physical contact/text.**
   [DR-0125](survival-program/decisions/DR-0125-current-publication-submission.md)
   активирован в current-dev: actual current submission над immutable original,
   permanent winner journal, без backdating/reset/legacy targets3/4. Registry
   bounded admission сохранён в исходном30s budget. Android и Windows прошли
   verified-publication на retained profiles. Совпадающие source и runtime refs
   и исходные FAIL находятся в linked checkpoints; generic aggregate counters
   не доказывают noncommit конкретного client intent.

   [DR-0126](survival-program/decisions/DR-0126-independent-grant-after-unresolved-acquisition.md)
   исправляет новый доступ после authenticated closure unknown grant:
   независимый owned holder/request, exact pending replay, сохранённые originals
   и active Store/Retrieve/ACK. Layout/wire/generations/lifetimes/128-entry bound
   не менялись. Focused16 и affected regression58 прошли без FAIL/skip/native
   errors; MAUI Smoke119 также прошёл. Exact3 source-case replacements объявлены
   в decision, исходные TRX не изменены. Strict registry PASS44/247/10/5/4/11,
   security12/0 findings, strict UTF-8/local links5/75.

   Windows build06 (`845a666`) завершил actual empty mailbox synchronization на
   retained аккаунте; это read observation, не delivery/noncommit. Android
   build10/install10 (`31fe23b`) сохранил account/recovery и protected packages,
   background Verified. AddContact05 того же intent завершён точным
   `RequireCurrentIssuer / XurWindow` (IL104), без contactRequestStored. Это
   доказанный отказ полного authenticated time window XUR, не доказательство
   конкретной стороны interval и не повод ослаблять guard. Шестого send нет.
   **Текущий следующий шаг:** на сохранённом intent устранить доказанный отказ
   current ContactResolve placement и дойти до первого Store/приём/A↔B text без reset.
   Stop не доказывает non-delivery/recall и не remint старого intent.
   Foreground network work и background verify используют одну существующую
   process queue; local history остаётся вне неё. QA-only diagnostics ограничены
   closed category/check/static method/IL, без произвольного exception text/IDs/
   paths. Source tests и Windows trace не заменяют actual Android observation.
   Explicit stop UI подключается к существующему `CancelOwnInitialContactAsync`;
   readonly `IsStopped` берётся из protected draft. Cold Add сначала предлагает
   retry/stop без dispatch; unknown stop сохраняет original, confirmed stop
   позволяет только последующее explicit Add. Никаких новых journals/wire/reset.
   Shared native/SQLCipher cold-reopen projection3, MAUI Clean175 и Smoke119
   прошли0fail/0skip/native0 (`contact-stop-projection-01`, `contact-stop-clean-01`,
   `contact-stop-maui-smoke-01`); это
   source evidence, не installed stop или contact delivery. Final full остаются.

   Первый intent остановлен через actual Stop01/Inspect52. Следующий original
   сохранён: exact retry13 завершён `XurWindow / RequireCurrentIssuer / IL87`,
   без Store. Cold Add14/Contacts20 восстановил его retry choice без dispatch.
   Stop03 на APK18 доказал отдельный `ArithmeticOverflow /
   StopInitialContactIntentAsync / IL4274`. Shared `cb7893c` проецирует checked elapsed, затем checked Unix
   result, вместо сложения абсолютного monotonic counter. Focused13 прошёл:
   десять pure boundary cases и три actual native/SQLCipher cold-reopen cases
   (`pre-session-stop-time-01`). Matching APK19/install19 сохранил account и
   original; Stop04 -> independent Inspect75 подтвердил stopped retries без
   ошибки и без StopRetry control. Только последующий отдельный Add16 создал
   новый intent: он завершён network-closure read `Io / FetchCurrentAsync / IL453`
   на exhausted eight429 attempts, не Store. Original не заменяется на retry.
   Registry candidate даёт один bounded public waiter рядом с прежним issuer
   waiter, при одном active frame/operation и том же30s whole-operation budget.
   Focused15 прошёл0fail/skip/native0 (`public-read-admission-focused-01`);
   matching current-dev Build/Up выполнен, Registry/три ONION verified за14s.
   Raw mount-hash guard после Up завершился FAIL; исходная before/after equality
   не доказана. Independent readonly audit подтвердил29 declared pre-existing
   named volumes и25 scoped binds без reset. Нужен повтор retained-upgrade gate
   с сохранёнными canonical inputs; первый FAIL не переклассифицировать в PASS.
   Exact Android Add17 на том же intent завершился без Store: Inspect80 видит
   error, новый closed timestamp указывает `RequireClaimContactTimeAsync / IL509`.
   Это combined clock/boot/request-window guard; отдельный expiry predicate ещё
   не доказан. Новый source candidate убирает повторную подготовку draft внутри
   одной команды, сохраняя protected/current claim checks, и разделяет только
   diagnostic reasons четырёх predicates. Shared `09f5c1d`: focused10 и actual
   owned application2 прошли0fail/skip/native0. MAUI `a2bc906`: Clean190 и Smoke119
   прошли; matching APK20 установлен с retained account/protected packages.
   Cold Add18 восстановил retry choice без dispatch. Exact Add19 на том же intent
   завершён error/no Store (Inspect84): новый trace указывает PermanentContactResolveVerifier
   VerifyAsync/IL1039 — combined current view/placement hash/request lifetime guard,
   не доказательство одной конкретной стороны. Дубль draft preparation уже убран,
   но этот отказ предшествует ему; ускорение не подтверждено. Original сохранён,
   нового intent нет. Final Registry full и physical contact/text остаются.

   QA-only optimized JIT сохраняет Debug/isolation/trust/Release guards и
   исходные временные окна. Source `f6e57b7`: Clean186/0/0 и Smoke119/0/0/native0
   (`android-qa-isolation-clean-01`, `android-qa-isolation-smoke-02`). Первый
   smoke01 прерван с FAIL после смены HEAD во время strict harness; на неподвижном
   source matching focused1 и smoke02 прошли, старый запуск не квалифицирован.
   Actual resource evaluation: QA0/defaultDebug1 Google Services items; Release
   без external config отвергнут прежним guard, не suppressed warning.
   Supported nonincremental APK18 собран0warnings/errors и запущен на сохранённом
   профиле (Install18/Inspect69), без ручного cache reset. APK15 JNI startup FAIL
   и recoverable generated-only cache сохранены. Не ослаблять sandbox/run-as.
   Новые события — только bounded exact-process/tag code metadata. Protocol
   permanent guard/public-surface focused15 прошёл с прежними predicates/windows.

   Windows UI возобновлён явно владельцем; build11 сохранил account/recovery и
   background Verified. Один mailbox refresh завершён `OutcomeUnknown /
   PrivacyManagedIngressHttpTransport.ForwardAsync / line304 IL1509`; это не
   noncommit или contact delivery. Current-dev Verify восстановил Registry и
   три ONION capabilities за43s без reset, но не доказывает device delivery.
   После нового явного resume один Chats refresh на том же build11/account
   завершил синхронизацию без visible error, список пуст. Это не contact delivery
   и не отмена предыдущего unknown outcome. Аккаунт не сбрасывался.
   Windows build13 сохранил profile/recovery; первый refresh завершён
   OutcomeUnknown/ForwardAsync/IL1509. Background ReadBootstrap выявил отдельный
   баг wrapper: BootstrapAuthority отсутствовал в closed stage list, из-за чего
   I/O failure заменялся ArgumentException, терял typed cause и мог останавливать
   reconnect как Rejected. Source `229c3da` добавляет только уже используемый этап.
   Regression red2/native1 сохранён; после fix Clean193 и Smoke119 прошли0fail/
   skip/native0. Реальная scheduling regression сохраняет429/503 cause и RetryAfter;
   generic I/O/crypto/floor rejection не получают retry authority. Windows14
   запущен без reset: background Verified, затем один Chats sync без visible error.
   Это не fault-injected429/503 recovery или contact delivery. Settings sentence
   «ещё не проверена» пока не синхронизируется с background Verified — UI issue.
   APK21 установлен/запущен с retained workspace/protected packages (Inspect85),
   нового contact retry ещё нет. Security50/0findings, strict UTF-8/local links остаются
   отдельными checks, а не release acceptance.
   Более ранние source/device FAIL остаются в linked checkpoint и receipts;
   ни один старый PASS не квалифицирует изменившиеся Shared inputs.

   **Открытые source/lifecycle границы:** dependency-closed retirement смешанной
   closed/adopted predecessor history (сейчас такие ancestors остаются pinned);
   actual Registry regression для гипотезы cross-view immutable ScopeHash conflict
   на exact XMG retry. Не удалять reservations, не ослаблять scope guard и не
   использовать expiry как non-issuance. Canonical full и installed cross-device
   acceptance остаются обязательными. Текст, файлы и группы ещё не переданы.
   Receipts: Shared `artifacts/s05-current-publication-20261015/`
   `independent-grant-focused-03`, `independent-grant-regression-01`;
   MAUI тот же prefix: `independent-grant-maui-smoke-01`, `windows-build-05`,
   `windows-observation-02.json` (manual, не release receipt), `android-build-07`,
   `android-install-07`, `android-verify-08`, `android-inspect-26`,
   `android-refresh-02`, `android-inspect-28`. Compiler/preflight FAIL02/05 и
   прочие исходные неуспешные попытки сохранены; они не превращены в PASS.
3. **Operational ceremony после активации roles.** Root/witness/role/traffic/TLS
   rotation, автоматический head/view/key lifecycle и предупреждение offline-policy
   expiry. Pre-mailbox Prepare/Apply отказывают на enabled contour: нужен supported
   coordinated role-volume/journal update, не обход fence или ручная правка.
4. **Оставшаяся runtime matrix.** Restart каждого автора/ноды с retained volumes,
   interruption/rollback, signer/time outage, expired observation/head, clock
   rollback, конкурирующие поколения и несколько ротаций; тот же client после
   renewal и bounded verified catch-up. Уже пройденные 129-head catch-up и
   retained restart scopes не заменяют всю эту матрицу.
5. **Final source qualification/review/commit/push coherent slice.** Не запускать
   full после каждой строки. DR-0125 Node full принят1519/0/0 на своих inputs;
   Protocol full2331/1/7 квалифицирован по matrix, но не принят из-за реального
   S08 package FAIL, семь explicit skips не сняты. Exact receipts:
   Node `artifacts/s05-current-publication-20261015/full-01`, Protocol тот же
   prefix `full-02`; новые DR-0126 metadata hashes не переиспользуют старый
   unchanged-input PASS. Прошлые FAIL и исправления сохраняются в Git/артефактах,
   не заменяют текущую приёмку. Shared/Registry final full на текущих входах
   ещё требуются; focused51 и device diagnostics не заменяют их. После закрытия
   текущего business slice выполнить требуемую квалификацию и зафиксировать
   coherent refs, без публикации Releases/main. Общего source/release PASS нет.

### Подтверждённая база S05 и ссылки

- [Registry source/runtime](../deep-registry-api/docs/testing/s05-protected-role-signer-2026-10-14.md):
  current issuer/readiness, separate protected role signers и permanent journals.
  Последний квалифицированный Registry full409/0/10 относится к своим inputs;
  Unix-socket skips требуют Linux lane. Первый Store14930ms/deadline15s остаётся
  performance risk, не S09 PASS.
- [Authority history и custody](../deep-devops/docs/S05-AUTHORITY-HISTORY-2026-10-14.md):
  same-day authority recovery, 129-head catch-up и retained restarts; original
  identities/keys/genesis/floors сохранены. Старый pre-cutover deep-dev не заменён
  current-only reader и не сброшен.
- [Signed reachable ingress](../deep-devops/docs/S05-PHYSICAL-INGRESS-2026-10-15.md):
  LAN origins, строгие TLS/H2, same-key PKI/CRL и retained publisher CAS.
  Это infrastructure evidence, не physical device delivery.
- [Prekey lifecycle](../deep-devops/docs/S05-PREKEY-LIFECYCLE-2026-10-15.md):
  DR-0121 stable publication assignment и exact cold-reopened XIC1 pair.
- [Текущий contact slice](../deep-devops/docs/S05-CONTACT-TRANSPORT-2026-10-15.md):
  исправлены duplicate peer endpoint, bounded public-read contention и repeated-Up
  ingress preflight. Все исходные неуспешные попытки сохранены.
- [Node prior full/smoke](../xnode/docs/testing/s05-control-read-backoff-2026-10-15.md):
  prior1508/0/0 и no-mock smoke/rehearsal, не квалификация новых inputs.
- Current-source no-mock smoke и three-node infrastructure rehearsal прошли
  native0; scoped cleanup завершён. Это не DID2 device delivery; точные receipts
  в текущем contact checkpoint, не замена final source qualification.

## Принятая база и следующие этапы

| Этап | Статус и оставшаяся приёмка |
| --- | --- |
| S00 | Source baseline принят, не shipping. [Node](../xnode/docs/testing/s00-node-baseline-2026-10-03.md), [Registry](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md). |
| S01 | Contract/API принят, не runtime/release. [Review](S01-CONTRACT-REVIEW-2026-10-10.md); original package FAIL остаётся S08 по DR-0095. |
| S02 | Current-only node source/composition принят, не deployed/physical. [Review](S02-CURRENT-NODE-REVIEW-2026-10-10.md). |
| S03 | Grant-bound peer source/composition принят. [Review](S03-CURRENT-PEER-REVIEW-2026-10-11.md); intermittent native MoveFileEx denial не объявлен исправленным. |
| S04 | Source lifecycle принят, committed/pushed: Shared full-05:1424/0/0, exact matrix и1984 unchanged inputs; matching201, MAUI95/smoke119, Windows/Android compiler checks. [Review](S04-CLIENT-LIFECYCLE-REVIEW-2026-10-13.md), [terminal audit](../deep-client-shared/docs/testing/s04-successful-audit-2026-10-12.md). Не installed/release acceptance. |
| S05 | Единственный активный: незавершённые критерии выше. |
| S06 | Не пройден: два owned clients, publication/resolve/claim/explicit consent/text через selected-entry и separate stores; offline/duplicate/lost-response/restart. |
| S07 | [Local history](../deep-client-shared/docs/testing/s07-local-history-2026-10-04.md) реализована; autonomous scheduler/drain, offline logical queue, AppAck/read и полный1:1 event/UI scope не закрыты. |
| S08 | Supported shipping composition без diagnostic flag, actual package/API/resource graph и installed Android/Windows text/receipt. MAU2 package FAIL открыт. |
| S09 | Sustained connected delivery, retained identities/floors, rotation/offline/restart/recovery и полный catalog не квалифицированы. |
| S10 | Local attachment custody есть; encrypted remote files/images/video/voice/avatar, integrity/resume/expiry/cache/UI не закрыты. |
| S11 | Current DID2 governed groups, multi-device/history transfer не замкнуты; retired GroupV1 harness не evidence. |
| S12 | Отдельные компоненты; carriers/bootstrap/push и relay-only calls не квалифицированы полностью. |
| S13 | Одна signed/installed artifact matrix, полный evidence catalog и reviews после предыдущих этапов. GitHub Releases/main — только по отдельной команде. |

## Релизные блокеры, которые нельзя потерять

- **B1/S02–S06:** health200/local Kestrel/fixture clocks не доказывают deployed
  authorities, owned client join или selected-entry/ONION delivery. PMA1 adapters
  не возвращать.
- **B2/S03–S09:** distinct identities, sole signed Store writer/prefix, independent
  peer facts и either-replica ACK приняты на source уровне; connected/physical
  retained-route/horizon/retirement/recovery всё ещё обязательны.
- **B3/S04:** source sustained512/128 и exhausted-PQ recovery приняты, installed
  acceptance отсутствует. Original pending/unknown requests, ciphertexts и floors
  сохранять; bounds не повышать, custody не evict/remint, fake freshness запрещена.
- **B4/S07:** reconnect не доказывает autonomous draining/AppAck/read. UI Delivered
  нельзя выводить из Store receipt или transport tombstone.
- **B5/S08:** conversation DI diagnostic-only и запрещена в Release. Нужен supported
  shipping owner/artifact, не снятие запрета.
- **B6/S04/S05/S08:** independent DCA/XUR/PMT/issuer/root rollover, verified catch-up,
  signed readiness и retained volumes остаются обязательными. MAU2/MCG2 нельзя
  спрятать переименованием; mapping/grammar меняются только по frozen authorization.
  Root/custody/account/device guards не исключаются.
- **B7/S10–S13:** весь [V1 release scope](architecture/V1-RELEASE-SCOPE.md), включая
  files/groups/calls/multi-device/carriers, остаётся обязательным. Outbox cleanup
  не доказывает independent DAM1/history/object-key retirement; live upload/download/
  resume obligations нельзя удалять ради capacity.
- **B8/S06/S08:** one-time source publication/descriptor/owned custody проверены
  локально; account-owned operation/QR export, request-expiry reconciliation и
  installed evidence открыты. Permanent-contact milestone не отменяет one-time UX.

Физические contacts/messages/files/groups: **0/4 подтверждены**. Релиз не готов.
Клиенты этого спринта — Windows и Android; macOS не собирать до явной команды.
OfficialXPoint3: **три production nodes**; обязательный hop outage останавливает
data route. S09 доказывает восстановление после возврата, не outage availability.
Переход к шести перед приглашением пользователей — отдельное решение владельца.

После terminal обновлять текущую строку и linked checkpoint, не наращивать
хронологический changelog. Одна функциональная часть → focused/build → связные
исправления → matching rerun → required final gates/review/commit.
