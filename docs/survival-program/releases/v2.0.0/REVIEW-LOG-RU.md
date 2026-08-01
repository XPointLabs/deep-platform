# Журнал ролевого ревью

Дата: 15 июля 2026 года. Роли: CEO, CTO, ведущий разработчик. Два независимых прохода; рецензенты не редактировали файлы.

## Итерация 1 — критика исходного плана

### CEO

Главные выводы: 16 недель не соответствуют GA; отсутствуют GTM, ресурсный/юридический план и unit economics Free; схема 40/20/40 противоречит 65% fiat margin; Rewards/LoRa/Teams отвлекают от доставки сообщений.

Исправлено: три горизонта, Survival Beta, отдельный fiat waterfall, `B_free`, GTM pilot, staffing/legal/kill criteria, Rewards V3 и LoRa вынесены из критического пути.

### CTO

Главные выводы: текущие DPE1/storage/push раскрывают metadata; forward secrecy не доказана; membership и bridge control planes смешаны; mailbox key был невычислим для sender; `R=1` не давал корректного quorum; update trust и mobile claims были слишком поздними/широкими.

Исправлено: metadata red gates, scoped claims, FS как отдельная reviewed программа, public/node-only control plane, deposit/retrieve capabilities, `N3/W2/R2`, update trust Wave 0, Android/iOS раздельно.

### Ведущий разработчик

Главные выводы: новый план не был source of truth; три onion-hop ошибочно принимались за replicas; не было package/manifest/pinned-SHA delivery, владельцев signer/storage/entitlement services, mixed-version migration, atomic prompts и cross-repo CI.

Исправлено: P00A/P00B, dependency manifest, local immutable artifacts, ADR decision gates, one-agent/one-repo, hot-file/SQLite locks, split producer/consumer prompts, migration/rollback artifacts.

## Итерация 2 — проверка исправленной версии

Рецензенты подтвердили исправление основных концептуальных P0, но нашли отсутствующие владельцы end-to-end путей:

- metadata-safe compatibility envelope;
- mailbox capability lifecycle и storage authorization;
- checkpoint signer, bridge mirrors и node-only membership consumer;
- production-like update ceremony и MAUI verifier;
- rotating push handles client/server;
- nearby handshake contract;
- self-hosted UI/operator/deployment/E2E;
- anonymous Free admission;
- безопасный storage rollback и verifiable quorum receipts.

Все перечисленные элементы получили отдельные repository-scoped prompts. Старые P00/P09/P11/P18 помечены umbrella/superseded и не выдаются исполнителю напрямую.

## Финальные принципиальные изменения

1. Survival Beta — закрытый pilot до focused external design review; Critical/High означает no-go.
2. 100% durable-acknowledged envelopes должны переживать любую одну replica loss в обязательной suite; минимум 100,000 test writes, ноль потерь.
3. `accepted`, `durable` и device-`delivered` — разные состояния.
4. Metadata gate запрещает не только raw IDs, но и stable cross-domain identifiers/joins.
5. Bridge gates включают cold start, future cache, независимые channels, enumeration trial и offline QR/file drill.
6. 40/20/40 относится к соответствующему on-chain purchase flow; fiat SaaS учитывается отдельно.
7. Free cloud — small-envelope public service с object/byte-day admission и cost envelope, не бесплатный drive.
8. Rewards V3, paid entitlement и LoRa являются shadow/Horizon B/C, не Beta dependency.

## Оставшиеся управленческие блокеры, которые нельзя «додумать» технически

- фактически доступная команда, named DRI и 20-week cash budget;
- утверждённый `B_free` и runway;
- выбранные repositories/owners для новых signer/publisher/entitlement services;
- legal/security approvals по role/jurisdiction;
- production key custodians and ceremony authorization;
- pilot acquisition owner, current user baseline and budget;
- external reviewer availability.

Они вынесены в [CEO Decision Memo](CEO-DECISION-MEMO-RU.md). До одобрения P00A implementation agents не запускаются.

