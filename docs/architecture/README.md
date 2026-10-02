# Целевая архитектура Deep и XPoint

Статус: **нормативный индекс целевой production-архитектуры**  
Решение: полный pre-production clean break, 30 августа 2026 года.

## Назначение

Этот каталог является единой точкой входа для реализации первого публичного
релиза. Он описывает целевое поведение, а не подтверждает готовность текущего
кода. Фактические незавершённые работы перечисляются только в
[`../NEXT-SPRINT.md`](../NEXT-SPRINT.md), а реализованное — в
[`../SPRINT-HISTORY.md`](../SPRINT-HISTORY.md).

Это единый нормативный раздел **технической документации master-репозитория**.
Он намеренно не перенесён в `xpoint-docs`: тот репозиторий публикуется для
пользователей и операторов и не должен становиться вторым владельцем wire,
crypto или security semantics.

При конфликте документов применяется следующий порядок:

1. принятые decision records в `docs/survival-program/decisions`;
2. frozen machine registry/schema/vectors в `deep-protocol`;
3. нормативные protocol/crypto и architecture specifications из списка ниже;
4. `PROTOCOL-REGISTRY-V1.md` и `IMPLEMENTATION-PLAN-V1.md`;
5. repository architecture/operator runbooks;
6. публичная документация `xpoint-docs`.

Несогласованный нижестоящий документ не меняет требования более высокого
уровня и должен быть исправлен вместе с реализацией.

## Единственный владелец каждого вида требований

| Предмет | Единственный normative source |
|---|---|
| threat model, privacy/security claims и non-claims | `THREAT-MODEL.md` |
| recovery, identity, AKE, ratchet и primitive suites | `DEEP-CRYPTO-V1-DRAFT.md` плюс frozen machine registry/vectors |
| глобальные имена magic/suite/profile/interface и lifecycle | `PROTOCOL-REGISTRY-V1.md` |
| DID/contact/message/multi-device/group application semantics | `CONTACT-AND-GROUP-PROTOCOL-V1.md` |
| contact publication/resolve/prekey service operations | `CONTACT-RESOLVER-V1.md` |
| account freshness/transparency/trusted time | `ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md` |
| retention и recovery guarantees | `RETENTION-AND-RECOVERY-V1.md` |
| transport-neutral interfaces/outbox/dedup | `TRANSPORT-NEUTRAL-MESSAGING.md` |
| XPoint membership/roles/onion/mailbox/placement | `XPOINT-NETWORK-V1.md` |
| carrier wires/bootstrap/bridge distribution | `CIRCUMVENTION-CARRIERS-V1.md` |
| call signaling/allocation/media state | `CALL-SESSION-V1.md` |
| deployment guarantees | `DEPLOYMENT-PROFILES.md` |
| release features/product claims | `V1-RELEASE-SCOPE.md` |
| exact release scenario/evidence IDs, owners, SLO predicates | `release-scope.v1.json` validated by `release-scope.v1.schema.json` |
| незавершённый milestone/release scope | `NEXT-SPRINT.md` |
| agent-sized dependency DAG и ownership | `IMPLEMENTATION-PLAN-V1.md` |

Нижестоящие документы MUST ссылаться на владельца и могут описывать только:

- фактическое состояние/конфигурацию собственного репозитория;
- user/operator workflow на уровне наблюдаемого поведения;
- локальный API mapping и команды проверки.

Они MUST NOT копировать canonical field tables, KDF/transcript, retention
numbers, topology guarantees, SLO или release status. Нужный фрагмент даётся
ссылкой на source of truth и коротким repo-specific consequence. При изменении
normative source выполняется link/consumer audit; текст не синхронизируется
ручным copy-paste.

### Documentation CI policy

Для нового clean-break generation допускается один быстрый path-filtered docs
job. Он проверяет только UTF-8, navigation/local links, public render, отсутствие
секретов/приватных путей и machine registry/schema/vector consistency. Он
запускается при изменении документации, registry/schema или docs tooling.

CI MUST NOT фиксировать prose через snapshot/regex, требовать присутствия
каждой исторической фразы или дублировать protocol/e2e tests. Старый
`Test-Rc6DocumentationContracts.ps1` остаётся evidence-контрактом конкретного
pre-cutover RC-6 recovery drill и не является шаблоном/default gate для V1.

