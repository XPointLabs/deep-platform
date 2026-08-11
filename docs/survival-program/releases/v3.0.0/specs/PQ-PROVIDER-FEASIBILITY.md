# Post-quantum provider feasibility checkpoint

Date: 2026-08-11

Status: **NO-GO for production provider selection; GO for dark-path vectors
and benchmarks**

## Outcome

Deep should specify and prototype hybrid post-quantum messaging now, but should
not activate it in the product runtime yet. The blocking issue is not ML-KEM or
ML-DSA standardization; it is a maintained, reviewed provider with consistent
Windows, Linux/server, Android and Apple behavior.

The 24-word DeepRecoveryV1 work is independent of that provider and may proceed
first.

## Candidate assessment

### .NET 10 `System.Security.Cryptography`

Microsoft exposes FIPS 203 ML-KEM and FIPS 204 ML-DSA APIs in .NET 10.
Official cross-platform documentation currently reports built-in support on
Windows 11 Insider and Linux with OpenSSL 3.5+, but no built-in Apple, Android
or browser support. The native interop classes depend on the underlying OS
cryptographic provider.

Verdict: preferred API shape and useful Windows/Linux oracle, but not a
cross-platform Deep client provider today.

References:

- <https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.mlkem?view=net-10.0>
- <https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.mldsa?view=net-10.0>
- <https://learn.microsoft.com/en-us/dotnet/standard/security/cross-platform-cryptography>

### Bouncy Castle .NET

Bouncy Castle .NET is managed and includes ML-KEM and ML-DSA. Its own project
documentation describes the post-quantum implementations as experimental and
subject to change or removal.

Verdict: suitable as an independent vector/portability oracle and benchmark
candidate; not accepted as the production provider without a specific version
audit, constant-time/platform evidence, supply-chain pin and external review.

Reference: <https://github.com/bcgit/bc-csharp>

### Open Quantum Safe `liboqs`

`liboqs` supports ML-KEM/ML-DSA, KATs, benchmarks and cross-compilation. The
project describes itself as a library for prototyping and experimenting with
quantum-resistant cryptography, and native mobile packaging would add another
ABI, memory-safety and update surface.

Verdict: useful as a second independent oracle and performance comparison;
not the production mobile provider by default.

Reference: <https://github.com/open-quantum-safe/liboqs>

## Required provider gate

A production provider is selected only after all of the following are true:

1. Exact FIPS 203/204 revision and current errata are pinned.
2. ML-KEM-768 and ML-DSA-65 KATs pass at process start or installation audit.
3. Windows, Linux/server, Android and Apple implementations agree on the Deep
   vectors and malformed inputs.
4. Key generation/import/export and deterministic seed behavior required by
   DeepRecoveryV1 are explicit and version-stable.
5. Constant-time, zeroization, RNG, fault handling and native ABI behavior are
   reviewed.
6. Android/iOS package size, startup, memory, CPU, thermal and battery budgets
   pass.
7. Reproducible source/package provenance, vulnerability response and rollback
   policy are accepted.
8. Independent crypto/privacy review reports P0=0/P1=0.

## Immediate implementation boundary

Allowed now:

- DeepRecoveryV1 codec/KDF vectors and a consumer-unreferenced dark path;
- canonical DPAC/DPDC/DPKB/DPHI parser models without cryptographic callbacks;
- .NET/Bouncy Castle/liboqs offline vector and benchmark harnesses;
- resource measurements and provider adapters that cannot be selected by a
  production composition root.

Forbidden now:

- adding a PQ package to the production client/node/service dependency graph;
- persisting real user PQ private keys;
- accepting suite `0x0101` or `0x0102` on any production endpoint;
- security claims beyond test-only feasibility evidence;
- hiding missing mobile support behind classical fallback.
