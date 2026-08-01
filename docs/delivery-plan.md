# Deep Delivery Plan (обновлено: 2026-06-03)

> **Статус с 2026-07-17:** документ сохраняется как подробное evidence выполненной parity-работы и известных release gates. Активный delivery plan — [`Deep Survival Program v2.0.0`](survival-program/README.md), accountable owner Mr. X. Указанные ниже сроки, проценты и GA-порядок не переопределяют Survival Beta horizons, dependencies или stop gates.
>
> Broad legacy prompts — backlog only. Реализация идёт атомарными work packages активной программы, в изолированных worktree, с локальными коммитами и без push/deploy/external publish.

## Историческая цель

Довести Deep до GA-уровня паритета с Session по launch-critical функциональности и эксплуатации.

Плановая длительность: 9-10 месяцев (базовый сценарий).

## Политика совместимости до production-запуска (Mr. X)

- Клиент, XNode, локальные БД, конфигурация и DevOps развиваются как clean break:
  только текущие форматы и схема, без dual-read, legacy fallback и автоматических
  миграций, пока Mr. X явно не потребует обратного.
- Старое dev-состояние считается сбрасываемым. Несовместимый локальный формат
  должен завершаться понятной ошибкой `wipe/reset required`, а не незаметным
  ослаблением текущих security/privacy-инвариантов.
- Устойчивость текущего формата (crash recovery, replay, quarantine повреждённых
  текущих записей, durable ACK/outbox) не считается legacy-совместимостью и
  должна сохраняться.
- Исключение — уже развернутые smart contracts и XPNT: изменения обязаны
  сохранять on-chain state и адрес/эмиссию токена; перевыпуск токена запрещён
  без отдельного решения Mr. X.

## Текущий baseline исполнения

