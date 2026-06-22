# 06 - Security and Compliance Gates (Active Sprint Track)

## Цель

Закрыть релиз-блокирующие security/compliance требования для текущего RC.

## Что нужно сделать в этом спринте

1. Закрыть staging secrets readiness для push provider canary:
- provider URL
- provider auth source/header
- canary token

2. Добиться стабильного green для:
- `release-secret-preflight`
- lane `devops-release-secret-preflight:selected`

3. Подтвердить обязательные security gates:
- secret scan
- dependency scan
- SBOM/эквивалент
- release-time guard против mock wiring

4. Сформировать/обновить security sign-off evidence для P6 пакета:
- `security-audit-signoff.json`

## Артефакты

- green preflight artifacts
- security gate artifacts из CI
- обновленный `security-audit-signoff.json`
- ссылки на workflow run IDs в `docs/delivery-plan.md`

## Критерий готовности

- preflight lane стабильно green;
- нет незакрытых critical/high в launch scope без remediation plan;
- security sign-off artifact присутствует и валиден для текущего RC.
