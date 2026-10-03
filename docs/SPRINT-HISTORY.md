# История спринтов

## 2026-10-03 — private publication successor и permanent generation fence

- [DR-0079](survival-program/decisions/DR-0079-did2-publication-issuer-successor.md)
  связывает отдельный закрытый issuer history с подписанными предыдущими XPO,
  completed journal request/XPU и permanent SQL fence на unsigned generation.
  Registry не получает resolver capability и не выдаёт факт расшифровки. Клиент
  отдельно проверяет encrypted object; оба пути используют общие правила lineage.
- V3-only publisher request/response, новые bounds, protected route journal clean
  break и совпадающие ONION consumers. Runtime DDL/legacy reader/backfill отсутствуют;
  operator-only provision сохраняет opaque audit bytes, reservations/counts/floors.
- Registry focused **29/29**, Protocol closed API **6/6**, XNode coordination
  **32/32**, Shared owner/history/retry **39/39**, без ошибок/пропусков и build warnings.
  Первые Shared 8/8, Registry 4/4 и XNode 32/32 — subsets/repeats,
  не дополнительные unique cases. Actual PQ/native/SQLCipher/ADA2/PostgreSQL/HTTP
  issuer lane: expiry, signed successor, forged receipt before reservation,
  interrupted reservation, another valid nonce before custody, lost HTTP response,
  restarted issuer without resigning, exact winner and corruption of marker/projection.
  Второй новый PQ-аккаунт действительно догоняет signed directory history через
  обычный client catchup; fixture переводит authority-unavailable в 503, как endpoint.
- In-process node signatures здесь НЕ actual replica persistence/socket TLS или
  physical device E2E. Full package/API/evidence/recovery/release gates, matched
  provisioning/repin, expired incomplete recovery и реальная доставка остаются P0.
  Установленные клиенты и prod в этой итерации не изменены; release/main merge не было.

## 2026-10-03 — owned committed/pending publication renewal

- [DR-0078](survival-program/decisions/DR-0078-did2-owned-publication-renewal.md)
  подключает permanent-contact client entry к настоящему protected current/pending
  custody под одним account lease. Предыдущая phase7 запись сохраняется exact до
  проверки обеих подписанных replica receipts; promotion выполняется одним
  whole-slot CAS и independent readback. Адрес, account instance, locator и owner
  capability не меняются. Нового wire, journal version или public retry ID нет.
- Shared focused **39/39**, zero failures/skips: genuine signed short genesis,
  expired committed predecessor, fresh DID2 proof, route/object/publication
  successor, loss/restart каждой adopted phase, hostile saved history до callbacks,
  поздний proof expiry, bad receipt, unknown replica reply, lost promotion reply
  и callback-free reopen. Первые 2/2 и 3/3 — subsets, не дополнительные unique cases.
  Native PQ/device/witness/node crypto и SQLCipher реальны; remote replicas здесь
  in-process signed fixtures, не actual node persistence/physical delivery.
- Expired incomplete proposal не удаляется и не remint-ится: exact custody остаётся,
  callback не вызывается. Для этого отдельного состояния bounded recovery ещё нужна.
  Полный integration/package/API/evidence/recovery/release gate отложен.
- Новый разрешённый Windows retry прошёл прежнюю IO-ошибку и завершился XRA1/Expiry.
  Guarded Android повтор/terminal Inspect также XRA1/Expiry, snapshots совпали.
  Оба старых installed клиента сохранили аккаунт/recovery; reset/reveal не было.
- Private Registry publication issuer всё ещё genesis-only, journal nonce-only.
  Independent historical publisher/replica verification без resolver capability
  export, generation fence, matched rollout и physical contacts/messages/assets/
  groups остаются P0. Production/push/GitHub Releases/main merges не менялись.

## 2026-10-03 — connected predecessor-aware route coordination

- [DR-0077](survival-program/decisions/DR-0077-did2-route-successor-coordination.md)
  связывает exact предыдущий XIR/route с current-only private request. Registry
  независимо проверяет closed history и current successor до durable reservation,
  использует successor author, retained completion требует ту же exact историю.
  Общий ONION wrapper и существующие node keys/signature transcript не меняются.
- Operator-only request provision сохраняет audit bytes, reservations/counts/floors;
  отсутствие mandatory marker останавливает callbacks. Runtime не выполняет DDL,
  не читает старый request и не освобождает failed generation reservation.
- Protected route journal current-only с обновлённым bounded request slot;
  это ещё не current/pending successor CAS и не automatic recovery после expiry.
- Registry **28/28**: реальный PQ/device/native/SQLCipher/PG сценарий signed short
  route expiry → fresh authority → exact successor request → lost HTTP response
  → unchanged winner/replay → retained completion, без новой genesis identity.
  Forged predecessor не резервирует capacity; другой nonce не подписывает то же
  поколение. Explicit operator upgrade сохраняет старые opaque audit bytes.
- Shared **38/38**, затем **7/7** retained/wire с дополнительными hostile cases;
  XNode **32/32** с exact signed predecessor request через current wrapper;
  Protocol API surface **5/5**. Повторные cases не считаются новыми unique tests.
  Только focused gates; полные package/API/evidence/DevOps/release gates отложены
  до integration boundary. Это не socket TLS/real replicas или physical E2E.
- Последний Windows UI retry на том же аккаунте дошёл до
  PreKeyPublication/SecureConnectionError (IOException, Chain PlatformChainAccepted).
  Аккаунт/recovery сохранены; APK/Windows source остаётся прежним. Production,
  GitHub Releases и main merges не менялись; push не выполнен. Release не готов.

## 2026-10-03 — permanent route-generation fencing и retained-device retry

- Registry реализует per-generation reservation из
  [DR-0072](survival-program/decisions/DR-0072-did2-route-renewal-lineage.md)
  поверх текущего exact request, без нового wire или legacy reader. Другой
  nonce/request того же account/XRA generation отклоняется до witness callbacks
  и не расходует дополнительную ёмкость, даже после interrupted signing/restart.
- Operator-only unique-index transaction сохраняет exact старые audit rows,
  counters, capacity и floor; наличие конкурирующих reservations прекращает
  provision без неявного выбора winner. Runtime не выполняет DDL и отклоняет
  отсутствие mandatory fencing provision до подписания.
- Connected Registry HTTP/PG/native-account lane **24/24**, zero skips/failures.
  Реальные PQ/device/witness подписи, SQLCipher и PostgreSQL; TestServer и
  controlled fixture time — не physical delivery или production activation.
  Callback expiry/view faults используют genuine отдельную pending lineage;
  второй nonce уже выданной lineage не является допустимым signing fixture.
- Android после включения VPN снова завершил guarded retained-account retry
  на `XRA1/Expiry`; protected package snapshots совпали. Последний Windows
  proxy-aware retry завершился `NetworkVerification/SecureConnectionError`
  с `IOException` и `Chain PlatformChainAccepted`, не Expiry. Старый displayed
  результат отделён от нового terminal outcome. Аккаунты/recovery сохранены.
- Publication generation fencing, protected current/pending successor adoption,
  matched provisioning/build/deployment, full batch/recovery gates и physical
  contacts/text/files/images/groups остаются открытыми. Production не менялся;
  GitHub push/Releases/main merges не выполнялись.

## 2026-10-03 — DID2 contact-object/publication successor API

- [DR-0076](survival-program/decisions/DR-0076-did2-contact-publication-successors.md)
  connects expired authenticated route/object/publication predecessors to a
  current signed/encrypted successor, XPA and two-node signed commit, then the
  next generation. Bundle ID, locator and owner custody remain stable; signed
  bundle predecessor and ciphertext predecessor hashes stay distinct.
- Shared connected renewal/retained-issuance/publication regression **18/18**;
  final strengthened successor cases **5/5** (subset), Protocol codec/closed-API
  checks **8/8**, zero failures/skips. Native device/witness/node signatures and
  SQLCipher account custody are real; replica results are in-process fixtures,
  not node persistence or physical delivery. Production-source build has 0/0.
- Default current verification still rejects expired objects; genesis APIs reject
  successors before witness callbacks. Corrupt cipher/receipt/publisher, changed
  profile/owner/hash, mutable inputs, genuine signed future issuance, cancellation,
  clock reversal and expiry during signing reject. Broader release gates and
  remaining rollover/hostile boundary coverage are not claimed complete.
- Repeated Windows UI and guarded USB Android network actions in installed
  `e745b63` retained their accounts/recovery and ended at `XRA1/Expiry`. Android
  protected-package snapshots matched. No reset, production mutation, peer,
  text/file/image/group delivery, GitHub push or release publication.
- Protected committed/pending successor custody, permanent per-generation
  Registry serialization, matched consumer deployment and same-account physical
  recovery remain release blockers. This API increment does not activate them.

## 2026-10-03 — connected exact issued-head custody and replay

- [DR-0075](survival-program/decisions/DR-0075-did2-issued-head-response-custody.md)
  connects DR74 to the complete private response, permanent server winner and
  protected client journal. Original request/nonce stays exact across directory
  advancement; current proof/network/time and expiry remain independent gates.
- New connected Shared scenarios: **4/4 passed**, including head1 proposal,
  head2 winner, head3 recovery after lost response or adopted-phase crash,
  publication/phase7 reopen and terminal corruption before callbacks. Actual
  signatures/SQLCipher are used; replica transport remains an in-process fixture.
- Registry **22/22**, XNode coordination **17/17**, Protocol **42/42** passed,
  zero failures/skips. Real PostgreSQL journal tests preserve retired audit bytes,
  reservations and capacity during explicit operator provisioning; actual DID2
  HTTP issuance replays without new signer calls after independent peer admission.
  These checks are focused local evidence, not complete release gates or live TLS.
- Final focused Shared custody/publication/retained-issuance batch: **32/32 passed**,
  zero failures/skips. A broader class run was interrupted for fast-mode scope;
  it is not counted as passing and does not replace the full release gate.
- Retained Windows QA was observed and its network action repeated through UI,
  without deleting the account. It reached `XRA1/Expiry` rather than a network
  timeout. The installed old client does not include this issued-head change.
  USB Android remains authorized. No physical peer/message/asset/group delivery
  or production mutation was performed. Route renewal and matched activation
  remain release blockers. No GitHub push or release publication.

## 2026-10-03 — closed DID2 retained issuance evidence

- [DR-0074](survival-program/decisions/DR-0074-did2-retained-threshold-issuance-evidence.md)
  adds authenticated signed-head retained threshold completion and genesis
  contact-object authoring. Real DID2/native signatures and SQLCipher account
  fixtures cover non-adjacent issuance heads, successor lineage, encrypted
  restoration and fresh publication, keeping default current-head APIs strict.
- Focused integration: **35 Shared + 27 Protocol passed, 0 failed/skipped**.
  Final strengthened retained-issuance negatives: **7/7 passed**; genuine signed
  future heads and wrong issuance windows reject, as do corruption, wrong
  request bindings, expiry, cancellation and clock discontinuity. Builds have
  zero warnings/errors. No device action, account reset or production mutation.
- Exact issuance-head wire response, permanent server replay and protected
  owner adoption remain open; existing journal-5 lost old-head winner still
  rejects. These tests do not prove physical contacts/messages/assets/groups
  or publication replica commits. No GitHub push or release publication.

## 2026-10-02 — actual DID2 Registry runtime canary and matched public export

- The current Registry image started in a separately named, no-published-port
  canary with the existing custody and independent floor. NTS was enabled;
  automatic head renewal remained explicitly disabled during diagnosis.
- A fresh protected ADA2/time-floor/fence backup and separate PostgreSQL schema
  dump were retained and transfer hashes checked before head mutation. Actual
  NTS-backed content-preserving renewal advanced ADH1 to generation 33/tree 12;
  independent floor observation and native authenticated export agreed.
- The retained expired view still yielded DID2 readiness 503. A separate
  canary with the actual native-exported current signed XNV1 returned both
  ordinary and DID2 readiness 200. No verifier, lifetime or TLS guard changed.
  This is proof readiness, not nonce-fresh device proof or message delivery.
- Explicitly authorized native XNode public export succeeded: 25 records,
  all eight role chains, independently pinned genesis and public observer.
  The first export rejected a mistakenly selected current head as genesis;
  the independently retained genesis was used without repinning or reset.
  Three node preparation bundles passed structural custody checks locally.
- Removed disabled retired authority sections from the canonical node compose,
  installer asset and diagnostic preparer: current DID2-only XNode rejects
  those sections even when disabled. Node staging/preparation focused tests
  passed 12/12, ingress contracts 34/34, installer syntax and script suite passed.
- Scoped canary/operator/preparation/staging checks passed 28/28 before this
  configuration follow-up. Canary tooling checkpoint: DevOps `c1e19a4`.
  Actual active Registry ingress, node containers, staking and certbot remained
  unchanged. Persistent renewal, matched live rollout and Windows/Android
  contact/text/attachment/group E2E remain open release gates.

## 2026-10-02 — current DID2 Registry image and production NTS preparation

- Pinned read-only SSH observation confirmed the active Registry still uses
  revision `31d7a14`, without configured automatic NTS or head renewal. The
  separately provisioned time floor was not an active service cutover.
- Actual authenticated production observations passed first in the retained
  operator and then in the newly built DID2-only source image (uncertainty 2s
  and 3s respectively). Reports explicitly deny reusable freshness authority;
  neither result establishes live account proof or message delivery.
- Local source checkpoints: Protocol
  `d6957bbaf2285fbb21e6bc66d1fd3b32d11b59d1` and Registry
  `f8215c882fcf9ad5afd93fab646eb9702dcb4979`. Both source trees are clean.
  The retained Protocol 299-test TRX hash was rechecked; Registry source
  diagnostics reran **37/37, 0 skipped** before image preparation.
  Registry TRX SHA256:
  `340FEFB4A9D6AEE7E5E21431A0BBB405AB71FE941049B6AA23670D71B5B132FE`.
- The Linux amd64 Registry Docker image was built with current Protocol source
  and the reviewed NTS observer, transferred with pinned SSH host trust, and
  its archive hash/source labels verified on production. It has not replaced
  the active service. No ingress, certbot, staking or node identities changed.
- DevOps `a864f4ec06eeeb06e098aaadc653f381421525bb` adds explicit disposable
  `observe-did2`/`renew-did2` operator modes. They remove only explicitly disabled
  retired configuration sections, preserving current custody/mounts/floors;
  active or ambiguous retired authority rejects. Focused contracts **9/9**.
  Existing operator modes are unchanged. This is not a deployment command.
- Runtime canary, persistent automatic renewal, matched complete node/network
  history and physical contact/text/file/image/group flows remain open. No
  GitHub push, CI publication, merge or Release publication in this checkpoint.

## 2026-10-02 — DID2 composer contact-selection isolation

- Fixed a UI recipient-isolation defect: loading a different conversation could
  retain editable draft text from the previous contact. Selection now preserves
  text only for the same dialog; closing or changing the dialog clears it.
  Unknown-send text is restored only for its original conversation, without
  changing its retained operation or automatically sending.
- Focused MAUI messaging UI tests: **16/16, 0 skipped** (6s).
  TRX SHA256: `42172732EFF51C35E4AF10BCBBE9B2581E7DA83E0E1B8F8811DF761E520C33FA`.
  Windows Debug source compiler check: **0 errors, 0 warnings** (19.24s).
  These are UI/source checks, not physical delivery evidence.
- Local MAUI checkpoint: `e1090b523e7f290493031d876b7b6e9575bbdce0`,
  author zhigubigule/no-reply. Not pushed separately from the pending linked
  Protocol/host candidates.
- Fresh strict HTTPS observation: normal Registry health returned 200, but
  `/health/did2/ready` returned **503 `did2-authority-unavailable`**.
  Ordinary health does not establish DID2 readiness. No production state changed.
  Android USB was reconnected and the isolated HTTPS package exists. No new
  account creation or physical contact/text/file/image/group delivery completed.

## 2026-10-02 — Shared retired-owner source cutover candidate

- Shared production source and the dependent DID2 UI-core build with **0 errors,
  0 warnings** against the current Protocol candidate. Old account, directory,
  contact resolver, messaging facade and group runtime sources were physically
  removed, with current DID2 ownership and neutral contracts retained. No new
  production compile exclusion, authority shim, wire operation or downgrade.
- The obsolete initiator outbox/reader/fork table is removed from the retained
  ratchet store. SQL schema **9** requires explicit reset of generation 8.
  The new SQLCipher test verifies rejection without changing the database file;
  it does not migrate or recreate a registered old state.
- The connected fixture now completes operational genesis only after actual
  native DID2 proof verification. The isolated network-history failure found an
  old fixture distribution bug: after advancing topology it distributed the
  previous PMA2, not the signed successor PMA2. The verifier correctly rejected
  it; only the fixture's current policy selection changed.
- Focused current-source gate: **48/48, 0 skipped**. Coverage includes local
  text/file/image offers, protected SQL custody and materialization, hostile
  mutations, removed owners, schema cutover and both network-history regressions.
  TRX SHA256: `66DD12AA44ABB4DA62E0773012158F6F2D8918B4C7530DC8464F0CCCFAAF71E6`.
- The actual Windows application Debug source build also completed with
  **0 errors, 0 warnings** (38.46s), without publishing, installing or launching.
  It is a compiler check, not a qualified physical/release build.
- A broader diagnostic run was interrupted after failures rather than treated
  as acceptance. Receiver retry diagnostics found a fixture that discarded its
  replica's previously observed publication while the owner correctly avoided
  redispatch after commit; the durable replica observer is corrected and checks
  exact request hashes plus no redispatch after commit.
- The two connected native tests passed individually in the rebuilt diagnostic
  batch: receiver one-time consumption/recovery at all three commit boundaries
  (1m41s), and owned publication/reverse Accept/text/semantic interruption/lost ACK/
  next empty poll (4m43s). That batch was **not green overall**: 48 passed and
  11 obsolete-test failures. The raw-scope initial-batch path and its retired
  tests are removed; neutral exact-DPE2 fixture now starts ordinary sequence at3.
  Their relevant business behavior is exercised through current owned native
  custody, not a restored V1 adapter. Diagnostic TRX SHA256:
  `86657E1FDA8C4C36AE57B0AE6E8CBF7C22E003B66BCCE46CC61F2BE37C8D1985`.
  The final focused current-source rerun passed **53/53, 0 skipped** (2m1s):
  retained ratchet atomicity/CAS/crash/restart, exact-DPE2 durable transactions,
  removed surface/schema checks and native receiver one-time recovery across
  every commit boundary. All current production test sources compiled.
  Final TRX SHA256: `9870B652AD84A0FD55ED2380CB7B8B70F84AEE3A4AB81329E555F9D4659D9BE8`.
  Local Shared checkpoint: `9bac6e70d151185943f187b8a88577fb04d0943e`
  (zhigubigule, GitHub no-reply); Shared tree clean. Not pushed independently of
  the still-pending linked Protocol/host/tool candidates. Removed source remains
  recoverable from Git history and private local snapshots.
  Final connected acceptance, MAUI package checks, obsolete test retirement,
  commits and physical contacts/text/files/images/groups remain separate gates.
  No production or device state changed in this source slice.

## 2026-10-02 — Registry source consumer cutover (not device evidence)

- Registry production source now builds against the same retired-surface
  Protocol candidate with **0 errors, 0 warnings**. ADA1 admission, V1 directory
  proof/current-value endpoints, artifact source and the old package-authoring
  operator action are removed. No live deployment, protected state, registered
  node identity or custody changed; exact deleted source snapshots were retained
  locally. Removed configuration must be absent, even when disabled.
- Neutral time/witness custody and the durable nonce ledger were extracted
  unchanged: five declarations were AST-compared against their saved originals;
  only the neutral replay DTO type name differs. Its bounded four-field input
  carries no query, freshness or network capability.
- The catalog freshness consumer uses the actual DID2 verifier, an independent
  configured public credential and ADA2 head under the external floor, with
  pre-release head/clock checks and elapsed retention projection. The existing
  neutral framing is unchanged; reader version two is mandatory.
- The existing focused diagnostics lane passed **37/37, 0 skipped** against
  actual Registry and XNode source. New coverage includes strict configuration,
  defensive request buffers, durable nonce replay after restart/boot changes,
  cancellation/wrong-network before filesystem mutation, missing DID2 context
  before challenge consumption and reader rejection before closure copying.
  The ledger tests derive an actual epoch from signed neutral XNA1/DTS1; they
  do not issue a native account proof or test a positive catalog/network path.
  TRX SHA256: `EBF56992F7D64E344036FD37FB802A805CCBD86901EA14EDCDF2217F631BB6BB`.
- The focused lane has no Shared dependency because these tests consume only
  Registry/Protocol; the default full gate still includes Shared and all test
  sources. Positive joined/native catalog, mixed V1 test fixture replacement,
  Shared/MAUI source cutover, final package/API gates and physical contacts/
  text/files/images/groups remain open. Changes are uncommitted candidates.

## 2026-10-02 — DID2-only XNode source and two-stage operational genesis candidate

- The XNode host production source compiles against the retired-surface Protocol
  candidate. Eight exclusively V1 authority/evidence providers were removed;
  mixed runtime members and old authority configuration were cut out without a
  compatibility reader. The current DID2 contact composition and independently
  registered proof/clock remain the only opt-in contact authority path. Removed
  configuration is rejected even when disabled. Existing files were preserved
  in operator custody before removal; registered identities and remote state
  were not changed.
- [DR-0070](survival-program/decisions/DR-0070-did2-operational-genesis-proof-order.md)
  separates a constructor-closed signed network candidate from completion with
  real DID2 evidence and current monotonic time. Defensive copies, exact
  authority/view binding and checks before topology callbacks prevent pending
  artifacts from becoming a verified capability. The time lease subtracts
  elapsed time from network hard expiry as well as DTT1 freshness.
- Focused Protocol tests passed **299/299, 0 skipped**; TRX SHA256
  `7855155AD905F7F12B9AF96EC7C6A5FD3F11F230861F723F643F04E79A64B461`.
  The operator bootstrap synthetic-input gate passed all five named scenarios
  on the new public ceremony, including DID2-only historical verification,
  wrong requested credential, invalid lengths, retired reader and successor
  checks. It never opened production custody. A historical signed snapshot is
  not NTS acquisition or current readiness.
- The XNode focused lane passed **31/31, 0 skipped** again after the final
  time-lease correction. It uses actual native
  DID2 account/device/directory signing and durable stores with an in-process
  authenticated HTTP handler, not live sockets/TLS or device delivery.
- These changes are an uncommitted linked source/API candidate. Registry and
  Shared release-source builds still expose retired consumer dependencies;
  full gates, approved API/resource/package snapshots and pins, deployment,
  physical Windows/Android contact/text/file/image/group E2E remain open.
  No GitHub Release or production update was performed by this increment.

## 2026-10-02 — durable opaque XNode BLOB chunk storage

- XNode `5f4946a` adds an internal content-addressed ciphertext storage primitive:
  bounded chunks/count/bytes, exclusive owner, service-restricted regular files,
  content/hash verification, flushed staging/atomic promotion, exact retry without
  rewrite, cold-reopen inventory and fail-closed uncertain durability/corruption.
  Only closed unpublished staging may be discarded. It introduces no public
  wire/interface, legacy URL, capability bypass or active server dispatcher.
- Focused tests passed **17/17, 0 skipped** on Windows and **17/17, 0 skipped**
  in actual Linux Docker, including a full-size hundred-chunk transfer resumed
  after 25 percent/cold reopen, byte/count quota, corrupted/hostile files, exact
  replay, cancellation and injected failures before/after atomic promotion.
  Linux TRX SHA256: `46AF227E5B8CC8D2EA1B88136C8A02A2D01EDDF70879F8A171FCECE5E947F591`.
  The optional digest-pinned test Dockerfile changes no default runtime image and
  mounts no production state or keys; actual file barriers are not power-cut,
  remote signed receipt, replication or device-delivery evidence.
- [The XNode component guide](../xnode/docs/BLOB_STORAGE_COMPONENT.md) records
  the boundary and remaining authenticated object/circuit/lifecycle composition.
  Production/node identities, Registry/staking/certbot and device accounts were
  not changed. Existing unrelated XNode/DevOps worktree edits were preserved.
  Matched installation assets, contacts/text physical E2E, encrypted remote
  files/images and governed groups remain release blockers.

## 2026-10-02 — complete local DID2 attachment materialization

- Shared `6c8c866` connects whole-file assembly to the existing internal
  account-owned asset readback. Frozen DAM1/chunk geometry, every ciphertext
  commitment, actual AEAD and the protected plaintext digest must all pass
  before independently disposable content is returned. Failed/cancelled
  assembly exposes no prefix and clears temporary content. No public transport
  API, schema, journal generation, wire or crypto provider changed.
- The final focused native/SQLCipher/component batch passed **22/22, 0 skipped**
  in 2 seconds, including 25-MiB exact reconstruction, chunk-boundary cases,
  missing/extra/reordered/truncated/corrupt-final data, wrong key/digest,
  cancellation/disposal and actual account-service adoption crash/cold restart.
  TRX SHA256: `09DDDDC056AA85F698FE7739B924203D61AB0ACD2A73946683B4891C3D1BF885`.
  This is local custody evidence, not incoming-offer authorization, remote
  BLOB receipt, a MAUI renderer or physical Windows/Android acceptance.
- The local boundary is recorded in DR31 and mapped in the Shared-owned
  architecture document. Matched production installation assets, encrypted
  masked upload/download/resume, governed groups and full device E2E remain
  open. Production configuration/state and device accounts were not changed.

## 2026-10-02 — exact external-signer response boundary

- Registry `b2e9dd0` removes an instantaneous socket-buffer check from the
  external signer used by DID2 private mailbox grant custody. It now requires
  the exact signature followed by peer end-of-stream under the original
  deadline, rejecting delayed trailing bytes, truncation, absent completion,
  timeout and caller cancellation. No signing domain, crypto provider or
  grant-authority API changed; Protocol still independently verifies signatures.
- The optional, pinned Docker target `mailbox-signer-tests` compiled the current
  Registry/Protocol source and passed **6/6, 0 skipped** using actual Linux Unix
  sockets. It consumes synthetic public frames and no signing key or production
  state. Its retained TRX is a socket regression artifact, not issuance, live
  network, Windows/Android or release evidence. The default image/full gate is
  unchanged. Operator prerequisites are documented in the Registry-owned
  [private grant guide](../deep-registry-api/docs/DID2_PRIVATE_MAILBOX_GRANTS.md).
- Fresh public readiness inspection still returned **503**. No production
  image/configuration was switched by this step. The previous host-assets
  export policy restriction remains; request existing permitted output rather
  than retrying a bypass. Complete matched rollout, real role-signer issuance,
  encrypted remote BLOB transport, governed groups and physical E2E remain open.

## 2026-10-02 — protected node predecessor capture and account-command cancellation

- Read-only, pinned-SSH snapshots of all three registered nodes were
  independently authenticated by XNode's existing offline floor/anchor audit.
  All retained the same revision-2 network history. A Protocol-internal,
  explicitly opt-in operator test matched each exact protected predecessor to
  the installed eight-chain source, without a new shipping API or DNH2 parser.
  The actual capture recheck passed **1/1, 0 skipped**; the report is historical
  custody only, never freshness/receive permission.
- Fresh authenticated NTS observation had a 2-second uncertainty. Existing
  canonical preparation generated a separate private current/next transport
  key set, preserving all registered identities. Native authoring accepted the
  strictly monotonic operational successor, and full eight-chain export passed.
  No production container/configuration or certbot was switched in this step.
  The subsequent host-install export was blocked by tool policy; that boundary
  was not bypassed, and public Registry/device readiness remains unproved.
- MAUI commands now cancel on account replacement or loss of verification and
  recheck delayed reads before transport/projection mutation. A delayed platform
  lookup cannot revive an old contact command after reset or reverification.
  Focused messaging UI tests passed **10/10, 0 skipped**, including both races;
  these use a stub runtime and are not physical delivery evidence.
- Full release gates, matched server/client rollout, contacts/text, encrypted
  remote files/images and governed groups on real Windows/Android remain open.

## 2026-10-02 — real production NTS and content-preserving DID2 head renewal

- Registry `8687d5a` removes the operator renewal's accidental manual-time
  dependency after automatic-time cutover. The observer uses the verified
  signed policy and protected lower floor, reacquires on every invocation,
  waits at most 30 seconds and never falls back to manual/OS/HTTP time.
  Its closed observation report is not DTT1 or transferable freshness evidence.
- Targeted time/operator tests: **32/32 passed, 0 skipped**; scoped DevOps
  operator contracts: **7/7 passed**. The Linux/amd64 image was rebuilt and
  transferred using pinned SSH; archive hash and complete Registry revision
  were checked before use. The operator script accommodates the server's
  existing Node 12 syntax without upgrading system packages.
- Under Mr. X's existing deployment authorization, a disposable candidate
  activated the separate protected NTS floor and retained its transition fence.
  Real acquisition then returned an authenticated quorum with 3-second
  uncertainty. This was actual server/network execution, not injected samples.
  The stale manual anchor and initialized directory were not re-provisioned.
- Current ADA2, NTS floor and fence were copied into private operator custody
  before renewal, with stable source/copy fingerprints and HMAC checks against
  independently retained keys. Registry then verified the complete directory
  and independent PostgreSQL floor and performed a content-preserving renewal
  to **ADH1 generation 32/tree size 12**. A second retained backup and native
  exact-head export verified that head against the newly observed core hash.
  No account content, genesis or registered node keys were reset.
- The old public Registry container, ingress, staking, certificate configuration
  and three XNode deployments were not replaced. Public readiness, complete
  current operational distribution, ongoing renewal and Android↔Windows
  contact/text/file/group delivery remain open. Operator success is not a
  production-release or device-E2E claim; no GitHub Release was published.

## 2026-10-02 — explicit manual-to-NTS protected floor transition

- DR-0068 and the Registry operator candidate add a first automatic-time
  floor for an already initialized directory without re-provisioning ADA2.
  Manual-anchor CAS/HMAC and pinned XNA1/DTS1 are mandatory; only retained
  historical lower constraints are transferred. No uptime, old upper bound,
  OS/HTTP time or artifact lifetime is promoted to current-time authority.
- CreateNew staging and an authenticated one-time fence precede activation.
  Exact interrupted staging can resume; an existing/advanced floor or completed
  transition with lost floor cannot be reset. The automatic runtime rejects
  pending activation and still requires fresh authenticated NTS acquisition.
- Focused transition/time slice: **24/24 passed, 0 skipped**. Includes CLI
  arity/scope/path/nonce-ledger/key alias negatives, old-state immutability,
  CAS/HMAC failures, crash recovery, exact pending/fence conflicts, restart,
  acquisition loss and prohibition of lost-floor reinitialization. Observations
  are controlled test inputs; this is not real NTS or device delivery evidence.
- Read-only pinned SSH copied only the live protected manual anchor into
  private operator custody. Its exact fingerprint and HMAC verified against
  one independently retained local time-integrity key. No remote key, state,
  container, floor, staking or certificate configuration was changed. The
  retained stale anchor is not fresh-time evidence.
- The extended time/operator slice passed **25/25, 0 skipped**, adding exact
  signed-window inspection and bad-pin rejection without custody mutation.
  Current linux/amd64 candidate `2def8a2` was built with complete Registry,
  Protocol and observer revision labels; a read-only, network-disabled container
  verified the actual retained pinned XNA1/DTS1. This proves packaged offline
  verification, not NTS acquisition, server readiness or physical messaging.

## 2026-10-02 — Registry authority diagnosis and isolated coordination slices

- A pinned-host-key, read-only Registry audit confirmed public DID2 readiness
  503. Only source-whitelisted literals/types were reported; the deployed
  protected manual-time anchor is stale and automatic NTS is not configured.
  No remote containers, staking services, custody or floors were changed.
