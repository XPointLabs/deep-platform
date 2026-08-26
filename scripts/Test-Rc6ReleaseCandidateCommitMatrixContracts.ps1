[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$gate = Join-Path $PSScriptRoot 'Test-Rc6ReleaseCandidateCommitMatrix.ps1'
$generator = Join-Path $PSScriptRoot 'New-Rc6ReleaseCandidateCommitMatrix.ps1'
$requiredRepositories = @(
    'deep-client-maui',
    'deep-client-shared',
    'deep-devops',
    'deep-protocol',
    'deep-registry-api',
    'deep-tests-e2e',
    'xnode'
)
$utf8 = [Text.UTF8Encoding]::new($false)
$checks = 0
$temporaryParent = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$temporaryRoot = Join-Path $temporaryParent ("deep-rc6-matrix-contract-" + [Guid]::NewGuid().ToString('N'))
$superproject = Join-Path $temporaryRoot 'superproject'
$evidencePath = Join-Path $temporaryRoot 'output/release-matrix-evidence.json'

function Assert-Contract([bool] $Condition, [string] $Message) {
    if (-not $Condition) {
        throw "RC-6 commit matrix contract failed: $Message"
    }
    $script:checks++
}

function Invoke-TestGit([string] $WorkingDirectory, [string[]] $Arguments) {
    & git -C $WorkingDirectory @Arguments 1>$null 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw 'RC-6 disposable repository setup failed.'
    }
}

function Write-Utf8([string] $Path, [string] $Text) {
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    [IO.File]::WriteAllText($Path, $Text, $utf8)
}

function Write-Manifest([System.Collections.IDictionary] $Commits, [scriptblock] $Mutator) {
    $entries = @($requiredRepositories | ForEach-Object {
        [ordered]@{ path = $_; commit = [string] $Commits[$_] }
    })
    $manifest = [ordered]@{
        schemaVersion = 'deep.rc6.release-candidate-commit-matrix.v1'
        bindingModel = 'child-commits-via-containing-superproject-tree'
        repositories = $entries
    }
    if ($null -ne $Mutator) {
        & $Mutator $manifest
    }
    Write-Utf8 (Join-Path $superproject 'docs/release-candidate-commit-matrix.v1.json') (($manifest | ConvertTo-Json -Depth 5) + "`n")
}

function Assert-GateFails([scriptblock] $Action, [string] $ExpectedCode) {
    $failed = $false
    try {
        & $Action | Out-Null
    }
    catch {
        $failed = $_.Exception.Message.IndexOf($ExpectedCode, [StringComparison]::Ordinal) -ge 0
    }
    Assert-Contract $failed "negative case did not fail with $ExpectedCode"
}