- P0 re-baseline зафиксирован документально: в `docs/parity-matrix.md` добавлены capability owner'ы, target gate/ETA и текущее test evidence.
- Governance baseline введен: role-based DRI ownership, blocker SLA, risk register и weekly parity report template.
- P1 backend migration control plane для storage/file/push добавлен: `test-env.ps1` теперь умеет валидировать external storage/file/push endpoints без переписывания e2e fixtures или router/registry/staking/contracts devnet stack.
- P1 first dedicated backend slice добавлен: отдельный storage-service profile/image теперь валидируется тем же full e2e через `-BackendMode external`, а harness в этом режиме стартует только router/registry/staking/contracts stack.
- P1 dedicated backend triad теперь валидирован: storage/file/push могут одновременно идти через отдельные service wrappers в `backend-external` profile, а full e2e остается green на этом cutover path.
- P1 runtime extraction по dedicated backend triad завершен: `storage-service`, `file-service` и `push-service` уже обслуживаются standalone runtimes без импорта общего `compat-service.mjs`, при сохранении green external full evidence на backend triad.
- P1 dedicated backend load evidence добавлен: `deep-tests-e2e` теперь содержит `e2e:load`, а `test-env.ps1 -Suite full -BackendMode external` требует `backend-load-smoke.json` с ненулевыми storage/file/push stats delta.
- P1 backend-external gate теперь воспроизводим в CI и локально без ad hoc shell orchestration: `test-env.ps1` умеет сам управлять локальным `backend-external` profile, `integration.yml` прогоняет external smoke, а `nightly-full-e2e.yml` прогоняет external full path с load artifact.
- P1 compose restart rehearsal добавлен для managed external full path: `test-env.ps1 -Suite full -BackendMode external -ManagedExternalProfile backend-external` теперь требует `backend-restart-smoke.json` и подтверждает persistence/reload behavior через реальный `docker compose restart` dedicated triad.
- P1/P3 client push acceptance теперь тоже заведен в parity path: shared client derives standard `05` identities from X25519, signs Session-style push subscribe/unsubscribe payloads, persists notification `enc_key`, and MAUI registration can mirror supported providers to backend push through optional `DEEP_PUSH_URL`.
- P1 dedicated push hardening теперь дополнительно фиксирует Session-style `idempotency_key` resubscribe semantics и TTL expiry pruning в standalone `push-service-runtime.test.mjs`, включая persisted `push.json` cleanup после prune.
- P1 dedicated push hardening теперь дополнительно фиксирует notify-path prune для expired subscriptions и mixed batch subscribe/unsubscribe semantics: internal `/_compat/push-notify` не создаёт delivery для просроченной подписки, удаляет её из persisted `push.json`, оставляет `queued: 0`, а batch `/subscribe` и `/unsubscribe` возвращают per-item success/error results без порчи runtime stats.
- P1 dedicated push hardening теперь дополнительно фиксирует invalid subscribe-shape rejection и notify queue edge cases: unsupported `service` и malformed `enc_key` стабильно отдаются как `400` без state mutation, repeated `/_compat/push-notify` hashes dedupe'ятся, а oversized delivery payloads сохраняются как `bodyTooLarge` без raw `data` bytes.
- P1 dedicated push provider/delivery hardening теперь фиксирует provider-facing dispatch: `push-service` сохраняет delivery queue в `push-deliveries.json`, отправляет configured provider payload через `PUSH_PROVIDER_{APNS|FIREBASE|HUAWEI}_URL` или `PUSH_PROVIDER_BASE_URL`, пишет per-delivery provider status, exposes provider inventory in `/stats`, and reloads persisted delivery/provider state across compose restart.
- P1 push provider canary hook теперь executable: provider proxy auth headers/bearer tokens пробрасываются через `PUSH_PROVIDER_{APNS|FIREBASE|HUAWEI}_AUTH_HEADER`, `PUSH_PROVIDER_AUTH_HEADER` or bearer-token variants, and `test-env.ps1 -RequirePushProviderCanary` runs `scripts/push-provider-canary.mjs`, requiring `push-provider-canary.json` with configured provider delivery before release rehearsal passes.
- P2 router no-mock guard теперь представлен как explicit release hook in devops: `test-env.ps1 -RequireRouterNoMock` (or `DEEP_REQUIRE_ROUTER_NO_MOCK=true`) fails if runtime snapshot reports `router-health-ready.transportMode=mocked`; default local dev stack still warns and records this in `runtime.gate.json`.
- P2 router real-Xray release rehearsal теперь воспроизводим локально: `-RequireRouterNoMock` switches compose to `docker/xnode-xray.Dockerfile`, installs pinned official Xray `v26.3.27`, runs the router in `Production` with `Vless__MockProcess=false`, `/usr/local/bin/xray`, and `Vless__TransportMode=Tcp`; latest managed external smoke and full no-mock evidence shows `routerTransportMode=running`, `routerTransportMocked=false`, no gate warnings, runtime snapshot failed checks `0`, and green `backend-load-smoke.json`/`backend-restart-smoke.json`.
- P2 router no-mock CI promotion теперь настроен: `integration.yml` runs backend-external smoke with `-RequireRouterNoMock` and always uploads `integration-artifacts`, while `nightly-full-e2e.yml` runs backend-external full with `-RequireRouterNoMock`; local full no-mock evidence is present, while remaining P2 evidence is first attached green CI artifacts for the no-mock and C3 paths.
- P2 router C3 operational evidence теперь свежий и executable: targeted `C3FailureAndLoadIntegrationTests` passed locally and writes `xnode/artifacts/test-results/c3/latest.json` + `latest.md`; latest SLO baseline passed with soak `100%`, chaos `57.5%` under `35%` packet loss, load `~36.2k req/s`, path-select p95 `~0.62 ms`, and restart storm entering degraded mode.
- P2/P5 production-gate baseline добавлен: real-Xray release image now supports `XNODE_XRAY_SHA256` archive verification, `deep-devops/scripts/security-gate.mjs` emits secret-scan/SBOM/dependency-audit artifacts, devops CI publishes a `security-gate` job artifact, and `deep-devops/docs/MESSENGER_NODE_PRODUCTION_RUNBOOK.md` defines the messenger-only rehearsal, rollback, and required artifacts.
- P2/P5 multi-node topology gate добавлен и локально green: `deep-devops` now has a `multi-node` compose profile with `xnode-1..3`, `scripts/multi-node-rehearsal.ps1` defaults to the no-mock Xray-backed router image, `scripts/multi-node-rehearsal.mjs` publishes all three VLESS transport profiles into the registry, seeds relay contacts through router RPC, requires a three-distinct-hop `select_path` proof, and emits `artifacts/test-results/multi-node-topology.json`; latest local run produced three `transportMocked=false` routers, registry `totalNodes=3`, no reconciliation issues, and `distinctHops=3`; `integration.yml` now runs this rehearsal before uploading integration artifacts.
- P5 observability/SLO gate добавлен: `deep-devops/scripts/observability-gate.mjs` validates runtime snapshot health, zero-error counters, load p95 budgets, push-provider failures, router C3 SLO budgets, rollback MTTR, dashboard panels, and alert-route coverage from `observability/deep-messenger-slos.json`, `observability/deep-messenger-dashboard.json`, and `observability/deep-alert-routes.json`; latest local run passed `66` checks and wrote `artifacts/observability/observability-gate-summary.json`.
- P5 release evidence gate добавлен: `deep-devops/scripts/release-evidence-gate.mjs` validates the release artifact set across `runtime.gate.json`, backend load/restart, push provider canary, multi-node topology, security summary, observability summary, router C3 SLO artifact, and rollback drill evidence, then writes `artifacts/release/release-evidence-summary.json`; latest local run with `--require-rollback-drill` passed `68` checks after `rollback-drill.json` reported status `ok`, MTTR `79.098` seconds, and green post-rollback storage/file/avatar/push smoke. Strict release sign-off still requires `--require-attached-ci`.
- P5 attached CI evidence format теперь строгий: `release-evidence-gate.mjs --require-attached-ci` validates `attached-ci-artifacts.json` against a named `releaseCandidate`, full 40-character run SHAs, run attempts, non-placeholder artifact links, and required green lanes for devops integration, devops nightly full e2e, devops security gate, devops release-gate contract validation, xnode C3, and MAUI platform matrix; schema documented in `deep-devops/docs/ATTACHED_CI_EVIDENCE.md`.
- P5 attached CI manifest intake добавлен: `deep-devops/scripts/attached-ci-manifest.mjs` normalizes collected CI lane data into canonical `attached-ci-artifacts.json`, validates required release lanes before writing, and emits `attached-ci-manifest-summary.json` for release evidence review.
- P5 attached CI GitHub intake добавлен: `deep-devops/scripts/collect-attached-ci-source.mjs` collects the required Actions runs/artifact handles from private `XPointLabs` repos into `attached-ci-source.json`, writes `attached-ci-source-summary.json`, and feeds the existing manifest validator; current prerequisite collection for `deep-messenger-rc.1` finds six green upstream lanes, while `devops-production-readiness` is available only as post-run audit evidence via `--include-production-readiness`.
- P5/P6 production-readiness CI bootstrap исправлен: attached-CI prerequisite manifest теперь требует только upstream release lanes, while `devops-production-readiness` is retained as post-readiness audit evidence after a green final workflow run; `production-readiness.yml` now collects prerequisite run IDs, downloads retained integration/nightly/security/router-C3 artifacts through Actions, and runs `hydrate-release-artifact-bundle.mjs` before strict preflight.
- P5/P6 release evidence intake теперь закрывает manual-copy gap: `hydrate-release-artifact-bundle.mjs` also materializes raw `client-device-acceptance.json`, `ops-deployment-evidence.json`, `security-audit-signoff.json`, and `ga-decision.json` into `artifacts/release` when a retained evidence bundle includes them, and `production-readiness.yml` accepts optional `supporting_evidence_run_id` + `supporting_evidence_artifact_name` inputs to download that bundle before strict preflight. Focused hydration smoke proved those four manifests plus `push-provider-canary.json` hydrate into a clean artifact root; remaining gap is still the real staged evidence, not the CI intake path.
- P5/P6 supporting evidence bundling теперь reproducible: `deep-devops/scripts/bundle-supporting-release-evidence.mjs` packages staging `push-provider-canary.json`, `rollback-drill.json`, `observability-gate-summary.json`, and the four raw P6 manifests into a retained bundle layout for later hydration, and the release checklist now points to that bundler before strict preflight. Focused bundle -> hydrate smoke passed against release-gate fixtures with `7` copied artifacts; remaining gap is still obtaining real staged evidence for the named RC.
- P5/P6 supporting evidence generation теперь has a GitHub runner path: manual `deep-devops/.github/workflows/supporting-release-evidence.yml` runs backend-external no-mock full evidence with the staging push-provider canary enabled, runs the rollback drill, downloads retained xnode C3 artifacts, runs `observability-gate.mjs`, and uploads `supporting-release-evidence-<rc>` for later hydration into `production-readiness.yml`.
- P5/P6 release artifact bundle preflight добавлен: `deep-devops/scripts/release-artifact-bundle.mjs` validates raw runtime/load/restart/provider/multi-node/security/observability/router C3, attached-CI, and P6 manifest files before strict gates consume them.
- P5/P6 production-readiness CI lane добавлен: manual `production-readiness.yml` runs strict `production-readiness-status.mjs --run-gates --strict-release --release-candidate <rc>`, uploads `production-readiness-artifacts`, and is now a required attached-CI lane for release sign-off.
- P1/P5 provider canary release strictness усилена: `push-provider-canary.mjs` records release lane, env-token source, provider auth configuration, and non-secret provider host evidence; `release-evidence-gate.mjs --require-staging-provider-canary` now rejects local/generated canary artifacts for production sign-off.
- P6/GA production readiness gate добавлен: `deep-devops/scripts/production-readiness-gate.mjs` validates strict release evidence plus `client-device-acceptance.json`, `ops-deployment-evidence.json`, `security-audit-signoff.json`, and `ga-decision.json`; `scripts/client-device-acceptance-gate.mjs`, `scripts/ops-deployment-evidence-gate.mjs`, `scripts/security-audit-signoff-gate.mjs`, and `scripts/ga-decision-gate.mjs` now separately validate Android/iOS/Windows device-lab acceptance, deployed ops evidence, security audit sign-off, and GA decision evidence, and the final gate requires their green summary files plus a consistent `releaseCandidate` across all P6 manifests and verifier summaries; placeholder evidence URLs are rejected outside isolated contract fixtures; `scripts/production-readiness-status.mjs` writes a consolidated blocker report; current local run writes `artifacts/release/production-readiness-summary.json` with status `failed` on missing external/GA artifacts and strict attached CI/staging evidence.
- P6 production readiness status hardening добавлен: `deep-devops/scripts/production-readiness-status.mjs --run-gates` now records failed verifier commands as release blockers, preventing stale green summary artifacts from satisfying GA when the current gate run failed.
- P6 exit checklist artifact добавлен: `production-readiness-status.mjs` now writes `artifacts/release/production-readiness-checklist.json` with release-exit items, owner roles, required artifacts, commands, and linked blockers for RC review.
- P6 retained evidence hardening добавлен: attached-CI and P6 manifests now reject missing local `path` evidence outside fixture mode, while URL/ID evidence remains allowed for retained external artifacts; release-gate contracts include a negative local-path fixture.
- P6 freshness hardening добавлен: release/P6 manifests and verifier summaries now fail stale or future-dated `generatedAt` evidence outside the default 30-day review window, with deterministic contract fixtures covering stale evidence rejection.
- P3/P4 platform matrix gate baseline добавлен: `deep-client-maui/.github/workflows/ci.yml` now uploads unit TRX evidence, release transport guard JSON, Android/iOS/MacCatalyst/Windows build evidence, and a final release-blocking `platform-matrix-gate` artifact that depends on all required client legs; latest local focused validation passed MAUI ViewModel tests `23/23`, route smoke `1/1`, release transport guard logic, and synthetic platform matrix gate logic.
- P3 avatar client publication baseline добавлен: `deep-client-shared` now has `HttpAvatarProfileTransport` for `/avatar/{sessionId}` upload/info/download plus `ClientRuntime.AvatarProfiles`, and `deep-client-maui` requires `DEEP_FILE_URL` in non-Debug builds and publishes selected profile photos to the Deep file service when enabled; latest local validation passed shared tests `44/44`, MAUI Windows build, ViewModel tests `23/23`, route smoke `1/1`, and updated release guard logic.
- P5 dependency baseline hardened `xpoint-staking-contracts` high/critical audit findings with pnpm overrides; local full Hardhat tests remain blocked on this Windows ARM64 host because upstream `@nomicfoundation/edr` does not publish the `win32-arm64-msvc` binary for the active Hardhat runtime. Staking contract full-test evidence must come from Linux CI or a Windows x64 developer runtime until that upstream package gap closes.
- P1 dedicated storage hardening теперь дополнительно фиксирует TTL expiry pruning в standalone `storage-service-runtime.test.mjs`: expired offline message больше не возвращается через `/storage/retrieve` и `/storage/get_expiries`, а persisted `storage.json` очищается после prune.
- P1 dedicated storage hardening теперь дополнительно фиксирует failure-path resilience для storage->push notify hop: при недоступном downstream `/_compat/push-notify` signed `/storage/store` остается `200 OK`, сообщение сохраняется локально и продолжает читаться через `/storage/retrieve`.
- P1 dedicated file hardening теперь дополнительно фиксирует TTL expiry pruning в standalone `file-service-runtime.test.mjs`: expired file получает `404` на `/file/{id}` и `/file/{id}/info`, runtime inventory обнуляется, а persisted `file.json` очищается после prune.
- P1 dedicated file hardening теперь дополнительно фиксирует legacy TTL prune и invalid TTL rejection: просроченный legacy файл исчезает из `/files/{id}` и `/file/{id}/extend`, а invalid `X-FS-TTL` не создаёт новых records и не мутирует persisted `file.json`.
- P1 dedicated file hardening теперь дополнительно фиксирует upload-boundary, malformed legacy payload, и metadata-failure semantics: empty/oversized uploads и bad legacy `/files` payloads стабильно отдаются как `400/413` без state mutation, а supported `/session_version` и `/token_info` paths возвращают `502`, когда env-backed metadata недоступна или битая.
- P1 dedicated file hardening теперь дополнительно фиксирует concurrent duplicate upload/extend monotonicity: parallel same-content `/file` uploads схлопываются в один persisted record, а concurrent `/file/{id}/extend` calls сохраняют single-file state и не уменьшают `expires`.
- P1 backend-external load hardening теперь дополнительно фиксирует signed storage retry/idempotence и redundant push unsubscribe idempotence на production cutover path: `deep.load.test.mjs` повторяет `/storage/store` с `idempotency_key` и второй раз вызывает signed `/unsubscribe`, а managed external full run сохраняет этот proof в `backend-load-smoke.json` alongside file retry и push resubscribe evidence.
- P1 backend-external load hardening теперь дополнительно фиксирует file concurrency behavior на production cutover path: `deep.load.test.mjs` шлёт parallel same-content `/file` uploads и concurrent same-id `/file/{id}/extend`, а managed external full run сохраняет monotonic `duplicateUploadExpires`/`duplicateExtendExpires` evidence в `backend-load-smoke.json`.
- P1 file/avatar lifecycle теперь выделен из generic file parity: dedicated и compat file runtimes обслуживают `/avatar/{sessionId}` upload/update/fetch/info, хранят pointer metadata в `avatar.json`, публикуют avatar stats/inventory, отклоняют unsupported/empty avatar payloads без state mutation, и подтверждают restart persistence.
- P1 backend-external evidence теперь включает avatar flow: full e2e пишет avatar upload/update/fetch в `full-suite.json`, load-smoke пишет `avatarUpload/avatarDownload/avatarInfo` deltas и `avatarFileIds` в `backend-load-smoke.json`, restart rehearsal пишет avatar persistence proof в `backend-restart-smoke.json`.
- P1 file durability теперь усилен serialized file/avatar state writes: focused test поймал stale persisted expiry при concurrent `/file/{id}/extend`, после фикса dedicated runtime suite green at `12` tests, compat suite green at `79` tests, managed external full gate green.
- Следующий исполняемый delivery-срез: run `supporting-release-evidence.yml` to publish a real staging `push-provider-canary.json` plus rollback/observability evidence, add the four P6 manifests for the same RC into that retained bundle, hydrate it through `production-readiness.yml`, run the four P6 evidence gates for the RC, then collect `devops-production-readiness` with `--include-production-readiness` for the final post-run audit package.

