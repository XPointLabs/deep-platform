# Transport-neutral messaging architecture

Статус: **целевая нормативная архитектура для clean-break реализации**

Актуально: 2026-08-30

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
- не переопределяет уже принятые canonical MAU2 и privacy-routing bytes;
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

```text
UI / conversation commands
          |
          v
Canonical application events
          |
          v
1:1 ratchet or MLS group engine  <-- owns E2EE state, epochs, replay window
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
       MAU2/onion     MAU2       live peer link   store/carry/forward
          |
          v
Masked carrier / link / radio / local network
```

`deep-protocol` владеет canonical records, validation, cryptographic domains и
test vectors. `deep-client-shared` владеет portable orchestration и durable
state. Platform project владеет secure storage, background execution, radios,
WebRTC и carrier process lifecycle. Adapter repositories не авторят
application events и не изменяют crypto state напрямую.

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

Deep ID сам по себе идентифицирует account, но не обязан раскрывать постоянный
mailbox. Для первого контакта используется canonical `DeepContactBundleV1`,
передаваемый text/QR/file/deep-link через любой канал. Bundle содержит:

- network/genesis ID и bundle version;
- `DeepAccountId` и current device-list commitment;
- account-authorized current device certificates;
- signed prekey bundle каждого принимающего устройства;
- случайный contact-scoped rendezvous descriptor или начальный набор deposit
  descriptors;
- supported crypto suite floor и application version floor;
- expiry, one-time invitation nonce и predecessor/rotation commitment;
- account/recovery-authorization signature в отдельном contact-invite domain.

Bundle MUST NOT содержать recovery material, private keys, reusable bearer
credential или полный глобальный topology. Один invite нельзя использовать для
неограниченного числа неизвестных senders: режимы `single-use`, `bounded-use`
и `public-address` имеют разные signed policy и rate limits.

После `ContactHello/Accept` стороны создают двунаправленные contact-scoped
route-update channels. Их единственная роль — доставить E2EE successor
descriptors, prekey/device-list updates и revocation hints. Старый deposit route
может истечь, не уничтожая контакт. Получатель хранит bounded precommitted
successors и долгоживущий update rendezvous на заявленный offline horizon.

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

Semantic dedup key: `(protocolGeneration, conversationId, semanticMessageId,
authorDeviceId)`. Одинаковый ключ с другими authenticated plaintext bytes —
permanent fork/security error, а не duplicate. Tombstone хранится не меньше
максимума application expiry, outbox retry window и transport retention плюс
clock-skew margin.

Дубликаты MAY приходить через разные transports, после crash или partition
merge. Пользователь видит один event, но transport-level receipts сохраняются
для диагностики в sanitized виде.

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

Call state machine и все signaling events проходят через тот же 1:1 E2EE и
logical outbox. Отдельный public Registry signaling endpoint не является
обязательной message semantics и в целевой композиции не нужен для official
calls.

Media policy выбирается независимо:

1. `DirectFast` (`DirectIce`) — минимальная latency, но peers могут узнать IP;
   только по явной privacy policy и не в official V1.
2. `RelayPrivacy` (`RelayOnly`) — рекомендуемый privacy default: WebRTC DTLS-SRTP через
   короткоживущие TURN credentials, recipient не видит client IP.
3. `RestrictedNetwork` (`MaskedRelay`) — relay endpoint достигается через
   rotating signed carrier catalog; `masque-h3-v1` является предпочтительным
   UDP/443 path, `capsule-over-masked-tcp-v1` — обязательным TCP/443 fallback.
   При блокировке UDP используется masked TCP, а не direct downgrade.

TURN/relay видит IP, время и объём, но не media plaintext. Три-hop onion для RTP
не применяется из-за latency и bandwidth amplification. Абсолютная
«невидимость для блокировок» не обещается; release gate доказывает конкретные
DNS/SNI/IP/UDP blocking scenarios. MASQUE CONNECT-UDP
([RFC 9298](https://www.rfc-editor.org/rfc/rfc9298.html)) является допустимым
будущим media carrier, но не единственным из-за блокируемости UDP.

Store-carry-forward mesh поддерживает call signaling, но не заявляет realtime
media без live end-to-end path. UI показывает `call unavailable on current
path`, а не скрыто переключает profile.

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

Работу следует делить по compile-time boundaries:

1. canonical IDs/events + hostile vectors;
2. device identity/prekey store + 1:1 crypto engine;
3. `DeepSmallGroupV1` state/hash-chain and bounded fan-out;
4. logical outbox/inbox v1 store and crash matrix;
5. adapter contracts + in-memory conformance fixture;
6. XPoint MAU2 adapter;
7. carrier catalog/Reality adapter and censorship harness;
8. contact bootstrap/update rendezvous;
9. attachment chunk adapter;
10. signaling over message plane + media providers;
11. push hint adapter;
12. physical Android/Windows matrix;
13. post-V1 OpenMLS/native-ABI spike for the scalable group successor.

Каждый slice имеет один owner repository, canonical vectors до consumers и не
добавляет временный production fallback. Исходный код Session/SimpleX/Signal
можно использовать как reference или dependency только после license/SBOM,
maintenance, platform и security review; copy-paste криптографии запрещён.

## 15. Границы гарантий

Эта архитектура защищает content и позволяет скрыть endpoint от отдельных
relays. Она сама по себе не скрывает timing/volume, proximity в BLE/Wi-Fi,
recipient IP при DirectIce, факт использования приложения от global observer,
malicious endpoint, compromised device или denial/withholding. Padding,
jitter, batching, guards и bridge rotation уменьшают отдельные риски, но не
создают абсолютную анонимность или unblockability.