## Принятые решения

- До отдельного письменного решения владельца единственным production
  operator и владельцем custody для offline root, Registry/DTT1 threshold,
  MSG authenticated-evidence, Contact/XPK, Group GSR1/DCR1, Android release
  signing и Windows release signing является **Mr. X**. Это operational
  custody, а не перенос ownership исходного кода или protocol semantics из
  репозиториев, указанных ниже.
- Пользователей production ещё нет: выполняется один destructive clean break
  без миграции, dual-read, legacy parser или downgrade.
- [`DR-0006`](../survival-program/decisions/DR-0006-pq-root-deep-id-clean-break.md)
  требует PQ-ключ, закреплённый в корне постоянного Deep ID уже при создании.
  Старые DID1/DAB1 и Ed25519-only succession не входят в release graph;
  exact replacement wire/provider ещё не frozen и блокирует выпуск.
- [`DR-0007`](../survival-program/decisions/DR-0007-did2-resolver-read-capability-separation.md)
  запрещает сырой resolver read capability в публичном DID2 и Registry
  DGA1/DPQ2: credential содержит только его hash commitment, адрес сохраняет
  сам capability. 2052-byte replacement codec/store и локальные тесты готовы;
  прежний raw-capability DID2 кандидат retired, а live/device closure ещё
  блокирует релиз.
- [`DR-0008`](../survival-program/decisions/DR-0008-did2-dph2-wire-clean-break.md)
  задаёт один DID2-only DPH2 version-2 target с exact DID2 в tag 20.
  Исторический DID1 DPH2 и его DAO1 размеры не входят в release graph;
  machine registry, vectors и consumers ещё должны быть перевыпущены вместе.
- [`DR-0009`](../survival-program/decisions/DR-0009-did2-selected-entry-transport.md)
  связывает TLS entry с фактически выбранным трёх-hop DID2 путём, а локальные
  guards и entropy — с текущим account/database instance. Это отдельное
  frozen API extension без изменения ONION wire; live publication и device
  E2E ещё не подтверждены.
- [`DR-0010`](../survival-program/decisions/DR-0010-did2-onion-host-authority.md)
  заменяет V1 receive snapshot и fixed-position host на DID2-only свежую
  authority с durable NETCODEC floor и signed multi-role receive. Реализация
  и all-six-permutations/live/device evidence ещё обязательны.
- [`DR-0011`](../survival-program/decisions/DR-0011-authenticated-relay-position.md)
  разрешает различать Ingress/Core только по проверенному содержимому после
  AEAD, с закрытым pre-commit error contract и ограниченным position retry.
  Внешний Relay header не даёт уникальную receive position; wire/API не меняются.
- [`DR-0012`](../survival-program/decisions/DR-0012-protected-network-history.md)
  задаёт restart-safe protected network history и проверку установленного onion
  public key через Protocol. DID2 host больше не принимает V1 snapshot или
  fixed-role configuration; local replay generation также clean-broken под
  настоящий 16-byte NETCODEC network ID. TLS/device rollout остаётся отдельным gate.
- [`DR-0013`](../survival-program/decisions/DR-0013-readonly-directory-issuance-readiness.md)
  замораживает read-only Protocol API для proof-aware readiness без signing,
  nonce consumption и mutation capability. Временный отказ зависимостей не
  должен прекращать recovery worker; NTS lifecycle и live soak этим не закрыты.
- Текущие Session-derived identity, DPE1/DMC1 и group bytes не являются
  production compatibility surface и не ограничивают новый дизайн.
- [`DR-0016`](../survival-program/decisions/DR-0016-did2-prekey-claim-receipt.md)
  замораживает DID2-only current-recipient XPC1 verifier без V1 receipt adapter.
  Typed receipt не выдаёт session/ACK и не заменяет durable replica read-back;
  DPH2/MSG composition и физическая доставка остаются отдельными gates.