## Фазы и сроки

| Фаза | Длительность | Основной результат |
|---|---|---|
| P0 Re-baseline and scope freeze | 2 недели | Подтвержденный scope, owners, риски, critical path |
| P1 Backend service parity | 8-10 недель | Storage/file/push production parity path |
| P2 Router hardening | 6-8 недель | No-mock transport + chaos/soak evidence |
| P3 Client runtime parity | 10-12 недель | Закрытые launch-critical MAUI flows для Android/iOS/Desktop |
| P4 MAUI desktop feature parity | 8-10 недель | Desktop-специфичные launch-critical сценарии в MAUI завершены |
| P5 Security + Observability + Release gates | 8-10 недель (параллельно) | Аудит, SBOM, SLO/alerts, rollout/rollback discipline |
| P6 Stabilization and GA decision | 4-6 недель | 30/60/90 stabilization и GA sign-off |

## Критический путь

1. P0 -> 2. P1 -> 3. P2 -> 4. P3 -> 5. P5 -> 6. P6

## Launch-Critical Ownership

| Capability | Owner (DRI role) | Target gate | Exit evidence expectation |
|---|---|---|---|
| Protocol zero-regression | Protocol / Crypto lead | Continuous before every phase gate | Golden-vector, differential, fuzz-smoke gates green with artifacts |
| Backend service parity: storage/file/push | Backend Services lead | P1 exit | Production path contract + load evidence without compatibility-only fallback |
| Router no-mock production path | Router / Transport lead | P2 exit | Release-path validation без mock Xray + chaos/soak/load artifacts |
| MAUI client runtime parity | Client Runtime lead | P3 exit | Acceptance evidence for onboarding, messaging, groups, attachments, push across MAUI targets |
| Desktop parity inside MAUI | Desktop Parity lead | P4 exit | Desktop-specific acceptance and regression evidence in MAUI runtime |
| Platform matrix e2e | QA / E2E lead | P4 + prompt 10 exit | Mandatory Android+iOS+Windows pipeline with attached artifacts |
| Security/compliance gates | Security lead | P5 exit | `security-gate.mjs` SBOM/secret/dependency artifacts now exist; remaining exit requires policy hardening and external audit closure |
| Observability/SRE maturity | SRE / Ops lead | P5 exit | SLO dashboards, alerts, runbooks, rollback drill evidence |
| Release discipline / rollout readiness | Release / Ops lead | P5 exit | Canary criteria, rollback rehearsal, post-release verification |

