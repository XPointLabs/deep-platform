# Transport-neutral messaging architecture

Статус: **целевая нормативная архитектура для clean-break реализации**

Актуально: 2026-10-03

## 1. Назначение и приоритет

Этот документ определяет границу между Deep-native прикладным протоколом и
способами доставки. Первый релиз использует XPoint Network. В дальнейшем должны
подключаться user-managed/on-prem mailbox, direct P2P и store-carry-forward mesh
без изменения семантики сообщений, ratchet/group state, локальной истории и
пользовательской identity.

Документ является source of truth для новой transport-neutral композиции. Он:

- следует clean-break решению
  [`DR-0003`](../survival-program/decisions/DR-0003-deep-native-session-clean-break.md):
  Session ID, Session wire, legacy readers, migration, dual-read/write и
  compatibility fallback в новой реализации запрещены;
- использует identity и crypto roles, утверждённые `DR-0003`, и только
  canonical crypto registry/vectors текущего clean-break поколения;
- не переопределяет canonical MAU3 (DR-0081) и privacy-routing bytes;
  transport adapter инкапсулирует их за общей границей;
- заменяет как целевую архитектуру текущие `ISession*`/`SessionId` contracts.
  Старые имена не переносятся в новый public API;
- отделяет продуктовую capability от факта наличия класса или endpoint.

Если старый документ требует fully disjoint fallback для трёхузлового первого
deployment или обещает network-level `exactly-once`, применяются более узкие
гарантии этого документа и
[`DEPLOYMENT-PROFILES.md`](DEPLOYMENT-PROFILES.md).

Нормативные слова MUST, MUST NOT, SHOULD и MAY имеют смысл RFC 2119.

## 2. Принятые решения

1. **Application semantics не знает transport.** Текст, reply, reaction,
   edit/delete, receipt, group commit, attachment manifest и call signal —
   canonical application events внутри E2EE, а не команды XNode/P2P.
2. **Identity отделена от адреса.** `DeepAccountId` и `DeepDeviceId` не содержат
   DNS, IP, mailbox, route, relay или radio address.
3. **Ключи устройств отделены от recovery.** Routine messaging никогда не
   загружает recovery phrase/root. Каждое устройство имеет собственные signing,
   agreement, prekey и ratchet keys; Ed25519→X25519 conversion запрещена.
4. **Криптография выполняется до transport.** Adapter получает непрозрачный
   ciphertext bundle и не получает plaintext, conversation secret или MLS
   epoch secret.
5. **Один durable logical outbox находится выше adapters.** Transport attempts
   вложены в logical item и могут меняться без создания второго сообщения.
6. **At-least-once + idempotency.** Сеть не обещает exactly-once. Клиент даёт
   exactly-once local materialization для одного semantic event посредством
   authenticated dedup.
7. **Failover управляется policy, а не adapter.** Не бывает скрытого перехода с
   XPoint на direct HTTPS, on-prem или P2P. Смена privacy/ownership profile
   требует разрешённой пользовательской или deployment policy.
8. **Push — только hint.** Отсутствие FCM/APNs/WNS не влияет на корректность
   доставки; polling/resume остаются достаточными.
9. **Call signaling использует обычную message plane.** Media path выбирается
   отдельно; onion-routing RTP через три store-and-forward XNode не требуется.
10. **V1 groups не требуют MLS.** Первый релиз использует owner-sequenced
   hash-chain и pairwise ratcheted fan-out; transport contracts не кодируют
   этот выбор и допускают последующий MLS group engine.
11. **Attachments — отдельная chunk plane.** В сообщении передаётся только
    E2EE attachment manifest; backend не получает plaintext или filename.

## 3. Слои и владельцы состояния

The current DID2-owned sender composition is governed by
[DR-0056](../survival-program/decisions/DR-0056-did2-owned-mailbox-message-dispatch.md).
Owned committed ciphertext, protected request/counter custody and SQL exact
preparation precede selected-entry dispatch; retry does not renew lifetime or
silently reroute. A verified durable Store receipt is not semantic recipient ACK.

```text
UI / conversation commands
          |
          v
Canonical application events
          |
          v
1:1 ratchet / selected group engine <-- owns E2EE state, epochs, replay window
          |
          v
Durable logical outbox/inbox     <-- owns semantic lifecycle and dedup
          |
          v
Delivery policy + capability negotiation
          |
          +------------+-------------+--------------+
          v            v             v              v
     XPoint adapter  on-prem      direct P2P      mesh adapter
       MAU3/onion   future profile  live peer link   store/carry/forward
          |
          v
Masked carrier / link / radio / local network
```

`deep-protocol` владеет canonical records, validation, cryptographic domains и
test vectors. `deep-client-shared` владеет portable orchestration и durable
state. Platform project владеет secure storage, background execution, radios,
WebRTC и carrier process lifecycle. Adapter repositories не авторят
application events и не изменяют crypto state напрямую.