- [`DR-0017`](../survival-program/decisions/DR-0017-did2-initial-claim-promotion.md)
  замораживает V2-only encrypted-prefix и current initiator/recipient promotion
  с neutral двухканальным prekey handoff. Полный sender/durable/MSG путь и
  device E2E этим не активируются; 4-КиБ wire bucket не вмещает V2 claim.
- [`DR-0018`](../survival-program/decisions/DR-0018-did2-initiator-completion.md)
  замораживает V2-only sender completion; protected pending custody и device
  delivery остаются отдельными gates.
- [`DR-0019`](../survival-program/decisions/DR-0019-did2-preclaim-secret-persistence.md)
  замораживает opaque local seal/restore секретов до XPK1. Shared protected
  logical-intent owner реализован; shipping composition остаётся gate.
- [`DR-0020`](../survival-program/decisions/DR-0020-did2-atomic-device-initial-session.md)
  задаёт закрытую локальную атомарную фиксацию device burn и DPH2/TRS1.
  Focused native/structural gates passed; final batch/device gates ещё открыты.
- [`DR-0021`](../survival-program/decisions/DR-0021-did2-contact-rendezvous-issuer.md)
  связывает issuer/time inbound rendezvous с current DID2 checkpoint.
  Identity-neutral XUR1 wire не меняется; это не route, acceptance или ACK.
- [`DR-0022`](../survival-program/decisions/DR-0022-did2-contact-control-events.md)
  переводит Hello/Accept на DAB2 и PQ-root safety number без V1 overload.
  Current endpoint metadata не заменяет authentication, route, durable inbox или ACK.
- [`DR-0023`](../survival-program/decisions/DR-0023-did2-owned-rendezvous-author.md)
  задаёт owned-device XUR1 author и account/instance/intent-bound protected custody.
  Exact retry сохраняет metadata-ключ и XUR1 после сбоя; старый DAB1 author удалён.
  Route/publication, MSG projection и физическая доставка остаются gates.
- [`DR-0024`](../survival-program/decisions/DR-0024-did2-owned-initial-claim-preview.md)
  задаёт read-only receiver preview из account-owned DID2 prekey custody.
  Открытый XPK1/XPC1 prefix не является session, inbox, prekey burn или ACK;
  current V2 promotion и atomic responder completion остаются обязательными.
- [`DR-0025`](../survival-program/decisions/DR-0025-did2-owned-responder-preparation.md)
  задаёт owned-device responder preparation и одноразовую передачу matching
  state/events/reservation атомарному store. Prepared capability не является
  durable session, применённым contact state или ACK.
- [`DR-0026`](../survival-program/decisions/DR-0026-did2-atomic-responder-custody.md)
  задаёт account-owned атомарную фиксацию входящего первого контакта,
  расход prekey и exact recovery без повторного открытия использованного ключа.
  Это локальное custody; MSG/contact projection и physical delivery ещё обязательны.
- [`DR-0027`](../survival-program/decisions/DR-0027-did2-messaging-session-ownership.md)
  задаёт передачу владения DID2 initial-state рабочему message store и удаление
  старых секретных копий до обычного send/receive. Внутренний seed не является
  durable transfer, ACK или transport capability; runtime activation gated.
- [`DR-0028`](../survival-program/decisions/DR-0028-did2-application-event-handoff.md)
  задаёт DID2 account-owned application custody и замкнутый handoff retained
  initial/ordinary events в inbox. Это не contact consent, dispatch, delivery
  или ACK; semantic rollback/outbox checkpoints остаются обязательными.
- [`DR-0029`](../survival-program/decisions/DR-0029-did2-contact-accept-custody.md)
  задаёт явную account-owned acceptance command, protected exact retry и
  authenticated pending-Hello/Accept handoff. Peer/local acceptance не являются
  Active/reachability, delivery или ACK.
- [`DR-0030`](../survival-program/decisions/DR-0030-did2-owned-direct-text-outbox.md)
  задаёт account-owned ordinary text authoring, protected pending/stable retry,
  единый authored counter и exact SQL mirror. Raw caller MessageCreate и
  остальные неподключённые виды событий не дают send authority. Это очередь,
  не доставка; semantic inbox, transport и physical gates остаются открытыми.
