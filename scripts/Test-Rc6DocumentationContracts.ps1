[CmdletBinding()]
param(
    [switch] $RenderedOutput
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$publishedRoot = Join-Path $repositoryRoot 'xpoint-docs'
$runbookPath = Join-Path $repositoryRoot 'docs/RC6-RECOVERY-ROLLBACK-DRILL.md'
$drillScriptPath = Join-Path $repositoryRoot 'scripts/Invoke-Rc6VolumeRecoveryDrill.ps1'
$drillSelfTestPath = Join-Path $repositoryRoot 'scripts/Test-Rc6VolumeRecoveryDrill.ps1'
$utf8 = [Text.UTF8Encoding]::new($false, $true)
$checks = 0

function Assert-Contract([bool] $Condition, [string] $Message) {
    if (-not $Condition) {
        throw "RC-6 documentation contract failed: $Message"
    }

    $script:checks++
}

function Read-StrictUtf8([string] $Path) {
    return $utf8.GetString([IO.File]::ReadAllBytes($Path))
}

function Assert-Matches([string] $Value, [string] $Pattern, [string] $Message) {
    Assert-Contract ([regex]::IsMatch($Value, $Pattern, [Text.RegularExpressions.RegexOptions]::CultureInvariant)) $Message
}

Assert-Contract (Test-Path -LiteralPath $runbookPath -PathType Leaf) 'recovery runbook is missing'
Assert-Contract (Test-Path -LiteralPath $drillScriptPath -PathType Leaf) 'volume recovery drill is missing'
Assert-Contract (Test-Path -LiteralPath $drillSelfTestPath -PathType Leaf) 'volume recovery self-test is missing'

$markdownFiles = @(Get-ChildItem -LiteralPath $publishedRoot -Recurse -File -Filter '*.md' |
    Where-Object { $_.FullName -notmatch '[\\/](node_modules|_book)[\\/]' })
$markdownFiles += Get-Item -LiteralPath $runbookPath

foreach ($file in $markdownFiles) {
    $text = Read-StrictUtf8 $file.FullName
    Assert-Contract (-not $text.Contains([char] 0xfffd)) "invalid UTF-8 replacement character in $($file.Name)"
    Assert-Contract (-not $text.Contains([char] 0x0000)) "NUL character in $($file.Name)"
}

$summaryPath = Join-Path $publishedRoot 'SUMMARY.md'
$summary = Read-StrictUtf8 $summaryPath
$publishedPages = @(Get-ChildItem -LiteralPath $publishedRoot -Recurse -File -Filter '*.md' |
    Where-Object {
        $_.Name -notin @('AGENTS.md', 'SUMMARY.md') -and
        $_.FullName -notmatch '[\\/](node_modules|_book)[\\/]'
    })
foreach ($page in $publishedPages) {
    $relative = $page.FullName.Substring($publishedRoot.Length).TrimStart('\', '/').Replace('\', '/')
    Assert-Contract ($summary.Contains("($relative)")) "SUMMARY.md does not reach $relative"
}

$linkPattern = [regex] '\[[^\]]*\]\((?<target>[^)]+)\)'
foreach ($file in $publishedPages + @(Get-Item -LiteralPath $summaryPath)) {
    $text = Read-StrictUtf8 $file.FullName
    foreach ($match in $linkPattern.Matches($text)) {
        $target = $match.Groups['target'].Value.Trim().Trim('<', '>')
        if ($target.Length -eq 0 -or $target.StartsWith('#') -or $target -match '^[A-Za-z][A-Za-z0-9+.-]*:') {
            continue
        }

        $relativeTarget = ($target -split '#', 2)[0]
        if ($relativeTarget.Length -eq 0) {
            continue
        }

        $resolved = [IO.Path]::GetFullPath((Join-Path $file.DirectoryName $relativeTarget))
        Assert-Contract (Test-Path -LiteralPath $resolved) "broken relative link in $($file.Name)"
    }
}

$operations = Read-StrictUtf8 (Join-Path $publishedRoot 'administrators/operations.md')
foreach ($term in @('X25519', 'Ed25519', 'BLS', 'calls-v2', 'snapshot', 'restore', 'signed nonce')) {
    Assert-Contract ($operations.Contains($term)) "operations inventory is missing $term"
}

$tls = Read-StrictUtf8 (Join-Path $publishedRoot 'administrators/tls-services.md')
foreach ($term in @(
    'Calls__Required=true', 'Calls__Enabled=true', 'Calls__StatePath',
    'Calls__TurnSharedSecretFile', 'Calls__CredentialLifetimeSeconds', 'Calls__IceUrls',
    'Calls__PushNotifyUrl', 'Calls__PushNotifyBearerTokenFile',
    'POST /api/calls/signal', 'GET /api/calls/inbox/{recipient}',
    'GET /api/calls/ice-servers/{recipient}', '3478/udp', '3478/tcp',
    '5349/tcp', '5349/udp'
)) {
    Assert-Contract ($tls.Contains($term)) "call/TURN contract is missing $term"
}
Assert-Matches $tls '49160.49200/udp' 'TURN UDP relay range is missing'
Assert-Matches $tls '49160.49200/tcp' 'TURN TCP relay range is missing'

$runbook = Read-StrictUtf8 $runbookPath
foreach ($term in @(
    'real, volume-backed snapshot', 'independent X25519', 'calls-v2',
    'source-volume-has-running-writers', 'isolated Compose project',
    'replaying the same signed nonce is rejected', 'explicitly', 'non-blocking',
    'rc6-application-recovery-verifier.mjs',
    'partialApplicationServicesValidated=true', 'applicationContourValidated=false',
    'scope=isolated-restored-application-services-partial',
    'XNode identity', 'privacy routing', 'TURN'
)) {
    Assert-Contract ($runbook.Contains($term)) "recovery runbook is missing $term"
}
Assert-Matches $runbook '(?s)node ./deep-devops/scripts/rc6-application-recovery-verifier\.mjs.*--compose-file ./deep-devops/docker-compose\.rc6-application-recovery\.yml.*--project-name rc6-recovery-drill.*--expectations.*--evidence' 'application recovery verifier command is incomplete'

$readme = Read-StrictUtf8 (Join-Path $publishedRoot 'README.md')
$gettingStarted = Read-StrictUtf8 (Join-Path $publishedRoot 'users/getting-started.md')
$releaseReadiness = Read-StrictUtf8 (Join-Path $publishedRoot 'release-readiness.md')
foreach ($text in @($readme, $gettingStarted, $releaseReadiness)) {
    Assert-Matches $text '(?s)(iOS|Apple).*unverified.*non-blocking' 'Apple lane must be unverified and non-blocking'
}
Assert-Contract ($releaseReadiness.Contains('release-supported')) 'Apple support claim boundary is missing'

$package = Get-Content -Raw -Encoding UTF8 (Join-Path $publishedRoot 'package.json') | ConvertFrom-Json
Assert-Contract ($package.devDependencies.marked -eq '18.0.11') 'marked must be pinned exactly'
Assert-Contract (-not ($package.devDependencies.PSObject.Properties.Name -contains 'honkit')) 'HonKit must be absent'
Assert-Contract ($package.packageManager -eq 'npm@11.8.0') 'npm must be pinned exactly'
Assert-Contract ($package.engines.node -eq '24.13.0') 'Node.js must be pinned exactly'
Assert-Contract ((Read-StrictUtf8 (Join-Path $publishedRoot '.nvmrc')).Trim() -eq '24.13.0') '.nvmrc must match package engines'

$lockPath = Join-Path $publishedRoot 'package-lock.json'
Assert-Contract (Test-Path -LiteralPath $lockPath -PathType Leaf) 'package-lock.json is missing'
$lockCheck = @(& node -e "const fs=require('node:fs');const p=JSON.parse(fs.readFileSync(process.argv[1],'utf8'));const names=Object.keys(p.packages||{});process.exit(p.lockfileVersion===3&&p.packages?.['']?.devDependencies?.marked==='18.0.11'&&!names.includes('node_modules/honkit')&&!names.includes('node_modules/immutable')?0:1)" $lockPath 2>$null)
Assert-Contract ($LASTEXITCODE -eq 0) 'npm lockfile pins drifted'

$tokens = $null
$parseErrors = $null
[Management.Automation.Language.Parser]::ParseFile($drillScriptPath, [ref] $tokens, [ref] $parseErrors) | Out-Null
Assert-Contract ($parseErrors.Count -eq 0) 'volume recovery drill has PowerShell parse errors'
$selfTestTokens = $null
$selfTestParseErrors = $null
[Management.Automation.Language.Parser]::ParseFile($drillSelfTestPath, [ref] $selfTestTokens, [ref] $selfTestParseErrors) | Out-Null
Assert-Contract ($selfTestParseErrors.Count -eq 0) 'volume recovery self-test has PowerShell parse errors'
$drillScript = Read-StrictUtf8 $drillScriptPath
Assert-Matches $drillScript "ValidatePattern\('\^\[\^\\s@\]\+@sha256:" 'tool image must require an immutable digest'
Assert-Matches $drillScript '''ps'', ''--quiet'', ''--filter''.*volume=\$SourceVolume' 'drill must reject running writers'
Assert-Contract ($drillScript.Contains('restored-state-mismatch')) 'drill must compare restored state'

$evidenceStart = $drillScript.IndexOf('$evidence = [ordered]@{', [StringComparison]::Ordinal)
$evidenceEnd = $drillScript.IndexOf('[IO.File]::WriteAllText(', $evidenceStart, [StringComparison]::Ordinal)
Assert-Contract ($evidenceStart -ge 0 -and $evidenceEnd -gt $evidenceStart) 'sanitized evidence block is missing'
$evidenceBlock = $drillScript.Substring($evidenceStart, $evidenceEnd - $evidenceStart)
foreach ($forbidden in @('SourceVolume', 'BackupDirectory', 'archivePath', 'restoreVolume =', 'stdout', 'stderr', 'container', 'hostname', 'identifier')) {
    Assert-Contract ($evidenceBlock.IndexOf($forbidden, [StringComparison]::OrdinalIgnoreCase) -lt 0) "evidence block contains forbidden field $forbidden"
}

if ($RenderedOutput) {
    $bookRoot = Join-Path $publishedRoot '_book'
    Assert-Contract (Test-Path -LiteralPath $bookRoot -PathType Container) 'rendered _book is missing'
    $renderedPages = @(Get-ChildItem -LiteralPath $bookRoot -Recurse -File -Filter '*.html')
    Assert-Contract ($renderedPages.Count -eq $publishedPages.Count) 'rendered page count does not match SUMMARY coverage'
    foreach ($page in $renderedPages) {
        $renderedText = Read-StrictUtf8 $page.FullName
        Assert-Contract (-not $renderedText.Contains([char] 0xfffd)) "rendered UTF-8 is invalid in $($page.Name)"
    }

    $renderedOperations = Read-StrictUtf8 (Join-Path $bookRoot 'administrators/operations.html')
    $renderedTls = Read-StrictUtf8 (Join-Path $bookRoot 'administrators/tls-services.html')
    foreach ($term in @('X25519', 'calls-v2', 'snapshot', 'signed nonce')) {
        Assert-Contract ($renderedOperations.Contains($term)) "rendered operations page is missing $term"
    }
    foreach ($term in @('Calls__StatePath', '3478/udp', '5349/tcp')) {
        Assert-Contract ($renderedTls.Contains($term)) "rendered TLS page is missing $term"
    }
    Assert-Matches $renderedTls '49160.49200/udp' 'rendered TURN relay range is missing'

    foreach ($privateAsset in @('AGENTS.md', 'package.json', 'package-lock.json', '.nvmrc', '.bookignore')) {
        Assert-Contract (-not (Test-Path -LiteralPath (Join-Path $bookRoot $privateAsset))) "private tool file was published: $privateAsset"
    }
}

Write-Output "RC-6 documentation contracts passed: $checks checks."