try {
    New-Item -ItemType Directory -Path $superproject -Force | Out-Null
    Invoke-TestGit $superproject @('init', '--quiet')
    Invoke-TestGit $superproject @('config', 'user.name', 'RC6 Contract')
    Invoke-TestGit $superproject @('config', 'user.email', 'rc6-contract@example.invalid')
    Invoke-TestGit $superproject @('config', 'core.autocrlf', 'false')

    $commits = [ordered]@{}
    $gitModules = [Text.StringBuilder]::new()
    foreach ($path in $requiredRepositories) {
        $child = Join-Path $superproject $path
        New-Item -ItemType Directory -Path $child -Force | Out-Null
        Invoke-TestGit $child @('init', '--quiet')
        Invoke-TestGit $child @('config', 'user.name', 'RC6 Contract')
        Invoke-TestGit $child @('config', 'user.email', 'rc6-contract@example.invalid')
        Invoke-TestGit $child @('config', 'core.autocrlf', 'false')
        Write-Utf8 (Join-Path $child 'state.txt') "initial-$path`n"
        Invoke-TestGit $child @('add', 'state.txt')
        Invoke-TestGit $child @('commit', '--quiet', '-m', 'initial')
        $commit = ((& git -C $child rev-parse HEAD 2>$null) -join '').Trim()
        $commits[$path] = $commit
        [void] $gitModules.AppendLine("[submodule `"$path`"]")
        [void] $gitModules.AppendLine("`tpath = $path")
        [void] $gitModules.AppendLine("`turl = https://example.invalid/$path.git")
        Invoke-TestGit $superproject @('update-index', '--add', '--cacheinfo', '160000', $commit, $path)
    }

    Write-Utf8 (Join-Path $superproject '.gitmodules') $gitModules.ToString()
    Write-Utf8 (Join-Path $superproject 'root.txt') "root`n"
    Write-Manifest $commits $null
    Invoke-TestGit $superproject @('add', '.gitmodules', 'root.txt', 'docs/release-candidate-commit-matrix.v1.json')
    Invoke-TestGit $superproject @('commit', '--quiet', '-m', 'candidate')

    & $gate -RepositoryRoot $superproject -Mode Verify -EvidencePath $evidencePath | Out-Null
    Assert-Contract ($LASTEXITCODE -eq 0) 'clean committed matrix must pass Verify'
    Assert-Contract (Test-Path -LiteralPath $evidencePath -PathType Leaf) 'Verify must write evidence outside the superproject'

    $evidenceBytes = [IO.File]::ReadAllBytes($evidencePath)
    $evidenceText = [Text.Encoding]::UTF8.GetString($evidenceBytes)
    $evidence = $evidenceText | ConvertFrom-Json
    Assert-Contract ($evidenceBytes.Length -le 8192) 'evidence must be bounded'
    Assert-Contract ($evidence.status -eq 'passed' -and $evidence.repositoryCount -eq 7) 'evidence status/count drifted'
    Assert-Contract ($evidenceText.IndexOf($temporaryRoot, [StringComparison]::OrdinalIgnoreCase) -lt 0) 'evidence leaked an absolute path'
    foreach ($forbidden in @('stdout', 'stderr', 'hostname', 'username', 'deviceId', 'privateId')) {
        Assert-Contract ($evidenceText.IndexOf($forbidden, [StringComparison]::OrdinalIgnoreCase) -lt 0) "evidence leaked $forbidden"
    }

    $manifestPath = Join-Path $superproject 'docs/release-candidate-commit-matrix.v1.json'
    $canonicalManifest = [IO.File]::ReadAllBytes($manifestPath)
    & $generator -RepositoryRoot $superproject | Out-Null
    $regeneratedManifest = [IO.File]::ReadAllBytes($manifestPath)
    Assert-Contract ([Convert]::ToBase64String($canonicalManifest) -ceq [Convert]::ToBase64String($regeneratedManifest)) 'generator must be deterministic'
    Assert-Contract (((& git -C $superproject status --porcelain=v1 --untracked-files=all 2>$null) -join '').Length -eq 0) 'deterministic generation must preserve clean state'

    Write-Manifest $commits { param($manifest) $manifest.repositories = @($manifest.repositories | Select-Object -First 6) }
    Assert-GateFails { & $gate -RepositoryRoot $superproject -Mode Verify } 'manifest-repository-count'

    Write-Manifest $commits {
        param($manifest)
        $manifest.repositories[6].path = $manifest.repositories[0].path
        $manifest.repositories[6].commit = $manifest.repositories[0].commit
    }
    Assert-GateFails { & $gate -RepositoryRoot $superproject -Mode Verify } 'manifest-repository-duplicate'

    Write-Manifest $commits { param($manifest) $manifest.repositories += [ordered]@{ path = 'unexpected'; commit = ('a' * 40) } }
    Assert-GateFails { & $gate -RepositoryRoot $superproject -Mode Verify } 'manifest-repository-count'

    Write-Manifest $commits { param($manifest) $manifest.repositories[0].commit = 'ABCDEF' }
    Assert-GateFails { & $gate -RepositoryRoot $superproject -Mode Verify } 'manifest-commit-deep-client-maui'

    Write-Manifest $commits { param($manifest) $manifest.superprojectCommit = ('a' * 40) }
    Assert-GateFails { & $gate -RepositoryRoot $superproject -Mode Verify } 'manifest-properties'

    [IO.File]::WriteAllBytes($manifestPath, $canonicalManifest)
    Assert-GateFails { & $gate -RepositoryRoot $superproject -Mode Verify -EvidencePath (Join-Path $superproject 'evidence.json') } 'evidence-must-be-outside-superproject'

    Write-Utf8 (Join-Path $superproject 'root.txt') "dirty`n"
    Assert-GateFails { & $gate -RepositoryRoot $superproject -Mode Verify } 'root-not-clean'
    Invoke-TestGit $superproject @('checkout', '--', 'root.txt')

    Write-Utf8 (Join-Path $superproject 'untracked.txt') "untracked`n"
    Assert-GateFails { & $gate -RepositoryRoot $superproject -Mode Verify } 'root-not-clean'
    Remove-Item -LiteralPath (Join-Path $superproject 'untracked.txt')

    $dirtyChild = Join-Path $superproject $requiredRepositories[0]
    Write-Utf8 (Join-Path $dirtyChild 'state.txt') "dirty-child`n"
    Assert-GateFails { & $gate -RepositoryRoot $superproject -Mode Verify } 'child-not-clean-deep-client-maui'
    Assert-GateFails { & $generator -RepositoryRoot $superproject } 'child-not-clean-deep-client-maui'
    Invoke-TestGit $dirtyChild @('checkout', '--', 'state.txt')

    $updatedChild = Join-Path $superproject $requiredRepositories[0]
    Write-Utf8 (Join-Path $updatedChild 'state.txt') "second`n"
    Invoke-TestGit $updatedChild @('add', 'state.txt')
    Invoke-TestGit $updatedChild @('commit', '--quiet', '-m', 'second')
    $updatedCommit = ((& git -C $updatedChild rev-parse HEAD 2>$null) -join '').Trim()
    $commits[$requiredRepositories[0]] = $updatedCommit
    Write-Manifest $commits $null
    Invoke-TestGit $superproject @('update-index', '--cacheinfo', '160000', $updatedCommit, $requiredRepositories[0])
    Invoke-TestGit $superproject @('add', 'docs/release-candidate-commit-matrix.v1.json')

    & $gate -RepositoryRoot $superproject -Mode Prepare | Out-Null
    Assert-Contract ($LASTEXITCODE -eq 0) 'narrow staged release input must pass Prepare'
    Assert-GateFails { & $gate -RepositoryRoot $superproject -Mode Verify } 'root-not-clean'

    $preparedManifest = Get-Content -Raw -Encoding UTF8 $manifestPath | ConvertFrom-Json
    Assert-Contract ([string] $preparedManifest.repositories[0].commit -eq $updatedCommit) 'prepare fixture manifest commit drifted'
    $originalCommit = ((& git -C $superproject rev-parse "HEAD:$($requiredRepositories[0])" 2>$null) -join '').Trim()
    Invoke-TestGit $superproject @('update-index', '--cacheinfo', '160000', $originalCommit, $requiredRepositories[0])
    Assert-GateFails { & $gate -RepositoryRoot $superproject -Mode Prepare } 'commit-mismatch-deep-client-maui'
    Invoke-TestGit $superproject @('update-index', '--cacheinfo', '160000', $updatedCommit, $requiredRepositories[0])

    Write-Utf8 (Join-Path $superproject 'unrelated.txt') "unrelated`n"
    Invoke-TestGit $superproject @('add', 'unrelated.txt')
    Assert-GateFails { & $gate -RepositoryRoot $superproject -Mode Prepare } 'prepare-unrelated-staged-change'

    Write-Output "RC-6 commit matrix disposable contracts passed: $checks checks."
}
finally {
    $resolvedTemporaryRoot = [IO.Path]::GetFullPath($temporaryRoot)
    $requiredPrefix = $temporaryParent.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar + 'deep-rc6-matrix-contract-'
    if ($resolvedTemporaryRoot.StartsWith($requiredPrefix, [StringComparison]::OrdinalIgnoreCase) -and
        (Test-Path -LiteralPath $resolvedTemporaryRoot -PathType Container)) {
        Remove-Item -LiteralPath $resolvedTemporaryRoot -Recurse -Force
    }
}
