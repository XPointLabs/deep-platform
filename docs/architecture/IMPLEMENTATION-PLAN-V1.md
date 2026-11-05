# План реализации Deep / XPoint V1

Текущая работа, блокеры и статус — только в [NEXT-SPRINT](../NEXT-SPRINT.md).
Этот план задаёт принятые зависимости и приёмку S00–S13.
Точные wire/state/security контракты принадлежат [нормативным владельцам](README.md);
функции, SLO и scenario IDs — [V1 scope](V1-RELEASE-SCOPE.md) и
[release catalog](release-scope.v1.json). Наличие кода, focused PASS или health=200
самостоятельно не принимают этап.

## Правила исполнения

Работать от фактических HEAD/dirty state, сохраняя независимые изменения.
Сначала законченный producer → consumer → recovery slice и focused проверки,
затем обязательный gate на согласованных inputs. Следующий этап открывается
после приёмки текущего; состояние DAG не разрешает пропуск зависимостей.
Новые wire/crypto/state semantics сначала принимаются в sole owner и machine
freeze. TLS, currentness, replay, quorum, revocation и protected floors не
ослабляются. Fixture failure не проверяет остановленную до него ветку.
Гейты и формат отчёта принадлежат [AGENTS](../../AGENTS.md). Production, reset,
push и публикация требуют отдельного разрешения.

## Этапы и приёмка

