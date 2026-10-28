# Аудит требований: задержки и восстановление

Дата:2026-10-28. Отдельный read-only аудит Astra Ultra по запросу владельца.
Владелец решений:Mr. X. Это evidence/review, не второй нормативный документ
или backlog. Очередь остаётся в [NEXT-SPRINT](../NEXT-SPRINT.md).
Проверены текущие требования и исходники; новый пакет recorded-winner/XPS
на момент аудита ещё не квалифицирован целиком и не активирован на CLI.

## Выводы

| Приоритет | Наблюдение | Необходимое действие |
| --- | --- | --- |
| Высокий | Полная проверка архива на обычных границах противоречит независимой от истории задержке≤1s | После retained-раунда принять точное изменение времени обнаружения повреждения неиспользуемого архива и реализовать P1.2 |
| Высокий | Ограничение одной recovery-транзакции не гарантирует длительное восстановление | Отдельно определить bounded active custody, authenticated archive checkpoint и допустимый retirement frontier |
| Средний | Fresh admission ошибочно может трактоваться как новый сетевой запрос в каждом helper | Объединять работу внутри закрытого сегмента; сохранять реальные проверки на trust/effect boundaries |
| Средний | Очистка имеет сильную, но последовательную модель callbacks | Сохранить final callback-free boundary; не смешивать logical commit и завершённое retirement |

Доказанной уязвимости, требующей остановить текущий XPS/recorded-winner пакет,
не найдено. Это ограниченный correctness/recovery срез, а не доказательство
subsecond delivery или завершённого S05.

## Полный архив и ordinary delivery

[DR-0175](../survival-program/decisions/DR-0175-active-native-state-and-archive-validation.md)
требует полного обхода metadata и физических cipher pages на прежних границах
проверки prefix. Реальный
[ActiveRead](../../deep-client-shared/src/Deep.Client.Shared/Persistence/DeviceV2/Did2MessagingSqlJournal.ActiveRead.cs)
выполняет cipher scan, metadata scan и lifetime COUNT. В зафиксированном замере
10k строк одна проверка заняла1.907s, ещё до сети. Этот microbenchmark не является
измерением доставки, но уже опровергает history-independent≤1s при таком контракте.

P1.2 должен оставить независимый защищённый root, authenticated membership и
nonmembership, bounded working suffix, semantic reducers, реальные selected
bytes, floors и отказ при missing referenced nodes. Обнаружение повреждения
НЕИСПОЛЬЗУЕМЫХ архивных страниц переносится на доступ/cold/full audit. Это
явное изменение времени обнаружения, а не эквивалентная косметическая оптимизация.
Обычный путь не может выполнять работу, пропорциональную всей истории.

## Границы восстановления и сохранения доказательств

[DR-0078](../survival-program/decisions/DR-0078-did2-owned-publication-renewal.md)
ограничивает новый recovery тремя последовательными positive winners. Каждое
закрытие добавляет два protected slots; retirement этих свидетельств не выделен.
[DR-0129](../survival-program/decisions/DR-0129-owned-prekey-service-succession.md)
помещает все промежуточные XPS в неизменный16KiB support. Повторная потеря ответа
после успешной выдачи либо длительный offline могут исчерпать эти границы без
компрометации identity. Увеличение caps и сброс аккаунта не решают lifecycle.

Нужно различать bounded work за вызов, bounded active custody и общий retained
archive. После НАСТОЯЩЕЙ completed publication исторические closure могут быть
перенесены за независимо защищённый checkpoint/index, с bounded current record,
монотонными generation/hash floors и sticky fork evidence. Это ограничивает
горячую работу, но само по себе не ограничивает общий архив. Удаление требует
отдельного frontier, навсегда делающего старое пространство операций недопустимым;
expiry, successor publication или заполнение диска таким доказательством не являются.
Lifetime operation-ID collision lookup нельзя молча заменить45-дневным semantic
dedup из [RETENTION](RETENTION-AND-RECOVERY-V1.md).

Полная цепочка XPS доказывает именно соседние переходы и policy continuity.
Текущая подпись устройства и две inventory receipts доказывают другие факты.
Два возможных будущих решения следует различать:

- Verified-lineage checkpoint: уполномоченный verifier проверяет всю цепочку
  один раз; защищённое/аутентифицированное свидетельство несёт результат.
  Нужна явная checkpoint authority; одного hash удалённому verifier недостаточно.
- Current-device supersession certificate: текущее устройство явно связывает
  actual prior DCB/XPS с current committed service. Это меняет all-hop audit
  invariant и требует отдельного semantic decision, даже если опубликованные
  threat-model свойства удастся сохранить.