- Current route/publication business slice: **33/33 passed, 0 skipped** on
  real isolated PostgreSQL, native PQ verification and SQLCipher. Lost-response
  publication retains exact durable bytes; immediate retry is correctly empty
  429, then succeeds after advancing only the test admission scheduling clock.
  The negative route fixture now corrupts PMT2 explicitly, not the last byte
  of the added independent PMA2 chain. Production admission is unchanged.
- Closed diagnostics: **15/15 passed, 0 skipped**; stale manual-anchor and
  monotonic reset are static Error reason labels, never arbitrary messages.
  Private grant JSON/admission/journal slice: **10/10 passed, 0 skipped**,
  including real PostgreSQL concurrent exact winners and restart/corruption.
  This does not prove the full signer/proof/TLS grant issuance composition.
- Registry CI definitions now provide disposable PostgreSQL for mandatory
  DID2 floor/route/grant tests and serialize candidate builds to avoid
  conflicting Protocol source/test-seam writes. Workflows were not run at
  this checkpoint. Full gates and physical contact/text/file/group remain open.

## 2026-10-02 — current physical packages and eight-chain deployment boundary

- Strict committed-source Windows and Android candidates were built; the USB
  APK was installed with all three protected packages unchanged. Physical Android
  onboarding reached the workspace; Settings retained the new address/encrypted
  recovery across process restart. The network action still failed at AccountProof
  with closed `TransportIo`. The Windows isolated reset confirmation remains
  pending. No physical contact/text/file/image/group success is claimed.
- MAUI harness `2d5cf17` adds separately owned, explicitly confirmed Android
  startup reset. Two focused UI/composition tests and four title/UID focus cases
  passed. A disappearing reset dialog and transient post-Create hierarchy failure
  were followed by observation, never blind repetition.
- The actual HTTPS distributor returned NCP2 version2 with **seven** chains;
  the current production adapter rejected its header. The source-cutover Registry
  distribution slice passed **9/9**, **0 skipped**, including empty 503 rejection
  of the retired bundle. No Registry deployment was performed at this checkpoint.
- DevOps `5a7148c`, exporter `b29be4c` and installer `8e6fadc` retain complete
  PMA2 public assets without promoting them into placement/freshness authority.
  Preparation/staging slice **12/12 passed**, **0 skipped**, including absent,
  duplicate/gapped PMA2 and placement substitution, plus vendored-byte equality.
  The synthetic operator/export gate passed all five cases. Retained signed
  genesis plus two successors were re-exported into a new complete eight-chain
  history without opening signers or changing account/genesis/floors. This is
  historical raw distribution, not current network or device authority.

## 2026-10-02 — committed-source contact device checkpoint (physical run open)

- Local candidate checkpoints, all authored by `zhigubigule` with the configured
  GitHub no-reply email: Protocol `95578bb`, Shared `5fdbb34`, MAUI `1261920`.
  These freeze the connected contact/text candidate for reproducible physical
  packages, not a public Release, shipping activation or completed full gate.
  Each of these three source trees is clean; other service work is preserved.
  Generated nested Protocol build artifacts are ignored, not committed/deleted.
- Focused current reply-route/contact-control/chunk/native-ownership codec
  checkpoint **24/24 passed**, **0 skipped**, 2s,
  `did2-native-contact-checkpoint-codecs.trx`. Earlier joined native receipt/
  restart/ACK and focused UI evidence remains recorded below. Full API/graph,
  evidence ownership, consumer repins and release gates remain the final batch.
- Windows automation now returns and captures the actual old QA window. It is
  rejected at account startup, not a chat/message success. No reset, new account
  or send action executed. Fresh committed-source Windows/APK and physical
  contact/text/restart are next; files/images/governed groups remain open.


## 2026-10-02 — durable ordinary Store/UI restart candidate (device open)

- [DR-0067](survival-program/decisions/DR-0067-did2-ordinary-store-completion-and-ui-retry.md)
  was accepted before the ordinary-journal clean break and application-registration
  advancement. Only the actual owned adapter plus final guards can retain Store
  completion; it is not recipient delivery. The local original-operation/text
  projection verifies actual custody/catalog and the SQL mirror in one transaction.
- MAUI checks retained original text operations before allocation and on selection
  after restart. Exact retry remains explicit; different text/conversation cannot
  replace an unresolved operation. Successful Store clears input before history
  refresh, preventing UI errors from resurrecting a completed send.
- Initial focused custody checkpoint **19/19 passed**, **0 skipped**, 921ms,
  `did2-ordinary-completion-custody.trx`; focused UI closure/error tests **3/3
  passed**, **0 skipped**, 1s, `did2-durable-text-ui.trx`. The UI tests do not
  construct authenticated conversation handles or claim transport/restart proof.
  The expanded native unknown-reply/protected-projection/reopen and contact/ACK
  checkpoint then **passed 21/21**, **0 skipped**, **5m49s**,
  `did2-durable-ordinary-store-restart.trx`, including the two actual native
  joined tests plus current focused custody cases. Original operation/text
  survives repeated pre-dispatch interruption and lost Store reply; verified
  completion is absent from the pending projection after reopen/cache retry.
  Additional fault assertions immediately before/after protected completion
  subsequently **passed 1/1**, **0 skipped**, **2m01s**,
  `did2-ordinary-completion-crash-boundary.trx`: failure before completion keeps
  the original operation pending; failure after protected completion leaves no
  pending text. Exact cached receipt recovery adds no third ingress, and the
  existing SQL rollback/root-loss refusals remain. No assertion/deadline weakened.
- UI metadata was isolated into an internal composer state, not a Shared trust
  handle/authority seam. Restart restores the original operation/text, defensive
  copies survive caller clearing, another text/conversation cannot replace an
  unknown send, and malformed retained IDs reject without replacement. Focused
  UI checkpoint **8/8 passed**, **0 skipped**, 2s,
  `did2-composer-original-operation-restart.trx`. This is UI-state evidence,
  not execution of account/network restart or physical delivery.
- Opt-in HTTPS Windows ARM64 working-tree compilation before the small composer
  extraction completed **0 warnings / 0 errors**, 27.86s. The extracted Core
  subsequently compiled in the focused UI test above. Neither output is a
  committed-source qualified physical build, install or launch.
- USB Android remains connected. Windows automation's prior request-budget error
  remains unresolved; no helper reset/budget bypass, device send or reset executed.
  Qualified committed-source packages, physical contacts/messages/restart,
  remote BLOB/groups and final API/graph/consumer gates remain open. No deployment,
  commit, push or Release publication in this checkpoint.


## 2026-10-02 — application random-key storage checkpoint (connected/device open)

- Expanded command replay/projection test failed after **5m53s** at the final
  reverse-Accept ACK semantic fence, with cancellation wrapped as an unknown
  outcome. The exact page/ACK cycle remained retained. Its preceding cached
  Accept and protected contact-intent projection assertions passed. No deadline
  or semantic fence was relaxed; the earlier completed command checkpoint is
  not relabelled as evidence for these new assertions.
- [DR-0066](survival-program/decisions/DR-0066-did2-application-sqlcipher-random-key.md)
  was accepted before changing DMB1 to native random-key encoding, SQL generation7
  and mandatory application-registration version2. Domain-separated/random
  binary keys no longer incur password derivation on each reopen. DSV2/DMS2,
  network/server floors and registered node keys are unchanged; older isolated
  accounts require explicit reset, not migration or implicit recreation.
- Focused storage/custody checkpoint: **62/62 passed**, **0 skipped**, 1s,
  `did2-application-random-key-custody.trx`: correct raw-key/schema7 reopening,
  encrypted bytes, wrong/zero/short keys, password-mode/schema6/registration1
  rejection without mutation, FULL/secure-delete/WAL policy, direct semantic
  materialization and attachment/text custody. The initial test hook had a
  Task type-inference compile error, corrected. A test incorrectly assumed
  the account's DELETE policy also applied to DMB1; inspection and real policy
  sampling confirmed its existing WAL, which is preserved. No product policy
  or negative integrity assertion was weakened.
- The unchanged extended native vertical then **passed 1/1**, **0 skipped**,
  **2m55s**, `did2-application-random-key-vertical.trx`, including protected
  intent projection, cached original acceptance winner despite a different
  repeat input ID, local-authored message projection and retained-page/
  semantic-fault/lost-ACK/exact-replay/next-empty-poll checks. The previous
  30-second ACK deadline and all semantic fences are unchanged. This is
  signed native in-process/SQLCipher evidence, not socket or device delivery.
  Five focused MAUI account/UI checks also passed against generation7, 0 skipped.
  Full
  API/graph/consumer repins, qualified physical Windows/USB Android, text-outbox
  UI restart, real remote BLOB and governed groups remain open. No production
  deployment, commit, push or release publication in this checkpoint.


## 2026-10-02 — application contact/text vertical and UI candidate (device open)

- [DR-0065](survival-program/decisions/DR-0065-did2-contact-application-command-boundary.md)
  exposes account-owned business commands with key-free internally constructed
  conversation handles, independently refreshed contact states and authenticated
  SQL message rows. Text rejects before authoring when acceptance is missing.
- Connected business-command vertical: **1/1 passed**, **0 skipped**, about
  **7m56s**, `did2-contact-application-vertical.trx`. Actual Start/Accept/SendText/
  List consumers join initial Store/Hello/ACK, reverse Accept, text, interrupted
  semantic materialization, lost ACK, exact retry and empty next poll. Original
  byte/hash checks remain; dynamic command ciphertext is independently matched
  to protected custody and real peer decryption. Signed native/SQLCipher fixture,
  not sockets, UI, remote chunks or physical delivery.
- MAUI connects these commands to the existing visual language: contact entry,
  request/accept states, text composer and responsive list/detail. Focused UI
  checkpoint **5/5 passed**, **0 skipped**, 1s; then current Clean checkpoint
  **51/51 passed**, **0 skipped**, 4s. These test UI closure, exact in-process
  retry and error sanitization, not transport authentication or physical delivery.
- Normal Windows ARM64 compilation and subsequent opt-in HTTPS working-tree
  compilation both finished **0 warnings / 0 errors**. First UI compile found
  two wrong Grid.SetRow overload calls; fixed without changing the runtime.
  Compile-only output is explicitly not device-qualified; strict physical
  expected-commit/clean-tree checks remain. Follow-up HTTPS QA incompatible
  startup reset is explicit and isolated, never automatic shipping repair;
  Follow-up recovery/compile-only boundary: **7/7 passed**, **0 skipped**, 2s;
  subsequent current Clean checkpoint **53/53 passed**, **0 skipped**, 6s,
  `did2-contact-text-ui-current.trx`. HTTPS QA recovery compilation also passed
  **0 warnings / 0 errors**. These are not reset execution or physical evidence.
- UI now retains an explicit idempotent acceptance-delivery retry after local
  acceptance, offers refresh inside the narrow conversation view, and resets
  the visual list selection on returning to it. Extra native projection/replay
  assertions completed after DR-0066; see the later storage checkpoint above.
- Read-only Registry readiness returned **HTTP 200**. Windows helper could list
  current windows, but opening the isolated debug client returned **request
  budget exhausted**; its process exists, so launch outcome is not treated as
  a verified UI state. No click/reset/create/send or physical result was claimed.
  BLOB/groups, outbox UI restart, full API/graph/repins and qualified device
  activation remain open. No production deployment, push or release publication.


## 2026-10-02 — owned initial contact draft before claim (local; shipping/device open)

- [DR-0064](survival-program/decisions/DR-0064-did2-owned-initial-contact-draft.md)
  froze protected draft custody before implementation. Init/Hello now originate
  in the account owner from current own DMD1 and actual phase-7 publication;
  exact size is checked before rendezvous/claim mutation. The mandatory root is
  initialized atomically with the account instance; missing/foreign/old roots
  require explicit isolated QA reset. No migration or larger initial bucket.
- First connected draft checkpoint: **1/1 passed**, **0 skipped**, **7m11s**,
  `did2-owned-contact-start-vertical.trx`: original Init/Hello survive caller
  mutation and service reopen, then actual native initial/reverse Accept/text
  Store/Retrieve/ACK. This is signed in-process authority/SQLCipher evidence,
  not physical UI, remote sockets or attachment chunk delivery.
- Expanded draft/claim-custody checkpoint: **13/13 passed**, **0 skipped**,
  **7m39s**, `did2-owned-contact-start-custody.trx`. Twelve focused structural/
  preflight cases plus the joined native vertical cover post-CAS interruption,
  exact draft recovery, no claim preparation before a draft, peer substitution,
  mandatory-root deletion, hostile sizes/metadata and cancellation. An initial
  fault-harness mistake attempted add-only overwrite; it was corrected to real
  compare-exchange, without weakening the storage contract or assertions.
- Connected internal completion checkpoint: **14/14 passed**, **0 skipped**,
  **2m32s**, `did2-owned-contact-completion.trx`: twelve structural/preflight
  cases and two actual native scenarios prove current owner-authored completion,
  exact account restart and completed-source retry after initial-key retirement.
  The fixture's completion delegate now calls the owned command, not a raw-event/
  proof/offering composition. Clock continuity and deadline fences remain enforced.
  Shipping StartContact/accept/text/list composition, BLOB/groups, matched live
  authorities, physical Windows/USB Android and final API/graph/consumer repins
  remain required. No deployment, commit, push or release publication here.

## 2026-10-02 — mandatory private-route control and reverse Accept (local; device open)

- [DR-0063](survival-program/decisions/DR-0063-did2-contact-reply-route-embedding.md)
  was frozen before the mandatory Hello/Accept package, variable version2-only
  acceptance journal and actual authenticated-route consumer. No old control
  reader, migration, resolver fallback or new DPH2 padding bucket was added.
  Four current vectors, machine bounds/schema and anchor were updated together;
  the provided generator is repeatable and schema validation passed.
- Protocol focused gate: **31/31 passed**, **0 skipped**, **365ms**,
  `did2-private-route-embedded.trx`. This covers exact minimum/maximum payloads
  and records, defensive private-package framing, retired/hostile bytes, current
  endpoint substitutions including the wrong sender route, clocks and cancellation.
- Joined Shared checkpoint: **4/4 passed**, **0 skipped**, **7m38s**,
  `did2-private-route-reverse-accept.trx`: actual own phase-7 publication on both
  accounts; initial Store/Retrieve/Hello/ACK; reverse Accept Store/Retrieve/ACK
  via the authenticated Hello route; peer acceptance from actual receive custody;
  then ordinary private-route text, retained-page/semantic interruption, lost ACK,
  exact reopen/retry and an empty next poll. It uses real native accounts,
  SQLCipher, cryptography and signed in-process issuer/terminal authorities:
  **not** socket/device evidence or remote ciphertext-chunk transfer.
- Final variable-journal structural/SQL/in-memory parity gate after additional
  hostile-length/byte-bound negatives: **3/3 passed**, **0 skipped**, **5s**,
  `did2-variable-accept-custody.trx`. Initial test compilation errors were corrected
  before these completed results; no production assertion/deadline was weakened.
- Android USB device is currently available. MAUI owned business commands,
  initial-size preflight before claiming, route renewal, live authority closure,
  physical Windows/Android, masked BLOB transport and groups remain open. Full
  graph/API review/repins and commits are deferred to the coherent business batch.
  No deployment, push or release publication in this checkpoint.

## 2026-10-02 — private DID2 reply-route boundary (local; reverse/device open)

- [DR-0062](survival-program/decisions/DR-0062-did2-private-contact-mailbox-route.md)
  was frozen before the new bounded route package and closed current-peer
  verifier. Its locator uses the existing public credential derivation;
  resolver-read/retrieve capabilities and private keys are not transmitted.
  Hello/Accept bytes remain unchanged until a separately frozen joined
  event/custody cutover; this package alone does not close reverse delivery.
- Protocol codec/domain boundary: **19/19 passed**, **0 skipped**, **81ms**,
  `did2-private-reply-route-codec.trx`, covering both exact bounds, defensive
  ownership, hostile sizes/header/lengths, retired inner versions, mixed
  delegation/network/route references and unchanged locator derivation.
  The first compilation found a missing test namespace alias; corrected
  before the reported completed checkpoint. Production Protocol build has
  zero warnings/errors.
- Actual Shared owner checkpoint: **1/1 passed**, **0 skipped**, **9s**,
  `did2-private-reply-route-owned.trx`. The internal drafting input requires
  actual own phase-7 publication; uncommitted route export rejects. Actual
  current verification derives the same locator as XPU1, exact route metadata
  survives owner reopen, and other-peer/cancellation/expired-proof cases
  reject. This uses native accounts, SQLCipher and real signed fixture
  authorities, not socket or device evidence. The initial test compilation
  exposed the missing explicit production Compile item and a misnamed reopen
  helper; both were corrected. Its first native run then found a fixture
  assumption: advancing 40 seconds did not expire the actual captured proof.
  The negative now advances to that proof's exact verified deadline; no
  product expiry check or assertion was weakened.
- Reverse Accept Store/Retrieve, authenticated retained private route heads,
  MAUI business commands, attachments/groups and physical Windows/USB Android
  remain open. No deploy, commit, push or release publication in this increment.

## 2026-10-02 — connected owned recipient checkpoint (local; live/device open)

- [DR-0058](survival-program/decisions/DR-0058-did2-owned-mailbox-retrieve-and-ack.md)
  was frozen before the protected read journal and recipient implementation.
  Mandatory account initialization, captured-page-before-SQL custody, actual
  semantic receive and signed tombstone ACK/recovery are connected internally;
  MAUI shipping activation is not implied.
- Closed read-root structural checks **16/16 passed**, **0 skipped**, **42ms**,
  `did2-mailbox-read-journal.trx`. The first connected native recipient run
  **failed** after **9m24s**; its 16 structural checks passed, but duplicate
  SQL directory/network rechecks consumed the bounded dispatch time after
  page capture and before semantic receive (`did2-owned-mailbox-receive-and-ack.trx`).
  Outcome remained unknown rather than announcing receipt. The private owner
  publication recheck now adds exact custody to the context's independent
  freshness check without reopening those same SQL stores a second time in
  each fence. The 30-second bound, proofs, signatures and protected checks remain.
  The next repeat reached the intended SQL page-commit interruption and retained
  phase-3 page without ACK, then **failed** after **9m55s** on fixture time:
  dispatch's real elapsed clock advanced creation time, but a newly fetched
  signed fixture proof reset to its old static sample, making the retained
  envelope appear future (`did2-owned-mailbox-receive-and-ack-recovery.trx`).
  Advance both fixture proof time and monotonic sample between those released
  leases; preserve production envelope validity checks. Connected repeat is
  pending, including SQL page-commit/outcome interruption,
  semantic fault, lost ACK response, exact reopen and next empty poll.
- Owned prepared Retrieve rejects retry exhaustion without advancing traversal.
  Exact captured-page recovery independently checks actual SQL inbox/traversal
  and outcome; ACK retains raw verified quorums, not only SQL's digest summary.
- An initial DPH2 consumer now composes independent initiator proof fetch,
  actual own published closure, atomic receiver source commit and owned import/
  initial-event materialization. Initial ACK independently rereads those actual
  source/catalog/active mutable rows. Source-only build has zero warnings/errors;
  its new native consumer check and full initial mailbox dispatch/ACK remain
  pending. The latest repeat includes the actual initial consumer; its mailbox
  terminal still serves ordinary text, not initial DPH2 ACK evidence.
- The initial-consumer repeat reached/asserted the actual incoming contact but
  **failed** after **9m25s** before its first Retrieve callback: the newly sampled
  dispatch policy's static fixture clock was earlier than the prepared request's
  `NotBefore` (`did2-owned-mailbox-receive-initial-checkpoint.trx`). No ACK/delivery
  claim follows from that partial progress. This native mailbox scenario now
  uses opt-in continuously moving monotonic/signed fixture time from dispatch
  setup, sampling proof time once per signed response. Other controlled-clock
  tests retain their deterministic behavior. Production `NotBefore`, expiry and
  retry-lease checks are unchanged; connected repeat remains pending.
- The moving-clock repeat **failed** after **13m53s**, with the 16 structural
  checks passing, because its genuinely signed 500-second XNV/head fixture
  interval expired while recovering the captured page
  (`did2-owned-mailbox-receive-moving-clock.trx`). This one long-running fixture
  now authors longer signed view/head intervals within the unchanged root
  bounds. Production proof freshness and expiry checks remain unchanged.
  That repeat **failed** after **15m56s**, with 16 structural checks passing
  (`did2-owned-mailbox-receive-signed-window.trx`): exact retained-page receive
  reached ACK recovery, but redundant full SQL/semantic fences exhausted the
  unchanged 30-second budget after the ACK response. The interceptor now performs
  one full fence before callback and one after response, with protected capture
  CAS/read-back and a full final fence after SQL outcome read-back. Redundant
  adjacent full reconstructions were removed, not authority/expiry checks.
  Initial import also
  refreshes the independent peer after releasing the source-commit lease, and
  the batch acquires its ACK endpoint set after all receive commits; neither
  stretches earlier proofs. The batch ordering and ACK fence edits postdate that binary.
- [DR-0059](survival-program/decisions/DR-0059-did2-owned-initial-mailbox-dispatch.md)
  was accepted before connecting initial Store to the same owned dispatch
  engine. Its service copies the intent before awaits, derives only the actual
  initialized sender scope and dispatches only its retained retired-source
  DPH2; normal sends still require actual direction-1 DPE2 rows. Stable active
  mutable custody and exact historical-source read-back remain mandatory.
  Source-only build has **zero warnings/errors**. The connected test now includes
  rejection before transfer, intent mutation, original DPH2 Store/receipt,
  cached dispatch, recipient Retrieve/Hello/ACK, exact source replay and the
  existing text interruption/reopen sequence. Its first connected run reached actual initial Store, then **failed**
  after **7m32s**, **31 passed / 1 failed / 0 skipped**,
  `did2-initial-store-hello-ack-text-checkpoint.trx`: an independently refreshed
  directory proof did not renew the original short-lived contact-read request.
  Both owned sender entries now perform an actual new non-consuming resolve
  from the verified address before current own/peer verification; old Store
  route/grant/MAU2/counter/lifetime still cannot change on retry. Connected repeat
  includes that correction and generation3 account storage below.
- No physical/device, production deployment, full gates, commit/push or release
  evidence in this increment. Remote attachment chunks/groups, initial sender,
  matching live authority and full Windows/USB Android still block release.

## 2026-10-02 — account SQLCipher random-key performance clean break

- [DR-0060](survival-program/decisions/DR-0060-did2-account-random-sqlcipher-key.md)
  was frozen before changing the local DSV2 key interpretation. An isolated
  same-provider measurement found five authenticated password-mode reopens
  **3429.3ms**, raw-key reopens **12.3ms**; both opposite-mode attempts rejected.
  This is connection evidence only, not a universal speedup or E2E claim.
- DSV2 now requires schema/cipher generation3 and protected DSK2 version3;
  its actual random key uses the same wipeable supported encoding as DMS2.
  The old account generation is refused, without migration, dual-key attempts
  or repair. Device/prekey/application key modes and registered node keys are
  unchanged. Source-only build passed with **zero warnings/errors**.
- Focused generation/key-mode/custody negatives and the connected initial
  Store/Retrieve/Hello/ACK/text checkpoint closed **82 passed / 1 failed /
  0 skipped**, **2m57s**, `did2-initial-mailbox-raw-account-checkpoint.trx`.
  Actual initial Store, cached dispatch, original-envelope Retrieve, incoming
  Hello, signed ACK and historical replay passed before Accept failed on the
  long test's expired short Hello. New Accept rejects expired requests before
  authoring; the long fixture now authors an appropriate finite Hello interval.
  The next repeat closed **7 passed / 1 failed / 0 skipped**, **4m50s**,
  `did2-initial-mailbox-hello-lifetime-checkpoint.trx`, at text ACK recovery:
  separate fixture terminals reused coordinator sequence1 for distinct signed
  statements. Shared fixture sequence allocation and exact cached Store/ACK
  responses replace that incorrect test behavior; product equivocation checks
  remain unchanged. A subsequent repeat closed **7 passed / 1 failed /
  0 skipped**, **2m24s**, `did2-initial-mailbox-coordinator-checkpoint.trx`, at
  first receipt after its 120-second claim request expired. This is the
  product delayed-receipt issue addressed by DR-0061, not a clock suppression.
  Older isolated physical QA accounts will require explicit reset before that
  new binary's device run. No production reset/deployment, complete gate,
  commit/push, physical E2E or release evidence follows from this local change.

## 2026-10-02 — delayed committed initial claim recipient boundary

- [DR-0061](survival-program/decisions/DR-0061-did2-committed-claim-recipient-verification.md)
  was frozen before changing recipient promotion. Protocol now separates the
  already signed allocation from the request's new-mutation expiry, with
  purpose-bound sealed evidence and unchanged current artifact/endpoint gates.
  Recipient evidence is refused by initiator consumption; initiator expiry
  remains enforced. Focused Protocol tests **3/3 passed**, **0 skipped**, **758ms**,
  `did2-committed-recipient-claim.trx`, including expired-request recipient
  positive, future interval/current artifact expiry, invalid quorum, clock
  reversal and cross-purpose negatives in the current signed fixture.
- Connected initial/text run now delays first receive beyond request expiry and
  passes text through actual owned Store plus the original MEO into Retrieve,
  rather than serving a newly constructed text envelope. That connected native
  fact **passed**, **5m57s**. Combined run closed **8 passed / 1 failed / 0 skipped**,
  **8m6s**, `did2-delayed-initial-and-text-store-checkpoint.trx`. The separate
  sender interruption fact failed before its terminal callback because the test
  immediately retried a still-leased BeforeDispatch operation. The now-fast raw
  account DB no longer implicitly consumed that lease interval. Advance both
  signed fixture/monotonic time explicitly after that interruption, with product
  lease/retry checks unchanged. Its focused repeat **1/1 passed**, **0 skipped**,
  **2m33s**, `did2-owned-send-explicit-retry-time.trx`, including exact retained
  signed Store response, protected rollback refusal and missing-root refusal.
  ContactAccept in this checkpoint still uses direct local authenticated receive,
  not reverse-direction Store/ONION delivery; issuer/terminal are in-process.
- The connected owned recipient command is exposed to platform composition
  without public grant/terminal/ACK injection, using the closed read-only
  `DeepIdV2MailboxSynchronizationResult`. Counts represent processed envelopes,
  including replays/contact events, not new-message or physical-delivery claims.
  Source-only production build **passed**, **zero warnings/errors**; a focused
  boundary batch **39/39 passed**, **0 skipped**, **1s**,
  `did2-connected-mailbox-boundary-checkpoint.trx`, including the new public
  surface, read/send custody, key-mode and expired-Hello checks. Root, Protocol
  and Shared `git diff --check` are clean. MAUI scheduling/UI remains open.
  API snapshot/consumer repins, full gate, physical and live activation remain
  required. USB Android was observed available; no UI/device business claim.

## 2026-10-02 — connected owned DID2 Store candidate

- [DR-0056](survival-program/decisions/DR-0056-did2-owned-mailbox-message-dispatch.md)
  freezes the connected local sender custody/API. The owner reads a committed
  DPE2 operation, retains original message/request bounds, read-backs protected
  pending custody before SQL and prepared MAU hash/counter before callbacks.
  The internal transport gets no holder, repository or issuer authority; an
  owner-only wrapper checks exact bytes/route/floors/roots around dispatch.
- Protected send-journal boundaries **14/14 passed**, **0 skipped**, **34ms**,
  `did2-mailbox-send-journal.trx`: hostile headers/phases/lifetimes, exact
  roundtrip, prepared counter floor, duplicate pending/counter rejection.
  This is local structural evidence, not native send or physical delivery.
- The first connected native Store run failed after **12m35s**: cold preparation
  consumed the installation/signing policy's bound before durable receipt
  journaling. The operation stayed outcome-unknown rather than claiming delivery.
  The accepted correction uses a separately sampled, independently verified
  dispatch-only scope after exact protected preparation. No grant/request
  lifetime or signing loan is renewed. The second run reached exact retry,
  signed two-replica durability, cached receipt and recipient text history, then
  failed after **14m10s** on a fixture SQL foreign-key violation while simulating
  rollback (`did2-owned-mailbox-send-final.trx`; 14 structural checks passed,
  one native scenario failed). Replace that observer with a byte-exact encrypted
  snapshot rollback of only its disposable closed SQL, preserving valid schema
  and protected prepared custody. The connected repeat **16/16 passed**,
  **0 skipped**, **14m50s**, `did2-owned-mailbox-send-receive-checkpoint.trx`,
  including native Store/receive and the coherent SQL rollback/missing-root
  rejection. Transport and signed time are fixture-controlled, not socket/device.
- [DR-0057](survival-program/decisions/DR-0057-did2-owned-incoming-session-selection.md)
  connects the ordinary receive entry to initialized protected-catalog session
  selection and independent endpoint refresh. Remove the unused service overload
  accepting a caller-selected scope; keep only the owner's private engine.
  Selection and send-journal boundaries **15/15 passed**, **0 skipped**, **33ms**,
  `did2-incoming-selection-journal.trx`. The connected native repeat above uses
  the real new incoming service entry. This is not mailbox polling, semantic ACK
  or device E2E.
- Own-publication secret derivation is shared inside one owner-private disposable
  loan for the recipient continuation. It requires the exact committed phase-7
  own permanent plan, verified publication and protected read-back; no capability
  or authority is caller-supplied. Its native grant-custody and incoming/catalog/
  protected-send regression **40/40 passed**, **0 skipped**, **5m18s**,
  `did2-own-publication-and-incoming-checkpoint.trx`, including own Retrieve
  rejection before publication, interrupted acquisition and exact reopen without
  reissue. Source builds have zero warnings/errors; actual Retrieve dispatch/ACK
  is not implemented by this private derivation.
- Copy the sender operation before the service's first network await; otherwise
  a caller could change that buffer while independent contact proof was fetched.
  Added deliberate input mutation in the native interrupted-send scenario.
  The connected boundary repeat **17/17 passed**, **0 skipped**, **14m55s**,
  `did2-owned-mailbox-service-boundary.trx`, including that mutation before
  asynchronous proof refresh. This predates the recipient read-root increment.
- Initial DPH delivery, owned Retrieve/materialization/ACK, remote attachment
  chunks, groups, matched deployment and physical Windows/USB Android remain
  release gates. USB Android is available; Windows exposes no open Deep window.
  No app reset/install, production change, full gates, commit/push or release here.

## 2026-10-01 — owner-held DID2 current mailbox credential installation

- [DR-0055](survival-program/decisions/DR-0055-did2-owned-mailbox-credential-installation.md)
  was frozen before implementation. The actual account owner installs the exact
  protected winner into its own SQLCipher application store under the same lease,
  current root-verified PMA2 and independently derived mailbox replica keys.
  It revalidates the SQL route and unchanged protected winner before returning.
  No next grant, caller repository/issuer, signer export or identity adapter.
- Installation policy is owner-private and bounded; synchronous validation uses
  authenticated interval upper time plus conservative monotonic elapsed, not OS
  UTC. Foreign grant queries reject. Current SQL installation revalidates after
  gate/transaction waits and before commit rather than trusting an earlier clock.
- Native two-account installation/restart coverage **1/1 passed**, **0 skipped**,
  **7m43s**, `did2-owned-grant-installation-final.trx`: actual ML-DSA/SQLCipher,
  Deposit/Retrieve, loss/corruption, interruptions before/after SQL installation,
  exact retry without reissue, independent SQL read-back, no prepared transport
  rows. The first diagnostic run failed on the observer's wrong SQL column name;
  this was corrected without weakening assertions. Private issuer is in-process.
