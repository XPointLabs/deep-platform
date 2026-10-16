# Текущая очередь Deep / XPoint

Обновлено: **2026-10-16**. Branch: release-candidate/prod-20260909.
Владелец, если не указан иной: **Mr. X**.

Единственный порядок, зависимости и критерии приёмки —
[IMPLEMENTATION-PLAN-V1](architecture/IMPLEMENTATION-PLAN-V1.md).
Основание — [аудит](architecture/ARCHITECTURE-AUDIT-2026-10-03.md),
[DR-0082](survival-program/decisions/DR-0082-integration-first-delivery-baseline.md)
и [DR-0095](survival-program/decisions/DR-0095-baseline-and-shipping-gate-separation.md).
Это очередь незавершённого, не второй specification или хронологический changelog.
Предыдущие наблюдения, исходные FAIL и exact receipts сохраняются в Git,
[исторической редакции](NEXT-SPRINT-CHECKPOINTS-2026-10-13.md) и repo-checkpoints.

## Единственный активный этап: S05

**S00–S04 приняты в своих source scopes; S05 не принят. S06/device acceptance
не получена.** Diagnostic device runs внутри S05 не открывают параллельные этапы.
Не повторять принятые gates без изменения входов или конкретной verification цели.

Installed diagnostic source:

| Device | MAUI | Shared | Protocol | Artifact |
| --- | --- | --- | --- | --- |
| Windows | `7cf9d21` | `acc65f1` | `605090b` | build15, running retained profile |
| Android | `7cf9d21` | `acc65f1` | `605090b` | APK22/install22, retained profile |

Windows build12 не запускался и не является installed evidence. Source `229c3da`
исправляет закрытый BootstrapAuthority I/O wrapper; matching Windows reached
Verified и завершил Chats sync без ошибки, Android reopened retained workspace.
Typed429/503 recovery физически не инъецировался. Local runtime managed code:
Registry `469460e` (comment-only after `2859756`), Node `0240120`;
Registry NTS helper `dd36774`, publisher
`f4a77ca` (no production change).
Новые source changes проходят отдельную квалификацию; старые APK не являются
доказательством новых inputs. Это не Releases/main или release acceptance.
Shared `acc65f1` carries the independently verified contact pair through one
owned command, including explicit borrowed read/claim custody; current protected
floor, time, endpoint and final native checks remain. Focused8 and the existing
eight affected regressions passed on that production source; MAUI Clean193 /
Smoke119 passed. The first new test run retained one wrong-exception assertion
FAIL, corrected without relaxing production verification. Final full remains.

**Immediate runtime blocker:** supported local Verify subsequently failed;
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
Android22 has no Store/contact delivery. Recover current time/host readiness
before another business retry; do not reset accounts/floors or extend windows.
Local diagnostic Node `0240120` is now active on all three nodes; its closed
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
It is not yet deployed or full-qualified, and is not the proven sole live cause.
Source/runtime evidence:
[contact transport](../deep-devops/docs/S05-CONTACT-TRANSPORT-2026-10-15.md),
[grant custody](../deep-client-shared/docs/architecture/owned-mailbox-grant-custody.md),
[физический checkpoint](../deep-client-maui/docs/DID2-HTTPS-DEVICE-2026-09-28.md).

Текущие испытания — только retained локальный current-dev, девять сервисов /
три ноды. Production этим срезом не изменён. Аккаунты, recovery, originals,
permanent fences, native replay floors, registered node keys и volumes сохранены.

### Оставшаяся работа S05 — по порядку

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
