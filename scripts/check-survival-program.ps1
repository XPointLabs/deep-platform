[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$governanceRoot = Join-Path $repoRoot 'docs\survival-program'
$activeRelease = '3.0.0'
$releaseRoot = Join-Path $governanceRoot "releases\v$activeRelease"
$manifestPath = Join-Path $releaseRoot 'program-manifest.json'

function Fail([string]$Message) {
    throw "Deep Survival governance check failed: $Message"
}

foreach ($required in @(
    $manifestPath,
    (Join-Path $releaseRoot 'DEEP-NATIVE-CLEAN-BREAK-RU.md'),
    (Join-Path $releaseRoot 'agent-prompts\README.md'),
    (Join-Path $governanceRoot 'decisions\DR-0001-local-execution-approval.md'),
    (Join-Path $governanceRoot 'decisions\DR-0003-deep-native-session-clean-break.md'),
    (Join-Path $governanceRoot 'schemas\program-manifest.schema.json'),
    (Join-Path $governanceRoot 'PACKAGE-POLICY.md')
)) {
    if (-not (Test-Path -LiteralPath $required -PathType Leaf)) {
        Fail "required file is missing: $required"
    }
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
if ($manifest.schemaVersion -ne '1.0.0') { Fail 'unexpected manifest schemaVersion' }
if ($manifest.programId -ne 'deep-survival') { Fail 'unexpected programId' }
if ($manifest.release -ne $activeRelease) { Fail 'unexpected active release' }
if ($manifest.status -ne 'approved-local-execution') { Fail 'program is not approved for local execution' }
if ($manifest.accountableOwner -ne 'Mr. X') { Fail 'accountableOwner must be Mr. X' }
if ($manifest.inventoryBaseline.algorithm -ne 'SHA-256' -or
    $manifest.inventoryBaseline.path -ne 'inventory/session-production-boundaries.v1.json' -or
    $manifest.inventoryBaseline.tag -ne 'legacy-session-baseline-v3.0.0') {
    Fail 'inventory baseline policy is invalid'
}
if (-not $manifest.executionPolicy.localOnly -or -not $manifest.executionPolicy.localDockerAllowed -or
    $manifest.executionPolicy.pushAllowed -or $manifest.executionPolicy.externalPublishAllowed -or
    $manifest.executionPolicy.externalDeployAllowed) {
    Fail 'execution policy must remain local-only, allow local Docker, and prohibit push, external publish and external deploy'
}

$expectedMachinePaths = @(
    'docs/survival-program/releases/v3.0.0/specs/dnp1-classical-v1.registry.json',
    'docs/survival-program/releases/v3.0.0/specs/dnp1-classical-v1.registry.schema.json',
    'docs/survival-program/releases/v3.0.0/specs/dnp1-classical-v1.vectors.schema.json',
    'docs/survival-program/releases/v3.0.0/specs/dnp1-classical-v1.vectors.skeleton.json',
    'scripts/check-dnp1-classical-spec.ps1'
)
if ($manifest.machineSpecificationSet.algorithm -ne 'SHA-256' -or
    $manifest.machineSpecificationSet.entryFormat -ne '<lowercase-file-sha256><two-spaces><forward-slash-repo-relative-path><LF>' -or
    [int]$manifest.machineSpecificationSet.artifactCount -ne 5 -or
    (@($manifest.machineSpecificationSet.paths) -join '|') -ne ($expectedMachinePaths -join '|')) {
    Fail 'machine specification artifact-set policy drifted'
}
$machineEntries = foreach ($relativePath in $expectedMachinePaths) {
    $machinePath = Join-Path $repoRoot $relativePath.Replace('/', '\')
    if (-not (Test-Path -LiteralPath $machinePath -PathType Leaf)) { Fail "machine specification artifact is missing: $relativePath" }
    $fileHash = (Get-FileHash -LiteralPath $machinePath -Algorithm SHA256).Hash.ToLowerInvariant()
    "$fileHash  $relativePath"
}
$machineDigestInput = ($machineEntries -join "`n") + "`n"
$machineSha = [System.Security.Cryptography.SHA256]::Create()
try {
    $machineDigestBytes = $machineSha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($machineDigestInput))
    $actualMachineDigest = ([System.BitConverter]::ToString($machineDigestBytes)).Replace('-', '').ToLowerInvariant()
}
finally { $machineSha.Dispose() }
if ($actualMachineDigest -ne [string]$manifest.machineSpecificationSet.sha256) {
    Fail "machine specification set mismatch: expected $($manifest.machineSpecificationSet.sha256), actual $actualMachineDigest"
}

$documents = @(
    Get-ChildItem -LiteralPath $releaseRoot -Recurse -File -Filter '*.md' |
        Where-Object { $_.Name -ne 'MIRROR-NOTES.md' } |
        Sort-Object { $_.FullName.Substring($releaseRoot.Length + 1).Replace('\', '/') }
)

if ($documents.Count -ne [int]$manifest.documentSet.documentCount) {
    Fail "document count $($documents.Count) differs from manifest $($manifest.documentSet.documentCount)"
}

$entries = foreach ($document in $documents) {
    $relativePath = $document.FullName.Substring($releaseRoot.Length + 1).Replace('\', '/')
    $fileHash = (Get-FileHash -LiteralPath $document.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
    "$fileHash  $relativePath"
}

$digestInput = ($entries -join "`n") + "`n"
$sha = [System.Security.Cryptography.SHA256]::Create()
try {
    $digestBytes = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($digestInput))
    $actualDigest = ([System.BitConverter]::ToString($digestBytes)).Replace('-', '').ToLowerInvariant()
}
finally {
    $sha.Dispose()
}

if ($actualDigest -ne $manifest.documentSet.sha256) {
    Fail "program revision mismatch: expected $($manifest.documentSet.sha256), actual $actualDigest"
}

$brokenLinks = New-Object System.Collections.Generic.List[string]
$linkDocuments = @(Get-ChildItem -LiteralPath $governanceRoot -Recurse -File -Filter '*.md')
foreach ($document in $linkDocuments) {
    $content = Get-Content -LiteralPath $document.FullName -Raw -Encoding UTF8
    foreach ($match in [regex]::Matches($content, '(?<!\!)\[[^\]]+\]\((?<target>[^)]+)\)')) {
        $target = $match.Groups['target'].Value.Trim().Trim('<', '>')
        if ($target -match '^(?:https?://|mailto:|#)' -or $target -match '^[A-Za-z]:\\') { continue }
        $target = ($target -split '\s+"', 2)[0]
        $target = ($target -split '#', 2)[0]
        if ([string]::IsNullOrWhiteSpace($target)) { continue }
        $decoded = [System.Uri]::UnescapeDataString($target)
        $candidate = [System.IO.Path]::GetFullPath((Join-Path $document.DirectoryName $decoded))
        if (-not $candidate.StartsWith($governanceRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            continue
        }
        if (-not (Test-Path -LiteralPath $candidate)) {
            $relativeSource = $document.FullName.Substring($repoRoot.Length + 1)
            $brokenLinks.Add("$relativeSource -> $target")
        }
    }
}

if ($brokenLinks.Count -gt 0) {
    Fail ("broken local links:`n" + ($brokenLinks -join "`n"))
}

foreach ($entryPoint in @(
    (Join-Path $repoRoot 'prompts\00_Agent_Entry_Point.md'),
    (Join-Path $repoRoot 'roadmap.md'),
    (Join-Path $repoRoot 'docs\delivery-plan.md')
)) {
    $content = Get-Content -LiteralPath $entryPoint -Raw -Encoding UTF8
    if ($content -notmatch 'survival-program[/\\]README\.md') {
        Fail "source-of-truth pointer is missing from $entryPoint"
    }
}

Write-Host "Deep Survival program check passed."
Write-Host "Release: $($manifest.release)"
Write-Host "Documents: $($documents.Count)"
Write-Host "Revision: sha256:$actualDigest"

$inventoryPath = Join-Path $releaseRoot ([string]$manifest.inventoryBaseline.path)
if (-not (Test-Path -LiteralPath $inventoryPath -PathType Leaf)) {
    Fail "inventory baseline is missing: $inventoryPath"
}
$inventorySha = (Get-FileHash -LiteralPath $inventoryPath -Algorithm SHA256).Hash.ToLowerInvariant()
if ($inventorySha -ne [string]$manifest.inventoryBaseline.sha256) {
    Fail "inventory baseline SHA mismatch: expected $($manifest.inventoryBaseline.sha256), actual $inventorySha"
}

$inventory = Get-Content -LiteralPath $inventoryPath -Raw -Encoding UTF8 | ConvertFrom-Json
$baselineTag = [string]$manifest.inventoryBaseline.tag
foreach ($repository in @($inventory.repositories)) {
    $repositoryPath = Join-Path $repoRoot ([string]$repository.path)
    $tagType = (& git -C $repositoryPath cat-file -t "refs/tags/$baselineTag" 2>$null)
    if ($LASTEXITCODE -ne 0 -or $tagType.Trim() -ne 'tag') {
        Fail "annotated baseline tag is missing for $($repository.name): $baselineTag"
    }
    $tagTarget = (& git -C $repositoryPath rev-parse "$baselineTag^{}" 2>$null).Trim()
    if ($LASTEXITCODE -ne 0 -or $tagTarget -ne [string]$repository.expectedHead) {
        Fail "baseline tag target mismatch for $($repository.name): expected $($repository.expectedHead), actual $tagTarget"
    }
    $annotation = (& git -C $repositoryPath for-each-ref "refs/tags/$baselineTag" --format='%(contents)' 2>$null) -join "`n"
    if ($LASTEXITCODE -ne 0 -or $annotation -notmatch [regex]::Escape("inventory-sha256:$inventorySha") -or
        $annotation -notmatch [regex]::Escape('decision:DR-0003') -or
        $annotation -notmatch [regex]::Escape("commit:$($repository.expectedHead)")) {
        Fail "baseline tag annotation mismatch for $($repository.name)"
    }
}

$inventoryCheck = Join-Path $repoRoot 'scripts\check-deep-native-inventory.ps1'
if (-not (Test-Path -LiteralPath $inventoryCheck -PathType Leaf)) {
    Fail "Deep-native inventory checker is missing: $inventoryCheck"
}
& $inventoryCheck
if ($LASTEXITCODE -ne 0) {
    Fail "Deep-native inventory checker failed with exit code $LASTEXITCODE"
}

$cryptoSpecCheck = Join-Path $repoRoot 'scripts\check-deep-crypto-spec.ps1'
if (-not (Test-Path -LiteralPath $cryptoSpecCheck -PathType Leaf)) {
    Fail "Deep crypto specification checker is missing: $cryptoSpecCheck"
}
& $cryptoSpecCheck
if ($LASTEXITCODE -ne 0) {
    Fail "Deep crypto specification checker failed with exit code $LASTEXITCODE"
}

$classicalSpecCheck = Join-Path $repoRoot 'scripts\check-dnp1-classical-spec.ps1'
if (-not (Test-Path -LiteralPath $classicalSpecCheck -PathType Leaf)) {
    Fail "DNP1 classical specification checker is missing: $classicalSpecCheck"
}
& $classicalSpecCheck
if ($LASTEXITCODE -ne 0) {
    Fail "DNP1 classical specification checker failed with exit code $LASTEXITCODE"
}