## Основные риски

| Риск | Вероятность | Влияние | Owner | Митигирующее действие | Trigger / ETA |
|---|---|---|---|---|---|
| Задержка production parity для storage/file/push | medium | high | Backend Services lead | Разделить storage/file/push на отдельные delivery tracks внутри P1, ввести contract/load evidence как обязательный exit gate | Проверка на P1 midpoint |
| Router real-Xray validation еще без attached CI artifacts | medium | high | Router / Transport lead | CI wiring now runs backend-external smoke/full with `-RequireRouterNoMock` plus the multi-node no-mock topology rehearsal, integration artifacts upload on every run, local managed external smoke/full no-mock are green, local C3 chaos/soak/load artifacts are green, and the release gate now validates a strict attached CI manifest; attach first green workflow artifacts before P2 exit | Проверка до конца P2 |
| Platform matrix не получает attached green evidence или остается флейковым | medium | high | QA / E2E lead | Release-blocking `platform-matrix-gate` now exists in MAUI CI and uploads matrix evidence; `client-device-acceptance-gate.mjs` now defines the GA-blocking Android/iOS/Windows device evidence contract; next mitigation is device/runtime budget, green workflow artifacts, device-lab expansion, and weekly stability review | Первое обязательное требование к P3 midpoint |
| Desktop parity drift внутри общего MAUI runtime | medium | high | Desktop Parity lead | Вести desktop gap backlog отдельно, но проверять только в общем MAUI runtime acceptance наборе | Еженедельный parity review |
| Security задачи сдвигаются вправо и перестают быть release-blocking | medium | high | Security lead | Minimum executable gate now emits SBOM, secret scan, dependency audit, and CI artifacts; next hardening is policy-as-code thresholds, triage SLAs, and external audit closure | Проверка на P5 kickoff |
| Observability и rollback остаются ручными практиками | medium | high | SRE / Ops lead | Observability/SLO gate now validates runtime health, zero-error counters, p95 budgets, router C3 budgets, rollback MTTR, dashboard panels, and alert-route coverage before release evidence; production-readiness gate now blocks GA until deployed dashboards, tested alert routes, attached CI evidence, and staging post-deploy verification artifacts are attached | Проверка на P5 midpoint |
| Role-based owner'ы не привязываются к конкретным DRI | medium | medium | Program / Delivery lead | На первом weekly governance review заменить role-based owner на named DRI без изменения capability scope | Следующий governance review |

