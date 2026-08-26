# Следующий спринт: post-production hardening

Спринт начинается после первого production deployment. История завершённого release-candidate спринта находится в [SPRINT-HISTORY.md](SPRINT-HISTORY.md).

## Цель

Закрыть отложенные production-bound evidence и замечания независимого lead/security review, не меняя уже зафиксированный clean-break протокол без отдельного design decision.

## Production-bound evidence и ceremonies

- Перевыпустить Mr. X-signed Android lab policy на точные MAUI commit, APK, runner и dependency pins.
- Заново выполнить подписанный physical Android ↔ Windows payload matrix: text, generic file, PDF/document, inline image, voice, exact metadata/hash, open/save/play, cold restart и deduplication.
- Подтвердить exact 3-hop primary privacy route, полностью непересекающийся fallback и отсутствие direct MAU2 endpoint.
- Повторить HTTPS manual resend, automatic retry и durable ACK crash-window suite на точной production-bound commit matrix; выпустить актуальный sanitized evidence envelope.
- Подтвердить authenticated physical audio call: ringing/accept, selected ICE pair, двусторонние RTP packets, mute/restore и hangup на обоих peers.
- Выпустить точные signed Android/Windows artifacts, SBOM, dependency/package inspection и sanitized evidence manifest.

## Recovery и security hardening

- Расширить application-contour recovery drill: кроме byte-exact Docker volume snapshot/restore проверять XNode identity, privacy routing, TURN/call state и полное восстановление пользовательского контура.
- Сузить UAT runtime secret mounts: HAProxy и coturn должны получать только необходимые leaf certificate/private key и public CA/CRL; `ca.key` и посторонние authority-файлы не должны попадать в runtime-контейнеры.
- Удалить из публикуемого Android evidence стабильные несолёные SHA-256 низкоэнтропийных model/product/hardware properties либо заменить их run-scoped keyed HMAC без межзапусковой корреляции.
- Сделать RC commit-matrix scripts устойчивыми при запуске в новом PowerShell process без явного `-RepositoryRoot`; добавить контракт на документированную default-команду.
- Устранить межтестовый SQLite pool race: сериализовать тесты, вызывающие глобальный `SqliteConnection.ClearAllPools()`, либо изолировать pools; подтвердить стабильность несколькими полными shared-suite прогонами.
- Проверить production-only DNP1 genesis/cutover/reset seams после первого deployment и провести безопасный rollback/recovery rehearsal.

## Платформы и fixtures

- Добавить безопасный Gallery fixture в предназначенном post-deployment тестовом контуре.
- Закрыть two-device evidence после появления второго поддерживаемого Android-устройства. Galaxy A5 API 26 остаётся ниже minSdk 28 и не является поддерживаемым host.
- Не заявлять iOS/macOS проверенными до появления реального device evidence.
- Direct P2P оставлять скрытым и fail-closed до отдельного protocol/crypto/privacy review, поддерживаемых двух устройств и полного activation gate.

## Definition of Done

- Все перечисленные physical, chaos, call, recovery и artifact gates воспроизводимо проходят на одной production-bound commit matrix.
- Runtime-контейнеры не получают CA private key или посторонние secrets; evidence не содержит стабильных коррелируемых device identifiers.
- Shared suite стабильно проходит повторные полные прогоны без SQLite pool race.
- Непроверенные платформы и Direct P2P остаются явно неподдерживаемыми и fail-closed.
- Все child repositories и superproject чистые, локально закоммичены и связаны обновлённой commit matrix.
