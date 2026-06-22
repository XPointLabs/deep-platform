# Roadmap Deep -> Session Parity (новый спринт, обновлено: 2026-06-19)

## 1. Цель нового спринта

Цель спринта: закрыть релиз-блокеры, перевести текущую готовность из pre-release в production-ready и подготовить формальный GA пакет.

Фокус спринта:
- закрыть секреты и canary для staging;
- собрать и провалидировать P6 evidence пакет;
- провести строгий production-readiness прогон на одном release candidate;
- подготовить Go/No-Go решение с подписями engineering, security, ops.

Плановый горизонт спринта: 2 недели.

## 2. Стартовая точка спринта (baseline)

Базовая точка на старт спринта:
- интегральная готовность к production release: 78%;
- техническая готовность runtime и CI gates: 91%;
- организационно-релизная готовность: 58%.

Формула интегральной оценки:
Overall = 0.6 x Technical + 0.4 x ReleaseOps

Текущий расчет:
Overall = 0.6 x 91 + 0.4 x 58 = 77.8, округлено до 78%.

## 3. Доказательства по текущим процентам

### 3.1 Техническая готовность: 91%

| Область | Оценка | Доказательства | Что осталось |
|---|---:|---|---|
| Backend external triad | 95% | dedicated storage/file/push path стабилен; smoke/full external path green; restart rehearsal green | финальный staging прогон на RC с полным набором артефактов |
| Router and transport | 94% | no-mock path, C3 evidence, multi-node topology, transport status публикация | финальная attached CI фиксация для RC |
| Staking flow integration | 90% | quorum signing, reward signer discovery, registry health gating, hardened deployment tests | полный UAT to staging релизный rehearsal на одном RC |
| Client parity | 86% | UI parity increments, UAT chat/settings flows, avatar and account updates | закрыть device-acceptance evidence для Android/iOS/Windows |
| Security and release gates implementation | 90% | release-gate scripts/workflows, observability gate, rollback drill gate, production-readiness gate каркас | доказать green end-to-end на реальных staging секретах |

Итог по техническому контуру: 91%.

### 3.2 Организационно-релизная готовность: 58%

| Область | Оценка | Доказательства | Что осталось |
|---|---:|---|---|
| Secrets and environment readiness | 35% | staging/production environments созданы; preflight lane добавлен | заполнить реальные staging secrets для push provider canary (url/auth/token) |
| Release evidence completeness | 55% | evidence bundling and hydration workflow готовы | собрать полный P6 raw bundle на одном RC |
| Attached CI strictness | 70% | strict lane intake и checks есть, блокер отображается корректно | получить green на devops-release-secret-preflight:selected |
| Governance and sign-off package | 60% | GA gates and templates подготовлены | финальный Go/No-Go пакет с обязательными подписями |

Итог по организационно-релизному контуру: 58%.

## 4. Что осталось до production

Критические блокеры:
- нет рабочих staging секретов для push provider canary;
- из-за этого не закрывается lane devops-release-secret-preflight:selected;
- отсутствует полный P6 raw manifest комплект в рамках одного release candidate:
  - client-device-acceptance.json
  - ops-deployment-evidence.json
  - security-audit-signoff.json
  - ga-decision.json
- не выполнен финальный strict production-readiness прогон на полном attached-CI комплекте.

## 5. План работ на новый спринт

### Sprint item S1: Закрыть staging secrets и preflight

Задачи:
- внести реальные значения provider url/auth/token в staging environment;
- повторить release-secret-preflight до стабильного green результата;
- приложить артефакт preflight в релизный пакет.

Критерий готовности:
- lane devops-release-secret-preflight:selected стабильно green.

### Sprint item S2: Сформировать полный P6 evidence пакет

Задачи:
- сформировать и приложить все 4 P6 raw manifests для одного RC;
- проверить согласованность releaseCandidate между всеми manifest файлами;
- прогнать p6-release-evidence workflow и сохранить артефакты.

Критерий готовности:
- P6 gates зеленые, P6 bundle пригоден к hydration без ошибок.

### Sprint item S3: Прогнать supporting-release-evidence

Задачи:
- запустить supporting-release-evidence с P6 входами;
- убедиться, что canary, rollback, observability и registry recovery включены в bundle;
- проверить связность артефактов и ссылок.

Критерий готовности:
- supporting-release-evidence bundle полный и валидный.

### Sprint item S4: Финальный production-readiness прогон

Задачи:
- выполнить production-readiness workflow на том же RC;
- убедиться, что strict attached-CI checks green;
- сформировать production-readiness summary без blocker статусов.

Критерий готовности:
- production-readiness статус green.

### Sprint item S5: Go/No-Go решение

Задачи:
- собрать финальный one-page status для engineering, security, ops;
- зафиксировать решение и риски остатка;
- оформить выпускной чеклист для запуска.

Критерий готовности:
- подписанное решение Go/No-Go и зафиксированный план запуска.

## 6. Sprint DoD

Спринт считается завершенным при одновременном выполнении:
- staging canary preflight green;
- полный P6 evidence bundle собран и валиден;
- strict production-readiness green;
- подтвержденный attached-CI пакет артефактов на одном RC;
- зафиксированное Go/No-Go решение с owner подписями.

## 7. Целевые проценты на конец спринта

План целевых значений:
- техническая готовность: 95%+;
- организационно-релизная готовность: 85%+;
- интегральная готовность: 91%+.

Условие для 100% release ready:
- формальный GA sign-off (engineering + security + ops) после green production-readiness.

## 8. Источники исполнения (для daily контроля)

Основные репозитории спринта:
- deep-devops
- xnode
- deep-registry-api
- xpoint-staking-backend
- xpoint-staking-contracts
- deep-client-maui
- deep-client-shared

Основные workflow и артефакты:
- release-secret-preflight
- p6-release-evidence
- supporting-release-evidence
- production-readiness
- release-gate-contracts
