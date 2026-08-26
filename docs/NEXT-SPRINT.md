# Ближайший спринт: release-candidate closure

Статус на 2026-08-26: локальная реализация и доступные без production/Mr. X ceremony проверки завершены на superproject commit `99224e184b05c7f27725ba9df30616351ba7f420`. По решению владельца замечания финального независимого review перенесены в следующий спринт, который начнётся после первого production deployment. Push, публикация и production deployment выполняются отдельным Go/No-Go решением.

## Цель

Получить один воспроизводимый release candidate Deep для Android и Windows с production-grade транспортом, закрытым DNP1 package/runtime контуром, актуальными user/admin docs и полным локальным evidence bundle.

## Уже подтверждено

- Реальный Android ↔ Windows текст проходит через authenticated MAU2 по CA-trusted HTTPS; Android показывает точный статус `✓ / Отправлено`.
- Реализован clean-break Deep-native privacy route: exact binary MAU2 проходит через три послойно зашифрованных XNode, primary/fallback полностью не пересекаются, а direct MAU2, Session RPC и прежний JSON-onion удалены. Это пока compile/automated-gate evidence; прежний physical run не подтверждает новый путь.
- Survival authority публикует независимые X25519 keys и `privacy-routes.v1.json`; его SHA-256 связан одновременно с activation и подписанной Mr. X policy. Fallback разрешён только при доказанном отказе до пересылки.
- Ошибка прежнего status test была в OEM-декодировке UTF-8 UI dump и исправлена в `deep-client-maui` commit `060a983`.
- Public services используют системное TLS-доверие без статического leaf-SPKI pinning; UAT CA добавляется только в physical-E2E Android build.
- UAT local-state reset разрешён. Production package/data остаются вне области сброса.
- Direct P2P Phase A — только отключённый radio scaffold; production transport/identity/AKE не активированы.

## Release blockers (в порядке исполнения)

### RC-1. Закрыть physical payload matrix

- Сначала заново опубликовать подписанный privacy-route runtime и доказать Android ↔ Windows текст через `/api/ingress/v1/frame`, exact 3-hop primary и непересекающийся fallback; прямой MAU2 endpoint не должен существовать.
- Исправить Android file-picker/import: после выбора generic fixture сейчас не появляется `Chat.StagedAttachmentFilename`.
- Доказать в обе стороны: generic file, PDF/document, inline image, voice message, exact metadata/hash, open/save/play completion.
- Повторить cold restart и доказать сохранность/дедупликацию.
- Прогнать HTTPS chaos: manual resend, automatic retry и durable ACK crash window с обязательным baseline cleanup.

### RC-2. Изолировать Windows UAT secure storage

- Убрать общий unpackaged SecureStorage key slot между обычным клиентом и physical UAT.
- Использовать compile-time/physical-lane namespace для SQLCipher key; не удалять весь `securestorage.dat`.
- Добавить lifecycle tests: reset, reopen, wrong lane/account, no production-key mutation.

### RC-3. Закрыть production calls path

- Удалить standalone legacy calls service из UAT/release topology.
- Маршрутизировать authenticated call signal/inbox/ICE к `deep-registry-api`; добавить UAT coturn и закрытые TURN credentials.
- Добавить Docker DNS re-resolution в HAProxy, чтобы restart backend не оставлял stale IP.
- Доказать physical audio call: authenticated ringing/accept, selected ICE pair, двусторонние RTP audio packets, mute/restore, hangup on both peers.

### RC-4. Завершить Deep-native protocol/package contour

- Реализовывать только замороженные DNP1 registry/spec bytes; не изобретать origin/authority semantics.
- Закрыть remaining package-blocking evidence and production-only genesis/cutover/reset authoring seams.
- Подтвердить exact-three package graph, public API/resource snapshots, hostile/replay vectors and downstream client pin/reset impact.

### RC-5. Direct P2P (отдельный activation gate)