- A new internal held mailbox path/transport loan checks readonly existing floors
  without recursively fetching/reacquiring the account lock. Source builds have
  zero warnings/errors. Its connected owner loan check plus current credential
  preparation/restart regression **8/8 passed**, **0 skipped**, **7m40s**,
  `did2-owned-installation-held-path.trx`: actual owner-held path checks, changed
  placement/disposed-loan rejection without recursive proof queries, six hostile
  grant headers and current credential exact-MAU preparation/restart. This is
  local integration, not socket/device evidence. Production preparation/dispatch consumer,
  semantic receive/ACK and physical Windows/USB Android remain unfinished.
- USB Android was visible as a ready device; no physical app scenario, device
  install, production deployment, full gates, commit/push or release occurred.

## 2026-10-01 — connected opaque DID2 mailbox issuance candidate

- [DR-0054](survival-program/decisions/DR-0054-did2-private-mailbox-grant-issuance.md)
  was frozen before implementation. Protocol verifies the current NET/root/PMA,
  exact threshold route and both independently selected stores' durable signed
  role lookup; its closed author captures the role key and checks returned
  signatures/full authenticated time, and verifies exact journal winners.
- Registry has a disabled-by-default bounded private JSON endpoint, independent
  service observer/proof/floor/time/bundle composition, external role signers and
  a permanently reserved hash-only PostgreSQL grant journal. XNode opt-in now
  connects acquisition through the ONION terminal and authenticated replica
  route, with the original XMG deadline across retries. No retired PMA1 authority
  is used in the new graph. No environment guard was relaxed.
- Connected native ML-DSA/SQLCipher Deposit/Retrieve restart test **1/1 passed**,
  **0 skipped**, **6m40s**, `did2-two-store-issuance-owned-restart.trx` with actual
  selected-store signatures, damaged/duplicate evidence and wrong-role signer
  rejection. The private hop remains in-process, not TLS.
- XNode **5/5 passed**, **0 skipped**, **920ms**,
  `did2-contact-two-store-grants.trx`: actual two on-disk stores and authenticated
  binary peer HTTP through an in-process handler, public DID2/NET, publication,
  resolve, Deposit/Retrieve, lost grant response and exact retry without reissue.
  This caught and fixed a terminal still rejecting acquisition before dispatch.
  Its private issuer winner cache is a fixture, not the production DB.
- Registry **10/10 passed**, **0 skipped**, **421ms**,
  `did2-private-grant-http-journal.trx`: closed JSON/body/replay/config bounds and
  actual isolated PostgreSQL reservation, interruption, immutable request/scope,
  competing issuers, restart/read-back, capacity and corruption rejection. Only
  an exact random test schema was created/dropped in the existing isolated test
  container; dev/prod databases were not changed. Journal records are structural
  target fixtures, not issuance-authority evidence. Protocol, Registry and XNode
  source builds have zero warnings/errors.
- Latest callback-size hardening also passed the same focused scenarios:
  XNode **5/5**, **0 skipped**, approximately **1s**,
  `did2-contact-two-store-grants-final.trx`; Registry **10/10**, **0 skipped**,
  **451ms**, `did2-private-grant-http-journal-final.trx`. These are not full gates.
- Composed private HTTP/external signer/observer/floor coverage, provisioned
  matching bundles, credential installation/use and physical Windows/USB
  Android messages/files/images/groups remain gates. No deployment, device
  install, commit/push or GitHub Release occurred in this increment.

## 2026-10-01 — owned DID2 Deposit/Retrieve grant restart custody

- [DR-0053](survival-program/decisions/DR-0053-did2-mailbox-grant-restart-custody.md)
  was frozen before implementation. Protocol separates still-current exact
  pending-request restoration from independently current retained-grant
  verification; an expired acquisition envelope cannot be retried or silently
  regenerated, and does not by itself expire an otherwise current grant.
- Shared atomically initializes a mandatory protected grant journal with its
  actual account/SQL instance. The owned Deposit entry derives scope from a
  freshly reverified permanent contact, persists/read-backs its independent
  random holder and exact request before callbacks, and adopts only a verified
  immutable exact winner. Reopened winners make no issuer callback. Missing
  or corrupt custody requires explicit disposable-QA reset, never repair.
- Internal grant carrier uses the existing selected-entry ContactResolve ONION
  path and actual held-account guards/entropy, without a direct issuer URL,
  public callback or legacy identity owner. It is not shipping activation.
- Focused connected native batch **8/8 passed**, **0 skipped**, **6m22s**,
  `did2-owned-mailbox-grant-restart.trx`. Hardened batch **8/8 passed**,
  **0 skipped**, **6m32s**, `did2-owned-mailbox-grant-restart-final.trx`:
  two ML-DSA/SQLCipher accounts, real publication/independent peer proof,
  pending read-back before callback, damaged issuer result, lost successful
  response/exact restart, winner restoration without reissue, malformed
  header/seed/phase/winner rejection, missing root rejection, both request
  roles, expired pending versus live retained grant, future response rejection,
  actual three-hop XMG frame and protected entropy duplicate check. Private
  issuer and resolver transports remain in-process fixture sources, not TLS.
- Owned Retrieve derives its secret only from the protected, verified phase-7
  own publication, never public resolve or caller input. Both directions share
  exact-retry custody but have independent holder keys. Publication custody is
  reread and compared throughout the held lease.
- Latest connected native test **1/1 passed**, **0 skipped**, **6m44s**,
  `did2-owned-deposit-retrieve-grant-restart.trx`: unpublished-owner rejection
  before transport, lost Retrieve response, exact pending replay after restart,
  immutable winner without reissue, independent role holders and current-PMA
  checks before mutation/dispatch. Latest production Shared build has **zero
  warnings/errors**. This remains in-process evidence, not physical delivery.
- Private live current-NET issuer/two-store evidence, credential
  installation/use and complete Windows/USB Android contacts/messages/files/
  images/groups remain release gates. No install, production rollout,
  commit/push or GitHub Release occurred in this increment.

## 2026-10-01 — direct DID2 mailbox issuer/result verification

- [DR-0052](survival-program/decisions/DR-0052-did2-mailbox-authority-distribution.md)
  freezes the missing public issuer input and direct result verification before
  their implementation. Protocol, Shared raw/HTTP distribution, Registry
  pipeline fixtures and DevOps genesis/successor/host exporters now use the
  complete bundle; the incomplete candidate fails closed without a converter.
- Focused wire **21/21 passed**, **0 skipped**, **34ms**;
  Shared raw/HTTP source **6/6 passed**, **0 skipped**, **48ms**;
  Registry pipeline **9/9 passed**, **0 skipped**, **200ms** with the connected
  source test graph compiled. Artifacts respectively
  `did2-mailbox-authority-distribution.trx`,
  `did2-mailbox-authority-distribution-client.trx`,
  `did2-mailbox-authority-distribution-registry-connected.trx`.
- Local bootstrap tool **5/5 named checks passed**, including signed ceremony
  export/successor, byte-exact issuer retention and host public-file export.
  These use synthetic local custody and HTTP handlers, not production inputs.
- Native connected account/issuer/result **2/2 passed**, **0 skipped**, **2m6s**,
  `did2-real-mailbox-grant-connected.trx`: actual ML-DSA/SQLCipher account,
  threshold route, PMA2 root and separate role issuer signatures, exact PMT2
  membership, current epoch and whole time interval; issuer/holder/epoch/hash/
  topology/expiry substitution, late clock, cancellation and mutable caller
  bytes reject. Missing, invalid and ambiguous current issuer policies do not
  advance the protected network floor. The earlier result-only run **1/1**,
  **1m8s** is superseded by this connected source run.
- Protocol and production Shared builds finish with zero warnings/errors.
  Registry's obsolete caller-supplied initial-session assertions are removed;
  current own/peer proof/floor coverage remains, while owned claim/receiver
  completion belongs to the existing Shared business fixture.
- This is not protected holder/request/winner custody, live private grant
  issuance, installed credentials, ONION socket delivery or device E2E. The
  USB Android device is visible; no client installation/UI/prod rollout,
  commit/push or GitHub Release is claimed by this increment. Machine/API/
  vector/package repins and full gates remain at business-batch completion.

## 2026-10-01 — protected permanent-contact client plan and closed public entry

- [DR-0051](survival-program/decisions/DR-0051-owned-permanent-contact-client-entry.md)
  was frozen before code. Public account publication derives its own stable
  local retry plan and verified profile, composes DR49 carriers internally and
  retains the existing exact two-store commit workflow. Each phase checks the
  actual protected account-instance plan under its existing lease before
  mutation/dispatch; public callbacks, raw keys, time and retry IDs are absent.
- Native SQLCipher/ML-DSA plan/surface lane **2/2 passed**, **0 skipped**, **1m15s**,
  `did2-permanent-contact-owned-client-plan.trx`: reopen equality, defensive
  copies, reset separation, wrong source owner, cancellation and substituted
  intent rejection before threshold or route mutation. A valid plan stages the
  actual XRA proposal and stops before external coordination.
- Joined native owned publication/reopen lane **1/1 passed**, **0 skipped**,
  **3m8s**, `did2-permanent-contact-owned-client-publication.trx`: the client entry
  uses its protected plan/profile and reaches phase 7 through actual Protocol
  threshold/object/publication/two-receipt verification. Reopened entry returns
  identical commit bytes without new threshold/publication/replica callbacks.
  Coordination and replica responses are in-process test sources; no socket,
  live Registry or device claim is made.
- Opt-in HTTPS MAUI composition now invokes owned contact publication after
  prekey commit and resolves peers through the owned resolver. Pasted diagnostic
  public DID2 must match the independently authenticated result. Focused source
  composition/error-contract lane **16/16 passed**, **0 skipped**, **176ms**,
  `did2-owned-contact-client-composition.trx`. This is not a platform build,
  network request, relationship acceptance, message or physical delivery claim.
- Final focused composition/error-contract lane **18/18 passed**, **0 skipped**,
  **329ms**, `did2-owned-contact-client-composition-final.trx`; both new contact
  stage labels are explicitly allowlisted and private transport details remain
  only in inner exceptions, never display/evidence text.
- Shared production source built with zero warnings/errors. Existing physical
  scripts require clean committed source, so fresh Windows/Android build and
  live deployment/evidence remain at the connected business-batch checkpoint.

## 2026-10-01 — DID2 contact service, authenticated time and two-store restart

- [DR-0050](survival-program/decisions/DR-0050-did2-contact-service-composition.md)
  was frozen before implementation. Explicit DID2 contact activation connects
  opaque publication/resolve and V2 prekeys behind one authenticated replica
  endpoint, without V1 snapshot/recipient dependencies. Default and existing
  candidate environment guards remain closed.
- Service expiry/retention and outbound placement checks no longer use the
  HTTP admission OS clock. Actual signed DID2 time and boot-scoped monotonic
  elapsed time are independently checked before/after dispatch. Permanent-contact
  preflight now binds the correct read receipt; the receiving replica still
  independently verifies its durable publication and exact tuple.
- Narrow joined batch **20/20 passed**, **0 skipped**, **687ms**,
  `did2-active-contact-service-connected.trx`. Actual public DID2/NET signatures,
  two selected stores, authenticated peer HTTP handlers, lost response after
  durable execution, restart of both service owners, exact retry, independent
  publication/resolve verification and closed-operation rejection are covered.
  Additional clock/restart lane **3/3 passed**, **0 skipped**, **689ms**,
  `did2-active-contact-service-restart.trx`: missing/expired/foreign-boot proof,
  time rollback and cancellation fail closed. Proof retrieval/clock are synthetic;
  no socket TLS, production deployment or physical Windows/Android delivery claim.
- Latest joined endpoint/replica/carrier lane **22/22 passed**, **0 skipped**,
  **747ms**, `did2-active-contact-service-connected-final.trx`; enabled mapping
  contains exactly one actual route, disabled maps none. The mapper uses the
  closed merged receiver. Existing opaque time/resolve regression **7/7 passed**,
  **0 skipped**, **1s**, `did2-opaque-contact-time-regression.trx`.
- Client public composition, source/package closure, grants, BLOB and DID2 groups
  remain unfinished. Full business gates and commit/push remain batch-end work.

## 2026-10-01 — DID2 three-hop coordination and actual held-account transport custody

- [DR-0049](survival-program/decisions/DR-0049-did2-three-hop-coordination-carrier.md)
  and machine registry were frozen before implementation. Protocol parses
  request-paired two-target wrappers without minting witness/publisher authority;
  gateway placement is derived independently from current NET, not mailbox routing.
- Shared added owned coordination and exact replica-publication carriers. Real
  account-held SQLCipher guards/entropy avoid recursive account/proof locking;
  parent proof/floor/journal checks remain. Narrow **2/2 passed**, **0 skipped**,
  **56s**, artifact `did2-owned-coordination-held-custody.trx`: actual native account,
  frame construction/reservation, duplicate rejection, foreign lease and disposed
  owner rejection. Network/clock/threshold retrieval is synthetic; no socket claim.
- XNode dispatches verified coordination through independently current gateway
  placement to the signed fixed-origin DR48 backend. Host composition validates
  explicit options and defaults disabled. Narrow **17/17 passed**, **0 skipped**,
  **456ms**, artifact `did2-coordination-onion-dispatch.trx`: both exact targets,
  malformed/version/target/reserved/length/trailing/network rejection, cross-operation
  rejection, selected exit/PMT checks, paired-response substitution and post-forward
  proof failure classified unknown. HTTP handler/observer clock are in-process;
  not TLS, ONION socket, remote durability or physical delivery evidence.
- Client and node source-cutover builds completed with zero warnings/errors.
  Default package/API/vector/full gates and deployment were not run. Active node
  DID2 contact publication/resolve composition, membership grants, BLOB lifecycle,
  group cutover and full Windows/USB Android E2E remain unfinished in NEXT-SPRINT.

## 2026-10-01 — private coordination node proof and bounded backend

- [DR-0048](survival-program/decisions/DR-0048-private-contact-coordination-peer-authentication.md)
  adds calling-node authentication to both private Registry V2 terminals using
  independent existing Ed25519 node keys, no new shared secret or key conversion.
  Missing/unknown/noncanonical/duplicate/stale or substituted headers/body
  reject before issuer invocation. Enabled hosting requires a public-key access list.
- Registry narrow pipeline/signature/configuration lane **16/16 passed**,
  **0 skipped**, **966ms**; artifact `did2-coordination-peer-auth-negative-final.trx`.
  XNode backend lane **15/15 passed**, **0 skipped**, **1s**; artifact
  `did2-coordination-node-backend.trx`. Independent Rebex/Sodium signature check,
  immutable request retry/fresh transport nonce, ignored-cancellation/late response
  disposal, hostile framing and default TLS/no-redirect configuration covered.
  XNode source-cutover build **0 warnings/errors**, **7.31s** before the final
  token-capture cleanup; the later targeted test compile also passed.
  Final node lane after owned request-buffer wiping/format cleanup **15/15 passed**,
  **0 skipped**, **302ms**; artifact `did2-coordination-node-backend-final.trx`.
- HTTP pipelines/handlers and structural publisher records are not socket TLS,
  three-hop transport, live witness deployment or physical Windows/Android E2E.
  The verified coordination carrier, actual backend provisioning, publication,
  mailbox grants, BLOB and groups remain unfinished. No full gates/commit/push yet.

## 2026-10-01 — immutable peer bootstrap and independent ordinary refresh

- [DR-0047](survival-program/decisions/DR-0047-did2-owned-peer-refresh.md)
  closes missing original peer DID2 lookup material: owned seed registration
  inserts mandatory scope/hash-bound public credential with catalog CAS/floor,
  without a schema migration or stale-proof fallback. Ordinary service methods
  acquire both current endpoints independently, then recheck under actual lease.
- Narrow structural history/bootstrap/cancellation checks **9/9 passed**,
  **0 skipped**, **34s**; artifact `did2-owned-history-bootstrap-narrow.trx`.
  Unicode history/reopen, foreign owner/limits, hostile SQL/hash, immutable
  bootstrap/missing-no-repair and ignored transport cancellation/late wiping.
  Production build **0 warnings/errors**, **7.08s** before final disposal cleanup;
  latest targeted test compile also passed. Native owned TTL refresh **1/1 passed**,
  **0 skipped**, **7m40s**, artifact `did2-owned-peer-ttl-refresh.trx`: same original
  authenticated peer credential after old proof TTL, unchanged ratchet floor,
  missing-bootstrap reject before querying without repair. Actual owned
  account/seed/SQL/native crypto; Registry and monotonic-time samples synthetic.
  Native binary predates the later DAM disposal cleanup, separately compiled
  and structurally covered in the 9/9 lane. No remote/device evidence or
  full-business gate/commit/push yet.

## 2026-10-01 — owned resolved-contact claim and ordinary attachment offers

- [DR-0045](survival-program/decisions/DR-0045-did2-owned-resolved-contact-claim.md)
  переносит XPK подготовку в account-owned runtime: verified publisher XPS,
  protected preclaim intent, atomic get-or-reserve под actual account lease,
  byte-exact timestamps на retry и final held proof/floor/time recheck.
  Connected real account/native PQ/SQLCipher run **1/1 passed**, **0 skipped**,
  **17m18s**; custody/Hello/Accept/text/restart/replay проходят. Result artifact:
  `deep-client-shared/tests/Deep.Client.Shared.Production.Tests/TestResults/did2-owned-resolved-contact-claim-text.trx`.
  Shell logger-name argument был ошибочно не quoted; пост-test shell error не
  является failed test. Проверены actual TRX counters 1 passed/0 failed;
  artifact renamed без изменения XML. Сетевые ответы всё ещё synthetic.
- [DR-0046](survival-program/decisions/DR-0046-did2-owned-attachment-offer.md)
  добавляет stable asset → owned AttachmentOffer в общую DR30 очередь без
  attachment counter. DPE2 send требует независимые stable command/asset
  custody и current expiry; raw/substituted offers не получают authoring.
  Structural/SQL regression **17/17 passed**, **0 skipped**, **1m42s**;
  text→offer→text, exact pending/restart и corruption/counter negative coverage.
  Artifact `did2-owned-ordinary-offer-sql.trx`; native/remote/device offer delivery
  этим не доказаны. Расширенный native connected run **1/1 passed**,
  **0 skipped**, **25m52s**, artifact `did2-owned-contact-claim-attachment-text.trx`:
  stable actual asset/offer/shared sequence/native DPE2/receiver DAM integrity,
  exact replay and following text, changed kind and expired asset reject.
  Chunks copied locally; no authenticated remote BLOB or device evidence.
  Key-free history/restart projection **2/2**, **0 skipped**, **15s**, artifact
  `did2-offer-key-free-history.trx`; no key or current download authority.
  Первый параллельный compile не дошёл до tests из-за Windows
  locked output; успешный run использует isolated output вне checkout.
- Latest narrow production/test compile **0 warnings/errors**. Старый native
  DR45-only run был запущен до DR46/latest DR45 query-union guard; expanded
  native run включает оба изменения и 30s token-ignoring publication bounds,
  но был собран до более позднего key-free history reader (structural run выше).
  Полный business gate/commit/push остаётся на конец
  пакета контакты/сообщения/вложения/группы. Production, node keys и устройства
  не менялись; shipping transport/device release readiness не заявляется.

## 2026-10-01 — retained contact routes and connected claim lifetime corrections

- [DR-0042](survival-program/decisions/DR-0042-did2-route-directory-issuance-anchor.md)
  исправляет воспроизведённую DR41 ошибку: unrelated account admission не
  требует перепубликации всех контактов. Signed issuance anchor отделён от
  independently current authority; new issuance по-прежнему требует current head.
  XNode focused **7/7**, **0 skipped**, около **1s**: настоящие additional DID2
  admission/signed successor/new proof, неизменные ciphertext/route, два local
  store restart/read и historical commit; old-proof/new-NET и stale dispatch reject.
- [DR-0043](survival-program/decisions/DR-0043-did2-claim-current-network-and-clock.md)
  добавляет exact claim recipient/NET pairing и защищённую last-observed
  monotonic boundary. Unit binding/surface **2/2**, **0 skipped**, **535ms**;
  internal output seams synthetic и не являются подписанным producer/device gate.
  Exact claim single dispatch ограничен 30s и реагирует на cancellation даже
  при token-ignoring response adapter, без нового operation/result.
- Connected real account/native PQ/SQLCipher publication/read → retained claim
  → Hello/Accept/text lane сначала **failed 1/1**, **4m36s**: manifest issued
  before later DCB incorrectly rejected. Исправление
  [DR-0044](survival-program/decisions/DR-0044-did2-prekey-service-contact-lifetimes.md)
  сохраняет полное containment inventory в XPS и operation-time containment
  во всех current lifetimes; не пересоздаёт ключи и не backdates DCB.
  Новый connected run **passed 1/1**, **0 skipped**, **14m09s**:
  actual owned publisher/phase7 → compact-address read/independent proof →
  durable exact claim → native DPH Hello/receiver → explicit ContactAccept →
  text reply/history; crash/response-loss/retry/dedup проверены.
  Token-ignoring adapter cancellation не сохраняет result; hidden claim-clock
  reversal отвергается. Accounts/native PQ/SQLCipher реальные, сетевые
  coordination/replica/ONION response adapters synthetic; physical delivery
  не заявляется. Latest unit binding/surface **2/2**, **0 skipped**, **523ms**
  включает inventory outside later DCB positive и expired-contact negative.
- Shared production Release build после DR43 **0 warnings/errors**. Full
  business gates/commits и shipping/private transport/Windows↔Android delivery,
  blob offers/resume/groups остаются открытыми. Production не изменён.

## 2026-10-01 — DID2 compact-address permanent read and account-bound composition

- [DR-0041](survival-program/decisions/DR-0041-did2-permanent-contact-resolution.md)
  добавляет descriptor-bound parsed bootstrap и независимую current peer
  verification. Исправлено несовпадение retired DID1 transcript с actual node
  resolve-read; unsigned serverTime не выдаёт свежесть. Final captured clock
  проверяется без нового callback; boot/backwards/deadline negatives покрыты.
- Actual PQ/directory/network/witness plus two local opaque stores: **6/6**,
  **0 skipped**, около **1s**. Publish/read/restart, exact credential/capability,
  altered receipt/result/address, cancellation и release-time failures проверены.
  Public closed API: **3/3**, **0 skipped**, **21ms**.
- Shared connected two-owned-account publication/read lane: **1/1**,
  **0 skipped**, **5m27s**. Независимый nonce-bound peer proof, account-bound
  floors, held-account release; counterfeit signature отвергается; read не
  создаёт prekeys/session/acceptance или automatic second dispatch.
  Secure-storage/response adapters synthetic; native PQ/account and SQLCipher
  реальны. Actual node stores проверены отдельным XNode lane.
- Дополненный local XNode lane: **7/7**, **0 skipped**, около **1s**.
  Real additional DID2 admission, threshold-signed successor head, retained
  predecessor floor и новый nonce-bound proof воспроизводят lifecycle gap:
  unchanged account identity остаётся current, но old exact-head route reject.
  Это regression/reproduction evidence; его прежний вывод о необходимости
  renewal при unrelated admission исправлен DR42 выше, delivery не заявляется.
  Первоначальный harness прыгал от empty genesis через два heads без forward
  checkpoint и был отвергнут; исправлен genuine already-verified predecessor
  floor, security assertion не ослаблена. В release-time route observation
  добавлены immutable boot/sample; owner сравнивает последнюю observation с
  последней held-account floor observation, чтобы поздний reversal не скрывался.
- Shared production Release compile: **0 warnings/errors**. Shipping/private
  transport, global ADH/network-head publication renewal, old DID1 recipient
  retirement, claim/handshake/messages/assets/groups, physical Windows/Android,
  whole-business gates/API/vector/repins/commits остаются незавершёнными.
  Production, registered keys, genesis и certbot не изменены.

## 2026-10-01 — owned DID2 publication commit and restart custody

- [DR-0040](survival-program/decisions/DR-0040-did2-owned-publication-commit.md)
  закрывает client verification двух selected-node XPO signatures и protected
  phase-7 CAS/readback. Journal version 4 only; old isolated QA state требует
  explicit reset, без migration/node key/genesis reset. Historical commit не
  продлевает XPA dispatch authority и требует current object/route/proof/placement.
- Actual PQ/account/directory/network/witness/local opaque-store lane **5/5**,
  **0 skipped**, ~**1s**: commit/restart/replay, bad/foreign signature/body,
  failure status, cancellation/oversize; после действительного нового nonce-bound
  proof historical commit принимается, expired dispatch отвергается.
  Public closed API **2/2**, **18ms**; protected journal bounds **8/8**, **14ms**.
- Native account/SQLCipher protected custody lane **1/1**, **0 skipped**,
  **7m43s**: invalid threshold retains phase5, lost response/bad receipt retain
  phase6, exact retry adopts7, reopen makes no threshold/replica callback and
  retains exact bytes. Replica response здесь synthetic с real signatures;
  actual node stores проверены отдельным XNode lane. Shipping transport отсутствует.
- Старый combined route/object тест **failed 1/1**, **6m04s**: после расширения
  framing injection меняла empty LP32, а не ciphertext. Исправлена конкретная
  точка corruption, strict crypto rejection сохранён; этот старый case после
  исправления ещё не перепроверен. Новый business lane выделен отдельно.
- Shared production Release build **0 warnings/errors**; обычный retired
  diagnostic project пока имеет пять missing-type compile errors и не является
  production graph pass. Private coordination, DID2 recipient resolve, PMA2
  membership/grants, shipping messages/assets/groups, physical devices и whole
  business gates/API/evidence/repins/commits остаются незавершёнными.

## 2026-10-01 — sole DID2 opaque publication consumer and local two-replica slice

- [DR-0039](survival-program/decisions/DR-0039-did2-opaque-publication-consumer.md)
  заменяет public XPU/XPA reader, node verifier и placement source прямыми
  DID2 proof/NETCODEC/time inputs. V1 reader/overload отсутствует; bounded input
  проверяется до копирования, full six-record route/network и Deposit/Retrieve
  разделены. Genesis XPA lifetime точно совпадает с request и не превышает DR38.
  Protected saga format/schema несовместимы со старым состоянием; оно reject,
  не мигрируется. Registered node keys и unrelated stores не изменены.
- Реальная PQ identity/device/directory/network/witness ceremony и локальные
  opaque stores: final **5/5 passed**, **0 skipped**, **925ms** test duration.
  Подтверждены actual commit, exact replay после restart, две selected replica
  signatures и восстановление потерянного ответа. Negative coverage: header/
  suite downgrade, body/capability/witness substitution, unavailable proof,
  cancellation, wrong placement, backwards/changed-boot/expired final clock.
  Positive V1 threshold fixture удалён; public authority surface требует DID2.
  Public closed surface focused test **1/1**, **0 skipped**, **11ms**.
- Воспроизведён defect peer receipt: committed ID/object hash разрешали
  подпись для changed witness bytes. До исправления exact negative test
  **failed 1/1** (no exception). Receipt теперь требует свежую авторизацию,
  exact committed saga digest и release-time recheck до/после подписи.
  Другой подлинный threshold subset тоже reject, если exact request не был
  committed. Guard не вызывает дополнительных proof HTTP fetch и не продлевает
  lifetime; backward sample относительно исходного mint также reject.
- Default XNode integration test project compile после обновления dependencies:
  **0 warnings / 0 errors**, final **3.85s**; это compile, не full suite run.
  Explicit focused lane не меняет default gate. Production не обновлён;
  socket TLS/remote peers, shipping client, mailbox membership/grants,
  сообщения/вложения/группы и physical device E2E этим не подтверждены.
  Android USB доступен; Windows Deep-клиент не запущен при read-only inventory.
  Full gates, API/vector/evidence/repins и commits отложены до business boundary.

## 2026-10-01 — DID2 publication coordination and protected exact request/response

- [DR-0038](survival-program/decisions/DR-0038-did2-publication-coordination.md)
  заменяет V1 publication endpoint/issuer/client/author прямым DID2 путём.
  Подпись владельца покрывает весь exact request, включая nonce, operation,
  directory minimum, ciphertext, owner Retrieve и времена. Сервер проверяет
  actual ADA2/external floor, DCR/support/XPS, route/XIR, publisher и NETCODEC
  placement; XPA witness signatures используют V2 domain. Exact PostgreSQL
  reservation/winner/readback не допускают реминта после потери ответа/expiry.
- Account owner сохраняет request до callback и verified response до return
  в phases 5/6. Journal version 3 only, одиннадцать LP32 records, max entry
  415,566, прежний slot limit 1 MiB; до callback резервируется complete entry.
  Старые QA roots требуют explicit reset, SQL2/application6 не менялись.
  Callback bound 30 seconds. Подмена, изменённый replay и stale state reject.
- Реальный account/native/SQLCipher/ADA2/PostgreSQL/witness TestServer сценарий
  прошёл **1/1**, **0 skipped**, **3m39s**; расширенный connected lane с nonce/
  unsigned-field binding, downgrade/framing, восемью concurrent journal replays,
  independent journal restart и HTTP/query negatives — **13/13**, **0 skipped**,
  **3m37s**. Protocol V2 codec **4/4**, **23ms**; protected bounds **7/7**, **17ms**.
  Shared production Release build **0 warnings / 0 errors**, **9.25s**.
  Выявлен и исправлен post-DR37 guard: XIR generation — tag 3 (u64), а не
  четырёхбайтовый redemption limit tag 10. Никакой совместимости не добавлено.
- Это не physical E2E: TestServer и controlled clock, без platform storage,
  socket TLS/ONION, dual-replica publication, grants, semantic ACK или devices.
  Shipping private coordination, DID2 opaque publication consumer и mailbox
  membership/grants — следующие connected consumers. Production не изменён.
  Full gates, API/vector/evidence repins и commits остаются в конце business batch.

## 2026-10-01 — account-owned signed/encrypted DID2 contact object

- [DR-0037](survival-program/decisions/DR-0037-did2-owned-contact-object.md)
  замораживает V2 reusable genesis DCB1/DCR1 author/restore без generic signer,
  caller clock или DID1 adapter. Exact current route/delegation, active-device
  XPS1, ADL1 minimum head и verified DRS1/DPD1 support проверяются до выдачи.
  Resolver capability-bound encryption не отдаёт read key witness/store.
  Public requests сохраняют manual-approval policy, не automatic acceptance.
- Shared internal owner сохраняет exact object в phase 4 route journal под
  account lease/CAS/readback. Bundle ID, подпись, encryption nonce и ciphertext
  переживают потерю ответа и concurrent independent reopen; changed profile,
  bad service/key/device/ciphertext, cancellation и stale/reversed time reject.
  Journal теперь version 2 only; старые QA instances требуют explicit reset.
  Account SQL2/application6 не изменены. Нельзя считать локальный candidate
  XPA1, grant, ACK или доказательством network publication/device delivery.
- Native/SQLCipher focused scenario + hostile headers **7/7 passed**, **0 skipped**,
  **7m01s**; первоначальный вариант **7/7**, **7m39s**. Это actual account и
  подписи с локальными storage/HTTP/clock adapters, не физические устройства.
  Обнаружено несовпадение capacity с production secure-store slot limit:
  aggregate journal ограничен тем же 1 MiB, pending entries резервируют место
  для complete object до threshold callback. Финальные byte/header bounds
  **7/7 passed**, **0 skipped**, **18ms**; current production Release build
  **0 warnings / 0 errors**, **4.99s**. Whole-business API/
  evidence/machine repins, full gates и commit ещё не выполнены.
  XPA1 server issuance/private coordination, replica publication и mailbox
  grants остаются следующими незамкнутыми участками. Production не изменён.

## 2026-10-01 — DID2 threshold coordination, actual account and durable replay

