# 00 - Agent Entry Point (Deep Parity Program, Sprint Baseline)

## Назначение

Этот документ задаёт единственную стартовую точку для локальной реализации Deep Survival Program.

Статус: программа `v2.0.0` одобрена Mr. X для локального исполнения 17 июля 2026 года. Канонический указатель: [`docs/survival-program/README.md`](../docs/survival-program/README.md). Program revision:

```text
sha256:ca5ad9f0c9d4dfb509dedcbf8133524c15867fce5534816da21ff86a07057383
```

Разрешены изолированные worktree и локальные коммиты. Запрещены push/fetch/pull, PR, merge, внешняя публикация пакетов и deployment без отдельного решения Mr. X.

## Исторический parity baseline

Источник: `roadmap.md`. Ниже сохранён baseline старой parity-программы как evidence, а не как активный план.

- Интегральная готовность к production release: 78%.
- Техническая готовность: 91%.
- Организационно-релизная готовность: 58%.

Ключевые блокеры на старте:
- отсутствуют рабочие staging secrets для provider canary;
- не закрыт lane `devops-release-secret-preflight:selected`;
- нет полного P6 raw manifests комплекта на одном RC;
- не пройден финальный strict `production-readiness` прогон.

## Источники истины

1. [`docs/survival-program/README.md`](../docs/survival-program/README.md)
2. [`program-manifest.json`](../docs/survival-program/releases/v2.0.0/program-manifest.json) и применимое decision record
3. [`REVISED-PROGRAM-RU.md`](../docs/survival-program/releases/v2.0.0/REVISED-PROGRAM-RU.md)
4. атомарный prompt из [`agent-prompts/`](../docs/survival-program/releases/v2.0.0/agent-prompts/README.md)
5. `AGENTS.md` назначенного дочернего репозитория, если он существует
6. `roadmap.md`, `docs/delivery-plan.md` и parity-документы только как historical evidence

Если документы конфликтуют:
- работа останавливается;
- расхождение фиксируется как blocker;
- Mr. X принимает decision record; изменение scope/контрактов выпускается новой SemVer-ревизией программы.

## Архитектурные инварианты

1. Клиент единый: `deep-client-maui` + `deep-client-shared`.
2. Изменения проверяются на Android, iOS, Desktop/Windows.
3. P2P/local/off-grid/self-hosted plane бесплатен и не зависит от XPNT, billing или managed cloud.
4. Launch-critical путь не зависит от mock/compat-only fallback.
5. Любой gate воспроизводим локально и затем в pinned-manifest CI.
6. Независимый внешний security/legal gate не заменяется внутренним или субагентским review.

## Текущий порядок исполнения

0. P00A — активировать source of truth.
1. P00B — pinned multi-repository manifest и fail-closed validation.
2. P01/P01B — metadata red tests и infrastructure log privacy.
3. P02/P02B/P02C — update trust, client verifier и локальная ceremony.
4. Далее — только по dependency graph активного `agent-prompts/README.md`.

Весь старый набор `prompts/01..13` является backlog/evidence. Его нельзя выдавать implementation agent напрямую.

## Phase gate правило

Переход к следующему шагу разрешен только если одновременно:
1. Изменения по текущему промпту реализованы.
2. Тесты/проверки зеленые.
3. Артефакты (логи, отчеты, CI evidence) приложены.
4. `roadmap.md` и релевантные `docs/*` обновлены.
5. Для открытых рисков зафиксированы owner, ETA, mitigation; внутренний human owner — Mr. X.
6. Producer/consumer SHA и package SHA256 зафиксированы в dependency manifest.
7. Architecture/lead/security role-review текущей итерации принято или создало corrective package.

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

## Критерий завершения Horizon A

1. Числовые Survival Beta gates активной программы закрыты на pinned SHA.
2. Android и Windows launch-critical E2E, Docker network, update/rollback и impairment suites воспроизводимы.
3. iOS заявляется только в границах подтверждённого foreground spike/device evidence.
4. Нет незакрытых Critical/High в scoped independent review.
5. Mr. X подписал локальный go/no-go; public rollout и GA требуют отдельного решения.