| Этап | Владелец; зависимости | Обязательный результат и gate |
| --- | --- | --- |
| **S00 baseline** | Root, Node, Registry, DevOps; нет | Воспроизводимые source/fixture/provider inputs; каждый отказ классифицирован и исправлен либо остаётся открытым. Текущий canonical full без unexplained failures/skips; не shipping acceptance. |
| **S01 contracts** | Root, Protocol, Shared; S00 | State/error tables у sole owners: current host admission, exact peer binding, unknown settlement, renewal, retirement/floors, capacity и AppAck. Для перехода указаны durable effect, retry/expiry/cancel и crash case. Нет bootstrap cycle. DR-0083/0084; TRANSPORT-NEUTRAL §8.4. |
| **S02 node admission** | Node, Protocol; S00/S01 | Одна current-only Program/DI composition для Store/Retrieve/ACK: MCG3/MCP3, selector/holder/role/body/member, protected time/revocation и selected exit. Distinct node IDs/descriptor keys. Profile1/MAU2, rollback и boundary expiry отвергаются до replay/mutation; expiry после callback не даёт receipt; unready сохраняет custody. |
| **S03 peer quorum** | Node; S01/S02 | Два независимых durable stores и actual peer HTTPS; exact grant/proof/placement/source до reservation и после callback. Partial commit/lost reply/deadline, concurrent exact retry, crash/reopen, signed quorum settlement, ACK replay и tombstone без resurrection. Одна replica не становится quorum. |
| **S04 client lifecycle** | Shared, Protocol; S01 | Exact original request/ciphertext сохраняется при unknown; новый attempt только по принятому transition. Renewal, retirement и compaction проходят cold/crash/cancel/replay tests. Genuine crossing 512 sends/128 grant scopes и backpressure без reset; pending dependencies/floors не теряются. Exhausted PQ recovery — DR-0111–0114, без увеличения data bound. |
| **S05 issuer/lifecycle** | Registry, Shared, DevOps, installer, CLI; S01, connected S02/S03 | Current issuer→client verify→node acceptance; поддерживаемая signed succession, protected catch-up и periodic contact/prekey/route maintenance. Offline expiry, pending lost response, competing generations, signer outage/rollback, >64 successors и несколько rotations на retained volumes без новых identities/ручных signed edits. CLI-first ниже. |
| **S06 connected text** | E2E, DevOps и runtime owners; S02–S05 | Два настоящих аккаунта: publish→resolve→claim→Hello/Accept→A↔B text→durable inbox→mailbox ACK через masked selected entry и две replica stores. Native crypto/current signed inputs; offline/duplicate/reorder/lost Store/ACK и restart дают один plaintext effect. Store receipt не означает Delivered. |
| **S07 scheduler/receipts/UI** | Shared, MAUI; S04/S06 | Account-scoped single-flight outbox/inbox/ACK scheduler с bounded pages, fairness/backoff/deadline/cancel; offline history/compose без fresh network proof, actual send с fresh authority. Mailbox ACK только после local commit; E2EE AppAck/read — отдельные durable obligations. Kill/reopen, lost/duplicate receipts и unknown recovery без ручного polling; Android Doze/foreground отдельно. Reply/reaction/edit/delete/disappearing authorization и reorder/expiry UI обязательны до S13; ранний S08/S09 требует только text/scheduler/receipt части. |
| **S08 shipping/device** | MAUI, E2E; S06/S07 text slice | Supported Release composition без DEEP_DID2_HTTPS_ADMISSION; actual assembly/native/package/API/resource graph и installed digests. Удаление PMA1/PMR1 shipping dependencies без переименования retired semantics. Android arm64 и Windows x64/arm64: установленный Hello/Accept/text/AppAck, kill/reopen/airplane→online на тех же accounts. Compile-only и source PASS не заменяют package/device gate. |
| **S09 sustained/recovery** | DevOps, E2E и runtime owners; S05/S08 | Retained process/host restart, один Node down/up, Registry/signer outage, new install/long-offline, route/grant/view/key rotation и interrupted compaction/renewal, push-off/network/Android lifecycle. Operator stop не отменяется автоматически. Ноль потерь/duplicate effects в retention window, bounded CPU/memory/DB/retries; corruption/fork/key loss fail closed. SLO/soak и outage intervals — по catalog. |
| **S10 remote media** | Shared BLOB, Node, MAUI, Protocol; S09 | Encrypted remote upload/download через allocated current contract; independent client/cold download и plaintext hash, integrity до exposure, resume/kill/offline/corrupt/missing/reordered/expiry/quota cases. Image/document/video/voice/avatar record/pick/preview/playback и limits по V1 §3.4; local manifest не remote evidence. |
| **S11 devices/history/groups** | Shared, Node, Protocol, MAUI; S09, attachment S10 | DID2 enrollment/revoke/history policy и governed group create/invite/accept/remove/roles/owner conflict; control quorum, durable partial fanout/restart/long-offline, limits и physical scenario IDs. Revoked device исключён из будущего fanout; fork не разрешается last-write-wins. |
| **S12 carriers/push/calls** | Package owners ниже; S09 | Второй независимый masked carrier, bridge/bootstrap/censorship/extraction matrix; push hint, доставка без него. Ratcheted signaling/outbox, Node answer CAS/allocation, relay-only MAUI media отдельно от mailbox onion. Physical Android/Windows audio/video, UDP-blocked/reconnect/provider-outage/wake cases, E2EE и peer-IP evidence; без direct ICE/TURN fallback. |
| **S13 release** | E2E, DevOps, COMPOSE-01, reviewers; S10–S12 | Одна immutable source/artifact matrix: full builds/tests, dependency/API/resource/evidence, native supply-chain/license/crypto/privacy и physical/security/censorship/load/retention/recovery gates. Installer/signed updates/runbooks/public claims проверены. Каждый blocking scenario имеет current PASS; P0/P1=0; reviewable release bundle. Публикация отдельно разрешается владельцем. |

### S00 — воспроизводимая исходная точка

