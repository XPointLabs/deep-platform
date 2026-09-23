# Post-quantum provider feasibility checkpoint

Date: 2026-08-30

Status: **`mlkem-native` v2.0.0 selected for whole ML-KEM/PQXDH; exact
incremental ML-KEM required by Braid remains a separate provider gate**

> **2026-09-23 identity decision:** [DR-0006](../../../decisions/DR-0006-pq-root-deep-id-clean-break.md)
> supersedes the older conclusion below that ML-DSA is entirely post-V1.
> ML-DSA for the permanent identity root is now a release requirement, while
> per-message signatures and other authority-suite migrations are not. This
> ML-KEM feasibility checkpoint is not ML-DSA provider approval: Android/
> Windows key lifecycle, deterministic recovery, KAT and review remain open.

## Outcome

Deep V1 targets a narrow C static-library ABI around vendored
`mlkem-native` v2.0.0, commit
`d1b2fe782888bdb761a50336012923180be7f502`, for ML-KEM-768 on Android arm64
and Windows x64/arm64. Only upstream source plus a Deep-owned configuration and
ABI wrapper are allowed; cryptographic arithmetic changes require a new
decision and independent review. Existing libsodium remains the provider for
X25519, Ed25519 and XChaCha20-Poly1305.
`libcrux-ml-kem`, Bouncy Castle, RustCrypto, .NET/OpenSSL/CNG where supported and NIST KATs
are independent oracles, not production fallbacks. No Apple provider is
required by the first Android/Windows release scope.

The completed API audit found that `mlkem-native` exposes only whole
encapsulation. Its internal PKE function computes `ct1(960) || ct2(128)` in one
call and does not expose the incremental `Encaps1` state or `Encaps2` primitive
required by Signal ML-KEM Braid. Deep will not fork or copy that polynomial
arithmetic without a separate cryptographic audit. The bounded next candidate
is therefore a second, narrow provider around pinned dual-licensed
`libcrux-ml-kem` incremental primitives; the AGPL Signal SPQR crate is reference
evidence only and is not admitted to the production dependency graph.

`BouncyCastle.Cryptography` 2.7.0 was evaluated on physical Android arm64 as a
managed alternative. It is functionally correct and fast enough, but is not an
accepted production provider: upstream still labels PQ algorithms experimental,
`MLKemPrivateKeyParameters` retains seed/expanded private-key arrays without a
deterministic disposal/zeroization API, and same-length private coefficient
mutation is accepted by the import surface. A wrapper can clear caller-owned
copies but cannot clear those retained internal arrays. The package remains a
test-only KAT/interoperability oracle and benchmark candidate.

Physical Release/AOT probe results on 2026-08-30 were:

| Device class | Android API | keygen median | encapsulate median | decapsulate median |
|---|---:|---:|---:|---:|
| Samsung Galaxy S10 arm64 | 31 | 0.213 ms | 0.238 ms | 0.280 ms |
| Samsung Galaxy A5 arm64 | 26 | 1.438 ms | 1.668 ms | 2.093 ms |

The isolated APK was 7,049,391 bytes; its linked Bouncy Castle assembly was
5,155,728 bytes and did not trim to an ML-KEM-only subset. Sanitized evidence and
the reproducible probe live in
`deep-protocol/eng/Deep.PqcProviderProbe.Android`. These measurements prove
execution and resource feasibility only, not constant-time behavior or
production security.

The isolated RustCrypto `ml-kem` 0.3.2 ABI spike compiled on Windows x64, passed
its wrapper tests and produced byte-identical clean release builds. Independent
source review nevertheless found that upstream keygen, encapsulation and
decapsulation leave secret intermediate polynomial/pre-key values without
zeroize-on-drop. The outer ABI can clear caller buffers and final provider
objects but cannot repair those inner lifetimes. Unmodified RustCrypto 0.3.2 is
therefore also NO-GO for production.

This is an implementation direction, not activation evidence. CRYPTO-01 must
vendor and review the exact upstream subset, pin source and toolchain inputs,
freeze the C ABI, produce reproducible binaries, pass KAT,
physical-benchmark, malformed-input, memory-lifetime and side-channel gates and
obtain independent review before suite `0x0201` becomes releasable.

The 24-word DeepRecoveryV1 work is independent of that provider and may proceed
first.

## Suite-substitution review (2026-09-12)

Changing AEAD, HKDF hash or authentication signatures does not remove the
incremental ML-KEM provider required by SPQR/Braid. They solve different
problems:

| Proposal | Security/implementation result | V1 decision |
| --- | --- | --- |
| AES-256-GCM instead of XChaCha20-Poly1305 | Both are approved 256-bit-key AEAD choices with a 128-bit tag. AES-GCM is widely hardware accelerated, but its short nonce MUST be unique for each key; XChaCha's 192-bit nonce is safer for random distributed nonce allocation. Either choice still consumes the same ML-KEM/Braid outputs. | Keep frozen XChaCha20 suite `0x0201`. Reopening the wire, nonce grammar and vectors provides no PQ gain and does not remove Rust. |
| HKDF-SHA-256 instead of HKDF-SHA-512 | Both are adequate labeled combiners at the required output sizes. The hash choice neither implements ML-KEM nor changes Braid's split encapsulation API. | Keep the frozen SHA-512 transcript/KDF construction; no extra suite or negotiation. |
| ML-DSA-65 in V1 | Adds post-quantum long-lived authentication, but not confidentiality or the continuous PQ ratchet. Public keys/signatures are large and the .NET platform implementation is unavailable on Android. | Required for the genesis-committed permanent ID under DR-0006, pending provider/recovery/wire gates; still not placed in each message. |
| .NET 10 `MLKem` | Removes an application-owned native ABI only on platforms whose OS crypto provider supports it. The API exposes whole keygen/encapsulate/decapsulate, not Braid `Encaps1`/`Encaps2`. | Windows/Linux oracle and future whole-KEM provider candidate; not an Android or incremental-Braid replacement. |

"AES-256" and "SHA-256" therefore do not mean a stronger suite than the
current 256-bit-key XChaCha20/HKDF-SHA-512 construction. AES-256 and
XChaCha20 have the same nominal key-search class; the operational difference
here is nonce handling and platform/provider behavior. HKDF security is bounded
by its input key material, labels and requested output as well as by the hash;
changing SHA-512 to SHA-256 is not an upgrade. ML-DSA is orthogonal: it can add
post-quantum authentication to selected long-lived signed objects, while
ML-KEM/PQXDH and Triple Ratchet protect message confidentiality and recovery.

Replacing only XChaCha20-Poly1305 with `AesGcm` would not remove the existing
native crypto boundary either: the current Sodium provider also owns the
cross-platform X25519 and Ed25519 operations, while the separate Rust
`libcrux-ml-kem` candidate owns incremental Braid state. A native-free client is
a valid future goal, but its acceptance gate is an Android-and-Windows provider
for every required primitive and exact Braid split operation, not an AEAD name
change.

On the current Windows arm64 lab host (`.NET 10.0.9`, Windows build 26200),
`MLKem.IsSupported` and `MLDsa.IsSupported` both return `true`. This is useful
platform evidence, not cross-platform evidence: Microsoft's current support
matrix lists ML-KEM and ML-DSA as unsupported on Android. Target Android 9/API
28 therefore still needs an application-supplied implementation.

Removing the native Rust Braid library is acceptable if a maintained,
license-compatible implementation later exposes the exact split operations,
passes the same vectors/zeroization/constant-time gates and runs on Android and
Windows. Replacing Triple Ratchet with whole-ML-KEM-only refresh merely to use
the .NET API is a protocol redesign and security regression, not a provider
simplification. Mixing .NET ML-KEM on Windows with another Android production
provider would retain two implementations without eliminating Braid, so it is
not the V1 default.

## Candidate assessment

### .NET 10 `System.Security.Cryptography`

Microsoft exposes FIPS 203 ML-KEM and FIPS 204 ML-DSA APIs in .NET 10.
Official cross-platform documentation currently reports built-in support on
Windows 11 Insider and Linux with OpenSSL 3.5+, but no built-in Apple, Android
or browser support. The native interop classes depend on the underlying OS
cryptographic provider.

Verdict: preferred API shape and useful Windows/Linux oracle, but not a
cross-platform Deep client provider today. The current API is also monolithic:
it cannot satisfy the separately required Braid `Encaps1`/`Encaps2` contract.

References:

- <https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.mlkem?view=net-10.0>
- <https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.mldsa?view=net-10.0>
- <https://learn.microsoft.com/en-us/dotnet/standard/security/cross-platform-cryptography>

### Bouncy Castle .NET

Bouncy Castle .NET is managed and includes ML-KEM and ML-DSA. Version 2.7.0,
tag `release-2.7.0`, commit
`4007498b13582d90ee1eda5d9920c324428b98b3`, was physically evaluated. Its own
project documentation describes the post-quantum implementations as
experimental and subject to change or removal. Public-key length/modulus and
private embedded-public corruption checks passed; caller-owned temporary arrays
can be cleared. The private-key object itself is not disposable/zeroizable and a
mutated private coefficient was accepted.

Verdict: accepted only as an independent vector/portability oracle and benchmark
candidate. It is rejected as the production provider for this generation. A
future reconsideration requires upstream removal of the experimental status and
a reviewed private-key lifetime/zeroization contract; a Deep-maintained crypto
fork is not the default because it would transfer implementation and patch
responsibility to the project.

Reference: <https://github.com/bcgit/bc-csharp>

### Open Quantum Safe `liboqs`

`liboqs` supports ML-KEM/ML-DSA, KATs, benchmarks and cross-compilation. The
project describes itself as a library for prototyping and experimenting with
quantum-resistant cryptography, and native mobile packaging would add another
ABI, memory-safety and update surface.

Verdict: useful as a second independent oracle and performance comparison;
not the production mobile provider by default.

Reference: <https://github.com/open-quantum-safe/liboqs>

