# 08 - Release Discipline and Rollout (Active Sprint Track)

## Цель

Закрыть release discipline контур так, чтобы финальный strict production-readiness прогон был воспроизводимым и зеленым.

## Что нужно сделать в этом спринте

1. Сформировать полный P6 evidence комплект на одном release candidate:
- `client-device-acceptance.json`
- `ops-deployment-evidence.json`
- `security-audit-signoff.json`
- `ga-decision.json`

2. Прогнать связку:
- `p6-release-evidence`
- `supporting-release-evidence`
- hydration в release artifacts

3. Убедиться, что attached-CI intake и strict checks проходят без ручных обходов.

## Артефакты

- P6 raw manifests
- supporting evidence bundle
- release evidence summary
- run IDs/links в `docs/delivery-plan.md`

## Критерий готовности

- все release evidence артефакты сформированы для одного RC;
- strict intake проверки green;
- данные готовы к финальному `production-readiness` шагу.
