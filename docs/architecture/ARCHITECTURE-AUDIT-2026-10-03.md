# Аудит XPointLabs: сеть, доставка и следующий этап

Дата: **2026-10-03**. Тип: source audit, проверка документации и ограниченное
воспроизведение тестов; не security certification и не release qualification.

## Вывод

**Архитектурный путь жизнеспособен, но текущая реализация не завершена как единая
система.** Переписывать transport или отказываться от durable mailbox оснований
нет. Предыдущий агент правильно строил криптографические границы, exact retry,
durable custody и запрет небезопасных fallback. DR-0081 исправляет реальный
недостающий binding выбора реплик. Однако последовательность оставила producer,
node consumers, жизненные циклы и shipping client в разных состояниях.
Продолжать наращивать изолированные протокольные slices без общей приёмки —
неэффективно и не доказывает стабильную доставку.

Принята коррекция: [DR-0082](../survival-program/decisions/DR-0082-integration-first-delivery-baseline.md).
Единственный исполняемый [план Codex](IMPLEMENTATION-PLAN-V1.md) начинается с
текущего кода и достоверных fixtures, затем закрывает mailbox integration,
durable lifecycle, scheduler/receipts, Release composition и recovery.
Полный [V1 scope](V1-RELEASE-SCOPE.md) остаётся целью после text milestone.

## Основание и границы проверки

Сверены все 13 child repositories и их рабочие деревья: до аудита они были
чистыми. Root baseline: `3a3afbd`; основные HEAD точно совпали с
[handoff](../RELEASE-STABILIZATION-HANDOFF-2026-10-03.md). В частности:

| Repo | Source baseline |
| --- | --- |
| deep-protocol | `c037aee6af66e1f88a36f91d2fffba041a26b246` |
| deep-client-shared | `07ae50d3408fbcebf0e545104d4a207fda3d02a8` |
| xnode | `b5899c90707c7c12b30849f05e0bb3ff9090217b` |
| deep-registry-api | `5c79cb07620915769f673fd4b92624d774ad709e` |
| deep-client-maui | `5dd1c34c3ee333a23583dd05b9f6f0fbc8fcf96f` |
| deep-devops | `af4f833787b2dcb41e8aac7ed8b54d69d4cbdfe3` |
| xpoint-node-installer | `381893257926732af1fb143d054f03f8a2b073c0` |

Глубоко проверен критический путь Protocol → Registry/XNode → Shared → MAUI,
его тесты и нормативные документы. DevOps/installer рассмотрены как владельцы
renewal/recovery, без live inspection. Staking, push, E2E и public docs проверены
на роль/статус в общей структуре, а не полностью построчно. Закрытый передаточный
контекст использован только как историческая подсказка; private сведения не
переносились в документацию. Предыдущие ограничения и reported результаты не
выдавались за новые замеры.

Production endpoints, устройства, данные, custody и deployment этим аудитом
не проверялись и не изменялись. Ссылки ниже указывают на исходники; номера строк
относятся к baseline, а не обещают неизменность после реализации плана.

## Подтверждённые разрывы

### 1. Новый mailbox protocol не подключён к текущему XNode

В [Program.cs](../../xnode/src/XNode/Program.cs), строки 261–276, подключается
`ProductionMailboxAuthorityProvider` и старый fanout; строки 331–338 подключают
RIP1/P04 peer verifier. [MailboxClientRuntime](../../xnode/src/XNode/MailboxClientRuntime.cs)
требует PMA1/PMR1 (строка 82). Current Protocol
[MailboxHostAuthorityV2Verifier](../../deep-protocol/src/Deep.Protocol/XPointNetworkV1/MailboxHostAuthorityV2Verifier.cs)
вычисляет выбранную пару из signed MCG3 selector, но current host verifier не
имеет XNode consumer. Disabled provider заменяется RejectAll, что безопасно
закрывает операцию, но не создаёт рабочую доставку.

