[CmdletBinding()]
param(
    [ValidateSet('Prepare', 'Verify')]
    [string] $Mode = 'Verify',

    [string] $RepositoryRoot = (Join-Path $PSScriptRoot '..'),

    [string] $EvidencePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$schemaVersion = 'deep.rc6.release-candidate-commit-matrix.v1'
$bindingModel = 'child-commits-via-containing-superproject-tree'
$manifestRelativePath = 'docs/release-candidate-commit-matrix.v1.json'
$requiredRepositories = @(
    'deep-client-maui',
    'deep-client-shared',
    'deep-devops',
    'deep-protocol',
    'deep-registry-api',
    'deep-tests-e2e',
    'xnode'
)
$commitPattern = '^[0-9a-f]{40}$'
$maximumManifestBytes = 32768
$maximumEvidenceBytes = 8192
$utf8 = [Text.UTF8Encoding]::new($false, $true)

function Stop-Gate([string] $Code) {
    throw "RC-6 commit matrix gate failed: $Code"
}

function Invoke-GitText(
    [string] $WorkingDirectory,
    [string[]] $Arguments,
    [string] $FailureCode
) {
    $output = @(& git -C $WorkingDirectory @Arguments 2>$null)
    if ($LASTEXITCODE -ne 0) {
        Stop-Gate $FailureCode
    }

    return (($output | ForEach-Object { [string] $_ }) -join "`n").Trim()
}

function Assert-ExactProperties(
    [object] $Value,
    [string[]] $Expected,
    [string] $FailureCode
) {
    if ($null -eq $Value) {
        Stop-Gate $FailureCode
    }

    $actual = @($Value.PSObject.Properties.Name)
    if ($actual.Count -ne $Expected.Count) {
        Stop-Gate $FailureCode
    }

    for ($index = 0; $index -lt $Expected.Count; $index++) {
        if (-not [StringComparer]::Ordinal.Equals([string] $actual[$index], $Expected[$index])) {
            Stop-Gate $FailureCode
        }
    }
}

function Test-IsWithinRepository([string] $Candidate, [string] $Root) {
    $rootWithSeparator = $Root.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    return [StringComparer]::OrdinalIgnoreCase.Equals($Candidate, $Root) -or
        $Candidate.StartsWith($rootWithSeparator, [StringComparison]::OrdinalIgnoreCase)
}

function Get-IndexGitlink([string] $Root, [string] $Path) {
    $line = Invoke-GitText $Root @('ls-files', '--stage', '--', $Path) "index-gitlink-$Path"
    $match = [regex]::Match($line, '^160000 ([0-9a-f]{40}) 0\t(.+)$', [Text.RegularExpressions.RegexOptions]::CultureInvariant)
    if (-not $match.Success -or -not [StringComparer]::Ordinal.Equals($match.Groups[2].Value, $Path)) {
        Stop-Gate "index-gitlink-$Path"
    }

    return $match.Groups[1].Value
}

function Get-HeadGitlink([string] $Root, [string] $Path) {
    $line = Invoke-GitText $Root @('ls-tree', 'HEAD', '--', $Path) "head-gitlink-$Path"
    $match = [regex]::Match($line, '^160000 commit ([0-9a-f]{40})\t(.+)$', [Text.RegularExpressions.RegexOptions]::CultureInvariant)
    if (-not $match.Success -or -not [StringComparer]::Ordinal.Equals($match.Groups[2].Value, $Path)) {
        Stop-Gate "head-gitlink-$Path"
    }

    return $match.Groups[1].Value
}

$root = [IO.Path]::GetFullPath($RepositoryRoot)
if (-not (Test-Path -LiteralPath $root -PathType Container)) {
    Stop-Gate 'superproject-missing'
}

$topLevel = Invoke-GitText $root @('rev-parse', '--show-toplevel') 'superproject-not-git'
if (-not [StringComparer]::OrdinalIgnoreCase.Equals([IO.Path]::GetFullPath($topLevel), $root)) {
    Stop-Gate 'superproject-root-mismatch'
}

$manifestPath = [IO.Path]::GetFullPath((Join-Path $root $manifestRelativePath))
if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
    Stop-Gate 'manifest-missing'
}

$manifestBytes = [IO.File]::ReadAllBytes($manifestPath)
if ($manifestBytes.Length -eq 0 -or $manifestBytes.Length -gt $maximumManifestBytes) {
    Stop-Gate 'manifest-size'
}

