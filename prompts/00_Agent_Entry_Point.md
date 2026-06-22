# 00 - Agent Entry Point (Deep Parity Program, Sprint Baseline)

## Назначение

Этот документ задает стартовую точку текущего спринта и правила исполнения до production-ready/GA.

## Текущий baseline (старт спринта)

Источник: `roadmap.md`.

- Интегральная готовность к production release: 78%.
- Техническая готовность: 91%.
- Организационно-релизная готовность: 58%.

Ключевые блокеры на старте:
- отсутствуют рабочие staging secrets для provider canary;
- не закрыт lane `devops-release-secret-preflight:selected`;
- нет полного P6 raw manifests комплекта на одном RC;
- не пройден финальный strict `production-readiness` прогон.

## Источники истины (порядок чтения)

1. `roadmap.md`
2. `docs/delivery-plan.md`
3. `docs/parity-matrix.md`
4. `docs/e4-acceptance-checklist.md`
5. `prompts/README.md`
6. активный дочерний промпт

Если документы конфликтуют:
- приоритет у `roadmap.md` и `docs/delivery-plan.md`;
- расхождение фиксируется как blocker/decision.

## Архитектурные инварианты

1. Клиент единый: `deep-client-maui` + `deep-client-shared`.
2. Изменения проверяются на Android, iOS, Desktop/Windows.
3. Launch-critical путь не зависит от mock/compat-only fallback.
4. Любой релизный gate воспроизводим в CI.

## Текущий порядок исполнения

0. Выполнить этот entry-point.
1. `06_Security_and_Compliance_Gates.md`
2. `07_Observability_and_SRE_Gates.md`
3. `08_Release_Discipline_and_Rollout.md`
4. `09_Stabilization_and_GA.md`

Опционально:
- `13_Messenger_Node_Production_Ready.md` для углубленной node/network operational готовности.

Архивные фазы (`01,02,03,04,05,10,11,12`) повторно не исполняются, если нет явного регресса.

## Phase gate правило

Переход к следующему шагу разрешен только если одновременно:
1. Изменения по текущему промпту реализованы.
2. Тесты/проверки зеленые.
3. Артефакты (логи, отчеты, CI evidence) приложены.
4. `roadmap.md` и релевантные `docs/*` обновлены.
5. Для открытых рисков зафиксированы owner, ETA, mitigation.

## Обязательный отчет после шага

1. Что сделано.
2. Какие файлы изменены.
3. Какие проверки запущены и результаты.
4. Какие блокеры/риски остались.
5. Что требуется для перехода дальше.

## Stop-the-line

Немедленно остановить продвижение и открыть blocker, если:
- найден mock/compat-only в release path;
- есть critical/high security finding без remediation plan;
- platform matrix нестабилен без owner и ETA;
- strict production-readiness не воспроизводим.

## Финальный критерий завершения

1. Launch-critical сценарии закрыты.
2. Security/observability/release gates стабильно зеленые.
3. Rollback rehearsal подтвержден артефактами и приемлемым MTTR.
4. GA решение подписано engineering, security, ops.