- [`DR-0031`](../survival-program/decisions/DR-0031-did2-local-attachment-custody.md)
  задаёт offline account-owned DAM1/ciphertext adoption, exact restart/retry
  и protected asset journal. Это не AttachmentOffer, masked blob transport
  или remote receipt; typed events используют общий authored namespace.
- [`DR-0032`](../survival-program/decisions/DR-0032-did2-mailbox-selected-entry.md)
  задаёт DID2-owned mailbox network refresh и selected-entry composition.
  Route/grant, semantic ACK и shipping/device activation остаются gates;
  identity-neutral MAU2 wire не является сохранением Session identity.
- [`DR-0033`](../survival-program/decisions/DR-0033-did2-current-mailbox-route.md)
  задаёт прямую current DID2 route authority и трёхфазный genesis author.
  Owned-device и threshold подписи не заменяют durable adoption/publication,
  mailbox grants, semantic ACK или physical delivery.
- [`DR-0034`](../survival-program/decisions/DR-0034-did2-owned-route-custody.md)
  задаёт account-owned route journal и exact restart трёх фаз под защищённой
  блокировкой. Новый обязательный protected root требует явного reset старых
  QA-аккаунтов; серверный wire и shipping publication этим не активируются.
- [`DR-0035`](../survival-program/decisions/DR-0035-did2-mailbox-grant-request.md)
  заменяет DID1 grant-request author прямым DID2 и использует только проверенный
  route time. Старые Shared acquisition client и V1-storage holder owner удалены;
  issuance, protected
  holder/request custody и authenticated topology остаются gates.
- [`DR-0036`](../survival-program/decisions/DR-0036-did2-route-threshold-coordination.md)
  заменяет route-coordination envelope на V2, серверную authority на прямой
  DID2/ADA2/external-floor путь и задаёт permanent PostgreSQL exact replay.
  Direct Registry fallback в shipping client не разрешён; publication,
  successor/renewal, API/repin и physical delivery остаются gates.
- [`DR-0038`](../survival-program/decisions/DR-0038-did2-publication-coordination.md)
  freezes exact DID2 publication coordination and protected request/response custody;
  shipping private transport and replica/device delivery remain gates.
- [`DR-0039`](../survival-program/decisions/DR-0039-did2-opaque-publication-consumer.md)
  replaces the public XPU/XPA consumer and node authorization/placement with
  direct DID2 authority; incompatible saga custody rejects without migration.
  Local two-replica evidence does not close private transport or device gates.
- [`DR-0040`](../survival-program/decisions/DR-0040-did2-owned-publication-commit.md)
  adds closed two-replica commit verification and owned exact phase-7 custody;
  route journal follows the current-only generation in DR-0073; disposable older
  QA instances require explicit reset. Historical evidence does not renew dispatch authority.
- [`DR-0041`](../survival-program/decisions/DR-0041-did2-permanent-contact-resolution.md)
  closes descriptor-bound candidate decryption and independent current DID2
  permanent-read verification. Parsed candidates are not identity authority;
  local evidence does not activate shipping/contact acceptance/device delivery.
- [`DR-0042`](../survival-program/decisions/DR-0042-did2-route-directory-issuance-anchor.md)
  separates signed route issuance anchors from independent current identity;
  unrelated directory admission does not require contact republishing. New
  issuance, current proof/floors and network/expiry successor gates remain.
- [`DR-0043`](../survival-program/decisions/DR-0043-did2-claim-current-network-and-clock.md)
  binds claim recipient/placement to exact current directory/network authority
  and retains the last protected verification sample; dispatch is bounded.
- [`DR-0044`](../survival-program/decisions/DR-0044-did2-prekey-service-contact-lifetimes.md)
  separates full inventory/service validity from later contact publication;
  all lifetimes must still cover the complete authenticated operation interval.
- [`DR-0045`](../survival-program/decisions/DR-0045-did2-owned-resolved-contact-claim.md)
  moves exact claim preparation into the account owner, deriving the publisher
  service and restoring the protected operation atomically before dispatch.
  Local custody does not activate shipping/session/device delivery.
