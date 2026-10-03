# Текущая очередь Deep / XPoint

Обновлено: **2026-10-03**. Branch baseline: `release-candidate/prod-20260909`;
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

| Этап | Статус на момент аудита | Что закрывает |
| --- | --- | --- |
| S00 | **В работе: Protocol full 2065 pass / 1 fail / 12 skips; XNode full 897 pass / 1 fail, новые prekey negatives 4/4; прежние focused 40 pass / 2 fail не закрыты; Registry 331 pass / 0 fail + 6 Linux signer pass** | [ONION checkpoint](../deep-protocol/docs/testing/s00-onion-baseline-2026-10-03.md), [contact checkpoint](../deep-protocol/docs/testing/s00-contact-baseline-2026-10-03.md), [Node checkpoints](../xnode/docs/testing/s00-node-baseline-2026-10-03.md), [Registry classification](../deep-registry-api/docs/testing/s00-registry-baseline-2026-10-03.md); ONION metadata и program input drift закрыты; package/current authority, invite/XPP и Windows storage открыты |
| S01 | **В работе: DR-0083, Protocol revocation/floor 49/49; native custody 29/29, node admission/peer consumers ещё отсутствуют** | [Revocation contract](survival-program/decisions/DR-0083-current-mailbox-grant-revocation.md), [Protocol evidence](../deep-protocol/docs/testing/s01-mailbox-revocation-2026-10-03.md), [native evidence](../xnode/docs/testing/s01-mailbox-revocation-native-2026-10-03.md); grant/send/route settlement, compaction и application receipt contracts открыты |
| S02 | Заблокирован S01 | Current XNode admission вместо PMA1/P04 и host UTC |
| S03 | Заблокирован S02 | Grant-bound peer mutation, отдельные ID/key, durable quorum |
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

## Блокеры, которые нельзя потерять

- **B1:** Protocol/Shared перешли к DR-0081, node Program всё ещё подключает
  retired mailbox authority; отсутствие current verifier consumer.
- **B2:** protected-time/revocation/holder/selected-exit admission и peer proof
  mutation/quorum не замкнуты; node ID и receipt key в старом adapter слиты.
- **B3:** send journal 512 и grant journal 128 не имеют завершённого sustained
  lifecycle; exact retry не заменяет renewal/settlement/retirement.
- **B4:** network reconnect не draining outbox/inbox; fresh proofs блокируют
  local history; AppAck/read события не включены в текущий DID2 consumer.
- **B5:** messaging DI зависит от diagnostic flag, запрещённого для Release;
  исходники исключённых services не доказывают shipping functionality.
- **B6:** signed PMA2/PMT2 successor provisioning, current issuer readiness,
  package/API/resource/evidence repin и actual installed matrix требуют проверки.
- **B7:** files/groups/calls/multi-device/carriers/full release evidence остаются
  обязательными согласно [V1 scope](architecture/V1-RELEASE-SCOPE.md).
- **B8:** current publication author/verifier поддерживает reusable genesis,
  но не подписанную DID2 one-time invitation; positive claim/replay сценарий
  остаётся failing prerequisite. Сверить current contract и закрыть producer/
  consumer; способность codec разобрать kind 2 не означает runtime support.

`OfficialXPoint3` не передаёт данные при отсутствии одного обязательного узла;
S09 проверяет сохранность и автоматическое восстановление после возврата.
Расширение topology — отдельное решение, а не скрытый fallback.

## Следующий запуск Codex

