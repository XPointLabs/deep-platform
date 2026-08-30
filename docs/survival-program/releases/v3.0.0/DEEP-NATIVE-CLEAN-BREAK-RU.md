# Deep Native Protocol — программа clean break

Версия: `3.0.0`

Статус: **утверждённая целевая архитектура первого публичного релиза**

Владелец решения: **Mr. X**

Дата: 2026-08-11

Повторно подтверждено: 2026-08-30. Пользователей production нет; clean break
выполняется непосредственно, без миграции и временного выпуска DPE1.

## 1. Цель

Создать один Deep-native protocol/runtime и полностью удалить Session
compatibility из production architecture до публичного выпуска. Проект ещё не
находится в production, поэтому cutover выполняется через новый identity/wire/
database generation и явный reset без live migration, dual-read, dual-write
или runtime adapter.

`v2.0.0` сохраняется как immutable evidence выполненных Deep-native контрактов,
тестов и security review. Она не является активным источником требований для
новой Session-совместимой разработки.

## 2. Product invariants

1. Session interoperability не является product requirement.
2. Production graph не содержит Session protobuf, wire parser, RPC/storage/
   onion compatibility, fallback или downgrade path.
3. Deep-native membership, mailbox, topology, continuity/history, protected
   state, CAS/replay/fork и managed-ingress work переиспользуется.
4. Проверенные криптографические примитивы сохраняются; новая композиция не
   изобретается без design review.
5. Старые аккаунты, БД, ключи, ID и runtime state не мигрируются.
6. Legacy baseline может временно существовать только как offline reference
   corpus без production reference.
7. Нельзя заявлять PFS, post-compromise security, anonymity или censorship
   resistance без собственной принятой evidence-базы Deep.
8. Новый account generation использует 24-word Deep Recovery Phrase с 256
   битами CSPRNG entropy и checksum; phrase является backup encoding, а не
   универсальным private key для всех ролей.
9. Message confidentiality должна быть crypto-agile и hybrid post-quantum;
   чисто классический fallback после cutover запрещён.

## 3. Target architecture

```text
Deep Native Core v1
├── Identity / Devices / Contacts
├── Messaging / Ratchet / Groups
├── Mailbox / Storage / Attachments / Push
├── Membership / Authority / Topology
└── Continuity / History

Deep Transport
├── Managed HTTP/XPoint
├── reviewed privacy routing
├── Direct P2P mesh (future provider)
├── User-managed/on-prem MAU2 (future provider)
└── additional reviewed carriers

Legacy.Session
└── temporary offline reference vectors only
```

Transport не определяет account/message/group wire. Один и тот же логический
E2EE envelope может доставляться через XPoint, будущий P2P mesh или on-prem,
сохраняя общий operation ID, deduplication и durable outbox. Capability
negotiation не может ослабить crypto suite или privacy policy.

Новый wire использует собственные magic, version и signing domains. Старый
magic или state всегда fail closed; negotiation downgrade отсутствует.

## 4. Retain / remove / redesign

### Retain

- libsodium-backed Ed25519/X25519, AEAD, KDF и hash primitives;
- canonical framing, domain separation, bounds, padding/metadata principles;
- P04 membership, MAU2/authenticated mailbox V2, PMA/PMR/PMT/PMS/PSS;
- route continuity/history D/D2/E/F, Profile Carrier и managed ingress;
- Registry/XNode protected state, CAS, HMAC, replay/fork, capacity и atomic
  publication semantics;
- Shared/MAUI durable inbox/outbox and protected mailbox state;
- privacy-routing concepts только после Deep-specific threat model.

### Remove from production

- Session protobuf and generated/runtime dependencies;
- Session IDs/prefix semantics, Session padding, `Content`/`Envelope`, Pro,
  shared-config/group compatibility and Session onion codecs;
- Session RPC/storage/onion endpoints and clients;
- P03A/DPE compatibility bridge after its successor is accepted;
- compatibility storage runtime, fixtures, parity gates and docs;
- file/push compatibility only after native replacements exist.

### Redesign

- `DeepAccountId`, account/device/agreement/mailbox/router/storage/push keys;
- recovery, contact and device authorization;
- 1:1 and group messaging state;
- DPE1/DMC1 successor envelope;
- peer contact/origin discovery;
- file/avatar, push, call and attachment ownership;
- Shared/MAUI models and stores currently carrying Session-derived names.

## 5. Mandatory security gates

Before a public release the program must provide:

- reviewed asynchronous AKE/ratchet with forward secrecy and
  post-compromise recovery;
- multi-device enrollment/revoke/recovery and backup separation;
- group epochs, member/admin authorization and rekey;
- authenticated contact establishment and signed config sync;
- attachment and call-signaling binding;
- algorithm agility without implicit fallback;
- golden and negative vectors, fuzzing, state-machine, traffic-analysis,
  load/chaos and cross-platform E2E evidence;
- independent crypto/privacy and red-team reviews with P0=0/P1=0.

The current long-term-key sealed-CEK DPE1 path is input evidence only and may
not be renamed into the final construction.

### Recovery phrase v1

- Phrase кодирует ровно 256 бит, полученных из OS CSPRNG, как 24 английских
  слова BIP-39 с 8-bit checksum и обязательной NFKD normalization.
- Это `Deep Recovery Phrase`, а не заявление о совместимости с Bitcoin/
  кошельками. UI запрещает повторное использование wallet mnemonic и никогда
  не просит вводить phrase вне локального secure-recovery flow.
- Стандартный mnemonic-to-seed output не используется напрямую как account,
  device, agreement, mailbox, router или push private key. Он проходит
  versioned Deep-domain HKDF; каждая роль получает отдельный domain и generation.