Использовать canonical runner и настоящие frozen/native/PostgreSQL prerequisites.
Изменение ожидаемого hash/count не принимает spec drift. Source qualification
и actual package/provider/shipping acceptance проверяются отдельно по
[правилам квалификации](../survival-program/README.md#integration-qualification);
исходный FAIL не становится PASS из-за переноса владельца gate.

### S05 — current issuer и автоматический lifecycle управляющего контура

Logical assignment и короткое operational carriage разделены
[DR-0122](../survival-program/decisions/DR-0122-logical-mailbox-assignment-carriage.md).
Prekey succession, pending/committed custody и retained secrets принадлежат
[CONTACT-RESOLVER §3.3](CONTACT-RESOLVER-V1.md#33-pre-key-service-descriptor-xps1), bounded active/archive
и paged history — DR-0177/0178. Freshness exhaustion требует ожидания current
authority. Health/readiness не расходуют issuance nonce; refresh single-flight
с bounded backoff. Ни reset, remint, продление signed lifetime, root online,
ни ручная правка floors не заменяют lifecycle. Connected repair не закрывает
periodic maintenance; current acceptance остаётся в NEXT-SPRINT.

#### CLI-first — первый приоритет внутри S05

`deep-cli` владеет console adapter, isolated persistent profiles и black-box driver;
Shared — единственный portable business/runtime owner, Protocol — codec/crypto,
DevOps — real TLS Registry/три Node. Не копировать transport/orchestration в CLI.

1. Windows headless account/status/address/network/profile на native stack,
   protected storage и SQLCipher; strict arguments/cancel/failure exits, без
   recovery/key exports и caller-authored authority.
2. Через публичные owned Shared APIs: publish/resolve/request/consent, A↔B text,
   send/sync/receive, restart/offline/exact retry/dedup/unknown recovery на тех же
   profiles. Незавершённый original не переавторяется после expiry.
3. После text — реальные attachments с byte/hash/resume/corruption и groups с
   membership/revocation; затем matching source/full/package gates. CLI PASS не
   заменяет физические Windows/Android evidence и release approval.

Сначала owner scopes/bounded state, затем independent dispatch и постоянный
receive/ACK. Warm local p95≤1s и release SLO проверяются отдельно от cold
maintenance; latency microbenchmark не закрывает S05/S06–S13.

## Стабильные package owners для evidence

IDs связывают existing release catalog с владельцем, не создают вторую очередь.
Codec/security/retention требования находятся у тематических owners.

| Package IDs | ownerRepository | Текущая привязка |
| --- | --- | --- |
| GOV-01, ARCH-01 | XPointLabs | S00/S01, нормативная согласованность |
| ID-PQ-CB, CRYPTO-01, ID-01, REG-01 | deep-protocol | существующая база; S01/S13 проверяют gaps и production closure |
| E2EE-01, APPLICATION-CORE-CODEC-01 | deep-protocol | S01/S06/S07, current semantics и receipt activation |
| ATTACHMENT-CODEC-01 | deep-protocol | S10 |
| HISTORY-CODEC-01, GROUP-CODEC-01 | deep-protocol | S11 |
| NETCODEC-01, ONION-01, CONTACT-CODEC-01 | deep-protocol | S01–S06, current contracts |
| CARRIER-CODEC-01, CALL-CODEC-01 | deep-protocol | S12 |
| STORE-01, MSG-01, CONTACT-CLIENT-01 | deep-client-shared | S04/S06/S07 |
| DIRECTORY-CLIENT-01, ROUTE-01, SUPERVISOR-01 | deep-client-shared | S04/S05/S07/S09 |
| DEVICE-01, GROUP-CLIENT-01 | deep-client-shared | S11 |
| BLOB-01 | deep-client-shared | S10 |
| CALL-SIGNAL-01 | deep-client-shared | S12 |
| XNODE-01, CONTACT-SERVICE-01 | xnode | S02/S03/S06/S09 |
| CARRIER-GATEWAY-01, CALL-RELAY-01 | xnode | S12 |
| GROUP-CONTROL-SERVICE-01 | xnode | S11 |
| DIRECTORY-01, ACCOUNT-DIRECTORY-AUTH-01 | deep-registry-api | S05 |
| CARRIER-CATALOG-01, BRIDGE-DISTRIBUTOR-01 | deep-registry-api | S12 |
| ROOT-CHECKPOINT-01, BRIDGE-01 | deep-devops | S05/S09/S12/S13 |
| REALITY-01, HTTPS-01, CALL-MEDIA-01 | deep-client-maui | S08/S12 |
| COMPOSE-01 | deep-client-maui | S08/S13 |
| PUSH-01 | deep-push-notification-server | S12 |
| E2E-01 | deep-tests-e2e | S06/S08–S13 |
| DEV-E2EE-01 | deep-protocol, deep-client-shared, deep-devops, deep-client-maui (отдельные repo-owned подзадачи) | deferred local-only authority; не release dependency |