### 3.1 Local availability и delivery lifecycle

Аутентифицированная локальная history/projection и сохранение нового logical
intent MUST работать без fresh network proof. Потеря current network authority
не очищает локальную историю и не уничтожает очередь. Current proof/consent/
revocation policy проверяется перед разрешённой сетевой mutation; offline intent
не является разрешением encrypt/send с устаревшей authority. Повреждённое либо
неаутентифицированное local state не получает это разрешение автоматически.

Scheduler обслуживает durable due work и bounded inbox pages, возобновляя их
после restart/lifecycle/connectivity wakeup. Network admission/reconnect лишь
обновляет readiness; он не заменяет outbox drain, receive или receipt delivery.
Single-flight, cancellation, bounded concurrency/backoff и backpressure
обязательны. Push остаётся hint; без push гарантируется catch-up при следующем
разрешённом выполнении, а не фиксированная задержка во время OS suspension.

Наблюдаемые статусы имеют разные основания: локальный durable intent — queued;
verified Store receipt — stored; authenticated application receipt после durable
recipient materialization — delivered; отдельное разрешённое read событие — read.
Mailbox tombstone ACK разрешает удаление transport copy после durable receive;
он не является sender-visible application receipt. Receipt work и dedup должны
переживать crash без потери подтверждения или повторной материализации.

Bounded custody journals требуют завершённого lifecycle: exact pending/unknown
операции сохраняются для reconciliation; retirement/compaction не удаляет
необходимую replay protection. Увеличение capacity или grant lifetime не
заменяет этот контракт. До реализации недостающие expiry/successor/compaction
переходы замораживаются согласно S01
[единого плана](IMPLEMENTATION-PLAN-V1.md); этот раздел не вводит новые wire bytes.

## 4. Canonical application model

### 4.1 Идентификаторы

Новый протокол MUST использовать отдельные bounded binary types:

| Type | Назначение | Видимость |
| --- | --- | --- |
| `DeepAccountId` | стабильная публичная identity аккаунта | контактам |
| `DeepDeviceId` | identity конкретного авторизованного устройства | участникам нужного security context |
| `ConversationId` | локатор 1:1 или группы | только внутри E2EE и local DB |
| `SemanticMessageId` | CSPRNG 128+ bit ID одного application event | только внутри E2EE |
| `TransportAttemptId` | уникальная попытка конкретного adapter | соответствующему transport |
| `OuterDedupToken` | keyed derivation для transport-level idempotency | только соответствующему transport |

`TransportAttemptId` и `OuterDedupToken` MUST NOT быть равны
`SemanticMessageId`. Для каждой transport family они выводятся domain-separated
из device-local outbox secret и semantic ID. Это не позволяет двум операторам
простым сравнением связать один event, доставленный через разные transports.

### 4.2 Application events

Обязательный закрытый registry v1:

- `ContactHello`, `ContactAccept`, `ContactRouteUpdate`;
- `MessageCreate`, `MessageEdit`, `MessageDelete`;
- `ReactionSet`, `ReceiptDelivered`, `ReceiptRead`;
- `GroupProposal`, `GroupCommit`, `GroupApplicationMessage`;
- `AttachmentOffer`, `AttachmentCancel`;
- `CallOffer`, `CallAnswer`, `CallIceCandidate`, `CallReconnect`, `CallEnd`;
- `DeviceListUpdate`, `DeviceRevocation`.

Каждый event содержит protocol version, semantic ID, conversation ID, author
device ID, logical time/sequence, creation time, optional expiry и bounded
typed payload. Unknown version/type, duplicate field, invalid UTF-8, trailing
bytes, non-canonical ordering и превышение размера MUST reject before state
mutation. Wall-clock time не является единственным ordering authority.

Сообщения пользователя не подписываются transferable long-term account key.
Аутентификация идёт через текущую ratchet/MLS session и device credential.
Account/recovery signatures применяются только к device authorization,
recovery и governance records в отдельных domains.

### 4.3 Сроки жизни

Нужно различать четыре срока:

- `applicationExpiry`: после него event не показывается/не применяется;
- `transportRetention`: сколько adapter может хранить ciphertext;
- `outboxRetryUntil`: сколько sender сохраняет и повторяет logical item;
- `trustHistoryHorizon`: сколько времени client может проверить control-plane
  successor chain.

Они MUST NOT выводиться друг из друга. Долгий offline reconnect не обещает
получение сообщений старше transport retention.

## 5. Contact bootstrap без циклической зависимости

Постоянный transport-neutral `DID2` использует PQ-root identity и адресный
resolver capability согласно текущему CONTACT/Protocol registry. Он не имеет
срока действия и не раскрывает постоянный mailbox. Transport-specific locator
и credential commitment выводятся только по текущему DID2 contract; старый
DID1 public-key-only рецепт не переносится в новый runtime.
Resolver возвращает rotating canonical `DCB1`; отдельный `DIA1` используется
только для истекающих one-time приглашений. Bundle содержит:

- network/genesis ID и bundle version;
- `DeepAccountId` и current device-list commitment;
- account-authorized current device certificates;
- signed prekey bundle каждого принимающего устройства;
- случайный contact-scoped rendezvous descriptor или начальный набор deposit
  descriptors;
- supported crypto suite floor и application version floor;
- current-publication expiry и predecessor/rotation commitment;
- account/recovery-authorization signature в отдельном contact-invite domain.

Bundle MUST NOT содержать recovery material, private keys, reusable secret bearer
credential или полный глобальный topology. Один invite нельзя использовать для
неограниченного числа неизвестных senders: режимы `single-use`, `bounded-use`
и `public-address` имеют разные signed policy и rate limits.

После `ContactHello/Accept` стороны создают двунаправленные contact-scoped
route-update channels. Их единственная роль — доставить E2EE successor
descriptors, prekey/device-list updates и revocation hints. Старый deposit route
может истечь, не уничтожая контакт. Получатель хранит bounded precommitted
successors и долгоживущий update rendezvous на заявленный offline horizon.
Истечение всех current publication objects даёт `TemporarilyUnavailable`, но
не меняет и не инвалидирует DID2; после recovery-authorized republication тот
же ID снова разрешается.

Fresh install, возвращающееся устройство и recovered account — три разные
flows. Recovery не копирует device private key: создаётся новое устройство,
оно авторизуется recovery authority или существующим устройством, а затем
получает разрешённый history snapshot по отдельному E2EE device-transfer
каналу.

## 6. Cryptographic engines

### 6.1 1:1 и multi-device

Целевая 1:1 схема MUST предоставлять асинхронное начало, forward secrecy,
post-compromise security, out-of-order window, skipped-key bounds, per-device
sessions и atomic one-time-prekey consumption. Базовая модель — PQXDH-class
hybrid AKE и Double/Triple-Ratchet-class session согласно принятому crypto
draft; новая собственная ratchet construction запрещена без отдельной
спецификации, vectors и внешнего аудита.

Logical send fan-out выполняется на все текущие устройства получателя и на
остальные собственные устройства sender. Один частичный device failure не
отменяет durable результаты остальных. Device-list continuity и revocation
проверяются перед созданием новых sessions; revoked device не получает новый
ciphertext.

