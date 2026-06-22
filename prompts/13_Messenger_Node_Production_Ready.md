# 13 - Messenger Node Production Ready (Supplemental, Active-on-Demand)

## Назначение

Дополнительный промпт для случаев, когда в текущем спринте требуется углубленное усиление messenger-only node/network readiness.

## Когда использовать

Использовать вместе с активным контуром (`06 -> 07 -> 08 -> 09`), если нужен отдельный фокус на:
- self-hosted Deep node/network path;
- transport/bootstrap/registry operational hardening;
- operator runbooks и production deployment readiness.

## Scope In

- `xnode`
- `deep-registry-api`
- `deep-devops`
- `deep-tests-e2e`
- по необходимости `xpoint-staking-backend`, `xpoint-staking-contracts`

## Критерий готовности

- messenger-only production path работает без зависимости на upstream Session infrastructure;
- no-mock release path подтвержден артефактами;
- runbooks и recovery evidence готовы к включению в release пакет.
