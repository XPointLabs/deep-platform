# История спринтов

## 2026-08-26 — release-candidate closure

Статус: завершён локально. Push, публикация и первый production deployment в этот спринт не входили. Отложенные production-bound проверки и замечания финального независимого review перенесены в [NEXT-SPRINT.md](NEXT-SPRINT.md).

### Цель

Получить воспроизводимый release candidate Deep для Android и Windows с production-grade транспортом, закрытым DNP1 package/runtime контуром, актуальными user/admin docs и локальным evidence bundle.

### Реализовано

- Завершён clean-break Deep-native privacy route: exact binary MAU2 проходит через три послойно зашифрованных XNode; primary и fallback не пересекаются; direct MAU2, Session RPC и прежний JSON-onion удалены.
- Survival authority публикует независимые X25519 keys и `privacy-routes.v1.json`; authority связана с activation и Mr. X policy, fallback разрешён только при доказанном отказе до пересылки.
- Реализован exact epoch-overlap recovery `7/8 → 8/9 → 9/10` с исторической проверкой истёкшего bridge proof и сохранением byte-identical overlap.
- Клиентский mailbox checkpoint ограничен монотонным шагом `+1`; отказ при gap сохраняет credentials, revocation checkpoint и active route атомарно.
- Physical Windows UAT storage отделён от обычного клиента; production package/data не входят в UAT reset.
- Authenticated calls path перенесён в `deep-registry-api`; UAT topology использует coturn и закрытые TURN credentials.
- Закрыты исполняемые DNP1 evidence mapping, exact package graph и связанные protocol/registry/e2e pins.
- Исправлены Android physical build RID propagation и race генерации compiled Mr. X trust root между Android RIDs.
- Добавлены RC-6 recovery tooling, documentation contracts и двухшаговая commit-matrix binding без циклической self-reference.
- HAProxy исключён из обычного dev-контура и используется только в UAT TLS/mTLS/chaos topology.

### Локальные проверки

- XNode: ProfileGenerator `107/107`, unit `134/134`, integration `197/197`.
- Shared: основной полный прогон `971/971`; обнаруженный независимым review межтестовый SQLite pool flake перенесён в следующий спринт.
- MAUI: ViewModels `537/537`, Smoke `164/164`, UI `78 passed / 2 physical skipped`; Android DeviceTests Release build завершён без ошибок.
- Mailbox/UAT integration evidence: `11/11` фаз, `passed=true`; registry, TURN, шесть XNode и UAT ingress были healthy.
- Android и Windows physical Debug builds завершены; E2E APK установлен без изменения production package.
- Runtime authority `9/10` опубликована на Android и Windows; Android подтвердил 11 файлов и `exactReplay=true`.
- Android cold-start/import window завершён без fatal, mailbox, rotation или checkpoint ошибок.
- Documentation contracts: `173` проверки; commit-matrix disposable contracts: `28` проверок; disposable volume snapshot/restore self-test пройден.
- Независимые lead developer и security reviews выполнены; незакрытые findings явно перенесены в следующий спринт.

### Точки фиксации

- Release child commit binding: superproject commit `99224e184b05c7f27725ba9df30616351ba7f420`.
- Manifest SHA-256: `6c97fa83575a1e7b55741fadec27279d1ec4d43e88dc04baaa9c960f9f587d83`.
- Финальный документирующий commit спринта до реорганизации истории: `38fe8d22954b1c0f6627a79fdd1fcd3e91e335b2`.
