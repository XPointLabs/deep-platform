# Local development E2EE authority

Status: **deferred until after the current Windows/Android release; not a
production trust source or release dependency**.

## Purpose

`DEV-E2EE-01` exists so an isolated Android package and a local Windows client
can exercise the real Deep account, DPK2/DPH2/DPE2, Triple Ratchet, MSG-01,
attachment and GroupV1 paths against the persistent Docker contour before the
production authority lifecycle is complete. It is not a mock outcome signer
and it cannot turn legacy DPE1/DPE2 callback evidence into a passing gate.

The lane produces two distinct result classes:

- **dev-functional E2E:** application behavior, wire dispatch, persistence,
  retry, deduplication, attachment transfer, group fanout and cold restart;
- **production-readiness E2E:** separately requires the release-approved
  production authorities, binaries and signing evidence. A dev-functional pass
  never satisfies this class.

## Cryptographic and state contract

The dev authority uses suite `0x0201` without substitution:

- the same canonical DPK2, DPH2, DPE2 and TRS1 codecs and transcripts;
- the same X25519 + ML-KEM-768 hybrid handshake and Triple Ratchet transition
  producer available on the tested platform;
- the same labelled HKDF-SHA-512 and XChaCha20-Poly1305 message protection;
- the same bounded skipped-key, replay, deletion, CAS and crash-recovery rules;
- the same MSG-01 authenticated-evidence verification and SQLCipher stores.

Only the root of trust and issuance policy are development-scoped. The issuer
may authorize arbitrary locally registered development accounts/devices and may
use short fixture lifetimes. It MUST NOT mint a successful MSG-01 result without
first producing and durably committing the exact real ratchet transition.

## Authority lifecycle

The local stack owns one generated environment under ignored
`.secrets/survival-dev/dev-e2ee-01/`. Preparation creates:

1. a random development issuer seed;
2. a public issuer descriptor bound to the exact local network ID and profile
   generation;
3. a monotonic signed authority snapshot with bounded validity;
4. an empty revocation head and an append-only development registration store.

Private issuer material is mounted read-only only into the local authority
process. Client handoff artifacts contain the public descriptor, exact snapshot
hash/generation and endpoint, never the issuer seed. Rotation creates a signed
successor and preserves the previous public checkpoint for overlap; it does not
silently replace a client's last-known-good authority.

Each client generates its account/device/prekey secrets locally and submits
only the canonical public registration. The dev issuer signs the verified
development registration. Device, hybrid prekey, one-time prekey and ratchet
secrets remain in the client's protected account/SQLCipher stores.

## Non-bypassable isolation

All of the following gates are mandatory:

1. The factory is compiled only for non-Release `DeepLocalDev=true` builds.
2. The runtime requires the isolated package/application identity
   `network.xpoint.deep.e2e` and the exact `SURVIVAL_ENVIRONMENT=Development`
   profile.
3. The public authority descriptor is bound to the generated local network ID,
   profile hash and loopback/LAN-scoped endpoint set.
4. Release builds reject every `DEV-E2EE-01` metadata key and do not contain the
   dev factory/type, issuer domain string or private fixture.
5. Production composition and CI scans fail if a dev symbol, resource,
   descriptor or endpoint enters an APK/AAB/Windows ZIP/release output.
6. No `requireE2eeTransport=false`, unconditional verifier, test
   `CreateTestEd25519`, DPE1, Session identity, plaintext message envelope or
   caller-controlled success callback is accepted.

## Service boundary

The authority extends the existing local registry/control-plane service; it is
not a new language, database or standalone cryptographic implementation. Its
bounded API is:

- register canonical development account/device/prekey public material;
- fetch the current signed descriptor/prekey bundle by opaque development
  locator;
- rotate one-time prekeys with idempotent operation IDs;
- fetch signed revocation and successor checkpoints.

The service never receives a recovery phrase, device private key, ratchet key,
message plaintext, attachment key or group secret. XNodes and storage remain
opaque transports and do not become E2EE authorities.

## Acceptance

`DEV-E2EE-01` becomes usable only when all of these pass on the same profile:

- negative Release composition/resource/symbol scans;
- issuer snapshot tamper, expiry, rollback, fork and revocation tests;
- Android↔Windows first-session handshake with exact DPK2/DPH2 evidence;
- bidirectional text plus duplicate/out-of-order/restart ratchet tests;
- attachment upload/download/decrypt/hash and bounded-resume tests;
- group create/invite/two-way message/member-change/cold-restart tests;
- deletion evidence proving consumed one-time prekeys and message keys are gone;
- sanitized evidence that records only hashes, generations, result classes and
  booleans, never identities, phrases, keys or plaintext.

Until this gate passes, the current local `Attach`, `GroupText` and
`PayloadMatrix` failures remain honest upstream blockers.