- [`DR-0046`](../survival-program/decisions/DR-0046-did2-owned-attachment-offer.md)
  connects stable owned assets to AttachmentOffer in the common protected
  ordinary-event namespace; BLOB/socket/device delivery is still gated.
- [`DR-0047`](../survival-program/decisions/DR-0047-did2-owned-peer-refresh.md)
  persists the seed's exact public peer credential atomically with registration;
  ordinary session operations independently refresh both endpoints, not a stored
  resolver proof. Missing bootstrap requires explicit reset, never lazy repair.
- [`DR-0048`](../survival-program/decisions/DR-0048-private-contact-coordination-peer-authentication.md)
  requires independent existing-node proof at both private coordination terminals.
  Transport access is not publisher/witness/network authority; the isolated
  backend client does not activate a direct client fallback or XPoint carrier.
- [`DR-0049`](../survival-program/decisions/DR-0049-did2-three-hop-coordination-carrier.md)
  selects the existing exact-three XPoint carrier for DID2 coordination, with
  request-paired wrappers and independently derived gateway placement. Owned
  operations loan the actual account lease to guards/entropy; recursive proof
  acquisition, direct Registry fallback and public lock-bypass flags are forbidden.
- [`DR-0050`](../survival-program/decisions/DR-0050-did2-contact-service-composition.md)
  connects DID2-only contact publication/resolve and V2 prekeys behind one
  authenticated replica endpoint. Service expiry/retention uses fresh signed
  DID2 time plus actual monotonic elapsed time, never the HTTP admission clock.
  Candidate activation and physical release evidence remain separate.
- [`DR-0051`](../survival-program/decisions/DR-0051-owned-permanent-contact-client-entry.md)
  exposes account-owned permanent publication/resolve without UI-supplied keys,
  authority callbacks or retry IDs. The protected instance determines the stable
  plan, checked under each phase lease; HTTPS diagnostic composition is not
  shipping message/device evidence.
- [`DR-0071`](../survival-program/decisions/DR-0071-did2-reachability-advertisement-successor.md)
  authorizes only the owned-device XRA1 successor candidate with exact predecessor
  lineage. Complete protected renewal/coordination/publication and retained-account
  device recovery remain gates; expired routes are not made current.
- [`DR-0072`](../survival-program/decisions/DR-0072-did2-route-renewal-lineage.md)
  closes the route-artifact successor phases and historical-input boundary,
  including timed selection refresh and reusable-invite expiry-gap semantics.
  Durable private lineage issuance, owned publication and devices remain gated.
- [`DR-0073`](../survival-program/decisions/DR-0073-did2-exact-route-request-custody.md)
  requires the entire original nonce-bound threshold request in protected custody
  before dispatch. Fresh directory proofs never rewrite a saved replay minimum;
  the local journal clean break requires explicit isolated old-QA reset.
- [`DR-0052`](../survival-program/decisions/DR-0052-did2-mailbox-authority-distribution.md)
  requires public PMA2 in the complete network bundle and a direct DID2 grant
  verifier under root-authorized role issuers and the exact current PMT2.
  Retained grant evidence is not protected holder custody or dispatch authority;
  live issuance, final machine bindings and physical delivery remain gates.
- [`DR-0053`](../survival-program/decisions/DR-0053-did2-mailbox-grant-restart-custody.md)
  separates exact current pending-request restoration from retained grant
  verification and binds holder/request/winner custody to the actual account
  lease and protected SQL instance. Private live issuance, credential use and
  physical delivery remain separate gates; no silent nonce/key renewal.
- [`DR-0054`](../survival-program/decisions/DR-0054-did2-private-mailbox-grant-issuance.md)
  authorizes opaque grant issuance only from the current root/network and both
  independently selected durable stores. The private issuer keeps exact winners
  in the external restore-authority journal; it learns no recipient identity.
  This is not client credential installation or physical delivery evidence.
- [`DR-0055`](../survival-program/decisions/DR-0055-did2-owned-mailbox-credential-installation.md)
  installs the read-back protected winner into the actual owner's application
  SQL under the same lease and current PMA2 policy. No holder/runtime authority
  escapes; installation is not dispatch, acknowledgement or device evidence.
