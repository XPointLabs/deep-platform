[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$governanceRoot = Join-Path $repoRoot 'docs\survival-program'
$releaseRoot = Join-Path $governanceRoot 'releases\v2.0.0'
$manifestPath = Join-Path $releaseRoot 'program-manifest.json'

function Fail([string]$Message) {
    throw "Deep Survival governance check failed: $Message"
}

foreach ($required in @(
    $manifestPath,
    (Join-Path $releaseRoot 'REVISED-PROGRAM-RU.md'),
    (Join-Path $releaseRoot 'agent-prompts\README.md'),
    (Join-Path $governanceRoot 'decisions\DR-0001-local-execution-approval.md'),
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
if ($manifest.release -ne '2.0.0') { Fail 'unexpected active release' }
if ($manifest.status -ne 'approved-local-execution') { Fail 'program is not approved for local execution' }
if ($manifest.accountableOwner -ne 'Mr. X') { Fail 'accountableOwner must be Mr. X' }
if (-not $manifest.executionPolicy.localOnly -or -not $manifest.executionPolicy.localDockerAllowed -or
    $manifest.executionPolicy.pushAllowed -or $manifest.executionPolicy.externalPublishAllowed -or
    $manifest.executionPolicy.externalDeployAllowed) {
    Fail 'execution policy must remain local-only, allow local Docker, and prohibit push, external publish and external deploy'
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