Следствие: это незавершённая composition, а не доказательство дефекта TCP/onion.
Нужно S02/S03, включая peer proof; простое включение старого provider недопустимо.

### 2. Admission, время и receipt keys нельзя исправить одной заменой DI

[MailboxAuthenticatedCapabilityRuntime](../../xnode/src/XNode.Core/Mailbox/Client/MailboxAuthenticatedCapabilityRuntime.cs)
использует UTC (строка 247); [MailboxReplicaReceiver](../../xnode/src/XNode.Core/Mailbox/MailboxReplicaReceiver.cs)
берёт UTC и проходит reserve → mutation → receipt без нового protected interval
после callback. Требование DR-0081 шире: holder/revocation/replay/body/selected
local exit и повторные проверки перед mutation/receipt. Источник revocation
требует явного закрытого решения S01.

[MailboxClientReceiptCrypto](../../xnode/src/XNode.Core/Mailbox/Client/MailboxClientReceiptCrypto.cs)
сравнивает public key с RouterId (строка 18) и проверяет подпись по replica ID.
Current XND node ID и descriptor signing key — разные сущности. S02/S03 должны
проверить положительный сценарий с различающимися ID/key и matching custody.
Это blockers активации; аудит не утверждает exploitability текущей deployment.

### 3. MAUI Release не имеет composition для сообщений

[MauiProgram.Did2](../../deep-client-maui/src/Deep.Client.Maui/MauiProgram.Did2.cs)
регистрирует conversation runtime только под `DEEP_DID2_HTTPS_ADMISSION`
(строки 47–50). [Проект приложения](../../deep-client-maui/src/Deep.Client.Maui/Deep.Client.Maui.csproj)
запрещает этот режим для Release (161–164). Большая часть прежних services
исключена compile whitelist; текущий Core.Did2 ограничен account/direct-text.

Следствие: требуется S08 production composition, а не только очередной device
test Debug пакета. Снятие diagnostic запрета не является исправлением.

### 4. Bounded journals не имеют завершённого sustained lifecycle

[Send journal](../../deep-client-shared/src/Deep.Client.Shared/Persistence/DeviceV2/ProtectedDid2MailboxSendJournal.cs)
ограничен 512 entries; [dispatch owner](../../deep-client-shared/src/Deep.Client.Shared/Persistence/DeviceV2/ProtectedDeepIdV2AccountOwner.MailboxDispatch.cs)
отклоняет новый entry на пределе. Production retirement/compaction caller не
найден. Completion ordinary command не удаляет send entry. Это предел записей,
не точная гарантированная граница «512 пользовательских сообщений».

[Grant journal](../../deep-client-shared/src/Deep.Client.Shared/Persistence/DeviceV2/ProtectedDid2MailboxGrantJournal.cs)
имеет 128 entries; [grant owner](../../deep-client-shared/src/Deep.Client.Shared/Persistence/DeviceV2/ProtectedDeepIdV2AccountOwner.MailboxGrant.cs)
сохраняет единственного winner для route/locator/domain. Expiry проверяется,
но renewal истёкшего winner в том же scope не найден. Exact send сохраняет
original grant/route/expiry; подстановка нового grant нарушила бы exact retry.

Это статические выводы по call graph, не проведённый 513-message soak. Нужны
S01/S04 state transitions: unknown settlement, authorized successor, retirement
с replay protection и backpressure. Просто увеличить лимиты недостаточно.

### 5. Reconnect ещё не является delivery scheduler

[DeepIdV2NetworkReconnect](../../deep-client-maui/src/Deep.Client.Maui.Core/Services/DeepIdV2NetworkReconnect.cs)
имеет полезные single-flight/backoff/cancellation, но callback запускает
admission/publication, не draining outbox/inbox. [MailboxReceive](../../deep-client-shared/src/Deep.Client.Shared/Services/DeepIdV2AccountService.MailboxReceive.cs)
делает одну bounded page, UI предлагает manual refresh.

