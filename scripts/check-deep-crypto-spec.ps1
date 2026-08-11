[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$specRoot = Join-Path $repoRoot 'docs\survival-program\releases\v3.0.0\specs'
$specPath = Join-Path $specRoot 'DEEP-CRYPTO-V1-DRAFT.md'
$registryPath = Join-Path $specRoot 'deep-crypto-v1.registry.json'
$vectorSchemaPath = Join-Path $specRoot 'deep-crypto-v1.vectors.schema.json'

function Fail([string]$Message) {
    throw "Deep crypto specification check failed: $Message"
}

foreach ($path in @($specPath, $registryPath, $vectorSchemaPath)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { Fail "missing artifact: $path" }
}

$spec = Get-Content -LiteralPath $specPath -Raw -Encoding UTF8
$registry = Get-Content -LiteralPath $registryPath -Raw -Encoding UTF8 | ConvertFrom-Json
$vectorSchema = Get-Content -LiteralPath $vectorSchemaPath -Raw -Encoding UTF8 | ConvertFrom-Json

if ($registry.schemaVersion -ne '1.0.0') { Fail 'unexpected registry schemaVersion' }
if ($registry.status -ne 'design-draft-dark-path-only') { Fail 'registry must remain dark-path only' }
if ($registry.decision -ne 'DR-0003' -or $registry.workPackage -ne 'DNP1-SPEC-crypto') {
    Fail 'registry governance binding changed'
}
if ($vectorSchema.'$schema' -ne 'https://json-schema.org/draft/2020-12/schema') {
    Fail 'unexpected vector schema dialect'
}

$expectedSizes = [ordered]@{
    ed25519PublicKey = 32
    ed25519Signature = 64
    x25519PublicKey = 32
    x25519SharedSecret = 32
    mlKem768EncapsulationKey = 1184
    mlKem768DecapsulationKey = 2400
    mlKem768Ciphertext = 1088
    mlKem768SharedSecret = 32
    mlDsa65PublicKey = 1952
    mlDsa65PrivateKey = 4032
    mlDsa65Signature = 3309
    xchacha20Nonce = 24
    aeadTag = 16
    recordMaximum = 65535
}
foreach ($entry in $expectedSizes.GetEnumerator()) {
    if ([int]$registry.sizes.($entry.Key) -ne $entry.Value) {
        Fail "size drift for $($entry.Key): expected $($entry.Value), actual $($registry.sizes.($entry.Key))"
    }
    if ($spec -notmatch "(?<![0-9])$([regex]::Escape([string]$entry.Value))(?![0-9])") {
        Fail "normative spec does not mention required size $($entry.Key)=$($entry.Value)"
    }
}

if ([int]$registry.recovery.entropyBytes -ne 32 -or
    [int]$registry.recovery.wordCount -ne 24 -or
    [int]$registry.recovery.checksumBits -ne 8 -or
    $registry.recovery.wordList -ne 'bip39-en-v1' -or
    $registry.recovery.normalization -ne 'UTF-8-NFKD' -or
    $registry.recovery.passphraseMode -ne 'empty-only' -or
    $registry.recovery.directMnemonicDeviceKeyDerivation) {
    Fail 'DeepRecoveryV1 invariants changed'
}

$suiteIds = New-Object 'System.Collections.Generic.HashSet[int]'
foreach ($suite in @($registry.suites)) {
    if (-not $suiteIds.Add([int]$suite.id)) { Fail "duplicate suite id $($suite.id)" }
    if (-not $suite.bothKemComponentsRequired) { Fail "suite $($suite.hex) permits a missing KEM component" }
    if ($suite.productionEligible) { Fail "suite $($suite.hex) cannot be production eligible in a draft" }
}
if (-not $suiteIds.SetEquals([int[]]@(257, 258))) { Fail 'suite set must be exactly 0x0101 and 0x0102' }

$domains = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
foreach ($domain in @($registry.domains)) {
    if (-not $domains.Add([string]$domain)) { Fail "duplicate domain: $domain" }
    if ($domain -notmatch '^Deep/[A-Za-z0-9/-]+$') { Fail "non-canonical domain: $domain" }
    if ($spec.IndexOf([string]$domain, [System.StringComparison]::Ordinal) -lt 0) {
        Fail "domain is absent from normative spec: $domain"
    }
}

$magics = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
foreach ($record in @($registry.records)) {
    if ([string]$record.magic -notmatch '^[A-Z0-9]{4}$') { Fail "invalid record magic $($record.magic)" }
    if (-not $magics.Add([string]$record.magic)) { Fail "duplicate record magic $($record.magic)" }
    if ([int]$record.version -ne 1) { Fail "unexpected record version for $($record.magic)" }
    if ($spec.IndexOf("``$($record.magic)``", [System.StringComparison]::Ordinal) -lt 0) {
        Fail "record magic is absent from normative spec: $($record.magic)"
    }
}

foreach ($forbidden in @(
    'Ed25519-to-X25519 key conversion',
    'classical-only KEM fallback',
    'PQ-only KEM fallback',
    'automatic suite downgrade',
    'direct use of the BIP-39 seed as a role key',
    'production activation before independent P0/P1-zero review',
    'custom implementation of ML-KEM or ML-DSA'
)) {
    if (@($registry.forbidden) -notcontains $forbidden) { Fail "missing forbidden rule: $forbidden" }
}

if ($registry.provider.selected) { Fail 'a cryptographic provider has not been reviewed or selected' }
if (@($registry.provider.requirements).Count -lt 6) { Fail 'provider gate is incomplete' }

foreach ($reference in @(
    'https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki',
    'https://csrc.nist.gov/pubs/fips/203/final',
    'https://csrc.nist.gov/pubs/fips/204/final',
    'https://signal.org/docs/specifications/pqxdh/',
    'https://signal.org/docs/specifications/doubleratchet/'
)) {
    if ($spec.IndexOf($reference, [System.StringComparison]::Ordinal) -lt 0) {
        Fail "missing primary reference: $reference"
    }
}

Write-Host 'Deep crypto specification check passed.'
Write-Host "Suites: $(@($registry.suites).Count) (all dark-path only)"
Write-Host "Domains: $($domains.Count)"
Write-Host "Recovery: $($registry.recovery.wordCount) words / $([int]$registry.recovery.entropyBytes * 8) bits"
Write-Host 'Provider selected: no'