try {
    $manifestText = $utf8.GetString($manifestBytes)
    $manifest = $manifestText | ConvertFrom-Json
}
catch {
    Stop-Gate 'manifest-json'
}

Assert-ExactProperties $manifest @('schemaVersion', 'bindingModel', 'repositories') 'manifest-properties'
if (-not [StringComparer]::Ordinal.Equals([string] $manifest.schemaVersion, $schemaVersion)) {
    Stop-Gate 'manifest-schema'
}
if (-not [StringComparer]::Ordinal.Equals([string] $manifest.bindingModel, $bindingModel)) {
    Stop-Gate 'manifest-binding-model'
}

$entries = @($manifest.repositories)
if ($entries.Count -ne $requiredRepositories.Count) {
    Stop-Gate 'manifest-repository-count'
}

$matrix = [ordered]@{}
for ($index = 0; $index -lt $entries.Count; $index++) {
    $entry = $entries[$index]
    Assert-ExactProperties $entry @('path', 'commit') 'manifest-repository-properties'
    $path = [string] $entry.path
    $commit = [string] $entry.commit
    if ($matrix.Contains($path)) {
        Stop-Gate 'manifest-repository-duplicate'
    }
    if (-not [StringComparer]::Ordinal.Equals($path, $requiredRepositories[$index])) {
        Stop-Gate 'manifest-repository-order-or-membership'
    }
    if (-not [regex]::IsMatch($commit, $commitPattern, [Text.RegularExpressions.RegexOptions]::CultureInvariant)) {
        Stop-Gate "manifest-commit-$path"
    }

    $matrix[$path] = $commit
}

$gitModulesPath = Join-Path $root '.gitmodules'
if (-not (Test-Path -LiteralPath $gitModulesPath -PathType Leaf)) {
    Stop-Gate 'gitmodules-missing'
}
$configuredPaths = @(Invoke-GitText $root @('config', '--file', '.gitmodules', '--get-regexp', '^submodule\..*\.path$') 'gitmodules-invalid' |
    ForEach-Object { $_ -split "`n" } |
    ForEach-Object {
        $parts = $_ -split '\s+', 2
        if ($parts.Count -ne 2) { Stop-Gate 'gitmodules-invalid' }
        $parts[1]
    })
foreach ($requiredPath in $requiredRepositories) {
    if (@($configuredPaths | Where-Object { [StringComparer]::Ordinal.Equals($_, $requiredPath) }).Count -ne 1) {
        Stop-Gate "gitmodules-$requiredPath"
    }
}

$rootUnstaged = Invoke-GitText $root @('diff', '--name-only', '--ignore-submodules=all', '--') 'root-unstaged-check'
$rootUntracked = Invoke-GitText $root @('ls-files', '--others', '--exclude-standard') 'root-untracked-check'
$rootStaged = Invoke-GitText $root @('diff', '--cached', '--name-only', '--') 'root-staged-check'

if ($Mode -eq 'Verify') {
    if ($rootUnstaged.Length -ne 0 -or $rootUntracked.Length -ne 0 -or $rootStaged.Length -ne 0) {
        Stop-Gate 'root-not-clean'
    }
}
else {
    if ($rootUnstaged.Length -ne 0 -or $rootUntracked.Length -ne 0) {
        Stop-Gate 'prepare-root-has-unstaged-or-untracked-change'
    }

    $stagedPaths = @($rootStaged -split "`n" | Where-Object { $_.Length -gt 0 })
    $allowedStagedPaths = @($requiredRepositories) + @($manifestRelativePath)
    if ($stagedPaths.Count -eq 0 -or $manifestRelativePath -notin $stagedPaths) {
        Stop-Gate 'prepare-manifest-not-staged'
    }
    foreach ($stagedPath in $stagedPaths) {
        if ($stagedPath -notin $allowedStagedPaths) {
            Stop-Gate 'prepare-unrelated-staged-change'
        }
    }

}

$manifestIndexCommit = Invoke-GitText $root @('hash-object', '--', $manifestRelativePath) 'manifest-worktree-hash'
$manifestStagedCommit = Invoke-GitText $root @('rev-parse', ":$manifestRelativePath") 'manifest-not-in-index'
if (-not [StringComparer]::Ordinal.Equals($manifestIndexCommit, $manifestStagedCommit)) {
    Stop-Gate 'manifest-index-worktree-mismatch'
}