- [`DR-0056`](../survival-program/decisions/DR-0056-did2-owned-mailbox-message-dispatch.md)
  binds exact committed owned DPE2 to protected pending/prepared request custody,
  current holder/counter policy and owner-held selected-entry Store. Local
  preparation/receipt tests do not replace initial delivery, receive/ACK or
  physical messages/files/images/groups evidence.
- [`DR-0057`](../survival-program/decisions/DR-0057-did2-owned-incoming-session-selection.md)
  selects ordinary incoming sessions only from the actual protected account
  catalog before independent endpoint refresh and owned materialization. The
  selector is not authentication, initial-contact completion or ACK authority.
- [`DR-0058`](../survival-program/decisions/DR-0058-did2-owned-mailbox-retrieve-and-ack.md)
  connects owned Retrieve to protected captured-page custody and actual native
  receive/materialization before signed tombstone ACK. Missing read custody
  requires explicit QA reset; local integration is not initial-contact,
  remote attachment/group or physical delivery evidence.
- [`DR-0059`](../survival-program/decisions/DR-0059-did2-owned-initial-mailbox-dispatch.md)
  binds initial contact Store to the actual retired sender source and protected
  initialized catalog through the same owned mailbox engine; no caller DPH2,
  separate legacy dispatcher or ordinary-send fallback. Connected initial
  Store/Hello/ACK and live/device evidence remain required.
- [`DR-0060`](../survival-program/decisions/DR-0060-did2-account-random-sqlcipher-key.md)
  selects the supported random-key encoding for local DSV2 generation3; old
  diagnostic account databases require explicit reset, never a dual-key reader.
  Durable authentication/protected floors and the network deadlines are unchanged.
- [`DR-0061`](../survival-program/decisions/DR-0061-did2-committed-claim-recipient-verification.md)
  separates a completed pre-key allocation from its new-mutation request deadline
  on delayed initial receipt. Current recipient/initiator, placement, inventory,
  signatures and atomic consumption remain required; recipient evidence cannot
  authorize initiator encryption. Connected and device closure remain pending.
- [`DR-0062`](../survival-program/decisions/DR-0062-did2-private-contact-mailbox-route.md)
  defines the bounded private reply-route package without resolver/retrieve
  secrets. Event embedding, durable route heads and actual reverse contact
  delivery remain gated; current sends must not use permanent public resolution
  as their steady-state route.
- [`DR-0063`](../survival-program/decisions/DR-0063-did2-contact-reply-route-embedding.md)
  requires the private package in every Hello/Accept and a version2-only
  variable-length acceptance journal. Joined native/transport/device evidence
  and explicit incompatible isolated-account reset remain activation gates.
- [`DR-0037`](../survival-program/decisions/DR-0037-did2-owned-contact-object.md)
  замораживает V2 owned genesis DCB1/DCR1 author, capability-bound encryption
  и protected exact restart в phase 4 route journal. Старый journal version 1
  требует explicit QA reset; local candidate не выдаёт XPA1/grant/ACK и не
  активирует network publication или физическую доставку.
- Current owned application boundaries are governed by
  [DR-0064](../survival-program/decisions/DR-0064-did2-owned-initial-contact-draft.md),
  [DR-0065](../survival-program/decisions/DR-0065-did2-contact-application-command-boundary.md),
  [DR-0066](../survival-program/decisions/DR-0066-did2-application-sqlcipher-random-key.md)
  and [DR-0067](../survival-program/decisions/DR-0067-did2-ordinary-store-completion-and-ui-retry.md):
  owned initial draft, business commands, random-key application SQL and durable
  original ordinary-command retry. Local completion is not physical activation.
- Первый публичный релиз использует новое поколение account/device/database,
  ratcheted E2EE и новый contact bootstrap.
- XPoint — первый transport provider, но message identity, E2EE, groups,
  outbox, deduplication, attachments и call signaling не зависят от него.
- Direct P2P mesh и on-prem являются обязательными архитектурными профилями,
  но их runtime-реализация не входит в первый релиз.
- Первая production topology состоит ровно из трёх XNode и обеспечивает один
  точный трёхузловой privacy route. Она **не** заявляет полностью независимый
  fallback, operator diversity или устойчивость к отказу общего провайдера.