## KPI

1. CI success rate launch-critical suites >= 95%
2. Defect escape rate <= 10% к концу программы
3. MTTR по rollback drill <= 60 минут
4. Нет open critical/high security findings в GA scope

## Governance

- Еженедельно: parity burn-down + risk review по capability owner'ам, со статус-дельтой и проверкой свежести evidence.
- Раз в 2 недели: critical path review по P1/P2/P3/P5 с фиксацией решений в этом документе.
- Ежемесячно: KPI и корректировка сроков на основе фактической пропускной способности и стабильности CI.
- Любой phase-gate сдвиг, blocker или изменение scope фиксируется в течение 1 рабочего дня.

## Blocker SLA

| Событие | SLA на owner | SLA на mitigation plan | SLA на обновление evidence / решение |
|---|---|---|---|
| Stop-the-line: mock/compat-only в release path, protocol gate red, critical/high security finding без remediation plan | 4 рабочих часа | 1 рабочий день | 3 рабочих дня или formal rollback/deferral decision |
| Matrix/e2e regression в launch-critical сценарии | 1 рабочий день | 2 рабочих дня | 5 рабочих дней |
| Срыв critical-path ETA более чем на 1 неделю | 1 рабочий день | 2 рабочих дня | Решение на ближайшем critical path review |
| Отсутствие обязательного test evidence на phase gate | Немедленно | Немедленно | Переход заблокирован до публикации evidence |