$verifiedEntries = @()
foreach ($path in $requiredRepositories) {
    $childRoot = [IO.Path]::GetFullPath((Join-Path $root $path))
    if (-not (Test-Path -LiteralPath $childRoot -PathType Container)) {
        Stop-Gate "child-missing-$path"
    }

    $childTopLevel = Invoke-GitText $childRoot @('rev-parse', '--show-toplevel') "child-not-git-$path"
    if (-not [StringComparer]::OrdinalIgnoreCase.Equals([IO.Path]::GetFullPath($childTopLevel), $childRoot)) {
        Stop-Gate "child-root-mismatch-$path"
    }

    $childStatus = Invoke-GitText $childRoot @('status', '--porcelain=v1', '--untracked-files=all') "child-status-$path"
    if ($childStatus.Length -ne 0) {
        Stop-Gate "child-not-clean-$path"
    }

    $childHead = Invoke-GitText $childRoot @('rev-parse', '--verify', 'HEAD^{commit}') "child-head-$path"
    $indexCommit = Get-IndexGitlink $root $path
    $manifestCommit = [string] $matrix[$path]
    if (-not [StringComparer]::Ordinal.Equals($childHead, $manifestCommit) -or
        -not [StringComparer]::Ordinal.Equals($indexCommit, $manifestCommit)) {
        Stop-Gate "commit-mismatch-$path"
    }

    if ($Mode -eq 'Verify') {
        $headCommit = Get-HeadGitlink $root $path
        if (-not [StringComparer]::Ordinal.Equals($headCommit, $manifestCommit)) {
            Stop-Gate "head-commit-mismatch-$path"
        }
    }

    $verifiedEntries += [ordered]@{ path = $path; commit = $manifestCommit }
}

$superprojectCommit = $null
if ($Mode -eq 'Verify') {
    $superprojectCommit = Invoke-GitText $root @('rev-parse', '--verify', 'HEAD^{commit}') 'superproject-head'
    if (-not [regex]::IsMatch($superprojectCommit, $commitPattern, [Text.RegularExpressions.RegexOptions]::CultureInvariant)) {
        Stop-Gate 'superproject-head-format'
    }
}

$sha256 = [Security.Cryptography.SHA256]::Create()
try {
    $manifestDigest = ([BitConverter]::ToString($sha256.ComputeHash($manifestBytes))).Replace('-', '').ToLowerInvariant()
}
finally {
    $sha256.Dispose()
}

if ($PSBoundParameters.ContainsKey('EvidencePath')) {
    if ([string]::IsNullOrWhiteSpace($EvidencePath)) {
        Stop-Gate 'evidence-path-empty'
    }
    if ($Mode -ne 'Verify') {
        Stop-Gate 'prepare-cannot-write-evidence'
    }

    $evidenceFile = [IO.Path]::GetFullPath($EvidencePath)
    if (Test-IsWithinRepository $evidenceFile $root) {
        Stop-Gate 'evidence-must-be-outside-superproject'
    }

    $evidence = [ordered]@{
        schemaVersion = 'deep.rc6.release-candidate-commit-matrix.evidence.v1'
        status = 'passed'
        bindingModel = $bindingModel
        superprojectCommit = $superprojectCommit
        manifestSha256 = $manifestDigest
        repositoryCount = $requiredRepositories.Count
        repositories = $verifiedEntries
        checks = [ordered]@{
            manifest = 'passed'
            superprojectTreeAndIndex = 'passed'
            childHeadsAndCleanliness = 'passed'
            rootCleanliness = 'passed'
        }
    }
    $evidenceText = ($evidence | ConvertTo-Json -Depth 5) + "`n"
    $evidenceBytes = $utf8.GetBytes($evidenceText)
    if ($evidenceBytes.Length -gt $maximumEvidenceBytes) {
        Stop-Gate 'evidence-size'
    }

    $evidenceDirectory = Split-Path -Parent $evidenceFile
    if (-not (Test-Path -LiteralPath $evidenceDirectory -PathType Container)) {
        New-Item -ItemType Directory -Path $evidenceDirectory -Force | Out-Null
    }
    [IO.File]::WriteAllBytes($evidenceFile, $evidenceBytes)
}

$phase = $Mode.ToLowerInvariant()
Write-Output "RC-6 commit matrix $phase passed: $($requiredRepositories.Count) exact child commits; manifest sha256 $manifestDigest."