[ListOwnMessagingMessagesAsync](../../deep-client-shared/src/Deep.Client.Shared/Services/DeepIdV2AccountService.Messaging.cs)
проверяет fresh own/peer proofs перед чтением local history (54–62), а
[MessagingViewModel](../../deep-client-maui/src/Deep.Client.Maui.Core/ViewModels/DeepIdV2MessagingViewModel.cs)
очищает projection при потере network verification. Нужно S07: безопасное
local reading/queueing отдельно от current network mutation и общий scheduler.

### 6. Durable receive есть, AppAck/Read orchestration ещё нет

Shared правильно фиксирует actual received envelope/materialization до
mailbox tombstone ACK; lost-response/reopen seams уже есть. Но current
[semantic consumer](../../deep-client-shared/src/Deep.Client.Shared/Persistence/DeviceV2/ProtectedDeepIdV2AccountOwner.MailboxAck.cs)
поддерживает MessageCreate/AttachmentOffer/ContactAccept, остальные ordinary
events отклоняет. Текущий authoring allowlist также не включает AppAck/read.

Store receipt, durable recipient inbox и mailbox deletion ACK не доказывают
sender-visible Delivered/Read. Нужна отдельная S07 receipt state machine.

### 7. Renewal и продуктовые функции остаются отдельными разрывами

[ContactRenewal](../../deep-client-shared/src/Deep.Client.Shared/Persistence/DeviceV2/ProtectedDeepIdV2AccountOwner.ContactRenewal.cs)
реализует protected successor/promotion, но начинает рассматриваемый renewal
после effective expiry и не разрешает смену profile/service bytes. Это ещё не
полный proactive lifecycle при изменении projection/service и incomplete request.

[Attachments](../../deep-client-shared/src/Deep.Client.Shared/Services/DeepIdV2AccountService.Attachments.cs)
содержит internal local prepare/read/materialize; remote commands отсутствуют
в [conversation runtime](../../deep-client-maui/src/Deep.Client.Maui.Core/Services/IDeepIdV2ConversationRuntime.cs).
Current group semantic/UI path также не подключён. Local manifest, старый
GroupV1 harness и наличие source files не доказывают remote files/groups.

Registry private grant issuer уже использует Protocol/current proof и
permanent winner. Его HTTP tests не закрывают весь positive
issuer → XMC2 → client custody → MAU3 → node → peer quorum. Matching signed
successors, deployed signers и installed artifacts требуют S05/S06 проверки.

## Что сохраняем

- PQ-root/identity и закрытые canonical interfaces; без Session compatibility.
- Owned contact draft/claim/session transfer и согласованные crypto/SQL commits.
- Exact request/ciphertext custody, replay/floor checks и pending/unknown.
- Проверку selector в DR-0081: blinded placement не восстанавливает независимый
  signed selection input; обход этого binding был бы ошибкой архитектуры.
- Atomic materialization, проверяемый tombstone quorum и нейтральные durable
  mailbox primitives, где они не зависят от retired authority.
- Trusted time/fail-closed policy. Не лечить её отсутствием проверок; исправлять
  authoring, renewal, readiness и доступность независимых trust observations.

## Сравнение с конкурентами

Это сравнение публичных архитектур, не независимый аудит их реализаций или
измеренный benchmark. Полный source/policy owner —
[SESSION-PARITY-AND-SOURCES](SESSION-PARITY-AND-SOURCES.md).