В качестве reference можно использовать спецификации Signal
[PQXDH](https://signal.org/docs/specifications/pqxdh/),
[Double Ratchet](https://signal.org/docs/specifications/doubleratchet/) и
[Sesame](https://signal.org/docs/specifications/sesame/). Прямое включение
`signalapp/libsignal` не считается автоматически принятым: upstream прямо
называет внешнее использование unsupported, API нестабильным, а лицензия —
AGPL-3.0. Нужны license review, pinned fork/version, cross-platform FFI gate и
независимый audit.

### 6.2 Groups

V1 group engine — `DeepSmallGroupV1`: owner-sequenced membership state и
pairwise ratcheted fan-out на все текущие devices участников. Он переиспользует
проверенные 1:1 device sessions, не вводит общий долгоживущий group decryption
key и уменьшает объём собственной криптографии перед первым релизом.

Каждый `GroupCommit` MUST содержать group ID, monotonic epoch, exact predecessor
commit hash, canonical ordered member/device set, roles, proposal hashes,
history policy, expiry и owner-device authentication. Правила:

- только current owner device может выпустить следующий commit;
- admins создают signed proposals, но не конкурирующие commits;
- ровно один successor допускается для `(groupId, epoch, predecessorHash)`;
  другой authenticated successor — fork/security error;
- member/device removal создаёт новый epoch; future fan-out исключает удалённые
  devices до отправки следующего application event;
- application event связан с exact group commit hash и epoch;
- losing/stale client запрашивает verified successor chain или rejoin package,
  а не выбирает состояние по arrival order;
- новый member не получает pre-join history по умолчанию;
- один logical group event имеет один semantic ID, но отдельный ratcheted
  ciphertext на каждое target device;
- delivery adapter принимает весь bounded target set одной logical batch и не
  превращает частичный fan-out в несколько пользовательских сообщений.

Это не MLS и не должно так называться. Размер V1 ограничен release scope.
Масштабируемый successor — MLS 1.0
([RFC 9420](https://www.rfc-editor.org/rfc/rfc9420.html)) с Deep credentials и
Delivery Service binding. Переход меняет group crypto profile/epoch, но не
application event registry, semantic IDs, outbox, attachments или transport
adapters. Предпочтительный будущий candidate —
[OpenMLS](https://github.com/openmls/openmls) за RFC 9420 compatibility и MIT
license; его native mobile targets всё равно потребуют pinned reproducible
build, narrow ABI, fuzz/interop, storage/zeroization review и physical evidence.

## 7. Target transport contracts

Ниже указана семантика будущих interfaces, а не разрешение добавить их без
protocol types и tests.

```csharp
public interface IMessageDeliveryTransport
{
    TransportId Id { get; }
    ValueTask<VerifiedTransportCapabilities> GetCapabilitiesAsync(
        TransportContext context, CancellationToken cancellationToken);
    ValueTask<PreparedTransportAttempt> PrepareAsync(
        LogicalDelivery delivery, TransportBinding binding,
        CancellationToken cancellationToken);
    ValueTask<DispatchResult> DispatchAsync(
        PreparedTransportAttempt attempt, CancellationToken cancellationToken);
    ValueTask<ReconcileResult> ReconcileAsync(
        PreparedTransportAttempt attempt, CancellationToken cancellationToken);
    IAsyncEnumerable<ReceivedCiphertext> ReceiveAsync(
        ReceiveCursor cursor, CancellationToken cancellationToken);
    ValueTask<AckResult> AcknowledgeAsync(
        ReceivedCiphertext item, CancellationToken cancellationToken);
}

public interface ITransportBindingProvider
{
    ValueTask<VerifiedTransportBindingSet> ResolveAsync(
        DeliveryTarget target, RequiredCapabilities required,
        CancellationToken cancellationToken);
}

public interface IAttachmentBlobTransport { /* encrypted chunks only */ }
public interface ICallMediaPathProvider { /* ICE/relay paths, never signaling semantics */ }
public interface IPushHintTransport { /* opaque wake hints only */ }
```

`VerifiedTransportCapabilities` — sealed value, полученное из signed deployment
profile и runtime attestation, а не произвольные adapter booleans. Минимальные
поля:

| Capability | Значение |
| --- | --- |
| `DeliveryModel` | `LiveDuplex`, `AsyncMailbox`, `StoreCarryForward` |
| `Ownership` | `OfficialManaged`, `UserManaged`, `PeerOwned` |
| `PrivacyPath` | `None`, `Relayed`, `ExactThreeHop` |
| `CarrierClass` | `DirectTls`, `MaskedTcp443`, `MaskedUdp443`, `LocalRadio` |
| `ReceiptLevel` | `Accepted`, `Durable`, `RecipientAck` bitset |
| `Ordering` | `None`, `PerBinding` |
| `MaxCiphertextBytes` | bounded positive integer |
| `Retention` | min/max advertised, not application promise |
| `SupportsAttachments` | inline/blob/chunk modes |
| `SupportsCallSignaling` | yes/no |
| `SupportsRealtimeMedia` | direct/relay modes |
| `RequiresBothPeersOnline` | yes/no |
| `ExposesPeerIp` | to peer/entry/relay bitset |
| `CostClass` | free/metered/user-operated |

Capability downgrade below conversation policy MUST return `Unavailable`, not
silently choose another path. Unknown capabilities fail closed.

## 8. Logical outbox and delivery semantics

### 8.1 State machine

```text
Prepared
  -> Dispatching
  -> Accepted       (adapter accepted request)
  -> Durable        (ciphertext durably stored/relayed where profile supports it)
  -> RecipientAcked (recipient device authenticated the semantic event)
  -> Expired

Any network exit after possible forwarding -> OutcomeUnknown -> Reconcile
```

Transitions are monotonic and atomic. Every state stores authenticated bounded
evidence. UI labels MUST distinguish `queued`, `sent/accepted`, `delivered to a
device`, `read` and `expired`; `Accepted` не называется delivered.

### 8.2 Retry and failover

- Retry одного adapter MUST повторять byte-identical prepared attempt, пока его
  протокол этого требует.
- До подтверждённого forwarding (`BeforeForward`) policy MAY создать новую
  attempt на другом binding того же разрешённого profile.
- После `OutcomeUnknown` сначала вызывается `ReconcileAsync`. Если transport не
  умеет reconciliation, MAY быть создана новая attempt с тем же semantic event;
  получатель обязан дедуплицировать её после E2EE authentication.
- Переход между XPoint/on-prem/P2P/mesh выполняется только если conversation
  policy заранее разрешает оба transports. По умолчанию policy pinned.
- Успех одной attempt не удаляет evidence другой до завершения bounded
  reconciliation window.
- Отмена UI не означает, что уже отправленный ciphertext отозван.

### 8.3 Receive and dedup

Порядок обработки: bounded outer parse → transport authentication/replay check
→ E2EE open → device/group authentication → semantic dedup → transactional
state apply + inbox cursor/ACK.

Коммит одного только pre-key/ratchet state MUST NOT разрешать transport ACK:
аутентифицированный application event должен быть либо атомарно сохранён
в inbox вместе с переходом, либо защищённо staged для точного восстановления
после crash до удаления транспортной копии. Повторный ciphertext после уже
сохранённого ratchet-перехода без recoverable application event не считается
успешной материализацией. ACK выдаётся лишь после durable semantic dedup и
доступности event для чтения клиентом.

Semantic dedup key: `(protocolGeneration, conversationId, semanticMessageId,
authorDeviceId)`. Одинаковый ключ с другими authenticated plaintext bytes —
permanent fork/security error, а не duplicate. Tombstone хранится не меньше
максимума application expiry, outbox retry window и transport retention плюс
clock-skew margin.

Дубликаты MAY приходить через разные transports, после crash или partition
merge. Пользователь видит один event, но transport-level receipts сохраняются
для диагностики в sanitized виде.

### 8.4 Owned attempt settlement, renewal and retirement

Принято [DR-0084](../survival-program/decisions/DR-0084-owned-delivery-settlement-and-retirement.md).
Эти таблицы задают S01 semantic contract, не фактическую runtime activation.
Account owner выполняет переходы под actual lease; UI/adapter не передают trusted
outcome, counter, replacement route/grant или deletion permission. Required
deadlines и shape audit/dedup tombstones берутся только из
[retention owner](RETENTION-AND-RECOVERY-V1.md), без новых чисел здесь.

**Независимые состояния.** Logical item хранит immutable event identity, target
device set, authored sequence и effective retry deadline. Per-device encrypted
item хранит уже committed exact ciphertext и ratchet transition. Attempt хранит
свой unique ID, exact route/grant/body/MAU/counter, original deadlines и outcome.
Одно logical item может иметь последовательные attempts; успешная доставка
одному устройству не утверждает успех остальных. Stored, delivered и read —
монотонные факты с разными authenticated evidence, не значения одного boolean.

#### 8.4.1 Send/attempt transitions

| Вход → переход | Обязательные evidence и durable effect | Retry / expiry / cancel | Crash/reopen obligation |
| --- | --- | --- | --- |
| Local intent → encrypted item | Authenticated local custody; independently current own/peer/consent для encryption; один atomic ratchet/ciphertext commit | Network unavailable сохраняет intent; expired/revoked target не получает encryption | До commit нет transport attempt; после commit exact ciphertext восстанавливается без второго ratchet step |
| Encrypted item → pending descriptor | Current route/grant и original logical retry deadline; preflight mandatory roots/capacity; bind exact ciphertext/route/grant/body до SQL/signing | Backpressure не удаляет queued item и не приобретает ненужный grant; existing attempt не получает новый lifetime | Pending read-back предшествует SQL; missing/foreign root rejects, не lazy initialize |
| Pending descriptor → prepared | Atomic SQL exact MAU/counter; independent protected counter floor; exact read-back и protected prepared commitment | Возобновить SQL commit, не подписывать второй запрос; counter нельзя получить из очищенного списка | Fault до/после SQL и protected CAS восстанавливает только один original request |
| Prepared → dispatch reservation | Current full authority/holder/selected path/revocation; durable bounded retry lease перед callback | Доказанный BeforeForward допускает policy-controlled successor; остальные выходы после possible forwarding — unknown | Сам факт reservation не доказывает forwarding или non-forwarding; после reopen не сбрасывать reservation |
| Dispatch → unknown | Timeout/cancel/invalid reply после possible forwarding; сохранить original exact attempt и uncertainty | Сначала exact reconciliation, пока independently current admission и original window разрешают его; не remint MAU | Lost response/partial commit/restart не превращаются в successful empty или новый logical send |
| Attempt → stored | Verified two-replica durable receipt, exact request/member/key binding и final current recheck; protected completion read-back | Cache/replay хранит тот же evidence; это не recipient delivery | Fault receipt→SQL→protected completion повторяет adoption, не remote Store и не ratchet encryption |
| Recipient materialized → application receipt due | Atomic authenticated semantic dedup + recoverable event + persistent receipt obligation | Transport ACK только после materialization; AppAck идёт отдельным E2EE event | Crash после receive не теряет receipt work и не разрешает повторную материализацию |
| Authenticated application receipt → delivered/read | Exact logical/conversation/author/target-device binding; read отдельно от delivered; policy и current session authentication | Duplicate idempotent; receipt не создаёт unknown event и не меняет payload/history | Receipt apply/projection и due-work completion атомарны либо защищённо recoverable |
| Attempt expired → closed outcome | Independent protected time proves original request no longer admissible; retain stored evidence либо explicit unresolved outcome | Expiry не доказывает «не записано»; old exact request больше не dispatches | Reopen сохраняет closed-unknown, не возвращает prepared и не продлевает grant/window |
| Closed/before-forward attempt → successor attempt | First reconcile as far as the original protocol permits; logical deadline/policy ещё разрешает send; independently verified replacement closure | Новый attempt ID и new grant/request; **тот же committed ciphertext и semantic event**, без encryption/signing старой attempt; bounded attempts/backoff | Durable predecessor/successor link до callback; partial successor adoption не теряет original uncertainty |
| Logical retry deadline / user cancel → stopped work | Protected terminal metadata; уничтожение outbox-only payload/key по retention owner; не удалять отдельную local history как побочный эффект | Cancel не recall; remote accepted copy может существовать; Store/Delivered facts не регрессируют | Никакой повторный wake/reopen не создаёт новую attempt для stopped work |

Статус cancellation/expired retry относится к работе sender, а не к отмене уже
аутентифицированного stored/delivered fact. Success terminal condition logical
outbox MUST явно следовать conversation policy; Store receipt не называется
Delivered и не очищает outstanding application-receipt obligation.

#### 8.4.2 Grant and route transitions

Shared local serialization и internal acquisition/pointer API принадлежат
[owned grant custody producer](../../deep-client-shared/docs/architecture/owned-mailbox-grant-custody.md).
Это один current local reader; его layout не активирует renewal/retirement и
не заменяет следующие semantic obligations или историческую authority.

| Вход → переход | Durable ownership / authority | Retry / expiry / cancel | Crash/reopen obligation |
| --- | --- | --- | --- |
| New acquisition → pending XMG | Independent reachability-direction holder, unique exact request; actual route/locator/domain и current PMA2; protected CAS/read-back before issuer callback | Capacity rejects до issuance; никаких account/device/root signing substitutes | Seed/request сохраняются exact; callback/root mutation rejects winner adoption |
| Pending XMG → winner | Fresh independently verified exact XMC2/MCG3 и complete current interval; one immutable winner per acquisition | Lost reply остаётся pending; original XMG window не renews | Reply receipt→winner CAS interruption возобновляет тот же request/result, не новую выдачу |
| Acquisition window expired → unresolved acquisition | Retain exact request и known signed upper bound возможного issued grant; original request больше не допускается | XMG expiry **не** доказывает отсутствие более долгого remotely issued grant; renewal — отдельная acquisition | До authenticated settlement/irreversible namespace retirement нельзя освобождать его dependencies как BeforeForward |
| Winner active → renewed successor | Current issuer/topology/route policy; new acquisition identity и serial; old winner immutable | Same reachability holder допустим; changed reachability получает отдельное owned scope; no synthetic next-epoch grant | Current pointer меняется только после successor read-back; old attempts сохраняют exact old winner |
| Route current → verified successor | Existing signed predecessor/current continuity, fresh own/peer authority и proactive policy deadline | Incomplete successor не заменяет current; expired current не становится fresh от нового local clock | Stage successor и handover до pointer adoption; нельзя менять unknown attempt bytes |
| Old route/grant → retained dependencies | Outstanding Store/Retrieve/ACK и accepted-object horizon независимы от grant admission lifetime | Short grant expiry не разрешает удалять remote object, owner capability или единственный retrieval path | Проверить retained-route receive/ACK или authenticated migration до удаления единственного пути |
| Retained scope → retired | Все зависимости settled/explicitly closed; irreversibly inadmissible old replay namespace proven by current signed policy + protected floors | Neither fresh grant, cache miss, local UTC, revocation hint nor capacity alone authorizes retirement | Fault до/после retirement сохраняет fences; no holder/key/nonce regeneration by reader |

Grant refresh MUST начинаться до expiry по действующей signed policy. Recovery
current time/network/issuer successors не может требовать предварительного
успеха expired data-plane attempt. Distribution bytes остаются untrusted до
independent verification; bootstrap не переносит recipient metadata на Registry.

**Expired/unknown acquisition: исходная граница возможной выдачи.** До первого
issuer callback owner MUST защищённо сохранить exact original XMG1, holder
custody и immutable evidence для conservative upper bound возможного MCG3.
Evidence включает independently verified original PMA2, связанную с exact PMT2
этого request, и original signed route closure. Их protected references должны
восстанавливаться в exact bytes; один hash без retained producer не достаточен.
Bound — минимум signed expiry original PMA2 и всех original route records,
ограничивающих выдачу по
[CONTACT-RESOLVER §3.7](CONTACT-RESOLVER-V1.md#37-privacy-routed-mailbox-grant-acquisition-xmg1--xmc2).
Это conservative ceiling, не срок действительного полученного grant. Более
короткие issuer/effective-time limits могут ограничивать реальную выдачу, но
unsigned effective-expiry, локальное UTC и XMG/XMC deadline не уменьшают ceiling.
Fresh policy/route не заменяют исходные evidence и не пересчитывают старый bound.
Missing/foreign/rolled-back evidence fails closed; reader не достраивает его.

Истечение original acquisition window подтверждается independently authenticated
protected time: lower bound достиг original XMG expiry. Upper bound, пересекающий
expiry, уже запрещает обычный dispatch, но не доказывает этот terminal transition.
Owner сохраняет explicit unresolved disposition посредством protected CAS и
exact read-back; он не утверждает BeforeForward, non-issuance или non-delivery.
Callback timeout/cancel/crash сохраняет possible issuance. Неподписанный failure
XMC2, `UnknownOrExpired`, HTTP error или cache miss не являются authenticated
отрицательным доказательством. После такого закрытия original XMG не dispatches,
не re-signs и не re-windows; successor остаётся отдельной acquisition с retained
predecessor uncertainty, не перезаписью старой строки.

Поздний exact successful XMC2 может стать usable winner только через existing
independent retained-success verification, пока полный current grant/issuer/route
interval допускает его. Expired request restoration для этого не используется;
неподдерживаемая historical verification оставляет outcome unresolved, без
synthetic winner или нового запроса. До/после CAS crash/reopen сохраняет один
original outcome и не повторяет issuer callback для закрытого acquisition.

Даже достижение possible-grant ceiling не доказывает отсутствия выданного grant
и само по себе не разрешает retirement replay floors или accepted-object paths.
Retirement отдельно требует irreversible exclusion exact old replay namespace
под independently current signed policy и actual protected floors, плюс закрытие
всех зависимостей по §8.4.3/8.4.4. Current grant, issuer rollover, freshness expiry
или отсутствие serial в свежем snapshot не заменяют это доказательство. Пока
closed producer/consumer такой fence не квалифицирован, compaction сохраняет
dependencies и применяет bounded backpressure. Эти требования не активируют
runtime, новый local reader или публичную verification API; их bounded local
format/API и fault fixtures остаются частью незавершённого S01.

#### 8.4.3 Compaction and boundedness

Перед освобождением working-set slot owner MUST сохранить отдельные protected
floors: next authored sequence для `(conversation, author device)` и highest
reserved counter для каждого live grant/operation replay scope. Actual mailbox
replay namespace задаётся current verifier (issuer key, serial, epoch,
generation, operation), не holder key alone. A retained exact pending request
может повторять свой reserved counter, но новый запрос не получает его вновь.
Floors, scope enrollment и revisions не выводятся из количества retained rows.

| Шаг | Durable requirement | Fault/reopen rule |
| --- | --- | --- |
| Select compaction batch | Only settled or explicitly closed work; authenticated terminal evidence, exact dependencies and time; pending/unknown work не evicts ради slots | Revalidate under held lease; stale selection does not authorize mutation |
| Protect plan/floors | Bound account/network/instance, exact predecessor root, new floors, disposition и affected working rows; persist/read-back before SQL cleanup | Interrupted plan owns recovery; missing/mismatched plan fails closed, не guess по SQL count |
| SQL cleanup | One transaction preserves counters/dedup/receipt work/local history while deleting only authorized outbox data; no new signature/encryption | Retry exact plan; deleted SQL cannot be rehydrated from obsolete payload after terminal deletion |
| Adopt compacted root | Protected CAS/read-back retains independent floors, remaining exact work and required terminal metadata | Before/after CAS interruption either resumes same plan or observes exact adopted root; no empty-journal repair |
| Retire plan / floors | Exact SQL/root agreement first; floor removal requires proven permanently inadmissible namespace, not just one grant's expiry | Cold replay, SQL rollback, expired authority and issuer rotation cannot resurrect old counters or events |
| Any capacity exhausted | Bounded backpressure before network acquisition/new encryption; retry existing work and process eligible cleanup | Never raise limits or discard unexpired audit/dedup/unknown work to make a test pass |

Audit tombstones MUST contain no payload/key/plaintext-derived content; exact
reconciliation material is active custody, not disguised audit data. Authenticated
semantic dedup follows its own retention. Compaction MUST qualify successful,
pending, rejected, unknown, expired and cancelled work beyond the existing
512-send/128-grant boundaries, including distinct scopes, cold restart and each
handover fault. Those counts are current implementation boundaries, not new
product limits or permission for an unbounded floor/tombstone collection.

#### 8.4.4 Object lifetime integration fence

Admission, original attempt/request window, logical retry deadline and accepted
object expiry MUST remain independent. A short grant neither grants a longer
dispatch window nor shortens an accepted object's signed retention. A refreshed
grant cannot extend an old exact body's expiry. Codec/producer/node storage,
replay/tombstone retention and retained-route retrieval/ACK MUST agree before
activating the retention claim. Current-only epoch credentials are not historic
read permission; unavailable old ciphertext is surfaced as a retention gap,
never a successful empty catch-up. No generic trust flag or expired-route bypass
is introduced by this section.

## 9. Selection, routing and decentralization

Application layer формирует `RequiredCapabilities`, а policy выбирает profile и
binding. Adapter не выбирает сам себя.

Для official XPoint:

- клиент получает signed global roster/topology и сам проверяет route;
- Registry/mirror не выбирает готовый per-user route; client-side selector
  строит его из eligible roster и locally blinded selection input;
- entry guard сохраняется между запусками, пока доступен и не revoked;
- middle/exit выбираются с diversity constraints;
- RouterId, traffic-encryption epoch key, origin и carrier descriptor связаны
  одной signed topology lineage;
- долгосрочный node identity key отделён от короткоживущего traffic-decryption
  key; retired traffic keys уничтожаются после bounded overlap;
- public routing/storage nodes и anti-censorship bridges — разные роли. Полный
  bridge pool не публикуется в APK/roster;
- bootstrap имеет embedded cache и несколько независимо размещённых signed
  distribution channels; Reality — один carrier, не определение XPoint.

Session служит reference по трёх-hop onion requests, recipient swarms,
persistent guards и client-side node selection, но не wire dependency. Его
актуальная архитектура также отправляет call signaling как обычные
onion-routed messages и не onion-route media:
[Session architecture](https://github.com/session-foundation/session-desktop/blob/dev/ARCHITECTURE.md).
От SimpleX принимается полезный принцип: transport передаёт opaque bytes, а
контакты/группы находятся выше; per-contact queues не обязаны раскрывать
глобальный user identifier:
[SMP v20](https://github.com/simplex-chat/simplexmq/blob/stable/protocol/simplex-messaging.md).

## 10. Attachments

`AttachmentManifestV1` находится внутри E2EE event и содержит plaintext size,
media metadata, ordered encrypted-chunk hashes, content key material, expiry и
один или несколько transport-specific opaque locators. Filename/MIME/preview
не выходят из E2EE.

- Каждый chunk шифруется независимо AEAD с ключом, производным от случайного
  attachment root и chunk index; nonce reuse запрещён.
- Storage адресуется ciphertext hash/opaque capability и не знает conversation.
- Resume проверяет каждый chunk до записи decrypted bytes.
- XPoint profile использует masked blob carrier; небольшой payload MAY идти
  inline, только если capability/limit это разрешают.
- On-prem заменяет locator/provider, не manifest semantics.
- P2P/mesh передают те же encrypted chunks; partial transfer переживает смену
  adapter.
- CDN/object store видит размер и timing; size buckets/padding являются
  отдельной privacy option с измеряемой стоимостью.

## 11. Push

Push payload содержит только version, random subscription handle, encrypted
opaque wake hint и expiry. Provider не получает DeepAccountId, sender,
conversation, message type или plaintext preview. Получив hint, клиент запускает
обычный `ReceiveAsync`; push не подтверждает delivery.

Без push foreground/resume polling MUST полностью восстанавливать состояние.
Для Android background ограничения могут увеличивать latency и честно
отражаются в profile SLO. On-prem MAY использовать UnifiedPush/WebPush; mesh
обычно не имеет push capability.

## 12. Calls

Этот документ владеет только seam: signaling идёт как DMC2 через
`IMessageDeliveryTransport`, а media выбирается отдельно через
`ICallMediaPathProvider`; transport switch не экспортирует ratchet keys и не
меняет call identity. Exact state/KDF/privacy profiles принадлежат
[`CALL-SESSION-V1.md`](CALL-SESSION-V1.md), carrier wire —
[`CIRCUMVENTION-CARRIERS-V1.md`](CIRCUMVENTION-CARRIERS-V1.md), release SLO —
[`V1-RELEASE-SCOPE.md`](V1-RELEASE-SCOPE.md). Adapter MUST surface unavailable
media capability instead of silently selecting another privacy profile.

## 13. Adapter conformance

Новый adapter принимается только при наличии общего black-box contract suite:

- capability authenticity/downgrade rejection;
- prepare-before-network and byte-stable retry;
- before-forward, accepted, durable, recipient-ACK и outcome-unknown cases;
- crash на каждой state transition и cold restart;
- duplicate across same/different adapters;
- changed bytes under same semantic ID produce fork error;
- expiry, cancellation and bounded resource exhaustion;
- no plaintext/identity in adapter logs/evidence;
- attachment partial resume and corrupt chunk;
- call signaling replay/staleness;
- profile isolation: запрещённый adapter не вызывается.

Mesh дополнительно проходит three-device physical relay, loop/flood limits,
partition merge и relay disappearance. On-prem проходит clean install без
Deep-operated DNS/Registry/billing/signer. Эти suites проектируются сейчас, но
их runtime реализация не входит в первый release.

## 14. Implementation slicing for agents

Единственный dependency DAG и agent-sized slicing находится в
[`IMPLEMENTATION-PLAN-V1.md`](IMPLEMENTATION-PLAN-V1.md). Для этого документа
нормативны только adapter interfaces и conformance suite выше; parallel
перечень work packages здесь не поддерживается.

## 15. Границы гарантий

Эта архитектура защищает content и позволяет скрыть endpoint от отдельных
relays. Она сама по себе не скрывает timing/volume, proximity в BLE/Wi-Fi,
recipient IP при будущем `DirectPeer`, факт использования приложения от global observer,
malicious endpoint, compromised device или denial/withholding. Padding,
jitter, batching, guards и bridge rotation уменьшают отдельные риски, но не
создают абсолютную анонимность или unblockability.
