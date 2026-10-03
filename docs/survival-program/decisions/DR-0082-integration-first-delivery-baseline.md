# DR-0082 — интеграция от текущего состояния и доказательство доставки

Дата: 2026-10-03. Статус: **принято для архитектуры и порядка реализации**
в рамках порученного пользователем аудита; runtime activation не предоставляется.
Основание: [аудит](../../architecture/ARCHITECTURE-AUDIT-2026-10-03.md) и
[зафиксированный handoff](../../RELEASE-STABILIZATION-HANDOFF-2026-10-03.md).

## Проблема

Изолированные Protocol/Shared slices продвинулись дальше XNode и shipping
composition. Старые execution plans предлагают одновременно начинать clean
break, продолжать текущий rollout и реализовывать полный product scope.
Компиляция и own-publication не доказывают доставку другому клиенту.

## Решение

1. Сохранить текущую DID2/E2EE/onion/durable-mailbox архитектуру. Сначала
   завершить один сквозной contact → text → durable receive → application receipt
   путь на одной точной матрице исходников и артефактов.
2. Использовать DR-0081 как текущий mailbox contract; связать issuer, Protocol
   host verification, node admission, peer replication, Shared и MAUI. Новая
   версия wire допустима только при доказанном пробеле, который нельзя закрыть
   текущим контрактом, с отдельным decision/frozen evidence.
3. Разделять liveness, current-authority readiness, transport Store receipt,
   durable recipient materialization и authenticated application receipt.
   Сообщение не получает статус «доставлено» только по Store/quorum ACK.
4. Recovery использует durable intent, exact retry/reconciliation и bounded
   backoff. Потеря сети/срока текущего authority не уничтожает account,
   историю или очередь. Невалидные/forked данные fail closed; это не обычный
   reconnect. Полные переходы остаются у тематических владельцев.
5. Сроки current authority и protected time не обходятся. Control-plane
   refresh выполняется proactively, single-flight и независимо от UI polling;
   historical catch-up даёт историю, а не current authorization.
6. `OfficialXPoint3` проверяется на сохранность и восстановление после outage.
   Доставка при отсутствии одного из трёх обязательных routing nodes не
   обещается. Расширение roster/privacy profile — отдельное product решение.
7. Сначала coherent server/client integration и retained-state recovery;
   затем физический Android/Windows text; затем files/groups/calls/carriers и
   полный release gate. Это milestones, не сокращение публичного scope.

## Documentation и границы решения

[NEXT-SPRINT](../../NEXT-SPRINT.md) хранит статус; единственный
[IMPLEMENTATION-PLAN](../../architecture/IMPLEMENTATION-PLAN-V1.md) хранит
зависимости, пакеты и acceptance. Старые package IDs сохраняются как ownership
mapping для release evidence, но больше не являются отдельным порядком работ.
Датированные checkpoints и SPRINT-HISTORY — исторические доказательства.

Это решение не вводит API/request-admission journal из удалённого эксперимента,
упомянутого в handoff; номер DR-0082 не восстанавливает тот эксперимент.
Не меняются wire bytes, криптография, root custody, retention, quorum, consent
или ранее принятые privacy/security требования. Не предоставляются разрешения
на production deployment, data reset, push, merge или публикацию.

## Acceptance

Выполнить DAG и gates единого плана. До evidence на точной shipping composition
не объявлять работоспособность сети, физическую доставку или release readiness.
Если connected slice обнаружит контрактный цикл, остановить affected lane и
оформить минимальное изменение у нормативного владельца.
