# Deep/XPoint threat model v1

Статус: **нормативный для первого публичного релиза**  
Дата: 30 августа 2026 года.

## 1. Защищаемые свойства

1. Содержимое сообщений, вложений и call signaling доступно только
   авторизованным устройствам участников.
2. Компрометация текущего conversation state не раскрывает удалённые прошлые
   message keys и после успешного ratchet/rekey перестаёт раскрывать будущие.
3. Один не вступивший в сговор XNode не узнаёт одновременно сетевой адрес
   клиента и mailbox назначения.
4. XNode, Registry, bridge, push, file и TURN не получают recovery phrase,
   plaintext, conversation keys или полномочия выдавать себя за устройство.
5. Цензор не может заблокировать весь поддерживаемый text/control path одним
   DNS/SNI/path rule. Блокировка всех известных IP остаётся возможной, поэтому
   используются неэнумеруемые/вращаемые bridges и несколько acquisition paths.
6. Потеря сети не блокирует локальное создание account, чтение локальной
   истории и постановку действий в durable outbox.
7. Rollback, same-generation fork, replay и suite downgrade обнаруживаются и
   fail closed до пользовательской мутации.

## 2. Противники

| Противник | Обязательная защита v1 | Не обещается v1 |
| --- | --- | --- |
| Пассивный ISP/локальный censor | отсутствие plaintext; masked carrier; скрытие обычного Deep HTTP/SNI; bounded traffic shaping | защита при блокировке всех destination IP |
| Активный censor | signed bootstrap; probe-resistant carrier; no direct downgrade; смена bridge/carrier | неотличимость от любого разрешённого приложения при неограниченном ML/DPI |
| Злонамеренный bridge/entry | onion frame не раскрывает mailbox/plaintext; replay/rate bounds | entry видит IP клиента и время соединения |
| Один злонамеренный XNode | не видит одновременно source и destination; не может изменить E2EE | доступные ему hop metadata и локальная доступность |
| Сговор entry+exit | E2EE сохраняется | timing/volume unlinkability не гарантируется |
| Global passive observer | E2EE сохраняется | глобальная traffic-correlation resistance |
| Компрометация Registry/directory | signed/transparent state не позволяет подменить identity/topology незаметно | withholding, selective denial и наблюдение запросов без oblivious access |
| Компрометация bootstrap-оператора D0 | изоляция witness keys/processes ограничивает одиночный host/credential fault | одновременная компрометация/принуждение единственного оператора может связать metadata и выпустить threshold split view; operator independence начинается только с D2 |
| Компрометация mailbox/file/push | ciphertext и opaque capabilities; bounded replay | availability и удаление сохранённых blobs |
| Компрометация TURN/media relay | SRTP/WebRTC E2EE; relay не получает chat keys | relay видит call endpoints, время и объём |
| Компрометация одного device | revoke/rekey и PCS ограничивают будущий ущерб | plaintext и активный state этого устройства до revoke/rekey |
| Компрометация recovery phrase | нет доступа к другим локальным данным без восстановления | account recovery authority и permanent DID1 address key считаются потерянными; безопасно сохранить тот же публичный ID после компрометации невозможно |
| Quantum store-now/decrypt-later | hybrid suite защищает handshake при стойкости хотя бы одной ветви и combiner | безопасность при одновременном взломе обеих ветвей/implementation |

## 3. Metadata boundary

Ни один компонент не должен получать больше минимально необходимого:

- bridge видит клиентский IP и первый router, но не mailbox;
- entry router видит bridge/клиента и следующий router;
- middle router видит соседние routers;
- exit видит blinded mailbox operation, но не IP клиента;
- storage replica видит opaque mailbox и ciphertext retention;
- Registry видит запросы topology/bootstrap, но не contact graph;
- push provider получает случайный installation channel и opaque wake-up;
- file service получает opaque blob capability, размерный класс и retention;
- TURN видит участников call на сетевом уровне, но не SRTP plaintext.