- Расширение до шести отложено до готовности приглашать реальных пользователей;
  после этого отдельный gate может активировать failure-domain-disjoint
  primary/fallback при проверенной независимости failure domains.
- Reality является первым pluggable carrier, а не единственным определением
  censorship resistance. Bootstrap и bridge distribution являются отдельной
  частью anti-censorship системы.
- Звонки входят в функциональный scope XPoint. Call signaling проходит как
  E2EE message; media использует отдельный низколатентный carrier с точным
  отображением privacy/reachability режима.
- Сетевая доставка имеет at-least-once retry и outcome-unknown semantics.
  Пользовательский exactly-once эффект достигается стабильным operation ID,
  идемпотентностью и durable local materialization.

## Нормативные документы

- [`THREAT-MODEL.md`](THREAT-MODEL.md) — противники, гарантии и запрещённые
  рекламные утверждения.
- `XPOINT-NETWORK-V1.md` — membership, node roles, routing, mailbox/storage,
  performance и calls.
- `CIRCUMVENTION-CARRIERS-V1.md` — carrier API, Reality, bridge distribution,
  bootstrap и censorship tests.
- `TRANSPORT-NEUTRAL-MESSAGING.md` — transport contract, outbox, dedup,
  attachments, push и calls.
- `DEPLOYMENT-PROFILES.md` — official, future six-node, on-prem и mesh
  guarantee matrix.
- `V1-RELEASE-SCOPE.md` — функциональный и physical release contract;
  [`release-scope.v1.json`](release-scope.v1.json) и
  [`release-scope.v1.schema.json`](release-scope.v1.schema.json) — его
  машиночитаемые scenario/evidence IDs, owners и exact pass predicates.
- [`SESSION-PARITY-AND-SOURCES.md`](SESSION-PARITY-AND-SOURCES.md) —
  функциональный/performance baseline Session, узкие выводы из
  Signal/Tor/Matrix/Briar/Cwtch и правила upstream reuse без нового
  runtime/wire зоопарка.
- [`LOCAL-DEV-E2EE-AUTHORITY.md`](LOCAL-DEV-E2EE-AUTHORITY.md) — отложенный
  post-release DEV-LOCAL-ONLY trust domain для настоящих DPK2/DPH2/DPE2/TRS1;
  не является зависимостью текущего production release.
- `CONTACT-AND-GROUP-PROTOCOL-V1.md` — permanent transport-neutral Deep ID
  (PQ-root DID2 for the release graph), one-time invites, initial contact,
  multi-device и small group semantics.
- `CONTACT-RESOLVER-V1.md` — invite publication/resolve, long-lived XIR1 и
  atomic fresh pre-key claim.
- `ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md` — fresh account/device heads,
  oblivious lookup, consistency/gossip и trusted time.
- `RETENTION-AND-RECOVERY-V1.md` — единственная retention matrix и разные
  гарантии existing-device/phrase/backup recovery.
- `CALL-SESSION-V1.md` — exact one-to-one call state, multi-device answer CAS,
  DTLS fingerprint и CallRelay allocation.
- `PROTOCOL-REGISTRY-V1.md` — глобальные magic/suite/carrier/profile/interface
  names, owners, lifecycle и collision gate.
- `IMPLEMENTATION-PLAN-V1.md` — dependency DAG из agent-sized packages,
  входы/выходы, removal lists и evidence gates.
- [`../survival-program/releases/v3.0.0/specs/DEEP-CRYPTO-V1-DRAFT.md`](../survival-program/releases/v3.0.0/specs/DEEP-CRYPTO-V1-DRAFT.md)
  — identity, recovery, AKE, ratchet и crypto suites.

## Требование к реализации

Каждый work package обязан ссылаться на конкретные разделы этих документов,
иметь closed canonical inputs/outputs, negative tests, durable crash points и
измеримый acceptance gate. Если спецификация оставляет разработчику выбор,
этот выбор должен быть локальным policy choice и не менять wire/security
semantics. Новая реализация не копирует код стороннего проекта до проверки
лицензии, provenance, поддерживаемости и собственной threat model.