### `mlkem-native` v2.0.0 — selected production candidate

`mlkem-native` is a portable C90 implementation maintained under the
Post-Quantum Cryptography Alliance/Linux Foundation and licensed
Apache-2.0 OR ISC OR MIT. Its portable C is proved memory/type safe with CBMC;
ARM64/x64 assembly backends have functional, memory-safety and
secret-independent-timing proofs at object-code level. The implementation
clears stack intermediates required by FIPS 203 section 3.3, applies compiler
barriers to constant-time code, and is tested with ACVP, Wycheproof and
valgrind secret-flow checks. It is already consumed by AWS-LC, liboqs and
rustls/AWS-LC.

Deep initially uses the portable C backend to minimize build and dispatch
complexity. Native ARM64/x64 backends may be enabled only after identical
vectors, physical benchmarks and binary review. The upstream build system is
development-only, so Deep owns a small pinned CMake/Ninja build and ABI wrapper.
Rust is not required for the selected whole-ML-KEM/PQXDH provider. It becomes a
production build prerequisite only if the separate `libcrux-ml-kem`
incremental-Braid gate passes; release artifacts must still consume pinned,
reproducible native binaries rather than requiring a toolchain on user devices.

Reference: <https://github.com/pq-code-package/mlkem-native/tree/v2.0.0>

### RustCrypto `ml-kem` — rejected unmodified spike

The pure-Rust/no_std implementation tracks FIPS 203 and is dual MIT/Apache-2.0.
Deep uses a tiny owned ABI rather than exposing Rust types or serialization.
Version 0.3.2 is the pinned spike base and passes functional wrapper tests, but
its algorithm internals do not wipe every secret intermediate on return or
unwind. Making it production-eligible would require invasive forks of both
`ml-kem` and `module-lattice`, plus correction of secret-dependent lookup
behavior. That maintenance burden is not accepted while `mlkem-native`
provides a narrower, better-reviewed implementation. RustCrypto remains test
evidence only.

Reference: <https://github.com/RustCrypto/KEMs/tree/master/ml-kem>

### libcrux — incremental-Braid candidate and independent oracle

libcrux provides the split ML-KEM-768 operations the Braid construction needs,
verified source and permissive licensing. Its project currently describes the
crates as pre-release and explicitly does not claim compiled executables are
side-channel resistant. Deep's pinned `0.0.10` candidate now has a panic-safe,
zeroizing 17-symbol C ABI, exact whole-ML-KEM interop, bounded 1,024-state
ownership, Windows x64 adversarial tests and physical Android arm64 native plus
managed-wrapper probes. On the API 26 lab device ten managed full roundtrips
took 26.752 ms. This proves compatibility and ownership behavior, not
constant-time production eligibility. Windows arm64, reproducible manifest/
SBOM and independent binary/side-channel review remain mandatory. It does not
replace `mlkem-native` for PQXDH merely to reduce the provider count.

Reference: <https://github.com/celabshq/libcrux>

## Required provider gate

A production provider is selected only after all of the following are true:

1. Exact FIPS 203 revision and current errata are pinned.
2. ML-KEM-768 ACVP/KATs pass at build evidence time; ML-DSA is a future
   certificate option and does not block the Ed25519-authenticated V1 suite.
3. Windows x64/arm64 and Android arm64 production builds agree with NIST,
   libcrux and platform-oracle vectors and malformed inputs. Apple is a later
   scope generation and cannot inherit this evidence.
4. Key generation/import/export and deterministic seed behavior required by
   DeepRecoveryV1 are explicit and version-stable.
5. Constant-time, zeroization, RNG, fault handling and native ABI behavior are
   reviewed, including provider-internal intermediates on success, rejection
   and unwind paths; clearing only ABI buffers is insufficient.
6. Android/Windows package size, startup, memory, CPU, thermal and battery budgets
   pass.
7. Reproducible source/package provenance, vulnerability response and rollback
   policy are accepted.
8. Independent crypto/privacy review reports P0=0/P1=0.

## Immediate implementation boundary

Allowed now:

- DeepRecoveryV1 codec/KDF vectors and a consumer-unreferenced dark path;
- canonical DPAC/DPDC/DPKB/DPHI parser models without cryptographic callbacks;
- .NET/Bouncy Castle/liboqs offline vector and benchmark harnesses; the pinned
  Bouncy Castle Android probe is retained as non-production evidence;
- resource measurements and provider adapters that cannot be selected by a
  production composition root.
- a consumer-unreferenced `mlkem-native` C ABI with deterministic builds and
  tests; its Android arm64 production wrapper has passed an isolated physical
  managed probe, but ordinary release composition remains fail-closed until all
  provider gates pass;
- the isolated `libcrux-ml-kem` incremental candidate and probes described
  above; `ApprovedForProduction` remains false.

Forbidden now:

- adding a PQ package to the production client/node/service dependency graph;
- persisting real user PQ private keys;
- accepting suite `0x0101` or `0x0102` on any production endpoint;
- security claims beyond test-only feasibility evidence;
- hiding missing mobile support behind classical fallback.