Оба варианта обязаны сохранять exact prior/current bindings, scope/policy,
current authority/time, same-generation winner, monotone floors, sticky forks,
consumed prekeys и pending claim/Initial obligations. Нельзя стирать уже
наблюдавшийся fork или подменять unknown pending inventory. Нынешняя полная
цепочка также не доказывает, что авторизованное злонамеренное устройство никогда
не подписало скрытую альтернативную ветку.

## Эквивалентные оптимизации и Signal

[TRANSPORT-NEUTRAL](TRANSPORT-NEUTRAL-MESSAGING.md) уже допускает retained
immutable public capabilities и общие endpoint sets при fresh account/device/
floor/time joins. [DR-0176](../survival-program/decisions/DR-0176-bounded-protected-storage-inventory.md)
допускает одну admission внутри закрытого operation segment. Поэтому повторные
reads/signature checks внутри неизменившегося сегмента можно объединять.
Callback/wait boundary, реально наблюдённый revoke, selected-byte validation
и независимый root этим не отменяются. Mtime/TTL не заменяют actual state.
[THREAT-MODEL](THREAT-MODEL.md) уже описывает глобальную revocation как eventual;
fresh authorization не означает обязательный сетевой fetch в каждом helper.

Signal PQXDH аутентифицирует current signed prekeys identity-ключом и допускает
их замену с ограниченным сохранением прежних private prekeys. Инициатору не нужна
вся история предыдущих signed prekeys. Это полезное разделение identity authority
и prekey history, но не автоматическое доказательство безопасности XPoint checkpoint.
Источник:[PQXDH §§2.4,3.2–3.3](https://signal.org/docs/specifications/pqxdh/).
Double Ratchet использует текущее состояние цепочек и ограниченные skipped keys,
не перепроверяет весь чат для каждого сообщения.
Источник:[Double Ratchet §§3.2–3.5](https://signal.org/docs/specifications/doubleratchet/).

Полные гейты нужны на законченном пакете, не после каждого edit. Исторический
каталог implementation-specific тестов можно обновлять через существующие
reviewed replacement bindings, сохраняя security/recovery assertions и исходные
отказы. Это уже разрешено текущими AGENTS/NEXT-SPRINT; новый framework не нужен.

## Порядок

1. Закончить B и исходный pending, провести retained round60 на тех же3 CLI.
2. Принять точный P1.2 timing contract, реализовать bounded ordinary state work
   и измерить warm delivery/ACK отдельно от cold maintenance.
3. Выделить completed-lineage checkpoint/retirement contract и проверить
   repeated-expiry/long-offline recovery. До этого соответствующие S05 claims
   остаются открытыми. Windows/Android и release не квалифицированы этим аудитом.

## Проверка замечаний по запросу владельца

Сверено с исходниками и существующими receipts 2026-10-28. Таблица фиксирует
состояние исправлений; исходные выводы аудита выше не заменяет.

| Замечание | Подтверждённое состояние | Что остаётся |
| --- | --- | --- |
| Полные обходы архива | Не исправлено: `VerifyActiveTip` по-прежнему вызывает cipher integrity scan, `VerifyActiveHistory` и lifetime COUNT | P1.2: authenticated index, reducers, bounded suffix, все consumers, enrollment и замеры |
| Пределы recovery/XPS | Частично: A/B Protocol127 и Shared53 focused PASS; не full/connected acceptance | Private route consumer correction, затем independently owned paged prefixes у owner, Registry и получателей; ограничение3/45 не считать lifecycle |
| Повторная fresh admission | Частично: DR-0176 закрытый operation segment реализован, admission сбрасывается перед callbacks | Измерить оставшиеся authority/native затраты полного пути; исключить повторную работу только внутри неизменного сегмента |
| Очистка после callbacks | Исправлено в проверенном storage-срезе `6d5a185`:207 Shared focused,29 CLI | Полный пакет и фактическое retained E2E ещё не квалифицированы; не ослаблять callback-free final boundary |

При дополнительной проверке обнаружен связанный функциональный дефект:
publication после recorded recovery могла завершиться, а DMC2/14 обновление
маршрута для существующего контакта отвергалось. Точная коррекция закреплена в
[DR-0110](../survival-program/decisions/DR-0110-did2-private-route-update-custody.md#2026-10-28--private-recorded-proposal-witness).
Producer/consumer код прошёл независимые focused native тесты: recovery,
принятие control, cold Store/ACK и обычный следующий offset. Registry positive
winner ceremony прошла на disposable PostgreSQL, XNode108 cases прошли.
CLI ещё не проверены этим пакетом; bounded-history замечание остаётся открытым.

### Уточнение рекомендации Astra для длительного recovery

Рекомендуется проверять историю страницами с независимо защищённым прогрессом
У КАЖДОГО verifier: owner, Registry issuer и DMC2/14 recipient. Удалённый hash
или чужой checkpoint не заменяет собственную проверку. Checkpoint связывает
kind/scope/device/policy, actual completed anchor, последний generation/hash,
ordered evidence commitment, отдельный archive root и sticky fork state.
Он удостоверяет только уже проверенные исторические факты, не live permission.

Страница содержит не более3 recorded pairs или32 XPS. Каждый соседний переход
проверяется исходным predicate; progress сохраняется атомарно. Следующий вызов
получает новую current authority/time/floor admission. Exact replay идемпотентен;
gap, changed same-generation, NULL winner, missing referenced node и rollback
отклоняются. Completion требует достижения точного endpoint. Общая catch-up
работа остаётся пропорциональной пропущенной истории, но один вызов ограничен.

Использовать существующие private control transports. Registry должен владеть
своим защищённым прогрессом: существующий MAC-механизм требует отдельного
purpose/domain и join с независимым restore-authority revision/hash; один MAC
не предотвращает rollback. Получатель сохраняет старый маршрут, пока сам не
проверит весь prefix. Доставка доказательства не должна зависеть от принятия
ещё непроверенного нового маршрута. DCR может перестать нести всю XPS историю
только после явной замены carriage rule DR-0129 и завершённой независимой
проверки owner/issuer; immediate-hop проверка не меняется.

Public evidence допускает общий codec индекса P1.2, но отдельные family/scope/
protected roots. Private phase1 scalar нельзя переносить в SQL под одним
database key. Его retirement требует positive winner, необратимого закрытия
старого intent, отсутствия поздней фазы/зависимостей, durable public evidence
и original-entry hash, атомарного принятия replacement intent. Иначе custody
сохраняется. XPS checkpoint не удаляет claimed/consumed prekeys или pending
Initial. Общий архив может расти; bounded total retention пока не заявляется.

Эта рекомендация ещё требует exact-format и adoption decision перед runtime
реализацией. Проверки должны включать4/10/100 прерванных renewals, более45 XPS,
независимый full-history verifier, fork/rollback/callback/crash/cold-reopen и
отставших получателей. Следующий агент не должен считать этот раздел готовым
кодом или закрытым замечанием. Владельцы реализации и очередь — только NEXT-SPRINT.

### Дополнительный review Astra перед P1.2 runtime

Изолированные codec/proof проверки по DR-0177 реализованы; runtime ещё не
подключён. Review конкретного adoption-плана выявил следующие обязательные
поправки. Они должны войти в точный runtime decision до реализации.

- Сначала завершить старые pending/cleanup/prefix plans всех сессий и сократить
  suffix до63 прежним authenticated owner. Затем один раз перевести весь catalog
  в V2/state0 без изменения фаз, scopes, keys или порядка. Один live progress
  на аккаунт; завершать adoption/readback/cleanup до следующей сессии. Пока есть
  state0, ordinary opens и новая регистрация запрещены.
- Source fingerprint связывает canonical исходные cells/types/lengths И
  `events.rowid`; исключаются только новые archive tables, schema5/6 связываются
  отдельно. Физический file hash меняется при staging и для этого не подходит.
  Initial target basis равен frozen history.Basis, suffix сохраняется над ним.
- Progress1120 может сохранить восемь32-byte hashes, но второй registration
  hash заменить peer-bootstrap hash: CompactionRegistrationSlot и KeySlot —
  один и тот же anchor. Hash-chain progress не является antirollback authority.
- Перед ordinary root/mirror check восстанавливать только явно существующий
  prefix plan/progress. SQL-after/protected-before — допустимое recorded state.
  Generic mismatch не запускает repair; state1 с отсутствующим root всегда
  отклоняется, даже если остался FinalReady progress.
- SQL work выполняется синхронными закрытыми сегментами. После callback заново
  присоединять actual protected custody и открывать физически новое nonpooled
  connection; один новый connection factory без изменения lifetime owner
  недостаточен. Postcommit failure сохраняет committed/incomplete plan.
- Immutable history304 больше не доказывает текущий archive. Проверить всех
  Store/ACK/outbox/control/retirement владельцев root10; добавить actual archive18
  guard там, где используются его факты. Private replay digest2 связывает
  archive608, moving basis, actual floor и все suffix transitions для DPE2 и DBR2.
- Bounded delta разрешает только immutable index/reducer inserts, mirror replace
  и удаление выбранного journal prefix. Event/payload/Store/ACK/key deletion не
  разрешается. Worst-case bounded batch не доказывает subsecond maintenance.

Нужны проверки двух сессий при частичном enrollment, всех cutpoints, регистрации
во время преобразования, state1/missing root, rowid substitution, callback page
substitution, SQL-after/protected-before, mutation во время retirement и
независимый full-source rebuild против incremental index. Эти пункты не закрыты
одними существующими codec tests.