- [DR-0036](survival-program/decisions/DR-0036-did2-route-threshold-coordination.md)
  заменяет V1 route-authority envelope/endpoint прямым DID2 V2. Старый
  DID1 server issuer, Shared HTTP client/options tests и DID1 wire-request helper
  удалены. Actual self-verified directory freshness теперь доступна как закрытый
  getter, без public raw-leaf mint или DID1 adapter.
- Сервер использует настоящие protected ADA2, independent PostgreSQL head floor,
  signed NCP2 и file-backed witness custody; challenge DTT nonce не совпадает с
  durable coordination nonce. Reservation фиксируется до route-sign callback,
  exact response — до release с независимым readback. Concurrency/restart возвращают
  один winner; missing root/capacity, changed replay, stale/expired proof и
  повреждённая сеть не создают новый маршрут. Delayed signer leaves a durable
  pending reservation; retry recovers it without publishing the interrupted candidate.
- Изолированный HTTP/journal/account batch **13/13 passed**, **0 skipped**;
  actual PQ-account/SQLCipher/ADA2/PostgreSQL/native server scenario **1m01s**.
  В найденном отрицательном пути OnionBoundaryException теперь закрыто переводится
  в отказ, а не необработанный HTTP error. Shared production Release build
  **0 warnings / 0 errors**, **8.52s** после удаления старого client/helper.
  Финальный callback fence также проверяет exact current-view file, root/time
  policy и bundle после подписания: замена view во время callback оставляет
  только pending reservation, без выдачи candidate. Registry local-cutover
  tests теперь используют Shared production project, не старый runtime graph.
- TestServer HTTP и явно управляемое тестовое время, не socket TLS, deployment,
  XPoint/OHTTP authority coordination, publication, grant installation, semantic
  ACK, UI или physical Windows/Android delivery. Full gates/API repin/consumer
  recovery и commit остаются на whole-business batch boundary; public Releases
  не опубликованы и production не изменён.

## 2026-10-01 — DID2-only mailbox grant request author

- [DR-0035](survival-program/decisions/DR-0035-did2-mailbox-grant-request.md)
  реализован: DID1 request author и unused caller-owned Shared acquisition
  client удалены. Новый direct DID2 author сохраняет neutral XMG1 wire/domain,
  фиксирует input/key до await, проверяет текущий route до/после подписания
  и вычисляет ограниченный срок по authenticated union time, не wall clock.
  Старый identity/V1-storage holder owner также удалён; узкий signer имеет
  только internal DID2 factory и exact role/capability/locator/PMT/PMS scope.
- Focused actual-account/route/native scenario **1/1 passed**, **1m01s**:
  actual holder Ed25519 signatures, Deposit/Retrieve, captured input/key across
  callback mutation, exact route-bound request, role mismatch, zero/oversize,
  invalid/short signature, cancellation, expiry after signing/before callback.
  Latest expanded signer scenario **1/1 passed**, **1m01s**, preceded by
  **1m05s**: narrow XMG role/capability/locator rejection and no public
  factory/storage/seed API, disposed signer rejection, MCP network/holder/
  placement/epoch/operation guards. MCP uses explicitly synthetic scope-only
  MCG2, not issuer or topology evidence. Current production Shared build
  **0 warnings/errors**, **4.27s**.
  Это request author boundary, не protected holder, issued MCG2, socket/TLS,
  durable installation или Windows/Android delivery.
- Neutral verified grant/replica models сохранены как transport inputs без
  нового producer. Account-owned grant journal/live coordination, PMA2 plus
  authenticated topology membership/epoch и exact XMC1 winner ещё обязательны.
  API snapshot/evidence repins, full gates и coherent commits остаются batch
  gates; no deployment/public Release/device delivery claim.

## 2026-10-01 — account-owned DID2 route custody

- [DR-0034](survival-program/decisions/DR-0034-did2-owned-route-custody.md)
  реализован: обязательный protected journal атомарно создаётся с account
  instance; proposal, threshold и complete сохраняются отдельными CAS с exact
  readback. Реальные account lease и protected directory/network floors
  проверяются до callback, adoption и возврата. Неверный threshold не
  записывается; callback имеет hard 30-second wait budget.
- Focused actual-account/native/SQLCipher scenario **7/7 passed**, **3m07s**:
  response loss после всех3 commits, reopen/exact retry без повторного threshold,
  changed config, invalid witness response/recovery с тем же nonce/proposal,
  повреждение effective scalar bit, missing journal и hostile header.
  Первоначальная mutation fixture меняла clamped-away X25519 bit: исправлен
  только тест, runtime checks не ослаблены. Local protected/clock/HTTP adapters,
  не live Registry/TLS/platform/device evidence.
- Current Shared production Release build **0 warnings/errors**, **4.73s**.
  Account SQL shape2/application shape6 не изменены; новый обязательный root
  требует explicit reset pre-increment QA accounts. No lazy repair/migration.
  Live DID2 threshold/publication, mailbox grants/dispatch/semantic ACK, blobs,
  groups, shipping UI, API/evidence repins и final batch gates/commits остаются.

## 2026-10-01 — прямой DID2 current route: verifier и genesis author

- [DR-0033](survival-program/decisions/DR-0033-did2-current-mailbox-route.md)
  реализован в Protocol: current DID2 DAB2/DMD1/DCA1 V2 проверяются напрямую,
  без DID1 wrapper. Три фазы выпускают XRA1, threshold PMS2/XRC1/XSS1 и
  owned-device XRR1/XIR1 V2. Существующие identity-neutral framing/domains
  сохранены; current traffic-key epoch берётся из verified nodes, не PMT
  selection epoch. Нет generic device signer или export private scalar.
- Production Protocol Release build **0 warnings/errors**, **11.52s**.
  Final Shared production Release build **0 warnings/errors**, **4.83s**.
  Latest focused scenario **1/1 passed**, **1m06s**; предшествующие три версии
  сценария также passed. Actual SQLCipher/DID2/native ML-DSA,
  protected retained device, independent nonce-bound proofs и настоящие
  signatures трёх witnesses. Проверены conservative union time ranges,
  async input ownership, immutable exact return, altered invite/reference/
  threshold, XRR deposit/policy/quota/issuer/signature, low-order/reused sealing key, foreign device, duplicate/invalid
  witness, boot change и expiry across signing. Это локальный crypto/account
  boundary test с in-memory HTTP/clock/storage adapters, не TLS или device E2E.
- Normative public/private route-coordination ambiguity исправлена у владельца
  `CONTACT-RESOLVER-V1.md`; downstream docs ссылаются на decision. Публичная
  storage/routing plane не получает device/delegation evidence.
- Durable exact route/metadata adoption, retry/successor/publication,
  DID2 Registry threshold endpoint, protected holder/grant acquisition,
  actual mailbox/semantic ACK, masked blobs, groups и shipping UI остаются
  открытыми. Exact API snapshot/evidence gate, consumer repins, full required
  gates и coherent commits — в конце whole-business batch. Нет deploy,
  physical delivery, public Release или commit в этом increment.

## 2026-10-01 — DID2 mailbox network and selected-entry candidate

- [DR-0032](survival-program/decisions/DR-0032-did2-mailbox-selected-entry.md)
  реализован как internal Shared composition: actual DID2-owned fresh network
  source, scoped MAU2/route equality, account-owned guards/entropy, selected-entry
  TLS and authenticated/canonical reply boundary. Static URL, DID1 adapter и
  automatic alternate dispatch не добавлены. Protocol wire/schema не менялись.
- Focused source/route/actual SQL credential batch **7/7 passed**, **1m16s**.
  Source получает новый proof на каждый refresh и отвергает повреждённый
  signed network без rewrite floor. Unscoped/foreign custody отказывает до
  network/guard activity; Store/Retrieve/ACK связываются с exact route.
- Latest copy/path/SQL batch **6/6 passed**, **2m11s**: actual DID2 account,
  signed three-node network, SQLCipher guards/entropy, оба replica exits для
  всех3 операций; TLS facts из selected path. После async mutation caller
  request/route buffers attempt сохраняет исходные verified bytes/scope.
  Path-only MAU2 grants в этом fixture synthetic: это не issued credentials,
  authenticated mailbox delivery, socket, platform protection или device E2E.
- Final production Release build **0 warnings/errors**, **4.71s**; root/Shared
  diff-check clean. Initial SQL regression test вызывал Store validation для
  собственного Retrieve frame; исправлен только этот harness operation,
  assertions/runtime binding не ослаблялись. Full gates не запускались.
- Current DID2 XIR1/XRR1 route publication/verification, protected holder,
  XMG1/XMC1 acquisition, real adapter receive/semantic ACK, masked blob/group
  composition и shipping Windows/Android UI остаются release gates. No deploy,
  physical delivery, public Release или commit в этом increment. Fast-mode
  whole-business batch продолжается, итоговые checks/commits ещё впереди.

## 2026-10-01 — exact account-owned attachment adoption candidate

- [DR-0031](survival-program/decisions/DR-0031-did2-local-attachment-custody.md)
  реализован в actual account lease/current-account path: complete candidate
  SQL transaction -> protected pending -> verified SQL readback -> stable CAS.
  Unregistered candidates inert; registered loss/substitution rejects. Object
  scope генерируется заново только до adoption, а resume читает прежние bytes.
- Actual DID2 account owner local adoption/restart + preparation **5/5 passed**
  (**1m23s**): все3 failpoints, exact manifests/chunks after owner restart,
  восстановление без plaintext/picker URI, chunk decrypt to original bytes,
  changed-input rejection и initialized SQL loss/no recreation. SQLCipher и
  native account verifier настоящие; protected adapter in-memory. Это не
  HTTPS/blob transport, Windows/Android platform protection или physical E2E.
- Current schema6 focused asset/text/removed-HTTP batch **22/22 passed**
  (**1m32s**): asset foreign/malformed/duplicate/disposed journal, inert orphan
  cleanup, registered object/chunk loss, changed ciphertext, text counter and
  corruption/replay guards. New SQL tables не вводят wire bytes или отдельный
  attachment message counter. Schema5/missing asset journal требуют explicit
  reset; migrations/legacy fallback отсутствуют. Device/prod data не менялись.
- Ordinary actual-owner native bidirectional gap/crash/replay/history test
  **1/1 passed**, **15m26s**. Этот run использовал preceding schema5 candidate,
  до DR-0031: это evidence messaging mechanism, не latest whole graph gate.
  Additional uncomposed-kind/removed-HTTP/bounded SQL payload checks **4/4**,
  **5.83s**, и affected MAUI TLS smoke **1/1**, **0.91s**. Oversized corruption
  fixture первоначально остановилась на production CHECK; test now explicitly
  injects hostile bytes only on its mutation connection without weakening DDL.
- No new physical messaging run, deploy, full gate or commit. BLOB-01 masked
  padding/upload/download/resume, typed offer/cancel, group ownership/fanout,
  semantic inbox/ACK and native shipping UI остаются release gates. Public
  Releases не публиковались; whole fast-mode business batch продолжается.

## 2026-10-01 — owned DID2 text queue and retired file transport removal

- [DR-0030](survival-program/decisions/DR-0030-did2-owned-direct-text-outbox.md)
  реализует actual account lease/current endpoint/source retirement checks,
  owner-generated logical ID/sequence, protected pending before SQL, exact SQL
  mirror/readback and stable CAS. Exact retry не авторует новый payload;
  raw caller text не допускается к crypto. Другие неподключённые typed events
  явно отвергаются на account send boundary. Это local queue, не delivery/ACK.
- Focused codec/SQL/preparation/removed-HTTP-surface batch passed **18/18**
  (**1m16s**). SQL loss, rollback/advance, changed recipient/operation/hash/time,
  unprotected rows, exact crash recovery/reopen and disposal checked. Первый
  старый harness assertion ошибочно считал любой новый operation malformed;
  исправлен на zero-operation/duplicate проверки без ослабления runtime.
- При review найден missing responder acceptance counter: text мог принять
  отсутствие baseline. Теперь responder обязан иметь actual counter4;
  loss rejects without recreation. Focused regression/recovery **3/3 passed**
  (**24.49s**); это structural SQL tests, не consent authority.
- Actual-owner native contact/accept/owned-text/retry/reply **1/1 passed**
  (**13m31s**), включая lost text preparation response after SQL and exact
  stable retry. Этот run предшествует дополнительным missing-counter/kind
  guards; они проверяются отдельно. Protected/HTTP fixture in-memory, actual
  native crypto/SQLCipher: не physical Windows/Android evidence.
- Retired `/file`/DEEPATT2 HTTP author/reader/options/factory и его positive
  test corpus удалены. UI file-I/O interface явно unavailable до DID2 blob
  composition; excluded Session composition больше не включает old protocol
  по URL. Удалённое восстановимо из Git, не compatibility fallback.
- Whole fast-mode business batch не завершён. Ordinary native gap/crash/replay
  scenario проверяется отдельно. Semantic inbox rollback/ACK, Active transport,
  durable masked blob/padding/resume, group ownership, MAUI device E2E, full
  gates и coherent commits остаются открытыми. Public Releases не публиковались.

## 2026-10-01 — explicit DID2 contact acceptance and attachment preparation (isolated candidate)

- [DR-0029](survival-program/decisions/DR-0029-did2-contact-accept-custody.md)
  реализован как явная account-owner команда, protected exact winner/retry,
  committed DPE2 handoff и actual-custody local/peer retained views.
  Hello не означает согласия; Accept не означает Active или ACK.
- Contact codec/SQL/in-memory/counter/replay/fork batch passed **27/27**.
  Native actual-owner acceptance/send/receive/reply passed **1/1**, **11m19s**:
  настоящий DID2, approved crypto и SQLCipher, committed semantic response loss,
  тот же Accept/operation/ciphertext при retry, receive replay без продвижения
  floor, retained acceptance с обеих сторон и обычный ответ. Protected adapter
  и HTTP fixture in-memory: это не platform protection/TLS/physical delivery.
- Protocol реализует уже frozen attachment §16 transcript без новых wire bytes:
  XChaCha20-Poly1305, HKDF-SHA-512, domain-separated nonce, exact geometry и
  commitment before AEAD. Key-bearing DAM1 теперь disposable. Focused cipher
  плюс существующий manifest codec batch passed **20/20** (**6.25s**), включая
  независимый transcript comparison, 25 MiB, подмены, границы и стирание owned
  key/canonical при disposal.
- Shared owned preparation и structural offer/cancel custody passed **6/6**
  (**12.83s**): short reads, exact input length, fresh random object scope,
  defensive ciphertext copies, disposal/cancellation, SQL restart и in-memory
  parity. Offer передаёт exact DAM1; восстановленные chunks расшифровываются
  в исходные bytes. Offer/cancel не становятся текстовыми сообщениями.
- Один parallel Shared build остановился на Windows DLL lock текущего native
  test; повторная проверка использовала отдельный output, затем canonical
  output после завершения native test. Это harness/build collision, не product
  failure и не причина ослаблять проверки. Итоговый production Release build
  после lifetime refinement: **0 warnings/errors**, **7.23s**.
- Нет нового deploy, device UI прогона, коммита или full gate. User fast-mode
  batch ещё не завершён. Protected semantic/outbox floors, Active/reachability,
  masked blob custody/upload/download/padding/resume, groups и shipping MAUI
  Windows/Android physical E2E остаются release gates; `/file`/DEEPATT2 не
  подключаются как fallback. Публичные Releases не опубликованы.

## 2026-09-30 — custody-bound initial conversation candidate

- По [DR-0020](survival-program/decisions/DR-0020-did2-atomic-device-initial-session.md)
  Shared выводит conversation metadata только из exact hash-bound initial
  events и проверяет exact retained DMD1, направление sender stream и TRS1
  local directory head. Это prerequisite для projection, не V1 scope adapter
  и не завершённая messaging-store/ContactHello V2 композиция.
- Focused Release custody gate **16/16 passed**; production Release build
  **0 warnings / 0 errors**. Проверены exact replay/reopen и подмена
  conversation/account/device/logical ID/sequence/time/local directory.
  Approved-native completion/restart/crash gate **1/1 passed**, 6m42s;
  loopback/HTTP fixture, не physical device evidence.
- В contact specification исправлена bootstrap-последовательность: inbound
  rendezvous готовится до Hello/Accept, которые несут его encrypted descriptor;
  public address его не раскрывает. Новые protocol bytes не введены.
- Physical Windows/Android delivery, attachments и groups этим не доказаны.

## 2026-09-30 — atomic DID2 initial-session custody candidate

- Принят bounded local contract
  [DR-0020](survival-program/decisions/DR-0020-did2-atomic-device-initial-session.md).
  Burn-then-return preparation удалён из Shared service API. Закрытый
  account-owned путь сохраняет полный DPH2/TRS1 и agreement burn через
  protected pending -> SQL transaction -> stable, до возврата ciphertext.
- Device SQL schema generation 4, без reader/migration generation 3.
  Checkpoint создаётся атомарно с protected device marker; пропажа и stable
  rollback не ремонтируются. Exact pending допускает только roll-forward
  прежнего результата, без нового DH/KEM/шифрования.
- Production Debug build: 0 warnings / 0 errors. Focused structural custody:
  **9/9 passed**; проверены восстановление до/после SQL commit, отсутствие
  checkpoint, чужое TRS device binding, подмена agreement burn и rollback.
  Это structural SQLCipher evidence, не authenticated handshake/device E2E.
- Native completion gate **1/1 passed**, 6m49s: approved ML-KEM/Braid,
  реальный DID2 и подписанные network/directory/claim, exact restart и все
  три commit failpoints. Loopback recipient/HTTP fixture — не физический E2E.
  Первый запуск остановился на
  неверном SessionInit expiry тестовой fixture, до вызова completion; fixture
  исправлена без ослабления frozen validation. Финальный Release batch gate
  выполняется hosted CI на фиксированном candidate SHA; он пока не закрыт.
  ContactHello V2, shipping composition и physical delivery остаются открытыми.

## 2026-09-30 — protected logical-intent owner candidate (isolated checks)

- Shared сохраняет opaque pre-XPK1 secrets по стабильному logical intent до
  возврата capability. Protected snapshot создаётся атомарно с SQL instance
  key до account publication; restart восстанавливает тот же operation и
  commitment. Нет floor-before-SQL промежутка или repair потерянного журнала.
  Exact local contract имеет единственного владельца в
  [DR-0019](survival-program/decisions/DR-0019-did2-preclaim-secret-persistence.md).
- Три structural ciphertext-custody cases прошли за 34 ms. Один адресный
  integration fixture прошёл за 3m03s: actual authored DID2/signed closure,
  exact restart, interruption после protected CAS, cancellation после CAS,
  unavailable proof и отказ при утрате journal без восстановления пустого.
  Native/HTTP fixture — не physical device evidence. Исправлено точное
  ожидание domain exception недоступного proof; protection не ослаблена.
- Полный Shared gate не повторяется в каждой итерации: следующий запуск
  будет на завершённой coherent vertical batch перед коммитом. Последняя
  committed matrix fd772be/Protocol1954525 прошла 219/219 за 1h06m; новый
  candidate этим прогоном не покрыт. Atomic postclaim preparation, ContactHello
  V2/inbox/ACK, shipping/device контакты/сообщения/медиа/группы ещё открыты.

## 2026-09-30 — sealed pre-XPK1 secret persistence

- [DR-0019](survival-program/decisions/DR-0019-did2-preclaim-secret-persistence.md)
  реализован в Protocol: opaque seal/restore сохраняет тот же claim operation
  и sender commitment, потребляет исходный secret owner и проверяет exact
  current DID2/device на начальном и финальном protected-clock samples.
  Raw scalar export, callback provider и replay device-DH lease не добавлены.
- Проверены independent envelope/KDF interpretation, authenticated plaintext
  с нулевым/неверным scalar, scope/key/header/cipher substitution, ownership,
  constructor fault, expiry, boot/backward time, cancellation и concurrent Dispose.
  Full Protocol Debug — 1853 passed / 11 прежних platform/provider skips;
  Routes 131/131, Carrier 105/105. Actual API/resource graph Debug/Release pass;
  evidence ownership mapped219/packageMissing0. Shared production Release
  project build с новым Protocol — 0 warnings/errors.
- Это Protocol-only persistence, не durable Shared logical-intent owner.
  Его подключение до XPK1 dispatch, atomic device-DH burn/prepared-secret
  commit, ContactHello V2/inbox/ACK и shipping/device цикл остаются blockers.
  CI Shared fd772be/Protocol1954525 прошёл; он не подтверждает новый Protocol
  или физическую доставку. Production не изменён; Releases не опубликованы.

## 2026-09-30 — exact V2 claim result custody

- Shared account journal сохраняет не только точный XPK1, но и успешный
  padded XPC1 после Protocol-проверки двух выбранных replica signatures и
  inclusion. Transport не выдаёт результат до локальной фиксации. После
  owner restart используется та же точная пара с повторной проверкой current
  placement/signatures, без второго сетевого claim и переупаковки Replay.
- Snapshot generation 3 — clean break без reader/migration generation 2.
  Request/result CAS идемпотентен; конфликт whole wire, включая смену статуса
  при том же signed tuple, необратимо блокирует журнал. Зарезервированная
  ёмкость учитывает максимальный result bucket каждой операции. Старые
  несовместимые QA журналы требуют изолированного reset; node keys, genesis
  и protected network floors не меняются.
- Focused Debug — 10/10: request/result restart, concurrent CAS, отказ без
  reservation, cancellation, подмена, SQL rollback, сбой result-floor до SQL,
  old/malformed snapshot и отсутствие незаметного repair/повторного claim.
  Production Release project build — 0 warnings/errors. Docs 174 и пять
  root spec consistency gates pass; source-only scan 8 файлов/0 findings.
  Предыдущая полная Shared matrix 374e85f/Protocol1954525 прошла локально
  216/216 и hosted Windows/Linux CI. Полный Release-прогон с новым custody
  запущен отдельно и пока не заявлен pass.
- Это public-byte custody, не current-recipient proof, independent replica
  storage read-back или секретная DPH2 preparation. Окно device-DH burn до
  сохранения preparation, ContactHello V2/inbox/ACK, shipping caller и полный
  физический Windows/Android цикл остаются незавершёнными. Production не
  изменён; GitHub Releases не опубликованы.

## 2026-09-30 — V2 initiator completion and exact recovery fixtures

- DR-0018 замораживает единственный CompleteAsync с V2 receipt, current
  initiator proof и protected time. Оба endpoints повторно проверяются перед
  выдачей DPH2/TRS1 capability; expiry, cancellation и Dispose во время await
  не оставляют доступного результата. События ограничены и скопированы до await.
- Удалены synchronous V1 Complete, synthetic recovery receipt, фабрика
  вымышленного DID2 и event-only reader/author seam. Старый Shared V1 caller
  не адаптирован: удалён его переход к Protocol completion и открытию store.
  Текущий V2 shipping composition остаётся отдельной незавершённой задачей.
- Recovery assertions перенесены на подписанные V2 XPK1/XPC1/DPK2 и точный
  current identity fixture: оба prekey kind, 16/32-КиБ buckets, SessionInit/
  first event recovery, AEAD tamper, неверные claim/stream, одноразовые
  capability/receipt, ownership cleanup, initial/final expiry, cancellation,
  concurrent Dispose и caller-buffer mutation. Assertions сгруппированы в
  переиспользуемый V2 fixture lane; уменьшение числа discovered xUnit cases
  не является удалением этих проверок. PQ/network/directory seams не
  заменяют native/physical evidence.
- Full Protocol Debug: 1852 passed / 11 прежних platform/provider skips;
  Routes 131/131, Carrier 105/105. Actual API/resource graph Debug/Release
  pass с reviewed DR-0018 snapshots; ownership mapped219/packageMissing0.
  Shared production Release project build — 0 warnings/errors. Docs 174
  checks и пять machine/spec consistency gates pass; source-only scan
  10 файлов, 0 findings. Предыдущая Shared matrix c834bdfe прошла локально
  216/216 и hosted CI; новый полный Shared прогон ещё идёт и не заявлен pass.
- Protected pending preparation/result custody, ContactHello V2/inbox/ACK,
  shipping UI и physical контакты/сообщения/медиа/группы остаются blockers.
  Production не изменён; GitHub Releases не опубликованы.

## 2026-09-30 — V2 encrypted claim prefix and current responder promotion

- DR-0017 замораживает один V2-only encrypted-prefix reader и закрытый
  current initiator/recipient promotion. Полный protected-time recheck обоих
  endpoints выполняется на финальном sample; проверка старого интервала
  адресата не переживает задержку проверки инициатора. Cancellation, boot,
  current-device и точные bytes остаются независимыми fail-closed gates.
- Promotion сохраняет non-null V2 checkpoint/DCR1 и только затем выдаёт
  одноразовый двухканальный handoff. Identity-neutral lane types перенесены
  из ContactV1 в MessagingCrypto без alias/type forward. Shared consumer
  использует полный verified initial claim; V1 placement не принимает V2
  request. Старый test-only promotion без initiator proof удалён.
- Пять старых preview/prefix/promotion positive tests заменены V2 coverage:
  реальные signed recipient/replica records и XChaCha20 AEAD, оба prekey kind,
  16/32-КиБ payload, malformed/V1/truncation/padding/status/header/tamper,
  single-use lanes и финальная expiry/cancellation. Directory/network/PQ
  fixture outputs — bounded seams, не real hybrid/device evidence.
- Уточнены crypto §8 и DR-0008: DPH2 V2/DID2 размеры и exact V2 DPK2 hash;
  минимум prefix — 4542 байта без events/trailer. Неизменённый 4-КиБ outer
  bucket имеет structural/negative coverage, не успешный V2 claim payload.
- Focused gate 6/6; полный Protocol Debug 1867 passed / 11 прежних provider
  skips, Routes 131/131, Carrier 105/105. Debug/Release builds и Shared
  production Release rebuild: 0 warnings/errors. Actual API/resource graph
  Debug/Release pass с новым reviewed snapshot; ownership mapped219,
  packageMissing0. Docs 174 checks, crypto/contact consistency pass;
  source-only scan 12 файлов, 0 findings. Полный новый Shared run ещё идёт
  и не заявлен прошедшим.
- Sender Complete и его recovery fixtures пока требуют V2 cutover; старый
  event-only recovery test seam не является release evidence. Pending secret
  custody, ContactHello V2/inbox/ACK, shipping caller и полный physical цикл
  остаются незавершёнными. Production не изменён; Releases не опубликованы.

## 2026-09-30 — exact V2 claim/header and current initiator device binding

- Protocol `f91cab8` связывает retained V2 claim pair с точным предложенным
  DPH2 header до выдачи копии transcript. Проверены оба prekey kind и все
  три ciphertext buckets; отвергаются подменённые recipient/network/key IDs,
  offering hash, operation, receipt hash, sender commitment и counter.
  V1 re-encoding projected DPK2 не воспроизводит exact V2 offering hash.
  Guard не расходует claim и не выдаёт session, AEAD или ACK capability.
- Current initiator check теперь отдельно связывает exact active DPD1,
  device generation и agreement key с V2 checkpoint. Полный device validity
  interval проверяется после checked monotonic delta; wrong boot/sample/head,
  unknown device, changed generation/key/reference, exact expiry и overflow
  fail closed. Sender commitment не включает device generation, поэтому
  этот независимый current-device guard обязателен.
- В обеих фазах initiator author исправлено неверное CONTACT-style encoding
  DPD1 reference: используется уже нормативный identity ArtifactRef из DNP1.
  Wire version, sizes, domains, primitive suites и public API не изменены.
  Старые несовместимые QA pending requests не мигрировать; isolated reset
  выполняется перед новым device-прогоном, не затрагивая node/network custody.
- Focused gate: 19/19. Полный Protocol Debug: 1871 passed, 11 прежних
  platform/provider skips, 2m15s; Routes 131/131 и Carrier 105/105.
  Release build и Shared production Release rebuild: 0 warnings/errors.
  Actual assembly/API/resource graph Debug/Release pass; ownership
  exact314/package219/final95, mapped219, packageMissing0. Docs 174 checks;
  source-only scan 9 файлов, 0 findings. Новый full Shared test run, native
  platform gate, raw artifact scan и physical delivery этим не заявлены.
- Coherent V2 encrypted prefix, sender completion, responder promotion,
  protected pending custody, ContactHello/inbox/ACK и shipping UI всё ещё
  не соединены. Production не изменён, Releases не опубликованы.

## 2026-09-30 — source-bound NTS observer packaging for Registry candidate

- Read-only production preflight: Registry DID2 readiness 503, staking 200;
  Android USB device доступен. Первый health probe ошибочно использовал
  стандартный loopback port; после read-only inspect повторён на фактическом
  binding. Ни контейнеры, ни authority/volumes/certbot не изменены.
- Registry candidate image теперь собирает reviewed DevOps observer из exact
  named source context, pinned Go builder и проверенных `go.sum` modules;
  поддерживает actual TARGETARCH amd64/arm64, выполняет Go unit tests и
  маркирует точный DevOps revision отдельно от Protocol. .NET exact-three
  Protocol graph не расширяется. Оба publisher workflows передают этот source
  context/revision; GHCR credential совпадает с рабочим ручным publisher.
- Focused Registry gate 9/9; полный Release source-cutover gate 465/465, 0 skips,
  3m31s. Реальный local Docker `nts` build target для linux/amd64 и linux/arm64
  прошёл locked-module verification, Go tests и cross-compilation. Это не полный
  deployed Registry image или NTS source acquisition/physical E2E evidence.
  Docs gate 174 checks, source-only scan 10 файлов 0 findings.
- Packaged executable не включает automatic time и не создаёт NTS floor.
  Existing manual-anchor deployment требует отдельного безопасного first-time
  time-floor upgrade; initialized ADA2, независимый head floor, nonce ledger,
  genesis, node identities и signed intervals должны сохраниться. Нельзя
  повторять `provision-state`, брать OS/HTTP time или reset для обхода readiness.
- Hosted Protocol CI для `fa4e47f`: build-test `36677371751` и native ML-DSA
  candidate `36677371772` success. Root docs CI `36677806231` для `23d8b66`
  success. Эти CI результаты не объявлены delivery/release evidence.

## 2026-09-30 — documentation CI without retired prose snapshots

- Предыдущий root CI `36673204459` прошёл checkout/render/public-doc checks,
  но отказал на machine-contract step. Локально воспроизведено: CONTACT
  checker требовал дословное `MUST NOT receive or derive DID1` в prose после
  DID2 clean-break. Это устаревший текстовый контракт, не отказ wire validation.
- CONTACT/ONION prose snapshots удалены согласно documentation CI policy.
  Schema/digest/bounds/domain/enum/lifecycle/negative mapping и source boundary
  checks сохранены. Документационные navigation/render checks остаются отдельно.
  Group checker получил явный `-MachineOnly` для docs CI; default executable
  vector/test gate не изменён, Protocol CI продолжает полный production test run.
- Все пять machine checker commands и 174 documentation checks прошли локально.
  Machine-only mode явно не заявляет executable/group/device evidence; native
  и physical release gates не закрыты этим CI исправлением.

## 2026-09-30 — current-recipient V2 pre-key claim receipt

- [DR-0016](survival-program/decisions/DR-0016-did2-prekey-claim-receipt.md)
  замораживает закрытый DID2-only receipt API. В Protocol добавлены exact
  current-recipient/service binding, обе выбранные подписи, signed inventory
  membership и last-resort limit. Protected network/recipient intervals
  консервативно объединяются и проверяются повторно после clock read;
  unsigned server time не становится trusted clock.
- Exact replay hash независимо проверен по domain/LP32 framing и включает
  полный padded result. Подмена DCB1, подписи, unsigned projection/status,
  превышение XPS1 limit, expiry during verification, wider network bounds,
  overflow, wrong boot и cancellation отвергаются. Нет публичного receipt
  constructor, V1 adapter, session/ACK capability или remote storage claim.
