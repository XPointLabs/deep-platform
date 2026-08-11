[CmdletBinding()]
param(
    [switch]$ReportOnly
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$inventoryPath = Join-Path $repoRoot 'docs\survival-program\releases\v3.0.0\inventory\session-production-boundaries.v1.json'

function Fail([string]$Message) {
    throw "Deep-native inventory check failed: $Message"
}

function Invoke-GitGrep(
    [string]$RepositoryPath,
    [string]$Revision,
    [string[]]$Roots,
    [string]$Pattern
) {
    if ($Roots.Count -eq 0) { return @() }

    $output = @(& git -C $RepositoryPath grep -n -I -P $Pattern $Revision -- @Roots 2>$null)
    $exitCode = $LASTEXITCODE
    if ($exitCode -eq 1) { return @() }
    if ($exitCode -ne 0) {
        Fail "git grep failed for $RepositoryPath at $Revision (exit $exitCode)"
    }

    return $output
}

if (-not (Test-Path -LiteralPath $inventoryPath -PathType Leaf)) {
    Fail "inventory is missing: $inventoryPath"
}

$inventory = Get-Content -LiteralPath $inventoryPath -Raw -Encoding UTF8 | ConvertFrom-Json
if ($inventory.schemaVersion -ne '1.0.0') { Fail 'unexpected schemaVersion' }
if ($inventory.inventoryId -ne 'DNP1-INV-session-production-boundaries') { Fail 'unexpected inventoryId' }
if ($inventory.decision -ne 'DR-0003') { Fail 'inventory must be governed by DR-0003' }

$allowedClassifications = @('retain', 'remove', 'redesign', 'reference-only')
if ((@($inventory.classifications) -join '|') -ne ($allowedClassifications -join '|')) {
    Fail 'classification vocabulary or order changed'
}

$markers = @($inventory.markers)
if ($markers.Count -eq 0) { Fail 'no curated markers are configured' }
$markerNames = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
foreach ($marker in $markers) {
    if ([string]::IsNullOrWhiteSpace($marker.name) -or [string]::IsNullOrWhiteSpace($marker.regex)) {
        Fail 'every marker requires name and regex'
    }
    if (-not $markerNames.Add([string]$marker.name)) { Fail "duplicate marker: $($marker.name)" }
    if ([string]$marker.regex -match '^\\?b?session\\?b?$') {
        Fail "generic session marker is forbidden because it matches ASP.NET, OS and application sessions: $($marker.name)"
    }
    try { [void][regex]::new([string]$marker.regex, [System.Text.RegularExpressions.RegexOptions]::CultureInvariant) }
    catch { Fail "invalid marker regex $($marker.name): $($_.Exception.Message)" }
}

$rules = @($inventory.rules)
$ruleIds = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
foreach ($rule in $rules) {
    foreach ($field in @('id', 'repository', 'pathRegex', 'classification', 'currentConsumers', 'prerequisite', 'impact', 'evidenceToPort', 'owner')) {
        if ([string]::IsNullOrWhiteSpace([string]$rule.$field)) { Fail "rule is missing $field" }
    }
    if (-not $ruleIds.Add([string]$rule.id)) { Fail "duplicate rule id: $($rule.id)" }
    if ($allowedClassifications -notcontains [string]$rule.classification) {
        Fail "rule $($rule.id) has unknown classification $($rule.classification)"
    }
    try { [void][regex]::new([string]$rule.pathRegex, [System.Text.RegularExpressions.RegexOptions]::CultureInvariant) }
    catch { Fail "invalid path regex in $($rule.id): $($_.Exception.Message)" }
}

$combinedPattern = '(' + (($markers | ForEach-Object { [string]$_.regex }) -join ')|(') + ')'
$hits = New-Object System.Collections.Generic.List[object]
$evidenceCounts = [ordered]@{}
$repositoryNames = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
$repositoryPaths = @{}
$repositoryRevisions = @{}

foreach ($repository in @($inventory.repositories)) {
    foreach ($field in @('name', 'path', 'expectedHead')) {
        if ([string]::IsNullOrWhiteSpace([string]$repository.$field)) { Fail "repository is missing $field" }
    }
    if (-not $repositoryNames.Add([string]$repository.name)) { Fail "duplicate repository: $($repository.name)" }

    $repositoryPath = Join-Path $repoRoot ([string]$repository.path)
    if (-not (Test-Path -LiteralPath $repositoryPath -PathType Container)) {
        Fail "repository directory is missing: $repositoryPath"
    }

    $actualHead = (& git -C $repositoryPath rev-parse HEAD).Trim()
    if ($LASTEXITCODE -ne 0) { Fail "cannot read HEAD for $($repository.name)" }
    if ($actualHead -ne [string]$repository.expectedHead) {
        Fail "HEAD drift for $($repository.name): expected $($repository.expectedHead), actual $actualHead"
    }
    $repositoryPaths[[string]$repository.name] = $repositoryPath
    $repositoryRevisions[[string]$repository.name] = $actualHead

    $productionRoots = @($repository.productionRoots | ForEach-Object { ([string]$_).Replace('\\', '/') })
    foreach ($root in $productionRoots) {
        & git -C $repositoryPath cat-file -e "$actualHead`:$root" 2>$null
        $existsAtHead = $LASTEXITCODE -eq 0
        if (-not $existsAtHead) { Fail "production root $root is absent at $($repository.name)@$actualHead" }
    }

    $lines = @(Invoke-GitGrep $repositoryPath $actualHead $productionRoots $combinedPattern)
    foreach ($line in $lines) {
        $parsed = [regex]::Match([string]$line, '^(?:[0-9a-f]{40}:)?(?<path>.+?):(?<line>[0-9]+):(?<text>.*)$')
        if (-not $parsed.Success) { Fail "cannot parse git grep output for $($repository.name): $line" }

        $relativePath = $parsed.Groups['path'].Value.Replace('\\', '/')
        $lineNumber = [int]$parsed.Groups['line'].Value
        $text = $parsed.Groups['text'].Value

        foreach ($marker in $markers) {
            $match = [regex]::Match($text, [string]$marker.regex, [System.Text.RegularExpressions.RegexOptions]::CultureInvariant)
            if (-not $match.Success) { continue }

            $matchingRules = @($rules | Where-Object {
                $_.repository -eq $repository.name -and
                [regex]::IsMatch($relativePath, [string]$_.pathRegex, [System.Text.RegularExpressions.RegexOptions]::CultureInvariant)
            })
            if ($matchingRules.Count -eq 0) {
                Fail "unclassified production hit: $($repository.name):$relativePath`:$lineNumber [$($marker.name)]"
            }
            if ($matchingRules.Count -gt 1) {
                Fail "multiply classified production hit: $($repository.name):$relativePath`:$lineNumber [$($marker.name)] -> $($matchingRules.id -join ', ')"
            }

            $rule = $matchingRules[0]
            $hits.Add([pscustomobject]@{
                repository = [string]$repository.name
                revision = $actualHead
                path = $relativePath
                line = $lineNumber
                marker = [string]$marker.name
                symbol = $match.Value
                classification = [string]$rule.classification
                rule = [string]$rule.id
                owner = [string]$rule.owner
            })
        }
    }

    $evidenceRoots = @($repository.evidenceRoots | ForEach-Object { ([string]$_).Replace('\\', '/') })
    $existingEvidenceRoots = @()
    foreach ($root in $evidenceRoots) {
        & git -C $repositoryPath cat-file -e "$actualHead`:$root" 2>$null
        if ($LASTEXITCODE -eq 0) { $existingEvidenceRoots += $root }
    }
    $evidenceLines = @(Invoke-GitGrep $repositoryPath $actualHead $existingEvidenceRoots $combinedPattern)
    $evidenceCounts[[string]$repository.name] = $evidenceLines.Count
}

foreach ($rule in $rules) {
    if (-not $repositoryNames.Contains([string]$rule.repository)) {
        Fail "rule $($rule.id) references unknown repository $($rule.repository)"
    }
}

$retainedBoundaries = @($inventory.retainedBoundaries)
foreach ($boundary in $retainedBoundaries) {
    foreach ($field in @('repository', 'pathPrefix', 'classification', 'invariant', 'owner')) {
        if ([string]::IsNullOrWhiteSpace([string]$boundary.$field)) { Fail "retained boundary is missing $field" }
    }
    if ($boundary.classification -ne 'retain') { Fail "retained boundary $($boundary.pathPrefix) must use retain" }
    if (-not $repositoryNames.Contains([string]$boundary.repository)) {
        Fail "retained boundary references unknown repository $($boundary.repository)"
    }
    $boundaryFiles = @(& git -C $repositoryPaths[[string]$boundary.repository] ls-tree -r --name-only $repositoryRevisions[[string]$boundary.repository] -- ([string]$boundary.pathPrefix) 2>$null)
    if ($LASTEXITCODE -ne 0 -or $boundaryFiles.Count -eq 0) {
        Fail "retained boundary path is absent: $($boundary.repository):$($boundary.pathPrefix)"
    }
}

$orderedHits = @($hits | Sort-Object repository, path, line, marker, symbol)
$identityLines = @($orderedHits | ForEach-Object {
    "$($_.repository)|$($_.revision)|$($_.path)|$($_.line)|$($_.marker)|$($_.symbol)|$($_.classification)|$($_.rule)|$($_.owner)"
})
$digestInput = if ($identityLines.Count -eq 0) { '' } else { ($identityLines -join "`n") + "`n" }
$sha = [System.Security.Cryptography.SHA256]::Create()
try {
    $digestBytes = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($digestInput))
    $actualDigest = ([System.BitConverter]::ToString($digestBytes)).Replace('-', '').ToLowerInvariant()
}
finally {
    $sha.Dispose()
}

