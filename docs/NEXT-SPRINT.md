# Текущая очередь Deep / XPoint

Обновлено: **2026-10-09**. Branch: `release-candidate/prod-20260909`.
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
held account lease, protected roots/native SQL fence и complete application/native
SQL readback по private owner DR-0105, включая crash recovery.
Базовый capture зависимостей намеренно pin-ит каждый known grant/catalog и
каждый Retrieve; наблюдаемые flags сами не дают deletion permission.
Отдельный used-Deposit source producer закрывает write-holder зависимости
независимыми original Store/native joins и сохраняет live object/read custody;
его targeted checkpoint ниже не закрывает весь lifecycle или activation.
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

### Текущий S01 functional batch — 2026-10-09, не принят

Private idle-counter profile по
[DR-0105](survival-program/decisions/DR-0105-idle-mailbox-counter-retirement.md)
реализован: held epoch exclusion, exact dependency guards, удаление только
неиспользуемого counter и cold recovery/abort. Original grant/holder/route,
traversals, SQL и semantic/receipt/asset custody сохраняются. Это не удаление
acquisition/path и не runtime cleanup S04. Следующий source increment связывает
ordinary outbox-cleanup с удалением только выбранных завершённых send entries:
Ordinary → Send, все counters и original SQL MAU3/quorum/coordinator ledger
сохраняются. Cached Store использует сохранённую custody без нового grant,
enrollment или dispatch; missing/changed ledger не восстанавливается.
Cold handover, non-prefix rejection и real used-Store floor retirement входят
в текущую проверку пакета, пока без matching qualification. Initial/acceptance,
acquisition/traversal и terminal receipt/object closure остаются открыты.
Current production build —0 errors/0 warnings. Targeted02 дал1 Passed/1 Failed:
cached Store/hostile ledger прошли, non-prefix fixture использовал insert-only
API вместо CAS. Fixture исправлен без ослабления guards; cached replay теперь
использует общий exact route/ciphertext post-callback recheck. Targeted03 прошёл
2/0/0/native0 за16m34s, включая все handovers/non-prefix/unknown pinning и
used-counter retirement после семи Store; current preflight6/0/0/native0.
Matching full Shared gate завершился FAIL в
`artifacts/test-gate-20261009/shared-retirement-full-01`: build0/zero warnings,
preflight6/0/0, predeclared union784, frozen inputs1825. Четыре новых runtime/test
source files включены в manifest. Full783/1/0/native1/qualification1;
единственный failed case — `UncommittedExactPlanCanAbandon(deposit: False)`.
Сбой до retirement, в durable onion entropy commit: Windows `MoveFileEx`
вернул ACCESS_DENIED при замене protected aggregate. Original terminal/TRX
сохранены. Независимая post-terminal проверка canonical module подтвердила
exact784 mappings и все1825 inputs unchanged, но не превращает native1 в PASS.
Причина исходного host отказа не установлена. Реальный Windows handle,
удержанный350ms, воспроизвёл отказ старого127ms replacement (native1).
Correction использует cancellable async retry до2s под обоими writer leases,
без обхода ACL/rename/custody. Targeted20/0/0/native0 за51s после build0/
zero warnings: storage CAS, четыре native replacement negatives/positive,
оба abort-retirement rows и все6 preflight. Persistent denial/cancellation
сохраняют whole previous aggregate; pending не становится recovery source.
Это не matching full PASS; новый full не запущен после отдельной правки.
Isolated storage/test fix закоммичен локально как Shared `ab78bb8` от
`zhigubigule`/no-reply, без push. Остальной S01 batch ещё в worktree;
targeted20 receipt относится к composed worktree, не к одному commit.
S01 целиком не закрыт. Подробности и точные reference receipts — в checkpoint ниже.

Counter profile дополнен обязательным unchanged complete application/native SQL
guard (sole layout — Shared owner DR-0105); прежний unqualified counter plan без
него отвергается без compatibility reader. Native SQL-only изменение после
staging теперь проверяется на реальном completed receive/ACK. Guard01 дал
93/1/0/native1 за5m58s: единственный FAIL нового Deposit fixture — он читал
replay counter до первого Store, когда такой SQL row ещё отсутствует. Остальные
guard/recovery/abort/cancellation и три current delayed-issuer cases прошли.
Fixture-only correction меняет обязательную credential-epoch row без изменения
product guards; matching build0/zero warnings, exact two modified cases плюс
preflight прошли8/0/0/native0 за26s. Canonical mappings подтверждены; исходный
FAIL сохранён. Matching mandatory full и известный acquisition/send-work closure
остаются открыты, S01 и device/release этим guard не закрываются.

