# Deployment profiles and privacy guarantees

Статус: **нормативная продуктовая матрица**

Актуально: 2026-08-30

## 1. Правило профиля

Deployment profile определяет ownership, способ приобретения bindings,
доступные transports, privacy/censorship guarantees и release evidence. Он не
изменяет Deep account/device identity, application events, 1:1 ratchet, group
crypto/state engine, logical outbox или semantic dedup, определённые в
[`TRANSPORT-NEUTRAL-MESSAGING.md`](TRANSPORT-NEUTRAL-MESSAGING.md).

Profile выбирается явно пользователем или подписанной deployment policy.
Transport failure не меняет profile. Переход между official, on-prem и P2P не
является retry и требует отдельного consent/policy decision. UI всегда
показывает фактический profile и privacy-relevant path.

## 2. Профили

### 2.1 `OfficialXPoint3` — первый релиз

Минимум три доступных public routing nodes. Каждый mailbox operation проходит
ровно три onion hops:

```text
client -> persistent entry guard -> middle -> mailbox exit
```

Первичный и резервный route MAY пересекаться, потому что три узла физически не
позволяют построить два непересекающихся трёх-hop пути. Поэтому первый релиз:

- MUST сохранять exact-three-hop на любой выбранной attempt;
- MUST использовать разные attempt/replay/ephemeral keys;
- SHOULD менять role assignment или route, когда topology это позволяет;
- MUST NOT заявлять fully disjoint fallback, operator diversity или survival
  при потере двух из трёх узлов;
- MAY повторить через другой carrier/entry binding только по правилам
  before-forward/outcome reconciliation;
- MUST показывать degraded/unavailable, если exact-three route собрать нельзя;
  direct managed HTTPS fallback запрещён.

Три узла — bootstrap deployment, а не достаточная долгосрочная
децентрализация. Registry/topology publisher может быть Deep-operated, но
клиент проверяет signed lineage и выбирает route из roster.

### 2.2 `OfficialXPoint6Plus` — усиленный официальный профиль

Минимум шесть одновременно пригодных routing nodes. Полностью disjoint primary
и fallback можно заявлять только если пути не пересекаются по:

- RouterId и current traffic-encryption key;
- physical host/VM;
- public IP prefix (`/24` IPv4 или `/48` IPv6 как минимальная проверка);
- operator;
- hosting provider и ASN.

Jurisdiction diversity — отдельная optional policy, а не автоматически
доказанное свойство. Если constraints не выполняются, capability понижается до
`ExactThreeHop` без `DisjointFallback`, и UI/telemetry не выдают прежнюю
гарантию.

Рекомендуемый путь роста сети по образцу полезных свойств Session:

- stake/Sybil-cost и signed admission;
- полный публично проверяемый roster routing/storage nodes;
- client-side route selection и persistent entry guards;
- recipient mailbox/swarm placement с несколькими storage replicas;
- перераспределение при churn с bounded retention/continuity;
- независимые operators и измеряемая ASN/provider concentration.

При этом anti-censorship bridges не обязаны входить в публичный roster: иначе
цензор извлечёт все адреса. Routing decentralization и bridge distribution —
разные подсистемы.

### 2.3 `UserManagedSingleNode`

Один XNode, выбранный пользователем или организацией:

- authenticated E2EE mailbox и durable async delivery доступны;
- path anonymity отсутствует; оператор знает client IP и mailbox activity;
- exact-three-hop, decentralized routing и disjoint fallback отсутствуют;
- private/loopback origins допустимы только после явного profile consent;
- trust root, TLS, retention, backup и account admission принадлежат operator;
- Deep-operated Registry, DNS, billing, staking и signer не обязательны.

Этот профиль полезен для семьи/организации и локальной сети, но не называется
анонимным XPoint routing.

### 2.4 `UserManagedMultiNode`

Несколько user-managed/community nodes:

- 1–2 доступных nodes: только direct authenticated mailbox;
- 3–5 nodes: exact-three-hop возможен, disjoint fallback невозможен;
- 6+ nodes: disjoint fallback возможен при выполнении failure-domain
  constraints из `OfficialXPoint6Plus`;
- operator может подключить собственный signed carrier catalog, file store,
  push bridge и TURN.

Общий on-prem installer MUST позволять external state/secrets, backup/restore,
несколько instances и independent authority. Official public-address policy не
ослабляется ради private on-prem origins.

### 2.5 `DirectP2P`

Live authenticated peer link без обязательного mailbox/control plane:

- минимальная latency и отсутствие server storage;
- оба peers обычно должны быть online;
- peer MAY видеть IP другого peer; NAT traversal может потребовать rendezvous,
  STUN или relay;
