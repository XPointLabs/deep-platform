# Client Acceptance Checklist (E4 refreshed, 2026-06-02)

Документ актуализирован под новый roadmap и теперь используется как чеклист клиентского launch-critical паритета.

## Обязательные сценарии

| Сценарий | Ожидаемое поведение | Статус |
|---|---|---|
| Onboarding + recovery | Создание/восстановление аккаунта устойчиво к рестарту | partial |
| 1:1 messaging | Отправка/получение, offline retrieval, read state sync | partial |
| Groups lifecycle | create/update/admin/remove/leave/destroy без регрессий | partial |
| Attachments | upload/download/expiry/error handling | partial |
| Avatars/profile image | upload/update/fetch + visibility через Deep file path | partial |
| Push lifecycle | register/refresh/unregister + delivery path | partial |
| Release no-stub/no-mock guards | Запрет fallback-путей для release | partial |

## Platform Coverage

| Платформа | Статус покрытия |
|---|---|
| Windows | partial |
| Android | partial |
| iOS | partial |
| Matrix gate (Android+iOS+Windows) | partial |

## Последний клиентско-бэкенд инкремент

- `2026-05-30`: push compatibility service получил Session-style `/unsubscribe`; contract tests и devops smoke e2e теперь подтверждают `register -> unregister`, но delivery path и platform matrix все еще не закрыты.
- `2026-05-30`: file compatibility service теперь отклоняет пустые/oversized uploads Session-style `413`, а full-stack validation подтверждает `POST /file/{id}/extend`; attachment error-contract и expiry lifecycle продвинулись, но delivery/UX matrix по вложениям все еще не закрыт.
- `2026-06-01`: backend file path получил явный avatar lifecycle (`/avatar/{sessionId}` upload/update/fetch/info) в compat и dedicated runtimes; managed external full gate green и публикует avatar evidence в `full-suite.json`, `backend-load-smoke.json`, `backend-restart-smoke.json`. Client-side remote avatar publication/fetch was still tracked as P3 acceptance gap until the 2026-06-02 client transport increment.
- `2026-06-01`: dedicated push path получил persisted delivery queue (`push-deliveries.json`), provider-facing dispatch hooks via `PUSH_PROVIDER_{APNS|FIREBASE|HUAWEI}_URL` / `PUSH_PROVIDER_BASE_URL`, provider proxy auth pass-through, and executable `push-provider-canary.json` gate via `test-env.ps1 -RequirePushProviderCanary`; backend evidence green в focused push suite, local canary harness, `backend-load-smoke.json`, and `backend-restart-smoke.json`. Real credentialed APNs/FCM/Huawei canary и platform matrix delivery acceptance остаются open.
- `2026-06-02`: release rehearsal baseline получил messenger-node runbook, no-mock router checksum hook (`XNODE_XRAY_SHA256`) и executable security gate artifacts (`secret-scan`, `SBOM`, dependency audit). Это усиливает release no-stub/no-mock guard, но не закрывает E4 без attached platform matrix, device-lab avatar evidence, and client-side push delivery acceptance.
- `2026-06-02`: router release rehearsal получил отдельный `multi-node` compose profile и `multi-node-topology.json` gate для трех no-mock router nodes, registry transport publication и трех distinct `select_path` hops. Это закрывает часть node topology evidence, но E4 всё ещё требует client-side Android/iOS/Windows acceptance.
- `2026-06-02`: MAUI CI получил release-blocking `platform-matrix-gate`: unit TRX artifacts, release transport guard JSON, Android/iOS/MacCatalyst/Windows build evidence, and final `client-platform-matrix.json` now replace the previous unsigned/signed placeholder artifact. Local focused validation passed ViewModel tests `23/23`, route smoke `1/1`, release guard logic, and synthetic matrix gate logic; E4 remains open until attached green CI artifacts and real device/e2e acceptance evidence exist.
- `2026-06-02`: shared client получил `HttpAvatarProfileTransport` для `/avatar/{sessionId}` upload/info/download, `ClientRuntime.AvatarProfiles`, and focused avatar contract tests; MAUI release startup now requires `DEEP_FILE_URL`, and profile photo changes are saved locally then published through the Deep file service when the transport is enabled. Local validation passed shared tests `44/44`, MAUI Windows build, ViewModel tests `23/23`, route smoke `1/1`, and updated release guard logic; E4 still needs attached Android/iOS/Windows device evidence against the real file service.

## Критерии закрытия E4

1. Все обязательные сценарии, включая attachments и avatars/profile image, имеют `done` и test evidence в CI.
2. Нет launch-critical fallback-зависимостей в release профиле.
3. Platform matrix прогон обязателен и стабильно зеленый.
4. Результаты acceptance привязаны к артефактам релизного pipeline.