После issuer request-start correction прежний failed initial pre-ingress row
проверен на текущей сборке: exact row плюс все6 preflight —7/0/0/native0 за5m46s,
canonical7 mappings подтверждены. Сценарий сохраняет exact request до ingress,
делает один Store и после cold signed-epoch rollover читает original outcome без
повторного dispatch. Hostile original-evidence assertions сохранены; исходный
focused08 остаётся FAIL. Это не qualification остальных current initial variants,
whole S01/full/connected/package или физических устройств; receipts в checkpoint.

Следующий source increment того же S01 реализует completed initial/ContactAccept
send working disposition: independent original Store closure и exact native/
semantic/source/MAU/quorum/coordinator/grant/counter join. Private ProtectedOnly
Audit profile меняет только Send; floors, acquisition, route/holder, semantic
receipts/objects и last Retrieve/ACK сохраняются. Existing mailbox-state guard
расширен contact intents и actual read-only device source SQL/checkpoint/key-
retirement/preclaim custody; source не создаётся/не чинится при recovery.
Matching solution build0/zero warnings/errors за4.52s после source/test integration;
targeted01 прошёл69/0/0/native0 за10m21s, exact mappings проверены canonical
module. Это не complete source closure: затем найден отсутствующий responder/
prekey guard. Его readback и actual responder-SQL post-stage negative добавлены;
matching targeted02 прошёл71/0/0/native0 за17m13s после clean build4.80s.
Canonical module подтвердил exact71 mappings, четыре contact-send случая,
обе ordinary regressions и все шесть preflight. Matching full/connected/
package/physical qualification остаётся открытой.
Exact scope и receipts — в Shared checkpoint. Known acquisition
deletion, traversal и sustained lifecycle остаются открыты. Состав profile и API —
только в Shared owner; S02/S04/runtime activation этим изменением не открываются.

Промежуточный source checkpoint этого S01 пакета: Shared `61b7ab8`,
Protocol `93ef9bd`; commits от `zhigubigule`/no-reply. Shared targeted71/0/0
и парный Protocol targeted50/0/0 проверены canonical reader, исходные FAIL
сохранены в checkpoint. Это фиксация реализации, не принятие всего S01:
known acquisition/traversal/terminal receipt-object closure, mandatory full,
shipping/package/platform и physical Windows/Android gates остаются открыты.
Production, account data, Releases и main этим checkpoint не изменены.