$classificationCounts = [ordered]@{}
foreach ($classification in $allowedClassifications) {
    $classificationCounts[$classification] = @($orderedHits | Where-Object classification -eq $classification).Count
}

if (-not $ReportOnly) {
    if ([int]$inventory.expectedProductionHits.count -ne $orderedHits.Count) {
        Fail "production hit count drift: expected $($inventory.expectedProductionHits.count), actual $($orderedHits.Count)"
    }
    if ([string]$inventory.expectedProductionHits.sha256 -ne $actualDigest) {
        Fail "production hit digest drift: expected $($inventory.expectedProductionHits.sha256), actual $actualDigest"
    }
    foreach ($classification in $allowedClassifications) {
        $expected = [int]$inventory.expectedProductionHits.classificationCounts.$classification
        if ($expected -ne $classificationCounts[$classification]) {
            Fail "$classification count drift: expected $expected, actual $($classificationCounts[$classification])"
        }
    }
}

Write-Host 'Deep-native Session inventory check passed.'
Write-Host "Repositories: $(@($inventory.repositories).Count)"
Write-Host "Explicit retained boundaries: $($retainedBoundaries.Count)"
Write-Host "Production hits: $($orderedHits.Count)"
Write-Host "Production digest: sha256:$actualDigest"
Write-Host ("Classifications: " + (($allowedClassifications | ForEach-Object { "$_=$($classificationCounts[$_])" }) -join ', '))
Write-Host ("Evidence-only marker lines: " + (($evidenceCounts.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ', '))

if ($ReportOnly) {
    Write-Host 'Report-only mode: copy the count, digest and classification counts into expectedProductionHits.'
}
