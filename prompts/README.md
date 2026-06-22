# Prompt Pack: Deep Parity Program (Sprint Refresh 2026-06-19)

Этот набор синхронизирован с текущим [roadmap.md](..\roadmap.md) и стартует с текущего baseline, а не с исторических фаз.

## Активный порядок выполнения (текущий спринт)

1. `00_Agent_Entry_Point.md`
2. `06_Security_and_Compliance_Gates.md`
3. `07_Observability_and_SRE_Gates.md`
4. `08_Release_Discipline_and_Rollout.md`
5. `09_Stabilization_and_GA.md`

Дополнительно по необходимости:
- `13_Messenger_Node_Production_Ready.md` (углубленный operational track для messenger-only production scope)

## Архивные (выполненные) фазы

Следующие промпты считаются выполненными в baseline и не являются стартовой точкой текущего спринта:
- `01_Rebaseline_and_Scope_Freeze.md`
- `02_Backend_Service_Parity.md`
- `03_Router_Transport_Hardening.md`
- `04_Client_Runtime_Parity.md`
- `05_Desktop_Parity.md`
- `10_Platform_Matrix_E2E.md`
- `11_Protocol_Regression_Zero.md`
- `12_Program_Governance_and_Risk.md`

Если в архивной фазе найден регресс, заводится delta-задача в рамках текущего спринта с обновлением `roadmap.md` и `docs/delivery-plan.md`.

## Обязательные правила

- После каждого шага обновлять `roadmap.md` и релевантные `docs/*` по фактическому состоянию.
- Любой blocker фиксировать с owner, ETA, mitigation.
- Нельзя закрывать шаг без test/CI evidence и ссылок на артефакты.
- Нельзя создавать отдельный клиентный трек вне MAUI-стека.