- Account/device authorization связывает только public role certificates.
  Phrase и recovery root никогда не передаются Registry, XNode, push/file
  service, telemetry, logs или cloud backup в открытом виде.
- Phrase-alone recovery имеет один явный profile `DeepRecoveryV1`; будущий
  profile не перебирается автоматически. Дополнительный split backup может
  использовать отдельно рассмотренный SLIP-39, но не меняет основную phrase.
- Ошибки checksum, неизвестная normalization/wordlist и лишние слова
  отклоняются до derivation. Golden/negative vectors и destructive restore
  rehearsals обязательны на всех клиентах.

Reference: BIP-39 определяет 24 слова как 256-bit entropy + 8-bit checksum:
<https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki>.

### Hybrid post-quantum profile

- Первая целевая конструкция — reviewed hybrid asynchronous handshake:
  X25519 совместно с NIST ML-KEM. Конкретный parameter set (исходный кандидат
  `ML-KEM-768`) фиксируется только после benchmark и независимого review.
- Оба shared secrets входят в один domain-separated transcript/KDF. Ошибка,
  отсутствие или downgrade любой половины завершает handshake; classical-only
  и PQ-only fallback отсутствуют.
- Initial hybrid handshake недостаточен: ratchet обязан периодически вводить
  свежий PQ KEM secret и сохранять classical ratchet, пока формальная модель и
  реализация обеих частей не приняты. PQXDH + reviewed Triple/Sparse-PQ-ratchet
  рассматриваются как reference design, а не копируются без анализа.
- 256-bit symmetric AEAD/KDF keys остаются; post-quantum migration относится
  прежде всего к public-key key establishment и long-lived authentication.
- ML-DSA рассматривается для редких долгоживущих account/device/membership/
  software certificates. Его public key/signature overhead не добавляется в
  каждый message, Nearby или LoRa frame без отдельного wire/battery benchmark;
  низкополосные кадры могут ссылаться на уже проверенный certificate hash.
- Algorithm identifiers, parameter sets, certificate generations, revocation
  и min-version policy подписываются и защищаются от rollback.
- Реализация использует поддерживаемую reviewed library/provider; собственная
  реализация ML-KEM/ML-DSA запрещена. NIST errata и dependency provenance
  входят в release gates.
- До external review разрешён только dark path без production activation и
  security claims.

References: NIST FIPS 203/204 и Signal PQXDH/Double Ratchet:
<https://csrc.nist.gov/pubs/fips/203/final>,
<https://csrc.nist.gov/pubs/fips/204/final>,
<https://signal.org/docs/specifications/pqxdh/>,
<https://signal.org/docs/specifications/doubleratchet/>.

## 6. Execution waves

### Wave 0 — governance and inventory

- activate this release and machine-verifiable manifest;
- freeze compatibility feature work;
- inventory every cross-repository dependency as `retain`, `remove`,
  `redesign` or `reference-only`;
- add production forbidden-reference gates;
- record exact last-compatible source/package identities.

### Wave 1 — specification

- Deep identity/key hierarchy and destructive reset;
- message/group/device/contact/config protocols;
- storage/file/push/call ownership;
- MRL2 and native peer-contact vocabulary;
- exact wire, bounds, domains and no-downgrade rules.
- 24-word DeepRecoveryV1 vectors and role-separated derivation tree;
- hybrid X25519+ML-KEM handshake, PQ ratchet injection and long-lived
  authentication profile with exact size/performance budgets.

### Wave 2 — protocol and client dark path

- build new Protocol packages without Session dependencies;
- implement new identity/envelope/storage APIs behind unmistakable new magic;
- introduce a new client schema generation;
- preserve reusable mailbox/membership/outbox invariants.

### Wave 3 — node/service cutover

- replace Session peer origin/RPC/storage contracts atomically across XNode,
  Registry, clients and DevOps;
- land native file/push contracts before deleting their compatibility services;
- replace the current Registry call inbox with typed ratcheted E2EE call
  signaling over the selected message transport; Registry may distribute
  signed relay policy but does not own conversation semantics.

### Wave 4 — destructive cutover and deletion

- reset pre-production accounts, keys, databases and push registrations;
- remove all runtime legacy parsers, bridges, endpoints and packages;
- replace compatibility fixtures/evidence with Deep-native suites;
- delete the offline baseline after equivalent vectors are accepted.

### Wave 5 — security/release

- external crypto/privacy audit, traffic analysis and red team;
- long fuzz/chaos/canary and supply-chain review;
- release only with P0=0/P1=0 and accurate Deep-specific claims.

## 7. Ordering constraints

- Do not delete `/api/peer/onion` until native peer contact/origin semantics and
  every consumer are ready for one atomic cutover.
- Do not delete file/avatar or push compatibility before their native
  replacements pass functional and privacy gates.
- Do not mutate signed MRL1 capability meanings; define MRL2 with a new domain.
- Do not package/repin the old Session dependency graph merely to unblock new
  feature work.
- Do not resume Registry 4B2B until inventory/specification identifies its
  final identity and package dependencies.
- No environment may accept old and new account/wire/database generations at
  the same time.

## 8. Release gates

The program is not complete until:

- production dependency/runtime scans report zero Session legacy references;
- old state/magic/endpoints reject deterministically;
- new account/device/group/recovery paths pass destructive-reset rehearsals;
- storage, attachments, push and calls have native accepted contracts;
- privacy claims are backed by Deep-specific evidence;
- all repository full gates, real-database tests and cross-platform E2E pass;
- independent review reports P0=0/P1=0.

If the project cannot fund protocol development and independent review, the
only acceptable fallback is an explicit decision to finish Session parity.
Indefinite hybrid operation is prohibited.