- Заморозить Deep-native discovery hints, device identity/roster/revocation, hybrid AKE/provider, protected record layer, replay/fragment/ACK rules и vectors.
- После независимого crypto/privacy review реализовать native BLE + Wi-Fi Direct links и durable direct inbox/outbox.
- Провести offline two-device UAT. Galaxy A5 (API 26) ниже текущего minSdk 28 и не является поддерживаемым host без отдельного platform decision; Wi-Fi Aware на нём отсутствует.
- Не регистрировать `IDirectP2pSessionMessageTransport` и не включать UI до полного activation gate.

### RC-6. Финальные release gates

- Полные client/shared/protocol/registry/xnode/devops/e2e gates на одних pinned commits.
- Android и Windows signed artifacts, SBOM/dependency/package inspection, security review, rollback/recovery drill и sanitized evidence manifest.
- Проверить user/admin docs против точных config keys, ports, TLS, backup/reset and troubleshooting behavior.
- Отдельно зафиксировать iOS/macOS scope: без device evidence не заявлять поддержку как проверенную.

## Definition of Done

- Все RC-1..RC-4 и RC-6 закрыты зелёными воспроизводимыми gates; RC-5 либо закрыт, либо Direct P2P остаётся скрытым и fail-closed.
- В release topology нет legacy/mocks/cleartext app endpoints, permissive TLS callbacks или неподписанных authority inputs.
- Все репозитории чистые, изменения локально закоммичены, superproject указывает на точные child commits.
- Документация описывает только реально доступное поведение и явно маркирует недоступные/непроверенные платформы.
- Push/publication/deployment выполняются только отдельным решением после финального Go/No-Go.

## Следующий спринт после первого production deployment

Ниже находится полный carry-over независимого lead/security review. Эти пункты не скрываются и не считаются подтверждёнными текущим локальным evidence:

- Перевыпустить Mr. X-signed Android lab policy на точные MAUI commit/APK/runner/dependency pins и заново выполнить подписанный physical Android ↔ Windows payload, exact 3-hop primary/disjoint fallback, HTTPS chaos, restart/deduplication и authenticated audio-call matrix.
- Повторить resend-chaos suite на точной RC commit matrix и выпустить envelope, связанный с актуальным XNode commit, а не с прежним rehearsal commit.
- Расширить application-contour recovery drill: кроме byte-exact Docker volume snapshot/restore проверять XNode identity, privacy routing, TURN/call state и полное восстановление пользовательского контура. Текущий disposable drill доказывает только bounded volume recovery.
- Сузить UAT runtime secret mounts: HAProxy и coturn должны получать только необходимые leaf certificate/private key и public CA/CRL; `ca.key` и посторонние файлы authority root не должны попадать в runtime-контейнеры.
- Удалить из публикуемого Android evidence стабильные несолёные SHA-256 низкоэнтропийных model/product/hardware properties либо заменить их run-scoped keyed HMAC без межзапусковой корреляции.
- Сделать RC-6 commit-matrix scripts устойчивыми при запуске в новом PowerShell process без явного `-RepositoryRoot`; добавить контракт на документированную default-команду и не полагаться на доступность `$PSScriptRoot` в default parameter expression.
- Устранить межтестовый SQLite pool race: сериализовать тесты, вызывающие глобальный `SqliteConnection.ClearAllPools()`, либо изолировать pools; повторить полный shared suite многократно, чтобы исключить observed `ObjectDisposedException` flake.
- Выпустить точные signed Android/Windows artifacts, SBOM/dependency/package inspection и sanitized evidence manifest на production-bound commit matrix.
- После появления поддерживаемого второго Android-устройства закрыть two-device evidence; Galaxy A5 API 26 остаётся ниже minSdk 28. iOS/macOS не заявлять проверенными до появления device evidence.
- Выполнить production-only DNP1 genesis/cutover/reset seams и безопасный Gallery fixture только в предназначенном production/post-deployment контуре.