Продолжить **S00**: current XPP fixture migration и Windows storage investigation.
ONION terminal metadata/schema/checker согласованы с уже принятыми DR-0049/0079/0081.
Фреймы, positive bytes/hashes и 18 hostile classes не изменены. Новый parity test
воспроизвёл четыре stale rows; после исправления privacy suite 64/64, final full
Protocol 2016/1/12. Reviewed repin затронул один document source hash и derived
registry digest, 174 anchors без изменений; strict registry/ONION проходят.
Это не signed authority, runtime activation или device evidence:
[текущий ONION checkpoint](../deep-protocol/docs/testing/s00-onion-baseline-2026-10-03.md).
Protocol: пять stale XPU fixtures переведены на V2; reviewed responder API snapshot
сверен с DR-0025/0026. Focused 40/40; full 2007/1/12, remaining package failure —
retired MCG2, production graph — retained MAU2 consumer. Семь contact-негативов
исполняются; два root contact/crypto consistency gate исправлены по approved
inputs без repin. Ownership mappings и manifest integrity проходят, но не
доказывают executable/native/physical acceptance. Подробности и skip classification:
[Protocol checkpoint](../deep-protocol/docs/testing/s00-contact-baseline-2026-10-03.md).
Registry reader/DB закрыты полным source прогоном; 6 Windows skips отдельно
прошли в actual Linux socket lane. Это не package/physical qualification.
XPP audit подтвердил unsafe construction sealed authority через
`GetUninitializedObject` в `PreKeyInventoryTestCapability`: положительные
opaque-store/XPC cases нельзя считать current signed prekey evidence.
Перенесены concurrency/exhaustion/last-resort-restart assertions в signed DID2
claim runtime; исправлен ошибочный unknown на доказанном pre-reservation отказе.
Checkpoint 5 переносит ещё три unsafe V1 claim scenarios на signed DID2 path:
whole-wire replay, changed-request conflict и scope rejection до mutation.
Восемь новых регрессий воспроизвели escape native Win32 errors; после исправления
claim возвращает Unknown, peer — bodyless unsigned 503, exact reconciliation
сохраняет ключ/generation. Regression 8/8; combined selection 40 pass / 2 fail:
один native access denied, один rejected non-success result с непроверенной
первопричиной. Full source 870 pass / 1 invite fail / 0 skips (871) не закрывает
эти падения. Local external smoke и multi-node проходят с real Xray, но privacy
без verified authority остаётся 503; это не delivery/device qualification.
Подробности, mapping и digests —
[Checkpoint 5](../xnode/docs/testing/s00-node-baseline-2026-10-03.md#checkpoint-5--current-claim-bindings-and-native-io-uncertainty).
Предыдущие lineage/Windows наблюдения сохранены в checkpoint 4; root cause
storage nondeterminism не выяснена и не исправлена новым error containment.
Checkpoint 6 заменил все восемь cases старого `ContactPreKeyXpc1ResponseTests`
на current signed scenarios и сохранил обе contract boundaries. Удалён его
514-line fabricated-capability fixture. Два inner-signature attacks проходят
при доказанно правильной outer HTTP authentication; Unknown/reopen/exact retry
сохраняют исходный ключ. XIC1 duplicate signer отклоняется до reservation;
полностью staged signed manifest с неверной DPK2 подписью не активируется.
Новые negatives 4/4; full 868 pass / 1 B8 fail / 0 skips (869), без удаления
необъяснённых failures. Local external smoke проходит, не physical delivery.
Default solution source build обнаружил Debug у out-of-solution Protocol refs;
проверочный build явно сохраняет Release, package graph этим не закрыт.
[Checkpoint 6](../xnode/docs/testing/s00-node-baseline-2026-10-03.md#checkpoint-6--current-signed-prekey-negative-paths-no-legacy-response-fixture)
содержит exact mapping, commands и hashes. Остальные unsafe fixtures ещё открыты.
Перенести их scenario semantics на actual DID2 inventory/claim path;
не удалять rotation/quota/replay/recovery coverage и не ослаблять verifier.
Synthetic XPA fixture удалён; facade-сценарии перенесены на signed DID2 inputs.
Свежий полный XNode checkpoint — 868 pass / 1 fail, без skips; оставшийся positive
one-time invite требует current producer/consumer contract (B8), а не обхода
verifier. Подробная классификация и границы evidence — по ссылке в строке S00.
Root program input drift закрыт: schema согласована с уже закреплёнными 12
machine inputs; raw LF aggregate перепривязан после сверки offline issuance
producer, шестой DPE2 authorization включён в exact document set. Runtime,
crypto/wire и accepted evidence blobs не изменены. Twelve program guard tests
и десять contact guards проходят; ClassificationOnly проходит, default
ProtocolPackageGO по-прежнему fails из-за отсутствующего executable evidence.
Это input integrity, не package или release qualification. Подробности:
[governance checkpoint](SPRINT-HISTORY.md#2026-10-03--s00-program-input-integrity).
Продолжить **S01** от [DR-0083](survival-program/decisions/DR-0083-current-mailbox-grant-revocation.md):
Protocol signed source/floor producer и independent vectors проверены; native
protected custody реализован и проверен 29/29, final full XNode 897 pass / 1 B8
fail / 0 skips. [Native checkpoint](../xnode/docs/testing/s01-mailbox-revocation-native-2026-10-03.md)
фиксирует границы recovery, concurrency и isolated external smoke. Это ещё не
активированный node consumer. Нельзя включать старую PMA1/P04 composition.
Закрыть остальные lifecycle/compaction contracts, затем подключать current node
admission и проверять issuer→node→client одним сценарием.
Подробные owners, gates и шаблон задания находятся только в едином плане.

Аудит разрешил documentation/architecture consolidation, а не возобновление
production deployment или physical reset. Предыдущие разрешения в historical
memory/checkpoints не трактуются как разрешение нового действия автоматически.
Новый implementation запуск работает в границах явной команды пользователя.

## Как обновлять этот файл

При закрытии этапа указать commit matrix, команды/gate и ссылку на sanitized
сценарное evidence; изменить одну строку статуса. Не добавлять длинные
хронологические повторы. Завершённые наблюдения записывать в
[SPRINT-HISTORY](SPRINT-HISTORY.md). Handoff от 2026-10-03 и DID2 checkpoints
остаются неизменяемой исходной историей, не текущими очередями работ.