- Focused Debug subset: 15/15. Полный Protocol Debug: 1871 passed / 11 existing
  platform/provider skips, 1m46s; MembershipRoutes 131/131, ProfileCarrier 105/105.
  Debug/Release build и Shared production Release rebuild: 0 warnings/errors.
  Reviewed actual assembly/API/resource graph: pass для обеих configurations;
  evidence ownership: exact314/package219/final95, mapped219, packageMissing0.
  Docs gate: 174 checks; source-only scan 10 файлов: 0 findings. Raw artifact
  scan и native/device evidence этими результатами не закрыты.
- Это компонентный инкремент, не работающий physical message cycle. Coherent
  V2 encrypted prefix/sender/responder, authenticated durable replica completion,
  protected initiator preparation и shipping ContactHello/MSG ещё обязательны.

## 2026-09-30 — V2 pre-claim operation-time expiry correction

- `DeepIdV2Dpk2PreClaimVerifier` больше не использует исходный trusted-time
  interval directory proof как неподвижное время. Обе границы продвигаются
  checked monotonic delta до текущей операции; overflow fail-closed.
  Живая directory proof не позволяет использовать уже истёкший DPK2.
- Локальный focused Debug gate: 14/14 `ApplicationCoreVerificationTests`;
  positive exact V2 signatures и случаи before expiry / exact expiry / after
  expiry / proof deadline / wrong boot / backward sample / overflow.
  Первые два прогона выявили несогласованную chronology тестовой fixture
  (DMD1 issued 100 при pre-key validity 10–20); исправлена дата подписанного
  fixture DMD1, production assertions и проверки не ослаблены. Полный Debug
  build: 0 warnings/errors; actual assembly/public-API/package graph gate pass.
- Полный Protocol Debug gate: MembershipRoutes 131/131, ProfileCarrier 105/105,
  Protocol 1870 passed / 11 existing platform/provider skips, 1m56s. Эти skips
  не выданы за native/device evidence. Docs gate: 174 checks. Source-only scan
  пяти изменённых файлов: 0 findings. Обычный artifact-inclusive scan всё ещё
  отвергает два прежних raw Android PNG (4 findings); они не изменены, не удалены
  и не подготовлены к upload. Release artifact scan этим не закрыт.
- Документация Protocol больше не называет прежний V1 claim-prefix/receipt
  путь production DID2 promotion. Полный V2 receipt/prefix/sender/responder
  cutover, protected initiator preparation и физическая доставка остаются
  незавершёнными; эта correction не закрывает message E2E.
- Полный Shared Release gate для committed `7967810` / Protocol `1b5da120`
  завершился: 216/216, 0 skips, 53m53s. Shared CI `36668595598` — success.
  Этот результат не выдан за проверку последующего Protocol исправления.

## 2026-09-30 — account-owned V2 exact claim request reservation

- Внутренний V2 claim transport теперь требует account-owned custody и
  сохраняет exact XPK1 в DSV2 до запроса path authority и ONION dispatch.
  SQL root связан с account/device/database instance и двумя protected floors;
  нет per-operation OS slots, V1 reader или silent reset/eviction.
- Exact replay и lookup сохраняются при reopen; same-operation substitution
  durably fork-latches journal. Capacity refusal, cancellation и malformed/
  foreign-network input не выдают dispatch capability. Floor-before-SQL
  interruption и SQL rollback проверены на настоящем SQLCipher owner.
- Первый focused run: 6/7 pass, найден собственный nullable-memory defect
  missing-request lookup (empty memory вместо null). Исправлен explicit return,
  assertions не ослаблялись. Повторный compiled custody subset: 3/3, 1m53s.
  Четыре transport tests первого run прошли; полный gate свежего build запущен
  и ещё не завершён. Предыдущий 213/213 не выдаётся за результат новых изменений.
  Docs gate: 174 checks; source-only secret scan 10 файлов: 0 findings.
- Это request reservation, не полный interrupted-handshake recovery: ещё нужны
  logical contact intent, Protocol-owned initiator secret/preparation custody,
  authenticated result/session completion и shipping MSG composition. Физические
  контакты/сообщения/вложения/группы не объявлены пройденными.
- Новый Registry digest скачан на production-хост и проверен по source/Protocol
  labels; sorted mount/image/running snapshot подтвердил сохранение текущего
  контейнера. Первый preflight ошибочно сравнивал неупорядоченный Mounts JSON;
  исправлен порядок, повторный preflight прошёл. На этом этапе был только image
  pull, не deployment. Локальный pull Registry дважды отказал с EOF, удалённый
  pull прошёл; отказ локального download не выдан за проблему production runtime.

## 2026-09-30 — исправление GHCR credential в ручных image workflows

- Сохранённый операторский GitHub PAT проверен через API: identity совпадает с
  `zhigubigule`, scope `write:packages` присутствует. GHCR выдал credentials для
  обоих существующих package scopes; это ещё не доказательство успешного upload.
- В обоих repositories уже есть secret `XPOINTLABS_CI_TOKEN`. Ручные XNode и
  Registry publishers ошибочно использовали отдельный `github.token`; старый
  Registry candidate publisher использует CI secret. Ручные workflows приведены
  к этому существующему механизму без нового токена или расширения его прав.
- Предыдущие `write_package` отказы не доказывали нехватку прав операторского
  PAT. Запрос ручной настройки Actions package access больше не является
  обязательным шагом для этого исправления. Успешный CI upload, digest и
  production readiness после retained upgrade остаются отдельными проверками.
- Исправления: XNode `e840810`, Registry `040fa99`; новые manual runs
  `36666182032` и `36666185488` запущены на этих revisions. У XNode GHCR login
  прошёл, image build/upload ещё выполняется; Registry ещё выполняет tests.
  Старые failed runs не перезапускались: rerun использовал бы старый workflow.
  `latest`, GitHub Releases и production deployment не изменены. Docs gate:
  174 checks; source-only secret scan пяти изменённых файлов: 0 findings.
- Оба новых image runs завершились success. GHCR index digests проверены:
  XNode `sha256:fadb285929666bbbc0c1e78f1f36208b77d14fcda018e5cc7de9b700d23e4969`,
  Registry `sha256:6694e5cb75e2d4bab119166866870361580e4749eb09966599502e5ab5963bd0`.
  Shared CI `36664964666` для `b01260a` также success. Production read-only
  inspection подтвердил ручной trusted-time path без включённого automatic NTS;
  замена образа сама по себе не закрывает протухшую authority.

## 2026-09-30 — возобновление physical E2E и V2 claim boundary

- Mr. X возобновил физические контакты/сообщения/вложения/группы и разрешил
  production update для этих проверок. Остаток network soak остаётся итоговым
  release gate, не запретом на message vertical.
- Shared `6682437`: внутренняя exact V2 XPK1/XPC1 transport boundary, один
  ONION coordinator, current placement до/после ответа, обе подписи и inclusion;
  отказ/unknown/отмена не выдают grant и не запускают второй claim.
  4 focused tests покрыли 11 сценариев за 3m16s вместо 11m25s: дорогая fixture
  повторно используется внутри немутирующих сценариев, все assertions сохранены.
  Первый прогон имел 2 неверных assertions типа исключения; исправлены тесты,
  production validation не ослаблена. Полный Shared Release gate прошёл
  213/213, 38m20s, без skips. CI Linux выявил недостающую native-runtime
  метку у четырёх новых integration tests; `b01260a` добавляет существующий
  `RequiresApprovedMlKemRuntime` trait. Debug compile/discovery подтвердили
  четыре случая в approved-runtime lane и ноль в portable-only selection;
  полный Windows gate их не исключает. Новый CI запущен, не объявлен зелёным.
- MAUI `d1689e6`: настоящий HTTPS Android build нашёл missing compile include
  для connectivity adapter нового reconnect. Исправлен clean allow-list и
  добавлена regression coverage. Clean 47/47, Smoke 119/119; supported Windows
  ARM64 и signed Android ARM64 diagnostic builds успешны, не Release packages.
- Свежая APK установлена по USB только в отдельный HTTPS package, Windows
  кандидат открыт на реальном desktop. Аккаунты и скрытые encrypted phrases
  сохранены; protected Android package path/metadata snapshots совпали.
  Оба device network действия остановились на AccountProof/TransportIo.
  Android post-action hierarchy unavailable обработана последующим read-only
  Inspect без повторного tap. Никакой message/contact/group delivery не заявлен.
- Production DID2 readiness: HTTP 503, closed code `did2-authority-unavailable`;
  staking HTTP 200. DEV Verify: current Registry proof + 3 verified ONION nodes.
  Эти результаты не доказывают причину каждого client IO wrapper и не
  подменяют production/device evidence.
- XNode `59fbae7` и Registry `29698a9` source-bound image workflows собрали
  образы, но GHCR upload rejected `permission_denied: write_package`.
  Запрошен Actions Write access соответствующих repositories к existing packages.
  Обновление prod, key/floor reset, main merge и GitHub Releases не выполнялись.
- Полный physical scope остаётся открытым: durable V2 caller journal,
  current recipient closure, DPH2/MSG composition, затем двусторонний текст,
  restart/dedup/durable ACK, image/file integrity/resume и membership changes.

## 2026-09-30 — полный Docker restart и честная readiness диагностика

- Сохранён и проверен локальный NTS-коммит другого агента `8c6eeb8`.
  Его NTS/TLS/SPKI/quorum/sample-age проверки не ослаблены.
- Полный Docker Desktop stop/start выявил, что `unless-stopped` оставляет все
  шесть сервисов остановленными. `deep-dev` теперь использует `always`;
  явный script Stop сохраняет maintenance stop, Start/Up возвращает автозапуск.
- Добавлен EngineFault с проверкой отдельного local engine, отсутствия чужих
  running containers, устойчивой readiness, прежних container IDs/canonical
  mount bindings и приватным сравнением online custody. Один цикл прошёл с
  60-секундным стабильным current proof/ONION окном. Raw mount JSON ordering
  corrected в harness; custody-check не снят.
- Второй цикл BLOCKED из-за Docker Desktop 4.45.0 Windows ARM64:
  inaccessible `dockerInference` AF_UNIX endpoint прерывает backend до старта
  Linux Engine. Clean force quit/one detached start воспроизвели host error;
  factory reset, volume/key/floor deletion не выполнялись. Позже оператор
  восстановил Docker без Windows reboot. CLI hang ограничен host-process deadline.
  По указанию оператора routine faults теперь ограничены `deep-dev`; полный
  Desktop shutdown требует отдельного разрешения и guard switch.
- Новый DEV ExpiryFault создаёт настоящий delegated 180-секундный signed view,
  затем 200-секундный stop/start только шести `deep-dev` контейнеров. Первый
  запуск не состоялся из-за host отказа; повторный scoped прогон прошёл:
  recovery 15 секунд, stable 60 секунд, Registry + 3 ONION ready,
  прежние node/Registry keys, IDs/mounts, без Docker Desktop restart.
  Это не one-hour head/7-day policy gate.
  Два коротких StackFault прошли: recovery 26/16 секунд, stable 30 секунд,
  custody/IDs/mounts неизменны, Docker Desktop не перезапускался.
- Registry: startup/live time loss и transient floor unavailable остаются
  warning + 503; crypto/custody/configuration failures остаются Error. Worker
  отмечает возврат protected authority. Проверки подписей/floor/status неизменны.
  Transient worker retry теперь 5/10/20/40 секунд с cap maintenance interval;
  crypto/custody/configuration errors остаются на обычном interval. Добавлены
  закрытые reason codes без echo exception messages. Старый startup crypto burst
  не воспроизведён в новых scoped прогонах; это не полный long-TTL gate.
- XNode: enabled privacy readiness требует реальной verified capability даже
  в Development. Cleartext management HTTP/1.1 настроен явно; TLS ALPN и
  dedicated authenticated HTTP/2 не изменены.
- Registry full Release source-cutover: 451/451; focused time/HTTP/diagnostics:
  16/16. XNode full Release: 107 + 280 + 502 = 889/889; focused listener/readiness:
  73/73. DEV tool Release build: 0 warnings/errors; compose/deep-dev contracts:
  13/13; DevOps release contracts 51/51 (fixtures only), source secret scan
  432 selected files passed, documentation gate 174 checks. Soak/device/production
  rollout не выполнялись, NET-STAB не закрыт.
- Scoped follow-up gates: Registry final Release source-cutover 462/462, включая
  самостоятельный retry после transient floor return без health request/restart,
  отказ expired head и выпуск свежего threshold-signed successor. Последнее —
  unit evidence с управляемым trusted-time fixture, не long-TTL Docker evidence.
  ARM64 images построены; compose contracts 13/13, release contracts 51 commands
  (fixtures only), changed-source scan 13 files/0 findings, documentation 174.
  Final strict Verify: Registry + 3 ONION ready, все шесть services healthy;
  последние пять минут Registry crypto/NTS acquisition failures 0.

## 2026-09-29 — ARM64 deep-dev и bounded automatic recovery candidate

- DR-0014: canonical bounded historical transport, independently verified
  contiguous signed heads and consistency proofs, sealed durable floor commit,
  then a new nonce-bound current proof. History never grants freshness.
- DR-0015: delegated operational view renewal without an online root; retained
  current/announced-next slots can be selected by a verified view. Unlimited
  future traffic/TLS key staging and offline-policy rollover remain open.
- Registry: owned two-family authenticated NTS acquisition, protected lower
  time floor and new bounded upper interval after boot; no OS/HTTPS-Date fallback.
  Explicit first-time floor provisioning is separate from acquisition; deleted
  or corrupt floor cannot silently restart at zero. Full Release source-cutover
  tests: 449/449.
- Real historical Docker exercise initially timed out on repeated full-prefix
  journal replay. Single-pass replay with incremental sparse-map updates now
  verifies every original prefix root and capability set; negative coverage and
  comparison against full map rebuild retained. No journal reset was performed.
- Only `deep-dev` remains among Deep compose projects: native ARM64, Registry,
  independent TLS PostgreSQL floor, delegated publisher and three nodes. Old
  scoped containers/empty networks removed, ephemeral node filesystems backed
  up privately first; volumes/images and unrelated local containers retained.
- Real six-service stop/start matrix: seven cases passed, recovery 3–27 seconds,
  unchanged custody/state mount bindings. Real 130 disposable DEV admissions
  with all three nodes offline: successor span 129, three independently verified
  ONION capabilities recovered in 46 seconds, no custody/floor reset.
- Linux ARM64 ML-DSA included as an exact hash/size-pinned binary from successful
  project CI run 35858379369; no local C++ build. Actual ARM64 managed/native
  consumer tests: 7/7. No Apple build enabled.
- Full Protocol Release: 1870 + 131 + 105 passed, 11 conditional native skips;
  Debug/Release actual public graph gates passed. Exact314 ownership with all
  applicable fragments: mapped219, packageMissing0. Package payload policy
  includes the reviewed linux-arm64 asset, not an unchecked directory wildcard.
- Shared full Release: 209/209; XNode full source-cutover: 885/885, then affected
  runtime 27/27 after safe logging/key cleanup. MAUI Clean 46/46, Smoke 119/119;
  Windows ARM64 and Android ARM64 Debug builds passed with zero warnings/errors.
- MAUI single-flight reconnect preserves account/floors and serializes confirmed
  reset with in-flight closure work. It currently reopens diagnostic DID2
  proof/closure/pre-key composition, not shipping MSG inbox/outbox/session.
  Optional HTTPS build still requires the real compiled operator trust pin.
- DevOps contracts 51 passed; compose build checks 8/8 and deep-dev scope checks
  3/3 passed. Production readiness remains blocked by missing actual release,
  device/ops/audit/GA evidence; contract fixtures do not substitute for it.
- No production changes, no physical message/device claim, no Docker-engine
  restart/20-cycle/beyond-TTL/multi-key crash evidence. Mr. X owns the 72-hour
  soak; device E2E runs locally in the separate agent, never CI.

## 2026-09-29 — локальный recovery/readiness инкремент, не полный NET-STAB gate

- Protocol `40a8273`: DR-0013 read-only issuance-context boundary использует
  тот же signed-head/time/XNV1 verifier, что authoring, без signing, nonce
  consumption, записи state или freshness capability. Wire/crypto/identity
  generation не меняются; consumer source/package repin не требует reset.
  Full Protocol solution: 2101 passed, 11 native skips; actual production
  assembly/resource/public-API graph passed в Debug и Release. Замороженные predecessor API
  snapshots заменены reviewed DR-0013 Debug/Release, negative gates сохранены.
- Registry `0d4367a`, `aed10b9`: production host не завершается до старта renewal worker
  при временном отказе floor/time; операции закрыты, liveness/readiness
  разделены. Proof-aware readiness не создаёт nonce ledger и не меняет ADA2.
  Dependency-owned cancellation воспроизведена как завершение background task;
  исправление сохраняет worker/host lifetime, caller/host cancellation не подавлена.
  Full source-cutover Release gate: 443/443. Host/DI floor outage/recreation
  tests используют подмену DB transport и не являются PostgreSQL/TLS evidence.
  Client test с настоящими PQ/SQLCipher checks подтверждает прежний account/floor
  и новую DTT1 после injected 503/timeout; physical device claims отсутствуют.
- XNode `cb8fb9a`, `945d01c`: initial outage/expiry и HTTP timeout не прекращают bounded
  receive refresh; typed 429/503 сохраняет ограниченный delta Retry-After,
  traffic/background разделяют monotonic backoff и для transport failure/timeout.
  Reproduction: 20 local calls вызывали 21 upstream attempts вместе со startup;
  теперь во время одной паузы остаётся один attempt, затем idle recovery.
  Никакого stale-authority revival или reset. Full Release source-cutover gate:
  885/885 (498 integration, 107 profile, 280 core); focused runtime 27/27.
  Первые два Windows durable-store
  Access-denied failures не маскировались: isolated rerun 2/2 и полный final
  gate passed без правок/ослабления этих storage assertions.
- Shared `1b787fc`: typed retryable proof failure/status/bounded delay;
  transport не replay-ит nonce, HTTP-date hint не становится trusted time.
  Focused transport/proof/SQLCipher floor gate: 19/19. Final полный production
  Release gate: 209/209, без пропусков, 36 m 31 s; previous obsolete run
  остановлен после обновления exact exception assertion. Typed metadata
  само по себе не закрывает полный CLIENT retry/resume/reconnect package.
- Installer `df53e38`: 27 shell/config cases и syntax passed в Linux container
  с Node/OpenSSL; durable named state mount, unless-stopped, retained keys,
  rerun и recreate/no-volume-deletion contracts проверены. Это не live rollout.
- DevOps `d7e1ef0`: причины отказов и обязательная fault matrix в
  [NETWORK_STABILITY_RECOVERY.md](../deep-devops/docs/NETWORK_STABILITY_RECOVERY.md).
  Stage/UAT custody contracts 10/10; release contract suite 51 commands passed
  на synthetic fixtures. Actual readiness-status остаётся blocked на десяти
  отсутствующих release/device/ops/security/GA evidence, не на fixture summary.
  Read-only TLS 1.3/`ntske/1` preflight двух bootstrap NTS endpoints прошёл с
  platform certificate validation и exact SPKI match. Это не deployed DTS1
  audit, NTS-KE/NTP observation или обновление CRT1.
- Public docs `b794e5a`: restart/no-reset operator/user behavior отмечено как
  candidate, без утверждения физического reconnect. Rendered docs gate 243
  checks, npm audit 0 vulnerabilities. Из-за npm child PATH render gate
  выполнен эквивалентными прямыми Node/PowerShell commands.
- E2E fixture validation и clean-break contract suite 10/10 passed, не device
  E2E. Production hosts/keys/certbot не менялись, push/deploy не выполнялись.
  Automated NTS, long-history catch-up, view/traffic-key lifecycle и реальные
  20-cycle/72-hour/device gates остаются в `NEXT-SPRINT.md`; soak NOT-RUN.

## 2026-09-29 — authenticated successor rollout и текущие device builds

- XNode `0a9ffbd` добавляет read-only offline floor/anchor/key-ring audit с
  тем же Data Protection scope и без автоматической генерации ключей. Общий
  decoder теперь отвергает authenticated anchor с другой history length.
  Focused tests: 21/21; полный source-cutover gate: 872/872 без пропусков
  (485 integration, 280 core, 107 profile). Deployed image пока от `44387ca`,
  audit выполнялся локально над независимыми приватными снимками.
- DevOps `a2a939a` и installer `0fb8711` исправляют stage growing signed
  history: новый immutable bundle не требует новых файлов внутри старого.
  Exact rerun по-прежнему отвергает отсутствующий retained record. Node tests
  10/10, installer syntax и shell gates passed. Full release contract gate
  прошёл 51 команду; readiness-status остаётся blocked на десяти отсутствующих
  real release/device/ops/security/GA evidence, это не release approval.
- Независимые authenticated DNH2 export на трёх нодах согласованы на revision 1
  до authoring. Подписан monotonic operational successor с полным retained
  NCP2, новым traffic key/certificate epoch и тем же registered/root custody.
  После checkpoint continuation все три ноды прошли supported installer
  health gate на immutable `c54cafd…` image. Registered Ed25519/BLS bytes
  hash-matched к исходным backup. Protected DNH2 advanced до revision 2/view 2,
  одинаковый capsule SHA на всех трёх нодах. Ни floor, ни genesis не сброшены.
  Подробное operational evidence и отрицательный first activation находятся
  в [DevOps runbook](../deep-devops/docs/DID2_FLOOR_PRODUCTION_CANDIDATE.md).
- Certificate-validated HTTPS distribution совпало с независимым новым NCP2
  (14,449 bytes) и прошло четыре negative checks. Live certificate-only audit
  подтвердил signed SPKI/SAN/validity/H2 для всех трёх endpoint без application
  exchange; это не подписанный message-path ответ. Registry readiness, три
  XNode health и staking passed; root private custody не отправлялась на hosts.
- Shared CI `36529522694` завершился success. MAUI `d116644` с Shared
  `72a78b7` собраны через supported scripts для Windows ARM64 и Android ARM64.
  Android build: zero warnings/errors, signer exact-match; установлен только
  dedicated HTTPS package, hashes остальных трёх пакетов unchanged. Clean
  tests 35/35 и smoke 119/119 passed. Это Debug diagnostics, не Release assets.