Стабильный `DeepAccountId` не передаётся XNode/bridge/storage как routing key.
Contact rendezvous, mailbox placement и transport credentials являются
раздельными вращаемыми capabilities. Логи не содержат account/contact/mailbox
IDs, route descriptors, prekey IDs, call SDP/ICE, payload hashes или стабильные
device fingerprints.

Account-directory threshold является отдельной metadata boundary: при выпуске
ADC1/XPA1 он проверяет DID1 hash/address-key ↔ account binding, но не получает
resolver read capability; запрос приходит
только через OHTTP/XPoint и не передаёт mapping invite/mailbox storage. Сговор
directory threshold с глобальным наблюдателем остаётся явным non-claim. Public
mirrors получают только roots/opaque transition commitments, не leaf-key index.
Holder конкретного DID1 при активном resolve может наблюдать generation/update
timing этого DID; это принятая contact-local metadata surface, а не пассивно
энумерируемый публичный account log.

## 4. Traffic analysis

V1 применяет ограниченную, измеримую защиту:

- канонические size buckets для message/control frames;
- раздельные attachment classes без plaintext имени/MIME;
- jittered foreground polling и bounded batching;
- connection reuse без смешивания разных privacy identities в один внешний
  credential;
- optional low-rate cover polling только при питании/политике пользователя.

Cover traffic, mix delays и padding расходуют latency, bandwidth и battery.
Поэтому v1 не заявляет Loopix/Tor-equivalent или global-observer anonymity.

## 5. Censorship claim

Разрешённая формулировка:

> XPoint поддерживает подписанные вращаемые точки доступа и несколько
> маскированных transport carriers, проверенные против перечисленных классов
> DNS, SNI, path, active-probe, TCP/UDP и известных-IP блокировок.

Запрещены абсолютные формулировки «невозможно заблокировать», «полностью
неотличим» и «анонимность гарантирована». Release evidence обязано указывать
страну/сеть, дату, carrier, censor action и observed result.

## 6. Calls

Call signaling является обычным ratcheted E2EE control message и наследует
XPoint censorship policy. Media не проходит через трёх-hop mailbox onion path:
это дало бы непредсказуемую задержку и не соответствовало бы real-time SLA.

Профили media:

- `RelayOnly` — единственный official V1 profile: relay-only ICE, без раскрытия peer IP участникам;
- `DirectPeer` — зарезервированный будущий opt-in, peer IP раскрывается другому
  участнику; в official v1 запрещён;
- `NetworkCondition=Restricted` — `MaskedTcpCapsule` carrier из подписанного
  вращаемого media bridge catalog.

UI показывает фактический профиль. Нельзя молча перейти из relay-only в
direct. SRTP/DTLS verification, call identity binding, stale-offer rejection и
replay protection обязательны во всех профилях.

## 7. Offline и revocation

Свежая установка может проверить полный retained root lineage и актуальный
threshold-signed checkpoint, если доступен хотя бы один подписанный acquisition
path либо user import. Если все такие пути заблокированы, account всё равно
создаётся локально, но network state остаётся `Blocked/RecoveryRequired` без
mutation или direct/stale fallback. История trust roots и transparency
checkpoints хранится бессрочно; hot issuer private keys не сохраняются.

Длительный offline означает возможность безопасно восстановить trust и
продолжить account, а не бессрочное хранение всех сообщений. Retention каждого
типа данных задаётся отдельно и показывается пользователю. Revocation в
изолированной partition является eventual: документируется максимальное окно
stale trust, после получения подписанного revoke rollback запрещён.

## 8. Release security gates

- protocol vectors и independent implementations для критических transcripts;
- fuzzing каждого parser и hostile-size boundary;
- compromise/recovery тесты для device, prekey, router traffic key, bridge,
  Registry и TURN;
- APK/MSIX extraction test: embedded seeds не должны быть полным доступным
  bridge pool или account-linked credential;
- DNS/SNI/IP/path/active-probe/UDP-block tests без direct fallback;
- packet-capture classifier baseline для text, polling, attachment и call;
- независимые crypto/privacy и censorship-resistance reviews с P0/P1=0.