## Weekly Parity Report Template

```md
# Weekly parity report

Week of:
Facilitator:

## 1. Capability burn-down
| Capability | Owner | Status last week | Status now | Evidence added | Next gate | ETA |
|---|---|---|---|---|---|---|

## 2. Blockers
| Blocker | Open since | Owner | SLA due | ETA | Mitigation |
|---|---|---|---|---|---|

## 3. Risks
| Risk | Trend | Owner | Action this week | Escalation needed |
|---|---|---|---|---|

## 4. Decisions needed
| Decision | Needed by | Owner | Impact if delayed |
|---|---|---|---|

## 5. Next week focus
1.
2.
3.
```
## Latest Evidence Addendum

- 2026-06-02: `deep-devops/scripts/session-infra-guard.mjs` now scans production-facing Deep source/config surfaces for forbidden upstream Session/Oxen/Lokinet hosted endpoints, writes `artifacts/release/session-infra-guard-summary.json`, and is consumed by the release artifact bundle plus release evidence gate. Latest local run scanned `181` files with `0` findings.
- 2026-06-04: GitHub supporting run `26871091284` produced rollback and observability evidence for `deep-messenger-rc.1`, but its push-provider canary used a generated token with no provider auth and did not include the four P6 manifests. Production-readiness run `26871267233` is correctly blocked on strict staging provider canary plus `client-device-acceptance.json`, `ops-deployment-evidence.json`, `security-audit-signoff.json`, and `ga-decision.json`. `deep-devops` commit `30b0a9e` now makes staging `supporting-release-evidence.yml` fail early unless real provider URL/auth/token secrets are configured.
- 2026-06-04: `deep-devops` commit `d3aeae9` adds P6 retained-artifact intake to `supporting-release-evidence.yml`: a manual run can now download a same-RC P6 evidence artifact, hydrate the four raw manifests into `artifacts/release`, and require the complete seven-artifact supporting bundle when P6 inputs are supplied. The default path remains fail-fast on missing real staging push-provider config, as confirmed by manual run `26948294624`.
- 2026-06-04: `deep-devops` commit `3adecab` adds the manual `p6-release-evidence.yml` workflow, so raw client/ops/security/GA P6 manifests can now be downloaded from a retained source artifact, hydrated with scoped `--only` selection, checked for release-candidate match, validated through the four P6 gates, and republished as `p6-release-evidence-<rc>` for `supporting-release-evidence.yml`. Push CI for this commit passed: `unit` run `26948777807` and `integration` run `26948777794`.
- 2026-06-04: `deep-devops` commit `bdbb9d9` hardens `production-readiness.yml` supporting evidence intake: `supporting_evidence_run_id` and `supporting_evidence_artifact_name` must now be provided together, and a supplied supporting bundle must hydrate at least one recognized release artifact before strict status runs. Local release-gate contracts and workflow PowerShell smoke checks passed; GitHub push CI passed (`unit` run `26971834821`, `integration` run `26971834740`). GitHub API secret-name audit for `deep-devops` still shows only `DEEP_CI_REPO_TOKEN` in visible repo scope, while real staging push provider secrets remain absent/not visible and org secret listing returned 403 for the provided PAT.
- 2026-06-04: `deep-devops` commit `211f0f4` adds `scripts/release-secret-preflight.mjs` plus manual `release-secret-preflight.yml`, producing retained non-secret `release-secret-preflight-<rc>` artifacts that prove which staging provider secret/config sources are present before the long supporting evidence job runs. `supporting-release-evidence.yml` now reuses this preflight and uploads its summary even on failure. Local positive/negative preflight smoke checks passed, release-gate contracts now cover `28` commands, and GitHub push CI passed (`unit` run `26972450097`, `integration` run `26972450144`).
- 2026-06-04: Live GitHub `release-secret-preflight.yml` run `26972734567` for `deep-messenger-rc.1` / `staging` / `firebase` failed as expected and uploaded retained artifact `release-secret-preflight-deep-messenger-rc.1` (`7420288188`). The summary proves `DEEP_CI_REPO_TOKEN` is configured, while `push-provider:url-configured`, `push-provider:auth-configured`, and `push-provider:canary-token-configured` are still failing. This is now the authoritative preflight blocker before any real `supporting-release-evidence.yml` staging run can produce push-provider canary evidence; GitHub blocker issue: https://github.com/XPointLabs/deep-devops/issues/1.
- 2026-06-04: `deep-devops` commit `3b85e4f` promotes `release-secret-preflight.yml` into the required attached-CI prerequisite set. `release-ci-lanes.mjs`, `attached-ci-manifest.mjs` fixtures, and `docs/ATTACHED_CI_EVIDENCE.md` now require a green `devops-release-secret-preflight` lane with retained `release-secret-preflight-artifacts` before strict release evidence can pass. Local attached-CI template validation now generates `7` runs, release-gate contracts passed with release-evidence coverage expanded to `147` checks, and GitHub push CI passed (`unit` run `26973228709`, `integration` run `26973228699`).
- 2026-06-05: Updated live preflight evidence on `3b85e4f`: `release-secret-preflight.yml` run `26973531286` failed and uploaded fixed attached-CI artifact `release-secret-preflight-artifacts` (`7420616883`), still proving missing Firebase staging provider URL/auth/canary token sources. A real `collect-attached-ci-source.mjs --require-success` run now fails on `lane:devops-release-secret-preflight:selected`, proving strict release prerequisite collection is blocked until issue `deep-devops#1` is resolved; GitHub issue comment: https://github.com/XPointLabs/deep-devops/issues/1#issuecomment-4625303499.
- 2026-06-05: Live `production-readiness.yml` run `26973832576` on `3b85e4f` failed in step `Collect attached CI prerequisite runs` and uploaded `production-readiness-artifacts` (`7420745605`). The retained `attached-ci-source-summary.json` collected six green prerequisite lanes (`devops-integration`, `devops-nightly-full-e2e`, `devops-security-gate`, `devops-release-gate-contracts`, `xnode-c3`, `client-maui-platform-matrix`) and blocked only on `lane:devops-release-secret-preflight:selected`. This confirms the final readiness workflow is now correctly stopped by the missing green Firebase staging secret preflight before later P6/supporting evidence stages can run; GitHub issue comment: https://github.com/XPointLabs/deep-devops/issues/1#issuecomment-4625351950.
- 2026-06-05: `deep-devops` commit `5cc5fd8` adds a registry recovery release gate: `scripts/registry-recovery-drill.mjs` runs the focused registry snapshot persistence, corrupt snapshot quarantine, runtime counter, and reconciliation job tests, emits `artifacts/test-results/registry-recovery.json`, and the artifact is now required by bundle hydration plus strict release evidence. Commit `ff7e637` binds `release-secret-preflight.yml`, `supporting-release-evidence.yml`, and `production-readiness.yml` to GitHub Environments selected by release lane. GitHub Environments `staging` and `production` were created, formal approval issue `deep-devops#2` was opened for security/GA approval evidence, and push CI passed on both commits (`5cc5fd8`: unit `27009133351`, integration `27009133342`; `ff7e637`: unit `27009170641`, integration `27009170629`). Fresh staging preflight run `27009314428` on `ff7e637` uploaded `release-secret-preflight-artifacts` (`7434264139`) and still fails only because provider URL/auth/canary token secret values are absent from the staging environment; blocker comment: https://github.com/XPointLabs/deep-devops/issues/1#issuecomment-4630518667.