- Новый Windows build сохранил старый аккаунт, но ожидаемо отверг его
  projection-only custody без migration. После action-time подтверждения
  изолированный QA сброшен через UI; новый аккаунт создал владелец. Android
  также наблюдался на fresh onboarding, позднее — retained recovery и проверке;
  неизвестный исход SetName не повторялся автоматически. Fresh publication
  пока failed: Android PreKeyPublication timeout; Windows request aborted/
  AccountProof timeout. Приватная HTTP trace локализует Windows proof response
  wait; Registry одновременно выдаёт другие proof responses 200. Read-only
  plain HttpClient H2 probe повторил прежний second-response abort, не только
  product orchestration. Причина ещё не доказана; downgrade/retry bypass нет.
  Follow-up Node.js control также повторил truncation на workstation, тогда
  как три reused-connection ответа с Registry host и три fresh локальных
  ответа совпали с независимым NCP2. Детальные device hashes и controlled
  observations находятся в [MAUI checkpoint](../deep-client-maui/docs/DID2-HTTPS-DEVICE-2026-09-28.md#dnh2-builds-after-the-authenticated-operational-successor).
- MAUI `00a089f` закрывает утечку сырого IOException в diagnostic UI:
  фиксированный stage/TransportIo вместо private exception text, исходная
  причина сохранена внутри. Clean tests 42/42, smoke 119/119, selected-file
  secret scan 10/10 без findings. DevOps rollout observation закоммичен как
  `a365590`. Новый Windows diagnostic build компилирует actual DID2 graph;
  это не исправление сетевого truncation и не physical publication success.
- Device changed-tip restart, новый XIC1 pair, live claim, DPH2, text,
  images/files/groups остаются открыты. GitHub Releases, latest, main merges
  и cutover attestation не выполнялись.

### Follow-up — Android protected completion после restart

- MAUI `00a089f` actual Windows/Android builds проверены на устройствах:
  Windows сохранил профиль/identity/recovery после замены процесса, но network
  action завершился AccountProof/TransportIo. Android update сохранил account
  и recovery; три protected package snapshots unchanged.
- Android Inspect около 08:07 UTC подтвердил account-owned XIC1 completion.
  После supported restart без reset и одного verification action Inspect
  около 08:13 UTC подтвердил fresh reauthentication protected pair. Это
  same-history restart, не changed-tip gate, current replica availability
  или новый claim. Неизвестные post-action hierarchy reads не привели к
  повторному tap. Device hashes и scope находятся в
  [MAUI evidence](../deep-client-maui/docs/DID2-HTTPS-DEVICE-2026-09-28.md#corrected-diagnostic-on-the-physical-devices).
- Local Linux ARM64 Docker identity-neutral control прошёл три reused H2
  responses с exact NCP2 hash; native Windows control всё ещё truncates.
  Windows-dependent path требует отдельной диагностики, системные настройки
  не менялись. Три XNode healthy, Registry и staking HTTP 200 на повторном
  read-only check. Полный messaging/attachment/group vertical не закрыт.

## 2026-09-29 — account-owned DNH2 и текущие production prerequisites

- Shared `72a78b7` сохраняет полный DR-0012 predecessor вместе с LKG
  projection в одной SQLCipher transaction; independent projection/history
  anchors записываются до SQL commit. Только typed verified network может
  инициализировать/продвигать custody. Raw CAS не заменяет authority;
  process-local cache и tuple-only restart fallback удалены из этого пути.
  Projection-only состояние несовместимо: migration/repair не добавлены.
- Первый полный local production gate прошёл 201/201 без пропусков за
  36 min 24 sec. Добавлены exact CAS/account scope, changed-tip restart с
  expired historical keys, omission, split/crash/rollback/anchor и hostile
  envelope negatives. После финального review DNF2 anchor выровнен с
  existing host format и добавлен byte-level assertion; финальный полный
  прогон прошёл 201/201 без пропусков за 37 min 46 sec.
  Solution теперь явно включает три Protocol projects: новый build output
  подтверждает Release для всех dependencies вместо прежнего Debug mapping.
  Ускорение этим замером не подтверждено; никакие тесты не исключались.
- Один промежуточный focused test failed из-за corruption fixture,
  пытавшейся переписать immutable SecureStorage slot. Исправлена только
  fault injection (delete собственной test slot до corrupt write);
  production create-only семантика сохранена. Отдельный concurrent build
  получил MSB3027/3021 из-за live testhost DLL lock; он не считается gate pass.
- Contracts `5b4b84b` фиксирует только `fast-uri` 3.1.7 и exact lock,
  без Solidity/ABI/deployment изменений. Frozen install, Linux ARM64 Docker
  compile (82 files), 182/182 Hardhat tests и ABI export passed.
  Native host gate не стартовал из-за отсутствующего Windows ARM64 analyzer;
  он не является assertion pass. Audit: high/critical=0, low=2/moderate=7.
  Три Contracts CI runs passed. DevOps security rerun
  `36520717871`, attempt 3, завершился success после этой dependency fix;
  предыдущий failed upload gate не обходился.
- Production ordinary time/head renewal сохранило existing custody,
  image/listener/mounts, node keys, genesis и floor scope. Independent floor
  и authenticated ADA2 export согласованы на head 28/tree 10. Staking и
  directory readiness отвечали 200, но свежий Windows proof failed:
  signed XNV1 не покрывает issuance interval. Все три production XNode
  running/unhealthy. Это не исправляется reset floors или verifier expiry.
- Windows HTTPS QA уже существовал и не пересоздавался. Android после
  unavailable UI hierarchy просмотрен без повторного tap и также показал
  `proof-authority-unavailable`; protected package hashes совпадают до/после.
  Эти устройства ещё на предыдущих Debug builds, без нового durable DNH2.
  Contact/claim/handshake/text/files/images/groups device E2E остаётся открыт.
- XNode image run `36525603771` failed на GHCR `write_package` для repository
  GITHUB_TOKEN, не на product test. Проверен прежний успешный owner workflow
  в DevOps; новый run `36526067828` завершился success с immutable tag
  `did2-claim-44387ca-devops-057c0cf-20260929`, `push_latest=false`.
  OCI index: `sha256:c54cafd4737274326e2e3583da6be9081e2188dc09c02742489875da4882aa0d`;
  amd64: `sha256:28c9d814191cb93a73e118ddfba3a03f6b44e168194a26eb9769ce4dc2661b4f`;
  arm64: `sha256:36af56736a3d36e8d9ebe07209747cac05a1a578d860d71ec75026994dfc29f6`.
  Это CI/distribution evidence, не live V2 claim. Permission/secret settings,
  production image rollout, main merges и GitHub Releases не менялись.

## 2026-09-29 — DID2 selected-coordinator claim candidate

- XNode `7ab73cd` соединяет opt-in Development/UAT claim runtime с текущей
  DID2 authority, verified inventory/XIC1 pair и двумя durable journals.
  Prepare/complete используют существующий authenticated peer transport;
  потерянный ответ сохраняет reservation, exact retry возвращает те же bytes.
  Forwarding second replica проверяет обе подписи; completion divergence
  сохраняет persistent fork latch. Production activation остаётся закрытой.
- Focused runtime tests прошли 11/11; полный source-cutover XNode gate —
  861/861 (unit 280, integration 474, profile 107). HTTP handler in-process
  упражняет настоящий peer codec/authentication/endpoint, но не socket/TLS,
  live ONION deployment или physical device delivery. Обычный pinned NuGet
  graph пока не согласован; этот gate использует `DeepProtocolSourceCutover`.
- Protocol `aa8fdb1` удаляет V1 XPK1/XPC1 acceptance из ONION claim boundary.
  Старый positive V1 test заменён explicit negative; требования не ослаблены.
  Полный Protocol gate: 2,100 passed / 11 native-harness skipped; production
  assembly/API/resource graph passed; DNP1 package mapping — 219/219,
  packageMissing=0. Это parser/verifier evidence, не release activation.
- Shared `b0bf585`: focused claim-path test passed 1/1 — fresh account proof,
  exact V2 placement и реальный frame codec с durable entropy. Полный Windows
  production gate прошёл 191/191 без пропусков за 26 min 36 sec. Изменение
  lock-файла нормализует только final newline; dependency/RID graph сохранён.
- DevOps `e85aedc` выделяет новый per-run artifact root одновременно для
  контейнера, collector и неизменённого secret scan. Default smoke сначала
  failed на 923 findings в общей исторической artifacts tree; она сохранена,
  не исключена из сканера и не одобрена для upload. Final isolated smoke
  прошёл: 10 contract tests, runtime failed checks=0, selected secret scan
  passed. Artifact-scope/upload tests — 8/8; release contract fixtures —
  51 commands passed. Реальная production readiness остаётся blocked
  по десяти отсутствующим release/device/ops/security/GA evidence inputs.
- Multi-node rehearsal сначала failed из-за занятого локального порта;
  повтор на свободных isolated ports прошёл с тремя real non-mocked Xray
  routers. Claim authority в этом стенде не активировалась: это startup/
  generic transport/fail-closed evidence, не DID2 claim или сообщение.
  Smoke cleanup удалил только local deep-integration containers/volumes.
- Windows HTTPS QA account уже существует; повторное создание не выполнялось.
  Android Inspect preflight и bounded UI phase подтвердили установленный
  HTTPS package и прежний экран verified-publication; protected packages
  до/после совпадают. Это сохранённый статус, не свежая доставка. Registry
  DID2 readiness отвечает 503, staking portal — 200. Production rollout,
  account reset, main merges и GitHub Releases этим инкрементом не выполнены.
- GitHub Protocol/XNode и DevOps integration CI passed. DevOps unit выявил
  14 failures в ProfileGenerator harness: Windows-only subprocess names и
  truncated PowerShell rejection output. Native OS tool selection исправлен;
  security assertions сохранены, error adapter возвращает полный exception
  message. PowerShell 7 focused tests также воспроизвели оставшуюся пустую
  `GIT_ATTR_NOSYSTEM` после snapshot: originally absent overrides теперь
  удаляются, не восстанавливаются пустыми. Focused набор прошёл 25/25 под
  Windows PowerShell 7 и Linux ARM64 в network-disabled Docker. Docker SDK
  ARM64 apphost сначала дал exec-format error; только этот локальный probe
  запускал тот же pwsh DLL через dotnet wrapper. Это не GitHub runner result.
- Первый полный повтор XNode после harness fix дал unit 280/280,
  ProfileGenerator 107/107 и integration 473/474: durable replace в старом
  ContactRouteClosure fork test получил Windows Access denied. Focused
  unchanged test затем passed 1/1; причина transient file failure не доказана,
  runtime retry/обход durable barrier не добавлялся. Полный повтор тех же
  binaries под PowerShell 7 прошёл 861/861 (474 integration, 107 profile,
  280 unit). Harness fix `44387ca` отправлен; DevOps failed job перезапущен,
  итог CI attempt 2 пока не получен. Shared CI также выполняется.

## 2026-09-29 — DID2 local claim reservation/completion custody

- XNode получил DID2-only локальный журнал claim proposals в том же custody
  lock, что и inventory. Signed snapshot связывает exact XPK1/DPK2/XPI1,
  generation и counter; новый proposal должен быть членом retained inventory.
  Pending one-time keys не освобождаются после expiry/cancellation/restart.
  Last-resort допускается только после exhaustion и сохраняет counter в
  signed service generation, включая смену inventory epoch.
- Local completion принимает только opaque Protocol capability после проверки
  обеих selected-replica signatures, требует exact durable reservation,
  сохраняет первый exact XPC1 result и rereads snapshot. Это local completion,
  не распределённый quorum или permission отправлять DPH2. Signed state не
  обнаруживает rollback целого валидного backup; admission capacity ограничена.
- Первый focused reservation запуск: 11 pass / 2 fail. Tests выявили отсутствие
  durable fault latch для InvalidDataException; исправлен catch, assertions
  сохранены. После добавления completion/exhaustion/semantic corruption cases
  полный source-cutover `dotnet test XNode.slnx` прошёл **850/850**:
  unit 280, integration 463, profile 107; warnings/errors не наблюдались.
  Real DID2/network/inventory ceremony проверена для двух local journals,
  one-time Merkle inclusion и last-resort, включая restart и crash на replace.
  Это in-process local-storage evidence, не peer HTTP/2 или physical delivery.
- Documentation gate прошёл 172 checks. Никаких production rollout, account
  resets, main merges или GitHub Releases этим инкрементом не выполнено.
  V1 claim dispatch не активируется для DID2; новый endpoint, authenticated
  coordinator/peer prepare+commit, оба durable completion read-backs и
  independent current publisher/publication authority остаются в NEXT-SPRINT.
  Обычный pinned NuGet release graph также ещё требует согласования.

## 2026-09-28 — повторная проверка protected publication на устройствах

- Shared `c5b97ef` проверяет completed XIC1 pair против свежего DID2/device
  proof и текущего NETCODEC placement, не отправляя повторно inventory.
  Подписи, операция, manifest, две selected replicas и интервалы проверяются;
  после protected read повторно проверяются freshness, cancellation и floor.
  Это завершённая историческая операция, не свидетельство текущей retention
  или claim authority. Неверная сохранённая пара не заменяется молча.
- Первый focused набор: 22 pass и один failed тест с неверно выбранным
  временем expiry. Исправлен только тест: теперь используется существующий
  verifier TTL и проверяется вызов delayed read. Повтор исправленного теста
  вместе с двумя дополнительными negative cases прошёл 3/3. Это раздельные
  запуски, не единый полный зелёный local gate. Последующий полный CI
  `36467218566` завершился успешно: Windows 190/190 (20 min 25 sec),
  Linux portable filter 160/160 (5 min 57 sec). Windows-only crypto cases
  не приравниваются к Linux runtime coverage.
- MAUI Clean 35/35 и Smoke 119/119; обе supported diagnostic сборки готовы.
  Windows reopened тот же аккаунт; Android guarded update сохранил данные и
  неизменность трёх остальных пакетов. Новая network verification успешна
  на Windows (~18:57 UTC) и Android (~18:58 UTC). Recovery не раскрывалась,
  reset и новая account creation не выполнялись. Подробности и hash binaries —
  [MAUI evidence note](../deep-client-maui/docs/DID2-HTTPS-DEVICE-2026-09-28.md).
- Штатный Registry refresh продолжил неизменённый directory до 27/tree 10;
  independent floor совпал, DID2 readiness и staking HTTP 200.
  [DevOps runbook](../deep-devops/docs/DID2_FLOOR_PRODUCTION_CANDIDATE.md)
  остаётся владельцем operational observations. V2 atomic claim, DPH2,
  сообщения, файлы/картинки и группы на устройствах ещё не подтверждены.
- После сверки фактических ingress backends остановлены три устаревших
  изолированных diagnostic XNode процесса; контейнеры и состояние сохранены,
  все production service trios остались healthy. Причина прежних 429 этим
  действием не доказана; подробности у DevOps owner.

## 2026-09-28 — новые physical аккаунты и bounded proof refresh

- После ручного удаления тестовых аккаунтов Mr. X новые Windows/Android
  HTTPS QA аккаунты созданы через name/Create; recovery сохранена зашифрованно
  и не раскрывалась. Обе device сборки Shared `7c5ee55` завершились без
  warnings/errors. Это account-creation evidence, не messaging E2E.
- Новый ADF1 generation 2 продолжает прежние checkpoint, покрывает головы
  22–24 и ведёт к independently pinned head 25/tree 10. Registry recomposed
  на том же runtime image со всеми 13 mounts и прежним listener. Readiness,
  три XNode и staking portal успешны после импорта; root остался локально.
  Подробности принадлежат
  [DevOps runbook](../deep-devops/docs/DID2_FLOOR_PRODUCTION_CANDIDATE.md).
- Production trace обнаружила исчерпание DID2 proof budget фоновыми запросами
  трёх XNode каждые пять секунд. XNode `6764cbf` использует десятисекундный
  refresh и exact live local binding в пределах этого интервала, без продления
  signed lease; отказ refresh очищает binding, stop блокирует late result.
  Focused gate 21/21; полный source-cutover: 457 integration, 107 profile,
  262 unit. Один первый concurrent-lock test сообщил protected-storage-rejected;
  isolated и полный повтор прошли, причина нестабильности ещё не установлена.
  Docker multi-node rehearsal прошёл с настоящим Xray и fail-closed authority
  boundary после выбора незанятых локальных портов. Owner CI `36459171075`
  собрал immutable image без `latest`; installer обновил все три production
  seed с byte-identical зарегистрированными ключами и non-image settings.
- MAUI `d1f9ef9` добавил closed Android `networkOutcome`: null stageFailure
  не считается успехом, произвольный UI error text не экспортируется.
  Clean 35/35, smoke 119/119 и восемь classifier cases прошли.
  После rollout Windows (~17:49 UTC) и Android (~17:55 UTC) завершили
  authenticated publication с verified durable XIC1 pair от двух выбранных
  replicas. Обе программы перезапущены без reset; аккаунты и скрытая recovery
  сохранены. Independent floor остался 25/tree 10, затем штатное renewal
  продолжило неизменённый directory content до 26/tree 10. Эти результаты
  не подтверждают XPK1 claim, контакты или text/media/group device E2E.
  Подробности device build/наблюдений — в
  [MAUI evidence note](../deep-client-maui/docs/DID2-HTTPS-DEVICE-2026-09-28.md).

## 2026-09-28 — authenticated terminal diagnosis и idle receive refresh

- Трёхузловая private trace подтвердила реальные peer и DID2 proof HTTP 200;
  Windows получил sealed authenticated terminal failure, а terminal reject
  сопоставлен с `DeepIdV2ReplicaPreKeyInventoryVerifier`. Закрытая metadata
  проверка установила истёкшие интервалы двух staged test inventories. Exact
  bytes, account credentials, payloads и trace не помещались в Git.
- XNode `f7caf73` добавил сериализованное background refresh через прежний
  verified authority source, очистку readiness при ошибке и bounded retry,
  отмену и запрет reactivation поздним result после stop. Health-read остаётся
  side-effect-free. Focused gate 19/19, полный source-cutover gate:
  455 integration / 107 profile / 262 unit; owner CI success.
  Build/publish из XNode workflow отвергнут GHCR package permission;
  существующий package-owner DevOps workflow `36447887244` завершился успешно
  без изменения `latest`. Проверена source revision и опубликованный amd64
  digest. Installer `ea169fe` обновил все три production-ноды; XNode, ingress
  и прежний storage healthy, зарегистрированные Ed25519/BLS/X25519 ключи
  byte-identical. Общий OCI-index не скачался на seed1; выбран проверенный
  amd64 manifest того же image, не mutable tag или другая source revision.
- Registry кратковременно fail-closed вернул readiness 503 после expiry ADH1;
  поддерживаемый operator refresh продолжил тот же floor до 23/tree 8 и
  readiness HTTP 200. HeadRenewalEnabled в этой конфигурации не включён.
  Попытка ранней trusted-time rotation отвергнута monotonic guard; state hash
  остался прежним и guard не обходился. После независимой UTC/NTP/no-reboot
  проверки штатный operator `989edd` в одноразовом network-disabled контейнере
  с прежними protected mounts выполнил explicit interval refinement через
  exact-state CAS: uncertainty 8 → 4, новый state generation 13; readiness 200.
  Runtime Registry image/listener и genesis остались прежними.
- Shared `7c5ee55` исправил lifetime начального inventory и проверку live
  support до отправки. Первый focused path gate прошёл 16/16; финальный полный
  Release gate — 182/182, включая expired-before-dispatch и exact retry/reopen.
  Подписанные expired inventory не переписаны. Successor lifecycle,
  новая physical publication/XIC1 pair и text/media/group E2E остаются открытыми.
- MAUI `753ab13` добавил подтверждаемый UI reset только для изолированных
  диагностических аккаунтов; обычный клиент не содержит этого control.
  Clean gate 35/35 и smoke 119/119 прошли. Reset/create проверен локальным
  ViewModel/store тестом, не заявлен как выполненный на устройствах.
  Новые device builds выполняются; параллельный Windows build столкнулся с
  Android restore в общем obj/assets и должен быть повторён последовательно.

## 2026-09-28 — periodic DID2 root checkpoint без сброса production floors

- Реальный Registry failure связан с ADF1, покрывавшим только directory heads
  0–3. Независимый PostgreSQL floor и authenticated ADA2 export совпали на
  generation 22/tree 8; импортированный predecessor hash-matched с локальным
  оригиналом. Новый root-signed ADF1 generation 1 покрывает 4–21 и продолжает
  сохранённый generation 0. Ключи нод, account state и floors не сбрасывались,
  offline root seed не переносился на сервер.
- Protocol `acfdf7a` проверяет predecessor pin/root receipt, original coverage,
  полный signed-head lineage и все intervening heads до signer callback.
  Focused author/полный DID2 reader — 10/10; production solution — 2 100 pass,
  11 platform skips; exact public API/package graph прошёл. Wire/domain не менялись.
- DevOps `ce7b075` добавил paired predecessor inputs в offline tool и closed
  environment append с сохранением всех прежних значений. Три helper tests и
  release contract gate (51 commands) прошли. Production readiness остаётся
  blocked по реальным недостающим evidence. Docker smoke дошёл до healthy
  сервисов и scenario checks, но итоговый artifact secret scan не прошёл из-за
  смешанных ранее сохранённых diagnostic binaries; aggregate pass не заявлен.
- Registry recomposed на прежнем immutable image с обоими checkpoint и теми
  же mounts/listener. DID2 readiness и staking portal вернули HTTP 200. Реальная
  XNode trace установила DPQ proof HTTP 200; seed1 healthy и negative H2 frame
  HTTP 400. Windows теперь получает outcome-unknown после forwarding, Android
  — directory-authority unavailable. Durable XIC1 pair и messaging/media/group
  device E2E остаются открытыми. Exact observation:
  [DevOps checkpoint](../deep-devops/docs/DID2_FLOOR_PRODUCTION_CANDIDATE.md).

## 2026-09-28 — repeated NETCODEC mint и ONION marker rotation

- Shared `14d7a9d` исправил передачу полной подписанной successor-истории как
  incremental suffix на повторном mint; полный Release gate прошёл 172/172.
  Windows `343ac23` с тем же сохранённым аккаунтом прошёл NetworkVerification,
  дошёл до PreKeyPublication и получил отказ ingress до forwarding. Receipt pair
  отсутствует; сообщения, файлы/изображения и группы не заявлены проверенными.
- Последующая private trace сопоставила фиксированную ошибку
  entropy-ledger-failed с повторной записью rotating marker в create-only storage.
  Shared `9485198` добавил обязательный exact-value atomic CAS в journaled и
  in-memory storage, сохранив create-only начальную запись и marker-before-SQL
  fail-closed порядок. Focused custody/storage проверки прошли 8/8; отдельные
  CAS и canonical ingress error-классификации — 7/7. Это локальные проверки;
  полный Release gate прошёл 181/181. Следующая Windows device проверка с
  сохранённым аккаунтом дошла до ingress и установила canonical Unavailable
  BeforeForward; прежняя entropy-marker ошибка в этом запуске не повторилась.
  Это ещё не publication receipt и не доказательство готовности транспорта.
- Android `343ac23` сохранил аккаунт/recovery после guarded update; остальные
  три установленных пакета не изменились. Всегда отвергающий отдельный TLS
  handshake установил RevocationStatusUnknown. MAUI `c88f8cd` диагностирует
  только closed detail labels и тестирует доступ к подписанному CRL текущего
  публичного CA через точный host exception, исключительно в non-Release DID2
  HTTPS lane. System trust и revocation не отключены; clean gate — 35/35,
  smoke — 119/119. Обе device сборки завершились без warnings/errors.
  Android guarded update сохранил аккаунт/recovery, остальные пакеты неизменны;
  два запуска AccountProof завершились Timeout, TLS success не подтверждён.
- Все три реальные production XNode работают, но health стал unhealthy.
  На первой ноде readiness сообщает privacyRouting=unavailable при готовых
  required terminals. Receive-authority/proof path требует диагностики;
  protected floors не сбрасывались. Registry trusted time штатно продолжено
  до generation 12 через strict expected-hash CAS после UTC/no-reboot проверки.
- Registry продолжил прежнюю подписанную историю до generation 21/tree 7.
  Durable client DNH2 custody для restart/advance изменившегося tip остаётся
  незавершённой; live cache не заменяет этот release gate. Точные ограничения:
  [device checkpoint](../deep-client-maui/docs/DID2-HTTPS-DEVICE-2026-09-28.md).

## 2026-09-28 — Windows HTTPS account continuity и Android diagnostic lane

- Реальный Windows portable DID2 diagnostic создал аккаунт через UI и открыл
  тот же аккаунт после закрытия и запуска следующей committed сборки; recovery
  не показывалась и не копировалась. Registry floor вырос до generation 18/tree 7.
  AccountProof завершён; NetworkVerification выявил оборванное тело повторного
  HTTPS proof. Runtime trace не показал account/SQL lease timeout. HTTP/2 не
  устранил обрыв; independent plain HttpClient также воспроизвёл connection-reuse
  failure, тогда как три fresh-client closure запроса завершились. Корневой
  виновник runtime/network/proxy пока не установлен; publication не заявлена.
- MAUI adapter классифицирует HTTP/timeout по фиксированным этапам без вывода
  адресов, идентификаторов или private exception messages. Поддерживаемые
  Android build/install/UI scripts используют отдельный пакет, system trust,
  PKCS12 signing и аудит неизменности остальных установленных клиентов.
  Реальный Android аккаунт создан через UI, сохранился после restart и guarded
  update вместе с encrypted recovery. TLS AccountProof всё ещё отвергается
  (AuthenticationException / Chain Unknown); проверки сертификатов не ослаблены.
  Shared full Release gate — 171/171, MAUI clean — 25/25, smoke — 119/119.
  Это не подтверждение Android device delivery или готовности релиза.
- Точные результаты и оставшиеся physical gates:
  [MAUI checkpoint](../deep-client-maui/docs/DID2-HTTPS-DEVICE-2026-09-28.md).

## 2026-09-28 — DID2 installer/H2 и сохранённые origin keys

- Поддерживаемый installer выбирает immutable DID2 inputs без замены
  зарегистрированных Ed25519/BLS/Reality и production state volume. Новый
  image успешно собран owner CI; отдельное доверие proxy ограничено H2 listeners.
- Исправлен IP SAN в шести origin-сертификатах без изменения ключей, SPKI,
  onion seeds или исходного срока действия. Все три реальных локальных пакета
  прошли custody staging и строгий TLS preflight. Исходные inputs сохранены.
- Проверки и оставшиеся ограничения описаны в
  [DevOps checkpoint](../deep-devops/docs/DID2-INGRESS-INSTALLER-2026-09-28.md).
  Все три production-проекта затем обновлены installer; public served origin
  certificate/SPKI проверены. Прикладной H2 запрос выявил scheme/bodyless-GET
  дефекты; исправления прошли 822 XNode tests, owner CI `36410301823` и повторный
  rollout на всех трёх нодах. Внешние HTTP/2 bodyless capabilities GET дали
  200/ready с проверкой сертификата и protected SPKI. Authenticated peer operations
  и device delivery не подтверждены;
  GitHub Releases/`latest` не опубликованы.

## 2026-09-28 — authenticated DID2 startup на трёх production-хостах

- Registry issuance time исправлено explicit CAS interval refinement после
  независимой UTC/no-reboot проверки; signed uncertainty/expiry verifier не
  ослаблен, directory history и внешний floor не сбрасывались. Registry full
  source-cutover gate — 440 passed, focused authority — 24 passed.
- Immutable owner-CI XNode кандидат прошёл authenticated startup и same-image
  restart на seed1–seed3: nonce-fresh proof, installed onion-key binding,
  protected directory/network state и прежний key ring. Старые зарегистрированные
  identities и production node/ingress/storage сохранены.
- Remote UAT отсутствует: диагностический профиль находится на production.
  По решению Mr. X production testing разрешён до его явного сообщения о
  появлении пользователей. Exact images, наблюдения и non-claims находятся в
  [DevOps evidence](../deep-devops/docs/DID2-HOST-CANARY-2026-09-28.md).
- Peer TLS, live two-replica publication и physical messaging ещё не доказаны;
  GitHub Releases и `latest` не публиковались. Следующий инкремент остаётся в
  [NEXT-SPRINT.md](NEXT-SPRINT.md).

## 2026-09-28 — Windows portable startup checkpoint

- Исправлена зависимость unpackaged Windows-сборки от установленного App Runtime:
  оба runtime включены в output, пакетный Deployment Manager исключён только
  для Windows `None`, registration-free activation остаётся у SDK.
- ARM64 Debug build — 0 warnings/errors; полный smoke — 119, clean account — 19.
  Реальное окно открыло существующий DID2 probe без reset и без восстановления
  удалённой локальной фразы. Точный hash и ограничения проверки находятся в
  [MAUI evidence](../deep-client-maui/docs/DID2-WINDOWS-PROBE-2026-09-24.md).
- Только закрытый Registry UAT получил CAS-renewal protected time и ADH1
  generation 13/tree 6. Genesis, account history и production-ноды не сбрасывались.
  Startup/renewal не закрывают Windows admission или Android↔Windows messaging E2E.

## 2026-09-28 — DID2 restart-safe signed multi-role host candidate

- [DR-0012](survival-program/decisions/DR-0012-protected-network-history.md)
  фиксирует проверяемую protected network history и host floor/anchor без
  восстановления старого time/key capability. Повторный startup/mint больше
  не стирает predecessor через null; другой installed key отклоняется до записи.
- ONION host получает только DID2 authority и роли подписанного XND1.
  Fixed-role options/CLI/compose удалены, неизвестная host configuration
  отклоняется. Reflection-created positive network fixture удалён из host tests.
- Настоящий signed three-host test обнаружил неверную 32-byte ширину network ID
  в replay adapter. Новый несовместимый local generation принимает 16-byte
  NETCODEC ID, отвергает старое состояние и replay после restart. Все шесть
  permutations проверены с durable replay/entropy и encrypted key vault.
- Локальные Protocol/package/host/config проверки и изолированный no-mock
  Xray rehearsal проходят; точные результаты и non-claims принадлежат DR-0012.
  Это не live publication, messaging device E2E или готовый релиз; оставшиеся
  activation задачи сохранены в [NEXT-SPRINT.md](NEXT-SPRINT.md).

## 2026-09-09 — official Windows ML-KEM/Braid runtime acceptance

- Official GitHub Actions artifact `10106322624` из run `34356754852`, attempt
  1, зафиксировал воспроизводимые `/Brepro` Braid DLL/import libraries из двух
  чистых изолированных target roots. Whole ML-KEM сохранил ранее принятые exact
  hashes; Braid получил новые deterministic hashes для Windows x64 и ARM64.
- Exact Braid binaries прошли managed state-machine и wrapper probes на
  физическом Windows ARM64 host: ARM64 нативно, x64 через Windows x64 emulation.
  Проверены standard-ML-KEM interop в обе стороны, pinned digest/approval
  fail-closed и single-consumer contention. Оба RID добавлены в закрытый
  production allowlist и NuGet package payload; полный Protocol gate прошёл
  `1650/1650`, 11 explicit native-harness skips, package witness прошёл.
- Apple client lane по решению Mr. X перенесён в следующий спринт. macOS, iOS и
  Mac Catalyst jobs удалены из текущей CI matrix и не возвращаются без его
  явной команды; текущий release scope — только Android и Windows.
- После исчерпания GitHub-hosted Actions лимита новые jobs завершаются до
  выдачи runner (`steps=0`). Workflow для повторной official сборки и managed
  x64 probes сохранён; следующий обязательный CI запуск будет выполнен на
  on-premise runners после их подключения оператором.

## 2026-09-09 — authority-bound DTT1 issuance epoch clean-break

- DTT1 получил подписанный authority-bound UTC-day issuance epoch, связанный с
  exact XNA1 authority core и DTS1 policy core. Старый 14-field DTT1 отклоняется
  без dual reader; signing/core projections теперь включают tag 13.
- Registry production issuer активируется только при полном наборе verified
  snapshot/proof/custody/trusted-time/ledger dependencies. Durable ledger v2
  связывает nonce с номером и ID эпохи, допускает только монотонный переход
  вперёд, а старые маркеры удаляет лишь после полной authenticated bounded scan;
  rollback, fork и tampering fail closed.
- Protocol AccountDirectory gate прошёл `95/95`, package witness `3/3`;
  Registry local-cutover gate прошёл `276/276`, Release builds — без warnings.
  Documentation gates прошли `172/172` и `176/176`.
  Прямой client-to-Registry lookup по-прежнему запрещён; production deployment
  всё ещё требует настоящие root/genesis/contact/group/release authorities.
- Native policy переведена на consumption готовых signed/attested official Deep
  ABI binaries без локальной пересборки. Существующий Windows x64 runtime уже
  hash-allowlisted; Windows ARM64 остаётся pending, потому что upstream
  `mlkem-native` публикует source provider, а не совместимый Deep wrapper DLL.
- В `deep-protocol` добавлен ручной GitHub Actions workflow официальной сборки
  Windows x64/ARM64 Whole ML-KEM и Braid ABI с pinned toolchains, clean-checkout
  gate, SHA-256 manifest, artifact attestation и закрытым binary bundle. ARM64
  Braid тесты cross-compile без попытки исполнять ARM64 PE на x64 runner;
  production acceptance всё ещё требует получить и проверить сам attested
  artifact на зафиксированном commit.
- Mr. X назначен единственным временным владельцем всех production authority до
  явного изменения перед появлением пользователей. Существующий Play upload
  credential скопирован без изменения в отдельный `secrets/prod/android`;
  private bytes и passwords не выводились.
- Legacy inline VLESS/REALITY credentials first-release topology fail-closed
  перенесены в шесть ACL-защищённых per-node files; private env теперь содержит
  только `_FILE` bindings. `Config` и focused contracts проходят, survival stack
  не изменён. `Up` честно остановлен до production root signer custody и
  отсутствующих `ADH1/ADC1/XVP1/XNV1/XNH1/XND1/PMT2` genesis authors.

## 2026-09-09 — final security hardening и fail-closed release composition

- XNode quorum signing теперь доступен только на exact peer-RPC listener и из
  разрешённой coordinator network; public API listener не может стать signing
  oracle. REALITY private key и VLESS UUID читаются только из bounded read-only
  secret files, не попадают в environment/options serialization, а generated
  Xray config фиксируется атомарно с закрытыми правами. Полный XNode Release
  regression после hardening прошёл `696/696`.
- Registry проверяет, что verified XIR1 подписывает именно запрошенный locator,
  до любого LKG/fork-state mutation. Публичные lookup paths получили общий
  bounded admission с короткоживущими per-source buckets; production
  ContactResolve HTTP issuance на этом этапе оставался намеренно `503`, потому
  что CDQ1/DTT1 ещё не содержал authority-bound replay epoch для безопасной
  compaction exact one-use nonce ledger. Прямой MAUI-to-Registry lookup удалён;
  production client принимает только verified privacy-routed host capability.
- Release `InternalsVisibleTo` между Shared и MAUI удалён из фактического build
  graph. Account-scoped SQLCipher/pre-key/session owner перенесён за opaque
  `DeepDirectMessagingStorageFacade`; raw store/secret типы остались internal.
  Actual dependency-shape hostile gate, Windows app/ViewModels builds и
  direct-storage lifecycle/restart/cleanup `11/11` прошли.
- First-release readiness теперь требует Contact и Group terminals и остаётся
  `503 required-unavailable` до настоящих Registry genesis/leaf и GSR1/DCR1
  authority inputs. Group creation с участниками также fail closed до real
  invitation/fanout/acceptance, не создавая ложный owner-only success.
- Docker, публикация, deploy и physical install не выполнялись. Оставшиеся
  production authority/composition и Windows ARM64 native prerequisites ведутся
  только в `NEXT-SPRINT.md`.

## 2026-09-08 — bounded DPK2 publication/claim и opaque client custody

- Protocol заменил monolithic XPP1 на bounded manifest/chunk/commit до 65 945
  байт на request, проверяет две независимые final XIC1 и выдаёт sealed atomic
  installation plan с restart-safe replica lineage. XPK1/XPC1 получил durable
  exact-retry journal; cross-operation, rollback, fork, phase/status и legacy
  wire fail closed.
- Private DPK2 material больше не пересекает public assembly boundary и не
  хранится в raw SQL columns/callbacks. Versioned XChaCha20-Poly1305 blob
  привязан к network/account/device generations, DPD1, exact DPK2, kind и
  pre-key IDs; Shared schema generation 4 хранит только exact DPK2 и canonical
  opaque blob, восстанавливая single-use capability только внутри atomic
  responder/TRS1 saga.
- Production `InternalsVisibleTo` из Protocol удалён. Public genesis composition
  выдаёт verifier-minted device и opaque `AuthorGenesisDmd1`, не экспортируя
  issuer seed/signature/provider. Full Protocol Release: `1883 passed`, 11
  platform-native skips; package witness, immutable corpus и zero-friend gates
  прошли. Full Shared win-x64: `1680/1680`, без skips; approved native asset
  SHA-256 `D682595F4F88D18A1A3039319D22CC06AAAA706C851EC717B06B6E45D42B2F45`.
- Shared ContactResolve теперь отправляет XPK1 через durable journal, а каждый
  bounded XPP1 stream — отдельно двум placement replicas; activation возможна
  только после двух verified XIC1. XNode сохраняет journal и inventory одной
  транзакцией до подписи single-replica XIC1; full gates: XNode `218/218`,
  integration `362/362`, profile generator `107/107`; Registry core `265/265`.
- Дополнительно устранены SQLite self-deadlock revocation read без TOCTOU,
  cancelled queued stale send и late physical failure после уже сохранённого
  terminal state. MAUI account owner смонтировал отдельные SQLCipher XPK1,
  current-DMD1, Group invitation activation stores и удалил legacy
  GroupV1 `SessionId` alias.
- First-release Docker не запускался: отсутствуют offline root signer/current
  authority artifact inventory и TLS PEM. Survival stack остался healthy.
  Physical delivery не заявлен: current DMD1/account-authority producer ещё не
  подключён к AppShell activation, а Windows ARM64 C++ target/native ML-KEM
  prerequisite на машине отсутствует.

## 2026-09-08 — публичная документация синхронизирована с release readiness

- Пользовательские и операторские страницы теперь честно отделяют готовый
  offline account/постоянный Deep ID от ещё не активированных direct messaging,
  групп и first-release XPoint stack. Зафиксированы Android API 28, будущие
  P2P mesh/on-prem профили и текущий Registry authority blocker.
- Повторяющиеся нормативные детали заменены ссылками на master technical docs;
  `verify-render` прошёл `241/241`, `npm audit` не нашёл уязвимостей,
  `git diff --check` чистый. Публикация не выполнялась.

## 2026-09-08 — Registry production ContactResolve authority prerequisites

- Registry получил production trusted-time source, durable one-use request
  ledger и DTT1 witness custody. Trusted UTC задаётся оператором, защищается
  HMAC и продвигается monotonic clock; rollback/reset/tampering/expiry и nonce
  replay после restart закрывают issuer fail-closed.
- Операторские команды `provision-time` и `author-package` проверяют полную
  Protocol-signed closure и выпускают свежие request-bound DTT1/ADP1 и
  canonical CDR1. Witness seed не выходит из custody, а неполная включённая
  конфигурация останавливает startup до файловой мутации; default остаётся
  dormant/503.
- Hostile/restart gate прошёл `10/10`, Directory/ContactResolve — `69/69`,
  Registry Release — `265/265`, build с warnings-as-errors чистый. Выпуск и
  монтирование внешнего root/topology/contact proof package в first-release
  compose остаются DevOps-композицией.

## 2026-09-08 — fail-closed DPK2 privacy transport boundary

- Shared разделяет pre-key publication и claim и возвращает вызывающему коду
  только Protocol-verified capabilities; direct HTTP, raw XIC1/XPC1/DCB1,
  caller trust и fallback отсутствуют. Для обоих путей доступны отдельные
  machine-readable blocker states.
- XPK1/XPC1 уже поддержан Protocol ContactResolve, но требует durable XPK1
  journal и расширения production path authority с XIQ1 на exact XPK1.
- XPP1 publication намеренно остаётся закрыт: максимальный XPP1 (`8 362 607`
  bytes) не помещается в bounded onion request (`1 048 576` bytes), а повышать
  общий предел нельзя. Нужен canonical chunk/manifest/commit protocol без
  частичной активации. Focused gate прошёл `7/7`, ContactV1 — `129/129`,
  Shared Release build чистый.

## 2026-09-08 — durable GroupV1 invitation/acceptance orchestration

- Invitation activation теперь сначала фиксируется в durable store и только
  затем отправляется через готовый privacy-routed GroupControl. Exact
  predecessor, known sibling/fork и out-of-order проверяются до первого
  network write; generic transition API не может обойти invitation semantics и
  фиктивно сделать участника active.
- Exact-operation retry/restart, verified GSS1, idempotent commit и permanent
  conflict latch сохранены; per-device message handoff допускает только узкий
  DPE2 dispatch context без legacy payload/`SessionId`.
- GroupV1 Release gate прошёл `74/74`, solution build чистый. Account-scoped
  MAUI store/transport composition и реальный DPE2 dispatcher остаются
  незавершённым consumer.

## 2026-09-08 — owned bounded HTTP service boundary

- Публичные `CreateBoundHttpHandler`, `HttpClient`, network-hook/delegate seams
  удалены. Registry и Contact Directory используют factory-owned disposable
  POST transport с exact path allowlist, request/response bounds и строгой
  endpoint/media-type проверкой; Contact directory constructor стал internal.
- Internal attested-carrier hooks сохранены через first-party friend boundary.
  Redirect, cookies, decompression и system proxy выключены; TLS certificate
  revocation остаётся `Online`.
- Исходный public-surface regression прошёл `1/1`, Shared HTTP — `64/64`, MAUI
  Registry/Contact — `32/32`, smoke — `24/24`; затронутые Release builds чистые.
  Это намеренный clean-break для внешних потребителей.

## 2026-09-08 — atomic initiator DPH2/TRS1 Shared adapter

- Protocol initial-session capability потребляется ровно один раз и фиксирует
  exact DPH2 вместе с canonical TRS1 одной SQLCipher-транзакцией, связанной с
  operation/session/contact, обеими account/device и directory generations.
- Exact replay идемпотентен; wrong scope/generation запрещает dispatch, а
  changed bytes ставят durable fork latch. После restart pending DPH2 доступен
  из защищённого outbox; UI cancellation после consume не разрывает короткий
  atomic commit. MessagingCrypto schema clean-break поднята до generation 5.
- Новые тесты прошли `10/10`, расширенная regression — `45/45`, Shared Release
  build чистый. Session остаётся pending до verified privacy-routed DPH2
  delivery receipt; established DPE2 заранее не выдаётся.

## 2026-09-08 — MAUI GroupV1 composer clean break

- Group composer больше не использует `SessionId`, legacy `ClientRuntime`,
  `IContactMailboxOnboarding` или scaffold API. Он принимает canonical
  `deep1…`/DIA1, повторно проверяет сохранённый ContactV1 package и создаёт
  GroupV1 через account-scoped runtime и custody текущего устройства.
- Missing account/custody/verifier/owner authority показывается как точный
  fail-closed state. Legacy GroupChat для нового group ID не открывается;
  verified members остаются draft до настоящего invitation/fanout/acceptance,
  а не объявляются активными фиктивно.
- Focused Release gate прошёл `9/9`, XAML/Windows compile и source guard чистые.
  Durable GroupControl invitation/acceptance и GroupChat DPE2 handoff остаются.

## 2026-09-08 — first-release ONION config wiring

- DevOps provisioning создаёт для каждого из трёх XNode отдельный 32-byte
  state-protection key и передаёт bounded replay/entropy/key-vault paths;
  позиции закреплены как Ingress/Core/Exit. Значения ключей не выводятся,
  повторное provisioning идемпотентно.
- Compose `Config`, `11/11` Node contracts, PowerShell guards, locked helper
  build и private-material scan прошли. `Up/Verify` fail closed до image build:
  Registry ещё не предоставляет production trusted-time source, durable
  one-use ledger, DTT witness custody и полный current
  ADH1/DTT1/ADP1/XVP1/XNV1/XNH1/XND1/PMT2 authority package.
- First-release containers остались остановленными, volumes сохранены, survival
  stack не изменён и остаётся healthy.

## 2026-09-08 — durable DPK2 publication/claim owner

- Shared атомарно сохраняет authored one-time/last-resort secret capabilities
  вместе с exact XPI1/XPP1 в account/device/generation/DPD1/DMD1-bound
  SQLCipher inventory. Private material проходит только через одноразовую
  `Dpk2PreKeySecretCapability`; raw-key/provider/trust-flag API отсутствует.
- Verified XPC1 связывается с exact DPK2 hash и prekey IDs. One-time secret
  удаляется после finalization, last-resort zeroize-ится после bounded use;
  replay возвращает exact XPP1, а rollback/conflict/predecessor mismatch ставит
  durable fork latch.
- Shared PreKey/coordinator gate прошёл `35/35`, Protocol DPK2/DPH2 — `5/5` и
  `11/11`; обе Release сборки чистые. MAUI lifetime/publication scheduler и
  privacy-routed XPP1/XPK1/XPC1 wiring остаются незавершёнными.

## 2026-09-08 — canonical arbitrary-contact MAUI entry flow

- New-conversation UI принимает только canonical permanent `deep1…` DID1 или
  поддерживаемый DIA1 и запускает durable ContactV1 resolver state machine.
  Retryable offline/unavailable сохраняет pending address и исходный ввод с
  точным повтором; local account startup от сети не зависит.
- Verified outcome выдаёт только verifier-minted opaque relationship и
  conversation IDs. Pending/terminal/fail-closed не открывают чат; `SessionId`,
  старый `05…` parser и legacy Chat route в этом entry-flow отсутствуют.
- Unit gate прошёл `8/8`, source smoke — `2/2`, Core Release и Windows
  MAUI/XAML Debug — без warnings/errors. AppShell activation нового DPH2/TRS1
  runtime остаётся незавершённым consumer.

## 2026-09-08 — XNode production ONION runtime closure

- `ProductionCapabilityAvailable` больше не является заглушкой или отражением
  одного config-флага. Capability появляется только из актуальной Protocol-
  minted XNV/XND/network authority, exact local owner/role, durable replay и
  entropy stores, opaque X25519 key-vault binding и codec, переданных атомарно.
- Stale/mismatch/wrong role/missing authority/partial DI fail closed; импорт
  X25519 не перезаписывает несовпадающий существующий vault slot. Health и
  advertised capabilities используют ту же проверенную instance capability.
- Privacy runtime gate прошёл `11/11`, durable ONION/key-vault — `16/16`, полный
  XNode Release build — без warnings/errors. First-release compose ещё должен
  передать отдельный state-protection secret, state paths/position и current
  topology/contact authority package.

## 2026-09-08 — production DPH2 initiator и initial TRS1

- Protocol реализует двухфазный `PrepareClaim → Complete` только из
  `VerifiedDpk2Offering`, exact XPC1 claim receipt и локального device agreement
  lease. Ephemeral и initial-ratchet X25519 создаются внутри boundary.
- Результат содержит self-verified canonical DPH2, первый DMC2 с одним из
  допустимых padding buckets, durable canonical TRS1 и single-use zeroizing
  capability для их атомарной фиксации. Recovery seam существует только в
  test build; неподтверждённые ML-KEM/Braid assets fail closed.
- Focused initiator gate прошёл `11/11`, расширенный crypto/integration —
  `68/68`, native provider suites — 16 passed/6 environment skips; полная
  Protocol Release сборка завершилась без warnings/errors. Shared atomic-store
  adapter и network dispatch остаются незавершёнными потребителями.

## 2026-09-08 — MAUI direct-message storage owner и session catalog

- Локальный Deep account теперь владеет одним account-wide SQLCipher DPK2
  prekey store и отдельным SQLCipher DPE2 store для каждого verified
  contact/device/DPH2 tuple. Durable DSC1 catalog связывает network, обе пары
  account/device с поколениями, `ContactConversationId32` и exact DPH2 ID.
- Boundary не использует `SessionId`, recovery phrase или synthetic aliases;
  protected keys разделены, pending→active recovery, wrong generation/network,
  reset и zeroization fail closed. Focused SQLCipher gate прошёл `9/9`.
- Owner теперь также владеет `ProductionPreKeyV1InventoryOwner`, сохраняет
  exact XPI1/XPP1, готовит verified-DPK2 initiator DPH2, атомарно фиксирует
  TRS1 и принимает responder commit через `ContactInitialSessionCoordinator`.
  Canonical DPD1 reference, scope/generation/restart/reset и zeroization
  подтверждены обновлённым gate `11/11`.
- MAUI Windows ARM64 Release собран без warnings/errors; проверенный DLL имел
  SHA-256 `FE016207F34B0014FC5589AE35C1F67F0F078CE990E811F8B4CC4C3FE2952091`.
  Сетевая DPK2 publication/claim, DPH2 dispatch и production bridge от
  protected device authorization к одноразовой agreement lease остаются
  незавершённой композицией.

## 2026-09-08 — incremental ML-KEM Braid supply-chain evidence

- Для неизменённых Windows x64 и Android arm64 candidate bytes добавлены
  machine-readable manifest и CycloneDX SBOM (22/21 компонентов), точные
  hashes Rust 1.89.0, `Cargo.lock`, `libcrux-ml-kem 0.0.10` и всех crate
  checksums.
- Rebuild gate повторно подтвердил exact 17 exports, Windows CFG/ASLR/High
  Entropy VA/NX, Android RELRO/NOW/non-executable stack/no TEXTREL и физический
  USB roundtrip. Hostile drift gate отклонил `6/6` мутаций manifest/artifacts.
- Production approval не включён: Windows ARM64 candidate, независимый oracle
  и crypto/dependency review остаются обязательными. Исходники native candidate
  и evidence должны войти в будущий коммит атомарно.

## 2026-09-08 — locator-keyed MSG01 recipient authority

- XNode получил production source, который по opaque locator повторно связывает
  Protocol-verified DPD1/DCA1/XIR1 с PMS2 из того же replica-authenticated
  route closure и текущими XNV1/PMT2. Permanent resolve и one-time invite claim
  поддерживаются без caller trust flags, raw keys или локального DPE1 minting.
- Проверяются monotonic freshness, network/locator, exact references, сроки и
  active-device status; повтор идемпотентен и использует один immutable evidence
  snapshot. Focused integration прошла `42/42`, XNode Release build — без
  warnings/errors.
- Добавлен durable bounded permanent/one-time resolve evidence cache с двойной
  authenticated encryption, restart recovery, zeroization и постоянной fork-
  защёлкой. Перед записью и чтением заново проверяются DID1/DIA1, XIQ1/XIS1,
  DCR1, DCB1/DMD1/DPD1 и route closure; plaintext identity/locator material в
  cache не хранится. Полный XNode gate прошёл `675/675` и Release build чистый.
- Production issuer/client flow ещё должен передать этому owner independently
  verified evidence через privacy-routed authenticated ingestion; до этого
  неизвестный locator остаётся fail-closed unavailable, без Registry/raw
  fallback.

## 2026-09-08 — безопасный first-release local bootstrap

- DevOps создаёт три свежих независимых XNode identity и защищённый ignored
  `first-release.env` в `C:\Work\DeepSession\secrets\first-release-local`.
  Ed25519 создаётся штатным Node crypto, Reality — offline Xray, а BLS
  public/proof — production XNode verifier через Prague/EIP-2537 RPC; VLESS,
  X25519 и BLS scalars используют криптографический RNG.
- Десять contract/keygen тестов, locked .NET restore/build, реальная BLS
  integration, ACL/inventory, secret scan и повторный bootstrap прошли.
  Повторный запуск не заменяет существующие identity и не печатает private
  material.
- `Config` проходит. `Up/Verify` остаётся fail-closed до подключения настоящей
  production ONION runtime closure в XNode; guard не отключён. Неуспешная
  first-release topology остановлена, survival stack остался healthy.

## 2026-09-08 — privacy-routed GroupControl client transport

- Shared client выбирает exact-three GroupControl route только из защищённых
  entry guards и проверенного `VerifiedGroupControlPlacement`; request всегда
  использует типизированную операцию `GroupControl`, а не общий или caller-
  controlled ingress.
- Exact GSW1/GSQ1 проходит через managed privacy ingress, а GSS1 проверяется
  production Protocol client до изменения client state. Fallback разрешён
  только после подтверждённого pre-forward reject; wrong route/network/
  operation, replay, hostile bounds, redirect и неверный media type закрыты.
- Focused GroupV1/managed-ingress regression прошёл `68/68`, Shared Release
  build — 0 warnings/errors. Это закрывает control transport, но не заменяет
  ещё незавершённый per-device DPE2 fanout и physical group-message gate.

## 2026-09-08 — physical Android gate incremental ML-KEM Braid

- Whole-KEM `mlkem-native` v2.0.0 production wrapper также прошёл отдельный
  managed Android probe на API 26: packaged identity/digest, drift rejection,
  roundtrip, dispose/reload и production-runtime owner. Probe-only asset:
  325216 байт, SHA-256
  `7799b36b8c522905f655af518124cdd74b97224c4ee42beb2f8142065392cd87`.
- Pinned `libcrux-ml-kem 0.0.10` incremental provider повторно собран для
  `android-arm64` с NDK `28.2.13676358`; export allowlist содержит ровно 17
  Deep ABI symbols, зависимости ограничены `libc.so` и `libdl.so`, проверки
  RELRO/NOW прошли.
- На физическом `arm64-v8a` Android устройстве изолированный native probe
  выполнил два keygen/Encaps1/Encaps2/decapsulation roundtrip, unload/reload и
  подтвердил отклонение replay/double-dispose без вывода secret bytes.
- Отдельный .NET 10 Android probe APK на том же API 26 устройстве подтвердил
  managed-wrapper staging/digest, закрытый production allowlist, ABI load,
  exact shared-secret interop, single-use и concurrent single-consumer,
  disposed-provider fail-closed. Десять полных roundtrip заняли 26,752 мс.
- Воспроизводимый текущий candidate: 612344 байта, SHA-256
  `fa287d90ffff2c6e5b199c7f8ec487e16d989f75e39c2620b07c26e1dccbdf0d`.
  Это закрывает Android compatibility evidence, но не включает production
  approval: Windows ARM64 asset и независимый crypto/dependency review ещё
  остаются gate.

## 2026-09-08 — XNode Contact route authority producer

- XNode атомарно получает current verified Contact/XPoint snapshot и mint'ит
  `VerifiedContactNetworkAuthority` только через Protocol verifier с exact
  XNV1/XNH1/ADH1/PMT2, network/locator/generation/freshness checks до запроса
  Registry. Stale/fork/rollback и malformed durable state дают одинаковый
  coarse unavailable.
- Typed DI остаётся default-dormant и fail-closed до появления locator-keyed
  источника уже проверенных recipient DPD1/DCA1/XIR1 и независимо полученного
  PMS2; Registry bytes не повышаются до trust authority.
- Focused Contact/GroupControl regression прошёл `95/95`, полный XNode Release
  gate — `651/651`, build — 0 warnings/errors.

## 2026-09-08 — durable verified peer package

- Contact relationship теперь атомарно сохраняется вместе с полным exact
  verified package: XIQ1/XIS1/DCR1/DCB1/DMD1/DPD1, route closure, версии,
  hashes и scope/correlation identifiers. CLR capability objects в БД не
  сериализуются.
- Публичное чтение возвращает defensive-copy evidence, а `ReverifyAsync`
  повторно декодирует и криптографически проверяет durable bytes перед выдачей
  свежего authority для DPK2/DPH2. In-memory и SQLCipher semantics совпадают;
  restart/replay/fork/rollback/corruption закрыты тестами.
- ContactV1 schema clean-break поднята до generation 4; старую локальную
  ContactV1 БД нужно пересоздать. Focused gate — `55/55`, production
  capability gate — `113/113`, Release build — 0 warnings/errors.

## 2026-09-08 — production DPK2 authoring

- Protocol device-secret owner теперь создаёт production DPK2 authority только
  для exact active/unforked DPD1/DMD1. Boundary сама генерирует bundle/prekey
  IDs, X25519 и ML-KEM-768 keypairs, формирует canonical one-time/last-resort
  DPK2 и подписывает три exact projection текущим device signing key.
- Private prekeys выдаются единственной opaque single-use capability и
  zeroize-ятся; public raw-key/provider/delegate seams и Session aliases
  отсутствуют. DPK2 интегрируется с XPI1/XPP1 publication boundary.
- Debug regression прошёл `120/120`, Release focused gate с настоящим
  `deep_mlkem.dll` — `87/87`, Protocol Release build — 0 warnings/errors.

## 2026-09-08 — targeted current directory и безопасный offline Debug

- Registry получил default-dormant `POST /api/v1/directory/current-values`:
  exact ADL1 lookup request выбирает только один current-value package и не
  принимает DID/account/device или caller-authored trust. Wrong network,
  missing/nonmembership и stale/forked floor неразличимы как пустой `404`;
  отсутствие verified source/custody/time/one-use ledger даёт пустой `503`.
  File publication повторно проверяет immutable inventory, generation,
  hashes, traversal/reparse/TOCTOU, rollback и same-generation fork. Registry
  Release gate прошёл `255/255`, build — без warnings/errors.
- Shared HTTP-клиент выбирает этот endpoint только для targeted current-value
  контекста, отправляет exact 286-byte request и принимает компактный пакет из
  восьми exact-артефактов. Обычный contact-resolve endpoint сохранён отдельно;
  `404` и `503` отображаются в неэнумеруемые typed outcomes, а HTTP bytes не
  повышаются до authority. Focused HTTP gate — `37/37`, затронутый XPoint gate
  — `98/98`, Release build — без warnings/errors.
- Обычная Debug-композиция после локального создания account больше не падает
  только потому, что сборка не является physical UAT: legacy transport
  открывается dormant и fail-closed до первой сетевой операции. Локальный
  account/store startup не требует Registry или соединения.
- Legacy HTTP call signaling, который повторно загружал recovery phrase для
  подписи, удалён из MAUI composition. До подключения typed ratcheted call
  signaling ветка с настроенным call origin возвращает явный `NotSupported`,
  а не читает recovery secret и не выполняет silent downgrade.

## 2026-09-08 — Group v1 authoring и GroupControl client boundary

- Protocol production author теперь создаёт exact remove-account,
  leave-account и role-change transitions, проверяя base state, current
  directory closure, custody signer, member-entry hash и роли. Удаление или
  выход owner и фиктивная смена роли отклоняются.
- GSW1/GSQ1/GSS1 получили закрытую production client boundary: operation,
  group, GSR1, placement и две Ed25519 receipt выбранных XNode связываются до
  выдачи capability. `SessionId`, `05...` aliases и caller-authored trust на
  этой границе отсутствуют. Focused Group/GroupControl gate прошёл `29/29`,
  Protocol Release build — без warnings/errors.
- Shared получил typed `IDeepGroupV1Runtime`: local create/invite/accept,
  membership proposal/commit/apply/read работают через production author,
  `GroupClientStateService` и account-scoped SQLCipher store. Public/runtime
  boundary использует реальные Group/Account/Device IDs, проверяет custody и
  exact GSS1 до CAS-мутирования; `SessionId`, `ConversationId`, `05...` и
  caller trust flags запрещены source guard. GroupV1 gate — `44/44`, Shared
  Release build — без warnings/errors.

## 2026-09-08 — permanent Deep ID verifier и clean-break client surfaces

- Protocol теперь mint'ит sealed `VerifiedPermanentContactResolveClosure` только
  после exact DID1/XIQ1/XIS1 correlation, current directory freshness,
  permanent DCR1 open, полного identity/device closure и двух подписей выбранных
  resolver replicas из разных failure domains. Unsigned permanent success и
  one-time receipt substitution отклоняются; ContactV1 gate — 118/118.
- MAUI default-dormant ContactResolve bootstrap не создаёт network/runtime до
  локального account success и verified host capabilities. Entropy ledger и
  X25519 vault account/device/store-bound, restart/rollback/corruption fail
  closed; focused bootstrap/runtime checks — 17/17.
- Settings показывает постоянный `deep1...` из offline Deep account, а не
  legacy Session ID. Повторное чтение recovery phrase из Settings удалено:
  фраза раскрывается только один раз до подтверждения создания account. Logout
  очищает authoritative Deep local state. ViewModel/smoke checks — 5/5,
  Windows ARM64 Debug build — 0 warnings/errors.

## 2026-09-08 — XNode GroupControl production authority composition

- GroupControl host получает authority только из current verified XPoint and
  Contact closure, повторно проверяет exact GSR1/DCR1/DCA1/DMD1, две replicas,
  local Exit role, network, generation и expiry. Durable lineage обнаруживает
  restart rollback/fork/corruption.
- Полная explicit configuration активирует runtime, partial configuration
  останавливает startup, default остаётся dormant; fallback и caller-provided
  trust отсутствуют. Focused unit/integration gate — 28/28, Release build —
  0 warnings/errors.

## 2026-09-08 — transport-only Contact route-closure distribution

- Registry получил default-dormant `POST /api/v1/contact-route-closures` с
  exact 50-byte network/locator request и bounded exact-six
  `XRR1/XRA1/XRC1/XSS1/PMT2/PMS2` response. Endpoint не принимает и не выдаёт
  Deep ID, account/device, DCR1 plaintext или resolver capability и не имеет
  enumerable list API.
- File-backed source проверяет canonical immutable generation inventory,
  hashes, XIR/route graph, path/reparse/TOCTOU, per-locator rollback и
  same-generation fork. HTTP bytes остаются только transport input и не mint'ят
  verified authority.
- Подтверждено 14/14 focused hostile tests и 243/243 Registry tests на local
  Protocol cutover; Release build завершился без warnings/errors.

## 2026-09-07 — clean-break messaging protocol foundations

Статус: завершены только перечисленные локальные protocol/authority packages;
произвольный контакт в product runtime, доставка сообщений, physical E2E и
production deployment пока не заявляются.

- Production MAUI startup/account graph отделён от сетевого bootstrap: создание
  и cold restart локального Deep account не разрешают Registry/HTTP callback.
  Старые raw privacy-hop/key artifacts удалены из UI composition; при отсутствии
  нового host adapter сетевой путь возвращает типизированный fail-closed, а не
  подменяет локальную ошибку сообщением о подключении. ViewModels gate прошёл
  `613/613`, focused offline smoke — `22/22`.
- NETCODEC runtime принимает bounded ordered XVP1/XNV1/XNH1/PMT2 chains,
  проверяет authority, threshold, lineage, fork, freshness, DTT и exact
  Contact-service placement; максимумы — 4096 поколений и 64 MiB. Protocol
  suite: `1464 passed`, `6 skipped`; два внешних package/snapshot gate не входят
  в этот результат. Дополнительно реализован bounded XNF1/NFP1 reset-path:
  exact NFP/XNF и непрерывная XNA authority chain, RFC 6962 source-membership,
  root/witness thresholds, target XNV/XNH и live DTT проверяются с лимитами
  64 XNA, 64 XNF и 560 KiB. Компактированный current snapshot можно проверить
  без generation-zero operational history; новый XNF сохраняется в следующем
  protected LKG. XPoint focused gate прошёл `86/86`. Клиентский XLK1-кодек
  фиксирует exact 265-byte protected LKG, а account/device/network-scoped
  SQLCipher store выполняет atomic CAS, restart recovery, idempotent replay и
  persistent fork latch; verified current/successor/reset capabilities
  проецируются в него без caller-authored snapshot. Дополнительный регрессионный
  slice `7/7` подтвердил, что
  обычная operational rotation сохраняет прежний forward-checkpoint floor и не
  требует нового root checkpoint на каждом XNV1 поколении.
- Итоговый MAUI offline account owner теперь лениво открывает эти XPoint LKG и
  entry-guard SQLCipher stores только после явного запроса сетевого consumer.
  Они используют разные ненулевые generation-scoped SecureStorage keys,
  переживают cold restart, закрываются вместе с owner и полностью удаляются
  вместе с key slots при account reset. Registry/bootstrap/transport не
  создаются при локальном startup/account creation; объединённый offline
  XPoint+Contact gate независимо прошёл `7/7`.
- ROUTE-01 для ContactResolve локально выбирает exact-three path из immutable
  verified candidate snapshot: exit берётся только из NETCODEC placement,
  entry guard сохраняется между запросами/перезапусками и меняется при revoke
  или новой view; node/owner/host/failure-domain/origin/key не совпадают.
  Entry/Relay/Mailbox capacity берётся из своего XND1 role field, поэтому
  корректные single-role узлы не исключаются. Канонический XGS1 state,
  SQLCipher-4 integrity и sealed DDL отвергают tamper/wrong key/schema;
  persistent fork latch нельзя очистить следующим CAS. Общий shared XPoint
  Release gate (LKG + guards + Contact path) прошёл `46/46`.
  Публикация/fetch authority-пакетов и расширение provider на остальные классы
  операций остаются интеграционной работой.
- Contact resolver coordinator больше не принимает caller-authored placement:
  context создаётся только из `VerifiedContactServicePlacement`, связан с
  `ResolveInvite`, exact locator/network/account/pending address, а XIQ expiry
  ограничен request/invite/placement. Ошибка или expiry отсекаются до journal и
  network; ContactV1 focused gate прошёл `80/80`.
- Production trusted-verifier клиента теперь получает bundle/route/placement
  только из capability source, проверяет current placement и exact XIS1, а для
  DIA1 требует cryptographically verified two-replica claim receipt; permanent
  DID1, напротив, отклоняет consuming receipt. Caller keys/trust flags и старый
  bundle+route-only `Accept` отсутствуют; новый hostile slice прошёл `8/8`, весь
  shared ContactV1 gate — `88/88`.
- Protocol теперь публично mint-ит `VerifiedContactNetworkAuthority` только из
  одной current closure: verified XPoint authority/network/directory freshness,
  recipient DPD1/current DCA1 и exact XNV1/XNH1/ADH1/PMT2/PMS2. Подмена
  network/ref/time/threshold/recipient или incomplete placement отклоняется;
  capability не имеет public constructor и не принимает caller key/boolean
  trust. Focused Release gate проходит `11/11`, build — без warnings/errors.
- Triple Ratchet получил канонический локальный `TRS1` state codec с лимитом
  2 MiB: directional bindings/counters, PQ frontier/commitments/provider state,
  skipped EC/PQ keys и terminal latch переживают restart. Hostile lengths,
  ordering, checksum/semantic tampering и unknown version/flags отклоняются,
  ошибочные временные секреты очищаются. Production component provider владеет
  X25519, EC/SPQR chains, skipped keys и incremental PQ Braid injection;
  restart во время Encaps1 сохраняет полный provider state, а capability
  создаётся только из verified hybrid-handshake seed. На этом промежуточном
  checkpoint MessagingCrypto gate прошёл `115`, ещё `11` platform-native
  тестов корректно skipped на ARM64 host; последующий durable DPE2 adapter
  описан ниже в той же записи. Полная runtime composition пока не активирована.
- Incremental ML-KEM Braid Windows x64 candidate повторно собран из pinned
  `libcrux-ml-kem 0.0.10` Rust toolchain: native unit `7/7`, export/hardening
  allowlist и отдельный C ABI probe прошли. Полученный DLL имеет размер 526336
  байт и SHA-256 `41ba8b15429bfc55b6a66cdadbb1ad3372dfc98a9f2bd1bce75a86d54426cd25`,
  совпадающий с candidate manifest. Self-contained win-x64 managed wrapper на
  ARM64-хосте через Windows emulation прошёл все `3/3`: digest/approval
  fail-closed, interop с standard ML-KEM в обе стороны и single-consumer
  contention. Таблица незавершённых `Encaps1` ограничена 1024 состояниями и
  fail-closed отклоняет дальнейшее накопление, поэтому брошенные handles не
  образуют неограниченное удержание secret state. Production approval намеренно
  не выставлен до release review и закрытия Android/Windows asset matrix.
- XNode получил durable restart-safe ONION replay/entropy stores и encrypted
  file key-agreement vault с bounds, atomic replacement, AES-GCM и zeroization;
  focused `15/15`, полный unit `191/191`. Host clean-break переведён с внутренних
  `PrivacyRoutingOperation/Hop` на публичные verified capabilities; XNode
  Release build — 0 warnings/errors, integration `201/201`. Protocol-owned
  receive boundary теперь выбирает локальный key capability по exact frame,
  выдаёт только network-verified next-hop transport capability и привязывает
  replay scope к boot ID; focused PrivacyRouting gate прошёл `50/50`.
  XNode runtime вызывает эту boundary и пересылает только sealed next-hop без
  DNS/manual peer lookup. Активация намеренно остаётся выключенной до producer
  свежей подписанной network closure, peer-ingress admission и полного DI.
- Shared runtime storage E2E переведён со старого DPE1/MAU2 wrapper на отдельные
  per-client MSG01 authoritative endpoints: direct messages, reply/reaction,
  attachment/voice metadata и small-group flow прошли `5/5`; raw direct/group
  dispatch в harness запрещён.
- Для one-time Contact Resolver redemption заморожен и реализован точный
  160-байтный replica-receipt transcript, связанный с request/locator,
  publication generation/expiry/ciphertext, exact route closure, commit
  generation и server time. Обе Ed25519-квитанции проверяются focused XNode
  тестом; Contact facade gate прошёл `4/4`.
- Клиентская protocol boundary для той же XIS1 claim теперь выпускает sealed
  capability только после проверки exact ResolveInvite placement, XND1 identity
  keys, двух разных failure domains, обеих подписей над 160-байтным transcript,
  object/route hashes и live trusted-time lease. Hostile gate прошёл `10/10`,
  объединённый XPoint/claim gate — `96/96`; permanent DID не может выдать
  one-time claim capability.
- XNode Contact receipts больше не требуют приватных ключей обеих реплик в
  одном процессе: per-replica typed authority подписывает только свой exact
  statement, ID жёстко связан с resolver/pre-key replica, а канонический
  193-байтный контейнер появляется лишь после двух валидных подписей. Hostile
  focused gate прошёл `10/10`, полный XNode unit — `197/197`; production host
  остаётся выключен до remote replica transport и XPA consume saga.
- `XPA1` получил production non-forgeable publication capability: exact XPU1,
  XNA/ADH/DTT authority, PublishInvite placement, monotonic boot/time window,
  sorted current witnesses и независимые failure domains проверяются до любой
  reservation/mutation. Hostile gate прошёл `10/10`, весь ContactV1 — `59/59`.
  XNode consumer сохраняет AES-GCM-защищённую однонаправленную saga
  `authorizationId -> Reserved -> Committed`, permanent conflict latch и
  выпускает receipt только после durable quorum `2/2`; restart/crash/replay/
  concurrency gate прошёл `15/15`.
- `CONTACT-SERVICE-01` получил authenticated HTTPS/HTTP2 transport между двумя
  NETCODEC-selected replicas и fail-closed host/DI boundary. Ed25519 transcript
  связывает sender/recipient, route, timestamp, nonce, correlation и exact body
  hash; receiver заново получает current placement до мутации, а receipt
  выпускается только после exact durable reread (для publication также после
  committed XPA saga). Закрыты wrong peer/network/placement/signer, replay,
  timeout, lost response и dormant endpoint; повторены `17/17` core и `24/24`
  integration tests. Дополнительно replay admission сделан строго bounded при
  concurrency (`12/12` transport tests). Runtime/endpoint остаются выключены
  до production XNV/PMT placement, route-closure и XPA authority sources.
- XNode ClaimPreKey bridge формирует canonical XPC1 из exact XPK1 и durable
  inventory: suite `0x0201`, DPK2 generation/counter/time, domain-separated
  DPK2 hash и две replica signatures детерминированы, поэтому replay после
  restart байт-в-байт совпадает. Malformed DPK2, selector/replica identity
  substitution закрываются без выдачи pre-key. Focused gates:
  ContactPreKey `23/23`, facade `15/15`, replica transport `13/13`; Release
  build — без warnings/errors. Endpoint остаётся dormant до Protocol-owned
  двухрепличной publication capability для exact XPS1/DPK2 inventory.
- DNP1 subprocess gate больше не зависит от несовместимого `PSModulePath`
  PowerShell 7/Windows PowerShell 5.1: file digests вычисляются streaming .NET
  SHA-256/SHA-512 с прежними exact hashes. Полный XNode ProfileGenerator gate
  восстановлен с `102/107` до `107/107` без ослабления closure-проверок.

- Account Directory authority реализует canonical ADC1/ADH1/ADP1/ADF1/AFP1,
  threshold/freshness/consistency и fail-closed rollback/fork/revocation
  semantics. Production LKG теперь безопасно восстанавливается после restart:
  сохранённый ADH1 повторно проходит canonical/network/authority/witness-policy
  проверку и остаётся rollback floor даже после operational expiry. Protocol
  Release-набор прошёл `88/88`, shared restart/state-store набор — `21/21`.
- `CONTACT-CODEC-01` замораживает DCB1/DCR1 closure, exact DRS1/DPD1 support,
  XIR1/XPS1 pre-key references, ADL1 freshness floor и полный XPU1/XPO1/XIQ1/
  XIS1/XPK1/XPC1/XUW1/XUQ1/XUS1 service wire. Вложенный ADL1 декодируется
  канонически и связан с network/minimum ADH tuple; размеры DCR/XIS, canonical
  claim/event hashes, event chain и retry semantics проверяются fail-closed.
- Frozen Contact manifest и anchor синхронизированы; Contact Release-набор
  прошёл `49/49`, отдельный specification checker — успешно. Локальный client import
  принимает только canonical бессрочный DID1 или отдельный expiring DIA1 и
  сохраняет pending state в account-scoped SQLCipher SQLite без `SessionId`;
  restart/concurrency/wrong-key/corruption gate прошёл `25/25`. Network
  resolution и runtime activation пока не заявляются.
- `CONTACT-CLIENT-01C` добавляет durable transport-neutral relationship state
  machine поверх того же SQLCipher store: нормативные CAS/revision transitions,
  атомарный operation journal, exact/conflicting replay, restart/concurrency,
  account-scope и corruption rejection. Verified identity/artifact evidence
  нельзя создать до trusted verifier boundary. Focused ContactV1 Release gate
  прошёл `39/39`. Итоговая MAUI composition создаёт/восстанавливает постоянный
  Deep ID и сохраняет canonical DID1/DIA1 pending contact полностью offline;
  restart/reset/secure-slot gate прошёл `5/5`. Network resolver и message
  activation остаются незавершёнными.
- `GROUP-CODEC-01` реализует 12 canonical group/control records,
  owner-sequenced transition verification, account-directory closure,
  durable successor/fork latch и DMC2 kinds 15–17/26–29. Сфокусированный
  Release-набор прошёл `17/17`, checker исполнил `14` hostile cases. Verified
  transition теперь выдаёт immutable exact GCP1 SHA-256 capability. Client
  package хранит account/generation-scoped SQLCipher head, proposals, invites,
  per-recipient cursors, CAS/replay и persistent fork latch; focused gate
  прошёл `8/8`, включая exact-byte binding до транзакции и после restart.
  `GROUP-CLIENT-01` теперь атомарно фиксирует один canonical DGM1 как один
  MSG-01 logical outbox и полный stable per-device fanout под database-wide
  read lease текущего DGC1: исключает author device, сохраняет directory/DPD1
  bindings и стабильные operation IDs, fail-closed обрабатывает stale/fork/
  replay и держит границы `100 members / 500 devices` (`499` remote targets).
  Независимо повторённый Release gate `GroupV1|Msg01` прошёл `71/71`.
  Product dispatch остаётся выключенным до per-device DPE2/ratchet composition
  и повторной проверки current group head непосредственно перед первым send.
- MSG-01 durable boundary реализует logical envelope/fanout, per-target
  attempts, reconcile/ACK intents, idempotency и crash-safe transaction store;
  legacy transport outbox не может работать параллельно в release composition.
  Shared Release-набор прошёл `48/48`, hostile friend/reflection boundary и
  MAUI composer `2/2` — успешно. До подключения production DPE2/Triple Ratchet
  transport намеренно возвращает `MessagingV1CryptoUnavailableException`.
- Exact DPE2 receive и send transaction pipelines реализуют DTR2 binding,
  header hash/nonce/AAD, combined key, AEAD-before-commit, replay fence,
  message-key deletion и crash-atomic state release. Дополнительно реализован
  managed профиль ML-KEM Braid для уже определённых частей transcript:
  HKDF-SHA-512, SHA3-256 public-key hash, HMAC, exact DTR2 header/Ct2 auth,
  transactional auth update, epoch/replay и защищённый export/import состояния.
  Этот ранний slice был доведён до полного managed component provider и
  MessagingCrypto gate `115 passed`/`11` platform-native skipped.
  Client persistence authority теперь хранит exact TRS1 в отдельном
  account/device/conversation/session-scoped SQLCipher v4 store и атомарно
  фиксирует state, replay/deletion/PQ evidence и hash-chained journal; закрыты
  cross-process CAS, exact replay, durable fork/rollback latches, wrong-key/
  scope/corruption rejection, zeroization и restart во всех пяти commit
  failpoints. Независимо повторены focused tests `11/11` и Release build
  `0 warnings / 0 errors`. Остались Protocol-owned sealed producer/durable
  receipt capability, runtime composition и безопасный rollover/compaction до
  bounded journal capacity. Application-specific Double/SPQR/Triple Ratchet
  KDF domains заморожены в crypto specification.
- Отдельный permissive `libcrux-ml-kem 0.0.10` spike подтвердил недостающий
  incremental ML-KEM-768 ABI без Signal/SPQR/AGPL-кода: deterministic/CSPRNG
  keygen, single-use `Encaps1` state, `Encaps2`, standard `ct1||ct2` decapsulation,
  overlap/replay/concurrency rejection и zeroization. Rust/native Release gate
  прошёл `6/6`, independent C consumer и whole-ML-KEM differential interop —
  успешно. Production graph пока не активирован; Android/Windows ARM64 assets,
  packaging allowlist и независимый security review остаются WP0 gate.
- Публичная документация больше не зависит от HonKit/Immutable.js 3.x:
  repository-owned `marked 18.0.11` renderer генерирует 20 статических страниц
  без client JavaScript, экранирует raw HTML и добавляет CSP. Полный npm graph
  сокращён с `238` до `2` packages и проходит audit с `0 vulnerabilities`.
  Новый единый docs gate проверяет UTF-8, SUMMARY/local links, private-path/key
  markers, pinned lockfile и render (`237 checks`); path-filtered GitHub job
  дополнительно запускает нормативные registry/schema/vector checkers.
- XNode получил внутренний opaque contact-resolver store с CAS/replay/fork
  latch, corruption quarantine, quota и XUR retention `400 дней + минимум
  1024 поколения`, а также two-replica application coordinator с
  outcome-unknown reconciliation. Opaque group-control service добавляет
  per-recipient streams, bounded catch-up/retention/compaction и durable fork
  latch. Совместный Contact Resolver + Group Control Release gate прошёл
  `21/21`. Отдельный opaque pre-key service реализует exact-one-time DPK2
  claim, deterministic selection, exact replay, bounded last-resort reuse,
  inventory rotation/overlap, two-replica reconciliation, fork latch и
  crash-safe retention/GC; его focused Release gate прошёл `14/14`.
  Wire/runtime activation и подписанные service receipts в эти результаты не
  входят.
- ONION-01 codec теперь отклоняет cross-network splice каждого вложенного XRF1
  до replay-state mutation; focused Release gate прошёл `23/23`. Production
  public Build/Open/Seal остаются намеренно fail-closed до закрытия verified
  path/time, durable replay lease, reply context, exact hop-count и payload
  verifier boundaries.
- PowerShell-совместимость локального DEV authority lifecycle подтверждена в
  Windows PowerShell 5.1 и PowerShell 7.6: устранены конфликт с автоматической
  `$Matches` при membership rotation и instance-only ACL API. Repeat fixture,
  private-secret ACL и compose contracts проходят; старый expired dev authority
  сохранён как clean-break backup. Новый v2 authority publication ожидает
  единый protocol package cutover и поэтому не заявлен готовым.
- Изолированная Android Debug `.e2e` APK собрана из текущего дерева, отдельно
  подписана ожидаемым upload-сертификатом и обновлена поверх только
  `network.xpoint.deep.e2e`; production package/data не изменялись. На Galaxy
  S10e/API 31 с выключенными Wi-Fi и mobile data чистый клиент сгенерировал
  ровно 24 слова, подтвердил и сохранил новый account, а cold restart без сети
  повторно открыл сохранённый account. Состояние сети восстановлено. Это
  закрывает Android physical create/restart slice, но не physical restore и не
  Android↔Windows messaging gate.
- Устранён найденный при этой сборке release-signing defect: однострочный
  PKCS#12 password source передавался одновременно как store/key password и
  второй consumer получал EOF. Play, ACT1 preparation и standalone UAT scripts
  теперь используют единственный PKCS#12 store-password source; security smoke
  gate прошёл `17/17`. Android Activity дополнительно очищает native input focus
  до `base.OnPause()`, закрывая наблюдавшийся disposed-MAUI-context crash; узкий
  lifecycle contract прошёл, повторная физическая сборка входит в следующий
  общий APK checkpoint.
- Добавлен local-only воспроизводимый NuGet cutover текущего Deep.Protocol для
  XNode без ослабления production `0.5.0-production.e75bfed` pins: package-graph
  gate прошёл `169/169`, повторный pack дал идентичные hashes. XNode также
  получил exact bounded HTTP validation boundary для XPU/XIQ/XPK/XUW/XUQ и
  matching result codecs (`5/5`). Реальный opaque dispatcher, ONION runtime
  activation и новый v2 authority всё ещё не заявлены готовыми.
- UAT secret mounts сужены до отдельных read-only файлов и минимального
  публичного CRL-каталога; приватный CA key и полный каталог секретов в runtime
  не монтируются. `survival-uat-tls-contracts` и
  `production-mailbox-uat-contracts` проходят локально.
- Protocol-owned exact DPE2 durable producer реализован: immutable prior/next
  TRS1 plan, CAS/journal/deletion/dedup/PQ commitments и attempt-bound receipt
  разрешают send/receive capability только после durable commit. Focused
  MessagingCrypto gate: `124 passed / 11 platform skips`, Release build без
  warnings/errors. Shared adapter теперь отображает все поля sealed plan в
  основной hash-chained journal и дополнительный exact-DPE2 journal одной
  SQLCipher-транзакцией; restart/lost callback, receive replay, CAS race,
  fork, cancellation, capacity и zeroization проходят focused gate `18/18`.
  Store-owned single-use preparation lease атомарно читает TRS1, CAS/protected
  commitment, journal head, exact receive replay и детерминированный retention
  commitment; caller не может подменить эти факты. Его focused Release gate
  проходит `22/22`, concurrency slice — `5/5`. Initial-session foundation
  теперь одной SQLCipher schema-v3 транзакцией сохраняет exact TRS1/replay
  journal, удаляет X25519 и ML-KEM one-time prekeys и связывает claim operation,
  full XPC1/full DPH2 replay hashes; lost callback exact-replay, cross-session
  prekey reuse/fork, crash и restart проходят focused gate `35/35`.
  Verified handshake producer/runtime composition, account/device-wide prekey
  owner и безопасный rollover ещё не входят в этот результат.
- Verified DPK2/DPH2 теперь mint-ят только внутреннюю одноразовую directional
  transcript capability: session/transcript/device direction/generation,
  responder directory head, ML-KEM ciphertext/prekey IDs и full-DPH2 replay hash
  связаны до derivation; подмена и повторное consumption отклоняются. Focused
  handshake/surface gate проходит `30/30`, Release build — без warnings/errors.
  Public XPK1/XPC1 verifier дополнительно проверяет exact request/result,
  ClaimPreKey placement, DCB1/XPS1/DPD1/DMD1/DRS1, trusted-time interval,
  DPK2 signatures и две replica identity signatures с разными failure domains.
  Его sealed receipt одноразово переходит во внутреннюю pre-key capability,
  связанную с full XPC1/DPH2 replay; соответствующий readiness blocker снят.
  Объединённый focused gate проходит `21/21`, Release build — без
  warnings/errors; raw-key/provider shortcut отсутствует.
- Identity-owned X25519 agreement authority хранит private scalar внутри
  non-exportable owner и выдаёт внутренний одноразовый lease, связанный с exact
  issued DPD1/verified active DMD1, network/account/device generations,
  purpose/operation и peer key. Replay, substitution, wrong owner и low-order
  result отклоняются; exception/Dispose paths очищают scalar, bindings и shared
  secret. Authority поддерживает verifier-issued genesis, enrolled и successor
  devices; revoked, superseded, omitted, wrong-generation и fork-latched
  состояния отклоняются. Focused gate проходит `35/35`, Release build — без
  warnings/errors. Store-side protected current-DMD1 LKG теперь хранит exact
  canonical head/active DPD1 closure в SQLCipher schema v3, выполняет CAS,
  restart-safe fork latch, durable operation burn и одноразовый handoff;
  stale/revoked/superseded/wrong-generation и concurrent replay paths проходят
  общий DeviceV1 gate `35/35`. Осталась assembly-композиция handoff с настоящим
  Protocol agreement lease: публичный подделываемый provider или production
  friend assembly не считаются решением.
- `GROUP-CLIENT-01` first-dispatch safety повторно проверяет exact DGM1,
  current DGC1/GCP1 и member/device/DPD/directory binding только для первого
  уже durable active attempt после `StartSending`; actual-send callback
  выполняется под DB-wide lease. Stale/fork/removed, completed и
  outcome-unknown цели не dispatch-ятся, ciphertext/request/ratchet hashes
  сверяются до callback. Boundary встроен в `Msg01AuthoritativeTransport`, а
  dispatch сериализован с recovery. Локальный block теперь является
  store-bound non-forgeable mutation: он атомарно очищает active/unresolved
  attempt и ciphertext, сохраняет `RevokedTarget`/terminal semantics и после
  crash/restart не допускает dispatch или reconcile. Общий focused gate
  `MessagingV1|GroupV1` проходит `98/98`, Release build — без warnings/errors.
  Production composition теперь лениво открывает отдельный account-scoped
  SQLCipher GroupV1 store только после локального Deep account, связывает его
  с exact account generation/message-store instance и передаёт safety authority
  в `Msg01AuthoritativeTransport`; wrong key/scope, missing protected key,
  reset/restart и no-account paths fail closed. Focused gates: Shared identity/
  first-dispatch `13/13`, MAUI runtime `6/6`, composer `8/8`; `MauiProgram`
  переключён на account-bound async composer. Незавершённым остаётся только
  per-device DPE2/ratchet evidence source вместо legacy transport payload.
- Реализован bounded сегментированный directory publication catalog: immutable
  generation segments, hash-bound manifest/head, fixed pending journal,
  crash recovery, persistent fork latch/quarantine и межпроцессный file lease.
  Абсолютный лимит одного артефакта — 65 535 bytes, retention — 2 048–4 096
  поколений; два экземпляра видят новую публикацию без restart. Focused gate
  проходит `21/21`, включая 2 049 последовательных commit. Production verifier
  также проверяет exact XNA1/DTS1, nonce-bound ADH1/DTT1/ADP1,
  XVP1/XNV1/XNH1/XND1/PMT2 и optional XNF1/NFP1 только против независимого
  protected LKG; NFP1 использует canonical domain-separated core hash.
  Local-cutover verifier проходит `21/21`, default production fail-closed —
  `1/1`, Release API build — без warnings/errors. Production DI и mirror HTTP
  теперь отдают byte-identical manifest/generation/XNH1 head с strong ETag;
  bounded publication envelope проходит verifier до commit, mTLS publisher,
  durable one-time challenge ledger и protected LKG имеют restart/replay/tamper
  protection. Focused HTTP/catalog/verifier gate проходит `30/30`; write surface
  configuration-disabled без актуального Protocol package/custody. Осталась
  checkpoint-authorized compaction до достижения hard cap.
- Incremental `libcrux-ml-kem` Braid spike на Windows x64 прошёл `7/7`
  adversarial/interop tests и отдельный C ABI probe, включая single-consumer,
  exact capacity и byte-identical interoperability. Android arm64 physical C
  ABI probe на Galaxy A5/API 26 также прошёл два CSPRNG round-trip,
  unload/reload, replay/double-dispose rejection и no-secret-output; `.so`
  содержит ровно 17 экспортов и только `libc/libdl` dependencies. До production
  activation остаются Windows arm64 и независимый binary/provenance review.
  Build script теперь также имеет fail-closed `windows-arm64` target и проверяет
  pinned Rust target/VS ARM64 toolchain до сборки; локальный gate ожидаемо
  остановлен из-за отсутствующего Visual Studio C++ ARM64 component и поэтому
  не считается закрытым Windows ARM64 evidence.
- Закрыта межэкземплярная SQLite pool race: admission lease регистрируется до
  schema initialization, откатывается при failed constructor, а последний
  `ClearPool` ждёт завершения instance operations. Детерминированный lifecycle
  gate проходит `4/4`, расширенный MembershipTrust/Persistence/Schema gate —
  `106/106`; pooling сохранён.

## 2026-08-31 — локальные clean-break foundations и восстановление DEV/UAT

Статус: перечисленные package-level результаты завершены локально; общий
release, physical client composition, push и production deployment не
заявляются.

- Production ML-KEM candidate переведён на vendored `mlkem-native` v2.0.0 с
  narrow Deep C ABI, воспроизводимым allowlist/manifest generator, closed
  production facade и синхронизированным dispose/finalizer barrier.
  Независимое повторное ревью не нашло P0/P1/P2; локальные native C, ABI и
  production-wrapper probes прошли. Физический Samsung S10e (`arm64`, Android
  API 31, .NET 10.0.9) дополнительно подтвердил exact asset SHA-256/ABI,
  encapsulate/decapsulate, dispose/reload и production-wrapper load/reload;
  все sanitized probe checks успешны. Windows ARM64, ACVP, release-approved
  reproducible Android asset, signed non-writable install и финальный binary
  security review остаются release activation gates.
- `NETCODEC-01` реализует canonical runtime всех девяти frozen XPoint records
  `XNA1/XVP1/XND1/XNV1/XNH1/XNP1/XNF1/NFP1/XCD1`. После corrective review
  genesis rollback отвергается до callbacks, machine parity проверяет все
  security-significant projections, а frozen JSON primitive/negative vectors
  исполняются побайтно и защищены manifest hash. Финальное независимое ревью:
  `66/66`, P0/P1/P2 отсутствуют; `runtimeActivation=false` сохранён до
  integration evidence.
- `ATTACHMENT-CODEC-01` реализует exact `DAM1` и typed DMC2 kinds 18/19:
  canonical metadata, chunk arithmetic, minimal capacity buckets, manifest
  identity и cross-network binding. Независимое ревью: `30/30`, P0/P1/P2
  отсутствуют. Blob upload/download намеренно не активирован до `BLOB-01`.
- Local Survival DEV/UAT выполнен destructive clean-break без пользовательских
  данных: старый expired mailbox authority сохранён в защищённой `.secrets`
  backup, state volumes пересозданы, новый authority выпущен. Шесть XNode,
  Registry, storage, file и push длительно отвечают healthy/`200`.
- Pinned XNode build-context export теперь материализует exact Git blob bytes,
  поэтому CRLF checkout не меняет reviewed manifest. Compose tests прошли
  `16/16`; context-export suite ранее прошёл `21/21`.
- Устранён Docker Desktop LAN defect Registry: один ASP.NET-процесс слушает
  container ports `8080/8081`, сохраняя host API `41810` и call API `41823`.
  Это не добавляет HAProxy в обычный DEV/UAT path.
- MAUI startup больше не создаёт Registry/HTTP runtime до фактического
  provisioning и не объясняет локальный account-store failure отсутствием
  сети. Offline account/onboarding остаётся независимым от Registry; повторный
  test gate запускается после завершения общей MSG/DEVICE переработки.

## 2026-08-30 — CRYPTO-01 managed ML-KEM feasibility

Статус: завершена физическая оценка Bouncy Castle; production dependency graph
не изменён.

- Создан изолированный Android arm64 Release/AOT probe с package ID
  `org.deep.protocol.pqcprobe` и exact pin
  `BouncyCastle.Cryptography` 2.7.0.
- На Galaxy S10/API 31 получены median keygen/encap/decap
  `0.213/0.238/0.280 ms`; на дополнительном Galaxy A5/API 26 —
  `1.438/1.668/2.093 ms`.
- Round-trip, exact-length, public modulus и embedded-public corruption gates
  прошли. Same-length private coefficient mutation принимается.
- Production verdict — NO-GO: upstream PQ status остаётся experimental, а
  retained seed/expanded private key не имеют deterministic disposal/
  zeroization. Provider сохранён только как KAT/interoperability oracle.
- Проверен альтернативный RustCrypto `ml-kem` 0.3.2 skeleton: narrow C ABI
  собрался, 8/8 wrapper tests и Clippy прошли, две чистые Windows x64 release
  сборки дали идентичный SHA-256. Независимый source review обнаружил
  неочищаемые provider-internal secret intermediates; unmodified crate также
  получил production NO-GO. Инвазивный fork RustCrypto/module-lattice отклонён;
  production candidate переключён на `mlkem-native` v2.0.0 с доказательной
  zeroization/constant-time базой и narrow C ABI.
- Sanitized evidence и воспроизводимый probe находятся в
  `deep-protocol/eng/Deep.PqcProviderProbe.Android`; приложение и UAT data не
  очищались и не изменялись.

## 2026-08-30 — итоговая clean-break/XPoint specification

Статус: завершена документация целевой архитектуры; runtime, physical evidence
и production deployment не выполнялись.

- Подтверждён destructive clean break: 24-word `DeepRecoveryV1`, DNP1
  account/device roles, device-scoped hybrid AKE/Triple Ratchet и отсутствие
  legacy migration/fallback.
- Специфицирован permanent transport-neutral DID1/DAB1, initial contact через XIR1, oblivious account transparency,
  atomic fresh pre-key claim и offline route delegation без циклического PRA lookup, multi-device,
  owner-sequenced groups до 100 участников/500 active devices и будущий MLS
  profile.
- Специфицирован transport-neutral application/outbox contract для XPoint,
  будущих P2P mesh и on-prem profiles.
- XPoint разделён на threshold-signed public roster, clean-break PMA2/PMT2/PMS2
  mailbox projection, three-hop routes, access bridges и pluggable carriers.
- Для initial three-node profile снято утверждение о disjoint fallback; оно
  возможно только при 6+ узлах и проверенном failure-domain diversity.
- Reality принят как первый carrier вместе с независимым HTTPS-like carrier,
  rotating bridge distribution и masked call-relay paths.
- Calls включены в v1: signaling идёт через E2EE message plane, media использует
  relay-only WebRTC; direct ICE и отдельный Registry signaling inbox исключены
  из release target.
- Разделены safe reconnect и message retention: trust возвращается после
  длительного offline, обычные server messages хранятся 30 дней; phrase-only
  recovery не обещает contacts/history без backup/device transfer.
- Добавлены единый protocol registry/collision policy и DAG из agent-sized
  implementation packages; старые AGENTS/runbooks помечены как pre-cutover.
- Техническая документация централизована в `docs/architecture`: для каждого
  предмета назначен один normative owner, повторные call/SLO/recovery/task
  definitions заменены ссылками; public `xpoint-docs` оставлен user/operator слоем.
- Добавлены threat model, Session parity baseline, performance/censorship gates,
  deployment profile matrix и детальные implementation work packages.
- Заморожены закрытые wire/state contracts для current-value account directory,
  arbitrary-contact publication/resolve/pre-key/update операций, contact outbox,
  consent-based group membership, chunked group commit и revocation saga.
- CallOffer/Answer/Reconnect/End теперь доставляют call secret и answer capability
  только внутри ratcheted E2EE, используют pseudonymous answer CAS и свежий
  non-exportable DTLS certificate на каждую leg/reconnect.
- Добавлены [`architecture/release-scope.v1.json`](architecture/release-scope.v1.json)
  и schema: stable scenario/evidence IDs, единственный producer owner,
  воспроизводимые percentile profiles, absolute first-RC Android idle budget и
  boundary evidence для каждой canonical retention class. Новый дублирующий
  docs-test/CI harness для этого не создавался.
- Bridge acquisition унифицирован на трёх обязательных channel:
  RFC 9458 OHTTP Relay/Gateway, multi-origin HTTPS и signed user import;
  embedded cache остаётся только bootstrap hint.
- Устранены hash-cycle `XNV1↔PMT2` и `XNV1↔XNH1`; network/account
  beyond-horizon recovery закрыт exact `XNF1/NFP1` и `ADF1/AFP1` с отдельным
  offline-root package.
- Fresh install больше не использует validity windows как источник времени:
  текущие ADH1/XNV1 и secure interval подтверждает nonce-bound threshold-signed
  `DTT1` с bounded monotonic round trip.
- Call wire закрыт `CMD1` media suite, exact CAC/CAO/CAR/CAA и разделёнными
  `CALL-CODEC-01`/`CALL-RELAY-01`; server runtime принадлежит `xnode`, deployment
  и operational evidence — `deep-devops`.
- Для long-offline групп добавлен per-recipient opaque group-control store
  (`GSR1/GSW1/GSQ1/GSS1`), не раскрывающий XNode общий group/member list.
- Финальные implementability/security/evidence-аудиты закрыли exact XNA1
  witness/root-key policy, indexed NFP1/AFP1 membership proofs, nonce-bound
  trusted-time ceremony, peer-verifiable call allocation, closed XOQ1/XOR1
  OHTTP purpose envelopes, отдельный `CARRIER-GATEWAY-01` transport runtime и
  единственный `BRIDGE-DISTRIBUTOR-01` owner для token-mint/replay transaction.
- Все threshold-signature envelopes нормализованы через стабильные unsigned
  core references; устранён цикл публикации `XCC1/XBB1`, а `DTS1` и `XNH1`
  получили однозначные predecessor/generation/fork-latch правила.

Все незавершённые реализации и проверки перенесены в
[`NEXT-SPRINT.md`](NEXT-SPRINT.md); выполненные старые DPE1/contact/group paths
сохраняются ниже только как историческое evidence и не являются release target.

## 2026-08-30 — аудит release transport целей

Статус: завершён документарный и code-path аудит без production deployment и без новых physical claims.

Последующее product-scope решение: первый production-релиз включает только
маскированный XPoint transport. Direct P2P больше не является gate этого
релиза и, как и on-prem, остаётся более поздним архитектурным требованием.
Целевой P2P должен поддерживать direct links и multi-hop mesh без обязательного
official mailbox/control plane. Отсутствие P2P реализации ниже сохранено как
результат аудита, а не как release blocker текущего спринта.

### Подтверждено

- Exact MAU2, durable outbox/inbox, authenticated receipts и трёхузловая бинарная
  privacy-маршрутизация были реализованы и покрыты автоматическими тестами.
  Сделанное тогда утверждение о полностью непересекающемся fallback позднее
  отозвано: три узла не позволяют доказать два disjoint трёх-hop маршрута.
- XNode реализует managed HTTP/2 ingress и серверный Xray/VLESS Reality ingress; production profile fail-closed запрещает mock Xray.
- Arbitrary-contact PeerDeposit, group fanout/state/message и отдельная ранняя physical-фаза `GroupText` реализованы в коде/тестовом harness.
- Account/recovery phrase создаются локально без сетевого вызова; startup больше не обязан синхронизировать inbox до показа onboarding.
- Portable contracts различают `DirectP2p`, `UserManaged` и `OfficialManaged`; self-hosted SHR1 activation принят как dormant protocol capability.

### Не выдано за готовность

- Клиентский mailbox path пока создаёт прямой HTTPS transport к signed `entryOrigin`; локальный Reality/Xray runtime не включён в отправку message frame. Поэтому anti-blocking XPoint carrier ещё не реализован end-to-end.
- Direct P2P имеет policy/interface и platform scaffolding, но не имеет production peer transport, discovery/handshake/NAT path или release composition.
- Последний физический сценарий на телефоне не подтвердил arbitrary-contact delivery, а новый APK с mailbox fixes не устанавливался. Предыдущие частичные прогоны не считаются актуальным release evidence.
- Group `GroupText` harness отделён от file picker, но успешного Android ↔ Windows physical roundtrip/cold-restart evidence ещё нет.
- Долгий offline/rotation, production clean-install control plane и два finding reactive refresh остаются release blockers.

## 2026-08-28 — authenticated contacts and groups

Статус: код и локальные автоматические тесты реализованы. Актуальный physical e2e для произвольных контактов, direct text и групп не закрыт; push и production deployment не выполнялись.

### Реализовано

- Произвольные контакты переведены на authenticated mailbox invitations и peer-deposit routes: `fa3a130`, `a27fa8c`, `0082721`, `8bac84d`, `7e1cea6`.
- Добавление контакта сначала завершает cryptographic onboarding и только затем изменяет локальную книгу контактов; peer selector сохраняется и восстанавливается после restart/offline.
- Группы используют проверенные `GroupState`/`GroupMessage` selectors; участники проходят onboarding до изменения group state: `83e8eca`, `7e1cea6`.
- Исправлена first-use/lifecycle композиция production coordinator, account release/rebind и production privacy route bootstrap.
- Добавлен Mr. X-signed DEV/UAT pair rebind на том же epoch только для `android-windows-pair/UserManaged`; production anti-rollback не ослаблен: `ade6a37`.
- Mailbox persisted-scope conflict в physical Debug преобразуется в типизированный app-owned clean-break reset: `eeb5b29`.
- Android lab policy проверяет точную версию runner: `ded889e`.

### Локальные проверки

- Shared после mailbox-liveness изменений: `1040/1040`.
- MAUI ViewModels после reactive-refresh patch: `622/622`.
- MAUI UI: `83 passed` и три opt-in physical skip; `GroupText` contract: `32/32`.
- Последний полный Smoke: `179/180`; остаётся один PowerShell 7 harness failure.
- Release DI composition: `69` app-owned descriptors.
- Android и Windows physical Debug builds: `0 warnings / 0 errors`; E2E APK установлен без изменения production package.
- Подписанная physical фаза `Attach` прошла без skipped tests после смены Android holder и перевыпуска credential pair.
- Предыдущие physical прогоны дали частичное evidence до Windows file-picker barrier, но последующая ошибка доставки на телефоне и отсутствие установки нового APK не позволяют считать contacts/direct text закрытым release gate.

### Найдено и перенесено дальше

- Windows UIA foreground limitation перед owned file picker; диагностические foreground-эксперименты откатаны и не оставлены в runtime/test policy.
- Android startup после forced cold-stop может встретить живой durable retrieve lease и показать generic retryable startup error; штатный Retry после `NotBefore` восстановил Conversations без reset.
- Один оставшийся PowerShell 7 smoke incompatibility, production offline/rotation/clean-install и Android ↔ Android на втором поддерживаемом устройстве.
- Client-to-entry Reality/VLESS не подключён к MAU2 message path; Direct P2P transport отсутствует.
- Reactive refresh commit `d488cd8` требует исправить independent trust-tuple transition и bounded lifecycle cancellation до установки на устройства.

## 2026-08-26 — release-candidate closure

Статус: завершён локально. Push, публикация и первый production deployment в этот спринт не входили. Отложенные production-bound проверки и замечания финального независимого review перенесены в [NEXT-SPRINT.md](NEXT-SPRINT.md).

### Цель

Получить воспроизводимый release candidate Deep для Android и Windows с production-grade транспортом, закрытым DNP1 package/runtime контуром, актуальными user/admin docs и локальным evidence bundle.

### Реализовано

- Завершён clean-break Deep-native privacy route: exact binary MAU2 проходит через три послойно зашифрованных XNode; primary и fallback не пересекаются; direct MAU2, Session RPC и прежний JSON-onion удалены.
- Survival authority публикует независимо привязанные owner/key/epoch X25519
  records и clean-break `privacy-routes.v2.json`; authority связана с activation
  и Mr. X policy, fallback разрешён только при доказанном отказе до пересылки.
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