| Система | Подтверждённый принцип | Вывод для Deep |
| --- | --- | --- |
| Session | Onion request и recipient swarm replication; durable jobs/backoff в desktop | Сохранить routing + mailbox, довести queue/recovery; [routing](https://github.com/session-foundation/session-docs/blob/main/session-network/session-protocol/onion-requests-and-message-routing.md), [swarms](https://docs.getsession.org/session-network/session-nodes/swarms), [desktop](https://github.com/session-foundation/session-desktop/blob/dev/ARCHITECTURE.md) |
| SimpleX | SMP ACK после сохранения у клиента; agent различает SENT и RCVD | Не смешивать Store/Delivered, сделать resume/ACK отдельными durable obligations; [SMP](https://github.com/simplex-chat/simplexmq/blob/stable/protocol/simplex-messaging.md#acknowledge-message-delivery), [agent](https://github.com/simplex-chat/simplexmq/blob/stable/protocol/agent-protocol.md) |
| Signal | Per-device offline queue; Sesame допускает loss/reorder/duplicates | Проверять доставку поверх ненадёжной сети и partial device fanout; [queue](https://support.signal.org/hc/en-us/articles/5532268300186-Disappearing-Messages-with-a-Linked-Device), [Sesame](https://signal.org/docs/specifications/sesame/) |
| Briar | P2P sync дополняется Mailbox для неодновременного online | Чистый P2P не устраняет offline-storage задачу; [Mailbox](https://briarproject.org/download-briar-mailbox/) |
| Tor | Cache/refresh/backoff и отдельные bridges | Развязать bootstrap/refresh/data plane, но не заимствовать чужую политику expired trust; [directory](https://spec.torproject.org/dir-spec/client-operation.html), [bridges](https://support.torproject.org/relays/getting-started/what-is-a-bridge/) |

Долгоживущий socket полезен для latency, но correctness держится на durable
queue, idempotency и подтверждениях. Android Doze ограничивает network/jobs;
бесконечный reconnect не создаёт CPU/network execution. Без push корректная
граница — сохранность и catch-up при следующем разрешённом выполнении.
[Android Doze](https://developer.android.com/training/monitoring-device-state/doze-standby).

## Когда текущие требования действительно становятся тупиковыми

Ровно три routing nodes + exact-three route + непрерывная доставка при отказе
любого узла несовместимы. Это следствие topology, а не дефект retry. Две mailbox
реплики сохраняют данные, но не создают третий доступный routing hop.

Для одного допустимого route после одного отказа нужно как минимум четыре
пригодных routing nodes; это необходимое, не достаточное условие. В частности,
текущий two-of-two storage quorum всё ещё может блокировать mutation при потере
назначенной реплики. Для двух полностью непересекающихся three-hop путей нужно
минимум шесть и проверка ролей, keys, carriers и failure domains. Введённые
числа — топологический вывод, не активация нового deployment profile.

Рекомендация сейчас: завершить `OfficialXPoint3` как честный pilot/recovery
profile и проверить text/renewal. Если продукт требует outage availability,
отдельно менять signed roster/profile, storage handover и независимость operators
по [DEPLOYMENT-PROFILES](DEPLOYMENT-PROFILES.md). Если команда решит отказаться
от собственной анонимизирующей сети ради обычной надёжной переписки, возможен
пересмотр продукта вокруг существующей инфраструктуры/другого transport, но это
изменяет privacy и операционную модель; текущие находки такого переписывания
не требуют. Не создавать новый transport как реакцию на незавершённую DI.

## Тестовое evidence этого аудита

Полный исходный отчёт: node 19 failures; Registry 31 failures/6 skips. Полные
suite в данном аудите повторно не выполнялись. Отдельные ограниченные запуски
с `--no-build -c Release` использовали уже существующие binaries:

| Выборка | Pass / fail | Что воспроизведено |
| --- | --- | --- |
| Node ContactReplicaTransport + dormant composition | 14 / 3 | Source-string assertion; два fixture placement reject до HTTP |
| Node mailbox invariants/runtime + contact samples | 39 / 3 | Старый reflection contract; два XPA fixture reject до mutation |
| Registry grant HTTP/journal + catalog sample | 13 / 3 | Reader 1 вместо 2; двум journal tests нужна isolated PostgreSQL |

Это полезная классификация, а не устранение failures. Другие падения остаются
неисследованными. Invalid fixture должен быть исправлен так, чтобы снова
выполнялась исходная timeout/signature/crash ветка. S00 требует свежего build,
полного повторного прогона и проверяемых artifacts.

Эти диагностические прогоны сохранили только console output сессии; отдельного
TRX нет. Для воспроизведения из соответствующего repo:

```powershell
# xnode
dotnet test tests/XNode.IntegrationTests/XNode.IntegrationTests.csproj -c Release --no-build -p:DeepProtocolSourceCutover=true --filter "FullyQualifiedName~ContactReplicaTransportTests|FullyQualifiedName~ContactServiceTerminalDispatchTests.ProductionCompositionKeepsContactRuntimeAndReplicaEndpointDormant" --logger "console;verbosity=normal"
dotnet test tests/XNode.Tests/XNode.Tests.csproj -c Release --no-build -p:DeepProtocolSourceCutover=true --filter "FullyQualifiedName~ContactServiceOpaqueFacadeTests.ContextMismatchDoesNotMutateAndAcceptedPublishDurablyExactReplays|FullyQualifiedName~ContactAuthorizedPublicationReplicaTests.ExactXpaReservationAndCommitSurviveReplicaRestart|FullyQualifiedName~ContactPreKeyXpc1ResponseTests.PublicVerifierContractIsPresentWithoutServerRawKeyInputs|FullyQualifiedName~MailboxNativeMau2BusinessInvariantTests|FullyQualifiedName~MailboxAuthenticatedCapabilityRuntimeTests" --logger "console;verbosity=normal"
# deep-registry-api
dotnet test tests/Deep.Registry.Api.Tests/Deep.Registry.Api.Tests.csproj -c Release --no-build -p:DeepProtocolLocalCutover=true -p:DeepProtocolSourceCutover=true --filter "FullyQualifiedName~DirectoryPublicationCatalogTests.RestartPreservesExactBytesHashesAndExactReplay|FullyQualifiedName~DeepIdV2MailboxGrantHttpTests|FullyQualifiedName~DeepIdV2MailboxGrantJournalTests" --logger "console;verbosity=normal"
```

## Что изменено в документации

Проверки documentation change:

| Проверка | Результат |
| --- | --- |
| Protocol strict registry + source/anchor consistency | PASS; 174 anchors, изменены только шесть document hashes и derived registry hash |
| Пересобранные DeepProtocolRegistryTests / XPointRegistryMachineParityTests | 11 passed / 0 failed / 0 skipped |
| Public documentation gate | 174 checks passed; public render в этом изменении не пересобирался |
| Изменённые root Markdown и release catalog | 18 UTF-8 файлов, 310 local links; release-scope JSON schema PASS |
| DNP1 `ClassificationOnly` | PASS; не package/final-release evidence |
| GROUP `-MachineOnly` | PASS; executable group tests не запускались |
| Root governance ClassificationOnly | FAIL до проверки prose: machine specification set raw SHA mismatch |
| Root deep-crypto specification | FAIL: expected contact primitives 15, current 13 |
| Root contact specification | FAIL: ссылка checker на удалённый `ContactV1/ContactCodecSecurityTests.cs` |
| Root onion specification | FAIL: ContactResolve pairing/bounds checker не совпадает с текущим набором |

Четыре root failures существуют на неизменённых этим аудитом scripts/frozen
inputs (проверены относительно baseline). Их исправление входит в S00; imported
approved blobs и release evidence не переписывались ради зелёного gate. Для
raw SHA отдельно проверить нормализацию checkout и approved bytes.

Нормативный index, NEXT-SPRINT и implementation plan пересобраны от фактической
базы; старые программы доступны в Git. В тематических владельцах исправлены
устаревшие current DID1/MAU2 claims, frozen-vs-implemented status и availability,
закреплена offline local/delivery граница. Historical field tables не стали
новыми positive wire contracts; machine allocation/lifecycle не активировались.
Hash-bound documents перепривязываются штатным reviewed registry workflow.

MAUI/Shared architecture теперь явно отделяют активный DID2 graph от исключённой
старой реализации. Dated handoff/checkpoints сохранены как evidence, а не
параллельные инструкции. Product code, crypto/wire, private context и production
state в этом documentation change не исправлялись.
