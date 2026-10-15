# Текущая очередь Deep / XPoint

Обновлено: **2026-10-15**. Branch: release-candidate/prod-20260909.
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

Installed diagnostic source: Protocol `0f295cd`, Shared `72a86c5`, MAUI Windows
`845a666` / Android `31fe23b`; Registry `6eb84ee`, Node `01d86d5`, DevOps `7b2799f`.
Новые source changes проходят отдельную квалификацию; старые APK не являются
доказательством новых inputs. Это не Releases/main или release acceptance.
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
   **Текущий следующий шаг:** завершить explicit stop старого contact intent
   через существующий owned producer, затем отдельное создание нового запроса
   и явное принятие / A↔B text без reset. Stop не доказывает non-delivery/recall.
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
