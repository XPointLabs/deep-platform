# Ближайший спринт: release-candidate closure

Статус на 2026-08-25: текущие локальные HEAD являются точкой отсчёта. Production ещё не запускался; обратная совместимость и legacy-пути не требуются. Push, публикация и production deployment не входят в этот спринт.

## Цель

Получить один воспроизводимый release candidate Deep для Android и Windows с production-grade транспортом, закрытым DNP1 package/runtime контуром, актуальными user/admin docs и полным локальным evidence bundle.

## Уже подтверждено

- Реальный Android ↔ Windows текст проходит через authenticated MAU2 по CA-trusted HTTPS; Android показывает точный статус `✓ / Отправлено`.
- Ошибка прежнего status test была в OEM-декодировке UTF-8 UI dump и исправлена в `deep-client-maui` commit `060a983`.
- Public services используют системное TLS-доверие без статического leaf-SPKI pinning; UAT CA добавляется только в physical-E2E Android build.
- UAT local-state reset разрешён. Production package/data остаются вне области сброса.
- Direct P2P Phase A — только отключённый radio scaffold; production transport/identity/AKE не активированы.

## Release blockers (в порядке исполнения)

### RC-1. Закрыть physical payload matrix

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
