[CmdletBinding()]
param(
    [string] $RepositoryRoot = (Join-Path $PSScriptRoot '..')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$requiredRepositories = @(
    'deep-client-maui',
    'deep-client-shared',
    'deep-devops',
    'deep-protocol',
    'deep-registry-api',
    'deep-tests-e2e',
    'xnode'
)
$root = [IO.Path]::GetFullPath($RepositoryRoot)
$topLevel = @(& git -C $root rev-parse --show-toplevel 2>$null)
if ($LASTEXITCODE -ne 0 -or -not [StringComparer]::OrdinalIgnoreCase.Equals([IO.Path]::GetFullPath(($topLevel -join '').Trim()), $root)) {
    throw 'RC-6 matrix generation failed: superproject-root'
}

$entries = @()
foreach ($path in $requiredRepositories) {
    $childRoot = Join-Path $root $path
    $status = @(& git -C $childRoot status --porcelain=v1 --untracked-files=all 2>$null)
    if ($LASTEXITCODE -ne 0) {
        throw "RC-6 matrix generation failed: child-not-git-$path"
    }
    if ($status.Count -ne 0) {
        throw "RC-6 matrix generation failed: child-not-clean-$path"
    }

    $commit = ((@(& git -C $childRoot rev-parse --verify 'HEAD^{commit}' 2>$null) -join '').Trim())
    if ($LASTEXITCODE -ne 0 -or $commit -notmatch '^[0-9a-f]{40}$') {
        throw "RC-6 matrix generation failed: child-head-$path"
    }
    $entries += [ordered]@{ path = $path; commit = $commit }
}

$manifest = [ordered]@{
    schemaVersion = 'deep.rc6.release-candidate-commit-matrix.v1'
    bindingModel = 'child-commits-via-containing-superproject-tree'
    repositories = $entries
}
$manifestPath = Join-Path $root 'docs/release-candidate-commit-matrix.v1.json'
$json = ($manifest | ConvertTo-Json -Depth 4) + "`n"
[IO.File]::WriteAllText($manifestPath, $json, [Text.UTF8Encoding]::new($false))

Write-Output 'RC-6 commit matrix generated from seven clean child HEADs. Stage the gitlinks and manifest, then run the Prepare gate.'