- relay-assisted connection честно маркируется `RelayedP2P`, а не direct;
- нет автоматической censorship resistance и offline delivery;
- E2EE, semantic dedup и outbox остаются теми же.

Internet rendezvous MUST использовать rotating contact-scoped tokens, не
broadcast `DeepAccountId`. Для будущей реализации можно оценить libp2p Circuit
Relay v2 и DCUtR, но global DHT не является default из-за Sybil/social-graph
риска: [Circuit Relay v2](https://github.com/libp2p/specs/blob/master/relay/circuit-v2.md),
[DCUtR](https://github.com/libp2p/specs/blob/master/relay/DCUtR.md).

### 2.6 `StoreCarryForwardMesh`

Offline/local mesh поверх BLE, Wi-Fi Direct/LAN или последующих peer links:

- intermediate peers хранят только E2EE bundle;
- каждый hop видит непосредственных соседей, размер, время и local radio data;
- rotating contact-scoped discovery tokens запрещают broadcast account ID;
- bundle имеет authenticated end-to-end semantic ID, outer per-hop ID,
  lifetime, hop limit и bounded copy budget;
- loop suppression, replay tombstones, custody/ACK, relay consent,
  battery/storage quotas и flood/Sybil policy обязательны;
- partition merge использует общий semantic dedup;
- realtime calls не гарантируются; call возможен только при live path с
  подходящей media capability.

Полезные DTN patterns можно брать из
[RFC 9171](https://www.rfc-editor.org/rfc/rfc9171.html), но его addressing нельзя
переносить напрямую, если оно раскрывает стабильную identity.

## 3. Capability matrix

| Свойство | Official 3 | Official 6+ | On-prem 1 | On-prem 3–5 | On-prem 6+ | Direct P2P | SCF mesh |
| --- | --- | --- | --- | --- | --- | --- | --- |
| E2EE message semantics | да | да | да | да | да | да | да |
| Async offline mailbox | да | да | да | да | да | нет | да, bounded |
| Exact three-hop | да | да | нет | возможно | возможно | нет | нет |
| Disjoint 3+3 fallback | **нет** | conditional | нет | нет | conditional | нет | нет |
| Operator diversity | не заявлено | measurable | нет | operator-defined | operator-defined | n/a | peer-dependent |
| Masked carrier | обязательно | обязательно | optional | optional | optional | link-dependent | radio/link-dependent |
| Peer IP hidden from recipient | да | да | да | да | да | нет по умолчанию | не от соседей |
| Sender IP hidden from mailbox exit | да при non-collusion | да при non-collusion | нет | conditional | conditional | n/a | n/a |
| Attachments | masked blob | masked blob | operator blob/P2P | operator blob | operator blob | live chunks | bounded chunks |
| Push | optional hint | optional hint | operator choice | operator choice | operator choice | нет | нет |
| Call signaling | E2EE message plane | E2EE message plane | message plane | message plane | message plane | live link | eventual only |
| Realtime call media | RelayOnly: MasqueUdp/MaskedTcpCapsule | RelayOnly: MasqueUdp/MaskedTcpCapsule | operator policy | operator policy | operator policy | direct/relay | только при live path |
| Первый релиз | **да** | нет | нет | нет | нет | нет | нет |

`conditional` означает, что runtime выдаёт capability только после
криптографической и operational проверки exact topology. Количество logical
IDs само по себе ничего не доказывает.

## 4. Privacy guarantee matrix

Легенда: `G` — гарантируется при выполнении profile gate; `C` — зависит от
конфигурации/non-collusion; `N` — не гарантируется.

| Угроза/свойство | Official 3 | Official 6+ | On-prem 1 | On-prem multi | Direct P2P | SCF mesh |
| --- | --- | --- | --- | --- | --- | --- |
| Relay/storage читает content | G | G | G | G | G | G |
| Получатель проверяет sender device/group epoch | G | G | G | G | G | G |
| Один routing node связывает client IP и mailbox | G | G | N | C | n/a | n/a |
| Компрометация одного route раскрывает content | G | G | G | G | G | G |
| Primary/fallback не имеют общего node/operator | N | C | N | C | n/a | n/a |
| Recipient не видит sender IP | G | G | G | G | N | C |
| ISP не видит очевидный Deep protocol fingerprint | C | C | N/C | N/C | N/C | local-only |
| Устойчивость к DNS/SNI block | G по release scenarios | G | operator-defined | operator-defined | N/C | local-only |
| Устойчивость к блокировке всех известных IP | C через bridge rotation | C | N | N/C | C | local-only |
| Защита от active probing | C по carrier | C | N/C | N/C | N/C | protocol-specific |
| Timing/volume correlation | N | N | N | N | N | N |
| Global passive observer | N | N | N | N | N | N |
| Compromised endpoint/device | N | N | N | N | N | N |
| Availability при malicious withholding | C | C, лучше | operator-defined | operator-defined | N | C |

`G` для onion privacy предполагает отсутствие collusion между entry и exit и
корректный endpoint. Ни один профиль не обещает абсолютную анонимность,
невозможность блокировки или защиту от global traffic analysis.

## 5. Carrier profiles

XPoint transport и carrier — разные оси. Один exact MAU2/onion frame может
проходить через:

- `reality-xhttp-v1` — первый production TCP/443 carrier;
- `https-stream-v1` — независимый HTTPS/WebTunnel-подобный TCP/443 carrier;
- `masque-h3-v1` — дополнительный QUIC/UDP carrier;
- `masked-tcp-capsule-v1` — обязательный real-time fallback без UDP;
- `DirectTls` — допустим только для explicit on-prem/admin profile, не как
  hidden official fallback.

Signed carrier descriptor содержит version, network/profile, bridge ID,
address/port, server name, public key, short credential/cohort, protocol/flow,
fingerprint profile, validity, predecessor и revocation reference. Account ID
и stable device ID в bridge credential запрещены.

Bridge acquisition MUST реализовать три канонических channel из
`CIRCUMVENTION-CARRIERS-V1.md`:

1. `in-app-oblivious` — RFC 9458 OHTTP с разделёнными Relay/Gateway;
2. `multi-origin-https` — byte-identical signed bundle у нескольких unrelated
   HTTPS/ECH providers;
3. `user-import` — signed QR/file/copied text через out-of-band channel.

Bounded embedded signed cache является bootstrap hint и четвёртым локальным
источником, но не засчитывается вместо обязательного channel.

Embedded endpoints считаются публично известными и не являются полной сетью.
Нельзя публиковать полный bridge pool в APK, DNS или public node roster.

Tor Pluggable Transport показывает полезную границу между application и
обфускацией: [PT specification](https://spec.torproject.org/pt-spec/). ECH
скрывает ClientHello/SNI, но не destination IP:
[RFC 9849](https://www.rfc-editor.org/rfc/rfc9849.html).

## 6. XPoint control/data-plane compromise

Для скорости XPoint не выполняет blockchain consensus или global node gossip
на каждую Store/Retrieve/Ack операцию. Децентрализация достигается разделением
ролей и подписанными epoch snapshots:

| Роль | Ответственность | Не получает |
| --- | --- | --- |
| admission/staking | Sybil-cost, eligible node set, operator claim | message/contact traffic |
| roster publishers | bounded signed snapshot eligible nodes/keys/capacity | право выбрать route конкретного клиента |
| mirrors/Registry | раздают byte-identical snapshots, prekeys и opaque control artifacts | право расшифровать/переподписать их |
| client selector | guard, middle, exit и carrier по verified snapshot | authority добавить неизвестный node |
| routing nodes | один onion hop | plaintext и полный route |
| storage replicas | opaque mailbox ciphertext/ACK state | DeepAccountId и sender IP |
| bridges | masked ingress к entry | mailbox destination/plaintext |

Target official network использует:

- offline release root и threshold-authorized online roster epochs;
- append-only snapshot/checkpoint lineage с consistency proof и независимыми
  witnesses/mirrors;
- staking/admission как input следующего epoch, не synchronous dependency
  message path;
- client-side weighted selection из eligible set с persistent guards;
- deterministic weighted rendezvous placement по blinded mailbox placement ID,
  roster epoch и signed node capacity;
- parallel write к двум storage replicas, bounded idempotency и read repair;
- short-lived node traffic keys отдельно от node identity/admission keys.

Registry MAY агрегировать health/capacity и раздавать snapshots, но не назначает
пользователю готовый маршрут и не может единолично добавить key/origin. Один и
тот же canonical snapshot доступен минимум через три mirrors/carriers; клиент
проверяет подпись, epoch, predecessor, expiry, network/genesis и consistency с
protected LKG.

Первый `OfficialXPoint3` допускает одного оператора и bootstrap governance,
поэтому называется **operator-centralized bootstrap with decentralized data
path**, а не fully decentralized network. Переход к независимым operators не
меняет client/application protocol: меняются admission snapshot и реально
доступные diversity capabilities.

## 7. Routing and storage policy

### 7.1 Guards and path lifetime

- Client SHOULD держать 2–3 persistent candidate guards, но одна attempt
  использует один entry.
- Guard меняется при revocation, длительной недоступности или signed policy
  expiry, не после единичного timeout.
- Middle/exit MAY меняться чаще для load balancing.
- Topology selection учитывает health, capacity и diversity, но не принимает
  operator-provided route без client verification.
- Route и carrier rotations независимы: смена bridge не обязана менять onion
  path, а смена exit не обязана раскрывать contact identity bridge service.

### 7.2 Recipient placement

Для скорости и устойчивости XPoint использует recipient-owned logical mailbox
со storage replication. Рекомендуемый первый профиль — две durable replicas с
идемпотентной записью и чтением; увеличение replication factor выполняется
policy/config без изменения E2EE message.

Placement descriptor contact-scoped и ротируется. Public roster не публикует
соответствие `DeepAccountId -> mailbox`. Registry может видеть provisioning,
поэтому его metadata power должна быть ограничена blinded placement ID,
минимальными logs, transparency и разделением signing/hosting roles.

### 7.3 Availability

Official 3 заявляет:

- корректную работу при потере одного carrier endpoint, если остаётся другой
  bridge к доступному exact-three route;
- bounded retry и сохранение logical outbox;
- отсутствие гарантии при недоступности одного из трёх единственных routing
  nodes, если replacement topology ещё не опубликована.

Official 6+ добавляет route-level fallback и failure-domain diversity после
отдельного gate.

## 8. Attachments, push and calls by profile

### Attachments

Official profiles MUST получать/upload encrypted chunks через masked carrier.
Прямой public file hostname, блокировка которого ломает messenger, запрещён.
On-prem использует operator blob provider или inline bounded mode. Direct/mesh
используют resumable encrypted chunks с тем же manifest.

### Push

FCM/APNs/WNS остаются optional wake optimization. Official profile MUST
работать без provider push через foreground/resume/background polling в рамках
ограничений ОС. On-prem выбирает собственный provider. Mesh push не обещает.

### Calls

Signaling следует message profile. Media использует отдельную policy:

- `RelayOnly` — единственный official V1 `CallPrivacyProfile`;
- `DirectPeer`/direct ICE — будущая opt-in policy из-за раскрытия IP peer и
  не входит в official V1;
- `NetworkCondition=Restricted` выбирает `MaskedTcpCapsule` без peer-IP
  downgrade;
- official call relay catalog ротируется и доступен через TCP/TLS 443 и
  UDP/443 families;
- on-prem может использовать собственный TURN;
- mesh даёт call media только при live path и достаточной bandwidth.

Звонок не называется censorship-resistant только потому, что TURN использует
TLS. Release evidence должно отдельно блокировать DNS/SNI, UDP и известный
relay IP и доказать разрешённый fallback.

## 9. Profile activation and downgrade

Profile activation атомарно сохраняет network/genesis, authority lineage,
capability set, carrier catalog head и user consent в protected LKG. Вход в
другой network/profile не переиспользует bindings или replay state.

Fail closed cases:

- signed profile обещает exact-three, но доступно меньше трёх nodes;
- carrier descriptor не связан с selected entry;
- runtime предлагает DirectTls в official masked-only policy;
- topology generation/fork не продолжают pinned lineage;
- adapter заявляет capability выше signed profile;
- on-prem private address попадает в official profile;
- P2P relay выдаётся за direct connection.

Допустимый downgrade требует нового signed policy или явного consent и должен
быть виден до отправки. Уже подготовленный ciphertext можно переиспользовать
только через новый outer attempt по правилам logical outbox.

## 10. Future profile acceptance gates

P2P/on-prem не входят в первый релиз, но target architecture считается
сохранённой, если contract tests доказывают:

- generic message/group/outbox assemblies не ссылаются на official Registry,
  PMA/billing/Reality/XNode types;
- `UserManaged` допускает private origin только после consent и не ослабляет
  official policy;
- `PeerOwned` не требует mailbox selector/entitlement;
- adapter capability может честно выразить отсутствие async retention,
  attachment, push или call media;
- один semantic event дедуплицируется после доставки XPoint+mesh;
- добавление profile не требует DB rewrite application history или crypto
  session migration.

## 11. Ingress implementation boundary

HAProxy is not a protocol or application dependency. It is the current
production implementation for sharing TCP/443 between exact-host HTTPS and
Reality SNI, suppressing headers and keeping internal services unpublished.

- A fast developer lane MAY connect directly to container-private Xray and
  managed-ingress listeners and omit HAProxy.
- A production-representative UAT lane MUST exercise the selected shared-port
  ingress, Docker DNS re-resolution, certificate rotation and SNI separation.
- Passing the direct developer lane cannot satisfy censorship, TLS, public
  exposure or production ingress evidence.
- A later Envoy/Nginx/custom ingress MAY replace HAProxy if the same closed
  listener/routes/header/re-resolution gates pass; no client or wire record
  contains `HAProxy`.