Следующий связный source checkpoint: Shared `f0a0a47`, used Deposit holder
retirement. Реальный исходный Store для initial DPH2 и ContactAccept остаётся
проверяемым после освобождения acquisition; live object, native/source/history,
read paths и receipt work не удаляются. Пять cold handovers каждого пути,
потеря SQL evidence до staging/при recovery и цепочка oldest-first проверены
targeted65/0/0/native0 (Windows PowerShell5.1, SDK10.0.301,12m59s).
Предшествующий exploratory61/1/0/native1 сохранён как FAIL, без ослабления30s
installation window. Exact receipt/границы —
[Shared checkpoint](../deep-client-shared/docs/testing/s01-idle-mailbox-floors-2026-10-09.md#used-deposit-holder-retirement--targeted-source-checkpoint),
private contract —
[sole grant owner](../deep-client-shared/docs/architecture/owned-mailbox-grant-custody.md#used-deposit-holder-retirement--s01-source-candidate).
Это source increment S01, не переход к S02: matching mandatory full,
sustained128/512, независимый issuer/receipt-key
rollover и known Retrieve/traversal/last-path closure ещё открыты. Новые public
wire/journal generations и legacy readers не добавлены. Runtime scheduler,
physical Windows/Android, shipping и релиз не квалифицированы; production,
account data, Releases и main не изменены.

Дополнение того же S01 пакета: Shared `3124614`, actual used-chain owner
targeted9/0/0/native0 (8m38s). Два Store под разными принятыми holders в одной
цепочке: oldest-first отказ при неверном порядке, cold recovery после staging,
сохранение successor и последующее освобождение обоих holders без удаления
live objects/source/history/receipt custody. Lost reply нового Store сохраняет
unknown send и запрещает удаление старой цепочки. Исходный шифротекст и cached
Store остаются точными без повторного ingress; ordinary cleanup использует
реального владельца scope в обоих направлениях.
[Exact checkpoint](../deep-client-shared/docs/testing/s01-idle-mailbox-floors-2026-10-09.md#used-deposit-chain--actual-owner-checkpoint).
Подготовка signed successor использует controlled fixture: runtime renewal,
sustained128/512, full, remaining S01 и physical/release этим не квалифицированы.

Во время этого запуска выполнен один EventPipe stack snapshot через официальный
`dotnet-stack` версии `10.0.750501` из ignored artifacts, без memory dump. Наблюдались
ordinary cold-recovery test в `SqliteDeepMailboxStore.InitializeSchema` и второй
actor в `SqliteDeviceStateStore.Open` при подготовке contact hello. Это не
доказательство единственной причины замедления или зависания. Source inspection:
mailbox уже использует native raw-key encoding, device store передаёт32 binary
bytes непосредственно в `sqlite3_key`. Профиль этого последнего consumer требует
проверки до оптимизации; KDF/integrity/path/rollback guards не ослаблены, source
и test inputs во время gate не менялись. Инструмент не добавлен в app dependencies.

Следующий связанный S01 пакет после terminal — independent retained public Store
outcome custody и retirement связанных old Deposit acquisition slots.
Source inspection подтвердил зависимость: current cached Store читает exact
XMG2/XMC2 из protected grant journal; policy/route получает как independently
current verified inputs. Original policy/route из acquisition нужны отдельному
epoch-exclusion consumer, а не читаются current cached Store. Application schema9
содержит MAU3/quorum/coordinator ledger и policy digest, но consumer всё ещё
зависит от acquisition winner и current issuer/route, поэтому не доказывает
independent historical outcome после их retirement/rollover. Retained native
MGR1 может уже сохранять нужную route: сначала проверить
его exact binding и переиспользовать, а не дублировать все public records.
Exact original policy и complete outcome join ещё требуют закрытого consumer.
Поэтому сначала закрыть producer/consumer этого evidence, затем удаление
acquisition/holder; не заменять его SQL `Durable` или
cached `verified` flag. Использовать существующие owned SQLCipher/native custody
и plan/recovery; exact dependency semantics остаются у
[§8.4.3/8.4.4](architecture/TRANSPORT-NEUTRAL-MESSAGING.md#843-compaction-and-boundedness),
private API mapping — у
[Shared grant custody](../deep-client-shared/docs/architecture/owned-mailbox-grant-custody.md#held-retirement-dependency-capture).
Initial/acceptance, unknown, retained Retrieve/ACK и receipt/object obligations
не становятся eligible от этого анализа. После этого inspection принят
[DR-0106](survival-program/decisions/DR-0106-retained-store-public-evidence.md):
original public policy/view/selected descriptors, без нового wire/holder secret.
Producer записывает их при Store completion, до protected Stored; selection
остаётся read-only. Новый historical reader связывает actual native/semantic/
MAU/quorum/coordinator без acquisition journal/current peer route/current keys.
Application schema10 — clean break без migration. Build0/zero warnings; первый
targeted17 дал16 Passed/1 Failed: public-evidence negatives, raw-key/schema и
preflight прошли; all-handover остановился на dispatch clock, который отстал от
prepared NotBefore. Детерминированный slow-SQL baseline воспроизвёл тот же FAIL.
Исправленный focused20/0/0/native0 прошёл за15m40s; exact mappings подтверждены.
Protocol bounded constructor6/0/0/native0, build0/zero warnings. Следующий
follow-up того же S01 пути: независимое чтение completed Store до compaction и
final authority recheck после локальной записи. Build0/zero warnings. Focused-03
дал13/1/0/native1: completed-working expiry прошёл, expiry fixture не пересекал
реальный deadline; тест исправлен без расширения authority. Focused-04 дал
8/1/0/native1: expiry/custody прошли, cancellation recovery остановился на
signed receipt interval. Его fixture clock приведён к уже существующему
монотонному dispatch sample; это изменение пока не квалифицировано. Прежние
FAIL сохранены; эти source receipts не означают mandatory full или device E2E.
Текущий связный S01 batch расширен на ContactAccept: исходные public records до
ingress, pending без ложного success, cached original Store после cold epoch
rollover без renewed peer/grant authority, exact winner/native/semantic joins
и повторные root/route guards. Focused-05 прошёл13/0/0/native0 за13m45s после
build0/zero warnings; canonical mappings13. Это cold/fault/negative ContactAccept,
completed-working expiry, pair, cancellation/expiry, slow clock и6 preflight,
но не два ordinary-compaction случая: фильтр не совпал с их actual names.
После прогона добавлен post-ingress exact evidence guard и отдельный lost-evidence
callback regression; build0/zero warnings (57.61s), targeted1/0/0/native0 за4m51s,
canonical mapping1. Проверены unknown-return/no-repair/no-second-ingress и
неизменность оставшихся native/protected/SQL facts. Повторный matching общий
source пакет ещё открыт; предыдущие13 не повторены на последней редакции. Initial
DPH2 recipient-route source реализован в следующем связном пакете: исходные
DCR/route/positive ADP в той же SQLCipher-записи; exact draft/source/native/
protected peer joins, original-time identity/PQ/witness verification и cached
public StartContact до нового resolve. Exact pending retry сохраняет первый
nonce-bound proof, а не заменяет его свежим. Missing attempted/durable evidence
не восстанавливается. Schema10 остаётся unqualified clean break; ранние локальные
candidate layouts требуют reset, без migration/dual reader. Последний build0,
zero warnings/errors за33.15s после связного correction batch. Focused-07 завершён
native1:16 Passed/4 Failed/0 Skipped; четыре новых initial случая выявили неверный
raw SHA256 вместо DID2 RecordHash. Проверка исправлена codec RecordHash, не
удалена. Добавлены fail-closed discovery для потерянного completed draft/source
и unknown Store с потерянными public evidence; без resolve/reauthor/provision.
Focused-08 завершён native1 за22m12s:20 Passed/1 Failed/0 Skipped/21 total;
canonical module подтвердил exact21 mappings. Остался initial pre-ingress случай:
выданный grant не покрывал полный authenticated client time interval. Inspection
выявил mismatch producer: начало grant было network-only lower bound, а клиент
правильно проверяет union recipient/network. Current и retained Retrieve producer
исправлены на bounded signed XMG2 start с signed role ValidFrom floor; lifetime,
current-only admission, expiry/signature/final guards не ослаблены. Добавлены
детерминированные0/1/5s delayed-issuer cases; новая source qualification pending.
Весь S01 и full/device gates не закрыты; исходные FAIL сохранены.
Lightweight Protocol retained-issuer matrix44/0/0/native0 за600ms подтверждена
canonical exact mappings; Shared build0/zero warnings/errors за25.84s. Это не
qualification current issuer/Shared initial retry. Следующая часть того же S01
source batch переводит ordinary working-cleanup selection на independent original
Store closure с current own authority, без renewed peer/issuer admission.
Actual send/acquisition/replay-floor joins, complete application SQL и два exact
root successors сохранены; holders/floors/ACK/receipts/history не удаляются.
Регрессия расширена selection после cold signed epoch rollover и hostile evidence;
final matching production build10.50s0/zero warnings/errors.
Matching Shared targeted/full откладываются до завершения связного S01 batch.
Known acquisition deletion permission, independent issuer/receipt-key rollover,
matching full/connected/API/package и physical gates остаются открыты.
Historical admission или runtime cleanup не активированы. Exact evidence —
[checkpoint](../deep-client-shared/docs/testing/s01-idle-mailbox-floors-2026-10-09.md#original-public-store-outcome-source--dr-0106).

Connected source проверка дала52 Passed/1 Failed/0 Skipped;26 новых floor
случаев прошли. Подписанный time window исправлен и4 preflight прошли;
semantic ACK fixture отдельно проверяет offline projection и отказ expired
current authority. Исправленный connected semantic сценарий отдельно прошёл
1/0/0/native0 за2m23s. Исходные FAIL сохранены; matching full ещё не
квалифицирован и S01 не принят.
[Exact checkpoint](../deep-client-shared/docs/testing/s01-idle-mailbox-floors-2026-10-09.md).
Полный Shared gate запускается после законченного S01 source batch, не после
каждой правки. Использовать новый общий runner/preflight из локальных коммитов;
исторический106-минутный full не является актуальным временем после throughput
follow-up. S01/S02, physical delivery и release acceptance этим пакетом не закрыты.

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
