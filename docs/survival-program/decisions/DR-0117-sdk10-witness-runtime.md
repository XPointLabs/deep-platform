# DR-0117 — SDK10 package-witness runtime

Status: accepted local/source verification contract; release activation unchanged
Date: 2026-10-14
Owner: Mr. X (delegated engineering authority)

The selected repository SDK remains10.0.301 and ordinary Windows native gates
remain Windows PowerShell5.1. The separate executable Protocol witnesses use
exact PowerShell7.6.5 with .NET10, not7.5.4/.NET9. The latter cannot load SDK10
MSBuild types; an X64 witness additionally cannot load the ARM64 SDK assembly.
No SDK downgrade, dependency resolver fallback or weakened package check is
authorized. The gate records actual witness version/runtime/architecture and
must reject an incompatible selected MSBuild assembly before build/full.

Evidence:7.5.4 X64 fails assembly load; official7.5.4 ARM64 (reviewed release
digest and valid Microsoft signature) loads the assembly but cannot enumerate
types because System.Runtime10 is absent. Installed signed7.6.5 ARM64/.NET10
executes the same actual ZIP/assembly/resource/API witness, reaching a real
retired `MAU2` assembly-token rejection. This remains a package FAIL, not a
source or release PASS. Preserve both diagnostic failures and original receipts.

Use only the explicitly selected existing executable; no test runner installs
or silently swaps interpreters. Scoped PATH selection is restored after native
children. CI must supply a matching witness runtime/architecture before this
lane can qualify; a version check alone is insufficient.
